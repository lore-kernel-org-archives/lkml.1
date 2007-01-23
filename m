Return-Path: <linux-kernel-owner+w=401wt.eu-S933134AbXAWWNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933134AbXAWWNt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 17:13:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933147AbXAWWMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 17:12:15 -0500
Received: from www.osadl.org ([213.239.205.134]:35815 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933141AbXAWWAt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 17:00:49 -0500
Message-Id: <20070123211203.889964000@localhost.localdomain>
References: <20070123211159.178138000@localhost.localdomain>
Date: Tue, 23 Jan 2007 22:01:03 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       John Stultz <johnstul@us.ibm.com>,
       Arjan van de Veen <arjan@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: [patch 08/46] i386: use GTOD persistent clock support
Content-Disposition: inline; filename=gtod-persistent-clock-support-i386.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Stultz <johnstul@us.ibm.com>

Persistent clock support: do proper timekeeping across suspend/resume, i386
arch support.

[ cleanup from Adrian Bunk <bunk@stusta.de> ]

Build-fixes-from: Andrew Morton <akpm@osdl.org>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/apm.c  |   44 ---------------------------------------
 arch/i386/kernel/time.c |   54 ------------------------------------------------
 2 files changed, 1 insertion(+), 97 deletions(-)

Index: linux-2.6.20-rc4-mm1-bo/arch/i386/kernel/apm.c
===================================================================
--- linux-2.6.20-rc4-mm1-bo.orig/arch/i386/kernel/apm.c
+++ linux-2.6.20-rc4-mm1-bo/arch/i386/kernel/apm.c
@@ -236,7 +236,6 @@
 
 #include "io_ports.h"
 
-extern unsigned long get_cmos_time(void);
 extern void machine_real_restart(unsigned char *, int);
 
 #if defined(CONFIG_APM_DISPLAY_BLANK) && defined(CONFIG_VT)
@@ -1176,28 +1175,6 @@ out:
 	spin_unlock(&user_list_lock);
 }
 
