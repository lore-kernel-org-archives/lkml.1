Return-Path: <linux-kernel-owner+w=401wt.eu-S1750977AbZCTKJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750977AbZCTKJU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 06:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758172AbZCTKCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 06:02:50 -0400
Received: from gir.skynet.ie ([193.1.99.77]:55097 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757970AbZCTKCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 06:02:44 -0400
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
Subject: [PATCH 17/25] Do not call get_pageblock_migratetype() more than necessary
Date: Fri, 20 Mar 2009 10:03:04 +0000
Message-Id: <1237543392-11797-18-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1237543392-11797-1-git-send-email-mel@csn.ul.ie>
References: <1237543392-11797-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_pageblock_migratetype() is potentially called twice for every page
free. Once, when being freed to the pcp lists and once when being freed
back to buddy. When freeing from the pcp lists, it is known what the
pageblock type was at the time of free so use it rather than rechecking.
In low memory situations under memory pressure, this might skew
anti-fragmentation slightly but the interference is minimal and
decisions that are fragmenting memory are being made anyway.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
---
 mm/page_alloc.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 795cfc5..349c64d 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -455,16 +455,18 @@ static inline int page_is_buddy(struct page *page, struct page *buddy,
  */
 
 static inline void __free_one_page(struct page *page,
-		struct zone *zone, unsigned int order)
+		struct zone *zone, unsigned int order,
+		int migratetype)
 {
 	unsigned long page_idx;
 	int order_size = 1 << order;
-	int migratetype = get_pageblock_migratetype(page);
 
 	if (unlikely(PageCompound(page)))
 		if (unlikely(destroy_compound_page(page, order)))
 			return;
 
+	VM_BUG_ON(migratetype == -1);
+
 	page_idx = page_to_pfn(page) & ((1 << MAX_ORDER) - 1);
 
 	VM_BUG_ON(page_idx & (order_size - 1));
@@ -533,17 +535,18 @@ static void free_pages_bulk(struct zone *zone, int count,
 		page = list_entry(list->prev, struct page, lru);
 		/* have to delete it as __free_one_page list manipulates */
 		list_del(&page->lru);
-		__free_one_page(page, zone, order);
+		__free_one_page(page, zone, order, page_private(page));
 	}
 	spin_unlock(&zone->lock);
 }
 
-static void free_one_page(struct zone *zone, struct page *page, int order)
+static void free_one_page(struct zone *zone, struct page *page, int order,
+				int migratetype)
 {
 	spin_lock(&zone->lock);
 	zone_clear_flag(zone, ZONE_ALL_UNRECLAIMABLE);
 	zone->pages_scanned = 0;
-	__free_one_page(page, zone, order);
+	__free_one_page(page, zone, order, migratetype);
 	spin_unlock(&zone->lock);
 }
 
@@ -568,7 +571,8 @@ static void __free_pages_ok(struct page *page, unsigned int order)
 
 	local_irq_save(flags);
 	__count_vm_events(PGFREE, 1 << order);
-	free_one_page(page_zone(page), page, order);
+	free_one_page(page_zone(page), page, order,
+					get_pageblock_migratetype(page));
 	local_irq_restore(flags);
 }
 
-- 
1.5.6.5

