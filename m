Return-Path: <linux-kernel-owner+w=401wt.eu-S1757961AbXLFM5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757961AbXLFM5Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 07:57:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754848AbXLFMou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 07:44:50 -0500
Received: from nic2.axis.se ([193.13.178.10]:45019 "EHLO krynn.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755206AbXLFMoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 07:44:44 -0500
From: Jesper Nilsson <jesper.nilsson@axis.com>
Message-Id: <16367c7dcde15b42e831549e14f1d03439cc02b0.1196848533.git.jesper.nilsson@axis.com>
In-Reply-To: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
References: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org
Date: Tue, 4 Dec 2007 17:25:45 +0100
Subject: [PATCH 46/47] Update and improve CRISv32 kernel/time.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Shorten include paths to machine dependent header files.
- Register name for first timer is now regi_timer0.
- Remove raw_printk hack, use oops_in_progress instead.
- Add handling of CPU frequency scaling for CRIS.
- Remove regs parameter to timer_interrupt, get them from get_irq_regs instead.
- Whitespace and formatting changes.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 arch/cris/arch-v32/kernel/time.c |  237 ++++++++++++++++++++++----------------
 1 files changed, 139 insertions(+), 98 deletions(-)

diff --git a/arch/cris/arch-v32/kernel/time.c b/arch/cris/arch-v32/kernel/time.c
index 2f7e8e2..3a13dd6 100644
--- a/arch/cris/arch-v32/kernel/time.c
+++ b/arch/cris/arch-v32/kernel/time.c
@@ -1,8 +1,7 @@
-/* $Id: time.c,v 1.19 2005/04/29 05:40:09 starvik Exp $
- *
+/*
  *  linux/arch/cris/arch-v32/kernel/time.c
  *
- *  Copyright (C) 2003 Axis Communications AB
+ *  Copyright (C) 2003-2007 Axis Communications AB
  *
  */
 
@@ -14,28 +13,34 @@
 #include <linux/sched.h>
 #include <linux/init.h>
 #include <linux/threads.h>
+#include <linux/cpufreq.h>
 #include <asm/types.h>
 #include <asm/signal.h>
 #include <asm/io.h>
 #include <asm/delay.h>
 #include <asm/rtc.h>
 #include <asm/irq.h>
-
-#include <asm/arch/hwregs/reg_map.h>
-#include <asm/arch/hwregs/reg_rdwr.h>
-#include <asm/arch/hwregs/timer_defs.h>
-#include <asm/arch/hwregs/intr_vect_defs.h>
+#include <asm/irq_regs.h>
+
+#include <hwregs/reg_map.h>
+#include <hwregs/reg_rdwr.h>
+#include <hwregs/timer_defs.h>
+#include <hwregs/intr_vect_defs.h>
+#ifdef CONFIG_CRIS_MACH_ARTPEC3
+#include <hwregs/clkgen_defs.h>
+#endif
 
 /* Watchdog defines */
-#define ETRAX_WD_KEY_MASK 0x7F /* key is 7 bit */
-#define ETRAX_WD_HZ       763 /* watchdog counts at 763 Hz */
-#define ETRAX_WD_CNT      ((2*ETRAX_WD_HZ)/HZ + 1) /* Number of 763 counts before watchdog bites */
+#define ETRAX_WD_KEY_MASK	0x7F /* key is 7 bit */
+#define ETRAX_WD_HZ		763 /* watchdog counts at 763 Hz */
+/* Number of 763 counts before watchdog bites */
+#define ETRAX_WD_CNT		((2*ETRAX_WD_HZ)/HZ + 1)
 
 unsigned long timer_regs[NR_CPUS] =
 {
-  regi_timer,
+	regi_timer0,
 #ifdef CONFIG_SMP
-  regi_timer2
+	regi_timer2
 #endif
 };
 
@@ -44,12 +49,22 @@ extern int set_rtc_mmss(unsigned long nowtime);
 extern int setup_irq(int, struct irqaction *);
 extern int have_rtc;
 
+#ifdef CONFIG_CPU_FREQ
+static int
+cris_time_freq_notifier(struct notifier_block *nb, unsigned long val,
+			void *data);
+
+static struct notifier_block cris_time_freq_notifier_block = {
+	.notifier_call = cris_time_freq_notifier,
+};
+#endif
+
 unsigned long get_ns_in_jiffie(void)
 {
 	reg_timer_r_tmr0_data data;
 	unsigned long ns;
 
-	data = REG_RD(timer, regi_timer, r_tmr0_data);
+	data = REG_RD(timer, regi_timer0, r_tmr0_data);
 	ns = (TIMER0_DIV - data) * 10;
 	return ns;
 }
@@ -59,31 +74,27 @@ unsigned long do_slow_gettimeoffset(void)
 	unsigned long count;
 	unsigned long usec_count = 0;
 
-	static unsigned long count_p = TIMER0_DIV;/* for the first call after boot */
+	/* For the first call after boot */
+	static unsigned long count_p = TIMER0_DIV;
 	static unsigned long jiffies_p = 0;
 
-	/*
-	 * cache volatile jiffies temporarily; we have IRQs turned off.
-	 */
+	/* Cache volatile jiffies temporarily; we have IRQs turned off. */
 	unsigned long jiffies_t;
 
 	/* The timer interrupt comes from Etrax timer 0. In order to get
 	 * better precision, we check the current value. It might have
-	 * underflowed already though.
-	 */
+	 * underflowed already though. */
+	count = REG_RD(timer, regi_timer0, r_tmr0_data);
+	jiffies_t = jiffies;
 
-	count = REG_RD(timer, regi_timer, r_tmr0_data);
- 	jiffies_t = jiffies;
-
-	/*
-	 * avoiding timer inconsistencies (they are rare, but they happen)...
-	 * there are one problem that must be avoided here:
-	 *  1. the timer counter underflows
+	/* Avoiding timer inconsistencies (they are rare, but they happen)
+	 * There is one problem that must be avoided here:
+	 *	1. the timer counter underflows
 	 */
 	if( jiffies_t == jiffies_p ) {
 		if( count > count_p ) {
-			/* Timer wrapped, use new count and prescale
-			 * increase the time corresponding to one jiffie
+			/* Timer wrapped, use new count and prescale.
+			 * Increase the time corresponding to one jiffy.
 			 */
 			usec_count = 1000000/HZ;
 		}
@@ -106,17 +117,15 @@ unsigned long do_slow_gettimeoffset(void)
  */
 /* This gives us 1.3 ms to do something useful when the NMI comes */
 
-/* right now, starting the watchdog is the same as resetting it */
+/* Right now, starting the watchdog is the same as resetting it */
 #define start_watchdog reset_watchdog
 
 #if defined(CONFIG_ETRAX_WATCHDOG)
 static short int watchdog_key = 42;  /* arbitrary 7 bit number */
 #endif
 
-/* number of pages to consider "out of memory". it is normal that the memory
- * is used though, so put this really low.
- */
-
+/* Number of pages to consider "out of memory". It is normal that the memory
+ * is used though, so set this really low. */
 #define WATCHDOG_MIN_FREE_PAGES 8
 
 void
@@ -125,14 +134,15 @@ reset_watchdog(void)
 #if defined(CONFIG_ETRAX_WATCHDOG)
 	reg_timer_rw_wd_ctrl wd_ctrl = { 0 };
 
-	/* only keep watchdog happy as long as we have memory left! */
+	/* Only keep watchdog happy as long as we have memory left! */
 	if(nr_free_pages() > WATCHDOG_MIN_FREE_PAGES) {
-		/* reset the watchdog with the inverse of the old key */
-		watchdog_key ^= ETRAX_WD_KEY_MASK; /* invert key, which is 7 bits */
+		/* Reset the watchdog with the inverse of the old key */
+		/* Invert key, which is 7 bits */
+		watchdog_key ^= ETRAX_WD_KEY_MASK;
 		wd_ctrl.cnt = ETRAX_WD_CNT;
 		wd_ctrl.cmd = regk_timer_start;
 		wd_ctrl.key = watchdog_key;
-		REG_WR(timer, regi_timer, rw_wd_ctrl, wd_ctrl);
+		REG_WR(timer, regi_timer0, rw_wd_ctrl, wd_ctrl);
 	}
 #endif
 }
@@ -148,7 +158,7 @@ stop_watchdog(void)
 	wd_ctrl.cnt = ETRAX_WD_CNT;
 	wd_ctrl.cmd = regk_timer_stop;
 	wd_ctrl.key = watchdog_key;
-	REG_WR(timer, regi_timer, rw_wd_ctrl, wd_ctrl);
+	REG_WR(timer, regi_timer0, rw_wd_ctrl, wd_ctrl);
 #endif
 }
 
