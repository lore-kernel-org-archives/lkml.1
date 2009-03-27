Return-Path: <linux-kernel-owner+w=401wt.eu-S1759625AbZC0SEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759625AbZC0SEV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 14:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754715AbZC0SCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 14:02:49 -0400
Received: from gw.goop.org ([64.81.55.164]:58149 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751494AbZC0SCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 14:02:47 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: the arch/x86 maintainers <x86@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 4/8] x86/paravirt: flush pending mmu updates on context switch
Date: Fri, 27 Mar 2009 11:02:39 -0700
Message-Id: <1238176963-21093-5-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1238176963-21093-1-git-send-email-jeremy@goop.org>
References: <1238176963-21093-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Impact: allow preemption during lazy mmu updates

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
index f79dc89..5ecd16e 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -1403,7 +1403,6 @@ void paravirt_enter_lazy_cpu(void);
 void paravirt_leave_lazy_cpu(void);
 void paravirt_enter_lazy_mmu(void);
 void paravirt_leave_lazy_mmu(void);
-void paravirt_leave_lazy(enum paravirt_lazy_mode mode);
 
 #define  __HAVE_ARCH_START_CONTEXT_SWITCH
 static inline void arch_start_context_switch(void)
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
index a53e4fb..eca40de 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -252,7 +252,7 @@ static inline void enter_lazy(enum paravirt_lazy_mode mode)
 	__get_cpu_var(paravirt_lazy_mode) = mode;
 }
 
-void paravirt_leave_lazy(enum paravirt_lazy_mode mode)
+static void leave_lazy(enum paravirt_lazy_mode mode)
 {
 	BUG_ON(__get_cpu_var(paravirt_lazy_mode) != mode);
 	BUG_ON(preemptible());
@@ -267,17 +267,24 @@ void paravirt_enter_lazy_mmu(void)
 
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
index 95deb9f..d74122f 100644
--- a/arch/x86/kernel/vmi_32.c
+++ b/arch/x86/kernel/vmi_32.c
@@ -468,16 +468,22 @@ static void vmi_enter_lazy_cpu(void)
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
@@ -713,12 +719,12 @@ static inline int __init activate_vmi(void)
 
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
index 90e44a1..70d412a 100644
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
@@ -1026,7 +1032,7 @@ __init void lguest_init(void)
 	pv_cpu_ops.write_idt_entry = lguest_write_idt_entry;
 	pv_cpu_ops.wbinvd = lguest_wbinvd;
 	pv_cpu_ops.lazy_mode.enter = paravirt_enter_lazy_cpu;
-	pv_cpu_ops.lazy_mode.leave = lguest_leave_lazy_mode;
+	pv_cpu_ops.lazy_mode.leave = lguest_leave_lazy_cpu_mode;
 
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
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 82cd39a..f586e63 100644
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
@@ -819,7 +819,7 @@ static const struct pv_cpu_ops xen_cpu_ops __initdata = {
 
 	.lazy_mode = {
 		.enter = paravirt_enter_lazy_cpu,
-		.leave = xen_leave_lazy,
+		.leave = xen_leave_lazy_cpu,
 	},
 };
 
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 4702c79..aba3b20 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1816,6 +1816,11 @@ __init void xen_post_allocator_init(void)
 	xen_mark_init_mm_pinned();
 }
 
+static void xen_leave_lazy_mmu(void)
+{
+	xen_mc_flush();
+	paravirt_leave_lazy_mmu();
+}
 
 const struct pv_mmu_ops xen_mmu_ops __initdata = {
 	.pagetable_setup_start = xen_pagetable_setup_start,
@@ -1890,7 +1895,7 @@ const struct pv_mmu_ops xen_mmu_ops __initdata = {
 
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

