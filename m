Return-Path: <linux-kernel-owner+w=401wt.eu-S1759205AbXEQRlK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759205AbXEQRlK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 13:41:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756165AbXEQRk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 13:40:57 -0400
Received: from h155.mvista.com ([63.81.120.155]:24894 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756111AbXEQRk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 13:40:56 -0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
To: tglx@linutronix.de, mingo@elte.hu
Subject: [PATCH 2.6.21-rt2] PowerPC: decrementer clockevent driver
Date: Thu, 17 May 2007 21:42:26 +0400
User-Agent: KMail/1.5
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200705172142.26739.sshtylyov@ru.mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add PowerPC decrementer clock event driver.

Every effort has been made to support the different implementations of the
decrementer: the classic one (with 970 series variation), 40x and Book E
specific ones.

I had to make CONFIG_GENERIC_CLOCKEVENTS option selectable for the
compatibility reasons -- this option is not compatible with the PPC64
deterministic time accounting.

Thanks to Daniel Walker and Thomas Gleixner for the suggestions they made...

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

---
This patch has been reworked against the 2.6.21 clockevents framework.
It has only been tested on the Book E 32-bit CPU this time, so re-testing on
"classic" PowerPC CPUs is needed (used to work as of 2.6.18-rt7)...

CONFIG_PPC_MULTIPLATFORM was the best option I was able to come up with
to cover machines built on 970 series CPUs...

 arch/powerpc/Kconfig       |   12 +++-
 arch/powerpc/kernel/time.c |  124 ++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 134 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/powerpc/Kconfig
===================================================================
--- linux-2.6.orig/arch/powerpc/Kconfig
+++ linux-2.6/arch/powerpc/Kconfig
@@ -317,7 +317,7 @@ config PPC_STD_MMU_32
 
 config VIRT_CPU_ACCOUNTING
 	bool "Deterministic task and CPU time accounting"
-	depends on PPC64
+	depends on PPC64 && !GENERIC_CLOCKEVENTS
 	default y
 	help
 	  Select this option to enable more accurate task and CPU time
@@ -760,6 +760,16 @@ config HIGHMEM
 	depends on PPC32
 
 source kernel/Kconfig.hz
+
+config GENERIC_CLOCKEVENTS
+	bool "Clock event devices support"
+	default n
+	help
+	  Enable support for the clock event devices necessary for the
+	  high-resolution timers and the tickless system support.
+	  NOTE: This is not compatible with the deterministic time accounting
+	  option on PPC64.
+
 source kernel/Kconfig.preempt
 
 config RWSEM_GENERIC_SPINLOCK
Index: linux-2.6/arch/powerpc/kernel/time.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/time.c
+++ linux-2.6/arch/powerpc/kernel/time.c
@@ -52,6 +52,7 @@
 #include <linux/jiffies.h>
 #include <linux/posix-timers.h>
 #include <linux/irq.h>
+#include <linux/clockchips.h>
 
 #include <asm/io.h>
 #include <asm/processor.h>
@@ -128,6 +129,83 @@ unsigned long ppc_tb_freq;
 static u64 tb_last_jiffy __cacheline_aligned_in_smp;
 static DEFINE_PER_CPU(u64, last_jiffy);
 
+#ifdef CONFIG_GENERIC_CLOCKEVENTS
+
+#if defined(CONFIG_40x) || defined(CONFIG_BOOKE)
+#define DECREMENTER_MAX 0xffffffff
+#else
+#define DECREMENTER_MAX 0x7fffffff /* setting MSB triggers an interrupt */
+#endif
+
+static int decrementer_set_next_event(unsigned long evt,
+				      struct clock_event_device *dev)
+{
+#if defined(CONFIG_40x)
+	mtspr(SPRN_PIT, evt);	/* 40x has a hidden PIT auto-reload register */
+#elif defined(CONFIG_BOOKE)
+	mtspr(SPRN_DECAR, evt); /* Book E has  separate auto-reload register */
+	set_dec(evt);
+#else
+	set_dec(evt - 1);	/* Classic decrementer interrupts at -1 */
+#endif
+	return 0;
+}
+
+static void decrementer_set_mode(enum	clock_event_mode   mode,
+				 struct clock_event_device *dev)
+{
+#if defined(CONFIG_40x) || defined(CONFIG_BOOKE)
+	u32 tcr = mfspr(SPRN_TCR);
+
+	tcr |= TCR_DIE;
+	switch (mode) {
+	case CLOCK_EVT_MODE_PERIODIC:
+		tcr |=  TCR_ARE;
+		break;
+	case CLOCK_EVT_MODE_ONESHOT:
+		tcr &= ~TCR_ARE;
+		break;
+	case CLOCK_EVT_MODE_UNUSED:
+	case CLOCK_EVT_MODE_SHUTDOWN:
+		tcr &= ~TCR_DIE;
+		break;
+	}
+	mtspr(SPRN_TCR, tcr);
+#endif
+	if (mode == CLOCK_EVT_MODE_PERIODIC)
+		decrementer_set_next_event(tb_ticks_per_jiffy, dev);
+}
+
+static struct clock_event_device decrementer_clockevent = {
+	.name		= "decrementer",
+#if defined(CONFIG_40x) || defined(CONFIG_BOOKE)
+	.features	= CLOCK_EVT_FEAT_ONESHOT | CLOCK_EVT_FEAT_PERIODIC,
+#else
+	.features	= CLOCK_EVT_FEAT_ONESHOT,
+#endif
+	.shift		= 32,
+	.rating		= 200,
+	.irq		= -1,
+	.set_next_event	= decrementer_set_next_event,
+	.set_mode	= decrementer_set_mode,
+};
+
+static DEFINE_PER_CPU(struct clock_event_device, decrementers);
+
+static void register_decrementer(void)
+{
+	int cpu = smp_processor_id();
+	struct clock_event_device *decrementer = &per_cpu(decrementers, cpu);
+
+	memcpy(decrementer, &decrementer_clockevent, sizeof(*decrementer));
+
+	decrementer->cpumask = cpumask_of_cpu(cpu);
+
+	clockevents_register_device(decrementer);
+}
+
+#endif /* CONFIG_GENERIC_CLOCKEVENTS */
+
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING
 /*
  * Factors for converting from cputime_t (timebase ticks) to
@@ -313,6 +391,9 @@ void snapshot_timebase(void)
 {
 	__get_cpu_var(last_jiffy) = get_tb();
 	snapshot_purr();
+#ifdef CONFIG_GENERIC_CLOCKEVENTS
+	register_decrementer();
+#endif
 }
 
 void __delay(unsigned long loops)
@@ -470,7 +551,31 @@ void timer_interrupt(struct pt_regs * re
 	old_regs = set_irq_regs(regs);
 	irq_enter();
 
+#ifdef CONFIG_GENERIC_CLOCKEVENTS
+#ifdef CONFIG_PPC_MULTIPLATFORM
+	/*
+	 * We must write a positive value to the decrementer to clear
+	 * the interrupt on the IBM 970 CPU series.  In periodic mode,
+	 * this happens when the decrementer gets reloaded later, but
+	 * in one-shot mode, we have to do it here since an event handler
+	 * may skip loading the new value...
+	 */
+	if (per_cpu(decrementers, cpu).mode != CLOCK_EVT_MODE_PERIODIC)
+		set_dec(DECREMENTER_MAX);
+#endif
+	/*
+	 * We can't disable the decrementer, so in the period between
+	 * CPU being marked offline and calling stop-self, it's taking
+	 * timer interrupts...
+	 */
+	if (!cpu_is_offline(cpu)) {
+		struct clock_event_device *dev = &per_cpu(decrementers, cpu);
+
+		dev->event_handler(dev);
+	}
+#else
 	profile_tick(CPU_PROFILING);
+#endif
 	calculate_steal_time();
 
 #ifdef CONFIG_PPC_ISERIES
@@ -486,6 +591,7 @@ void timer_interrupt(struct pt_regs * re
 		if (__USE_RTC() && per_cpu(last_jiffy, cpu) >= 1000000000)
 			per_cpu(last_jiffy, cpu) -= 1000000000;
 
+#ifndef CONFIG_GENERIC_CLOCKEVENTS
 		/*
 		 * We cannot disable the decrementer, so in the period
 		 * between this cpu's being marked offline in cpu_online_map
@@ -495,6 +601,7 @@ void timer_interrupt(struct pt_regs * re
 		 */
 		if (!cpu_is_offline(cpu))
 			account_process_time(regs);
+#endif
 
 		/*
 		 * No need to check whether cpu is offline here; boot_cpuid
@@ -507,15 +614,19 @@ void timer_interrupt(struct pt_regs * re
 		tb_next_jiffy = tb_last_jiffy + tb_ticks_per_jiffy;
 		if (per_cpu(last_jiffy, cpu) >= tb_next_jiffy) {
 			tb_last_jiffy = tb_next_jiffy;
+#ifndef CONFIG_GENERIC_CLOCKEVENTS
 			do_timer(1);
+#endif
 			/*timer_recalc_offset(tb_last_jiffy);*/
 			timer_check_rtc();
 		}
 		write_sequnlock(&xtime_lock);
 	}
-	
+
+#ifndef CONFIG_GENERIC_CLOCKEVENTS
 	next_dec = tb_ticks_per_jiffy - ticks;
 	set_dec(next_dec);
+#endif
 
 #ifdef CONFIG_PPC_ISERIES
 	if (firmware_has_feature(FW_FEATURE_ISERIES) && hvlpevent_is_pending())
@@ -770,8 +881,19 @@ void __init time_init(void)
 	                        -xtime.tv_sec, -xtime.tv_nsec);
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 
+#ifdef CONFIG_GENERIC_CLOCKEVENTS
+	decrementer_clockevent.mult = div_sc(ppc_tb_freq, NSEC_PER_SEC,
+					     decrementer_clockevent.shift);
+	decrementer_clockevent.max_delta_ns =
+		clockevent_delta2ns(DECREMENTER_MAX, &decrementer_clockevent);
+	decrementer_clockevent.min_delta_ns =
+		clockevent_delta2ns(0xf, &decrementer_clockevent);
+
+	register_decrementer();
+#else
 	/* Not exact, but the timer interrupt takes care of this */
 	set_dec(tb_ticks_per_jiffy);
+#endif
 }
 
 #define FEBRUARY	2

