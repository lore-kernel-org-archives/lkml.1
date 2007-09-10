Return-Path: <linux-kernel-owner+w=401wt.eu-S1761619AbXIJV4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761619AbXIJV4Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 17:56:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760947AbXIJV4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 17:56:04 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34084 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760796AbXIJV4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 17:56:01 -0400
Date: Mon, 10 Sep 2007 14:47:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: clockevents: fix resume logic
Message-Id: <20070910144740.4eba2fda.akpm@linux-foundation.org>
In-Reply-To: <200707220159.l6M1xBgH001236@hera.kernel.org>
References: <200707220159.l6M1xBgH001236@hera.kernel.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Jul 2007 01:59:11 GMT Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:

> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=18de5bc4c1f1f1fa5e14f354a7603bd6e9d4e3b6
> Commit:     18de5bc4c1f1f1fa5e14f354a7603bd6e9d4e3b6
> Parent:     93da56efcf8c6a111f0349f6b7651172d4745ca0
> Author:     Thomas Gleixner <tglx@linutronix.de>
> AuthorDate: Sat Jul 21 04:37:34 2007 -0700
> Committer:  Linus Torvalds <torvalds@woody.linux-foundation.org>
> CommitDate: Sat Jul 21 17:49:15 2007 -0700
> 
>     clockevents: fix resume logic
>     
>     We need to make sure, that the clockevent devices are resumed, before
>     the tick is resumed. The current resume logic does not guarantee this.
>     
>     Add CLOCK_EVT_MODE_RESUME and call the set mode functions of the clock
>     event devices before resuming the tick / oneshot functionality.
>     
>     Fixup the existing users.
>     
>     Thanks to Nigel Cunningham for tracking down a long standing thinko,
>     which affected the jinxed VAIO.
>     

This patch broke the jinxed vaio.

Which is a bit odd, considering that I must have tested it at the time. 
But I bisected it right down to this commit, and the below revert patch
fixed it up.

The symptoms are that with this patch applied, resume-from-RAM will get
stuck partway through doing its stuff.  If I then repeatedly hit a key on
the keyboard, resume will struggle through and complete.  The system time
is then a few seconds behind the time which `hwclock' says, so it looks
like we're also not restoring the time correctly.

Also, a `reboot -f' get stuck in the same way.  No progress until I start
hitting a key.


With the below revert patch against current-Linus-mainline, resume-from-RAM
does work correctly.  However suspend-to-disk is still busted, in the same
way: I need to repeatedly hit a key to make progress.



From: Andrew Morton <akpm@linux-foundation.org>

Revert:

commit 18de5bc4c1f1f1fa5e14f354a7603bd6e9d4e3b6
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Sat Jul 21 04:37:34 2007 -0700

    clockevents: fix resume logic
    
    We need to make sure, that the clockevent devices are resumed, before
    the tick is resumed. The current resume logic does not guarantee this.
    
    Add CLOCK_EVT_MODE_RESUME and call the set mode functions of the clock
    event devices before resuming the tick / oneshot functionality.
    
    Fixup the existing users.
    
    Thanks to Nigel Cunningham for tracking down a long standing thinko,
    which affected the jinxed VAIO.


It causes the following on the Vaio:

- resume-from-ram gets stuck and requires repeated hitting of a key for it
  to make progress

