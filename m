Return-Path: <linux-kernel-owner+w=401wt.eu-S1755923AbXJXCEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923AbXJXCEq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 22:04:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753396AbXJXCEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 22:04:04 -0400
Received: from rex.snapgear.com ([203.143.235.140]:34294 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753203AbXJXCED (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 22:04:03 -0400
Date: Wed, 24 Oct 2007 12:03:20 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200710240203.l9O23Ksf016643@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: cleanup 68328 timer code
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use common function naming for 68328 timer functions to make them
consistent with the various other hardware m68knommu timers.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naurp linux-2.6.23/arch/m68knommu/platform/68328/timers.c linux-2.6.23-uc0/arch/m68knommu/platform/68328/timers.c
--- linux-2.6.23/arch/m68knommu/platform/68328/timers.c	2007-10-19 10:30:55.000000000 +1000
+++ linux-2.6.23-uc0/arch/m68knommu/platform/68328/timers.c	2007-10-19 10:35:40.000000000 +1000
@@ -53,18 +53,28 @@
 
 /***************************************************************************/
 
+static irqreturn_t hw_tick(int irq, void *dummy)
+{
+	/* Reset Timer1 */
+	TSTAT &= 0;
+
+	return arch_timer_interrupt(irq, dummy);
+}
+
+/***************************************************************************/
+
 static struct irqaction m68328_timer_irq = {
-	.name    = "timer",
-	.flags   = IRQF_DISABLED | IRQF_TIMER,
+	.name	 = "timer",
+	.flags	 = IRQF_DISABLED | IRQF_TIMER,
+	.handler = hw_tick,
 };
 
-void m68328_timer_init(irq_handler_t timer_routine)
+void hw_timer_init(void)
 {
 	/* disable timer 1 */
 	TCTL = 0;
 
 	/* set ISR */
-	m68328_timer_irq.handler = timer_routine;
 	setup_irq(TMR_IRQ_NUM, &m68328_timer_irq);
 
 	/* Restart mode, Enable int, Set clock source */
@@ -78,14 +88,7 @@ void m68328_timer_init(irq_handler_t tim
 
 /***************************************************************************/
 
-void m68328_timer_tick(void)
-{
-	/* Reset Timer1 */
-	TSTAT &= 0;
-}
-/***************************************************************************/
-
-unsigned long m68328_timer_gettimeoffset(void)
+unsigned long hw_timer_offset(void)
 {
 	unsigned long ticks = TCN, offset = 0;
 
