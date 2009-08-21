Return-Path: <linux-kernel-owner+w=401wt.eu-S933038AbZHUVd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933038AbZHUVd2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 17:33:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932966AbZHUVd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 17:33:26 -0400
Received: from www.tglx.de ([62.245.132.106]:51927 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933028AbZHUVdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 17:33:22 -0400
Message-Id: <20090821205603.064905105@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 21 Aug 2009 21:31:50 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: x86 team <x86@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>, Avi Kivity <avi@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alok N Kataria <akataria@vmware.com>,
       Pan Jacob jun <jacob.jun.pan@intel.com>
Subject: [RFC patch 26/32] x86: Make timer setup and global variables the same
	in time_32/64.c
References: <20090821205008.518392436@linutronix.de>
Content-Disposition: inline; filename=x86-time-unify-some-more.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The timer and timer irq setup code is identical in 32 and 64 bit. Make
it the same formatting as well. Also add the global variables under
the necessary ifdefs to both files.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/time_32.c |    8 +++++---
 arch/x86/kernel/time_64.c |   38 ++++++++++++++++++++++++++++++--------
 2 files changed, 35 insertions(+), 11 deletions(-)

Index: linux-2.6/arch/x86/kernel/time_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/time_32.c
+++ linux-2.6/arch/x86/kernel/time_32.c
@@ -26,6 +26,10 @@
 int timer_ack;
 #endif
 
+#ifdef CONFIG_X86_64
+volatile unsigned long __jiffies __section_jiffies = INITIAL_JIFFIES;
+#endif
+
 unsigned long profile_pc(struct pt_regs *regs)
 {
 	unsigned long pc = instruction_pointer(regs);
@@ -52,9 +56,7 @@ unsigned long profile_pc(struct pt_regs 
 EXPORT_SYMBOL(profile_pc);
 
 /*
- * This is the same as the above, except we _also_ save the current
- * Time Stamp Counter value at the time of the timer interrupt, so that
- * we later on can estimate the time of day more exactly.
+ * Default timer interrupt handler for PIT/HPET
  */
 static irqreturn_t timer_interrupt(int irq, void *dev_id)
 {
Index: linux-2.6/arch/x86/kernel/time_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/time_64.c
+++ linux-2.6/arch/x86/kernel/time_64.c
@@ -22,7 +22,13 @@
 #include <asm/time.h>
 #include <asm/nmi.h>
 
+#if defined(CONFIG_X86_32) && defined(CONFIG_X86_IO_APIC)
+int timer_ack;
+#endif
+
+#ifdef CONFIG_X86_64
 volatile unsigned long __jiffies __section_jiffies = INITIAL_JIFFIES;
+#endif
 
 unsigned long profile_pc(struct pt_regs *regs)
 {
@@ -46,8 +52,12 @@ unsigned long profile_pc(struct pt_regs 
 }
 EXPORT_SYMBOL(profile_pc);
 
+/*
+ * Default timer interrupt handler for PIT/HPET
+ */
 static irqreturn_t timer_interrupt(int irq, void *dev_id)
 {
+	/* Keep nmi watchdog up to date */
 	inc_irq_stat(irq0_irqs);
 
 	/* Optimized out for !IO_APIC and x86_64 */
@@ -73,8 +83,10 @@ static irqreturn_t timer_interrupt(int i
 	return IRQ_HANDLED;
 }
 
-/* calibrate_cpu is used on systems with fixed rate TSCs to determine
- * processor frequency */
+/*
+ * calibrate_cpu is used on systems with fixed rate TSCs to determine
+ * processor frequency
+ */
 #define TICK_COUNT 100000000
 unsigned long __init calibrate_cpu(void)
 {
@@ -121,18 +133,24 @@ unsigned long __init calibrate_cpu(void)
 	return pmc_now * tsc_khz / (tsc_now - tsc_start);
 }
 
-static struct irqaction irq0 = {
-	.handler	= timer_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_IRQPOLL | IRQF_NOBALANCING | IRQF_TIMER,
-	.name		= "timer"
+static struct irqaction irq0  = {
+	.handler = timer_interrupt,
+	.flags = IRQF_DISABLED | IRQF_NOBALANCING | IRQF_IRQPOLL | IRQF_TIMER,
+	.name = "timer"
 };
 
+void __init setup_default_timer_irq(void)
+{
+	irq0.mask = cpumask_of_cpu(0);
+	setup_irq(0, &irq0);
+}
+
+/* Default timer init function */
 void __init hpet_time_init(void)
 {
 	if (!hpet_enable())
 		setup_pit_timer();
-
-	setup_irq(0, &irq0);
+	setup_default_timer_irq();
 }
 
 static void x86_late_time_init(void)
@@ -140,6 +158,10 @@ static void x86_late_time_init(void)
 	platform_setup.timers.timer_init();
 }
 
+/*
+ * Initialize TSC and delay the periodic timer init to
+ * late x86_late_time_init() so ioremap works.
+ */
 void __init time_init(void)
 {
 	tsc_init();


