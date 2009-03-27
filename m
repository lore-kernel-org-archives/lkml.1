Return-Path: <linux-kernel-owner+w=401wt.eu-S1755331AbZC0SFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331AbZC0SFp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 14:05:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754405AbZC0SCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 14:02:52 -0400
Received: from gw.goop.org ([64.81.55.164]:58157 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752287AbZC0SCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 14:02:48 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: the arch/x86 maintainers <x86@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 5/8] x86/paravirt: finish change from lazy cpu to context switch start/end
Date: Fri, 27 Mar 2009 11:02:40 -0700
Message-Id: <1238176963-21093-6-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1238176963-21093-1-git-send-email-jeremy@goop.org>
References: <1238176963-21093-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Impact: fix lazy context switch API

Pass the previous and next tasks into the context switch start
end calls, so that the called functions can properly access the
task state (esp in end_context_switch, in which the next task
is not yet completely current).

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/paravirt.h |   17 ++++++++++-------
 arch/x86/include/asm/pgtable.h  |    2 ++
 arch/x86/kernel/paravirt.c      |   14 ++++++--------
 arch/x86/kernel/process_32.c    |    2 +-
 arch/x86/kernel/process_64.c    |    2 +-
 arch/x86/kernel/vmi_32.c        |   12 ++++++------
 arch/x86/lguest/boot.c          |    8 ++++----
 arch/x86/xen/enlighten.c        |   10 ++++------
 include/asm-frv/pgtable.h       |    2 +-
 include/asm-generic/pgtable.h   |    2 +-
 kernel/sched.c                  |    2 +-
 11 files changed, 37 insertions(+), 36 deletions(-)

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 5ecd16e..bc384be 100644
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
@@ -1399,20 +1401,21 @@ enum paravirt_lazy_mode {
 };
 
 enum paravirt_lazy_mode paravirt_get_lazy_mode(void);
-void paravirt_enter_lazy_cpu(void);
-void paravirt_leave_lazy_cpu(void);
+void paravirt_start_context_switch(struct task_struct *prev);
+void paravirt_end_context_switch(struct task_struct *next);
+
 void paravirt_enter_lazy_mmu(void);
 void paravirt_leave_lazy_mmu(void);
 
 #define  __HAVE_ARCH_START_CONTEXT_SWITCH
-static inline void arch_start_context_switch(void)
+static inline void arch_start_context_switch(struct task_struct *prev)
 {
-	PVOP_VCALL0(pv_cpu_ops.lazy_mode.enter);
+	PVOP_VCALL1(pv_cpu_ops.start_context_switch, prev);
 }
 
-static inline void arch_end_context_switch(void)
+static inline void arch_end_context_switch(struct task_struct *next)
 {
-	PVOP_VCALL0(pv_cpu_ops.lazy_mode.leave);
+	PVOP_VCALL1(pv_cpu_ops.end_context_switch, next);
 }
 
 #define  __HAVE_ARCH_ENTER_LAZY_MMU_MODE
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
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index eca40de..35eb353 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -270,20 +270,20 @@ void paravirt_leave_lazy_mmu(void)
 	leave_lazy(PARAVIRT_LAZY_MMU);
 }
 
-void paravirt_enter_lazy_cpu(void)
+void paravirt_start_context_switch(struct task_struct *prev)
 {
 	if (percpu_read(paravirt_lazy_mode) == PARAVIRT_LAZY_MMU) {
 		arch_leave_lazy_mmu_mode();
-		set_thread_flag(TIF_LAZY_MMU_UPDATES);
+		set_ti_thread_flag(task_thread_info(prev), TIF_LAZY_MMU_UPDATES);
 	}
 	enter_lazy(PARAVIRT_LAZY_CPU);
 }
 
-void paravirt_leave_lazy_cpu(void)
+void paravirt_end_context_switch(struct task_struct *next)
 {
 	leave_lazy(PARAVIRT_LAZY_CPU);
 
-	if (test_and_clear_thread_flag(TIF_LAZY_MMU_UPDATES))
+	if (test_and_clear_ti_thread_flag(task_thread_info(next), TIF_LAZY_MMU_UPDATES))
 		arch_enter_lazy_mmu_mode();
 }
 
