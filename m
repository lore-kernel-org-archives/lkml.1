Return-Path: <linux-kernel-owner+w=401wt.eu-S932788AbYBBJJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932788AbYBBJJR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 04:09:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761253AbYBBJHB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 04:07:01 -0500
Received: from gw.goop.org ([64.81.55.164]:56633 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758017AbYBBJG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 04:06:57 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 4 of 7] x86: move pte functions into common asm/pgalloc.h
X-Mercurial-Node: 59bc53e1690feb091fa3d4b74b4c12361a0c316c
Message-Id: <59bc53e1690feb091fa3.1201943116@localhost>
In-Reply-To: <patchbomb.1201943112@localhost>
Date: Sat, 02 Feb 2008 01:05:16 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Jan Beulich <jbeulich@novell.com>,
       Eduardo Pereira Habkost <ehabkost@redhat.com>,
       Ian Campbell <ijc@hellion.org.uk>, H Peter Anvin <hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Common definitions for 2-level pagetable functions.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
---
 arch/x86/mm/pgtable.c        |    6 ++++++
 arch/x86/mm/pgtable_32.c     |    6 ------
 include/asm-x86/pgalloc.h    |   16 ++++++++++++++++
 include/asm-x86/pgalloc_32.h |   17 -----------------
 include/asm-x86/pgalloc_64.h |   19 -------------------
 5 files changed, 22 insertions(+), 42 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -843,11 +843,6 @@
 }
 #endif
 
-void __pte_free_tlb(struct mmu_gather *tlb, struct page *pte)
-{
-	tlb_remove_page(tlb, pte);
-}
-
 void __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd)
 {
 	tlb_remove_page(tlb, virt_to_page(pmd));
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -16,6 +16,12 @@
 	pte = alloc_pages(GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO, 0);
 #endif
 	return pte;
+}
+
+void __pte_free_tlb(struct mmu_gather *tlb, struct page *pte)
+{
+	paravirt_release_pt(page_to_pfn(pte));
+	tlb_remove_page(tlb, pte);
 }
 
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/mm/pgtable_32.c b/arch/x86/mm/pgtable_32.c
--- a/arch/x86/mm/pgtable_32.c
+++ b/arch/x86/mm/pgtable_32.c
@@ -178,12 +178,6 @@
 	__VMALLOC_RESERVE += reserve;
 }
 
-void __pte_free_tlb(struct mmu_gather *tlb, struct page *pte)
-{
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
 pte_t *pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address);
 struct page *pte_alloc_one(struct mm_struct *mm, unsigned long address);
 
+/* Should really implement gc for free page table pages. This could be
+   done with a reference count in struct page. */
+
+static inline void pte_free_kernel(pte_t *pte)
+{
+	BUG_ON((unsigned long)pte & (PAGE_SIZE-1));
+	free_page((unsigned long)pte);
+}
+
+static inline void pte_free(struct page *pte)
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
@@ -15,23 +15,6 @@
 	paravirt_alloc_pt(mm, pfn);
 	set_pmd(pmd, __pmd(((pteval_t)pfn << PAGE_SHIFT) | _PAGE_TABLE));
 }
-
-/*
- * Allocate and free page tables.
- */
-
-static inline void pte_free_kernel(pte_t *pte)
-{
-	free_page((unsigned long)pte);
-}
-
-static inline void pte_free(struct page *pte)
-{
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
@@ -45,21 +45,6 @@
 	free_page((unsigned long)pud);
 }
 
-/* Should really implement gc for free page table pages. This could be
-   done with a reference count in struct page. */
-
-static inline void pte_free_kernel(pte_t *pte)
-{
-	BUG_ON((unsigned long)pte & (PAGE_SIZE-1));
-	free_page((unsigned long)pte); 
-}
-
-static inline void pte_free(struct page *pte)
-{
-	__free_page(pte);
-}
-
-extern void __pte_free_tlb(struct mmu_gather *tlb, struct page *pte);
 extern void __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd);
 extern void __pud_free_tlb(struct mmu_gather *tlb, pud_t *pud);
 


