Return-Path: <linux-kernel-owner+w=401wt.eu-S1753810AbYIVS6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810AbYIVS6R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 14:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752910AbYIVS6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 14:58:04 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35142 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752890AbYIVS6B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 14:58:01 -0400
Date: Mon, 22 Sep 2008 14:57:33 -0400
Message-Id: <200809221857.m8MIvXUB019029@ns3.rdu.redhat.com>
From: Glauber Costa <gcosta@redhat.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, x86@kernel.org
Subject: [GIT-PULL] Split time.c series: part 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, please pull the latest master branch git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/glommer/linux-2.6-x86-integration.git ingo-time

into your tree

It contains the part of time.c integration that is considered mostly safe,
and does not touch (but one reorganization patch) the interrupt code. It should
go smootly, but it's (should be) bisection friendly in case it doesn't.

Sorry for the delay.

Thanks!

	Glauber

------------------>
Glauber Costa (13):
      x86: use user_mode macro
      x86: coalesce tests
      x86: set bp field in pt_regs properly
      x86: use frame pointer information on x86_64 profile_pc
      x86: remove SEGMENT_IS_FLAT_CODE
      x86: use user_mode_vm instead of user_mode
      x86: bind irq0 irq data to cpu0
      x86: factor out irq initialization for x86_64
      x86: make init_ISA_irqs nonstatic
      x86: rename timer_event_interrupt to timer_interrupt
      x86: replace hardcoded number
      x86: wrap MCA_bus test around an ifdef
      x86: move vgetcpu mode probing to cpu detection

 arch/x86/kernel/cpu/common.c |   12 +++++++++++
 arch/x86/kernel/entry_64.S   |    7 ++++++
 arch/x86/kernel/irqinit_64.c |   45 +++++++++++++++++++++++++++--------------
 arch/x86/kernel/time_32.c    |    7 +++--
 arch/x86/kernel/time_64.c    |   23 ++++++++++++++------
 include/asm-x86/segment.h    |    6 -----
 6 files changed, 68 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 7d38e0a..70abc5b 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -719,12 +719,24 @@ static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 #endif
 }
 
+#ifdef CONFIG_X86_64
+static void vgetcpu_set_mode(void)
+{
+	if (cpu_has(&boot_cpu_data, X86_FEATURE_RDTSCP))
+		vgetcpu_mode = VGETCPU_RDTSCP;
+	else
+		vgetcpu_mode = VGETCPU_LSL;
+}
+#endif
+
 void __init identify_boot_cpu(void)
 {
 	identify_cpu(&boot_cpu_data);
 #ifdef CONFIG_X86_32
 	sysenter_setup();
 	enable_sep_cpu();
+#else
+	vgetcpu_set_mode();
 #endif
 }
 
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index bed477b..76adfc7 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -643,6 +643,13 @@ END(stub_rt_sigreturn)
 	SAVE_ARGS
 	leaq -ARGOFFSET(%rsp),%rdi	# arg1 for handler
 	pushq %rbp
+	/*
+	 * Save rbp twice: One is for marking the stack frame, as usual, and the
+	 * other, to fill pt_regs properly. This is because bx comes right
+	 * before the last saved register in that structure, and not bp. If the
+	 * base pointer were in the place bx is today, this would not be needed.
+	 */
+	movq %rbp, -8(%rsp)
 	CFI_ADJUST_CFA_OFFSET	8
 	CFI_REL_OFFSET		rbp, 0
 	movq %rsp,%rbp
diff --git a/arch/x86/kernel/irqinit_64.c b/arch/x86/kernel/irqinit_64.c
index 2f4d009..7df020b 100644
--- a/arch/x86/kernel/irqinit_64.c
+++ b/arch/x86/kernel/irqinit_64.c
@@ -135,7 +135,7 @@ DEFINE_PER_CPU(vector_irq_t, vector_irq) = {
 	[IRQ15_VECTOR + 1 ... NR_VECTORS - 1] = -1
 };
 
