Return-Path: <linux-kernel-owner+w=401wt.eu-S1759032AbZC2UXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759032AbZC2UXZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 16:23:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756278AbZC2UVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 16:21:23 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:35858 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756604AbZC2UVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 16:21:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:user-agent:date:from:to:cc:subject:references
         :content-disposition;
        b=E3hLOVR2srqhm67xEkr6GDC0n7IEDGyVmTWpnNEF0Nt11AGEEI8BZ5wzanBAO5/RUd
         +Wt8SenPIFnswrzGx7IYvubSYBcrAf5J3gK2WAH6W90VzTDLrYhiJfTgNIuZ23tDIJWP
         pD36VgxaPKrbJt/0pEOMP24weLj1+oylWkkz4=
Message-Id: <20090329202208.439338795@openvz.org>
User-Agent: quilt/0.47-1
Date: Mon, 30 Mar 2009 00:15:51 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, xemul@openvz.org, yhlu.kernel@gmail.com,
       Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [patch 6/6] x86: irqinit - merge irqinit_32/64.c into irqinit.c
References: <20090329201545.470255691@openvz.org>
Content-Disposition: inline; filename=x86-irqinit-merge
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So the files are merged there is still #include's
mess -- need serious cleanup.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/kernel/Makefile     |    2 
 arch/x86/kernel/irqinit.c    |  249 +++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/irqinit_32.c |  246 ------------------------------------------
 arch/x86/kernel/irqinit_64.c |  249 -------------------------------------------
 4 files changed, 250 insertions(+), 496 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/Makefile
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/Makefile
+++ linux-2.6.git/arch/x86/kernel/Makefile
@@ -28,7 +28,7 @@ CFLAGS_paravirt.o	:= $(nostackp)
 obj-y			:= process_$(BITS).o signal.o entry_$(BITS).o
 obj-y			+= traps.o irq.o irq_$(BITS).o dumpstack_$(BITS).o
 obj-y			+= time_$(BITS).o ioport.o ldt.o dumpstack.o
-obj-y			+= setup.o i8259.o irqinit_$(BITS).o
+obj-y			+= setup.o i8259.o irqinit.o
 obj-$(CONFIG_X86_VISWS)	+= visws_quirks.o
 obj-$(CONFIG_X86_32)	+= probe_roms_32.o
 obj-$(CONFIG_X86_32)	+= sys_i386_32.o i386_ksyms_32.o
