Return-Path: <linux-kernel-owner+w=401wt.eu-S1755478AbYFXTSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478AbYFXTSl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 15:18:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754927AbYFXTS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 15:18:28 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:46551 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965AbYFXTS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 15:18:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=o8QoOJhuubJb/dF2stR0PlxM6t1+kfRrwVc63VpCXnpsS8yO2rYB8BAvW5bgH98QNn
         sX6t0gbu54+HhkL12Iy4uDovOwiRHndWwWxdEEdgeC2dotGscElmrNQWTWNycWRibM+h
         ive8id3zygqRBzGLhi6zFnSj7OUV7RPz7uqe0=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: introduce init_memory_mapping for 32bit #1
Date: Tue, 24 Jun 2008 12:18:14 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806231951.10898.yhlu.kernel@gmail.com> <200806240410.47856.yhlu.kernel@gmail.com>
In-Reply-To: <200806240410.47856.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806241218.14436.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


so could use mem below max_low_pfn as early.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/setup_32.c |   10 +--
 arch/x86/mm/init_32.c      |  141 +++++++++++++++++++++++++++++++++++----------
 include/asm-x86/page_32.h  |    2 
 3 files changed, 120 insertions(+), 33 deletions(-)

Index: xy/arch/x86/kernel/setup_32.c
===================================================================
--- xy.orig/arch/x86/kernel/setup_32.c
+++ xy/arch/x86/kernel/setup_32.c
@@ -227,10 +227,8 @@ static void __init reserve_initrd(void)
 	}
 
 	/* We need to move the initrd down into lowmem */
-	ramdisk_target = max_pfn_mapped<<PAGE_SHIFT;
-	ramdisk_here = find_e820_area(min(ramdisk_target, end_of_lowmem>>1),
-				 end_of_lowmem, ramdisk_size,
-				 PAGE_SIZE);
+	ramdisk_here = find_e820_area(0, end_of_lowmem, ramdisk_size,
+					 PAGE_SIZE);
 
 	if (ramdisk_here == -1ULL)
 		panic("Cannot find place for new RAMDISK of size %lld\n",
@@ -440,8 +438,12 @@ void __init setup_arch(char **cmdline_p)
 		max_pfn = e820_end_of_ram();
 	}
 
+	/* max_low_pfn get updated here */
 	find_low_pfn_range();
 
+	/* max_pfn_mapped is updated here*/
+	init_memory_mapping(0, (max_low_pfn << PAGE_SHIFT));
+
 	reserve_initrd();
 
 	dmi_scan_machine();
Index: xy/arch/x86/mm/init_32.c
===================================================================
--- xy.orig/arch/x86/mm/init_32.c
+++ xy/arch/x86/mm/init_32.c
@@ -57,6 +57,27 @@ unsigned long highstart_pfn, highend_pfn
 
 static noinline int do_test_wp_bit(void);
 
