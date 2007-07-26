Return-Path: <linux-kernel-owner+w=401wt.eu-S1765132AbXGZPKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765132AbXGZPKd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 11:10:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758975AbXGZPKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 11:10:17 -0400
Received: from rex.snapgear.com ([203.143.235.140]:47906 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758150AbXGZPKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 11:10:15 -0400
Date: Fri, 27 Jul 2007 01:09:00 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200707261509.l6QF90EQ004063@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: use setup_irq() in ColdFire simple timer
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use setup_irq() instead of request_irq() to set up system timer
in ColdFire simple timer code. With the old m68knommu irq code this
was safe, but it is not now within the generic irq framework.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---

diff -Naur linux-2.6.23-rc1-git2/arch/m68knommu/platform/5307/timers.c linux/arch/m68knommu/platform/5307/timers.c
--- linux-2.6.23-rc1-git2/arch/m68knommu/platform/5307/timers.c	2007-07-26 10:47:41.000000000 +1000
+++ linux/arch/m68knommu/platform/5307/timers.c	2007-07-26 22:54:53.000000000 +1000
@@ -3,7 +3,7 @@
 /*
  *	timers.c -- generic ColdFire hardware timer support.
  *
- *	Copyright (C) 1999-2006, Greg Ungerer (gerg@snapgear.com)
+ *	Copyright (C) 1999-2007, Greg Ungerer (gerg@snapgear.com)
  */
 
 /***************************************************************************/
@@ -13,8 +13,8 @@
 #include <linux/param.h>
 #include <linux/interrupt.h>
 #include <linux/init.h>
+#include <linux/irq.h>
 #include <asm/io.h>
-#include <asm/irq.h>
 #include <asm/traps.h>
 #include <asm/machdep.h>
 #include <asm/coldfire.h>
@@ -62,17 +62,24 @@
 
 /***************************************************************************/
 
+static struct irqaction coldfire_timer_irq = {
+        .name    = "timer",
+        .flags   = IRQF_DISABLED | IRQF_TIMER,
+};
+
 static int ticks_per_intr;
 
 void coldfire_timer_init(irq_handler_t handler)
 {
+	coldfire_timer_irq.handler = handler;
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
