Return-Path: <linux-kernel-owner+w=401wt.eu-S1756052AbYFYFNH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052AbYFYFNH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 01:13:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752851AbYFYFMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 01:12:52 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:50852 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610AbYFYFMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 01:12:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=SOf7aAsTGlfUOaElakuRuaZFxotE4U9JTZxcaFiEU3+l722qfjvzvAgvzqCZGhLdwJ
         35g/Ro/5d9r1jFS/vNjQ2opIYSc07zCJjTbfGSf1cwXC9vQKHcyOHbJlMJVPyHU6R2WK
         k1tpbUWjzr4JaMHQIlzZqhWitlTOfY5YOvbo4=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: remove end_pfn in 64bit
Date: Tue, 24 Jun 2008 22:14:09 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806242213.15310.yhlu.kernel@gmail.com>
In-Reply-To: <200806242213.15310.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806242214.09503.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


and use max_pfn directly.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/aperture_64.c      |    6 ++++--
 arch/x86/kernel/e820.c             |    2 +-
 arch/x86/kernel/early-quirks.c     |    2 +-
 arch/x86/kernel/machine_kexec_64.c |    2 +-
 arch/x86/kernel/pci-calgary_64.c   |    4 ++--
 arch/x86/kernel/pci-dma.c          |    4 ++--
 arch/x86/kernel/pci-gart_64.c      |    4 ++--
 arch/x86/kernel/pci-swiotlb_64.c   |    2 +-
 arch/x86/kernel/setup_64.c         |   21 ++++++++++-----------
 arch/x86/mm/init_64.c              |   17 ++++++-----------
 arch/x86/mm/k8topology_64.c        |    4 ++--
 arch/x86/mm/numa_64.c              |    4 ++--
 arch/x86/mm/srat_64.c              |    2 +-
 arch/x86/power/hibernate_64.c      |    2 +-
 include/asm-x86/page_64.h          |    5 +++--
 15 files changed, 39 insertions(+), 42 deletions(-)

