Return-Path: <linux-kernel-owner+w=401wt.eu-S1760881AbXJLVqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760881AbXJLVqg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 17:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760445AbXJLVok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 17:44:40 -0400
Received: from 224.sub-75-208-255.myvzw.com ([75.208.255.224]:42255 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760294AbXJLVoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 17:44:38 -0400
Message-Id: <20071012211148.337291000@goop.org>
References: <20071012211132.198718000@goop.org>
User-Agent: quilt/0.46-1
Date: Fri, 12 Oct 2007 14:11:38 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Keir Fraser <keir@xensource.com>,
       Rik van Riel <riel@redhat.com>, Hugh Dickens <hugh@veritas.com>,
       David Rientjes <rientjes@google.com>, Andi Kleen <ak@suse.de>,
       Jan Beulich <jbeulich@novell.com>
Subject: [PATCH 06/10] xen: lock pte pages while pinning/unpinning
Content-Disposition: inline; filename=xen-pin-ptelock.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When a pagetable is created, it is made globally visible in the rmap
prio tree before it is pinned via arch_dup_mmap(), and remains in the
rmap tree while it is unpinned with arch_exit_mmap().

This means that other CPUs may race with the pinning/unpinning
process, and see a pte between when it gets marked RO and actually
pinned, causing any pte updates to fail with write-protect faults.

As a result, all pte pages must be properly locked, and only unlocked
once the pinning/unpinning process has finished.

In order to avoid taking spinlocks for the whole pagetable - which may
overflow the PREEMPT_BITS portion of preempt counter - it locks and pins
each pte page individually, and then finally pins the whole pagetable.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Hugh Dickens <hugh@veritas.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <ak@suse.de>
Cc: Keir Fraser <keir@xensource.com>
Cc: Jan Beulich <jbeulich@novell.com>

---
 arch/i386/xen/enlighten.c |   30 ++++++++---
 arch/i386/xen/mmu.c       |  113 ++++++++++++++++++++++++++++++++-------------
 mm/Kconfig                |    1 
 3 files changed, 103 insertions(+), 41 deletions(-)

===================================================================
--- a/arch/i386/xen/enlighten.c
+++ b/arch/i386/xen/enlighten.c
@@ -687,6 +687,15 @@ static __init void xen_alloc_pt_init(str
 	make_lowmem_page_readonly(__va(PFN_PHYS(pfn)));
 }
 
+static void pin_pagetable_pfn(unsigned level, unsigned long pfn)
+{
+	struct mmuext_op op;
+	op.cmd = level;
+	op.arg1.mfn = pfn_to_mfn(pfn);
+	if (HYPERVISOR_mmuext_op(&op, 1, NULL, DOMID_SELF))
+		BUG();
+}
+
 /* This needs to make sure the new pte page is pinned iff its being
    attached to a pinned pagetable. */
 static void xen_alloc_pt(struct mm_struct *mm, u32 pfn)
@@ -696,9 +705,10 @@ static void xen_alloc_pt(struct mm_struc
 	if (PagePinned(virt_to_page(mm->pgd))) {
 		SetPagePinned(page);
 
-		if (!PageHighMem(page))
+		if (!PageHighMem(page)) {
 			make_lowmem_page_readonly(__va(PFN_PHYS(pfn)));
-		else
+			pin_pagetable_pfn(MMUEXT_PIN_L1_TABLE, pfn);
+		} else
 			/* make sure there are no stray mappings of
 			   this page */
 			kmap_flush_unused();
@@ -711,8 +721,10 @@ static void xen_release_pt(u32 pfn)
 	struct page *page = pfn_to_page(pfn);
 
 	if (PagePinned(page)) {
-		if (!PageHighMem(page))
+		if (!PageHighMem(page)) {
+			pin_pagetable_pfn(MMUEXT_UNPIN_TABLE, pfn);
 			make_lowmem_page_readwrite(__va(PFN_PHYS(pfn)));
+		}
 	}
 }
 
@@ -827,15 +839,15 @@ static __init void xen_pagetable_setup_d
 	/* Actually pin the pagetable down, but we can't set PG_pinned
 	   yet because the page structures don't exist yet. */
 	{
-		struct mmuext_op op;
+		unsigned level;
+
 #ifdef CONFIG_X86_PAE
-		op.cmd = MMUEXT_PIN_L3_TABLE;
+		level = MMUEXT_PIN_L3_TABLE;
 #else
-		op.cmd = MMUEXT_PIN_L3_TABLE;
+		level = MMUEXT_PIN_L2_TABLE;
 #endif
-		op.arg1.mfn = pfn_to_mfn(PFN_DOWN(__pa(base)));
-		if (HYPERVISOR_mmuext_op(&op, 1, NULL, DOMID_SELF))
-			BUG();
+
+		pin_pagetable_pfn(level, PFN_DOWN(__pa(base)));
 	}
 }
 
===================================================================
--- a/arch/i386/xen/mmu.c
+++ b/arch/i386/xen/mmu.c
@@ -303,7 +303,12 @@ pgd_t xen_make_pgd(unsigned long pgd)
 }
 #endif	/* CONFIG_X86_PAE */
 
