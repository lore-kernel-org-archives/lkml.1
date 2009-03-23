Return-Path: <linux-kernel-owner+w=401wt.eu-S1757471AbZCWRjC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471AbZCWRjC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 13:39:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755049AbZCWRiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 13:38:50 -0400
Received: from gw.goop.org ([64.81.55.164]:43081 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573AbZCWRis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 13:38:48 -0400
Message-ID: <49C7C916.2080806@goop.org>
Date: Mon, 23 Mar 2009 10:38:30 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Alok Kataria <akataria@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Marcelo Tosatti <mtosatti@redhat.com>
Subject: [GIT PULL] x86/paravirt: allow preemption while doing lazy mmu update
References: <49C28AC2.4010407@goop.org> <49C29381.9050201@zytor.com> <49C29983.3040305@goop.org> <49C2ABCA.6010009@zytor.com> <49C43D31.7040805@goop.org> <49C45238.7050007@zytor.com>
In-Reply-To: <49C45238.7050007@zytor.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series allows preemption during lazy mmu updates.

No changes from previous postings, just rebased to a newer tip/master.

The following changes since commit 8c85122f33c5242e2f384b1f9f202f28e6bf4e61:
  Ingo Molnar (1):
        Merge branch 'core/locking'

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git push2/x86/paravirt

Jeremy Fitzhardinge (8):
      mm: disable preemption in apply_to_pte_range
      x86/paravirt: remove lazy mode in interrupts
      x86/pvops: replace arch_enter_lazy_cpu_mode with arch_start_context_switch
      x86/paravirt: flush pending mmu updates on context switch
      x86/paravirt: finish change from lazy cpu to context switch start/end
      x86/paravirt: allow preemption with lazy mmu mode
      mm: allow preemption in apply_to_pte_range
      x86/paravirt: use percpu_ rather than __get_cpu_var

 arch/x86/include/asm/paravirt.h    |   22 +++++++-------
 arch/x86/include/asm/pgtable.h     |    2 +
 arch/x86/include/asm/thread_info.h |    2 +
 arch/x86/kernel/kvm.c              |    2 +-
 arch/x86/kernel/paravirt.c         |   56 ++++++++++++++++-------------------
 arch/x86/kernel/process_32.c       |    2 +-
 arch/x86/kernel/process_64.c       |    2 +-
 arch/x86/kernel/vmi_32.c           |   20 ++++++++----
 arch/x86/lguest/boot.c             |   16 +++++++---
 arch/x86/mm/fault.c                |    6 +--
 arch/x86/mm/highmem_32.c           |    2 -
 arch/x86/mm/iomap_32.c             |    2 -
 arch/x86/mm/pageattr.c             |   14 ---------
 arch/x86/xen/enlighten.c           |   10 ++----
 arch/x86/xen/mmu.c                 |   20 +++++--------
 arch/x86/xen/xen-ops.h             |    1 -
 include/asm-frv/pgtable.h          |    4 +-
 include/asm-generic/pgtable.h      |   21 +++++++------
 kernel/sched.c                     |    2 +-
 19 files changed, 96 insertions(+), 110 deletions(-)

Overall diff:

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 7727aa8..bc384be 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -56,6 +56,7 @@ struct desc_ptr;
 struct tss_struct;
 struct mm_struct;
 struct desc_struct;
+struct task_struct;
 
 /*
  * Wrapper type for pointers to code which uses the non-standard
@@ -203,7 +204,8 @@ struct pv_cpu_ops {
 
 	void (*swapgs)(void);
 
-	struct pv_lazy_ops lazy_mode;
+	void (*start_context_switch)(struct task_struct *prev);
+	void (*end_context_switch)(struct task_struct *next);
 };
 
 struct pv_irq_ops {
@@ -1399,25 +1401,23 @@ enum paravirt_lazy_mode {
 };
 
 enum paravirt_lazy_mode paravirt_get_lazy_mode(void);
-void paravirt_enter_lazy_cpu(void);
-void paravirt_leave_lazy_cpu(void);
+void paravirt_start_context_switch(struct task_struct *prev);
+void paravirt_end_context_switch(struct task_struct *next);
+
 void paravirt_enter_lazy_mmu(void);
 void paravirt_leave_lazy_mmu(void);
-void paravirt_leave_lazy(enum paravirt_lazy_mode mode);
 
-#define  __HAVE_ARCH_ENTER_LAZY_CPU_MODE
-static inline void arch_enter_lazy_cpu_mode(void)
+#define  __HAVE_ARCH_START_CONTEXT_SWITCH
+static inline void arch_start_context_switch(struct task_struct *prev)
 {
-	PVOP_VCALL0(pv_cpu_ops.lazy_mode.enter);
+	PVOP_VCALL1(pv_cpu_ops.start_context_switch, prev);
 }
 
-static inline void arch_leave_lazy_cpu_mode(void)
+static inline void arch_end_context_switch(struct task_struct *next)
 {
-	PVOP_VCALL0(pv_cpu_ops.lazy_mode.leave);
+	PVOP_VCALL1(pv_cpu_ops.end_context_switch, next);
 }
 
-void arch_flush_lazy_cpu_mode(void);
-
 #define  __HAVE_ARCH_ENTER_LAZY_MMU_MODE
 static inline void arch_enter_lazy_mmu_mode(void)
 {
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index f5ba6c1..205f6a9 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -81,6 +81,8 @@ static inline void __init paravirt_pagetable_setup_done(pgd_t *base)
 #define pte_val(x)	native_pte_val(x)
 #define __pte(x)	native_make_pte(x)
 
+#define arch_end_context_switch(prev)	do {} while(0)
+
 #endif	/* CONFIG_PARAVIRT */
 
 /*
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index 83d2b73..e6b4beb 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -96,6 +96,7 @@ struct thread_info {
 #define TIF_DEBUGCTLMSR		25	/* uses thread_struct.debugctlmsr */
 #define TIF_DS_AREA_MSR		26      /* uses thread_struct.ds_area_msr */
 #define TIF_SYSCALL_FTRACE	27	/* for ftrace syscall instrumentation */
+#define TIF_LAZY_MMU_UPDATES	28	/* task is updating the mmu lazily */
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
@@ -119,6 +120,7 @@ struct thread_info {
 #define _TIF_DEBUGCTLMSR	(1 << TIF_DEBUGCTLMSR)
 #define _TIF_DS_AREA_MSR	(1 << TIF_DS_AREA_MSR)
 #define _TIF_SYSCALL_FTRACE	(1 << TIF_SYSCALL_FTRACE)
+#define _TIF_LAZY_MMU_UPDATES	(1 << TIF_LAZY_MMU_UPDATES)
 
 /* work to do in syscall_trace_enter() */
 #define _TIF_WORK_SYSCALL_ENTRY	\
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 33019dd..6551ded 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -195,7 +195,7 @@ static void kvm_leave_lazy_mmu(void)
 	struct kvm_para_state *state = kvm_para_state();
 
 	mmu_queue_flush(state);
-	paravirt_leave_lazy(paravirt_get_lazy_mode());
+	paravirt_leave_lazy_mmu();
 	state->mode = paravirt_get_lazy_mode();
 }
 
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 8e45f44..aa34423 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -246,18 +246,16 @@ static DEFINE_PER_CPU(enum paravirt_lazy_mode, paravirt_lazy_mode) = PARAVIRT_LA
 
 static inline void enter_lazy(enum paravirt_lazy_mode mode)
 {
-	BUG_ON(__get_cpu_var(paravirt_lazy_mode) != PARAVIRT_LAZY_NONE);
-	BUG_ON(preemptible());
+	BUG_ON(percpu_read(paravirt_lazy_mode) != PARAVIRT_LAZY_NONE);
 
-	__get_cpu_var(paravirt_lazy_mode) = mode;
+	percpu_write(paravirt_lazy_mode, mode);
 }
 
-void paravirt_leave_lazy(enum paravirt_lazy_mode mode)
+static void leave_lazy(enum paravirt_lazy_mode mode)
 {
-	BUG_ON(__get_cpu_var(paravirt_lazy_mode) != mode);
-	BUG_ON(preemptible());
+	BUG_ON(percpu_read(paravirt_lazy_mode) != mode);
 
-	__get_cpu_var(paravirt_lazy_mode) = PARAVIRT_LAZY_NONE;
+	percpu_write(paravirt_lazy_mode, PARAVIRT_LAZY_NONE);
 }
 
 void paravirt_enter_lazy_mmu(void)
@@ -267,22 +265,36 @@ void paravirt_enter_lazy_mmu(void)
 
 void paravirt_leave_lazy_mmu(void)
 {
-	paravirt_leave_lazy(PARAVIRT_LAZY_MMU);
+	leave_lazy(PARAVIRT_LAZY_MMU);
 }
 
-void paravirt_enter_lazy_cpu(void)
+void paravirt_start_context_switch(struct task_struct *prev)
 {
+	BUG_ON(preemptible());
+
+	if (percpu_read(paravirt_lazy_mode) == PARAVIRT_LAZY_MMU) {
+		arch_leave_lazy_mmu_mode();
+		set_ti_thread_flag(task_thread_info(prev), TIF_LAZY_MMU_UPDATES);
+	}
 	enter_lazy(PARAVIRT_LAZY_CPU);
 }
 
-void paravirt_leave_lazy_cpu(void)
+void paravirt_end_context_switch(struct task_struct *next)
 {
-	paravirt_leave_lazy(PARAVIRT_LAZY_CPU);
+	BUG_ON(preemptible());
+
+	leave_lazy(PARAVIRT_LAZY_CPU);
+
+	if (test_and_clear_ti_thread_flag(task_thread_info(next), TIF_LAZY_MMU_UPDATES))
+		arch_enter_lazy_mmu_mode();
 }
 
 enum paravirt_lazy_mode paravirt_get_lazy_mode(void)
 {
-	return __get_cpu_var(paravirt_lazy_mode);
+	if (in_interrupt())
+		return PARAVIRT_LAZY_NONE;
+
+	return percpu_read(paravirt_lazy_mode);
 }
 
 void arch_flush_lazy_mmu_mode(void)
@@ -290,7 +302,6 @@ void arch_flush_lazy_mmu_mode(void)
 	preempt_disable();
 
 	if (paravirt_get_lazy_mode() == PARAVIRT_LAZY_MMU) {
-		WARN_ON(preempt_count() == 1);
 		arch_leave_lazy_mmu_mode();
 		arch_enter_lazy_mmu_mode();
 	}
@@ -298,19 +309,6 @@ void arch_flush_lazy_mmu_mode(void)
 	preempt_enable();
 }
 
