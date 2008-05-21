Return-Path: <linux-kernel-owner+w=401wt.eu-S1761296AbYEUCT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761296AbYEUCT3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 22:19:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933583AbYEUCSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 22:18:37 -0400
Received: from saeurebad.de ([85.214.36.134]:33173 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933436AbYEUCSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 22:18:35 -0400
X-Mailbox-Line: From hannes@saeurebad.de Wed May 21 03:46:35 2008
Message-Id: <20080521014635.311702567@saeurebad.de>
References: <20080521013735.559724194@saeurebad.de>
User-Agent: quilt/0.46-1
Date: Wed, 21 May 2008 03:37:38 +0200
From: Johannes Weiner <hannes@saeurebad.de>
To: linux-kernel@vger.kernel.org
Cc: Richard Henderson <rth@twiddle.net>, Russell King <rmk@arm.linux.org.uk>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Tony Luck <tony.luck@intel.com>,
       Hirokazu Takata <takata@linux-m32r.org>,
       David Howells <dhowells@redhat.com>, Paul Mundt <lethal@linux-sh.org>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC 3/3] mm: Remove node_boot_start from bootmem_data_t
Content-Disposition: inline; filename=bootmem-replace-node_boot_start-with-node_min_pfn.patch
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drop node_boot_start and convert users to node_min_pfn which is what
they really mean.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
CC: Richard Henderson <rth@twiddle.net>
CC: Russell King <rmk@arm.linux.org.uk>
CC: Haavard Skinnemoen <hskinnemoen@atmel.com>
CC: Tony Luck <tony.luck@intel.com>
CC: Hirokazu Takata <takata@linux-m32r.org>
CC: David Howells <dhowells@redhat.com>
CC: Paul Mundt <lethal@linux-sh.org>
CC: Ingo Molnar <mingo@elte.hu>
---

 arch/alpha/mm/numa.c     |    2 +-
 arch/arm/plat-omap/fb.c  |    4 +---
 arch/avr32/mm/init.c     |    3 +--
 arch/ia64/mm/discontig.c |   19 ++++++++++---------
 arch/m32r/mm/init.c      |    4 +---
 arch/mn10300/mm/init.c   |    6 +++---
 arch/sh/mm/init.c        |    2 +-
 include/linux/bootmem.h  |    1 -
 mm/bootmem.c             |    3 ---
 9 files changed, 18 insertions(+), 26 deletions(-)

