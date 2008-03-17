Return-Path: <linux-kernel-owner+w=401wt.eu-S1758325AbYCRFdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758325AbYCRFdg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 01:33:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753014AbYCRFYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 01:24:31 -0400
Received: from gw.goop.org ([64.81.55.164]:37854 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752882AbYCRFYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 01:24:09 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 07 of 31] x86: move pmd functions into common asm/pgalloc.h
X-Mercurial-Node: 048aa7d0d95a7b8998059999c094ca69f648919b
Message-Id: <048aa7d0d95a7b899805.1205797018@localhost>
In-Reply-To: <patchbomb.1205797011@localhost>
Date: Mon, 17 Mar 2008 16:36:58 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Ian Campbell <ijc@hellion.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Common definitions for 3-level pagetable functions.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/mm/init_64.c        |    5 -----
 arch/x86/mm/pgtable.c        |    8 ++++++++
 arch/x86/mm/pgtable_32.c     |   10 ----------
 include/asm-x86/pgalloc.h    |   33 +++++++++++++++++++++++++++++++++
 include/asm-x86/pgalloc_32.h |   32 --------------------------------
 include/asm-x86/pgalloc_64.h |   24 ------------------------
 6 files changed, 41 insertions(+), 71 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -848,11 +848,6 @@
 }
 #endif
 
-void __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd)
-{
-	tlb_remove_page(tlb, virt_to_page(pmd));
-}
-
 void __pud_free_tlb(struct mmu_gather *tlb, pud_t *pud)
 {
 	tlb_remove_page(tlb, virt_to_page(pud));
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -27,6 +27,14 @@
 	paravirt_release_pt(page_to_pfn(pte));
 	tlb_remove_page(tlb, pte);
 }
+
+#if PAGETABLE_LEVELS > 2
+void __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd)
+{
+	paravirt_release_pd(__pa(pmd) >> PAGE_SHIFT);
+	tlb_remove_page(tlb, virt_to_page(pmd));
+}
+#endif	/* PAGETABLE_LEVELS > 2 */
 
 #ifdef CONFIG_X86_64
 static inline void pgd_list_add(pgd_t *pgd)
diff --git a/arch/x86/mm/pgtable_32.c b/arch/x86/mm/pgtable_32.c
--- a/arch/x86/mm/pgtable_32.c
+++ b/arch/x86/mm/pgtable_32.c
@@ -173,16 +173,6 @@
 	__VMALLOC_RESERVE += reserve;
 }
 
-#ifdef CONFIG_X86_PAE
-
-void __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd)
-{
-	paravirt_release_pd(__pa(pmd) >> PAGE_SHIFT);
-	tlb_remove_page(tlb, virt_to_page(pmd));
-}
-
-#endif
-
 int pmd_bad(pmd_t pmd)
 {
 	WARN_ON_ONCE(pmd_bad_v1(pmd) != pmd_bad_v2(pmd));
diff --git a/include/asm-x86/pgalloc.h b/include/asm-x86/pgalloc.h
--- a/include/asm-x86/pgalloc.h
+++ b/include/asm-x86/pgalloc.h
@@ -40,6 +40,39 @@
 
 extern void __pte_free_tlb(struct mmu_gather *tlb, struct page *pte);
 
+static inline void pmd_populate_kernel(struct mm_struct *mm,
+				       pmd_t *pmd, pte_t *pte)
+{
+	paravirt_alloc_pt(mm, __pa(pte) >> PAGE_SHIFT);
+	set_pmd(pmd, __pmd(__pa(pte) | _PAGE_TABLE));
+}
+
+static inline void pmd_populate(struct mm_struct *mm, pmd_t *pmd,
+				struct page *pte)
+{
+	unsigned long pfn = page_to_pfn(pte);
+
+	paravirt_alloc_pt(mm, pfn);
+	set_pmd(pmd, __pmd(((pteval_t)pfn << PAGE_SHIFT) | _PAGE_TABLE));
+}
+
+#define pmd_pgtable(pmd) pmd_page(pmd)
+
+#if PAGETABLE_LEVELS > 2
+static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long addr)
+{
+	return (pmd_t *)get_zeroed_page(GFP_KERNEL|__GFP_REPEAT);
+}
+
+static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
+{
+	BUG_ON((unsigned long)pmd & (PAGE_SIZE-1));
+	free_page((unsigned long)pmd);
+}
+
+extern void __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd);
+#endif	/* PAGETABLE_LEVELS > 2 */
+
 #ifdef CONFIG_X86_32
 # include "pgalloc_32.h"
 #else