-void arch_flush_lazy_cpu_mode(void)
-{
-	preempt_disable();
-
-	if (paravirt_get_lazy_mode() == PARAVIRT_LAZY_CPU) {
-		WARN_ON(preempt_count() == 1);
-		arch_leave_lazy_cpu_mode();
-		arch_enter_lazy_cpu_mode();
-	}
-
-	preempt_enable();
-}
-
 struct pv_info pv_info = {
 	.name = "bare hardware",
 	.paravirt_enabled = 0,
@@ -402,10 +400,8 @@ struct pv_cpu_ops pv_cpu_ops = {
 	.set_iopl_mask = native_set_iopl_mask,
 	.io_delay = native_io_delay,
 
-	.lazy_mode = {
-		.enter = paravirt_nop,
-		.leave = paravirt_nop,
-	},
+	.start_context_switch = paravirt_nop,
+	.end_context_switch = paravirt_nop,
 };
 
 struct pv_apic_ops pv_apic_ops = {
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 14014d7..d766c76 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -407,7 +407,7 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	 * done before math_state_restore, so the TS bit is up
 	 * to date.
 	 */
-	arch_leave_lazy_cpu_mode();
+	arch_end_context_switch(next_p);
 
 	/* If the task has used fpu the last 5 timeslices, just do a full
 	 * restore of the math state immediately to avoid the trap; the
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index abb7e6a..e8a9aaf 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -428,7 +428,7 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	 * done before math_state_restore, so the TS bit is up
 	 * to date.
 	 */
-	arch_leave_lazy_cpu_mode();
+	arch_end_context_switch(next_p);
 
 	/*
 	 * Switch FS and GS.
diff --git a/arch/x86/kernel/vmi_32.c b/arch/x86/kernel/vmi_32.c
index 95deb9f..b263423 100644
--- a/arch/x86/kernel/vmi_32.c
+++ b/arch/x86/kernel/vmi_32.c
@@ -462,22 +462,28 @@ vmi_startup_ipi_hook(int phys_apicid, unsigned long start_eip,
 }
 #endif
 
-static void vmi_enter_lazy_cpu(void)
+static void vmi_start_context_switch(struct task_struct *prev)
 {
-	paravirt_enter_lazy_cpu();
+	paravirt_start_context_switch(prev);
 	vmi_ops.set_lazy_mode(2);
 }
 
+static void vmi_end_context_switch(struct task_struct *next)
+{
+	vmi_ops.set_lazy_mode(0);
+	paravirt_end_context_switch(next);
+}
+
 static void vmi_enter_lazy_mmu(void)
 {
 	paravirt_enter_lazy_mmu();
 	vmi_ops.set_lazy_mode(1);
 }
 
-static void vmi_leave_lazy(void)
+static void vmi_leave_lazy_mmu(void)
 {
-	paravirt_leave_lazy(paravirt_get_lazy_mode());
 	vmi_ops.set_lazy_mode(0);
+	paravirt_leave_lazy_mmu();
 }
 
 static inline int __init check_vmi_rom(struct vrom_header *rom)
@@ -711,14 +717,14 @@ static inline int __init activate_vmi(void)
 	para_fill(pv_cpu_ops.set_iopl_mask, SetIOPLMask);
 	para_fill(pv_cpu_ops.io_delay, IODelay);
 
-	para_wrap(pv_cpu_ops.lazy_mode.enter, vmi_enter_lazy_cpu,
+	para_wrap(pv_cpu_ops.start_context_switch, vmi_start_context_switch,
 		  set_lazy_mode, SetLazyMode);
-	para_wrap(pv_cpu_ops.lazy_mode.leave, vmi_leave_lazy,
+	para_wrap(pv_cpu_ops.end_context_switch, vmi_end_context_switch,
 		  set_lazy_mode, SetLazyMode);
 
 	para_wrap(pv_mmu_ops.lazy_mode.enter, vmi_enter_lazy_mmu,
 		  set_lazy_mode, SetLazyMode);
-	para_wrap(pv_mmu_ops.lazy_mode.leave, vmi_leave_lazy,
+	para_wrap(pv_mmu_ops.lazy_mode.leave, vmi_leave_lazy_mmu,
 		  set_lazy_mode, SetLazyMode);
 
 	/* user and kernel flush are just handled with different flags to FlushTLB */
diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
index 90e44a1..25799f3 100644
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -147,10 +147,16 @@ static void lazy_hcall(unsigned long call,
 
 /* When lazy mode is turned off reset the per-cpu lazy mode variable and then
  * issue the do-nothing hypercall to flush any stored calls. */
-static void lguest_leave_lazy_mode(void)
+static void lguest_leave_lazy_mmu_mode(void)
 {
-	paravirt_leave_lazy(paravirt_get_lazy_mode());
 	hcall(LHCALL_FLUSH_ASYNC, 0, 0, 0);
+	paravirt_leave_lazy_mmu();
+}
+
+static void lguest_end_context_switch(struct task_struct *next)
+{
+	hcall(LHCALL_FLUSH_ASYNC, 0, 0, 0);
+	paravirt_end_context_switch(next);
 }
 
 /*G:033
@@ -1025,8 +1031,8 @@ __init void lguest_init(void)
 	pv_cpu_ops.write_gdt_entry = lguest_write_gdt_entry;
 	pv_cpu_ops.write_idt_entry = lguest_write_idt_entry;
 	pv_cpu_ops.wbinvd = lguest_wbinvd;
-	pv_cpu_ops.lazy_mode.enter = paravirt_enter_lazy_cpu;
-	pv_cpu_ops.lazy_mode.leave = lguest_leave_lazy_mode;
+	pv_cpu_ops.start_context_switch = paravirt_start_context_switch;
+	pv_cpu_ops.end_context_switch = lguest_end_context_switch;
 
 	/* pagetable management */
 	pv_mmu_ops.write_cr3 = lguest_write_cr3;
@@ -1039,7 +1045,7 @@ __init void lguest_init(void)
 	pv_mmu_ops.read_cr2 = lguest_read_cr2;
 	pv_mmu_ops.read_cr3 = lguest_read_cr3;
 	pv_mmu_ops.lazy_mode.enter = paravirt_enter_lazy_mmu;
-	pv_mmu_ops.lazy_mode.leave = lguest_leave_lazy_mode;
+	pv_mmu_ops.lazy_mode.leave = lguest_leave_lazy_mmu_mode;
 
 #ifdef CONFIG_X86_LOCAL_APIC
 	/* apic read/write intercepts */
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index f70b901..09e6ae4 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -227,12 +227,10 @@ static inline pmd_t *vmalloc_sync_one(pgd_t *pgd, unsigned long address)
 	if (!pmd_present(*pmd_k))
 		return NULL;
 
-	if (!pmd_present(*pmd)) {
+	if (!pmd_present(*pmd))
 		set_pmd(pmd, *pmd_k);
-		arch_flush_lazy_mmu_mode();
-	} else {
+	else
 		BUG_ON(pmd_page(*pmd) != pmd_page(*pmd_k));
-	}
 
 	return pmd_k;
 }
diff --git a/arch/x86/mm/highmem_32.c b/arch/x86/mm/highmem_32.c
index 522db5e..17d0103 100644
--- a/arch/x86/mm/highmem_32.c
+++ b/arch/x86/mm/highmem_32.c
@@ -87,7 +87,6 @@ void *kmap_atomic_prot(struct page *page, enum km_type type, pgprot_t prot)
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 	BUG_ON(!pte_none(*(kmap_pte-idx)));
 	set_pte(kmap_pte-idx, mk_pte(page, prot));
-	arch_flush_lazy_mmu_mode();
 
 	return (void *)vaddr;
 }
@@ -117,7 +116,6 @@ void kunmap_atomic(void *kvaddr, enum km_type type)
 #endif
 	}
 
