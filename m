Return-Path: <linux-kernel-owner+w=401wt.eu-S1763851AbYBAHls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763851AbYBAHls (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 02:41:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935017AbYBAHim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 02:38:42 -0500
Received: from rex.snapgear.com ([203.143.235.140]:48061 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S935028AbYBAHik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 02:38:40 -0500
Date: Fri, 1 Feb 2008 17:37:39 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200802010737.m117bdaN022701@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU 04/06]: move ColdFire timers.c to its own coldfire directory
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move common ColdFire CPU timers.c to common coldfire platform directory.

Currently the common ColdFire CPU family code sits in the
arch/m68knommu/platform/5307 directory. This is confusing, the files
containing this common code are in no way specific to the 5307 ColdFire.
Create an arch/m68knommu/platform/coldfire directory to contain this
common code. Other m68knommu CPU varients do not need use this code
though, so it doesn't make sense to move it to arch/m68knommu/kernel.

Signed-off-by: Greg Ungerer <gerg@uclinux.org


diff -Naurp linux-2.6.24/arch/m68knommu/platform/5307/timers.c linux-2.6.24.1/arch/m68knommu/platform/5307/timers.c
--- linux-2.6.24/arch/m68knommu/platform/5307/timers.c	2008-01-25 08:58:37.000000000 +1000
+++ linux-2.6.24.1/arch/m68knommu/platform/5307/timers.c	1970-01-01 10:00:00.000000000 +1000
@@ -1,155 +0,0 @@
-/***************************************************************************/
-
-/*
- *	timers.c -- generic ColdFire hardware timer support.
- *
- *	Copyright (C) 1999-2007, Greg Ungerer (gerg@snapgear.com)
- */
-
-/***************************************************************************/
-
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/sched.h>
-#include <linux/interrupt.h>
-#include <linux/irq.h>
-#include <asm/io.h>
-#include <asm/traps.h>
-#include <asm/machdep.h>
-#include <asm/coldfire.h>
-#include <asm/mcftimer.h>
-#include <asm/mcfsim.h>
-
-/***************************************************************************/
-
-/*
- *	By default use timer1 as the system clock timer.
- */
-#define	TA(a)	(MCF_MBAR + MCFTIMER_BASE1 + (a))
-
-/*
- *	Default the timer and vector to use for ColdFire. Some ColdFire
- *	CPU's and some boards may want different. Their sub-architecture
- *	startup code (in config.c) can change these if they want.
- */
-unsigned int	mcf_timervector = 29;
-unsigned int	mcf_profilevector = 31;
-unsigned int	mcf_timerlevel = 5;
-
-/*
- *	These provide the underlying interrupt vector support.
- *	Unfortunately it is a little different on each ColdFire.
- */
-extern void mcf_settimericr(int timer, int level);
-extern int mcf_timerirqpending(int timer);
-
-#if defined(CONFIG_M532x)
-#define	__raw_readtrr	__raw_readl
-#define	__raw_writetrr	__raw_writel
-#else
-#define	__raw_readtrr	__raw_readw
-#define	__raw_writetrr	__raw_writew
-#endif
-
-/***************************************************************************/
-
-static irqreturn_t hw_tick(int irq, void *dummy)
-{
-	/* Reset the ColdFire timer */
-	__raw_writeb(MCFTIMER_TER_CAP | MCFTIMER_TER_REF, TA(MCFTIMER_TER));
-
-	return arch_timer_interrupt(irq, dummy);
-}
-
-/***************************************************************************/
-
-static struct irqaction coldfire_timer_irq = {
-	.name	 = "timer",
-	.flags	 = IRQF_DISABLED | IRQF_TIMER,
-	.handler = hw_tick,
-};
-
-/***************************************************************************/
-
-static int ticks_per_intr;
-
-void hw_timer_init(void)
-{
-	setup_irq(mcf_timervector, &coldfire_timer_irq);
-
-	__raw_writew(MCFTIMER_TMR_DISABLE, TA(MCFTIMER_TMR));
-	ticks_per_intr = (MCF_BUSCLK / 16) / HZ;
-	__raw_writetrr(ticks_per_intr - 1, TA(MCFTIMER_TRR));
-	__raw_writew(MCFTIMER_TMR_ENORI | MCFTIMER_TMR_CLK16 |
-		MCFTIMER_TMR_RESTART | MCFTIMER_TMR_ENABLE, TA(MCFTIMER_TMR));
-
-	mcf_settimericr(1, mcf_timerlevel);
-
-#ifdef CONFIG_HIGHPROFILE
-	coldfire_profile_init();
-#endif
-}
-
-/***************************************************************************/
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
-#ifdef CONFIG_HIGHPROFILE
-/***************************************************************************/
-
-/*
- *	By default use timer2 as the profiler clock timer.
- */
-#define	PA(a)	(MCF_MBAR + MCFTIMER_BASE2 + (a))
-
-/*
- *	Choose a reasonably fast profile timer. Make it an odd value to
- *	try and get good coverage of kernel operations.
- */
-#define	PROFILEHZ	1013
-
-/*
- *	Use the other timer to provide high accuracy profiling info.
- */
-irqreturn_t coldfire_profile_tick(int irq, void *dummy)
-{
-	/* Reset ColdFire timer2 */
-	__raw_writeb(MCFTIMER_TER_CAP | MCFTIMER_TER_REF, PA(MCFTIMER_TER));
-	if (current->pid)
-		profile_tick(CPU_PROFILING, regs);
-	return IRQ_HANDLED;
-}
-
-/***************************************************************************/
-
-void coldfire_profile_init(void)
-{
-	printk(KERN_INFO "PROFILE: lodging TIMER2 @ %dHz as profile timer\n", PROFILEHZ);
-
-	/* Set up TIMER 2 as high speed profile clock */
-	__raw_writew(MCFTIMER_TMR_DISABLE, PA(MCFTIMER_TMR));
-
-	__raw_writetrr(((MCF_CLK / 16) / PROFILEHZ), PA(MCFTIMER_TRR));
-	__raw_writew(MCFTIMER_TMR_ENORI | MCFTIMER_TMR_CLK16 |
-		MCFTIMER_TMR_RESTART | MCFTIMER_TMR_ENABLE, PA(MCFTIMER_TMR));
-
-	request_irq(mcf_profilevector, coldfire_profile_tick,
-		(IRQF_DISABLED | IRQ_FLG_FAST), "profile timer", NULL);
-	mcf_settimericr(2, 7);
-}
-
-/***************************************************************************/
-#endif	/* CONFIG_HIGHPROFILE */
-/***************************************************************************/
diff -Naurp linux-2.6.24/arch/m68knommu/platform/coldfire/timers.c linux-2.6.24.1/arch/m68knommu/platform/coldfire/timers.c
--- linux-2.6.24/arch/m68knommu/platform/coldfire/timers.c	1970-01-01 10:00:00.000000000 +1000
+++ linux-2.6.24.1/arch/m68knommu/platform/coldfire/timers.c	2008-01-25 08:58:37.000000000 +1000
@@ -0,0 +1,155 @@
+/***************************************************************************/
+
+/*
+ *	timers.c -- generic ColdFire hardware timer support.
+ *
+ *	Copyright (C) 1999-2007, Greg Ungerer (gerg@snapgear.com)
+ */
+
+/***************************************************************************/
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/sched.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <asm/io.h>
+#include <asm/traps.h>
+#include <asm/machdep.h>
+#include <asm/coldfire.h>
+#include <asm/mcftimer.h>
+#include <asm/mcfsim.h>
+
+/***************************************************************************/
+
+/*
+ *	By default use timer1 as the system clock timer.
+ */
+#define	TA(a)	(MCF_MBAR + MCFTIMER_BASE1 + (a))
+
+/*
+ *	Default the timer and vector to use for ColdFire. Some ColdFire
+ *	CPU's and some boards may want different. Their sub-architecture
+ *	startup code (in config.c) can change these if they want.
+ */
+unsigned int	mcf_timervector = 29;
+unsigned int	mcf_profilevector = 31;
+unsigned int	mcf_timerlevel = 5;
+
+/*
+ *	These provide the underlying interrupt vector support.
+ *	Unfortunately it is a little different on each ColdFire.
+ */
+extern void mcf_settimericr(int timer, int level);
+extern int mcf_timerirqpending(int timer);
+
+#if defined(CONFIG_M532x)
+#define	__raw_readtrr	__raw_readl
+#define	__raw_writetrr	__raw_writel
+#else
+#define	__raw_readtrr	__raw_readw
+#define	__raw_writetrr	__raw_writew
+#endif
+
+/***************************************************************************/
+
+static irqreturn_t hw_tick(int irq, void *dummy)
+{
+	/* Reset the ColdFire timer */
+	__raw_writeb(MCFTIMER_TER_CAP | MCFTIMER_TER_REF, TA(MCFTIMER_TER));
+
+	return arch_timer_interrupt(irq, dummy);
+}
+
+/***************************************************************************/
+
+static struct irqaction coldfire_timer_irq = {
+	.name	 = "timer",
+	.flags	 = IRQF_DISABLED | IRQF_TIMER,
+	.handler = hw_tick,
+};
+
+/***************************************************************************/
+
+static int ticks_per_intr;
+
+void hw_timer_init(void)
+{
+	setup_irq(mcf_timervector, &coldfire_timer_irq);
+
+	__raw_writew(MCFTIMER_TMR_DISABLE, TA(MCFTIMER_TMR));
+	ticks_per_intr = (MCF_BUSCLK / 16) / HZ;
+	__raw_writetrr(ticks_per_intr - 1, TA(MCFTIMER_TRR));
+	__raw_writew(MCFTIMER_TMR_ENORI | MCFTIMER_TMR_CLK16 |
+		MCFTIMER_TMR_RESTART | MCFTIMER_TMR_ENABLE, TA(MCFTIMER_TMR));
+
+	mcf_settimericr(1, mcf_timerlevel);
+
+#ifdef CONFIG_HIGHPROFILE
+	coldfire_profile_init();
+#endif
+}
+
+/***************************************************************************/
+
+unsigned long hw_timer_offset(void)
+{
+	unsigned long tcn, offset;
+
+	tcn = __raw_readw(TA(MCFTIMER_TCN));
+	offset = ((tcn + 1) * (1000000 / HZ)) / ticks_per_intr;
+
+	/* Check if we just wrapped the counters and maybe missed a tick */
+	if ((offset < (1000000 / HZ / 2)) && mcf_timerirqpending(1))
+		offset += 1000000 / HZ;
+	return offset;
+}
+
+/***************************************************************************/
+#ifdef CONFIG_HIGHPROFILE
+/***************************************************************************/
+
+/*
+ *	By default use timer2 as the profiler clock timer.
+ */
+#define	PA(a)	(MCF_MBAR + MCFTIMER_BASE2 + (a))
+
+/*
+ *	Choose a reasonably fast profile timer. Make it an odd value to
+ *	try and get good coverage of kernel operations.
+ */
+#define	PROFILEHZ	1013
+
+/*
+ *	Use the other timer to provide high accuracy profiling info.
+ */
+irqreturn_t coldfire_profile_tick(int irq, void *dummy)
+{
+	/* Reset ColdFire timer2 */
+	__raw_writeb(MCFTIMER_TER_CAP | MCFTIMER_TER_REF, PA(MCFTIMER_TER));
+	if (current->pid)
+		profile_tick(CPU_PROFILING, regs);
+	return IRQ_HANDLED;
+}
+
+/***************************************************************************/
+
+void coldfire_profile_init(void)
+{
+	printk(KERN_INFO "PROFILE: lodging TIMER2 @ %dHz as profile timer\n", PROFILEHZ);
+
+	/* Set up TIMER 2 as high speed profile clock */
+	__raw_writew(MCFTIMER_TMR_DISABLE, PA(MCFTIMER_TMR));
+
+	__raw_writetrr(((MCF_CLK / 16) / PROFILEHZ), PA(MCFTIMER_TRR));
+	__raw_writew(MCFTIMER_TMR_ENORI | MCFTIMER_TMR_CLK16 |
+		MCFTIMER_TMR_RESTART | MCFTIMER_TMR_ENABLE, PA(MCFTIMER_TMR));
+
+	request_irq(mcf_profilevector, coldfire_profile_tick,
+		(IRQF_DISABLED | IRQ_FLG_FAST), "profile timer", NULL);
+	mcf_settimericr(2, 7);
+}
+
+/***************************************************************************/
+#endif	/* CONFIG_HIGHPROFILE */
+/***************************************************************************/
