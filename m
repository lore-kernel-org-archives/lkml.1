Return-Path: <linux-kernel-owner+w=401wt.eu-S1751762AbXJUQyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762AbXJUQyY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 12:54:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751665AbXJUQxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 12:53:48 -0400
Received: from il.qumranet.com ([82.166.9.18]:50927 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751534AbXJUQxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 12:53:42 -0400
Date: Sun, 21 Oct 2007 18:54:01 +0200
From: Or Sagi <ors@tutis.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Nir Peleg <nir@tutis.com>
Subject: [PATCH] Reserve low memory
Message-ID: <20071021165401.GA8626@cleopatra.qumranet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adds a CONFIG_RESERVE_LOWMEM option which reserves all memory below
CONFIG_PHYSICAL_START address.

Cleans up some of the static early-boot memory allocations (nodemap, trampoline)
Useful in particular for running virtual machines which require a 1:1 mapping 
of the physical memory. This lets a virtual machine control a dma-capable device
directly without hypervisor involvement.

Signed-off-by: Or Sagi <ors@tutis.com>
---
 arch/x86/kernel/e820_64.c    |   11 +++++++++++
 arch/x86/kernel/head_64.S    |    8 ++++----
 arch/x86/kernel/setup_64.c   |    3 +++
 arch/x86/kernel/suspend_64.c |    2 +-
 arch/x86/mm/init_64.c        |   11 ++++++++++-
 arch/x86/mm/numa_64.c        |   12 ++++++++++++
 arch/x86/mm/pageattr_64.c    |    4 ++--
 arch/x86_64/Kconfig          |   10 +++++++++-
 include/asm-x86/page_64.h    |    7 ++++++-
 include/asm-x86/pgtable_64.h |    2 +-
 init/initramfs.c             |    6 +++++-
 11 files changed, 64 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/e820_64.c b/arch/x86/kernel/e820_64.c
index 5761686..29b927a 100644
--- a/arch/x86/kernel/e820_64.c
+++ b/arch/x86/kernel/e820_64.c
@@ -49,6 +49,14 @@ static unsigned long __initdata end_user_pfn = MAXMEM>>PAGE_SHIFT;
 
 extern struct resource code_resource, data_resource;
 
+#ifdef CONFIG_RESERVE_LOWMEM
+static struct resource lowmem_res = {
+				.start = 1024*1024,
+				.end = CONFIG_PHYSICAL_START - 1,
+				.name = "reserved low memory"
+};
+#endif
+
 /* Check for some hardcoded bad areas that early boot is not allowed to touch */ 
 static inline int bad_addr(unsigned long *addrp, unsigned long size)
 { 
@@ -229,6 +237,9 @@ void __init e820_reserve_resources(void)
 			if (crashk_res.start != crashk_res.end)
 				request_resource(res, &crashk_res);
 #endif
+#ifdef CONFIG_RESERVE_LOWMEM
+			request_resource(res, &lowmem_res);
+#endif
 		}
 	}
 }
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index b6167fe..9fd2be0 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -342,12 +342,12 @@ NEXT_PAGE(level2_ident_pgt)
 	PMDS(0x0000000000000000, __PAGE_KERNEL_LARGE_EXEC, PTRS_PER_PMD)
 
 NEXT_PAGE(level2_kernel_pgt)
-	/* 40MB kernel mapping. The kernel code cannot be bigger than that.
-	   When you change this change KERNEL_TEXT_SIZE in page.h too. */
+	/* kernel mapping. The kernel code cannot be bigger than that.
+	   When you change this change KERNEL_TEXT_TOP in page.h too. */
 	/* (2^48-(2*1024*1024*1024)-((2^39)*511)-((2^30)*510)) = 0 */
-	PMDS(0x0000000000000000, __PAGE_KERNEL_LARGE_EXEC|_PAGE_GLOBAL, KERNEL_TEXT_SIZE/PMD_SIZE)
+	PMDS(0x0000000000000000, __PAGE_KERNEL_LARGE_EXEC|_PAGE_GLOBAL, KERNEL_TEXT_TOP/PMD_SIZE)
 	/* Module mapping starts here */
-	.fill	(PTRS_PER_PMD - (KERNEL_TEXT_SIZE/PMD_SIZE)),8,0
+	.fill	(PTRS_PER_PMD - (KERNEL_TEXT_TOP/PMD_SIZE)),8,0
 
 NEXT_PAGE(level2_spare_pgt)
 	.fill   512,8,0
diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
index 31322d4..7db301e 100644
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -363,6 +363,9 @@ void __init setup_arch(char **cmdline_p)
 	/* Reserve SMP trampoline */
 	reserve_bootmem_generic(SMP_TRAMPOLINE_BASE, 2*PAGE_SIZE);
 #endif