-	arch_flush_lazy_mmu_mode();
 	pagefault_enable();
 }
 
diff --git a/arch/x86/mm/iomap_32.c b/arch/x86/mm/iomap_32.c
index 699c9b2..0c16a33 100644
--- a/arch/x86/mm/iomap_32.c
+++ b/arch/x86/mm/iomap_32.c
@@ -41,7 +41,6 @@ void *kmap_atomic_prot_pfn(unsigned long pfn, enum km_type type, pgprot_t prot)
 	idx = type + KM_TYPE_NR * smp_processor_id();
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 	set_pte(kmap_pte - idx, pfn_pte(pfn, prot));
-	arch_flush_lazy_mmu_mode();
 
 	return (void *)vaddr;
 }
@@ -80,7 +79,6 @@ iounmap_atomic(void *kvaddr, enum km_type type)
 	if (vaddr == __fix_to_virt(FIX_KMAP_BEGIN+idx))
 		kpte_clear_flush(kmap_pte-idx, vaddr);
 
-	arch_flush_lazy_mmu_mode();
 	pagefault_enable();
 }
 EXPORT_SYMBOL_GPL(iounmap_atomic);
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index b0e5adb..1224865 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -844,13 +844,6 @@ static int change_page_attr_set_clr(unsigned long *addr, int numpages,
 
 	vm_unmap_aliases();
 
-	/*
-	 * If we're called with lazy mmu updates enabled, the
-	 * in-memory pte state may be stale.  Flush pending updates to
-	 * bring them up to date.
-	 */
-	arch_flush_lazy_mmu_mode();
-
 	cpa.vaddr = addr;
 	cpa.pages = pages;
 	cpa.numpages = numpages;
@@ -895,13 +888,6 @@ static int change_page_attr_set_clr(unsigned long *addr, int numpages,
 	} else
 		cpa_flush_all(cache);
 
-	/*
-	 * If we've been called with lazy mmu updates enabled, then
-	 * make sure that everything gets flushed out before we
-	 * return.
-	 */
-	arch_flush_lazy_mmu_mode();
-
 out:
 	return ret;
 }
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 82cd39a..70b355d 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -203,10 +203,10 @@ static unsigned long xen_get_debugreg(int reg)
 	return HYPERVISOR_get_debugreg(reg);
 }
 
