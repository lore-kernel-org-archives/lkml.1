Return-Path: <linux-kernel-owner+w=401wt.eu-S1031076AbXD2TXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031076AbXD2TXZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 15:23:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031283AbXD2TXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 15:23:25 -0400
Received: from www.osadl.org ([213.239.205.134]:46226 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1031076AbXD2TXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 15:23:24 -0400
Subject: Re: [2.6.21] BUG: clocksource_watchdog isn't reset after resume
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Indan Zupancic <indan@nul.nu>
Cc: johnstul@us.ibm.com, linux-kernel@vger.kernel.org
In-Reply-To: <4655.81.207.0.53.1177863612.squirrel@secure.samage.net>
References: <4655.81.207.0.53.1177863612.squirrel@secure.samage.net>
Content-Type: text/plain
Date: Sun, 29 Apr 2007 21:25:32 +0200
Message-Id: <1177874733.5791.137.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-04-29 at 18:20 +0200, Indan Zupancic wrote:
> Hello,
> 
> After s2ram, basically the following happens, which shouldn't happen:
> 
> [    0.880234] Clocksource tsc unstable (delta = 449782067799 ns)
> [    0.881221] Time: pit clocksource has been installed.
> 
> Looking at the source, it seems that clocksource_watchdog isn't reset
> after resume, while the clock source used is, and hence it thinks that
> the clock is unstable.

Yup, missed that. I was looking into the resume path anyway for other
reasons. Does the patch below fix your problem ?

	tglx

Index: linux-2.6/arch/i386/kernel/apic.c
===================================================================
--- linux-2.6.orig/arch/i386/kernel/apic.c
+++ linux-2.6/arch/i386/kernel/apic.c
@@ -242,6 +242,9 @@ static void lapic_timer_setup(enum clock
 		v |= (APIC_LVT_MASKED | LOCAL_TIMER_VECTOR);
 		apic_write_around(APIC_LVTT, v);
 		break;
+	case CLOCK_EVT_MODE_RESUME:
+		/* Nothing to do here */
+		break;
 	}
 
 	local_irq_restore(flags);
Index: linux-2.6/arch/i386/kernel/hpet.c
===================================================================
--- linux-2.6.orig/arch/i386/kernel/hpet.c
+++ linux-2.6/arch/i386/kernel/hpet.c
@@ -187,6 +187,10 @@ static void hpet_set_mode(enum clock_eve
 		cfg &= ~HPET_TN_ENABLE;
 		hpet_writel(cfg, HPET_T0_CFG);
 		break;
+
+	case CLOCK_EVT_MODE_RESUME:
+		hpet_enable_int();
+		break;
 	}
 }
 
@@ -217,6 +221,7 @@ static struct clocksource clocksource_hp
 	.mask		= HPET_MASK,
 	.shift		= HPET_SHIFT,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
+	.resume		= hpet_start_counter,
 };
 
 /*
@@ -291,7 +296,6 @@ int __init hpet_enable(void)
 
 	clocksource_register(&clocksource_hpet);
 
-
 	if (id & HPET_ID_LEGSUP) {
 		hpet_enable_int();
 		hpet_reserve_platform_timers(id);
@@ -524,68 +528,3 @@ irqreturn_t hpet_rtc_interrupt(int irq, 
 	return IRQ_HANDLED;
 }
 #endif
-
-
-/*
- * Suspend/resume part
- */
-
-#ifdef CONFIG_PM
-
-static int hpet_suspend(struct sys_device *sys_device, pm_message_t state)
-{
-	unsigned long cfg = hpet_readl(HPET_CFG);
-
-	cfg &= ~(HPET_CFG_ENABLE|HPET_CFG_LEGACY);
-	hpet_writel(cfg, HPET_CFG);
-
-	return 0;
-}
-
-static int hpet_resume(struct sys_device *sys_device)
-{
-	unsigned int id;
-
-	hpet_start_counter();
-
-	id = hpet_readl(HPET_ID);
-
-	if (id & HPET_ID_LEGSUP)
-		hpet_enable_int();
-
-	return 0;
-}
-
-static struct sysdev_class hpet_class = {
-	set_kset_name("hpet"),
-	.suspend	= hpet_suspend,
-	.resume		= hpet_resume,
-};
-
-static struct sys_device hpet_device = {
-	.id		= 0,
-	.cls		= &hpet_class,
-};
-
-
-static __init int hpet_register_sysfs(void)
-{
-	int err;
-
-	if (!is_hpet_capable())
-		return 0;
-
-	err = sysdev_class_register(&hpet_class);
-
-	if (!err) {
-		err = sysdev_register(&hpet_device);
-		if (err)
-			sysdev_class_unregister(&hpet_class);
-	}
-
-	return err;
-}
-
-device_initcall(hpet_register_sysfs);
-
-#endif
Index: linux-2.6/arch/i386/kernel/i8253.c
===================================================================
--- linux-2.6.orig/arch/i386/kernel/i8253.c
+++ linux-2.6/arch/i386/kernel/i8253.c
@@ -62,6 +62,10 @@ static void init_pit_timer(enum clock_ev
 		outb_p(0x38, PIT_MODE);
 		udelay(10);
 		break;
+
+	case CLOCK_EVT_MODE_RESUME:
+		/* Nothing to do here */
+		break;
 	}
 	spin_unlock_irqrestore(&i8253_lock, flags);
 }
