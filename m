Return-Path: <linux-kernel-owner+w=401wt.eu-S933244AbYBBJLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933244AbYBBJLm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 04:11:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765686AbYBBJHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 04:07:10 -0500
Received: from gw.goop.org ([64.81.55.164]:56646 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759559AbYBBJHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 04:07:01 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 5 of 7] x86: move pmd functions into common asm/pgalloc.h
X-Mercurial-Node: eac039c139d4b72a41e61bddbb829e686e1e0f96
Message-Id: <eac039c139d4b72a41e6.1201943117@localhost>
In-Reply-To: <patchbomb.1201943112@localhost>
Date: Sat, 02 Feb 2008 01:05:17 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Jan Beulich <jbeulich@novell.com>,
       Eduardo Pereira Habkost <ehabkost@redhat.com>,
       Ian Campbell <ijc@hellion.org.uk>, H Peter Anvin <hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Common definitions for 3-level pagetable functions.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
---
 arch/x86/mm/pgtable.c        |    8 ++++++++
 arch/x86/mm/pgtable_32.c     |   10 ----------
 include/asm-x86/pgalloc.h    |   31 +++++++++++++++++++++++++++++++
 include/asm-x86/pgalloc_32.h |   31 -------------------------------
 include/asm-x86/pgalloc_64.h |   26 --------------------------
 5 files changed, 39 insertions(+), 67 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -843,11 +843,6 @@
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
@@ -23,6 +23,14 @@
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
@@ -177,13 +177,3 @@
 	__FIXADDR_TOP = -reserve - PAGE_SIZE;
 	__VMALLOC_RESERVE += reserve;
 }
-
-#ifdef CONFIG_X86_PAE
-
-void __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd)
-{
-	paravirt_release_pd(__pa(pmd) >> PAGE_SHIFT);
-	tlb_remove_page(tlb, virt_to_page(pmd));
-}
-
-#endif
diff --git a/include/asm-x86/pgalloc.h b/include/asm-x86/pgalloc.h
--- a/include/asm-x86/pgalloc.h
+++ b/include/asm-x86/pgalloc.h
@@ -40,6 +40,37 @@
 
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
+#if PAGETABLE_LEVELS > 2
+static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long addr)
+{
+	return (pmd_t *)get_zeroed_page(GFP_KERNEL|__GFP_REPEAT);
+}
+
+static inline void pmd_free(pmd_t *pmd)
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
@@ -1,38 +1,7 @@
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
-static inline void pmd_free(pmd_t *pmd)
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
@@ -16,22 +11,6 @@
 static inline void pgd_populate(struct mm_struct *mm, pgd_t *pgd, pud_t *pud)
 {
 	set_pgd(pgd, __pgd(_PAGE_TABLE | __pa(pud)));
-}
-
-static inline void pmd_populate(struct mm_struct *mm, pmd_t *pmd, struct page *pte)
-{
-	set_pmd(pmd, __pmd(_PAGE_TABLE | (page_to_pfn(pte) << PAGE_SHIFT)));
-}
-
-static inline void pmd_free(pmd_t *pmd)
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
@@ -45,7 +24,6 @@
 	free_page((unsigned long)pud);
 }
 
-extern void __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd);
 extern void __pud_free_tlb(struct mmu_gather *tlb, pud_t *pud);
 
 #endif /* _X86_64_PGALLOC_H */