-void xen_leave_lazy(void)
+static void xen_end_context_switch(struct task_struct *next)
 {
-	paravirt_leave_lazy(paravirt_get_lazy_mode());
 	xen_mc_flush();
+	paravirt_end_context_switch(next);
 }
 
 static unsigned long xen_store_tr(void)
@@ -817,10 +817,8 @@ static const struct pv_cpu_ops xen_cpu_ops __initdata = {
 	/* Xen takes care of %gs when switching to usermode for us */
 	.swapgs = paravirt_nop,
 
-	.lazy_mode = {
-		.enter = paravirt_enter_lazy_cpu,
-		.leave = xen_leave_lazy,
-	},
+	.start_context_switch = paravirt_start_context_switch,
+	.end_context_switch = xen_end_context_switch,
 };
 
 static const struct pv_apic_ops xen_apic_ops __initdata = {
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index db3802f..e194f72 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -419,10 +419,6 @@ void set_pte_mfn(unsigned long vaddr, unsigned long mfn, pgprot_t flags)
 void xen_set_pte_at(struct mm_struct *mm, unsigned long addr,
 		    pte_t *ptep, pte_t pteval)
 {
-	/* updates to init_mm may be done without lock */
-	if (mm == &init_mm)
-		preempt_disable();
-
 	ADD_STATS(set_pte_at, 1);
 //	ADD_STATS(set_pte_at_pinned, xen_page_pinned(ptep));
 	ADD_STATS(set_pte_at_current, mm == current->mm);
@@ -443,9 +439,7 @@ void xen_set_pte_at(struct mm_struct *mm, unsigned long addr,
 	}
 	xen_set_pte(ptep, pteval);
 
-out:
-	if (mm == &init_mm)
-		preempt_enable();
+out:	return;
 }
 
 pte_t xen_ptep_modify_prot_start(struct mm_struct *mm,
@@ -1119,10 +1113,8 @@ static void drop_other_mm_ref(void *info)
 
 	/* If this cpu still has a stale cr3 reference, then make sure
 	   it has been flushed. */
-	if (percpu_read(xen_current_cr3) == __pa(mm->pgd)) {
+	if (percpu_read(xen_current_cr3) == __pa(mm->pgd))
 		load_cr3(swapper_pg_dir);
-		arch_flush_lazy_cpu_mode();
-	}
 }
 
 static void xen_drop_mm_ref(struct mm_struct *mm)
@@ -1135,7 +1127,6 @@ static void xen_drop_mm_ref(struct mm_struct *mm)
 			load_cr3(swapper_pg_dir);
 		else
 			leave_mm(smp_processor_id());
-		arch_flush_lazy_cpu_mode();
 	}
 
 	/* Get the "official" set of cpus referring to our pagetable. */
