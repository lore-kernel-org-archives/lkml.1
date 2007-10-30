Return-Path: <linux-kernel-owner+w=401wt.eu-S1755132AbXJ3EnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132AbXJ3EnW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 00:43:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752843AbXJ3EmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 00:42:24 -0400
Received: from rex.snapgear.com ([203.143.235.140]:37121 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752610AbXJ3EmW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 00:42:22 -0400
Date: Tue, 30 Oct 2007 14:41:14 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200710300441.l9U4fER7032197@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: use raw read/write for all register access in ColdFire timer
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use __raw_read/__raw_write to write to all registers (instead of
using local pointer de-referencing in ColdFirePIT timer code.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naurp linux-2.6.23/arch/m68knommu/platform/5307/pit.c linux-2.6.23-uc0/arch/m68knommu/platform/5307/pit.c
--- linux-2.6.23/arch/m68knommu/platform/5307/pit.c	2007-10-19 10:30:55.000000000 +1000
+++ linux-2.6.23-uc0/arch/m68knommu/platform/5307/pit.c	2007-10-19 10:35:40.000000000 +1000
@@ -29,6 +29,7 @@
  *	By default use timer1 as the system clock timer.
  */
 #define	TA(a)	(MCF_IPSBAR + MCFPIT_BASE1 + (a))
+#define	INTC0	(MCF_IPSBAR + MCFICM_INTC0)
 
 /***************************************************************************/
 
@@ -53,17 +54,14 @@ static struct irqaction coldfire_pit_irq
 
 void hw_timer_init(void)
 {
-	volatile unsigned char *icrp;
-	volatile unsigned long *imrp;
+	u32 imr;
 
 	setup_irq(MCFINT_VECBASE + MCFINT_PIT1, &coldfire_pit_irq);
 
-	icrp = (volatile unsigned char *) (MCF_IPSBAR + MCFICM_INTC0 +
-		MCFINTC_ICR0 + MCFINT_PIT1);
-	*icrp = ICR_INTRCONF;
-
-	imrp = (volatile unsigned long *) (MCF_IPSBAR + MCFICM_INTC0 + MCFPIT_IMR);
-	*imrp &= ~MCFPIT_IMR_IBIT;
+	__raw_writeb(ICR_INTRCONF, INTC0 + MCFINTC_ICR0 + MCFINT_PIT1);
+	imr = __raw_readl(INTC0 + MCFPIT_IMR);
+	imr &= ~MCFPIT_IMR_IBIT;
+	__raw_writel(imr, INTC0 + MCFPIT_IMR);
 
 	/* Set up PIT timer 1 as poll clock */
 	__raw_writew(MCFPIT_PCSR_DISABLE, TA(MCFPIT_PCSR));
