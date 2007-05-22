Return-Path: <linux-kernel-owner+w=401wt.eu-S935114AbXEVPU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935114AbXEVPU4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 11:20:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965693AbXEVPTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 11:19:14 -0400
Received: from host217-46-209-99.in-addr.btopenworld.com ([217.46.209.99]:4977
	"EHLO mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759813AbXEVPTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 11:19:10 -0400
Message-Id: <20070522141252.278027702@goop.org>
References: <20070522140941.802382212@goop.org>
User-Agent: quilt/0.46-1
Date: Tue, 22 May 2007 15:09:58 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Zach Amsden <zach@vmware.com>
Subject: [patch 17/33] xen: Complete pagetable pinning for Xen
Content-Disposition: inline; filename=xen-pinned-pagetables.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Xen requires all active pagetables to be marked read-only.  When the
base of the pagetable is loaded into %cr3, the hypervisor validates
the entire pagetable and only allows the load to proceed if it all
checks out.

This is pretty slow, so to mitigate this cost Xen has a notion of
pinned pagetables.  Pinned pagetables are pagetables which are
considered to be active even if no processor's cr3 is pointing to is.
This means that it must remain read-only and all updates are validated
by the hypervisor.  This makes context switches much cheaper, because
the hypervisor doesn't need to revalidate the pagetable each time.

This also adds a new paravirt hook which is called during setup once
the zones and memory allocator have been initialized.  When the
init_mm pagetable is first built, the struct page array does not yet
exist, and so there's nowhere to put he init_mm pagetable's PG_pinned
flags.  Once the zones are initialized and the struct page array
exists, we can set the PG_pinned flags for those pages.

This patch also adds the Xen support for pte pages allocated out of
highmem (highpte) by implementing xen_kmap_atomic_pte.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Cc: Zach Amsden <zach@vmware.com>

---
 arch/i386/xen/enlighten.c |  107 ++++++++++++----
 arch/i386/xen/mmu.c       |  289 ++++++++++++++++++++++++++++-----------------
 arch/i386/xen/mmu.h       |    2 
 arch/i386/xen/xen-ops.h   |    2 
 4 files changed, 266 insertions(+), 134 deletions(-)

===================================================================
--- a/arch/i386/xen/enlighten.c
+++ b/arch/i386/xen/enlighten.c
@@ -21,6 +21,9 @@
 #include <linux/sched.h>
 #include <linux/bootmem.h>
 #include <linux/module.h>
+#include <linux/mm.h>
+#include <linux/page-flags.h>
+#include <linux/highmem.h>
 
 #include <xen/interface/xen.h>
 #include <xen/interface/physdev.h>
@@ -496,32 +499,59 @@ static void xen_write_cr3(unsigned long 
 	}
 }
 