diff --git a/include/asm-x86/pgalloc_32.h b/include/asm-x86/pgalloc_32.h
--- a/include/asm-x86/pgalloc_32.h
+++ b/include/asm-x86/pgalloc_32.h
@@ -1,39 +1,7 @@
 #ifndef _I386_PGALLOC_H
 #define _I386_PGALLOC_H
 
-static inline void pmd_populate_kernel(struct mm_struct *mm,
-				       pmd_t *pmd, pte_t *pte)
-{
-	paravirt_alloc_pt(mm, __pa(pte) >> PAGE_SHIFT);
-	set_pmd(pmd, __pmd(__pa(pte) | _PAGE_TABLE));
-}
-
-static inline void pmd_populate(struct mm_struct *mm, pmd_t *pmd, struct page *pte)
-{
-	unsigned long pfn = page_to_pfn(pte);
-
-	paravirt_alloc_pt(mm, pfn);
-	set_pmd(pmd, __pmd(((pteval_t)pfn << PAGE_SHIFT) | _PAGE_TABLE));
-}
-#define pmd_pgtable(pmd) pmd_page(pmd)
-
 #ifdef CONFIG_X86_PAE
-/*
- * In the PAE case we free the pmds as part of the pgd.
- */
-static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long addr)
-{
-	return (pmd_t *)get_zeroed_page(GFP_KERNEL|__GFP_REPEAT);
-}
-
-static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
-{
-	BUG_ON((unsigned long)pmd & (PAGE_SIZE-1));
-	free_page((unsigned long)pmd);
-}
-
-extern void __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd);
-
 static inline void pud_populate(struct mm_struct *mm, pud_t *pudp, pmd_t *pmd)
 {
 	paravirt_alloc_pd(mm, __pa(pmd) >> PAGE_SHIFT);
diff --git a/include/asm-x86/pgalloc_64.h b/include/asm-x86/pgalloc_64.h
--- a/include/asm-x86/pgalloc_64.h
+++ b/include/asm-x86/pgalloc_64.h
@@ -2,11 +2,6 @@
 #define _X86_64_PGALLOC_H
 
 #include <asm/pda.h>
-
-static inline void pmd_populate_kernel(struct mm_struct *mm, pmd_t *pmd, pte_t *pte)
-{
-	set_pmd(pmd, __pmd(_PAGE_TABLE | __pa(pte)));
-}
 
 static inline void pud_populate(struct mm_struct *mm, pud_t *pud, pmd_t *pmd)
 {
@@ -16,24 +11,6 @@
 static inline void pgd_populate(struct mm_struct *mm, pgd_t *pgd, pud_t *pud)
 {
 	set_pgd(pgd, __pgd(_PAGE_TABLE | __pa(pud)));
-}
-
-#define pmd_pgtable(pmd) pmd_page(pmd)
-
-static inline void pmd_populate(struct mm_struct *mm, pmd_t *pmd, struct page *pte)
-{
-	set_pmd(pmd, __pmd(_PAGE_TABLE | (page_to_pfn(pte) << PAGE_SHIFT)));
-}
-
-static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
-{
-	BUG_ON((unsigned long)pmd & (PAGE_SIZE-1));
-	free_page((unsigned long)pmd);
-}
-
-static inline pmd_t *pmd_alloc_one (struct mm_struct *mm, unsigned long addr)
-{
-	return (pmd_t *)get_zeroed_page(GFP_KERNEL|__GFP_REPEAT);
 }
 
 static inline pud_t *pud_alloc_one(struct mm_struct *mm, unsigned long addr)
@@ -47,7 +24,6 @@
 	free_page((unsigned long)pud);
 }
 
-extern void __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd);
 extern void __pud_free_tlb(struct mmu_gather *tlb, pud_t *pud);
 
 #endif /* _X86_64_PGALLOC_H */


