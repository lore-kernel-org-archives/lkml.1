Return-Path: <linux-kernel-owner+w=401wt.eu-S1761255AbXEKQs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761255AbXEKQs3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 12:48:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757929AbXEKQsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 12:48:20 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37711 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753661AbXEKQsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 12:48:19 -0400
Date: Fri, 11 May 2007 09:47:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>,
       linux-acpi@vger.kernel.org
Subject: Re: [patch 3/3] clockevents: Fix resume logic - updated version
Message-Id: <20070511094750.e91ea55b.akpm@linux-foundation.org>
In-Reply-To: <200705102212.08046.rjw@sisk.pl>
References: <20070430102837.748238000@linutronix.de>
	<20070510021841.2dff9233.akpm@linux-foundation.org>
	<1178789261.4646.9.camel@chaos>
	<200705102212.08046.rjw@sisk.pl>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007 22:12:07 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Thursday, 10 May 2007 11:27, Thomas Gleixner wrote:
> > On Thu, 2007-05-10 at 02:18 -0700, Andrew Morton wrote:
> > > > > > If that patch makes the problem go away, then we should have a quite
> > > > > > good hint what we need to look at.
> > > > > 
> > > > > No joy, sorry.  It still hangs at the last statement in acpi_evaluate_object().
> > > > 
> > > > Can you add "nolapic_timer" to the command line please ?
> > > > 
> > > 
> > > That works.
> > 
> > Ok, that boils it down to the change, which affects the lapic timer
> > resume. It does nothing else, than fiddling in some APIC registers, but
> > I don't see how this affects the ACPI stuff. This smells extremly fishy.
> 
> Hmm, I wonder if it might be related to the execution of the _GTS ACPI control
> method in acpi_enter_sleep_state_prep() in violation of the spec.
> 
> Andrew, could you please try to apply the following change on top of the
> previous ones and see if the machine still hangs in the same place without
> "nolapic_timer"?
> 
> ---
>  drivers/acpi/hardware/hwsleep.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6.21/drivers/acpi/hardware/hwsleep.c
> ===================================================================
> --- linux-2.6.21.orig/drivers/acpi/hardware/hwsleep.c
> +++ linux-2.6.21/drivers/acpi/hardware/hwsleep.c
> @@ -200,10 +200,10 @@ acpi_status acpi_enter_sleep_state_prep(
>  		return_ACPI_STATUS(status);
>  	}
>  
> -	status = acpi_evaluate_object(NULL, METHOD_NAME__GTS, &arg_list, NULL);
> +	/*status = acpi_evaluate_object(NULL, METHOD_NAME__GTS, &arg_list, NULL);
>  	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
>  		return_ACPI_STATUS(status);
> -	}
> +	}*/
>  
>  	/* Setup the argument to _SST */
>  

I tested this against Thomas's original patch (below).  Still hangs, in the
same way.

From: Thomas Gleixner <tglx@linutronix.de>

We need to make sure that the clockevent devices are resumed before the
tick is resumed.  The current resume logic does not guarantee this.

Add CLOCK_EVT_MODE_RESUME and call the set mode functions of the clock
event devices before resuming the tick / oneshot functionality.

Fixup the existing users.

Fix the PIT handling of CLOCK_EVT_SHUTDOWN by disabling the interrupt
instead of switching to oneshot mode, as this causes slowness on a couple
of systems.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/apic.c      |    3 +
 arch/i386/kernel/hpet.c      |   71 ++-------------------------------
 arch/i386/kernel/i8253.c     |   43 +++++++++++++------
 include/linux/clockchips.h   |    1 
 kernel/time/tick-broadcast.c |    4 +
 kernel/time/tick-common.c    |   16 ++++---
 6 files changed, 51 insertions(+), 87 deletions(-)

