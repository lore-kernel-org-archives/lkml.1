Return-Path: <linux-kernel-owner+w=401wt.eu-S932394AbXKOGcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932394AbXKOGcp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:32:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764577AbXKOGWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:22:43 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:46093 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764296AbXKOGWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:22:41 -0500
Date: Wed, 14 Nov 2007 22:21:10 -0800
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
       Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
       linux-wireless@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>,
       Bill Moss <bmoss@clemson.edu>
Subject: [patch 21/23] mac80211: honor IW_SCAN_THIS_ESSID in siwscan ioctl
Message-ID: <20071115062110.GV8282@kroah.com>
References: <20071115055238.692814352@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="mac80211-honor-iw_scan_this_essid-in-siwscan-ioctl.patch"
In-Reply-To: <20071115061806.GA8282@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Bill Moss <bmoss@clemson.edu>

patch 107acb23ba763197d390ae9ffd347f3e2a524d39 in mainline.

This patch fixes the problem of associating with wpa_secured hidden
AP.  Please try out.

The original author of this patch is Bill Moss <bmoss@clemson.edu>

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/ieee80211_ioctl.c |   40 ++++++++++++++++++++++++----------------
 1 file changed, 24 insertions(+), 16 deletions(-)

--- a/net/mac80211/ieee80211_ioctl.c
+++ b/net/mac80211/ieee80211_ioctl.c
@@ -687,32 +687,40 @@ static int ieee80211_ioctl_giwap(struct 
 
 static int ieee80211_ioctl_siwscan(struct net_device *dev,
 				   struct iw_request_info *info,
-				   struct iw_point *data, char *extra)
+				   union iwreq_data *wrqu, char *extra)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct iw_scan_req *req = NULL;
 	u8 *ssid = NULL;
 	size_t ssid_len = 0;
 
 	if (!netif_running(dev))
 		return -ENETDOWN;
 
-	switch (sdata->type) {
-	case IEEE80211_IF_TYPE_STA:
-	case IEEE80211_IF_TYPE_IBSS:
-		if (local->scan_flags & IEEE80211_SCAN_MATCH_SSID) {
-			ssid = sdata->u.sta.ssid;
-			ssid_len = sdata->u.sta.ssid_len;
-		}
-		break;
-	case IEEE80211_IF_TYPE_AP:
-		if (local->scan_flags & IEEE80211_SCAN_MATCH_SSID) {
-			ssid = sdata->u.ap.ssid;
-			ssid_len = sdata->u.ap.ssid_len;
+	if (wrqu->data.length == sizeof(struct iw_scan_req) &&
+	    wrqu->data.flags & IW_SCAN_THIS_ESSID) {
+		req = (struct iw_scan_req *)extra;
+		ssid = req->essid;
+		ssid_len = req->essid_len;
+	} else {
+		switch (sdata->type) {
+		case IEEE80211_IF_TYPE_STA:
+		case IEEE80211_IF_TYPE_IBSS:
+			if (local->scan_flags & IEEE80211_SCAN_MATCH_SSID) {
+				ssid = sdata->u.sta.ssid;
+				ssid_len = sdata->u.sta.ssid_len;
+			}
+			break;
+		case IEEE80211_IF_TYPE_AP:
+			if (local->scan_flags & IEEE80211_SCAN_MATCH_SSID) {
+				ssid = sdata->u.ap.ssid;
+				ssid_len = sdata->u.ap.ssid_len;
+			}
+			break;
+		default:
+			return -EOPNOTSUPP;
 		}
-		break;
-	default:
-		return -EOPNOTSUPP;
 	}
 
 	return ieee80211_sta_req_scan(dev, ssid, ssid_len);

-- 
