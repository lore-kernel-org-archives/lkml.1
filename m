Return-Path: <linux-kernel-owner+w=401wt.eu-S1758730AbYAJSu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758730AbYAJSu2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 13:50:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756821AbYAJSuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 13:50:11 -0500
Received: from mga11.intel.com ([192.55.52.93]:41805 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756176AbYAJSuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 13:50:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,267,1196668800"; 
   d="scan'208";a="493433334"
Message-Id: <20080110184854.787474000@intel.com>
References: <20080110184840.927409000@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 10 Jan 2008 10:48:42 -0800
From: venkatesh.pallipadi@intel.com
To: ak@muc.de, ebiederm@xmission.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, gregkh@suse.de, airlied@skynet.ie,
       davej@redhat.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com,
       davem@davemloft.net
Cc: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 02/11] PAT x86: Map only usable memory in x86_64 identity map and kernel text
Content-Disposition: inline; filename=usable_only_map.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86_64: Map only usable memory in identity map. All reserved memory maps to a
zero page. This is done later during the boot process, by pruning the
page table setup earlier to remove mappings for the reserved region. Prune
done after mem_init, so we can allocate pages as needed and before APs start.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

Index: linux-2.6.git/arch/x86/kernel/e820_64.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/e820_64.c	2008-01-08 03:41:30.000000000 -0800
+++ linux-2.6.git/arch/x86/kernel/e820_64.c	2008-01-08 04:00:59.000000000 -0800
@@ -121,6 +121,35 @@
 }
 EXPORT_SYMBOL_GPL(e820_any_mapped);
 
