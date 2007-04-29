Return-Path: <linux-kernel-owner+w=401wt.eu-S1031046AbXD2Rki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031046AbXD2Rki (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 13:40:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030890AbXD2RbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 13:31:06 -0400
Received: from gw.goop.org ([64.81.55.164]:58979 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753832AbXD2RaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 13:30:17 -0400
Message-Id: <20070429172911.581459000@goop.org>
References: <20070429172835.284784000@goop.org>
User-Agent: quilt/0.46-1
Date: Sun, 29 Apr 2007 10:28:41 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>
Subject: [patch 06/32] xen: Xen virtual mmu
Content-Disposition: inline; filename=xen-mmu.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Xen pagetable handling, including the machinery to implement direct
pagetables.  This means that pte update operations are intercepted so
that pseudo-physical addresses can be converted to machine addresses.
It also implements late pinning/early unpinning so that pagetables are
initialized while they're normal read-write memory as much as
possible, yet pinned to make cr3 reloads as efficient as possible.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

---
 arch/i386/xen/Makefile    |    2 
 arch/i386/xen/enlighten.c |   30 ++-
 arch/i386/xen/mmu.c       |  419 +++++++++++++++++++++++++++++++++++++++++++++
 arch/i386/xen/mmu.h       |   47 +++++
 4 files changed, 493 insertions(+), 5 deletions(-)

===================================================================
--- a/arch/i386/xen/Makefile
+++ b/arch/i386/xen/Makefile
@@ -1,1 +1,1 @@ obj-y		:= enlighten.o setup.o features.o
-obj-y		:= enlighten.o setup.o features.o multicalls.o
+obj-y		:= enlighten.o setup.o features.o multicalls.o mmu.o
===================================================================
--- a/arch/i386/xen/enlighten.c
+++ b/arch/i386/xen/enlighten.c
@@ -39,6 +39,7 @@
 #include <asm/pgtable.h>
 
 #include "xen-ops.h"
+#include "mmu.h"
 #include "multicalls.h"
 
 EXPORT_SYMBOL_GPL(hypercall_page);
@@ -565,11 +566,9 @@ static __init void xen_pagetable_setup_d
 		 * Should be set_fixmap(), but shared_info is a machine
 		 * address with no corresponding pseudo-phys address.
 		 */
-#if 0
 		set_pte_mfn(fix_to_virt(FIX_PARAVIRT_BOOTMAP),
 			    PFN_DOWN(xen_start_info->shared_info),
 			    PAGE_KERNEL);
-#endif
 
 		HYPERVISOR_shared_info =
 			(struct shared_info *)fix_to_virt(FIX_PARAVIRT_BOOTMAP);
@@ -578,9 +577,7 @@ static __init void xen_pagetable_setup_d
 		HYPERVISOR_shared_info =
 			(struct shared_info *)__va(xen_start_info->shared_info);
 
-#if 0
 	xen_pgd_pin(base);
-#endif
 
 	xen_vcpu_setup(smp_processor_id());
 }
@@ -682,6 +679,31 @@ static const struct paravirt_ops xen_par
 	.release_pd = xen_release_pd,
 	.release_pt = xen_release_pt,
 
+	.set_pte = xen_set_pte,
+	.set_pte_at = xen_set_pte_at,
+	.set_pmd = xen_set_pmd,
+
+	.pte_val = xen_pte_val,
+	.pgd_val = xen_pgd_val,
+
+	.make_pte = xen_make_pte,
+	.make_pgd = xen_make_pgd,
+
+#ifdef CONFIG_X86_PAE
+	.set_pte_atomic = xen_set_pte_atomic,
+	.set_pte_present = xen_set_pte_at,
+	.set_pud = xen_set_pud,
+	.pte_clear = xen_pte_clear,
+	.pmd_clear = xen_pmd_clear,
+
+	.make_pmd = xen_make_pmd,
+	.pmd_val = xen_pmd_val,
+#endif	/* PAE */
+
+	.activate_mm = xen_activate_mm,
+	.dup_mmap = xen_dup_mmap,
+	.exit_mmap = xen_exit_mmap,
+
 	.set_lazy_mode = xen_set_lazy_mode,
 };
 