Index: linux-2.6.git/arch/x86/kernel/irqinit.c
===================================================================
--- /dev/null
+++ linux-2.6.git/arch/x86/kernel/irqinit.c
@@ -0,0 +1,249 @@
+#include <linux/linkage.h>
+#include <linux/errno.h>
+#include <linux/signal.h>
+#include <linux/sched.h>
+#include <linux/ioport.h>
+#include <linux/interrupt.h>
+#include <linux/kprobes.h>
+#include <linux/timex.h>
+#include <linux/slab.h>
+#include <linux/random.h>
+#include <linux/init.h>
+#include <linux/kernel_stat.h>
+#include <linux/sysdev.h>
+#include <linux/bitops.h>
+#include <linux/acpi.h>
+#include <linux/io.h>
+#include <linux/delay.h>
+
+#include <asm/atomic.h>
+#include <asm/system.h>
+#include <asm/hw_irq.h>
+#include <asm/timer.h>
+#include <asm/pgtable.h>
+#include <asm/desc.h>
+#include <asm/apic.h>
+#include <asm/setup.h>
+#include <asm/i8259.h>
+#include <asm/traps.h>
+
+#ifdef CONFIG_X86_32
+/*
+ * Note that on a 486, we don't want to do a SIGFPE on an irq13
+ * as the irq is unreliable, and exception 16 works correctly
+ * (ie as explained in the intel literature). On a 386, you
+ * can't use exception 16 due to bad IBM design, so we have to
+ * rely on the less exact irq13.
+ *
+ * Careful.. Not only is IRQ13 unreliable, but it is also
+ * leads to races. IBM designers who came up with it should
+ * be shot.
+ */
+static irqreturn_t math_error_irq(int cpl, void *dev_id)
+{
+	outb(0, 0xF0);
+	if (ignore_fpu_irq || !boot_cpu_data.hard_math)
+		return IRQ_NONE;
+	math_error((void __user *)get_irq_regs()->ip);
+	return IRQ_HANDLED;
+}
+
+/*
+ * New motherboards sometimes make IRQ 13 be a PCI interrupt,
+ * so allow interrupt sharing.
+ */
+static struct irqaction fpu_irq = {
+	.handler = math_error_irq,
+	.mask = CPU_MASK_NONE,
+	.name = "fpu",
+};
+#endif /* CONFIG_X86_32 */
+
+/*
+ * ISA PIC or low IO-APIC triggered (INTA-cycle or APIC) interrupts:
+ * (these are usually mapped to vectors 0x30-0x3f)
+ */
+void __init init_ISA_irqs(void)
+{
+	int i;
+
+#ifdef CONFIG_X86_LOCAL_APIC
+	init_bsp_APIC();
+#endif
+	init_8259A(0);
+
+	/* 16 old-style INTA-cycle interrupts */
+	for (i = 0; i < NR_IRQS_LEGACY; i++) {
+		struct irq_desc *desc = irq_to_desc(i);
+
+		desc->status = IRQ_DISABLED;
+		desc->action = NULL;
+		desc->depth = 1;
+
+		set_irq_chip_and_handler_name(i, &i8259A_chip,
+					handle_level_irq, "XT");
+	}
+}
+
+/*
+ * The IO-APIC gives us many more interrupt sources. Most of these
+ * are unused but an SMP system is supposed to have enough memory ...
+ * sometimes (mostly wrt. hw bugs) we get corrupted vectors all
+ * across the spectrum, so we really want to be prepared to get all
+ * of these. Plus, more powerful systems might have more than 64
+ * IO-APIC registers.
+ *
+ * (these are usually mapped into the 0x30-0xff vector range)
+ */
+
+/*
+ * IRQ2 is cascade interrupt to second interrupt controller
+ */
+
+static struct irqaction irq2 = {
+	.handler = no_action,
+	.mask = CPU_MASK_NONE,
+	.name = "cascade",
+};
+DEFINE_PER_CPU(vector_irq_t, vector_irq) = {
+	[0 ... IRQ0_VECTOR - 1] = -1,
+	[IRQ0_VECTOR] = 0,
+	[IRQ1_VECTOR] = 1,
+	[IRQ2_VECTOR] = 2,
+	[IRQ3_VECTOR] = 3,
+	[IRQ4_VECTOR] = 4,
+	[IRQ5_VECTOR] = 5,
+	[IRQ6_VECTOR] = 6,
+	[IRQ7_VECTOR] = 7,
+	[IRQ8_VECTOR] = 8,
+	[IRQ9_VECTOR] = 9,
+	[IRQ10_VECTOR] = 10,
+	[IRQ11_VECTOR] = 11,
+	[IRQ12_VECTOR] = 12,
+	[IRQ13_VECTOR] = 13,
+	[IRQ14_VECTOR] = 14,
+	[IRQ15_VECTOR] = 15,
+	[IRQ15_VECTOR + 1 ... NR_VECTORS - 1] = -1
+};
+
+int vector_used_by_percpu_irq(unsigned int vector)
+{
+	int cpu;
+
+	for_each_online_cpu(cpu) {
+		if (per_cpu(vector_irq, cpu)[vector] != -1)
+			return 1;
+	}
+
+	return 0;
+}
+
+/* Overridden in paravirt.c */
+void init_IRQ(void) __attribute__((weak, alias("native_init_IRQ")));
+
+static void __init smp_intr_init(void)
+{
+#if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_SMP)
+	/*
+	 * The reschedule interrupt is a CPU-to-CPU reschedule-helper
+	 * IPI, driven by wakeup.
+	 */
+	alloc_intr_gate(RESCHEDULE_VECTOR, reschedule_interrupt);
+
+	/* IPIs for invalidation */
+	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+0, invalidate_interrupt0);
+	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+1, invalidate_interrupt1);
+	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+2, invalidate_interrupt2);
+	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+3, invalidate_interrupt3);
+	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+4, invalidate_interrupt4);
+	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+5, invalidate_interrupt5);
+	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+6, invalidate_interrupt6);
+	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+7, invalidate_interrupt7);
+
+	/* IPI for generic function call */
+	alloc_intr_gate(CALL_FUNCTION_VECTOR, call_function_interrupt);
+
+	/* IPI for generic single function call */
+	alloc_intr_gate(CALL_FUNCTION_SINGLE_VECTOR,
+			call_function_single_interrupt);
+
+	/* Low priority IPI to cleanup after moving an irq */
+	set_intr_gate(IRQ_MOVE_CLEANUP_VECTOR, irq_move_cleanup_interrupt);
+	set_bit(IRQ_MOVE_CLEANUP_VECTOR, used_vectors);
+#endif
+}
+
+static void __init apic_intr_init(void)
+{
+	smp_intr_init();
+
+#ifdef CONFIG_X86_LOCAL_APIC
+
+	/* self generated IPI for local APIC timer */
+	alloc_intr_gate(LOCAL_TIMER_VECTOR, apic_timer_interrupt);
+
+	/* generic IPI for platform specific use */
+	alloc_intr_gate(GENERIC_INTERRUPT_VECTOR, generic_interrupt);
+
+	/* IPI vectors for APIC spurious and error interrupts */
+	alloc_intr_gate(SPURIOUS_APIC_VECTOR, spurious_interrupt);
+	alloc_intr_gate(ERROR_APIC_VECTOR, error_interrupt);
+
+# ifdef CONFIG_PERF_COUNTERS
+	/* Performance monitoring interrupt */
+	alloc_intr_gate(LOCAL_PERF_VECTOR, perf_counter_interrupt);
+# endif
+
+#if defined(CONFIG_X86_MCE_P4THERMAL) || defined(CONFIG_X86_64)
+	/* thermal monitor LVT interrupt */
+	alloc_intr_gate(THERMAL_APIC_VECTOR, thermal_interrupt);
+# endif
+
+# ifdef CONFIG_X86_64
+	alloc_intr_gate(THRESHOLD_APIC_VECTOR, threshold_interrupt);
+# endif
+
+#endif
+}
+
+void __init native_init_IRQ(void)
+{
+	int i;
+
+	/* Execute any quirks before the call gates are initialised: */
+	x86_quirk_pre_intr_init();
+
+	apic_intr_init();
+
+	/*
+	 * Cover the whole vector space, no vector can escape
+	 * us. (some of these will be overridden and become
+	 * 'special' SMP interrupts)
+	 */
+	for (i = 0; i < (NR_VECTORS - FIRST_EXTERNAL_VECTOR); i++) {
+		int vector = FIRST_EXTERNAL_VECTOR + i;
+		/* X86-32: SYSCALL_VECTOR was reserved in trap_init. */
+		if (!test_bit(vector, used_vectors))
+			set_intr_gate(vector, interrupt[i]);
+	}
+
+	if (!acpi_ioapic)
+		setup_irq(2, &irq2);
+
+	/*
+	 * Call quirks after call gates are initialised (usually add in
+	 * the architecture specific gates):
+	 */
+	x86_quirk_intr_init();
+
+#ifdef CONFIG_X86_32
+	/*
+	 * External FPU? Set up irq13 if so, for
+	 * original braindamaged IBM FERR coupling.
+	 */
+	if (boot_cpu_data.hard_math && !cpu_has_fpu)
+		setup_irq(FPU_IRQ, &fpu_irq);
+
+	irq_ctx_init(smp_processor_id());
+#endif
+}
Index: linux-2.6.git/arch/x86/kernel/irqinit_32.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/irqinit_32.c
+++ /dev/null
@@ -1,246 +0,0 @@
-#include <linux/linkage.h>
-#include <linux/errno.h>
-#include <linux/signal.h>
-#include <linux/sched.h>
-#include <linux/ioport.h>
-#include <linux/interrupt.h>
-#include <linux/timex.h>
-#include <linux/slab.h>
-#include <linux/random.h>
-#include <linux/init.h>
-#include <linux/kernel_stat.h>
-#include <linux/sysdev.h>
-#include <linux/bitops.h>
-#include <linux/acpi.h>
-#include <linux/io.h>
-#include <linux/delay.h>
-
-#include <asm/atomic.h>
-#include <asm/system.h>
-#include <asm/hw_irq.h>
-#include <asm/timer.h>
-#include <asm/pgtable.h>
-#include <asm/desc.h>
-#include <asm/apic.h>
-#include <asm/setup.h>
-#include <asm/i8259.h>
-#include <asm/traps.h>
-
-#ifdef CONFIG_X86_32
-/*
- * Note that on a 486, we don't want to do a SIGFPE on an irq13
- * as the irq is unreliable, and exception 16 works correctly
- * (ie as explained in the intel literature). On a 386, you
- * can't use exception 16 due to bad IBM design, so we have to
- * rely on the less exact irq13.
- *
- * Careful.. Not only is IRQ13 unreliable, but it is also
- * leads to races. IBM designers who came up with it should
- * be shot.
- */
-static irqreturn_t math_error_irq(int cpl, void *dev_id)
-{
-	outb(0, 0xF0);
-	if (ignore_fpu_irq || !boot_cpu_data.hard_math)
-		return IRQ_NONE;
-	math_error((void __user *)get_irq_regs()->ip);
-	return IRQ_HANDLED;
-}
-
-/*
- * New motherboards sometimes make IRQ 13 be a PCI interrupt,
- * so allow interrupt sharing.
- */
-static struct irqaction fpu_irq = {
-	.handler = math_error_irq,
-	.mask = CPU_MASK_NONE,
-	.name = "fpu",
-};
-#endif /* CONFIG_X86_32 */
-
-/*
- * ISA PIC or low IO-APIC triggered (INTA-cycle or APIC) interrupts:
- * (these are usually mapped to vectors 0x30-0x3f)
- */
-void __init init_ISA_irqs(void)
-{
-	int i;
-
-#ifdef CONFIG_X86_LOCAL_APIC
-	init_bsp_APIC();
-#endif
-	init_8259A(0);
-
-	/* 16 old-style INTA-cycle interrupts */
-	for (i = 0; i < NR_IRQS_LEGACY; i++) {
-		struct irq_desc *desc = irq_to_desc(i);
-
-		desc->status = IRQ_DISABLED;
-		desc->action = NULL;
-		desc->depth = 1;
-
-		set_irq_chip_and_handler_name(i, &i8259A_chip,
-					handle_level_irq, "XT");
-	}
-}
-
-/*
- * The IO-APIC gives us many more interrupt sources. Most of these
- * are unused but an SMP system is supposed to have enough memory ...
- * sometimes (mostly wrt. hw bugs) we get corrupted vectors all
- * across the spectrum, so we really want to be prepared to get all
- * of these. Plus, more powerful systems might have more than 64
- * IO-APIC registers.
- *
- * (these are usually mapped into the 0x30-0xff vector range)
- */
-
-/*
- * IRQ2 is cascade interrupt to second interrupt controller
- */
-static struct irqaction irq2 = {
-	.handler = no_action,
-	.mask = CPU_MASK_NONE,
-	.name = "cascade",
-};
-
-DEFINE_PER_CPU(vector_irq_t, vector_irq) = {
-	[0 ... IRQ0_VECTOR - 1] = -1,
-	[IRQ0_VECTOR] = 0,
-	[IRQ1_VECTOR] = 1,
-	[IRQ2_VECTOR] = 2,
-	[IRQ3_VECTOR] = 3,
-	[IRQ4_VECTOR] = 4,
-	[IRQ5_VECTOR] = 5,
-	[IRQ6_VECTOR] = 6,
-	[IRQ7_VECTOR] = 7,
-	[IRQ8_VECTOR] = 8,
-	[IRQ9_VECTOR] = 9,
-	[IRQ10_VECTOR] = 10,
-	[IRQ11_VECTOR] = 11,
-	[IRQ12_VECTOR] = 12,
-	[IRQ13_VECTOR] = 13,
-	[IRQ14_VECTOR] = 14,
-	[IRQ15_VECTOR] = 15,
-	[IRQ15_VECTOR + 1 ... NR_VECTORS - 1] = -1
-};
-
-int vector_used_by_percpu_irq(unsigned int vector)
-{
-	int cpu;
-
-	for_each_online_cpu(cpu) {
-		if (per_cpu(vector_irq, cpu)[vector] != -1)
-			return 1;
-	}
-
-	return 0;
-}
-
-/* Overridden in paravirt.c */
-void init_IRQ(void) __attribute__((weak, alias("native_init_IRQ")));
-
-static void __init smp_intr_init(void)
-{
-#if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_SMP)
-	/*
-	 * The reschedule interrupt is a CPU-to-CPU reschedule-helper
-	 * IPI, driven by wakeup.
-	 */
-	alloc_intr_gate(RESCHEDULE_VECTOR, reschedule_interrupt);
-
-	/* IPIs for invalidation */
-	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+0, invalidate_interrupt0);
-	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+1, invalidate_interrupt1);
-	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+2, invalidate_interrupt2);
-	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+3, invalidate_interrupt3);
-	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+4, invalidate_interrupt4);
-	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+5, invalidate_interrupt5);
-	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+6, invalidate_interrupt6);
-	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+7, invalidate_interrupt7);
-
-	/* IPI for generic function call */
-	alloc_intr_gate(CALL_FUNCTION_VECTOR, call_function_interrupt);
-
-	/* IPI for generic single function call */
-	alloc_intr_gate(CALL_FUNCTION_SINGLE_VECTOR,
-				 call_function_single_interrupt);
-
-	/* Low priority IPI to cleanup after moving an irq */
-	set_intr_gate(IRQ_MOVE_CLEANUP_VECTOR, irq_move_cleanup_interrupt);
-	set_bit(IRQ_MOVE_CLEANUP_VECTOR, used_vectors);
-#endif
-}
-
-static void __init apic_intr_init(void)
-{
-	smp_intr_init();
-
-#ifdef CONFIG_X86_LOCAL_APIC
-	/* self generated IPI for local APIC timer */
-	alloc_intr_gate(LOCAL_TIMER_VECTOR, apic_timer_interrupt);
-
-	/* generic IPI for platform specific use */
-	alloc_intr_gate(GENERIC_INTERRUPT_VECTOR, generic_interrupt);
-
-	/* IPI vectors for APIC spurious and error interrupts */
-	alloc_intr_gate(SPURIOUS_APIC_VECTOR, spurious_interrupt);
-	alloc_intr_gate(ERROR_APIC_VECTOR, error_interrupt);
-# ifdef CONFIG_PERF_COUNTERS
-	/* Performance monitoring interrupt */
-	alloc_intr_gate(LOCAL_PERF_VECTOR, perf_counter_interrupt);
-# endif
-
-#if defined(CONFIG_X86_MCE_P4THERMAL) || defined(CONFIG_X86_64)
-	/* thermal monitor LVT interrupt */
-	alloc_intr_gate(THERMAL_APIC_VECTOR, thermal_interrupt);
-# endif
-
-# ifdef CONFIG_X86_64
-	alloc_intr_gate(THRESHOLD_APIC_VECTOR, threshold_interrupt);
-# endif
-
-#endif
-}
-
-void __init native_init_IRQ(void)
-{
-	int i;
-
-	/* Execute any quirks before the call gates are initialised: */
-	x86_quirk_pre_intr_init();
-
-	apic_intr_init();
-
-	/*
-	 * Cover the whole vector space, no vector can escape
-	 * us. (some of these will be overridden and become
-	 * 'special' SMP interrupts)
-	 */
-	for (i = 0; i < (NR_VECTORS - FIRST_EXTERNAL_VECTOR); i++) {
-		int vector = FIRST_EXTERNAL_VECTOR + i;
-		/* X86-32: SYSCALL_VECTOR was reserved in trap_init. */
-		if (!test_bit(vector, used_vectors))
-			set_intr_gate(vector, interrupt[i]);
-	}
-
-	if (!acpi_ioapic)
-		setup_irq(2, &irq2);
-
-	/*
-	 * Call quirks after call gates are initialised (usually add in
-	 * the architecture specific gates):
-	 */
-	x86_quirk_intr_init();
-
-#ifdef CONFIG_X86_32
-	/*
-	 * External FPU? Set up irq13 if so, for
-	 * original braindamaged IBM FERR coupling.
-	 */
-	if (boot_cpu_data.hard_math && !cpu_has_fpu)
-		setup_irq(FPU_IRQ, &fpu_irq);
-
-	irq_ctx_init(smp_processor_id());
-#endif
-}
Index: linux-2.6.git/arch/x86/kernel/irqinit_64.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/irqinit_64.c
+++ /dev/null
@@ -1,249 +0,0 @@
-#include <linux/linkage.h>
-#include <linux/errno.h>
-#include <linux/signal.h>
-#include <linux/sched.h>
-#include <linux/ioport.h>
-#include <linux/interrupt.h>
-#include <linux/kprobes.h>
-#include <linux/timex.h>
-#include <linux/slab.h>
-#include <linux/random.h>
-#include <linux/init.h>
-#include <linux/kernel_stat.h>
-#include <linux/sysdev.h>
-#include <linux/bitops.h>
-#include <linux/acpi.h>
-#include <linux/io.h>
-#include <linux/delay.h>
-
-#include <asm/atomic.h>
-#include <asm/system.h>
-#include <asm/hw_irq.h>
-#include <asm/timer.h>
-#include <asm/pgtable.h>
-#include <asm/desc.h>
-#include <asm/apic.h>
-#include <asm/setup.h>
-#include <asm/i8259.h>
-#include <asm/traps.h>
-
-#ifdef CONFIG_X86_32
-/*
- * Note that on a 486, we don't want to do a SIGFPE on an irq13
- * as the irq is unreliable, and exception 16 works correctly
- * (ie as explained in the intel literature). On a 386, you
- * can't use exception 16 due to bad IBM design, so we have to
- * rely on the less exact irq13.
- *
- * Careful.. Not only is IRQ13 unreliable, but it is also
- * leads to races. IBM designers who came up with it should
- * be shot.
- */
-static irqreturn_t math_error_irq(int cpl, void *dev_id)
-{
-	outb(0, 0xF0);
-	if (ignore_fpu_irq || !boot_cpu_data.hard_math)
-		return IRQ_NONE;
-	math_error((void __user *)get_irq_regs()->ip);
-	return IRQ_HANDLED;
-}
-
-/*
- * New motherboards sometimes make IRQ 13 be a PCI interrupt,
- * so allow interrupt sharing.
- */
-static struct irqaction fpu_irq = {
-	.handler = math_error_irq,
-	.mask = CPU_MASK_NONE,
-	.name = "fpu",
-};
-#endif /* CONFIG_X86_32 */
-
-/*
- * ISA PIC or low IO-APIC triggered (INTA-cycle or APIC) interrupts:
- * (these are usually mapped to vectors 0x30-0x3f)
- */
-void __init init_ISA_irqs(void)
-{
-	int i;
-
-#ifdef CONFIG_X86_LOCAL_APIC
-	init_bsp_APIC();
-#endif
-	init_8259A(0);
-
-	/* 16 old-style INTA-cycle interrupts */
-	for (i = 0; i < NR_IRQS_LEGACY; i++) {
-		struct irq_desc *desc = irq_to_desc(i);
-
-		desc->status = IRQ_DISABLED;
-		desc->action = NULL;
-		desc->depth = 1;
-
-		set_irq_chip_and_handler_name(i, &i8259A_chip,
-					handle_level_irq, "XT");
-	}
-}
-
-/*
- * The IO-APIC gives us many more interrupt sources. Most of these
- * are unused but an SMP system is supposed to have enough memory ...
- * sometimes (mostly wrt. hw bugs) we get corrupted vectors all
- * across the spectrum, so we really want to be prepared to get all
- * of these. Plus, more powerful systems might have more than 64
- * IO-APIC registers.
- *
- * (these are usually mapped into the 0x30-0xff vector range)
- */
-
-/*
- * IRQ2 is cascade interrupt to second interrupt controller
- */
-
-static struct irqaction irq2 = {
-	.handler = no_action,
-	.mask = CPU_MASK_NONE,
-	.name = "cascade",
-};
-DEFINE_PER_CPU(vector_irq_t, vector_irq) = {
-	[0 ... IRQ0_VECTOR - 1] = -1,
-	[IRQ0_VECTOR] = 0,
-	[IRQ1_VECTOR] = 1,
-	[IRQ2_VECTOR] = 2,
-	[IRQ3_VECTOR] = 3,
-	[IRQ4_VECTOR] = 4,
-	[IRQ5_VECTOR] = 5,
-	[IRQ6_VECTOR] = 6,
-	[IRQ7_VECTOR] = 7,
-	[IRQ8_VECTOR] = 8,
-	[IRQ9_VECTOR] = 9,
-	[IRQ10_VECTOR] = 10,
-	[IRQ11_VECTOR] = 11,
-	[IRQ12_VECTOR] = 12,
-	[IRQ13_VECTOR] = 13,
-	[IRQ14_VECTOR] = 14,
-	[IRQ15_VECTOR] = 15,
-	[IRQ15_VECTOR + 1 ... NR_VECTORS - 1] = -1
-};
-
-int vector_used_by_percpu_irq(unsigned int vector)
-{
-	int cpu;
-
-	for_each_online_cpu(cpu) {
-		if (per_cpu(vector_irq, cpu)[vector] != -1)
-			return 1;
-	}
-
-	return 0;
-}
-
-/* Overridden in paravirt.c */
-void init_IRQ(void) __attribute__((weak, alias("native_init_IRQ")));
-
-static void __init smp_intr_init(void)
-{
-#if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_SMP)
-	/*
-	 * The reschedule interrupt is a CPU-to-CPU reschedule-helper
-	 * IPI, driven by wakeup.
-	 */
-	alloc_intr_gate(RESCHEDULE_VECTOR, reschedule_interrupt);
-
-	/* IPIs for invalidation */
-	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+0, invalidate_interrupt0);
-	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+1, invalidate_interrupt1);
-	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+2, invalidate_interrupt2);
-	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+3, invalidate_interrupt3);
-	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+4, invalidate_interrupt4);
-	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+5, invalidate_interrupt5);
-	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+6, invalidate_interrupt6);
-	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+7, invalidate_interrupt7);
-
-	/* IPI for generic function call */
-	alloc_intr_gate(CALL_FUNCTION_VECTOR, call_function_interrupt);
-
-	/* IPI for generic single function call */
-	alloc_intr_gate(CALL_FUNCTION_SINGLE_VECTOR,
-			call_function_single_interrupt);
-
-	/* Low priority IPI to cleanup after moving an irq */
-	set_intr_gate(IRQ_MOVE_CLEANUP_VECTOR, irq_move_cleanup_interrupt);
-	set_bit(IRQ_MOVE_CLEANUP_VECTOR, used_vectors);
-#endif
-}
-
-static void __init apic_intr_init(void)
-{
-	smp_intr_init();
-
-#ifdef CONFIG_X86_LOCAL_APIC
-
-	/* self generated IPI for local APIC timer */
-	alloc_intr_gate(LOCAL_TIMER_VECTOR, apic_timer_interrupt);
-
-	/* generic IPI for platform specific use */
-	alloc_intr_gate(GENERIC_INTERRUPT_VECTOR, generic_interrupt);
-
-	/* IPI vectors for APIC spurious and error interrupts */
-	alloc_intr_gate(SPURIOUS_APIC_VECTOR, spurious_interrupt);
-	alloc_intr_gate(ERROR_APIC_VECTOR, error_interrupt);
-
-# ifdef CONFIG_PERF_COUNTERS
-	/* Performance monitoring interrupt */
-	alloc_intr_gate(LOCAL_PERF_VECTOR, perf_counter_interrupt);
-# endif
-
-#if defined(CONFIG_X86_MCE_P4THERMAL) || defined(CONFIG_X86_64)
-	/* thermal monitor LVT interrupt */
-	alloc_intr_gate(THERMAL_APIC_VECTOR, thermal_interrupt);
-# endif
-
-# ifdef CONFIG_X86_64
-	alloc_intr_gate(THRESHOLD_APIC_VECTOR, threshold_interrupt);
-# endif
-
-#endif
-}
-
-void __init native_init_IRQ(void)
-{
-	int i;
-
-	/* Execute any quirks before the call gates are initialised: */
-	x86_quirk_pre_intr_init();
-
-	apic_intr_init();
-
-	/*
-	 * Cover the whole vector space, no vector can escape
-	 * us. (some of these will be overridden and become
-	 * 'special' SMP interrupts)
-	 */
-	for (i = 0; i < (NR_VECTORS - FIRST_EXTERNAL_VECTOR); i++) {
-		int vector = FIRST_EXTERNAL_VECTOR + i;
-		/* X86-32: SYSCALL_VECTOR was reserved in trap_init. */
-		if (!test_bit(vector, used_vectors))
-			set_intr_gate(vector, interrupt[i]);
-	}
-
-	if (!acpi_ioapic)
-		setup_irq(2, &irq2);
-
-	/*
-	 * Call quirks after call gates are initialised (usually add in
-	 * the architecture specific gates):
-	 */
-	x86_quirk_intr_init();
-
-#ifdef CONFIG_X86_32
-	/*
-	 * External FPU? Set up irq13 if so, for
-	 * original braindamaged IBM FERR coupling.
-	 */
-	if (boot_cpu_data.hard_math && !cpu_has_fpu)
-		setup_irq(FPU_IRQ, &fpu_irq);
-
-	irq_ctx_init(smp_processor_id());
-#endif
-}

