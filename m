Return-Path: <linux-kernel-owner+w=401wt.eu-S933053AbZHUVeF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933053AbZHUVeF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 17:34:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933050AbZHUVeC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 17:34:02 -0400
Received: from www.tglx.de ([62.245.132.106]:52015 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932988AbZHUVd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 17:33:59 -0400
Message-Id: <20090821205603.221997437@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 21 Aug 2009 21:32:07 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: x86 team <x86@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>, Avi Kivity <avi@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alok N Kataria <akataria@vmware.com>,
       Pan Jacob jun <jacob.jun.pan@intel.com>
Subject: [RFC patch 29/32] x86: Replace the now identical time_32/64.c by
	time.c
References: <20090821205008.518392436@linutronix.de>
Content-Disposition: inline; filename=x86-remove-the-redundant-copy.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the redundant copy.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/Makefile  |    2 
 arch/x86/kernel/time.c    |  120 ++++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/time_32.c |  120 ----------------------------------------------
 arch/x86/kernel/time_64.c |  120 ----------------------------------------------
 4 files changed, 121 insertions(+), 241 deletions(-)

Index: linux-2.6/arch/x86/kernel/Makefile
===================================================================
--- linux-2.6.orig/arch/x86/kernel/Makefile
+++ linux-2.6/arch/x86/kernel/Makefile
@@ -31,7 +31,7 @@ GCOV_PROFILE_paravirt.o		:= n
 
 obj-y			:= process_$(BITS).o signal.o entry_$(BITS).o
 obj-y			+= traps.o irq.o irq_$(BITS).o dumpstack_$(BITS).o
-obj-y			+= time_$(BITS).o ioport.o ldt.o dumpstack.o
+obj-y			+= time.o ioport.o ldt.o dumpstack.o
 obj-y			+= setup.o platform_setup.o i8259.o irqinit.o
 obj-$(CONFIG_X86_VISWS)	+= visws_quirks.o
 obj-$(CONFIG_X86_32)	+= probe_roms_32.o
Index: linux-2.6/arch/x86/kernel/time.c
===================================================================
--- /dev/null
+++ linux-2.6/arch/x86/kernel/time.c
@@ -0,0 +1,120 @@
+/*
+ *  Copyright (c) 1991,1992,1995  Linus Torvalds
+ *  Copyright (c) 1994  Alan Modra
+ *  Copyright (c) 1995  Markus Kuhn
+ *  Copyright (c) 1996  Ingo Molnar
+ *  Copyright (c) 1998  Andrea Arcangeli
+ *  Copyright (c) 2002,2006  Vojtech Pavlik
+ *  Copyright (c) 2003  Andi Kleen
+ *
+ */
+
+#include <linux/clockchips.h>
+#include <linux/interrupt.h>
+#include <linux/time.h>
+#include <linux/mca.h>
+
+#include <asm/platform.h>
+#include <asm/i8259.h>
+#include <asm/i8253.h>
+#include <asm/timer.h>
+#include <asm/hpet.h>
+#include <asm/time.h>
+
+#if defined(CONFIG_X86_32) && defined(CONFIG_X86_IO_APIC)
+int timer_ack;
+#endif
+
+#ifdef CONFIG_X86_64
+volatile unsigned long __jiffies __section_jiffies = INITIAL_JIFFIES;
+#endif
+
+unsigned long profile_pc(struct pt_regs *regs)
+{
+	unsigned long pc = instruction_pointer(regs);
+
+	if (!user_mode_vm(regs) && in_lock_functions(pc)) {
+#ifdef CONFIG_FRAME_POINTER
+		return *(unsigned long *)(regs->bp + sizeof(long));
+#else
+		unsigned long *sp = (unsigned long *)regs->sp;
+		/*
+		 * Return address is either directly at stack pointer
+		 * or above a saved flags. Eflags has bits 22-31 zero,
+		 * kernel addresses don't.
+		 */
+		if (sp[0] >> 22)
+			return sp[0];
+		if (sp[1] >> 22)
+			return sp[1];
+#endif
+	}
+	return pc;
+}
+EXPORT_SYMBOL(profile_pc);
+
+/*
+ * Default timer interrupt handler for PIT/HPET
+ */
+static irqreturn_t timer_interrupt(int irq, void *dev_id)
+{
+	/* Keep nmi watchdog up to date */
+	inc_irq_stat(irq0_irqs);
+
+	/* Optimized out for !IO_APIC and x86_64 */
+	if (timer_ack) {
+		/*
+		 * Subtle, when I/O APICs are used we have to ack timer IRQ
+		 * manually to deassert NMI lines for the watchdog if run
+		 * on an 82489DX-based system.
+		 */
+		spin_lock(&i8259A_lock);
+		outb(0x0c, PIC_MASTER_OCW3);
+		/* Ack the IRQ; AEOI will end it automatically. */
+		inb(PIC_MASTER_POLL);
+		spin_unlock(&i8259A_lock);
+	}
+
+	global_clock_event->event_handler(global_clock_event);
+
+	/* MCA bus quirk: Acknowledge irq0 by setting bit 7 in port 0x61 */
+	if (MCA_bus)
+		outb_p(inb_p(0x61)| 0x80, 0x61);
+
+	return IRQ_HANDLED;
+}
+
+static struct irqaction irq0  = {
+	.handler = timer_interrupt,
+	.flags = IRQF_DISABLED | IRQF_NOBALANCING | IRQF_IRQPOLL | IRQF_TIMER,
+	.name = "timer"
+};
+
+void __init setup_default_timer_irq(void)
+{
+	irq0.mask = cpumask_of_cpu(0);
+	setup_irq(0, &irq0);
+}
+
+/* Default timer init function */
+void __init hpet_time_init(void)
+{
+	if (!hpet_enable())
+		setup_pit_timer();
+	setup_default_timer_irq();
+}
+
+static void x86_late_time_init(void)
+{
+	platform_setup.timers.timer_init();
+}
+
+/*
+ * Initialize TSC and delay the periodic timer init to
+ * late x86_late_time_init() so ioremap works.
+ */
+void __init time_init(void)
+{
+	tsc_init();
+	late_time_init = x86_late_time_init;
+}
Index: linux-2.6/arch/x86/kernel/time_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/time_32.c
+++ /dev/null
@@ -1,120 +0,0 @@
-/*
- *  Copyright (c) 1991,1992,1995  Linus Torvalds
- *  Copyright (c) 1994  Alan Modra
- *  Copyright (c) 1995  Markus Kuhn
- *  Copyright (c) 1996  Ingo Molnar
- *  Copyright (c) 1998  Andrea Arcangeli
- *  Copyright (c) 2002,2006  Vojtech Pavlik
- *  Copyright (c) 2003  Andi Kleen
- *
- */
-
-#include <linux/clockchips.h>
-#include <linux/interrupt.h>
-#include <linux/time.h>
-#include <linux/mca.h>
-
-#include <asm/platform.h>
-#include <asm/i8259.h>
-#include <asm/i8253.h>
-#include <asm/timer.h>
-#include <asm/hpet.h>
-#include <asm/time.h>
-
-#if defined(CONFIG_X86_32) && defined(CONFIG_X86_IO_APIC)
-int timer_ack;
-#endif
-
-#ifdef CONFIG_X86_64
-volatile unsigned long __jiffies __section_jiffies = INITIAL_JIFFIES;
-#endif
-
-unsigned long profile_pc(struct pt_regs *regs)
-{
-	unsigned long pc = instruction_pointer(regs);
-
-	if (!user_mode_vm(regs) && in_lock_functions(pc)) {
-#ifdef CONFIG_FRAME_POINTER
-		return *(unsigned long *)(regs->bp + sizeof(long));
-#else
-		unsigned long *sp = (unsigned long *)regs->sp;
-		/*
-		 * Return address is either directly at stack pointer
-		 * or above a saved flags. Eflags has bits 22-31 zero,
-		 * kernel addresses don't.
-		 */
-		if (sp[0] >> 22)
-			return sp[0];
-		if (sp[1] >> 22)
-			return sp[1];
-#endif
-	}
-	return pc;
-}
-EXPORT_SYMBOL(profile_pc);
-
-/*
- * Default timer interrupt handler for PIT/HPET
- */
-static irqreturn_t timer_interrupt(int irq, void *dev_id)
-{
-	/* Keep nmi watchdog up to date */
-	inc_irq_stat(irq0_irqs);
-
-	/* Optimized out for !IO_APIC and x86_64 */
-	if (timer_ack) {
-		/*
-		 * Subtle, when I/O APICs are used we have to ack timer IRQ
-		 * manually to deassert NMI lines for the watchdog if run
-		 * on an 82489DX-based system.
-		 */
-		spin_lock(&i8259A_lock);
-		outb(0x0c, PIC_MASTER_OCW3);
-		/* Ack the IRQ; AEOI will end it automatically. */
-		inb(PIC_MASTER_POLL);
-		spin_unlock(&i8259A_lock);
-	}
-
-	global_clock_event->event_handler(global_clock_event);
-
-	/* MCA bus quirk: Acknowledge irq0 by setting bit 7 in port 0x61 */
-	if (MCA_bus)
-		outb_p(inb_p(0x61)| 0x80, 0x61);
-
-	return IRQ_HANDLED;
-}
-
-static struct irqaction irq0  = {
-	.handler = timer_interrupt,
-	.flags = IRQF_DISABLED | IRQF_NOBALANCING | IRQF_IRQPOLL | IRQF_TIMER,
-	.name = "timer"
-};
-
-void __init setup_default_timer_irq(void)
-{
-	irq0.mask = cpumask_of_cpu(0);
-	setup_irq(0, &irq0);
-}
-
-/* Default timer init function */
-void __init hpet_time_init(void)
-{
-	if (!hpet_enable())
-		setup_pit_timer();
-	setup_default_timer_irq();
-}
-
-static void x86_late_time_init(void)
-{
-	platform_setup.timers.timer_init();
-}
-
-/*
- * Initialize TSC and delay the periodic timer init to
- * late x86_late_time_init() so ioremap works.
- */
-void __init time_init(void)
-{
-	tsc_init();
-	late_time_init = x86_late_time_init;
-}
Index: linux-2.6/arch/x86/kernel/time_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/time_64.c
+++ /dev/null
@@ -1,120 +0,0 @@
-/*
- *  Copyright (c) 1991,1992,1995  Linus Torvalds
- *  Copyright (c) 1994  Alan Modra
- *  Copyright (c) 1995  Markus Kuhn
- *  Copyright (c) 1996  Ingo Molnar
- *  Copyright (c) 1998  Andrea Arcangeli
- *  Copyright (c) 2002,2006  Vojtech Pavlik
- *  Copyright (c) 2003  Andi Kleen
- *
- */
-
-#include <linux/clockchips.h>
-#include <linux/interrupt.h>
-#include <linux/time.h>
-#include <linux/mca.h>
-
-#include <asm/platform.h>
-#include <asm/i8259.h>
-#include <asm/i8253.h>
-#include <asm/timer.h>
-#include <asm/hpet.h>
-#include <asm/time.h>
-
-#if defined(CONFIG_X86_32) && defined(CONFIG_X86_IO_APIC)
-int timer_ack;
-#endif
-
-#ifdef CONFIG_X86_64
-volatile unsigned long __jiffies __section_jiffies = INITIAL_JIFFIES;
-#endif
-
-unsigned long profile_pc(struct pt_regs *regs)
-{
-	unsigned long pc = instruction_pointer(regs);
-
-	if (!user_mode_vm(regs) && in_lock_functions(pc)) {
-#ifdef CONFIG_FRAME_POINTER
-		return *(unsigned long *)(regs->bp + sizeof(long));
-#else
-		unsigned long *sp = (unsigned long *)regs->sp;
-		/*
-		 * Return address is either directly at stack pointer
-		 * or above a saved flags. Eflags has bits 22-31 zero,
-		 * kernel addresses don't.
-		 */
-		if (sp[0] >> 22)
-			return sp[0];
-		if (sp[1] >> 22)
-			return sp[1];
-#endif
-	}
-	return pc;
-}
-EXPORT_SYMBOL(profile_pc);
-
-/*
- * Default timer interrupt handler for PIT/HPET
- */
-static irqreturn_t timer_interrupt(int irq, void *dev_id)
-{
-	/* Keep nmi watchdog up to date */
-	inc_irq_stat(irq0_irqs);
-
-	/* Optimized out for !IO_APIC and x86_64 */
-	if (timer_ack) {
-		/*
-		 * Subtle, when I/O APICs are used we have to ack timer IRQ
-		 * manually to deassert NMI lines for the watchdog if run
-		 * on an 82489DX-based system.
-		 */
-		spin_lock(&i8259A_lock);
-		outb(0x0c, PIC_MASTER_OCW3);
-		/* Ack the IRQ; AEOI will end it automatically. */
-		inb(PIC_MASTER_POLL);
-		spin_unlock(&i8259A_lock);
-	}
-
-	global_clock_event->event_handler(global_clock_event);
-
-	/* MCA bus quirk: Acknowledge irq0 by setting bit 7 in port 0x61 */
-	if (MCA_bus)
-		outb_p(inb_p(0x61)| 0x80, 0x61);
-
-	return IRQ_HANDLED;
-}
-
-static struct irqaction irq0  = {
-	.handler = timer_interrupt,
-	.flags = IRQF_DISABLED | IRQF_NOBALANCING | IRQF_IRQPOLL | IRQF_TIMER,
-	.name = "timer"
-};
-
-void __init setup_default_timer_irq(void)
-{
-	irq0.mask = cpumask_of_cpu(0);
-	setup_irq(0, &irq0);
-}
-
-/* Default timer init function */
-void __init hpet_time_init(void)
-{
-	if (!hpet_enable())
-		setup_pit_timer();
-	setup_default_timer_irq();
-}
-
-static void x86_late_time_init(void)
-{
-	platform_setup.timers.timer_init();
-}
-
-/*
- * Initialize TSC and delay the periodic timer init to
- * late x86_late_time_init() so ioremap works.
- */
-void __init time_init(void)
-{
-	tsc_init();
-	late_time_init = x86_late_time_init;
-}