Index: linux-2.6/include/linux/clockchips.h
===================================================================
--- linux-2.6.orig/include/linux/clockchips.h
+++ linux-2.6/include/linux/clockchips.h
@@ -23,6 +23,7 @@ enum clock_event_mode {
 	CLOCK_EVT_MODE_SHUTDOWN,
 	CLOCK_EVT_MODE_PERIODIC,
 	CLOCK_EVT_MODE_ONESHOT,
+	CLOCK_EVT_MODE_RESUME,
 };
 
 /* Clock event notification values */
Index: linux-2.6/include/linux/clocksource.h
===================================================================
--- linux-2.6.orig/include/linux/clocksource.h
+++ linux-2.6/include/linux/clocksource.h
@@ -48,6 +48,7 @@ struct clocksource;
  * @shift:		cycle to nanosecond divisor (power of two)
  * @flags:		flags describing special properties
  * @vread:		vsyscall based read
+ * @resume:		resume function for the clocksource, if necessary
  * @cycle_interval:	Used internally by timekeeping core, please ignore.
  * @xtime_interval:	Used internally by timekeeping core, please ignore.
  */
@@ -61,6 +62,7 @@ struct clocksource {
 	u32 shift;
 	unsigned long flags;
 	cycle_t (*vread)(void);
+	void (*resume)(void);
 
 	/* timekeeping specific data, ignore */
 	cycle_t cycle_last, cycle_interval;
@@ -198,6 +200,7 @@ static inline void clocksource_calculate
 extern int clocksource_register(struct clocksource*);
 extern struct clocksource* clocksource_get_next(void);
 extern void clocksource_change_rating(struct clocksource *cs, int rating);
+extern void clocksource_resume(void);
 
 #ifdef CONFIG_GENERIC_TIME_VSYSCALL
 extern void update_vsyscall(struct timespec *ts, struct clocksource *c);
Index: linux-2.6/kernel/time/clocksource.c
===================================================================
--- linux-2.6.orig/kernel/time/clocksource.c
+++ linux-2.6/kernel/time/clocksource.c
@@ -74,6 +74,8 @@ static struct clocksource *watchdog;
 static struct timer_list watchdog_timer;
 static DEFINE_SPINLOCK(watchdog_lock);
 static cycle_t watchdog_last;
+static int watchdog_resumed;
+
 /*
  * Interval: 0.5sec Treshold: 0.0625s
  */
@@ -98,15 +100,26 @@ static void clocksource_watchdog(unsigne
 	struct clocksource *cs, *tmp;
 	cycle_t csnow, wdnow;
 	int64_t wd_nsec, cs_nsec;
+	int resumed;
 
 	spin_lock(&watchdog_lock);
 
+	resumed = watchdog_resumed;
+	if (unlikely(resumed))
+		watchdog_resumed = 0;
+
 	wdnow = watchdog->read();
 	wd_nsec = cyc2ns(watchdog, (wdnow - watchdog_last) & watchdog->mask);
 	watchdog_last = wdnow;
 
 	list_for_each_entry_safe(cs, tmp, &watchdog_list, wd_list) {
 		csnow = cs->read();
+
+		if (unlikely(resumed)) {
+			cs->wd_last = csnow;
+			continue;
+		}
+
 		/* Initialized ? */
 		if (!(cs->flags & CLOCK_SOURCE_WATCHDOG)) {
 			if ((cs->flags & CLOCK_SOURCE_IS_CONTINUOUS) &&
@@ -136,6 +149,13 @@ static void clocksource_watchdog(unsigne
 	}
 	spin_unlock(&watchdog_lock);
 }
+static void clocksource_resume_watchdog(void)
+{
+	spin_lock(&watchdog_lock);
+	watchdog_resumed = 1;
+	spin_unlock(&watchdog_lock);
+}
+
 static void clocksource_check_watchdog(struct clocksource *cs)
 {
 	struct clocksource *cse;
@@ -182,9 +202,34 @@ static void clocksource_check_watchdog(s
 	if (cs->flags & CLOCK_SOURCE_IS_CONTINUOUS)
 		cs->flags |= CLOCK_SOURCE_VALID_FOR_HRES;
 }
+
+static inline void clocksource_resume_watchdog(void) { }
 #endif
 
 /**
+ * clocksource_resume - resume the clocksource(s)
+ */
+void clocksource_resume(void)
+{
+	struct list_head *tmp;
+	unsigned long flags;
+
+	spin_lock_irqsave(&clocksource_lock, flags);
+
+	list_for_each(tmp, &clocksource_list) {
+		struct clocksource *cs;
+
+		cs = list_entry(tmp, struct clocksource, list);
+		if (cs->resume)
+			cs->resume();
+	}
+
+	clocksource_resume_watchdog();
+
+	spin_unlock_irqrestore(&clocksource_lock, flags);
+}
+
+/**
  * clocksource_get_next - Returns the selected clocksource
  *
  */
Index: linux-2.6/kernel/time/tick-broadcast.c
===================================================================
--- linux-2.6.orig/kernel/time/tick-broadcast.c
+++ linux-2.6/kernel/time/tick-broadcast.c
@@ -309,6 +309,8 @@ int tick_resume_broadcast(void)
 	bc = tick_broadcast_device.evtdev;
 
 	if (bc) {
+		clockevents_set_mode(bc, CLOCK_EVT_MODE_RESUME);
+
 		switch (tick_broadcast_device.mode) {
 		case TICKDEV_MODE_PERIODIC:
 			if(!cpus_empty(tick_broadcast_mask))
Index: linux-2.6/kernel/time/tick-common.c
===================================================================
--- linux-2.6.orig/kernel/time/tick-common.c
+++ linux-2.6/kernel/time/tick-common.c
@@ -308,16 +308,20 @@ static void tick_suspend(void)
 	spin_unlock_irqrestore(&tick_device_lock, flags);
 }
 
-static void tick_resume(void)
+static void tick_resume(int broadcast)
 {
 	struct tick_device *td = &__get_cpu_var(tick_cpu_device);
 	unsigned long flags;
 
 	spin_lock_irqsave(&tick_device_lock, flags);
-	if (td->mode == TICKDEV_MODE_PERIODIC)
-		tick_setup_periodic(td->evtdev, 0);
-	else
-		tick_resume_oneshot();
+	clockevents_set_mode(td->evtdev, CLOCK_EVT_MODE_RESUME);
+
+	if (!broadcast) {
+		if (td->mode == TICKDEV_MODE_PERIODIC)
+			tick_setup_periodic(td->evtdev, 0);
+		else
+			tick_resume_oneshot();
+	}
 	spin_unlock_irqrestore(&tick_device_lock, flags);
 }
 
@@ -327,6 +331,8 @@ static void tick_resume(void)
 static int tick_notify(struct notifier_block *nb, unsigned long reason,
 			       void *dev)
 {
+	int res;
+
 	switch (reason) {
 
 	case CLOCK_EVT_NOTIFY_ADD:
@@ -354,8 +360,8 @@ static int tick_notify(struct notifier_b
 		break;
 
 	case CLOCK_EVT_NOTIFY_RESUME:
-		if (!tick_resume_broadcast())
-			tick_resume();
+		res = tick_resume_broadcast();
+		tick_resume(res);
 		break;
 
 	default:
Index: linux-2.6/kernel/timer.c
===================================================================
--- linux-2.6.orig/kernel/timer.c
+++ linux-2.6/kernel/timer.c
@@ -999,6 +999,8 @@ static int timekeeping_resume(struct sys
 	unsigned long flags;
 	unsigned long now = read_persistent_clock();
 
+	clocksource_resume();
+
 	write_seqlock_irqsave(&xtime_lock, flags);
 
 	if (now && (now > timekeeping_suspend_time)) {


