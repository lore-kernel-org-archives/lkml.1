Return-Path: <linux-kernel-owner+w=401wt.eu-S966032AbXHIPCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966032AbXHIPCw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 11:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965395AbXHIPCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 11:02:40 -0400
Received: from xmrt0101.northgrum.com ([208.20.220.55]:3048 "EHLO
	xmrt0101.northgrum.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965494AbXHIPCi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 11:02:38 -0400
Subject: Re: [PATCH] s at91 timer: clockevents on sam926x
From: Andy Herzig <andrew.herzig@ngc.com>
To: linux-kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1186667286.9492.16.camel@leoh9-18574.nges.northgrum.com>
References: <1186667286.9492.16.camel@leoh9-18574.nges.northgrum.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Date: Thu, 09 Aug 2007 11:02:48 -0400
Message-Id: <1186671768.9492.27.camel@leoh9-18574.nges.northgrum.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
X-OriginalArrivalTime: 09 Aug 2007 15:02:36.0304 (UTC) FILETIME=[523D3100:01C7DA96]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-09 at 09:48 -0400, Andy Herzig wrote:
> Hello all,
> 
> I have taken a stab at implementing a clocksource and a event device on
> my AT91SAM9260. I based it on David Brownell's work on the 9200. I would
> love some feedback as I'm not confident I have everything right.
> Specifically:
> 
> - I'm not sure how to pick the .shift member of struct clocksource. It
> seems that it would be based on the register size, but it's not clear to
> me.
> 
> - More importantly, I do not get a dyn_tick file in
> the /sys/devices/system/timer/timer0 directory and can't seem to turn on
> the feature even with dyntick=enable in the kernel parameters. Have I
> missed something in the driver?
> 
> Kindly CC me on any responses as currently I only read the archives.
Use this patch instead. The other had EOL problems. Sorry

Signed-off-by: Andrew J. Herzig <andrew.herzig@ngc.com>
---
 arch/arm/Kconfig                      |    2 
 arch/arm/mach-at91/at91sam926x_time.c |  225 ++++++++++++++++++------
 2 files changed, 176 insertions(+), 51 deletions(-)
diff -uprN -X linux-2.6.23-rc2-vanilla/Documentation/dontdiff
linux-2.6.23-rc2-vanilla/arch/arm/Kconfig
linux-2.6.23-rc2-testpatch/arch/arm/Kconfig
--- linux-2.6.23-rc2-vanilla/arch/arm/Kconfig	2007-08-08
13:28:38.000000000 -0400
+++ linux-2.6.23-rc2-testpatch/arch/arm/Kconfig	2007-08-08
15:17:15.000000000 -0400
@@ -179,6 +179,8 @@ config ARCH_VERSATILE
 config ARCH_AT91
 	bool "Atmel AT91"
 	select GENERIC_GPIO
+	select GENERIC_TIME
+	select GENERIC_CLOCKEVENTS
 	help
 	  This enables support for systems based on the Atmel AT91RM9200
 	  and AT91SAM9xxx processors.
diff -uprN -X linux-2.6.23-rc2-vanilla/Documentation/dontdiff
linux-2.6.23-rc2-vanilla/arch/arm/mach-at91/at91sam926x_time.c
linux-2.6.23-rc2-testpatch/arch/arm/mach-at91/at91sam926x_time.c
--- linux-2.6.23-rc2-vanilla/arch/arm/mach-at91/at91sam926x_time.c
2007-08-08 13:28:37.000000000 -0400
+++ linux-2.6.23-rc2-testpatch/arch/arm/mach-at91/at91sam926x_time.c
2007-08-08 15:16:15.000000000 -0400
@@ -1,44 +1,57 @@
 /*
  * linux/arch/arm/mach-at91/at91sam926x_time.c
  *
- * Copyright (C) 2005-2006 M. Amine SAYA, ATMEL Rousset, France
- * Revision	 2005 M. Nicolas Diremdjian, ATMEL Rousset, France
+ * clockevents and clocksource implementation based on a compination
+ * of the PIT and RTT system hardware.
+ * Copyright (c) 2007 Andrew J. Herzig <andrew.herzig@ngc.com>.
+ *
+ * Derived largely from David Brownell's implementation for the RM9200.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
 
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
-#include <linux/time.h>
-
+#include <linux/clockchips.h>
 #include <asm/hardware.h>
 #include <asm/io.h>
 #include <asm/mach/time.h>
-
 #include <asm/arch/at91_pit.h>
+#include <asm/arch/at91_rtt.h>
 
+static struct clock_event_device clkevt;
 
-#define PIT_CPIV(x)	((x) & AT91_PIT_CPIV)
-#define PIT_PICNT(x)	(((x) & AT91_PIT_PICNT) >> 20)
+/* According to 6221D–ATARM–12-Mar-07 p.103, the status register
+ * is cleared 2 SLOW_CLOCK cycles after a read. Therefore, to avoid
+ * a race, we must wait for the register to actually clear before
+ * re-enabling interrupts. If there's a better fix for this, I don't
+ * know it.
+ */
+static inline void clear_RTT_SR(void)
+{
+	while (at91_sys_read(AT91_RTT_SR))
+		;
+}
 
 /*
- * Returns number of microseconds since last timer interrupt.  Note
that interrupts
- * will have been disabled by do_gettimeofday()
- *  'LATCH' is hwclock ticks (see CLOCK_TICK_RATE in timex.h) per
jiffy.
+ * The counter value (CRTV) is updated asychronously to the master
+ * clock, so we are advised to read RTT_VR twice to avoid glitching.
  */
-static unsigned long at91sam926x_gettimeoffset(void)
+static inline unsigned long read_CRTV(void)
 {
-	unsigned long elapsed;
-	unsigned long t = at91_sys_read(AT91_PIT_PIIR);
+	unsigned long x1, x2;
 
-	elapsed = (PIT_PICNT(t) * LATCH) + PIT_CPIV(t);		/* hardware clock
cycles */
-
-	return (unsigned long)(elapsed * jiffies_to_usecs(1)) / LATCH;
+	x1 = at91_sys_read(AT91_RTT_VR);
+	while (1) {
+		x2 = at91_sys_read(AT91_RTT_VR);
+		if (x1 == x2)
+			break;
+		x1 = x2;
+	}
+	return x1;
 }
 
 /*
@@ -48,66 +61,176 @@ static irqreturn_t at91sam926x_timer_int
 {
 	volatile long nr_ticks;
 
-	if (at91_sys_read(AT91_PIT_SR) & AT91_PIT_PITS) {	/* This is a shared
interrupt */
-		write_seqlock(&xtime_lock);
+	/* Periodic mode. */
+	if (at91_sys_read(AT91_PIT_SR) & AT91_PIT_PITS) { /* shared interrupt
*/
 
-		/* Get number to ticks performed before interrupt and clear PIT
interrupt */
-		nr_ticks = PIT_PICNT(at91_sys_read(AT91_PIT_PIVR));
+		/* Get number of system  ticks between last interrupt
+		 * and now and clear PIT interrupt. This is to support
+		 * dynticks.
+		 */
+		nr_ticks = (at91_sys_read(AT91_PIT_PIVR) & AT91_PIT_PICNT)
+			>> 20;
 		do {
-			timer_tick();
+			/* Call evt handler for every sys tick missed. */
+			clkevt.event_handler(&clkevt);
 			nr_ticks--;
 		} while (nr_ticks);
 
-		write_sequnlock(&xtime_lock);
 		return IRQ_HANDLED;
-	} else
-		return IRQ_NONE;		/* not handled */
+	}
+
+	/* "Oneshot" timer (alarm mode). */
+	if (at91_sys_read(AT91_RTT_SR) & AT91_RTT_ALMS) {
+		clear_RTT_SR();
+		clkevt.event_handler(&clkevt);
+		return IRQ_HANDLED;
+	}
+	return IRQ_NONE;		/* not handled, this IRQ is shared */
 }
 
 static struct irqaction at91sam926x_timer_irq = {
-	.name		= "at91_tick",
-	.flags		= IRQF_SHARED | IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
-	.handler	= at91sam926x_timer_interrupt
+	.name	 = "at91_tick",
+	.flags	 = IRQF_SHARED | IRQF_DISABLED
+	           | IRQF_TIMER | IRQF_IRQPOLL,
+	.handler = at91sam926x_timer_interrupt
+};
+
+static cycle_t read_clksrc(void)
+{
+	return read_CRTV();
+}
+
+static struct clocksource clksrc = {
+	.name   = "at91_rtt",
+	.rating = 150,
+	.read   = read_clksrc,
+	.mask   = CLOCKSOURCE_MASK(32),
+	.shift  = 10,
+	.flags  = CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
-void at91sam926x_timer_reset(void)
+#ifdef CONFIG_PM
+
+static void at91sam926x_timer_suspend(void)
+{
+	printk(KERN_ALERT "926x_timer_suspend\n");
+	/* Disable both PIT and RTT counters. */
+	at91_sys_write(AT91_PIT_MR, 0);
+	at91_sys_write(AT91_RTT_MR, 0);
+}
+
+static void at91sam926x_timer_resume(void)
+{
+	printk(KERN_ALERT "926x_timer_resume\n");
+	at91_sys_write(AT91_RTT_MR, 1 | AT91_RTT_RTTRST);
+	at91_sys_write(AT91_PIT_MR, (LATCH & AT91_PIT_PIV)
+		       | AT91_PIT_PITIEN | AT91_PIT_PITEN);
+}
+#else
+#define at91sam926x_timer_suspend	NULL
+#define at91sam926x_timer_resume	NULL
+#endif
+
+static void
+at91sam926x_timer_mode(enum clock_event_mode mode,
+		       struct clock_event_device *dev)
 {
-	/* Disable timer */
+	/* Disable timer interrupts and clear any pending. */
 	at91_sys_write(AT91_PIT_MR, 0);
+	at91_sys_read(AT91_PIT_PIVR);
 
-	/* Clear any pending interrupts */
-	(void) at91_sys_read(AT91_PIT_PIVR);
+	at91_sys_write(AT91_RTT_MR, 1);
+	clear_RTT_SR();
 
-	/* Set Period Interval timer and enable its interrupt */
-	at91_sys_write(AT91_PIT_MR, (LATCH & AT91_PIT_PIV) | AT91_PIT_PITIEN |
AT91_PIT_PITEN);
+	switch(mode) {
+	case CLOCK_EVT_MODE_PERIODIC:
+		/* Standard PIT; period = HZ. */
+		at91_sys_write(AT91_PIT_MR, (LATCH & AT91_PIT_PIV)
+			       | AT91_PIT_PITIEN | AT91_PIT_PITEN);
+		break;
+	case CLOCK_EVT_MODE_ONESHOT:
+		/* Oneshot hanled by the RTT hardware.
+		 * Set alarm to just missed. Real alarm value will get
+		 * set by next_event() before counter rolls back around.
+		 */
+		at91_sys_write(AT91_RTT_AR, read_CRTV());
+		at91_sys_write(AT91_RTT_MR, AT91_RTT_ALMIEN | 1);
+		break;
+	case CLOCK_EVT_MODE_SHUTDOWN:
+		at91sam926x_timer_suspend();
+		break;
+	case CLOCK_EVT_MODE_RESUME:
+		at91sam926x_timer_resume();
+		break;
+	case CLOCK_EVT_MODE_UNUSED:
+		break;
+	}
 }
 
+static int at91sam926x_timer_next_event(unsigned long delta,
+					struct clock_event_device *dev)
+{
+        unsigned long   flags;
+        u32             alm;
+        int             status = 0;
+
+        BUG_ON(delta < 2);
+
+        /* Use "raw" primitives so we behave correctly on RT kernels.
*/
+        raw_local_irq_save(flags);
+        alm = read_CRTV();
+
+        /* Cancel any pending alarm; flush any pending IRQ */
+        at91_sys_write(AT91_RTT_AR, alm);
+        clear_RTT_SR();
+
+        /* Schedule alarm by writing to alarm register. */
+        alm += delta;
+        at91_sys_write(AT91_RTT_AR, alm);
+
+        raw_local_irq_restore(flags);
+        return status;
+}
+
+static struct clock_event_device clkevt = {
+	.name          = "at91_tick",
+	.features      = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
+	.shift         = 32,
+	.rating        = 150,
+	.cpumask       = CPU_MASK_CPU0,
+	.set_next_event = at91sam926x_timer_next_event,
+	.set_mode      = at91sam926x_timer_mode,
+};
+
 /*
  * Set up timer interrupt.
  */
-void __init at91sam926x_timer_init(void)
+static void __init at91sam926x_timer_init(void)
 {
-	/* Initialize and enable the timer */
-	at91sam926x_timer_reset();
+
+	/* Disable interrupts and clear any pending.
+	 * The 32 kHz "slow clock" drives the RTT timer. We adjust
+	 * the prescaler down to 1 for better resolution. Otherwise
+	 * we get a 1 Hz default. This however requires waiting
+	 * for the RTT_SR to clear before re-enabling interrupts.
+	 */
+	at91_sys_write(AT91_RTT_MR, 1 | AT91_RTT_RTTRST);
+	at91_sys_read(AT91_RTT_SR);
 
 	/* Make IRQs happen for the system timer. */
 	setup_irq(AT91_ID_SYS, &at91sam926x_timer_irq);
+	clkevt.mult = div_sc(AT91_SLOW_CLOCK, NSEC_PER_SEC, clkevt.shift);
+	clkevt.max_delta_ns = clockevent_delta2ns(AT91_RTT_ALMV, &clkevt);
+	clkevt.min_delta_ns = clockevent_delta2ns(2, &clkevt) + 1;
+	clockevents_register_device(&clkevt);
+
+	/* Register clocksource. */
+	clksrc.mult = clocksource_hz2mult(AT91_SLOW_CLOCK, clksrc.shift);
+	clocksource_register(&clksrc);
 }
 
-#ifdef CONFIG_PM
-static void at91sam926x_timer_suspend(void)
-{
-	/* Disable timer */
-	at91_sys_write(AT91_PIT_MR, 0);
-}
-#else
-#define at91sam926x_timer_suspend	NULL
-#endif
-
 struct sys_timer at91sam926x_timer = {
 	.init		= at91sam926x_timer_init,
-	.offset		= at91sam926x_gettimeoffset,
 	.suspend	= at91sam926x_timer_suspend,
-	.resume		= at91sam926x_timer_reset,
+	.resume		= at91sam926x_timer_resume,
 };
-

