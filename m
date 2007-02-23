Return-Path: <linux-kernel-owner+w=401wt.eu-S1752119AbXBWBqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119AbXBWBqn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 20:46:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752116AbXBWBqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 20:46:43 -0500
Received: from mga05.intel.com ([192.55.52.89]:39419 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752112AbXBWBql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 20:46:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,208,1170662400"; 
   d="scan'208"; a="203159230:sNHT20849689"
Date: Thu, 22 Feb 2007 17:11:18 -0800
From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
To: linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 4/5] RT kernel: HPET emulate RTC and other cleanups
Message-ID: <20070222171118.C27475@unix-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Cleanup HPET RTC emulation based on earlier patch which uses HPET interrupts
in normal mode instead of legacy replacement mode. RTC can now coexist with
HPET.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

Index: linux-2.6.21-rc-mm/arch/x86_64/Kconfig
===================================================================
--- linux-2.6.21-rc-mm.orig/arch/x86_64/Kconfig
+++ linux-2.6.21-rc-mm/arch/x86_64/Kconfig
@@ -448,6 +448,7 @@ config ARCH_ENABLE_MEMORY_HOTPLUG
 config HPET_TIMER
 	bool
 	default y
+	depends ACPI
 	help
 	  Use the IA-PC HPET (High Precision Event Timer) to manage
 	  time in preference to the PIT and RTC, if a HPET is
@@ -458,7 +459,7 @@ config HPET_TIMER
 
 config HPET_EMULATE_RTC
 	bool "Provide RTC interrupt"
-	depends on HPET_TIMER && RTC=y
+	depends on HPET_TIMER && RTC=y && !GENERIC_TIME
 
 # Mark as embedded because too many people got it wrong.
 # The code disables itself when not needed.
Index: linux-2.6.21-rc-mm/arch/x86_64/kernel/hpet.c
===================================================================
--- linux-2.6.21-rc-mm.orig/arch/x86_64/kernel/hpet.c
+++ linux-2.6.21-rc-mm/arch/x86_64/kernel/hpet.c
@@ -2,7 +2,6 @@
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/init.h>
-#include <linux/mc146818rtc.h>
 #include <linux/time.h>
 #include <linux/clocksource.h>
 #include <linux/ioport.h>
@@ -10,6 +9,8 @@
 #include <linux/hpet.h>
 #include <linux/clockchips.h>
 #include <linux/delay.h>
+#include <linux/irq.h>
+#include <linux/interrupt.h>
 
 #include <asm/pgtable.h>
 #include <asm/vsyscall.h>
@@ -44,36 +45,35 @@ static __init int late_hpet_init(void)
 
 	/*
 	 * Register with driver.
-	 * Timer0 and Timer1 is used by platform.
+	 * num_timers_used timers are used by platform.
 	 */
 	hd.hd_phys_address = hpet_address;
 	hd.hd_address = (void __iomem *)fix_to_virt(FIX_HPET_BASE);
 	hd.hd_nirqs = ntimer;
 	hd.hd_flags = HPET_DATA_PLATFORM;
-	hpet_reserve_timer(&hd, 0);
-#ifdef	CONFIG_HPET_EMULATE_RTC
-	hpet_reserve_timer(&hd, 1);
-#endif
-	hd.hd_irq[0] = HPET_LEGACY_8254;
-	hd.hd_irq[1] = HPET_LEGACY_RTC;
-	if (ntimer > 2) {
+
+	for (i = 0; i < num_timers_used; i++) {
+		hpet_reserve_timer(&hd, i);
+	}
+
+	if (ntimer > num_timers_used) {
 		struct hpet		*hpet;
 		struct hpet_timer	*timer;
 		int			i;
 
 		hpet = (struct hpet *) fix_to_virt(FIX_HPET_BASE);
-		timer = &hpet->hpet_timers[2];
-		for (i = 2; i < ntimer; timer++, i++)
+		for (i = num_timers_used; i < ntimer; timer++, i++) {
+			timer = &hpet->hpet_timers[i];
 			hd.hd_irq[i] = (timer->hpet_config &
 					Tn_INT_ROUTE_CNF_MASK) >>
 				Tn_INT_ROUTE_CNF_SHIFT;
-
+		}
 	}
 
 	hpet_alloc(&hd);
 	return 0;
 }
-fs_initcall(late_hpet_init);
+late_initcall(late_hpet_init);
 #endif
 
 static int hpet_timer_stop_set_go(unsigned long tick)
@@ -209,257 +209,6 @@ unsigned int __init hpet_calibrate_tsc(v
 		/ ((hpet_now - hpet_start) * hpet_period / 1000);
 }
 
