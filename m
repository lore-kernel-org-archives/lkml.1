Return-Path: <linux-kernel-owner+w=401wt.eu-S1759053AbYACR3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759053AbYACR3h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 12:29:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754902AbYACR1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 12:27:09 -0500
Received: from mx2.suse.de ([195.135.220.15]:54722 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754030AbYACR1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 12:27:06 -0500
From: Andi Kleen <ak@suse.de>
References: <20080103626.635376000@suse.de>
In-Reply-To: <20080103626.635376000@suse.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] [8/8] GBPAGES: Do kernel direct mapping at boot using GB pages
Message-Id: <20080103172705.2D78414DDD@wotan.suse.de>
Date: Thu,  3 Jan 2008 18:27:05 +0100 (CET)
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
 arch/x86/mm/init_64.c |   63 ++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 54 insertions(+), 9 deletions(-)

Index: linux/arch/x86/mm/init_64.c
===================================================================
--- linux.orig/arch/x86/mm/init_64.c
+++ linux/arch/x86/mm/init_64.c
@@ -264,13 +264,20 @@ __meminit void early_iounmap(void *addr,
 	__flush_tlb();
 }
 
+static unsigned long direct_entry(unsigned long paddr)
+{
+	unsigned long entry;
+	entry = __PAGE_KERNEL_LARGE|_PAGE_GLOBAL|paddr;
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
@@ -283,9 +290,7 @@ phys_pmd_init(pmd_t *pmd_page, unsigned 
 		if (pmd_val(*pmd))
 			continue;
 
-		entry = __PAGE_KERNEL_LARGE|_PAGE_GLOBAL|address;
-		entry &= __supported_pte_mask;
-		set_pmd(pmd, __pmd(entry));
+		set_pmd(pmd, __pmd(direct_entry(address)));
 	}
 }
 
@@ -318,7 +323,13 @@ static void __meminit phys_pud_init(pud_
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
 
@@ -337,9 +348,11 @@ static void __init find_early_table_spac
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
 
  	/* RED-PEN putting page tables only on node 0 could
  	   cause a hotspot and fill up ZONE_DMA. The page tables
@@ -372,8 +385,15 @@ void __init_refok init_memory_mapping(un
 	 * mapped.  Unfortunately this is done currently before the nodes are 
 	 * discovered.
 	 */
-	if (!after_bootmem)
+	if (!after_bootmem) {
+		if (direct_gbpages >= 0 && cpu_has_gbpages) {
+			printk(KERN_INFO "Using GB pages for direct mapping\n");
+			direct_gbpages = 1;
+		} else
+			direct_gbpages = 0;
+
 		find_early_table_space(end);
+	}
 
 	start = (unsigned long)__va(start);
 	end = (unsigned long)__va(end);
@@ -419,6 +439,27 @@ void __init paging_init(void)
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
+	Dprintk("split_gb_page %lx\n", paddr);
+
+	SetPagePrivate(p);
+	/* Set reference to 1 so that c_p_a() does not undo it */
+	page_private(p) = 1;
+
+	paddr &= PUD_PAGE_MASK;
+	pmd = page_address(p);
+	for (i = 0; i < PTRS_PER_PTE; i++, paddr += PMD_PAGE_SIZE)
+		pmd[i] = __pmd(direct_entry(paddr));
+	pud_populate(NULL, pud, pmd);
+}
+
 /* Unmap a kernel mapping if it exists. This is useful to avoid prefetches
    from the CPU leading to inconsistent cache lines. address and size
    must be aligned to 2MB boundaries. 
@@ -430,6 +471,8 @@ __clear_kernel_mapping(unsigned long add
 
 	BUG_ON(address & ~PMD_PAGE_MASK);
 	BUG_ON(size & ~PMD_PAGE_MASK);
+
+	Dprintk("clear_kernel_mapping %lx-%lx\n", address, address+size);
 	
 	for (; address < end; address += PMD_PAGE_SIZE) {
 		pgd_t *pgd = pgd_offset_k(address);
@@ -438,6 +481,8 @@ __clear_kernel_mapping(unsigned long add
 		if (pgd_none(*pgd))
 			continue;
 		pud = pud_offset(pgd, address);
+		if (pud_large(*pud))
+			split_gb_page(pud, __pa(address));
 		if (pud_none(*pud))
 			continue; 
 		pmd = pmd_offset(pud, address);
