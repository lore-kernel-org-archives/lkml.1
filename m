Return-Path: <linux-kernel-owner+w=401wt.eu-S1757896AbZEMIDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757896AbZEMIDk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 04:03:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753310AbZEMIDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 04:03:21 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:42676 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161AbZEMIDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 04:03:18 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: greg@kroah.com
Cc: stable@kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH stable-27 1/1] mac80211: pid, fix memory corruption
Date: Wed, 13 May 2009 09:55:26 +0200
Message-Id: <1242201326-10935-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3
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

Also remove a comment which is wrong now.

This version also contains half of
mac80211: avoid NULL ptr deref when finding max_rates in PID and minstrel
patch by John W. Linville, which is namely:
-               if (sband->n_bitrates > max_rates)
+               if (sband && sband->n_bitrates > max_rates)
to fix oopses on one band devices.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: John W. Linville <linville@tuxdriver.com>
---
 net/mac80211/rc80211_pid_algo.c |   71 +++++++++++++++++++++-----------------
 1 files changed, 39 insertions(+), 32 deletions(-)

diff --git a/net/mac80211/rc80211_pid_algo.c b/net/mac80211/rc80211_pid_algo.c
index a914ba7..4077676 100644
--- a/net/mac80211/rc80211_pid_algo.c
+++ b/net/mac80211/rc80211_pid_algo.c
@@ -367,8 +367,40 @@ static void rate_control_pid_rate_init(void *priv, void *priv_sta,
 	 * Until that method is implemented, we will use the lowest supported
 	 * rate as a workaround. */
 	struct ieee80211_supported_band *sband;
+	struct rc_pid_info *pinfo = priv;
+	struct rc_pid_rateinfo *rinfo = pinfo->rinfo;
+	int i, j, tmp;
+	bool s;
 
 	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
+
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
 	sta->txrate_idx = rate_lowest_index(local, sband, sta);
 	sta->fail_avg = 0;
 }
@@ -378,21 +410,23 @@ static void *rate_control_pid_alloc(struct ieee80211_local *local)
 	struct rc_pid_info *pinfo;
 	struct rc_pid_rateinfo *rinfo;
 	struct ieee80211_supported_band *sband;
-	int i, j, tmp;
-	bool s;
+	int i, max_rates = 0;
 #ifdef CONFIG_MAC80211_DEBUGFS
 	struct rc_pid_debugfs_entries *de;
 #endif
 
-	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
-
 	pinfo = kmalloc(sizeof(*pinfo), GFP_ATOMIC);
 	if (!pinfo)
 		return NULL;
 
+	for (i = 0; i < IEEE80211_NUM_BANDS; i++) {
+		sband = local->hw.wiphy->bands[i];
+		if (sband && sband->n_bitrates > max_rates)
+			max_rates = sband->n_bitrates;
+	}
 	/* We can safely assume that sband won't change unless we get
 	 * reinitialized. */
-	rinfo = kmalloc(sizeof(*rinfo) * sband->n_bitrates, GFP_ATOMIC);
+	rinfo = kmalloc(sizeof(*rinfo) * max_rates, GFP_ATOMIC);
 	if (!rinfo) {
 		kfree(pinfo);
 		return NULL;
@@ -410,33 +444,6 @@ static void *rate_control_pid_alloc(struct ieee80211_local *local)
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
 	de->dir = debugfs_create_dir("rc80211_pid",
-- 
1.6.3

