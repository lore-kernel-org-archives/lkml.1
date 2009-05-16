Return-Path: <linux-kernel-owner+w=401wt.eu-S1756268AbZEPJHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756268AbZEPJHk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 05:07:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755391AbZEPJHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 05:07:10 -0400
Received: from mga03.intel.com ([143.182.124.21]:60473 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755805AbZEPJHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 05:07:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,204,1241420400"; 
   d="scan'208";a="143510107"
Message-Id: <20090516090448.535217680@intel.com>
References: <20090516090005.916779788@intel.com>
User-Agent: quilt/0.46-1
Date: Sat, 16 May 2009 17:00:08 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>,
       Wu Fengguang <fengguang.wu@intel.com>
cc: Christoph Lameter <cl@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>
Subject: [PATCH 3/3] vmscan: merge duplicate code in shrink_active_list()
Content-Disposition: inline; filename=mm-vmscan-reduce-code.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "move pages to active list" and "move pages to inactive list"
code blocks are mostly identical and can be served by a function.

Thanks to Andrew Morton for pointing this out.

Note that buffer_heads_over_limit check will also be carried out
for re-activated pages, which is slightly different from pre-2.6.28
kernels. Also, Rik's "vmscan: evict use-once pages first" patch
could totally stop scans of active list when memory pressure is low.
So the net effect could be, the number of buffer heads is now more
likely to grow large.

CC: Rik van Riel <riel@redhat.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/vmscan.c |   95 ++++++++++++++++++++++----------------------------
 1 file changed, 42 insertions(+), 53 deletions(-)

--- linux.orig/mm/vmscan.c
+++ linux/mm/vmscan.c
@@ -1225,6 +1225,43 @@ static inline void note_zone_scanning_pr
  * But we had to alter page->flags anyway.
  */
 
+static void move_active_pages_to_lru(struct zone *zone,
+				     struct list_head *list,
+				     enum lru_list lru)
+{
+	unsigned long pgmoved = 0;
+	struct pagevec pvec;
+	struct page *page;
+
+	pagevec_init(&pvec, 1);
+
+	while (!list_empty(list)) {
+		page = lru_to_page(list);
+		prefetchw_prev_lru_page(page, list, flags);
+
+		VM_BUG_ON(PageLRU(page));
+		SetPageLRU(page);
+
+		VM_BUG_ON(!PageActive(page));
+		if (lru == LRU_INACTIVE_ANON || lru == LRU_INACTIVE_FILE)
+			ClearPageActive(page);	/* we are de-activating */
+
+		list_move(&page->lru, &zone->lru[lru].list);
+		mem_cgroup_add_lru_list(page, lru);
+		pgmoved++;
+
+		if (!pagevec_add(&pvec, page) || list_empty(list)) {
+			spin_unlock_irq(&zone->lru_lock);
+			if (buffer_heads_over_limit)
+				pagevec_strip(&pvec);
+			__pagevec_release(&pvec);
+			spin_lock_irq(&zone->lru_lock);
+		}
+	}
+	__mod_zone_page_state(zone, NR_LRU_BASE + lru, pgmoved);
+	if (lru == LRU_INACTIVE_ANON || lru == LRU_INACTIVE_FILE)
+		__count_vm_events(PGDEACTIVATE, pgmoved);
+}
 
 static void shrink_active_list(unsigned long nr_pages, struct zone *zone,
 			struct scan_control *sc, int priority, int file)
@@ -1236,8 +1273,6 @@ static void shrink_active_list(unsigned 
 	LIST_HEAD(l_active);
 	LIST_HEAD(l_inactive);
 	struct page *page;
-	struct pagevec pvec;
-	enum lru_list lru;
 	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
 
 	lru_add_drain();
@@ -1254,6 +1289,7 @@ static void shrink_active_list(unsigned 
 	}
 	reclaim_stat->recent_scanned[!!file] += pgmoved;
 
+	__count_zone_vm_events(PGREFILL, zone, pgscanned);
 	if (file)
 		__mod_zone_page_state(zone, NR_ACTIVE_FILE, -pgmoved);
 	else
@@ -1295,8 +1331,6 @@ static void shrink_active_list(unsigned 
 	/*
 	 * Move pages back to the lru list.
 	 */
-	pagevec_init(&pvec, 1);
-
 	spin_lock_irq(&zone->lru_lock);
 	/*
 	 * Count referenced pages from currently used mappings as rotated.
@@ -1305,57 +1339,12 @@ static void shrink_active_list(unsigned 
 	 */
 	reclaim_stat->recent_rotated[!!file] += pgmoved;
 
-	pgmoved = 0;  /* count pages moved to inactive list */
-	lru = LRU_BASE + file * LRU_FILE;
-	while (!list_empty(&l_inactive)) {
-		page = lru_to_page(&l_inactive);
-		prefetchw_prev_lru_page(page, &l_inactive, flags);
-		VM_BUG_ON(PageLRU(page));
-		SetPageLRU(page);
-		VM_BUG_ON(!PageActive(page));
-		ClearPageActive(page);
-
-		list_move(&page->lru, &zone->lru[lru].list);
-		mem_cgroup_add_lru_list(page, lru);
-		pgmoved++;
-		if (!pagevec_add(&pvec, page)) {
-			spin_unlock_irq(&zone->lru_lock);
-			if (buffer_heads_over_limit)
-				pagevec_strip(&pvec);
-			__pagevec_release(&pvec);
-			spin_lock_irq(&zone->lru_lock);
-		}
-	}
-	__mod_zone_page_state(zone, NR_LRU_BASE + lru, pgmoved);
-	__count_zone_vm_events(PGREFILL, zone, pgscanned);
-	__count_vm_events(PGDEACTIVATE, pgmoved);
-
-	pgmoved = 0;  /* count pages moved back to active list */
-	lru = LRU_ACTIVE + file * LRU_FILE;
-	while (!list_empty(&l_active)) {
-		page = lru_to_page(&l_active);
-		prefetchw_prev_lru_page(page, &l_active, flags);
-		VM_BUG_ON(PageLRU(page));
-		SetPageLRU(page);
-		VM_BUG_ON(!PageActive(page));
-
-		list_move(&page->lru, &zone->lru[lru].list);
-		mem_cgroup_add_lru_list(page, lru);
-		pgmoved++;
-		if (!pagevec_add(&pvec, page)) {
-			spin_unlock_irq(&zone->lru_lock);
-			if (buffer_heads_over_limit)
-				pagevec_strip(&pvec);
-			__pagevec_release(&pvec);
-			spin_lock_irq(&zone->lru_lock);
-		}
-	}
-	__mod_zone_page_state(zone, NR_LRU_BASE + lru, pgmoved);
+	move_active_pages_to_lru(zone, &l_active,
+						LRU_ACTIVE + file * LRU_FILE);
+	move_active_pages_to_lru(zone, &l_inactive,
+						LRU_BASE   + file * LRU_FILE);
 
 	spin_unlock_irq(&zone->lru_lock);
-	if (buffer_heads_over_limit)
-		pagevec_strip(&pvec);
-	pagevec_release(&pvec);
 }
 
 static int inactive_anon_is_low_global(struct zone *zone)

-- 

