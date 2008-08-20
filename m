Return-Path: <linux-kernel-owner+w=401wt.eu-S1759551AbYHTPHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759551AbYHTPHu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 11:07:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754589AbYHTPHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 11:07:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50162 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759472AbYHTPHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 11:07:36 -0400
Date: Wed, 20 Aug 2008 11:07:09 -0400
Message-Id: <200808201507.m7KF79Fk021224@int-mx1.corp.redhat.com>
From: Glauber Costa <gcosta@redhat.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, x86@kernel.org
Subject: [GIT PULL] time.c - respin
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, please pull the latest master git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/glommer/linux-2.6-x86-integration.git master

into your tree. It solves a bisectability issue, but I can't, unfortunately, reproduce
the problem you report. So hopefuly you'll now be able to bisect your problems to a point
we can find out what's going on


Thanks!

	Glauber

------------------>
Glauber Costa (31):
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
      x86: allow x86_64 to build with subarch support
      x86: replace ISA initialization function
      x86: use generic intr_init call
      x86: use time_init_hook in time_64.c
      x86: use generic time hook
      x86: replace hardcoded number
      x86: unconditionalize timer_ack
      x86: assign timer_ack variable
      x86: wrap MCA_bus test around an ifdef
      x86: wrap conditional inside ifdef at profile_pc
      x86: fix checkpatch errors
      x86: move vgetcpu mode probing to cpu detection
      x86: add pre_time_init_hooks to x86_64 time initialization
      x86: conditionalize interrupt accounting
      x86: fix address reference
      x86: remove header from time_64.c
      x86: reorganize time_32.c headers
      x86: reorganize 64-bit only code
      x86: merge copyright notice
      x86: make time_64 and time_32 equal
      x86: merge time.c

 arch/x86/Makefile                     |    4 -
 arch/x86/kernel/Makefile              |    2 +-
 arch/x86/kernel/cpu/common_64.c       |    9 +++
 arch/x86/kernel/entry_64.S            |    7 ++
 arch/x86/kernel/io_apic.c             |    6 +-
 arch/x86/kernel/irqinit_64.c          |   59 ++++++++--------
 arch/x86/kernel/{time_32.c => time.c} |   79 +++++++++++++++++++--
 arch/x86/kernel/time_64.c             |  126 ---------------------------------
 include/asm-x86/segment.h             |    6 --
 include/asm-x86/timer.h               |    2 +-
 10 files changed, 121 insertions(+), 179 deletions(-)
 rename arch/x86/kernel/{time_32.c => time.c} (65%)
 delete mode 100644 arch/x86/kernel/time_64.c

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 58ea55c..3ead876 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -121,10 +121,6 @@ mcore-$(CONFIG_X86_GENERICARCH)	:= arch/x86/mach-default/
 # default subarch .h files
 mflags-y += -Iinclude/asm-x86/mach-default
 
-# 64 bit does not support subarch support - clear sub arch variables
-fcore-$(CONFIG_X86_64)  :=
-mcore-$(CONFIG_X86_64)  :=
-
 KBUILD_CFLAGS += $(mflags-y)
 KBUILD_AFLAGS += $(mflags-y)
 
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index a7ce8b0..5510d86 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -25,7 +25,7 @@ CFLAGS_paravirt.o	:= $(nostackp)
 
 obj-y			:= process_$(BITS).o signal_$(BITS).o entry_$(BITS).o
 obj-y			+= traps_$(BITS).o irq_$(BITS).o
-obj-y			+= time_$(BITS).o ioport.o ldt.o
+obj-y			+= time.o ioport.o ldt.o
 obj-y			+= setup.o i8259.o irqinit_$(BITS).o setup_percpu.o
 obj-$(CONFIG_X86_VISWS)	+= visws_quirks.o
 obj-$(CONFIG_X86_32)	+= probe_roms_32.o
diff --git a/arch/x86/kernel/cpu/common_64.c b/arch/x86/kernel/cpu/common_64.c
index 35d11ef..8432e0b 100644
--- a/arch/x86/kernel/cpu/common_64.c
+++ b/arch/x86/kernel/cpu/common_64.c
@@ -411,9 +411,18 @@ static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 
 }
 
