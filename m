Return-Path: <linux-kernel-owner+w=401wt.eu-S1758133AbZEDQKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758133AbZEDQKp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 12:10:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756271AbZEDQKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 12:10:33 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:55707 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756735AbZEDQKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 12:10:32 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH v2 2/2] mac80211: pid, fix memory corruption
Date: Mon,  4 May 2009 18:10:28 +0200
Message-Id: <1241453428-9029-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1241453238.8683.52.camel@johannes.local>
References: <1241453238.8683.52.camel@johannes.local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pid doesn't count with some band having more bitrates than the one
associated the first time.
Fix that by counting the maximal available bitrate count and allocate
big enough space.

Secondly, fix touching uninitialized memory which causes panics.
Index sucked from this random memory points to the hell.
The fix is to sort the rates on each band change.

[v2]
 - remove comment which is wrong now

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 net/mac80211/rc80211_pid_algo.c |   73 +++++++++++++++++++++------------------
 1 files changed, 39 insertions(+), 34 deletions(-)

diff --git a/net/mac80211/rc80211_pid_algo.c b/net/mac80211/rc80211_pid_algo.c
index b16801c..01d59a8 100644
--- a/net/mac80211/rc80211_pid_algo.c
+++ b/net/mac80211/rc80211_pid_algo.c
@@ -317,13 +317,44 @@ rate_control_pid_rate_init(void *priv, struct ieee80211_supported_band *sband,
 			   struct ieee80211_sta *sta, void *priv_sta)
 {
 	struct rc_pid_sta_info *spinfo = priv_sta;
+	struct rc_pid_info *pinfo = priv;
+	struct rc_pid_rateinfo *rinfo = pinfo->rinfo;
 	struct sta_info *si;
+	int i, j, tmp;
+	bool s;
 
 	/* TODO: This routine should consider using RSSI from previous packets
 	 * as we need to have IEEE 802.1X auth succeed immediately after assoc..
 	 * Until that method is implemented, we will use the lowest supported
 	 * rate as a workaround. */
 
+	/* Sort the rates. This is optimized for the most common case (i.e.
+	 * almost-sorted CCK+OFDM rates). Kind of bubble-sort with reversed
+	 * mapping too. */
+	for (i = 0; i < sband->n_bitrates; i++) {
+		rinfo[i].index = i;
+		rinfo[i].rev_index = i;
+		if (RC_PID_FAST_START)
+			rinfo[i].diff = 0;
+		else
+			rinfo[i].diff = i * pinfo->norm_offset;
+	}
+	for (i = 1; i < sband->n_bitrates; i++) {
+		s = 0;
+		for (j = 0; j < sband->n_bitrates - i; j++)
+			if (unlikely(sband->bitrates[rinfo[j].index].bitrate >
+				     sband->bitrates[rinfo[j + 1].index].bitrate)) {
+				tmp = rinfo[j].index;
+				rinfo[j].index = rinfo[j + 1].index;
+				rinfo[j + 1].index = tmp;
+				rinfo[rinfo[j].index].rev_index = j;
+				rinfo[rinfo[j + 1].index].rev_index = j + 1;
+				s = 1;
+			}
+		if (!s)
+			break;
+	}
+
 	spinfo->txrate_idx = rate_lowest_index(sband, sta);
 	/* HACK */
 	si = container_of(sta, struct sta_info, sta);
@@ -336,21 +367,22 @@ static void *rate_control_pid_alloc(struct ieee80211_hw *hw,
 	struct rc_pid_info *pinfo;
 	struct rc_pid_rateinfo *rinfo;
 	struct ieee80211_supported_band *sband;
-	int i, j, tmp;
-	bool s;
+	int i, max_rates = 0;
 #ifdef CONFIG_MAC80211_DEBUGFS
 	struct rc_pid_debugfs_entries *de;
 #endif
 
-	sband = hw->wiphy->bands[hw->conf.channel->band];
-
 	pinfo = kmalloc(sizeof(*pinfo), GFP_ATOMIC);
 	if (!pinfo)
 		return NULL;
 
-	/* We can safely assume that sband won't change unless we get
-	 * reinitialized. */
-	rinfo = kmalloc(sizeof(*rinfo) * sband->n_bitrates, GFP_ATOMIC);
+	for (i = 0; i < IEEE80211_NUM_BANDS; i++) {
+		sband = hw->wiphy->bands[i];
+		if (sband->n_bitrates > max_rates)
+			max_rates = sband->n_bitrates;
+	}
+
+	rinfo = kmalloc(sizeof(*rinfo) * max_rates, GFP_ATOMIC);
 	if (!rinfo) {
 		kfree(pinfo);
 		return NULL;
@@ -368,33 +400,6 @@ static void *rate_control_pid_alloc(struct ieee80211_hw *hw,
 	pinfo->rinfo = rinfo;
 	pinfo->oldrate = 0;
 
-	/* Sort the rates. This is optimized for the most common case (i.e.
-	 * almost-sorted CCK+OFDM rates). Kind of bubble-sort with reversed
-	 * mapping too. */
-	for (i = 0; i < sband->n_bitrates; i++) {
-		rinfo[i].index = i;
-		rinfo[i].rev_index = i;
-		if (RC_PID_FAST_START)
-			rinfo[i].diff = 0;
-		else
-			rinfo[i].diff = i * pinfo->norm_offset;
-	}
-	for (i = 1; i < sband->n_bitrates; i++) {
-		s = 0;
-		for (j = 0; j < sband->n_bitrates - i; j++)
-			if (unlikely(sband->bitrates[rinfo[j].index].bitrate >
-				     sband->bitrates[rinfo[j + 1].index].bitrate)) {
-				tmp = rinfo[j].index;
-				rinfo[j].index = rinfo[j + 1].index;
-				rinfo[j + 1].index = tmp;
-				rinfo[rinfo[j].index].rev_index = j;
-				rinfo[rinfo[j + 1].index].rev_index = j + 1;
-				s = 1;
-			}
-		if (!s)
-			break;
-	}
-
 #ifdef CONFIG_MAC80211_DEBUGFS
 	de = &pinfo->dentries;
 	de->target = debugfs_create_u32("target_pf", S_IRUSR | S_IWUSR,
-- 
1.6.2.4

