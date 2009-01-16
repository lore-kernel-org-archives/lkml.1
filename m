Return-Path: <linux-kernel-owner+w=401wt.eu-S1764043AbZAPL7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764043AbZAPL7Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 06:59:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753363AbZAPL66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 06:58:58 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:50254 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757575AbZAPL65 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 06:58:57 -0500
Message-Id: <497084B5.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Fri, 16 Jan 2009 11:59:33 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: "Nick Piggin" <npiggin@suse.de>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] i386: fix assumed to be contiguous leaf page tables
	 for kmap_atomic region (take 2)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Debugging and original patch from Nick Piggin <npiggin@suse.de>

The early fixmap pmd entry inserted at the very top of the KVA is causing the
subsequent fixmap mapping code to not provide physically linear pte pages over
the kmap atomic portion of the fixmap (which relies on said property to
calculate pte addresses).

This has caused weird boot failures in kmap_atomic much later in the boot
process (initial userspace faults) on a 32-bit PAE system with a larger number
of CPUs (smaller CPU counts tend not to run over into the next page so don't
show up the problem).

Solve this by attempting to clear out the page table, and copy any of its
entries to the new one. Also, add a bug if a nonlinear condition is encountered
and can't be resolved, which might save some hours of debugging if this fragile
scheme ever breaks again...

Signed-off-by: Nick Piggin <npiggin@suse.de>

Once we have such logic, we can also use it to eliminate the early ioremap
trickery around the page table setup for the fixmap area. This also fixes
potential issues with FIX_* entries sharing the leaf page table with the early
ioremap ones getting discarded by early_ioremap_clear() and not restored by
early_ioremap_reset(). It at once eliminates the temporary (and configuration,
namely NR_CPUS, dependent) unavailability of early fixed mappings during the
time the fixmap area page tables get constructed.

Finally, also replace the hard coded calculation of the initial table space
needed for the fixmap area with a proper one, allowing kernels configured for
large CPU counts to actually boot.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/include/asm/io.h |    1 
 arch/x86/mm/init_32.c     |   48 +++++++++++++++++++++++++++++++++++++++++++---
 arch/x86/mm/ioremap.c     |   25 -----------------------
 3 files changed, 45 insertions(+), 29 deletions(-)

--- linux-2.6.29-rc1/arch/x86/include/asm/io.h	2009-01-14 11:36:05.000000000 +0100
+++ 2.6.29-rc1-i386-fix-kmap-contig/arch/x86/include/asm/io.h	2009-01-16 00:00:00.000000000 +0100
@@ -99,7 +99,6 @@ extern void __iomem *ioremap_wc(unsigned
  * A boot-time mapping is currently limited to at most 16 pages.
  */
 extern void early_ioremap_init(void);
-extern void early_ioremap_clear(void);
 extern void early_ioremap_reset(void);
 extern void __iomem *early_ioremap(unsigned long offset, unsigned long size);
 extern void __iomem *early_memremap(unsigned long offset, unsigned long size);
--- linux-2.6.29-rc1/arch/x86/mm/init_32.c	2009-01-14 11:36:05.000000000 +0100
+++ 2.6.29-rc1-i386-fix-kmap-contig/arch/x86/mm/init_32.c	2009-01-16 00:00:00.000000000 +0100
@@ -138,6 +138,47 @@ static pte_t * __init one_page_table_ini
 	return pte_offset_kernel(pmd, 0);
 }
 