+static void vgetcpu_set_mode(void)
+{
+	if (cpu_has(&boot_cpu_data, X86_FEATURE_RDTSCP))
+		vgetcpu_mode = VGETCPU_RDTSCP;
+	else
+		vgetcpu_mode = VGETCPU_LSL;
+}
+
 void __cpuinit identify_boot_cpu(void)
 {
 	identify_cpu(&boot_cpu_data);
+	vgetcpu_set_mode();
 }
 
 void __cpuinit identify_secondary_cpu(struct cpuinfo_x86 *c)
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
diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
index 34c74cf..111ae4a 100644
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -2749,9 +2749,7 @@ static inline void __init check_timer(void)
 	 */
 	apic_write(APIC_LVT0, APIC_LVT_MASKED | APIC_DM_EXTINT);
 	init_8259A(1);
-#ifdef CONFIG_X86_32
 	timer_ack = (nmi_watchdog == NMI_IO_APIC && !APIC_INTEGRATED(ver));
-#endif
 
 	pin1  = find_isa_irq_pin(0, mp_INT);
 	apic1 = find_isa_irq_apic(0, mp_INT);
@@ -2838,14 +2836,14 @@ static inline void __init check_timer(void)
 		apic_printk(APIC_QUIET, KERN_INFO "....... failed.\n");
 	}
 
+	timer_ack = (nmi_watchdog == NMI_IO_APIC && !APIC_INTEGRATED(ver));
+
 	if (nmi_watchdog == NMI_IO_APIC) {
 		apic_printk(APIC_QUIET, KERN_WARNING "timer doesn't work "
 			    "through the IO-APIC - disabling NMI Watchdog!\n");
 		nmi_watchdog = NMI_NONE;
 	}
-#ifdef CONFIG_X86_32
 	timer_ack = 0;
-#endif
 
 	apic_printk(APIC_QUIET, KERN_INFO
 		    "...trying to set up timer as Virtual Wire IRQ...\n");
diff --git a/arch/x86/kernel/irqinit_64.c b/arch/x86/kernel/irqinit_64.c
index 2f4d009..f01df30 100644
--- a/arch/x86/kernel/irqinit_64.c
+++ b/arch/x86/kernel/irqinit_64.c
@@ -22,6 +22,7 @@
 #include <asm/desc.h>
 #include <asm/apic.h>
 #include <asm/i8259.h>
+#include <asm/arch_hooks.h>
 
 /*
  * Common place to define all x86 IRQ vectors
@@ -102,18 +103,6 @@ static void (*__initdata interrupt[NR_VECTORS - FIRST_EXTERNAL_VECTOR])(void) =
 #undef IRQ
 #undef IRQLIST_16
 
-
-
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
 DEFINE_PER_CPU(vector_irq_t, vector_irq) = {
 	[0 ... IRQ0_VECTOR - 1] = -1,
 	[IRQ0_VECTOR] = 0,
@@ -135,7 +124,7 @@ DEFINE_PER_CPU(vector_irq_t, vector_irq) = {
 	[IRQ15_VECTOR + 1 ... NR_VECTORS - 1] = -1
 };
 
-static void __init init_ISA_irqs (void)
+void __init init_ISA_irqs(void)
 {
 	int i;
 
@@ -160,22 +149,8 @@ static void __init init_ISA_irqs (void)
 
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
@@ -203,6 +178,14 @@ void __init native_init_IRQ(void)
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
 
@@ -212,7 +195,23 @@ void __init native_init_IRQ(void)
 	/* IPI vectors for APIC spurious and error interrupts */
 	alloc_intr_gate(SPURIOUS_APIC_VECTOR, spurious_interrupt);
 	alloc_intr_gate(ERROR_APIC_VECTOR, error_interrupt);
+}
+
+void __init native_init_IRQ(void)
+{
+	int i;
+
+	pre_intr_init_hook();
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
 
-	if (!acpi_ioapic)
-		setup_irq(2, &irq2);
+	intr_init_hook();
 }
