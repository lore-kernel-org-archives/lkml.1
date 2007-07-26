Return-Path: <linux-kernel-owner+w=401wt.eu-S1759228AbXGZCtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759228AbXGZCtf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 22:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755216AbXGZCt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 22:49:26 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:48998 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756073AbXGZCtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 22:49:24 -0400
Date: Thu, 26 Jul 2007 11:50:20 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>,
       "mel@csn.ul.ie" <mel@csn.ul.ie>,
       "kamezawa.hiroyu@jp.fujitsu.com" <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH] config_zone_movable [1/2] clean up zone config by
 renumbering
Message-Id: <20070726115020.1ff4513b.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I refreshed config_zone_movable patch set against 2.6.23-rc1.
Reflected comments on previous version.
Tested on ia64/NUMA system and my small i386 desktop.

Andrew, I like this patch but know that there are many types of memory layout. 
Could you test this set in -mm ?
I'll refresh this against rc1-mm1 if necessary.

-Kame

==
zone_ifdef_cleanup_by_renumbering.patch

Now, this patch defines zone_idx for not-configured-zones.
like 
	enum_zone_type {
		(ZONE_DMA configured)
		(ZONE_DMA32 configured)
		ZONE_NORMAL
		(ZONE_HIGHMEM configured)
		ZONE_MOVABLE
		MAX_NR_ZONES,
		(ZONE_DMA not-configured)
		(ZONE_DMA32 not-configured)
		(ZONE_HIGHMEM not-configured)
	};

By this, we can determine zone is configured or not by

	zone_idx < MAX_NR_ZONES.

We can avoid #ifdef for CONFIG_ZONE_xxx to some extent.

This patch also replaces CONFIG_ZONE_DMA_FLAG by is_configured_zone(ZONE_DMA).

Changelog: v1 -> v2
	- rebased to 2.6.23-rc1
	- Removed MAX_POSSIBLE_ZONES
	- Added comments

Signed-Off-By: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---
 include/linux/gfp.h    |   16 ++++-----
 include/linux/mmzone.h |   79 ++++++++++++++++++++++++++++++-------------------
 include/linux/vmstat.h |   24 +++++++-------
 mm/Kconfig             |    5 ---
 mm/page-writeback.c    |    7 +---
 mm/page_alloc.c        |   33 ++++++++------------
 mm/slab.c              |    4 +-
 7 files changed, 87 insertions(+), 81 deletions(-)

Index: linux-2.6.23-rc1/include/linux/mmzone.h
===================================================================
--- linux-2.6.23-rc1.orig/include/linux/mmzone.h
+++ linux-2.6.23-rc1/include/linux/mmzone.h
@@ -155,10 +155,36 @@ enum zone_type {
 	ZONE_HIGHMEM,
 #endif
 	ZONE_MOVABLE,
-	MAX_NR_ZONES
+	MAX_NR_ZONES,
+#ifndef CONFIG_ZONE_DMA
+	ZONE_DMA,
+#endif
+#ifndef CONFIG_ZONE_DMA32
+	ZONE_DMA32,
+#endif
+#ifndef CONFIG_HIGHMEM
+	ZONE_HIGHMEM,
+#endif
 };
 
 /*
+ * Test zone type is configured or not.
+ * You can use this functio for avoiding #ifdef.
+ *
+ * #ifdef OCNFIG_ZONE_DMA
+ *	do_something...
+ * #endif
+ * can be written as
+ * if (is_configured_zone(ZONE_DMA)) {
+ *	do_something..
+ * }
+ */
+static inline int is_configured_zone(enum zone_type zoneidx)
+{
+	return (zoneidx < MAX_NR_ZONES);
+}
+
+/*
  * When a memory allocation must conform to specific limitations (such
  * as being suitable for DMA) the caller will pass in hints to the
  * allocator in the gfp_mask, in the zone modifier bits.  These bits
@@ -511,28 +537,35 @@ static inline int populated_zone(struct 
 
 extern int movable_zone;
 
-static inline int zone_movable_is_highmem(void)
+/*
+ * Check zone is configured && specified "idx" is equal to target zone type.
+ * Zone's index is calucalted by above zone_idx().
+ */
+static inline int zone_idx_is(enum zone_type idx, enum zone_type target)
 {
-#if defined(CONFIG_HIGHMEM) && defined(CONFIG_ARCH_POPULATES_NODE_MAP)
-	return movable_zone == ZONE_HIGHMEM;
-#else
+	if (is_configured_zone(target) && (idx == target))
+		return 1;
 	return 0;
+}
+
+static inline int zone_movable_is_highmem(void)
+{
+#if CONFIG_ARCH_POPULATES_NODE_MAP
+	if (is_configured_zone(ZONE_HIGHMEM))
+		return movable_zone == ZONE_HIGHMEM;
 #endif
+	return 0;
 }
 
 static inline int is_highmem_idx(enum zone_type idx)
 {
-#ifdef CONFIG_HIGHMEM
-	return (idx == ZONE_HIGHMEM ||
-		(idx == ZONE_MOVABLE && zone_movable_is_highmem()));
-#else
-	return 0;
-#endif
+	return (zone_idx_is(idx, ZONE_HIGHMEM) ||
+	       (zone_idx_is(idx, ZONE_MOVABLE) && zone_movable_is_highmem()));
 }
 
 static inline int is_normal_idx(enum zone_type idx)
 {
-	return (idx == ZONE_NORMAL);
+	return zone_idx_is(idx, ZONE_NORMAL);
 }
 
 /**
@@ -543,36 +576,22 @@ static inline int is_normal_idx(enum zon
  */
 static inline int is_highmem(struct zone *zone)
 {
-#ifdef CONFIG_HIGHMEM
-	int zone_idx = zone - zone->zone_pgdat->node_zones;
-	return zone_idx == ZONE_HIGHMEM ||
-		(zone_idx == ZONE_MOVABLE && zone_movable_is_highmem());
-#else
-	return 0;
-#endif
+	return is_highmem_idx(zone_idx(zone));
 }
 
 static inline int is_normal(struct zone *zone)
 {
-	return zone == zone->zone_pgdat->node_zones + ZONE_NORMAL;
+	return zone_idx_is(zone_idx(zone), ZONE_NORMAL);
 }
 
 static inline int is_dma32(struct zone *zone)
 {
-#ifdef CONFIG_ZONE_DMA32
-	return zone == zone->zone_pgdat->node_zones + ZONE_DMA32;
-#else
-	return 0;
-#endif
+	return zone_idx_is(zone_idx(zone), ZONE_DMA32);
 }
 
 static inline int is_dma(struct zone *zone)
 {
-#ifdef CONFIG_ZONE_DMA
-	return zone == zone->zone_pgdat->node_zones + ZONE_DMA;
-#else
-	return 0;
-#endif
+	return zone_idx_is(zone_idx(zone), ZONE_DMA);
 }
 
 /* These two functions are used to setup the per zone pages min values */
