Return-Path: <linux-kernel-owner+w=401wt.eu-S1759798AbYFXLJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759798AbYFXLJl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 07:09:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbYFXLJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 07:09:33 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:18364 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbYFXLJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 07:09:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=V+ruDrFRJRNPn0kEetQcM8p26Bq2vNX24niXKUaHM7lAIbghfRaybp2PWNMBUjm7OW
         ljoa26cItW9ELFSooKTp2ZheVEmAoFs/sNLjOL7TNHRzclgua/afocftdr9o3y+I+fV1
         dzJKr7kgXLIMJSn3MAkQfbXKCqGTVnEi6cZT0=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: introduce init_memory_mapping for 32bit
Date: Tue, 24 Jun 2008 04:10:47 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806231951.10898.yhlu.kernel@gmail.com>
In-Reply-To: <200806231951.10898.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806240410.47856.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



so could use mem below max_low_pfn as early.
could move several function more early instead of waiting after
paging_init
including moving relocate_initrd early, and kva related early done
in initmem_init

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>


---
 arch/x86/kernel/setup_32.c |   32 +++------
 arch/x86/mm/discontig_32.c |    8 +-
 arch/x86/mm/init_32.c      |  154 +++++++++++++++++++++++++++++++--------------
 include/asm-x86/numa_32.h  |    5 -
 include/asm-x86/page_32.h  |    2 
 include/asm-x86/setup.h    |    1 
 6 files changed, 128 insertions(+), 74 deletions(-)

Index: linux-2.6/arch/x86/kernel/setup_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_32.c
+++ linux-2.6/arch/x86/kernel/setup_32.c
@@ -187,7 +187,7 @@ static inline void copy_edd(void)
 
 #ifdef CONFIG_BLK_DEV_INITRD
 
-static bool do_relocate_initrd = false;
+static void __init relocate_initrd(void);
 
 static void __init reserve_initrd(void)
 {
@@ -196,7 +196,6 @@ static void __init reserve_initrd(void)
 	u64 ramdisk_end   = ramdisk_image + ramdisk_size;
 	u64 end_of_lowmem = max_low_pfn << PAGE_SHIFT;
 	u64 ramdisk_here;
-	u64 ramdisk_target;
 
 	if (!boot_params.hdr.type_of_loader ||
 	    !ramdisk_image || !ramdisk_size)
@@ -227,10 +226,8 @@ static void __init reserve_initrd(void)
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
@@ -245,12 +242,12 @@ static void __init reserve_initrd(void)
 	printk(KERN_INFO "Allocated new RAMDISK: %08llx - %08llx\n",
 			 ramdisk_here, ramdisk_here + ramdisk_size);
 
-	do_relocate_initrd = true;
+	relocate_initrd();
 }
 
 #define MAX_MAP_CHUNK	(NR_FIX_BTMAPS << PAGE_SHIFT)
 
-void __init post_reserve_initrd(void)
+static void __init relocate_initrd(void)
 {
 	u64 ramdisk_image = boot_params.hdr.ramdisk_image;
 	u64 ramdisk_size  = boot_params.hdr.ramdisk_size;
@@ -259,9 +256,6 @@ void __init post_reserve_initrd(void)
 	unsigned long slop, clen, mapaddr;
 	char *p, *q;
 
-	if (!do_relocate_initrd)
-		return;
-
 	ramdisk_here = initrd_start - PAGE_OFFSET;
 
 	q = (char *)initrd_start;
@@ -272,10 +266,6 @@ void __init post_reserve_initrd(void)
 		p = (char *)__va(ramdisk_image);
 		memcpy(q, p, clen);
 		q += clen;
-		/* need to free these low pages...*/
-		printk(KERN_INFO "Freeing old partial RAMDISK %08llx-%08llx\n",
-			 ramdisk_image, ramdisk_image + clen - 1);
-		free_bootmem(ramdisk_image, clen);
 		ramdisk_image += clen;
 		ramdisk_size  -= clen;
 	}
@@ -301,16 +291,16 @@ void __init post_reserve_initrd(void)
 		ramdisk_image, ramdisk_image + ramdisk_size - 1,
 		ramdisk_here, ramdisk_here + ramdisk_size - 1);
 
-	/* need to free that, otherwise init highmem will reserve it again */
+	/*
+	 * need to free old one, otherwise init cross max_low_pfn could be
+	 * converted to bootmem
+	 */
 	free_early(ramdisk_image, ramdisk_image+ramdisk_size);
 }
 #else
 void __init reserve_initrd(void)
 {
 }
-void __init post_reserve_initrd(void)
-{
-}
 #endif /* CONFIG_BLK_DEV_INITRD */
 
 #ifdef CONFIG_MCA
@@ -439,8 +429,12 @@ void __init setup_arch(char **cmdline_p)
 		max_pfn = e820_end_of_ram();
 	}
 