+/* Early in boot, while setting up the initial pagetable, assume
+   everything is pinned. */
+static void xen_alloc_pt_init(struct mm_struct *mm, u32 pfn)
+{
+	BUG_ON(mem_map);	/* should only be used early */
+	make_lowmem_page_readonly(__va(PFN_PHYS(pfn)));
+}
+
+/* This needs to make sure the new pte page is pinned iff its being
+   attached to a pinned pagetable. */
 static void xen_alloc_pt(struct mm_struct *mm, u32 pfn)
 {
-	/* XXX pfn isn't necessarily a lowmem page */
-	make_lowmem_page_readonly(__va(PFN_PHYS(pfn)));
-}
-
-static void xen_alloc_pd(u32 pfn)
-{
-	make_lowmem_page_readonly(__va(PFN_PHYS(pfn)));
-}
-
-static void xen_release_pd(u32 pfn)
-{
-	make_lowmem_page_readwrite(__va(PFN_PHYS(pfn)));
-}
-
+	struct page *page = pfn_to_page(pfn);
+
+	if (PagePinned(virt_to_page(mm->pgd))) {
+		SetPagePinned(page);
+
+		if (!PageHighMem(page))
+			make_lowmem_page_readonly(__va(PFN_PHYS(pfn)));
+		else
+			/* make sure there are no stray mappings of
+			   this page */
+			kmap_flush_unused();
+	}
+}
+
+/* This should never happen until we're OK to use struct page */
 static void xen_release_pt(u32 pfn)
 {
-	make_lowmem_page_readwrite(__va(PFN_PHYS(pfn)));
-}
-
-static void xen_alloc_pd_clone(u32 pfn, u32 clonepfn,
-					u32 start, u32 count)
-{
-	xen_alloc_pd(pfn);
-}
+	struct page *page = pfn_to_page(pfn);
+
+	if (PagePinned(page)) {
+		if (!PageHighMem(page))
+			make_lowmem_page_readwrite(__va(PFN_PHYS(pfn)));
+	}
+}
+
+#ifdef CONFIG_HIGHPTE
+static void *xen_kmap_atomic_pte(struct page *page, enum km_type type)
+{
+	pgprot_t prot = PAGE_KERNEL;
+
+	if (PagePinned(page))
+		prot = PAGE_KERNEL_RO;
+
+	if (0 && PageHighMem(page))
+		printk("mapping highpte %lx type %d prot %s\n",
+		       page_to_pfn(page), type,
+		       (unsigned long)pgprot_val(prot) & _PAGE_RW ? "WRITE" : "READ");
+
+	return kmap_atomic_prot(page, type, prot);
+}
+#endif
 
 static __init void xen_pagetable_setup_start(pgd_t *base)
 {
@@ -549,7 +579,7 @@ static __init void xen_pagetable_setup_s
 				memcpy(pmd, (void *)pgd_page_vaddr(xen_pgd[i]),
 				       PAGE_SIZE);
 
-				xen_alloc_pd(PFN_DOWN(__pa(pmd)));
+				make_lowmem_page_readonly(pmd);
 
 				set_pgd(&base[i], __pgd(1 + __pa(pmd)));
 			} else
