Return-Path: <linux-kernel-owner+w=401wt.eu-S1759399AbYG1SyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759399AbYG1SyS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 14:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753311AbYG1SyD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 14:54:03 -0400
Received: from gw.goop.org ([64.81.55.164]:55460 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752602AbYG1SyC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 14:54:02 -0400
Message-ID: <488E15C5.3070902@goop.org>
Date: Mon, 28 Jul 2008 11:53:57 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Sam Ravnborg <sam@ravnborg.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Alex Nixon (Intern)" <Alex.Nixon@eu.citrix.com>,
       Eduardo Habkost <ehabkost@redhat.com>
Subject: [PATCH] xen: xen: compile irq functions without -pg for ftrace
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For some reason I managed to miss a bunch of irq-related functions
which also need to be compiled without -pg when using ftrace.  This
patch moves them into their own file, and starts a cleanup process
I've been meaning to do anyway.

[ Sam, Ingo: I think the problem was that I enabled CONFIG_FTRACE
  but didn't do a clean build.  Shouldn't the build-system notice
  that the config changes the CFLAGS and rebuild everything?  That
  didn't seem to happen in this case. ]

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/ldt.c     |    2 
 arch/x86/xen/Makefile     |    3 
 arch/x86/xen/enlighten.c  |  122 --------------------------------------
 arch/x86/xen/irq.c        |  143 +++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/xen/xen-asm_32.S |    2 
 arch/x86/xen/xen-asm_64.S |    2 
 arch/x86/xen/xen-ops.h    |    1 
 drivers/xen/events.c      |   11 ---
 8 files changed, 152 insertions(+), 134 deletions(-)

===================================================================
--- a/arch/x86/xen/Makefile
+++ b/arch/x86/xen/Makefile
@@ -2,9 +2,10 @@
 # Do not profile debug and lowlevel utilities
 CFLAGS_REMOVE_spinlock.o = -pg
 CFLAGS_REMOVE_time.o = -pg
+CFLAGS_REMOVE_irq.o = -pg
 endif
 
-obj-y		:= enlighten.o setup.o multicalls.o mmu.o \
+obj-y		:= enlighten.o setup.o multicalls.o mmu.o irq.o \
 			time.o xen-asm_$(BITS).o grant-table.o suspend.o
 
 obj-$(CONFIG_SMP)	+= smp.o spinlock.o
===================================================================
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -30,7 +30,6 @@
 #include <xen/interface/xen.h>
 #include <xen/interface/physdev.h>
 #include <xen/interface/vcpu.h>
-#include <xen/interface/sched.h>
 #include <xen/features.h>
 #include <xen/page.h>
 #include <xen/hvc-console.h>
@@ -293,94 +292,6 @@
 static unsigned long xen_get_debugreg(int reg)
 {
 	return HYPERVISOR_get_debugreg(reg);
-}
-
-static unsigned long xen_save_fl(void)
-{
-	struct vcpu_info *vcpu;
-	unsigned long flags;
-
-	vcpu = x86_read_percpu(xen_vcpu);
-
-	/* flag has opposite sense of mask */
-	flags = !vcpu->evtchn_upcall_mask;
-
-	/* convert to IF type flag
-	   -0 -> 0x00000000
-	   -1 -> 0xffffffff
-	*/
-	return (-flags) & X86_EFLAGS_IF;
-}
-
-static void xen_restore_fl(unsigned long flags)
-{
-	struct vcpu_info *vcpu;
-
-	/* convert from IF type flag */
-	flags = !(flags & X86_EFLAGS_IF);
-
-	/* There's a one instruction preempt window here.  We need to
-	   make sure we're don't switch CPUs between getting the vcpu
-	   pointer and updating the mask. */
-	preempt_disable();
-	vcpu = x86_read_percpu(xen_vcpu);
-	vcpu->evtchn_upcall_mask = flags;
-	preempt_enable_no_resched();
-
-	/* Doesn't matter if we get preempted here, because any
-	   pending event will get dealt with anyway. */
-
-	if (flags == 0) {
-		preempt_check_resched();
-		barrier(); /* unmask then check (avoid races) */
-		if (unlikely(vcpu->evtchn_upcall_pending))
-			force_evtchn_callback();
-	}
-}
-
-static void xen_irq_disable(void)
-{
-	/* There's a one instruction preempt window here.  We need to
-	   make sure we're don't switch CPUs between getting the vcpu
-	   pointer and updating the mask. */
-	preempt_disable();
-	x86_read_percpu(xen_vcpu)->evtchn_upcall_mask = 1;
-	preempt_enable_no_resched();
-}
-
-static void xen_irq_enable(void)
-{
-	struct vcpu_info *vcpu;
-
-	/* We don't need to worry about being preempted here, since
-	   either a) interrupts are disabled, so no preemption, or b)
-	   the caller is confused and is trying to re-enable interrupts
-	   on an indeterminate processor. */
-
-	vcpu = x86_read_percpu(xen_vcpu);
-	vcpu->evtchn_upcall_mask = 0;
-
-	/* Doesn't matter if we get preempted here, because any
-	   pending event will get dealt with anyway. */
-
-	barrier(); /* unmask then check (avoid races) */
-	if (unlikely(vcpu->evtchn_upcall_pending))
-		force_evtchn_callback();
-}
-
-static void xen_safe_halt(void)
-{
-	/* Blocking includes an implicit local_irq_enable(). */
-	if (HYPERVISOR_sched_op(SCHEDOP_block, NULL) != 0)
-		BUG();
-}
-
-static void xen_halt(void)
-{
-	if (irqs_disabled())
-		HYPERVISOR_vcpu_op(VCPUOP_down, smp_processor_id(), NULL);
-	else
-		xen_safe_halt();
 }
 
 static void xen_leave_lazy(void)
@@ -1378,36 +1289,6 @@
 	},
 };
 
