Return-Path: <linux-kernel-owner+w=401wt.eu-S1756427AbYCRF1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427AbYCRF1x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 01:27:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753975AbYCRFYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 01:24:17 -0400
Received: from gw.goop.org ([64.81.55.164]:37844 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752829AbYCRFYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 01:24:08 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 03 of 31] x86: convert pgalloc_64.h from macros to inlines
X-Mercurial-Node: f7d9e8f672f4ca3d0e22b66593b94ea0a0617d8d
Message-Id: <f7d9e8f672f4ca3d0e22.1205797014@localhost>
In-Reply-To: <patchbomb.1205797011@localhost>
Date: Mon, 17 Mar 2008 16:36:54 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Ian Campbell <ijc@hellion.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert asm-x86/pgalloc_64.h from macros into functions (#include hell
prevents __*_free_tlb from being inline, but they're probably a bit
big to inline anyway).

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/mm/init_64.c        |   16 ++++++++++++++++
 include/asm-x86/pgalloc_64.h |   33 ++++++++++++++++++---------------
 2 files changed, 34 insertions(+), 15 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -847,3 +847,19 @@
 	return 0;
 }
 #endif
+
+void __pte_free_tlb(struct mmu_gather *tlb, struct page *pte)
+{
+	pgtable_page_dtor(pte);
+	tlb_remove_page(tlb, pte);
+}
+
+void __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd)
+{
+	tlb_remove_page(tlb, virt_to_page(pmd));
+}
+
+void __pud_free_tlb(struct mmu_gather *tlb, pud_t *pud)
+{
+	tlb_remove_page(tlb, virt_to_page(pud));
+}
diff --git a/include/asm-x86/pgalloc_64.h b/include/asm-x86/pgalloc_64.h
--- a/include/asm-x86/pgalloc_64.h
+++ b/include/asm-x86/pgalloc_64.h
@@ -1,16 +1,24 @@
 #ifndef _X86_64_PGALLOC_H
 #define _X86_64_PGALLOC_H
 
-#include <asm/pda.h>
 #include <linux/threads.h>
 #include <linux/mm.h>
+#include <asm/pda.h>
 
-#define pmd_populate_kernel(mm, pmd, pte) \
-		set_pmd(pmd, __pmd(_PAGE_TABLE | __pa(pte)))
-#define pud_populate(mm, pud, pmd) \
-		set_pud(pud, __pud(_PAGE_TABLE | __pa(pmd)))
-#define pgd_populate(mm, pgd, pud) \
-		set_pgd(pgd, __pgd(_PAGE_TABLE | __pa(pud)))
+static inline void pmd_populate_kernel(struct mm_struct *mm, pmd_t *pmd, pte_t *pte)
+{
+	set_pmd(pmd, __pmd(_PAGE_TABLE | __pa(pte)));
+}
+
+static inline void pud_populate(struct mm_struct *mm, pud_t *pud, pmd_t *pmd)
+{
+	set_pud(pud, __pud(_PAGE_TABLE | __pa(pmd)));
+}
+
+static inline void pgd_populate(struct mm_struct *mm, pgd_t *pgd, pud_t *pud)
+{
+	set_pgd(pgd, __pgd(_PAGE_TABLE | __pa(pud)));
+}
 
 #define pmd_pgtable(pmd) pmd_page(pmd)
 
@@ -121,13 +129,8 @@
 	__free_page(pte);
 } 
 
-#define __pte_free_tlb(tlb,pte)				\
-do {							\
-	pgtable_page_dtor((pte));				\
-	tlb_remove_page((tlb), (pte));			\
-} while (0)
-
-#define __pmd_free_tlb(tlb,x)   tlb_remove_page((tlb),virt_to_page(x))
-#define __pud_free_tlb(tlb,x)   tlb_remove_page((tlb),virt_to_page(x))
+extern void __pte_free_tlb(struct mmu_gather *tlb, struct page *pte);
+extern void __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd);
+extern void __pud_free_tlb(struct mmu_gather *tlb, pud_t *pud);
 
 #endif /* _X86_64_PGALLOC_H */


