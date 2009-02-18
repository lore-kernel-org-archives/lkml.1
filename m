Return-Path: <linux-kernel-owner+w=401wt.eu-S1757772AbZBRWdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757772AbZBRWdm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 17:33:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754188AbZBRWa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 17:30:28 -0500
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:43934
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753930AbZBRWa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 17:30:27 -0500
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Rusty Russell <rusty@rustcorp.com.au>, Zachary Amsden <zach@vmware.com>,
       Alok N Kataria <akataria@vmware.com>, Avi Kivity <avi@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 5/9] x86/paravirt: flush pending mmu updates on context switch
Date: Wed, 18 Feb 2009 14:30:14 -0800
Message-Id: <4586181f5d4bf0d883fc74e777cc852daf8630c7.1234988621.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <cover.1234988621.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1234988621.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1234988621.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1234988621.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

If we're in lazy mmu mode when context switching, leave
lazy mmu mode, but remember the task's state in
TIF_LAZY_MMU_UPDATES.  When we resume the task, check this
flag and re-enter lazy mmu mode if its set.

This sets things up for allowing lazy mmu mode while preemptible,
though that won't actually be active until the next change.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/paravirt.h    |    1 -
 arch/x86/include/asm/thread_info.h |    2 ++
 arch/x86/kernel/kvm.c              |    2 +-
 arch/x86/kernel/paravirt.c         |   13 ++++++++++---
 arch/x86/kernel/vmi_32.c           |   14 ++++++++++----
 arch/x86/lguest/boot.c             |   14 ++++++++++----
 arch/x86/xen/enlighten.c           |    6 +++---
 arch/x86/xen/mmu.c                 |    7 ++++++-
 arch/x86/xen/xen-ops.h             |    1 -
 9 files changed, 42 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 7b28aba..58d2481 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -1418,7 +1418,6 @@ void paravirt_enter_lazy_cpu(void);
 void paravirt_leave_lazy_cpu(void);
 void paravirt_enter_lazy_mmu(void);
 void paravirt_leave_lazy_mmu(void);
-void paravirt_leave_lazy(enum paravirt_lazy_mode mode);
 
 #define  __HAVE_ARCH_START_CONTEXT_SWITCH
 static inline void arch_start_context_switch(void)
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index ca7310e..b857399 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -95,6 +95,7 @@ struct thread_info {
 #define TIF_FORCED_TF		24	/* true if TF in eflags artificially */
 #define TIF_DEBUGCTLMSR		25	/* uses thread_struct.debugctlmsr */
 #define TIF_DS_AREA_MSR		26      /* uses thread_struct.ds_area_msr */
+#define TIF_LAZY_MMU_UPDATES	27	/* task is updating the mmu lazily */
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
@@ -117,6 +118,7 @@ struct thread_info {
 #define _TIF_FORCED_TF		(1 << TIF_FORCED_TF)
 #define _TIF_DEBUGCTLMSR	(1 << TIF_DEBUGCTLMSR)
 #define _TIF_DS_AREA_MSR	(1 << TIF_DS_AREA_MSR)
+#define _TIF_LAZY_MMU_UPDATES	(1 << TIF_LAZY_MMU_UPDATES)
 
 /* work to do in syscall_trace_enter() */
 #define _TIF_WORK_SYSCALL_ENTRY	\
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 478bca9..5d7f6e7 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -201,7 +201,7 @@ static void kvm_leave_lazy_mmu(void)
 	struct kvm_para_state *state = kvm_para_state();
 
 	mmu_queue_flush(state);
-	paravirt_leave_lazy(paravirt_get_lazy_mode());
+	paravirt_leave_lazy_mmu();
 	state->mode = paravirt_get_lazy_mode();
 }
 
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index ef3ca17..554dadd 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -253,7 +253,7 @@ static inline void enter_lazy(enum paravirt_lazy_mode mode)
 	__get_cpu_var(paravirt_lazy_mode) = mode;
 }
 
-void paravirt_leave_lazy(enum paravirt_lazy_mode mode)
+static void leave_lazy(enum paravirt_lazy_mode mode)
 {
 	BUG_ON(__get_cpu_var(paravirt_lazy_mode) != mode);
 	BUG_ON(preemptible());
@@ -268,17 +268,24 @@ void paravirt_enter_lazy_mmu(void)
 
 void paravirt_leave_lazy_mmu(void)
 {
-	paravirt_leave_lazy(PARAVIRT_LAZY_MMU);
+	leave_lazy(PARAVIRT_LAZY_MMU);
 }
 
 void paravirt_enter_lazy_cpu(void)
 {
+	if (percpu_read(paravirt_lazy_mode) == PARAVIRT_LAZY_MMU) {
+		arch_leave_lazy_mmu_mode();
+		set_thread_flag(TIF_LAZY_MMU_UPDATES);
+	}
 	enter_lazy(PARAVIRT_LAZY_CPU);
 }
 
 void paravirt_leave_lazy_cpu(void)
 {
-	paravirt_leave_lazy(PARAVIRT_LAZY_CPU);
+	leave_lazy(PARAVIRT_LAZY_CPU);
+
+	if (test_and_clear_thread_flag(TIF_LAZY_MMU_UPDATES))
+		arch_enter_lazy_mmu_mode();
 }
 
 enum paravirt_lazy_mode paravirt_get_lazy_mode(void)
diff --git a/arch/x86/kernel/vmi_32.c b/arch/x86/kernel/vmi_32.c
index 2cc4a90..950929c 100644
--- a/arch/x86/kernel/vmi_32.c
+++ b/arch/x86/kernel/vmi_32.c
@@ -473,16 +473,22 @@ static void vmi_enter_lazy_cpu(void)
 	vmi_ops.set_lazy_mode(2);
 }
 
