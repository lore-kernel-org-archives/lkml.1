Return-Path: <linux-kernel-owner+w=401wt.eu-S1756360AbYAJStb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756360AbYAJStb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 13:49:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758048AbYAJStU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 13:49:20 -0500
Received: from mga11.intel.com ([192.55.52.93]:23280 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757702AbYAJStR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 13:49:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,267,1196668800"; 
   d="scan'208";a="283324522"
Message-Id: <20080110184855.000724000@intel.com>
References: <20080110184840.927409000@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 10 Jan 2008 10:48:43 -0800
From: venkatesh.pallipadi@intel.com
To: ak@muc.de, ebiederm@xmission.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, gregkh@suse.de, airlied@skynet.ie,
       davej@redhat.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com,
       davem@davemloft.net
Cc: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 03/11] PAT x86: Map only usable memory in i386 identity map
Content-Disposition: inline; filename=usable_only_map_i386.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i386: Map only usable memory in identity map. Reserved memory maps to a
zero page.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

Index: linux-2.6.git/arch/x86/kernel/e820_32.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/e820_32.c	2008-01-08 03:41:30.000000000 -0800
+++ linux-2.6.git/arch/x86/kernel/e820_32.c	2008-01-08 04:05:24.000000000 -0800
@@ -673,14 +673,42 @@
 }
 EXPORT_SYMBOL_GPL(e820_any_mapped);
 
+int e820_any_non_reserved(u64 start, u64 end)
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
+int is_memory_any_valid(u64 start, u64 end)
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
   * Note: this function only works correct if the e820 table is sorted and
   * not-overlapping, which is the case
   */
-int __init
-e820_all_mapped(unsigned long s, unsigned long e, unsigned type)
+int e820_all_mapped(u64 s, u64 e, unsigned type)
 {
 	u64 start = s;
 	u64 end = e;
@@ -705,6 +733,56 @@
 	return 0;
 }
 
+int e820_all_non_reserved(u64 start, u64 end)
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
+int is_memory_all_valid(u64 start, u64 end)
+{
+	/*
+	 * Keep low PCI/ISA area always mapped.
+	 * Note: end address is exclusive and start is inclusive here
+	 */
+	if (start >= ISA_START_ADDRESS && end <= ISA_END_ADDRESS)
+		return 1;
+
+	/* Switch to efi or e820 in future here */
+	return e820_all_non_reserved(start, end);
+}
+EXPORT_SYMBOL_GPL(is_memory_all_valid);
+
+int is_memory_all_reserved(u64 start, u64 end)
+{
+	/* Switch to efi or e820 in future here */
+	if (e820_all_mapped(start, end, E820_RESERVED) == 1)
+		return 1;
+	return !is_memory_any_valid(start, end);
+}
+EXPORT_SYMBOL_GPL(is_memory_all_reserved);
+
 static int __init parse_memmap(char *arg)
 {
 	if (!arg)
Index: linux-2.6.git/arch/x86/mm/init_32.c
===================================================================
--- linux-2.6.git.orig/arch/x86/mm/init_32.c	2008-01-08 03:41:30.000000000 -0800
+++ linux-2.6.git/arch/x86/mm/init_32.c	2008-01-08 04:20:44.000000000 -0800
@@ -143,6 +143,50 @@
 	return 0;
 }
 
