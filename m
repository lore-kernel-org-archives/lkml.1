Return-Path: <linux-kernel-owner+w=401wt.eu-S1765262AbXLNAA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765262AbXLNAA2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 19:00:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934158AbXLMX6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 18:58:23 -0500
Received: from mga09.intel.com ([134.134.136.24]:60218 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765008AbXLMX6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 18:58:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,163,1196668800"; 
   d="scan'208";a="237491374"
Message-Id: <20071213235713.061041000@intel.com>
References: <20071213235543.568682000@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 13 Dec 2007 15:55:52 -0800
From: venkatesh.pallipadi@intel.com
To: ak@muc.de, ebiederm@xmission.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, gregkh@suse.de, airlied@skynet.ie,
       davej@redhat.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com
Cc: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [RFC PATCH 09/12] PAT 64b: map only usable memory in identity mapping
Content-Disposition: inline; filename=usable_only_map.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Map only the usable memory, i.e., memory mapped in e820 and not marked as
reserved, in the identity mapping. This includes 'usable' and 'ACPI *' regions.

Mapping reserved regions in identity map, even though it has worked in practise,
can potentially be problematic. With identity map, there can be speculative
access to these reserved regions which can have undetermined behavior.

Caveat is that the legacy ISA address (0xa0000 - 0x100000) is always mapped,
even when it is reserved in e820. VGA seems to depend on this.

TODO:
* Clean up early table space allocation, avoiding overallocation there.
* Avoid mapping 0 - 1M physical addresses in kernel text mapping.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: linux-2.6.24-rc/arch/x86/kernel/e820_64.c
===================================================================
--- linux-2.6.24-rc.orig/arch/x86/kernel/e820_64.c
+++ linux-2.6.24-rc/arch/x86/kernel/e820_64.c
@@ -121,6 +121,35 @@ e820_any_mapped(unsigned long start, uns
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
@@ -150,6 +179,47 @@ int __init e820_all_mapped(unsigned long
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
 /* 
  * Find a free area in a specific range. 
  */ 
Index: linux-2.6.24-rc/arch/x86/mm/init_64.c
===================================================================
--- linux-2.6.24-rc.orig/arch/x86/mm/init_64.c
+++ linux-2.6.24-rc/arch/x86/mm/init_64.c
@@ -250,13 +250,46 @@ __meminit void early_iounmap(void *addr,
 }
 
 static void __meminit
+phys_pte_init(pte_t *pte_page, unsigned long address, unsigned long end)
+{
+	int i = pte_index(address); // (address % PMD_SIZE) >> PAGE_SHIFT;
+
+	for (; i < PTRS_PER_PTE; i++, address += PAGE_SIZE) {
+		unsigned long entry;
+		pte_t *pte = pte_page + i;
+
+		if (address >= end) {
+			if (!after_bootmem)
+				for (; i < PTRS_PER_PTE; i++, pte++)
+					set_pte(pte, __pte(0));
+			break;
+		}
+
+		if (pte_val(*pte))
+			continue;
+
+		/* Nothing to map */
+		if (!is_memory_any_valid(address, address + PAGE_SIZE)) {
+			set_pte(pte, __pte(0));
+			continue;
+		}
+
+		entry = _PAGE_NX|_KERNPG_TABLE|_PAGE_GLOBAL|address;
+		entry &= __supported_pte_mask;
+		set_pte(pte, __pte(entry));
+	}
+}
+
+static void __meminit
 phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end)
 {
 	int i = pmd_index(address);
 
 	for (; i < PTRS_PER_PMD; i++, address += PMD_SIZE) {
 		unsigned long entry;
-		pmd_t *pmd = pmd_page + pmd_index(address);
+		pmd_t *pmd = pmd_page + i; // pmd_index(address);
+		pte_t *pte;
+		unsigned long pte_phys;
 
 		if (address >= end) {
 			if (!after_bootmem)
@@ -268,9 +301,27 @@ phys_pmd_init(pmd_t *pmd_page, unsigned 
 		if (pmd_val(*pmd))
 			continue;
 
-		entry = _PAGE_NX|_PAGE_PSE|_KERNPG_TABLE|_PAGE_GLOBAL|address;
-		entry &= __supported_pte_mask;
-		set_pmd(pmd, __pmd(entry));
+		/* Nothing to map */
+		if (!is_memory_any_valid(address, address + PMD_SIZE)) {
+			set_pmd(pmd, __pmd(0));
+			continue;
+		}
+
+		/* Map with 2M pages */
+		if (is_memory_all_valid(address, address + PUD_SIZE)) {
+			entry = _PAGE_NX|_PAGE_PSE|_KERNPG_TABLE|
+				_PAGE_GLOBAL|address;
+			entry &= __supported_pte_mask;
+			set_pmd(pmd, __pmd(entry));
+			continue;
+		}
+
+		/* Map with 4k pages */
+		pte = alloc_low_page(&pte_phys);
+		set_pmd(pmd, __pmd(pte_phys | _KERNPG_TABLE));
+		phys_pte_init(pte, address, address + PMD_SIZE);
+		unmap_low_page(pte);
+
 	}
 }
 
@@ -291,14 +342,15 @@ static void __meminit phys_pud_init(pud_
 
 	for (; i < PTRS_PER_PUD; i++, addr = (addr & PUD_MASK) + PUD_SIZE ) {
 		unsigned long pmd_phys;
-		pud_t *pud = pud_page + pud_index(addr);
+		pud_t *pud = pud_page + i; // pud_index(addr);
 		pmd_t *pmd;
 
 		if (addr >= end)
 			break;
 
-		if (!after_bootmem && !e820_any_mapped(addr,addr+PUD_SIZE,0)) {
-			set_pud(pud, __pud(0)); 
+		if (!after_bootmem &&
+		    !is_memory_any_valid(addr, addr+PUD_SIZE)) {
+			set_pud(pud, __pud(0));
 			continue;
 		} 
 
@@ -310,7 +362,7 @@ static void __meminit phys_pud_init(pud_
 		pmd = alloc_low_page(&pmd_phys);
 		spin_lock(&init_mm.page_table_lock);
 		set_pud(pud, __pud(pmd_phys | _KERNPG_TABLE));
-		phys_pmd_init(pmd, addr, end);
+		phys_pmd_init(pmd, addr, addr + PUD_SIZE);
 		spin_unlock(&init_mm.page_table_lock);
 		unmap_low_page(pmd);
 	}
@@ -319,12 +371,14 @@ static void __meminit phys_pud_init(pud_
 
 static void __init find_early_table_space(unsigned long end)
 {
-	unsigned long puds, pmds, tables, start;
+	unsigned long puds, pmds, ptes, tables, start;
 
 	puds = (end + PUD_SIZE - 1) >> PUD_SHIFT;
 	pmds = (end + PMD_SIZE - 1) >> PMD_SHIFT;
+	ptes = (end + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	tables = round_up(puds * sizeof(pud_t), PAGE_SIZE) +
-		 round_up(pmds * sizeof(pmd_t), PAGE_SIZE);
+		 round_up(pmds * sizeof(pmd_t), PAGE_SIZE) +
+		 round_up(ptes * sizeof(pte_t), PAGE_SIZE);
 
  	/* RED-PEN putting page tables only on node 0 could
  	   cause a hotspot and fill up ZONE_DMA. The page tables
Index: linux-2.6.24-rc/include/asm-x86/e820_64.h
===================================================================
--- linux-2.6.24-rc.orig/include/asm-x86/e820_64.h
+++ linux-2.6.24-rc/include/asm-x86/e820_64.h
@@ -24,6 +24,10 @@ extern void e820_mark_nosave_regions(voi
 extern void e820_print_map(char *who);
 extern int e820_any_mapped(unsigned long start, unsigned long end, unsigned type);
 extern int e820_all_mapped(unsigned long start, unsigned long end, unsigned type);
+extern int e820_any_non_reserved(unsigned long start, unsigned long end);
+extern int is_memory_any_valid(unsigned long start, unsigned long end);
+extern int e820_all_non_reserved(unsigned long start, unsigned long end);
+extern int is_memory_all_valid(unsigned long start, unsigned long end);
 extern unsigned long e820_hole_size(unsigned long start, unsigned long end);
 
 extern void e820_setup_gap(void);
@@ -36,6 +40,10 @@ extern struct e820map e820;
 
 extern unsigned ebda_addr, ebda_size;
 extern unsigned long nodemap_addr, nodemap_size;
+
+#define ISA_START_ADDRESS	0xa0000
+#define ISA_END_ADDRESS		0x100000
+
 #endif/*!__ASSEMBLY__*/
 
 #endif/*__E820_HEADER*/
Index: linux-2.6.24-rc/arch/x86/mm/pageattr_64.c
===================================================================
--- linux-2.6.24-rc.orig/arch/x86/mm/pageattr_64.c
+++ linux-2.6.24-rc/arch/x86/mm/pageattr_64.c
@@ -160,9 +160,6 @@ __change_page_attr(unsigned long address
 	} else
 		BUG();
 
-	/* on x86-64 the direct mapping set at boot is not using 4k pages */
- 	BUG_ON(PageReserved(kpte_page));
-
 	save_page(kpte_page);
 	if (page_private(kpte_page) == 0)
 		revert_page(address, ref_prot);
Index: linux-2.6.24-rc/arch/x86/mm/ioremap_64.c
===================================================================
--- linux-2.6.24-rc.orig/arch/x86/mm/ioremap_64.c
+++ linux-2.6.24-rc/arch/x86/mm/ioremap_64.c
@@ -28,9 +29,6 @@ unsigned long __phys_addr(unsigned long 
 }
 EXPORT_SYMBOL(__phys_addr);
 
-#define ISA_START_ADDRESS      0xa0000
-#define ISA_END_ADDRESS                0x100000
-
 /*
  * Fix up the linear direct mapping of the kernel to avoid cache attribute
  * conflicts.

-- 
