Return-Path: <linux-kernel-owner+w=401wt.eu-S1759228AbXEIVXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759228AbXEIVXm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 17:23:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757676AbXEIVXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 17:23:34 -0400
Received: from www.osadl.org ([213.239.205.134]:45470 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757005AbXEIVXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 17:23:32 -0400
Subject: Re: [patch 3/3] clockevents: Fix resume logic - updated version
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>,
       linux-acpi@vger.kernel.org
In-Reply-To: <200705092253.49896.rjw@sisk.pl>
References: <20070430102837.748238000@linutronix.de>
	 <200705092036.20953.rjw@sisk.pl>
	 <1178743550.3042.541.camel@localhost.localdomain>
	 <200705092253.49896.rjw@sisk.pl>
Content-Type: text/plain
Date: Wed, 09 May 2007 23:26:22 +0200
Message-Id: <1178745983.3042.565.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-09 at 22:53 +0200, Rafael J. Wysocki wrote:
> On Wednesday, 9 May 2007 22:45, Thomas Gleixner wrote:
> > On Wed, 2007-05-09 at 20:36 +0200, Rafael J. Wysocki wrote:
> > > Well, apparently, not in -mm2:
> > > 
> > > rafael@albercik:~/src/mm/linux-2.6.21-mm2> grep -r -I -l 'timekeeping_resume' *
> > > kernel/time/timekeeping.c
> > > rafael@albercik:~/src/mm/linux-2.6.21-mm2> grep clocksource_resume kernel/time/timekeeping.c
> > > rafael@albercik:~/src/mm/linux-2.6.21-mm2>
> > 
> > Andrew dropped the patch because it did not work on his jinxed VAIO, but
> > he debugged with the patch applied.
> 
> I see.
> 
> In that case, since timekeeping_resume() is called via sysdev_resume, then it's
> executed before acpi_leave_sleep_state() and may very well interfere with the
> ACPI methods executed from there, depending on what's happening in the
> cs->resume() callbacks in clocksource_resume().

The only difference in the clocksource_resume() path with the patch
applied on Andrews laptop is, that the watchdog for the TSC is reset.
But that's only touching some variables.

The other change is the way how the clock events are resumed. It touches
the PIT, local APIC and the interrupt controller.

Andrew,

can you test the alternative replacement patch for 

clockevents: Fix resume logic - updated version

It does not touch the interrupt controller, it does the PIT restart
different. That's a patch from Chris Wright and confirmed to work on the
affected machines - except the @%$#! VAIO of course.

If that patch makes the problem go away, then we should have a quite
good hint what we need to look at.

	tglx

Index: linux-2.6.21-git-x86-64/arch/i386/kernel/apic.c
===================================================================
--- linux-2.6.21-git-x86-64.orig/arch/i386/kernel/apic.c
+++ linux-2.6.21-git-x86-64/arch/i386/kernel/apic.c
@@ -264,6 +264,9 @@ static void lapic_timer_setup(enum clock
 		v |= (APIC_LVT_MASKED | LOCAL_TIMER_VECTOR);
 		apic_write_around(APIC_LVTT, v);
 		break;
+	case CLOCK_EVT_MODE_RESUME:
+		/* Nothing to do here */
+		break;
 	}
 
 	local_irq_restore(flags);
Index: linux-2.6.21-git-x86-64/arch/i386/kernel/hpet.c
===================================================================
--- linux-2.6.21-git-x86-64.orig/arch/i386/kernel/hpet.c
+++ linux-2.6.21-git-x86-64/arch/i386/kernel/hpet.c
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
Index: linux-2.6.21-git-x86-64/arch/i386/kernel/i8253.c
===================================================================
--- linux-2.6.21-git-x86-64.orig/arch/i386/kernel/i8253.c
+++ linux-2.6.21-git-x86-64/arch/i386/kernel/i8253.c
@@ -3,11 +3,11 @@
  *
  */
 #include <linux/clockchips.h>
-#include <linux/spinlock.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
 #include <linux/jiffies.h>
-#include <linux/sysdev.h>
 #include <linux/module.h>
-#include <linux/init.h>
+#include <linux/spinlock.h>
 
 #include <asm/smp.h>
 #include <asm/delay.h>
@@ -41,26 +41,24 @@ static void init_pit_timer(enum clock_ev
 	case CLOCK_EVT_MODE_PERIODIC:
 		/* binary, mode 2, LSB/MSB, ch 0 */
 		outb_p(0x34, PIT_MODE);
-		udelay(10);
 		outb_p(LATCH & 0xff , PIT_CH0);	/* LSB */
-		udelay(10);
 		outb(LATCH >> 8 , PIT_CH0);	/* MSB */
 		break;
 
-	/*
-	 * Avoid unnecessary state transitions, as it confuses
-	 * Geode / Cyrix based boxen.
-	 */
 	case CLOCK_EVT_MODE_SHUTDOWN:
-		if (evt->mode == CLOCK_EVT_MODE_UNUSED)
-			break;
 	case CLOCK_EVT_MODE_UNUSED:
-		if (evt->mode == CLOCK_EVT_MODE_SHUTDOWN)
-			break;
+		outb_p(0x30, PIT_MODE);
+		outb_p(0, PIT_CH0);	/* LSB */
+		outb_p(0, PIT_CH0);	/* MSB */
+		break;
+
 	case CLOCK_EVT_MODE_ONESHOT:
 		/* One shot setup */
 		outb_p(0x38, PIT_MODE);
-		udelay(10);
+		break;
+
+	case CLOCK_EVT_MODE_RESUME:
+		/* Nothing to do here */
 		break;
 	}
 	spin_unlock_irqrestore(&i8253_lock, flags);
Index: linux-2.6.21-git-x86-64/include/linux/clockchips.h
===================================================================
--- linux-2.6.21-git-x86-64.orig/include/linux/clockchips.h
+++ linux-2.6.21-git-x86-64/include/linux/clockchips.h
@@ -23,6 +23,7 @@ enum clock_event_mode {
 	CLOCK_EVT_MODE_SHUTDOWN,
 	CLOCK_EVT_MODE_PERIODIC,
 	CLOCK_EVT_MODE_ONESHOT,
+	CLOCK_EVT_MODE_RESUME,
 };
 
 /* Clock event notification values */
Index: linux-2.6.21-git-x86-64/kernel/time/tick-broadcast.c
===================================================================
--- linux-2.6.21-git-x86-64.orig/kernel/time/tick-broadcast.c
+++ linux-2.6.21-git-x86-64/kernel/time/tick-broadcast.c
@@ -292,7 +292,7 @@ void tick_suspend_broadcast(void)
 	spin_lock_irqsave(&tick_broadcast_lock, flags);
 
 	bc = tick_broadcast_device.evtdev;
-	if (bc && tick_broadcast_device.mode == TICKDEV_MODE_PERIODIC)
+	if (bc)
 		clockevents_set_mode(bc, CLOCK_EVT_MODE_SHUTDOWN);
 
 	spin_unlock_irqrestore(&tick_broadcast_lock, flags);
@@ -309,6 +309,8 @@ int tick_resume_broadcast(void)
 	bc = tick_broadcast_device.evtdev;
 
 	if (bc) {
+		clockevents_set_mode(bc, CLOCK_EVT_MODE_RESUME);
+
 		switch (tick_broadcast_device.mode) {
 		case TICKDEV_MODE_PERIODIC:
 			if(!cpus_empty(tick_broadcast_mask))
Index: linux-2.6.21-git-x86-64/kernel/time/tick-common.c
===================================================================
--- linux-2.6.21-git-x86-64.orig/kernel/time/tick-common.c
+++ linux-2.6.21-git-x86-64/kernel/time/tick-common.c
@@ -318,12 +318,17 @@ static void tick_resume(void)
 {
 	struct tick_device *td = &__get_cpu_var(tick_cpu_device);
 	unsigned long flags;
+	int broadcast = tick_resume_broadcast();
 
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
 
@@ -360,8 +365,7 @@ static int tick_notify(struct notifier_b
 		break;
 
 	case CLOCK_EVT_NOTIFY_RESUME:
-		if (!tick_resume_broadcast())
-			tick_resume();
+		tick_resume();
 		break;
 
 	default:


