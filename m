Return-Path: <linux-kernel-owner+w=401wt.eu-S1764347AbXGYOHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764347AbXGYOHl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 10:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755024AbXGYOHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 10:07:07 -0400
Received: from rex.snapgear.com ([203.143.235.140]:59453 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753734AbXGYOHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 10:07:04 -0400
Date: Thu, 26 Jul 2007 00:06:25 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200707251406.l6PE6PcZ005823@goober>
To: linux-kernel@vger.kernel.org
Subject: [M68KNOMMU 03/06]: use setup_irq() in 68328 timer
Cc: gerg@uclinux.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Timer setup is done early, cannot use request_irq(), change to
using setup_irq() in the 68328 timer code.

This is also a good time to simplify the functional setup of
m68knommu timers, to clean up external use of the functions
all over the board/cpu config code.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naur linux-2.6.22/arch/m68knommu/platform/68328/timers.c linux-2.6.22-uc0/arch/m68knommu/platform/68328/timers.c
--- linux-2.6.22/arch/m68knommu/platform/68328/timers.c	2007-07-12 15:23:02.000000000 +1000
+++ linux-2.6.22-uc0/arch/m68knommu/platform/68328/timers.c	2007-07-12 15:27:00.000000000 +1000
@@ -18,10 +18,10 @@
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
+#include <linux/irq.h>
 #include <asm/setup.h>
 #include <asm/system.h>
 #include <asm/pgtable.h>
-#include <asm/irq.h>
 #include <asm/machdep.h>
 #include <asm/MC68VZ328.h>
 
@@ -53,14 +53,29 @@
 
 /***************************************************************************/
 
-void m68328_timer_init(irq_handler_t timer_routine)
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
+static struct irqaction m68328_timer_irq = {
+	.name	 = "timer",
+	.flags	 = IRQF_DISABLED | IRQF_TIMER,
+	.handler = hw_tick,
+};
+
+void hw_timer_init(void)
 {
 	/* disable timer 1 */
 	TCTL = 0;
 
 	/* set ISR */
-	if (request_irq(TMR_IRQ_NUM, timer_routine, IRQ_FLG_LOCK, "timer", NULL)) 
-		panic("Unable to attach timer interrupt\n");
+	setup_irq(TMR_IRQ_NUM, &m68328_timer_irq);
 
 	/* Restart mode, Enable int, Set clock source */
 	TCTL = TCTL_OM | TCTL_IRQEN | CLOCK_SOURCE;
@@ -73,14 +88,7 @@
 
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
 