--- a/arch/alpha/mm/numa.c
+++ b/arch/alpha/mm/numa.c
@@ -304,7 +304,7 @@ void __init paging_init(void)
 
 	for_each_online_node(nid) {
 		bootmem_data_t *bdata = &bootmem_node_data[nid];
-		unsigned long start_pfn = bdata->node_boot_start >> PAGE_SHIFT;
+		unsigned long start_pfn = bdata->node_min_pfn;
 		unsigned long end_pfn = bdata->node_low_pfn;
 
 		if (dma_local_pfn >= end_pfn - start_pfn)
--- a/arch/arm/plat-omap/fb.c
+++ b/arch/arm/plat-omap/fb.c
@@ -182,7 +182,7 @@ void __init omapfb_reserve_sdram(void)
 		return;
 
 	bdata = NODE_DATA(0)->bdata;
-	sdram_start = bdata->node_boot_start;
+	sdram_start = bdata->node_min_pfn << PAGE_SHIFT;
 	sdram_size = (bdata->node_low_pfn << PAGE_SHIFT) - sdram_start;
 	reserved = 0;
 	for (i = 0; ; i++) {
@@ -340,5 +340,3 @@ unsigned long omapfb_reserve_sram(unsign
 
 
 #endif
-
-
--- a/arch/avr32/mm/init.c
+++ b/arch/avr32/mm/init.c
@@ -125,8 +125,7 @@ void __init paging_init(void)
 		unsigned long zones_size[MAX_NR_ZONES];
 		unsigned long low, start_pfn;
 
-		start_pfn = pgdat->bdata->node_boot_start;
-		start_pfn >>= PAGE_SHIFT;
+		start_pfn = pgdat->bdata->node_min_pfn;
 		low = pgdat->bdata->node_low_pfn;
 
 		memset(zones_size, 0, sizeof(zones_size));
--- a/arch/ia64/mm/discontig.c
+++ b/arch/ia64/mm/discontig.c
@@ -74,17 +74,17 @@ pg_data_t *pgdat_list[MAX_NUMNODES];
 static int __init build_node_maps(unsigned long start, unsigned long len,
 				  int node)
 {
-	unsigned long cstart, epfn, end = start + len;
+	unsigned long spfn, epfn, end = start + len;
 	struct bootmem_data *bdp = &bootmem_node_data[node];
 
 	epfn = GRANULEROUNDUP(end) >> PAGE_SHIFT;
-	cstart = GRANULEROUNDDOWN(start);
+	spfn = GRANULEROUNDDOWN(start) >> PAGE_SHIFT;
 
 	if (!bdp->node_low_pfn) {
-		bdp->node_boot_start = cstart;
+		bdp->node_min_pfn = spfn;
 		bdp->node_low_pfn = epfn;
 	} else {
-		bdp->node_boot_start = min(cstart, bdp->node_boot_start);
+		bdp->node_min_pfn = min(spfn, bdp->node_min_pfn);
 		bdp->node_low_pfn = max(epfn, bdp->node_low_pfn);
 	}
 
@@ -221,20 +221,21 @@ static void __init fill_pernode(int node
 static int __init find_pernode_space(unsigned long start, unsigned long len,
 				     int node)
 {
-	unsigned long epfn;
+	unsigned long spfn, epfn;
 	unsigned long pernodesize = 0, pernode, pages, mapsize;
 	struct bootmem_data *bdp = &bootmem_node_data[node];
 
+	spfn = start >> PAGE_SHIFT;
 	epfn = (start + len) >> PAGE_SHIFT;
 
-	pages = bdp->node_low_pfn - (bdp->node_boot_start >> PAGE_SHIFT);
+	pages = bdp->node_low_pfn - bdp->node_min_pfn;
 	mapsize = bootmem_bootmap_pages(pages) << PAGE_SHIFT;
 
 	/*
 	 * Make sure this memory falls within this node's usable memory
 	 * since we may have thrown some away in build_maps().
 	 */
-	if (start < bdp->node_boot_start || epfn > bdp->node_low_pfn)
+	if (spfn < bdp->node_min_pfn || epfn > bdp->node_low_pfn)
 		return 0;
 
 	/* Don't setup this node's local space twice... */
@@ -296,7 +297,7 @@ static void __init reserve_pernode_space
 		bdp = pdp->bdata;
 
 		/* First the bootmem_map itself */
-		pages = bdp->node_low_pfn - (bdp->node_boot_start>>PAGE_SHIFT);
+		pages = bdp->node_low_pfn - bdp->node_min_pfn;
 		size = bootmem_bootmap_pages(pages) << PAGE_SHIFT;
 		base = __pa(bdp->node_bootmem_map);
 		reserve_bootmem_node(pdp, base, size, BOOTMEM_DEFAULT);
@@ -466,7 +467,7 @@ void __init find_memory(void)
 
 		init_bootmem_node(pgdat_list[node],
 				  map>>PAGE_SHIFT,
-				  bdp->node_boot_start>>PAGE_SHIFT,
+				  bdp->node_min_pfn,
 				  bdp->node_low_pfn);
 	}
 
--- a/arch/m32r/mm/init.c
+++ b/arch/m32r/mm/init.c
@@ -93,8 +93,7 @@ void free_initrd_mem(unsigned long, unsi
 #endif
 
 /* It'd be good if these lines were in the standard header file. */
-#define START_PFN(nid)	\
-	(NODE_DATA(nid)->bdata->node_boot_start >> PAGE_SHIFT)
+#define START_PFN(nid)		(NODE_DATA(nid)->bdata->node_min_pfn)
 #define MAX_LOW_PFN(nid)	(NODE_DATA(nid)->bdata->node_low_pfn)
 
 #ifndef CONFIG_DISCONTIGMEM
@@ -252,4 +251,3 @@ void free_initrd_mem(unsigned long start
 	printk (KERN_INFO "Freeing initrd memory: %ldk freed\n", (end - start) >> 10);
 }
 #endif
-
--- a/arch/mn10300/mm/init.c
+++ b/arch/mn10300/mm/init.c
@@ -67,8 +67,8 @@ void __init paging_init(void)
 
 	/* declare the sizes of the RAM zones (only use the normal zone) */
 	zones_size[ZONE_NORMAL] =
-		(contig_page_data.bdata->node_low_pfn) -
-		(contig_page_data.bdata->node_boot_start >> PAGE_SHIFT);
+		contig_page_data.bdata->node_low_pfn -
+		contig_page_data.bdata->node_min_pfn;
 
 	/* pass the memory from the bootmem allocator to the main allocator */
 	free_area_init(zones_size);
@@ -87,7 +87,7 @@ void __init mem_init(void)
 	if (!mem_map)
 		BUG();
 
-#define START_PFN	(contig_page_data.bdata->node_boot_start >> PAGE_SHIFT)
+#define START_PFN	(contig_page_data.bdata->node_min_pfn)
 #define MAX_LOW_PFN	(contig_page_data.bdata->node_low_pfn)
 
 	max_mapnr = num_physpages = MAX_LOW_PFN - START_PFN;
--- a/arch/sh/mm/init.c
+++ b/arch/sh/mm/init.c
@@ -191,7 +191,7 @@ void __init paging_init(void)
 		pg_data_t *pgdat = NODE_DATA(nid);
 		unsigned long low, start_pfn;
 
-		start_pfn = pgdat->bdata->node_boot_start >> PAGE_SHIFT;
+		start_pfn = pgdat->bdata->node_min_pfn;
 		low = pgdat->bdata->node_low_pfn;
 
 		if (max_zone_pfns[ZONE_NORMAL] < low)
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -81,9 +81,6 @@ static unsigned long __init __init_bootm
 	bdata->node_min_pfn = startpfn;
 	bdata->node_low_pfn = endpfn;
 
-	/* XXX: To be dropped */
-	bdata->node_boot_start = startpfn << PAGE_SHIFT;
-
 	bytes = bootmem_bootmap_bytes(endpfn - startpfn);
 	memset(bdata->node_bootmem_map, 0xff, bytes);
 	link_bdata(bdata);
--- a/include/linux/bootmem.h
+++ b/include/linux/bootmem.h
@@ -13,7 +13,6 @@ extern unsigned long saved_max_pfn;
 #endif
 
 typedef struct bootmem_data {
-	unsigned long node_boot_start;
 	unsigned long node_min_pfn;
 	unsigned long node_low_pfn;
 	void *node_bootmem_map;

-- 