+static void vmi_leave_lazy_cpu(void)
+{
+	vmi_ops.set_lazy_mode(0);
+	paravirt_leave_lazy_cpu();
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
@@ -718,12 +724,12 @@ static inline int __init activate_vmi(void)
 
 	para_wrap(pv_cpu_ops.lazy_mode.enter, vmi_enter_lazy_cpu,
 		  set_lazy_mode, SetLazyMode);
-	para_wrap(pv_cpu_ops.lazy_mode.leave, vmi_leave_lazy,
+	para_wrap(pv_cpu_ops.lazy_mode.leave, vmi_leave_lazy_cpu,
 		  set_lazy_mode, SetLazyMode);
 
 	para_wrap(pv_mmu_ops.lazy_mode.enter, vmi_enter_lazy_mmu,
 		  set_lazy_mode, SetLazyMode);
-	para_wrap(pv_mmu_ops.lazy_mode.leave, vmi_leave_lazy,
+	para_wrap(pv_mmu_ops.lazy_mode.leave, vmi_leave_lazy_mmu,
 		  set_lazy_mode, SetLazyMode);
 
 	/* user and kernel flush are just handled with different flags to FlushTLB */
diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
index f3a5305..804c170 100644
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
+static void lguest_leave_lazy_cpu_mode(void)
+{
+	hcall(LHCALL_FLUSH_ASYNC, 0, 0, 0);
+	paravirt_leave_lazy_cpu();
 }
 
 /*G:033
@@ -1019,7 +1025,7 @@ __init void lguest_init(void)
 	pv_cpu_ops.write_idt_entry = lguest_write_idt_entry;
 	pv_cpu_ops.wbinvd = lguest_wbinvd;
 	pv_cpu_ops.lazy_mode.enter = paravirt_enter_lazy_cpu;
-	pv_cpu_ops.lazy_mode.leave = lguest_leave_lazy_mode;
+	pv_cpu_ops.lazy_mode.leave = lguest_leave_lazy_cpu_mode;
 
 	/* pagetable management */
 	pv_mmu_ops.write_cr3 = lguest_write_cr3;
@@ -1032,7 +1038,7 @@ __init void lguest_init(void)
 	pv_mmu_ops.read_cr2 = lguest_read_cr2;
 	pv_mmu_ops.read_cr3 = lguest_read_cr3;
 	pv_mmu_ops.lazy_mode.enter = paravirt_enter_lazy_mmu;
-	pv_mmu_ops.lazy_mode.leave = lguest_leave_lazy_mode;
+	pv_mmu_ops.lazy_mode.leave = lguest_leave_lazy_mmu_mode;
 
 #ifdef CONFIG_X86_LOCAL_APIC
 	/* apic read/write intercepts */
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 86497d5..fc6519a 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -203,10 +203,10 @@ static unsigned long xen_get_debugreg(int reg)
 	return HYPERVISOR_get_debugreg(reg);
 }
 
-void xen_leave_lazy(void)
+static void xen_leave_lazy_cpu(void)
 {
-	paravirt_leave_lazy(paravirt_get_lazy_mode());
 	xen_mc_flush();
+	paravirt_leave_lazy_cpu();
 }
 
 static unsigned long xen_store_tr(void)
@@ -817,7 +817,7 @@ static const struct pv_cpu_ops xen_cpu_ops __initdata = {
 
 	.lazy_mode = {
 		.enter = paravirt_enter_lazy_cpu,
-		.leave = xen_leave_lazy,
+		.leave = xen_leave_lazy_cpu,
 	},
 };
 
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 298b9f5..2669c58 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1809,6 +1809,11 @@ __init void xen_post_allocator_init(void)
 	xen_mark_init_mm_pinned();
 }
 
+static void xen_leave_lazy_mmu(void)
+{
+	xen_mc_flush();
+	paravirt_leave_lazy_mmu();
+}
 
 const struct pv_mmu_ops xen_mmu_ops __initdata = {
 	.pagetable_setup_start = xen_pagetable_setup_start,
@@ -1884,7 +1889,7 @@ const struct pv_mmu_ops xen_mmu_ops __initdata = {
 
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
-- 
1.6.0.6