===================================================================
--- /dev/null
+++ b/arch/i386/xen/mmu.c
@@ -0,0 +1,419 @@
+/*
+ * Xen mmu operations
+ *
+ * This file contains the various mmu fetch and update operations.
+ * The most important job they must perform is the mapping between the
+ * domain's pfn and the overall machine mfns.
+ *
+ * Xen allows guests to directly update the pagetable, in a controlled
+ * fashion.  In other words, the guest modifies the same pagetable
+ * that the CPU actually uses, which eliminates the overhead of having
+ * a separate shadow pagetable.
+ *
+ * In order to allow this, it falls on the guest domain to map its
+ * notion of a "physical" pfn - which is just a domain-local linear
+ * address - into a real "machine address" which the CPU's MMU can
+ * use.
+ *
+ * A pgd_t/pmd_t/pte_t will typically contain an mfn, and so can be
+ * inserted directly into the pagetable.  When creating a new
+ * pte/pmd/pgd, it converts the passed pfn into an mfn.  Conversely,
+ * when reading the content back with __(pgd|pmd|pte)_val, it converts
+ * the mfn back into a pfn.
+ *
+ * The other constraint is that all pages which make up a pagetable
+ * must be mapped read-only in the guest.  This prevents uncontrolled
+ * guest updates to the pagetable.  Xen strictly enforces this, and
+ * will disallow any pagetable update which will end up mapping a
+ * pagetable page RW, and will disallow using any writable page as a
+ * pagetable.
+ *
+ * Naively, when loading %cr3 with the base of a new pagetable, Xen
+ * would need to validate the whole pagetable before going on.
+ * Naturally, this is quite slow.  The solution is to "pin" a
+ * pagetable, which enforces all the constraints on the pagetable even
+ * when it is not actively in use.  This menas that Xen can be assured
+ * that it is still valid when you do load it into %cr3, and doesn't
+ * need to revalidate it.
+ *
+ * Jeremy Fitzhardinge <jeremy@xensource.com>, XenSource Inc, 2007
+ */
+#include <asm/bug.h>
+
+#include <asm/pgtable.h>
+#include <asm/tlbflush.h>
+#include <asm/mmu_context.h>
+
+#include <asm/xen/hypercall.h>
+#include <asm/paravirt.h>
+
+#include <xen/page.h>
+#include <xen/interface/xen.h>
+
+#include "mmu.h"
+
+xmaddr_t arbitrary_virt_to_machine(unsigned long address)
+{
+	pte_t *pte = lookup_address(address);
+	unsigned offset = address & PAGE_MASK;
+
+	BUG_ON(pte == NULL);
+
+	return XMADDR((pte_mfn(*pte) << PAGE_SHIFT) + offset);
+}
+
+void make_lowmem_page_readonly(void *vaddr)
+{
+	pte_t *pte, ptev;
+	unsigned long address = (unsigned long)vaddr;
+
+	pte = lookup_address(address);
+	BUG_ON(pte == NULL);
+
+	ptev = pte_wrprotect(*pte);
+
+	if(HYPERVISOR_update_va_mapping(address, ptev, 0))
+		BUG();
+}
+
+void make_lowmem_page_readwrite(void *vaddr)
+{
+	pte_t *pte, ptev;
+	unsigned long address = (unsigned long)vaddr;
+
+	pte = lookup_address(address);
+	BUG_ON(pte == NULL);
+
+	ptev = pte_mkwrite(*pte);
+
+	if(HYPERVISOR_update_va_mapping(address, ptev, 0))
+		BUG();
+}
+
+
+void xen_set_pte(pte_t *ptep, pte_t pte)
+{
+	struct mmu_update u;
+
+	u.ptr = virt_to_machine(ptep).maddr;
+	u.val = pte_val_ma(pte);
+	if (HYPERVISOR_mmu_update(&u, 1, NULL, DOMID_SELF) < 0)
+		BUG();
+}
+
+void xen_set_pmd(pmd_t *ptr, pmd_t val)
+{
+	struct mmu_update u;
+
+	u.ptr = virt_to_machine(ptr).maddr;
+	u.val = pmd_val_ma(val);
+	if (HYPERVISOR_mmu_update(&u, 1, NULL, DOMID_SELF) < 0)
+		BUG();
+}
+
+#ifdef CONFIG_X86_PAE
+void xen_set_pud(pud_t *ptr, pud_t val)
+{
+	struct mmu_update u;
+
+	u.ptr = virt_to_machine(ptr).maddr;
+	u.val = pud_val_ma(val);
+	if (HYPERVISOR_mmu_update(&u, 1, NULL, DOMID_SELF) < 0)
+		BUG();
+}
+#endif
+
+/*
+ * Associate a virtual page frame with a given physical page frame
+ * and protection flags for that frame.
+ */
+void set_pte_mfn(unsigned long vaddr, unsigned long mfn, pgprot_t flags)
+{
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *pte;
+
+	pgd = swapper_pg_dir + pgd_index(vaddr);
+	if (pgd_none(*pgd)) {
+		BUG();
+		return;
+	}
+	pud = pud_offset(pgd, vaddr);
+	if (pud_none(*pud)) {
+		BUG();
+		return;
+	}
+	pmd = pmd_offset(pud, vaddr);
+	if (pmd_none(*pmd)) {
+		BUG();
+		return;
+	}
+	pte = pte_offset_kernel(pmd, vaddr);
+	/* <mfn,flags> stored as-is, to permit clearing entries */
+	xen_set_pte(pte, mfn_pte(mfn, flags));
+
+	/*
+	 * It's enough to flush this one mapping.
+	 * (PGE mappings get flushed as well)
+	 */
+	__flush_tlb_one(vaddr);
+}
+
+void xen_set_pte_at(struct mm_struct *mm, unsigned long addr,
+		    pte_t *ptep, pte_t pteval)
+{
+	if ((mm != current->mm && mm != &init_mm) ||
+	    HYPERVISOR_update_va_mapping(addr, pteval, 0) != 0)
+		xen_set_pte(ptep, pteval);
+}
+
+#ifdef CONFIG_X86_PAE
+void xen_set_pte_atomic(pte_t *ptep, pte_t pte)
+{
+	set_64bit((u64 *)ptep, pte_val_ma(pte));
+}
+
+void xen_pte_clear(struct mm_struct *mm, unsigned long addr,pte_t *ptep)
+{
+	ptep->pte_low = 0;
+	smp_wmb();
+	ptep->pte_high = 0;
+}
+
+void xen_pmd_clear(pmd_t *pmdp)
+{
+	xen_set_pmd(pmdp, __pmd(0));
+}
+
+unsigned long long xen_pte_val(pte_t pte)
+{
+	unsigned long long ret = 0;
+
+	if (pte.pte_low) {
+		ret = ((unsigned long long)pte.pte_high << 32) | pte.pte_low;
+		ret = machine_to_phys(XMADDR(ret)).paddr | 1;
+	}
+
+	return ret;
+}
+
+unsigned long long xen_pmd_val(pmd_t pmd)
+{
+	unsigned long long ret = pmd.pmd;
+	if (ret)
+		ret = machine_to_phys(XMADDR(ret)).paddr | 1;
+	return ret;
+}
+
+unsigned long long xen_pgd_val(pgd_t pgd)
+{
+	unsigned long long ret = pgd.pgd;
+	if (ret)
+		ret = machine_to_phys(XMADDR(ret)).paddr | 1;
+	return ret;
+}
+
+pte_t xen_make_pte(unsigned long long pte)
+{
+	if (pte & 1)
+		pte = phys_to_machine(XPADDR(pte)).maddr;
+
+	return (pte_t){ pte, pte >> 32 };
+}
+
+pmd_t xen_make_pmd(unsigned long long pmd)
+{
+	if (pmd & 1)
+		pmd = phys_to_machine(XPADDR(pmd)).maddr;
+
+	return (pmd_t){ pmd };
+}
+
+pgd_t xen_make_pgd(unsigned long long pgd)
+{
+	if (pgd & _PAGE_PRESENT)
+		pgd = phys_to_machine(XPADDR(pgd)).maddr;
+
+	return (pgd_t){ pgd };
+}
+#else  /* !PAE */
+unsigned long xen_pte_val(pte_t pte)
+{
+	unsigned long ret = pte.pte_low;
+
+	if (ret & _PAGE_PRESENT)
+		ret = machine_to_phys(XMADDR(ret)).paddr;
+
+	return ret;
+}
+
+unsigned long xen_pmd_val(pmd_t pmd)
+{
+	/* a BUG here is a lot easier to track down than a NULL eip */
+	BUG();
+	return 0;
+}
+
+unsigned long xen_pgd_val(pgd_t pgd)
+{
+	unsigned long ret = pgd.pgd;
+	if (ret)
+		ret = machine_to_phys(XMADDR(ret)).paddr | 1;
+	return ret;
+}
+
+pte_t xen_make_pte(unsigned long pte)
+{
+	if (pte & _PAGE_PRESENT)
+		pte = phys_to_machine(XPADDR(pte)).maddr;
+
+	return (pte_t){ pte };
+}
+
+pmd_t xen_make_pmd(unsigned long pmd)
+{
+	/* a BUG here is a lot easier to track down than a NULL eip */
+	BUG();
+	return __pmd(0);
+}
+
+pgd_t xen_make_pgd(unsigned long pgd)
+{
+	if (pgd & _PAGE_PRESENT)
+		pgd = phys_to_machine(XPADDR(pgd)).maddr;
+
+	return (pgd_t){ pgd };
+}
+#endif	/* CONFIG_X86_PAE */
+
+
+
+static void pgd_walk_set_prot(void *pt, pgprot_t flags)
+{
+	unsigned long pfn = PFN_DOWN(__pa(pt));
+
+	if (HYPERVISOR_update_va_mapping((unsigned long)pt,
+					 pfn_pte(pfn, flags), 0) < 0)
+		BUG();
+}
+
+static void pgd_walk(pgd_t *pgd_base, pgprot_t flags)
+{
+	pgd_t *pgd = pgd_base;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *pte;
+	int    g, u, m;
+
+	if (xen_feature(XENFEAT_auto_translated_physmap))
+		return;
+
+	for (g = 0; g < USER_PTRS_PER_PGD; g++, pgd++) {
+		if (pgd_none(*pgd))
+			continue;
+		pud = pud_offset(pgd, 0);
+
+		if (PTRS_PER_PUD > 1) /* not folded */
+			pgd_walk_set_prot(pud,flags);
+
+		for (u = 0; u < PTRS_PER_PUD; u++, pud++) {
+			if (pud_none(*pud))
+				continue;
+			pmd = pmd_offset(pud, 0);
+
+			if (PTRS_PER_PMD > 1) /* not folded */
+				pgd_walk_set_prot(pmd,flags);
+
+			for (m = 0; m < PTRS_PER_PMD; m++, pmd++) {
+				if (pmd_none(*pmd))
+					continue;
+
+				/* This can get called before mem_map
+				   is set up, so we assume nothing is
+				   highmem at that point. */
+				if (mem_map == NULL ||
+				    !PageHighMem(pmd_page(*pmd))) {
+					pte = pte_offset_kernel(pmd,0);
+					pgd_walk_set_prot(pte,flags);
+				}
+			}
+		}
+	}
+
+	if (HYPERVISOR_update_va_mapping((unsigned long)pgd_base,
+					 pfn_pte(PFN_DOWN(__pa(pgd_base)),
+						 flags),
+					 UVMF_TLB_FLUSH) < 0)
+		BUG();
+}
+
+
+/* This is called just after a mm has been duplicated from its parent,
+   but it has not been used yet.  We need to make sure that its
+   pagetable is all read-only, and can be pinned. */
+void xen_pgd_pin(pgd_t *pgd)
+{
+	struct mmuext_op op;
+
+	pgd_walk(pgd, PAGE_KERNEL_RO);
+
+#if defined(CONFIG_X86_PAE)
+	op.cmd = MMUEXT_PIN_L3_TABLE;
+#else
+	op.cmd = MMUEXT_PIN_L2_TABLE;
+#endif
+	op.arg1.mfn = pfn_to_mfn(PFN_DOWN(__pa(pgd)));
+	if (HYPERVISOR_mmuext_op(&op, 1, NULL, DOMID_SELF) < 0)
+		BUG();
+}
+
+/* Release a pagetables pages back as normal RW */
+void xen_pgd_unpin(pgd_t *pgd)
+{
+	struct mmuext_op op;
+
+	op.cmd = MMUEXT_UNPIN_TABLE;
+	op.arg1.mfn = pfn_to_mfn(PFN_DOWN(__pa(pgd)));
+
+	if (HYPERVISOR_mmuext_op(&op, 1, NULL, DOMID_SELF) < 0)
+		BUG();
+
+	pgd_walk(pgd, PAGE_KERNEL);
+}
+
+
+void xen_activate_mm(struct mm_struct *prev, struct mm_struct *next)
+{
+	xen_pgd_pin(next->pgd);
+}
+
+void xen_dup_mmap(struct mm_struct *oldmm, struct mm_struct *mm)
+{
+	xen_pgd_pin(mm->pgd);
+}
+
+void xen_exit_mmap(struct mm_struct *mm)
+{
+	struct task_struct *tsk = current;
+
+	task_lock(tsk);
+
+	/*
+	 * We aggressively remove defunct pgd from cr3. We execute unmap_vmas()
+	 * *much* faster this way, as no tlb flushes means bigger wrpt batches.
+	 */
+	if (tsk->active_mm == mm) {
+		tsk->active_mm = &init_mm;
+		atomic_inc(&init_mm.mm_count);
+
+		switch_mm(mm, &init_mm, tsk);
+
+		atomic_dec(&mm->mm_count);
+		BUG_ON(atomic_read(&mm->mm_count) == 0);
+	}
+
+	task_unlock(tsk);
+
+	xen_pgd_unpin(mm->pgd);
+}
===================================================================
--- /dev/null
+++ b/arch/i386/xen/mmu.h
@@ -0,0 +1,47 @@
+#ifndef _XEN_MMU_H
+
+#include <linux/linkage.h>
+#include <asm/page.h>
+
+void set_pte_mfn(unsigned long vaddr, unsigned long pfn, pgprot_t flags);
+
+void xen_set_pte(pte_t *ptep, pte_t pteval);
+void xen_set_pte_at(struct mm_struct *mm, unsigned long addr,
+		    pte_t *ptep, pte_t pteval);
+void xen_set_pmd(pmd_t *pmdp, pmd_t pmdval);
+
+void xen_activate_mm(struct mm_struct *prev, struct mm_struct *next);
+void xen_dup_mmap(struct mm_struct *oldmm, struct mm_struct *mm);
+void xen_exit_mmap(struct mm_struct *mm);
+
+void xen_pgd_pin(pgd_t *pgd);
+void xen_pgd_unpin(pgd_t *pgd);
+
+#ifdef CONFIG_X86_PAE
+unsigned long long xen_pte_val(pte_t);
+unsigned long long xen_pmd_val(pmd_t);
+unsigned long long xen_pgd_val(pgd_t);
+
+pte_t xen_make_pte(unsigned long long);
+pmd_t xen_make_pmd(unsigned long long);
+pgd_t xen_make_pgd(unsigned long long);
+
+void xen_set_pte_at(struct mm_struct *mm, unsigned long addr,
+		    pte_t *ptep, pte_t pteval);
+void xen_set_pte_atomic(pte_t *ptep, pte_t pte);
+void xen_set_pud(pud_t *ptr, pud_t val);
+void xen_pte_clear(struct mm_struct *mm, unsigned long addr,pte_t *ptep);
+void xen_pmd_clear(pmd_t *pmdp);
+
+
+#else
+unsigned long xen_pte_val(pte_t);
+unsigned long xen_pmd_val(pmd_t);
+unsigned long xen_pgd_val(pgd_t);
+
+pte_t xen_make_pte(unsigned long);
+pmd_t xen_make_pmd(unsigned long);
+pgd_t xen_make_pgd(unsigned long);
+#endif
+
+#endif	/* _XEN_MMU_H */

-- 