@@ -160,17 +170,28 @@ handle_watchdog_bite(struct pt_regs* regs)
 #if defined(CONFIG_ETRAX_WATCHDOG)
 	extern int cause_of_death;
 
-	raw_printk("Watchdog bite\n");
+	oops_in_progress = 1;
+	printk(KERN_WARNING "Watchdog bite\n");
 
 	/* Check if forced restart or unexpected watchdog */
 	if (cause_of_death == 0xbedead) {
+#ifdef CONFIG_CRIS_MACH_ARTPEC3
+		/* There is a bug in Artpec-3 (voodoo TR 78) that requires
+		 * us to go to lower frequency for the reset to be reliable
+		 */
+		reg_clkgen_rw_clk_ctrl ctrl =
+			REG_RD(clkgen, regi_clkgen, rw_clk_ctrl);
+		ctrl.pll = 0;
+		REG_WR(clkgen, regi_clkgen, rw_clk_ctrl, ctrl);
+#endif
 		while(1);
 	}
 
-	/* Unexpected watchdog, stop the watchdog and dump registers*/
+	/* Unexpected watchdog, stop the watchdog and dump registers. */
 	stop_watchdog();
-	raw_printk("Oops: bitten by watchdog\n");
-        show_registers(regs);
+	printk(KERN_WARNING "Oops: bitten by watchdog\n");
+	show_registers(regs);
+	oops_in_progress = 0;
 #ifndef CONFIG_ETRAX_WATCHDOG_NICE_DOGGY
 	reset_watchdog();
 #endif
