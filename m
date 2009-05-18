Return-Path: <linux-kernel-owner+w=401wt.eu-S1756057AbZERHlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057AbZERHlq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 03:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756624AbZERHlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 03:41:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:48980 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756593AbZERHlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 03:41:03 -0400
Date: Mon, 18 May 2009 07:39:53 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, mel@csn.ul.ie, akpm@linux-foundation.org,
       tglx@linutronix.de, mingo@elte.hu, cl@linux-foundation.org
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, mel@csn.ul.ie, akpm@linux-foundation.org,
       tglx@linutronix.de, mingo@elte.hu, cl@linux-foundation.org
In-Reply-To: <4A0C4910.7090508@kernel.org>
References: <4A0C4910.7090508@kernel.org>
Subject: [tip:x86/mm] mm, x86: remove MEMORY_HOTPLUG_RESERVE related code
Message-ID: <tip-888a589f6be07d624e21e2174d98375e9f95911b@git.kernel.org>
Git-Commit-ID: 888a589f6be07d624e21e2174d98375e9f95911b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 18 May 2009 07:39:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  888a589f6be07d624e21e2174d98375e9f95911b
Gitweb:     http://git.kernel.org/tip/888a589f6be07d624e21e2174d98375e9f95911b
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Fri, 15 May 2009 13:59:37 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 18 May 2009 09:13:31 +0200

mm, x86: remove MEMORY_HOTPLUG_RESERVE related code

after:

 | commit b263295dbffd33b0fbff670720fa178c30e3392a
 | Author: Christoph Lameter <clameter@sgi.com>
 | Date:   Wed Jan 30 13:30:47 2008 +0100
 |
 |    x86: 64-bit, make sparsemem vmemmap the only memory model

we don't have MEMORY_HOTPLUG_RESERVE anymore.

Historically, x86-64 had an architecture-specific method for memory hotplug
whereby it scanned the SRAT for physical memory ranges that could be
potentially used for memory hot-add later. By reserving those ranges
without physical memory, the memmap would be allocated and left dormant
until needed. This depended on the DISCONTIG memory model which has been
removed so the code implementing HOTPLUG_RESERVE is now dead.

This patch removes the dead code used by MEMORY_HOTPLUG_RESERVE.

(Changelog authored by Mel.)

v2: updated changelog, and remove hotadd= in doc

[ Impact: remove dead code ]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
Reviewed-by: Mel Gorman <mel@csn.ul.ie>
Workflow-found-OK-by: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <4A0C4910.7090508@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/x86/x86_64/boot-options.txt |    5 --
 arch/x86/include/asm/numa_64.h            |    3 -
 arch/x86/mm/numa_64.c                     |    5 --
 arch/x86/mm/srat_64.c                     |   63 +++++---------------------
 include/linux/mm.h                        |    2 -
 mm/page_alloc.c                           |   69 -----------------------------
 6 files changed, 12 insertions(+), 135 deletions(-)

diff --git a/Documentation/x86/x86_64/boot-options.txt b/Documentation/x86/x86_64/boot-options.txt
index 34c1304..2db5893 100644
--- a/Documentation/x86/x86_64/boot-options.txt
+++ b/Documentation/x86/x86_64/boot-options.txt
@@ -150,11 +150,6 @@ NUMA
 		Otherwise, the remaining system RAM is allocated to an
 		additional node.
 
-  numa=hotadd=percent
-		Only allow hotadd memory to preallocate page structures upto
-		percent of already available memory.
-		numa=hotadd=0 will disable hotadd memory.
-
 ACPI
 
   acpi=off	Don't enable ACPI
