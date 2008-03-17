Return-Path: <linux-kernel-owner+w=401wt.eu-S1755831AbYCRF0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831AbYCRF0d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 01:26:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753477AbYCRFYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 01:24:14 -0400
Received: from gw.goop.org ([64.81.55.164]:37846 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752606AbYCRFYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 01:24:07 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 23 of 31] x86: unify pgd ctor/dtor
X-Mercurial-Node: 7f6034426f0ecf0f084bcb939bd053d9c742ac78
Message-Id: <7f6034426f0ecf0f084b.1205797034@localhost>
In-Reply-To: <patchbomb.1205797011@localhost>
Date: Mon, 17 Mar 2008 16:37:14 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Ian Campbell <ijc@hellion.org.uk>,
       Andi Kleen <ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All pagetables need fundamentally the same setup and destruction, so
just use the same code for everything.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Andi Kleen <ak@suse.de>
---
 arch/x86/mm/pgtable.c        |   59 +++++++++---------------------------------
 include/asm-x86/pgtable.h    |   16 +++++++++++
 include/asm-x86/pgtable_32.h |   15 ----------
 include/asm-x86/pgtable_64.h |    2 -
 4 files changed, 30 insertions(+), 62 deletions(-)

diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -59,50 +59,6 @@
 	list_del(&page->lru);
 }
 
-#ifdef CONFIG_X86_64
-pgd_t *pgd_alloc(struct mm_struct *mm)
-{
-	unsigned boundary;
-	pgd_t *pgd = (pgd_t *)__get_free_page(GFP_KERNEL|__GFP_REPEAT);
-	unsigned long flags;
-	if (!pgd)
-		return NULL;
-	spin_lock_irqsave(&pgd_lock, flags);
-	pgd_list_add(pgd);
-	spin_unlock_irqrestore(&pgd_lock, flags);
-	/*
-	 * Copy kernel pointers in from init.
-	 * Could keep a freelist or slab cache of those because the kernel
-	 * part never changes.
-	 */
-	boundary = pgd_index(__PAGE_OFFSET);
-	memset(pgd, 0, boundary * sizeof(pgd_t));
-	memcpy(pgd + boundary,
-	       init_level4_pgt + boundary,
-	       (PTRS_PER_PGD - boundary) * sizeof(pgd_t));
-	return pgd;
-}
-
-void pgd_free(struct mm_struct *mm, pgd_t *pgd)
-{
-	unsigned long flags;
-	BUG_ON((unsigned long)pgd & (PAGE_SIZE-1));
-	spin_lock_irqsave(&pgd_lock, flags);
-	pgd_list_del(pgd);
-	spin_unlock_irqrestore(&pgd_lock, flags);
-	free_page((unsigned long)pgd);
-}
-#else
-/*
- * List of all pgd's needed for non-PAE so it can invalidate entries
- * in both cached and uncached pgd's; not needed for PAE since the
- * kernel pmd is shared. If PAE were not to share the pmd a similar
- * tactic would be needed. This is essentially codepath-based locking
- * against pageattr.c; it is the unique case in which a valid change
- * of kernel pagetables can't be lazily synchronized by vmalloc faults.
- * vmalloc faults work because attached pagetables are never freed.
- * -- wli
- */
 #define UNSHARED_PTRS_PER_PGD				\
 	(SHARED_KERNEL_PMD ? KERNEL_PGD_BOUNDARY : PTRS_PER_PGD)
 
@@ -120,7 +76,8 @@
 	   ptes in non-PAE, or shared PMD in PAE), then just copy the
 	   references from swapper_pg_dir. */
 	if (PAGETABLE_LEVELS == 2 ||
-	    (PAGETABLE_LEVELS == 3 && SHARED_KERNEL_PMD)) {
+	    (PAGETABLE_LEVELS == 3 && SHARED_KERNEL_PMD) ||
+	    PAGETABLE_LEVELS == 4) {
 		clone_pgd_range(pgd + KERNEL_PGD_BOUNDARY,
 				swapper_pg_dir + KERNEL_PGD_BOUNDARY,
 				KERNEL_PGD_PTRS);
@@ -148,6 +105,17 @@
 	pgd_list_del(pgd);
 	spin_unlock_irqrestore(&pgd_lock, flags);
 }
+
+/*
+ * List of all pgd's needed for non-PAE so it can invalidate entries
+ * in both cached and uncached pgd's; not needed for PAE since the
+ * kernel pmd is shared. If PAE were not to share the pmd a similar
+ * tactic would be needed. This is essentially codepath-based locking
+ * against pageattr.c; it is the unique case in which a valid change
+ * of kernel pagetables can't be lazily synchronized by vmalloc faults.
+ * vmalloc faults work because attached pagetables are never freed.
+ * -- wli
+ */
 
 #ifdef CONFIG_X86_PAE
 /*
@@ -246,7 +214,6 @@
 	pgd_dtor(pgd);
 	free_page((unsigned long)pgd);
 }
-#endif
 
 int ptep_set_access_flags(struct vm_area_struct *vma,
 			  unsigned long address, pte_t *ptep,
diff --git a/include/asm-x86/pgtable.h b/include/asm-x86/pgtable.h
--- a/include/asm-x86/pgtable.h
+++ b/include/asm-x86/pgtable.h
@@ -344,6 +344,22 @@
 	pte_update(mm, addr, ptep);
 }
 
+/*
+ * clone_pgd_range(pgd_t *dst, pgd_t *src, int count);
+ *
+ *  dst - pointer to pgd range anwhere on a pgd page
+ *  src - ""
+ *  count - the number of pgds to copy.
+ *
+ * dst and src can be on the same page, but the range must not overlap,
+ * and must not cross a page boundary.
+ */
+static inline void clone_pgd_range(pgd_t *dst, pgd_t *src, int count)
+{
+       memcpy(dst, src, count * sizeof(pgd_t));
+}
+
+
 #include <asm-generic/pgtable.h>
 #endif	/* __ASSEMBLY__ */
 
diff --git a/include/asm-x86/pgtable_32.h b/include/asm-x86/pgtable_32.h
--- a/include/asm-x86/pgtable_32.h
+++ b/include/asm-x86/pgtable_32.h
@@ -104,21 +104,6 @@
 #else
 # include <asm/pgtable-2level.h>
 #endif
-
-/*
- * clone_pgd_range(pgd_t *dst, pgd_t *src, int count);
- *
- *  dst - pointer to pgd range anwhere on a pgd page
- *  src - ""
- *  count - the number of pgds to copy.
- *
- * dst and src can be on the same page, but the range must not overlap,
- * and must not cross a page boundary.
- */
-static inline void clone_pgd_range(pgd_t *dst, pgd_t *src, int count)
-{
-       memcpy(dst, src, count * sizeof(pgd_t));
-}
 
 /*
  * Macro to mark a page protection value as "uncacheable".  On processors which do not support
diff --git a/include/asm-x86/pgtable_64.h b/include/asm-x86/pgtable_64.h
--- a/include/asm-x86/pgtable_64.h
+++ b/include/asm-x86/pgtable_64.h
@@ -24,7 +24,7 @@
 
 #endif /* !__ASSEMBLY__ */
 
-#define SHARED_KERNEL_PMD	1
+#define SHARED_KERNEL_PMD	0
 
 /*
  * PGDIR_SHIFT determines what a top-level page table entry can map


