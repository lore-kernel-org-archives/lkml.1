Return-Path: <linux-kernel-owner+w=401wt.eu-S1757445AbZEDAZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445AbZEDAZp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 20:25:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757160AbZEDAYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 20:24:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37245 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756577AbZEDAYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 20:24:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: [PATCH 4/5] PM/Hibernate: Use memory allocations to free memory (rev. 3)
Date: Mon, 4 May 2009 02:20:43 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc4-rjw; KDE/4.2.2; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>, pavel@ucw.cz,
       torvalds@linux-foundation.org, jens.axboe@oracle.com,
       alan-jenkins@tuffmail.co.uk, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera> <200905031830.49690.rjw@sisk.pl> <200905040208.43040.rjw@sisk.pl>
In-Reply-To: <200905040208.43040.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905040220.44902.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Modify the hibernation memory shrinking code so that it will make
memory allocations to free memory instead of using an artificial
memory shrinking mechanism for that.  Remove the no longer used memory
shrinking functions from mm/vmscan.c .

[rev. 2: Use the existing memory bitmaps for marking preallocated
 image pages and use swsusp_free() from releasing them, add comments
 describing the memory shrinking strategy.
 rev. 3: change the memory shrinking strategy to preallocate as much
 memory as needed to get the right image size in one shot.]

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/snapshot.c |  119 +++++++++++++++++++++++-----------------
 mm/vmscan.c             |  142 ------------------------------------------------
 2 files changed, 70 insertions(+), 191 deletions(-)

Index: linux-2.6/kernel/power/snapshot.c
===================================================================
--- linux-2.6.orig/kernel/power/snapshot.c
+++ linux-2.6/kernel/power/snapshot.c
@@ -1066,69 +1066,90 @@ void swsusp_free(void)
 	buffer = NULL;
 }
 
+/* Helper function used for the shrinking of memory. */
+
 /**
- *	swsusp_shrink_memory -  Try to free as much memory as needed
+ * swsusp_shrink_memory -  Make the kernel release as much memory as needed
+ *
+ * To create a hibernation image it is necessary to make a copy of every page
+ * frame in use.  We also need a number of page frames to be free during
+ * hibernation for allocations made while saving the image and for device
+ * drivers, in case they need to allocate memory from their hibernation
+ * callbacks (these two numbers are given by PAGES_FOR_IO and SPARE_PAGES,
+ * respectively, both of which are rough estimates).  To make this happen, we
+ * compute the total number of available page frames and allocate at least
  *
- *	... but do not OOM-kill anyone
+ * ([page frames total] + PAGES_FOR_IO + SPARE_PAGES + [metadata pages]) / 2
  *
- *	Notice: all userland should be stopped before it is called, or
- *	livelock is possible.
+ * of them, which corresponds to the maximum size of a hibernation image.
+ *
+ * If image_size is set below the number following from the above formula,
+ * the preallocation of memory is continued until the total number of page
+ * frames in use is below the requested image size or it is impossible to
+ * allocate more memory, whichever happens first.
  */
-
-#define SHRINK_BITE	10000
-static inline unsigned long __shrink_memory(long tmp)
-{
-	if (tmp > SHRINK_BITE)
-		tmp = SHRINK_BITE;
-	return shrink_all_memory(tmp);
-}
-
 int swsusp_shrink_memory(void)
 {
-	long tmp;
 	struct zone *zone;
-	unsigned long pages = 0;
-	unsigned int i = 0;
-	char *p = "-\\|/";
+	unsigned long saveable, size, max_size, count, pages = 0;
 	struct timeval start, stop;
+	int error = 0;
 
-	printk(KERN_INFO "PM: Shrinking memory...  ");
+	printk(KERN_INFO "PM: Shrinking memory ... ");
 	do_gettimeofday(&start);
-	do {
-		long size, highmem_size;
 
-		highmem_size = count_highmem_pages();
-		size = count_data_pages() + PAGES_FOR_IO + SPARE_PAGES;
-		tmp = size;
-		size += highmem_size;
-		for_each_populated_zone(zone) {
-			tmp += snapshot_additional_pages(zone);
-			if (is_highmem(zone)) {
-				highmem_size -=
-					zone_page_state(zone, NR_FREE_PAGES);
-			} else {
-				tmp -= zone_page_state(zone, NR_FREE_PAGES);
-				tmp += zone->lowmem_reserve[ZONE_NORMAL];
-			}
-		}
+	/* Count the number of saveable data pages. */
+	saveable = count_data_pages() + count_highmem_pages();
+
+	/*
+	 * Compute the total number of page frames we can use (count) and the
+	 * number of pages needed for image metadata (size).
+	 */
+	count = saveable;
+	size = 0;
+	for_each_populated_zone(zone) {
+		size += snapshot_additional_pages(zone);
+		count += zone_page_state(zone, NR_FREE_PAGES);
+		if (!is_highmem(zone))
+			count -= zone->lowmem_reserve[ZONE_NORMAL];
+	}
+
+	/* Compute the maximum number of saveable pages to leave in memory. */
+	max_size = (count - (size + PAGES_FOR_IO + SPARE_PAGES)) / 2;
+	size = DIV_ROUND_UP(image_size, PAGE_SIZE);
+	if (size > max_size)
+		size = max_size;
+	/*
+	 * If the current number of saveable pages is lesser than the maximum,
+	 * we don't need to do anything more.
+	 */
+	if (size > saveable)
+		goto out;
 
-		if (highmem_size < 0)
-			highmem_size = 0;
+	/* Preallocate memory. */
+	for (count -= size; count > 0; count--) {
+		struct page *page;
 
-		tmp += highmem_size;
-		if (tmp > 0) {
-			tmp = __shrink_memory(tmp);
-			if (!tmp)
-				return -ENOMEM;
-			pages += tmp;
-		} else if (size > image_size / PAGE_SIZE) {
-			tmp = __shrink_memory(size - (image_size / PAGE_SIZE));
-			pages += tmp;
-		}
-		printk("\b%c", p[i++%4]);
-	} while (tmp > 0);
+		page = alloc_image_page(GFP_KERNEL | __GFP_NO_OOM_KILL);
+		if (!page)
+			break;
+		pages++;
+	}
+	/* If size < max_size, preallocating enough memory may be impossible. */
+	if (count > 0 && size == max_size)
+		error = -ENOMEM;
+
+	/* Release all of the preallocated page frames. */
+	swsusp_free();
+
+	if (error) {
+		printk(KERN_CONT "\n");
+		return error;
+	}
+
+ out:
 	do_gettimeofday(&stop);
-	printk("\bdone (%lu pages freed)\n", pages);
+	printk(KERN_CONT "done (preallocated %lu free pages)\n", pages);
 	swsusp_show_speed(&start, &stop, pages, "Freed");
 
 	return 0;
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
