Return-Path: <linux-kernel-owner+w=401wt.eu-S1758068AbZF0Gh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758068AbZF0Gh0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 02:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751258AbZF0GhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 02:37:14 -0400
Received: from mail-px0-f190.google.com ([209.85.216.190]:57574 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbZF0GhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 02:37:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=NqanC4/hRKEnWTND9Y32DyxGjq9ZcffYCdeajcCzDitKy/siJyyrMZPaW6Uj+i7tp+
         mh6A2ZeilDwa8RXH++3U00lHAl9p92HRBRD1P9AieJPy/0R3yDojsaWbgTCR4ZnudzrJ
         H6QahfUeC1jtM/StOK+uquuwdU+691+czGlCc=
Date: Sat, 27 Jun 2009 15:35:15 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Subject: [PATCH] x86: cleanup dump_pagetable()
Message-ID: <20090627063514.GA2834@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use pgtable access helpers for 32bit version dump_pagetable() and get rid
of __typeof__() operators. This needs to make pmd_pfn() available for 2-level
pgtable.

Also, remove some casts for 64bit version dump_pagetable().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 arch/x86/include/asm/pgtable.h |   10 ++++----
 arch/x86/mm/fault.c            |   51 ++++++++++++++++-----------------------
 2 files changed, 26 insertions(+), 35 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 3cc06e3..af5481e 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -134,6 +134,11 @@ static inline unsigned long pte_pfn(pte_t pte)
 	return (pte_val(pte) & PTE_PFN_MASK) >> PAGE_SHIFT;
 }
 
+static inline unsigned long pmd_pfn(pmd_t pmd)
+{
+	return (pmd_val(pmd) & PTE_PFN_MASK) >> PAGE_SHIFT;
+}
+
 #define pte_page(pte)	pfn_to_page(pte_pfn(pte))
 
 static inline int pmd_large(pmd_t pte)
@@ -422,11 +427,6 @@ static inline pmd_t *pmd_offset(pud_t *pud, unsigned long address)
 	return (pmd_t *)pud_page_vaddr(*pud) + pmd_index(address);
 }
 
-static inline unsigned long pmd_pfn(pmd_t pmd)
-{
-	return (pmd_val(pmd) & PTE_PFN_MASK) >> PAGE_SHIFT;
-}
-
 static inline int pud_large(pud_t pud)
 {
 	return (pud_val(pud) & (_PAGE_PSE | _PAGE_PRESENT)) ==
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 78a5fff..9bf7e52 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -285,26 +285,25 @@ check_v8086_mode(struct pt_regs *regs, unsigned long address,
 		tsk->thread.screen_bitmap |= 1 << bit;
 }
 
-static void dump_pagetable(unsigned long address)
+static bool low_pfn(unsigned long pfn)
 {
-	__typeof__(pte_val(__pte(0))) page;
+	return pfn < max_low_pfn;
+}
 
-	page = read_cr3();
-	page = ((__typeof__(page) *) __va(page))[address >> PGDIR_SHIFT];
+static void dump_pagetable(unsigned long address)
+{
+	pgd_t *base = __va(read_cr3());
+	pgd_t *pgd = &base[pgd_index(address)];
+	pmd_t *pmd;
+	pte_t *pte;
 
 #ifdef CONFIG_X86_PAE
-	printk("*pdpt = %016Lx ", page);
-	if ((page >> PAGE_SHIFT) < max_low_pfn
-	    && page & _PAGE_PRESENT) {
-		page &= PAGE_MASK;
-		page = ((__typeof__(page) *) __va(page))[(address >> PMD_SHIFT)
-							& (PTRS_PER_PMD - 1)];
-		printk(KERN_CONT "*pde = %016Lx ", page);
-		page &= ~_PAGE_NX;
-	}
-#else
-	printk("*pde = %08lx ", page);
+	printk("*pdpt = %016Lx ", pgd_val(*pgd));
+	if (!low_pfn(pgd_val(*pgd) >> PAGE_SHIFT) || !pgd_present(*pgd))
+		goto out;
 #endif
+	pmd = pmd_offset(pud_offset(pgd, address), address);
+	printk(KERN_CONT "*pde = %0*Lx ", sizeof(*pmd) * 2, (u64)pmd_val(*pmd));
 
 	/*
 	 * We must not directly access the pte in the highpte
@@ -312,16 +311,12 @@ static void dump_pagetable(unsigned long address)
 	 * And let's rather not kmap-atomic the pte, just in case
 	 * it's allocated already:
 	 */
-	if ((page >> PAGE_SHIFT) < max_low_pfn
-	    && (page & _PAGE_PRESENT)
-	    && !(page & _PAGE_PSE)) {
-
-		page &= PAGE_MASK;
-		page = ((__typeof__(page) *) __va(page))[(address >> PAGE_SHIFT)
-							& (PTRS_PER_PTE - 1)];
-		printk("*pte = %0*Lx ", sizeof(page)*2, (u64)page);
-	}
+	if (!low_pfn(pmd_pfn(*pmd)) || !pmd_present(*pmd) || pmd_large(*pmd))
+		goto out;
 
+	pte = pte_offset_kernel(pmd, address);
+	printk("*pte = %0*Lx ", sizeof(*pte) * 2, (u64)pte_val(*pte));
+out:
 	printk("\n");
 }
 
@@ -449,16 +444,12 @@ static int bad_address(void *p)
 
 static void dump_pagetable(unsigned long address)
 {
-	pgd_t *pgd;
+	pgd_t *base = __va(read_cr3() & PHYSICAL_PAGE_MASK);
+	pgd_t *pgd = base + pgd_index(address);
 	pud_t *pud;
 	pmd_t *pmd;
 	pte_t *pte;
 
-	pgd = (pgd_t *)read_cr3();
-
-	pgd = __va((unsigned long)pgd & PHYSICAL_PAGE_MASK);
-
-	pgd += pgd_index(address);
 	if (bad_address(pgd))
 		goto bad;
 
