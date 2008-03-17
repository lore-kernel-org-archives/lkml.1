Return-Path: <linux-kernel-owner+w=401wt.eu-S1758638AbYCRFe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758638AbYCRFe2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 01:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753727AbYCRFYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 01:24:33 -0400
Received: from gw.goop.org ([64.81.55.164]:37852 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752835AbYCRFYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 01:24:08 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 06 of 31] x86: move pte functions into common asm/pgalloc.h
X-Mercurial-Node: 82cbca231a9d9c4a46ae13ac1bc83b1b505b47da
Message-Id: <82cbca231a9d9c4a46ae.1205797017@localhost>
In-Reply-To: <patchbomb.1205797011@localhost>
Date: Mon, 17 Mar 2008 16:36:57 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Ian Campbell <ijc@hellion.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Common definitions for 2-level pagetable functions.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/mm/init_64.c        |    6 ------
 arch/x86/mm/pgtable.c        |    7 +++++++
 arch/x86/mm/pgtable_32.c     |    7 -------
 include/asm-x86/pgalloc.h    |   16 ++++++++++++++++
 include/asm-x86/pgalloc_32.h |   18 ------------------
 include/asm-x86/pgalloc_64.h |   16 ----------------
 6 files changed, 23 insertions(+), 47 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -848,12 +848,6 @@
 }
 #endif
 
-void __pte_free_tlb(struct mmu_gather *tlb, struct page *pte)
-{
-	pgtable_page_dtor(pte);
-	tlb_remove_page(tlb, pte);
-}
-
 void __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd)
 {
 	tlb_remove_page(tlb, virt_to_page(pmd));
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -19,6 +19,13 @@
 	if (pte)
 		pgtable_page_ctor(pte);
 	return pte;
+}
+
+void __pte_free_tlb(struct mmu_gather *tlb, struct page *pte)
+{
+	pgtable_page_dtor(pte);
+	paravirt_release_pt(page_to_pfn(pte));
+	tlb_remove_page(tlb, pte);
 }
 
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/mm/pgtable_32.c b/arch/x86/mm/pgtable_32.c
--- a/arch/x86/mm/pgtable_32.c
+++ b/arch/x86/mm/pgtable_32.c
@@ -173,13 +173,6 @@
 	__VMALLOC_RESERVE += reserve;
 }
 
-void __pte_free_tlb(struct mmu_gather *tlb, struct page *pte)
-{
-	pgtable_page_dtor(pte);
-	paravirt_release_pt(page_to_pfn(pte));
-	tlb_remove_page(tlb, pte);
-}
-
 #ifdef CONFIG_X86_PAE
 
 void __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd)
diff --git a/include/asm-x86/pgalloc.h b/include/asm-x86/pgalloc.h
--- a/include/asm-x86/pgalloc.h
+++ b/include/asm-x86/pgalloc.h
@@ -24,6 +24,22 @@
 extern pte_t *pte_alloc_one_kernel(struct mm_struct *, unsigned long);
 extern pgtable_t pte_alloc_one(struct mm_struct *, unsigned long);
 
+/* Should really implement gc for free page table pages. This could be
+   done with a reference count in struct page. */
+
+static inline void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
+{
+	BUG_ON((unsigned long)pte & (PAGE_SIZE-1));
+	free_page((unsigned long)pte);
+}
+
+static inline void pte_free(struct mm_struct *mm, struct page *pte)
+{
+	__free_page(pte);
+}
+
+extern void __pte_free_tlb(struct mmu_gather *tlb, struct page *pte);
+
 #ifdef CONFIG_X86_32
 # include "pgalloc_32.h"
 #else
diff --git a/include/asm-x86/pgalloc_32.h b/include/asm-x86/pgalloc_32.h
--- a/include/asm-x86/pgalloc_32.h
+++ b/include/asm-x86/pgalloc_32.h
@@ -16,24 +16,6 @@
 	set_pmd(pmd, __pmd(((pteval_t)pfn << PAGE_SHIFT) | _PAGE_TABLE));
 }
 #define pmd_pgtable(pmd) pmd_page(pmd)
-
-/*
- * Allocate and free page tables.
- */
-
-static inline void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
-{
-	free_page((unsigned long)pte);
-}
-
-static inline void pte_free(struct mm_struct *mm, pgtable_t pte)
-{
-	pgtable_page_dtor(pte);
-	__free_page(pte);
-}
-
-
-extern void __pte_free_tlb(struct mmu_gather *tlb, struct page *pte);
 
 #ifdef CONFIG_X86_PAE
 /*
diff --git a/include/asm-x86/pgalloc_64.h b/include/asm-x86/pgalloc_64.h
--- a/include/asm-x86/pgalloc_64.h
+++ b/include/asm-x86/pgalloc_64.h
@@ -47,22 +47,6 @@
 	free_page((unsigned long)pud);
 }
 
-/* Should really implement gc for free page table pages. This could be
-   done with a reference count in struct page. */
-
-static inline void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
-{
-	BUG_ON((unsigned long)pte & (PAGE_SIZE-1));
-	free_page((unsigned long)pte); 
-}
-
-static inline void pte_free(struct mm_struct *mm, pgtable_t pte)
-{
-	pgtable_page_dtor(pte);
-	__free_page(pte);
-} 
-
-extern void __pte_free_tlb(struct mmu_gather *tlb, struct page *pte);
 extern void __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd);
 extern void __pud_free_tlb(struct mmu_gather *tlb, pud_t *pud);
 


