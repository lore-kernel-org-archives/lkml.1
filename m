Return-Path: <linux-kernel-owner+w=401wt.eu-S1753403AbZBQQgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403AbZBQQgt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 11:36:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752088AbZBQQgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 11:36:41 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56798 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752072AbZBQQgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 11:36:40 -0500
Date: Tue, 17 Feb 2009 17:36:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [git pull] x86 fixes
Message-ID: <20090217163618.GA3100@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus


out-of-topic modifications in x86-fixes-for-linus:
--------------------------------------------------
include/linux/mm.h                 # 9f339e7: x86, ptrace, mm: fix double-free 
mm/mlock.c                         # 9f339e7: x86, ptrace, mm: fix double-free 

 Thanks,

	Ingo

------------------>
Chris Ball (1):
      x86, olpc: fix model detection without OFW

Jeremy Fitzhardinge (2):
      x86/cpa: make sure cpa is safe to call in lazy mmu mode
      x86/paravirt: make arch_flush_lazy_mmu/cpu disable preemption

John Stultz (1):
      x86, hpet: fix for LS21 + HPET = boot hang

Markus Metzger (1):
      x86, ptrace, mm: fix double-free on race

Suresh Siddha (1):
      x86, pat: fix warn_on_once() while mapping 0-1MB range with /dev/mem

Thomas Gleixner (3):
      x86: warn if arch_flush_lazy_mmu_cpu is called in preemptible context
      x86: CPA avoid repeated lazy mmu flush
      x86, vm86: fix preemption bug


 arch/x86/include/asm/page.h     |    1 -
 arch/x86/include/asm/paravirt.h |   17 +-------
 arch/x86/kernel/hpet.c          |    2 +
 arch/x86/kernel/olpc.c          |    2 +-
 arch/x86/kernel/paravirt.c      |   26 ++++++++++++
 arch/x86/kernel/ptrace.c        |   16 +++++---
 arch/x86/kernel/traps.c         |   10 ++++-
 arch/x86/mm/ioremap.c           |   19 ---------
 arch/x86/mm/pageattr.c          |   15 +++++++-
 arch/x86/mm/pat.c               |   83 +++++++++++++++++++++------------------
 include/linux/mm.h              |    1 +
 mm/mlock.c                      |    7 +++-
 12 files changed, 116 insertions(+), 83 deletions(-)

diff --git a/arch/x86/include/asm/page.h b/arch/x86/include/asm/page.h
index e9873a2..7765791 100644
--- a/arch/x86/include/asm/page.h
+++ b/arch/x86/include/asm/page.h
@@ -57,7 +57,6 @@ typedef struct { pgdval_t pgd; } pgd_t;
 typedef struct { pgprotval_t pgprot; } pgprot_t;
 
 extern int page_is_ram(unsigned long pagenr);
-extern int pagerange_is_ram(unsigned long start, unsigned long end);
 extern int devmem_is_allowed(unsigned long pagenr);
 extern void map_devmem(unsigned long pfn, unsigned long size,
 		       pgprot_t vma_prot);
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index ba3e2ff..a660ece 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -1352,14 +1352,7 @@ static inline void arch_leave_lazy_cpu_mode(void)
 	PVOP_VCALL0(pv_cpu_ops.lazy_mode.leave);
 }
 
-static inline void arch_flush_lazy_cpu_mode(void)
-{
-	if (unlikely(paravirt_get_lazy_mode() == PARAVIRT_LAZY_CPU)) {
-		arch_leave_lazy_cpu_mode();
-		arch_enter_lazy_cpu_mode();
-	}
-}
-
+void arch_flush_lazy_cpu_mode(void);
 
 #define  __HAVE_ARCH_ENTER_LAZY_MMU_MODE
 static inline void arch_enter_lazy_mmu_mode(void)
@@ -1372,13 +1365,7 @@ static inline void arch_leave_lazy_mmu_mode(void)
 	PVOP_VCALL0(pv_mmu_ops.lazy_mode.leave);
 }
 