+static pte_t *__init page_table_kmap_check(pte_t *pte, pmd_t *pmd,
+					   unsigned long vaddr, pte_t *lastpte)
+{
+#ifdef CONFIG_HIGHMEM
+	/*
+	 * Something (early fixmap) may already have put a pte
+	 * page here, which causes the page table allocation
+	 * to become nonlinear. Attempt to fix it, and if it
+	 * is still nonlinear then we have to bug.
+	 */
+	int pmd_idx_kmap_begin = fix_to_virt(FIX_KMAP_END) >> PMD_SHIFT;
+	int pmd_idx_kmap_end = fix_to_virt(FIX_KMAP_BEGIN) >> PMD_SHIFT;
+
+	if (pmd_idx_kmap_begin != pmd_idx_kmap_end
+	    && (vaddr >> PMD_SHIFT) >= pmd_idx_kmap_begin
+	    && (vaddr >> PMD_SHIFT) <= pmd_idx_kmap_end
+	    && ((__pa(pte) >> PAGE_SHIFT) < table_start
+		|| (__pa(pte) >> PAGE_SHIFT) >= table_end)) {
+		pte_t *newpte;
+		int i;
+
+		BUG_ON(after_init_bootmem);
+		newpte = alloc_low_page();
+		for (i = 0; i < PTRS_PER_PTE; i++)
+			set_pte(newpte + i, pte[i]);
+
+		paravirt_alloc_pte(&init_mm, __pa(newpte) >> PAGE_SHIFT);
+		set_pmd(pmd, __pmd(__pa(newpte)|_PAGE_TABLE));
+		BUG_ON(newpte != pte_offset_kernel(pmd, 0));
+		__flush_tlb_all();
+
+		paravirt_release_pte(__pa(pte) >> PAGE_SHIFT);
+		pte = newpte;
+	}
+	BUG_ON(vaddr < fix_to_virt(FIX_KMAP_BEGIN - 1)
+	       && vaddr > fix_to_virt(FIX_KMAP_END)
+	       && lastpte && lastpte + PTRS_PER_PTE != pte);
+#endif
+	return pte;
+}
+
 /*
  * This function initializes a certain range of kernel virtual memory
  * with new bootmem page tables, everywhere page tables are missing in
@@ -154,6 +195,7 @@ page_table_range_init(unsigned long star
 	unsigned long vaddr;
 	pgd_t *pgd;
 	pmd_t *pmd;
+	pte_t *pte = NULL;
 
 	vaddr = start;
 	pgd_idx = pgd_index(vaddr);
@@ -165,7 +207,8 @@ page_table_range_init(unsigned long star
 		pmd = pmd + pmd_index(vaddr);
 		for (; (pmd_idx < PTRS_PER_PMD) && (vaddr != end);
 							pmd++, pmd_idx++) {
-			one_page_table_init(pmd);
+			pte = page_table_kmap_check(one_page_table_init(pmd),
+			                            pmd, vaddr, pte);
 
 			vaddr += PMD_SIZE;
 		}
@@ -508,7 +551,6 @@ static void __init early_ioremap_page_ta
 	 * Fixed mappings, only the page table structure has to be
 	 * created - mappings will be set by set_fixmap():
 	 */
-	early_ioremap_clear();
 	vaddr = __fix_to_virt(__end_of_fixed_addresses - 1) & PMD_MASK;
 	end = (FIXADDR_TOP + PMD_SIZE - 1) & PMD_MASK;
 	page_table_range_init(vaddr, end, pgd_base);
@@ -801,7 +843,7 @@ static void __init find_early_table_spac
 	tables += PAGE_ALIGN(ptes * sizeof(pte_t));
 
 	/* for fixmap */
-	tables += PAGE_SIZE * 2;
+	tables += PAGE_ALIGN(__end_of_fixed_addresses * sizeof(pte_t));
 
 	/*
 	 * RED-PEN putting page tables only on node 0 could
--- linux-2.6.29-rc1/arch/x86/mm/ioremap.c	2009-01-14 11:36:05.000000000 +0100
+++ 2.6.29-rc1-i386-fix-kmap-contig/arch/x86/mm/ioremap.c	2009-01-16 00:00:00.000000000 +0100
@@ -557,34 +557,9 @@ void __init early_ioremap_init(void)
 	}
 }
 
-void __init early_ioremap_clear(void)
-{
-	pmd_t *pmd;
-
-	if (early_ioremap_debug)
-		printk(KERN_INFO "early_ioremap_clear()\n");
-
-	pmd = early_ioremap_pmd(fix_to_virt(FIX_BTMAP_BEGIN));
-	pmd_clear(pmd);
-	paravirt_release_pte(__pa(bm_pte) >> PAGE_SHIFT);
-	__flush_tlb_all();
-}
-
 void __init early_ioremap_reset(void)
 {
-	enum fixed_addresses idx;
-	unsigned long addr, phys;
-	pte_t *pte;
-
 	after_paging_init = 1;
-	for (idx = FIX_BTMAP_BEGIN; idx >= FIX_BTMAP_END; idx--) {
-		addr = fix_to_virt(idx);
-		pte = early_ioremap_pte(addr);
-		if (pte_present(*pte)) {
-			phys = pte_val(*pte) & PAGE_MASK;
-			set_fixmap(idx, phys);
-		}
-	}
 }
 
 static void __init __early_set_fixmap(enum fixed_addresses idx,


