Return-Path: <linux-kernel-owner+w=401wt.eu-S933417AbXIJLYI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933417AbXIJLYI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 07:24:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933245AbXIJLW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 07:22:56 -0400
Received: from gir.skynet.ie ([193.1.99.77]:44703 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932983AbXIJLWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 07:22:54 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: akpm@linux-foundation.org
Cc: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Message-Id: <20070910112252.3097.9357.sendpatchset@skynet.skynet.ie>
In-Reply-To: <20070910112011.3097.8438.sendpatchset@skynet.skynet.ie>
References: <20070910112011.3097.8438.sendpatchset@skynet.skynet.ie>
Subject: [PATCH 8/13] Move free pages between lists on steal
Date: Mon, 10 Sep 2007 12:22:52 +0100 (IST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: Move free pages between lists on steal

When a fallback is forced to steal a page from a block of a different
type and more than half of the block is free reassign that block to the
new type and move the free pages over to the new type's free lists.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
[y-goto@jp.fujitsu.com: fix BUG_ON check at move_freepages()]
[apw@shadowen.org: Move to using pfn_valid_within()]
Cc: Christoph Lameter <clameter@engr.sgi.com>
Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Andy Whitcroft <andyw@uk.ibm.com>
Cc: Bob Picco <bob.picco@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   72 +++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 70 insertions(+), 2 deletions(-)

diff -rup -X /usr/src/patchset-0.6/bin//dontdiff linux-2.6.23-rc5-007-drain-per-cpu-lists-when-high-order-allocations-fail/mm/page_alloc.c linux-2.6.23-rc5-008-move-free-pages-between-lists-on-steal/mm/page_alloc.c
--- linux-2.6.23-rc5-007-drain-per-cpu-lists-when-high-order-allocations-fail/mm/page_alloc.c	2007-09-02 16:20:48.000000000 +0100
+++ linux-2.6.23-rc5-008-move-free-pages-between-lists-on-steal/mm/page_alloc.c	2007-09-02 16:21:09.000000000 +0100
@@ -662,6 +662,72 @@ static int fallbacks[MIGRATE_TYPES][MIGR
 	[MIGRATE_MOVABLE]     = { MIGRATE_RECLAIMABLE, MIGRATE_UNMOVABLE },
 };
 
+/*
+ * Move the free pages in a range to the free lists of the requested type.
+ * Note that start_page and end_pages are not aligned on a pageblock
+ * boundary. If alignment is required, use move_freepages_block()
+ */
+int move_freepages(struct zone *zone,
+			struct page *start_page, struct page *end_page,
+			int migratetype)
+{
+	struct page *page;
+	unsigned long order;
+	int blocks_moved = 0;
+
+#ifndef CONFIG_HOLES_IN_ZONE
+	/*
+	 * page_zone is not safe to call in this context when
+	 * CONFIG_HOLES_IN_ZONE is set. This bug check is probably redundant
+	 * anyway as we check zone boundaries in move_freepages_block().
+	 * Remove at a later date when no bug reports exist related to
+	 * grouping pages by mobility
+	 */
+	BUG_ON(page_zone(start_page) != page_zone(end_page));
+#endif
+
+	for (page = start_page; page <= end_page;) {
+		if (!pfn_valid_within(page_to_pfn(page))) {
+			page++;
+			continue;
+		}
+
+		if (!PageBuddy(page)) {
+			page++;
+			continue;
+		}
+
+		order = page_order(page);
+		list_del(&page->lru);
+		list_add(&page->lru,
+			&zone->free_area[order].free_list[migratetype]);
+		page += 1 << order;
+		blocks_moved++;
+	}
+
+	return blocks_moved;
+}
+
+int move_freepages_block(struct zone *zone, struct page *page, int migratetype)
+{
+	unsigned long start_pfn, end_pfn;
+	struct page *start_page, *end_page;
+
+	start_pfn = page_to_pfn(page);
+	start_pfn = start_pfn & ~(pageblock_nr_pages-1);
+	start_page = pfn_to_page(start_pfn);
+	end_page = start_page + pageblock_nr_pages - 1;
+	end_pfn = start_pfn + pageblock_nr_pages - 1;
+
+	/* Do not cross zone boundaries */
+	if (start_pfn < zone->zone_start_pfn)
+		start_page = page;
+	if (end_pfn >= zone->zone_start_pfn + zone->spanned_pages)
+		return 0;
+
+	return move_freepages(zone, start_page, end_page, migratetype);
+}
+
 /* Remove an element from the buddy allocator from the fallback list */
 static struct page *__rmqueue_fallback(struct zone *zone, int order,
 						int start_migratetype)
@@ -686,11 +752,13 @@ static struct page *__rmqueue_fallback(s
 			area->nr_free--;
 
 			/*
-			 * If breaking a large block of pages, place the buddies
-			 * on the preferred allocation list
+			 * If breaking a large block of pages, move all free
+			 * pages to the preferred allocation list
 			 */
 			if (unlikely(current_order >= (pageblock_order >> 1)))
 				migratetype = start_migratetype;
+				move_freepages_block(zone, page, migratetype);
+			}
 
 			/* Remove the page from the freelists */
 			list_del(&page->lru);
