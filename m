Return-Path: <linux-kernel-owner+w=401wt.eu-S1755704AbZDGSzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704AbZDGSzp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 14:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754685AbZDGSzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 14:55:09 -0400
Received: from smtp-68.nebula.fi ([83.145.220.68]:41255 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582AbZDGSzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 14:55:07 -0400
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: ming@elte.hu
Cc: penberg@cs.helsinki.fi, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 11/13] x86: unify irqinit_{32,64}.c into irqinit.c
Date: Tue,  7 Apr 2009 16:48:38 +0300
Message-Id: <1239112120-676-11-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1239112120-676-1-git-send-email-penberg@cs.helsinki.fi>
References: <1239112120-676-1-git-send-email-penberg@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 arch/x86/kernel/Makefile                    |    2 +-
 arch/x86/kernel/{irqinit_32.c => irqinit.c} |    0 
 arch/x86/kernel/irqinit_64.c                |  277 ---------------------------
 3 files changed, 1 insertions(+), 278 deletions(-)
 rename arch/x86/kernel/{irqinit_32.c => irqinit.c} (100%)
 delete mode 100644 arch/x86/kernel/irqinit_64.c

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index c611ad6..8ca0a33 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -28,7 +28,7 @@ CFLAGS_paravirt.o	:= $(nostackp)
 obj-y			:= process_$(BITS).o signal.o entry_$(BITS).o
 obj-y			+= traps.o irq.o irq_$(BITS).o dumpstack_$(BITS).o
 obj-y			+= time_$(BITS).o ioport.o ldt.o dumpstack.o
-obj-y			+= setup.o i8259.o irqinit_$(BITS).o
+obj-y			+= setup.o i8259.o irqinit.o
 obj-$(CONFIG_X86_VISWS)	+= visws_quirks.o
 obj-$(CONFIG_X86_32)	+= probe_roms_32.o
 obj-$(CONFIG_X86_32)	+= sys_i386_32.o i386_ksyms_32.o
diff --git a/arch/x86/kernel/irqinit_32.c b/arch/x86/kernel/irqinit.c
similarity index 100%
rename from arch/x86/kernel/irqinit_32.c
rename to arch/x86/kernel/irqinit.c
diff --git a/arch/x86/kernel/irqinit_64.c b/arch/x86/kernel/irqinit_64.c
deleted file mode 100644
index f3be5e9..0000000
--- a/arch/x86/kernel/irqinit_64.c
+++ /dev/null
@@ -1,277 +0,0 @@
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
-#include <asm/timer.h>
-#include <asm/hw_irq.h>
-#include <asm/pgtable.h>
-#include <asm/desc.h>
-#include <asm/apic.h>
-#include <asm/setup.h>
-#include <asm/i8259.h>
-#include <asm/traps.h>
-
-/*
- * ISA PIC or low IO-APIC triggered (INTA-cycle or APIC) interrupts:
- * (these are usually mapped to vectors 0x30-0x3f)
- */
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
-
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
-	.name = "fpu",
-};
-#endif
-
-/*
- * IRQ2 is cascade interrupt to second interrupt controller
- */
-static struct irqaction irq2 = {
-	.handler = no_action,
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
-static void __init init_ISA_irqs(void)
-{
-	int i;
-
-#if defined(CONFIG_X86_64) || defined(CONFIG_X86_LOCAL_APIC)
-	init_bsp_APIC();
-#endif
-	init_8259A(0);
-
-	/*
-	 * 16 old-style INTA-cycle interrupts:
-	 */
-	for (i = 0; i < NR_IRQS_LEGACY; i++) {
-		struct irq_desc *desc = irq_to_desc(i);
-
-		desc->status = IRQ_DISABLED;
-		desc->action = NULL;
-		desc->depth = 1;
-
-		set_irq_chip_and_handler_name(i, &i8259A_chip,
-					      handle_level_irq, "XT");
-	}
-}
-
-/* Overridden in paravirt.c */
-void init_IRQ(void) __attribute__((weak, alias("native_init_IRQ")));
-
-static void __init smp_intr_init(void)
-{
-#ifdef CONFIG_SMP
-#if defined(CONFIG_X86_64) || defined(CONFIG_X86_LOCAL_APIC)
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
-#endif /* CONFIG_SMP */
-}
-
-static void __init apic_intr_init(void)
-{
-	smp_intr_init();
-
-#ifdef CONFIG_X86_64
-	alloc_intr_gate(THERMAL_APIC_VECTOR, thermal_interrupt);
-	alloc_intr_gate(THRESHOLD_APIC_VECTOR, threshold_interrupt);
-#endif
-
-#if defined(CONFIG_X86_64) || defined(CONFIG_X86_LOCAL_APIC)
-	/* self generated IPI for local APIC timer */
-	alloc_intr_gate(LOCAL_TIMER_VECTOR, apic_timer_interrupt);
-
-	/* generic IPI for platform specific use */
-	alloc_intr_gate(GENERIC_INTERRUPT_VECTOR, generic_interrupt);
-
-	/* IPI vectors for APIC spurious and error interrupts */
-	alloc_intr_gate(SPURIOUS_APIC_VECTOR, spurious_interrupt);
-	alloc_intr_gate(ERROR_APIC_VECTOR, error_interrupt);
-#endif
-
-#ifdef CONFIG_X86_32
-#if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86_MCE_P4THERMAL)
-	/* thermal monitor LVT interrupt */
-	alloc_intr_gate(THERMAL_APIC_VECTOR, thermal_interrupt);
-#endif
-#endif
-}
-
-#ifdef CONFIG_X86_32
-/**
- * x86_quirk_pre_intr_init - initialisation prior to setting up interrupt vectors
- *
- * Description:
- *	Perform any necessary interrupt initialisation prior to setting up
- *	the "ordinary" interrupt call gates.  For legacy reasons, the ISA
- *	interrupts should be initialised here if the machine emulates a PC
- *	in any way.
- **/
-static void __init x86_quirk_pre_intr_init(void)
-{
-	if (x86_quirks->arch_pre_intr_init) {
-		if (x86_quirks->arch_pre_intr_init())
-			return;
-	}
-	init_ISA_irqs();
-}
-#endif
-
-void __init native_init_IRQ(void)
-{
-	int i;
-
-#ifdef CONFIG_X86_32
-	/* Execute any quirks before the call gates are initialised: */
-	x86_quirk_pre_intr_init();
-#else
-	init_ISA_irqs();
-#endif
-
-	/*
-	 * Cover the whole vector space, no vector can escape
-	 * us. (some of these will be overridden and become
-	 * 'special' SMP interrupts)
-	 */
-	for (i = FIRST_EXTERNAL_VECTOR; i < NR_VECTORS; i++) {
-#ifdef CONFIG_X86_32
-		/* SYSCALL_VECTOR was reserved in trap_init. */
-		if (i != SYSCALL_VECTOR)
-			set_intr_gate(i, interrupt[i-FIRST_EXTERNAL_VECTOR]);
-#else
-		/* IA32_SYSCALL_VECTOR was reserved in trap_init. */
-		if (i != IA32_SYSCALL_VECTOR)
-			set_intr_gate(i, interrupt[i-FIRST_EXTERNAL_VECTOR]);
-#endif
-	}
-
-	apic_intr_init();
-
-	if (!acpi_ioapic)
-		setup_irq(2, &irq2);
-
-#ifdef CONFIG_X86_32
-	/*
-	 * Call quirks after call gates are initialised (usually add in
-	 * the architecture specific gates):
-	 */
-	x86_quirk_intr_init();
-
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
-- 
1.5.6.3

