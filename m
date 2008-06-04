Return-Path: <linux-kernel-owner+w=401wt.eu-S1757773AbYFDCiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757773AbYFDCiX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 22:38:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756423AbYFDChw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 22:37:52 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:57816 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756108AbYFDCht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 22:37:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=X4ZToVyP7sSX2wQs2cR+JZ0Dr+Gg3PDLnsabkE+tKCv15iBwh6mVDQ8yeAloJ2Nv2ikutxS1XdmLeCqGgsc1Bbbl81oDKog4Lkv4JeM/u3E4yJMhkVMJEtFWbKdVv8tVxn5eB9AMy48kr+o8riJN9kPl4yS1qx/A4MxvzkTs678=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] x86: 32 bit use e820_register_active_regions
Date: Tue, 3 Jun 2008 19:35:04 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806031025.55026.yhlu.kernel@gmail.com> <200806031934.01198.yhlu.kernel@gmail.com>
In-Reply-To: <200806031934.01198.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806031935.05202.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


so 32bit is more like 64bit, and more smart with combining e820 and numa.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/arch/x86/kernel/setup_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_32.c
+++ linux-2.6/arch/x86/kernel/setup_32.c
@@ -406,11 +406,12 @@ static void __init zone_sizes_init(void)
 	max_zone_pfns[ZONE_DMA] =
 		virt_to_phys((char *)MAX_DMA_ADDRESS) >> PAGE_SHIFT;
 	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
+	remove_all_active_ranges();
 #ifdef CONFIG_HIGHMEM
 	max_zone_pfns[ZONE_HIGHMEM] = highend_pfn;
-	add_active_range(0, 0, highend_pfn);
+	e820_register_active_regions(0, 0, highend_pfn);
 #else
-	add_active_range(0, 0, max_low_pfn);
+	e820_register_active_regions(0, 0, max_low_pfn);
 #endif
 
 	free_area_init_nodes(max_zone_pfns);