-static void __init __xen_init_IRQ(void)
-{
-#ifdef CONFIG_X86_64
-	int i;
-
-	/* Create identity vector->irq map */
-	for(i = 0; i < NR_VECTORS; i++) {
-		int cpu;
-
-		for_each_possible_cpu(cpu)
-			per_cpu(vector_irq, cpu)[i] = i;
-	}
-#endif	/* CONFIG_X86_64 */
-
-	xen_init_IRQ();
-}
-
-static const struct pv_irq_ops xen_irq_ops __initdata = {
-	.init_IRQ = __xen_init_IRQ,
-	.save_fl = xen_save_fl,
-	.restore_fl = xen_restore_fl,
-	.irq_disable = xen_irq_disable,
-	.irq_enable = xen_irq_enable,
-	.safe_halt = xen_safe_halt,
-	.halt = xen_halt,
-#ifdef CONFIG_X86_64
-	.adjust_exception_frame = xen_adjust_exception_frame,
-#endif
-};
-
 static const struct pv_apic_ops xen_apic_ops __initdata = {
 #ifdef CONFIG_X86_LOCAL_APIC
 	.setup_boot_clock = paravirt_nop,
@@ -1810,9 +1691,10 @@
 	pv_init_ops = xen_init_ops;
 	pv_time_ops = xen_time_ops;
 	pv_cpu_ops = xen_cpu_ops;
-	pv_irq_ops = xen_irq_ops;
 	pv_apic_ops = xen_apic_ops;
 	pv_mmu_ops = xen_mmu_ops;
+
+	xen_init_irq_ops();
 
 #ifdef CONFIG_X86_LOCAL_APIC
 	/*
===================================================================
--- /dev/null
+++ b/arch/x86/xen/irq.c
@@ -0,0 +1,143 @@
+#include <linux/hardirq.h>
+
+#include <xen/interface/xen.h>
+#include <xen/interface/sched.h>
+#include <xen/interface/vcpu.h>
+
+#include <asm/xen/hypercall.h>
+#include <asm/xen/hypervisor.h>
+
+#include "xen-ops.h"
+
+/*
+ * Force a proper event-channel callback from Xen after clearing the
+ * callback mask. We do this in a very simple manner, by making a call
+ * down into Xen. The pending flag will be checked by Xen on return.
+ */
+void xen_force_evtchn_callback(void)
+{
+	(void)HYPERVISOR_xen_version(0, NULL);
+}
+
+static void __init __xen_init_IRQ(void)
+{
+#ifdef CONFIG_X86_64
+	int i;
+
+	/* Create identity vector->irq map */
+	for(i = 0; i < NR_VECTORS; i++) {
+		int cpu;
+
+		for_each_possible_cpu(cpu)
+			per_cpu(vector_irq, cpu)[i] = i;
+	}
+#endif	/* CONFIG_X86_64 */
+
+	xen_init_IRQ();
+}
+
+static unsigned long xen_save_fl(void)
+{
+	struct vcpu_info *vcpu;
+	unsigned long flags;
+
+	vcpu = x86_read_percpu(xen_vcpu);
+
+	/* flag has opposite sense of mask */
+	flags = !vcpu->evtchn_upcall_mask;
+
+	/* convert to IF type flag
+	   -0 -> 0x00000000
+	   -1 -> 0xffffffff
+	*/
+	return (-flags) & X86_EFLAGS_IF;
+}
+
+static void xen_restore_fl(unsigned long flags)
+{
+	struct vcpu_info *vcpu;
+
+	/* convert from IF type flag */
+	flags = !(flags & X86_EFLAGS_IF);
+
+	/* There's a one instruction preempt window here.  We need to
+	   make sure we're don't switch CPUs between getting the vcpu
+	   pointer and updating the mask. */
+	preempt_disable();
+	vcpu = x86_read_percpu(xen_vcpu);
+	vcpu->evtchn_upcall_mask = flags;
+	preempt_enable_no_resched();
+
+	/* Doesn't matter if we get preempted here, because any
+	   pending event will get dealt with anyway. */
+
+	if (flags == 0) {
+		preempt_check_resched();
+		barrier(); /* unmask then check (avoid races) */
+		if (unlikely(vcpu->evtchn_upcall_pending))
+			xen_force_evtchn_callback();
+	}
+}
+
+static void xen_irq_disable(void)
+{
+	/* There's a one instruction preempt window here.  We need to
+	   make sure we're don't switch CPUs between getting the vcpu
+	   pointer and updating the mask. */
+	preempt_disable();
+	x86_read_percpu(xen_vcpu)->evtchn_upcall_mask = 1;
+	preempt_enable_no_resched();
+}
+
+static void xen_irq_enable(void)
+{
+	struct vcpu_info *vcpu;
+
+	/* We don't need to worry about being preempted here, since
+	   either a) interrupts are disabled, so no preemption, or b)
+	   the caller is confused and is trying to re-enable interrupts
+	   on an indeterminate processor. */
+
+	vcpu = x86_read_percpu(xen_vcpu);
+	vcpu->evtchn_upcall_mask = 0;
+
+	/* Doesn't matter if we get preempted here, because any
+	   pending event will get dealt with anyway. */
+
+	barrier(); /* unmask then check (avoid races) */
+	if (unlikely(vcpu->evtchn_upcall_pending))
+		xen_force_evtchn_callback();
+}
+
+static void xen_safe_halt(void)
+{
+	/* Blocking includes an implicit local_irq_enable(). */
+	if (HYPERVISOR_sched_op(SCHEDOP_block, NULL) != 0)
+		BUG();
+}
+
+static void xen_halt(void)
+{
+	if (irqs_disabled())
+		HYPERVISOR_vcpu_op(VCPUOP_down, smp_processor_id(), NULL);
+	else
+		xen_safe_halt();
+}
+
+static const struct pv_irq_ops xen_irq_ops __initdata = {
+	.init_IRQ = __xen_init_IRQ,
+	.save_fl = xen_save_fl,
+	.restore_fl = xen_restore_fl,
+	.irq_disable = xen_irq_disable,
+	.irq_enable = xen_irq_enable,
+	.safe_halt = xen_safe_halt,
+	.halt = xen_halt,
+#ifdef CONFIG_X86_64
+	.adjust_exception_frame = xen_adjust_exception_frame,
+#endif
+};
+
+void __init xen_init_irq_ops()
+{
+	pv_irq_ops = xen_irq_ops;
+}
===================================================================
--- a/arch/x86/xen/xen-asm_32.S
+++ b/arch/x86/xen/xen-asm_32.S
@@ -298,7 +298,7 @@
 	push %eax
 	push %ecx
 	push %edx
-	call force_evtchn_callback
+	call xen_force_evtchn_callback
 	pop %edx
 	pop %ecx
 	pop %eax
===================================================================
--- a/arch/x86/xen/xen-asm_64.S
+++ b/arch/x86/xen/xen-asm_64.S
@@ -122,7 +122,7 @@
 	push %r9
 	push %r10
 	push %r11
-	call force_evtchn_callback
+	call xen_force_evtchn_callback
 	pop %r11
 	pop %r10
 	pop %r9
===================================================================
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -32,6 +32,7 @@
 
 void __init xen_build_dynamic_phys_to_machine(void);
 
+void xen_init_irq_ops(void);
 void xen_setup_timer(int cpu);
 void xen_setup_cpu_clockevents(void);
 unsigned long xen_tsc_khz(void);
===================================================================
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -83,17 +83,6 @@
 
 /* Xen will never allocate port zero for any purpose. */
 #define VALID_EVTCHN(chn)	((chn) != 0)
-
-/*
- * Force a proper event-channel callback from Xen after clearing the
- * callback mask. We do this in a very simple manner, by making a call
- * down into Xen. The pending flag will be checked by Xen on return.
- */
-void force_evtchn_callback(void)
-{
-	(void)HYPERVISOR_xen_version(0, NULL);
-}
-EXPORT_SYMBOL_GPL(force_evtchn_callback);
 
 static struct irq_chip xen_dynamic_chip;
 


