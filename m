Return-Path: <linux-kernel-owner+w=401wt.eu-S1757328AbZGQUlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757328AbZGQUlV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 16:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757113AbZGQUlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 16:41:19 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58786 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757173AbZGQUlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 16:41:16 -0400
Date: Fri, 17 Jul 2009 22:41:14 +0200
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org
Cc: mel@csn.ul.ie
Subject: [PATCH] Handle PXM memory hotadd regions with existing memory
Message-ID: <20090717204114.GA535@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handle PXM memory hotadd regions with existing memory

Linux would previously assume that if a PXM region in SRAT
has the hotplug memory bit set the memory is only future
hotpluggable. If there was already memory in this area
it would reject it completely.

This patch changes this to deal with systems which
set the memory hotplug bit on already existing PXMs.

We simply check if there is any memory in a PXM
and if yes always handle it like a non hotpluggable
PXM.

This also removes some obsolete checks.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/mm/srat_64.c |   79 ++++++++++++++++++++++++++++++++++----------------
 1 file changed, 55 insertions(+), 24 deletions(-)

Index: linux-2.6.31-rc3-ak/arch/x86/mm/srat_64.c
===================================================================
--- linux-2.6.31-rc3-ak.orig/arch/x86/mm/srat_64.c
+++ linux-2.6.31-rc3-ak/arch/x86/mm/srat_64.c
@@ -36,6 +36,12 @@ static int num_node_memblks __initdata;
 static struct bootnode node_memblk_range[NR_NODE_MEMBLKS] __initdata;
 static int memblk_nodeid[NR_NODE_MEMBLKS] __initdata;
 
+/*
+ * Memory expected to be missing in PXMs. We lose 3 pages
+ * somewhere, so default to 1MB of slack. Unit is PFNs
+ */
+static unsigned long memory_missing __initdata = (1 << (20 - PAGE_SHIFT));
+
 static __init int setup_node(int pxm)
 {
 	return acpi_map_pxm_to_node(pxm);
@@ -172,11 +178,6 @@ acpi_numa_processor_affinity_init(struct
 	       pxm, apic_id, node);
 }
 
-#ifdef CONFIG_MEMORY_HOTPLUG_SPARSE
-static inline int save_add_info(void) {return 1;}
-#else
-static inline int save_add_info(void) {return 0;}
-#endif
 /*
  * Update nodes_add[]
  * This code supports one contiguous hot add area per node
@@ -184,8 +185,6 @@ static inline int save_add_info(void) {r
 static void __init
 update_nodes_add(int node, unsigned long start, unsigned long end)
 {
-	unsigned long s_pfn = start >> PAGE_SHIFT;
-	unsigned long e_pfn = end >> PAGE_SHIFT;
 	int changed = 0;
 	struct bootnode *nd = &nodes_add[node];
 
@@ -200,14 +199,6 @@ update_nodes_add(int node, unsigned long
 		return;
 	}
 
-	/* This check might be a bit too strict, but I'm keeping it for now. */
-	if (absent_pages_in_range(s_pfn, e_pfn) != e_pfn - s_pfn) {
-		printk(KERN_ERR
-			"SRAT: Hotplug area %lu -> %lu has existing memory\n",
-			s_pfn, e_pfn);
-		return;
-	}
-
 	/* Looks good */
 
 	if (nd->start == nd->end) {
@@ -232,6 +223,33 @@ update_nodes_add(int node, unsigned long
 				 nd->start, nd->end);
 }
 
+/*
+ * PXM only contains future-pluggable memory?
+ * Side effect: Updates memory_missing.
+ */
+static int __init ma_future_pluggable(struct acpi_srat_mem_affinity *ma,
+				  unsigned long start_pfn,
+				  unsigned long end_pfn)
+{
+	unsigned long absent;
+
+	if (!(ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE))
+		return 0;
+
+	absent = absent_pages_in_range(start_pfn, end_pfn);
+	if (absent != end_pfn - start_pfn) {
+		printk(KERN_INFO
+	"SRAT: Hotplug area %lx-%lx has existing memory (missing %lu MB)\n",
+				start_pfn << PAGE_SHIFT,
+				end_pfn << PAGE_SHIFT,
+				absent << (20 - PAGE_SHIFT));
+		memory_missing += absent;
+		return 0;
+	}
+
+	return 1;
+}
+
 /* Callback for parsing of the Proximity Domain <-> Memory Area mappings */
 void __init
 acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
@@ -240,6 +258,7 @@ acpi_numa_memory_affinity_init(struct ac
 	unsigned long start, end;
 	int node, pxm;
 	int i;
+	unsigned long start_pfn, end_pfn;
 
 	if (srat_disabled())
 		return;
@@ -250,8 +269,6 @@ acpi_numa_memory_affinity_init(struct ac
 	if ((ma->flags & ACPI_SRAT_MEM_ENABLED) == 0)
 		return;
 
-	if ((ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE) && !save_add_info())
-		return;
 	start = ma->base_address;
 	end = start + ma->length;
 	pxm = ma->proximity_domain;
@@ -288,10 +305,24 @@ acpi_numa_memory_affinity_init(struct ac
 
 	printk(KERN_INFO "SRAT: Node %u PXM %u %lx-%lx\n", node, pxm,
 	       start, end);
-	e820_register_active_regions(node, start >> PAGE_SHIFT,
-				     end >> PAGE_SHIFT);
 
-	if (ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE) {
+	start_pfn = start >> PAGE_SHIFT;
+	end_pfn = end >> PAGE_SHIFT;
+
+	e820_register_active_regions(node, start_pfn, end_pfn);
+
+	/*
+	 * Only treat a range as future-hotplug when it contains no existing
+	 * memory.
+	 *
+	 * We could probably split this into multiple areas in case
+	 * only some memory is missing, but let's keep it simple for now.
+	 * Not treating a non-existing range as hotplug only costs
+	 * some memory.
+	 */
+	if (ma_future_pluggable(ma, start_pfn, end_pfn)) {
+		printk(KERN_INFO "PXM Node %u %lx-%lx is future hotpluggable\n",
+					node, start, end);
 		update_nodes_add(node, start, end);
 		/* restore nodes[node] */
 		*nd = oldnode;
@@ -323,12 +354,12 @@ static int __init nodes_cover_memory(con
 	}
 
 	e820ram = max_pfn - (e820_hole_size(0, max_pfn<<PAGE_SHIFT)>>PAGE_SHIFT);
-	/* We seem to lose 3 pages somewhere. Allow 1M of slack. */
-	if ((long)(e820ram - pxmram) >= (1<<(20 - PAGE_SHIFT))) {
+	if ((long)(e820ram - pxmram) >= memory_missing) {
 		printk(KERN_ERR
-	"SRAT: PXMs only cover %luMB of your %luMB e820 RAM. Not used.\n",
+	"SRAT: PXMs only cover %luMB of your %luMB e820 RAM (expected missing %luMB)\n",
 			(pxmram << PAGE_SHIFT) >> 20,
-			(e820ram << PAGE_SHIFT) >> 20);
+			(e820ram << PAGE_SHIFT) >> 20,
+			(memory_missing << PAGE_SHIFT) >> 20);
 		return 0;
 	}
 	return 1;