@@ -583,6 +584,7 @@ static void __init relocate_initrd(void)
 
 void __init setup_bootmem_allocator(void)
 {
+	int i;
 	unsigned long bootmap_size, bootmap;
 	/*
 	 * Initialize the boot-time allocator (with low memory only):
@@ -604,7 +606,8 @@ void __init setup_bootmem_allocator(void
 		 min_low_pfn<<PAGE_SHIFT, max_low_pfn<<PAGE_SHIFT);
 	printk(KERN_INFO "  bootmap %08lx - %08lx\n",
 		 bootmap, bootmap + bootmap_size);
-	register_bootmem_low_pages(max_low_pfn);
+	for_each_online_node(i)
+		free_bootmem_with_active_regions(i, max_low_pfn);
 	early_res_to_bootmem(0, max_low_pfn<<PAGE_SHIFT);
 
 #ifdef CONFIG_ACPI_SLEEP
@@ -745,11 +748,20 @@ void __init setup_arch(char **cmdline_p)
 	if (efi_enabled)
 		efi_init();
 
+	e820_register_active_regions(0, 0, -1UL);
+	/*
+	 * partially used pages are not usable - thus
+	 * we are rounding upwards:
+	 */
+	max_pfn = e820_end_of_ram();
+
 	/* update e820 for memory not covered by WB MTRRs */
-	find_max_pfn();
 	mtrr_bp_init();
-	if (mtrr_trim_uncached_memory(max_pfn))
-		find_max_pfn();
+	if (mtrr_trim_uncached_memory(max_pfn)) {
+		remove_all_active_ranges();
+		e820_register_active_regions(0, 0, -1UL);
+		max_pfn = e820_end_of_ram();
+	}
 
 	max_low_pfn = setup_memory();
 
Index: linux-2.6/arch/x86/mm/discontig_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/discontig_32.c
+++ linux-2.6/arch/x86/mm/discontig_32.c
@@ -120,10 +120,9 @@ int __init get_memcfg_numa_flat(void)
 {
 	printk("NUMA - single node, flat memory mode\n");
 
-	/* Run the memory configuration and find the top of memory. */
-	find_max_pfn();
 	node_start_pfn[0] = 0;
 	node_end_pfn[0] = max_pfn;
+	e820_register_active_regions(0, 0, max_pfn);
 	memory_present(0, 0, max_pfn);
 	node_remap_size[0] = node_memmap_size_bytes(0, 0, max_pfn);
 
@@ -315,6 +314,11 @@ unsigned long __init setup_memory(void)
 	 * this space and use it to adjust the boundary between ZONE_NORMAL
 	 * and ZONE_HIGHMEM.
 	 */
+
+	/* call find_max_low_pfn at first, it could update max_pfn */
+	system_max_low_pfn = max_low_pfn = find_max_low_pfn();
+
+	remove_all_active_ranges();
 	get_memcfg_numa();
 
 	kva_pages = round_up(calculate_numa_remap_pages(), PTRS_PER_PTE);
@@ -322,7 +326,6 @@ unsigned long __init setup_memory(void)
 	/* partially used pages are not usable - thus round upwards */
 	system_start_pfn = min_low_pfn = PFN_UP(init_pg_tables_end);
 
-	system_max_low_pfn = max_low_pfn = find_max_low_pfn();
 	kva_target_pfn = round_down(max_low_pfn - kva_pages, PTRS_PER_PTE);
 	do {
 		kva_start_pfn = find_e820_area(kva_target_pfn<<PAGE_SHIFT,
@@ -380,7 +383,6 @@ unsigned long __init setup_memory(void)
 
 void __init zone_sizes_init(void)
 {
-	int nid;
 	unsigned long max_zone_pfns[MAX_NR_ZONES];
 	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
 	max_zone_pfns[ZONE_DMA] =
@@ -390,15 +392,6 @@ void __init zone_sizes_init(void)
 	max_zone_pfns[ZONE_HIGHMEM] = highend_pfn;
 #endif
 
-	/* If SRAT has not registered memory, register it now */
-	if (find_max_pfn_with_active_regions() == 0) {
-		for_each_online_node(nid) {
-			if (node_has_online_mem(nid))
-				add_active_range(nid, node_start_pfn[nid],
-							node_end_pfn[nid]);
-		}
-	}
-
 	free_area_init_nodes(max_zone_pfns);
 	return;
 }
Index: linux-2.6/arch/x86/kernel/numaq_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/numaq_32.c
+++ linux-2.6/arch/x86/kernel/numaq_32.c
@@ -32,6 +32,7 @@
 #include <asm/topology.h>
 #include <asm/processor.h>
 #include <asm/mpspec.h>
+#include <asm/e820.h>
 
 #define	MB_TO_PAGES(addr) ((addr) << (20 - PAGE_SHIFT))
 
@@ -61,6 +62,8 @@ static void __init smp_dump_qct(void)
 			node_end_pfn[node] = MB_TO_PAGES(
 				eq->hi_shrd_mem_start + eq->hi_shrd_mem_size);
 
+			e820_register_active_regions(node, node_start_pfn[node],
+							node_end_pfn[node]);
 			memory_present(node,
 				node_start_pfn[node], node_end_pfn[node]);
 			node_remap_size[node] = node_memmap_size_bytes(node,
Index: linux-2.6/arch/x86/kernel/e820_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820_32.c
+++ linux-2.6/arch/x86/kernel/e820_32.c
@@ -207,69 +207,6 @@ void __init init_iomem_resources(struct 
 	}
 }
 
-/*
- * Find the highest page frame number we have available
- */
-void __init find_max_pfn(void)
-{
-	int i;
-
-	max_pfn = 0;
-
-	for (i = 0; i < e820.nr_map; i++) {
-		unsigned long start, end;
-		/* RAM? */
-		if (e820.map[i].type != E820_RAM)
-			continue;
-		start = PFN_UP(e820.map[i].addr);
-		end = PFN_DOWN(e820.map[i].addr + e820.map[i].size);
-		if (start >= end)
-			continue;
-		if (end > max_pfn)
-			max_pfn = end;
-	}
-}
-
-/*
- * Register fully available low RAM pages with the bootmem allocator.
- */
-void __init register_bootmem_low_pages(unsigned long max_low_pfn)
-{
-	int i;
-
-	for (i = 0; i < e820.nr_map; i++) {
-		unsigned long curr_pfn, last_pfn, size;
-		/*
-		 * Reserve usable low memory
-		 */
-		if (e820.map[i].type != E820_RAM)
-			continue;
-		/*
-		 * We are rounding up the start address of usable memory:
-		 */
-		curr_pfn = PFN_UP(e820.map[i].addr);
-		if (curr_pfn >= max_low_pfn)
-			continue;
-		/*
-		 * ... and at the end of the usable range downwards:
-		 */
-		last_pfn = PFN_DOWN(e820.map[i].addr + e820.map[i].size);
-
-		if (last_pfn > max_low_pfn)
-			last_pfn = max_low_pfn;
-
-		/*
-		 * .. finally, did all the rounding and playing
-		 * around just make the area go away?
-		 */
-		if (last_pfn <= curr_pfn)
-			continue;
-
-		size = last_pfn - curr_pfn;
-		free_bootmem(PFN_PHYS(curr_pfn), PFN_PHYS(size));
-	}
-}
-
 void __init limit_regions(unsigned long long size)
 {
 	unsigned long long current_addr;
@@ -360,8 +297,9 @@ static int __init parse_memmap(char *arg
 		 * size before original memory map is
 		 * reset.
 		 */
-		find_max_pfn();
-		saved_max_pfn = max_pfn;
+		e820_register_active_regions(0, 0, -1UL);
+		saved_max_pfn = e820_end_of_ram();
+		remove_all_active_ranges();
 #endif
 		e820.nr_map = 0;
 		user_defined_memmap = 1;
Index: linux-2.6/arch/x86/kernel/srat_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/srat_32.c
+++ linux-2.6/arch/x86/kernel/srat_32.c
@@ -31,6 +31,7 @@
 #include <asm/srat.h>
 #include <asm/topology.h>
 #include <asm/smp.h>
+#include <asm/e820.h>
 
 /*
  * proximity macros and definitions
@@ -244,7 +245,8 @@ static int __init acpi20_parse_srat(stru
 		printk("chunk %d nid %d start_pfn %08lx end_pfn %08lx\n",
 		       j, chunk->nid, chunk->start_pfn, chunk->end_pfn);
 		node_read_chunk(chunk->nid, chunk);
-		add_active_range(chunk->nid, chunk->start_pfn, chunk->end_pfn);
+		e820_register_active_regions(chunk->nid, chunk->start_pfn,
+					     min(chunk->end_pfn, max_pfn));
 	}
  
 	for_each_online_node(nid) {
Index: linux-2.6/include/asm-x86/e820_32.h
===================================================================
--- linux-2.6.orig/include/asm-x86/e820_32.h
+++ linux-2.6/include/asm-x86/e820_32.h
@@ -21,8 +21,6 @@
 extern void setup_memory_map(void);
 extern void finish_e820_parsing(void);
 
-extern void find_max_pfn(void);
-extern void register_bootmem_low_pages(unsigned long max_low_pfn);
 extern void limit_regions(unsigned long long size);
 extern void init_iomem_resources(struct resource *code_resource,
 				 struct resource *data_resource,
