Return-Path: <linux-kernel-owner+w=401wt.eu-S932989AbYBBJLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932989AbYBBJLA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 04:11:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763711AbYBBJHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 04:07:08 -0500
Received: from gw.goop.org ([64.81.55.164]:56647 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759591AbYBBJHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 04:07:01 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 6 of 7] x86: move pud/pgd functions into common asm/pgalloc.h
X-Mercurial-Node: fe3ff49757e16a5b9290363c2f9102530861478f
Message-Id: <fe3ff49757e16a5b9290.1201943118@localhost>
In-Reply-To: <patchbomb.1201943112@localhost>
Date: Sat, 02 Feb 2008 01:05:18 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Jan Beulich <jbeulich@novell.com>,
       Eduardo Pereira Habkost <ehabkost@redhat.com>,
       Ian Campbell <ijc@hellion.org.uk>, H Peter Anvin <hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Common definitions for 4-level pagetable functions.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
---
 arch/x86/mm/pgtable.c        |    7 ++++++
 include/asm-x86/pgalloc.h    |   46 ++++++++++++++++++++++++++++++++++++------
 include/asm-x86/pgalloc_32.h |   24 ---------------------
 include/asm-x86/pgalloc_64.h |   32 -----------------------------
 4 files changed, 47 insertions(+), 62 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -842,8 +842,3 @@
 	return 0;
 }
 #endif
-
-void __pud_free_tlb(struct mmu_gather *tlb, pud_t *pud)
-{
-	tlb_remove_page(tlb, virt_to_page(pud));
-}
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -30,6 +30,13 @@
 	paravirt_release_pd(__pa(pmd) >> PAGE_SHIFT);
 	tlb_remove_page(tlb, virt_to_page(pmd));
 }
+
+#if PAGETABLE_LEVELS > 3
+void __pud_free_tlb(struct mmu_gather *tlb, pud_t *pud)
+{
+	tlb_remove_page(tlb, virt_to_page(pud));
+}
+#endif	/* PAGETABLE_LEVELS > 3 */
 #endif	/* PAGETABLE_LEVELS > 2 */
 
 #ifdef CONFIG_X86_64
diff --git a/include/asm-x86/pgalloc.h b/include/asm-x86/pgalloc.h
--- a/include/asm-x86/pgalloc.h
+++ b/include/asm-x86/pgalloc.h
@@ -69,12 +69,46 @@
 }
 
 extern void __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd);
+
+static inline void pud_populate(struct mm_struct *mm, pud_t *pudp, pmd_t *pmd)
+{
+	paravirt_alloc_pd(mm, __pa(pmd) >> PAGE_SHIFT);
+
+	/* Note: almost everything apart from _PAGE_PRESENT is
+	   reserved at the pmd (PDPT) level. */
+	set_pud(pudp, __pud(__pa(pmd) | _PAGE_PRESENT));
+
+#ifdef CONFIG_X86_PAE
+	/*
+	 * According to Intel App note "TLBs, Paging-Structure Caches,
+	 * and Their Invalidation", April 2007, document 317080-001,
+	 * section 8.1: in PAE mode we explicitly have to flush the
+	 * TLB via cr3 if the top-level pgd is changed...
+	 */
+	if (mm == current->active_mm)
+		write_cr3(read_cr3());
+#endif	/* CONFIG_X86_PAE */
+}
+
+#if PAGETABLE_LEVELS > 3
+static inline void pgd_populate(struct mm_struct *mm, pgd_t *pgd, pud_t *pud)
+{
+	set_pgd(pgd, __pgd(_PAGE_TABLE | __pa(pud)));
+}
+
+static inline pud_t *pud_alloc_one(struct mm_struct *mm, unsigned long addr)
+{
+	return (pud_t *)get_zeroed_page(GFP_KERNEL|__GFP_REPEAT);
+}
+
+static inline void pud_free(pud_t *pud)
+{
+	BUG_ON((unsigned long)pud & (PAGE_SIZE-1));
+	free_page((unsigned long)pud);
+}
+
+extern void __pud_free_tlb(struct mmu_gather *tlb, pud_t *pud);
+#endif	/* PAGETABLE_LEVELS > 3 */
 #endif	/* PAGETABLE_LEVELS > 2 */
 
-#ifdef CONFIG_X86_32
-# include "pgalloc_32.h"
-#else
-# include "pgalloc_64.h"
-#endif
-
 #endif	/* _ASM_X86_PGALLOC_H */
diff --git a/include/asm-x86/pgalloc_32.h b/include/asm-x86/pgalloc_32.h
deleted file mode 100644
--- a/include/asm-x86/pgalloc_32.h
+++ /dev/null
@@ -1,24 +0,0 @@
-#ifndef _I386_PGALLOC_H
-#define _I386_PGALLOC_H
-
-#ifdef CONFIG_X86_PAE
-static inline void pud_populate(struct mm_struct *mm, pud_t *pudp, pmd_t *pmd)
-{
-	paravirt_alloc_pd(mm, __pa(pmd) >> PAGE_SHIFT);
-
-	/* Note: almost everything apart from _PAGE_PRESENT is
-	   reserved at the pmd (PDPT) level. */
-	set_pud(pudp, __pud(__pa(pmd) | _PAGE_PRESENT));
-
-	/*
-	 * According to Intel App note "TLBs, Paging-Structure Caches,
-	 * and Their Invalidation", April 2007, document 317080-001,
-	 * section 8.1: in PAE mode we explicitly have to flush the
-	 * TLB via cr3 if the top-level pgd is changed...
-	 */
-	if (mm == current->active_mm)
-		write_cr3(read_cr3());
-}
-#endif	/* CONFIG_X86_PAE */
-
-#endif /* _I386_PGALLOC_H */
diff --git a/include/asm-x86/pgalloc_64.h b/include/asm-x86/pgalloc_64.h
deleted file mode 100644
--- a/include/asm-x86/pgalloc_64.h
+++ /dev/null
@@ -1,29 +0,0 @@
-#ifndef _X86_64_PGALLOC_H
-#define _X86_64_PGALLOC_H
-
-#include <asm/pda.h>
-
-static inline void pud_populate(struct mm_struct *mm, pud_t *pud, pmd_t *pmd)
-{
-	set_pud(pud, __pud(_PAGE_TABLE | __pa(pmd)));
-}
-
-static inline void pgd_populate(struct mm_struct *mm, pgd_t *pgd, pud_t *pud)
-{
-	set_pgd(pgd, __pgd(_PAGE_TABLE | __pa(pud)));
-}
-
-static inline pud_t *pud_alloc_one(struct mm_struct *mm, unsigned long addr)
-{
-	return (pud_t *)get_zeroed_page(GFP_KERNEL|__GFP_REPEAT);
-}
-
-static inline void pud_free (pud_t *pud)
-{
-	BUG_ON((unsigned long)pud & (PAGE_SIZE-1));
-	free_page((unsigned long)pud);
-}
-
-extern void __pud_free_tlb(struct mmu_gather *tlb, pud_t *pud);
-
-#endif /* _X86_64_PGALLOC_H */