+static unsigned long __init get_res_page(void)
+{
+	static unsigned long res_phys_page;
+	if (!res_phys_page) {
+
+		res_phys_page = (unsigned long)
+		                alloc_bootmem_low_pages(PAGE_SIZE);
+		if (!res_phys_page)
+			BUG();
+
+		memset((char *)res_phys_page, 0xe, PAGE_SIZE);
+		res_phys_page = __pa(res_phys_page);
+	}
+	return res_phys_page;
+}
+
+static unsigned long __init get_res_ptepage(void)
+{
+	static unsigned long res_phys_ptepage;
+	pte_t *pte;
+	int pte_ofs;
+	unsigned long pfn;
+
+	if (!res_phys_ptepage) {
+
+		res_phys_ptepage = (unsigned long)
+		                   alloc_bootmem_low_pages(PAGE_SIZE);
+		if (!res_phys_ptepage)
+			BUG();
+
+		paravirt_alloc_pt(&init_mm,
+		                  __pa(res_phys_ptepage) >> PAGE_SHIFT);
+
+		/* Set all PTEs in the range to zero page */
+		pfn = get_res_page() >> PAGE_SHIFT;
+		pte = (pte_t *)res_phys_ptepage;
+		for (pte_ofs = 0; pte_ofs < PTRS_PER_PTE; pte++, pte_ofs++)
+			set_pte(pte, pfn_pte(pfn, PAGE_KERNEL));
+
+		res_phys_ptepage = __pa(res_phys_ptepage);
+	}
+	return res_phys_ptepage;
+}
+
 /*
  * This maps the physical memory to kernel virtual address space, a total 
  * of max_low_pfn pages, by creating page tables starting from address 
@@ -155,6 +199,7 @@
 	pmd_t *pmd;
 	pte_t *pte;
 	int pgd_idx, pmd_idx, pte_ofs;
+	unsigned long temp_pfn;
 
 	pgd_idx = pgd_index(PAGE_OFFSET);
 	pgd = pgd_base + pgd_idx;
@@ -168,15 +213,19 @@
 		     pmd_idx < PTRS_PER_PMD && pfn < max_low_pfn;
 		     pmd++, pmd_idx++) {
 			unsigned int address = pfn * PAGE_SIZE + PAGE_OFFSET;
+			unsigned int paddr = pfn * PAGE_SIZE;
 
-			/* Map with big pages if possible, otherwise
-			   create normal page tables. */
-			if (cpu_has_pse) {
+			/*
+			 * Map with big pages if possible, otherwise create
+			 * normal page tables.
+			 */
+			if (cpu_has_pse &&
+			    is_memory_all_valid(paddr, paddr + PMD_SIZE)) {
 				unsigned int address2;
 				pgprot_t prot = PAGE_KERNEL_LARGE;
 
-				address2 = (pfn + PTRS_PER_PTE - 1) * PAGE_SIZE +
-					PAGE_OFFSET + PAGE_SIZE-1;
+				address2 = (pfn + PTRS_PER_PTE) * PAGE_SIZE +
+				           PAGE_OFFSET - 1;
 
 				if (is_kernel_text(address) ||
 				    is_kernel_text(address2))
@@ -185,19 +234,42 @@
 				set_pmd(pmd, pfn_pmd(pfn, prot));
 
 				pfn += PTRS_PER_PTE;
-			} else {
-				pte = one_page_table_init(pmd);
-
-				for (pte_ofs = 0;
-				     pte_ofs < PTRS_PER_PTE && pfn < max_low_pfn;
-				     pte++, pfn++, pte_ofs++, address += PAGE_SIZE) {
-					pgprot_t prot = PAGE_KERNEL;
+				continue;
+			}
+			if (cpu_has_pse &&
+			    !is_memory_any_valid(paddr, paddr + PMD_SIZE)) {
 
-					if (is_kernel_text(address))
-						prot = PAGE_KERNEL_EXEC;
+				temp_pfn = get_res_ptepage();
+				set_pmd(pmd, __pmd(temp_pfn | _PAGE_TABLE));
+				pfn += PTRS_PER_PTE;
+				continue;
+			}
 
-					set_pte(pte, pfn_pte(pfn, prot));
+			/*
+			 * Either !cpu_has_pse or we have some reserved holes
+			 * in the memory region
+			 */
+			pte = one_page_table_init(pmd);
+
+			for (pte_ofs = 0;
+			     pte_ofs < PTRS_PER_PTE && pfn < max_low_pfn;
+			     pte++, pfn++, pte_ofs++,
+			     address += PAGE_SIZE, paddr += PAGE_SIZE) {
+				pgprot_t prot = PAGE_KERNEL;
+
+				if (!is_memory_any_valid(paddr,
+				                         paddr + PAGE_SIZE)) {
+
+					temp_pfn = get_res_page() >> PAGE_SHIFT;
+					set_pte(pte,
+					        pfn_pte(temp_pfn, PAGE_KERNEL));
+					continue;
 				}
+
+				if (is_kernel_text(address))
+					prot = PAGE_KERNEL_EXEC;
+
+				set_pte(pte, pfn_pte(pfn, prot));
 			}
 		}
 	}
@@ -713,6 +785,8 @@
 	if (boot_cpu_data.wp_works_ok < 0)
 		test_wp_bit();
 
+	printk("Prune to be done here. max_low_pfn %lu\n", max_low_pfn);
+	//prune_kernel_identity_map();
 	/*
 	 * Subtle. SMP is doing it's boot stuff late (because it has to
 	 * fork idle threads) - but it also needs low mappings for the
Index: linux-2.6.git/include/asm-x86/e820_32.h
===================================================================
--- linux-2.6.git.orig/include/asm-x86/e820_32.h	2008-01-08 03:41:30.000000000 -0800
+++ linux-2.6.git/include/asm-x86/e820_32.h	2008-01-08 04:05:24.000000000 -0800
@@ -20,9 +20,13 @@
 
 extern struct e820map e820;
 
-extern int e820_all_mapped(unsigned long start, unsigned long end,
-			   unsigned type);
+extern int e820_all_mapped(u64 start, u64 end, unsigned type);
 extern int e820_any_mapped(u64 start, u64 end, unsigned type);
+extern int e820_any_non_reserved(u64 start, u64 end);
+extern int is_memory_any_valid(u64 start, u64 end);
+extern int e820_all_non_reserved(u64 start, u64 end);
+extern int is_memory_all_valid(u64 start, u64 end);
+extern int is_memory_all_reserved(u64 start, u64 end);
 extern void find_max_pfn(void);
 extern void register_bootmem_low_pages(unsigned long max_low_pfn);
 extern void e820_register_memory(void);
@@ -41,5 +45,8 @@
 #endif
 
 
+#define ISA_START_ADDRESS	0xa0000
+#define ISA_END_ADDRESS		0x100000
+
 #endif/*!__ASSEMBLY__*/
 #endif/*__E820_HEADER*/
Index: linux-2.6.git/arch/x86/mm/pageattr_32.c
===================================================================
--- linux-2.6.git.orig/arch/x86/mm/pageattr_32.c	2008-01-08 03:41:30.000000000 -0800
+++ linux-2.6.git/arch/x86/mm/pageattr_32.c	2008-01-08 04:05:24.000000000 -0800
@@ -55,9 +55,11 @@
 	/*
 	 * page_private is used to track the number of entries in
 	 * the page table page that have non standard attributes.
+	 * Count of 1 indicates page split by split_large_page(),
+	 * additional count indicates the number of pages with non-std attr.
 	 */
 	SetPagePrivate(base);
-	page_private(base) = 0;
+	page_private(base) = 1;
 
 	address = __pa(address);
 	addr = address & LARGE_PAGE_MASK;
@@ -203,7 +205,7 @@
 
 	save_page(kpte_page);
 	if (!PageReserved(kpte_page)) {
-		if (cpu_has_pse && (page_private(kpte_page) == 0)) {
+		if (cpu_has_pse && (page_private(kpte_page) == 1)) {
 			paravirt_release_pt(page_to_pfn(kpte_page));
 			revert_page(kpte_page, address);
 		}

-- 