diff --git a/arch/x86/include/asm/numa_64.h b/arch/x86/include/asm/numa_64.h
index 064ed6d..7feff06 100644
--- a/arch/x86/include/asm/numa_64.h
+++ b/arch/x86/include/asm/numa_64.h
@@ -17,9 +17,6 @@ extern int compute_hash_shift(struct bootnode *nodes, int numblks,
 extern void numa_init_array(void);
 extern int numa_off;
 
-extern void srat_reserve_add_area(int nodeid);
-extern int hotadd_percent;
-
 extern s16 apicid_to_node[MAX_LOCAL_APIC];
 
 extern unsigned long numa_free_all_bootmem(void);
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index fb61d81..a6a93c3 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -272,9 +272,6 @@ void __init setup_node_bootmem(int nodeid, unsigned long start,
 		reserve_bootmem_node(NODE_DATA(nodeid), bootmap_start,
 				 bootmap_pages<<PAGE_SHIFT, BOOTMEM_DEFAULT);
 
-#ifdef CONFIG_ACPI_NUMA
-	srat_reserve_add_area(nodeid);
-#endif
 	node_set_online(nodeid);
 }
 
@@ -591,8 +588,6 @@ static __init int numa_setup(char *opt)
 #ifdef CONFIG_ACPI_NUMA
 	if (!strncmp(opt, "noacpi", 6))
 		acpi_numa = -1;
-	if (!strncmp(opt, "hotadd=", 7))
-		hotadd_percent = simple_strtoul(opt+7, NULL, 10);
 #endif
 	return 0;
 }
diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index 87b45bf..b0dbbd4 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -31,8 +31,6 @@ static nodemask_t nodes_parsed __initdata;
 static nodemask_t cpu_nodes_parsed __initdata;
 static struct bootnode nodes[MAX_NUMNODES] __initdata;
 static struct bootnode nodes_add[MAX_NUMNODES];
-static int found_add_area __initdata;
-int hotadd_percent __initdata = 0;
 
 static int num_node_memblks __initdata;
 static struct bootnode node_memblk_range[NR_NODE_MEMBLKS] __initdata;
@@ -66,9 +64,6 @@ static __init void cutoff_node(int i, unsigned long start, unsigned long end)
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
@@ -182,24 +176,21 @@ acpi_numa_processor_affinity_init(struct acpi_srat_cpu_affinity *pa)
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
@@ -210,7 +201,7 @@ reserve_hotadd(int node, unsigned long start, unsigned long end)
 	   mistakes */
 	if ((signed long)(end - start) < NODE_MIN_SIZE) {
 		printk(KERN_ERR "SRAT: Hotplug area too small\n");
-		return -1;
+		return;
 	}
 
 	/* This check might be a bit too strict, but I'm keeping it for now. */
@@ -218,12 +209,7 @@ reserve_hotadd(int node, unsigned long start, unsigned long end)
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
@@ -245,11 +231,9 @@ reserve_hotadd(int node, unsigned long start, unsigned long end)
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
@@ -310,13 +294,10 @@ acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
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
@@ -510,26 +491,6 @@ static int null_slit_node_compare(int a, int b)
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
diff --git a/include/linux/mm.h b/include/linux/mm.h
index bff1f0d..511b098 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1031,8 +1031,6 @@ extern void add_active_range(unsigned int nid, unsigned long start_pfn,
 					unsigned long end_pfn);
 extern void remove_active_range(unsigned int nid, unsigned long start_pfn,
 					unsigned long end_pfn);
-extern void push_node_boundaries(unsigned int nid, unsigned long start_pfn,
-					unsigned long end_pfn);
 extern void remove_all_active_ranges(void);
 extern unsigned long absent_pages_in_range(unsigned long start_pfn,
 						unsigned long end_pfn);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index fe753ec..474c7e9 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -149,10 +149,6 @@ static unsigned long __meminitdata dma_reserve;
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
@@ -3103,64 +3099,6 @@ void __init sparse_memory_present_with_active_regions(int nid)
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
@@ -3185,9 +3123,6 @@ void __meminit get_pfn_range_for_nid(unsigned int nid,
 
 	if (*start_pfn == -1UL)
 		*start_pfn = 0;
-
-	/* Push the node boundaries out if requested */
-	account_node_boundary(nid, start_pfn, end_pfn);
 }
 
 /*
@@ -3793,10 +3728,6 @@ void __init remove_all_active_ranges(void)
 {
 	memset(early_node_map, 0, sizeof(early_node_map));
 	nr_nodemap_entries = 0;
-#ifdef CONFIG_MEMORY_HOTPLUG_RESERVE
-	memset(node_boundary_start_pfn, 0, sizeof(node_boundary_start_pfn));
-	memset(node_boundary_end_pfn, 0, sizeof(node_boundary_end_pfn));
-#endif /* CONFIG_MEMORY_HOTPLUG_RESERVE */
 }
 
 /* Compare two active node_active_regions */
