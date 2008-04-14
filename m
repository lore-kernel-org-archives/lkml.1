Return-Path: <linux-kernel-owner+w=401wt.eu-S1762913AbYDNSWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762913AbYDNSWM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 14:22:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765378AbYDNSPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 14:15:51 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:57183 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765374AbYDNSPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 14:15:50 -0400
Date: Mon, 14 Apr 2008 21:14:44 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] mm/page_alloc.c: cleanups
Message-ID: <20080414181444.GW6695@cs181133002.pp.htv.fi>
References: <20080330225335.GF28445@cs181133002.pp.htv.fi> <1206963138.8514.637.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1206963138.8514.637.camel@twins>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2008 at 01:32:18PM +0200, Peter Zijlstra wrote:
> On Mon, 2008-03-31 at 01:53 +0300, Adrian Bunk wrote:
> > This patch contains the following cleanups:
> > - make the following needlessly global variables static:
> >   - required_kernelcore
> >   - zone_movable_pfn[]
> > - make the following needlessly global functions static:
> >   - move_freepages()
> >   - move_freepages_block()
> >   - setup_pageset()
> >   - find_usable_zone_for_movable()
> >   - adjust_zone_range_for_zone_movable()
> >   - __absent_pages_in_range()
> >   - find_min_pfn_for_node()
> >   - find_zone_movable_pfns_for_nodes()
> > - #if 0 the following no longer used global function:
> >   - free_cold_page()
> 
> Why no outright removal? #if 0 only leaves more junk around to clean up
> later.

Updated patch below.

cu
Adrian


<--  snip  -->


This patch contains the following cleanups:
- make the following needlessly global variables static:
  - required_kernelcore
  - zone_movable_pfn[]
- make the following needlessly global functions static:
  - move_freepages()
  - move_freepages_block()
  - setup_pageset()
  - find_usable_zone_for_movable()
  - adjust_zone_range_for_zone_movable()
  - __absent_pages_in_range()
  - find_min_pfn_for_node()
  - find_zone_movable_pfns_for_nodes()
- remove the following no longer used global function:
  - free_cold_page()

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 include/linux/gfp.h |    1 -
 mm/page_alloc.c     |   30 +++++++++++++-----------------
 2 files changed, 13 insertions(+), 18 deletions(-)

10a85861ad4361685b5cab50937a10ea4a0f34d1 diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 164be9d..2b8148c 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -220,7 +220,6 @@ extern unsigned long get_zeroed_page(gfp_t gfp_mask);
 extern void __free_pages(struct page *page, unsigned int order);
 extern void free_pages(unsigned long addr, unsigned int order);
 extern void free_hot_page(struct page *page);
-extern void free_cold_page(struct page *page);
 
 #define __free_page(page) __free_pages((page), 0)
 #define free_page(addr) free_pages((addr),0)
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 402a504..da4f033 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -152,9 +152,9 @@ static unsigned long __meminitdata dma_reserve;
   static unsigned long __meminitdata node_boundary_start_pfn[MAX_NUMNODES];
   static unsigned long __meminitdata node_boundary_end_pfn[MAX_NUMNODES];
 #endif /* CONFIG_MEMORY_HOTPLUG_RESERVE */
-  unsigned long __initdata required_kernelcore;
+  static unsigned long __initdata required_kernelcore;
   static unsigned long __initdata required_movablecore;
-  unsigned long __meminitdata zone_movable_pfn[MAX_NUMNODES];
+  static unsigned long __meminitdata zone_movable_pfn[MAX_NUMNODES];
 
   /* movable_zone is the "real" zone pages in ZONE_MOVABLE are taken from */
   int movable_zone;
@@ -697,9 +697,9 @@ static int fallbacks[MIGRATE_TYPES][MIGRATE_TYPES-1] = {
  * Note that start_page and end_pages are not aligned on a pageblock
  * boundary. If alignment is required, use move_freepages_block()
  */
-int move_freepages(struct zone *zone,
-			struct page *start_page, struct page *end_page,
-			int migratetype)
+static int move_freepages(struct zone *zone,
+			  struct page *start_page, struct page *end_page,
+			  int migratetype)
 {
 	struct page *page;
 	unsigned long order;
@@ -738,7 +738,8 @@ int move_freepages(struct zone *zone,
 	return pages_moved;
 }
 
-int move_freepages_block(struct zone *zone, struct page *page, int migratetype)
+static int move_freepages_block(struct zone *zone, struct page *page,
+				int migratetype)
 {
 	unsigned long start_pfn, end_pfn;
 	struct page *start_page, *end_page;
@@ -1021,11 +1022,6 @@ void free_hot_page(struct page *page)
 {
 	free_hot_cold_page(page, 0);
 }
-	
-void free_cold_page(struct page *page)
-{
-	free_hot_cold_page(page, 1);
-}
 
 /*
  * split_page takes a non-compound higher-order page, and splits it into
@@ -2604,7 +2600,7 @@ static int zone_batchsize(struct zone *zone)
 	return batch;
 }
 
-inline void setup_pageset(struct per_cpu_pageset *p, unsigned long batch)
+static void setup_pageset(struct per_cpu_pageset *p, unsigned long batch)
 {
 	struct per_cpu_pages *pcp;
 
@@ -3033,7 +3029,7 @@ void __meminit get_pfn_range_for_nid(unsigned int nid,
  * assumption is made that zones within a node are ordered in monotonic
  * increasing memory addresses so that the "highest" populated zone is used
  */
-void __init find_usable_zone_for_movable(void)
+static void __init find_usable_zone_for_movable(void)
 {
 	int zone_index;
 	for (zone_index = MAX_NR_ZONES - 1; zone_index >= 0; zone_index--) {
@@ -3059,7 +3055,7 @@ void __init find_usable_zone_for_movable(void)
  * highest usable zone for ZONE_MOVABLE. This preserves the assumption that
  * zones within a node are in order of monotonic increases memory addresses
  */
-void __meminit adjust_zone_range_for_zone_movable(int nid,
+static void __meminit adjust_zone_range_for_zone_movable(int nid,
 					unsigned long zone_type,
 					unsigned long node_start_pfn,
 					unsigned long node_end_pfn,
@@ -3120,7 +3116,7 @@ static unsigned long __meminit zone_spanned_pages_in_node(int nid,
  * Return the number of holes in a range on a node. If nid is MAX_NUMNODES,
  * then all holes in the requested range will be accounted for.
  */
-unsigned long __meminit __absent_pages_in_range(int nid,
+static unsigned long __meminit __absent_pages_in_range(int nid,
 				unsigned long range_start_pfn,
 				unsigned long range_end_pfn)
 {
@@ -3604,7 +3600,7 @@ static void __init sort_node_map(void)
 }
 
 /* Find the lowest pfn for a node */
-unsigned long __init find_min_pfn_for_node(unsigned long nid)
+static unsigned long __init find_min_pfn_for_node(unsigned long nid)
 {
 	int i;
 	unsigned long min_pfn = ULONG_MAX;
@@ -3676,7 +3672,7 @@ static unsigned long __init early_calculate_totalpages(void)
  * memory. When they don't, some nodes will have more kernelcore than
  * others
  */
-void __init find_zone_movable_pfns_for_nodes(unsigned long *movable_pfn)
+static void __init find_zone_movable_pfns_for_nodes(unsigned long *movable_pfn)
 {
 	int i, nid;
 	unsigned long usable_startpfn;