+#ifdef CONFIG_RESERVE_LOWMEM
+	reserve_bootmem_generic(0x100000, CONFIG_PHYSICAL_START - 0x100000 + 1);
+#endif
 
 #ifdef CONFIG_ACPI_SLEEP
        /*
diff --git a/arch/x86/kernel/suspend_64.c b/arch/x86/kernel/suspend_64.c
index bc9f59c..1f17db7 100644
--- a/arch/x86/kernel/suspend_64.c
+++ b/arch/x86/kernel/suspend_64.c
@@ -207,7 +207,7 @@ static int res_kernel_text_pud_init(pud_t *pud, unsigned long start)
 	if (!pmd)
 		return -ENOMEM;
 	set_pud(pud + pud_index(start), __pud(__pa(pmd) | _KERNPG_TABLE));
-	for (paddr = 0; paddr < KERNEL_TEXT_SIZE; pmd++, paddr += PMD_SIZE) {
+	for (paddr = 0; paddr < KERNEL_TEXT_TOP; pmd++, paddr += PMD_SIZE) {
 		unsigned long pe;
 
 		pe = __PAGE_KERNEL_LARGE_EXEC | _PAGE_GLOBAL | paddr;
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 1e3862e..4f320d2 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -329,7 +329,11 @@ static void __init find_early_table_space(unsigned long end)
  	/* RED-PEN putting page tables only on node 0 could
  	   cause a hotspot and fill up ZONE_DMA. The page tables
  	   need roughly 0.5KB per GB. */
- 	start = 0x8000;
+#ifdef CONFIG_RESERVE_LOWMEM
+	start = CONFIG_PHYSICAL_START;
+#else
+	start = 0x8000;
+#endif
  	table_start = find_e820_area(start, end, tables);
 	if (table_start == -1UL)
 		panic("Cannot find space for the kernel page tables");
@@ -526,6 +530,11 @@ void __init mem_init(void)
 
 	reservedpages = 0;
 
+#ifdef CONFIG_RESERVE_LOWMEM
+	/* see also mm/numa.c:allocate_cachealigned_memnodemap. */
+	reserve_bootmem_generic(0, 0xa0000);
+#endif
+
 	/* this will put all low memory onto the freelists */
 #ifdef CONFIG_NUMA
 	totalram_pages = numa_free_all_bootmem();
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 3d6926b..70940b6 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -82,7 +82,11 @@ static int __init allocate_cachealigned_memnodemap(void)
 		return 0;
 
 	pad = L1_CACHE_BYTES - 1;
+#ifdef CONFIG_RESERVE_LOWMEM
+	pad_addr = CONFIG_PHYSICAL_START + 0x8000;
+#else
 	pad_addr = 0x8000;
+#endif
 	nodemap_size = pad + memnodemapsize;
 	nodemap_addr = find_e820_area(pad_addr, end_pfn<<PAGE_SHIFT,
 				      nodemap_size);
@@ -189,7 +193,15 @@ void __init setup_node_bootmem(int nodeid, unsigned long start, unsigned long en
 	start_pfn = start >> PAGE_SHIFT;
 	end_pfn = end >> PAGE_SHIFT;
 
+#ifdef CONFIG_RESERVE_LOWMEM
+	{
+		unsigned long s = start;
+		if (s < CONFIG_PHYSICAL_START) s += CONFIG_PHYSICAL_START;
+		node_data[nodeid] = early_node_mem(nodeid, s, end, pgdat_size);
+	}
+#else
 	node_data[nodeid] = early_node_mem(nodeid, start, end, pgdat_size);
+#endif
 	if (node_data[nodeid] == NULL)
 		return;
 	nodedata_phys = __pa(node_data[nodeid]);
diff --git a/arch/x86/mm/pageattr_64.c b/arch/x86/mm/pageattr_64.c
index c7b7dfe..158a448 100644
--- a/arch/x86/mm/pageattr_64.c
+++ b/arch/x86/mm/pageattr_64.c
@@ -188,7 +188,7 @@ int change_page_attr_addr(unsigned long address, int numpages, pgprot_t prot)
 	int i; 
 
 	if (address >= __START_KERNEL_map
-	    && address < __START_KERNEL_map + KERNEL_TEXT_SIZE) {
+	    && address < __START_KERNEL_map + KERNEL_TEXT_TOP) {
 		address = (unsigned long)__va(__pa(address));
 		kernel_map = 1;
 	}
@@ -204,7 +204,7 @@ int change_page_attr_addr(unsigned long address, int numpages, pgprot_t prot)
 		}
 		/* Handle kernel mapping too which aliases part of the
 		 * lowmem */
