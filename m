Return-Path: <linux-kernel-owner+w=401wt.eu-S932675AbXAWCxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932675AbXAWCxa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 21:53:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932694AbXAWCxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 21:53:30 -0500
Received: from av5.karneval.cz ([81.27.192.12]:6722 "EHLO av1.karneval.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932675AbXAWCx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 21:53:29 -0500
From: Pavel Pisa <pisa@cmp.felk.cvut.cz>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH query] arm: i.MX/MX1 clock event source
Date: Tue, 23 Jan 2007 03:52:56 +0100
User-Agent: KMail/1.9.4
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Sascha Hauer <s.hauer@pengutronix.de>
References: <200701210101.27345.pisa@cmp.felk.cvut.cz> <20070122195924.GD21277@elte.hu>
In-Reply-To: <20070122195924.GD21277@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701230352.57380.pisa@cmp.felk.cvut.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 January 2007 20:59, Ingo Molnar wrote:
> * Pavel Pisa <pisa@cmp.felk.cvut.cz> wrote:
> > Hello Thomas, Sascha and Ingo
> >
> > please can you find some time to review next patch
> >   arm: i.MX/MX1 clock event source
> > which has been sent to you and to the ALKML at 2007-01-13.
> >
> > http://thread.gmane.org/gmane.linux.ports.arm.kernel/29510/focus=29533
> >
> > There seems to be some problems, because this patch has not been
> > accepted to patch-2.6.20-rc5-rt7.patch, but GENERIC_CLOCKEVENTS are
> > set already for i.MX and this results in a problems to run RT kernel
> > on this architecture.
>
> i've added your patch to -rt, but note that there's a new, slightly
> incompatible clockevents code in -rt now so you'll need to do some more
> (hopefully trivial) fixups for this to build and work.
>
> 	Ingo


Hello Ingo,

thanks for reply. I am attaching updated version of the patch at the end of e-mail.
There is problem with missing include in tick-sched.c

  CC      kernel/time/tick-sched.o
/usr/src/linux-2.6.20-rc5/kernel/time/tick-sched.c: In function `tick_nohz_handler':
/usr/src/linux-2.6.20-rc5/kernel/time/tick-sched.c:330: warning: implicit declaration of function `get_irq_regs'
/usr/src/linux-2.6.20-rc5/kernel/time/tick-sched.c:330: warning: initialization makes pointer from integer without a cast
/usr/src/linux-2.6.20-rc5/kernel/time/tick-sched.c: In function `tick_sched_timer':
/usr/src/linux-2.6.20-rc5/kernel/time/tick-sched.c:425: warning: initialization makes pointer from integer without a cast
  LD      kernel/time/built-in.o

--- linux-2.6.20-rc5.orig/kernel/time/tick-sched.c
+++ linux-2.6.20-rc5/kernel/time/tick-sched.c
@@ -20,6 +20,7 @@
 #include <linux/profile.h>
 #include <linux/sched.h>
 #include <linux/tick.h>
+#include <asm/irq_regs.h>
 
 #include "tick-internal.h"

And

  CC      arch/arm/kernel/process.o
/usr/src/linux-2.6.20-rc5/arch/arm/kernel/process.c: In function `cpu_idle':
/usr/src/linux-2.6.20-rc5/arch/arm/kernel/process.c:157: warning: implicit declaration of function `hrtimer_stop_sched_tick'
/usr/src/linux-2.6.20-rc5/arch/arm/kernel/process.c:161: warning: implicit declaration of function `hrtimer_restart_sched_tick'

--- linux-2.6.20-rc5.orig/arch/arm/kernel/process.c
+++ linux-2.6.20-rc5/arch/arm/kernel/process.c
@@ -154,11 +154,11 @@ void cpu_idle(void)
 		if (!idle)
 			idle = default_idle;
 		leds_event(led_idle_start);
-		hrtimer_stop_sched_tick();
+		tick_nohz_stop_sched_tick();
 		while (!need_resched() && !need_resched_delayed())
 			idle();
 		leds_event(led_idle_end);