@@ -570,6 +600,10 @@ static __init void xen_pagetable_setup_s
 
 static __init void xen_pagetable_setup_done(pgd_t *base)
 {
+	/* This will work as long as patching hasn't happened yet
+	   (which it hasn't) */
+	paravirt_ops.alloc_pt = xen_alloc_pt;
+
 	if (!xen_feature(XENFEAT_auto_translated_physmap)) {
 		/*
 		 * Create a mapping for the shared info page.
@@ -587,7 +621,19 @@ static __init void xen_pagetable_setup_d
 		HYPERVISOR_shared_info =
 			(struct shared_info *)__va(xen_start_info->shared_info);
 
-	xen_pgd_pin(base);
+	/* Actually pin the pagetable down, but we can't set PG_pinned
+	   yet because the page structures don't exist yet. */
+	{
+		struct mmuext_op op;
+#ifdef CONFIG_X86_PAE
+		op.cmd = MMUEXT_PIN_L3_TABLE;
+#else
+		op.cmd = MMUEXT_PIN_L3_TABLE;
+#endif
+		op.arg1.mfn = pfn_to_mfn(PFN_DOWN(__pa(base)));
+		if (HYPERVISOR_mmuext_op(&op, 1, NULL, DOMID_SELF))
+			BUG();
+	}
 
 	xen_vcpu_setup(smp_processor_id());
 }
@@ -604,6 +650,7 @@ static const struct paravirt_ops xen_par
 	.memory_setup = xen_memory_setup,
 	.arch_setup = xen_arch_setup,
 	.init_IRQ = xen_init_IRQ,
+	.post_allocator_init = xen_mark_init_mm_pinned,
 
 	.time_init = xen_time_init,
 	.set_wallclock = xen_set_wallclock,
@@ -684,11 +731,15 @@ static const struct paravirt_ops xen_par
 	.pagetable_setup_start = xen_pagetable_setup_start,
 	.pagetable_setup_done = xen_pagetable_setup_done,
 
-	.alloc_pt = xen_alloc_pt,
-	.alloc_pd = xen_alloc_pd,
-	.alloc_pd_clone = xen_alloc_pd_clone,
-	.release_pd = xen_release_pd,
+	.alloc_pt = xen_alloc_pt_init,
 	.release_pt = xen_release_pt,
+	.alloc_pd = paravirt_nop,
+	.alloc_pd_clone = paravirt_nop,
+	.release_pd = paravirt_nop,
+
+#ifdef CONFIG_HIGHPTE
+	.kmap_atomic_pte = xen_kmap_atomic_pte,
+#endif
 
 	.set_pte = xen_set_pte,
 	.set_pte_at = xen_set_pte_at,
===================================================================
--- a/arch/i386/xen/mmu.c
+++ b/arch/i386/xen/mmu.c
@@ -38,18 +38,21 @@
  *
  * Jeremy Fitzhardinge <jeremy@xensource.com>, XenSource Inc, 2007
  */
+#include <linux/highmem.h>
+
 #include <asm/bug.h>
-
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
+#include <asm/paravirt.h>
 
 #include <asm/xen/hypercall.h>
-#include <asm/paravirt.h>
+#include <asm/xen/hypervisor.h>
 
 #include <xen/page.h>
 #include <xen/interface/xen.h>
 
+#include "multicalls.h"
 #include "mmu.h"
 
 xmaddr_t arbitrary_virt_to_machine(unsigned long address)
@@ -87,17 +90,6 @@ void make_lowmem_page_readwrite(void *va
 	ptev = pte_mkwrite(*pte);
 
 	if(HYPERVISOR_update_va_mapping(address, ptev, 0))
-		BUG();
-}
-
-
-void xen_set_pte(pte_t *ptep, pte_t pte)
-{
-	struct mmu_update u;
-
-	u.ptr = virt_to_machine(ptep).maddr;
-	u.val = pte_val_ma(pte);
-	if (HYPERVISOR_mmu_update(&u, 1, NULL, DOMID_SELF) < 0)
 		BUG();
 }
 
@@ -110,18 +102,6 @@ void xen_set_pmd(pmd_t *ptr, pmd_t val)
 	if (HYPERVISOR_mmu_update(&u, 1, NULL, DOMID_SELF) < 0)
 		BUG();
 }
-
-#ifdef CONFIG_X86_PAE
-void xen_set_pud(pud_t *ptr, pud_t val)
-{
-	struct mmu_update u;
-
-	u.ptr = virt_to_machine(ptr).maddr;
-	u.val = pud_val_ma(val);
-	if (HYPERVISOR_mmu_update(&u, 1, NULL, DOMID_SELF) < 0)
-		BUG();
-}
-#endif
 
 /*
  * Associate a virtual page frame with a given physical page frame
@@ -169,12 +149,29 @@ void xen_set_pte_at(struct mm_struct *mm
 }
 
 #ifdef CONFIG_X86_PAE
+void xen_set_pud(pud_t *ptr, pud_t val)
+{
+	struct mmu_update u;
+
+	u.ptr = virt_to_machine(ptr).maddr;
+	u.val = pud_val_ma(val);
+	if (HYPERVISOR_mmu_update(&u, 1, NULL, DOMID_SELF) < 0)
+		BUG();
+}
+
+void xen_set_pte(pte_t *ptep, pte_t pte)
+{
+	ptep->pte_high = pte.pte_high;
+	smp_wmb();
+	ptep->pte_low = pte.pte_low;
+}
+
 void xen_set_pte_atomic(pte_t *ptep, pte_t pte)
 {
 	set_64bit((u64 *)ptep, pte_val_ma(pte));
 }
 
-void xen_pte_clear(struct mm_struct *mm, unsigned long addr,pte_t *ptep)
+void xen_pte_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
 {
 	ptep->pte_low = 0;
 	smp_wmb();
@@ -238,6 +235,11 @@ pgd_t xen_make_pgd(unsigned long long pg
 	return (pgd_t){ pgd };
 }
 #else  /* !PAE */
