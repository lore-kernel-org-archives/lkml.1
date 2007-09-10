Return-Path: <linux-kernel-owner+w=401wt.eu-S933693AbXIJL02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933693AbXIJL02 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 07:26:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933377AbXIJLYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 07:24:17 -0400
Received: from gir.skynet.ie ([193.1.99.77]:44820 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933483AbXIJLYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 07:24:15 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: akpm@linux-foundation.org
Cc: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Message-Id: <20070910112412.3097.66906.sendpatchset@skynet.skynet.ie>
In-Reply-To: <20070910112011.3097.8438.sendpatchset@skynet.skynet.ie>
References: <20070910112011.3097.8438.sendpatchset@skynet.skynet.ie>
Subject: [PATCH 12/13] Be more agressive about stealing when MIGRATE_RECLAIMABLE allocations fallback
Date: Mon, 10 Sep 2007 12:24:12 +0100 (IST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: Be more agressive about stealing when MIGRATE_RECLAIMABLE allocations fallback

MIGRATE_RECLAIMABLE allocations tend to be very bursty in nature like when
updatedb starts.  It is likely this will occur in situations where MAX_ORDER
blocks of pages are not free.  This means that updatedb can scatter
MIGRATE_RECLAIMABLE pages throughout the address space.  This patch is more
agressive about stealing blocks of pages for MIGRATE_RECLAIMABLE.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff -rup -X /usr/src/patchset-0.6/bin//dontdiff linux-2.6.23-rc5-011-bias-the-placement-of-kernel-pages-at-lower-pfns/mm/page_alloc.c linux-2.6.23-rc5-012-be-more-agressive-about-stealing-when-migrate_reclaimable-allocations-fallback/mm/page_alloc.c
--- linux-2.6.23-rc5-011-bias-the-placement-of-kernel-pages-at-lower-pfns/mm/page_alloc.c	2007-09-02 16:22:27.000000000 +0100
+++ linux-2.6.23-rc5-012-be-more-agressive-about-stealing-when-migrate_reclaimable-allocations-fallback/mm/page_alloc.c	2007-09-02 16:22:47.000000000 +0100
@@ -713,7 +713,7 @@ int move_freepages(struct zone *zone,
 {
 	struct page *page;
 	unsigned long order;
-	int blocks_moved = 0;
+	int pages_moved = 0;
 
 #ifndef CONFIG_HOLES_IN_ZONE
 	/*
@@ -742,10 +742,10 @@ int move_freepages(struct zone *zone,
 		list_add(&page->lru,
 			&zone->free_area[order].free_list[migratetype]);
 		page += 1 << order;
-		blocks_moved++;
+		pages_moved += 1 << order;
 	}
 
-	return blocks_moved;
+	return pages_moved;
 }
 
 int move_freepages_block(struct zone *zone, struct page *page, int migratetype)
@@ -817,11 +817,22 @@ static struct page *__rmqueue_fallback(s
 
 			/*
 			 * If breaking a large block of pages, move all free
-			 * pages to the preferred allocation list
+			 * pages to the preferred allocation list. If falling
+			 * back for a reclaimable kernel allocation, be more
+			 * agressive about taking ownership of free pages
 			 */
-			if (unlikely(current_order >= (pageblock_order >> 1)))
+			if (unlikely(current_order >= (pageblock_order >> 1)) ||
+					start_migratetype == MIGRATE_RECLAIMABLE) {
+				unsigned long pages;
+				pages = move_freepages_block(zone, page,
+								start_migratetype);
+
+				/* Claim the whole block if over half of it is free */
+				if (pages >= (1 << (pageblock_order-1)))
+					set_pageblock_migratetype(page,
+								start_migratetype);
+
 				migratetype = start_migratetype;
-				move_freepages_block(zone, page, migratetype);
 			}
 
 			/* Remove the page from the freelists */
