Return-Path: <linux-kernel-owner+w=401wt.eu-S1755538AbZA1WoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538AbZA1WoP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 17:44:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752486AbZA1Wmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 17:42:42 -0500
Received: from gw.goop.org ([64.81.55.164]:52549 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751364AbZA1Wmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 17:42:39 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 1 of 7] xen: move remaining mmu-related stuff into mmu.c
X-Mercurial-Node: bae8f03f625e978f9df9fbb891c984b319264c4c
Message-Id: <bae8f03f625e978f9df9.1233182101@abulafia.goop.org>
In-Reply-To: <patchbomb.1233182100@abulafia.goop.org>
References: <patchbomb.1233182100@abulafia.goop.org>
Date: Wed, 28 Jan 2009 14:35:01 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Ravikiran Thirumalai <kiran@scalemp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A general cleanup, and lay the groundwork for later patches.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/enlighten.c |  731 ----------------------------------------------
 arch/x86/xen/mmu.c       |  700 ++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/xen/mmu.h       |    3
 arch/x86/xen/xen-ops.h   |    8
 4 files changed, 712 insertions(+), 730 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -61,35 +61,6 @@
 enum xen_domain_type xen_domain_type = XEN_NATIVE;
 EXPORT_SYMBOL_GPL(xen_domain_type);
 
-/*
- * Identity map, in addition to plain kernel map.  This needs to be
- * large enough to allocate page table pages to allocate the rest.
- * Each page can map 2MB.
- */
-static pte_t level1_ident_pgt[PTRS_PER_PTE * 4] __page_aligned_bss;
-
-#ifdef CONFIG_X86_64
-/* l3 pud for userspace vsyscall mapping */
-static pud_t level3_user_vsyscall[PTRS_PER_PUD] __page_aligned_bss;
-#endif /* CONFIG_X86_64 */
-
-/*
- * Note about cr3 (pagetable base) values:
- *
- * xen_cr3 contains the current logical cr3 value; it contains the
- * last set cr3.  This may not be the current effective cr3, because
- * its update may be being lazily deferred.  However, a vcpu looking
- * at its own cr3 can use this value knowing that it everything will
- * be self-consistent.
- *
- * xen_current_cr3 contains the actual vcpu cr3; it is set once the
- * hypercall to set the vcpu cr3 is complete (so it may be a little
- * out of date, but it will never be set early).  If one vcpu is
- * looking at another vcpu's cr3 value, it should use this variable.
- */
-DEFINE_PER_CPU(unsigned long, xen_cr3);	 /* cr3 stored as physaddr */
-DEFINE_PER_CPU(unsigned long, xen_current_cr3);	 /* actual vcpu cr3 */
-
 struct start_info *xen_start_info;
 EXPORT_SYMBOL_GPL(xen_start_info);
 
@@ -237,7 +208,7 @@
 	return HYPERVISOR_get_debugreg(reg);
 }
 
