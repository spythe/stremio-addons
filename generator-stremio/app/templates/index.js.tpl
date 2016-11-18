var Stremio = require("stremio-addons");

// Enable server logging for development purposes
process.env.STREMIO_LOGGING = true; 

// Define manifest object
var manifest = { 
    // See https://github.com/Stremio/stremio-addons/blob/master/docs/api/manifest.md for full explanation
    "id": "org.stremio.<%= id %>",
    "version": "1.0.0",

    "name": "<%= name %>",
    "description": "<%= description %>",
    "icon": "<%= icon %>", 
    "background": "<%= background %>",

    // Properties that determine when Stremio picks this add-on
    "types": <%- types %>, // your add-on will be preferred for those content types
    "idProperty": <%- idProperty %>, // the property to use as an ID for your add-on; your add-on will be preferred for items with that property; can be an array
    // We need this for pre-4.0 Stremio, it's the obsolete equivalent of types/idProperty
    "filter": { "query.imdb_id": { "$exists": true }, "query.type": { "$in":["series","movie"] } }
};

var dataset = {};

var methods = { };

var addon = new Stremio.Server({
    "stream.find": function(args, callback, user) {
        // callback expects array of stream objects
    },
    "meta.find": function(args, callback, user) {
        // callback expects array of meta object (primary meta feed)
        // it passes "limit" and "skip" for pagination
    },
    "meta.get": function(args, callback, user) {
        // callback expects one meta element
    },
    "meta.search": function(args, callback, user) {
        // callback expects array of search results with meta objects
        // does not support pagination
    },
}, manifest);

var server = require("http").createServer(function (req, res) {
    addon.middleware(req, res, function() { res.end() }); // wire the middleware - also compatible with connect / express
}).on("listening", function()
{
    console.log("Sample Stremio Addon listening on "+server.address().port);
}).listen(process.env.PORT || 7000);
