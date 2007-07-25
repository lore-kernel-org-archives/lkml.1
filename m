Return-Path: <linux-kernel-owner+w=401wt.eu-S1765591AbXGYOHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765591AbXGYOHy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 10:07:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755622AbXGYOHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 10:07:08 -0400
Received: from rex.snapgear.com ([203.143.235.140]:59452 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753652AbXGYOHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 10:07:04 -0400
Date: Thu, 26 Jul 2007 00:06:25 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200707251406.l6PE6PQ0005819@goober>
To: linux-kernel@vger.kernel.org
Subject: [M68KNOMMU 01/06]: use setup_irq() in ColdFire PIT timer
Cc: gerg@uclinux.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Timer setup is done early, cannot use request_irq(), change to
using setup_irq() in the Coldfire PIT timer code.

This is also a good time to simplify the functional setup of
ColdFire timers, to clean up external use of the functions
all over the board/cpu config code.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naur linux-2.6.22/arch/m68knommu/platform/5307/pit.c linux-2.6.22-uc0/arch/m68knommu/platform/5307/pit.c
--- linux-2.6.22/arch/m68knommu/platform/5307/pit.c	2007-07-12 15:23:02.000000000 +1000
+++ linux-2.6.22-uc0/arch/m68knommu/platform/5307/pit.c	2007-07-12 15:27:01.000000000 +1000
@@ -5,9 +5,8 @@
  *	         hardware timer only exists in the Freescale ColdFire
  *		 5270/5271, 5282 and other CPUs.
  *
- *	Copyright (C) 1999-2006, Greg Ungerer (gerg@snapgear.com)
+ *	Copyright (C) 1999-2007, Greg Ungerer (gerg@snapgear.com)
  *	Copyright (C) 2001-2004, SnapGear Inc. (www.snapgear.com)
- *
  */
 
 /***************************************************************************/
@@ -17,8 +16,8 @@
 #include <linux/param.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
+#include <linux/irq.h>
 #include <asm/io.h>
-#include <asm/irq.h>
 #include <asm/coldfire.h>
 #include <asm/mcfpit.h>
 #include <asm/mcfsim.h>
@@ -32,24 +31,31 @@
 
 /***************************************************************************/
 
-void coldfire_pit_tick(void)
+static irqreturn_t hw_tick(int irq, void *dummy)
 {
 	unsigned short pcsr;
 
 	/* Reset the ColdFire timer */
 	pcsr = __raw_readw(TA(MCFPIT_PCSR));
 	__raw_writew(pcsr | MCFPIT_PCSR_PIF, TA(MCFPIT_PCSR));
+
+	return arch_timer_interrupt(irq, dummy);
 }
 
 /***************************************************************************/
 
-void coldfire_pit_init(irq_handler_t handler)
+static struct irqaction coldfire_pit_irq = {
+	.name	 = "timer",
+	.flags	 = IRQF_DISABLED | IRQF_TIMER,
+	.handler = hw_tick,
+};
+
+void hw_timer_init(void)
 {
 	volatile unsigned char *icrp;
 	volatile unsigned long *imrp;
 
-	request_irq(MCFINT_VECBASE + MCFINT_PIT1, handler, IRQF_DISABLED,
-		"ColdFire Timer", NULL);
+	setup_irq(MCFINT_VECBASE + MCFINT_PIT1, &coldfire_pit_irq);
 
 	icrp = (volatile unsigned char *) (MCF_IPSBAR + MCFICM_INTC0 +
 		MCFINTC_ICR0 + MCFINT_PIT1);
@@ -67,7 +73,7 @@
 
 /***************************************************************************/
 
-unsigned long coldfire_pit_offset(void)
+unsigned long hw_timer_offset(void)
 {
 	volatile unsigned long *ipr;
 	unsigned long pmr, pcntr, offset;