+int e820_any_non_reserved(unsigned long start, unsigned long end)
+{
+	int i;
+	for (i = 0; i < e820.nr_map; i++) {
+		struct e820entry *ei = &e820.map[i];
+		if (ei->type == E820_RESERVED)
+			continue;
+		if (ei->addr >= end || ei->addr + ei->size <= start)
+			continue;
+		return 1;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(e820_any_non_reserved);
+
+int is_memory_any_valid(unsigned long start, unsigned long end)
+{
+	/*
+	 * Keep low PCI/ISA area always mapped.
+	 * Note: end address is exclusive and start is inclusive here
+	 */
+	if (start >= ISA_START_ADDRESS && end <= ISA_END_ADDRESS)
+		return 1;
+
+	/* Switch to efi or e820 in future here */
+	return e820_any_non_reserved(start, end);
+}
+EXPORT_SYMBOL_GPL(is_memory_any_valid);
+
 /*
  * This function checks if the entire range <start,end> is mapped with type.
  *
@@ -156,6 +185,47 @@
 	return 0;
 }
 
+int e820_all_non_reserved(unsigned long start, unsigned long end)
+{
+	int i;
+	for (i = 0; i < e820.nr_map; i++) {
+		struct e820entry *ei = &e820.map[i];
+		if (ei->type == E820_RESERVED)
+			continue;
+
+		/* is the region (part) in overlap with the current region ?*/
+		if (ei->addr >= end || ei->addr + ei->size <= start)
+			continue;
+
+		/*
+		 * if the region is at the beginning of <start,end> we move
+		 * start to the end of the region since it's ok until there
+		 */
+		if (ei->addr <= start)
+			start = ei->addr + ei->size;
+
+		/* if start is at or beyond end, we're done, full coverage */
+		if (start >= end)
+			return 1; /* we're done */
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(e820_all_non_reserved);
+
+int is_memory_all_valid(unsigned long start, unsigned long end)
+{
+	/*
+	 * Keep low PCI/ISA area always mapped.
+ 	 * Note: end address is exclusive and start is inclusive here
+	 */
+	if (start >= ISA_START_ADDRESS && end <= ISA_END_ADDRESS)
+		return 1;
+
+	/* Switch to efi or e820 in future here */
+	return e820_all_non_reserved(start, end);
+}
+EXPORT_SYMBOL_GPL(is_memory_all_valid);
+
 /*
  * Find a free area in a specific range.
  */
Index: linux-2.6.git/arch/x86/mm/init_64.c
===================================================================
--- linux-2.6.git.orig/arch/x86/mm/init_64.c	2008-01-08 03:43:46.000000000 -0800
+++ linux-2.6.git/arch/x86/mm/init_64.c	2008-01-08 03:59:28.000000000 -0800
@@ -215,8 +215,9 @@
 	int i, pmds;
 
 	pmds = ((addr & ~PMD_MASK) + size + ~PMD_MASK) / PMD_SIZE;
-	vaddr = __START_KERNEL_map;
-	pmd = level2_kernel_pgt;
+	/* Skip PMDs meant for kernel text */
+	vaddr = __START_KERNEL_map + KERNEL_TEXT_SIZE;
+	pmd = level2_kernel_pgt + (KERNEL_TEXT_SIZE / PMD_SIZE);
 	last_pmd = level2_kernel_pgt + PTRS_PER_PMD - 1;
 	for (; pmd <= last_pmd; pmd++, vaddr += PMD_SIZE) {
 		for (i = 0; i < pmds; i++) {
@@ -299,11 +300,6 @@
 		if (addr >= end)
 			break;
 
-		if (!after_bootmem && !e820_any_mapped(addr,addr+PUD_SIZE,0)) {
-			set_pud(pud, __pud(0)); 
-			continue;
-		} 
-
 		if (pud_val(*pud)) {
 			phys_pmd_update(pud, addr, end);
 			continue;
@@ -344,6 +340,8 @@
 		(table_start << PAGE_SHIFT) + tables);
 }
 
+static unsigned long max_addr;
+
 /* Setup the direct mapping of the physical memory at PAGE_OFFSET.
    This runs before bootmem is initialized and gets pages directly from the 
    physical memory. To access them they are temporarily mapped. */
@@ -370,10 +368,13 @@
 		pgd_t *pgd = pgd_offset_k(start);
 		pud_t *pud;
 
-		if (after_bootmem)
+		if (after_bootmem) {
 			pud = pud_offset(pgd, start & PGDIR_MASK);
-		else
+		} else {
 			pud = alloc_low_page(&pud_phys);
+			if (end > max_addr)
+				max_addr = end;
+		}
 
 		next = start + PGDIR_SIZE;
 		if (next > end) 
@@ -489,6 +490,187 @@
 static struct kcore_list kcore_mem, kcore_vmalloc, kcore_kernel, kcore_modules,
 			 kcore_vsyscall;
 
+
+static unsigned long __init get_res_page(void)
+{
+	static unsigned long res_phys_page;
+	if (!res_phys_page) {
+		pte_t *pte;
+		pte = alloc_low_page(&res_phys_page);
+		unmap_low_page(pte);
+	}
+	return res_phys_page;
+}
+
+static unsigned long __init get_res_ptepage(void)
+{
+	static unsigned long res_phys_ptepage;
+	if (!res_phys_ptepage) {
+		pte_t *pte_page;
+		unsigned long page_phys;
+		unsigned long entry;
+		int i;
+
+		pte_page = alloc_low_page(&res_phys_ptepage);
+
+		page_phys = get_res_page();
+		entry = _PAGE_NX | _KERNPG_TABLE | _PAGE_GLOBAL | page_phys;
+		entry &= __supported_pte_mask;
+		for (i = 0; i < PTRS_PER_PTE; i++) {
+			pte_t *pte = pte_page + i;
+			set_pte(pte, __pte(entry));
+		}
+
+		unmap_low_page(pte_page);
+	}
+	return res_phys_ptepage;
+}
+
+static void __init phys_pte_prune(pte_t *pte_page, unsigned long address,
+		unsigned long end, unsigned long vaddr, unsigned int exec)
+{
+	int i = pte_index(vaddr);
+
+	for (; i < PTRS_PER_PTE; i++, address = (address & PAGE_MASK) + PAGE_SIZE, vaddr = (vaddr + PAGE_MASK) + PAGE_SIZE) {
+		unsigned long entry;
+		pte_t *pte = pte_page + i;
+
+		if (address >= end)
+			break;
+
+		if (pte_val(*pte))
+			continue;
+
+		/* Nothing to map. Map the null page */
+		if (!(address & (~PAGE_MASK)) &&
+		    (address + PAGE_SIZE <= end) &&
+		    !is_memory_any_valid(address, address + PAGE_SIZE)) {
+			unsigned long phys_page;
+
+			phys_page = get_res_page();
+			entry = _PAGE_NX | _KERNPG_TABLE | _PAGE_GLOBAL |
+				phys_page;
+
+			entry &= __supported_pte_mask;
+			set_pte(pte, __pte(entry));
+
+			continue;
+		}
+
+		if (exec)
+			entry = _PAGE_NX|_KERNPG_TABLE|_PAGE_GLOBAL|address;
+		else
+			entry = _KERNPG_TABLE|_PAGE_GLOBAL|address;
+		entry &= __supported_pte_mask;
+		set_pte(pte, __pte(entry));
+	}
+}
+
+static void __init phys_pmd_prune(pmd_t *pmd_page, unsigned long address,
+		unsigned long end, unsigned long vaddr, unsigned int exec)
+{
+	int i = pmd_index(vaddr);
+
+	for (; i < PTRS_PER_PMD; i++, address = (address & PMD_MASK) + PMD_SIZE,
+			vaddr = (vaddr & PMD_MASK) + PMD_SIZE) {
+		pmd_t *pmd = pmd_page + i;
+		pte_t *pte;
+		unsigned long pte_phys;
+
+		if (address >= end)
+			break;
+
+		if (!pmd_val(*pmd))
+			continue;
+
+		/* Nothing to map. Map the null page */
+		if (!(address & (~PMD_MASK)) &&
+		    (address + PMD_SIZE <= end) &&
+		    !is_memory_any_valid(address, address + PMD_SIZE)) {
+
+			pte_phys = get_res_ptepage();
+			set_pmd(pmd, __pmd(pte_phys | _KERNPG_TABLE));
+
+			continue;
+		}
+
+		/* Map with 2M pages */
+		if (is_memory_all_valid(address, address + PUD_SIZE)) {
+			/* Init already done */
+			continue;
+		}
+
+		/* Map with 4k pages */
+		pte = alloc_low_page(&pte_phys);
+		phys_pte_prune(pte, address, address + PMD_SIZE, vaddr, exec);
+		set_pmd(pmd, __pmd(pte_phys | _KERNPG_TABLE));
+		unmap_low_page(pte);
+
+	}
+}
+
+static void __init phys_pud_prune(pud_t *pud_page, unsigned long addr,
+	       unsigned long end, unsigned long vaddr, unsigned int exec)
+{
+	int i = pud_index(vaddr);
+
+	for (; i < PTRS_PER_PUD; i++, addr = (addr & PUD_MASK) + PUD_SIZE,
+			vaddr = (vaddr & PUD_MASK) + PUD_SIZE) {
+		pud_t *pud = pud_page + i;
+
+		if (addr >= end)
+			break;
+
+		if (pud_val(*pud)) {
+			pmd_t *pmd = pmd_offset(pud,0);
+			phys_pmd_prune(pmd, addr, end, vaddr, exec);
+		}
+	}
+}
+
+void __init prune_reserved_region_maps(void)
+{
+	unsigned long start, end, next;
+
+	/* Prune physical memory identity map */
+	start = (unsigned long)__va(0);
+	end = max_addr;
+	for (; start < end; start = next) {
+		pgd_t *pgd = pgd_offset_k(start);
+		pud_t *pud;
+
+		pud = pud_offset(pgd, start & PGDIR_MASK);
+
+		next = start + PGDIR_SIZE;
+		if (next > end)
+			next = end;
+
+		phys_pud_prune(pud, __pa(start), __pa(next), start, 0);
+	}
+
+	/* Prune kernel text region */
+	start = (unsigned long)KERNEL_TEXT_START;
+	end = start + (unsigned long)KERNEL_TEXT_SIZE;
+	for (; start < end; start = next) {
+		pgd_t *pgd = pgd_offset_k(start);
+		pud_t *pud;
+
+		pud = pud_offset(pgd, start & PGDIR_MASK);
+
+		next = (start & PGDIR_MASK) + (unsigned long)PGDIR_SIZE;
+		if (!next || next > end)
+			next = end;
+
+		phys_pud_prune(pud,
+		               start - (unsigned long)KERNEL_TEXT_START,
+		               next - (unsigned long)KERNEL_TEXT_START,
+			       start,
+			       1);
+	}
+
+	__flush_tlb();
+}
+
 void __init mem_init(void)
 {
 	long codesize, reservedpages, datasize, initsize;
@@ -538,6 +720,8 @@
 		reservedpages << (PAGE_SHIFT-10),
 		datasize >> 10,
 		initsize >> 10);
+
+	prune_reserved_region_maps();
 }
 
 void free_init_pages(char *what, unsigned long begin, unsigned long end)
Index: linux-2.6.git/arch/x86/mm/ioremap_64.c
===================================================================
--- linux-2.6.git.orig/arch/x86/mm/ioremap_64.c	2008-01-08 03:41:30.000000000 -0800
+++ linux-2.6.git/arch/x86/mm/ioremap_64.c	2008-01-08 03:59:28.000000000 -0800
@@ -19,6 +19,7 @@
 #include <asm/tlbflush.h>
 #include <asm/cacheflush.h>
 #include <asm/proto.h>
+#include <asm/e820.h>
 
 unsigned long __phys_addr(unsigned long x)
 {
@@ -28,9 +29,6 @@
 }
 EXPORT_SYMBOL(__phys_addr);
 
-#define ISA_START_ADDRESS      0xa0000
-#define ISA_END_ADDRESS                0x100000
-
 /*
  * Fix up the linear direct mapping of the kernel to avoid cache attribute
  * conflicts.
Index: linux-2.6.git/arch/x86/mm/pageattr_64.c
===================================================================
--- linux-2.6.git.orig/arch/x86/mm/pageattr_64.c	2008-01-08 03:41:30.000000000 -0800
+++ linux-2.6.git/arch/x86/mm/pageattr_64.c	2008-01-08 04:03:33.000000000 -0800
@@ -53,9 +53,11 @@
 	/*
 	 * page_private is used to track the number of entries in
 	 * the page table page have non standard attributes.
+	 * Count of 1 indicates page split by split_large_page(),
+	 * additional count indicates the number of pages with non-std attr.
 	 */
 	SetPagePrivate(base);
-	page_private(base) = 0;
+	page_private(base) = 1;
 
 	address = __pa(address);
 	addr = address & LARGE_PAGE_MASK;
@@ -176,11 +178,8 @@
 			BUG();
 	}
 
-	/* on x86-64 the direct mapping set at boot is not using 4k pages */
-	BUG_ON(PageReserved(kpte_page));
-
 	save_page(kpte_page);
-	if (page_private(kpte_page) == 0)
+	if (page_private(kpte_page) == 1)
 		revert_page(address, ref_prot);
 	return 0;
 }
