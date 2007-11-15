Return-Path: <linux-kernel-owner+w=401wt.eu-S932380AbXKOGdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932380AbXKOGdS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:33:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764000AbXKOGWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:22:45 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:46097 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764944AbXKOGWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:22:42 -0500
Date: Wed, 14 Nov 2007 22:21:13 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       linux-wireless@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 22/23] mac80211: only honor IW_SCAN_THIS_ESSID in STA,
	IBSS, and AP modes
Message-ID: <20071115062113.GW8282@kroah.com>
References: <20071115055238.692814352@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="mac80211-only-honor-iw_scan_this_essid-in-sta-ibss-and-ap-modes.patch"
In-Reply-To: <20071115061806.GA8282@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------


From: John W. Linville <linville@tuxdriver.com>

patch d114f399b4da6fa7f9da3bbf1fb841370c11e788 in mainline.

The previous IW_SCAN_THIS_ESSID patch left a hole allowing scan
requests on interfaces in inappropriate modes.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/ieee80211_ioctl.c |   37 +++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 18 deletions(-)

--- a/net/mac80211/ieee80211_ioctl.c
+++ b/net/mac80211/ieee80211_ioctl.c
@@ -698,29 +698,30 @@ static int ieee80211_ioctl_siwscan(struc
 	if (!netif_running(dev))
 		return -ENETDOWN;
 
+	switch (sdata->type) {
+	case IEEE80211_IF_TYPE_STA:
+	case IEEE80211_IF_TYPE_IBSS:
+		if (local->scan_flags & IEEE80211_SCAN_MATCH_SSID) {
+			ssid = sdata->u.sta.ssid;
+			ssid_len = sdata->u.sta.ssid_len;
+		}
+		break;
+	case IEEE80211_IF_TYPE_AP:
+		if (local->scan_flags & IEEE80211_SCAN_MATCH_SSID) {
+			ssid = sdata->u.ap.ssid;
+			ssid_len = sdata->u.ap.ssid_len;
+		}
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	/* if SSID was specified explicitly then use that */
 	if (wrqu->data.length == sizeof(struct iw_scan_req) &&
 	    wrqu->data.flags & IW_SCAN_THIS_ESSID) {
 		req = (struct iw_scan_req *)extra;
 		ssid = req->essid;
 		ssid_len = req->essid_len;
-	} else {
-		switch (sdata->type) {
-		case IEEE80211_IF_TYPE_STA:
-		case IEEE80211_IF_TYPE_IBSS:
-			if (local->scan_flags & IEEE80211_SCAN_MATCH_SSID) {
-				ssid = sdata->u.sta.ssid;
-				ssid_len = sdata->u.sta.ssid_len;
-			}
-			break;
-		case IEEE80211_IF_TYPE_AP:
-			if (local->scan_flags & IEEE80211_SCAN_MATCH_SSID) {
-				ssid = sdata->u.ap.ssid;
-				ssid_len = sdata->u.ap.ssid_len;
-			}
-			break;
-		default:
-			return -EOPNOTSUPP;
-		}
 	}
 
 	return ieee80211_sta_req_scan(dev, ssid, ssid_len);

-- 
