Return-Path: <linux-kernel-owner+w=401wt.eu-S932368AbXKOGdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932368AbXKOGdu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:33:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764957AbXKOGWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:22:48 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:46111 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763641AbXKOGWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:22:46 -0500
Date: Wed, 14 Nov 2007 22:21:17 -0800
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
       Michael Wu <flamingice@sourmilk.net>
Subject: [patch 23/23] mac80211: make ieee802_11_parse_elems return void
Message-ID: <20071115062117.GX8282@kroah.com>
References: <20071115055238.692814352@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="mac80211-make-ieee802_11_parse_elems-return-void.patch"
In-Reply-To: <20071115061806.GA8282@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------


From: John W. Linville <linville@tuxdriver.com>

patch 67a4cce4a89718d252b61aaf58882c69c0e2f6e3 in mainline.

Some APs send management frames with junk padding after the last IE.
We already account for a similar problem with some Apple Airport
devices, but at least one device is known to send more than a single
extra byte.  The device in question is the Draytek Vigor2900:

	http://www.draytek.com.au/products/Vigor2900.php

The junk in question looks like an IE that runs off the end of the
frame.  This cause us to return ParseFailed.  Since the frame in
question is an association response, this causes us to fail to associate
with this AP.

The return code from ieee802_11_parse_elems is superfluous.
All callers still check for the presence of the specific IEs that
interest them anyway.  So, remove the return code so the parse never
"fails".

Acked-by: Michael Wu <flamingice@sourmilk.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/ieee80211_sta.c |   56 ++++++-------------------------------------
 1 file changed, 9 insertions(+), 47 deletions(-)

--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -108,15 +108,11 @@ struct ieee802_11_elems {
 	u8 wmm_param_len;
 };
 
-typedef enum { ParseOK = 0, ParseUnknown = 1, ParseFailed = -1 } ParseRes;
-
-
-static ParseRes ieee802_11_parse_elems(u8 *start, size_t len,
-				       struct ieee802_11_elems *elems)
+static void ieee802_11_parse_elems(u8 *start, size_t len,
+				   struct ieee802_11_elems *elems)
 {
 	size_t left = len;
 	u8 *pos = start;
-	int unknown = 0;
 
 	memset(elems, 0, sizeof(*elems));
 
@@ -127,15 +123,8 @@ static ParseRes ieee802_11_parse_elems(u
 		elen = *pos++;
 		left -= 2;
 
-		if (elen > left) {
-#if 0
-			if (net_ratelimit())
-				printk(KERN_DEBUG "IEEE 802.11 element parse "
-				       "failed (id=%d elen=%d left=%d)\n",
-				       id, elen, left);
-#endif
-			return ParseFailed;
-		}
+		if (elen > left)
+			return;
 
 		switch (id) {
 		case WLAN_EID_SSID:
@@ -202,28 +191,15 @@ static ParseRes ieee802_11_parse_elems(u
 			elems->ext_supp_rates_len = elen;
 			break;
 		default:
-#if 0
-			printk(KERN_DEBUG "IEEE 802.11 element parse ignored "
-				      "unknown element (id=%d elen=%d)\n",
-				      id, elen);
-#endif
-			unknown++;
 			break;
 		}
 
 		left -= elen;
 		pos += elen;
 	}
-
-	/* Do not trigger error if left == 1 as Apple Airport base stations
-	 * send AssocResps that are one spurious byte too long. */
-
-	return unknown ? ParseUnknown : ParseOK;
 }
 
 
-
-
 static int ecw2cw(int ecw)
 {
 	int cw = 1;
@@ -907,12 +883,7 @@ static void ieee80211_auth_challenge(str
 
 	printk(KERN_DEBUG "%s: replying to auth challenge\n", dev->name);
 	pos = mgmt->u.auth.variable;
-	if (ieee802_11_parse_elems(pos, len - (pos - (u8 *) mgmt), &elems)
-	    == ParseFailed) {
-		printk(KERN_DEBUG "%s: failed to parse Auth(challenge)\n",
-		       dev->name);
-		return;
-	}
+	ieee802_11_parse_elems(pos, len - (pos - (u8 *) mgmt), &elems);
 	if (!elems.challenge) {
 		printk(KERN_DEBUG "%s: no challenge IE in shared key auth "
 		       "frame\n", dev->name);
@@ -1200,12 +1171,7 @@ static void ieee80211_rx_mgmt_assoc_resp
 	aid &= ~(BIT(15) | BIT(14));
 
 	pos = mgmt->u.assoc_resp.variable;
-	if (ieee802_11_parse_elems(pos, len - (pos - (u8 *) mgmt), &elems)
-	    == ParseFailed) {
-		printk(KERN_DEBUG "%s: failed to parse AssocResp\n",
-		       dev->name);
-		return;
-	}
+	ieee802_11_parse_elems(pos, len - (pos - (u8 *) mgmt), &elems);
 
 	if (!elems.supp_rates) {
 		printk(KERN_DEBUG "%s: no SuppRates element in AssocResp\n",
@@ -1434,7 +1400,7 @@ static void ieee80211_rx_bss_info(struct
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee802_11_elems elems;
 	size_t baselen;
-	int channel, invalid = 0, clen;
+	int channel, clen;
 	struct ieee80211_sta_bss *bss;
 	struct sta_info *sta;
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
@@ -1478,9 +1444,7 @@ static void ieee80211_rx_bss_info(struct
 #endif /* CONFIG_MAC80211_IBSS_DEBUG */
 	}
 
-	if (ieee802_11_parse_elems(mgmt->u.beacon.variable, len - baselen,
-				   &elems) == ParseFailed)
-		invalid = 1;
+	ieee802_11_parse_elems(mgmt->u.beacon.variable, len - baselen, &elems);
 
 	if (sdata->type == IEEE80211_IF_TYPE_IBSS && elems.supp_rates &&
 	    memcmp(mgmt->bssid, sdata->u.sta.bssid, ETH_ALEN) == 0 &&
@@ -1699,9 +1663,7 @@ static void ieee80211_rx_mgmt_beacon(str
 	if (baselen > len)
 		return;
 
-	if (ieee802_11_parse_elems(mgmt->u.beacon.variable, len - baselen,
-				   &elems) == ParseFailed)
-		return;
+	ieee802_11_parse_elems(mgmt->u.beacon.variable, len - baselen, &elems);
 
 	if (elems.erp_info && elems.erp_info_len >= 1)
 		ieee80211_handle_erp_ie(dev, elems.erp_info[0]);

-- 