-static inline void arch_flush_lazy_mmu_mode(void)
-{
-	if (unlikely(paravirt_get_lazy_mode() == PARAVIRT_LAZY_MMU)) {
-		arch_leave_lazy_mmu_mode();
-		arch_enter_lazy_mmu_mode();
-	}
-}
+void arch_flush_lazy_mmu_mode(void);
 
 static inline void __set_fixmap(unsigned /* enum fixed_addresses */ idx,
 				unsigned long phys, pgprot_t flags)
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 64d5ad0..5c8da2c 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -269,6 +269,8 @@ static void hpet_set_mode(enum clock_event_mode mode,
 		now = hpet_readl(HPET_COUNTER);
 		cmp = now + (unsigned long) delta;
 		cfg = hpet_readl(HPET_Tn_CFG(timer));
+		/* Make sure we use edge triggered interrupts */
+		cfg &= ~HPET_TN_LEVEL;
 		cfg |= HPET_TN_ENABLE | HPET_TN_PERIODIC |
 		       HPET_TN_SETVAL | HPET_TN_32BIT;
 		hpet_writel(cfg, HPET_Tn_CFG(timer));
diff --git a/arch/x86/kernel/olpc.c b/arch/x86/kernel/olpc.c
index 7a13fac..4006c52 100644
--- a/arch/x86/kernel/olpc.c
+++ b/arch/x86/kernel/olpc.c
@@ -203,7 +203,7 @@ static void __init platform_detect(void)
 static void __init platform_detect(void)
 {
 	/* stopgap until OFW support is added to the kernel */
-	olpc_platform_info.boardrev = 0xc2;
+	olpc_platform_info.boardrev = olpc_board(0xc2);
 }
 #endif
 
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index e4c8fb6..c6520a4 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -268,6 +268,32 @@ enum paravirt_lazy_mode paravirt_get_lazy_mode(void)
 	return __get_cpu_var(paravirt_lazy_mode);
 }
 
+void arch_flush_lazy_mmu_mode(void)
+{
+	preempt_disable();
+
+	if (paravirt_get_lazy_mode() == PARAVIRT_LAZY_MMU) {
+		WARN_ON(preempt_count() == 1);
+		arch_leave_lazy_mmu_mode();
+		arch_enter_lazy_mmu_mode();
+	}
+
+	preempt_enable();
+}
+
+void arch_flush_lazy_cpu_mode(void)
+{
+	preempt_disable();
+
+	if (paravirt_get_lazy_mode() == PARAVIRT_LAZY_CPU) {
+		WARN_ON(preempt_count() == 1);
+		arch_leave_lazy_cpu_mode();
+		arch_enter_lazy_cpu_mode();
+	}
+
+	preempt_enable();
+}
+
 struct pv_info pv_info = {
 	.name = "bare hardware",
 	.paravirt_enabled = 0,
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 0a5df5f..5a4c23d 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -810,12 +810,16 @@ static void ptrace_bts_untrace(struct task_struct *child)
 
 static void ptrace_bts_detach(struct task_struct *child)
 {
-	if (unlikely(child->bts)) {
-		ds_release_bts(child->bts);
-		child->bts = NULL;
-
-		ptrace_bts_free_buffer(child);
-	}
+	/*
+	 * Ptrace_detach() races with ptrace_untrace() in case
+	 * the child dies and is reaped by another thread.
+	 *
+	 * We only do the memory accounting at this point and
+	 * leave the buffer deallocation and the bts tracer
+	 * release to ptrace_bts_untrace() which will be called
+	 * later on with tasklist_lock held.
+	 */
+	release_locked_buffer(child->bts_buffer, child->bts_size);
 }
 #else
 static inline void ptrace_bts_fork(struct task_struct *tsk) {}
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 7932338..a9e7548 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -99,6 +99,12 @@ static inline void preempt_conditional_sti(struct pt_regs *regs)
 		local_irq_enable();
 }
 
+static inline void conditional_cli(struct pt_regs *regs)
+{
+	if (regs->flags & X86_EFLAGS_IF)
+		local_irq_disable();
+}
+
 static inline void preempt_conditional_cli(struct pt_regs *regs)
 {
 	if (regs->flags & X86_EFLAGS_IF)
@@ -626,8 +632,10 @@ clear_dr7:
 
 #ifdef CONFIG_X86_32
 debug_vm86:
+	/* reenable preemption: handle_vm86_trap() might sleep */
+	dec_preempt_count();
 	handle_vm86_trap((struct kernel_vm86_regs *) regs, error_code, 1);
-	preempt_conditional_cli(regs);
+	conditional_cli(regs);
 	return;
 #endif
 
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index af750ab..f45d5e2 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -134,25 +134,6 @@ int page_is_ram(unsigned long pagenr)
 	return 0;
 }
 
