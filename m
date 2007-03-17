Return-Path: <linux-kernel-owner+w=401wt.eu-S1752847AbXCQS0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847AbXCQS0q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 14:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751653AbXCQS0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 14:26:45 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:51230 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbXCQS0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 14:26:44 -0400
Date: Sat, 17 Mar 2007 18:26:41 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mariusz Kozlowski <m.kozlowski@tuxland.pl>, linux-kernel@vger.kernel.org
Subject: [PATCH] Bias the location of pages freed for min_free_kbytes in the same MAX_ORDER_NR_PAGES blocks
Message-ID: <20070317182641.GA19447@skynet.ie>
References: <20070307201839.6f45735b.akpm@linux-foundation.org> <200703142006.04547.m.kozlowski@tuxland.pl> <20070314170738.d5d35c06.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20070314170738.d5d35c06.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Begorrah - patches from Irish people on Paddy's day, who would have though it.
Clearly, this patch is full of lucky charms.

On a more serious note, this patch appears to address the page allocation
problem reported by Mariusz Kozlowski.

Changelog since v1
o Select the number of blocks to mark MIGRATE_RESERVE intelligently
o Take bootmem into account when placing MIGRATE_RESERVE blocks

The standard buddy allocator always favours the smallest block of pages. The
effect of this is that the pages free to satisfy min_free_kbytes tends to be
preserved since boot time at the same location of memory ffor a very long time
and as a contiguous block. When an administrator sets the reserve at 16384 at
boot time, it tends to be the same MAX_ORDER blocks that remain free. This
allows the occasional high atomic allocation to succeed up until the point
the blocks are split. In practice, it is difficult to split these blocks
but when they do split, the benefit of having min_free_kbytes for contiguous
blocks disappears. Additionally, increasing min_free_kbytes once the system
has been running for some time has no guarantee of creating contiguous blocks.

On the other hand, CONFIG_PAGE_GROUP_BY_MOBILITY favours splitting large blocks
when there are no free pages of the appropriate type available. A side-effect
of this is that all blocks in memory tends to be used up and the contiguous
free blocks from boot time are not preserved like in the vanilla allocator.
This can cause a problem if a new caller is unwilling to reclaim or does
not reclaim for long enough.

A failure scenario was found for a wireless network device allocating order-1
atomic allocations but the allocations were not intense or frequent enough
for a whole block of pages to be preserved for MIGRATE_HIGHALLOC. This was
reproduced on a desktop by booting with mem=256mb, forcing the driver to
allocate at order-1, running a bittorrent client (downloading a debian ISO)
and building a kernel with -j2.

This patch addresses the problem on the desktop machine booted with mem=256mb.
It works by setting aside a reserve of MAX_ORDER_NR_PAGES blocks, the number
of which depends on the value of min_free_kbytes.  These blocks are only
fallen back to when there is no other free pages. Then the smallest possible
page is used just like the normal buddy allocator instead of the largest
possible page to preserve contiguous pages The pages in free lists in the
reserve blocks are never taken for another migrate type.  The results is
that even if min_free_kbytes is set to a low value, contiguous blocks will
be preserved in the MIGRATE_RESERVE blocks.

This works better than the vanilla allocator because if min_free_kbytes
is increased, a new reserve block will be chosen based on the location of
reclaimable pages and the block will free up as contiguous pages. In the
vanilla allocator, no effort is made to target a block of pages to free as
contiguous pages and min_free_kbytes pages are scattered randomly.

This effect has been observed on the test machine. min_free_kbytes
was set initially low but it was kept as a contiguous free block within
MIGRATE_RESERVE. min_free_kbytes was then set to a higher value and over a
period of time, the free blocks were within the reserve and coalescing. How
long it takes to free up depends on how quickly LRU is rotating. Amusingly,
this means that more activity will free the blocks faster.

This mechanism potentially replaces MIGRATE_HIGHALLOC as it may be more
effective than grouping contiguous free pages together. It all depends on
whether the number of active atomic high allocations exceeds min_free_kbytes or
not. If the number of active allocations exceeds min_free_kbytes, it's worth
it but maybe in that situation, min_free_kbytes should be set higher. Once
there are no more reports of allocation failures, a patch will be submitted
that backs out MIGRATE_HIGHALLOC and see if the reports stay missing.