- `reboot -f' fails in the same way, with the same fix

- the system time after resume is wrong: it is behind the hwclock time by a
  period which appears to be equal to the time spent in suspend


Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-davinci/time.c      |    2 
 arch/arm/mach-imx/time.c          |    1 
 arch/arm/mach-ixp4xx/common.c     |    2 
 arch/arm/mach-omap1/time.c        |    1 
 arch/arm/plat-omap/timer32k.c     |    2 
 arch/i386/kernel/apic.c           |    3 -
 arch/i386/kernel/hpet.c           |   71 ++++++++++++++++++++++++++--
 arch/i386/kernel/i8253.c          |   29 +++++------
 arch/i386/kernel/vmiclock.c       |    1 
 arch/i386/xen/time.c              |    3 -
 arch/sh/kernel/timers/timer-tmu.c |    1 
 arch/sparc64/kernel/time.c        |    1 
 drivers/lguest/lguest.c           |    2 
 include/linux/clockchips.h        |    1 
 kernel/time/tick-broadcast.c      |    6 --
 kernel/time/tick-common.c         |   16 ++----
 16 files changed, 88 insertions(+), 54 deletions(-)

diff -puN arch/arm/mach-davinci/time.c~a arch/arm/mach-davinci/time.c
--- a/arch/arm/mach-davinci/time.c~a
+++ a/arch/arm/mach-davinci/time.c
@@ -285,8 +285,6 @@ static void davinci_set_mode(enum clock_
 	case CLOCK_EVT_MODE_SHUTDOWN:
 		t->opts = TIMER_OPTS_DISABLED;
 		break;
-	case CLOCK_EVT_MODE_RESUME:
-		break;
 	}
 }
 
diff -puN arch/arm/mach-imx/time.c~a arch/arm/mach-imx/time.c
--- a/arch/arm/mach-imx/time.c~a
+++ a/arch/arm/mach-imx/time.c
@@ -159,7 +159,6 @@ static void imx_set_mode(enum clock_even
 		break;
 	case CLOCK_EVT_MODE_SHUTDOWN:
 	case CLOCK_EVT_MODE_UNUSED:
-	case CLOCK_EVT_MODE_RESUME:
 		/* Left event sources disabled, no more interrupts appears */
 		break;
 	}
diff -puN arch/arm/mach-ixp4xx/common.c~a arch/arm/mach-ixp4xx/common.c
--- a/arch/arm/mach-ixp4xx/common.c~a
+++ a/arch/arm/mach-ixp4xx/common.c
@@ -459,8 +459,6 @@ static void ixp4xx_set_mode(enum clock_e
 	default:
 		osrt = opts = 0;
 		break;
-	case CLOCK_EVT_MODE_RESUME:
-		break;
 	}
 
 	*IXP4XX_OSRT1 = osrt | opts;
diff -puN arch/arm/mach-omap1/time.c~a arch/arm/mach-omap1/time.c
--- a/arch/arm/mach-omap1/time.c~a
+++ a/arch/arm/mach-omap1/time.c
@@ -156,7 +156,6 @@ static void omap_mpu_set_mode(enum clock
 		break;
 	case CLOCK_EVT_MODE_UNUSED:
 	case CLOCK_EVT_MODE_SHUTDOWN:
-	case CLOCK_EVT_MODE_RESUME:
 		break;
 	}
 }
diff -puN arch/arm/plat-omap/timer32k.c~a arch/arm/plat-omap/timer32k.c
--- a/arch/arm/plat-omap/timer32k.c~a
+++ a/arch/arm/plat-omap/timer32k.c
@@ -157,8 +157,6 @@ static void omap_32k_timer_set_mode(enum
 	case CLOCK_EVT_MODE_UNUSED:
 	case CLOCK_EVT_MODE_SHUTDOWN:
 		break;
-	case CLOCK_EVT_MODE_RESUME:
-		break;
 	}
 }
 
diff -puN arch/i386/kernel/apic.c~a arch/i386/kernel/apic.c
--- a/arch/i386/kernel/apic.c~a
+++ a/arch/i386/kernel/apic.c
@@ -264,9 +264,6 @@ static void lapic_timer_setup(enum clock
 		v |= (APIC_LVT_MASKED | LOCAL_TIMER_VECTOR);
 		apic_write_around(APIC_LVTT, v);
 		break;
-	case CLOCK_EVT_MODE_RESUME:
-		/* Nothing to do here */
-		break;
 	}
 
 	local_irq_restore(flags);
diff -puN arch/i386/kernel/hpet.c~a arch/i386/kernel/hpet.c
--- a/arch/i386/kernel/hpet.c~a
+++ a/arch/i386/kernel/hpet.c
@@ -188,10 +188,6 @@ static void hpet_set_mode(enum clock_eve
 		cfg &= ~HPET_TN_ENABLE;
 		hpet_writel(cfg, HPET_T0_CFG);
 		break;
-
-	case CLOCK_EVT_MODE_RESUME:
-		hpet_enable_int();
-		break;
 	}
 }
 
@@ -222,7 +218,6 @@ static struct clocksource clocksource_hp
 	.mask		= HPET_MASK,
 	.shift		= HPET_SHIFT,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
-	.resume		= hpet_start_counter,
 };
 
 /*
@@ -319,6 +314,7 @@ int __init hpet_enable(void)
 
 	clocksource_register(&clocksource_hpet);
 
+
 	if (id & HPET_ID_LEGSUP) {
 		hpet_enable_int();
 		hpet_reserve_platform_timers(id);
@@ -551,3 +547,68 @@ irqreturn_t hpet_rtc_interrupt(int irq, 
 	return IRQ_HANDLED;
 }
 #endif
+
+
+/*
+ * Suspend/resume part
+ */
+
+#ifdef CONFIG_PM
+
+static int hpet_suspend(struct sys_device *sys_device, pm_message_t state)
+{
+	unsigned long cfg = hpet_readl(HPET_CFG);
+
+	cfg &= ~(HPET_CFG_ENABLE|HPET_CFG_LEGACY);
+	hpet_writel(cfg, HPET_CFG);
+
+	return 0;
+}
+
+static int hpet_resume(struct sys_device *sys_device)
+{
+	unsigned int id;
+
+	hpet_start_counter();
+
+	id = hpet_readl(HPET_ID);
+
+	if (id & HPET_ID_LEGSUP)
+		hpet_enable_int();
+
+	return 0;
+}
+
+static struct sysdev_class hpet_class = {
+	set_kset_name("hpet"),
+	.suspend	= hpet_suspend,
+	.resume		= hpet_resume,
+};
+
+static struct sys_device hpet_device = {
+	.id		= 0,
+	.cls		= &hpet_class,
+};
+
+
+static __init int hpet_register_sysfs(void)
+{
+	int err;
+
+	if (!is_hpet_capable())
+		return 0;
+
+	err = sysdev_class_register(&hpet_class);
+
+	if (!err) {
+		err = sysdev_register(&hpet_device);
+		if (err)
+			sysdev_class_unregister(&hpet_class);
+	}
+
+	return err;
+}
+
+device_initcall(hpet_register_sysfs);
+
+#endif
diff -puN arch/i386/kernel/i8253.c~a arch/i386/kernel/i8253.c
--- a/arch/i386/kernel/i8253.c~a
+++ a/arch/i386/kernel/i8253.c
@@ -3,11 +3,11 @@
  *
  */
 #include <linux/clockchips.h>
-#include <linux/init.h>
-#include <linux/interrupt.h>
+#include <linux/spinlock.h>
 #include <linux/jiffies.h>
+#include <linux/sysdev.h>
 #include <linux/module.h>
-#include <linux/spinlock.h>
+#include <linux/init.h>
 
 #include <asm/smp.h>
 #include <asm/delay.h>
@@ -40,27 +40,26 @@ static void init_pit_timer(enum clock_ev
 	case CLOCK_EVT_MODE_PERIODIC:
 		/* binary, mode 2, LSB/MSB, ch 0 */
 		outb_p(0x34, PIT_MODE);
+		udelay(10);
 		outb_p(LATCH & 0xff , PIT_CH0);	/* LSB */
+		udelay(10);
 		outb(LATCH >> 8 , PIT_CH0);	/* MSB */
 		break;
 
+	/*
+	 * Avoid unnecessary state transitions, as it confuses
+	 * Geode / Cyrix based boxen.
+	 */
 	case CLOCK_EVT_MODE_SHUTDOWN:
+		if (evt->mode == CLOCK_EVT_MODE_UNUSED)
+			break;
 	case CLOCK_EVT_MODE_UNUSED:
-		if (evt->mode == CLOCK_EVT_MODE_PERIODIC ||
-		    evt->mode == CLOCK_EVT_MODE_ONESHOT) {
-			outb_p(0x30, PIT_MODE);
-			outb_p(0, PIT_CH0);
-			outb_p(0, PIT_CH0);
-		}
-		break;
-
+		if (evt->mode == CLOCK_EVT_MODE_SHUTDOWN)
+			break;
 	case CLOCK_EVT_MODE_ONESHOT:
 		/* One shot setup */
 		outb_p(0x38, PIT_MODE);
-		break;
-
-	case CLOCK_EVT_MODE_RESUME:
-		/* Nothing to do here */
+		udelay(10);
 		break;
 	}
 	spin_unlock_irqrestore(&i8253_lock, flags);
diff -puN arch/i386/kernel/vmiclock.c~a arch/i386/kernel/vmiclock.c
--- a/arch/i386/kernel/vmiclock.c~a
+++ a/arch/i386/kernel/vmiclock.c
@@ -143,7 +143,6 @@ static void vmi_timer_set_mode(enum cloc
 
 	switch (mode) {
 	case CLOCK_EVT_MODE_ONESHOT:
-	case CLOCK_EVT_MODE_RESUME:
 		break;
 	case CLOCK_EVT_MODE_PERIODIC:
 		cycles_per_hz = vmi_timer_ops.get_cycle_frequency();
diff -puN arch/i386/xen/time.c~a arch/i386/xen/time.c
--- a/arch/i386/xen/time.c~a
+++ a/arch/i386/xen/time.c
@@ -412,7 +412,6 @@ static void xen_timerop_set_mode(enum cl
 		break;
 
 	case CLOCK_EVT_MODE_ONESHOT:
-	case CLOCK_EVT_MODE_RESUME:
 		break;
 
 	case CLOCK_EVT_MODE_UNUSED:
@@ -475,8 +474,6 @@ static void xen_vcpuop_set_mode(enum clo
 		    HYPERVISOR_vcpu_op(VCPUOP_stop_periodic_timer, cpu, NULL))
 			BUG();
 		break;
-	case CLOCK_EVT_MODE_RESUME:
-		break;
 	}
 }
 
diff -puN arch/sh/kernel/timers/timer-tmu.c~a arch/sh/kernel/timers/timer-tmu.c
--- a/arch/sh/kernel/timers/timer-tmu.c~a
+++ a/arch/sh/kernel/timers/timer-tmu.c
@@ -80,7 +80,6 @@ static void tmu_set_mode(enum clock_even
 		break;
 	case CLOCK_EVT_MODE_UNUSED:
 	case CLOCK_EVT_MODE_SHUTDOWN:
-	case CLOCK_EVT_MODE_RESUME:
 		break;
 	}
 }
diff -puN arch/sparc64/kernel/time.c~a arch/sparc64/kernel/time.c
--- a/arch/sparc64/kernel/time.c~a
+++ a/arch/sparc64/kernel/time.c
@@ -882,7 +882,6 @@ static void sparc64_timer_setup(enum clo
 {
 	switch (mode) {
 	case CLOCK_EVT_MODE_ONESHOT:
-	case CLOCK_EVT_MODE_RESUME:
 		break;
 
 	case CLOCK_EVT_MODE_SHUTDOWN:
diff -puN drivers/lguest/lguest.c~a drivers/lguest/lguest.c
--- a/drivers/lguest/lguest.c~a
+++ a/drivers/lguest/lguest.c
@@ -730,8 +730,6 @@ static void lguest_clockevent_set_mode(e
 		break;
 	case CLOCK_EVT_MODE_PERIODIC:
 		BUG();
-	case CLOCK_EVT_MODE_RESUME:
-		break;
 	}
 }
 
diff -puN include/linux/clockchips.h~a include/linux/clockchips.h
--- a/include/linux/clockchips.h~a
+++ a/include/linux/clockchips.h
@@ -23,7 +23,6 @@ enum clock_event_mode {
 	CLOCK_EVT_MODE_SHUTDOWN,
 	CLOCK_EVT_MODE_PERIODIC,
 	CLOCK_EVT_MODE_ONESHOT,
-	CLOCK_EVT_MODE_RESUME,
 };
 
 /* Clock event notification values */
diff -puN kernel/time/tick-broadcast.c~a kernel/time/tick-broadcast.c
--- a/kernel/time/tick-broadcast.c~a
+++ a/kernel/time/tick-broadcast.c
@@ -55,7 +55,7 @@ cpumask_t *tick_get_broadcast_mask(void)
  */
 static void tick_broadcast_start_periodic(struct clock_event_device *bc)
 {
-	if (bc)
+	if (bc && bc->mode == CLOCK_EVT_MODE_SHUTDOWN)
 		tick_setup_periodic(bc, 1);
 }
 
@@ -316,7 +316,7 @@ void tick_suspend_broadcast(void)
 	spin_lock_irqsave(&tick_broadcast_lock, flags);
 
 	bc = tick_broadcast_device.evtdev;
-	if (bc)
+	if (bc && tick_broadcast_device.mode == TICKDEV_MODE_PERIODIC)
 		clockevents_set_mode(bc, CLOCK_EVT_MODE_SHUTDOWN);
 
 	spin_unlock_irqrestore(&tick_broadcast_lock, flags);
@@ -333,8 +333,6 @@ int tick_resume_broadcast(void)
 	bc = tick_broadcast_device.evtdev;
 
 	if (bc) {
-		clockevents_set_mode(bc, CLOCK_EVT_MODE_RESUME);
-
 		switch (tick_broadcast_device.mode) {
 		case TICKDEV_MODE_PERIODIC:
 			if(!cpus_empty(tick_broadcast_mask))
diff -puN kernel/time/tick-common.c~a kernel/time/tick-common.c
--- a/kernel/time/tick-common.c~a
+++ a/kernel/time/tick-common.c
@@ -318,17 +318,12 @@ static void tick_resume(void)
 {
 	struct tick_device *td = &__get_cpu_var(tick_cpu_device);
 	unsigned long flags;
-	int broadcast = tick_resume_broadcast();
 
 	spin_lock_irqsave(&tick_device_lock, flags);
-	clockevents_set_mode(td->evtdev, CLOCK_EVT_MODE_RESUME);
-
-	if (!broadcast) {
-		if (td->mode == TICKDEV_MODE_PERIODIC)
-			tick_setup_periodic(td->evtdev, 0);
-		else
-			tick_resume_oneshot();
-	}
+	if (td->mode == TICKDEV_MODE_PERIODIC)
+		tick_setup_periodic(td->evtdev, 0);
+	else
+		tick_resume_oneshot();
 	spin_unlock_irqrestore(&tick_device_lock, flags);
 }
 
@@ -365,7 +360,8 @@ static int tick_notify(struct notifier_b
 		break;
 
 	case CLOCK_EVT_NOTIFY_RESUME:
-		tick_resume();
+		if (!tick_resume_broadcast())
+			tick_resume();
 		break;
 
 	default:
_