+	/* max_low_pfn get updated here */
 	find_low_pfn_range();
 
+	/* max_pfn_mapped is updated here*/
+	init_memory_mapping(0, (max_low_pfn << PAGE_SHIFT));
+
 	reserve_initrd();
 
 	dmi_scan_machine();
Index: linux-2.6/arch/x86/mm/discontig_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/discontig_32.c
+++ linux-2.6/arch/x86/mm/discontig_32.c
@@ -200,7 +200,7 @@ void *alloc_remap(int nid, unsigned long
 	return allocation;
 }
 
-void __init remap_numa_kva(void)
+static void __init remap_numa_kva(void)
 {
 	void *vaddr;
 	unsigned long pfn;
@@ -373,12 +373,16 @@ void __init initmem_init(unsigned long s
 
 		allocate_pgdat(nid);
 	}
+	remap_numa_kva();
+
 	printk(KERN_DEBUG "High memory starts at vaddr %08lx\n",
 			(ulong) pfn_to_kaddr(highstart_pfn));
 	for_each_online_node(nid)
 		propagate_e820_map_node(nid);
 
-	memset(NODE_DATA(0), 0, sizeof(struct pglist_data));
+	for_each_online_node(nid)
+		memset(NODE_DATA(nid), 0, sizeof(struct pglist_data));
+
 	NODE_DATA(0)->bdata = &node0_bdata;
 	setup_bootmem_allocator();
 }
Index: linux-2.6/arch/x86/mm/init_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_32.c
+++ linux-2.6/arch/x86/mm/init_32.c
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
 
@@ -418,20 +449,6 @@ static void __init pagetable_init(void)
 
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
-	remap_numa_kva();
-
 	/*
 	 * Fixed mappings, only the page table structure has to be
 	 * created - mappings will be set by set_fixmap():
@@ -703,24 +720,78 @@ void __init setup_bootmem_allocator(void
 		free_bootmem_with_active_regions(i, max_low_pfn);
 	early_res_to_bootmem(0, max_low_pfn<<PAGE_SHIFT);
 
+	after_init_bootmem = 1;
 }
 
-/*
- * The node 0 pgdat is initialized before all of these because
- * it's needed for bootmem.  node>0 pgdats have their virtual
- * space allocated before the pagetables are in place to access
- * them, so they can't be cleared then.
- *
- * This should all compile down to nothing when NUMA is off.
- */
-static void __init remapped_pgdat_init(void)
+static void __init find_early_table_space(unsigned long end)
 {
-	int nid;
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
 
-	for_each_online_node(nid) {
-		if (nid != 0)
-			memset(NODE_DATA(nid), 0, sizeof(struct pglist_data));
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
 	}
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
 }
 
 /*
@@ -732,15 +803,8 @@ static void __init remapped_pgdat_init(v
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
@@ -748,10 +812,6 @@ void __init paging_init(void)
 	/*
 	 * NOTE: at this point the bootmem allocator is fully available.
 	 */
-
-	post_reserve_initrd();
-
-	remapped_pgdat_init();
 	sparse_init();
 	zone_sizes_init();
 
Index: linux-2.6/include/asm-x86/numa_32.h
===================================================================
--- linux-2.6.orig/include/asm-x86/numa_32.h
+++ linux-2.6/include/asm-x86/numa_32.h
@@ -5,12 +5,7 @@ extern int pxm_to_nid(int pxm);
 extern void numa_remove_cpu(int cpu);
 
 #ifdef CONFIG_NUMA
-extern void __init remap_numa_kva(void);
 extern void set_highmem_pages_init(void);
-#else
-static inline void remap_numa_kva(void)
-{
-}
 #endif
 
 #endif /* _ASM_X86_32_NUMA_H */
Index: linux-2.6/include/asm-x86/page_32.h
===================================================================
--- linux-2.6.orig/include/asm-x86/page_32.h
+++ linux-2.6/include/asm-x86/page_32.h
@@ -93,6 +93,8 @@ extern int sysctl_legacy_va_layout;
 #define MAXMEM			(-__PAGE_OFFSET - __VMALLOC_RESERVE)
 
 extern void find_low_pfn_range(void);
+extern unsigned long init_memory_mapping(unsigned long start,
+					 unsigned long end);
 extern void initmem_init(unsigned long, unsigned long);
 extern void zone_sizes_init(void);
 extern void setup_bootmem_allocator(void);
Index: linux-2.6/include/asm-x86/setup.h
===================================================================
--- linux-2.6.orig/include/asm-x86/setup.h
+++ linux-2.6/include/asm-x86/setup.h
@@ -39,7 +39,6 @@ void reserve_crashkernel(void);
 #include <asm/bootparam.h>
 
 void reserve_standard_io_resources(void);
-extern void post_reserve_initrd(void);
 
 #ifndef _SETUP
 