@@ -178,21 +199,19 @@ handle_watchdog_bite(struct pt_regs* regs)
 #endif
 }
 
-/* last time the cmos clock got updated */
+/* Last time the cmos clock got updated. */
 static long last_rtc_update = 0;
 
 /*
  * timer_interrupt() needs to keep up the real-time clock,
- * as well as call the "do_timer()" routine every clocktick
+ * as well as call the "do_timer()" routine every clocktick.
  */
-
-//static unsigned short myjiff; /* used by our debug routine print_timestamp */
-
 extern void cris_do_profile(struct pt_regs *regs);
 
 static inline irqreturn_t
-timer_interrupt(int irq, void *dev_id, struct pt_regs *regs)
+timer_interrupt(int irq, void *dev_id)
 {
+	struct pt_regs *regs = get_irq_regs();
 	int cpu = smp_processor_id();
 	reg_timer_r_masked_intr masked_intr;
 	reg_timer_rw_ack_intr ack_intr = { 0 };
@@ -202,11 +221,11 @@ timer_interrupt(int irq, void *dev_id, struct pt_regs *regs)
 	if (!masked_intr.tmr0)
 		return IRQ_NONE;
 
-	/* acknowledge the timer irq */
+	/* Acknowledge the timer irq. */
 	ack_intr.tmr0 = 1;
 	REG_WR(timer, timer_regs[cpu], rw_ack_intr, ack_intr);
 
-	/* reset watchdog otherwise it resets us! */
+	/* Reset watchdog otherwise it resets us! */
 	reset_watchdog();
 
         /* Update statistics. */
@@ -218,7 +237,7 @@ timer_interrupt(int irq, void *dev_id, struct pt_regs *regs)
 	if (cpu != 0)
 		return IRQ_HANDLED;
 
-	/* call the real timer interrupt handler */
+	/* Call the real timer interrupt handler */
 	do_timer(1);
 
 	/*
@@ -236,17 +255,17 @@ timer_interrupt(int irq, void *dev_id, struct pt_regs *regs)
 		if (set_rtc_mmss(xtime.tv_sec) == 0)
 			last_rtc_update = xtime.tv_sec;
 		else
-			last_rtc_update = xtime.tv_sec - 600; /* do it again in 60 s */
+			/* Do it again in 60 s */
+			last_rtc_update = xtime.tv_sec - 600;
 	}
         return IRQ_HANDLED;
 }
 
