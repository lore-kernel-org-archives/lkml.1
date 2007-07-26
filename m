Return-Path: <linux-kernel-owner+w=401wt.eu-S1765974AbXGZPKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765974AbXGZPKt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 11:10:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759089AbXGZPKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 11:10:18 -0400
Received: from rex.snapgear.com ([203.143.235.140]:47907 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758423AbXGZPKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 11:10:15 -0400
Date: Fri, 27 Jul 2007 01:09:00 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200707261509.l6QF90qU004061@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: use setup_irq() in ColdFire PIT timer
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use setup_irq() instead of request_irq() to set up system timer
in ColdFire PIT timer code. With the old m68knommu irq code this
was safe, but it is not now within the generic irq framework.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---

diff -Naur linux-2.6.23-rc1-git2/arch/m68knommu/platform/5307/pit.c linux/arch/m68knommu/platform/5307/pit.c
--- linux-2.6.23-rc1-git2/arch/m68knommu/platform/5307/pit.c	2007-07-26 10:47:41.000000000 +1000
+++ linux/arch/m68knommu/platform/5307/pit.c	2007-07-26 22:54:40.000000000 +1000
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
@@ -43,13 +42,18 @@
 
 /***************************************************************************/
 
+static struct irqaction coldfire_pit_irq = {
+	.name    = "timer",
+	.flags   = IRQF_DISABLED | IRQF_TIMER,
+};
+
 void coldfire_pit_init(irq_handler_t handler)
 {
 	volatile unsigned char *icrp;
 	volatile unsigned long *imrp;
 
-	request_irq(MCFINT_VECBASE + MCFINT_PIT1, handler, IRQF_DISABLED,
-		"ColdFire Timer", NULL);
+	coldfire_pit_irq.handler = handler;
+	setup_irq(MCFINT_VECBASE + MCFINT_PIT1, &coldfire_pit_irq);
 
 	icrp = (volatile unsigned char *) (MCF_IPSBAR + MCFICM_INTC0 +
 		MCFINTC_ICR0 + MCFINT_PIT1);
