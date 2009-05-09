Return-Path: <linux-kernel-owner+w=401wt.eu-S1754103AbZEIGsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103AbZEIGsT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 02:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751465AbZEIGsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 02:48:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:46016 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750931AbZEIGsF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 02:48:05 -0400
Message-ID: <4A05269D.8000701@kernel.org>
Date: Fri, 08 May 2009 23:45:49 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Christoph Lameter <cl@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 1/3] x86: remove MEMORY_HOTPLUG_RESERVE related code
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


after
| commit b263295dbffd33b0fbff670720fa178c30e3392a
| Author: Christoph Lameter <clameter@sgi.com>
| Date:   Wed Jan 30 13:30:47 2008 +0100
|
|    x86: 64-bit, make sparsemem vmemmap the only memory model

we don't have MEMORY_HOTPLUG_RESERVE anymore.

remove related dead code.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/numa_64.h |    3 -
 arch/x86/mm/numa_64.c          |    5 --
 arch/x86/mm/srat_64.c          |   63 +++++++------------------------------
 include/linux/mm.h             |    2 -
 mm/page_alloc.c                |   69 -----------------------------------------
 5 files changed, 12 insertions(+), 130 deletions(-)

Index: linux-2.6/arch/x86/include/asm/numa_64.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/numa_64.h
+++ linux-2.6/arch/x86/include/asm/numa_64.h
@@ -17,9 +17,6 @@ extern int compute_hash_shift(struct boo
 extern void numa_init_array(void);
 extern int numa_off;
 
-extern void srat_reserve_add_area(int nodeid);
-extern int hotadd_percent;
-
 extern s16 apicid_to_node[MAX_LOCAL_APIC];
 
 extern unsigned long numa_free_all_bootmem(void);
Index: linux-2.6/arch/x86/mm/numa_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/numa_64.c
+++ linux-2.6/arch/x86/mm/numa_64.c
@@ -272,9 +272,6 @@ void __init setup_node_bootmem(int nodei
 		reserve_bootmem_node(NODE_DATA(nodeid), bootmap_start,
 				 bootmap_pages<<PAGE_SHIFT, BOOTMEM_DEFAULT);
 
-#ifdef CONFIG_ACPI_NUMA
-	srat_reserve_add_area(nodeid);
-#endif
 	node_set_online(nodeid);
 }
 
@@ -608,8 +605,6 @@ static __init int numa_setup(char *opt)
 #ifdef CONFIG_ACPI_NUMA
 	if (!strncmp(opt, "noacpi", 6))
 		acpi_numa = -1;
-	if (!strncmp(opt, "hotadd=", 7))
-		hotadd_percent = simple_strtoul(opt+7, NULL, 10);
 #endif
 	return 0;
 }
Index: linux-2.6/arch/x86/mm/srat_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/srat_64.c
+++ linux-2.6/arch/x86/mm/srat_64.c
@@ -31,8 +31,6 @@ static nodemask_t nodes_parsed __initdat
 static nodemask_t cpu_nodes_parsed __initdata;
 static struct bootnode nodes[MAX_NUMNODES] __initdata;
 static struct bootnode nodes_add[MAX_NUMNODES];
-static int found_add_area __initdata;
-int hotadd_percent __initdata = 0;
 
 static int num_node_memblks __initdata;
 static struct bootnode node_memblk_range[NR_NODE_MEMBLKS] __initdata;