+
+static unsigned long __initdata table_start;
+static unsigned long __meminitdata table_end;
+static unsigned long __meminitdata table_top;
+
+static int __initdata after_init_bootmem;
+
+static __init void *alloc_low_page(unsigned long *phys)
+{
+	unsigned long pfn = table_end++;
+	void *adr;
+
+	if (pfn >= table_top)
+		panic("alloc_low_page: ran out of memory");
+
+	adr = __va(pfn * PAGE_SIZE);
+	memset(adr, 0, PAGE_SIZE);
+	*phys  = pfn * PAGE_SIZE;
+	return adr;
+}
+
 /*
  * Creates a middle page table and puts a pointer to it in the
  * given global directory entry. This only returns the gd entry
@@ -68,9 +89,12 @@ static pmd_t * __init one_md_table_init(
 	pmd_t *pmd_table;
 
 #ifdef CONFIG_X86_PAE
+	unsigned long phys;
 	if (!(pgd_val(*pgd) & _PAGE_PRESENT)) {
-		pmd_table = (pmd_t *) alloc_bootmem_low_pages(PAGE_SIZE);
-
+		if (after_init_bootmem)
+			pmd_table = (pmd_t *)alloc_bootmem_low_pages(PAGE_SIZE);
+		else
+			pmd_table = (pmd_t *)alloc_low_page(&phys);
 		paravirt_alloc_pmd(&init_mm, __pa(pmd_table) >> PAGE_SHIFT);
 		set_pgd(pgd, __pgd(__pa(pmd_table) | _PAGE_PRESENT));
 		pud = pud_offset(pgd, 0);
@@ -92,12 +116,16 @@ static pte_t * __init one_page_table_ini
 	if (!(pmd_val(*pmd) & _PAGE_PRESENT)) {
 		pte_t *page_table = NULL;
 
+		if (after_init_bootmem) {
 #ifdef CONFIG_DEBUG_PAGEALLOC
-		page_table = (pte_t *) alloc_bootmem_pages(PAGE_SIZE);
+			page_table = (pte_t *) alloc_bootmem_pages(PAGE_SIZE);
 #endif
-		if (!page_table) {
-			page_table =
+			if (!page_table)
+				page_table =
 				(pte_t *)alloc_bootmem_low_pages(PAGE_SIZE);
+		} else {
+			unsigned long phys;
+			page_table = (pte_t *)alloc_low_page(&phys);
 		}
 
 		paravirt_alloc_pte(&init_mm, __pa(page_table) >> PAGE_SHIFT);
@@ -155,7 +183,9 @@ static inline int is_kernel_text(unsigne
  * of max_low_pfn pages, by creating page tables starting from address
  * PAGE_OFFSET:
  */
