Return-Path: <linux-kernel-owner+w=401wt.eu-S1759860AbZFJDnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759860AbZFJDnS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 23:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757405AbZFJDfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 23:35:45 -0400
Received: from kroah.org ([198.145.64.141]:57158 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757361AbZFJDfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 23:35:43 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 17:23:48 2009
Message-Id: <20090610002347.991977455@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 17:14:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Jiri Slaby <jirislaby@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 36/60] mac80211: pid, fix memory corruption
References: <20090610001328.251476848@blue.kroah.org>
Content-Disposition: inline; filename=mac80211-pid-fix-memory-corruption.patch
In-Reply-To: <20090610032135.GA19346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jiri Slaby <jirislaby@gmail.com>

commit a8659597bf744b0f8d2560e2a734b5c941569e0e upstream

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/rc80211_pid_algo.c |   71 +++++++++++++++++++++-------------------
 1 file changed, 39 insertions(+), 32 deletions(-)

--- a/net/mac80211/rc80211_pid_algo.c
+++ b/net/mac80211/rc80211_pid_algo.c
@@ -367,8 +367,40 @@ static void rate_control_pid_rate_init(v
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
@@ -378,21 +410,23 @@ static void *rate_control_pid_alloc(stru
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
@@ -410,33 +444,6 @@ static void *rate_control_pid_alloc(stru
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


