Return-Path: <linux-kernel-owner+w=401wt.eu-S1756652AbYGVGAN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652AbYGVGAN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 02:00:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751503AbYGVF75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:59:57 -0400
Received: from gw.goop.org ([64.81.55.164]:35784 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169AbYGVF74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:59:56 -0400
Message-ID: <4885774E.3000909@goop.org>
Date: Mon, 21 Jul 2008 22:59:42 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] x86: rename PTE_MASK to PTE_PFN_MASK
References: <200807221431.58991.rusty@rustcorp.com.au> <488566EA.5040805@goop.org> <200807221540.47161.rusty@rustcorp.com.au>
In-Reply-To: <200807221540.47161.rusty@rustcorp.com.au>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty, in his peevish way, complained that macros defining constants
should have a name which somewhat accurately reflects the actual
purpose of the constant.

Aside from the fact that PTE_MASK gives no clue as to what's actually
being masked, and is misleadingly similar to the functionally entirely
different PMD_MASK, PUD_MASK and PGD_MASK, I don't really see what the
problem is.

But if this patch silences the incessent noise, then it will have
achieved its goal (TODO: write test-case).

Signed-off-by: Jeremy Fitzhardinge <jeremy@goop.org>
---
 arch/x86/mm/dump_pagetables.c    |   10 +++++-----
 arch/x86/xen/enlighten.c         |    2 +-
 arch/x86/xen/mmu.c               |    8 ++++----
 include/asm-x86/page.h           |    6 +++---
 include/asm-x86/paravirt.h       |    2 +-
 include/asm-x86/pgtable-3level.h |    8 ++++----
 include/asm-x86/pgtable.h        |    4 ++--
 include/asm-x86/pgtable_32.h     |    4 ++--
 include/asm-x86/pgtable_64.h     |   10 +++++-----
 include/asm-x86/xen/page.h       |    2 +-
 10 files changed, 28 insertions(+), 28 deletions(-)

===================================================================
--- a/arch/x86/mm/dump_pagetables.c
+++ b/arch/x86/mm/dump_pagetables.c
@@ -148,8 +148,8 @@
 	 * we have now. "break" is either changing perms, levels or
 	 * address space marker.
 	 */
