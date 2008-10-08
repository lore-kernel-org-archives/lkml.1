Return-Path: <linux-kernel-owner+w=401wt.eu-S1756003AbYJHUBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003AbYJHUBw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 16:01:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753872AbYJHUBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 16:01:44 -0400
Received: from gw.goop.org ([64.81.55.164]:60714 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752146AbYJHUBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 16:01:43 -0400
Message-ID: <48ED11A3.3090605@goop.org>
Date: Wed, 08 Oct 2008 13:01:39 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080919)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] xen: use spin_lock_nest_lock when pinning a pagetable
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When pinning/unpinning a pagetable with split pte locks, we can end up
holding multiple pte locks at once (we need to hold the locks while
there's a pending batched hypercall affecting the pte page).  Because
all the pte locks are in the same lock class, lockdep thinks that
we're potentially taking a lock recursively.

This warning is spurious because we always take the pte locks while
holding mm->page_table_lock.  lockdep now has spin_lock_nest_lock to
express this kind of dominant lock use, so use it here so that lockdep
knows what's going on.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/mmu.c |   74 +++++++++++++++++++++++++++++++++-------------------
 arch/x86/xen/mmu.h |    3 --
 2 files changed, 48 insertions(+), 29 deletions(-)

===================================================================
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -651,9 +651,12 @@
  * For 64-bit, we must skip the Xen hole in the middle of the address
  * space, just after the big x86-64 virtual hole.
  */
-static int xen_pgd_walk(pgd_t *pgd, int (*func)(struct page *, enum pt_level),
+static int xen_pgd_walk(struct mm_struct *mm,
+			int (*func)(struct mm_struct *mm, struct page *,
+				    enum pt_level),
 			unsigned long limit)
 {
+	pgd_t *pgd = mm->pgd;
 	int flush = 0;
 	unsigned hole_low, hole_high;
 	unsigned pgdidx_limit, pudidx_limit, pmdidx_limit;
@@ -698,7 +701,7 @@
 		pud = pud_offset(&pgd[pgdidx], 0);
 
 		if (PTRS_PER_PUD > 1) /* not folded */
-			flush |= (*func)(virt_to_page(pud), PT_PUD);
+			flush |= (*func)(mm, virt_to_page(pud), PT_PUD);
 
 		for (pudidx = 0; pudidx < PTRS_PER_PUD; pudidx++) {
 			pmd_t *pmd;
@@ -713,7 +716,7 @@
 			pmd = pmd_offset(&pud[pudidx], 0);
 
 			if (PTRS_PER_PMD > 1) /* not folded */
-				flush |= (*func)(virt_to_page(pmd), PT_PMD);
+				flush |= (*func)(mm, virt_to_page(pmd), PT_PMD);
 
 			for (pmdidx = 0; pmdidx < PTRS_PER_PMD; pmdidx++) {
 				struct page *pte;
@@ -727,7 +730,7 @@
 					continue;
 
 				pte = pmd_page(pmd[pmdidx]);
-				flush |= (*func)(pte, PT_PTE);
+				flush |= (*func)(mm, pte, PT_PTE);
 			}
 		}
 	}
@@ -735,20 +738,20 @@
 out:
 	/* Do the top level last, so that the callbacks can use it as
 	   a cue to do final things like tlb flushes. */
-	flush |= (*func)(virt_to_page(pgd), PT_PGD);
+	flush |= (*func)(mm, virt_to_page(pgd), PT_PGD);
 
 	return flush;
 }
 
 /* If we're using split pte locks, then take the page's lock and
    return a pointer to it.  Otherwise return NULL. */
-static spinlock_t *xen_pte_lock(struct page *page)
+static spinlock_t *xen_pte_lock(struct page *page, struct mm_struct *mm)
 {
 	spinlock_t *ptl = NULL;
 
 #if USE_SPLIT_PTLOCKS
 	ptl = __pte_lockptr(page);
-	spin_lock(ptl);
+	spin_lock_nest_lock(ptl, &mm->page_table_lock);
 #endif
 
 	return ptl;
@@ -772,7 +775,8 @@
 	MULTI_mmuext_op(mcs.mc, op, 1, NULL, DOMID_SELF);
 }
 
-static int xen_pin_page(struct page *page, enum pt_level level)
+static int xen_pin_page(struct mm_struct *mm, struct page *page,
+			enum pt_level level)
 {
 	unsigned pgfl = TestSetPagePinned(page);
 	int flush;
@@ -813,7 +817,7 @@
 		 */
 		ptl = NULL;
 		if (level == PT_PTE)
-			ptl = xen_pte_lock(page);
+			ptl = xen_pte_lock(page, mm);
 
 		MULTI_update_va_mapping(mcs.mc, (unsigned long)pt,
 					pfn_pte(pfn, PAGE_KERNEL_RO),
@@ -834,11 +838,11 @@
 /* This is called just after a mm has been created, but it has not
    been used yet.  We need to make sure that its pagetable is all
    read-only, and can be pinned. */
-void xen_pgd_pin(pgd_t *pgd)
+static void __xen_pgd_pin(struct mm_struct *mm, pgd_t *pgd)
 {
 	xen_mc_batch();
 
-	if (xen_pgd_walk(pgd, xen_pin_page, USER_LIMIT)) {
+	if (xen_pgd_walk(mm, xen_pin_page, USER_LIMIT)) {
 		/* re-enable interrupts for kmap_flush_unused */
 		xen_mc_issue(0);
 		kmap_flush_unused();
@@ -852,18 +856,24 @@
 		xen_do_pin(MMUEXT_PIN_L4_TABLE, PFN_DOWN(__pa(pgd)));
 
 		if (user_pgd) {
-			xen_pin_page(virt_to_page(user_pgd), PT_PGD);
+			xen_pin_page(mm, virt_to_page(user_pgd), PT_PGD);
 			xen_do_pin(MMUEXT_PIN_L4_TABLE, PFN_DOWN(__pa(user_pgd)));
 		}
 	}
 #else /* CONFIG_X86_32 */
 #ifdef CONFIG_X86_PAE
 	/* Need to make sure unshared kernel PMD is pinnable */
-	xen_pin_page(virt_to_page(pgd_page(pgd[pgd_index(TASK_SIZE)])), PT_PMD);
+	xen_pin_page(mm, virt_to_page(pgd_page(pgd[pgd_index(TASK_SIZE)])),
+		     PT_PMD);
 #endif
 	xen_do_pin(MMUEXT_PIN_L3_TABLE, PFN_DOWN(__pa(pgd)));
 #endif /* CONFIG_X86_64 */
 	xen_mc_issue(0);
+}
+
+static void xen_pgd_pin(struct mm_struct *mm)
+{
+	__xen_pgd_pin(mm, mm->pgd);
 }
 
 /*
@@ -871,6 +881,10 @@
  * mfns turned into pfns.  Search the list for any unpinned pgds and pin
  * them (unpinned pgds are not currently in use, probably because the
  * process is under construction or destruction).
+ *
+ * Expected to be called in stop_machine() ("equivalent to taking
+ * every spinlock in the system"), so the locking doesn't really
+ * matter all that much.
  */
 void xen_mm_pin_all(void)
 {
@@ -881,7 +895,7 @@
 
 	list_for_each_entry(page, &pgd_list, lru) {
 		if (!PagePinned(page)) {
-			xen_pgd_pin((pgd_t *)page_address(page));
+			__xen_pgd_pin(&init_mm, (pgd_t *)page_address(page));
 			SetPageSavePinned(page);
 		}
 	}
@@ -894,7 +908,8 @@
  * that's before we have page structures to store the bits.  So do all
  * the book-keeping now.
  */
-static __init int xen_mark_pinned(struct page *page, enum pt_level level)
+static __init int xen_mark_pinned(struct mm_struct *mm, struct page *page,
+				  enum pt_level level)
 {
 	SetPagePinned(page);
 	return 0;
@@ -902,10 +917,11 @@
 
 void __init xen_mark_init_mm_pinned(void)
 {
-	xen_pgd_walk(init_mm.pgd, xen_mark_pinned, FIXADDR_TOP);
+	xen_pgd_walk(&init_mm, xen_mark_pinned, FIXADDR_TOP);
 }
 
-static int xen_unpin_page(struct page *page, enum pt_level level)
+static int xen_unpin_page(struct mm_struct *mm, struct page *page,
+			  enum pt_level level)
 {
 	unsigned pgfl = TestClearPagePinned(page);
 
@@ -923,7 +939,7 @@
 		 * partially-pinned state.
 		 */
 		if (level == PT_PTE) {
-			ptl = xen_pte_lock(page);
+			ptl = xen_pte_lock(page, mm);
 
 			if (ptl)
 				xen_do_pin(MMUEXT_UNPIN_TABLE, pfn);
@@ -945,7 +961,7 @@
 }
 
 /* Release a pagetables pages back as normal RW */
-static void xen_pgd_unpin(pgd_t *pgd)
+static void __xen_pgd_unpin(struct mm_struct *mm, pgd_t *pgd)
 {
 	xen_mc_batch();
 
@@ -957,19 +973,25 @@
 
 		if (user_pgd) {
 			xen_do_pin(MMUEXT_UNPIN_TABLE, PFN_DOWN(__pa(user_pgd)));
-			xen_unpin_page(virt_to_page(user_pgd), PT_PGD);
+			xen_unpin_page(mm, virt_to_page(user_pgd), PT_PGD);
 		}
 	}
 #endif
 
 #ifdef CONFIG_X86_PAE
 	/* Need to make sure unshared kernel PMD is unpinned */
-	xen_unpin_page(virt_to_page(pgd_page(pgd[pgd_index(TASK_SIZE)])), PT_PMD);
+	xen_unpin_page(mm, virt_to_page(pgd_page(pgd[pgd_index(TASK_SIZE)])),
+		       PT_PMD);
 #endif
 
-	xen_pgd_walk(pgd, xen_unpin_page, USER_LIMIT);
+	xen_pgd_walk(mm, xen_unpin_page, USER_LIMIT);
 
 	xen_mc_issue(0);
+}
+
+static void xen_pgd_unpin(struct mm_struct *mm)
+{
+	__xen_pgd_unpin(mm, mm->pgd);
 }
 
 /*
@@ -986,7 +1008,7 @@
 	list_for_each_entry(page, &pgd_list, lru) {
 		if (PageSavePinned(page)) {
 			BUG_ON(!PagePinned(page));
-			xen_pgd_unpin((pgd_t *)page_address(page));
+			__xen_pgd_unpin(&init_mm, (pgd_t *)page_address(page));
 			ClearPageSavePinned(page);
 		}
 	}
@@ -997,14 +1019,14 @@
 void xen_activate_mm(struct mm_struct *prev, struct mm_struct *next)
 {
 	spin_lock(&next->page_table_lock);
-	xen_pgd_pin(next->pgd);
+	xen_pgd_pin(next);
 	spin_unlock(&next->page_table_lock);
 }
 
 void xen_dup_mmap(struct mm_struct *oldmm, struct mm_struct *mm)
 {
 	spin_lock(&mm->page_table_lock);
-	xen_pgd_pin(mm->pgd);
+	xen_pgd_pin(mm);
 	spin_unlock(&mm->page_table_lock);
 }
 
@@ -1095,7 +1117,7 @@
 
 	/* pgd may not be pinned in the error exit path of execve */
 	if (xen_page_pinned(mm->pgd))
-		xen_pgd_unpin(mm->pgd);
+		xen_pgd_unpin(mm);
 
 	spin_unlock(&mm->page_table_lock);
 }
===================================================================
--- a/arch/x86/xen/mmu.h
+++ b/arch/x86/xen/mmu.h
@@ -17,9 +17,6 @@
 void xen_activate_mm(struct mm_struct *prev, struct mm_struct *next);
 void xen_dup_mmap(struct mm_struct *oldmm, struct mm_struct *mm);
 void xen_exit_mmap(struct mm_struct *mm);
-
-void xen_pgd_pin(pgd_t *pgd);
-//void xen_pgd_unpin(pgd_t *pgd);
 
 pteval_t xen_pte_val(pte_t);
 pmdval_t xen_pmd_val(pmd_t);


