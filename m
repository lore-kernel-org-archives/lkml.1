Return-Path: <linux-kernel-owner+w=401wt.eu-S1759514AbYHSUf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759514AbYHSUf1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 16:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754520AbYHSUfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 16:35:19 -0400
Received: from gw.goop.org ([64.81.55.164]:54900 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753983AbYHSUfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 16:35:17 -0400
Message-ID: <48AB2E4E.80909@goop.org>
Date: Tue, 19 Aug 2008 13:34:22 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] xen: add xen_ prefixes to make tracing with ftrace easier
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's easier to pattern match on Xen function if they all start with xen_.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/mmu.c |   66 ++++++++++++++++++++++++++--------------------------
 1 file changed, 34 insertions(+), 32 deletions(-)

===================================================================
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -229,14 +229,14 @@
 }
 
 
-static bool page_pinned(void *ptr)
+static bool xen_page_pinned(void *ptr)
 {
 	struct page *page = virt_to_page(ptr);
 
 	return PagePinned(page);
 }
 
-static void extend_mmu_update(const struct mmu_update *update)
+static void xen_extend_mmu_update(const struct mmu_update *update)
 {
 	struct multicall_space mcs;
 	struct mmu_update *u;
@@ -265,7 +265,7 @@
 	/* ptr may be ioremapped for 64-bit pagetable setup */
 	u.ptr = arbitrary_virt_to_machine(ptr).maddr;
 	u.val = pmd_val_ma(val);
-	extend_mmu_update(&u);
+	xen_extend_mmu_update(&u);
 
 	xen_mc_issue(PARAVIRT_LAZY_MMU);
 
@@ -276,7 +276,7 @@
 {
 	/* If page is not pinned, we can just update the entry
 	   directly */
-	if (!page_pinned(ptr)) {
+	if (!xen_page_pinned(ptr)) {
 		*ptr = val;
 		return;
 	}
@@ -334,7 +334,7 @@
 
 	u.ptr = virt_to_machine(ptep).maddr | MMU_PT_UPDATE_PRESERVE_AD;
 	u.val = pte_val_ma(pte);
-	extend_mmu_update(&u);
+	xen_extend_mmu_update(&u);
 
 	xen_mc_issue(PARAVIRT_LAZY_MMU);
 }
@@ -400,7 +400,7 @@
 	/* ptr may be ioremapped for 64-bit pagetable setup */
 	u.ptr = arbitrary_virt_to_machine(ptr).maddr;
 	u.val = pud_val_ma(val);
-	extend_mmu_update(&u);
+	xen_extend_mmu_update(&u);
 
 	xen_mc_issue(PARAVIRT_LAZY_MMU);
 
@@ -411,7 +411,7 @@
 {
 	/* If page is not pinned, we can just update the entry
 	   directly */
-	if (!page_pinned(ptr)) {
+	if (!xen_page_pinned(ptr)) {
 		*ptr = val;
 		return;
 	}
@@ -490,7 +490,7 @@
 
 	u.ptr = virt_to_machine(ptr).maddr;
 	u.val = pgd_val_ma(val);
-	extend_mmu_update(&u);
+	xen_extend_mmu_update(&u);
 }
 
 /*
@@ -519,10 +519,10 @@
 
 	/* If page is not pinned, we can just update the entry
 	   directly */
-	if (!page_pinned(ptr)) {
+	if (!xen_page_pinned(ptr)) {
 		*ptr = val;
 		if (user_ptr) {
-			WARN_ON(page_pinned(user_ptr));
+			WARN_ON(xen_page_pinned(user_ptr));
 			*user_ptr = val;
 		}
 		return;
@@ -555,8 +555,8 @@
  * For 64-bit, we must skip the Xen hole in the middle of the address
  * space, just after the big x86-64 virtual hole.
  */
-static int pgd_walk(pgd_t *pgd, int (*func)(struct page *, enum pt_level),
-		    unsigned long limit)
+static int xen_pgd_walk(pgd_t *pgd, int (*func)(struct page *, enum pt_level),
+			unsigned long limit)
 {
 	int flush = 0;
 	unsigned hole_low, hole_high;
@@ -644,7 +644,9 @@
 	return flush;
 }
 
-static spinlock_t *lock_pte(struct page *page)
+/* If we're using split pte locks, then take the page's lock and
+   return a pointer to it.  Otherwise return NULL. */
+static spinlock_t *xen_pte_lock(struct page *page)
 {
 	spinlock_t *ptl = NULL;
 
@@ -656,7 +658,7 @@
 	return ptl;
 }
 
-static void do_unlock(void *v)
+static void xen_pte_unlock(void *v)
 {
 	spinlock_t *ptl = v;
 	spin_unlock(ptl);
@@ -674,7 +676,7 @@
 	MULTI_mmuext_op(mcs.mc, op, 1, NULL, DOMID_SELF);
 }
 
-static int pin_page(struct page *page, enum pt_level level)
+static int xen_pin_page(struct page *page, enum pt_level level)
 {
 	unsigned pgfl = TestSetPagePinned(page);
 	int flush;
@@ -715,7 +717,7 @@
 		 */
 		ptl = NULL;
 		if (level == PT_PTE)
-			ptl = lock_pte(page);
+			ptl = xen_pte_lock(page);
 
 		MULTI_update_va_mapping(mcs.mc, (unsigned long)pt,
 					pfn_pte(pfn, PAGE_KERNEL_RO),
@@ -726,7 +728,7 @@
 
 			/* Queue a deferred unlock for when this batch
 			   is completed. */
-			xen_mc_callback(do_unlock, ptl);
+			xen_mc_callback(xen_pte_unlock, ptl);
 		}
 	}
 
@@ -740,7 +742,7 @@
 {
 	xen_mc_batch();
 
-	if (pgd_walk(pgd, pin_page, USER_LIMIT)) {
+	if (xen_pgd_walk(pgd, xen_pin_page, USER_LIMIT)) {
 		/* re-enable interrupts for kmap_flush_unused */
 		xen_mc_issue(0);
 		kmap_flush_unused();
@@ -754,14 +756,14 @@
 		xen_do_pin(MMUEXT_PIN_L4_TABLE, PFN_DOWN(__pa(pgd)));
 
 		if (user_pgd) {
-			pin_page(virt_to_page(user_pgd), PT_PGD);
+			xen_pin_page(virt_to_page(user_pgd), PT_PGD);
 			xen_do_pin(MMUEXT_PIN_L4_TABLE, PFN_DOWN(__pa(user_pgd)));
 		}
 	}
 #else /* CONFIG_X86_32 */
 #ifdef CONFIG_X86_PAE
 	/* Need to make sure unshared kernel PMD is pinnable */
-	pin_page(virt_to_page(pgd_page(pgd[pgd_index(TASK_SIZE)])), PT_PMD);
+	xen_pin_page(virt_to_page(pgd_page(pgd[pgd_index(TASK_SIZE)])), PT_PMD);
 #endif
 	xen_do_pin(MMUEXT_PIN_L3_TABLE, PFN_DOWN(__pa(pgd)));
 #endif /* CONFIG_X86_64 */
@@ -796,7 +798,7 @@
  * that's before we have page structures to store the bits.  So do all
  * the book-keeping now.
  */
-static __init int mark_pinned(struct page *page, enum pt_level level)
+static __init int xen_mark_pinned(struct page *page, enum pt_level level)
 {
 	SetPagePinned(page);
 	return 0;
@@ -804,10 +806,10 @@
 
 void __init xen_mark_init_mm_pinned(void)
 {
-	pgd_walk(init_mm.pgd, mark_pinned, FIXADDR_TOP);
+	xen_pgd_walk(init_mm.pgd, xen_mark_pinned, FIXADDR_TOP);
 }
 
-static int unpin_page(struct page *page, enum pt_level level)
+static int xen_unpin_page(struct page *page, enum pt_level level)
 {
 	unsigned pgfl = TestClearPagePinned(page);
 
@@ -825,7 +827,7 @@
 		 * partially-pinned state.
 		 */
 		if (level == PT_PTE) {
-			ptl = lock_pte(page);
+			ptl = xen_pte_lock(page);
 
 			if (ptl)
 				xen_do_pin(MMUEXT_UNPIN_TABLE, pfn);
@@ -839,7 +841,7 @@
 
 		if (ptl) {
 			/* unlock when batch completed */
-			xen_mc_callback(do_unlock, ptl);
+			xen_mc_callback(xen_pte_unlock, ptl);
 		}
 	}
 
@@ -859,17 +861,17 @@
 
 		if (user_pgd) {
 			xen_do_pin(MMUEXT_UNPIN_TABLE, PFN_DOWN(__pa(user_pgd)));
-			unpin_page(virt_to_page(user_pgd), PT_PGD);
+			xen_unpin_page(virt_to_page(user_pgd), PT_PGD);
 		}
 	}
 #endif
 
 #ifdef CONFIG_X86_PAE
 	/* Need to make sure unshared kernel PMD is unpinned */
-	unpin_page(virt_to_page(pgd_page(pgd[pgd_index(TASK_SIZE)])), PT_PMD);
+	xen_unpin_page(virt_to_page(pgd_page(pgd[pgd_index(TASK_SIZE)])), PT_PMD);
 #endif
 
-	pgd_walk(pgd, unpin_page, USER_LIMIT);
+	xen_pgd_walk(pgd, xen_unpin_page, USER_LIMIT);
 
 	xen_mc_issue(0);
 }
@@ -936,7 +938,7 @@
 	}
 }
 
-static void drop_mm_ref(struct mm_struct *mm)
+static void xen_drop_mm_ref(struct mm_struct *mm)
 {
 	cpumask_t mask;
 	unsigned cpu;
@@ -966,7 +968,7 @@
 		smp_call_function_mask(mask, drop_other_mm_ref, mm, 1);
 }
 #else
-static void drop_mm_ref(struct mm_struct *mm)
+static void xen_drop_mm_ref(struct mm_struct *mm)
 {
 	if (current->active_mm == mm)
 		load_cr3(swapper_pg_dir);
@@ -990,13 +992,13 @@
 void xen_exit_mmap(struct mm_struct *mm)
 {
 	get_cpu();		/* make sure we don't move around */
-	drop_mm_ref(mm);
+	xen_drop_mm_ref(mm);
 	put_cpu();
 
 	spin_lock(&mm->page_table_lock);
 
 	/* pgd may not be pinned in the error exit path of execve */
-	if (page_pinned(mm->pgd))
+	if (xen_page_pinned(mm->pgd))
 		xen_pgd_unpin(mm->pgd);
 
 	spin_unlock(&mm->page_table_lock);