-	prot = pgprot_val(new_prot) & ~(PTE_MASK);
-	cur = pgprot_val(st->current_prot) & ~(PTE_MASK);
+	prot = pgprot_val(new_prot) & ~(PTE_PFN_MASK);
+	cur = pgprot_val(st->current_prot) & ~(PTE_PFN_MASK);
 
 	if (!st->level) {
 		/* First entry */
@@ -221,7 +221,7 @@
 	for (i = 0; i < PTRS_PER_PMD; i++) {
 		st->current_address = normalize_addr(P + i * PMD_LEVEL_MULT);
 		if (!pmd_none(*start)) {
-			pgprotval_t prot = pmd_val(*start) & ~PTE_MASK;
+			pgprotval_t prot = pmd_val(*start) & ~PTE_PFN_MASK;
 
 			if (pmd_large(*start) || !pmd_present(*start))
 				note_page(m, st, __pgprot(prot), 3);
@@ -253,7 +253,7 @@
 	for (i = 0; i < PTRS_PER_PUD; i++) {
 		st->current_address = normalize_addr(P + i * PUD_LEVEL_MULT);
 		if (!pud_none(*start)) {
-			pgprotval_t prot = pud_val(*start) & ~PTE_MASK;
+			pgprotval_t prot = pud_val(*start) & ~PTE_PFN_MASK;
 
 			if (pud_large(*start) || !pud_present(*start))
 				note_page(m, st, __pgprot(prot), 2);
@@ -288,7 +288,7 @@
 	for (i = 0; i < PTRS_PER_PGD; i++) {
 		st.current_address = normalize_addr(i * PGD_LEVEL_MULT);
 		if (!pgd_none(*start)) {
-			pgprotval_t prot = pgd_val(*start) & ~PTE_MASK;
+			pgprotval_t prot = pgd_val(*start) & ~PTE_PFN_MASK;
 
 			if (pgd_large(*start) || !pgd_present(*start))
 				note_page(m, &st, __pgprot(prot), 1);
===================================================================
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1482,7 +1482,7 @@
 {
 	phys_addr_t paddr;
 
-	maddr &= PTE_MASK;
+	maddr &= PTE_PFN_MASK;
 	paddr = mfn_to_pfn(maddr >> PAGE_SHIFT) << PAGE_SHIFT;
 
 	return paddr;
===================================================================
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -343,8 +343,8 @@
 static pteval_t pte_mfn_to_pfn(pteval_t val)
 {
 	if (val & _PAGE_PRESENT) {
-		unsigned long mfn = (val & PTE_MASK) >> PAGE_SHIFT;
-		pteval_t flags = val & ~PTE_MASK;
+		unsigned long mfn = (val & PTE_PFN_MASK) >> PAGE_SHIFT;
+		pteval_t flags = val & ~PTE_PFN_MASK;
 		val = ((pteval_t)mfn_to_pfn(mfn) << PAGE_SHIFT) | flags;
 	}
 
@@ -354,8 +354,8 @@
 static pteval_t pte_pfn_to_mfn(pteval_t val)
 {
 	if (val & _PAGE_PRESENT) {
-		unsigned long pfn = (val & PTE_MASK) >> PAGE_SHIFT;
-		pteval_t flags = val & ~PTE_MASK;
+		unsigned long pfn = (val & PTE_PFN_MASK) >> PAGE_SHIFT;
+		pteval_t flags = val & ~PTE_PFN_MASK;
 		val = ((pteval_t)pfn_to_mfn(pfn) << PAGE_SHIFT) | flags;
 	}
 
===================================================================
--- a/include/asm-x86/page.h
+++ b/include/asm-x86/page.h
@@ -18,8 +18,8 @@
    (ie, 32-bit PAE). */
 #define PHYSICAL_PAGE_MASK	(((signed long)PAGE_MASK) & __PHYSICAL_MASK)
 
-/* PTE_MASK extracts the PFN from a (pte|pmd|pud|pgd)val_t */
-#define PTE_MASK		((pteval_t)PHYSICAL_PAGE_MASK)
+/* PTE_PFN_MASK extracts the PFN from a (pte|pmd|pud|pgd)val_t */
+#define PTE_PFN_MASK		((pteval_t)PHYSICAL_PAGE_MASK)
 
 #define PMD_PAGE_SIZE		(_AC(1, UL) << PMD_SHIFT)
 #define PMD_PAGE_MASK		(~(PMD_PAGE_SIZE-1))
@@ -146,7 +146,7 @@
 
 static inline pteval_t native_pte_flags(pte_t pte)
 {
-	return native_pte_val(pte) & ~PTE_MASK;
+	return native_pte_val(pte) & ~PTE_PFN_MASK;
 }
 
 #define pgprot_val(x)	((x).pgprot)
===================================================================
--- a/include/asm-x86/paravirt.h
+++ b/include/asm-x86/paravirt.h
@@ -1071,7 +1071,7 @@
 				 pte.pte);
 
 #ifdef CONFIG_PARAVIRT_DEBUG
-	BUG_ON(ret & PTE_MASK);
+	BUG_ON(ret & PTE_PFN_MASK);
 #endif
 	return ret;
 }
===================================================================
--- a/include/asm-x86/pgtable-3level.h
+++ b/include/asm-x86/pgtable-3level.h
@@ -25,7 +25,7 @@
 
 static inline int pud_bad(pud_t pud)
 {
-	return (pud_val(pud) & ~(PTE_MASK | _KERNPG_TABLE | _PAGE_USER)) != 0;
+	return (pud_val(pud) & ~(PTE_PFN_MASK | _KERNPG_TABLE | _PAGE_USER)) != 0;
 }
 
 static inline int pud_present(pud_t pud)
@@ -120,9 +120,9 @@
 		write_cr3(pgd);
 }
 
-#define pud_page(pud) ((struct page *) __va(pud_val(pud) & PTE_MASK))
+#define pud_page(pud) ((struct page *) __va(pud_val(pud) & PTE_PFN_MASK))
 
-#define pud_page_vaddr(pud) ((unsigned long) __va(pud_val(pud) & PTE_MASK))
+#define pud_page_vaddr(pud) ((unsigned long) __va(pud_val(pud) & PTE_PFN_MASK))
 
 
 /* Find an entry in the second-level page table.. */
@@ -160,7 +160,7 @@
 
 static inline unsigned long pte_pfn(pte_t pte)
 {
-	return (pte_val(pte) & PTE_MASK) >> PAGE_SHIFT;
+	return (pte_val(pte) & PTE_PFN_MASK) >> PAGE_SHIFT;
 }
 
 /*
===================================================================
--- a/include/asm-x86/pgtable.h
+++ b/include/asm-x86/pgtable.h
@@ -53,7 +53,7 @@
 			 _PAGE_DIRTY)
 
 /* Set of bits not changed in pte_modify */
-#define _PAGE_CHG_MASK	(PTE_MASK | _PAGE_PCD | _PAGE_PWT |		\
+#define _PAGE_CHG_MASK	(PTE_PFN_MASK | _PAGE_PCD | _PAGE_PWT |		\
 			 _PAGE_ACCESSED | _PAGE_DIRTY)
 
 #define _PAGE_CACHE_MASK	(_PAGE_PCD | _PAGE_PWT)
@@ -286,7 +286,7 @@
 	return __pgprot(preservebits | addbits);
 }
 
-#define pte_pgprot(x) __pgprot(pte_flags(x) & ~PTE_MASK)
+#define pte_pgprot(x) __pgprot(pte_flags(x) & ~PTE_PFN_MASK)
 
 #define canon_pgprot(p) __pgprot(pgprot_val(p) & __supported_pte_mask)
 
===================================================================
--- a/include/asm-x86/pgtable_32.h
+++ b/include/asm-x86/pgtable_32.h
@@ -94,7 +94,7 @@
 /* To avoid harmful races, pmd_none(x) should check only the lower when PAE */
 #define pmd_none(x)	(!(unsigned long)pmd_val((x)))
 #define pmd_present(x)	(pmd_val((x)) & _PAGE_PRESENT)
-#define pmd_bad(x) ((pmd_val(x) & (~PTE_MASK & ~_PAGE_USER)) != _KERNPG_TABLE)
+#define pmd_bad(x) ((pmd_val(x) & (~PTE_PFN_MASK & ~_PAGE_USER)) != _KERNPG_TABLE)
 
 #define pages_to_mb(x) ((x) >> (20-PAGE_SHIFT))
 
@@ -145,7 +145,7 @@
 #define pmd_page(pmd) (pfn_to_page(pmd_val((pmd)) >> PAGE_SHIFT))
 
 #define pmd_page_vaddr(pmd)					\
-	((unsigned long)__va(pmd_val((pmd)) & PTE_MASK))
+	((unsigned long)__va(pmd_val((pmd)) & PTE_PFN_MASK))
 
 #if defined(CONFIG_HIGHPTE)
 #define pte_offset_map(dir, address)					\
===================================================================
--- a/include/asm-x86/pgtable_64.h
+++ b/include/asm-x86/pgtable_64.h
@@ -158,17 +158,17 @@
 
 static inline int pgd_bad(pgd_t pgd)
 {
-	return (pgd_val(pgd) & ~(PTE_MASK | _PAGE_USER)) != _KERNPG_TABLE;
+	return (pgd_val(pgd) & ~(PTE_PFN_MASK | _PAGE_USER)) != _KERNPG_TABLE;
 }
 
 static inline int pud_bad(pud_t pud)
 {
-	return (pud_val(pud) & ~(PTE_MASK | _PAGE_USER)) != _KERNPG_TABLE;
+	return (pud_val(pud) & ~(PTE_PFN_MASK | _PAGE_USER)) != _KERNPG_TABLE;
 }
 
 static inline int pmd_bad(pmd_t pmd)
 {
-	return (pmd_val(pmd) & ~(PTE_MASK | _PAGE_USER)) != _KERNPG_TABLE;
+	return (pmd_val(pmd) & ~(PTE_PFN_MASK | _PAGE_USER)) != _KERNPG_TABLE;
 }
 
 #define pte_none(x)	(!pte_val((x)))
@@ -199,7 +199,7 @@
  * Level 4 access.
  */
 #define pgd_page_vaddr(pgd)						\
-	((unsigned long)__va((unsigned long)pgd_val((pgd)) & PTE_MASK))
+	((unsigned long)__va((unsigned long)pgd_val((pgd)) & PTE_PFN_MASK))
 #define pgd_page(pgd)		(pfn_to_page(pgd_val((pgd)) >> PAGE_SHIFT))
 #define pgd_present(pgd) (pgd_val(pgd) & _PAGE_PRESENT)
 static inline int pgd_large(pgd_t pgd) { return 0; }
@@ -222,7 +222,7 @@
 }
 
 /* PMD  - Level 2 access */
-#define pmd_page_vaddr(pmd) ((unsigned long) __va(pmd_val((pmd)) & PTE_MASK))
+#define pmd_page_vaddr(pmd) ((unsigned long) __va(pmd_val((pmd)) & PTE_PFN_MASK))
 #define pmd_page(pmd)		(pfn_to_page(pmd_val((pmd)) >> PAGE_SHIFT))
 
 #define pmd_index(address) (((address) >> PMD_SHIFT) & (PTRS_PER_PMD - 1))
===================================================================
--- a/include/asm-x86/xen/page.h
+++ b/include/asm-x86/xen/page.h
@@ -124,7 +124,7 @@
 
 static inline unsigned long pte_mfn(pte_t pte)
 {
-	return (pte.pte & PTE_MASK) >> PAGE_SHIFT;
+	return (pte.pte & PTE_PFN_MASK) >> PAGE_SHIFT;
 }
 
 static inline pte_t mfn_pte(unsigned long page_nr, pgprot_t pgprot)