-		hrtimer_restart_sched_tick();
+		tick_nohz_restart_sched_tick();
 		local_irq_disable();
 		__preempt_enable_no_resched();
 		__schedule();

Unfortunately, even with these corrections boot stuck at

Memory: 18972KB available (2488K code, 358K data, 92K init)

I have not time now to start JTAG debugging session, so I look at that
tomorrow or on Friday.

It seems, that the interrupts are not coming from device.

Best wishes

            Pavel

==========================================================================
Subject: arm: i.MX/MX1 clock event source

Support clock event source based on i.MX general purpose
timer in free running timer mode.

Signed-off-by: Pavel Pisa <pisa@cmp.felk.cvut.cz>

 arch/arm/mach-imx/time.c |  112 ++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 107 insertions(+), 5 deletions(-)

Index: linux-2.6.20-rc5/arch/arm/mach-imx/time.c
===================================================================
--- linux-2.6.20-rc5.orig/arch/arm/mach-imx/time.c
+++ linux-2.6.20-rc5/arch/arm/mach-imx/time.c
@@ -15,6 +15,9 @@
 #include <linux/irq.h>
 #include <linux/time.h>
 #include <linux/clocksource.h>
+#ifdef CONFIG_GENERIC_CLOCKEVENTS
+#include <linux/clockchips.h>
+#endif
 
 #include <asm/hardware.h>
 #include <asm/io.h>
@@ -25,6 +28,11 @@
 /* Use timer 1 as system timer */
 #define TIMER_BASE IMX_TIM1_BASE
 
+#ifdef CONFIG_GENERIC_CLOCKEVENTS
+static struct clock_event_device clockevent_imx;
+static enum clock_event_mode clockevent_mode = CLOCK_EVT_MODE_PERIODIC;
+#endif
+
 static unsigned long evt_diff;
 
 /*
@@ -33,6 +41,7 @@ static unsigned long evt_diff;
 static irqreturn_t
 imx_timer_interrupt(int irq, void *dev_id)
 {
+	unsigned long tcmp;
 	uint32_t tstat;
 
 	/* clear the interrupt */
@@ -42,13 +51,20 @@ imx_timer_interrupt(int irq, void *dev_i
 	if (tstat & TSTAT_COMP) {
 		do {
 
+#ifdef CONFIG_GENERIC_CLOCKEVENTS
+			if (clockevent_imx.event_handler)
+				clockevent_imx.event_handler(&clockevent_imx);
+			if (likely(clockevent_mode != CLOCK_EVT_MODE_PERIODIC))
+				break;
+#else
 			write_seqlock(&xtime_lock);
 			timer_tick();
 			write_sequnlock(&xtime_lock);
-			IMX_TCMP(TIMER_BASE) += evt_diff;
+#endif
+			tcmp = IMX_TCMP(TIMER_BASE) + evt_diff;
+			IMX_TCMP(TIMER_BASE) = tcmp;
 
-		} while (unlikely((int32_t)(IMX_TCMP(TIMER_BASE)
-					- IMX_TCN(TIMER_BASE)) < 0));
+		} while (unlikely((int32_t)(tcmp - IMX_TCN(TIMER_BASE)) < 0));
 	}
 
 	return IRQ_HANDLED;
@@ -70,7 +86,7 @@ static void __init imx_timer_hardware_in
 	 */
 	IMX_TCTL(TIMER_BASE) = 0;
 	IMX_TPRER(TIMER_BASE) = 0;
-	IMX_TCMP(TIMER_BASE) = LATCH - 1;
+	IMX_TCMP(TIMER_BASE) += LATCH;
 
 	IMX_TCTL(TIMER_BASE) = TCTL_FRR | TCTL_CLK_PCLK1 | TCTL_IRQEN | TCTL_TEN;
 	evt_diff = LATCH;