Credit to Mariusz Kozlowski for discovering the problem, describing the
failure scenario and testing patches and scenarios.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Andy Whitcroft <apw@shadowen.org>

 include/linux/mmzone.h          |    4 -
 include/linux/pageblock-flags.h |    2 
 mm/page_alloc.c                 |  139 +++++++++++++++++++++++++++++++---------
 3 files changed, 115 insertions(+), 30 deletions(-)

---

diff -rup -X /usr/src/patchset-0.6/bin//dontdiff linux-2.6.21-rc3-mm2-clean/include/linux/mmzone.h linux-2.6.21-rc3-mm2-blockreserve/include/linux/mmzone.h
--- linux-2.6.21-rc3-mm2-clean/include/linux/mmzone.h	2007-03-14 15:47:09.000000000 +0000
+++ linux-2.6.21-rc3-mm2-blockreserve/include/linux/mmzone.h	2007-03-15 16:07:31.000000000 +0000
@@ -30,12 +30,14 @@
 #define MIGRATE_RECLAIMABLE   1
 #define MIGRATE_MOVABLE       2
 #define MIGRATE_HIGHATOMIC    3
-#define MIGRATE_TYPES         4
+#define MIGRATE_RESERVE       4
+#define MIGRATE_TYPES         5
 #else
 #define MIGRATE_UNMOVABLE     0
 #define MIGRATE_UNRECLAIMABLE 0
 #define MIGRATE_MOVABLE       0
 #define MIGRATE_HIGHATOMIC    0
+#define MIGRATE_RESERVE       0
 #define MIGRATE_TYPES         1
 #endif
 
diff -rup -X /usr/src/patchset-0.6/bin//dontdiff linux-2.6.21-rc3-mm2-clean/include/linux/pageblock-flags.h linux-2.6.21-rc3-mm2-blockreserve/include/linux/pageblock-flags.h
--- linux-2.6.21-rc3-mm2-clean/include/linux/pageblock-flags.h	2007-03-14 15:47:09.000000000 +0000
+++ linux-2.6.21-rc3-mm2-blockreserve/include/linux/pageblock-flags.h	2007-03-15 16:07:31.000000000 +0000
@@ -31,7 +31,7 @@
 
 /* Bit indices that affect a whole block of pages */
 enum pageblock_bits {
-	PB_range(PB_migrate, 2), /* 2 bits required for migrate types */
+	PB_range(PB_migrate, 3), /* 3 bits required for migrate types */
 	NR_PAGEBLOCK_BITS
 };
 
diff -rup -X /usr/src/patchset-0.6/bin//dontdiff linux-2.6.21-rc3-mm2-clean/mm/page_alloc.c linux-2.6.21-rc3-mm2-blockreserve/mm/page_alloc.c
--- linux-2.6.21-rc3-mm2-clean/mm/page_alloc.c	2007-03-14 16:07:23.000000000 +0000
+++ linux-2.6.21-rc3-mm2-blockreserve/mm/page_alloc.c	2007-03-16 19:18:13.000000000 +0000
@@ -682,16 +682,48 @@ static int prep_new_page(struct page *pa
 	return 0;
 }
 