-
+enum pt_level {
+	PT_PGD,
+	PT_PUD,
+	PT_PMD,
+	PT_PTE
+};
 
 /*
   (Yet another) pagetable walker.  This one is intended for pinning a
@@ -315,7 +320,7 @@ pgd_t xen_make_pgd(unsigned long pgd)
   FIXADDR_TOP.  But the important bit is that we don't pin beyond
   there, because then we start getting into Xen's ptes.
 */
-static int pgd_walk(pgd_t *pgd_base, int (*func)(struct page *, unsigned),
+static int pgd_walk(pgd_t *pgd_base, int (*func)(struct page *, enum pt_level),
 		    unsigned long limit)
 {
 	pgd_t *pgd = pgd_base;
@@ -340,7 +345,7 @@ static int pgd_walk(pgd_t *pgd_base, int
 		pud = pud_offset(pgd, 0);
 
 		if (PTRS_PER_PUD > 1) /* not folded */
-			flush |= (*func)(virt_to_page(pud), 0);
+			flush |= (*func)(virt_to_page(pud), PT_PUD);
 
 		for (; addr != pud_limit; pud++, addr = pud_next) {
 			pmd_t *pmd;
@@ -359,7 +364,7 @@ static int pgd_walk(pgd_t *pgd_base, int
 			pmd = pmd_offset(pud, 0);
 
 			if (PTRS_PER_PMD > 1) /* not folded */
-				flush |= (*func)(virt_to_page(pmd), 0);
+				flush |= (*func)(virt_to_page(pmd), PT_PMD);
 
 			for (; addr != pmd_limit; pmd++) {
 				addr += (PAGE_SIZE * PTRS_PER_PTE);
@@ -371,17 +376,47 @@ static int pgd_walk(pgd_t *pgd_base, int
 				if (pmd_none(*pmd))
 					continue;
 
-				flush |= (*func)(pmd_page(*pmd), 0);
+				flush |= (*func)(pmd_page(*pmd), PT_PTE);
 			}
 		}
 	}
 
-	flush |= (*func)(virt_to_page(pgd_base), UVMF_TLB_FLUSH);
+	flush |= (*func)(virt_to_page(pgd_base), PT_PGD);
 
 	return flush;
 }
 
-static int pin_page(struct page *page, unsigned flags)
+static spinlock_t *lock_pte(struct page *page)
+{
+	spinlock_t *ptl = NULL;
+
+#if NR_CPUS >= CONFIG_SPLIT_PTLOCK_CPUS
+	ptl = __pte_lockptr(page);
+	spin_lock(ptl);
+#endif
+
+	return ptl;
+}
+
+static void do_unlock(void *v)
+{
+	spinlock_t *ptl = v;
+	spin_unlock(ptl);
+}
+
+static void xen_do_pin(unsigned level, unsigned long pfn)
+{
+	struct mmuext_op *op;
+	struct multicall_space mcs;
+
+	mcs = __xen_mc_entry(sizeof(*op));
+	op = mcs.args;
+	op->cmd = level;
+	op->arg1.mfn = pfn_to_mfn(pfn);
+	MULTI_mmuext_op(mcs.mc, op, 1, NULL, DOMID_SELF);
+}
+
+static int pin_page(struct page *page, enum pt_level level)
 {
 	unsigned pgfl = test_and_set_bit(PG_pinned, &page->flags);
 	int flush;
@@ -396,12 +431,26 @@ static int pin_page(struct page *page, u
 		void *pt = lowmem_page_address(page);
 		unsigned long pfn = page_to_pfn(page);
 		struct multicall_space mcs = __xen_mc_entry(0);
+		spinlock_t *ptl;
 
 		flush = 0;
+
+		ptl = NULL;
+		if (level == PT_PTE)
+			ptl = lock_pte(page);
 
 		MULTI_update_va_mapping(mcs.mc, (unsigned long)pt,
 					pfn_pte(pfn, PAGE_KERNEL_RO),
-					flags);
+					level == PT_PGD ? UVMF_TLB_FLUSH : 0);
+
+		if (level == PT_PTE)
+			xen_do_pin(MMUEXT_PIN_L1_TABLE, pfn);
+
+		if (ptl) {
+			/* Queue a deferred unlock for when this batch
+			   is completed. */
+			xen_mc_callback(do_unlock, ptl);
+		}
 	}
 
 	return flush;
@@ -412,8 +461,7 @@ static int pin_page(struct page *page, u
    read-only, and can be pinned. */
 void xen_pgd_pin(pgd_t *pgd)
 {
-	struct multicall_space mcs;
-	struct mmuext_op *op;
+	unsigned level;
 
 	xen_mc_batch();
 
@@ -424,16 +472,13 @@ void xen_pgd_pin(pgd_t *pgd)
 		xen_mc_batch();
 	}
 
-	mcs = __xen_mc_entry(sizeof(*op));
-	op = mcs.args;
-
 #ifdef CONFIG_X86_PAE
-	op->cmd = MMUEXT_PIN_L3_TABLE;
+	level = MMUEXT_PIN_L3_TABLE;
 #else
-	op->cmd = MMUEXT_PIN_L2_TABLE;
+	level = MMUEXT_PIN_L2_TABLE;
 #endif
-	op->arg1.mfn = pfn_to_mfn(PFN_DOWN(__pa(pgd)));
-	MULTI_mmuext_op(mcs.mc, op, 1, NULL, DOMID_SELF);
+
+	xen_do_pin(level, PFN_DOWN(__pa(pgd)));
 
 	xen_mc_issue(0);
 }
@@ -441,7 +486,7 @@ void xen_pgd_pin(pgd_t *pgd)
 /* The init_mm pagetable is really pinned as soon as its created, but
    that's before we have page structures to store the bits.  So do all
    the book-keeping now. */
-static __init int mark_pinned(struct page *page, unsigned flags)
+static __init int mark_pinned(struct page *page, enum pt_level level)
 {
 	SetPagePinned(page);
 	return 0;
@@ -452,18 +497,32 @@ void __init xen_mark_init_mm_pinned(void
 	pgd_walk(init_mm.pgd, mark_pinned, FIXADDR_TOP);
 }
 
-static int unpin_page(struct page *page, unsigned flags)
+static int unpin_page(struct page *page, enum pt_level level)
 {
 	unsigned pgfl = test_and_clear_bit(PG_pinned, &page->flags);
 
 	if (pgfl && !PageHighMem(page)) {
 		void *pt = lowmem_page_address(page);
 		unsigned long pfn = page_to_pfn(page);
-		struct multicall_space mcs = __xen_mc_entry(0);
+		spinlock_t *ptl = NULL;
+		struct multicall_space mcs;
+
+		if (level == PT_PTE) {
+			ptl = lock_pte(page);
+
+			xen_do_pin(MMUEXT_UNPIN_TABLE, pfn);
+		}
+
+		mcs = __xen_mc_entry(0);
 
 		MULTI_update_va_mapping(mcs.mc, (unsigned long)pt,
 					pfn_pte(pfn, PAGE_KERNEL),
-					flags);
+					level == PT_PGD ? UVMF_TLB_FLUSH : 0);
+
+		if (ptl) {
+			/* unlock when batch completed */
+			xen_mc_callback(do_unlock, ptl);
+		}
 	}
 
 	return 0;		/* never need to flush on unpin */
@@ -472,18 +531,9 @@ static int unpin_page(struct page *page,
 /* Release a pagetables pages back as normal RW */
 static void xen_pgd_unpin(pgd_t *pgd)
 {
-	struct mmuext_op *op;
-	struct multicall_space mcs;
-
 	xen_mc_batch();
 
-	mcs = __xen_mc_entry(sizeof(*op));
-
-	op = mcs.args;
-	op->cmd = MMUEXT_UNPIN_TABLE;
-	op->arg1.mfn = pfn_to_mfn(PFN_DOWN(__pa(pgd)));
-
-	MULTI_mmuext_op(mcs.mc, op, 1, NULL, DOMID_SELF);
+	xen_do_pin(MMUEXT_UNPIN_TABLE, PFN_DOWN(__pa(pgd)));
 
 	pgd_walk(pgd, unpin_page, TASK_SIZE);
 
@@ -585,5 +635,6 @@ void xen_exit_mmap(struct mm_struct *mm)
 	/* pgd may not be pinned in the error exit path of execve */
 	if (PagePinned(virt_to_page(mm->pgd)))
 		xen_pgd_unpin(mm->pgd);
+
 	spin_unlock(&mm->page_table_lock);
 }
===================================================================
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -137,7 +137,6 @@ config SPLIT_PTLOCK_CPUS
 	int
 	default "4096" if ARM && !CPU_CACHE_VIPT
 	default "4096" if PARISC && !PA20
-	default "4096" if XEN
 	default "4"
 
 #

-- 