-static void xen_leave_lazy(void)
+void xen_leave_lazy(void)
 {
 	paravirt_leave_lazy(paravirt_get_lazy_mode());
 	xen_mc_flush();
@@ -598,76 +569,6 @@
 
 #endif
 
-static void xen_flush_tlb(void)
-{
-	struct mmuext_op *op;
-	struct multicall_space mcs;
-
-	preempt_disable();
-
-	mcs = xen_mc_entry(sizeof(*op));
-
-	op = mcs.args;
-	op->cmd = MMUEXT_TLB_FLUSH_LOCAL;
-	MULTI_mmuext_op(mcs.mc, op, 1, NULL, DOMID_SELF);
-
-	xen_mc_issue(PARAVIRT_LAZY_MMU);
-
-	preempt_enable();
-}
-
-static void xen_flush_tlb_single(unsigned long addr)
-{
-	struct mmuext_op *op;
-	struct multicall_space mcs;
-
-	preempt_disable();
-
-	mcs = xen_mc_entry(sizeof(*op));
-	op = mcs.args;
-	op->cmd = MMUEXT_INVLPG_LOCAL;
-	op->arg1.linear_addr = addr & PAGE_MASK;
-	MULTI_mmuext_op(mcs.mc, op, 1, NULL, DOMID_SELF);
-
-	xen_mc_issue(PARAVIRT_LAZY_MMU);
-
-	preempt_enable();
-}
-
-static void xen_flush_tlb_others(const struct cpumask *cpus,
-				 struct mm_struct *mm, unsigned long va)
-{
-	struct {
-		struct mmuext_op op;
-		DECLARE_BITMAP(mask, NR_CPUS);
-	} *args;
-	struct multicall_space mcs;
-
-	BUG_ON(cpumask_empty(cpus));
-	BUG_ON(!mm);
-
-	mcs = xen_mc_entry(sizeof(*args));
-	args = mcs.args;
-	args->op.arg2.vcpumask = to_cpumask(args->mask);
-
-	/* Remove us, and any offline CPUS. */
-	cpumask_and(to_cpumask(args->mask), cpus, cpu_online_mask);
-	cpumask_clear_cpu(smp_processor_id(), to_cpumask(args->mask));
-	if (unlikely(cpumask_empty(to_cpumask(args->mask))))
-		goto issue;
-
-	if (va == TLB_FLUSH_ALL) {
-		args->op.cmd = MMUEXT_TLB_FLUSH_MULTI;
-	} else {
-		args->op.cmd = MMUEXT_INVLPG_MULTI;
-		args->op.arg1.linear_addr = va;
-	}
-
-	MULTI_mmuext_op(mcs.mc, &args->op, 1, NULL, DOMID_SELF);
-
-issue:
-	xen_mc_issue(PARAVIRT_LAZY_MMU);
-}
 
 static void xen_clts(void)
 {
@@ -693,21 +594,6 @@
 	xen_mc_issue(PARAVIRT_LAZY_CPU);
 }
 
-static void xen_write_cr2(unsigned long cr2)
-{
-	percpu_read(xen_vcpu)->arch.cr2 = cr2;
-}
-
-static unsigned long xen_read_cr2(void)
-{
-	return percpu_read(xen_vcpu)->arch.cr2;
-}
-
-static unsigned long xen_read_cr2_direct(void)
-{
-	return percpu_read(xen_vcpu_info.arch.cr2);
-}
-
 static void xen_write_cr4(unsigned long cr4)
 {
 	cr4 &= ~X86_CR4_PGE;
@@ -716,71 +602,6 @@
 	native_write_cr4(cr4);
 }
 
-static unsigned long xen_read_cr3(void)
-{
-	return percpu_read(xen_cr3);
-}
-
-static void set_current_cr3(void *v)
-{
-	percpu_write(xen_current_cr3, (unsigned long)v);
-}
-
-static void __xen_write_cr3(bool kernel, unsigned long cr3)
-{
-	struct mmuext_op *op;
-	struct multicall_space mcs;
-	unsigned long mfn;
-
-	if (cr3)
-		mfn = pfn_to_mfn(PFN_DOWN(cr3));
-	else
-		mfn = 0;
-
-	WARN_ON(mfn == 0 && kernel);
-
-	mcs = __xen_mc_entry(sizeof(*op));
-
-	op = mcs.args;
-	op->cmd = kernel ? MMUEXT_NEW_BASEPTR : MMUEXT_NEW_USER_BASEPTR;
-	op->arg1.mfn = mfn;
-
-	MULTI_mmuext_op(mcs.mc, op, 1, NULL, DOMID_SELF);
-
-	if (kernel) {
-		percpu_write(xen_cr3, cr3);
-
-		/* Update xen_current_cr3 once the batch has actually
-		   been submitted. */
-		xen_mc_callback(set_current_cr3, (void *)cr3);
-	}
-}
-
-static void xen_write_cr3(unsigned long cr3)
-{
-	BUG_ON(preemptible());
-
-	xen_mc_batch();  /* disables interrupts */
-
-	/* Update while interrupts are disabled, so its atomic with
-	   respect to ipis */
-	percpu_write(xen_cr3, cr3);
-
-	__xen_write_cr3(true, cr3);
-
-#ifdef CONFIG_X86_64
-	{
-		pgd_t *user_pgd = xen_get_user_pgd(__va(cr3));
-		if (user_pgd)
-			__xen_write_cr3(false, __pa(user_pgd));
-		else
-			__xen_write_cr3(false, 0);
-	}
-#endif
-
-	xen_mc_issue(PARAVIRT_LAZY_CPU);  /* interrupts restored */
-}
-
 static int xen_write_msr_safe(unsigned int msr, unsigned low, unsigned high)
 {
 	int ret;
@@ -822,185 +643,6 @@
 	return ret;
 }
 
-/* Early in boot, while setting up the initial pagetable, assume
-   everything is pinned. */
-static __init void xen_alloc_pte_init(struct mm_struct *mm, unsigned long pfn)
-{
-#ifdef CONFIG_FLATMEM
-	BUG_ON(mem_map);	/* should only be used early */
-#endif
-	make_lowmem_page_readonly(__va(PFN_PHYS(pfn)));
-}
-
-/* Early release_pte assumes that all pts are pinned, since there's
-   only init_mm and anything attached to that is pinned. */
-static void xen_release_pte_init(unsigned long pfn)
-{
-	make_lowmem_page_readwrite(__va(PFN_PHYS(pfn)));
-}
-
-static void pin_pagetable_pfn(unsigned cmd, unsigned long pfn)
-{
-	struct mmuext_op op;
-	op.cmd = cmd;
-	op.arg1.mfn = pfn_to_mfn(pfn);
-	if (HYPERVISOR_mmuext_op(&op, 1, NULL, DOMID_SELF))
-		BUG();
-}
-
-/* This needs to make sure the new pte page is pinned iff its being
-   attached to a pinned pagetable. */
-static void xen_alloc_ptpage(struct mm_struct *mm, unsigned long pfn, unsigned level)
-{
-	struct page *page = pfn_to_page(pfn);
-
-	if (PagePinned(virt_to_page(mm->pgd))) {
-		SetPagePinned(page);
-
-		vm_unmap_aliases();
-		if (!PageHighMem(page)) {
-			make_lowmem_page_readonly(__va(PFN_PHYS((unsigned long)pfn)));
-			if (level == PT_PTE && USE_SPLIT_PTLOCKS)
-				pin_pagetable_pfn(MMUEXT_PIN_L1_TABLE, pfn);
-		} else {
-			/* make sure there are no stray mappings of
-			   this page */
-			kmap_flush_unused();
-		}
-	}
-}
-
-static void xen_alloc_pte(struct mm_struct *mm, unsigned long pfn)
-{
-	xen_alloc_ptpage(mm, pfn, PT_PTE);
-}
-
-static void xen_alloc_pmd(struct mm_struct *mm, unsigned long pfn)
-{
-	xen_alloc_ptpage(mm, pfn, PT_PMD);
-}
-
-static int xen_pgd_alloc(struct mm_struct *mm)
-{
-	pgd_t *pgd = mm->pgd;
-	int ret = 0;
-
-	BUG_ON(PagePinned(virt_to_page(pgd)));
-
-#ifdef CONFIG_X86_64
-	{
-		struct page *page = virt_to_page(pgd);
-		pgd_t *user_pgd;
-
-		BUG_ON(page->private != 0);
-
-		ret = -ENOMEM;
-
-		user_pgd = (pgd_t *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
-		page->private = (unsigned long)user_pgd;
-
-		if (user_pgd != NULL) {
-			user_pgd[pgd_index(VSYSCALL_START)] =
-				__pgd(__pa(level3_user_vsyscall) | _PAGE_TABLE);
-			ret = 0;
-		}
-
-		BUG_ON(PagePinned(virt_to_page(xen_get_user_pgd(pgd))));
-	}
-#endif
-
-	return ret;
-}
-
-static void xen_pgd_free(struct mm_struct *mm, pgd_t *pgd)
-{
-#ifdef CONFIG_X86_64
-	pgd_t *user_pgd = xen_get_user_pgd(pgd);
-
-	if (user_pgd)
-		free_page((unsigned long)user_pgd);
-#endif
-}
-
-/* This should never happen until we're OK to use struct page */
-static void xen_release_ptpage(unsigned long pfn, unsigned level)
-{
-	struct page *page = pfn_to_page(pfn);
-
-	if (PagePinned(page)) {
-		if (!PageHighMem(page)) {
-			if (level == PT_PTE && USE_SPLIT_PTLOCKS)
-				pin_pagetable_pfn(MMUEXT_UNPIN_TABLE, pfn);
-			make_lowmem_page_readwrite(__va(PFN_PHYS(pfn)));
-		}
-		ClearPagePinned(page);
-	}
-}
-
-static void xen_release_pte(unsigned long pfn)
-{
-	xen_release_ptpage(pfn, PT_PTE);
-}
-
-static void xen_release_pmd(unsigned long pfn)
-{
-	xen_release_ptpage(pfn, PT_PMD);
-}
-
-#if PAGETABLE_LEVELS == 4
-static void xen_alloc_pud(struct mm_struct *mm, unsigned long pfn)
-{
-	xen_alloc_ptpage(mm, pfn, PT_PUD);
-}
-
-static void xen_release_pud(unsigned long pfn)
-{
-	xen_release_ptpage(pfn, PT_PUD);
-}
-#endif
-
-#ifdef CONFIG_HIGHPTE
-static void *xen_kmap_atomic_pte(struct page *page, enum km_type type)
-{
-	pgprot_t prot = PAGE_KERNEL;
-
-	if (PagePinned(page))
-		prot = PAGE_KERNEL_RO;
-
-	if (0 && PageHighMem(page))
-		printk("mapping highpte %lx type %d prot %s\n",
-		       page_to_pfn(page), type,
-		       (unsigned long)pgprot_val(prot) & _PAGE_RW ? "WRITE" : "READ");
-
-	return kmap_atomic_prot(page, type, prot);
-}
-#endif
-
-#ifdef CONFIG_X86_32
-static __init pte_t mask_rw_pte(pte_t *ptep, pte_t pte)
-{
-	/* If there's an existing pte, then don't allow _PAGE_RW to be set */
-	if (pte_val_ma(*ptep) & _PAGE_PRESENT)
-		pte = __pte_ma(((pte_val_ma(*ptep) & _PAGE_RW) | ~_PAGE_RW) &
-			       pte_val_ma(pte));
-
-	return pte;
-}
-
-/* Init-time set_pte while constructing initial pagetables, which
-   doesn't allow RO pagetable pages to be remapped RW */
-static __init void xen_set_pte_init(pte_t *ptep, pte_t pte)
-{
-	pte = mask_rw_pte(ptep, pte);
-
-	xen_set_pte(ptep, pte);
-}
-#endif
-
-static __init void xen_pagetable_setup_start(pgd_t *base)
-{
-}
-
 void xen_setup_shared_info(void)
 {
 	if (!xen_feature(XENFEAT_auto_translated_physmap)) {
@@ -1021,37 +663,6 @@
 	xen_setup_mfn_list_list();
 }
 
-static __init void xen_pagetable_setup_done(pgd_t *base)
-{
-	xen_setup_shared_info();
-}
-
-static __init void xen_post_allocator_init(void)
-{
-	pv_mmu_ops.set_pte = xen_set_pte;
-	pv_mmu_ops.set_pmd = xen_set_pmd;
-	pv_mmu_ops.set_pud = xen_set_pud;
-#if PAGETABLE_LEVELS == 4
-	pv_mmu_ops.set_pgd = xen_set_pgd;
-#endif
-
-	/* This will work as long as patching hasn't happened yet
-	   (which it hasn't) */
-	pv_mmu_ops.alloc_pte = xen_alloc_pte;
-	pv_mmu_ops.alloc_pmd = xen_alloc_pmd;
-	pv_mmu_ops.release_pte = xen_release_pte;
-	pv_mmu_ops.release_pmd = xen_release_pmd;
-#if PAGETABLE_LEVELS == 4
-	pv_mmu_ops.alloc_pud = xen_alloc_pud;
-	pv_mmu_ops.release_pud = xen_release_pud;
-#endif
-
-#ifdef CONFIG_X86_64
-	SetPagePinned(virt_to_page(level3_user_vsyscall));
-#endif
-	xen_mark_init_mm_pinned();
-}
-
 /* This is called once we have the cpu_possible_map */
 void xen_setup_vcpu_info_placement(void)
 {
@@ -1126,49 +737,6 @@
 	return ret;
 }
 
-static void xen_set_fixmap(unsigned idx, unsigned long phys, pgprot_t prot)
-{
-	pte_t pte;
-
-	phys >>= PAGE_SHIFT;
-
-	switch (idx) {
-	case FIX_BTMAP_END ... FIX_BTMAP_BEGIN:
-#ifdef CONFIG_X86_F00F_BUG
-	case FIX_F00F_IDT:
-#endif
-#ifdef CONFIG_X86_32
-	case FIX_WP_TEST:
-	case FIX_VDSO:
-# ifdef CONFIG_HIGHMEM
-	case FIX_KMAP_BEGIN ... FIX_KMAP_END:
-# endif
-#else
-	case VSYSCALL_LAST_PAGE ... VSYSCALL_FIRST_PAGE:
-#endif
-#ifdef CONFIG_X86_LOCAL_APIC
-	case FIX_APIC_BASE:	/* maps dummy local APIC */
-#endif
-		pte = pfn_pte(phys, prot);
-		break;
-
-	default:
-		pte = mfn_pte(phys, prot);
-		break;
-	}
-
-	__native_set_fixmap(idx, pte);
-
-#ifdef CONFIG_X86_64
-	/* Replicate changes to map the vsyscall page into the user
-	   pagetable vsyscall mapping. */
-	if (idx >= VSYSCALL_LAST_PAGE && idx <= VSYSCALL_FIRST_PAGE) {
-		unsigned long vaddr = __fix_to_virt(idx);
-		set_pte_vaddr_pud(level3_user_vsyscall, vaddr, pte);
-	}
-#endif
-}
-
 static const struct pv_info xen_info __initdata = {
 	.paravirt_enabled = 1,
 	.shared_kernel_pmd = 0,
@@ -1264,86 +832,6 @@
 #endif
 };
 
-static const struct pv_mmu_ops xen_mmu_ops __initdata = {
-	.pagetable_setup_start = xen_pagetable_setup_start,
-	.pagetable_setup_done = xen_pagetable_setup_done,
-
-	.read_cr2 = xen_read_cr2,
-	.write_cr2 = xen_write_cr2,
-
-	.read_cr3 = xen_read_cr3,
-	.write_cr3 = xen_write_cr3,
-
-	.flush_tlb_user = xen_flush_tlb,
-	.flush_tlb_kernel = xen_flush_tlb,
-	.flush_tlb_single = xen_flush_tlb_single,
-	.flush_tlb_others = xen_flush_tlb_others,
-
-	.pte_update = paravirt_nop,
-	.pte_update_defer = paravirt_nop,
-
-	.pgd_alloc = xen_pgd_alloc,
-	.pgd_free = xen_pgd_free,
-
-	.alloc_pte = xen_alloc_pte_init,
-	.release_pte = xen_release_pte_init,
-	.alloc_pmd = xen_alloc_pte_init,
-	.alloc_pmd_clone = paravirt_nop,
-	.release_pmd = xen_release_pte_init,
-
-#ifdef CONFIG_HIGHPTE
-	.kmap_atomic_pte = xen_kmap_atomic_pte,
-#endif
-
-#ifdef CONFIG_X86_64
-	.set_pte = xen_set_pte,
-#else
-	.set_pte = xen_set_pte_init,
-#endif
-	.set_pte_at = xen_set_pte_at,
-	.set_pmd = xen_set_pmd_hyper,
-
-	.ptep_modify_prot_start = __ptep_modify_prot_start,
-	.ptep_modify_prot_commit = __ptep_modify_prot_commit,
-
-	.pte_val = xen_pte_val,
-	.pgd_val = xen_pgd_val,
-
-	.make_pte = xen_make_pte,
-	.make_pgd = xen_make_pgd,
-
-#ifdef CONFIG_X86_PAE
-	.set_pte_atomic = xen_set_pte_atomic,
-	.set_pte_present = xen_set_pte_at,
-	.pte_clear = xen_pte_clear,
-	.pmd_clear = xen_pmd_clear,
-#endif	/* CONFIG_X86_PAE */
-	.set_pud = xen_set_pud_hyper,
-
-	.make_pmd = xen_make_pmd,
-	.pmd_val = xen_pmd_val,
-
-#if PAGETABLE_LEVELS == 4
-	.pud_val = xen_pud_val,
-	.make_pud = xen_make_pud,
-	.set_pgd = xen_set_pgd_hyper,
-
-	.alloc_pud = xen_alloc_pte_init,
-	.release_pud = xen_release_pte_init,
-#endif	/* PAGETABLE_LEVELS == 4 */
-
-	.activate_mm = xen_activate_mm,
-	.dup_mmap = xen_dup_mmap,
-	.exit_mmap = xen_exit_mmap,
-
-	.lazy_mode = {
-		.enter = paravirt_enter_lazy_mmu,
-		.leave = xen_leave_lazy,
-	},
-
-	.set_fixmap = xen_set_fixmap,
-};
-
 static void xen_reboot(int reason)
 {
 	struct sched_shutdown r = { .reason = reason };
@@ -1386,223 +874,6 @@
 };
 
 
-static void __init xen_reserve_top(void)
-{
-#ifdef CONFIG_X86_32
-	unsigned long top = HYPERVISOR_VIRT_START;
-	struct xen_platform_parameters pp;
-
-	if (HYPERVISOR_xen_version(XENVER_platform_parameters, &pp) == 0)
-		top = pp.virt_start;
-
-	reserve_top_address(-top);
-#endif	/* CONFIG_X86_32 */
-}
-
-/*
- * Like __va(), but returns address in the kernel mapping (which is
- * all we have until the physical memory mapping has been set up.
- */
-static void *__ka(phys_addr_t paddr)
-{
-#ifdef CONFIG_X86_64
-	return (void *)(paddr + __START_KERNEL_map);
-#else
-	return __va(paddr);
-#endif
-}
-
-/* Convert a machine address to physical address */
-static unsigned long m2p(phys_addr_t maddr)
-{
-	phys_addr_t paddr;
-
-	maddr &= PTE_PFN_MASK;
-	paddr = mfn_to_pfn(maddr >> PAGE_SHIFT) << PAGE_SHIFT;
-
-	return paddr;
-}
-
-/* Convert a machine address to kernel virtual */
-static void *m2v(phys_addr_t maddr)
-{
-	return __ka(m2p(maddr));
-}
-
-static void set_page_prot(void *addr, pgprot_t prot)
-{
-	unsigned long pfn = __pa(addr) >> PAGE_SHIFT;
-	pte_t pte = pfn_pte(pfn, prot);
-
-	if (HYPERVISOR_update_va_mapping((unsigned long)addr, pte, 0))
-		BUG();
-}
-
-static __init void xen_map_identity_early(pmd_t *pmd, unsigned long max_pfn)
-{
-	unsigned pmdidx, pteidx;
-	unsigned ident_pte;
-	unsigned long pfn;
-
-	ident_pte = 0;
-	pfn = 0;
-	for (pmdidx = 0; pmdidx < PTRS_PER_PMD && pfn < max_pfn; pmdidx++) {
-		pte_t *pte_page;
-
-		/* Reuse or allocate a page of ptes */
-		if (pmd_present(pmd[pmdidx]))
-			pte_page = m2v(pmd[pmdidx].pmd);
-		else {
-			/* Check for free pte pages */
-			if (ident_pte == ARRAY_SIZE(level1_ident_pgt))
-				break;
-
-			pte_page = &level1_ident_pgt[ident_pte];
-			ident_pte += PTRS_PER_PTE;
-
-			pmd[pmdidx] = __pmd(__pa(pte_page) | _PAGE_TABLE);
-		}
-
-		/* Install mappings */
-		for (pteidx = 0; pteidx < PTRS_PER_PTE; pteidx++, pfn++) {
-			pte_t pte;
-
-			if (pfn > max_pfn_mapped)
-				max_pfn_mapped = pfn;
-
-			if (!pte_none(pte_page[pteidx]))
-				continue;
-
-			pte = pfn_pte(pfn, PAGE_KERNEL_EXEC);
-			pte_page[pteidx] = pte;
-		}
-	}
-
-	for (pteidx = 0; pteidx < ident_pte; pteidx += PTRS_PER_PTE)
-		set_page_prot(&level1_ident_pgt[pteidx], PAGE_KERNEL_RO);
-
-	set_page_prot(pmd, PAGE_KERNEL_RO);
-}
-
-#ifdef CONFIG_X86_64
-static void convert_pfn_mfn(void *v)
-{
-	pte_t *pte = v;
-	int i;
-
-	/* All levels are converted the same way, so just treat them
-	   as ptes. */
-	for (i = 0; i < PTRS_PER_PTE; i++)
-		pte[i] = xen_make_pte(pte[i].pte);
-}
-
-/*
- * Set up the inital kernel pagetable.
- *
- * We can construct this by grafting the Xen provided pagetable into
- * head_64.S's preconstructed pagetables.  We copy the Xen L2's into
- * level2_ident_pgt, level2_kernel_pgt and level2_fixmap_pgt.  This
- * means that only the kernel has a physical mapping to start with -
- * but that's enough to get __va working.  We need to fill in the rest
- * of the physical mapping once some sort of allocator has been set
- * up.
- */
-static __init pgd_t *xen_setup_kernel_pagetable(pgd_t *pgd,
-						unsigned long max_pfn)
-{
-	pud_t *l3;
-	pmd_t *l2;
-
-	/* Zap identity mapping */
-	init_level4_pgt[0] = __pgd(0);
-
-	/* Pre-constructed entries are in pfn, so convert to mfn */
-	convert_pfn_mfn(init_level4_pgt);
-	convert_pfn_mfn(level3_ident_pgt);
-	convert_pfn_mfn(level3_kernel_pgt);
-
-	l3 = m2v(pgd[pgd_index(__START_KERNEL_map)].pgd);
-	l2 = m2v(l3[pud_index(__START_KERNEL_map)].pud);
-
-	memcpy(level2_ident_pgt, l2, sizeof(pmd_t) * PTRS_PER_PMD);
-	memcpy(level2_kernel_pgt, l2, sizeof(pmd_t) * PTRS_PER_PMD);
-
-	l3 = m2v(pgd[pgd_index(__START_KERNEL_map + PMD_SIZE)].pgd);
-	l2 = m2v(l3[pud_index(__START_KERNEL_map + PMD_SIZE)].pud);
-	memcpy(level2_fixmap_pgt, l2, sizeof(pmd_t) * PTRS_PER_PMD);
-
-	/* Set up identity map */
-	xen_map_identity_early(level2_ident_pgt, max_pfn);
-
-	/* Make pagetable pieces RO */
-	set_page_prot(init_level4_pgt, PAGE_KERNEL_RO);
-	set_page_prot(level3_ident_pgt, PAGE_KERNEL_RO);
-	set_page_prot(level3_kernel_pgt, PAGE_KERNEL_RO);
-	set_page_prot(level3_user_vsyscall, PAGE_KERNEL_RO);
-	set_page_prot(level2_kernel_pgt, PAGE_KERNEL_RO);
-	set_page_prot(level2_fixmap_pgt, PAGE_KERNEL_RO);
-
-	/* Pin down new L4 */
-	pin_pagetable_pfn(MMUEXT_PIN_L4_TABLE,
-			  PFN_DOWN(__pa_symbol(init_level4_pgt)));
-
-	/* Unpin Xen-provided one */
-	pin_pagetable_pfn(MMUEXT_UNPIN_TABLE, PFN_DOWN(__pa(pgd)));
-
-	/* Switch over */
-	pgd = init_level4_pgt;
-
-	/*
-	 * At this stage there can be no user pgd, and no page
-	 * structure to attach it to, so make sure we just set kernel
-	 * pgd.
-	 */
-	xen_mc_batch();
-	__xen_write_cr3(true, __pa(pgd));
-	xen_mc_issue(PARAVIRT_LAZY_CPU);
-
-	reserve_early(__pa(xen_start_info->pt_base),
-		      __pa(xen_start_info->pt_base +
-			   xen_start_info->nr_pt_frames * PAGE_SIZE),
-		      "XEN PAGETABLES");
-
-	return pgd;
-}
-#else	/* !CONFIG_X86_64 */
-static pmd_t level2_kernel_pgt[PTRS_PER_PMD] __page_aligned_bss;
-
-static __init pgd_t *xen_setup_kernel_pagetable(pgd_t *pgd,
-						unsigned long max_pfn)
-{
-	pmd_t *kernel_pmd;
-
-	init_pg_tables_start = __pa(pgd);
-	init_pg_tables_end = __pa(pgd) + xen_start_info->nr_pt_frames*PAGE_SIZE;
-	max_pfn_mapped = PFN_DOWN(init_pg_tables_end + 512*1024);
-
-	kernel_pmd = m2v(pgd[KERNEL_PGD_BOUNDARY].pgd);
-	memcpy(level2_kernel_pgt, kernel_pmd, sizeof(pmd_t) * PTRS_PER_PMD);
-
-	xen_map_identity_early(level2_kernel_pgt, max_pfn);
-
-	memcpy(swapper_pg_dir, pgd, sizeof(pgd_t) * PTRS_PER_PGD);
-	set_pgd(&swapper_pg_dir[KERNEL_PGD_BOUNDARY],
-			__pgd(__pa(level2_kernel_pgt) | _PAGE_PRESENT));
-
-	set_page_prot(level2_kernel_pgt, PAGE_KERNEL_RO);
-	set_page_prot(swapper_pg_dir, PAGE_KERNEL_RO);
-	set_page_prot(empty_zero_page, PAGE_KERNEL_RO);
-
-	pin_pagetable_pfn(MMUEXT_UNPIN_TABLE, PFN_DOWN(__pa(pgd)));
-
-	xen_write_cr3(__pa(swapper_pg_dir));
-
-	pin_pagetable_pfn(MMUEXT_PIN_L3_TABLE, PFN_DOWN(__pa(swapper_pg_dir)));
-
-	return swapper_pg_dir;
-}
-#endif	/* CONFIG_X86_64 */
-
 /* First C function to be called on Xen boot */
 asmlinkage void __init xen_start_kernel(void)
 {
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -47,6 +47,7 @@
 #include <asm/tlbflush.h>
 #include <asm/fixmap.h>
 #include <asm/mmu_context.h>
+#include <asm/setup.h>
 #include <asm/paravirt.h>
 #include <asm/linkage.h>
 
@@ -55,6 +56,8 @@
 
 #include <xen/page.h>
 #include <xen/interface/xen.h>
+#include <xen/interface/version.h>
+#include <xen/hvc-console.h>
 
 #include "multicalls.h"
 #include "mmu.h"
@@ -114,6 +117,37 @@
 
 #endif /* CONFIG_XEN_DEBUG_FS */
 
+
+/*
+ * Identity map, in addition to plain kernel map.  This needs to be
+ * large enough to allocate page table pages to allocate the rest.
+ * Each page can map 2MB.
+ */
+static pte_t level1_ident_pgt[PTRS_PER_PTE * 4] __page_aligned_bss;
+
+#ifdef CONFIG_X86_64
+/* l3 pud for userspace vsyscall mapping */
+static pud_t level3_user_vsyscall[PTRS_PER_PUD] __page_aligned_bss;
+#endif /* CONFIG_X86_64 */
+
+/*
+ * Note about cr3 (pagetable base) values:
+ *
+ * xen_cr3 contains the current logical cr3 value; it contains the
+ * last set cr3.  This may not be the current effective cr3, because
+ * its update may be being lazily deferred.  However, a vcpu looking
+ * at its own cr3 can use this value knowing that it everything will
+ * be self-consistent.
+ *
+ * xen_current_cr3 contains the actual vcpu cr3; it is set once the
+ * hypercall to set the vcpu cr3 is complete (so it may be a little
+ * out of date, but it will never be set early).  If one vcpu is
+ * looking at another vcpu's cr3 value, it should use this variable.
+ */
+DEFINE_PER_CPU(unsigned long, xen_cr3);	 /* cr3 stored as physaddr */
+DEFINE_PER_CPU(unsigned long, xen_current_cr3);	 /* actual vcpu cr3 */
+
+
 /*
  * Just beyond the highest usermode address.  STACK_TOP_MAX has a
  * redzone above it, so round it up to a PGD boundary.
@@ -1152,6 +1186,672 @@
 	spin_unlock(&mm->page_table_lock);
 }
 
+static __init void xen_pagetable_setup_start(pgd_t *base)
+{
+}
+
+static __init void xen_pagetable_setup_done(pgd_t *base)
+{
+	xen_setup_shared_info();
+}
+
+static void xen_write_cr2(unsigned long cr2)
+{
+	percpu_read(xen_vcpu)->arch.cr2 = cr2;
+}
+
+static unsigned long xen_read_cr2(void)
+{
+	return percpu_read(xen_vcpu)->arch.cr2;
+}
+
+unsigned long xen_read_cr2_direct(void)
+{
+	return percpu_read(xen_vcpu_info.arch.cr2);
+}
+
+static void xen_flush_tlb(void)
+{
+	struct mmuext_op *op;
+	struct multicall_space mcs;
+
+	preempt_disable();
+
+	mcs = xen_mc_entry(sizeof(*op));
+
+	op = mcs.args;
+	op->cmd = MMUEXT_TLB_FLUSH_LOCAL;
+	MULTI_mmuext_op(mcs.mc, op, 1, NULL, DOMID_SELF);
+
+	xen_mc_issue(PARAVIRT_LAZY_MMU);
+
+	preempt_enable();
+}
+
+static void xen_flush_tlb_single(unsigned long addr)
+{
+	struct mmuext_op *op;
+	struct multicall_space mcs;
+
+	preempt_disable();
+
+	mcs = xen_mc_entry(sizeof(*op));
+	op = mcs.args;
+	op->cmd = MMUEXT_INVLPG_LOCAL;
+	op->arg1.linear_addr = addr & PAGE_MASK;
+	MULTI_mmuext_op(mcs.mc, op, 1, NULL, DOMID_SELF);
+
+	xen_mc_issue(PARAVIRT_LAZY_MMU);
+
+	preempt_enable();
+}
+
+static void xen_flush_tlb_others(const struct cpumask *cpus,
+				 struct mm_struct *mm, unsigned long va)
+{
+	struct {
+		struct mmuext_op op;
+		DECLARE_BITMAP(mask, NR_CPUS);
+	} *args;
+	struct multicall_space mcs;
+
+	BUG_ON(cpumask_empty(cpus));
+	BUG_ON(!mm);
+
+	mcs = xen_mc_entry(sizeof(*args));
+	args = mcs.args;
+	args->op.arg2.vcpumask = to_cpumask(args->mask);
+
+	/* Remove us, and any offline CPUS. */
+	cpumask_and(to_cpumask(args->mask), cpus, cpu_online_mask);
+	cpumask_clear_cpu(smp_processor_id(), to_cpumask(args->mask));
+	if (unlikely(cpumask_empty(to_cpumask(args->mask))))
+		goto issue;
+
+	if (va == TLB_FLUSH_ALL) {
+		args->op.cmd = MMUEXT_TLB_FLUSH_MULTI;
+	} else {
+		args->op.cmd = MMUEXT_INVLPG_MULTI;
+		args->op.arg1.linear_addr = va;
+	}
+
+	MULTI_mmuext_op(mcs.mc, &args->op, 1, NULL, DOMID_SELF);
+
+issue:
+	xen_mc_issue(PARAVIRT_LAZY_MMU);
+}
+
+static unsigned long xen_read_cr3(void)
+{
+	return percpu_read(xen_cr3);
+}
+
+static void set_current_cr3(void *v)
+{
+	percpu_write(xen_current_cr3, (unsigned long)v);
+}
+
+static void __xen_write_cr3(bool kernel, unsigned long cr3)
+{
+	struct mmuext_op *op;
+	struct multicall_space mcs;
+	unsigned long mfn;
+
+	if (cr3)
+		mfn = pfn_to_mfn(PFN_DOWN(cr3));
+	else
+		mfn = 0;
+
+	WARN_ON(mfn == 0 && kernel);
+
+	mcs = __xen_mc_entry(sizeof(*op));
+
+	op = mcs.args;
+	op->cmd = kernel ? MMUEXT_NEW_BASEPTR : MMUEXT_NEW_USER_BASEPTR;
+	op->arg1.mfn = mfn;
+
+	MULTI_mmuext_op(mcs.mc, op, 1, NULL, DOMID_SELF);
+
+	if (kernel) {
+		percpu_write(xen_cr3, cr3);
+
+		/* Update xen_current_cr3 once the batch has actually
+		   been submitted. */
+		xen_mc_callback(set_current_cr3, (void *)cr3);
+	}
+}
+
+static void xen_write_cr3(unsigned long cr3)
+{
+	BUG_ON(preemptible());
+
+	xen_mc_batch();  /* disables interrupts */
+
+	/* Update while interrupts are disabled, so its atomic with
+	   respect to ipis */
+	percpu_write(xen_cr3, cr3);
+
+	__xen_write_cr3(true, cr3);
+
+#ifdef CONFIG_X86_64
+	{
+		pgd_t *user_pgd = xen_get_user_pgd(__va(cr3));
+		if (user_pgd)
+			__xen_write_cr3(false, __pa(user_pgd));
+		else
+			__xen_write_cr3(false, 0);
+	}
+#endif
+
+	xen_mc_issue(PARAVIRT_LAZY_CPU);  /* interrupts restored */
+}
+
+static int xen_pgd_alloc(struct mm_struct *mm)
+{
+	pgd_t *pgd = mm->pgd;
+	int ret = 0;
+
+	BUG_ON(PagePinned(virt_to_page(pgd)));
+
+#ifdef CONFIG_X86_64
+	{
+		struct page *page = virt_to_page(pgd);
+		pgd_t *user_pgd;
+
+		BUG_ON(page->private != 0);
+
+		ret = -ENOMEM;
+
+		user_pgd = (pgd_t *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
+		page->private = (unsigned long)user_pgd;
+
+		if (user_pgd != NULL) {
+			user_pgd[pgd_index(VSYSCALL_START)] =
+				__pgd(__pa(level3_user_vsyscall) | _PAGE_TABLE);
+			ret = 0;
+		}
+
+		BUG_ON(PagePinned(virt_to_page(xen_get_user_pgd(pgd))));
+	}
+#endif
+
+	return ret;
+}
+
+static void xen_pgd_free(struct mm_struct *mm, pgd_t *pgd)
+{
+#ifdef CONFIG_X86_64
+	pgd_t *user_pgd = xen_get_user_pgd(pgd);
+
+	if (user_pgd)
+		free_page((unsigned long)user_pgd);
+#endif
+}
+
+
+/* Early in boot, while setting up the initial pagetable, assume
+   everything is pinned. */
+static __init void xen_alloc_pte_init(struct mm_struct *mm, unsigned long pfn)
+{
+#ifdef CONFIG_FLATMEM
+	BUG_ON(mem_map);	/* should only be used early */
+#endif
+	make_lowmem_page_readonly(__va(PFN_PHYS(pfn)));
+}
+
+/* Early release_pte assumes that all pts are pinned, since there's
+   only init_mm and anything attached to that is pinned. */
+static void xen_release_pte_init(unsigned long pfn)
+{
+	make_lowmem_page_readwrite(__va(PFN_PHYS(pfn)));
+}
+
+static void pin_pagetable_pfn(unsigned cmd, unsigned long pfn)
+{
+	struct mmuext_op op;
+	op.cmd = cmd;
+	op.arg1.mfn = pfn_to_mfn(pfn);
+	if (HYPERVISOR_mmuext_op(&op, 1, NULL, DOMID_SELF))
+		BUG();
+}
+
+/* This needs to make sure the new pte page is pinned iff its being
+   attached to a pinned pagetable. */
+static void xen_alloc_ptpage(struct mm_struct *mm, unsigned long pfn, unsigned level)
+{
+	struct page *page = pfn_to_page(pfn);
+
+	if (PagePinned(virt_to_page(mm->pgd))) {
+		SetPagePinned(page);
+
+		vm_unmap_aliases();
+		if (!PageHighMem(page)) {
+			make_lowmem_page_readonly(__va(PFN_PHYS((unsigned long)pfn)));
+			if (level == PT_PTE && USE_SPLIT_PTLOCKS)
+				pin_pagetable_pfn(MMUEXT_PIN_L1_TABLE, pfn);
+		} else {
+			/* make sure there are no stray mappings of
+			   this page */
+			kmap_flush_unused();
+		}
+	}
+}
+
+static void xen_alloc_pte(struct mm_struct *mm, unsigned long pfn)
+{
+	xen_alloc_ptpage(mm, pfn, PT_PTE);
+}
+
+static void xen_alloc_pmd(struct mm_struct *mm, unsigned long pfn)
+{
+	xen_alloc_ptpage(mm, pfn, PT_PMD);
+}
+
+/* This should never happen until we're OK to use struct page */
+static void xen_release_ptpage(unsigned long pfn, unsigned level)
+{
+	struct page *page = pfn_to_page(pfn);
+
+	if (PagePinned(page)) {
+		if (!PageHighMem(page)) {
+			if (level == PT_PTE && USE_SPLIT_PTLOCKS)
+				pin_pagetable_pfn(MMUEXT_UNPIN_TABLE, pfn);
+			make_lowmem_page_readwrite(__va(PFN_PHYS(pfn)));
+		}
+		ClearPagePinned(page);
+	}
+}
+
+static void xen_release_pte(unsigned long pfn)
+{
+	xen_release_ptpage(pfn, PT_PTE);
+}
+
+static void xen_release_pmd(unsigned long pfn)
+{
+	xen_release_ptpage(pfn, PT_PMD);
+}
+
+#if PAGETABLE_LEVELS == 4
+static void xen_alloc_pud(struct mm_struct *mm, unsigned long pfn)
+{
+	xen_alloc_ptpage(mm, pfn, PT_PUD);
+}
+
+static void xen_release_pud(unsigned long pfn)
+{
+	xen_release_ptpage(pfn, PT_PUD);
+}
+#endif
+
+void __init xen_reserve_top(void)
+{
+#ifdef CONFIG_X86_32
+	unsigned long top = HYPERVISOR_VIRT_START;
+	struct xen_platform_parameters pp;
+
+	if (HYPERVISOR_xen_version(XENVER_platform_parameters, &pp) == 0)
+		top = pp.virt_start;
+
+	reserve_top_address(-top);
+#endif	/* CONFIG_X86_32 */
+}
+
+/*
+ * Like __va(), but returns address in the kernel mapping (which is
+ * all we have until the physical memory mapping has been set up.
+ */
+static void *__ka(phys_addr_t paddr)
+{
+#ifdef CONFIG_X86_64
+	return (void *)(paddr + __START_KERNEL_map);
+#else
+	return __va(paddr);
+#endif
+}
+
+/* Convert a machine address to physical address */
+static unsigned long m2p(phys_addr_t maddr)
+{
+	phys_addr_t paddr;
+
+	maddr &= PTE_PFN_MASK;
+	paddr = mfn_to_pfn(maddr >> PAGE_SHIFT) << PAGE_SHIFT;
+
+	return paddr;
+}
+
+/* Convert a machine address to kernel virtual */
+static void *m2v(phys_addr_t maddr)
+{
+	return __ka(m2p(maddr));
+}
+
+static void set_page_prot(void *addr, pgprot_t prot)
+{
+	unsigned long pfn = __pa(addr) >> PAGE_SHIFT;
+	pte_t pte = pfn_pte(pfn, prot);
+
+	if (HYPERVISOR_update_va_mapping((unsigned long)addr, pte, 0))
+		BUG();
+}
+
+static __init void xen_map_identity_early(pmd_t *pmd, unsigned long max_pfn)
+{
+	unsigned pmdidx, pteidx;
+	unsigned ident_pte;
+	unsigned long pfn;
+
+	ident_pte = 0;
+	pfn = 0;
+	for (pmdidx = 0; pmdidx < PTRS_PER_PMD && pfn < max_pfn; pmdidx++) {
+		pte_t *pte_page;
+
+		/* Reuse or allocate a page of ptes */
+		if (pmd_present(pmd[pmdidx]))
+			pte_page = m2v(pmd[pmdidx].pmd);
+		else {
+			/* Check for free pte pages */
+			if (ident_pte == ARRAY_SIZE(level1_ident_pgt))
+				break;
+
+			pte_page = &level1_ident_pgt[ident_pte];
+			ident_pte += PTRS_PER_PTE;
+
+			pmd[pmdidx] = __pmd(__pa(pte_page) | _PAGE_TABLE);
+		}
+
+		/* Install mappings */
+		for (pteidx = 0; pteidx < PTRS_PER_PTE; pteidx++, pfn++) {
+			pte_t pte;
+
+			if (pfn > max_pfn_mapped)
+				max_pfn_mapped = pfn;
+
+			if (!pte_none(pte_page[pteidx]))
+				continue;
+
+			pte = pfn_pte(pfn, PAGE_KERNEL_EXEC);
+			pte_page[pteidx] = pte;
+		}
+	}
+
+	for (pteidx = 0; pteidx < ident_pte; pteidx += PTRS_PER_PTE)
+		set_page_prot(&level1_ident_pgt[pteidx], PAGE_KERNEL_RO);
+
+	set_page_prot(pmd, PAGE_KERNEL_RO);
+}
+
+#ifdef CONFIG_X86_64
+static void convert_pfn_mfn(void *v)
+{
+	pte_t *pte = v;
+	int i;
+
+	/* All levels are converted the same way, so just treat them
+	   as ptes. */
+	for (i = 0; i < PTRS_PER_PTE; i++)
+		pte[i] = xen_make_pte(pte[i].pte);
+}
+
+/*
+ * Set up the inital kernel pagetable.
+ *
+ * We can construct this by grafting the Xen provided pagetable into
+ * head_64.S's preconstructed pagetables.  We copy the Xen L2's into
+ * level2_ident_pgt, level2_kernel_pgt and level2_fixmap_pgt.  This
+ * means that only the kernel has a physical mapping to start with -
+ * but that's enough to get __va working.  We need to fill in the rest
+ * of the physical mapping once some sort of allocator has been set
+ * up.
+ */
+__init pgd_t *xen_setup_kernel_pagetable(pgd_t *pgd,
+					 unsigned long max_pfn)
+{
+	pud_t *l3;
+	pmd_t *l2;
+
+	/* Zap identity mapping */
+	init_level4_pgt[0] = __pgd(0);
+
+	/* Pre-constructed entries are in pfn, so convert to mfn */
+	convert_pfn_mfn(init_level4_pgt);
+	convert_pfn_mfn(level3_ident_pgt);
+	convert_pfn_mfn(level3_kernel_pgt);
+
+	l3 = m2v(pgd[pgd_index(__START_KERNEL_map)].pgd);
+	l2 = m2v(l3[pud_index(__START_KERNEL_map)].pud);
+
+	memcpy(level2_ident_pgt, l2, sizeof(pmd_t) * PTRS_PER_PMD);
+	memcpy(level2_kernel_pgt, l2, sizeof(pmd_t) * PTRS_PER_PMD);
+
+	l3 = m2v(pgd[pgd_index(__START_KERNEL_map + PMD_SIZE)].pgd);
+	l2 = m2v(l3[pud_index(__START_KERNEL_map + PMD_SIZE)].pud);
+	memcpy(level2_fixmap_pgt, l2, sizeof(pmd_t) * PTRS_PER_PMD);
+
+	/* Set up identity map */
+	xen_map_identity_early(level2_ident_pgt, max_pfn);
+
+	/* Make pagetable pieces RO */
+	set_page_prot(init_level4_pgt, PAGE_KERNEL_RO);
+	set_page_prot(level3_ident_pgt, PAGE_KERNEL_RO);
+	set_page_prot(level3_kernel_pgt, PAGE_KERNEL_RO);
+	set_page_prot(level3_user_vsyscall, PAGE_KERNEL_RO);
+	set_page_prot(level2_kernel_pgt, PAGE_KERNEL_RO);
+	set_page_prot(level2_fixmap_pgt, PAGE_KERNEL_RO);
+
+	/* Pin down new L4 */
+	pin_pagetable_pfn(MMUEXT_PIN_L4_TABLE,
+			  PFN_DOWN(__pa_symbol(init_level4_pgt)));
+
+	/* Unpin Xen-provided one */
+	pin_pagetable_pfn(MMUEXT_UNPIN_TABLE, PFN_DOWN(__pa(pgd)));
+
+	/* Switch over */
+	pgd = init_level4_pgt;
+
+	/*
+	 * At this stage there can be no user pgd, and no page
+	 * structure to attach it to, so make sure we just set kernel
+	 * pgd.
+	 */
+	xen_mc_batch();
+	__xen_write_cr3(true, __pa(pgd));
+	xen_mc_issue(PARAVIRT_LAZY_CPU);
+
+	reserve_early(__pa(xen_start_info->pt_base),
+		      __pa(xen_start_info->pt_base +
+			   xen_start_info->nr_pt_frames * PAGE_SIZE),
+		      "XEN PAGETABLES");
+
+	return pgd;
+}
+#else	/* !CONFIG_X86_64 */
+static pmd_t level2_kernel_pgt[PTRS_PER_PMD] __page_aligned_bss;
+
+__init pgd_t *xen_setup_kernel_pagetable(pgd_t *pgd,
+					 unsigned long max_pfn)
+{
+	pmd_t *kernel_pmd;
+
+	init_pg_tables_start = __pa(pgd);
+	init_pg_tables_end = __pa(pgd) + xen_start_info->nr_pt_frames*PAGE_SIZE;
+	max_pfn_mapped = PFN_DOWN(init_pg_tables_end + 512*1024);
+
+	kernel_pmd = m2v(pgd[KERNEL_PGD_BOUNDARY].pgd);
+	memcpy(level2_kernel_pgt, kernel_pmd, sizeof(pmd_t) * PTRS_PER_PMD);
+
+	xen_map_identity_early(level2_kernel_pgt, max_pfn);
+
+	memcpy(swapper_pg_dir, pgd, sizeof(pgd_t) * PTRS_PER_PGD);
+	set_pgd(&swapper_pg_dir[KERNEL_PGD_BOUNDARY],
+			__pgd(__pa(level2_kernel_pgt) | _PAGE_PRESENT));
+
+	set_page_prot(level2_kernel_pgt, PAGE_KERNEL_RO);
+	set_page_prot(swapper_pg_dir, PAGE_KERNEL_RO);
+	set_page_prot(empty_zero_page, PAGE_KERNEL_RO);
+
+	pin_pagetable_pfn(MMUEXT_UNPIN_TABLE, PFN_DOWN(__pa(pgd)));
+
+	xen_write_cr3(__pa(swapper_pg_dir));
+
+	pin_pagetable_pfn(MMUEXT_PIN_L3_TABLE, PFN_DOWN(__pa(swapper_pg_dir)));
+
+	return swapper_pg_dir;
+}
+#endif	/* CONFIG_X86_64 */
+
+static void xen_set_fixmap(unsigned idx, unsigned long phys, pgprot_t prot)
+{
+	pte_t pte;
+
+	phys >>= PAGE_SHIFT;
+
+	switch (idx) {
+	case FIX_BTMAP_END ... FIX_BTMAP_BEGIN:
+#ifdef CONFIG_X86_F00F_BUG
+	case FIX_F00F_IDT:
+#endif
+#ifdef CONFIG_X86_32
+	case FIX_WP_TEST:
+	case FIX_VDSO:
+# ifdef CONFIG_HIGHMEM
+	case FIX_KMAP_BEGIN ... FIX_KMAP_END:
+# endif
+#else
+	case VSYSCALL_LAST_PAGE ... VSYSCALL_FIRST_PAGE:
+#endif
+#ifdef CONFIG_X86_LOCAL_APIC
+	case FIX_APIC_BASE:	/* maps dummy local APIC */
+#endif
+		pte = pfn_pte(phys, prot);
+		break;
+
+	default:
+		pte = mfn_pte(phys, prot);
+		break;
+	}
+
+	__native_set_fixmap(idx, pte);
+
+#ifdef CONFIG_X86_64
+	/* Replicate changes to map the vsyscall page into the user
+	   pagetable vsyscall mapping. */
+	if (idx >= VSYSCALL_LAST_PAGE && idx <= VSYSCALL_FIRST_PAGE) {
+		unsigned long vaddr = __fix_to_virt(idx);
+		set_pte_vaddr_pud(level3_user_vsyscall, vaddr, pte);
+	}
+#endif
+}
+
+__init void xen_post_allocator_init(void)
+{
+	pv_mmu_ops.set_pte = xen_set_pte;
+	pv_mmu_ops.set_pmd = xen_set_pmd;
+	pv_mmu_ops.set_pud = xen_set_pud;
+#if PAGETABLE_LEVELS == 4
+	pv_mmu_ops.set_pgd = xen_set_pgd;
+#endif
+
+	/* This will work as long as patching hasn't happened yet
+	   (which it hasn't) */
+	pv_mmu_ops.alloc_pte = xen_alloc_pte;
+	pv_mmu_ops.alloc_pmd = xen_alloc_pmd;
+	pv_mmu_ops.release_pte = xen_release_pte;
+	pv_mmu_ops.release_pmd = xen_release_pmd;
+#if PAGETABLE_LEVELS == 4
+	pv_mmu_ops.alloc_pud = xen_alloc_pud;
+	pv_mmu_ops.release_pud = xen_release_pud;
+#endif
+
+#ifdef CONFIG_X86_64
+	SetPagePinned(virt_to_page(level3_user_vsyscall));
+#endif
+	xen_mark_init_mm_pinned();
+}
+
+
+const struct pv_mmu_ops xen_mmu_ops __initdata = {
+	.pagetable_setup_start = xen_pagetable_setup_start,
+	.pagetable_setup_done = xen_pagetable_setup_done,
+
+	.read_cr2 = xen_read_cr2,
+	.write_cr2 = xen_write_cr2,
+
+	.read_cr3 = xen_read_cr3,
+	.write_cr3 = xen_write_cr3,
+
+	.flush_tlb_user = xen_flush_tlb,
+	.flush_tlb_kernel = xen_flush_tlb,
+	.flush_tlb_single = xen_flush_tlb_single,
+	.flush_tlb_others = xen_flush_tlb_others,
+
+	.pte_update = paravirt_nop,
+	.pte_update_defer = paravirt_nop,
+
+	.pgd_alloc = xen_pgd_alloc,
+	.pgd_free = xen_pgd_free,
+
+	.alloc_pte = xen_alloc_pte_init,
+	.release_pte = xen_release_pte_init,
+	.alloc_pmd = xen_alloc_pte_init,
+	.alloc_pmd_clone = paravirt_nop,
+	.release_pmd = xen_release_pte_init,
+
+#ifdef CONFIG_HIGHPTE
+	.kmap_atomic_pte = xen_kmap_atomic_pte,
+#endif
+
+#ifdef CONFIG_X86_64
+	.set_pte = xen_set_pte,
+#else
+	.set_pte = xen_set_pte_init,
+#endif
+	.set_pte_at = xen_set_pte_at,
+	.set_pmd = xen_set_pmd_hyper,
+
+	.ptep_modify_prot_start = __ptep_modify_prot_start,
+	.ptep_modify_prot_commit = __ptep_modify_prot_commit,
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
+	.pte_clear = xen_pte_clear,
+	.pmd_clear = xen_pmd_clear,
+#endif	/* CONFIG_X86_PAE */
+	.set_pud = xen_set_pud_hyper,
+
+	.make_pmd = xen_make_pmd,
+	.pmd_val = xen_pmd_val,
+
+#if PAGETABLE_LEVELS == 4
+	.pud_val = xen_pud_val,
+	.make_pud = xen_make_pud,
+	.set_pgd = xen_set_pgd_hyper,
+
+	.alloc_pud = xen_alloc_pte_init,
+	.release_pud = xen_release_pte_init,
+#endif	/* PAGETABLE_LEVELS == 4 */
+
+	.activate_mm = xen_activate_mm,
+	.dup_mmap = xen_dup_mmap,
+	.exit_mmap = xen_exit_mmap,
+
+	.lazy_mode = {
+		.enter = paravirt_enter_lazy_mmu,
+		.leave = xen_leave_lazy,
+	},
+
+	.set_fixmap = xen_set_fixmap,
+};
+
+
 #ifdef CONFIG_XEN_DEBUG_FS
 
 static struct dentry *d_mmu_debug;
diff --git a/arch/x86/xen/mmu.h b/arch/x86/xen/mmu.h
--- a/arch/x86/xen/mmu.h
+++ b/arch/x86/xen/mmu.h
@@ -54,4 +54,7 @@
 void  xen_ptep_modify_prot_commit(struct mm_struct *mm, unsigned long addr,
 				  pte_t *ptep, pte_t pte);
 
+unsigned long xen_read_cr2_direct(void);
+
+extern const struct pv_mmu_ops xen_mmu_ops;
 #endif	/* _XEN_MMU_H */
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -13,6 +13,7 @@
 struct trap_info;
 void xen_copy_trap_info(struct trap_info *traps);
 
+DECLARE_PER_CPU(struct vcpu_info, xen_vcpu_info);
 DECLARE_PER_CPU(unsigned long, xen_cr3);
 DECLARE_PER_CPU(unsigned long, xen_current_cr3);
 
@@ -22,6 +23,13 @@
 
 void xen_setup_mfn_list_list(void);
 void xen_setup_shared_info(void);
+void xen_setup_machphys_mapping(void);
+pgd_t *xen_setup_kernel_pagetable(pgd_t *pgd, unsigned long max_pfn);
+void xen_ident_map_ISA(void);
+void xen_reserve_top(void);
+
+void xen_leave_lazy(void);
+void xen_post_allocator_init(void);
 
 char * __init xen_memory_setup(void);
 void __init xen_arch_setup(void);


