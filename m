Return-Path: <linux-kernel-owner+w=401wt.eu-S1758760AbYAJHnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758760AbYAJHnX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 02:43:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753610AbYAJHnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 02:43:15 -0500
Received: from rex.snapgear.com ([203.143.235.140]:49386 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752770AbYAJHnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 02:43:14 -0500
Date: Thu, 10 Jan 2008 17:42:25 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200801100742.m0A7gPrg007440@goober>
To: linux-kernel@vger.kernel.org
Subject: [M68KNOMMU]: use GENERIC_TIME for ColdFire PIT timer
Cc: gerg@uclinux.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A first attempt at switching the m68knommu/ColdFire PIT timer to
use GENERIC_TIME.

Signed-of-by: Greg Ungerer <gerg@uclinux.org>

--- arch/m68knommu/platform/5307/pit.c	10 Oct 2007 06:46:56 -0000	1.11
+++ arch/m68knommu/platform/5307/pit.c	10 Jan 2008 07:17:34 -0000
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
@@ -28,35 +30,69 @@
 /*
  *	By default use timer1 as the system clock timer.
  */
+#define	FREQ	((MCF_CLK / 2) / 64)
 #define	TA(a)	(MCF_IPSBAR + MCFPIT_BASE1 + (a))
 #define	INTC0	(MCF_IPSBAR + MCFICM_INTC0)
 
+static u32 pit_cycles_per_jiffy;
+static u32 pit_cnt;
+
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
 
+/***************************************************************************/
+
+static cycle_t pit_read_clk(void)
+{
+	unsigned long flags;
+	u32 pmr, pcntr, cycles;
+
+	local_irq_save(flags);
+	pmr = __raw_readw(TA(MCFPIT_PMR));
+	pcntr = __raw_readw(TA(MCFPIT_PCNTR));
+	cycles = pit_cnt;
+	local_irq_restore(flags);
+
+	return cycles + pmr - pcntr;
+}
+
+/***************************************************************************/
+
+static struct clocksource pit_clk = {
+	.name	= "pit",
+	.rating	= 250,
+	.read	= pit_read_clk,
+	.shift	= 20,
+	.mask	= CLOCKSOURCE_MASK(32),
+	.flags	= CLOCK_SOURCE_IS_CONTINUOUS,
+};
+
+/***************************************************************************/
+
 void hw_timer_init(void)
 {
 	u32 imr;
 
-	setup_irq(MCFINT_VECBASE + MCFINT_PIT1, &coldfire_pit_irq);
+	setup_irq(MCFINT_VECBASE + MCFINT_PIT1, &pit_irq);
 
 	__raw_writeb(ICR_INTRCONF, INTC0 + MCFINTC_ICR0 + MCFINT_PIT1);
 	imr = __raw_readl(INTC0 + MCFPIT_IMR);
@@ -64,32 +100,14 @@
 	__raw_writel(imr, INTC0 + MCFPIT_IMR);
 
 	/* Set up PIT timer 1 as poll clock */
+	pit_cycles_per_jiffy = FREQ / HZ;
 	__raw_writew(MCFPIT_PCSR_DISABLE, TA(MCFPIT_PCSR));
-	__raw_writew(((MCF_CLK / 2) / 64) / HZ, TA(MCFPIT_PMR));
+	__raw_writew(pit_cycles_per_jiffy, TA(MCFPIT_PMR));
 	__raw_writew(MCFPIT_PCSR_EN | MCFPIT_PCSR_PIE | MCFPIT_PCSR_OVW |
 		MCFPIT_PCSR_RLD | MCFPIT_PCSR_CLK64, TA(MCFPIT_PCSR));
-}
-
-/***************************************************************************/
-
-unsigned long hw_timer_offset(void)
-{
-	volatile unsigned long *ipr;
-	unsigned long pmr, pcntr, offset;
-
-	ipr = (volatile unsigned long *) (MCF_IPSBAR + MCFICM_INTC0 + MCFPIT_IMR);
-
-	pmr = __raw_readw(TA(MCFPIT_PMR));
-	pcntr = __raw_readw(TA(MCFPIT_PCNTR));
 
-	/*
-	 * If we are still in the first half of the upcount and a
-	 * timer interupt is pending, then add on a ticks worth of time.
-	 */
-	offset = ((pmr - pcntr) * (1000000 / HZ)) / pmr;
-	if ((offset < (1000000 / HZ / 2)) && (*ipr & MCFPIT_IMR_IBIT))
-		offset += 1000000 / HZ;
-	return offset;	
+	pit_clk.mult = clocksource_hz2mult(FREQ, pit_clk.shift);
+	clocksource_register(&pit_clk);
 }
 
 /***************************************************************************/