-static void __init kernel_physical_mapping_init(pgd_t *pgd_base)
+static void __init kernel_physical_mapping_init(pgd_t *pgd_base,
+						unsigned long start,
+						unsigned long end)
 {
 	int pgd_idx, pmd_idx, pte_ofs;
 	unsigned long pfn;
@@ -163,18 +193,19 @@ static void __init kernel_physical_mappi
 	pmd_t *pmd;
 	pte_t *pte;
 	unsigned pages_2m = 0, pages_4k = 0;
+	unsigned limit_pfn = end >> PAGE_SHIFT;
 
 	pgd_idx = pgd_index(PAGE_OFFSET);
 	pgd = pgd_base + pgd_idx;
-	pfn = 0;
+	pfn = start >> PAGE_SHIFT;
 
 	for (; pgd_idx < PTRS_PER_PGD; pgd++, pgd_idx++) {
 		pmd = one_md_table_init(pgd);
-		if (pfn >= max_low_pfn)
+		if (pfn >= limit_pfn)
 			continue;
 
 		for (pmd_idx = 0;
-		     pmd_idx < PTRS_PER_PMD && pfn < max_low_pfn;
+		     pmd_idx < PTRS_PER_PMD && pfn < limit_pfn;
 		     pmd++, pmd_idx++) {
 			unsigned int addr = pfn * PAGE_SIZE + PAGE_OFFSET;
 
@@ -418,20 +449,7 @@ static void __init pagetable_init(void)
 
 	paravirt_pagetable_setup_start(pgd_base);
 
-	/* Enable PSE if available */
-	if (cpu_has_pse)
-		set_in_cr4(X86_CR4_PSE);
-
-	/* Enable PGE if available */
-	if (cpu_has_pge) {
-		set_in_cr4(X86_CR4_PGE);
-		__PAGE_KERNEL |= _PAGE_GLOBAL;
-		__PAGE_KERNEL_EXEC |= _PAGE_GLOBAL;
-	}
-
-	kernel_physical_mapping_init(pgd_base);
 	remap_numa_kva();
-
 	/*
 	 * Fixed mappings, only the page table structure has to be
 	 * created - mappings will be set by set_fixmap():
@@ -703,6 +721,7 @@ void __init setup_bootmem_allocator(void
 		free_bootmem_with_active_regions(i, max_low_pfn);
 	early_res_to_bootmem(0, max_low_pfn<<PAGE_SHIFT);
 
+	after_init_bootmem = 1;
 }
 
 /*
@@ -723,6 +742,77 @@ static void __init remapped_pgdat_init(v
 	}
 }
 
+static void __init find_early_table_space(unsigned long end)
+{
+	unsigned long puds, pmds, tables, start;
+
+	puds = (end + PUD_SIZE - 1) >> PUD_SHIFT;
+	tables = PAGE_ALIGN(puds * sizeof(pud_t));
+
+	pmds = (end + PMD_SIZE - 1) >> PMD_SHIFT;
+	tables += PAGE_ALIGN(pmds * sizeof(pmd_t));
+
+	/*
+	 * RED-PEN putting page tables only on node 0 could
+	 * cause a hotspot and fill up ZONE_DMA. The page tables
+	 * need roughly 0.5KB per GB.
+	 */
+	start = 0x7000;
+	table_start = find_e820_area(start, max_pfn_mapped<<PAGE_SHIFT,
+					tables, PAGE_SIZE);
+	if (table_start == -1UL)
+		panic("Cannot find space for the kernel page tables");
+
+	table_start >>= PAGE_SHIFT;
+	table_end = table_start;
+	table_top = table_start + (tables>>PAGE_SHIFT);
+
+	printk(KERN_DEBUG "kernel direct mapping tables up to %lx @ %lx-%lx\n",
+		end, table_start << PAGE_SHIFT,
+		(table_start << PAGE_SHIFT) + tables);
+}
+
+unsigned long __init_refok init_memory_mapping(unsigned long start,
+						unsigned long end)
+{
+	pgd_t *pgd_base = swapper_pg_dir;
+
+	/*
+	 * Find space for the kernel direct mapping tables.
+	 */
+	if (!after_init_bootmem)
+		find_early_table_space(end);
+
+#ifdef CONFIG_X86_PAE
+	set_nx();
+	if (nx_enabled)
+		printk(KERN_INFO "NX (Execute Disable) protection: active\n");
+#endif
+
+	/* Enable PSE if available */
+	if (cpu_has_pse)
+		set_in_cr4(X86_CR4_PSE);
+
+	/* Enable PGE if available */
+	if (cpu_has_pge) {
+		set_in_cr4(X86_CR4_PGE);
+		__PAGE_KERNEL |= _PAGE_GLOBAL;
+		__PAGE_KERNEL_EXEC |= _PAGE_GLOBAL;
+	}
+
+	kernel_physical_mapping_init(pgd_base, start, end);
+
+	load_cr3(swapper_pg_dir);
+
+	__flush_tlb_all();
+
+	if (!after_init_bootmem)
+		reserve_early(table_start << PAGE_SHIFT,
+				 table_end << PAGE_SHIFT, "PGTABLE");
+
+	return end >> PAGE_SHIFT;
+}
+
 /*
  * paging_init() sets up the page tables - note that the first 8MB are
  * already mapped by head.S.
@@ -732,15 +822,8 @@ static void __init remapped_pgdat_init(v
  */
 void __init paging_init(void)
 {
-#ifdef CONFIG_X86_PAE
-	set_nx();
-	if (nx_enabled)
-		printk(KERN_INFO "NX (Execute Disable) protection: active\n");
-#endif
 	pagetable_init();
 
-	load_cr3(swapper_pg_dir);
-
 	__flush_tlb_all();
 
 	kmap_init();
Index: xy/include/asm-x86/page_32.h
===================================================================
--- xy.orig/include/asm-x86/page_32.h
+++ xy/include/asm-x86/page_32.h
@@ -93,6 +93,8 @@ extern int sysctl_legacy_va_layout;
 #define MAXMEM			(-__PAGE_OFFSET - __VMALLOC_RESERVE)
 
 extern void find_low_pfn_range(void);
+extern unsigned long init_memory_mapping(unsigned long start,
+					 unsigned long end);
 extern void initmem_init(unsigned long, unsigned long);
 extern void zone_sizes_init(void);
 extern void setup_bootmem_allocator(void);