@@ -1819,6 +1810,11 @@ __init void xen_post_allocator_init(void)
 	xen_mark_init_mm_pinned();
 }
 
+static void xen_leave_lazy_mmu(void)
+{
+	xen_mc_flush();
+	paravirt_leave_lazy_mmu();
+}
 
 const struct pv_mmu_ops xen_mmu_ops __initdata = {
 	.pagetable_setup_start = xen_pagetable_setup_start,
@@ -1893,7 +1889,7 @@ const struct pv_mmu_ops xen_mmu_ops __initdata = {
 
 	.lazy_mode = {
 		.enter = paravirt_enter_lazy_mmu,
-		.leave = xen_leave_lazy,
+		.leave = xen_leave_lazy_mmu,
 	},
 
 	.set_fixmap = xen_set_fixmap,
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index 2f5ef26..f897cdf 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -30,7 +30,6 @@ pgd_t *xen_setup_kernel_pagetable(pgd_t *pgd, unsigned long max_pfn);
 void xen_ident_map_ISA(void);
 void xen_reserve_top(void);
 
-void xen_leave_lazy(void);
 void xen_post_allocator_init(void);
 
 char * __init xen_memory_setup(void);
diff --git a/include/asm-frv/pgtable.h b/include/asm-frv/pgtable.h
index e16fdb1..0988704 100644
--- a/include/asm-frv/pgtable.h
+++ b/include/asm-frv/pgtable.h
@@ -73,8 +73,8 @@ static inline int pte_file(pte_t pte) { return 0; }
 #define pgtable_cache_init()		do {} while (0)
 #define arch_enter_lazy_mmu_mode()	do {} while (0)
 #define arch_leave_lazy_mmu_mode()	do {} while (0)
-#define arch_enter_lazy_cpu_mode()	do {} while (0)
-#define arch_leave_lazy_cpu_mode()	do {} while (0)
+
+#define arch_start_context_switch(prev)	do {} while (0)
 
 #else /* !CONFIG_MMU */
 /*****************************************************************************/
diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
index 8e6d0ca..e410f60 100644
--- a/include/asm-generic/pgtable.h
+++ b/include/asm-generic/pgtable.h
@@ -280,17 +280,18 @@ static inline void ptep_modify_prot_commit(struct mm_struct *mm,
 #endif
 
 /*
- * A facility to provide batching of the reload of page tables with the
- * actual context switch code for paravirtualized guests.  By convention,
- * only one of the lazy modes (CPU, MMU) should be active at any given
- * time, entry should never be nested, and entry and exits should always
- * be paired.  This is for sanity of maintaining and reasoning about the
- * kernel code.
+ * A facility to provide batching of the reload of page tables and
+ * other process state with the actual context switch code for
+ * paravirtualized guests.  By convention, only one of the batched
+ * update (lazy) modes (CPU, MMU) should be active at any given time,
+ * entry should never be nested, and entry and exits should always be
+ * paired.  This is for sanity of maintaining and reasoning about the
+ * kernel code.  In this case, the exit (end of the context switch) is
+ * in architecture-specific code, and so doesn't need a generic
+ * definition.
  */
-#ifndef __HAVE_ARCH_ENTER_LAZY_CPU_MODE
-#define arch_enter_lazy_cpu_mode()	do {} while (0)
-#define arch_leave_lazy_cpu_mode()	do {} while (0)
-#define arch_flush_lazy_cpu_mode()	do {} while (0)
+#ifndef __HAVE_ARCH_START_CONTEXT_SWITCH
+#define arch_start_context_switch(prev)	do {} while (0)
 #endif
 
 #ifndef __HAVE_PFNMAP_TRACKING
diff --git a/kernel/sched.c b/kernel/sched.c
index 3e827b8..77b43e3 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2804,7 +2804,7 @@ context_switch(struct rq *rq, struct task_struct *prev,
 	 * combine the page table reload and the switch backend into
 	 * one hypercall.
 	 */
-	arch_enter_lazy_cpu_mode();
+	arch_start_context_switch(prev);
 
 	if (unlikely(!mm)) {
 		next->active_mm = oldmm;


