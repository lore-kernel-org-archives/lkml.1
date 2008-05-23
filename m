Return-Path: <linux-kernel-owner+w=401wt.eu-S1759638AbYEWWIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759638AbYEWWIs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 18:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760002AbYEWWGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 18:06:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55749 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760087AbYEWWGo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 18:06:44 -0400
Message-Id: <20080523195535.387798883@redhat.com>
References: <20080523195506.084894989@redhat.com>
User-Agent: quilt/0.46-1
Date: Fri, 23 May 2008 15:55:14 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH -mm 08/16] add some sanity checks to get_scan_ratio
Content-Disposition: inline; filename=rvr-04-linux-2.6-scan-ratio-fixes.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

The access ratio based scan rate determination in get_scan_ratio
works ok in most situations, but needs to be corrected in some
corner cases:
- if we run out of swap space, do not bother scanning the anon LRUs
- if we have already freed all of the page cache, we need to scan
  the anon LRUs
- restore the *actual* access ratio based scan rate algorithm, the
  previous versions of this patch series had the wrong version
- scale the number of pages added to zone->nr_scan[l]

Signed-off-by: Rik van Riel <riel@redhat.com>

---
 include/linux/mmzone.h |    2 
 mm/page_alloc.c        |    3 -
 mm/swap.c              |   13 +++++-
 mm/vmscan.c            |  104 ++++++++++++++++++++++++++++++++-----------------
 4 files changed, 85 insertions(+), 37 deletions(-)

Index: linux-2.6.26-rc2-mm1/mm/vmscan.c
===================================================================
--- linux-2.6.26-rc2-mm1.orig/mm/vmscan.c	2008-05-23 14:21:35.000000000 -0400
+++ linux-2.6.26-rc2-mm1/mm/vmscan.c	2008-05-23 14:21:35.000000000 -0400
@@ -893,8 +893,13 @@ static unsigned long shrink_inactive_lis
 		__mod_zone_page_state(zone, NR_INACTIVE_ANON,
 						-count[LRU_INACTIVE_ANON]);
 
-		if (scan_global_lru(sc))
+		if (scan_global_lru(sc)) {
 			zone->pages_scanned += nr_scan;
+			zone->recent_scanned_anon += count[LRU_ACTIVE_ANON] +
+						     count[LRU_INACTIVE_ANON];
+			zone->recent_scanned_file += count[LRU_ACTIVE_FILE] +
+						     count[LRU_INACTIVE_FILE];
+		}
 		spin_unlock_irq(&zone->lru_lock);
 
 		nr_scanned += nr_scan;
@@ -944,11 +949,13 @@ static unsigned long shrink_inactive_lis
 			VM_BUG_ON(PageLRU(page));
 			SetPageLRU(page);
 			list_del(&page->lru);
-			if (page_file_cache(page)) {
+			if (page_file_cache(page))
 				lru += LRU_FILE;
-				zone->recent_rotated_file++;
-			} else {
-				zone->recent_rotated_anon++;
+			if (scan_global_lru(sc)) {
+				if (page_file_cache(page))
+					zone->recent_rotated_file++;
+				else
+					zone->recent_rotated_anon++;
 			}
 			if (PageActive(page))
 				lru += LRU_ACTIVE;
@@ -1027,8 +1034,13 @@ static void shrink_active_list(unsigned 
 	 * zone->pages_scanned is used for detect zone's oom
 	 * mem_cgroup remembers nr_scan by itself.
 	 */
-	if (scan_global_lru(sc))
+	if (scan_global_lru(sc)) {
 		zone->pages_scanned += pgscanned;
+		if (file)
+			zone->recent_scanned_file += pgscanned;
+		else
+			zone->recent_scanned_anon += pgscanned;
+	}
 
 	if (file)
 		__mod_zone_page_state(zone, NR_ACTIVE_FILE, -pgmoved);
@@ -1165,9 +1177,8 @@ static unsigned long shrink_list(enum lr
 static void get_scan_ratio(struct zone *zone, struct scan_control * sc,
 					unsigned long *percent)
 {
-	unsigned long anon, file;
+	unsigned long anon, file, free;
 	unsigned long anon_prio, file_prio;
-	unsigned long rotate_sum;
 	unsigned long ap, fp;
 
 	anon  = zone_page_state(zone, NR_ACTIVE_ANON) +
@@ -1175,15 +1186,19 @@ static void get_scan_ratio(struct zone *
 	file  = zone_page_state(zone, NR_ACTIVE_FILE) +
 		zone_page_state(zone, NR_INACTIVE_FILE);
 
-	rotate_sum = zone->recent_rotated_file + zone->recent_rotated_anon;
-
 	/* Keep a floating average of RECENT references. */
-	if (unlikely(rotate_sum > min(anon, file))) {
+	if (unlikely(zone->recent_scanned_anon > anon / zone->inactive_ratio)) {
 		spin_lock_irq(&zone->lru_lock);
-		zone->recent_rotated_file /= 2;
+		zone->recent_scanned_anon /= 2;
 		zone->recent_rotated_anon /= 2;
 		spin_unlock_irq(&zone->lru_lock);
-		rotate_sum /= 2;
+	}
+
+	if (unlikely(zone->recent_scanned_file > file / 4)) {
+		spin_lock_irq(&zone->lru_lock);
+		zone->recent_scanned_file /= 2;
+		zone->recent_rotated_file /= 2;
+		spin_unlock_irq(&zone->lru_lock);
 	}
 
 	/*
@@ -1196,23 +1211,33 @@ static void get_scan_ratio(struct zone *
 	/*
 	 *                  anon       recent_rotated_anon
 	 * %anon = 100 * ----------- / ------------------- * IO cost
-	 *               anon + file       rotate_sum
+	 *               anon + file   recent_scanned_anon
 	 */
-	ap = (anon_prio * anon) / (anon + file + 1);
-	ap *= rotate_sum / (zone->recent_rotated_anon + 1);
-	if (ap == 0)
-		ap = 1;
-	else if (ap > 100)
-		ap = 100;
-	percent[0] = ap;
-
-	fp = (file_prio * file) / (anon + file + 1);
-	fp *= rotate_sum / (zone->recent_rotated_file + 1);
-	if (fp == 0)
-		fp = 1;
-	else if (fp > 100)
-		fp = 100;
-	percent[1] = fp;
+	ap = (anon_prio + 1) * (zone->recent_scanned_anon + 1);
+	ap /= zone->recent_rotated_anon + 1;
+
+	fp = (file_prio + 1) * (zone->recent_scanned_file + 1);
+	fp /= zone->recent_rotated_file + 1;
+
+	/* Normalize to percentages */
+	percent[0] = 100 * ap / (ap + fp + 1);
+	percent[1] = 100 - percent[0];
+
+	free = zone_page_state(zone, NR_FREE_PAGES);
+
+	/*
+	 * If we have no swap space, do not bother scanning anon pages.
+	 */
+	if (nr_swap_pages <= 0) {
+		percent[0] = 0;
+		percent[1] = 100;
+	}
+	/*
+	 * If we already freed most file pages, scan the anon pages
+	 * regardless of the page access ratios or swappiness setting.
+	 */
+	else if (file + free <= zone->pages_high)
+		percent[0] = 100;
 }
 
 
@@ -1233,13 +1258,17 @@ static unsigned long shrink_zone(int pri
 	for_each_lru(l) {
 		if (scan_global_lru(sc)) {
 			int file = is_file_lru(l);
+			int scan;
 			/*
 			 * Add one to nr_to_scan just to make sure that the
-			 * kernel will slowly sift through the active list.
+			 * kernel will slowly sift through each list.
 			 */
-			zone->nr_scan[l] += (zone_page_state(zone,
-				NR_INACTIVE_ANON + l) >> priority) + 1;
-			nr[l] = zone->nr_scan[l] * percent[file] / 100;
+			scan = zone_page_state(zone, NR_INACTIVE_ANON + l);
+			scan >>= priority;
+			scan = (scan * percent[file]) / 100;
+
+			zone->nr_scan[l] += scan + 1;
+			nr[l] = zone->nr_scan[l];
 			if (nr[l] >= sc->swap_cluster_max)
 				zone->nr_scan[l] = 0;
 			else
@@ -1256,7 +1285,7 @@ static unsigned long shrink_zone(int pri
 	}
 
 	while (nr[LRU_INACTIVE_ANON] || nr[LRU_ACTIVE_FILE] ||
-						 nr[LRU_INACTIVE_FILE]) {
+					nr[LRU_INACTIVE_FILE]) {
 		for_each_lru(l) {
 			if (nr[l]) {
 				nr_to_scan = min(nr[l],
@@ -1269,6 +1298,13 @@ static unsigned long shrink_zone(int pri
 		}
 	}
 
+	/*
+	 * Even if we did not try to evict anon pages at all, we want to
+	 * rebalance the anon lru active/inactive ratio.
+	 */
+	if (scan_global_lru(sc) && inactive_anon_low(zone))
+		shrink_active_list(SWAP_CLUSTER_MAX, zone, sc, priority, 0);
+
 	throttle_vm_writeout(sc->gfp_mask);
 	return nr_reclaimed;
 }
Index: linux-2.6.26-rc2-mm1/include/linux/mmzone.h
===================================================================
--- linux-2.6.26-rc2-mm1.orig/include/linux/mmzone.h	2008-05-23 14:21:35.000000000 -0400
+++ linux-2.6.26-rc2-mm1/include/linux/mmzone.h	2008-05-23 14:21:35.000000000 -0400
@@ -289,6 +289,8 @@ struct zone {
 
 	unsigned long		recent_rotated_anon;
 	unsigned long		recent_rotated_file;
+	unsigned long		recent_scanned_anon;
+	unsigned long		recent_scanned_file;
 
 	unsigned long		pages_scanned;	   /* since last reclaim */
 	unsigned long		flags;		   /* zone flags, see below */
Index: linux-2.6.26-rc2-mm1/mm/page_alloc.c
===================================================================
--- linux-2.6.26-rc2-mm1.orig/mm/page_alloc.c	2008-05-23 14:21:35.000000000 -0400
+++ linux-2.6.26-rc2-mm1/mm/page_alloc.c	2008-05-23 14:21:35.000000000 -0400
@@ -3512,7 +3512,8 @@ static void __paginginit free_area_init_
 		}
 		zone->recent_rotated_anon = 0;
 		zone->recent_rotated_file = 0;
-//TODO recent_scanned_* ???
+		zone->recent_scanned_anon = 0;
+		zone->recent_scanned_file = 0;
 		zap_zone_vm_stats(zone);
 		zone->flags = 0;
 		if (!size)
Index: linux-2.6.26-rc2-mm1/mm/swap.c
===================================================================
--- linux-2.6.26-rc2-mm1.orig/mm/swap.c	2008-05-23 14:21:34.000000000 -0400
+++ linux-2.6.26-rc2-mm1/mm/swap.c	2008-05-23 14:21:35.000000000 -0400
@@ -176,8 +176,8 @@ void activate_page(struct page *page)
 
 	spin_lock_irq(&zone->lru_lock);
 	if (PageLRU(page) && !PageActive(page)) {
-		int lru = LRU_BASE;
-		lru += page_file_cache(page);
+		int file = page_file_cache(page);
+		int lru = LRU_BASE + file;
 		del_page_from_lru_list(zone, page, lru);
 
 		SetPageActive(page);
@@ -185,6 +185,15 @@ void activate_page(struct page *page)
 		add_page_to_lru_list(zone, page, lru);
 		__count_vm_event(PGACTIVATE);
 		mem_cgroup_move_lists(page, true);
+
+		if (file) {
+			zone->recent_scanned_file++;
+			zone->recent_rotated_file++;
+		} else {
+			/* Can this happen?  Maybe through tmpfs... */
+			zone->recent_scanned_anon++;
+			zone->recent_rotated_anon++;
+		}
 	}
 	spin_unlock_irq(&zone->lru_lock);
 }

-- 
All Rights Reversed

