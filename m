Return-Path: <linux-kernel-owner+w=401wt.eu-S1759225AbYFKStL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759225AbYFKStL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 14:49:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757939AbYFKSrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 14:47:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47900 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757886AbYFKSrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 14:47:17 -0400
Message-Id: <20080611184338.855835090@redhat.com>
References: <20080611184214.605110868@redhat.com>
User-Agent: quilt/0.46-1
Date: Wed, 11 Jun 2008 14:42:16 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <clameter@sgi.com>
Subject: [PATCH -mm 02/24] vmscan: Use an indexed array for LRU variables
Content-Disposition: inline; filename=vmscan-use-an-indexed-array-for-lru-variables.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <clameter@sgi.com>

Currently we are defining explicit variables for the inactive
and active list. An indexed array can be more generic and avoid
repeating similar code in several places in the reclaim code.

We are saving a few bytes in terms of code size:

Before:

   text    data     bss     dec     hex filename
4097753  573120 4092484 8763357  85b7dd vmlinux

After:

   text    data     bss     dec     hex filename
4097729  573120 4092484 8763333  85b7c5 vmlinux

Having an easy way to add new lru lists may ease future work on
the reclaim code.

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

---

 include/linux/memcontrol.h |   17 +-----
 include/linux/mm_inline.h  |   49 ++++++++++++++----
 include/linux/mmzone.h     |   26 +++++++--
 mm/memcontrol.c            |  115 ++++++++++++++++---------------------------
 mm/page_alloc.c            |    9 +--
 mm/swap.c                  |    2 
 mm/vmscan.c                |  120 +++++++++++++++++++++------------------------
 mm/vmstat.c                |    3 -
 8 files changed, 171 insertions(+), 170 deletions(-)