-		if (__pa(address) < KERNEL_TEXT_SIZE) {
+		if (__pa(address) < KERNEL_TEXT_TOP) {
 			unsigned long addr2;
 			pgprot_t prot2;
 			addr2 = __START_KERNEL_map + __pa(address);
diff --git a/arch/x86_64/Kconfig b/arch/x86_64/Kconfig
index aab25f3..391f4e0 100644
--- a/arch/x86_64/Kconfig
+++ b/arch/x86_64/Kconfig
@@ -576,6 +576,14 @@ config KEXEC
 	  support.  As of this writing the exact hardware interface is
 	  strongly in flux, so no good recommendation can be made.
 
+config RESERVE_LOWMEM
+	bool "Reserve memory below CONFIG_PHYSICAL_START (EXPERIMENTAL)"
+	depends on EXPERIMENTAL && !RELOCATABLE && !CRASH_DUMP
+	help
+	  Does not make use of memory below CONFIG_PHYSICAL_START.
+	  This is work in progress, and low memory may still be used
+	  or run over during bootstrap and/or shutdown.
+
 config CRASH_DUMP
 	bool "kernel crash dumps (EXPERIMENTAL)"
 	depends on EXPERIMENTAL
@@ -607,7 +615,7 @@ config RELOCATABLE
 	  (CONFIG_PHYSICAL_START) is ignored.
 
 config PHYSICAL_START
-	hex "Physical address where the kernel is loaded" if (EMBEDDED || CRASH_DUMP)
+	hex "Physical address where the kernel is loaded" if (EMBEDDED || CRASH_DUMP || RESERVE_LOWMEM)
 	default "0x200000"
 	help
 	  This gives the physical address where the kernel is loaded. It
diff --git a/include/asm-x86/page_64.h b/include/asm-x86/page_64.h
index c3b52bc..e25221e 100644
--- a/include/asm-x86/page_64.h
+++ b/include/asm-x86/page_64.h
@@ -103,7 +103,12 @@ extern unsigned long phys_base;
 #define __VIRTUAL_MASK_SHIFT	48
 #define __VIRTUAL_MASK		((_AC(1,UL) << __VIRTUAL_MASK_SHIFT) - 1)
 
-#define KERNEL_TEXT_SIZE  (40*1024*1024)
+/*
+ * This used to be called KERNEL_TEXT_SIZE, which it never was.
+ * Note that going beond 1GB requires code modifications
+ * (arch/x86_64/kernel/head.S)
+ */
+#define KERNEL_TEXT_TOP  (576*1024*1024)
 #define KERNEL_TEXT_START _AC(0xffffffff80000000, UL)
 #define PAGE_OFFSET		__PAGE_OFFSET
 
diff --git a/include/asm-x86/pgtable_64.h b/include/asm-x86/pgtable_64.h
index 9b0ff47..26cc42e 100644
--- a/include/asm-x86/pgtable_64.h
+++ b/include/asm-x86/pgtable_64.h
@@ -138,7 +138,7 @@ static inline pte_t ptep_get_and_clear_full(struct mm_struct *mm, unsigned long
 #define VMALLOC_START    _AC(0xffffc20000000000, UL)
 #define VMALLOC_END      _AC(0xffffe1ffffffffff, UL)
 #define VMEMMAP_START	 _AC(0xffffe20000000000, UL)
-#define MODULES_VADDR    _AC(0xffffffff88000000, UL)
+#define MODULES_VADDR    _AC(0xffffffffa8000000, UL)
 #define MODULES_END      _AC(0xfffffffffff00000, UL)
 #define MODULES_LEN   (MODULES_END - MODULES_VADDR)
 
diff --git a/init/initramfs.c b/init/initramfs.c
index 1db02a0..c0a36df 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -513,10 +513,14 @@ static void __init free_initrd(void)
 	unsigned long crashk_start = (unsigned long)__va(crashk_res.start);
 	unsigned long crashk_end   = (unsigned long)__va(crashk_res.end);
 #endif
+#ifdef CONFIG_RESERVE_LOWMEM
+	unsigned long crashk_start = 1024*1024;
+	unsigned long crashk_end   = CONFIG_PHYSICAL_START - 1;
+#endif
 	if (do_retain_initrd)
 		goto skip;
 
-#ifdef CONFIG_KEXEC
+#if defined(CONFIG_KEXEC) || defined(CONFIG_RESERVE_LOWMEM)
 	/*
 	 * If the initrd region is overlapped with crashkernel reserved region,
 	 * free only memory that is not part of crashkernel region.
-- 
1.5.0