Index: linux-2.6.23-rc1/include/linux/vmstat.h
===================================================================
--- linux-2.6.23-rc1.orig/include/linux/vmstat.h
+++ linux-2.6.23-rc1/include/linux/vmstat.h
@@ -159,19 +159,19 @@ static inline unsigned long node_page_st
 				 enum zone_stat_item item)
 {
 	struct zone *zones = NODE_DATA(node)->node_zones;
+	unsigned long val = zone_page_state(&zones[ZONE_NORMAL],item);
 
-	return
-#ifdef CONFIG_ZONE_DMA
-		zone_page_state(&zones[ZONE_DMA], item) +
-#endif
-#ifdef CONFIG_ZONE_DMA32
-		zone_page_state(&zones[ZONE_DMA32], item) +
-#endif
-#ifdef CONFIG_HIGHMEM
-		zone_page_state(&zones[ZONE_HIGHMEM], item) +
-#endif
-		zone_page_state(&zones[ZONE_NORMAL], item) +
-		zone_page_state(&zones[ZONE_MOVABLE], item);
+	if (is_configured_zone(ZONE_DMA))
+		val += zone_page_state(&zones[ZONE_DMA], item);
+
+	if (is_configured_zone(ZONE_DMA32))
+		val += zone_page_state(&zones[ZONE_DMA32], item);
+
+	if (is_configured_zone(ZONE_HIGHMEM))
+		val += zone_page_state(&zones[ZONE_HIGHMEM], item);
+
+	val += zone_page_state(&zones[ZONE_MOVABLE], item);
+	return val;
 }
 
 extern void zone_statistics(struct zonelist *, struct zone *);
Index: linux-2.6.23-rc1/include/linux/gfp.h
===================================================================
--- linux-2.6.23-rc1.orig/include/linux/gfp.h
+++ linux-2.6.23-rc1/include/linux/gfp.h
@@ -98,21 +98,19 @@ struct vm_area_struct;
 
 static inline enum zone_type gfp_zone(gfp_t flags)
 {
-#ifdef CONFIG_ZONE_DMA
-	if (flags & __GFP_DMA)
+	if (is_configured_zone(ZONE_DMA) && (flags & __GFP_DMA))
 		return ZONE_DMA;
-#endif
-#ifdef CONFIG_ZONE_DMA32
-	if (flags & __GFP_DMA32)
+
+	if (is_configured_zone(ZONE_DMA32) && (flags & __GFP_DMA32))
 		return ZONE_DMA32;
-#endif
+
 	if ((flags & (__GFP_HIGHMEM | __GFP_MOVABLE)) ==
 			(__GFP_HIGHMEM | __GFP_MOVABLE))
 		return ZONE_MOVABLE;
-#ifdef CONFIG_HIGHMEM
-	if (flags & __GFP_HIGHMEM)
+
+	if (is_configured_zone(ZONE_HIGHMEM) && (flags & __GFP_HIGHMEM))
 		return ZONE_HIGHMEM;
-#endif
+
 	return ZONE_NORMAL;
 }
 
