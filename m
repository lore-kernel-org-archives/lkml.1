Return-Path: <linux-kernel-owner+w=401wt.eu-S933679AbYBAHs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933679AbYBAHs5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 02:48:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935300AbYBAHlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 02:41:16 -0500
Received: from rex.snapgear.com ([203.143.235.140]:48110 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S935262AbYBAHlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 02:41:14 -0500
Date: Fri, 1 Feb 2008 17:40:21 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200802010740.m117eLFQ022781@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU 02/07]: switch ColdFire PIT timer to use GENERIC_TIME
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch the ColdFire PIT timer to using GENERIC_TIME.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naurp linux-2.6.24.1/arch/m68knommu/platform/coldfire/pit.c linux-2.6.24.2/arch/m68knommu/platform/coldfire/pit.c
--- linux-2.6.24.1/arch/m68knommu/platform/coldfire/pit.c	2008-01-25 08:58:37.000000000 +1000
+++ linux-2.6.24.2/arch/m68knommu/platform/coldfire/pit.c	2008-02-01 16:29:26.000000000 +1000
@@ -3,9 +3,10 @@
 /*
  *	pit.c -- Freescale ColdFire PIT timer. Currently this type of
  *	         hardware timer only exists in the Freescale ColdFire
- *		 5270/5271, 5282 and other CPUs.
+ *		 5270/5271, 5282 and 5208 CPUs. No doubt newer ColdFire
+ *		 family members will probably use it too.
  *
- *	Copyright (C) 1999-2007, Greg Ungerer (gerg@snapgear.com)
+ *	Copyright (C) 1999-2008, Greg Ungerer (gerg@snapgear.com)
  *	Copyright (C) 2001-2004, SnapGear Inc. (www.snapgear.com)
  */
 
@@ -17,6 +18,7 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
+#include <linux/clocksource.h>
 #include <asm/machdep.h>
 #include <asm/io.h>
 #include <asm/coldfire.h>
@@ -28,70 +30,84 @@
 /*
  *	By default use timer1 as the system clock timer.
  */
+#define	FREQ	((MCF_CLK / 2) / 64)
 #define	TA(a)	(MCF_IPSBAR + MCFPIT_BASE1 + (a))
+#define	INTC0	(MCF_IPSBAR + MCFICM_INTC0)
+
+static u32 pit_cycles_per_jiffy;
+static u32 pit_cnt;
 
 /***************************************************************************/
 
-static irqreturn_t hw_tick(int irq, void *dummy)
+static irqreturn_t pit_tick(int irq, void *dummy)
 {
-	unsigned short pcsr;
+	u16 pcsr;
 
 	/* Reset the ColdFire timer */
 	pcsr = __raw_readw(TA(MCFPIT_PCSR));
 	__raw_writew(pcsr | MCFPIT_PCSR_PIF, TA(MCFPIT_PCSR));
 
+	pit_cnt += pit_cycles_per_jiffy;
 	return arch_timer_interrupt(irq, dummy);
 }
 
 /***************************************************************************/
 
-static struct irqaction coldfire_pit_irq = {
+static struct irqaction pit_irq = {
 	.name	 = "timer",
 	.flags	 = IRQF_DISABLED | IRQF_TIMER,
-	.handler = hw_tick,
+	.handler = pit_tick,
 };
 
-void hw_timer_init(void)
+/***************************************************************************/
+
+static cycle_t pit_read_clk(void)
 {
-	volatile unsigned char *icrp;
-	volatile unsigned long *imrp;
+	unsigned long flags;
+	u32 cycles;
+	u16 pcntr;
 
-	setup_irq(MCFINT_VECBASE + MCFINT_PIT1, &coldfire_pit_irq);
+	local_irq_save(flags);
+	pcntr = __raw_readw(TA(MCFPIT_PCNTR));
+	cycles = pit_cnt;
+	local_irq_restore(flags);
 
-	icrp = (volatile unsigned char *) (MCF_IPSBAR + MCFICM_INTC0 +
-		MCFINTC_ICR0 + MCFINT_PIT1);
-	*icrp = ICR_INTRCONF;
+	return cycles + pit_cycles_per_jiffy - pcntr;
+}
 
-	imrp = (volatile unsigned long *) (MCF_IPSBAR + MCFICM_INTC0 + MCFPIT_IMR);
-	*imrp &= ~MCFPIT_IMR_IBIT;
+/***************************************************************************/
 
-	/* Set up PIT timer 1 as poll clock */
-	__raw_writew(MCFPIT_PCSR_DISABLE, TA(MCFPIT_PCSR));
-	__raw_writew(((MCF_CLK / 2) / 64) / HZ, TA(MCFPIT_PMR));
-	__raw_writew(MCFPIT_PCSR_EN | MCFPIT_PCSR_PIE | MCFPIT_PCSR_OVW |
-		MCFPIT_PCSR_RLD | MCFPIT_PCSR_CLK64, TA(MCFPIT_PCSR));
-}
+static struct clocksource pit_clk = {
+	.name	= "pit",
+	.rating	= 250,
+	.read	= pit_read_clk,
+	.shift	= 20,
+	.mask	= CLOCKSOURCE_MASK(32),
+	.flags	= CLOCK_SOURCE_IS_CONTINUOUS,
+};
 
 /***************************************************************************/
 
-unsigned long hw_timer_offset(void)
+void hw_timer_init(void)
 {
-	volatile unsigned long *ipr;
-	unsigned long pmr, pcntr, offset;
+	u32 imr;
 
-	ipr = (volatile unsigned long *) (MCF_IPSBAR + MCFICM_INTC0 + MCFPIT_IMR);
+	setup_irq(MCFINT_VECBASE + MCFINT_PIT1, &pit_irq);
 
-	pmr = __raw_readw(TA(MCFPIT_PMR));
-	pcntr = __raw_readw(TA(MCFPIT_PCNTR));
+	__raw_writeb(ICR_INTRCONF, INTC0 + MCFINTC_ICR0 + MCFINT_PIT1);
+	imr = __raw_readl(INTC0 + MCFPIT_IMR);
+	imr &= ~MCFPIT_IMR_IBIT;
+	__raw_writel(imr, INTC0 + MCFPIT_IMR);
+
+	/* Set up PIT timer 1 as poll clock */
+	pit_cycles_per_jiffy = FREQ / HZ;
+	__raw_writew(MCFPIT_PCSR_DISABLE, TA(MCFPIT_PCSR));
+	__raw_writew(pit_cycles_per_jiffy, TA(MCFPIT_PMR));
+	__raw_writew(MCFPIT_PCSR_EN | MCFPIT_PCSR_PIE | MCFPIT_PCSR_OVW |
+		MCFPIT_PCSR_RLD | MCFPIT_PCSR_CLK64, TA(MCFPIT_PCSR));
 
-	/*
-	 * If we are still in the first half of the upcount and a
-	 * timer interrupt is pending, then add on a ticks worth of time.
-	 */
-	offset = ((pmr - pcntr) * (1000000 / HZ)) / pmr;
-	if ((offset < (1000000 / HZ / 2)) && (*ipr & MCFPIT_IMR_IBIT))
-		offset += 1000000 / HZ;
-	return offset;	
+	pit_clk.mult = clocksource_hz2mult(FREQ, pit_clk.shift);
+	clocksource_register(&pit_clk);
 }
 
 /***************************************************************************/