Index: linux-2.6/arch/x86/kernel/aperture_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/aperture_64.c
+++ linux-2.6/arch/x86/kernel/aperture_64.c
@@ -407,7 +407,9 @@ void __init gart_iommu_hole_init(void)
 				    agp_aper_base == aper_base &&
 				    agp_aper_order == aper_order) {
 					/* the same between two setting from NB and agp */
-					if (!no_iommu && end_pfn > MAX_DMA32_PFN && !printed_gart_size_msg) {
+					if (!no_iommu &&
+					    max_pfn > MAX_DMA32_PFN &&
+					    !printed_gart_size_msg) {
 						printk(KERN_ERR "you are using iommu with agp, but GART size is less than 64M\n");
 						printk(KERN_ERR "please increase GART size in your BIOS setup\n");
 						printk(KERN_ERR "if BIOS doesn't have that option, contact your HW vendor!\n");
@@ -448,7 +450,7 @@ out:
 		/* Got the aperture from the AGP bridge */
 	} else if (swiotlb && !valid_agp) {
 		/* Do nothing */
-	} else if ((!no_iommu && end_pfn > MAX_DMA32_PFN) ||
+	} else if ((!no_iommu && max_pfn > MAX_DMA32_PFN) ||
 		   force_iommu ||
 		   valid_agp ||
 		   fallback_aper_force) {
Index: linux-2.6/arch/x86/kernel/e820.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820.c
+++ linux-2.6/arch/x86/kernel/e820.c
@@ -527,7 +527,7 @@ __init void e820_setup_gap(void)
 
 #ifdef CONFIG_X86_64
 	if (!found) {
-		gapstart = (end_pfn << PAGE_SHIFT) + 1024*1024;
+		gapstart = (max_pfn << PAGE_SHIFT) + 1024*1024;
 		printk(KERN_ERR "PCI: Warning: Cannot find a gap in the 32bit "
 		       "address range\n"
 		       KERN_ERR "PCI: Unassigned devices with 32bit resource "
Index: linux-2.6/arch/x86/kernel/early-quirks.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/early-quirks.c
+++ linux-2.6/arch/x86/kernel/early-quirks.c
@@ -50,7 +50,7 @@ static void __init fix_hypertransport_co
 static void __init via_bugs(int  num, int slot, int func)
 {
 #ifdef CONFIG_GART_IOMMU
-	if ((end_pfn > MAX_DMA32_PFN ||  force_iommu) &&
+	if ((max_pfn > MAX_DMA32_PFN ||  force_iommu) &&
 	    !gart_iommu_aperture_allowed) {
 		printk(KERN_INFO
 		       "Looks like a VIA chipset. Disabling IOMMU."
Index: linux-2.6/arch/x86/kernel/machine_kexec_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/machine_kexec_64.c
+++ linux-2.6/arch/x86/kernel/machine_kexec_64.c
@@ -112,7 +112,7 @@ static int init_pgtable(struct kimage *i
 {
 	pgd_t *level4p;
 	level4p = (pgd_t *)__va(start_pgtable);
- 	return init_level4_page(image, level4p, 0, end_pfn << PAGE_SHIFT);
+	return init_level4_page(image, level4p, 0, max_pfn << PAGE_SHIFT);
 }
 
 static void set_idt(void *newidt, u16 limit)
Index: linux-2.6/arch/x86/kernel/pci-calgary_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/pci-calgary_64.c
+++ linux-2.6/arch/x86/kernel/pci-calgary_64.c
@@ -1394,7 +1394,7 @@ void __init detect_calgary(void)
 		return;
 	}
 
-	specified_table_size = determine_tce_table_size(end_pfn * PAGE_SIZE);
+	specified_table_size = determine_tce_table_size(max_pfn * PAGE_SIZE);
 
 	for (bus = 0; bus < MAX_PHB_BUS_NUM; bus++) {
 		struct calgary_bus_info *info = &bus_info[bus];
@@ -1459,7 +1459,7 @@ int __init calgary_iommu_init(void)
 	if (ret) {
 		printk(KERN_ERR "PCI-DMA: Calgary init failed %d, "
 		       "falling back to no_iommu\n", ret);
-		if (end_pfn > MAX_DMA32_PFN)
+		if (max_pfn > MAX_DMA32_PFN)
 			printk(KERN_ERR "WARNING more than 4GB of memory, "
 					"32bit PCI may malfunction.\n");
 		return ret;
Index: linux-2.6/arch/x86/kernel/pci-dma.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/pci-dma.c
+++ linux-2.6/arch/x86/kernel/pci-dma.c
@@ -74,7 +74,7 @@ early_param("dma32_size", parse_dma32_si
 void __init dma32_reserve_bootmem(void)
 {
 	unsigned long size, align;
-	if (end_pfn <= MAX_DMA32_PFN)
+	if (max_pfn <= MAX_DMA32_PFN)
 		return;
 
 	/*
@@ -93,7 +93,7 @@ void __init dma32_reserve_bootmem(void)
 static void __init dma32_free_bootmem(void)
 {
 
-	if (end_pfn <= MAX_DMA32_PFN)
+	if (max_pfn <= MAX_DMA32_PFN)
 		return;
 
 	if (!dma32_bootmem_ptr)
Index: linux-2.6/arch/x86/kernel/pci-gart_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/pci-gart_64.c
+++ linux-2.6/arch/x86/kernel/pci-gart_64.c
@@ -752,10 +752,10 @@ void __init gart_iommu_init(void)
 		return;
 
 	if (no_iommu ||
-	    (!force_iommu && end_pfn <= MAX_DMA32_PFN) ||
+	    (!force_iommu && max_pfn <= MAX_DMA32_PFN) ||
 	    !gart_iommu_aperture ||
 	    (no_agp && init_k8_gatt(&info) < 0)) {
-		if (end_pfn > MAX_DMA32_PFN) {
+		if (max_pfn > MAX_DMA32_PFN) {
 			printk(KERN_WARNING "More than 4GB of memory "
 			       	          "but GART IOMMU not available.\n"
 			       KERN_WARNING "falling back to iommu=soft.\n");
Index: linux-2.6/arch/x86/kernel/pci-swiotlb_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/pci-swiotlb_64.c
+++ linux-2.6/arch/x86/kernel/pci-swiotlb_64.c
@@ -38,7 +38,7 @@ const struct dma_mapping_ops swiotlb_dma
 void __init pci_swiotlb_init(void)
 {
 	/* don't initialize swiotlb if iommu=off (no_iommu=1) */
-	if (!iommu_detected && !no_iommu && end_pfn > MAX_DMA32_PFN)
+	if (!iommu_detected && !no_iommu && max_pfn > MAX_DMA32_PFN)
 	       swiotlb = 1;
 	if (swiotlb_force)
 		swiotlb = 1;
Index: linux-2.6/arch/x86/kernel/setup_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_64.c
+++ linux-2.6/arch/x86/kernel/setup_64.c
@@ -161,7 +161,7 @@ static void __init reserve_initrd(void)
 		unsigned long ramdisk_image = boot_params.hdr.ramdisk_image;
 		unsigned long ramdisk_size  = boot_params.hdr.ramdisk_size;
 		unsigned long ramdisk_end   = ramdisk_image + ramdisk_size;
-		unsigned long end_of_mem    = end_pfn << PAGE_SHIFT;
+		unsigned long end_of_mem    = max_pfn << PAGE_SHIFT;
 
 		if (ramdisk_end <= end_of_mem) {
 			/*
@@ -270,25 +270,25 @@ void __init setup_arch(char **cmdline_p)
 	 * partially used pages are not usable - thus
 	 * we are rounding upwards:
 	 */
-	end_pfn = e820_end_of_ram();
+	max_pfn = e820_end_of_ram();
 
 	/* pre allocte 4k for mptable mpc */
 	early_reserve_e820_mpc_new();
 	/* update e820 for memory not covered by WB MTRRs */
 	mtrr_bp_init();
-	if (mtrr_trim_uncached_memory(end_pfn)) {
+	if (mtrr_trim_uncached_memory(max_pfn)) {
 		remove_all_active_ranges();
 		e820_register_active_regions(0, 0, -1UL);
-		end_pfn = e820_end_of_ram();
+		max_pfn = e820_end_of_ram();
 	}
 
 	reserve_initrd();
 
-	num_physpages = end_pfn;
+	num_physpages = max_pfn;
 
 	check_efer();
 
-	max_pfn_mapped = init_memory_mapping(0, (end_pfn << PAGE_SHIFT));
+	max_pfn_mapped = init_memory_mapping(0, (max_pfn << PAGE_SHIFT));
 
 	vsmp_init();
 
@@ -303,9 +303,8 @@ void __init setup_arch(char **cmdline_p)
 	acpi_boot_table_init();
 
 	/* How many end-of-memory variables you have, grandma! */
-	max_low_pfn = end_pfn;
-	max_pfn = end_pfn;
-	high_memory = (void *)__va(end_pfn * PAGE_SIZE - 1) + 1;
+	max_low_pfn = max_pfn;
+	high_memory = (void *)__va(max_pfn * PAGE_SIZE - 1) + 1;
 
 	/* Remove active ranges so rediscovery with NUMA-awareness happens */
 	remove_all_active_ranges();
@@ -317,7 +316,7 @@ void __init setup_arch(char **cmdline_p)
 	acpi_numa_init();
 #endif
 
-	initmem_init(0, end_pfn);
+	initmem_init(0, max_pfn);
 
 	dma32_reserve_bootmem();
 
@@ -369,7 +368,7 @@ void __init setup_arch(char **cmdline_p)
 	 * We trust e820 completely. No explicit ROM probing in memory.
 	 */
 	e820_reserve_resources();
-	e820_mark_nosave_regions(end_pfn);
+	e820_mark_nosave_regions(max_pfn);
 
 	reserve_standard_io_resources();
 
Index: linux-2.6/arch/x86/mm/init_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_64.c
+++ linux-2.6/arch/x86/mm/init_64.c
@@ -49,11 +49,6 @@
 #include <asm/cacheflush.h>
 
 /*
- * PFN of last memory page.
- */
-unsigned long end_pfn;
-
-/*
  * end_pfn only includes RAM, while max_pfn_mapped includes all e820 entries.
  * The direct mapping extends to max_pfn_mapped, so that we can directly access
  * apertures, ACPI and other tables without having to play with fixmaps.
@@ -650,9 +645,9 @@ void __init paging_init(void)
 	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
 	max_zone_pfns[ZONE_DMA] = MAX_DMA_PFN;
 	max_zone_pfns[ZONE_DMA32] = MAX_DMA32_PFN;
-	max_zone_pfns[ZONE_NORMAL] = end_pfn;
+	max_zone_pfns[ZONE_NORMAL] = max_pfn;
 
-	memory_present(0, 0, end_pfn);
+	memory_present(0, 0, max_pfn);
 	sparse_init();
 	free_area_init_nodes(max_zone_pfns);
 }
@@ -734,8 +729,8 @@ void __init mem_init(void)
 #else
 	totalram_pages = free_all_bootmem();
 #endif
-	reservedpages = end_pfn - totalram_pages -
-					absent_pages_in_range(0, end_pfn);
+	reservedpages = max_pfn - totalram_pages -
+					absent_pages_in_range(0, max_pfn);
 	after_bootmem = 1;
 
 	codesize =  (unsigned long) &_etext - (unsigned long) &_text;
@@ -754,7 +749,7 @@ void __init mem_init(void)
 	printk(KERN_INFO "Memory: %luk/%luk available (%ldk kernel code, "
 				"%ldk reserved, %ldk data, %ldk init)\n",
 		(unsigned long) nr_free_pages() << (PAGE_SHIFT-10),
-		end_pfn << (PAGE_SHIFT-10),
+		max_pfn << (PAGE_SHIFT-10),
 		codesize >> 10,
 		reservedpages << (PAGE_SHIFT-10),
 		datasize >> 10,
@@ -854,7 +849,7 @@ int __init reserve_bootmem_generic(unsig
 #endif
 	unsigned long pfn = phys >> PAGE_SHIFT;
 
-	if (pfn >= end_pfn) {
+	if (pfn >= max_pfn) {
 		/*
 		 * This can happen with kdump kernels when accessing
 		 * firmware tables:
Index: linux-2.6/arch/x86/mm/k8topology_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/k8topology_64.c
+++ linux-2.6/arch/x86/mm/k8topology_64.c
@@ -143,8 +143,8 @@ int __init k8_scan_nodes(unsigned long s
 		limit |= (1<<24)-1;
 		limit++;
 
-		if (limit > end_pfn << PAGE_SHIFT)
-			limit = end_pfn << PAGE_SHIFT;
+		if (limit > max_pfn << PAGE_SHIFT)
+			limit = max_pfn << PAGE_SHIFT;
 		if (limit <= base)
 			continue;
 
Index: linux-2.6/arch/x86/mm/numa_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/numa_64.c
+++ linux-2.6/arch/x86/mm/numa_64.c
@@ -86,7 +86,7 @@ static int __init allocate_cachealigned_
 
 	addr = 0x8000;
 	nodemap_size = round_up(sizeof(s16) * memnodemapsize, L1_CACHE_BYTES);
-	nodemap_addr = find_e820_area(addr, end_pfn<<PAGE_SHIFT,
+	nodemap_addr = find_e820_area(addr, max_pfn<<PAGE_SHIFT,
 				      nodemap_size, L1_CACHE_BYTES);
 	if (nodemap_addr == -1UL) {
 		printk(KERN_ERR
@@ -581,7 +581,7 @@ void __init paging_init(void)
 	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
 	max_zone_pfns[ZONE_DMA] = MAX_DMA_PFN;
 	max_zone_pfns[ZONE_DMA32] = MAX_DMA32_PFN;
-	max_zone_pfns[ZONE_NORMAL] = end_pfn;
+	max_zone_pfns[ZONE_NORMAL] = max_pfn;
 
 	sparse_memory_present_with_active_regions(MAX_NUMNODES);
 	sparse_init();
Index: linux-2.6/arch/x86/mm/srat_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/srat_64.c
+++ linux-2.6/arch/x86/mm/srat_64.c
@@ -299,7 +299,7 @@ static int __init nodes_cover_memory(con
 			pxmram = 0;
 	}
 
-	e820ram = end_pfn - absent_pages_in_range(0, end_pfn);
+	e820ram = max_pfn - absent_pages_in_range(0, max_pfn);
 	/* We seem to lose 3 pages somewhere. Allow a bit of slack. */
 	if ((long)(e820ram - pxmram) >= 1*1024*1024) {
 		printk(KERN_ERR
Index: linux-2.6/arch/x86/power/hibernate_64.c
===================================================================
--- linux-2.6.orig/arch/x86/power/hibernate_64.c
+++ linux-2.6/arch/x86/power/hibernate_64.c
@@ -83,7 +83,7 @@ static int set_up_temporary_mappings(voi
 
 	/* Set up the direct mapping from scratch */
 	start = (unsigned long)pfn_to_kaddr(0);
-	end = (unsigned long)pfn_to_kaddr(end_pfn);
+	end = (unsigned long)pfn_to_kaddr(max_pfn);
 
 	for (; start < end; start = next) {
 		pud_t *pud = (pud_t *)get_safe_page(GFP_ATOMIC);
Index: linux-2.6/include/asm-x86/page_64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/page_64.h
+++ linux-2.6/include/asm-x86/page_64.h
@@ -58,7 +58,8 @@
 void clear_page(void *page);
 void copy_page(void *to, void *from);
 
-extern unsigned long end_pfn;
+/* duplicated to the one in bootmem.h */
+extern unsigned long max_pfn;
 extern unsigned long phys_base;
 
 extern unsigned long __phys_addr(unsigned long);
@@ -87,7 +88,7 @@ extern void initmem_init(unsigned long s
 #endif	/* !__ASSEMBLY__ */
 
 #ifdef CONFIG_FLATMEM
-#define pfn_valid(pfn)          ((pfn) < end_pfn)
+#define pfn_valid(pfn)          ((pfn) < max_pfn)
 #endif
 
 
