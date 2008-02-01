Return-Path: <linux-kernel-owner+w=401wt.eu-S935934AbYBAHsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935934AbYBAHsj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 02:48:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933160AbYBAHlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 02:41:12 -0500
Received: from rex.snapgear.com ([203.143.235.140]:48107 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934943AbYBAHlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 02:41:09 -0500
Date: Fri, 1 Feb 2008 17:40:17 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200802010740.m117eHNS022774@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU 01/07]: switch 68328 timer to use GENERIC_TIME
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch the 68328 CPU timer code to using GENERIC_TIME.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naurp linux-2.6.24/arch/m68knommu/platform/68328/timers.c linux-2.6.24-uc0/arch/m68knommu/platform/68328/timers.c
--- linux-2.6.24/arch/m68knommu/platform/68328/timers.c	2008-01-25 08:58:37.000000000 +1000
+++ linux-2.6.24-uc0/arch/m68knommu/platform/68328/timers.c	2008-01-25 14:32:37.000000000 +1000
@@ -19,6 +19,7 @@
 #include <linux/mm.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
+#include <linux/clocksource.h>
 #include <asm/setup.h>
 #include <asm/system.h>
 #include <asm/pgtable.h>
@@ -51,6 +52,19 @@
 #define TICKS_PER_JIFFY	10
 #endif
 
+static u32 m68328_tick_cnt;
+
+/***************************************************************************/
+
+static irqreturn_t hw_tick(int irq, void *dummy)
+{
+	/* Reset Timer1 */
+	TSTAT &= 0;
+
+	m68328_tick_cnt += TICKS_PER_JIFFY;
+	return arch_timer_interrupt(irq, dummy);
+}
+
 /***************************************************************************/
 
 static irqreturn_t hw_tick(int irq, void *dummy)
@@ -69,6 +83,33 @@ static struct irqaction m68328_timer_irq
 	.handler = hw_tick,
 };
 
+/***************************************************************************/
+
+static cycle_t m68328_read_clk(void)
+{
+	unsigned long flags;
+	u32 cycles;
+
+	local_irq_save(flags);
+	cycles = m68328_tick_cnt + TCN;
+	local_irq_restore(flags);
+
+	return cycles;
+}
+
+/***************************************************************************/
+
+static struct clocksource m68328_clk = {
+	.name	= "timer",
+	.rating	= 250,
+	.read	= m68328_read_clk,
+	.shift	= 20,
+	.mask	= CLOCKSOURCE_MASK(32),
+	.flags	= CLOCK_SOURCE_IS_CONTINUOUS,
+};
+
+/***************************************************************************/
+
 void hw_timer_init(void)
 {
 	/* disable timer 1 */
@@ -84,19 +125,8 @@ void hw_timer_init(void)
 
 	/* Enable timer 1 */
 	TCTL |= TCTL_TEN;
-}
-
-/***************************************************************************/
-
-unsigned long hw_timer_offset(void)
-{
-	unsigned long ticks = TCN, offset = 0;
-
-	/* check for pending interrupt */
-	if (ticks < (TICKS_PER_JIFFY >> 1) && (ISR & (1 << TMR_IRQ_NUM)))
-		offset = 1000000 / HZ;
-	ticks = (ticks * 1000000 / HZ) / TICKS_PER_JIFFY;
-	return ticks + offset;
+	m68328_clk.mult = clocksource_hz2mult(TICKS_PER_JIFFY*HZ, m68328_clk.shift);
+	clocksource_register(&m68328_clk);
 }
 
 /***************************************************************************/
