Return-Path: <linux-kernel-owner+w=401wt.eu-S1756816AbYGGUYI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816AbYGGUYI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 16:24:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755520AbYGGUXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 16:23:54 -0400
Received: from mail.gmx.net ([213.165.64.20]:56968 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755461AbYGGUXx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 16:23:53 -0400
X-Authenticated: #429267
X-Provags-ID: V01U2FsdGVkX1+Gu2VNrYOGK5vxciilKm3+ZBgOdeNYGcxrS0SsD1
	/jI+cBStqulH5a
Subject: [PATCH] rc80211_pid: Fix fast_start parameter handling
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
       "John W. Linville" <linville@tuxdriver.com>,
       "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@elte.hu>,
       Pekka Enberg <penberg@cs.helsinki.fi>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <19f34abd0807070427w5398c617uae0a4e8e40fd8f0e@mail.gmail.com>
References: <19f34abd0807070427w5398c617uae0a4e8e40fd8f0e@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 07 Jul 2008 22:23:48 +0200
Message-Id: <1215462228.4416.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes the fast_start parameter from the rc_pid parameters information
and instead uses the parameter macro when initializing the rc_pid state. Since the
parameter is only used on initialization, there is no point of making exporting
it via debugfs. This also fixes uninitialized memory references to the
fast_start and norm_offset parameters.

Signed-off-by: Mattias Nissler <mattias.nissler@gmx.de>
---

This should fix the problem. I think this should go into mainline ASAP.

Stefano, any comments?



 net/mac80211/rc80211_pid.h      |    5 -----
 net/mac80211/rc80211_pid_algo.c |   31 +++++++++++++------------------
 2 files changed, 13 insertions(+), 23 deletions(-)

diff --git a/net/mac80211/rc80211_pid.h b/net/mac80211/rc80211_pid.h
index 04afc13..4ea7b97 100644
--- a/net/mac80211/rc80211_pid.h
+++ b/net/mac80211/rc80211_pid.h
@@ -141,7 +141,6 @@ struct rc_pid_events_file_info {
  *	rate behaviour values (lower means we should trust more what we learnt
  *	about behaviour of rates, higher means we should trust more the natural
  *	ordering of rates)
- * @fast_start: if Y, push high rates right after initialization
  */
 struct rc_pid_debugfs_entries {
 	struct dentry *dir;
@@ -154,7 +153,6 @@ struct rc_pid_debugfs_entries {
 	struct dentry *sharpen_factor;
 	struct dentry *sharpen_duration;
 	struct dentry *norm_offset;
-	struct dentry *fast_start;
 };
 
 void rate_control_pid_event_tx_status(struct rc_pid_event_buffer *buf,
@@ -267,9 +265,6 @@ struct rc_pid_info {
 	/* Normalization offset. */
 	unsigned int norm_offset;
 
-	/* Fast starst parameter. */
-	unsigned int fast_start;
-
 	/* Rates information. */
 	struct rc_pid_rateinfo *rinfo;
 
diff --git a/net/mac80211/rc80211_pid_algo.c b/net/mac80211/rc80211_pid_algo.c
index a849b74..bcd27c1 100644
--- a/net/mac80211/rc80211_pid_algo.c
+++ b/net/mac80211/rc80211_pid_algo.c
@@ -398,13 +398,25 @@ static void *rate_control_pid_alloc(struct ieee80211_local *local)
 		return NULL;
 	}
 
+	pinfo->target = RC_PID_TARGET_PF;
+	pinfo->sampling_period = RC_PID_INTERVAL;
+	pinfo->coeff_p = RC_PID_COEFF_P;
+	pinfo->coeff_i = RC_PID_COEFF_I;
+	pinfo->coeff_d = RC_PID_COEFF_D;
+	pinfo->smoothing_shift = RC_PID_SMOOTHING_SHIFT;
+	pinfo->sharpen_factor = RC_PID_SHARPENING_FACTOR;
+	pinfo->sharpen_duration = RC_PID_SHARPENING_DURATION;
+	pinfo->norm_offset = RC_PID_NORM_OFFSET;
+	pinfo->rinfo = rinfo;
+	pinfo->oldrate = 0;
+
 	/* Sort the rates. This is optimized for the most common case (i.e.
 	 * almost-sorted CCK+OFDM rates). Kind of bubble-sort with reversed
 	 * mapping too. */
 	for (i = 0; i < sband->n_bitrates; i++) {
 		rinfo[i].index = i;
 		rinfo[i].rev_index = i;
-		if (pinfo->fast_start)
+		if (RC_PID_FAST_START)
 			rinfo[i].diff = 0;
 		else
 			rinfo[i].diff = i * pinfo->norm_offset;
@@ -425,19 +437,6 @@ static void *rate_control_pid_alloc(struct ieee80211_local *local)
 			break;
 	}
 
-	pinfo->target = RC_PID_TARGET_PF;
-	pinfo->sampling_period = RC_PID_INTERVAL;
-	pinfo->coeff_p = RC_PID_COEFF_P;
-	pinfo->coeff_i = RC_PID_COEFF_I;
-	pinfo->coeff_d = RC_PID_COEFF_D;
-	pinfo->smoothing_shift = RC_PID_SMOOTHING_SHIFT;
-	pinfo->sharpen_factor = RC_PID_SHARPENING_FACTOR;
-	pinfo->sharpen_duration = RC_PID_SHARPENING_DURATION;
-	pinfo->norm_offset = RC_PID_NORM_OFFSET;
-	pinfo->fast_start = RC_PID_FAST_START;
-	pinfo->rinfo = rinfo;
-	pinfo->oldrate = 0;
-
 #ifdef CONFIG_MAC80211_DEBUGFS
 	de = &pinfo->dentries;
 	de->dir = debugfs_create_dir("rc80211_pid",
@@ -465,9 +464,6 @@ static void *rate_control_pid_alloc(struct ieee80211_local *local)
 	de->norm_offset = debugfs_create_u32("norm_offset",
 					     S_IRUSR | S_IWUSR, de->dir,
 					     &pinfo->norm_offset);
-	de->fast_start = debugfs_create_bool("fast_start",
-					     S_IRUSR | S_IWUSR, de->dir,
-					     &pinfo->fast_start);
 #endif
 
 	return pinfo;
@@ -479,7 +475,6 @@ static void rate_control_pid_free(void *priv)
 #ifdef CONFIG_MAC80211_DEBUGFS
 	struct rc_pid_debugfs_entries *de = &pinfo->dentries;
 
-	debugfs_remove(de->fast_start);
 	debugfs_remove(de->norm_offset);
 	debugfs_remove(de->sharpen_duration);
 	debugfs_remove(de->sharpen_factor);
-- 
1.5.6.1

