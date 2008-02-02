Return-Path: <linux-kernel-owner+w=401wt.eu-S932634AbYBBJIC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932634AbYBBJIC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 04:08:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758929AbYBBJG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 04:06:59 -0500
Received: from gw.goop.org ([64.81.55.164]:56616 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753267AbYBBJG4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 04:06:56 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 1 of 7] x86: convert pgalloc_64.h from macros to inlines
X-Mercurial-Node: 0d893168b08e5e0d24c22d884951b18e650c5f6b
Message-Id: <0d893168b08e5e0d24c2.1201943113@localhost>
In-Reply-To: <patchbomb.1201943112@localhost>
Date: Sat, 02 Feb 2008 01:05:13 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Jan Beulich <jbeulich@novell.com>,
       Eduardo Pereira Habkost <ehabkost@redhat.com>,
       Ian Campbell <ijc@hellion.org.uk>, H Peter Anvin <hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert asm-x86/pgalloc_64.h from macros into inline functions.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
---
 include/asm-x86/pgalloc_64.h |   41 ++++++++++++++++++++++++++++++-----------
 1 file changed, 30 insertions(+), 11 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -842,3 +842,18 @@
 	return 0;
 }
 #endif
+
+void __pte_free_tlb(struct mmu_gather *tlb, struct page *pte)
+{
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
 
 static inline void pmd_populate(struct mm_struct *mm, pmd_t *pmd, struct page *pte)
 {
@@ -109,11 +117,10 @@
 static inline void pte_free(struct page *pte)
 {
 	__free_page(pte);
-} 
+}
 
-#define __pte_free_tlb(tlb,pte) tlb_remove_page((tlb),(pte))
-
-#define __pmd_free_tlb(tlb,x)   tlb_remove_page((tlb),virt_to_page(x))
-#define __pud_free_tlb(tlb,x)   tlb_remove_page((tlb),virt_to_page(x))
+extern void __pte_free_tlb(struct mmu_gather *tlb, struct page *pte);
+extern void __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd);
+extern void __pud_free_tlb(struct mmu_gather *tlb, pud_t *pud);
 
 #endif /* _X86_64_PGALLOC_H */


