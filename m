Return-Path: <linux-kernel-owner+w=401wt.eu-S933072AbZHUVfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933072AbZHUVfX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 17:35:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933024AbZHUVdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 17:33:20 -0400
Received: from www.tglx.de ([62.245.132.106]:51913 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932934AbZHUVdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 17:33:17 -0400
Message-Id: <20090821205602.954426816@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 21 Aug 2009 21:31:39 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: x86 team <x86@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>, Avi Kivity <avi@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alok N Kataria <akataria@vmware.com>,
       Pan Jacob jun <jacob.jun.pan@intel.com>
Subject: [RFC patch 24/32] x86: Simplify timer_ack magic in time_32.c
References: <20090821205008.518392436@linutronix.de>
Content-Disposition: inline; filename=x86-simplify-timer-ack-hack.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let the compiler optimize the timer_ack magic away in the 32bit timer
interrupt and put the same code into time_64.c. It's optimized out for
CONFIG_X86_IO_APIC on 32bit and for 64bit because timer_ack is const 0
in both cases.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/timer.h |    6 ++++--
 arch/x86/kernel/time_32.c    |    5 +++--
 arch/x86/kernel/time_64.c    |   14 ++++++++++++++
 3 files changed, 21 insertions(+), 4 deletions(-)

Index: linux-2.6/arch/x86/include/asm/timer.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/timer.h
+++ linux-2.6/arch/x86/include/asm/timer.h
@@ -9,11 +9,13 @@
 
 unsigned long long native_sched_clock(void);
 unsigned long native_calibrate_tsc(void);
+extern int recalibrate_cpu_khz(void);
 
-#ifdef CONFIG_X86_32
+#if defined(CONFIG_X86_32) && defined(CONFIG_X86_IO_APIC)
 extern int timer_ack;
+#else
+# define timer_ack (0)
 #endif
-extern int recalibrate_cpu_khz(void);
 
 extern int no_timer_check;
 
Index: linux-2.6/arch/x86/kernel/time_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/time_32.c
+++ linux-2.6/arch/x86/kernel/time_32.c
@@ -22,7 +22,9 @@
 #include <asm/time.h>
 #include <asm/nmi.h>
 
+#if defined(CONFIG_X86_32) && defined(CONFIG_X86_IO_APIC)
 int timer_ack;
+#endif
 
 unsigned long profile_pc(struct pt_regs *regs)
 {
@@ -59,7 +61,7 @@ static irqreturn_t timer_interrupt(int i
 	/* Keep nmi watchdog up to date */
 	inc_irq_stat(irq0_irqs);
 
-#ifdef CONFIG_X86_IO_APIC
+	/* Optimized out for !IO_APIC and x86_64 */
 	if (timer_ack) {
 		/*
 		 * Subtle, when I/O APICs are used we have to ack timer IRQ
@@ -72,7 +74,6 @@ static irqreturn_t timer_interrupt(int i
 		inb(PIC_MASTER_POLL);
 		spin_unlock(&i8259A_lock);
 	}
-#endif
 
 	global_clock_event->event_handler(global_clock_event);
 
Index: linux-2.6/arch/x86/kernel/time_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/time_64.c
+++ linux-2.6/arch/x86/kernel/time_64.c
@@ -50,6 +50,20 @@ static irqreturn_t timer_interrupt(int i
 {
 	inc_irq_stat(irq0_irqs);
 
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
 	global_clock_event->event_handler(global_clock_event);
 
 #ifdef CONFIG_MCA


