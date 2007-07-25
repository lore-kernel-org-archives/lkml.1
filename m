Return-Path: <linux-kernel-owner+w=401wt.eu-S1757268AbXGYOIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268AbXGYOIh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 10:08:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757095AbXGYOHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 10:07:10 -0400
Received: from rex.snapgear.com ([203.143.235.140]:59457 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753481AbXGYOHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 10:07:08 -0400
Date: Thu, 26 Jul 2007 00:06:25 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200707251406.l6PE6PKo005821@goober>
To: linux-kernel@vger.kernel.org
Subject: [M68KNOMMU 02/06]: use setup_irq() in ColdFire simple timer
Cc: gerg@uclinux.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Timer setup is done early, cannot use request_irq(), change to
using setup_irq() in the Coldfire simple timer code.

This is also a good time to simplify the functional setup of
ColdFire timers, to clean up external use of the functions
all over the board/cpu config code.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naur linux-2.6.22/arch/m68knommu/platform/5307/timers.c linux-2.6.22-uc0/arch/m68knommu/platform/5307/timers.c
--- linux-2.6.22/arch/m68knommu/platform/5307/timers.c	2007-07-12 15:23:02.000000000 +1000
+++ linux-2.6.22-uc0/arch/m68knommu/platform/5307/timers.c	2007-07-12 15:27:01.000000000 +1000
@@ -3,18 +3,17 @@
 /*
  *	timers.c -- generic ColdFire hardware timer support.
  *
- *	Copyright (C) 1999-2006, Greg Ungerer (gerg@snapgear.com)
+ *	Copyright (C) 1999-2007, Greg Ungerer (gerg@snapgear.com)
  */
 
 /***************************************************************************/
 
 #include <linux/kernel.h>
+#include <linux/init.h>
 #include <linux/sched.h>
-#include <linux/param.h>
 #include <linux/interrupt.h>
-#include <linux/init.h>
+#include <linux/irq.h>
 #include <asm/io.h>
-#include <asm/irq.h>
 #include <asm/traps.h>
 #include <asm/machdep.h>
 #include <asm/coldfire.h>
@@ -54,25 +53,36 @@
 
 /***************************************************************************/
 
-void coldfire_tick(void)
+static irqreturn_t hw_tick(int irq, void *dummy)
 {
 	/* Reset the ColdFire timer */
 	__raw_writeb(MCFTIMER_TER_CAP | MCFTIMER_TER_REF, TA(MCFTIMER_TER));
+
+	return arch_timer_interrupt(irq, dummy);
 }
 
 /***************************************************************************/
 
+static struct irqaction coldfire_timer_irq = {
+	.name	 = "timer",
+	.flags	 = IRQF_DISABLED | IRQF_TIMER,
+	.handler = hw_tick,
+};
+
+/***************************************************************************/
+
 static int ticks_per_intr;
 
-void coldfire_timer_init(irq_handler_t handler)
+void hw_timer_init(void)
 {
+	setup_irq(mcf_timervector, &coldfire_timer_irq);
+
 	__raw_writew(MCFTIMER_TMR_DISABLE, TA(MCFTIMER_TMR));
 	ticks_per_intr = (MCF_BUSCLK / 16) / HZ;
 	__raw_writetrr(ticks_per_intr - 1, TA(MCFTIMER_TRR));
 	__raw_writew(MCFTIMER_TMR_ENORI | MCFTIMER_TMR_CLK16 |
 		MCFTIMER_TMR_RESTART | MCFTIMER_TMR_ENABLE, TA(MCFTIMER_TMR));
 
-	request_irq(mcf_timervector, handler, IRQF_DISABLED, "timer", NULL);
 	mcf_settimericr(1, mcf_timerlevel);
 
 #ifdef CONFIG_HIGHPROFILE
@@ -82,7 +92,7 @@
 
 /***************************************************************************/
 
-unsigned long coldfire_timer_offset(void)
+unsigned long hw_timer_offset(void)
 {
 	unsigned long tcn, offset;
 
