Return-Path: <linux-kernel-owner+w=401wt.eu-S932661AbZEAWcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932661AbZEAWcd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 18:32:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764885AbZEAWbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 18:31:14 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56699 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764485AbZEAWbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 18:31:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/3] PM/Hibernate: Use memory allocations to free memory
Date: Sat, 2 May 2009 00:29:38 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc4-rjw; KDE/4.2.2; x86_64; ; )
Cc: pavel@ucw.cz, torvalds@linux-foundation.org, jens.axboe@oracle.com,
       alan-jenkins@tuffmail.co.uk, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera> <20090422131943.69288af3.akpm@linux-foundation.org> <200905020026.19027.rjw@sisk.pl>
In-Reply-To: <200905020026.19027.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905020029.39181.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Modify the hibernation memory shrinking code so that it will make
memory allocations to free memory instead of using an artificial
memory shrinking mechanism for that.  Remove the shrinking of
memory from the suspend-to-RAM code, where it is not really
necessary.  Finally, remove the no longer used memory shrinking
functions from mm/vmscan.c .

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/main.c     |   25 +-------
 kernel/power/snapshot.c |  118 ++++++++++++++++++++++++++++++---------
 mm/vmscan.c             |  142 ------------------------------------------------
 3 files changed, 93 insertions(+), 192 deletions(-)

Index: linux-2.6/kernel/power/snapshot.c
===================================================================
--- linux-2.6.orig/kernel/power/snapshot.c
+++ linux-2.6/kernel/power/snapshot.c
@@ -576,39 +576,89 @@ static unsigned long memory_bm_next_pfn(
 	return bb->start_pfn + bit;
 }
 
+/* Helper functions used for the shrinking of memory. */
+
 /**
- *	swsusp_shrink_memory -  Try to free as much memory as needed
- *
- *	... but do not OOM-kill anyone
+ * free_marked_pages - release pages allocated during memory shrinking
+ * @bm: Memory bitmap where the allocated pages were marked.
  *
- *	Notice: all userland should be stopped before it is called, or
- *	livelock is possible.
+ * Free all pages marked in given memory bitmap.
  */
+static void free_marked_pages(struct memory_bitmap *bm)
+{
+	memory_bm_position_reset(bm);
+	for(;;) {
+		unsigned long pfn;
+		struct page *page;
 
-#define SHRINK_BITE	10000
-static inline unsigned long __shrink_memory(long tmp)
+		pfn = memory_bm_next_pfn(bm);
+		if (pfn == BM_END_OF_MAP)
+			break;
+		page = pfn_to_page(pfn);
+		__free_page(page);
+	}
+}
+
+/**
+ * alloc_and_mark_page - allocate given number of pages and mark their PFNs
+ * @bm: Memory bitmap to use for marking allocated pages.
+ * @nr_pages: Number of pages to allocate.
+ *
+ * Allocate given number of pages and mark their PFNs in given memory bitmap,
+ * so that they can be released by free_marked_pages().
+ * Return value: The number of normal (ie. non-highmem) pages allocated or
+ * -ENOMEM on failure.
+ */
+static long alloc_and_mark_pages(struct memory_bitmap *bm, long nr_pages)
 {
-	if (tmp > SHRINK_BITE)
-		tmp = SHRINK_BITE;
-	return shrink_all_memory(tmp);
+	long nr_normal = 0;
+
+	while (nr_pages-- > 0) {
+		struct page *page;
+
+		page = alloc_page(GFP_KERNEL | __GFP_HIGHMEM);
+		if (!page)
+			return -ENOMEM;
+		memory_bm_set_bit(bm, page_to_pfn(page));
+		if (!PageHighMem(page))
+			nr_normal++;
+	}
+
+	return nr_normal;
 }
 