-static void __init init_ISA_irqs (void)
+void __init init_ISA_irqs(void)
 {
 	int i;
 
@@ -160,22 +160,8 @@ static void __init init_ISA_irqs (void)
 
 void init_IRQ(void) __attribute__((weak, alias("native_init_IRQ")));
 
-void __init native_init_IRQ(void)
+void __init smp_intr_init(void)
 {
-	int i;
-
-	init_ISA_irqs();
-	/*
-	 * Cover the whole vector space, no vector can escape
-	 * us. (some of these will be overridden and become
-	 * 'special' SMP interrupts)
-	 */
-	for (i = 0; i < (NR_VECTORS - FIRST_EXTERNAL_VECTOR); i++) {
-		int vector = FIRST_EXTERNAL_VECTOR + i;
-		if (vector != IA32_SYSCALL_VECTOR)
-			set_intr_gate(vector, interrupt[i]);
-	}
-
 #ifdef CONFIG_SMP
 	/*
 	 * The reschedule interrupt is a CPU-to-CPU reschedule-helper
@@ -203,6 +189,14 @@ void __init native_init_IRQ(void)
 	/* Low priority IPI to cleanup after moving an irq */
 	set_intr_gate(IRQ_MOVE_CLEANUP_VECTOR, irq_move_cleanup_interrupt);
 #endif
+}
+
+void __init apic_intr_init(void)
+{
+#ifdef CONFIG_SMP
+	smp_intr_init();
+#endif
+
 	alloc_intr_gate(THERMAL_APIC_VECTOR, thermal_interrupt);
 	alloc_intr_gate(THRESHOLD_APIC_VECTOR, threshold_interrupt);
 
@@ -212,6 +206,25 @@ void __init native_init_IRQ(void)
 	/* IPI vectors for APIC spurious and error interrupts */
 	alloc_intr_gate(SPURIOUS_APIC_VECTOR, spurious_interrupt);
 	alloc_intr_gate(ERROR_APIC_VECTOR, error_interrupt);
+}
+
+void __init native_init_IRQ(void)
+{
+	int i;
+
+	init_ISA_irqs();
+	/*
+	 * Cover the whole vector space, no vector can escape
+	 * us. (some of these will be overridden and become
+	 * 'special' SMP interrupts)
+	 */
+	for (i = 0; i < (NR_VECTORS - FIRST_EXTERNAL_VECTOR); i++) {
+		int vector = FIRST_EXTERNAL_VECTOR + i;
+		if (vector != IA32_SYSCALL_VECTOR)
+			set_intr_gate(vector, interrupt[i]);
+	}
+
+	apic_intr_init();
 
 	if (!acpi_ioapic)
 		setup_irq(2, &irq2);
diff --git a/arch/x86/kernel/time_32.c b/arch/x86/kernel/time_32.c
index bbecf8b..77b400f 100644
--- a/arch/x86/kernel/time_32.c
+++ b/arch/x86/kernel/time_32.c
@@ -47,10 +47,9 @@ unsigned long profile_pc(struct pt_regs *regs)
 	unsigned long pc = instruction_pointer(regs);
 
 #ifdef CONFIG_SMP
-	if (!v8086_mode(regs) && SEGMENT_IS_KERNEL_CODE(regs->cs) &&
-	    in_lock_functions(pc)) {
+	if (!user_mode_vm(regs) && in_lock_functions(pc)) {
 #ifdef CONFIG_FRAME_POINTER
-		return *(unsigned long *)(regs->bp + 4);
+		return *(unsigned long *)(regs->bp + sizeof(long));
 #else
 		unsigned long *sp = (unsigned long *)&regs->sp;
 
@@ -95,6 +94,7 @@ irqreturn_t timer_interrupt(int irq, void *dev_id)
 
 	do_timer_interrupt_hook();
 
+#ifdef CONFIG_MCA
 	if (MCA_bus) {
 		/* The PS/2 uses level-triggered interrupts.  You can't
 		turn them off, nor would you want to (any attempt to
@@ -108,6 +108,7 @@ irqreturn_t timer_interrupt(int irq, void *dev_id)
 		u8 irq_v = inb_p( 0x61 );	/* read the current state */
 		outb_p( irq_v|0x80, 0x61 );	/* reset the IRQ */
 	}
+#endif
 
 	return IRQ_HANDLED;
 }
diff --git a/arch/x86/kernel/time_64.c b/arch/x86/kernel/time_64.c
index 6a6af01..2f6457e 100644
--- a/arch/x86/kernel/time_64.c
+++ b/arch/x86/kernel/time_64.c
@@ -16,6 +16,7 @@
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/time.h>
+#include <linux/mca.h>
 
 #include <asm/i8253.h>
 #include <asm/hpet.h>
@@ -33,23 +34,34 @@ unsigned long profile_pc(struct pt_regs *regs)
 	/* Assume the lock function has either no stack frame or a copy
 	   of flags from PUSHF
 	   Eflags always has bits 22 and up cleared unlike kernel addresses. */
-	if (!user_mode(regs) && in_lock_functions(pc)) {
+	if (!user_mode_vm(regs) && in_lock_functions(pc)) {
+#ifdef CONFIG_FRAME_POINTER
+		return *(unsigned long *)(regs->bp + sizeof(long));
+#else
 		unsigned long *sp = (unsigned long *)regs->sp;
 		if (sp[0] >> 22)
 			return sp[0];
 		if (sp[1] >> 22)
 			return sp[1];
+#endif
 	}
 	return pc;
 }
 EXPORT_SYMBOL(profile_pc);
 
-static irqreturn_t timer_event_interrupt(int irq, void *dev_id)
+irqreturn_t timer_interrupt(int irq, void *dev_id)
 {
 	add_pda(irq0_irqs, 1);
 
 	global_clock_event->event_handler(global_clock_event);
 
+#ifdef CONFIG_MCA
+	if (MCA_bus) {
+		u8 irq_v = inb_p(0x61);       /* read the current state */
+		outb_p(irq_v|0x80, 0x61);     /* reset the IRQ */
+	}
+#endif
+
 	return IRQ_HANDLED;
 }
 
@@ -100,7 +112,7 @@ unsigned long __init calibrate_cpu(void)
 }
 
 static struct irqaction irq0 = {
-	.handler	= timer_event_interrupt,
+	.handler	= timer_interrupt,
 	.flags		= IRQF_DISABLED | IRQF_IRQPOLL | IRQF_NOBALANCING,
 	.mask		= CPU_MASK_NONE,
 	.name		= "hpet"
@@ -113,16 +125,13 @@ void __init hpet_time_init(void)
 		setup_pit_timer();
 	}
 
+	irq0.mask = cpumask_of_cpu(0);
 	setup_irq(0, &irq0);
 }
 
 void __init time_init(void)
 {
 	tsc_init();
-	if (cpu_has(&boot_cpu_data, X86_FEATURE_RDTSCP))
-		vgetcpu_mode = VGETCPU_RDTSCP;
-	else
-		vgetcpu_mode = VGETCPU_LSL;
 
 	late_time_init = choose_time_init();
 }
diff --git a/include/asm-x86/segment.h b/include/asm-x86/segment.h
index ea5f0a8..5d6e694 100644
--- a/include/asm-x86/segment.h
+++ b/include/asm-x86/segment.h
@@ -131,12 +131,6 @@
  * Matching rules for certain types of segments.
  */
 
-/* Matches only __KERNEL_CS, ignoring PnP / USER / APM segments */
-#define SEGMENT_IS_KERNEL_CODE(x) (((x) & 0xfc) == GDT_ENTRY_KERNEL_CS * 8)
-
-/* Matches __KERNEL_CS and __USER_CS (they must be 2 entries apart) */
-#define SEGMENT_IS_FLAT_CODE(x)  (((x) & 0xec) == GDT_ENTRY_KERNEL_CS * 8)
-
 /* Matches PNP_CS32 and PNP_CS16 (they must be consecutive) */
 #define SEGMENT_IS_PNP_CODE(x)   (((x) & 0xf4) == GDT_ENTRY_PNPBIOS_BASE * 8)
 
