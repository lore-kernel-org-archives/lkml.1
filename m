Return-Path: <linux-kernel-owner+w=401wt.eu-S1756184AbYBAHl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184AbYBAHl1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 02:41:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935034AbYBAHik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 02:38:40 -0500
Received: from rex.snapgear.com ([203.143.235.140]:48054 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S935017AbYBAHii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 02:38:38 -0500
Date: Fri, 1 Feb 2008 17:37:36 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200802010737.m117ba6v022697@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU 03/06]: move ColdFire pit.c to its own coldfire directory
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move common ColdFire CPU pit.c to common coldfire platform directory.

Currently the common ColdFire CPU family code sits in the
arch/m68knommu/platform/5307 directory. This is confusing, the files
containing this common code are in no way specific to the 5307 ColdFire.
Create an arch/m68knommu/platform/coldfire directory to contain this
common code. Other m68knommu CPU varients do not need use this code
though, so it doesn't make sense to move it to arch/m68knommu/kernel.

Signed-off-by: Greg Ungerer <gerg@uclinux.org


diff -Naurp linux-2.6.24/arch/m68knommu/platform/5307/pit.c linux-2.6.24.1/arch/m68knommu/platform/5307/pit.c
--- linux-2.6.24/arch/m68knommu/platform/5307/pit.c	2008-01-25 08:58:37.000000000 +1000
+++ linux-2.6.24.1/arch/m68knommu/platform/5307/pit.c	1970-01-01 10:00:00.000000000 +1000
@@ -1,97 +0,0 @@
-/***************************************************************************/
-
-/*
- *	pit.c -- Freescale ColdFire PIT timer. Currently this type of
- *	         hardware timer only exists in the Freescale ColdFire
- *		 5270/5271, 5282 and other CPUs.
- *
- *	Copyright (C) 1999-2007, Greg Ungerer (gerg@snapgear.com)
- *	Copyright (C) 2001-2004, SnapGear Inc. (www.snapgear.com)
- */
-
-/***************************************************************************/
-
-#include <linux/kernel.h>
-#include <linux/sched.h>
-#include <linux/param.h>
-#include <linux/init.h>
-#include <linux/interrupt.h>
-#include <linux/irq.h>
-#include <asm/machdep.h>
-#include <asm/io.h>
-#include <asm/coldfire.h>
-#include <asm/mcfpit.h>
-#include <asm/mcfsim.h>
-
-/***************************************************************************/
-
-/*
- *	By default use timer1 as the system clock timer.
- */
-#define	TA(a)	(MCF_IPSBAR + MCFPIT_BASE1 + (a))
-
-/***************************************************************************/
-
-static irqreturn_t hw_tick(int irq, void *dummy)
-{
-	unsigned short pcsr;
-
-	/* Reset the ColdFire timer */
-	pcsr = __raw_readw(TA(MCFPIT_PCSR));
-	__raw_writew(pcsr | MCFPIT_PCSR_PIF, TA(MCFPIT_PCSR));
-
-	return arch_timer_interrupt(irq, dummy);
-}
-
-/***************************************************************************/
-
-static struct irqaction coldfire_pit_irq = {
-	.name	 = "timer",
-	.flags	 = IRQF_DISABLED | IRQF_TIMER,
-	.handler = hw_tick,
-};
-
-void hw_timer_init(void)
-{
-	volatile unsigned char *icrp;
-	volatile unsigned long *imrp;
-
-	setup_irq(MCFINT_VECBASE + MCFINT_PIT1, &coldfire_pit_irq);
-
-	icrp = (volatile unsigned char *) (MCF_IPSBAR + MCFICM_INTC0 +
-		MCFINTC_ICR0 + MCFINT_PIT1);
-	*icrp = ICR_INTRCONF;
-
-	imrp = (volatile unsigned long *) (MCF_IPSBAR + MCFICM_INTC0 + MCFPIT_IMR);
-	*imrp &= ~MCFPIT_IMR_IBIT;
-
-	/* Set up PIT timer 1 as poll clock */
-	__raw_writew(MCFPIT_PCSR_DISABLE, TA(MCFPIT_PCSR));
-	__raw_writew(((MCF_CLK / 2) / 64) / HZ, TA(MCFPIT_PMR));
-	__raw_writew(MCFPIT_PCSR_EN | MCFPIT_PCSR_PIE | MCFPIT_PCSR_OVW |
-		MCFPIT_PCSR_RLD | MCFPIT_PCSR_CLK64, TA(MCFPIT_PCSR));
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
-
-	/*
-	 * If we are still in the first half of the upcount and a
-	 * timer interrupt is pending, then add on a ticks worth of time.
-	 */
-	offset = ((pmr - pcntr) * (1000000 / HZ)) / pmr;
-	if ((offset < (1000000 / HZ / 2)) && (*ipr & MCFPIT_IMR_IBIT))
-		offset += 1000000 / HZ;
-	return offset;	
-}
-
-/***************************************************************************/
diff -Naurp linux-2.6.24/arch/m68knommu/platform/coldfire/pit.c linux-2.6.24.1/arch/m68knommu/platform/coldfire/pit.c
--- linux-2.6.24/arch/m68knommu/platform/coldfire/pit.c	1970-01-01 10:00:00.000000000 +1000
+++ linux-2.6.24.1/arch/m68knommu/platform/coldfire/pit.c	2008-01-25 08:58:37.000000000 +1000
@@ -0,0 +1,97 @@
+/***************************************************************************/
+
+/*
+ *	pit.c -- Freescale ColdFire PIT timer. Currently this type of
+ *	         hardware timer only exists in the Freescale ColdFire
+ *		 5270/5271, 5282 and other CPUs.
+ *
+ *	Copyright (C) 1999-2007, Greg Ungerer (gerg@snapgear.com)
+ *	Copyright (C) 2001-2004, SnapGear Inc. (www.snapgear.com)
+ */
+
+/***************************************************************************/
+
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/param.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <asm/machdep.h>
+#include <asm/io.h>
+#include <asm/coldfire.h>
+#include <asm/mcfpit.h>
+#include <asm/mcfsim.h>
+
+/***************************************************************************/
+
+/*
+ *	By default use timer1 as the system clock timer.
+ */
+#define	TA(a)	(MCF_IPSBAR + MCFPIT_BASE1 + (a))
+
+/***************************************************************************/
+
+static irqreturn_t hw_tick(int irq, void *dummy)
+{
+	unsigned short pcsr;
+
+	/* Reset the ColdFire timer */
+	pcsr = __raw_readw(TA(MCFPIT_PCSR));
+	__raw_writew(pcsr | MCFPIT_PCSR_PIF, TA(MCFPIT_PCSR));
+
+	return arch_timer_interrupt(irq, dummy);
+}
+
+/***************************************************************************/
+
+static struct irqaction coldfire_pit_irq = {
+	.name	 = "timer",
+	.flags	 = IRQF_DISABLED | IRQF_TIMER,
+	.handler = hw_tick,
+};
+
+void hw_timer_init(void)
+{
+	volatile unsigned char *icrp;
+	volatile unsigned long *imrp;
+
+	setup_irq(MCFINT_VECBASE + MCFINT_PIT1, &coldfire_pit_irq);
+
+	icrp = (volatile unsigned char *) (MCF_IPSBAR + MCFICM_INTC0 +
+		MCFINTC_ICR0 + MCFINT_PIT1);
+	*icrp = ICR_INTRCONF;
+
+	imrp = (volatile unsigned long *) (MCF_IPSBAR + MCFICM_INTC0 + MCFPIT_IMR);
+	*imrp &= ~MCFPIT_IMR_IBIT;
+
+	/* Set up PIT timer 1 as poll clock */
+	__raw_writew(MCFPIT_PCSR_DISABLE, TA(MCFPIT_PCSR));
+	__raw_writew(((MCF_CLK / 2) / 64) / HZ, TA(MCFPIT_PMR));
+	__raw_writew(MCFPIT_PCSR_EN | MCFPIT_PCSR_PIE | MCFPIT_PCSR_OVW |
+		MCFPIT_PCSR_RLD | MCFPIT_PCSR_CLK64, TA(MCFPIT_PCSR));
+}
+
+/***************************************************************************/
+
+unsigned long hw_timer_offset(void)
+{
+	volatile unsigned long *ipr;
+	unsigned long pmr, pcntr, offset;
+
+	ipr = (volatile unsigned long *) (MCF_IPSBAR + MCFICM_INTC0 + MCFPIT_IMR);
+
+	pmr = __raw_readw(TA(MCFPIT_PMR));
+	pcntr = __raw_readw(TA(MCFPIT_PCNTR));
+
+	/*
+	 * If we are still in the first half of the upcount and a
+	 * timer interrupt is pending, then add on a ticks worth of time.
+	 */
+	offset = ((pmr - pcntr) * (1000000 / HZ)) / pmr;
+	if ((offset < (1000000 / HZ / 2)) && (*ipr & MCFPIT_IMR_IBIT))
+		offset += 1000000 / HZ;
+	return offset;	
+}
+
+/***************************************************************************/