diff --git a/arch/x86/kernel/time_32.c b/arch/x86/kernel/time.c
similarity index 65%
rename from arch/x86/kernel/time_32.c
rename to arch/x86/kernel/time.c
index bbecf8b..9e6e5fb 100644
--- a/arch/x86/kernel/time_32.c
+++ b/arch/x86/kernel/time.c
@@ -1,5 +1,6 @@
 /*
  *  Copyright (C) 1991, 1992, 1995  Linus Torvalds
+ *  "High Precision Event Timer" based timekeeping.
  *
  * This file contains the PC-specific time handling details:
  * reading the RTC at bootup, etc..
@@ -26,17 +27,26 @@
  * 1998-12-24 Copyright (C) 1998  Andrea Arcangeli
  *	Fixed a xtime SMP race (we need the xtime_lock rw spinlock to
  *	serialize accesses to xtime/lost_ticks).
+ *
+ *  Copyright (c) 2002,2006  Vojtech Pavlik
+ *  Copyright (c) 2003  Andi Kleen
+ *  Copyright (c) 2008 Glauber Costa - i386/x86_64 integration.
+ *
+ *  RTC support code taken from arch/i386/kernel/timers/time_hpet.c
  */
 
+#include <linux/clockchips.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
+#include <linux/module.h>
 #include <linux/time.h>
 #include <linux/mca.h>
 
-#include <asm/arch_hooks.h>
 #include <asm/hpet.h>
+#include <asm/nmi.h>
 #include <asm/time.h>
 #include <asm/timer.h>
+#include <asm/arch_hooks.h>
 
 #include "do_timer.h"
 
@@ -47,12 +57,11 @@ unsigned long profile_pc(struct pt_regs *regs)
 	unsigned long pc = instruction_pointer(regs);
 
 #ifdef CONFIG_SMP