+#define SHRINK_BITE	10000
+
+/**
+ * swsusp_shrink_memory -  Try to make the kernel free as much memory as needed
+ */
 int swsusp_shrink_memory(void)
 {
 	long tmp;
 	struct zone *zone;
-	unsigned long pages = 0;
+	unsigned long pages = 0, alloc_normal = 0, alloc_highmem = 0;
 	unsigned int i = 0;
 	char *p = "-\\|/";
 	struct timeval start, stop;
+	struct memory_bitmap *bm;
+	int error;
+
+	bm = kzalloc(sizeof(*bm), GFP_KERNEL);
+	if (!bm)
+		return -ENOMEM;
+	error = memory_bm_create(bm, GFP_KERNEL, PG_ANY);
+	if (error)
+		return error;
 
 	printk(KERN_INFO "PM: Shrinking memory...  ");
 	do_gettimeofday(&start);
-	do {
-		long size, highmem_size;
 
-		highmem_size = count_highmem_pages();
-		size = count_data_pages() + PAGES_FOR_IO + SPARE_PAGES;
+	for (;;) {
+		long size, highmem_size, ret;
+
+		highmem_size = count_highmem_pages() - 2 * alloc_highmem;
+		size = count_data_pages() + PAGES_FOR_IO + SPARE_PAGES
+			- 2 * alloc_normal;
 		tmp = size;
 		size += highmem_size;
 		for_each_populated_zone(zone) {
@@ -621,27 +671,39 @@ int swsusp_shrink_memory(void)
 				tmp += zone->lowmem_reserve[ZONE_NORMAL];
 			}
 		}
-
 		if (highmem_size < 0)
 			highmem_size = 0;
-
 		tmp += highmem_size;
-		if (tmp > 0) {
-			tmp = __shrink_memory(tmp);
-			if (!tmp)
-				return -ENOMEM;
-			pages += tmp;
-		} else if (size > image_size / PAGE_SIZE) {
-			tmp = __shrink_memory(size - (image_size / PAGE_SIZE));
-			pages += tmp;
+
+		if (tmp <= 0 && size > image_size / PAGE_SIZE)
+			tmp = size - (image_size / PAGE_SIZE);
+
+		if (tmp > SHRINK_BITE)
+			tmp = SHRINK_BITE;
+		else if (tmp <= 0)
+			break;
+
+		ret = alloc_and_mark_pages(bm, tmp);
+		if (ret < 0) {
+			error = -ENOMEM;
+			goto out;
 		}
+		alloc_normal += ret;
+		alloc_highmem += tmp - ret;
+		pages += tmp;
+
 		printk("\b%c", p[i++%4]);
-	} while (tmp > 0);
+	}
+
 	do_gettimeofday(&stop);
-	printk("\bdone (%lu pages freed)\n", pages);
+	printk("\bdone (preallocated %lu free pages)\n", pages);
 	swsusp_show_speed(&start, &stop, pages, "Freed");
 
-	return 0;
+ out:
+	free_marked_pages(bm);
+	memory_bm_free(bm, PG_UNSAFE_CLEAR);
+
+	return error;
 }
 
 /**
Index: linux-2.6/mm/vmscan.c
===================================================================
--- linux-2.6.orig/mm/vmscan.c
+++ linux-2.6/mm/vmscan.c
@@ -2054,148 +2054,6 @@ unsigned long global_lru_pages(void)
 		+ global_page_state(NR_INACTIVE_FILE);
 }
 
-#ifdef CONFIG_PM
-/*
- * Helper function for shrink_all_memory().  Tries to reclaim 'nr_pages' pages
- * from LRU lists system-wide, for given pass and priority.
- *
- * For pass > 3 we also try to shrink the LRU lists that contain a few pages
- */
-static void shrink_all_zones(unsigned long nr_pages, int prio,
-				      int pass, struct scan_control *sc)
-{
-	struct zone *zone;
-	unsigned long nr_reclaimed = 0;
-
-	for_each_populated_zone(zone) {
-		enum lru_list l;
-
-		if (zone_is_all_unreclaimable(zone) && prio != DEF_PRIORITY)
-			continue;
-
-		for_each_evictable_lru(l) {
-			enum zone_stat_item ls = NR_LRU_BASE + l;
-			unsigned long lru_pages = zone_page_state(zone, ls);
-
-			/* For pass = 0, we don't shrink the active list */
-			if (pass == 0 && (l == LRU_ACTIVE_ANON ||
-						l == LRU_ACTIVE_FILE))
-				continue;
-
-			zone->lru[l].nr_scan += (lru_pages >> prio) + 1;
-			if (zone->lru[l].nr_scan >= nr_pages || pass > 3) {
-				unsigned long nr_to_scan;
-
-				zone->lru[l].nr_scan = 0;
-				nr_to_scan = min(nr_pages, lru_pages);
-				nr_reclaimed += shrink_list(l, nr_to_scan, zone,
-								sc, prio);
-				if (nr_reclaimed >= nr_pages) {
-					sc->nr_reclaimed += nr_reclaimed;
-					return;
-				}
-			}
-		}
-	}
-	sc->nr_reclaimed += nr_reclaimed;
-}
-
-/*
- * Try to free `nr_pages' of memory, system-wide, and return the number of
- * freed pages.
- *
- * Rather than trying to age LRUs the aim is to preserve the overall
- * LRU order by reclaiming preferentially
- * inactive > active > active referenced > active mapped
- */
-unsigned long shrink_all_memory(unsigned long nr_pages)
-{
-	unsigned long lru_pages, nr_slab;
-	int pass;
-	struct reclaim_state reclaim_state;
-	struct scan_control sc = {
-		.gfp_mask = GFP_KERNEL,
-		.may_unmap = 0,
-		.may_writepage = 1,
-		.isolate_pages = isolate_pages_global,
-		.nr_reclaimed = 0,
-	};
-
-	current->reclaim_state = &reclaim_state;
-
-	lru_pages = global_lru_pages();
-	nr_slab = global_page_state(NR_SLAB_RECLAIMABLE);
-	/* If slab caches are huge, it's better to hit them first */
-	while (nr_slab >= lru_pages) {
-		reclaim_state.reclaimed_slab = 0;
-		shrink_slab(nr_pages, sc.gfp_mask, lru_pages);
-		if (!reclaim_state.reclaimed_slab)
-			break;
-
-		sc.nr_reclaimed += reclaim_state.reclaimed_slab;
-		if (sc.nr_reclaimed >= nr_pages)
-			goto out;
-
-		nr_slab -= reclaim_state.reclaimed_slab;
-	}
-
-	/*
-	 * We try to shrink LRUs in 5 passes:
-	 * 0 = Reclaim from inactive_list only
-	 * 1 = Reclaim from active list but don't reclaim mapped
-	 * 2 = 2nd pass of type 1
-	 * 3 = Reclaim mapped (normal reclaim)
-	 * 4 = 2nd pass of type 3
-	 */
-	for (pass = 0; pass < 5; pass++) {
-		int prio;
-
-		/* Force reclaiming mapped pages in the passes #3 and #4 */
-		if (pass > 2)
-			sc.may_unmap = 1;
-
-		for (prio = DEF_PRIORITY; prio >= 0; prio--) {
-			unsigned long nr_to_scan = nr_pages - sc.nr_reclaimed;
-
-			sc.nr_scanned = 0;
-			sc.swap_cluster_max = nr_to_scan;
-			shrink_all_zones(nr_to_scan, prio, pass, &sc);
-			if (sc.nr_reclaimed >= nr_pages)
-				goto out;
-
-			reclaim_state.reclaimed_slab = 0;
-			shrink_slab(sc.nr_scanned, sc.gfp_mask,
-					global_lru_pages());
-			sc.nr_reclaimed += reclaim_state.reclaimed_slab;
-			if (sc.nr_reclaimed >= nr_pages)
-				goto out;
-
-			if (sc.nr_scanned && prio < DEF_PRIORITY - 2)
-				congestion_wait(WRITE, HZ / 10);
-		}
-	}
-
-	/*
-	 * If sc.nr_reclaimed = 0, we could not shrink LRUs, but there may be
-	 * something in slab caches
-	 */
-	if (!sc.nr_reclaimed) {
-		do {
-			reclaim_state.reclaimed_slab = 0;
-			shrink_slab(nr_pages, sc.gfp_mask, global_lru_pages());
-			sc.nr_reclaimed += reclaim_state.reclaimed_slab;
-		} while (sc.nr_reclaimed < nr_pages &&
-				reclaim_state.reclaimed_slab > 0);
-	}
-
-
-out:
-	current->reclaim_state = NULL;
-
-	return sc.nr_reclaimed;
-}
-#endif
-
 /* It's optimal to keep kswapds on the same CPUs as their memory, but
    not required for correctness.  So if the last cpu in a node goes
    away, we get changed to run anywhere: as the first one comes back,
Index: linux-2.6/kernel/power/main.c
===================================================================
--- linux-2.6.orig/kernel/power/main.c
+++ linux-2.6/kernel/power/main.c
@@ -195,9 +195,6 @@ static void suspend_test_finish(const ch
 
 #endif
 
-/* This is just an arbitrary number */
-#define FREE_PAGE_NUMBER (100)
-
 static struct platform_suspend_ops *suspend_ops;
 
 /**
@@ -233,7 +230,6 @@ int suspend_valid_only_mem(suspend_state
 static int suspend_prepare(void)
 {
 	int error;
-	unsigned int free_pages;
 
 	if (!suspend_ops || !suspend_ops->enter)
 		return -EPERM;
@@ -250,26 +246,11 @@ static int suspend_prepare(void)
 
 	if (suspend_freeze_processes()) {
 		error = -EAGAIN;
-		goto Thaw;
-	}
-
-	transition_in_progress = true;
-
-	free_pages = global_page_state(NR_FREE_PAGES);
-	if (free_pages < FREE_PAGE_NUMBER) {
-		pr_debug("PM: free some memory\n");
-		shrink_all_memory(FREE_PAGE_NUMBER - free_pages);
-		if (nr_free_pages() < FREE_PAGE_NUMBER) {
-			error = -ENOMEM;
-			printk(KERN_ERR "PM: No enough memory\n");
-		}
-	}
-	if (!error)
+	} else {
+		transition_in_progress = true;
 		return 0;
+	}
 
-	transition_in_progress = false;
-
- Thaw:
 	suspend_thaw_processes();
 	usermodehelper_enable();
  Finish:
