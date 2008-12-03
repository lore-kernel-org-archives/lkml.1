Return-Path: <linux-kernel-owner+w=401wt.eu-S1755938AbYLCE4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938AbYLCE4U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 23:56:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753767AbYLCE4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 23:56:10 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:48291 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204AbYLCE4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 23:56:09 -0500
Date: Wed, 3 Dec 2008 13:55:15 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH  7/21] introduce-zone_reclaim-struct.patch
Message-Id: <20081203135515.324a8769.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081203134718.6b60986f.kamezawa.hiroyu@jp.fujitsu.com>
References: <20081203134718.6b60986f.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

make zone_reclam_stat strcut for latter enhancement.

latter patch use this.
this patch doesn't any behavior change (yet).

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Rik van Riel <riel@redhat.com>

 include/linux/mmzone.h |   24 ++++++++++++++----------
 mm/page_alloc.c        |    8 ++++----
 mm/swap.c              |   12 ++++++++----
 mm/vmscan.c            |   47 ++++++++++++++++++++++++++++++-----------------
 4 files changed, 56 insertions(+), 35 deletions(-)

Index: mmotm-2.6.28-Dec02/include/linux/mmzone.h
===================================================================
--- mmotm-2.6.28-Dec02.orig/include/linux/mmzone.h
+++ mmotm-2.6.28-Dec02/include/linux/mmzone.h
@@ -263,6 +263,19 @@ enum zone_type {
 #error ZONES_SHIFT -- too many zones configured adjust calculation
 #endif
 
+struct zone_reclaim_stat {
+	/*
+	 * The pageout code in vmscan.c keeps track of how many of the
+	 * mem/swap backed and file backed pages are refeferenced.
+	 * The higher the rotated/scanned ratio, the more valuable
+	 * that cache is.
+	 *
+	 * The anon LRU stats live in [0], file LRU stats in [1]
+	 */
+	unsigned long		recent_rotated[2];
+	unsigned long		recent_scanned[2];
+};
+
 struct zone {
 	/* Fields commonly accessed by the page allocator */
 	unsigned long		pages_min, pages_low, pages_high;
@@ -315,16 +328,7 @@ struct zone {
 		unsigned long nr_scan;
 	} lru[NR_LRU_LISTS];
 
-	/*
-	 * The pageout code in vmscan.c keeps track of how many of the
-	 * mem/swap backed and file backed pages are refeferenced.
-	 * The higher the rotated/scanned ratio, the more valuable
-	 * that cache is.
-	 *
-	 * The anon LRU stats live in [0], file LRU stats in [1]
-	 */
-	unsigned long		recent_rotated[2];
-	unsigned long		recent_scanned[2];
+	struct zone_reclaim_stat reclaim_stat;
 
 	unsigned long		pages_scanned;	   /* since last reclaim */
 	unsigned long		slab_defrag_counter; /* since last defrag */
Index: mmotm-2.6.28-Dec02/mm/page_alloc.c
===================================================================
--- mmotm-2.6.28-Dec02.orig/mm/page_alloc.c
+++ mmotm-2.6.28-Dec02/mm/page_alloc.c
@@ -3523,10 +3523,10 @@ static void __paginginit free_area_init_
 			INIT_LIST_HEAD(&zone->lru[l].list);
 			zone->lru[l].nr_scan = 0;
 		}
-		zone->recent_rotated[0] = 0;
-		zone->recent_rotated[1] = 0;
-		zone->recent_scanned[0] = 0;
-		zone->recent_scanned[1] = 0;
+		zone->reclaim_stat.recent_rotated[0] = 0;
+		zone->reclaim_stat.recent_rotated[1] = 0;
+		zone->reclaim_stat.recent_scanned[0] = 0;
+		zone->reclaim_stat.recent_scanned[1] = 0;
 		zap_zone_vm_stats(zone);
 		zone->flags = 0;
 		if (!size)
Index: mmotm-2.6.28-Dec02/mm/swap.c
===================================================================
--- mmotm-2.6.28-Dec02.orig/mm/swap.c
+++ mmotm-2.6.28-Dec02/mm/swap.c
@@ -157,6 +157,7 @@ void  rotate_reclaimable_page(struct pag
 void activate_page(struct page *page)
 {
 	struct zone *zone = page_zone(page);
+	struct zone_reclaim_stat *reclaim_stat = &zone->reclaim_stat;
 
 	spin_lock_irq(&zone->lru_lock);
 	if (PageLRU(page) && !PageActive(page) && !PageUnevictable(page)) {
@@ -169,8 +170,8 @@ void activate_page(struct page *page)
 		add_page_to_lru_list(zone, page, lru);
 		__count_vm_event(PGACTIVATE);
 
-		zone->recent_rotated[!!file]++;
-		zone->recent_scanned[!!file]++;
+		reclaim_stat->recent_rotated[!!file]++;
+		reclaim_stat->recent_scanned[!!file]++;
 	}
 	spin_unlock_irq(&zone->lru_lock);
 }
@@ -398,6 +399,8 @@ void ____pagevec_lru_add(struct pagevec 
 {
 	int i;
 	struct zone *zone = NULL;
+	struct zone_reclaim_stat *reclaim_stat = NULL;
+
 	VM_BUG_ON(is_unevictable_lru(lru));
 
 	for (i = 0; i < pagevec_count(pvec); i++) {
@@ -409,6 +412,7 @@ void ____pagevec_lru_add(struct pagevec 
 			if (zone)
 				spin_unlock_irq(&zone->lru_lock);
 			zone = pagezone;
+			reclaim_stat = &zone->reclaim_stat;
 			spin_lock_irq(&zone->lru_lock);
 		}
 		VM_BUG_ON(PageActive(page));
@@ -416,10 +420,10 @@ void ____pagevec_lru_add(struct pagevec 
 		VM_BUG_ON(PageLRU(page));
 		SetPageLRU(page);
 		file = is_file_lru(lru);
-		zone->recent_scanned[file]++;
+		reclaim_stat->recent_scanned[file]++;
 		if (is_active_lru(lru)) {
 			SetPageActive(page);
-			zone->recent_rotated[file]++;
+			reclaim_stat->recent_rotated[file]++;
 		}
 		add_page_to_lru_list(zone, page, lru);
 	}
Index: mmotm-2.6.28-Dec02/mm/vmscan.c
===================================================================
--- mmotm-2.6.28-Dec02.orig/mm/vmscan.c
+++ mmotm-2.6.28-Dec02/mm/vmscan.c
@@ -131,6 +131,12 @@ static DECLARE_RWSEM(shrinker_rwsem);
 #define scan_global_lru(sc)	(1)
 #endif
 
+static struct zone_reclaim_stat *get_reclaim_stat(struct zone *zone,
+						  struct scan_control *sc)
+{
+	return &zone->reclaim_stat;
+}
+
 /*
  * Add a shrinker callback to be called from the vm
  */
@@ -1083,6 +1089,7 @@ static unsigned long shrink_inactive_lis
 	struct pagevec pvec;
 	unsigned long nr_scanned = 0;
 	unsigned long nr_reclaimed = 0;
+	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
 
 	pagevec_init(&pvec, 1);
 
@@ -1126,10 +1133,14 @@ static unsigned long shrink_inactive_lis
 
 		if (scan_global_lru(sc)) {
 			zone->pages_scanned += nr_scan;
-			zone->recent_scanned[0] += count[LRU_INACTIVE_ANON];
-			zone->recent_scanned[0] += count[LRU_ACTIVE_ANON];
-			zone->recent_scanned[1] += count[LRU_INACTIVE_FILE];
-			zone->recent_scanned[1] += count[LRU_ACTIVE_FILE];
+			reclaim_stat->recent_scanned[0] +=
+						      count[LRU_INACTIVE_ANON];
+			reclaim_stat->recent_scanned[0] +=
+						      count[LRU_ACTIVE_ANON];
+			reclaim_stat->recent_scanned[1] +=
+						      count[LRU_INACTIVE_FILE];
+			reclaim_stat->recent_scanned[1] +=
+						      count[LRU_ACTIVE_FILE];
 		}
 		spin_unlock_irq(&zone->lru_lock);
 
@@ -1190,7 +1201,7 @@ static unsigned long shrink_inactive_lis
 			add_page_to_lru_list(zone, page, lru);
 			if (PageActive(page) && scan_global_lru(sc)) {
 				int file = !!page_is_file_cache(page);
-				zone->recent_rotated[file]++;
+				reclaim_stat->recent_rotated[file]++;
 			}
 			if (!pagevec_add(&pvec, page)) {
 				spin_unlock_irq(&zone->lru_lock);
@@ -1250,6 +1261,7 @@ static void shrink_active_list(unsigned 
 	struct page *page;
 	struct pagevec pvec;
 	enum lru_list lru;
+	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
 
 	lru_add_drain();
 	spin_lock_irq(&zone->lru_lock);
@@ -1262,7 +1274,7 @@ static void shrink_active_list(unsigned 
 	 */
 	if (scan_global_lru(sc)) {
 		zone->pages_scanned += pgscanned;
-		zone->recent_scanned[!!file] += pgmoved;
+		reclaim_stat->recent_scanned[!!file] += pgmoved;
 	}
 
 	if (file)
@@ -1298,7 +1310,7 @@ static void shrink_active_list(unsigned 
 	 * pages in get_scan_ratio.
 	 */
 	if (scan_global_lru(sc))
-		zone->recent_rotated[!!file] += pgmoved;
+		reclaim_stat->recent_rotated[!!file] += pgmoved;
 
 	/*
 	 * Move the pages to the [file or anon] inactive list.
@@ -1398,6 +1410,7 @@ static void get_scan_ratio(struct zone *
 	unsigned long anon, file, free;
 	unsigned long anon_prio, file_prio;
 	unsigned long ap, fp;
+	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
 
 	/* If we have no swap space, do not bother scanning anon pages. */
 	if (nr_swap_pages <= 0) {
@@ -1430,17 +1443,17 @@ static void get_scan_ratio(struct zone *
 	 *
 	 * anon in [0], file in [1]
 	 */
-	if (unlikely(zone->recent_scanned[0] > anon / 4)) {
+	if (unlikely(reclaim_stat->recent_scanned[0] > anon / 4)) {
 		spin_lock_irq(&zone->lru_lock);
-		zone->recent_scanned[0] /= 2;
-		zone->recent_rotated[0] /= 2;
+		reclaim_stat->recent_scanned[0] /= 2;
+		reclaim_stat->recent_rotated[0] /= 2;
 		spin_unlock_irq(&zone->lru_lock);
 	}
 
-	if (unlikely(zone->recent_scanned[1] > file / 4)) {
+	if (unlikely(reclaim_stat->recent_scanned[1] > file / 4)) {
 		spin_lock_irq(&zone->lru_lock);
-		zone->recent_scanned[1] /= 2;
-		zone->recent_rotated[1] /= 2;
+		reclaim_stat->recent_scanned[1] /= 2;
+		reclaim_stat->recent_rotated[1] /= 2;
 		spin_unlock_irq(&zone->lru_lock);
 	}
 
@@ -1456,11 +1469,11 @@ static void get_scan_ratio(struct zone *
 	 * proportional to the fraction of recently scanned pages on
 	 * each list that were recently referenced and in active use.
 	 */
-	ap = (anon_prio + 1) * (zone->recent_scanned[0] + 1);
-	ap /= zone->recent_rotated[0] + 1;
+	ap = (anon_prio + 1) * (reclaim_stat->recent_scanned[0] + 1);
+	ap /= reclaim_stat->recent_rotated[0] + 1;
 
-	fp = (file_prio + 1) * (zone->recent_scanned[1] + 1);
-	fp /= zone->recent_rotated[1] + 1;
+	fp = (file_prio + 1) * (reclaim_stat->recent_scanned[1] + 1);
+	fp /= reclaim_stat->recent_rotated[1] + 1;
 
 	/* Normalize to percentages */
 	percent[0] = 100 * ap / (ap + fp + 1);

