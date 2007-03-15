Return-Path: <linux-kernel-owner+w=401wt.eu-S933633AbXCOT7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933633AbXCOT7i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 15:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933620AbXCOT7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 15:59:37 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:42278 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933633AbXCOT7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 15:59:36 -0400
Date: Thu, 15 Mar 2007 19:59:33 +0000
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc3-mm1
Message-ID: <20070315195932.GB6236@skynet.ie>
References: <20070307201839.6f45735b.akpm@linux-foundation.org> <20070314170738.d5d35c06.akpm@linux-foundation.org> <20070315101625.GA16974@skynet.ie> <200703151637.14558.m.kozlowski@tuxland.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <200703151637.14558.m.kozlowski@tuxland.pl>
User-Agent: Mutt/1.5.9i
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (15/03/07 16:37), Mariusz Kozlowski didst pronounce:
> Hello Mel, 
> 
> > > > 	Today after +- 24h of uptime I found some more page allocation
> > > > failures ('eth1: Can't allocate skb for Rx'). You'll find more here:
> > > > 
> > > > http://tuxland.pl/misc/2.6.21-rc3-mm1-page-allocation-failure.txt
> > > > 
> > > > System wasn't doing anything unusual, as usual ;-) X, some p2p 
> > > > software, firefox+flash playing music.
> > > 
> > > Do other kernels do this, or is 2.6.21-rc3-mm1 worse?
> > > 
> > > It is of course a non-fatal problem and will inevitably happen sometimes,
> > > but we would like the VM to be able to minimise the occurrence of this
> > > problem.
> > 
> > Mariusz, I would be interested in finding out if this problem still occurs when
> > you set min_free_kbytes to 16384 via /proc/sys/vm/min_free_kbytes. I understand
> > that the problem is not easily reproduced and requiring configuration changes
> > is far from ideal but it'd allow me to find out if options 2 or 3 below make
> > sense in advance.
> 
> After a few hours I can confirm that this happens with 
> 
> $ cat /proc/sys/vm/min_free_kbytes 
> 16384
> 
> as well. See the syslog output below. Feel free to mail me to do some more tests.
> 

Ok, great. Well, not great because it's broken, but I know what's going
on. I was able to reproduce the problem based on your report on my desktop
and put together a fix for it. Full regression tests are still running but
it should be in good enough state for you to test.

Without this patch, I got allocation failures within 15 minutes by stressing
the machine. With the patch below, it's been up an hour and 15 minutes and
I'm seeing no problems so far. Will keep the machine running a few days to
see what happens.

For people watching, this patch is potentially better than MIGRATE_HIGHALLOC
for preserving areas for atomic allocations - particularly if
the size of the reserve is based on min_free_kbytes instead of
MIGATE_TYPES*MAX_ORDER_NR_PAGES. If high-order allocation reports disappear
altogether, I'll put together a patch that gets rid of MIGRATE_HIGHALLOC
altogether and see if anyone reacts. That will bring the number of free
lists down and reduce the number of bits required in pageblock flags again.

Mariusz, please try the following patch. It should not be necessary to
adjust your min_free_kbytes again but if you see a failure, please try
with min_free_kbytes set to 16384. Thanks a lot.

===== Candidate fix as follows =====
The standard buddy allocator always favours the smallest block of pages. The
effect of this is that the min_free_kbytes reserved tends to be preserved at
the same location of memory for a very long time and often as a contiguous
block. When an administrator sets the reserve at 16384, it tends to be the
same MAX_ORDER blocks that remain free. This allows the occasional high atomic
allocation to succeed. In practice, it is difficult to split these blocks
with any load but when they do split, the benefit of having min_free_kbytes
for contiguous blocks disappears.

On the other hand, CONFIG_PAGE_GROUP_BY_MOBILITY favours splitting large
blocks when there are no free pages of the appropriate type available. A
side-effect of this is that all blocks in memory tends to be used up and the
contiguous free blocks don't exist like in the vanilla allocator.  This can
cause a problem if a new caller is unwilling to reclaim or does not reclaim
for long enough.

A failure scenario was found for a wireless network device allocating order-1
atomic allocations. This was reproduced on a desktop by booting with mem=256mb,
forcing the network driver to allocate at order-1, running a bittorrent client
(downloading a debian ISO) and building a kernel with -j2.

This patch addresses the problem on the desktop machine booted with mem=256mb.
It works by setting aside a reserve of blocks at the beginning of a zone
that is only fallen back to when there is no other choice.  When falling
back to these blocks, the smallest possible page is used just like the normal
buddy allocator instead of the largest possible page to preserve contiguous
pages. More importantly, the pages in free lists in these blocks are never
taken for another migrate type.  The results is that even if min_free_kbytes
is set to a low value, a large contiguous block is still be preserved in
the MIGRATE_RESERVE blocks. This works better than the vanilla allocator
because even if a situation occurs that uses all the contiguous blocks,
they will return when the pressure relaxes because effort is made to not
use them unnecessarily.

Credit to Mariusz Kozlowski for discovering the problem, describing the
failure scenario and testing the issue.

 include/linux/mmzone.h          |    4 +
 include/linux/pageblock-flags.h |    2 
 mm/page_alloc.c                 |   83 ++++++++++++++++++++++++++++++----------
    3 files changed, 67 insertions(+), 22 deletions(-)

Signed-off-by: Mel Gorman <mel@csn.ul.ie>

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
+++ linux-2.6.21-rc3-mm2-blockreserve/mm/page_alloc.c	2007-03-15 16:13:54.000000000 +0000
@@ -688,10 +688,11 @@ static int prep_new_page(struct page *pa
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
+	[MIGRATE_RESERVE]     = { MIGRATE_RESERVE,     MIGRATE_RESERVE,   MIGRATE_RESERVE,    MIGRATE_RESERVE },
 };
 
 /*
@@ -786,6 +787,10 @@ retry:
 		for (i = 0; i < MIGRATE_TYPES - 1; i++) {
 			migratetype = fallbacks[start_migratetype][i];
 
+			/* Do not break up large MIGRATE_RESERVE blocks */
+			if (migratetype == MIGRATE_RESERVE)
+				continue;
+
 			/*
 			 * Make it hard to fallback to blocks used for
 			 * high-order atomic allocations
@@ -858,15 +863,15 @@ static struct page *__rmqueue_fallback(s
 }
 #endif /* CONFIG_PAGE_GROUP_BY_MOBILITY */
 
-/* 
- * Do the hard work of removing an element from the buddy allocator.
- * Call me with the zone->lock already held.
+/*
+ * Go through the free lists for the given migratetype and remove
+ * the smallest available page from the freelists
  */
-static struct page *__rmqueue(struct zone *zone, unsigned int order,
+static struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 						int migratetype)
 {
-	struct free_area * area;
 	unsigned int current_order;
+	struct free_area * area;
 	struct page *page;
 
 	/* Find a page of the appropriate size in the preferred list */
@@ -882,13 +887,35 @@ static struct page *__rmqueue(struct zon
 		area->nr_free--;
 		__mod_zone_page_state(zone, NR_FREE_PAGES, - (1UL << order));
 		expand(zone, page, order, current_order, area, migratetype);
-		goto got_page;
+		return page;
 	}
 
-	page = __rmqueue_fallback(zone, order, migratetype);
+	return NULL;
+}
 
-got_page:
+/*
+ * Do the hard work of removing an element from the buddy allocator.
+ * Call me with the zone->lock already held.
+ */
+static struct page *__rmqueue(struct zone *zone, unsigned int order,
+						int migratetype)
+{
+	struct page *page;
+
+	page = __rmqueue_smallest(zone, order, migratetype);
+
+	if (unlikely(!page))
+		page = __rmqueue_fallback(zone, order, migratetype);
 
+#ifdef CONFIG_PAGE_GROUP_BY_MOBILITY
+	/*
+	 * If we still have not allocated a page, use the reserve block
+	 * of pages. The smallest possible page is used in case high-order
+	 * allocations have similar problems later.
+	 */
+	if (unlikely(!page))
+		page = __rmqueue_smallest(zone, order, MIGRATE_RESERVE);
+#endif
 	return page;
 }
 
@@ -2347,7 +2374,9 @@ void __meminit memmap_init_zone(unsigned
 	struct page *page;
 	unsigned long end_pfn = start_pfn + size;
 	unsigned long pfn;
+	int reserved_blocks = 0;
 
+	/* Initialise all pages in the zone */
 	for (pfn = start_pfn; pfn < end_pfn; pfn++) {
 		/*
 		 * There can be holes in boot-time mem_map[]s
@@ -2366,14 +2395,28 @@ void __meminit memmap_init_zone(unsigned
 		reset_page_mapcount(page);
 		SetPageReserved(page);
 
-		/*
-		 * Mark the block movable so that blocks are reserved for
-		 * movable at startup. This will force kernel allocations
-		 * to reserve their blocks rather than leaking throughout
-		 * the address space during boot when many long-lived
-		 * kernel allocations are made
-		 */
-		set_pageblock_migratetype(page, MIGRATE_MOVABLE);
+		/* Initialse a pageblock if this is the first PFN */
+		if ((pfn & (MAX_ORDER_NR_PAGES-1)) == 0) {
+			/*
+			 * The majority of the blocks are marked movable so
+			 * that blocks are reserved for movable at startup.
+			 * This forces kernel allocations to reserve their
+			 * blocks rather than leaking throughout the address
+			 * space during boot when many long-lived kernel
+			 * allocations are made. MIGRATE_TYPE number of
+			 * blocks are reserved for falling back to in
+			 * situations where the page groupings failed to
+			 * keep large blocks free due to low min_free_kbytes
+			 */
+			if (reserved_blocks > MIGRATE_TYPES) {
+				set_pageblock_migratetype(page,
+							MIGRATE_MOVABLE);
+			} else {
+				reserved_blocks++;
+				set_pageblock_migratetype(page,
+							MIGRATE_RESERVE);
+			}
+		}
 
 		INIT_LIST_HEAD(&page->lru);
 #ifdef WANT_PAGE_VIRTUAL
-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