Index: linux-2.6.git/include/asm-x86/e820_64.h
===================================================================
--- linux-2.6.git.orig/include/asm-x86/e820_64.h	2008-01-08 03:41:30.000000000 -0800
+++ linux-2.6.git/include/asm-x86/e820_64.h	2008-01-08 03:59:28.000000000 -0800
@@ -26,6 +26,10 @@
 extern void e820_mark_nosave_regions(void);
 extern int e820_any_mapped(unsigned long start, unsigned long end, unsigned type);
 extern int e820_all_mapped(unsigned long start, unsigned long end, unsigned type);
+extern int e820_any_non_reserved(unsigned long start, unsigned long end);
+extern int is_memory_any_valid(unsigned long start, unsigned long end);
+extern int e820_all_non_reserved(unsigned long start, unsigned long end);
+extern int is_memory_all_valid(unsigned long start, unsigned long end);
 extern unsigned long e820_hole_size(unsigned long start, unsigned long end);
 
 extern void e820_setup_gap(void);
@@ -38,6 +42,10 @@
 
 extern unsigned ebda_addr, ebda_size;
 extern unsigned long nodemap_addr, nodemap_size;
+
+#define ISA_START_ADDRESS	0xa0000
+#define ISA_END_ADDRESS		0x100000
+
 #endif/*!__ASSEMBLY__*/
 
 #endif/*__E820_HEADER*/

-- 
