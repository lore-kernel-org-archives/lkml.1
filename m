Return-Path: <linux-kernel-owner+w=401wt.eu-S1754377AbYKJHnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377AbYKJHnu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 02:43:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbYKJHnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 02:43:42 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:51384 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547AbYKJHnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 02:43:41 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: dcg <diegocalleja@gmail.com>
Subject: Re: swappiness in 2.6.28-rc3?
Cc: kosaki.motohiro@jp.fujitsu.com, Gene Heskett <gene.heskett@gmail.com>,
       linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>,
       Rik van Riel <riel@redhat.com>
In-Reply-To: <20081108184625.6a64a518@diego-desktop>
References: <200811081211.24000.gene.heskett@gmail.com> <20081108184625.6a64a518@diego-desktop>
Message-Id: <20081110132742.6165.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Mon, 10 Nov 2008 16:43:38 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

CCed Rik van Riel

> El Sat, 08 Nov 2008 12:11:23 -0500, Gene Heskett <gene.heskett@gmail.com> escribio:
> 
> > Greetings;
> > 
> > I have 2.6.28-rc3 with a 5 day uptime, and I have had to do a "swapoff -a; 
> > swapon -a" almost daily to clear the swap.
> > 
> > This is about 18 hours since I last did that:
> > Mem:   4151132k total,  2891180k used,  1259952k free,   281224k buffers
> > Swap:  2048276k total,    85864k used,  1962412k free,  2078404k cached
> > 
> > I don't recall having to do this with 2.6.27 or any of its -rc's.
> 
> I've also noticed more swappiness (very probably due to the vm scanning
> rework), but I can't say for sure if it's a bad thing...

Could you please try to following patch?


-----------------------------------------------------------------
From: Rik van Riel <riel@redhat.com>

This patch still needs some testing under various workloads
on different hardware - the approach should work but the
threshold may need tweaking.


When there is a lot of streaming IO going on, we do not want
to scan or evict pages from the working set.  The old VM used
to skip any mapped page, but still evict indirect blocks and
other data that is useful to cache.

This patch adds logic to skip scanning the anon lists and
the active file list if most of the file pages are on the
inactive file list (where streaming IO pages live), while
at the lowest scanning priority.

If the system is not doing a lot of streaming IO, eg. the
system is running a database workload, then more often used
file pages will be on the active file list and this logic
is automatically disabled.

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 include/linux/mmzone.h |    1 +
 mm/vmscan.c            |   18 ++++++++++++++++--
 2 files changed, 17 insertions(+), 2 deletions(-)

Index: b/include/linux/mmzone.h
===================================================================
--- a/include/linux/mmzone.h	2008-11-10 16:10:34.000000000 +0900
+++ b/include/linux/mmzone.h	2008-11-10 16:12:20.000000000 +0900
@@ -453,6 +453,7 @@ static inline int zone_is_oom_locked(con
  * queues ("queue_length >> 12") during an aging round.
  */
 #define DEF_PRIORITY 12
+#define PRIO_CACHE_ONLY (DEF_PRIORITY+1)
 
 /* Maximum number of zones on a zonelist */
 #define MAX_ZONES_PER_ZONELIST (MAX_NUMNODES * MAX_NR_ZONES)
Index: b/mm/vmscan.c
===================================================================
--- a/mm/vmscan.c	2008-11-10 16:10:34.000000000 +0900
+++ b/mm/vmscan.c	2008-11-10 16:11:30.000000000 +0900
@@ -1443,6 +1443,20 @@ static unsigned long shrink_zone(int pri
 		}
 	}
 
+	/*
+	 * If there is a lot of sequential IO going on, most of the
+	 * file pages will be on the inactive file list.  We start
+	 * out by reclaiming those pages, without putting pressure on
+	 * the working set.  We only do this if the bulk of the file pages
+	 * are not in the working set (on the active file list).
+	 */
+	if (priority == PRIO_CACHE_ONLY &&
+			(nr[LRU_INACTIVE_FILE] > nr[LRU_ACTIVE_FILE]))
+		for_each_evictable_lru(l)
+			/* Scan only the inactive_file list. */
+			if (l != LRU_INACTIVE_FILE)
+				nr[l] = 0;
+
 	while (nr[LRU_INACTIVE_ANON] || nr[LRU_ACTIVE_FILE] ||
 					nr[LRU_INACTIVE_FILE]) {
 		for_each_evictable_lru(l) {
@@ -1573,7 +1587,7 @@ static unsigned long do_try_to_free_page
 		}
 	}
 
-	for (priority = DEF_PRIORITY; priority >= 0; priority--) {
+	for (priority = PRIO_CACHE_ONLY; priority >= 0; priority--) {
 		sc->nr_scanned = 0;
 		if (!priority)
 			disable_swap_token();
@@ -1735,7 +1749,7 @@ loop_again:
 	for (i = 0; i < pgdat->nr_zones; i++)
 		temp_priority[i] = DEF_PRIORITY;
 
-	for (priority = DEF_PRIORITY; priority >= 0; priority--) {
+	for (priority = PRIO_CACHE_ONLY; priority >= 0; priority--) {
 		int end_zone = 0;	/* Inclusive.  0 = ZONE_DMA */
 		unsigned long lru_pages = 0;
 




