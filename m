Return-Path: <linux-kernel-owner+w=401wt.eu-S935289AbYBAHvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935289AbYBAHvi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 02:51:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935440AbYBAHlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 02:41:52 -0500
Received: from rex.snapgear.com ([203.143.235.140]:45236 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S935436AbYBAHlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 02:41:51 -0500
Date: Fri, 1 Feb 2008 17:40:26 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200802010740.m117eQi4022783@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU 03/07]: switch ColdFire TIMER to use GENERIC_TIME
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch the ColdFire TIMER timer to use GENERIC_TIME.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naurp linux-2.6.24.1/arch/m68knommu/platform/coldfire/timers.c linux-2.6.24.2/arch/m68knommu/platform/coldfire/timers.c
--- linux-2.6.24.1/arch/m68knommu/platform/coldfire/timers.c	2008-01-25 08:58:37.000000000 +1000
+++ linux-2.6.24.2/arch/m68knommu/platform/coldfire/timers.c	2008-02-01 16:15:50.000000000 +1000
@@ -3,7 +3,7 @@
 /*
  *	timers.c -- generic ColdFire hardware timer support.
  *
- *	Copyright (C) 1999-2007, Greg Ungerer (gerg@snapgear.com)
+ *	Copyright (C) 1999-2008, Greg Ungerer <gerg@snapgear.com>
  */
 
 /***************************************************************************/
@@ -13,6 +13,8 @@
 #include <linux/sched.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
+#include <linux/profile.h>
+#include <linux/clocksource.h>
 #include <asm/io.h>
 #include <asm/traps.h>
 #include <asm/machdep.h>
@@ -25,6 +27,7 @@
 /*
  *	By default use timer1 as the system clock timer.
  */
+#define	FREQ	(MCF_BUSCLK / 16)
 #define	TA(a)	(MCF_MBAR + MCFTIMER_BASE1 + (a))
 
 /*
@@ -41,7 +44,7 @@ unsigned int	mcf_timerlevel = 5;
  *	Unfortunately it is a little different on each ColdFire.
  */
 extern void mcf_settimericr(int timer, int level);
-extern int mcf_timerirqpending(int timer);
+void coldfire_profile_init(void);
 
 #if defined(CONFIG_M532x)
 #define	__raw_readtrr	__raw_readl
@@ -51,38 +54,70 @@ extern int mcf_timerirqpending(int timer
 #define	__raw_writetrr	__raw_writew
 #endif
 
+static u32 mcftmr_cycles_per_jiffy;
+static u32 mcftmr_cnt;
+
 /***************************************************************************/
 
-static irqreturn_t hw_tick(int irq, void *dummy)
+static irqreturn_t mcftmr_tick(int irq, void *dummy)
 {
 	/* Reset the ColdFire timer */
 	__raw_writeb(MCFTIMER_TER_CAP | MCFTIMER_TER_REF, TA(MCFTIMER_TER));
 
+	mcftmr_cnt += mcftmr_cycles_per_jiffy;
 	return arch_timer_interrupt(irq, dummy);
 }
 
 /***************************************************************************/
 
-static struct irqaction coldfire_timer_irq = {
+static struct irqaction mcftmr_timer_irq = {
 	.name	 = "timer",
 	.flags	 = IRQF_DISABLED | IRQF_TIMER,
-	.handler = hw_tick,
+	.handler = mcftmr_tick,
 };
 
 /***************************************************************************/
 
-static int ticks_per_intr;
+static cycle_t mcftmr_read_clk(void)
+{
+	unsigned long flags;
+	u32 cycles;
+	u16 tcn;
+
+	local_irq_save(flags);
+	tcn = __raw_readw(TA(MCFTIMER_TCN));
+	cycles = mcftmr_cnt;
+	local_irq_restore(flags);
+
+	return cycles + tcn;
+}
+
+/***************************************************************************/
+
+static struct clocksource mcftmr_clk = {
+	.name	= "tmr",
+	.rating	= 250,
+	.read	= mcftmr_read_clk,
+	.shift	= 20,
+	.mask	= CLOCKSOURCE_MASK(32),
+	.flags	= CLOCK_SOURCE_IS_CONTINUOUS,
+};
+
+/***************************************************************************/
 
 void hw_timer_init(void)
 {
-	setup_irq(mcf_timervector, &coldfire_timer_irq);
+	setup_irq(mcf_timervector, &mcftmr_timer_irq);
 
 	__raw_writew(MCFTIMER_TMR_DISABLE, TA(MCFTIMER_TMR));
-	ticks_per_intr = (MCF_BUSCLK / 16) / HZ;
-	__raw_writetrr(ticks_per_intr - 1, TA(MCFTIMER_TRR));
+	mcftmr_cycles_per_jiffy = FREQ / HZ;
+	__raw_writetrr(mcftmr_cycles_per_jiffy, TA(MCFTIMER_TRR));
 	__raw_writew(MCFTIMER_TMR_ENORI | MCFTIMER_TMR_CLK16 |
 		MCFTIMER_TMR_RESTART | MCFTIMER_TMR_ENABLE, TA(MCFTIMER_TMR));
 
+	mcftmr_clk.mult = clocksource_hz2mult(FREQ, mcftmr_clk.shift);
+	clocksource_register(&mcftmr_clk);
+
 	mcf_settimericr(1, mcf_timerlevel);
 
 #ifdef CONFIG_HIGHPROFILE
@@ -91,21 +126,6 @@ void hw_timer_init(void)
 }
 
 /***************************************************************************/
-
-unsigned long hw_timer_offset(void)
-{
-	unsigned long tcn, offset;
-
-	tcn = __raw_readw(TA(MCFTIMER_TCN));
-	offset = ((tcn + 1) * (1000000 / HZ)) / ticks_per_intr;
-
-	/* Check if we just wrapped the counters and maybe missed a tick */
-	if ((offset < (1000000 / HZ / 2)) && mcf_timerirqpending(1))
-		offset += 1000000 / HZ;
-	return offset;
-}
-
-/***************************************************************************/
 #ifdef CONFIG_HIGHPROFILE
 /***************************************************************************/
 
