class API {
  String key;
  int maxResults;
  String order;
  String safeSearch;
  String type;
  String videoDuration;
  String nextPageToken;
  String prevPageToken;
  String query;
  String channelId;
  String playListId;
  Object options;
  String regionCode;
  static String baseURL = 'www.googleapis.com';

  API({this.key, this.type, this.maxResults, this.query});

  Uri trendingUri({String regionCode}) {
    this.regionCode = regionCode;
    var options = getTrendingOption(this.regionCode);
    Uri url = new Uri.https(baseURL, "youtube/v3/videos", options);
    return url;
  }

  Uri searchUri(query, {String type}) {
    this.query = query;
    this.type = type ?? this.type;
    this.channelId = null;
    var options = getOption();
    Uri url = new Uri.https(baseURL, "youtube/v3/search", options);
    return url;
  }

  Uri channelUri(String channelId, String order,{String query}) {
    this.order = order ?? 'date';
    this.query = query ?? '';
    this.channelId = channelId;
    var options = getChannelOption(channelId, this.order,query: query);
    Uri url = new Uri.https(baseURL, "youtube/v3/search", options);
    return url;
  }

  Uri channelPlaylistUri(String channelId, String order) {
    this.order = order ?? 'date';
    this.channelId = channelId;
    var options = getChannelOption(channelId, this.order);
    Uri url = new Uri.https(baseURL, "youtube/v3/search", options);
    return url;
  }

  Uri listUri(String listId, String order) {
    this.order = order ?? 'date';
    this.playListId = listId;
    var options = getlistOption(listId, this.order);
    Uri url = new Uri.https(baseURL, "youtube/v3/playlistItems", options);
    return url;
  }

  Uri videoUri(List<String> videoId) {
    int length = videoId.length;
    String videoIds = videoId.join(',');
    var options = getVideoOption(videoIds, length);
    Uri url = new Uri.https(baseURL, "youtube/v3/videos", options);
    return url;
  }

//  For Getting Getting Next Page
  Uri nextPageUri(bool getTrending , String nextPage) {
    Uri url;
    if (getTrending) {
      var options = this.getTrendingPageOption("pageToken", nextPage);
      url = new Uri.https(baseURL, "youtube/v3/videos", options);
    } else {
      print(nextPage);
      var options = this.channelId == null
          ? getOptions("pageToken", nextPage)
          : getChannelPageOption(channelId, "pageToken", nextPage);
      url = new Uri.https(baseURL, "youtube/v3/search", options);
    }
    return url;
  }

//  For Getting Getting Previous Page
  Uri prevPageUri(bool getTrending) {
    Uri url;
    if (getTrending) {
      var options = this.getTrendingPageOption("pageToken", prevPageToken);
      url = new Uri.https(baseURL, "youtube/v3/videos", options);
    } else {
      var options = this.channelId == null
          ? getOptions("pageToken", prevPageToken)
          : getChannelPageOption(channelId, "pageToken", prevPageToken);
      url = new Uri.https(baseURL, "youtube/v3/search", options);
    }
    return url;
  }

  Object getTrendingOption(String regionCode) {
    this.regionCode = regionCode;
    Object options = {
      "part": "snippet",
      "chart": "mostPopular",
      "maxResults": "${this.maxResults}",
      "regionCode": "${this.regionCode}",
      "key": "${this.key}",
    };
    return options;
  }

  Object getTrendingPageOption(String key, String value) {
    Object options = {
      key: value,
      "part": "snippet",
      "chart": "mostPopular",
      "maxResults": "${this.maxResults}",
      "regionCode": "${this.regionCode}",
      "key": "${this.key}",
    };
    return options;
  }

  Object getOptions(String key, String value) {
    Object options = {
      key: value,
      "q": "${this.query}",
      "part": "snippet",
      "maxResults": "${this.maxResults}",
      "key": "${this.key}",
      "type": "${this.type}"
    };
    return options;
  }

  Object getOption() {
    Object options = {
      "q": "${this.query}",
      "part": "snippet",
      "maxResults": "${this.maxResults}",
      "key": "${this.key}",
      "type": "${this.type}"
    };
    return options;
  }

  Object getChannelOption(String channelId, String order,{String query}) {
    Object options = {
      "q": "${this.query}",
      'channelId': channelId,
      "part": "snippet",
      'order': this.order,
      "maxResults": "${this.maxResults}",
      "key": "${this.key}",
    };
    return options;
  }

  Object getlistOption(String listId, String order) {
    Object options = {
      'playlistId': listId,
      "part": "snippet",
      'order': this.order,
      "maxResults": "${this.maxResults}",
      "key": "${this.key}",
    };
    return options;
  }

  Object getChannelPageOption(String channelId, String key, String value) {
    Object options = {
      key: value,
      'q': "${this.query}",
      'channelId': channelId,
      "part": "snippet",
      'order': this.order,
      "maxResults": "${this.maxResults}",
      "key": "${this.key}",
    };
    return options;
  }

  Object getVideoOption(String videoIds, int length) {
    Object options = {
      "part": "contentDetails",
      "id": videoIds,
      "maxResults": "$length",
      "key": "${this.key}",
    };
    return options;
  }

  void setNextPageToken(String token) => this.nextPageToken = token;
  void setPrevPageToken(String token) => this.nextPageToken = token;
}
