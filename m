Return-Path: <linux-kernel-owner+w=401wt.eu-S1751062AbXBUE1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751062AbXBUE1P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 23:27:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751054AbXBUE1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 23:27:15 -0500
Received: from cantor.suse.de ([195.135.220.2]:48755 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823AbXBUE1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 23:27:14 -0500
Date: Wed, 21 Feb 2007 05:27:12 +0100
From: Nick Piggin <npiggin@suse.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [patch] mm: remove gcc workaround
Message-ID: <20070221042712.GA28623@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Minimum gcc version is 3.2 now. However, with likely profiling, even
modern gcc versions cannot always eliminate the call.

Replace the placeholder functions with the more conventional empty static
inlines, which should be optimal for everyone.

Signed-off-by: Nick Piggin <npiggin@suse.de>

Index: linux-2.6/mm/memory.c
===================================================================
--- linux-2.6.orig/mm/memory.c
+++ linux-2.6/mm/memory.c
@@ -2539,12 +2539,6 @@ int __pud_alloc(struct mm_struct *mm, pg
 	spin_unlock(&mm->page_table_lock);
 	return 0;
 }
-#else
-/* Workaround for gcc 2.96 */
-int __pud_alloc(struct mm_struct *mm, pgd_t *pgd, unsigned long address)
-{
-	return 0;
-}
 #endif /* __PAGETABLE_PUD_FOLDED */
 
 #ifndef __PAGETABLE_PMD_FOLDED
@@ -2573,12 +2567,6 @@ int __pmd_alloc(struct mm_struct *mm, pu
 	spin_unlock(&mm->page_table_lock);
 	return 0;
 }
-#else
-/* Workaround for gcc 2.96 */
-int __pmd_alloc(struct mm_struct *mm, pud_t *pud, unsigned long address)
-{
-	return 0;
-}
 #endif /* __PAGETABLE_PMD_FOLDED */
 
 int make_pages_present(unsigned long addr, unsigned long end)
Index: linux-2.6/include/linux/mm.h
===================================================================
--- linux-2.6.orig/include/linux/mm.h
+++ linux-2.6/include/linux/mm.h
@@ -855,8 +855,26 @@ static inline int vma_wants_writenotify(
 
 extern pte_t *FASTCALL(get_locked_pte(struct mm_struct *mm, unsigned long addr, spinlock_t **ptl));
 
+#ifdef __PAGETABLE_PUD_FOLDED
+static inline int __pud_alloc(struct mm_struct *mm, pgd_t *pgd,
+						unsigned long address)
+{
+	return 0;
+}
+#else
 int __pud_alloc(struct mm_struct *mm, pgd_t *pgd, unsigned long address);
+#endif
+
+#ifdef __PAGETABLE_PMD_FOLDED
+static inline int __pmd_alloc(struct mm_struct *mm, pud_t *pud,
+						unsigned long address)
+{
+	return 0;
+}
+#else
 int __pmd_alloc(struct mm_struct *mm, pud_t *pud, unsigned long address);
+#endif
+
 int __pte_alloc(struct mm_struct *mm, pmd_t *pmd, unsigned long address);
 int __pte_alloc_kernel(pmd_t *pmd, unsigned long address);
 