-int pagerange_is_ram(unsigned long start, unsigned long end)
-{
-	int ram_page = 0, not_rampage = 0;
-	unsigned long page_nr;
-
-	for (page_nr = (start >> PAGE_SHIFT); page_nr < (end >> PAGE_SHIFT);
-	     ++page_nr) {
-		if (page_is_ram(page_nr))
-			ram_page = 1;
-		else
-			not_rampage = 1;
-
-		if (ram_page == not_rampage)
-			return -1;
-	}
-
-	return ram_page;
-}
-
 /*
  * Fix up the linear direct mapping of the kernel to avoid cache attribute
  * conflicts.
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 84ba748..8ca0d85 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -575,7 +575,6 @@ static int __change_page_attr(struct cpa_data *cpa, int primary)
 		address = cpa->vaddr[cpa->curpage];
 	else
 		address = *cpa->vaddr;
-
 repeat:
 	kpte = lookup_address(address, &level);
 	if (!kpte)
@@ -812,6 +811,13 @@ static int change_page_attr_set_clr(unsigned long *addr, int numpages,
 
 	vm_unmap_aliases();
 
+	/*
+	 * If we're called with lazy mmu updates enabled, the
+	 * in-memory pte state may be stale.  Flush pending updates to
+	 * bring them up to date.
+	 */
+	arch_flush_lazy_mmu_mode();
+
 	cpa.vaddr = addr;
 	cpa.numpages = numpages;
 	cpa.mask_set = mask_set;
@@ -854,6 +860,13 @@ static int change_page_attr_set_clr(unsigned long *addr, int numpages,
 	} else
 		cpa_flush_all(cache);
 
+	/*
+	 * If we've been called with lazy mmu updates enabled, then
+	 * make sure that everything gets flushed out before we
+	 * return.
+	 */
+	arch_flush_lazy_mmu_mode();
+
 out:
 	return ret;
 }
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 7b61036..aebbf67 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -211,6 +211,33 @@ chk_conflict(struct memtype *new, struct memtype *entry, unsigned long *type)
 static struct memtype *cached_entry;
 static u64 cached_start;
 
+static int pat_pagerange_is_ram(unsigned long start, unsigned long end)
+{
+	int ram_page = 0, not_rampage = 0;
+	unsigned long page_nr;
+
+	for (page_nr = (start >> PAGE_SHIFT); page_nr < (end >> PAGE_SHIFT);
+	     ++page_nr) {
+		/*
+		 * For legacy reasons, physical address range in the legacy ISA
+		 * region is tracked as non-RAM. This will allow users of
+		 * /dev/mem to map portions of legacy ISA region, even when
+		 * some of those portions are listed(or not even listed) with
+		 * different e820 types(RAM/reserved/..)
+		 */
+		if (page_nr >= (ISA_END_ADDRESS >> PAGE_SHIFT) &&
+		    page_is_ram(page_nr))
+			ram_page = 1;
+		else
+			not_rampage = 1;
+
+		if (ram_page == not_rampage)
+			return -1;
+	}
+
+	return ram_page;
+}
+
 /*
  * For RAM pages, mark the pages as non WB memory type using
  * PageNonWB (PG_arch_1). We allow only one set_memory_uc() or
@@ -336,20 +363,12 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 	if (new_type)
 		*new_type = actual_type;
 
-	/*
-	 * For legacy reasons, some parts of the physical address range in the
-	 * legacy 1MB region is treated as non-RAM (even when listed as RAM in
-	 * the e820 tables).  So we will track the memory attributes of this
-	 * legacy 1MB region using the linear memtype_list always.
-	 */
-	if (end >= ISA_END_ADDRESS) {
-		is_range_ram = pagerange_is_ram(start, end);
-		if (is_range_ram == 1)
-			return reserve_ram_pages_type(start, end, req_type,
-						      new_type);
-		else if (is_range_ram < 0)
-			return -EINVAL;
-	}
+	is_range_ram = pat_pagerange_is_ram(start, end);
+	if (is_range_ram == 1)
+		return reserve_ram_pages_type(start, end, req_type,
+					      new_type);
+	else if (is_range_ram < 0)
+		return -EINVAL;
 
 	new  = kmalloc(sizeof(struct memtype), GFP_KERNEL);
 	if (!new)