-static void set_time(void)
-{
-	struct timespec ts;
-	if (got_clock_diff) {	/* Must know time zone in order to set clock */
-		ts.tv_sec = get_cmos_time() + clock_cmos_diff;
-		ts.tv_nsec = 0;
-		do_settimeofday(&ts);
-	} 
-}
-
-static void get_time_diff(void)
-{
-#ifndef CONFIG_APM_RTC_IS_GMT
-	/*
-	 * Estimate time zone so that set_time can update the clock
-	 */
-	clock_cmos_diff = -get_cmos_time();
-	clock_cmos_diff += get_seconds();
-	got_clock_diff = 1;
-#endif
-}
-
 static void reinit_timer(void)
 {
 #ifdef INIT_TIMER_AFTER_SUSPEND
@@ -1237,19 +1214,6 @@ static int suspend(int vetoable)
 	local_irq_disable();
 	device_power_down(PMSG_SUSPEND);
 
-	/* serialize with the timer interrupt */
-	write_seqlock(&xtime_lock);
-
-	/* protect against access to timer chip registers */
-	spin_lock(&i8253_lock);
-
-	get_time_diff();
-	/*
-	 * Irq spinlock must be dropped around set_system_power_state.
-	 * We'll undo any timer changes due to interrupts below.
-	 */
-	spin_unlock(&i8253_lock);
-	write_sequnlock(&xtime_lock);
 	local_irq_enable();
 
 	save_processor_state();
@@ -1258,7 +1222,6 @@ static int suspend(int vetoable)
 	restore_processor_state();
 
 	local_irq_disable();
-	set_time();
 	reinit_timer();
 
 	if (err == APM_NO_ERROR)
@@ -1288,11 +1251,6 @@ static void standby(void)
 
 	local_irq_disable();
 	device_power_down(PMSG_SUSPEND);
-	/* serialize with the timer interrupt */
-	write_seqlock(&xtime_lock);
-	/* If needed, notify drivers here */
-	get_time_diff();
-	write_sequnlock(&xtime_lock);
 	local_irq_enable();
 
 	err = set_system_power_state(APM_STATE_STANDBY);
@@ -1386,7 +1344,6 @@ static void check_events(void)
 			ignore_bounce = 1;
 			if ((event != APM_NORMAL_RESUME)
 			    || (ignore_normal_resume == 0)) {
-				set_time();
 				device_resume();
 				pm_send_all(PM_RESUME, (void *)0);
 				queue_event(event, NULL);
@@ -1402,7 +1359,6 @@ static void check_events(void)
 			break;
 
 		case APM_UPDATE_TIME:
-			set_time();
 			break;
 
 		case APM_CRITICAL_SUSPEND:
Index: linux-2.6.20-rc4-mm1-bo/arch/i386/kernel/time.c
===================================================================
--- linux-2.6.20-rc4-mm1-bo.orig/arch/i386/kernel/time.c
+++ linux-2.6.20-rc4-mm1-bo/arch/i386/kernel/time.c
@@ -214,7 +214,7 @@ irqreturn_t timer_interrupt(int irq, voi
 }
 
 /* not static: needed by APM */
-unsigned long get_cmos_time(void)
+unsigned long read_persistent_clock(void)
 {
 	unsigned long retval;
 	unsigned long flags;
@@ -227,7 +227,6 @@ unsigned long get_cmos_time(void)
 
 	return retval;
 }
-EXPORT_SYMBOL(get_cmos_time);
 
 static void sync_cmos_clock(unsigned long dummy);
 
@@ -280,58 +279,19 @@ void notify_arch_cmos_timer(void)
 		mod_timer(&sync_cmos_timer, jiffies + 1);
 }
 
-static long clock_cmos_diff;
-static unsigned long sleep_start;
-
-static int timer_suspend(struct sys_device *dev, pm_message_t state)
-{
-	/*
-	 * Estimate time zone so that set_time can update the clock
-	 */
-	unsigned long ctime =  get_cmos_time();
-
-	clock_cmos_diff = -ctime;
-	clock_cmos_diff += get_seconds();
-	sleep_start = ctime;
-	return 0;
-}
-
 static int timer_resume(struct sys_device *dev)
 {
-	unsigned long flags;
-	unsigned long sec;
-	unsigned long ctime = get_cmos_time();
-	long sleep_length = (ctime - sleep_start) * HZ;
-	struct timespec ts;
-
-	if (sleep_length < 0) {
-		printk(KERN_WARNING "CMOS clock skew detected in timer resume!\n");
-		/* The time after the resume must not be earlier than the time
-		 * before the suspend or some nasty things will happen
-		 */
-		sleep_length = 0;
-		ctime = sleep_start;
-	}
 #ifdef CONFIG_HPET_TIMER
 	if (is_hpet_enabled())
 		hpet_reenable();
 #endif
 	setup_pit_timer();
-
-	sec = ctime + clock_cmos_diff;
-	ts.tv_sec = sec;
-	ts.tv_nsec = 0;
-	do_settimeofday(&ts);
-	write_seqlock_irqsave(&xtime_lock, flags);
-	jiffies_64 += sleep_length;
-	write_sequnlock_irqrestore(&xtime_lock, flags);
 	touch_softlockup_watchdog();
 	return 0;
 }
 
 static struct sysdev_class timer_sysclass = {
 	.resume = timer_resume,
-	.suspend = timer_suspend,
 	set_kset_name("timer"),
 };
 
@@ -357,12 +317,6 @@ extern void (*late_time_init)(void);
 /* Duplicate of time_init() below, with hpet_enable part added */
 static void __init hpet_time_init(void)
 {
-	struct timespec ts;
-	ts.tv_sec = get_cmos_time();
-	ts.tv_nsec = (INITIAL_JIFFIES % HZ) * (NSEC_PER_SEC / HZ);
-
-	do_settimeofday(&ts);
-
 	if ((hpet_enable() >= 0) && hpet_use_timer) {
 		printk("Using HPET for base-timer\n");
 	}
@@ -373,7 +327,6 @@ static void __init hpet_time_init(void)
 
 void __init time_init(void)
 {
-	struct timespec ts;
 #ifdef CONFIG_HPET_TIMER
 	if (is_hpet_capable()) {
 		/*
@@ -384,10 +337,5 @@ void __init time_init(void)
 		return;
 	}
 #endif
-	ts.tv_sec = get_cmos_time();
-	ts.tv_nsec = (INITIAL_JIFFIES % HZ) * (NSEC_PER_SEC / HZ);
-
-	do_settimeofday(&ts);
-
 	do_time_init();
 }

--