Index: linux-2.6.23-rc1/mm/Kconfig
===================================================================
--- linux-2.6.23-rc1.orig/mm/Kconfig
+++ linux-2.6.23-rc1/mm/Kconfig
@@ -158,11 +158,6 @@ config RESOURCES_64BIT
 	help
 	  This option allows memory and IO resources to be 64 bit.
 
-config ZONE_DMA_FLAG
-	int
-	default "0" if !ZONE_DMA
-	default "1"
-
 config BOUNCE
 	def_bool y
 	depends on BLOCK && MMU && (ZONE_DMA || HIGHMEM)
Index: linux-2.6.23-rc1/mm/page_alloc.c
===================================================================
--- linux-2.6.23-rc1.orig/mm/page_alloc.c
+++ linux-2.6.23-rc1/mm/page_alloc.c
@@ -87,18 +87,12 @@ int sysctl_lowmem_reserve_ratio[MAX_NR_Z
 
 EXPORT_SYMBOL(totalram_pages);
 
-static char * const zone_names[MAX_NR_ZONES] = {
-#ifdef CONFIG_ZONE_DMA
-	 "DMA",
-#endif
-#ifdef CONFIG_ZONE_DMA32
-	 "DMA32",
-#endif
-	 "Normal",
-#ifdef CONFIG_HIGHMEM
-	 "HighMem",
-#endif
-	 "Movable",
+static char * const zone_names[] = {
+	[ZONE_DMA] = "DMA",
+	[ZONE_DMA32] = "DMA32",
+	[ZONE_NORMAL] = "Normal",
+	[ZONE_HIGHMEM] = "HighMem",
+	[ZONE_MOVABLE] =  "Movable",
 };
 
 int min_free_kbytes = 1024;
@@ -1513,14 +1507,15 @@ void si_meminfo_node(struct sysinfo *val
 
 	val->totalram = pgdat->node_present_pages;
 	val->freeram = node_page_state(nid, NR_FREE_PAGES);
-#ifdef CONFIG_HIGHMEM
-	val->totalhigh = pgdat->node_zones[ZONE_HIGHMEM].present_pages;
-	val->freehigh = zone_page_state(&pgdat->node_zones[ZONE_HIGHMEM],
+	if (is_configured_zone(ZONE_HIGHMEM)) {
+		val->totalhigh = pgdat->node_zones[ZONE_HIGHMEM].present_pages;
+		val->freehigh =
+			zone_page_state(&pgdat->node_zones[ZONE_HIGHMEM],
 			NR_FREE_PAGES);
-#else
-	val->totalhigh = 0;
-	val->freehigh = 0;
-#endif
+	} else {
+		val->totalhigh = 0;
+		val->freehigh = 0;
+	}
 	val->mem_unit = PAGE_SIZE;
 }
 #endif
Index: linux-2.6.23-rc1/mm/slab.c
===================================================================
--- linux-2.6.23-rc1.orig/mm/slab.c
+++ linux-2.6.23-rc1/mm/slab.c
@@ -2337,7 +2337,7 @@ kmem_cache_create (const char *name, siz
 	cachep->slab_size = slab_size;
 	cachep->flags = flags;
 	cachep->gfpflags = 0;
-	if (CONFIG_ZONE_DMA_FLAG && (flags & SLAB_CACHE_DMA))
+	if (is_configured_zone(ZONE_DMA) && (flags & SLAB_CACHE_DMA))
 		cachep->gfpflags |= GFP_DMA;
 	cachep->buffer_size = size;
 	cachep->reciprocal_buffer_size = reciprocal_value(size);
@@ -2658,7 +2658,7 @@ static void cache_init_objs(struct kmem_
 
 static void kmem_flagcheck(struct kmem_cache *cachep, gfp_t flags)
 {
-	if (CONFIG_ZONE_DMA_FLAG) {
+	if (is_configured_zone(ZONE_DMA)) {
 		if (flags & GFP_DMA)
 			BUG_ON(!(cachep->gfpflags & GFP_DMA));
 		else
Index: linux-2.6.23-rc1/mm/page-writeback.c
===================================================================
--- linux-2.6.23-rc1.orig/mm/page-writeback.c
+++ linux-2.6.23-rc1/mm/page-writeback.c
@@ -122,10 +122,12 @@ static void background_writeout(unsigned
 
 static unsigned long highmem_dirtyable_memory(unsigned long total)
 {
-#ifdef CONFIG_HIGHMEM
 	int node;
 	unsigned long x = 0;
 
+	if (!is_configured_zone(ZONE_HIGHMEM))
+		return 0;
+
 	for_each_online_node(node) {
 		struct zone *z =
 			&NODE_DATA(node)->node_zones[ZONE_HIGHMEM];
@@ -141,9 +143,6 @@ static unsigned long highmem_dirtyable_m
 	 * that this does not occur.
 	 */
 	return min(x, total);
-#else
-	return 0;
-#endif
 }
 
 static unsigned long determine_dirtyable_memory(void)