+void xen_set_pte(pte_t *ptep, pte_t pte)
+{
+	*ptep = pte;
+}
+
 unsigned long xen_pte_val(pte_t pte)
 {
 	unsigned long ret = pte.pte_low;
@@ -246,13 +248,6 @@ unsigned long xen_pte_val(pte_t pte)
 		ret = machine_to_phys(XMADDR(ret)).paddr;
 
 	return ret;
-}
-
-unsigned long xen_pmd_val(pmd_t pmd)
-{
-	/* a BUG here is a lot easier to track down than a NULL eip */
-	BUG();
-	return 0;
 }
 
 unsigned long xen_pgd_val(pgd_t pgd)
@@ -271,13 +266,6 @@ pte_t xen_make_pte(unsigned long pte)
 	return (pte_t){ pte };
 }
 
-pmd_t xen_make_pmd(unsigned long pmd)
-{
-	/* a BUG here is a lot easier to track down than a NULL eip */
-	BUG();
-	return __pmd(0);
-}
-
 pgd_t xen_make_pgd(unsigned long pgd)
 {
 	if (pgd & _PAGE_PRESENT)
@@ -288,109 +276,200 @@ pgd_t xen_make_pgd(unsigned long pgd)
 #endif	/* CONFIG_X86_PAE */
 
 
-
-static void pgd_walk_set_prot(void *pt, pgprot_t flags)
-{
-	unsigned long pfn = PFN_DOWN(__pa(pt));
-
-	if (HYPERVISOR_update_va_mapping((unsigned long)pt,
-					 pfn_pte(pfn, flags), 0) < 0)
-		BUG();
-}
-
-static void pgd_walk(pgd_t *pgd_base, pgprot_t flags)
+/*
+  (Yet another) pagetable walker.  This one is intended for pinning a
+  pagetable.  This means that it walks a pagetable and calls the
+  callback function on each page it finds making up the page table,
+  at every level.  It walks the entire pagetable, but it only bothers
+  pinning pte pages which are below pte_limit.  In the normal case
+  this will be TASK_SIZE, but at boot we need to pin up to
+  FIXADDR_TOP.  But the important bit is that we don't pin beyond
+  there, because then we start getting into Xen's ptes.
+*/
+static int pgd_walk(pgd_t *pgd_base, int (*func)(struct page *, unsigned),
+		    unsigned long limit)
 {
 	pgd_t *pgd = pgd_base;
-	pud_t *pud;
-	pmd_t *pmd;
-	pte_t *pte;
-	int    g, u, m;
+	int flush = 0;
+	unsigned long addr = 0;
+	unsigned long pgd_next;
+
+	BUG_ON(limit > FIXADDR_TOP);
 
 	if (xen_feature(XENFEAT_auto_translated_physmap))
-		return;
-
-	for (g = 0; g < USER_PTRS_PER_PGD; g++, pgd++) {
-		if (pgd_none(*pgd))
+		return 0;
+
+	for (; addr != FIXADDR_TOP; pgd++, addr = pgd_next) {
+		pud_t *pud;
+		unsigned long pud_limit, pud_next;
+
+		pgd_next = pud_limit = pgd_addr_end(addr, FIXADDR_TOP);
+
+		if (!pgd_val(*pgd))
 			continue;
+
 		pud = pud_offset(pgd, 0);
 
 		if (PTRS_PER_PUD > 1) /* not folded */
-			pgd_walk_set_prot(pud,flags);
-
-		for (u = 0; u < PTRS_PER_PUD; u++, pud++) {
+			flush |= (*func)(virt_to_page(pud), 0);
+
+		for (; addr != pud_limit; pud++, addr = pud_next) {
+			pmd_t *pmd;
+			unsigned long pmd_limit;
+
+			pud_next = pud_addr_end(addr, pud_limit);
+
+			if (pud_next < limit)
+				pmd_limit = pud_next;
+			else
+				pmd_limit = limit;
+
 			if (pud_none(*pud))
 				continue;
+
 			pmd = pmd_offset(pud, 0);
 
 			if (PTRS_PER_PMD > 1) /* not folded */
-				pgd_walk_set_prot(pmd,flags);
-
-			for (m = 0; m < PTRS_PER_PMD; m++, pmd++) {
+				flush |= (*func)(virt_to_page(pmd), 0);
+
+			for (; addr != pmd_limit; pmd++) {
+				addr += (PAGE_SIZE * PTRS_PER_PTE);
+				if ((pmd_limit-1) < (addr-1)) {
+					addr = pmd_limit;
+					break;
+				}
+
 				if (pmd_none(*pmd))
 					continue;
 
-				/* This can get called before mem_map
-				   is set up, so we assume nothing is
-				   highmem at that point. */
-				if (mem_map == NULL ||
-				    !PageHighMem(pmd_page(*pmd))) {
-					pte = pte_offset_kernel(pmd,0);
-					pgd_walk_set_prot(pte,flags);
-				}
+				flush |= (*func)(pmd_page(*pmd), 0);
 			}
 		}
 	}
 
-	if (HYPERVISOR_update_va_mapping((unsigned long)pgd_base,
-					 pfn_pte(PFN_DOWN(__pa(pgd_base)),
-						 flags),
-					 UVMF_TLB_FLUSH) < 0)
-		BUG();
-}
-
-
-/* This is called just after a mm has been duplicated from its parent,
-   but it has not been used yet.  We need to make sure that its
-   pagetable is all read-only, and can be pinned. */
+	flush |= (*func)(virt_to_page(pgd_base), UVMF_TLB_FLUSH);
+
+	return flush;
+}
+
+static int pin_page(struct page *page, unsigned flags)
+{
+	unsigned pgfl = test_and_set_bit(PG_pinned, &page->flags);
+	int flush;
+
+	if (pgfl)
+		flush = 0;		/* already pinned */
+	else if (PageHighMem(page))
+		/* kmaps need flushing if we found an unpinned
+		   highpage */
+		flush = 1;
+	else {
+		void *pt = lowmem_page_address(page);
+		unsigned long pfn = page_to_pfn(page);
+		struct multicall_space mcs = __xen_mc_entry(0);
+
+		flush = 0;
+
+		MULTI_update_va_mapping(mcs.mc, (unsigned long)pt,
+					pfn_pte(pfn, PAGE_KERNEL_RO),
+					flags);
+	}
+
+	return flush;
+}
+
+/* This is called just after a mm has been created, but it has not
+   been used yet.  We need to make sure that its pagetable is all
+   read-only, and can be pinned. */
 void xen_pgd_pin(pgd_t *pgd)
 {
-	struct mmuext_op op;
-
-	pgd_walk(pgd, PAGE_KERNEL_RO);
-
-#if defined(CONFIG_X86_PAE)
-	op.cmd = MMUEXT_PIN_L3_TABLE;
+	struct multicall_space mcs;
+	struct mmuext_op *op;
+
+	xen_mc_batch();
+
+	if (pgd_walk(pgd, pin_page, TASK_SIZE))
+		kmap_flush_unused();
+
+	mcs = __xen_mc_entry(sizeof(*op));
+	op = mcs.args;
+
+#ifdef CONFIG_X86_PAE
+	op->cmd = MMUEXT_PIN_L3_TABLE;
 #else
-	op.cmd = MMUEXT_PIN_L2_TABLE;
+	op->cmd = MMUEXT_PIN_L2_TABLE;
 #endif
-	op.arg1.mfn = pfn_to_mfn(PFN_DOWN(__pa(pgd)));
-	if (HYPERVISOR_mmuext_op(&op, 1, NULL, DOMID_SELF) < 0)
-		BUG();
+	op->arg1.mfn = pfn_to_mfn(PFN_DOWN(__pa(pgd)));
+	MULTI_mmuext_op(mcs.mc, op, 1, NULL, DOMID_SELF);
+
+	xen_mc_issue(0);
+}
+
+/* The init_mm pagetable is really pinned as soon as its created, but
+   that's before we have page structures to store the bits.  So do all
+   the book-keeping now. */
+static __init int mark_pinned(struct page *page, unsigned flags)
+{
+	SetPagePinned(page);
+	return 0;
+}
+
+void __init xen_mark_init_mm_pinned(void)
+{
+	pgd_walk(init_mm.pgd, mark_pinned, FIXADDR_TOP);
+}
+
+static int unpin_page(struct page *page, unsigned flags)
+{
+	unsigned pgfl = test_and_clear_bit(PG_pinned, &page->flags);
+
+	if (pgfl && !PageHighMem(page)) {
+		void *pt = lowmem_page_address(page);
+		unsigned long pfn = page_to_pfn(page);
+		struct multicall_space mcs = __xen_mc_entry(0);
+
+		MULTI_update_va_mapping(mcs.mc, (unsigned long)pt,
+					pfn_pte(pfn, PAGE_KERNEL),
+					flags);
+	}
+
+	return 0;		/* never need to flush on unpin */
 }
 
 /* Release a pagetables pages back as normal RW */
-void xen_pgd_unpin(pgd_t *pgd)
-{
-	struct mmuext_op op;
-
-	op.cmd = MMUEXT_UNPIN_TABLE;
-	op.arg1.mfn = pfn_to_mfn(PFN_DOWN(__pa(pgd)));
-
-	if (HYPERVISOR_mmuext_op(&op, 1, NULL, DOMID_SELF) < 0)
-		BUG();
-
-	pgd_walk(pgd, PAGE_KERNEL);
+static void xen_pgd_unpin(pgd_t *pgd)
+{
+	struct mmuext_op *op;
+	struct multicall_space mcs;
+
+	xen_mc_batch();
+
+	mcs = __xen_mc_entry(sizeof(*op));
+
+	op = mcs.args;
+	op->cmd = MMUEXT_UNPIN_TABLE;
+	op->arg1.mfn = pfn_to_mfn(PFN_DOWN(__pa(pgd)));
+
+	MULTI_mmuext_op(mcs.mc, op, 1, NULL, DOMID_SELF);
+
+	pgd_walk(pgd, unpin_page, TASK_SIZE);
+
+	xen_mc_issue(0);
 }
 
 
 void xen_activate_mm(struct mm_struct *prev, struct mm_struct *next)
 {
+	spin_lock(&next->page_table_lock);
 	xen_pgd_pin(next->pgd);
+	spin_unlock(&next->page_table_lock);
 }
 
 void xen_dup_mmap(struct mm_struct *oldmm, struct mm_struct *mm)
 {
+	spin_lock(&mm->page_table_lock);
 	xen_pgd_pin(mm->pgd);
+	spin_unlock(&mm->page_table_lock);
 }
 
 void xen_exit_mmap(struct mm_struct *mm)
===================================================================
--- a/arch/i386/xen/mmu.h
+++ b/arch/i386/xen/mmu.h
@@ -15,7 +15,7 @@ void xen_exit_mmap(struct mm_struct *mm)
 void xen_exit_mmap(struct mm_struct *mm);
 
 void xen_pgd_pin(pgd_t *pgd);
-void xen_pgd_unpin(pgd_t *pgd);
+//void xen_pgd_unpin(pgd_t *pgd);
 
 #ifdef CONFIG_X86_PAE
 unsigned long long xen_pte_val(pte_t);
===================================================================
--- a/arch/i386/xen/xen-ops.h
+++ b/arch/i386/xen/xen-ops.h
@@ -20,6 +20,8 @@ int xen_set_wallclock(unsigned long time
 int xen_set_wallclock(unsigned long time);
 cycle_t xen_clocksource_read(void);
 
+void xen_mark_init_mm_pinned(void);
+
 DECLARE_PER_CPU(enum paravirt_lazy_mode, xen_lazy_mode);
 
 static inline unsigned xen_get_lazy_mode(void)

-- 