@@ -66,9 +64,6 @@ static __init void cutoff_node(int i, un
 {
 	struct bootnode *nd = &nodes[i];
 
-	if (found_add_area)
-		return;
-
 	if (nd->start < start) {
 		nd->start = start;
 		if (nd->end < nd->start)
@@ -86,7 +81,6 @@ static __init void bad_srat(void)
 	int i;
 	printk(KERN_ERR "SRAT: SRAT not used.\n");
 	acpi_numa = -1;
-	found_add_area = 0;
 	for (i = 0; i < MAX_LOCAL_APIC; i++)
 		apicid_to_node[i] = NUMA_NO_NODE;
 	for (i = 0; i < MAX_NUMNODES; i++)
@@ -182,24 +176,21 @@ acpi_numa_processor_affinity_init(struct
 	       pxm, apic_id, node);
 }
 
-static int update_end_of_memory(unsigned long end) {return -1;}
-static int hotadd_enough_memory(struct bootnode *nd) {return 1;}
 #ifdef CONFIG_MEMORY_HOTPLUG_SPARSE
 static inline int save_add_info(void) {return 1;}
 #else
 static inline int save_add_info(void) {return 0;}
 #endif
 /*
- * Update nodes_add and decide if to include add are in the zone.
- * Both SPARSE and RESERVE need nodes_add information.
- * This code supports one contiguous hot add area per node.
+ * Update nodes_add[]
+ * This code supports one contiguous hot add area per node
  */
-static int __init
-reserve_hotadd(int node, unsigned long start, unsigned long end)
+static void __init
+update_nodes_add(int node, unsigned long start, unsigned long end)
 {
 	unsigned long s_pfn = start >> PAGE_SHIFT;
 	unsigned long e_pfn = end >> PAGE_SHIFT;
-	int ret = 0, changed = 0;
+	int changed = 0;
 	struct bootnode *nd = &nodes_add[node];
 
 	/* I had some trouble with strange memory hotadd regions breaking
@@ -210,7 +201,7 @@ reserve_hotadd(int node, unsigned long s
 	   mistakes */
 	if ((signed long)(end - start) < NODE_MIN_SIZE) {
 		printk(KERN_ERR "SRAT: Hotplug area too small\n");
-		return -1;
+		return;
 	}
 
 	/* This check might be a bit too strict, but I'm keeping it for now. */
@@ -218,12 +209,7 @@ reserve_hotadd(int node, unsigned long s
 		printk(KERN_ERR
 			"SRAT: Hotplug area %lu -> %lu has existing memory\n",
 			s_pfn, e_pfn);
-		return -1;
-	}
-
-	if (!hotadd_enough_memory(&nodes_add[node]))  {
-		printk(KERN_ERR "SRAT: Hotplug area too large\n");
-		return -1;
+		return;
 	}
 
 	/* Looks good */
@@ -245,11 +231,9 @@ reserve_hotadd(int node, unsigned long s
 			printk(KERN_ERR "SRAT: Hotplug zone not continuous. Partly ignored\n");
 	}
 
-	ret = update_end_of_memory(nd->end);
-
 	if (changed)
-	 	printk(KERN_INFO "SRAT: hot plug zone found %Lx - %Lx\n", nd->start, nd->end);
-	return ret;
+		printk(KERN_INFO "SRAT: hot plug zone found %Lx - %Lx\n",
+				 nd->start, nd->end);
 }
 
 /* Callback for parsing of the Proximity Domain <-> Memory Area mappings */
@@ -310,13 +294,10 @@ acpi_numa_memory_affinity_init(struct ac
 	       start, end);
 	e820_register_active_regions(node, start >> PAGE_SHIFT,
 				     end >> PAGE_SHIFT);
-	push_node_boundaries(node, nd->start >> PAGE_SHIFT,
-						nd->end >> PAGE_SHIFT);
 
-	if ((ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE) &&
-	    (reserve_hotadd(node, start, end) < 0)) {
-		/* Ignore hotadd region. Undo damage */
-		printk(KERN_NOTICE "SRAT: Hotplug region ignored\n");
+	if (ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE) {
+		update_nodes_add(node, start, end);
+		/* restore nodes[node] */
 		*nd = oldnode;
 		if ((nd->start | nd->end) == 0)
 			node_clear(node, nodes_parsed);
@@ -510,26 +491,6 @@ static int null_slit_node_compare(int a,
 }
 #endif /* CONFIG_NUMA_EMU */
 
-void __init srat_reserve_add_area(int nodeid)
-{
-	if (found_add_area && nodes_add[nodeid].end) {
-		u64 total_mb;
-
-		printk(KERN_INFO "SRAT: Reserving hot-add memory space "
-				"for node %d at %Lx-%Lx\n",
-			nodeid, nodes_add[nodeid].start, nodes_add[nodeid].end);
-		total_mb = (nodes_add[nodeid].end - nodes_add[nodeid].start)
-					>> PAGE_SHIFT;
-		total_mb *= sizeof(struct page);
-		total_mb >>= 20;
-		printk(KERN_INFO "SRAT: This will cost you %Lu MB of "
-				"pre-allocated memory.\n", (unsigned long long)total_mb);
-		reserve_bootmem_node(NODE_DATA(nodeid), nodes_add[nodeid].start,
-			       nodes_add[nodeid].end - nodes_add[nodeid].start,
-			       BOOTMEM_DEFAULT);
-	}
-}
-
 int __node_distance(int a, int b)
 {
 	int index;
Index: linux-2.6/include/linux/mm.h
===================================================================
--- linux-2.6.orig/include/linux/mm.h
+++ linux-2.6/include/linux/mm.h
@@ -1032,8 +1032,6 @@ extern void add_active_range(unsigned in
 					unsigned long end_pfn);
 extern void remove_active_range(unsigned int nid, unsigned long start_pfn,
 					unsigned long end_pfn);
-extern void push_node_boundaries(unsigned int nid, unsigned long start_pfn,
-					unsigned long end_pfn);
 extern void remove_all_active_ranges(void);
 extern unsigned long absent_pages_in_range(unsigned long start_pfn,
 						unsigned long end_pfn);
Index: linux-2.6/mm/page_alloc.c
===================================================================
--- linux-2.6.orig/mm/page_alloc.c
+++ linux-2.6/mm/page_alloc.c
@@ -150,10 +150,6 @@ static unsigned long __meminitdata dma_r
   static int __meminitdata nr_nodemap_entries;
   static unsigned long __meminitdata arch_zone_lowest_possible_pfn[MAX_NR_ZONES];
   static unsigned long __meminitdata arch_zone_highest_possible_pfn[MAX_NR_ZONES];
-#ifdef CONFIG_MEMORY_HOTPLUG_RESERVE
-  static unsigned long __meminitdata node_boundary_start_pfn[MAX_NUMNODES];
-  static unsigned long __meminitdata node_boundary_end_pfn[MAX_NUMNODES];
-#endif /* CONFIG_MEMORY_HOTPLUG_RESERVE */
   static unsigned long __initdata required_kernelcore;
   static unsigned long __initdata required_movablecore;
   static unsigned long __meminitdata zone_movable_pfn[MAX_NUMNODES];
@@ -3121,64 +3117,6 @@ void __init sparse_memory_present_with_a
 }
 
 /**
- * push_node_boundaries - Push node boundaries to at least the requested boundary
- * @nid: The nid of the node to push the boundary for
- * @start_pfn: The start pfn of the node
- * @end_pfn: The end pfn of the node
- *
- * In reserve-based hot-add, mem_map is allocated that is unused until hotadd
- * time. Specifically, on x86_64, SRAT will report ranges that can potentially
- * be hotplugged even though no physical memory exists. This function allows
- * an arch to push out the node boundaries so mem_map is allocated that can
- * be used later.
- */
-#ifdef CONFIG_MEMORY_HOTPLUG_RESERVE
-void __init push_node_boundaries(unsigned int nid,
-		unsigned long start_pfn, unsigned long end_pfn)
-{
-	mminit_dprintk(MMINIT_TRACE, "zoneboundary",
-			"Entering push_node_boundaries(%u, %lu, %lu)\n",
-			nid, start_pfn, end_pfn);
-
-	/* Initialise the boundary for this node if necessary */
-	if (node_boundary_end_pfn[nid] == 0)
-		node_boundary_start_pfn[nid] = -1UL;
-
-	/* Update the boundaries */
-	if (node_boundary_start_pfn[nid] > start_pfn)
-		node_boundary_start_pfn[nid] = start_pfn;
-	if (node_boundary_end_pfn[nid] < end_pfn)
-		node_boundary_end_pfn[nid] = end_pfn;
-}
-
-/* If necessary, push the node boundary out for reserve hotadd */
-static void __meminit account_node_boundary(unsigned int nid,
-		unsigned long *start_pfn, unsigned long *end_pfn)
-{
-	mminit_dprintk(MMINIT_TRACE, "zoneboundary",
-			"Entering account_node_boundary(%u, %lu, %lu)\n",
-			nid, *start_pfn, *end_pfn);
-
-	/* Return if boundary information has not been provided */
-	if (node_boundary_end_pfn[nid] == 0)
-		return;
-
-	/* Check the boundaries and update if necessary */
-	if (node_boundary_start_pfn[nid] < *start_pfn)
-		*start_pfn = node_boundary_start_pfn[nid];
-	if (node_boundary_end_pfn[nid] > *end_pfn)
-		*end_pfn = node_boundary_end_pfn[nid];
-}
-#else
-void __init push_node_boundaries(unsigned int nid,
-		unsigned long start_pfn, unsigned long end_pfn) {}
-
-static void __meminit account_node_boundary(unsigned int nid,
-		unsigned long *start_pfn, unsigned long *end_pfn) {}
-#endif
-
-
-/**
  * get_pfn_range_for_nid - Return the start and end page frames for a node
  * @nid: The nid to return the range for. If MAX_NUMNODES, the min and max PFN are returned.
  * @start_pfn: Passed by reference. On return, it will have the node start_pfn.
@@ -3203,9 +3141,6 @@ void __meminit get_pfn_range_for_nid(uns
 
 	if (*start_pfn == -1UL)
 		*start_pfn = 0;
-
-	/* Push the node boundaries out if requested */
-	account_node_boundary(nid, start_pfn, end_pfn);
 }
 
 /*
@@ -3810,10 +3745,6 @@ void __init remove_all_active_ranges(voi
 {
 	memset(early_node_map, 0, sizeof(early_node_map));
 	nr_nodemap_entries = 0;
-#ifdef CONFIG_MEMORY_HOTPLUG_RESERVE
-	memset(node_boundary_start_pfn, 0, sizeof(node_boundary_start_pfn));
-	memset(node_boundary_end_pfn, 0, sizeof(node_boundary_end_pfn));
-#endif /* CONFIG_MEMORY_HOTPLUG_RESERVE */
 }
 
 /* Compare two active node_active_regions */
