Return-Path: <linux-kernel-owner+w=401wt.eu-S1754496AbYDRMJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496AbYDRMJO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 08:09:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752137AbYDRMI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 08:08:58 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58155 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbYDRMI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 08:08:57 -0400
Date: Fri, 18 Apr 2008 21:12:14 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Shi Weihua <shiwh@cn.fujitsu.com>
Cc: akpm@linux-foundation.org, balbir@linux.vnet.ibm.com, xemul@openvz.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, hugh@veritas.com,
       "mel@csn.ul.ie" <mel@csn.ul.ie>
Subject: [PATCH]Fix usemap for DISCONTIG/FLATMEM with not-aligned zone
 initilaization.
Message-Id: <20080418211214.299f91cd.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <48080B86.7040200@cn.fujitsu.com>
References: <48080706.50305@cn.fujitsu.com>
	<48080930.5090905@cn.fujitsu.com>
	<48080B86.7040200@cn.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Apr 2008 10:46:30 +0800
Shi Weihua <shiwh@cn.fujitsu.com> wrote:
> We found commit 9442ec9df40d952b0de185ae5638a74970388e01
> causes this boot failure by git-bisect.
> And, we found the following change caused the boot failure.
> -------------------------------------
> @@ -2528,7 +2535,6 @@ void __meminit memmap_init_zone(unsigned long size, int nid, unsigned long zon
>                 set_page_links(page, zone, nid, pfn);
>                 init_page_count(page);
>                 reset_page_mapcount(page);
> -               page_assign_page_cgroup(page, NULL);
>                 SetPageReserved(page);
> 
>                 /*
> -------------------------------------
Finally, above was not guilty. patch is below. Mel, could you review below ?

This happens because this box's start_pfn == 256 and memmap_init_zone(),
called by ia64's virtual_mem_map() passed aligned pfn.
patch is against 2.6.25.

-Kame
==
This patch is quick workaround. If someone can write a clearer patch, please.
Tested under ia64/torublesome machine. works well.
****

At boot, memmap_init_zone(size, zone, start_pfn, context) is called.

In usual,  memmap_init_zone() 's start_pfn is equal to zone->zone_start_pfn.
But ia64's virtual memmap under CONFIG_DISCONTIGMEM passes an aligned pfn
to this function.

When start_pfn is smaller than zone->zone_start_pfn, set_pageblock_migratetype()
causes a memory corruption, because bitmap_idx in usemap (pagetype bitmap)
is calculated by "pfn - start_pfn" and out-of-range.
(See set_pageblock_flags_group()//pfn_to_bitidx() in page_alloc.c)

On my ia64 box case, which has start_pfn = 256, bitmap_idx == -3
and set_pageblock_flags_group() corrupts memory.

This patch fixes the calculation of bitmap_idx and bitmap_size for pagetype.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---
 include/linux/mmzone.h |    1 +
 mm/page_alloc.c        |   22 ++++++++++++++--------
 2 files changed, 15 insertions(+), 8 deletions(-)

Index: linux-2.6.25/mm/page_alloc.c
===================================================================
--- linux-2.6.25.orig/mm/page_alloc.c
+++ linux-2.6.25/mm/page_alloc.c
@@ -2546,8 +2546,7 @@ void __meminit memmap_init_zone(unsigned
 		 * the start are marked MIGRATE_RESERVE by
 		 * setup_zone_migrate_reserve()
 		 */
-		if ((pfn & (pageblock_nr_pages-1)))
-			set_pageblock_migratetype(page, MIGRATE_MOVABLE);
+		set_pageblock_migratetype(page, MIGRATE_MOVABLE);
 
 		INIT_LIST_HEAD(&page->lru);
 #ifdef WANT_PAGE_VIRTUAL
@@ -2815,6 +2814,48 @@ static __meminit void zone_pcp_init(stru
 			zone->name, zone->present_pages, batch);
 }
 