-/* timer is IRQF_SHARED so drivers can add stuff to the timer irq chain
- * it needs to be IRQF_DISABLED to make the jiffies update work properly
+/* Timer is IRQF_SHARED so drivers can add stuff to the timer irq chain.
+ * It needs to be IRQF_DISABLED to make the jiffies update work properly.
  */
-
-static struct irqaction irq_timer  = {
-	.mask = timer_interrupt,
+static struct irqaction irq_timer = {
+	.handler = timer_interrupt,
 	.flags = IRQF_SHARED | IRQF_DISABLED,
 	.mask = CPU_MASK_NONE,
 	.name = "timer"
@@ -256,27 +275,27 @@ void __init
 cris_timer_init(void)
 {
 	int cpu = smp_processor_id();
-  	reg_timer_rw_tmr0_ctrl tmr0_ctrl = { 0 };
-       	reg_timer_rw_tmr0_div tmr0_div = TIMER0_DIV;
+	reg_timer_rw_tmr0_ctrl tmr0_ctrl = { 0 };
+	reg_timer_rw_tmr0_div tmr0_div = TIMER0_DIV;
 	reg_timer_rw_intr_mask timer_intr_mask;
 
-	/* Setup the etrax timers
+	/* Setup the etrax timers.
 	 * Base frequency is 100MHz, divider 1000000 -> 100 HZ
 	 * We use timer0, so timer1 is free.
 	 * The trig timer is used by the fasttimer API if enabled.
 	 */
 
-       	tmr0_ctrl.op = regk_timer_ld;
+	tmr0_ctrl.op = regk_timer_ld;
 	tmr0_ctrl.freq = regk_timer_f100;
-       	REG_WR(timer, timer_regs[cpu], rw_tmr0_div, tmr0_div);
-       	REG_WR(timer, timer_regs[cpu], rw_tmr0_ctrl, tmr0_ctrl); /* Load */
-       	tmr0_ctrl.op = regk_timer_run;
-       	REG_WR(timer, timer_regs[cpu], rw_tmr0_ctrl, tmr0_ctrl); /* Start */
-
-       	/* enable the timer irq */
-       	timer_intr_mask = REG_RD(timer, timer_regs[cpu], rw_intr_mask);
-       	timer_intr_mask.tmr0 = 1;
-       	REG_WR(timer, timer_regs[cpu], rw_intr_mask, timer_intr_mask);
+	REG_WR(timer, timer_regs[cpu], rw_tmr0_div, tmr0_div);
+	REG_WR(timer, timer_regs[cpu], rw_tmr0_ctrl, tmr0_ctrl); /* Load */
+	tmr0_ctrl.op = regk_timer_run;
+	REG_WR(timer, timer_regs[cpu], rw_tmr0_ctrl, tmr0_ctrl); /* Start */
+
+	/* Enable the timer irq. */
+	timer_intr_mask = REG_RD(timer, timer_regs[cpu], rw_intr_mask);
+	timer_intr_mask.tmr0 = 1;
+	REG_WR(timer, timer_regs[cpu], rw_intr_mask, timer_intr_mask);
 }
 
 void __init
@@ -284,7 +303,7 @@ time_init(void)
 {
 	reg_intr_vect_rw_mask intr_mask;
 
-	/* probe for the RTC and read it if it exists
+	/* Probe for the RTC and read it if it exists.
 	 * Before the RTC can be probed the loops_per_usec variable needs
 	 * to be initialized to make usleep work. A better value for
 	 * loops_per_usec is calculated by the kernel later once the
@@ -293,52 +312,74 @@ time_init(void)
 	loops_per_usec = 50;
 
 	if(RTC_INIT() < 0) {
-		/* no RTC, start at 1980 */
+		/* No RTC, start at 1980 */
 		xtime.tv_sec = 0;
 		xtime.tv_nsec = 0;
 		have_rtc = 0;
 	} else {
-		/* get the current time */
+		/* Get the current time */
 		have_rtc = 1;
 		update_xtime_from_cmos();
 	}
 
 	/*
-	 * Initialize wall_to_monotonic such that adding it to xtime will yield zero, the
-	 * tv_nsec field must be normalized (i.e., 0 <= nsec < NSEC_PER_SEC).
+	 * Initialize wall_to_monotonic such that adding it to
+	 * xtime will yield zero, the tv_nsec field must be normalized
+	 * (i.e., 0 <= nsec < NSEC_PER_SEC).
 	 */
 	set_normalized_timespec(&wall_to_monotonic, -xtime.tv_sec, -xtime.tv_nsec);
 
-	/* Start CPU local timer */
+	/* Start CPU local timer. */
 	cris_timer_init();
 
-	/* enable the timer irq in global config */
-	intr_mask = REG_RD(intr_vect, regi_irq, rw_mask);
-	intr_mask.timer = 1;
-	REG_WR(intr_vect, regi_irq, rw_mask, intr_mask);
-
-	/* now actually register the timer irq handler that calls timer_interrupt() */
+	/* Enable the timer irq in global config. */
+	intr_mask = REG_RD_VECT(intr_vect, regi_irq, rw_mask, 1);
+	intr_mask.timer0 = 1;
+	REG_WR_VECT(intr_vect, regi_irq, rw_mask, 1, intr_mask);
 
-	setup_irq(TIMER_INTR_VECT, &irq_timer);
+	/* Now actually register the timer irq handler that calls
+	 * timer_interrupt(). */
+	setup_irq(TIMER0_INTR_VECT, &irq_timer);
 
-	/* enable watchdog if we should use one */
+	/* Enable watchdog if we should use one. */
 
 #if defined(CONFIG_ETRAX_WATCHDOG)
-	printk("Enabling watchdog...\n");
+	printk(KERN_INFO "Enabling watchdog...\n");
 	start_watchdog();
 
 	/* If we use the hardware watchdog, we want to trap it as an NMI
-	   and dump registers before it resets us.  For this to happen, we
-	   must set the "m" NMI enable flag (which once set, is unset only
-	   when an NMI is taken).
-
-	   The same goes for the external NMI, but that doesn't have any
-	   driver or infrastructure support yet.  */
-        {
-          unsigned long flags;
-          local_save_flags(flags);
-          flags |= (1<<30); /* NMI M flag is at bit 30 */
-          local_irq_restore(flags);
-        }
+	 * and dump registers before it resets us.  For this to happen, we
+	 * must set the "m" NMI enable flag (which once set, is unset only
+	 * when an NMI is taken). */
+	{
+		unsigned long flags;
+		local_save_flags(flags);
+		flags |= (1<<30); /* NMI M flag is at bit 30 */
+		local_irq_restore(flags);
+	}
+#endif
+
+#ifdef CONFIG_CPU_FREQ
+	cpufreq_register_notifier(&cris_time_freq_notifier_block,
+		CPUFREQ_TRANSITION_NOTIFIER);
 #endif
 }
+
+#ifdef CONFIG_CPU_FREQ
+static int
+cris_time_freq_notifier(struct notifier_block *nb, unsigned long val,
+			void *data)
+{
+	struct cpufreq_freqs *freqs = data;
+	if (val == CPUFREQ_POSTCHANGE) {
+		reg_timer_r_tmr0_data data;
+		reg_timer_rw_tmr0_div div = (freqs->new * 500) / HZ;
+		do {
+			data = REG_RD(timer, timer_regs[freqs->cpu],
+				r_tmr0_data);
+		} while (data > 20);
+		REG_WR(timer, timer_regs[freqs->cpu], rw_tmr0_div, div);
+	}
+	return 0;
+}
+#endif
-- 
1.5.3.6.970.gd25430