@@ -446,19 +465,11 @@ int free_memtype(u64 start, u64 end)
 	if (is_ISA_range(start, end - 1))
 		return 0;
 
-	/*
-	 * For legacy reasons, some parts of the physical address range in the
-	 * legacy 1MB region is treated as non-RAM (even when listed as RAM in
-	 * the e820 tables).  So we will track the memory attributes of this
-	 * legacy 1MB region using the linear memtype_list always.
-	 */
-	if (end >= ISA_END_ADDRESS) {
-		is_range_ram = pagerange_is_ram(start, end);
-		if (is_range_ram == 1)
-			return free_ram_pages_type(start, end);
-		else if (is_range_ram < 0)
-			return -EINVAL;
-	}
+	is_range_ram = pat_pagerange_is_ram(start, end);
+	if (is_range_ram == 1)
+		return free_ram_pages_type(start, end);
+	else if (is_range_ram < 0)
+		return -EINVAL;
 
 	spin_lock(&memtype_lock);
 	list_for_each_entry(entry, &memtype_list, nd) {
@@ -626,17 +637,13 @@ static int reserve_pfn_range(u64 paddr, unsigned long size, pgprot_t *vma_prot,
 	unsigned long flags;
 	unsigned long want_flags = (pgprot_val(*vma_prot) & _PAGE_CACHE_MASK);
 
-	is_ram = pagerange_is_ram(paddr, paddr + size);
+	is_ram = pat_pagerange_is_ram(paddr, paddr + size);
 
-	if (is_ram != 0) {
-		/*
-		 * For mapping RAM pages, drivers need to call
-		 * set_memory_[uc|wc|wb] directly, for reserve and free, before
-		 * setting up the PTE.
-		 */
-		WARN_ON_ONCE(1);
-		return 0;
-	}
+	/*
+	 * reserve_pfn_range() doesn't support RAM pages.
+	 */
+	if (is_ram != 0)
+		return -EINVAL;
 
 	ret = reserve_memtype(paddr, paddr + size, want_flags, &flags);
 	if (ret)
@@ -693,7 +700,7 @@ static void free_pfn_range(u64 paddr, unsigned long size)
 {
 	int is_ram;
 
-	is_ram = pagerange_is_ram(paddr, paddr + size);
+	is_ram = pat_pagerange_is_ram(paddr, paddr + size);
 	if (is_ram == 0)
 		free_memtype(paddr, paddr + size);
 }
diff --git a/include/linux/mm.h b/include/linux/mm.h
index e8ddc98..3d7fb44 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1305,5 +1305,6 @@ void vmemmap_populate_print_last(void);
 
 extern void *alloc_locked_buffer(size_t size);
 extern void free_locked_buffer(void *buffer, size_t size);
+extern void release_locked_buffer(void *buffer, size_t size);
 #endif /* __KERNEL__ */
 #endif /* _LINUX_MM_H */
diff --git a/mm/mlock.c b/mm/mlock.c
index 028ec48..2b57f7e 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -657,7 +657,7 @@ void *alloc_locked_buffer(size_t size)
 	return buffer;
 }
 
-void free_locked_buffer(void *buffer, size_t size)
+void release_locked_buffer(void *buffer, size_t size)
 {
 	unsigned long pgsz = PAGE_ALIGN(size) >> PAGE_SHIFT;
 
@@ -667,6 +667,11 @@ void free_locked_buffer(void *buffer, size_t size)
 	current->mm->locked_vm -= pgsz;
 
 	up_write(&current->mm->mmap_sem);
+}
+
+void free_locked_buffer(void *buffer, size_t size)
+{
+	release_locked_buffer(buffer, size);
 
 	kfree(buffer);
 }