+/*
+ * Go through the free lists for the given migratetype and remove
+ * the smallest available page from the freelists
+ */
+static struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
+						int migratetype)
+{
+	unsigned int current_order;
+	struct free_area * area;
+	struct page *page;
+
+	/* Find a page of the appropriate size in the preferred list */
+	for (current_order = order; current_order < MAX_ORDER; ++current_order) {
+		area = &(zone->free_area[current_order]);
+		if (list_empty(&area->free_list[migratetype]))
+			continue;
+
+		page = list_entry(area->free_list[migratetype].next,
+							struct page, lru);
+		list_del(&page->lru);
+		rmv_page_order(page);
+		area->nr_free--;
+		__mod_zone_page_state(zone, NR_FREE_PAGES, - (1UL << order));
+		expand(zone, page, order, current_order, area, migratetype);
+		return page;
+	}
+
+	return NULL;
+}
+
+
 #ifdef CONFIG_PAGE_GROUP_BY_MOBILITY
 /*
  * This array describes the order lists are fallen back to when
  * the free lists for the desirable migrate type are depleted
  */
 static int fallbacks[MIGRATE_TYPES][MIGRATE_TYPES-1] = {
-	[MIGRATE_UNMOVABLE]   = { MIGRATE_RECLAIMABLE, MIGRATE_MOVABLE,  MIGRATE_HIGHATOMIC },
-	[MIGRATE_RECLAIMABLE] = { MIGRATE_UNMOVABLE,   MIGRATE_MOVABLE,  MIGRATE_HIGHATOMIC },
-	[MIGRATE_MOVABLE]     = { MIGRATE_RECLAIMABLE, MIGRATE_UNMOVABLE,MIGRATE_HIGHATOMIC },
-	[MIGRATE_HIGHATOMIC]  = { MIGRATE_RECLAIMABLE, MIGRATE_UNMOVABLE,MIGRATE_MOVABLE},
+	[MIGRATE_UNMOVABLE]   = { MIGRATE_RECLAIMABLE, MIGRATE_MOVABLE,   MIGRATE_HIGHATOMIC, MIGRATE_RESERVE },
+	[MIGRATE_RECLAIMABLE] = { MIGRATE_UNMOVABLE,   MIGRATE_MOVABLE,   MIGRATE_HIGHATOMIC, MIGRATE_RESERVE },
+	[MIGRATE_MOVABLE]     = { MIGRATE_RECLAIMABLE, MIGRATE_UNMOVABLE, MIGRATE_HIGHATOMIC, MIGRATE_RESERVE },
+	[MIGRATE_HIGHATOMIC]  = { MIGRATE_RECLAIMABLE, MIGRATE_UNMOVABLE, MIGRATE_MOVABLE,    MIGRATE_RESERVE },
+	[MIGRATE_RESERVE]     = { MIGRATE_RESERVE,     MIGRATE_RESERVE,   MIGRATE_RESERVE,    MIGRATE_RESERVE }, /* Never used */
 };
 
 /*
@@ -786,6 +818,9 @@ retry:
 		for (i = 0; i < MIGRATE_TYPES - 1; i++) {
 			migratetype = fallbacks[start_migratetype][i];
 
+			/* MIGRATE_RESERVE handled later if necessary */
+			if (migratetype == MIGRATE_RESERVE)
+				continue;
 			/*
 			 * Make it hard to fallback to blocks used for
 			 * high-order atomic allocations
@@ -848,7 +883,8 @@ retry:
 		goto retry;
 	}
 
-	return NULL;
+	/* Use MIGRATE_RESERVE rather than fail an allocation */
+	return __rmqueue_smallest(zone, order, MIGRATE_RESERVE);
 }
 #else
 static struct page *__rmqueue_fallback(struct zone *zone, int order,
@@ -858,36 +894,19 @@ static struct page *__rmqueue_fallback(s
 }
 #endif /* CONFIG_PAGE_GROUP_BY_MOBILITY */
 
-/* 
+/*
  * Do the hard work of removing an element from the buddy allocator.
  * Call me with the zone->lock already held.
  */
 static struct page *__rmqueue(struct zone *zone, unsigned int order,
 						int migratetype)
 {
-	struct free_area * area;
-	unsigned int current_order;
 	struct page *page;
 
-	/* Find a page of the appropriate size in the preferred list */
-	for (current_order = order; current_order < MAX_ORDER; ++current_order) {
-		area = &(zone->free_area[current_order]);
-		if (list_empty(&area->free_list[migratetype]))
-			continue;
-
-		page = list_entry(area->free_list[migratetype].next,
-							struct page, lru);
-		list_del(&page->lru);
-		rmv_page_order(page);
-		area->nr_free--;
-		__mod_zone_page_state(zone, NR_FREE_PAGES, - (1UL << order));
-		expand(zone, page, order, current_order, area, migratetype);
-		goto got_page;
-	}
-
-	page = __rmqueue_fallback(zone, order, migratetype);
+	page = __rmqueue_smallest(zone, order, migratetype);
 
-got_page:
+	if (unlikely(!page))
+		page = __rmqueue_fallback(zone, order, migratetype);
 
 	return page;
 }
@@ -2336,6 +2355,63 @@ static inline unsigned long wait_table_b
 
 #define LONG_ALIGN(x) (((x)+(sizeof(long))-1)&~((sizeof(long))-1))
 
+#ifdef CONFIG_PAGE_GROUP_BY_MOBILITY
+/*
+ * Mark a number of MAX_ORDER_NR_PAGES blocks as MIGRATE_RESERVE. The number
+ * of blocks reserved is based on zone->pages_min. The memory within the
+ * reserve will tend to store contiguous free pages. Setting min_free_kbytes
+ * higher will lead to a bigger reserve which will get freed as contiguous
+ * blocks as reclaim kicks in
+ */
+void setup_zone_migrate_reserve(struct zone *zone)
+{
+	unsigned long start_pfn, pfn, end_pfn;
+	struct page *page;
+	unsigned long reserve, block_migratetype;
+
+	/* Get the start pfn, end pfn and the number of blocks to reserve */
+	start_pfn = zone->zone_start_pfn;
+	end_pfn = start_pfn + zone->spanned_pages;
+	reserve = roundup(zone->pages_min, MAX_ORDER_NR_PAGES) >> (MAX_ORDER-1);
+
+	for (pfn = start_pfn; pfn < end_pfn; pfn += MAX_ORDER_NR_PAGES) {
+		if (!pfn_valid(pfn))
+			continue;
+		page = pfn_to_page(pfn);
+
+		/* Blocks with reserved pages will never free, skip them. */
+		if (PageReserved(page))
+			continue;
+
+		block_migratetype = get_pageblock_migratetype(page);
+
+		/* If this block is reserved, account for it */
+		if (reserve > 0 && block_migratetype == MIGRATE_RESERVE) {
+			reserve--;
+			continue;
+		}
+
+		/* Suitable for reserving if this block is movable */
+		if (reserve > 0 && block_migratetype == MIGRATE_MOVABLE) {
+			set_pageblock_migratetype(page, MIGRATE_RESERVE);
+			move_freepages_block(zone, page, MIGRATE_RESERVE);
+			reserve--;
+			continue;
+		}
+
+		/*
+		 * If the reserve is met and this is a previous reserved block,
+		 * take it back
+		 */
+		if (block_migratetype == MIGRATE_RESERVE) {
+			set_pageblock_migratetype(page, MIGRATE_MOVABLE);
+			move_freepages_block(zone, page, MIGRATE_MOVABLE);
+		}
+	}
+}
+#else
+void setup_zone_migrate_reserve(struct zone *zone) {}
+#endif /* CONFIG_PAGE_GROUP_BY_MOBILITY */
 /*
  * Initially all pages are reserved - free ones are freed
  * up by free_all_bootmem() once the early boot process is
@@ -2371,9 +2449,13 @@ void __meminit memmap_init_zone(unsigned
 		 * movable at startup. This will force kernel allocations
 		 * to reserve their blocks rather than leaking throughout
 		 * the address space during boot when many long-lived
-		 * kernel allocations are made
+		 * kernel allocations are made. Later some blocks near
+		 * the start are marked MIGRATE_RESERVE by
+		 * setup_zone_migrate_reserve()
 		 */
-		set_pageblock_migratetype(page, MIGRATE_MOVABLE);
+		if ((pfn & (MAX_ORDER_NR_PAGES-1)) == 0 &&
+				get_pageblock_migratetype(page) != MIGRATE_RESERVE)
+			set_pageblock_migratetype(page, MIGRATE_MOVABLE);
 
 		INIT_LIST_HEAD(&page->lru);
 #ifdef WANT_PAGE_VIRTUAL
@@ -3806,6 +3888,7 @@ void setup_per_zone_pages_min(void)
 
 		zone->pages_low   = zone->pages_min + (tmp >> 2);
 		zone->pages_high  = zone->pages_min + (tmp >> 1);
+		setup_zone_migrate_reserve(zone);
 		spin_unlock_irqrestore(&zone->lru_lock, flags);
 	}
 
-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
