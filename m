Return-Path: <linux-kernel-owner+w=401wt.eu-S1762551AbYA2FKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762551AbYA2FKd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 00:10:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756847AbYA2FGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 00:06:40 -0500
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:52731 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756345AbYA2FGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 00:06:39 -0500
From: Andi Kleen <ak@suse.de>
References: <20080129606.610336873@suse.de>
In-Reply-To: <20080129606.610336873@suse.de>
To: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: [PATCH] [9/9] GBPAGES: Do kernel direct mapping at boot using GB pages
Message-Id: <20080129050637.BD7441B416E@basil.firstfloor.org>
Date: Tue, 29 Jan 2008 06:06:37 +0100 (CET)
X-OriginalArrivalTime: 29 Jan 2008 05:00:21.0424 (UTC) FILETIME=[D9A2D300:01C86233]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This should decrease TLB pressure because the kernel will need
less TLB faults for its own data access.

Only done for 64bit because i386 does not support GB page tables.

This only applies to the data portion of the direct mapping; the
kernel text mapping stays with 2MB pages because the AMD Fam10h
microarchitecture does not support GB ITLBs and AMD recommends 
against using GB mappings for code.

Can be disabled with direct_gbpages=off

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/mm/init_64.c |   64 ++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 55 insertions(+), 9 deletions(-)

Index: linux/arch/x86/mm/init_64.c
===================================================================
--- linux.orig/arch/x86/mm/init_64.c
+++ linux/arch/x86/mm/init_64.c
@@ -279,13 +279,20 @@ __meminit void early_iounmap(void *addr,
 	__flush_tlb_all();
 }
 
+static unsigned long direct_entry(unsigned long paddr)
+{
+	unsigned long entry;
+	entry = __PAGE_KERNEL_LARGE|paddr;
+	entry &= __supported_pte_mask;
+	return entry;
+}
+
 static void __meminit
 phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end)
 {
 	int i = pmd_index(address);
 
 	for (; i < PTRS_PER_PMD; i++, address += PMD_SIZE) {
-		unsigned long entry;
 		pmd_t *pmd = pmd_page + pmd_index(address);
 
 		if (address >= end) {
@@ -299,9 +306,7 @@ phys_pmd_init(pmd_t *pmd_page, unsigned 
 		if (pmd_val(*pmd))
 			continue;
 
-		entry = __PAGE_KERNEL_LARGE|_PAGE_GLOBAL|address;
-		entry &= __supported_pte_mask;
-		set_pmd(pmd, __pmd(entry));
+		set_pmd(pmd, __pmd(direct_entry(address)));
 	}
 }
 
@@ -335,7 +340,13 @@ phys_pud_init(pud_t *pud_page, unsigned 
 		}
 
 		if (pud_val(*pud)) {
-			phys_pmd_update(pud, addr, end);
+			if (!pud_large(*pud))
+				phys_pmd_update(pud, addr, end);
+			continue;
+		}
+
+		if (direct_gbpages > 0) {
+			set_pud(pud, __pud(direct_entry(addr)));
 			continue;
 		}
 
@@ -356,9 +367,11 @@ static void __init find_early_table_spac
 	unsigned long puds, pmds, tables, start;
 
 	puds = (end + PUD_SIZE - 1) >> PUD_SHIFT;
-	pmds = (end + PMD_SIZE - 1) >> PMD_SHIFT;
-	tables = round_up(puds * sizeof(pud_t), PAGE_SIZE) +
-		 round_up(pmds * sizeof(pmd_t), PAGE_SIZE);
+	tables = round_up(puds * sizeof(pud_t), PAGE_SIZE);
+	if (!direct_gbpages) {
+		pmds = (end + PMD_SIZE - 1) >> PMD_SHIFT;
+		tables += round_up(pmds * sizeof(pmd_t), PAGE_SIZE);
+	}
 
 	/*
 	 * RED-PEN putting page tables only on node 0 could
@@ -378,6 +391,20 @@ static void __init find_early_table_spac
 		(table_start << PAGE_SHIFT) + tables);
 }
 
+static void init_gbpages(void)
+{
+#ifdef CONFIG_DEBUG_PAGEALLOC
+	/* debug pagealloc causes too much recursion with gbpages */
+	if (direct_gbpages == 0)
+		return;
+#endif
+	if (direct_gbpages >= 0 && cpu_has_gbpages) {
+		printk(KERN_INFO "Using GB pages for direct mapping\n");
+		direct_gbpages = 1;
+	} else
+		direct_gbpages = 0;
+}
+
 /*
  * Setup the direct mapping of the physical memory at PAGE_OFFSET.
  * This runs before bootmem is initialized and gets pages directly from
@@ -396,8 +423,10 @@ void __init_refok init_memory_mapping(un
 	 * memory mapped. Unfortunately this is done currently before the
 	 * nodes are discovered.
 	 */
-	if (!after_bootmem)
+	if (!after_bootmem) {
+		init_gbpages();
 		find_early_table_space(end);
+	}
 
 	start = (unsigned long)__va(start);
 	end = (unsigned long)__va(end);
@@ -444,6 +473,21 @@ void __init paging_init(void)
 }
 #endif
 
+static void split_gb_page(pud_t *pud, unsigned long paddr)
+{
+	int i;
+	pmd_t *pmd;
+	struct page *p = alloc_page(GFP_KERNEL);
+	if (!p)
+		return;
+
+	paddr &= PUD_PAGE_MASK;
+	pmd = page_address(p);
+	for (i = 0; i < PTRS_PER_PTE; i++, paddr += PMD_PAGE_SIZE)
+		pmd[i] = __pmd(direct_entry(paddr));
+	pud_populate(NULL, pud, pmd);
+}
+
 /*
  * Unmap a kernel mapping if it exists. This is useful to avoid
  * prefetches from the CPU leading to inconsistent cache lines.
@@ -467,6 +511,8 @@ __clear_kernel_mapping(unsigned long add
 			continue;
 
 		pud = pud_offset(pgd, address);
+		if (pud_large(*pud))
+			split_gb_page(pud, __pa(address));
 		if (pud_none(*pud))
 			continue;
 
