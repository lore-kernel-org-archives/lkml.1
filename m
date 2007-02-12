Return-Path: <linux-kernel-owner+w=401wt.eu-S933078AbXBLHut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933078AbXBLHut (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 02:50:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933076AbXBLHuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 02:50:14 -0500
Received: from ns.suse.de ([195.135.220.2]:38361 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933075AbXBLHhw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 02:37:52 -0500
From: Andi Kleen <ak@suse.de>
References: <20070212837.963446000@suse.de>
In-Reply-To: <20070212837.963446000@suse.de>
To: Stephane Eranian <eranian@hpl.hp.com>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH x86 for review II] [4/39] i386: add idle notifier
Message-Id: <20070212073750.3DBD013D7F@wotan.suse.de>
Date: Mon, 12 Feb 2007 08:37:50 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Stephane Eranian <eranian@hpl.hp.com>

Add a notifier mechanism to the low level idle loop.  You can register a
callback function which gets invoked on entry and exit from the low level idle
loop.  The low level idle loop is defined as the polling loop, low-power call,
or the mwait instruction.  Interrupts processed by the idle thread are not
considered part of the low level loop.

The notifier can be used to measure precisely how much is spent in useless
execution (or low power mode).  The perfmon subsystem uses it to turn on/off
monitoring.

Signed-off-by: stephane eranian <eranian@hpl.hp.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/i386/kernel/apic.c          |    4 ++
 arch/i386/kernel/cpu/mcheck/p4.c |    2 +
 arch/i386/kernel/irq.c           |    3 ++
 arch/i386/kernel/process.c       |   53 ++++++++++++++++++++++++++++++++++++++-
 arch/i386/kernel/smp.c           |    2 +
 include/asm-i386/idle.h          |   14 ++++++++++
 include/asm-i386/processor.h     |    8 +++++
 7 files changed, 85 insertions(+), 1 deletion(-)

Index: linux/arch/i386/kernel/apic.c
===================================================================
--- linux.orig/arch/i386/kernel/apic.c
+++ linux/arch/i386/kernel/apic.c
@@ -36,6 +36,7 @@
 #include <asm/hpet.h>
 #include <asm/i8253.h>
 #include <asm/nmi.h>
+#include <asm/idle.h>
 
 #include <mach_apic.h>
 #include <mach_apicdef.h>
@@ -1255,6 +1256,7 @@ fastcall void smp_apic_timer_interrupt(s
 	 * Besides, if we don't timer interrupts ignore the global
 	 * interrupt lock, which is the WrongThing (tm) to do.
 	 */
+	exit_idle();
 	irq_enter();
 	smp_local_timer_interrupt();
 	irq_exit();
@@ -1305,6 +1307,7 @@ fastcall void smp_spurious_interrupt(str
 {
 	unsigned long v;
 
+	exit_idle();
 	irq_enter();
 	/*
 	 * Check if this really is a spurious interrupt and ACK it
@@ -1329,6 +1332,7 @@ fastcall void smp_error_interrupt(struct
 {
 	unsigned long v, v1;
 
+	exit_idle();
 	irq_enter();
 	/* First tickle the hardware, only then report what went on. -- REW */
 	v = apic_read(APIC_ESR);
Index: linux/arch/i386/kernel/cpu/mcheck/p4.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/mcheck/p4.c
+++ linux/arch/i386/kernel/cpu/mcheck/p4.c
@@ -12,6 +12,7 @@
 #include <asm/system.h>
 #include <asm/msr.h>
 #include <asm/apic.h>
+#include <asm/idle.h>
 
 #include <asm/therm_throt.h>
 
@@ -59,6 +60,7 @@ static void (*vendor_thermal_interrupt)(
 
 fastcall void smp_thermal_interrupt(struct pt_regs *regs)
 {
+	exit_idle();
 	irq_enter();
 	vendor_thermal_interrupt(regs);
 	irq_exit();
Index: linux/arch/i386/kernel/irq.c
===================================================================
--- linux.orig/arch/i386/kernel/irq.c
+++ linux/arch/i386/kernel/irq.c
@@ -19,6 +19,8 @@
 #include <linux/cpu.h>
 #include <linux/delay.h>
 
+#include <asm/idle.h>
+
 DEFINE_PER_CPU(irq_cpustat_t, irq_stat) ____cacheline_internodealigned_in_smp;
 EXPORT_PER_CPU_SYMBOL(irq_stat);
 
@@ -61,6 +63,7 @@ fastcall unsigned int do_IRQ(struct pt_r
 	union irq_ctx *curctx, *irqctx;
 	u32 *isp;
 #endif
+	exit_idle();
 
 	if (unlikely((unsigned)irq >= NR_IRQS)) {
 		printk(KERN_EMERG "%s: cannot handle IRQ %d\n",
Index: linux/arch/i386/kernel/process.c
===================================================================
--- linux.orig/arch/i386/kernel/process.c
+++ linux/arch/i386/kernel/process.c
@@ -48,6 +48,7 @@
 #include <asm/i387.h>
 #include <asm/desc.h>
 #include <asm/vm86.h>
+#include <asm/idle.h>
 #ifdef CONFIG_MATH_EMULATION
 #include <asm/math_emu.h>
 #endif
@@ -80,6 +81,42 @@ void (*pm_idle)(void);
 EXPORT_SYMBOL(pm_idle);
 static DEFINE_PER_CPU(unsigned int, cpu_idle_state);
 
+static ATOMIC_NOTIFIER_HEAD(idle_notifier);
+
+void idle_notifier_register(struct notifier_block *n)
+{
+	atomic_notifier_chain_register(&idle_notifier, n);
+}
+
+void idle_notifier_unregister(struct notifier_block *n)
+{
+	atomic_notifier_chain_unregister(&idle_notifier, n);
+}
+
+static DEFINE_PER_CPU(volatile unsigned long, idle_state);
+
+void enter_idle(void)
+{
+	/* needs to be atomic w.r.t. interrupts, not against other CPUs */
+	__set_bit(0, &__get_cpu_var(idle_state));
+	atomic_notifier_call_chain(&idle_notifier, IDLE_START, NULL);
+}
+
+static void __exit_idle(void)
+{
+	/* needs to be atomic w.r.t. interrupts, not against other CPUs */
+	if (__test_and_clear_bit(0, &__get_cpu_var(idle_state)) == 0)
+		return;
+	atomic_notifier_call_chain(&idle_notifier, IDLE_END, NULL);
+}
+
+void exit_idle(void)
+{
+	if (current->pid)
+		return;
+	__exit_idle();
+}
+
 void disable_hlt(void)
 {
 	hlt_counter++;
@@ -130,6 +167,7 @@ EXPORT_SYMBOL(default_idle);
  */
 static void poll_idle (void)
 {
+	local_irq_enable();
 	cpu_relax();
 }
 
@@ -189,7 +227,16 @@ void cpu_idle(void)
 				play_dead();
 
 			__get_cpu_var(irq_stat).idle_timestamp = jiffies;
+
+			/*
+			 * Idle routines should keep interrupts disabled
+			 * from here on, until they go to idle.
+			 * Otherwise, idle callbacks can misfire.
+			 */
+			local_irq_disable();
+			enter_idle();
 			idle();
+			__exit_idle();
 		}
 		preempt_enable_no_resched();
 		schedule();
@@ -243,7 +290,11 @@ void mwait_idle_with_hints(unsigned long
 		__monitor((void *)&current_thread_info()->flags, 0, 0);
 		smp_mb();
 		if (!need_resched())
-			__mwait(eax, ecx);
+			__sti_mwait(eax, ecx);
+		else
+			local_irq_enable();
+	} else {
+		local_irq_enable();
 	}
 }
 
Index: linux/arch/i386/kernel/smp.c
===================================================================
--- linux.orig/arch/i386/kernel/smp.c
+++ linux/arch/i386/kernel/smp.c
@@ -23,6 +23,7 @@
 
 #include <asm/mtrr.h>
 #include <asm/tlbflush.h>
+#include <asm/idle.h>
 #include <mach_apic.h>
 
 /*
@@ -624,6 +625,7 @@ fastcall void smp_call_function_interrup
 	/*
 	 * At this point the info structure may be out of scope unless wait==1
 	 */
+	exit_idle();
 	irq_enter();
 	(*func)(info);
 	irq_exit();
Index: linux/include/asm-i386/idle.h
===================================================================
--- /dev/null
+++ linux/include/asm-i386/idle.h
@@ -0,0 +1,14 @@
+#ifndef _ASM_I386_IDLE_H
+#define _ASM_I386_IDLE_H 1
+
+#define IDLE_START 1
+#define IDLE_END 2
+
+struct notifier_block;
+void idle_notifier_register(struct notifier_block *n);
+void idle_notifier_unregister(struct notifier_block *n);
+
+void exit_idle(void);
+void enter_idle(void);
+
+#endif
Index: linux/include/asm-i386/processor.h
===================================================================
--- linux.orig/include/asm-i386/processor.h
+++ linux/include/asm-i386/processor.h
@@ -257,6 +257,14 @@ static inline void __mwait(unsigned long
 		: :"a" (eax), "c" (ecx));
 }
 
+static inline void __sti_mwait(unsigned long eax, unsigned long ecx)
+{
+	/* "mwait %eax,%ecx;" */
+	asm volatile(
+		"sti; .byte 0x0f,0x01,0xc9;"
+		: :"a" (eax), "c" (ecx));
+}
+
 extern void mwait_idle_with_hints(unsigned long eax, unsigned long ecx);
 
 /* from system description table in BIOS.  Mostly for MCA use, but