-	if (!v8086_mode(regs) && SEGMENT_IS_KERNEL_CODE(regs->cs) &&
-	    in_lock_functions(pc)) {
+	if (!user_mode_vm(regs) && in_lock_functions(pc)) {
 #ifdef CONFIG_FRAME_POINTER
-		return *(unsigned long *)(regs->bp + 4);
+		return *(unsigned long *)(regs->bp + sizeof(long));
 #else
-		unsigned long *sp = (unsigned long *)&regs->sp;
+		unsigned long *sp = (unsigned long *)regs->sp;
 
 		/* Return address is either directly at stack pointer
 		   or above a saved flags. Eflags has bits 22-31 zero,
@@ -75,8 +84,13 @@ EXPORT_SYMBOL(profile_pc);
  */
 irqreturn_t timer_interrupt(int irq, void *dev_id)
 {
+
+#ifdef CONFIG_X86_32
 	/* Keep nmi watchdog up to date */
 	per_cpu(irq_stat, smp_processor_id()).irq0_irqs++;
+#else
+	add_pda(irq0_irqs, 1);
+#endif
 
 #ifdef CONFIG_X86_IO_APIC
 	if (timer_ack) {
@@ -95,6 +109,7 @@ irqreturn_t timer_interrupt(int irq, void *dev_id)
 
 	do_timer_interrupt_hook();
 
+#ifdef CONFIG_MCA
 	if (MCA_bus) {
 		/* The PS/2 uses level-triggered interrupts.  You can't
 		turn them off, nor would you want to (any attempt to
@@ -105,13 +120,63 @@ irqreturn_t timer_interrupt(int irq, void *dev_id)
 		high bit of the PPI port B (0x61).  Note that some PS/2s,
 		notably the 55SX, work fine if this is removed.  */
 
-		u8 irq_v = inb_p( 0x61 );	/* read the current state */
-		outb_p( irq_v|0x80, 0x61 );	/* reset the IRQ */
+		u8 irq_v = inb_p(0x61);	/* read the current state */
+		outb_p(irq_v|0x80, 0x61);	/* reset the IRQ */
 	}
+#endif
 
 	return IRQ_HANDLED;
 }
 
+#ifdef CONFIG_X86_64
+volatile unsigned long __jiffies __section_jiffies = INITIAL_JIFFIES;
+/* calibrate_cpu is used on systems with fixed rate TSCs to determine
+ * processor frequency */
+#define TICK_COUNT 100000000
+unsigned long __init calibrate_cpu(void)
+{
+	int tsc_start, tsc_now;
+	int i, no_ctr_free;
+	unsigned long evntsel3 = 0, pmc3 = 0, pmc_now = 0;
+	unsigned long flags;
+
+	for (i = 0; i < 4; i++)
+		if (avail_to_resrv_perfctr_nmi_bit(i))
+			break;
+	no_ctr_free = (i == 4);
+	if (no_ctr_free) {
+		i = 3;
+		rdmsrl(MSR_K7_EVNTSEL3, evntsel3);
+		wrmsrl(MSR_K7_EVNTSEL3, 0);
+		rdmsrl(MSR_K7_PERFCTR3, pmc3);
+	} else {
+		reserve_perfctr_nmi(MSR_K7_PERFCTR0 + i);
+		reserve_evntsel_nmi(MSR_K7_EVNTSEL0 + i);
+	}
+	local_irq_save(flags);
+	/* start measuring cycles, incrementing from 0 */
+	wrmsrl(MSR_K7_PERFCTR0 + i, 0);
+	wrmsrl(MSR_K7_EVNTSEL0 + i, 1 << 22 | 3 << 16 | 0x76);
+	rdtscl(tsc_start);
+	do {
+		rdmsrl(MSR_K7_PERFCTR0 + i, pmc_now);
+		tsc_now = get_cycles();
+	} while ((tsc_now - tsc_start) < TICK_COUNT);
+
+	local_irq_restore(flags);
+	if (no_ctr_free) {
+		wrmsrl(MSR_K7_EVNTSEL3, 0);
+		wrmsrl(MSR_K7_PERFCTR3, pmc3);
+		wrmsrl(MSR_K7_EVNTSEL3, evntsel3);
+	} else {
+		release_perfctr_nmi(MSR_K7_PERFCTR0 + i);
+		release_evntsel_nmi(MSR_K7_EVNTSEL0 + i);
+	}
+
+	return pmc_now * tsc_khz / (tsc_now - tsc_start);
+}
+#endif
+
 /* Duplicate of time_init() below, with hpet_enable part added */
 void __init hpet_time_init(void)
 {
diff --git a/arch/x86/kernel/time_64.c b/arch/x86/kernel/time_64.c
deleted file mode 100644
index e3d49c5..0000000
--- a/arch/x86/kernel/time_64.c
+++ /dev/null
@@ -1,126 +0,0 @@
-/*
- *  "High Precision Event Timer" based timekeeping.
- *
- *  Copyright (c) 1991,1992,1995  Linus Torvalds
- *  Copyright (c) 1994  Alan Modra
- *  Copyright (c) 1995  Markus Kuhn
- *  Copyright (c) 1996  Ingo Molnar
- *  Copyright (c) 1998  Andrea Arcangeli
- *  Copyright (c) 2002,2006  Vojtech Pavlik
- *  Copyright (c) 2003  Andi Kleen
- *  RTC support code taken from arch/i386/kernel/timers/time_hpet.c
- */
-
-#include <linux/clockchips.h>
-#include <linux/init.h>
-#include <linux/interrupt.h>
-#include <linux/module.h>
-#include <linux/time.h>
-
-#include <asm/i8253.h>
-#include <asm/hpet.h>
-#include <asm/nmi.h>
-#include <asm/vgtod.h>
-#include <asm/time.h>
-#include <asm/timer.h>
-
-volatile unsigned long __jiffies __section_jiffies = INITIAL_JIFFIES;
-
-unsigned long profile_pc(struct pt_regs *regs)
-{
-	unsigned long pc = instruction_pointer(regs);
-
-	/* Assume the lock function has either no stack frame or a copy
-	   of flags from PUSHF
-	   Eflags always has bits 22 and up cleared unlike kernel addresses. */
-	if (!user_mode(regs) && in_lock_functions(pc)) {
-		unsigned long *sp = (unsigned long *)regs->sp;
-		if (sp[0] >> 22)
-			return sp[0];
-		if (sp[1] >> 22)
-			return sp[1];
-	}
-	return pc;
-}
-EXPORT_SYMBOL(profile_pc);
-
-static irqreturn_t timer_event_interrupt(int irq, void *dev_id)
-{
-	add_pda(irq0_irqs, 1);
-
-	global_clock_event->event_handler(global_clock_event);
-
-	return IRQ_HANDLED;
-}
-
-/* calibrate_cpu is used on systems with fixed rate TSCs to determine
- * processor frequency */
-#define TICK_COUNT 100000000
-unsigned long __init calibrate_cpu(void)
-{
-	int tsc_start, tsc_now;
-	int i, no_ctr_free;
-	unsigned long evntsel3 = 0, pmc3 = 0, pmc_now = 0;
-	unsigned long flags;
-
-	for (i = 0; i < 4; i++)
-		if (avail_to_resrv_perfctr_nmi_bit(i))
-			break;
-	no_ctr_free = (i == 4);
-	if (no_ctr_free) {
-		i = 3;
-		rdmsrl(MSR_K7_EVNTSEL3, evntsel3);
-		wrmsrl(MSR_K7_EVNTSEL3, 0);
-		rdmsrl(MSR_K7_PERFCTR3, pmc3);
-	} else {
-		reserve_perfctr_nmi(MSR_K7_PERFCTR0 + i);
-		reserve_evntsel_nmi(MSR_K7_EVNTSEL0 + i);
-	}
-	local_irq_save(flags);
-	/* start measuring cycles, incrementing from 0 */
-	wrmsrl(MSR_K7_PERFCTR0 + i, 0);
-	wrmsrl(MSR_K7_EVNTSEL0 + i, 1 << 22 | 3 << 16 | 0x76);
-	rdtscl(tsc_start);
-	do {
-		rdmsrl(MSR_K7_PERFCTR0 + i, pmc_now);
-		tsc_now = get_cycles();
-	} while ((tsc_now - tsc_start) < TICK_COUNT);
-
-	local_irq_restore(flags);
-	if (no_ctr_free) {
-		wrmsrl(MSR_K7_EVNTSEL3, 0);
-		wrmsrl(MSR_K7_PERFCTR3, pmc3);
-		wrmsrl(MSR_K7_EVNTSEL3, evntsel3);
-	} else {
-		release_perfctr_nmi(MSR_K7_PERFCTR0 + i);
-		release_evntsel_nmi(MSR_K7_EVNTSEL0 + i);
-	}
-
-	return pmc_now * tsc_khz / (tsc_now - tsc_start);
-}
-
-static struct irqaction irq0 = {
-	.handler	= timer_event_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_IRQPOLL | IRQF_NOBALANCING,
-	.mask		= CPU_MASK_NONE,
-	.name		= "timer"
-};
-
-void __init hpet_time_init(void)
-{
-	if (!hpet_enable())
-		setup_pit_timer();
-
-	setup_irq(0, &irq0);
-}
-
-void __init time_init(void)
-{
-	tsc_init();
-	if (cpu_has(&boot_cpu_data, X86_FEATURE_RDTSCP))
-		vgetcpu_mode = VGETCPU_RDTSCP;
-	else
-		vgetcpu_mode = VGETCPU_LSL;
-
-	late_time_init = choose_time_init();
-}
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
 
diff --git a/include/asm-x86/timer.h b/include/asm-x86/timer.h
index d0babce..013b2b8 100644
--- a/include/asm-x86/timer.h
+++ b/include/asm-x86/timer.h
@@ -10,10 +10,10 @@ unsigned long long native_sched_clock(void);
 unsigned long native_calibrate_tsc(void);
 
 #ifdef CONFIG_X86_32
-extern int timer_ack;
 extern int recalibrate_cpu_khz(void);
 #endif /* CONFIG_X86_32 */
 
+extern int timer_ack;
 extern int no_timer_check;
 
 #ifndef CONFIG_PARAVIRT