diff -puN arch/i386/kernel/apic.c~clockevents-fix-resume-logic-updated-version arch/i386/kernel/apic.c
--- a/arch/i386/kernel/apic.c~clockevents-fix-resume-logic-updated-version
+++ a/arch/i386/kernel/apic.c
@@ -263,6 +263,9 @@ static void lapic_timer_setup(enum clock
 		v |= (APIC_LVT_MASKED | LOCAL_TIMER_VECTOR);
 		apic_write_around(APIC_LVTT, v);
 		break;
+	case CLOCK_EVT_MODE_RESUME:
+		/* Nothing to do here */
+		break;
 	}
 
 	local_irq_restore(flags);
diff -puN arch/i386/kernel/hpet.c~clockevents-fix-resume-logic-updated-version arch/i386/kernel/hpet.c
--- a/arch/i386/kernel/hpet.c~clockevents-fix-resume-logic-updated-version
+++ a/arch/i386/kernel/hpet.c
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
diff -puN arch/i386/kernel/i8253.c~clockevents-fix-resume-logic-updated-version arch/i386/kernel/i8253.c
--- a/arch/i386/kernel/i8253.c~clockevents-fix-resume-logic-updated-version
+++ a/arch/i386/kernel/i8253.c
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
@@ -26,6 +26,24 @@ EXPORT_SYMBOL(i8253_lock);
  */
 struct clock_event_device *global_clock_event;
 
+/* Status of the PIT interrupt */
+static int pit_irq_disabled;
+
+/*
+ * Control pit interrupt enable / disable
+ */
+static void pit_control_irq(int disable)
+{
+	if (pit_irq_disabled == disable)
+		return;
+
+	pit_irq_disabled = disable;
+	if (disable)
+		disable_irq(0);
+	else
+		enable_irq(0);
+}
+
 /*
  * Initialize the PIT timer.
  *
@@ -42,26 +60,23 @@ static void init_pit_timer(enum clock_ev
 	case CLOCK_EVT_MODE_PERIODIC:
 		/* binary, mode 2, LSB/MSB, ch 0 */
 		outb_p(0x34, PIT_MODE);
-		udelay(10);
 		outb_p(LATCH & 0xff , PIT_CH0);	/* LSB */
-		udelay(10);
 		outb(LATCH >> 8 , PIT_CH0);	/* MSB */
+		pit_control_irq(0);
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
+		pit_control_irq(1);
+		break;
 	case CLOCK_EVT_MODE_ONESHOT:
 		/* One shot setup */
 		outb_p(0x38, PIT_MODE);
-		udelay(10);
+		pit_control_irq(0);
+		break;
+
+	case CLOCK_EVT_MODE_RESUME:
+		/* Nothing to do here */
 		break;
 	}
 	spin_unlock_irqrestore(&i8253_lock, flags);
diff -puN include/linux/clockchips.h~clockevents-fix-resume-logic-updated-version include/linux/clockchips.h
--- a/include/linux/clockchips.h~clockevents-fix-resume-logic-updated-version
+++ a/include/linux/clockchips.h
@@ -23,6 +23,7 @@ enum clock_event_mode {
 	CLOCK_EVT_MODE_SHUTDOWN,
 	CLOCK_EVT_MODE_PERIODIC,
 	CLOCK_EVT_MODE_ONESHOT,
+	CLOCK_EVT_MODE_RESUME,
 };
 
 /* Clock event notification values */
diff -puN kernel/time/tick-broadcast.c~clockevents-fix-resume-logic-updated-version kernel/time/tick-broadcast.c
--- a/kernel/time/tick-broadcast.c~clockevents-fix-resume-logic-updated-version
+++ a/kernel/time/tick-broadcast.c
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
diff -puN kernel/time/tick-common.c~clockevents-fix-resume-logic-updated-version kernel/time/tick-common.c
--- a/kernel/time/tick-common.c~clockevents-fix-resume-logic-updated-version
+++ a/kernel/time/tick-common.c
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
_

