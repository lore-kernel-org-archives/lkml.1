Return-Path: <linux-kernel-owner+w=401wt.eu-S1757341AbZBRWcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341AbZBRWcR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 17:32:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753999AbZBRWa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 17:30:26 -0500
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:43890
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752742AbZBRWaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 17:30:23 -0500
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
Subject: [PATCH 9/9] x86/paravirt: finish change from lazy cpu to context switch start/end
Date: Wed, 18 Feb 2009 14:30:18 -0800
Message-Id: <e97718e1da1dde2dfb843cd37b9d07214cb61f76.1234988621.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <cover.1234988621.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1234988621.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1234988621.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1234988621.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

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
index 58d2481..dfdee0c 100644
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
@@ -1414,20 +1416,21 @@ enum paravirt_lazy_mode {
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
index a00628a..d7dfb89 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -83,6 +83,8 @@ static inline void __init paravirt_pagetable_setup_done(pgd_t *base)
 #define pte_val(x)	native_pte_val(x)
 #define __pte(x)	native_make_pte(x)
 
+#define arch_end_context_switch(prev)	do {} while(0)
+
 #endif	/* CONFIG_PARAVIRT */
 
 /*
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 0811730..cb406cb 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -269,24 +269,24 @@ void paravirt_leave_lazy_mmu(void)
 	leave_lazy(PARAVIRT_LAZY_MMU);
 }
 
-void paravirt_enter_lazy_cpu(void)
+void paravirt_start_context_switch(struct task_struct *prev)
 {
 	BUG_ON(preemptible());
 
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
 	BUG_ON(preemptible());
 
 	leave_lazy(PARAVIRT_LAZY_CPU);
 
-	if (test_and_clear_thread_flag(TIF_LAZY_MMU_UPDATES))
+	if (test_and_clear_ti_thread_flag(task_thread_info(next), TIF_LAZY_MMU_UPDATES))
 		arch_enter_lazy_mmu_mode();
 }
 
@@ -401,10 +401,8 @@ struct pv_cpu_ops pv_cpu_ops = {
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
index 60d7b18..a846b53 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -578,7 +578,7 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	 * done before math_state_restore, so the TS bit is up
 	 * to date.
 	 */
-	arch_end_context_switch();
+	arch_end_context_switch(next_p);
 
 	/* If the task has used fpu the last 5 timeslices, just do a full
 	 * restore of the math state immediately to avoid the trap; the
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index d5156e7..64fcb9f 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -595,7 +595,7 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	 * done before math_state_restore, so the TS bit is up
 	 * to date.
 	 */
-	arch_end_context_switch();
+	arch_end_context_switch(next_p);
 
 	/*
 	 * Switch FS and GS.
diff --git a/arch/x86/kernel/vmi_32.c b/arch/x86/kernel/vmi_32.c
index 950929c..55a5d69 100644
--- a/arch/x86/kernel/vmi_32.c
+++ b/arch/x86/kernel/vmi_32.c
@@ -467,16 +467,16 @@ vmi_startup_ipi_hook(int phys_apicid, unsigned long start_eip,
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
@@ -722,9 +722,9 @@ static inline int __init activate_vmi(void)
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
index 804c170..d70e80d 100644
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
@@ -1024,8 +1024,8 @@ __init void lguest_init(void)
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
index fc6519a..2af94de 100644
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
@@ -815,10 +815,8 @@ static const struct pv_cpu_ops xen_cpu_ops __initdata = {
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
index 88bec28..b2107a5 100644
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
index 25d4c6b..2376a90 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2782,7 +2782,7 @@ context_switch(struct rq *rq, struct task_struct *prev,
 	 * combine the page table reload and the switch backend into
 	 * one hypercall.
 	 */
-	arch_start_context_switch();
+	arch_start_context_switch(prev);
 
 	if (unlikely(!mm)) {
 		next->active_mm = oldmm;
-- 
1.6.0.6