@@ -87,7 +103,7 @@ static struct clocksource clocksource_im
 	.read		= imx_get_cycles,
 	.mask		= 0xFFFFFFFF,
 	.shift 		= 20,
-	.is_continuous 	= 1,
+	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
 static int __init imx_clocksource_init(void)
@@ -99,11 +115,97 @@ static int __init imx_clocksource_init(v
 	return 0;
 }
 
+#ifdef CONFIG_GENERIC_CLOCKEVENTS
+
+static int imx_set_next_event(unsigned long evt,
+				  struct clock_event_device *unused)
+{
+	unsigned long tcmp;
+	evt_diff = evt;
+
+	tcmp = IMX_TCN(TIMER_BASE) + evt;
+	IMX_TCMP(TIMER_BASE) = tcmp;
+
+	return unlikely((int32_t)(tcmp - IMX_TCN(TIMER_BASE)) < 0) ? -ETIME : 0;
+}
+
+static void imx_set_mode(enum clock_event_mode mode, struct clock_event_device *evt)
+{
+	unsigned long flags;
+
+	/*
+	 * The timer interrupt generation is disabled at least
+	 * for enough time to call imx_set_next_event()
+	 */
+	local_irq_save(flags);
+	/* Disable interrupt in GPT module */
+	IMX_TCTL(TIMER_BASE) &= ~TCTL_IRQEN;
+	if ((mode != CLOCK_EVT_MODE_PERIODIC) || (mode != clockevent_mode)) {
+		/* Set event time into far-far future */
+		IMX_TCMP(TIMER_BASE) = IMX_TCN(TIMER_BASE) - 3;
+		/* Clear pending interrupt */
+		IMX_TSTAT(TIMER_BASE) &= ~TSTAT_COMP;
+	}
+	/* Remember timer mode */
+	clockevent_mode = mode;
+	local_irq_restore(flags);
+
+	switch (mode) {
+	case CLOCK_EVT_MODE_PERIODIC:
+		/* It seems, that periodic mode expects old ugly latch period */
+		evt_diff = LATCH;
+		IMX_TCMP(TIMER_BASE) = IMX_TCN(TIMER_BASE) + evt_diff;
+	case CLOCK_EVT_MODE_ONESHOT:
+		/*
+		 * Do not put overhead of interrupt enable/disable into
+		 * imx_set_next_event(), the core has about 4 minutes
+		 * to call imx_set_next_event() or shutdown clock after
+		 * mode switching
+		 */
+		local_irq_save(flags);
+		IMX_TCTL(TIMER_BASE) |= TCTL_IRQEN;
+		local_irq_restore(flags);
+		break;
+	case CLOCK_EVT_MODE_SHUTDOWN:
+	case CLOCK_EVT_MODE_UNUSED:
+		/* Left event sources disabled, no more interrupts appears */
+		break;
+	}
+}
+
+static struct clock_event_device clockevent_imx = {
+	.name		= "imx_timer1",
+	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
+	.shift		= 32,
+	.set_mode	= imx_set_mode,
+	.set_next_event	= imx_set_next_event,
+	.rating		= 200,
+};
+
+static int __init imx_clockevent_init(void)
+{
+	clockevent_imx.mult = div_sc(imx_get_perclk1(), NSEC_PER_SEC,
+					clockevent_imx.shift);
+	clockevent_imx.max_delta_ns =
+		clockevent_delta2ns(0xfffffffe, &clockevent_imx);
+	clockevent_imx.min_delta_ns =
+		clockevent_delta2ns(0xf, &clockevent_imx);
+	clockevents_register_device(&clockevent_imx);
+
+	return 0;
+}
+#endif
+
+
 static void __init imx_timer_init(void)
 {
 	imx_timer_hardware_init();
 	imx_clocksource_init();
 
+#ifdef CONFIG_GENERIC_CLOCKEVENTS
+	imx_clockevent_init();
+#endif
+
 	/*
 	 * Make irqs happen for the system timer
 	 */