Index: linux-2.6.26-rc5-mm2/include/linux/mmzone.h
===================================================================
--- linux-2.6.26-rc5-mm2.orig/include/linux/mmzone.h	2008-06-10 10:25:07.000000000 -0400
+++ linux-2.6.26-rc5-mm2/include/linux/mmzone.h	2008-06-10 13:18:26.000000000 -0400
@@ -81,8 +81,9 @@ struct zone_padding {
 enum zone_stat_item {
 	/* First 128 byte cacheline (assuming 64 bit words) */
 	NR_FREE_PAGES,
-	NR_INACTIVE,
-	NR_ACTIVE,
+	NR_LRU_BASE,
+	NR_INACTIVE = NR_LRU_BASE, /* must match order of LRU_[IN]ACTIVE */
+	NR_ACTIVE,	/*  "     "     "   "       "         */
 	NR_ANON_PAGES,	/* Mapped anonymous pages */
 	NR_FILE_MAPPED,	/* pagecache pages mapped into pagetables.
 			   only modified from process context */
@@ -107,6 +108,19 @@ enum zone_stat_item {
 #endif
 	NR_VM_ZONE_STAT_ITEMS };
 
+enum lru_list {
+	LRU_BASE,
+	LRU_INACTIVE=LRU_BASE,	/* must match order of NR_[IN]ACTIVE */
+	LRU_ACTIVE,		/*  "     "     "   "       "        */
+	NR_LRU_LISTS };
+
+#define for_each_lru(l) for (l = 0; l < NR_LRU_LISTS; l++)
+
+static inline int is_active_lru(enum lru_list l)
+{
+	return (l == LRU_ACTIVE);
+}
+
 struct per_cpu_pages {
 	int count;		/* number of pages in the list */
 	int high;		/* high watermark, emptying needed */
@@ -251,10 +265,10 @@ struct zone {
 
 	/* Fields commonly accessed by the page reclaim scanner */
 	spinlock_t		lru_lock;	
-	struct list_head	active_list;
-	struct list_head	inactive_list;
-	unsigned long		nr_scan_active;
-	unsigned long		nr_scan_inactive;
+	struct {
+		struct list_head list;
+		unsigned long nr_scan;
+	} lru[NR_LRU_LISTS];
 	unsigned long		pages_scanned;	   /* since last reclaim */
 	unsigned long		flags;		   /* zone flags, see below */
 
Index: linux-2.6.26-rc5-mm2/include/linux/mm_inline.h
===================================================================
--- linux-2.6.26-rc5-mm2.orig/include/linux/mm_inline.h	2007-07-08 19:32:17.000000000 -0400
+++ linux-2.6.26-rc5-mm2/include/linux/mm_inline.h	2008-06-10 13:18:26.000000000 -0400
@@ -1,40 +1,67 @@
 static inline void
+add_page_to_lru_list(struct zone *zone, struct page *page, enum lru_list l)
+{
+	list_add(&page->lru, &zone->lru[l].list);
+	__inc_zone_state(zone, NR_LRU_BASE + l);
+}
+
+static inline void
+del_page_from_lru_list(struct zone *zone, struct page *page, enum lru_list l)
+{
+	list_del(&page->lru);
+	__dec_zone_state(zone, NR_LRU_BASE + l);
+}
+
+static inline void
 add_page_to_active_list(struct zone *zone, struct page *page)
 {
-	list_add(&page->lru, &zone->active_list);
-	__inc_zone_state(zone, NR_ACTIVE);
+	add_page_to_lru_list(zone, page, LRU_ACTIVE);
 }
 
 static inline void
 add_page_to_inactive_list(struct zone *zone, struct page *page)
 {
-	list_add(&page->lru, &zone->inactive_list);
-	__inc_zone_state(zone, NR_INACTIVE);
+	add_page_to_lru_list(zone, page, LRU_INACTIVE);
 }
 
 static inline void
 del_page_from_active_list(struct zone *zone, struct page *page)
 {
-	list_del(&page->lru);
-	__dec_zone_state(zone, NR_ACTIVE);
+	del_page_from_lru_list(zone, page, LRU_ACTIVE);
 }
 
 static inline void
 del_page_from_inactive_list(struct zone *zone, struct page *page)
 {
-	list_del(&page->lru);
-	__dec_zone_state(zone, NR_INACTIVE);
+	del_page_from_lru_list(zone, page, LRU_INACTIVE);
 }
 
 static inline void
 del_page_from_lru(struct zone *zone, struct page *page)
 {
+	enum lru_list l = LRU_INACTIVE;
+
 	list_del(&page->lru);
 	if (PageActive(page)) {
 		__ClearPageActive(page);
-		__dec_zone_state(zone, NR_ACTIVE);
-	} else {
-		__dec_zone_state(zone, NR_INACTIVE);
+		l = LRU_ACTIVE;
 	}
+	__dec_zone_state(zone, NR_LRU_BASE + l);
 }
 
+/**
+ * page_lru - which LRU list should a page be on?
+ * @page: the page to test
+ *
+ * Returns the LRU list a page should be on, as an index
+ * into the array of LRU lists.
+ */
+static inline enum lru_list page_lru(struct page *page)
+{
+	enum lru_list lru = LRU_BASE;
+
+	if (PageActive(page))
+		lru += LRU_ACTIVE;
+
+	return lru;
+}
Index: linux-2.6.26-rc5-mm2/mm/page_alloc.c
===================================================================
--- linux-2.6.26-rc5-mm2.orig/mm/page_alloc.c	2008-06-10 10:46:24.000000000 -0400
+++ linux-2.6.26-rc5-mm2/mm/page_alloc.c	2008-06-10 13:18:26.000000000 -0400
@@ -3367,6 +3367,7 @@ static void __paginginit free_area_init_
 	for (j = 0; j < MAX_NR_ZONES; j++) {
 		struct zone *zone = pgdat->node_zones + j;
 		unsigned long size, realsize, memmap_pages;
+		enum lru_list l;
 
 		size = zone_spanned_pages_in_node(nid, j, zones_size);
 		realsize = size - zone_absent_pages_in_node(nid, j,
@@ -3418,10 +3419,10 @@ static void __paginginit free_area_init_
 		zone->prev_priority = DEF_PRIORITY;
 
 		zone_pcp_init(zone);
-		INIT_LIST_HEAD(&zone->active_list);
-		INIT_LIST_HEAD(&zone->inactive_list);
-		zone->nr_scan_active = 0;
-		zone->nr_scan_inactive = 0;
+		for_each_lru(l) {
+			INIT_LIST_HEAD(&zone->lru[l].list);
+			zone->lru[l].nr_scan = 0;
+		}
 		zap_zone_vm_stats(zone);
 		zone->flags = 0;
 		if (!size)
Index: linux-2.6.26-rc5-mm2/mm/swap.c
===================================================================
--- linux-2.6.26-rc5-mm2.orig/mm/swap.c	2008-06-10 10:25:07.000000000 -0400
+++ linux-2.6.26-rc5-mm2/mm/swap.c	2008-06-10 13:18:26.000000000 -0400
@@ -117,7 +117,7 @@ static void pagevec_move_tail(struct pag
 			spin_lock(&zone->lru_lock);
 		}
 		if (PageLRU(page) && !PageActive(page)) {
-			list_move_tail(&page->lru, &zone->inactive_list);
+			list_move_tail(&page->lru, &zone->lru[LRU_INACTIVE].list);
 			pgmoved++;
 		}
 	}
Index: linux-2.6.26-rc5-mm2/mm/vmscan.c
===================================================================
--- linux-2.6.26-rc5-mm2.orig/mm/vmscan.c	2008-06-10 12:54:22.000000000 -0400
+++ linux-2.6.26-rc5-mm2/mm/vmscan.c	2008-06-10 13:18:26.000000000 -0400
@@ -785,10 +785,10 @@ static unsigned long isolate_pages_globa
 					int active)
 {
 	if (active)
-		return isolate_lru_pages(nr, &z->active_list, dst,
+		return isolate_lru_pages(nr, &z->lru[LRU_ACTIVE].list, dst,
 						scanned, order, mode);
 	else
-		return isolate_lru_pages(nr, &z->inactive_list, dst,
+		return isolate_lru_pages(nr, &z->lru[LRU_INACTIVE].list, dst,
 						scanned, order, mode);
 }
 
@@ -939,10 +939,7 @@ static unsigned long shrink_inactive_lis
 			VM_BUG_ON(PageLRU(page));
 			SetPageLRU(page);
 			list_del(&page->lru);
-			if (PageActive(page))
-				add_page_to_active_list(zone, page);
-			else
-				add_page_to_inactive_list(zone, page);
+			add_page_to_lru_list(zone, page, page_lru(page));
 			if (!pagevec_add(&pvec, page)) {
 				spin_unlock_irq(&zone->lru_lock);
 				__pagevec_release(&pvec);
@@ -1110,8 +1107,8 @@ static void shrink_active_list(unsigned 
 	int pgdeactivate = 0;
 	unsigned long pgscanned;
 	LIST_HEAD(l_hold);	/* The pages which were snipped off */
-	LIST_HEAD(l_inactive);	/* Pages to go onto the inactive_list */
-	LIST_HEAD(l_active);	/* Pages to go onto the active_list */
+	LIST_HEAD(l_active);
+	LIST_HEAD(l_inactive);
 	struct page *page;
 	struct pagevec pvec;
 	int reclaim_mapped = 0;
@@ -1163,7 +1160,7 @@ static void shrink_active_list(unsigned 
 		VM_BUG_ON(!PageActive(page));
 		ClearPageActive(page);
 
-		list_move(&page->lru, &zone->inactive_list);
+		list_move(&page->lru, &zone->lru[LRU_INACTIVE].list);
 		mem_cgroup_move_lists(page, false);
 		pgmoved++;
 		if (!pagevec_add(&pvec, page)) {
@@ -1193,7 +1190,7 @@ static void shrink_active_list(unsigned 
 		SetPageLRU(page);
 		VM_BUG_ON(!PageActive(page));
 
-		list_move(&page->lru, &zone->active_list);
+		list_move(&page->lru, &zone->lru[LRU_ACTIVE].list);
 		mem_cgroup_move_lists(page, true);
 		pgmoved++;
 		if (!pagevec_add(&pvec, page)) {
@@ -1213,65 +1210,64 @@ static void shrink_active_list(unsigned 
 	pagevec_release(&pvec);
 }
 
+static unsigned long shrink_list(enum lru_list l, unsigned long nr_to_scan,
+	struct zone *zone, struct scan_control *sc, int priority)
+{
+	if (l == LRU_ACTIVE) {
+		shrink_active_list(nr_to_scan, zone, sc, priority);
+		return 0;
+	}
+	return shrink_inactive_list(nr_to_scan, zone, sc);
+}
+
 /*
  * This is a basic per-zone page freer.  Used by both kswapd and direct reclaim.
  */
 static unsigned long shrink_zone(int priority, struct zone *zone,
 				struct scan_control *sc)
 {
-	unsigned long nr_active;
-	unsigned long nr_inactive;
+	unsigned long nr[NR_LRU_LISTS];
 	unsigned long nr_to_scan;
 	unsigned long nr_reclaimed = 0;
+	enum lru_list l;
 
 	if (scan_global_lru(sc)) {
 		/*
 		 * Add one to nr_to_scan just to make sure that the kernel
 		 * will slowly sift through the active list.
 		 */
-		zone->nr_scan_active +=
-			(zone_page_state(zone, NR_ACTIVE) >> priority) + 1;
-		nr_active = zone->nr_scan_active;
-		zone->nr_scan_inactive +=
-			(zone_page_state(zone, NR_INACTIVE) >> priority) + 1;
-		nr_inactive = zone->nr_scan_inactive;
-		if (nr_inactive >= sc->swap_cluster_max)
-			zone->nr_scan_inactive = 0;
-		else
-			nr_inactive = 0;
-
-		if (nr_active >= sc->swap_cluster_max)
-			zone->nr_scan_active = 0;
-		else
-			nr_active = 0;
+		for_each_lru(l) {
+			zone->lru[l].nr_scan += (zone_page_state(zone,
+					NR_LRU_BASE + l)  >> priority) + 1;
+			nr[l] = zone->lru[l].nr_scan;
+			if (nr[l] >= sc->swap_cluster_max)
+				zone->lru[l].nr_scan = 0;
+			else
+				nr[l] = 0;
+		}
 	} else {
 		/*
 		 * This reclaim occurs not because zone memory shortage but
 		 * because memory controller hits its limit.
 		 * Then, don't modify zone reclaim related data.
 		 */
-		nr_active = mem_cgroup_calc_reclaim_active(sc->mem_cgroup,
-					zone, priority);
+		nr[LRU_ACTIVE] = mem_cgroup_calc_reclaim(sc->mem_cgroup,
+					zone, priority, LRU_ACTIVE);
 
-		nr_inactive = mem_cgroup_calc_reclaim_inactive(sc->mem_cgroup,
-					zone, priority);
+		nr[LRU_INACTIVE] = mem_cgroup_calc_reclaim(sc->mem_cgroup,
+					zone, priority, LRU_INACTIVE);
 	}
 
-
-	while (nr_active || nr_inactive) {
-		if (nr_active) {
-			nr_to_scan = min(nr_active,
+	while (nr[LRU_ACTIVE] || nr[LRU_INACTIVE]) {
+		for_each_lru(l) {
+			if (nr[l]) {
+				nr_to_scan = min(nr[l],
 					(unsigned long)sc->swap_cluster_max);
-			nr_active -= nr_to_scan;
-			shrink_active_list(nr_to_scan, zone, sc, priority);
-		}
+				nr[l] -= nr_to_scan;
 
-		if (nr_inactive) {
-			nr_to_scan = min(nr_inactive,
-					(unsigned long)sc->swap_cluster_max);
-			nr_inactive -= nr_to_scan;
-			nr_reclaimed += shrink_inactive_list(nr_to_scan, zone,
-								sc);
+				nr_reclaimed += shrink_list(l, nr_to_scan,
+							zone, sc, priority);
+			}
 		}
 	}
 
@@ -1788,6 +1784,7 @@ static unsigned long shrink_all_zones(un
 {
 	struct zone *zone;
 	unsigned long nr_to_scan, ret = 0;
+	enum lru_list l;
 
 	for_each_zone(zone) {
 
@@ -1797,28 +1794,25 @@ static unsigned long shrink_all_zones(un
 		if (zone_is_all_unreclaimable(zone) && prio != DEF_PRIORITY)
 			continue;
 
-		/* For pass = 0 we don't shrink the active list */
-		if (pass > 0) {
-			zone->nr_scan_active +=
-				(zone_page_state(zone, NR_ACTIVE) >> prio) + 1;
-			if (zone->nr_scan_active >= nr_pages || pass > 3) {
-				zone->nr_scan_active = 0;
+		for_each_lru(l) {
+			/* For pass = 0 we don't shrink the active list */
+			if (pass == 0 && l == LRU_ACTIVE)
+				continue;
+
+			zone->lru[l].nr_scan +=
+				(zone_page_state(zone, NR_LRU_BASE + l)
+								>> prio) + 1;
+			if (zone->lru[l].nr_scan >= nr_pages || pass > 3) {
+				zone->lru[l].nr_scan = 0;
 				nr_to_scan = min(nr_pages,
-					zone_page_state(zone, NR_ACTIVE));
-				shrink_active_list(nr_to_scan, zone, sc, prio);
+					zone_page_state(zone,
+							NR_LRU_BASE + l));
+				ret += shrink_list(l, nr_to_scan, zone,
+								sc, prio);
+				if (ret >= nr_pages)
+					return ret;
 			}
 		}
-
-		zone->nr_scan_inactive +=
-			(zone_page_state(zone, NR_INACTIVE) >> prio) + 1;
-		if (zone->nr_scan_inactive >= nr_pages || pass > 3) {
-			zone->nr_scan_inactive = 0;
-			nr_to_scan = min(nr_pages,
-				zone_page_state(zone, NR_INACTIVE));
-			ret += shrink_inactive_list(nr_to_scan, zone, sc);
-			if (ret >= nr_pages)
-				return ret;
-		}
 	}
 
 	return ret;
Index: linux-2.6.26-rc5-mm2/mm/vmstat.c
===================================================================
--- linux-2.6.26-rc5-mm2.orig/mm/vmstat.c	2008-06-10 10:46:23.000000000 -0400
+++ linux-2.6.26-rc5-mm2/mm/vmstat.c	2008-06-10 13:18:26.000000000 -0400
@@ -679,7 +679,8 @@ static void zoneinfo_show_print(struct s
 		   zone->pages_low,
 		   zone->pages_high,
 		   zone->pages_scanned,
-		   zone->nr_scan_active, zone->nr_scan_inactive,
+		   zone->lru[LRU_ACTIVE].nr_scan,
+		   zone->lru[LRU_INACTIVE].nr_scan,
 		   zone->spanned_pages,
 		   zone->present_pages);
 
Index: linux-2.6.26-rc5-mm2/include/linux/memcontrol.h
===================================================================
--- linux-2.6.26-rc5-mm2.orig/include/linux/memcontrol.h	2008-06-10 10:46:29.000000000 -0400
+++ linux-2.6.26-rc5-mm2/include/linux/memcontrol.h	2008-06-10 13:18:26.000000000 -0400
@@ -69,10 +69,8 @@ extern void mem_cgroup_note_reclaim_prio
 extern void mem_cgroup_record_reclaim_priority(struct mem_cgroup *mem,
 							int priority);
 
-extern long mem_cgroup_calc_reclaim_active(struct mem_cgroup *mem,
-				struct zone *zone, int priority);
-extern long mem_cgroup_calc_reclaim_inactive(struct mem_cgroup *mem,
-				struct zone *zone, int priority);
+extern long mem_cgroup_calc_reclaim(struct mem_cgroup *mem, struct zone *zone,
+					int priority, enum lru_list lru);
 
 #else /* CONFIG_CGROUP_MEM_RES_CTLR */
 static inline void page_reset_bad_cgroup(struct page *page)
@@ -159,14 +157,9 @@ static inline void mem_cgroup_record_rec
 {
 }
 
-static inline long mem_cgroup_calc_reclaim_active(struct mem_cgroup *mem,
-					struct zone *zone, int priority)
-{
-	return 0;
-}
-
-static inline long mem_cgroup_calc_reclaim_inactive(struct mem_cgroup *mem,
-					struct zone *zone, int priority)
+static inline long mem_cgroup_calc_reclaim(struct mem_cgroup *mem,
+					struct zone *zone, int priority,
+					enum lru_list lru)
 {
 	return 0;
 }
Index: linux-2.6.26-rc5-mm2/mm/memcontrol.c
===================================================================
--- linux-2.6.26-rc5-mm2.orig/mm/memcontrol.c	2008-06-10 10:46:29.000000000 -0400
+++ linux-2.6.26-rc5-mm2/mm/memcontrol.c	2008-06-10 13:18:26.000000000 -0400
@@ -32,6 +32,7 @@
 #include <linux/fs.h>
 #include <linux/seq_file.h>
 #include <linux/vmalloc.h>
+#include <linux/mm_inline.h>
 
 #include <asm/uaccess.h>
 
@@ -85,22 +86,13 @@ static s64 mem_cgroup_read_stat(struct m
 /*
  * per-zone information in memory controller.
  */
-
-enum mem_cgroup_zstat_index {
-	MEM_CGROUP_ZSTAT_ACTIVE,
-	MEM_CGROUP_ZSTAT_INACTIVE,
-
-	NR_MEM_CGROUP_ZSTAT,
-};
-
 struct mem_cgroup_per_zone {
 	/*
 	 * spin_lock to protect the per cgroup LRU
 	 */
 	spinlock_t		lru_lock;
-	struct list_head	active_list;
-	struct list_head	inactive_list;
-	unsigned long count[NR_MEM_CGROUP_ZSTAT];
+	struct list_head	lists[NR_LRU_LISTS];
+	unsigned long		count[NR_LRU_LISTS];
 };
 /* Macro for accessing counter */
 #define MEM_CGROUP_ZSTAT(mz, idx)	((mz)->count[(idx)])
@@ -227,7 +219,7 @@ page_cgroup_zoneinfo(struct page_cgroup 
 }
 
 static unsigned long mem_cgroup_get_all_zonestat(struct mem_cgroup *mem,
-					enum mem_cgroup_zstat_index idx)
+					enum lru_list idx)
 {
 	int nid, zid;
 	struct mem_cgroup_per_zone *mz;
@@ -289,11 +281,9 @@ static void __mem_cgroup_remove_list(str
 			struct page_cgroup *pc)
 {
 	int from = pc->flags & PAGE_CGROUP_FLAG_ACTIVE;
+	int lru = !!from;
 
-	if (from)
-		MEM_CGROUP_ZSTAT(mz, MEM_CGROUP_ZSTAT_ACTIVE) -= 1;
-	else
-		MEM_CGROUP_ZSTAT(mz, MEM_CGROUP_ZSTAT_INACTIVE) -= 1;
+	MEM_CGROUP_ZSTAT(mz, lru) -= 1;
 
 	mem_cgroup_charge_statistics(pc->mem_cgroup, pc->flags, false);
 	list_del(&pc->lru);
@@ -302,37 +292,35 @@ static void __mem_cgroup_remove_list(str
 static void __mem_cgroup_add_list(struct mem_cgroup_per_zone *mz,
 				struct page_cgroup *pc)
 {
-	int to = pc->flags & PAGE_CGROUP_FLAG_ACTIVE;
+	int lru = LRU_INACTIVE;
+
+	if (pc->flags & PAGE_CGROUP_FLAG_ACTIVE)
+		lru += LRU_ACTIVE;
+
+	MEM_CGROUP_ZSTAT(mz, lru) += 1;
+	list_add(&pc->lru, &mz->lists[lru]);
 
-	if (!to) {
-		MEM_CGROUP_ZSTAT(mz, MEM_CGROUP_ZSTAT_INACTIVE) += 1;
-		list_add(&pc->lru, &mz->inactive_list);
-	} else {
-		MEM_CGROUP_ZSTAT(mz, MEM_CGROUP_ZSTAT_ACTIVE) += 1;
-		list_add(&pc->lru, &mz->active_list);
-	}
 	mem_cgroup_charge_statistics(pc->mem_cgroup, pc->flags, true);
 }
 
 static void __mem_cgroup_move_lists(struct page_cgroup *pc, bool active)
 {
-	int from = pc->flags & PAGE_CGROUP_FLAG_ACTIVE;
 	struct mem_cgroup_per_zone *mz = page_cgroup_zoneinfo(pc);
+	int lru = LRU_INACTIVE;
 
-	if (from)
-		MEM_CGROUP_ZSTAT(mz, MEM_CGROUP_ZSTAT_ACTIVE) -= 1;
-	else
-		MEM_CGROUP_ZSTAT(mz, MEM_CGROUP_ZSTAT_INACTIVE) -= 1;
+	if (pc->flags & PAGE_CGROUP_FLAG_ACTIVE)
+		lru += LRU_ACTIVE;
 
-	if (active) {
-		MEM_CGROUP_ZSTAT(mz, MEM_CGROUP_ZSTAT_ACTIVE) += 1;
+	MEM_CGROUP_ZSTAT(mz, lru) -= 1;
+
+	if (active)
 		pc->flags |= PAGE_CGROUP_FLAG_ACTIVE;
-		list_move(&pc->lru, &mz->active_list);
-	} else {
-		MEM_CGROUP_ZSTAT(mz, MEM_CGROUP_ZSTAT_INACTIVE) += 1;
+	else
 		pc->flags &= ~PAGE_CGROUP_FLAG_ACTIVE;
-		list_move(&pc->lru, &mz->inactive_list);
-	}
+
+	lru = !!active;
+	MEM_CGROUP_ZSTAT(mz, lru) += 1;
+	list_move(&pc->lru, &mz->lists[lru]);
 }
 
 int task_in_mem_cgroup(struct task_struct *task, const struct mem_cgroup *mem)
@@ -401,8 +389,8 @@ long mem_cgroup_reclaim_imbalance(struct
 {
 	unsigned long active, inactive;
 	/* active and inactive are the number of pages. 'long' is ok.*/
-	active = mem_cgroup_get_all_zonestat(mem, MEM_CGROUP_ZSTAT_ACTIVE);
-	inactive = mem_cgroup_get_all_zonestat(mem, MEM_CGROUP_ZSTAT_INACTIVE);
+	active = mem_cgroup_get_all_zonestat(mem, LRU_ACTIVE);
+	inactive = mem_cgroup_get_all_zonestat(mem, LRU_INACTIVE);
 	return (long) (active / (inactive + 1));
 }
 
@@ -433,28 +421,17 @@ void mem_cgroup_record_reclaim_priority(
  * (see include/linux/mmzone.h)
  */
 
-long mem_cgroup_calc_reclaim_active(struct mem_cgroup *mem,
-				   struct zone *zone, int priority)
+long mem_cgroup_calc_reclaim(struct mem_cgroup *mem, struct zone *zone,
+					int priority, enum lru_list lru)
 {
-	long nr_active;
+	long nr_pages;
 	int nid = zone->zone_pgdat->node_id;
 	int zid = zone_idx(zone);
 	struct mem_cgroup_per_zone *mz = mem_cgroup_zoneinfo(mem, nid, zid);
 
-	nr_active = MEM_CGROUP_ZSTAT(mz, MEM_CGROUP_ZSTAT_ACTIVE);
-	return (nr_active >> priority);
-}
-
-long mem_cgroup_calc_reclaim_inactive(struct mem_cgroup *mem,
-					struct zone *zone, int priority)
-{
-	long nr_inactive;
-	int nid = zone->zone_pgdat->node_id;
-	int zid = zone_idx(zone);
-	struct mem_cgroup_per_zone *mz = mem_cgroup_zoneinfo(mem, nid, zid);
+	nr_pages = MEM_CGROUP_ZSTAT(mz, lru);
 
-	nr_inactive = MEM_CGROUP_ZSTAT(mz, MEM_CGROUP_ZSTAT_INACTIVE);
-	return (nr_inactive >> priority);
+	return (nr_pages >> priority);
 }
 
 unsigned long mem_cgroup_isolate_pages(unsigned long nr_to_scan,
@@ -473,14 +450,11 @@ unsigned long mem_cgroup_isolate_pages(u
 	int nid = z->zone_pgdat->node_id;
 	int zid = zone_idx(z);
 	struct mem_cgroup_per_zone *mz;
+	int lru = !!active;
 
 	BUG_ON(!mem_cont);
 	mz = mem_cgroup_zoneinfo(mem_cont, nid, zid);
-	if (active)
-		src = &mz->active_list;
-	else
-		src = &mz->inactive_list;
-
+	src = &mz->lists[lru];
 
 	spin_lock(&mz->lru_lock);
 	scan = 0;
@@ -798,7 +772,7 @@ int mem_cgroup_shrink_usage(struct mm_st
 #define FORCE_UNCHARGE_BATCH	(128)
 static void mem_cgroup_force_empty_list(struct mem_cgroup *mem,
 			    struct mem_cgroup_per_zone *mz,
-			    int active)
+			    enum lru_list lru)
 {
 	struct page_cgroup *pc;
 	struct page *page;
@@ -806,10 +780,7 @@ static void mem_cgroup_force_empty_list(
 	unsigned long flags;
 	struct list_head *list;
 
-	if (active)
-		list = &mz->active_list;
-	else
-		list = &mz->inactive_list;
+	list = &mz->lists[lru];
 
 	spin_lock_irqsave(&mz->lru_lock, flags);
 	while (!list_empty(list)) {
@@ -857,11 +828,10 @@ static int mem_cgroup_force_empty(struct
 		for_each_node_state(node, N_POSSIBLE)
 			for (zid = 0; zid < MAX_NR_ZONES; zid++) {
 				struct mem_cgroup_per_zone *mz;
+				enum lru_list l;
 				mz = mem_cgroup_zoneinfo(mem, node, zid);
-				/* drop all page_cgroup in active_list */
-				mem_cgroup_force_empty_list(mem, mz, 1);
-				/* drop all page_cgroup in inactive_list */
-				mem_cgroup_force_empty_list(mem, mz, 0);
+				for_each_lru(l)
+					mem_cgroup_force_empty_list(mem, mz, l);
 			}
 	}
 	ret = 0;
@@ -948,9 +918,9 @@ static int mem_control_stat_show(struct 
 		unsigned long active, inactive;
 
 		inactive = mem_cgroup_get_all_zonestat(mem_cont,
-						MEM_CGROUP_ZSTAT_INACTIVE);
+						LRU_INACTIVE);
 		active = mem_cgroup_get_all_zonestat(mem_cont,
-						MEM_CGROUP_ZSTAT_ACTIVE);
+						LRU_ACTIVE);
 		cb->fill(cb, "active", (active) * PAGE_SIZE);
 		cb->fill(cb, "inactive", (inactive) * PAGE_SIZE);
 	}
@@ -995,6 +965,7 @@ static int alloc_mem_cgroup_per_zone_inf
 {
 	struct mem_cgroup_per_node *pn;
 	struct mem_cgroup_per_zone *mz;
+	enum lru_list l;
 	int zone, tmp = node;
 	/*
 	 * This routine is called against possible nodes.
@@ -1015,9 +986,9 @@ static int alloc_mem_cgroup_per_zone_inf
 
 	for (zone = 0; zone < MAX_NR_ZONES; zone++) {
 		mz = &pn->zoneinfo[zone];
-		INIT_LIST_HEAD(&mz->active_list);
-		INIT_LIST_HEAD(&mz->inactive_list);
 		spin_lock_init(&mz->lru_lock);
+		for_each_lru(l)
+			INIT_LIST_HEAD(&mz->lists[l]);
 	}
 	return 0;
 }

-- 
All Rights Reversed

