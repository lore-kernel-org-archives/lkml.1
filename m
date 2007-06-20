Return-Path: <linux-kernel-owner+w=401wt.eu-S1761518AbXFTShw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761518AbXFTShw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 14:37:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759377AbXFTSbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 14:31:10 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:54800 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757893AbXFTSaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 14:30:13 -0400
Message-Id: <20070620183012.751140302@sgi.com>
References: <20070620182907.506775016@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 20 Jun 2007 11:29:36 -0700
From: clameter@sgi.com
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Badari Pulavarty <pbadari@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [29/37] Large blocksize support: Fix up reclaim counters
Content-Disposition: inline; filename=vps_higher_order_reclaim
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We now have to reclaim compound pages of arbitrary order.

Adjust the counting in vmscan.c to could the number of base
pages.

Also change the active and inactive accounting to do the same.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/mm_inline.h |   41 +++++++++++++++++++++++++++++++----------
 mm/vmscan.c               |   22 ++++++++++++----------
 2 files changed, 43 insertions(+), 20 deletions(-)

Index: linux-2.6.22-rc4-mm2/mm/vmscan.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/mm/vmscan.c	2007-06-19 23:27:02.000000000 -0700
+++ linux-2.6.22-rc4-mm2/mm/vmscan.c	2007-06-19 23:27:29.000000000 -0700
@@ -474,14 +474,14 @@ static unsigned long shrink_page_list(st
 
 		VM_BUG_ON(PageActive(page));
 
-		sc->nr_scanned++;
+		sc->nr_scanned += compound_pages(page);
 
 		if (!sc->may_swap && page_mapped(page))
 			goto keep_locked;
 
 		/* Double the slab pressure for mapped and swapcache pages */
 		if (page_mapped(page) || PageSwapCache(page))
-			sc->nr_scanned++;
+			sc->nr_scanned += compound_pages(page);
 
 		if (PageWriteback(page))
 			goto keep_locked;
@@ -585,7 +585,7 @@ static unsigned long shrink_page_list(st
 
 free_it:
 		unlock_page(page);
-		nr_reclaimed++;
+		nr_reclaimed += compound_pages(page);
 		if (!pagevec_add(&freed_pvec, page))
 			__pagevec_release_nonlru(&freed_pvec);
 		continue;
@@ -677,22 +677,23 @@ static unsigned long isolate_lru_pages(u
 	unsigned long nr_taken = 0;
 	unsigned long scan;
 
-	for (scan = 0; scan < nr_to_scan && !list_empty(src); scan++) {
+	for (scan = 0; scan < nr_to_scan && !list_empty(src); ) {
 		struct page *page;
 		unsigned long pfn;
 		unsigned long end_pfn;
 		unsigned long page_pfn;
+		int pages;
 		int zone_id;
 
 		page = lru_to_page(src);
 		prefetchw_prev_lru_page(page, src, flags);
-
+		pages = compound_pages(page);
 		VM_BUG_ON(!PageLRU(page));
 
 		switch (__isolate_lru_page(page, mode)) {
 		case 0:
 			list_move(&page->lru, dst);
-			nr_taken++;
+			nr_taken += pages;
 			break;
 
 		case -EBUSY:
@@ -738,8 +739,8 @@ static unsigned long isolate_lru_pages(u
 			switch (__isolate_lru_page(cursor_page, mode)) {
 			case 0:
 				list_move(&cursor_page->lru, dst);
-				nr_taken++;
-				scan++;
+				nr_taken += compound_pages(cursor_page);
+				scan+= compound_pages(cursor_page);
 				break;
 
 			case -EBUSY:
@@ -749,6 +750,7 @@ static unsigned long isolate_lru_pages(u
 				break;
 			}
 		}
+		scan += pages;
 	}
 
 	*scanned = scan;
@@ -985,7 +987,7 @@ force_reclaim_mapped:
 		ClearPageActive(page);
 
 		list_move(&page->lru, &zone->inactive_list);
-		pgmoved++;
+		pgmoved += compound_pages(page);
 		if (!pagevec_add(&pvec, page)) {
 			__mod_zone_page_state(zone, NR_INACTIVE, pgmoved);
 			spin_unlock_irq(&zone->lru_lock);
@@ -1013,7 +1015,7 @@ force_reclaim_mapped:
 		SetPageLRU(page);
 		VM_BUG_ON(!PageActive(page));
 		list_move(&page->lru, &zone->active_list);
-		pgmoved++;
+		pgmoved += compound_pages(page);
 		if (!pagevec_add(&pvec, page)) {
 			__mod_zone_page_state(zone, NR_ACTIVE, pgmoved);
 			pgmoved = 0;
Index: linux-2.6.22-rc4-mm2/include/linux/mm_inline.h
===================================================================
--- linux-2.6.22-rc4-mm2.orig/include/linux/mm_inline.h	2007-06-19 23:27:02.000000000 -0700
+++ linux-2.6.22-rc4-mm2/include/linux/mm_inline.h	2007-06-20 00:22:16.000000000 -0700
@@ -2,46 +2,67 @@ static inline void
 add_page_to_active_list(struct zone *zone, struct page *page)
 {
 	list_add(&page->lru, &zone->active_list);
-	__inc_zone_state(zone, NR_ACTIVE);
+	if (!PageHead(page))
+		__inc_zone_state(zone, NR_ACTIVE);
+	else
+		__inc_zone_page_state(page, NR_ACTIVE);
 }
 
 static inline void
 add_page_to_inactive_list(struct zone *zone, struct page *page)
 {
 	list_add(&page->lru, &zone->inactive_list);
-	__inc_zone_state(zone, NR_INACTIVE);
+	if (!PageHead(page))
+		__inc_zone_state(zone, NR_INACTIVE);
+	else
+		__inc_zone_page_state(page, NR_INACTIVE);
 }
 
 static inline void
 add_page_to_inactive_list_tail(struct zone *zone, struct page *page)
 {
 	list_add_tail(&page->lru, &zone->inactive_list);
-	__inc_zone_state(zone, NR_INACTIVE);
+	if (!PageHead(page))
+		__inc_zone_state(zone, NR_INACTIVE);
+	else
+		__inc_zone_page_state(page, NR_INACTIVE);
 }
 
 static inline void
 del_page_from_active_list(struct zone *zone, struct page *page)
 {
 	list_del(&page->lru);
-	__dec_zone_state(zone, NR_ACTIVE);
+	if (!PageHead(page))
+		__dec_zone_state(zone, NR_ACTIVE);
+	else
+		__dec_zone_page_state(page, NR_ACTIVE);
 }
 
 static inline void
 del_page_from_inactive_list(struct zone *zone, struct page *page)
 {
 	list_del(&page->lru);
-	__dec_zone_state(zone, NR_INACTIVE);
+	if (!PageHead(page))
+		__dec_zone_state(zone, NR_INACTIVE);
+	else
+		__dec_zone_page_state(page, NR_INACTIVE);
 }
 
 static inline void
 del_page_from_lru(struct zone *zone, struct page *page)
 {
+	enum zone_stat_item counter = NR_ACTIVE;
+
 	list_del(&page->lru);
-	if (PageActive(page)) {
+	if (PageActive(page))
 		__ClearPageActive(page);
-		__dec_zone_state(zone, NR_ACTIVE);
-	} else {
-		__dec_zone_state(zone, NR_INACTIVE);
-	}
+	else
+		counter = NR_INACTIVE;
+
+	if (!PageHead(page))
+		__dec_zone_state(zone, counter);
+	else
+		__dec_zone_page_state(page, counter);
 }
 
+

-- 
