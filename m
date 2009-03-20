Return-Path: <linux-kernel-owner+w=401wt.eu-S1761452AbZCTKLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761452AbZCTKLQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 06:11:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757914AbZCTKCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 06:02:54 -0400
Received: from gir.skynet.ie ([193.1.99.77]:55162 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756610AbZCTKCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 06:02:49 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: Mel Gorman <mel@csn.ul.ie>,
       Linux Memory Management List <linux-mm@kvack.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 22/25] Update NR_FREE_PAGES only as necessary
Date: Fri, 20 Mar 2009 10:03:09 +0000
Message-Id: <1237543392-11797-23-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1237543392-11797-1-git-send-email-mel@csn.ul.ie>
References: <1237543392-11797-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When pages are being freed to the buddy allocator, the zone
NR_FREE_PAGES counter must be updated. In the case of bulk per-cpu page
freeing, it's updated once per page. This retouches cache lines more
than necessary. Update the counters one per per-cpu bulk free.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
---
 mm/page_alloc.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 3117209..6584465 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -459,7 +459,6 @@ static inline void __free_one_page(struct page *page,
 		int migratetype)
 {
 	unsigned long page_idx;
-	int order_size = 1 << order;
 
 	if (unlikely(PageCompound(page)))
 		if (unlikely(destroy_compound_page(page, order)))
@@ -469,10 +468,9 @@ static inline void __free_one_page(struct page *page,
 
 	page_idx = page_to_pfn(page) & ((1 << MAX_ORDER) - 1);
 
-	VM_BUG_ON(page_idx & (order_size - 1));
+	VM_BUG_ON(page_idx & ((1 << order) - 1));
 	VM_BUG_ON(bad_range(zone, page));
 
-	__mod_zone_page_state(zone, NR_FREE_PAGES, order_size);
 	while (order < MAX_ORDER-1) {
 		unsigned long combined_idx;
 		struct page *buddy;
@@ -527,6 +525,8 @@ static void free_pages_bulk(struct zone *zone, int count,
 	spin_lock(&zone->lock);
 	zone_clear_flag(zone, ZONE_ALL_UNRECLAIMABLE);
 	zone->pages_scanned = 0;
+
+	__mod_zone_page_state(zone, NR_FREE_PAGES, count);
 	while (count--) {
 		struct page *page;
 
@@ -545,6 +545,8 @@ static void free_one_page(struct zone *zone, struct page *page, int order,
 	spin_lock(&zone->lock);
 	zone_clear_flag(zone, ZONE_ALL_UNRECLAIMABLE);
 	zone->pages_scanned = 0;
+
+	__mod_zone_page_state(zone, NR_FREE_PAGES, 1 << order);
 	__free_one_page(page, zone, order, migratetype);
 	spin_unlock(&zone->lock);
 }
@@ -689,7 +691,6 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 		list_del(&page->lru);
 		rmv_page_order(page);
 		area->nr_free--;
-		__mod_zone_page_state(zone, NR_FREE_PAGES, - (1UL << order));
 		expand(zone, page, order, current_order, area, migratetype);
 		return page;
 	}
@@ -829,8 +830,6 @@ __rmqueue_fallback(struct zone *zone, int order, int start_migratetype)
 			/* Remove the page from the freelists */
 			list_del(&page->lru);
 			rmv_page_order(page);
-			__mod_zone_page_state(zone, NR_FREE_PAGES,
-							-(1UL << order));
 
 			if (current_order == pageblock_order)
 				set_pageblock_migratetype(page,
@@ -904,6 +903,7 @@ static int rmqueue_bulk(struct zone *zone, unsigned int order,
 		set_page_private(page, migratetype);
 		list = &page->lru;
 	}
+	__mod_zone_page_state(zone, NR_FREE_PAGES, -(i << order));
 	spin_unlock(&zone->lock);
 	return i;
 }
-- 
1.5.6.5

