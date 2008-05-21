Return-Path: <linux-kernel-owner+w=401wt.eu-S933808AbYEUCSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933808AbYEUCSk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 22:18:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932146AbYEUCSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 22:18:07 -0400
Received: from saeurebad.de ([85.214.36.134]:33140 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765619AbYEUCSD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 22:18:03 -0400
X-Mailbox-Line: From hannes@saeurebad.de Wed May 21 03:46:35 2008
Message-Id: <20080521014634.884729216@saeurebad.de>
References: <20080521013735.559724194@saeurebad.de>
User-Agent: quilt/0.46-1
Date: Wed, 21 May 2008 03:37:36 +0200
From: Johannes Weiner <hannes@saeurebad.de>
To: linux-kernel@vger.kernel.org
Cc: Ralf Baechle <ralf@linux-mips.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Richard Henderson <rth@twiddle.net>,
       Russell King <rmk@arm.linux.org.uk>, Tony Luck <tony.luck@intel.com>,
       Hirokazu Takata <takata@linux-m32r.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Kyle McMartin <kyle@parisc-linux.org>,
       Paul Mackerras <paulus@samba.org>, Paul Mundt <lethal@linux-sh.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: [RFC 1/3] mm: Move bootmem descriptors to a single place
Content-Disposition: inline; filename=mm-move-bootmem-descriptors.patch
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are a lot of places that define either a single bootmem
descriptor or an array of them.  Use only one central array with
MAX_NUMNODES items instead.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Acked-by: Ralf Baechle <ralf@linux-mips.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>
CC: Richard Henderson <rth@twiddle.net>
CC: Russell King <rmk@arm.linux.org.uk>
CC: Tony Luck <tony.luck@intel.com>
CC: Hirokazu Takata <takata@linux-m32r.org>
CC: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Kyle McMartin <kyle@parisc-linux.org>
CC: Paul Mackerras <paulus@samba.org>
CC: Paul Mundt <lethal@linux-sh.org>
CC: David S. Miller <davem@davemloft.net>
---

Andrew, this patch is already in -mm together with:

  - mm: Fix free_all_bootmem_core alignment check
  - mm: Normalize internal argument passing of bootmem data
  - mm: Unexport __alloc_bootmem_core()

They are obsoleted by this series.  This patch stays the same.

--- a/arch/alpha/mm/numa.c
+++ b/arch/alpha/mm/numa.c
@@ -19,7 +19,6 @@
 #include <asm/pgalloc.h>
 
 pg_data_t node_data[MAX_NUMNODES];
-bootmem_data_t node_bdata[MAX_NUMNODES];
 EXPORT_SYMBOL(node_data);
 
 #undef DEBUG_DISCONTIG
@@ -141,7 +140,7 @@ setup_memory_node(int nid, void *kernel_
 		printk(" not enough mem to reserve NODE_DATA");
 		return;
 	}
-	NODE_DATA(nid)->bdata = &node_bdata[nid];
+	NODE_DATA(nid)->bdata = &bootmem_node_data[nid];
 
 	printk(" Detected node memory:   start %8lu, end %8lu\n",
 	       node_min_pfn, node_max_pfn);
@@ -304,8 +303,9 @@ void __init paging_init(void)
 	dma_local_pfn = virt_to_phys((char *)MAX_DMA_ADDRESS) >> PAGE_SHIFT;
 
 	for_each_online_node(nid) {
-		unsigned long start_pfn = node_bdata[nid].node_boot_start >> PAGE_SHIFT;
-		unsigned long end_pfn = node_bdata[nid].node_low_pfn;
+		bootmem_data_t *bdata = &bootmem_node_data[nid];
+		unsigned long start_pfn = bdata->node_boot_start >> PAGE_SHIFT;
+		unsigned long end_pfn = bdata->node_low_pfn;
 
 		if (dma_local_pfn >= end_pfn - start_pfn)
 			zones_size[ZONE_DMA] = end_pfn - start_pfn;
--- a/arch/arm/mm/discontig.c
+++ b/arch/arm/mm/discontig.c
@@ -21,26 +21,24 @@
  * Our node_data structure for discontiguous memory.
  */
 
-static bootmem_data_t node_bootmem_data[MAX_NUMNODES];
-
 pg_data_t discontig_node_data[MAX_NUMNODES] = {
-  { .bdata = &node_bootmem_data[0] },
-  { .bdata = &node_bootmem_data[1] },
-  { .bdata = &node_bootmem_data[2] },
-  { .bdata = &node_bootmem_data[3] },
+  { .bdata = &bootmem_node_data[0] },
+  { .bdata = &bootmem_node_data[1] },
+  { .bdata = &bootmem_node_data[2] },
+  { .bdata = &bootmem_node_data[3] },
 #if MAX_NUMNODES == 16
-  { .bdata = &node_bootmem_data[4] },
-  { .bdata = &node_bootmem_data[5] },
-  { .bdata = &node_bootmem_data[6] },
-  { .bdata = &node_bootmem_data[7] },
-  { .bdata = &node_bootmem_data[8] },
-  { .bdata = &node_bootmem_data[9] },
-  { .bdata = &node_bootmem_data[10] },
-  { .bdata = &node_bootmem_data[11] },
-  { .bdata = &node_bootmem_data[12] },
-  { .bdata = &node_bootmem_data[13] },
-  { .bdata = &node_bootmem_data[14] },
-  { .bdata = &node_bootmem_data[15] },
+  { .bdata = &bootmem_node_data[4] },
+  { .bdata = &bootmem_node_data[5] },
+  { .bdata = &bootmem_node_data[6] },
+  { .bdata = &bootmem_node_data[7] },
+  { .bdata = &bootmem_node_data[8] },
+  { .bdata = &bootmem_node_data[9] },
+  { .bdata = &bootmem_node_data[10] },
+  { .bdata = &bootmem_node_data[11] },
+  { .bdata = &bootmem_node_data[12] },
+  { .bdata = &bootmem_node_data[13] },
+  { .bdata = &bootmem_node_data[14] },
+  { .bdata = &bootmem_node_data[15] },
 #endif
 };
 
--- a/arch/ia64/mm/discontig.c
+++ b/arch/ia64/mm/discontig.c
@@ -36,7 +36,6 @@ struct early_node_data {
 	struct ia64_node_data *node_data;
 	unsigned long pernode_addr;
 	unsigned long pernode_size;
-	struct bootmem_data bootmem_data;
 	unsigned long num_physpages;
 #ifdef CONFIG_ZONE_DMA
 	unsigned long num_dma_physpages;
@@ -76,7 +75,7 @@ static int __init build_node_maps(unsign
 				  int node)
 {
 	unsigned long cstart, epfn, end = start + len;
-	struct bootmem_data *bdp = &mem_data[node].bootmem_data;
+	struct bootmem_data *bdp = &bootmem_node_data[node];
 
 	epfn = GRANULEROUNDUP(end) >> PAGE_SHIFT;
 	cstart = GRANULEROUNDDOWN(start);
@@ -167,7 +166,7 @@ static void __init fill_pernode(int node
 {
 	void *cpu_data;
 	int cpus = early_nr_cpus_node(node);
-	struct bootmem_data *bdp = &mem_data[node].bootmem_data;
+	struct bootmem_data *bdp = &bootmem_node_data[node];
 
 	mem_data[node].pernode_addr = pernode;
 	mem_data[node].pernode_size = pernodesize;
@@ -224,7 +223,7 @@ static int __init find_pernode_space(uns
 {
 	unsigned long epfn;
 	unsigned long pernodesize = 0, pernode, pages, mapsize;
-	struct bootmem_data *bdp = &mem_data[node].bootmem_data;
+	struct bootmem_data *bdp = &bootmem_node_data[node];
 
 	epfn = (start + len) >> PAGE_SHIFT;
 
@@ -440,7 +439,7 @@ void __init find_memory(void)
 	efi_memmap_walk(find_max_min_low_pfn, NULL);
 
 	for_each_online_node(node)
-		if (mem_data[node].bootmem_data.node_low_pfn) {
+		if (bootmem_node_data[node].node_low_pfn) {
 			node_clear(node, memory_less_mask);
 			mem_data[node].min_pfn = ~0UL;
 		}
@@ -460,7 +459,7 @@ void __init find_memory(void)
 		else if (node_isset(node, memory_less_mask))
 			continue;
 
-		bdp = &mem_data[node].bootmem_data;
+		bdp = &bootmem_node_data[node];
 		pernode = mem_data[node].pernode_addr;
 		pernodesize = mem_data[node].pernode_size;
 		map = pernode + pernodesize;
--- a/arch/m32r/mm/discontig.c
+++ b/arch/m32r/mm/discontig.c
@@ -20,7 +20,6 @@ extern char _end[];
 
 struct pglist_data *node_data[MAX_NUMNODES];
 EXPORT_SYMBOL(node_data);
-static bootmem_data_t node_bdata[MAX_NUMNODES] __initdata;
 
 pg_data_t m32r_node_data[MAX_NUMNODES];
 
@@ -81,7 +80,7 @@ unsigned long __init setup_memory(void)
 	for_each_online_node(nid) {
 		mp = &mem_prof[nid];
 		NODE_DATA(nid)=(pg_data_t *)&m32r_node_data[nid];
-		NODE_DATA(nid)->bdata = &node_bdata[nid];
+		NODE_DATA(nid)->bdata = &bootmem_node_data[nid];
 		min_pfn = mp->start_pfn;
 		max_pfn = mp->start_pfn + mp->pages;
 		bootmap_size = init_bootmem_node(NODE_DATA(nid), mp->free_pfn,
@@ -163,4 +162,3 @@ unsigned long __init zone_sizes_init(voi
 
 	return holes;
 }
-
--- a/arch/m68k/mm/init.c
+++ b/arch/m68k/mm/init.c
@@ -32,8 +32,6 @@
 
 DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
 
-static bootmem_data_t __initdata bootmem_data[MAX_NUMNODES];
-
 pg_data_t pg_data_map[MAX_NUMNODES];
 EXPORT_SYMBOL(pg_data_map);
 
@@ -58,7 +56,7 @@ void __init m68k_setup_node(int node)
 		pg_data_table[i] = pg_data_map + node;
 	}
 #endif
-	pg_data_map[node].bdata = bootmem_data + node;
+	pg_data_map[node].bdata = bootmem_node_data + node;
 	node_set_online(node);
 }
 
--- a/arch/mips/sgi-ip27/ip27-memory.c
+++ b/arch/mips/sgi-ip27/ip27-memory.c
@@ -37,7 +37,6 @@
 
 static short __initdata slot_lastfilled_cache[MAX_COMPACT_NODES];
 static unsigned short __initdata slot_psize_cache[MAX_COMPACT_NODES][MAX_MEM_SLOTS];
-static struct bootmem_data __initdata plat_node_bdata[MAX_COMPACT_NODES];
 
 struct node_data *__node_data[MAX_COMPACT_NODES];
 
@@ -453,7 +452,7 @@ static void __init node_mem_init(cnodeid
 	__node_data[node] = __va(slot_freepfn << PAGE_SHIFT);
 
 	pd = NODE_DATA(node);
-	pd->bdata = &plat_node_bdata[node];
+	pd->bdata = &bootmem_node_data[node];
 
 	cpus_clear(hub_data(node)->h_cpus);
 
--- a/arch/parisc/mm/init.c
+++ b/arch/parisc/mm/init.c
@@ -36,7 +36,6 @@ extern int  data_start;
 
 #ifdef CONFIG_DISCONTIGMEM
 struct node_map_data node_data[MAX_NUMNODES] __read_mostly;
-bootmem_data_t bmem_data[MAX_NUMNODES] __read_mostly;
 unsigned char pfnnid_map[PFNNID_MAP_MAX] __read_mostly;
 #endif
 
@@ -262,7 +261,7 @@ static void __init setup_bootmem(void)
 #ifdef CONFIG_DISCONTIGMEM
 	for (i = 0; i < MAX_PHYSMEM_RANGES; i++) {
 		memset(NODE_DATA(i), 0, sizeof(pg_data_t));
-		NODE_DATA(i)->bdata = &bmem_data[i];
+		NODE_DATA(i)->bdata = &bootmem_node_data[i];
 	}
 	memset(pfnnid_map, 0xff, sizeof(pfnnid_map));
 
--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -39,7 +39,6 @@ EXPORT_SYMBOL(numa_cpu_lookup_table);
 EXPORT_SYMBOL(numa_cpumask_lookup_table);
 EXPORT_SYMBOL(node_data);
 
-static bootmem_data_t __initdata plat_node_bdata[MAX_NUMNODES];
 static int min_common_depth;
 static int n_mem_addr_cells, n_mem_size_cells;
 
@@ -685,7 +684,7 @@ void __init do_init_bootmem(void)
   		dbg("node %d\n", nid);
 		dbg("NODE_DATA() = %p\n", NODE_DATA(nid));
 
-		NODE_DATA(nid)->bdata = &plat_node_bdata[nid];
+		NODE_DATA(nid)->bdata = &bootmem_node_data[nid];
 		NODE_DATA(nid)->node_start_pfn = start_pfn;
 		NODE_DATA(nid)->node_spanned_pages = end_pfn - start_pfn;
 
--- a/arch/sh/mm/numa.c
+++ b/arch/sh/mm/numa.c
@@ -14,7 +14,6 @@
 #include <linux/pfn.h>
 #include <asm/sections.h>
 
-static bootmem_data_t plat_node_bdata[MAX_NUMNODES];
 struct pglist_data *node_data[MAX_NUMNODES] __read_mostly;
 EXPORT_SYMBOL_GPL(node_data);
 
@@ -35,7 +34,7 @@ void __init setup_memory(void)
 	NODE_DATA(0) = pfn_to_kaddr(free_pfn);
 	memset(NODE_DATA(0), 0, sizeof(struct pglist_data));
 	free_pfn += PFN_UP(sizeof(struct pglist_data));
-	NODE_DATA(0)->bdata = &plat_node_bdata[0];
+	NODE_DATA(0)->bdata = &bootmem_node_data[0];
 
 	/* Set up node 0 */
 	setup_bootmem_allocator(free_pfn);
@@ -66,7 +65,7 @@ void __init setup_bootmem_node(int nid, 
 	free_pfn += PFN_UP(sizeof(struct pglist_data));
 	memset(NODE_DATA(nid), 0, sizeof(struct pglist_data));
 
-	NODE_DATA(nid)->bdata = &plat_node_bdata[nid];
+	NODE_DATA(nid)->bdata = &bootmem_node_data[nid];
 	NODE_DATA(nid)->node_start_pfn = start_pfn;
 	NODE_DATA(nid)->node_spanned_pages = end_pfn - start_pfn;
 
--- a/arch/sparc64/mm/init.c
+++ b/arch/sparc64/mm/init.c
@@ -788,7 +788,6 @@ int numa_cpu_lookup_table[NR_CPUS];
 cpumask_t numa_cpumask_lookup_table[MAX_NUMNODES];
 
 #ifdef CONFIG_NEED_MULTIPLE_NODES
-static bootmem_data_t plat_node_bdata[MAX_NUMNODES];
 
 struct mdesc_mblock {
 	u64	base;
@@ -871,7 +870,7 @@ static void __init allocate_node_data(in
 	NODE_DATA(nid) = __va(paddr);
 	memset(NODE_DATA(nid), 0, sizeof(struct pglist_data));
 
-	NODE_DATA(nid)->bdata = &plat_node_bdata[nid];
+	NODE_DATA(nid)->bdata = &bootmem_node_data[nid];
 #endif
 
 	p = NODE_DATA(nid);
--- a/arch/x86/mm/discontig_32.c
+++ b/arch/x86/mm/discontig_32.c
@@ -41,7 +41,6 @@
 
 struct pglist_data *node_data[MAX_NUMNODES] __read_mostly;
 EXPORT_SYMBOL(node_data);
-static bootmem_data_t node0_bdata;
 
 /*
  * numa interface - we expect the numa architecture specific code to have
@@ -382,7 +381,7 @@ unsigned long __init setup_memory(void)
 		propagate_e820_map_node(nid);
 
 	memset(NODE_DATA(0), 0, sizeof(struct pglist_data));
-	NODE_DATA(0)->bdata = &node0_bdata;
+	NODE_DATA(0)->bdata = &bootmem_node_data[0];
 	setup_bootmem_allocator();
 	return max_low_pfn;
 }
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -27,8 +27,6 @@
 struct pglist_data *node_data[MAX_NUMNODES] __read_mostly;
 EXPORT_SYMBOL(node_data);
 
-bootmem_data_t plat_node_bdata[MAX_NUMNODES];
-
 struct memnode memnode;
 
 #ifdef CONFIG_SMP
@@ -215,7 +213,7 @@ void __init setup_node_bootmem(int nodei
 		nodedata_phys + pgdat_size - 1);
 
 	memset(NODE_DATA(nodeid), 0, sizeof(pg_data_t));
-	NODE_DATA(nodeid)->bdata = &plat_node_bdata[nodeid];
+	NODE_DATA(nodeid)->bdata = &bootmem_node_data[nodeid];
 	NODE_DATA(nodeid)->node_start_pfn = start_pfn;
 	NODE_DATA(nodeid)->node_spanned_pages = end_pfn - start_pfn;
 
@@ -671,5 +669,3 @@ void __init init_cpu_to_node(void)
 		numa_set_node(i, node);
 	}
 }
-
-
--- a/include/linux/bootmem.h
+++ b/include/linux/bootmem.h
@@ -38,6 +38,8 @@ typedef struct bootmem_data {
 	struct list_head list;
 } bootmem_data_t;
 
+extern bootmem_data_t bootmem_node_data[];
+
 extern unsigned long bootmem_bootmap_pages(unsigned long);
 extern unsigned long init_bootmem(unsigned long addr, unsigned long memend);
 extern void free_bootmem(unsigned long addr, unsigned long size);
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -36,6 +36,8 @@ static LIST_HEAD(bdata_list);
 unsigned long saved_max_pfn;
 #endif
 
+bootmem_data_t bootmem_node_data[MAX_NUMNODES] __initdata;
+
 /* return the number of _pages_ that will be allocated for the boot bitmap */
 unsigned long __init bootmem_bootmap_pages(unsigned long pages)
 {
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3992,9 +3992,7 @@ void __init set_dma_reserve(unsigned lon
 }
 
 #ifndef CONFIG_NEED_MULTIPLE_NODES
-static bootmem_data_t contig_bootmem_data;
-struct pglist_data contig_page_data = { .bdata = &contig_bootmem_data };
-
+struct pglist_data contig_page_data = { .bdata = &bootmem_node_data[0] };
 EXPORT_SYMBOL(contig_page_data);
 #endif
 

-- 

