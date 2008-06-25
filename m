Return-Path: <linux-kernel-owner+w=401wt.eu-S1758153AbYFYEjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758153AbYFYEjN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 00:39:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753817AbYFYEhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 00:37:14 -0400
Received: from 9.sub-70-198-159.myvzw.com ([70.198.159.9]:37442 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752814AbYFYEhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 00:37:10 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 12 of 36] x86_64: replace end_pfn with num_physpages
X-Mercurial-Node: 1c137345bcac5c8cdf7108c49366055d644aa335
Message-Id: <1c137345bcac5c8cdf71.1214367548@localhost>
In-Reply-To: <patchbomb.1214367536@localhost>
Date: Wed, 25 Jun 2008 00:19:08 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       xen-devel <xen-devel@lists.xensource.com>,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reasons for replacement:
 - they're semantically identical
 - end_pfn is a bad name for a global identifier
 - small step towards unification

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Vivek Goyal <vgoyal@in.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
---
 arch/x86/kernel/aperture_64.c      |    4 ++--
 arch/x86/kernel/e820.c             |    2 +-
 arch/x86/kernel/early-quirks.c     |    2 +-
 arch/x86/kernel/machine_kexec_64.c |    2 +-
 arch/x86/kernel/pci-calgary_64.c   |    4 ++--
 arch/x86/kernel/pci-dma.c          |    4 ++--
 arch/x86/kernel/pci-gart_64.c      |    4 ++--
 arch/x86/kernel/pci-swiotlb_64.c   |    2 +-
 arch/x86/kernel/setup_64.c         |   22 ++++++++++------------
 arch/x86/mm/init_64.c              |   14 +++++++-------
 arch/x86/mm/k8topology_64.c        |    4 ++--
 arch/x86/mm/numa_64.c              |    4 ++--
 arch/x86/mm/srat_64.c              |    2 +-
 arch/x86/power/hibernate_64.c      |    2 +-
 include/asm-x86/page_64.h          |    3 +--
 15 files changed, 36 insertions(+), 39 deletions(-)

diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -407,7 +407,7 @@
 				    agp_aper_base == aper_base &&
 				    agp_aper_order == aper_order) {
 					/* the same between two setting from NB and agp */
-					if (!no_iommu && end_pfn > MAX_DMA32_PFN && !printed_gart_size_msg) {
+					if (!no_iommu && num_physpages > MAX_DMA32_PFN && !printed_gart_size_msg) {
 						printk(KERN_ERR "you are using iommu with agp, but GART size is less than 64M\n");
 						printk(KERN_ERR "please increase GART size in your BIOS setup\n");
 						printk(KERN_ERR "if BIOS doesn't have that option, contact your HW vendor!\n");
@@ -448,7 +448,7 @@
 		/* Got the aperture from the AGP bridge */
 	} else if (swiotlb && !valid_agp) {
 		/* Do nothing */
-	} else if ((!no_iommu && end_pfn > MAX_DMA32_PFN) ||
+	} else if ((!no_iommu && num_physpages > MAX_DMA32_PFN) ||
 		   force_iommu ||
 		   valid_agp ||
 		   fallback_aper_force) {
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -516,7 +516,7 @@
 
 #ifdef CONFIG_X86_64
 	if (!found) {
-		gapstart = (end_pfn << PAGE_SHIFT) + 1024*1024;
+		gapstart = (num_physpages << PAGE_SHIFT) + 1024*1024;
 		printk(KERN_ERR "PCI: Warning: Cannot find a gap in the 32bit "
 		       "address range\n"
 		       KERN_ERR "PCI: Unassigned devices with 32bit resource "
diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -50,7 +50,7 @@
 static void __init via_bugs(int  num, int slot, int func)
 {
 #ifdef CONFIG_GART_IOMMU
-	if ((end_pfn > MAX_DMA32_PFN ||  force_iommu) &&
+	if ((num_physpages > MAX_DMA32_PFN ||  force_iommu) &&
 	    !gart_iommu_aperture_allowed) {
 		printk(KERN_INFO
 		       "Looks like a VIA chipset. Disabling IOMMU."
diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -112,7 +112,7 @@
 {
 	pgd_t *level4p;
 	level4p = (pgd_t *)__va(start_pgtable);
- 	return init_level4_page(image, level4p, 0, end_pfn << PAGE_SHIFT);
+ 	return init_level4_page(image, level4p, 0, num_physpages << PAGE_SHIFT);
 }
 
 static void set_idt(void *newidt, u16 limit)
diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -1394,7 +1394,7 @@
 		return;
 	}
 
-	specified_table_size = determine_tce_table_size(end_pfn * PAGE_SIZE);
+	specified_table_size = determine_tce_table_size(num_physpages * PAGE_SIZE);
 
 	for (bus = 0; bus < MAX_PHB_BUS_NUM; bus++) {
 		struct calgary_bus_info *info = &bus_info[bus];
@@ -1459,7 +1459,7 @@
 	if (ret) {
 		printk(KERN_ERR "PCI-DMA: Calgary init failed %d, "
 		       "falling back to no_iommu\n", ret);
-		if (end_pfn > MAX_DMA32_PFN)
+		if (num_physpages > MAX_DMA32_PFN)
 			printk(KERN_ERR "WARNING more than 4GB of memory, "
 					"32bit PCI may malfunction.\n");
 		return ret;
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -74,7 +74,7 @@
 void __init dma32_reserve_bootmem(void)
 {
 	unsigned long size, align;
-	if (end_pfn <= MAX_DMA32_PFN)
+	if (num_physpages <= MAX_DMA32_PFN)
 		return;
 
 	/*
@@ -93,7 +93,7 @@
 static void __init dma32_free_bootmem(void)
 {
 
-	if (end_pfn <= MAX_DMA32_PFN)
+	if (num_physpages <= MAX_DMA32_PFN)
 		return;
 
 	if (!dma32_bootmem_ptr)
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -752,10 +752,10 @@
 		return;
 
 	if (no_iommu ||
-	    (!force_iommu && end_pfn <= MAX_DMA32_PFN) ||
+	    (!force_iommu && num_physpages <= MAX_DMA32_PFN) ||
 	    !gart_iommu_aperture ||
 	    (no_agp && init_k8_gatt(&info) < 0)) {
-		if (end_pfn > MAX_DMA32_PFN) {
+		if (num_physpages > MAX_DMA32_PFN) {
 			printk(KERN_WARNING "More than 4GB of memory "
 			       	          "but GART IOMMU not available.\n"
 			       KERN_WARNING "falling back to iommu=soft.\n");
diff --git a/arch/x86/kernel/pci-swiotlb_64.c b/arch/x86/kernel/pci-swiotlb_64.c
--- a/arch/x86/kernel/pci-swiotlb_64.c
+++ b/arch/x86/kernel/pci-swiotlb_64.c
@@ -38,7 +38,7 @@
 void __init pci_swiotlb_init(void)
 {
 	/* don't initialize swiotlb if iommu=off (no_iommu=1) */
-	if (!iommu_detected && !no_iommu && end_pfn > MAX_DMA32_PFN)
+	if (!iommu_detected && !no_iommu && num_physpages > MAX_DMA32_PFN)
 	       swiotlb = 1;
 	if (swiotlb_force)
 		swiotlb = 1;
diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -161,7 +161,7 @@
 		unsigned long ramdisk_image = boot_params.hdr.ramdisk_image;
 		unsigned long ramdisk_size  = boot_params.hdr.ramdisk_size;
 		unsigned long ramdisk_end   = ramdisk_image + ramdisk_size;
-		unsigned long end_of_mem    = end_pfn << PAGE_SHIFT;
+		unsigned long end_of_mem    = num_physpages << PAGE_SHIFT;
 
 		if (ramdisk_end <= end_of_mem) {
 			/*
@@ -267,25 +267,23 @@
 	 * partially used pages are not usable - thus
 	 * we are rounding upwards:
 	 */
-	end_pfn = e820_end_of_ram();
+	num_physpages = e820_end_of_ram();
 
 	/* pre allocte 4k for mptable mpc */
 	early_reserve_e820_mpc_new();
 	/* update e820 for memory not covered by WB MTRRs */
 	mtrr_bp_init();
-	if (mtrr_trim_uncached_memory(end_pfn)) {
+	if (mtrr_trim_uncached_memory(num_physpages)) {
 		remove_all_active_ranges();
 		e820_register_active_regions(0, 0, -1UL);
-		end_pfn = e820_end_of_ram();
+		num_physpages = e820_end_of_ram();
 	}
 
 	reserve_initrd();
 
-	num_physpages = end_pfn;
-
 	check_efer();
 
-	max_pfn_mapped = init_memory_mapping(0, (end_pfn << PAGE_SHIFT));
+	max_pfn_mapped = init_memory_mapping(0, (num_physpages << PAGE_SHIFT));
 
 	vsmp_init();
 
@@ -300,9 +298,9 @@
 	acpi_boot_table_init();
 
 	/* How many end-of-memory variables you have, grandma! */
-	max_low_pfn = end_pfn;
-	max_pfn = end_pfn;
-	high_memory = (void *)__va(end_pfn * PAGE_SIZE - 1) + 1;
+	max_low_pfn = num_physpages;
+	max_pfn = num_physpages;
+	high_memory = (void *)__va(num_physpages * PAGE_SIZE - 1) + 1;
 
 	/* Remove active ranges so rediscovery with NUMA-awareness happens */
 	remove_all_active_ranges();
@@ -314,7 +312,7 @@
 	acpi_numa_init();
 #endif
 
-	initmem_init(0, end_pfn);
+	initmem_init(0, num_physpages);
 
 	dma32_reserve_bootmem();
 
@@ -366,7 +364,7 @@
 	 * We trust e820 completely. No explicit ROM probing in memory.
 	 */
 	e820_reserve_resources();
-	e820_mark_nosave_regions(end_pfn);
+	e820_mark_nosave_regions(num_physpages);
 
 	reserve_standard_io_resources();
 
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -240,7 +240,7 @@
 		return adr;
 	}
 
-	if (pfn >= end_pfn)
+	if (pfn >= num_physpages)
 		panic("alloc_low_page: ran out of memory");
 
 	adr = early_ioremap(pfn * PAGE_SIZE, PAGE_SIZE);
@@ -584,9 +584,9 @@
 	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
 	max_zone_pfns[ZONE_DMA] = MAX_DMA_PFN;
 	max_zone_pfns[ZONE_DMA32] = MAX_DMA32_PFN;
-	max_zone_pfns[ZONE_NORMAL] = end_pfn;
+	max_zone_pfns[ZONE_NORMAL] = num_physpages;
 
-	memory_present(0, 0, end_pfn);
+	memory_present(0, 0, num_physpages);
 	sparse_init();
 	free_area_init_nodes(max_zone_pfns);
 }
@@ -668,8 +668,8 @@
 #else
 	totalram_pages = free_all_bootmem();
 #endif
-	reservedpages = end_pfn - totalram_pages -
-					absent_pages_in_range(0, end_pfn);
+	reservedpages = num_physpages - totalram_pages -
+					absent_pages_in_range(0, num_physpages);
 	after_bootmem = 1;
 
 	codesize =  (unsigned long) &_etext - (unsigned long) &_text;
@@ -688,7 +688,7 @@
 	printk(KERN_INFO "Memory: %luk/%luk available (%ldk kernel code, "
 				"%ldk reserved, %ldk data, %ldk init)\n",
 		(unsigned long) nr_free_pages() << (PAGE_SHIFT-10),
-		end_pfn << (PAGE_SHIFT-10),
+		num_physpages << (PAGE_SHIFT-10),
 		codesize >> 10,
 		reservedpages << (PAGE_SHIFT-10),
 		datasize >> 10,
@@ -788,7 +788,7 @@
 #endif
 	unsigned long pfn = phys >> PAGE_SHIFT;
 
-	if (pfn >= end_pfn) {
+	if (pfn >= num_physpages) {
 		/*
 		 * This can happen with kdump kernels when accessing
 		 * firmware tables:
diff --git a/arch/x86/mm/k8topology_64.c b/arch/x86/mm/k8topology_64.c
--- a/arch/x86/mm/k8topology_64.c
+++ b/arch/x86/mm/k8topology_64.c
@@ -143,8 +143,8 @@
 		limit |= (1<<24)-1;
 		limit++;
 
-		if (limit > end_pfn << PAGE_SHIFT)
-			limit = end_pfn << PAGE_SHIFT;
+		if (limit > num_physpages << PAGE_SHIFT)
+			limit = num_physpages << PAGE_SHIFT;
 		if (limit <= base)
 			continue;
 
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -86,7 +86,7 @@
 
 	addr = 0x8000;
 	nodemap_size = round_up(sizeof(s16) * memnodemapsize, L1_CACHE_BYTES);
-	nodemap_addr = find_e820_area(addr, end_pfn<<PAGE_SHIFT,
+	nodemap_addr = find_e820_area(addr, num_physpages<<PAGE_SHIFT,
 				      nodemap_size, L1_CACHE_BYTES);
 	if (nodemap_addr == -1UL) {
 		printk(KERN_ERR
@@ -579,7 +579,7 @@
 	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
 	max_zone_pfns[ZONE_DMA] = MAX_DMA_PFN;
 	max_zone_pfns[ZONE_DMA32] = MAX_DMA32_PFN;
-	max_zone_pfns[ZONE_NORMAL] = end_pfn;
+	max_zone_pfns[ZONE_NORMAL] = num_physpages;
 
 	sparse_memory_present_with_active_regions(MAX_NUMNODES);
 	sparse_init();
diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -299,7 +299,7 @@
 			pxmram = 0;
 	}
 
-	e820ram = end_pfn - absent_pages_in_range(0, end_pfn);
+	e820ram = num_physpages - absent_pages_in_range(0, num_physpages);
 	/* We seem to lose 3 pages somewhere. Allow a bit of slack. */
 	if ((long)(e820ram - pxmram) >= 1*1024*1024) {
 		printk(KERN_ERR
diff --git a/arch/x86/power/hibernate_64.c b/arch/x86/power/hibernate_64.c
--- a/arch/x86/power/hibernate_64.c
+++ b/arch/x86/power/hibernate_64.c
@@ -83,7 +83,7 @@
 
 	/* Set up the direct mapping from scratch */
 	start = (unsigned long)pfn_to_kaddr(0);
-	end = (unsigned long)pfn_to_kaddr(end_pfn);
+	end = (unsigned long)pfn_to_kaddr(num_physpages);
 
 	for (; start < end; start = next) {
 		pud_t *pud = (pud_t *)get_safe_page(GFP_ATOMIC);
diff --git a/include/asm-x86/page_64.h b/include/asm-x86/page_64.h
--- a/include/asm-x86/page_64.h
+++ b/include/asm-x86/page_64.h
@@ -58,7 +58,6 @@
 void clear_page(void *page);
 void copy_page(void *to, void *from);
 
-extern unsigned long end_pfn;
 extern unsigned long phys_base;
 
 extern unsigned long __phys_addr(unsigned long);
@@ -87,7 +86,7 @@
 #endif	/* !__ASSEMBLY__ */
 
 #ifdef CONFIG_FLATMEM
-#define pfn_valid(pfn)          ((pfn) < end_pfn)
+#define pfn_valid(pfn)          ((pfn) < num_physpages)
 #endif
 
 


