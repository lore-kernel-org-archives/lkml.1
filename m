Return-Path: <linux-kernel-owner+w=401wt.eu-S933114AbXGZPML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933114AbXGZPML (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 11:12:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764534AbXGZPKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 11:10:24 -0400
Received: from rex.snapgear.com ([203.143.235.140]:47911 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758461AbXGZPKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 11:10:21 -0400
Date: Fri, 27 Jul 2007 01:09:00 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200707261509.l6QF90Am004065@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: use setup_irq() in 68328 timer code
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use setup_irq() instead of request_irq() to set up system timer
in 68328 timer code. With the old m68knommu irq code this
was safe, but it is not now within the generic irq framework.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---

diff -Naur linux-2.6.23-rc1-git2/arch/m68knommu/platform/68328/timers.c linux/arch/m68knommu/platform/68328/timers.c
--- linux-2.6.23-rc1-git2/arch/m68knommu/platform/68328/timers.c	2007-07-26 10:47:40.000000000 +1000
+++ linux/arch/m68knommu/platform/68328/timers.c	2007-07-26 22:55:51.000000000 +1000
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
 
@@ -53,14 +53,19 @@
 
 /***************************************************************************/
 
+static struct irqaction m68328_timer_irq = {
+	.name    = "timer",
+	.flags   = IRQF_DISABLED | IRQF_TIMER,
+};
+
 void m68328_timer_init(irq_handler_t timer_routine)
 {
 	/* disable timer 1 */
 	TCTL = 0;
 
 	/* set ISR */
-	if (request_irq(TMR_IRQ_NUM, timer_routine, IRQ_FLG_LOCK, "timer", NULL)) 
-		panic("Unable to attach timer interrupt\n");
+	m68328_timer_irq.handler = timer_routine;
+	setup_irq(TMR_IRQ_NUM, &m68328_timer_irq);
 
 	/* Restart mode, Enable int, Set clock source */
 	TCTL = TCTL_OM | TCTL_IRQEN | CLOCK_SOURCE;