+#ifndef CONFIG_SPARSEMEM
+/*
+ * Calculate the size of the zone->blockflags rounded to an unsigned long
+ * Start by making sure zonesize is a multiple of pageblock_order by rounding
+ * up. Then use 1 NR_PAGEBLOCK_BITS worth of bits per pageblock, finally
+ * round what is now in bits to nearest long in bits, then return it in
+ * bytes.
+ */
+static unsigned long __init usemap_size(struct zone* zone)
+{
+	unsigned long usemapsize;
+	unsigned long usemapbase = zone->zone_start_pfn;
+	unsigned long usemapend = zone->zone_start_pfn + zone->spanned_pages;
+
+	usemapbase = ALIGN(usemapbase, pageblock_nr_pages);
+	usemapend = roundup(usemapend, pageblock_nr_pages);
+	usemapsize = usemapend - usemapbase;
+	usemapsize = usemapsize >> pageblock_order;
+	usemapsize *= NR_PAGEBLOCK_BITS;
+	usemapsize = roundup(usemapsize, 8 * sizeof(unsigned long));
+
+	return usemapsize / 8;
+}
+
+static void __init setup_usemap(struct pglist_data *pgdat,
+				struct zone *zone)
+{
+	unsigned long usemapsize = usemap_size(zone);
+	zone->pageblock_base_pfn = zone->zone_start_pfn;
+	zone->pageblock_flags = NULL;
+	if (usemapsize) {
+		zone->pageblock_base_pfn =
+			ALIGN(zone->zone_start_pfn, pageblock_nr_pages);
+		zone->pageblock_flags = alloc_bootmem_node(pgdat, usemapsize);
+		memset(zone->pageblock_flags, 0, usemapsize);
+	}
+}
+#else
+static void inline setup_usemap(struct pglist_data *pgdat,
+				struct zone *zone) {}
+#endif /* CONFIG_SPARSEMEM */
+
 __meminit int init_currently_empty_zone(struct zone *zone,
 					unsigned long zone_start_pfn,
 					unsigned long size,
@@ -2829,6 +2870,8 @@ __meminit int init_currently_empty_zone(
 
 	zone->zone_start_pfn = zone_start_pfn;
 
+	setup_usemap(pgdat, zone);
+
 	memmap_init(size, pgdat->node_id, zone_idx(zone), zone_start_pfn);
 
 	zone_init_free_lists(zone);
@@ -3240,40 +3283,6 @@ static void __meminit calculate_node_tot
 							realtotalpages);
 }
 
-#ifndef CONFIG_SPARSEMEM
-/*
- * Calculate the size of the zone->blockflags rounded to an unsigned long
- * Start by making sure zonesize is a multiple of pageblock_order by rounding
- * up. Then use 1 NR_PAGEBLOCK_BITS worth of bits per pageblock, finally
- * round what is now in bits to nearest long in bits, then return it in
- * bytes.
- */
-static unsigned long __init usemap_size(unsigned long zonesize)
-{
-	unsigned long usemapsize;
-
-	usemapsize = roundup(zonesize, pageblock_nr_pages);
-	usemapsize = usemapsize >> pageblock_order;
-	usemapsize *= NR_PAGEBLOCK_BITS;
-	usemapsize = roundup(usemapsize, 8 * sizeof(unsigned long));
-
-	return usemapsize / 8;
-}
-
-static void __init setup_usemap(struct pglist_data *pgdat,
-				struct zone *zone, unsigned long zonesize)
-{
-	unsigned long usemapsize = usemap_size(zonesize);
-	zone->pageblock_flags = NULL;
-	if (usemapsize) {
-		zone->pageblock_flags = alloc_bootmem_node(pgdat, usemapsize);
-		memset(zone->pageblock_flags, 0, usemapsize);
-	}
-}
-#else
-static void inline setup_usemap(struct pglist_data *pgdat,
-				struct zone *zone, unsigned long zonesize) {}
-#endif /* CONFIG_SPARSEMEM */
 
 #ifdef CONFIG_HUGETLB_PAGE_SIZE_VARIABLE
 
@@ -3396,7 +3405,6 @@ static void __paginginit free_area_init_
 			continue;
 
 		set_pageblock_order(pageblock_default_order());
-		setup_usemap(pgdat, zone, size);
 		ret = init_currently_empty_zone(zone, zone_start_pfn,
 						size, MEMMAP_EARLY);
 		BUG_ON(ret);
@@ -4408,7 +4416,7 @@ static inline int pfn_to_bitidx(struct z
 	pfn &= (PAGES_PER_SECTION-1);
 	return (pfn >> pageblock_order) * NR_PAGEBLOCK_BITS;
 #else
-	pfn = pfn - zone->zone_start_pfn;
+	pfn = pfn - zone->pageblock_base_pfn;
 	return (pfn >> pageblock_order) * NR_PAGEBLOCK_BITS;
 #endif /* CONFIG_SPARSEMEM */
 }
Index: linux-2.6.25/include/linux/mmzone.h
===================================================================
--- linux-2.6.25.orig/include/linux/mmzone.h
+++ linux-2.6.25/include/linux/mmzone.h
@@ -250,6 +250,7 @@ struct zone {
 	 * Flags for a pageblock_nr_pages block. See pageblock-flags.h.
 	 * In SPARSEMEM, this map is stored in struct mem_section
 	 */
+	unsigned long		pageblock_base_pfn;
 	unsigned long		*pageblock_flags;
 #endif /* CONFIG_SPARSEMEM */
 