-#ifdef CONFIG_HPET_EMULATE_RTC
-/* HPET in LegacyReplacement Mode eats up RTC interrupt line. When, HPET
- * is enabled, we support RTC interrupt functionality in software.
- * RTC has 3 kinds of interrupts:
- * 1) Update Interrupt - generate an interrupt, every sec, when RTC clock
- *    is updated
- * 2) Alarm Interrupt - generate an interrupt at a specific time of day
- * 3) Periodic Interrupt - generate periodic interrupt, with frequencies
- *    2Hz-8192Hz (2Hz-64Hz for non-root user) (all freqs in powers of 2)
- * (1) and (2) above are implemented using polling at a frequency of
- * 64 Hz. The exact frequency is a tradeoff between accuracy and interrupt
- * overhead. (DEFAULT_RTC_INT_FREQ)
- * For (3), we use interrupts at 64Hz or user specified periodic
- * frequency, whichever is higher.
- */
-#include <linux/rtc.h>
-
-#define DEFAULT_RTC_INT_FREQ 	64
-#define RTC_NUM_INTS 		1
-
-static unsigned long UIE_on;
-static unsigned long prev_update_sec;
-
-static unsigned long AIE_on;
-static struct rtc_time alarm_time;
-
-static unsigned long PIE_on;
-static unsigned long PIE_freq = DEFAULT_RTC_INT_FREQ;
-static unsigned long PIE_count;
-
-static unsigned long hpet_rtc_int_freq; /* RTC interrupt frequency */
-static unsigned int hpet_t1_cmp; /* cached comparator register */
-
-int is_hpet_enabled(void)
-{
-	return hpet_address != 0;
-}
-
-/*
- * Timer 1 for RTC, we do not use periodic interrupt feature,
- * even if HPET supports periodic interrupts on Timer 1.
- * The reason being, to set up a periodic interrupt in HPET, we need to
- * stop the main counter. And if we do that everytime someone diables/enables
- * RTC, we will have adverse effect on main kernel timer running on Timer 0.
- * So, for the time being, simulate the periodic interrupt in software.
- *
- * hpet_rtc_timer_init() is called for the first time and during subsequent
- * interuppts reinit happens through hpet_rtc_timer_reinit().
- */
-int hpet_rtc_timer_init(void)
-{
-	unsigned int cfg, cnt;
-	unsigned long flags;
-
-	if (!is_hpet_enabled())
-		return 0;
-	/*
-	 * Set the counter 1 and enable the interrupts.
-	 */
-	if (PIE_on && (PIE_freq > DEFAULT_RTC_INT_FREQ))
-		hpet_rtc_int_freq = PIE_freq;
-	else
-		hpet_rtc_int_freq = DEFAULT_RTC_INT_FREQ;
-
-	local_irq_save(flags);
-
-	cnt = hpet_readl(HPET_COUNTER);
-	cnt += ((hpet_tick*HZ)/hpet_rtc_int_freq);
-	hpet_writel(cnt, HPET_T1_CMP);
-	hpet_t1_cmp = cnt;
-
-	cfg = hpet_readl(HPET_T1_CFG);
-	cfg &= ~HPET_TN_PERIODIC;
-	cfg |= HPET_TN_ENABLE | HPET_TN_32BIT;
-	hpet_writel(cfg, HPET_T1_CFG);
-
-	local_irq_restore(flags);
-
-	return 1;
-}
-
-static void hpet_rtc_timer_reinit(void)
-{
-	unsigned int cfg, cnt, ticks_per_int, lost_ints;
-
-	if (unlikely(!(PIE_on | AIE_on | UIE_on))) {
-		cfg = hpet_readl(HPET_T1_CFG);
-		cfg &= ~HPET_TN_ENABLE;
-		hpet_writel(cfg, HPET_T1_CFG);
-		return;
-	}
-
-	if (PIE_on && (PIE_freq > DEFAULT_RTC_INT_FREQ))
-		hpet_rtc_int_freq = PIE_freq;
-	else
-		hpet_rtc_int_freq = DEFAULT_RTC_INT_FREQ;
-
-	/* It is more accurate to use the comparator value than current count.*/
-	ticks_per_int = hpet_tick * HZ / hpet_rtc_int_freq;
-	hpet_t1_cmp += ticks_per_int;
-	hpet_writel(hpet_t1_cmp, HPET_T1_CMP);
-
-	/*
-	 * If the interrupt handler was delayed too long, the write above tries
-	 * to schedule the next interrupt in the past and the hardware would
-	 * not interrupt until the counter had wrapped around.
-	 * So we have to check that the comparator wasn't set to a past time.
-	 */
-	cnt = hpet_readl(HPET_COUNTER);
-	if (unlikely((int)(cnt - hpet_t1_cmp) > 0)) {
-		lost_ints = (cnt - hpet_t1_cmp) / ticks_per_int + 1;
-		/* Make sure that, even with the time needed to execute
-		 * this code, the next scheduled interrupt has been moved
-		 * back to the future: */
-		lost_ints++;
-
-		hpet_t1_cmp += lost_ints * ticks_per_int;
-		hpet_writel(hpet_t1_cmp, HPET_T1_CMP);
-
-		if (PIE_on)
-			PIE_count += lost_ints;
-
-		if (printk_ratelimit())
-			printk(KERN_WARNING "rtc: lost some interrupts at %ldHz.\n",
-			       hpet_rtc_int_freq);
-	}
-}
-
-/*
- * The functions below are called from rtc driver.
- * Return 0 if HPET is not being used.
- * Otherwise do the necessary changes and return 1.
- */
-int hpet_mask_rtc_irq_bit(unsigned long bit_mask)
-{
-	if (!is_hpet_enabled())
-		return 0;
-
-	if (bit_mask & RTC_UIE)
-		UIE_on = 0;
-	if (bit_mask & RTC_PIE)
-		PIE_on = 0;
-	if (bit_mask & RTC_AIE)
-		AIE_on = 0;
-
-	return 1;
-}
-
-int hpet_set_rtc_irq_bit(unsigned long bit_mask)
-{
-	int timer_init_reqd = 0;
-
-	if (!is_hpet_enabled())
-		return 0;
-
-	if (!(PIE_on | AIE_on | UIE_on))
-		timer_init_reqd = 1;
-
-	if (bit_mask & RTC_UIE) {
-		UIE_on = 1;
-	}
-	if (bit_mask & RTC_PIE) {
-		PIE_on = 1;
-		PIE_count = 0;
-	}
-	if (bit_mask & RTC_AIE) {
-		AIE_on = 1;
-	}
-
-	if (timer_init_reqd)
-		hpet_rtc_timer_init();
-
-	return 1;
-}
-
-int hpet_set_alarm_time(unsigned char hrs, unsigned char min, unsigned char sec)
-{
-	if (!is_hpet_enabled())
-		return 0;
-
-	alarm_time.tm_hour = hrs;
-	alarm_time.tm_min = min;
-	alarm_time.tm_sec = sec;
-
-	return 1;
-}
-
-int hpet_set_periodic_freq(unsigned long freq)
-{
-	if (!is_hpet_enabled())
-		return 0;
-
-	PIE_freq = freq;
-	PIE_count = 0;
-
-	return 1;
-}
-
-int hpet_rtc_dropped_irq(void)
-{
-	if (!is_hpet_enabled())
-		return 0;
-
-	return 1;
-}
-
-irqreturn_t hpet_rtc_interrupt(int irq, void *dev_id)
-{
-	struct rtc_time curr_time;
-	unsigned long rtc_int_flag = 0;
-	int call_rtc_interrupt = 0;
-
-	hpet_rtc_timer_reinit();
-
-	if (UIE_on | AIE_on) {
-		rtc_get_rtc_time(&curr_time);
-	}
-	if (UIE_on) {
-		if (curr_time.tm_sec != prev_update_sec) {
-			/* Set update int info, call real rtc int routine */
-			call_rtc_interrupt = 1;
-			rtc_int_flag = RTC_UF;
-			prev_update_sec = curr_time.tm_sec;
-		}
-	}
-	if (PIE_on) {
-		PIE_count++;
-		if (PIE_count >= hpet_rtc_int_freq/PIE_freq) {
-			/* Set periodic int info, call real rtc int routine */
-			call_rtc_interrupt = 1;
-			rtc_int_flag |= RTC_PF;
-			PIE_count = 0;
-		}
-	}
-	if (AIE_on) {
-		if ((curr_time.tm_sec == alarm_time.tm_sec) &&
-		    (curr_time.tm_min == alarm_time.tm_min) &&
-		    (curr_time.tm_hour == alarm_time.tm_hour)) {
-			/* Set alarm int info, call real rtc int routine */
-			call_rtc_interrupt = 1;
-			rtc_int_flag |= RTC_AF;
-		}
-	}
-	if (call_rtc_interrupt) {
-		rtc_int_flag |= (RTC_IRQF | (RTC_NUM_INTS << 8));
-		rtc_interrupt(rtc_int_flag, dev_id);
-	}
-	return IRQ_HANDLED;
-}
-#endif
-
 static int __init nohpet_setup(char *s)
 {
 	nohpet = 1;