@@ -399,10 +399,8 @@ struct pv_cpu_ops pv_cpu_ops = {
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
index 57e49a8..d766c76 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -407,7 +407,7 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	 * done before math_state_restore, so the TS bit is up
 	 * to date.
 	 */
-	arch_end_context_switch();
+	arch_end_context_switch(next_p);
 
 	/* If the task has used fpu the last 5 timeslices, just do a full
 	 * restore of the math state immediately to avoid the trap; the
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 7115e60..e8a9aaf 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -428,7 +428,7 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	 * done before math_state_restore, so the TS bit is up
 	 * to date.
 	 */
-	arch_end_context_switch();
+	arch_end_context_switch(next_p);
 
 	/*
 	 * Switch FS and GS.
diff --git a/arch/x86/kernel/vmi_32.c b/arch/x86/kernel/vmi_32.c
index d74122f..b263423 100644
--- a/arch/x86/kernel/vmi_32.c
+++ b/arch/x86/kernel/vmi_32.c
@@ -462,16 +462,16 @@ vmi_startup_ipi_hook(int phys_apicid, unsigned long start_eip,
 }
 #endif
 
-static void vmi_enter_lazy_cpu(void)
+static void vmi_start_context_switch(struct task_struct *prev)
 {
-	paravirt_enter_lazy_cpu();
+	paravirt_start_context_switch(prev);
 	vmi_ops.set_lazy_mode(2);
 }
 
-static void vmi_leave_lazy_cpu(void)
+static void vmi_end_context_switch(struct task_struct *next)
 {
 	vmi_ops.set_lazy_mode(0);
-	paravirt_leave_lazy_cpu();
+	paravirt_end_context_switch(next);
 }
 
 static void vmi_enter_lazy_mmu(void)
@@ -717,9 +717,9 @@ static inline int __init activate_vmi(void)
 	para_fill(pv_cpu_ops.set_iopl_mask, SetIOPLMask);
 	para_fill(pv_cpu_ops.io_delay, IODelay);
 
-	para_wrap(pv_cpu_ops.lazy_mode.enter, vmi_enter_lazy_cpu,
+	para_wrap(pv_cpu_ops.start_context_switch, vmi_start_context_switch,
 		  set_lazy_mode, SetLazyMode);
-	para_wrap(pv_cpu_ops.lazy_mode.leave, vmi_leave_lazy_cpu,
+	para_wrap(pv_cpu_ops.end_context_switch, vmi_end_context_switch,
 		  set_lazy_mode, SetLazyMode);
 
 	para_wrap(pv_mmu_ops.lazy_mode.enter, vmi_enter_lazy_mmu,
diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
index 70d412a..25799f3 100644
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -153,10 +153,10 @@ static void lguest_leave_lazy_mmu_mode(void)
 	paravirt_leave_lazy_mmu();
 }
 
-static void lguest_leave_lazy_cpu_mode(void)
+static void lguest_end_context_switch(struct task_struct *next)
 {
 	hcall(LHCALL_FLUSH_ASYNC, 0, 0, 0);
-	paravirt_leave_lazy_cpu();
+	paravirt_end_context_switch(next);
 }
 
 /*G:033
@@ -1031,8 +1031,8 @@ __init void lguest_init(void)
 	pv_cpu_ops.write_gdt_entry = lguest_write_gdt_entry;
 	pv_cpu_ops.write_idt_entry = lguest_write_idt_entry;
 	pv_cpu_ops.wbinvd = lguest_wbinvd;
-	pv_cpu_ops.lazy_mode.enter = paravirt_enter_lazy_cpu;
-	pv_cpu_ops.lazy_mode.leave = lguest_leave_lazy_cpu_mode;
+	pv_cpu_ops.start_context_switch = paravirt_start_context_switch;
+	pv_cpu_ops.end_context_switch = lguest_end_context_switch;
 
 	/* pagetable management */
 	pv_mmu_ops.write_cr3 = lguest_write_cr3;
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index f586e63..70b355d 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -203,10 +203,10 @@ static unsigned long xen_get_debugreg(int reg)
 	return HYPERVISOR_get_debugreg(reg);
 }
 
-static void xen_leave_lazy_cpu(void)
+static void xen_end_context_switch(struct task_struct *next)
 {
 	xen_mc_flush();
-	paravirt_leave_lazy_cpu();
+	paravirt_end_context_switch(next);
 }
 
 static unsigned long xen_store_tr(void)
@@ -817,10 +817,8 @@ static const struct pv_cpu_ops xen_cpu_ops __initdata = {
 	/* Xen takes care of %gs when switching to usermode for us */
 	.swapgs = paravirt_nop,
 
-	.lazy_mode = {
-		.enter = paravirt_enter_lazy_cpu,
-		.leave = xen_leave_lazy_cpu,
-	},
+	.start_context_switch = paravirt_start_context_switch,
+	.end_context_switch = xen_end_context_switch,
 };
 
 static const struct pv_apic_ops xen_apic_ops __initdata = {
diff --git a/include/asm-frv/pgtable.h b/include/asm-frv/pgtable.h
index 235e34a..0988704 100644
--- a/include/asm-frv/pgtable.h
+++ b/include/asm-frv/pgtable.h
@@ -74,7 +74,7 @@ static inline int pte_file(pte_t pte) { return 0; }
 #define arch_enter_lazy_mmu_mode()	do {} while (0)
 #define arch_leave_lazy_mmu_mode()	do {} while (0)
 
-#define arch_start_context_switch()	do {} while (0)
+#define arch_start_context_switch(prev)	do {} while (0)
 
 #else /* !CONFIG_MMU */
 /*****************************************************************************/
diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
index 922f036..e410f60 100644
--- a/include/asm-generic/pgtable.h
+++ b/include/asm-generic/pgtable.h
@@ -291,7 +291,7 @@ static inline void ptep_modify_prot_commit(struct mm_struct *mm,
  * definition.
  */
 #ifndef __HAVE_ARCH_START_CONTEXT_SWITCH
-#define arch_start_context_switch()	do {} while (0)
+#define arch_start_context_switch(prev)	do {} while (0)
 #endif
 
 #ifndef __HAVE_PFNMAP_TRACKING
diff --git a/kernel/sched.c b/kernel/sched.c
index 168adaf..77b43e3 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2804,7 +2804,7 @@ context_switch(struct rq *rq, struct task_struct *prev,
 	 * combine the page table reload and the switch backend into
 	 * one hypercall.
 	 */
-	arch_start_context_switch();
+	arch_start_context_switch(prev);
 
 	if (unlikely(!mm)) {
 		next->active_mm = oldmm;
-- 
1.6.0.6

