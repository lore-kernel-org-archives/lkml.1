Return-Path: <linux-kernel-owner+w=401wt.eu-S1755897AbZIKTtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897AbZIKTtc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 15:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752198AbZIKTtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 15:49:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52525 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751987AbZIKTtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 15:49:31 -0400
Date: Fri, 11 Sep 2009 21:49:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] x86/mm for v2.6.32
Message-ID: <20090911194925.GA30200@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-mm-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-mm-for-linus

 Thanks,

	Ingo

------------------>
Akinobu Mita (1):
      x86: Clean up dump_pagetable()

Figo.zhang (2):
      x86, pgtable.h: Clean up types
      x86, highmem_32.c: Clean up comment


 arch/x86/include/asm/pgtable.h |   16 ++++++------
 arch/x86/mm/fault.c            |   51 ++++++++++++++++-----------------------
 arch/x86/mm/highmem_32.c       |    2 +-
 3 files changed, 30 insertions(+), 39 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 3cc06e3..9de8729 100644
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
@@ -351,7 +356,7 @@ static inline unsigned long pmd_page_vaddr(pmd_t pmd)
  * this macro returns the index of the entry in the pmd page which would
  * control the given virtual address
  */
-static inline unsigned pmd_index(unsigned long address)
+static inline unsigned long pmd_index(unsigned long address)
 {
 	return (address >> PMD_SHIFT) & (PTRS_PER_PMD - 1);
 }
@@ -371,7 +376,7 @@ static inline unsigned pmd_index(unsigned long address)
  * this function returns the index of the entry in the pte page which would
  * control the given virtual address
  */
-static inline unsigned pte_index(unsigned long address)
+static inline unsigned long pte_index(unsigned long address)
 {
 	return (address >> PAGE_SHIFT) & (PTRS_PER_PTE - 1);
 }
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
@@ -462,7 +462,7 @@ static inline unsigned long pgd_page_vaddr(pgd_t pgd)
 #define pgd_page(pgd)		pfn_to_page(pgd_val(pgd) >> PAGE_SHIFT)
 
 /* to find an entry in a page-table-directory. */
-static inline unsigned pud_index(unsigned long address)
+static inline unsigned long pud_index(unsigned long address)
 {
 	return (address >> PUD_SHIFT) & (PTRS_PER_PUD - 1);
 }
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
 
diff --git a/arch/x86/mm/highmem_32.c b/arch/x86/mm/highmem_32.c
index 58f621e..0c6f43c 100644
--- a/arch/x86/mm/highmem_32.c
+++ b/arch/x86/mm/highmem_32.c
@@ -24,7 +24,7 @@ void kunmap(struct page *page)
  * no global lock is needed and because the kmap code must perform a global TLB
  * invalidation when the kmap pool wraps.
  *
- * However when holding an atomic kmap is is not legal to sleep, so atomic
+ * However when holding an atomic kmap it is not legal to sleep, so atomic
  * kmaps are appropriate for short, tight code paths only.
  */
 void *kmap_atomic_prot(struct page *page, enum km_type type, pgprot_t prot)
