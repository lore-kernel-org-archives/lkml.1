Return-Path: <linux-kernel-owner+w=401wt.eu-S932861AbXGZPLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932861AbXGZPLd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 11:11:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760533AbXGZPKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 11:10:21 -0400
Received: from rex.snapgear.com ([203.143.235.140]:47909 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758435AbXGZPKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 11:10:15 -0400
Date: Fri, 27 Jul 2007 01:09:00 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200707261509.l6QF906I004067@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: use setup_irq() in 68360 timer code
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use setup_irq() instead of request_irq() to set up system timer
in 68360 timer code. With the old m68knommu irq code this
was safe, but it is not now within the generic irq framework.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---

diff -Naur linux-2.6.23-rc1-git2/arch/m68knommu/platform/68360/config.c linux/arch/m68knommu/platform/68360/config.c
--- linux-2.6.23-rc1-git2/arch/m68knommu/platform/68360/config.c	2007-07-26 10:47:41.000000000 +1000
+++ linux/arch/m68knommu/platform/68360/config.c	2007-07-26 22:40:20.000000000 +1000
@@ -17,11 +17,11 @@
 #include <linux/tty.h>
 #include <linux/console.h>
 #include <linux/interrupt.h>
+#include <linux/irq.h>
 
 #include <asm/setup.h>
 #include <asm/system.h>
 #include <asm/pgtable.h>
-#include <asm/irq.h>
 #include <asm/machdep.h>
 #include <asm/m68360.h>
 
@@ -51,11 +51,15 @@
 
 extern void config_M68360_irq(void);
 
+static struct irqaction m68360_timer_irq = {
+	.name    = "timer",
+	.flags   = IRQF_DISABLED | IRQF_TIMER,
+};
+
 void BSP_sched_init(irq_handler_t timer_routine)
 {
   unsigned char prescaler;
   unsigned short tgcr_save;
-  int return_value;
 
 #if 0
   /* Restart mode, Enable int, 32KHz, Enable timer */
@@ -86,10 +90,8 @@
   pquicc->timer_ter1 = 0x0003; /* clear timer events */
 
   /* enable timer 1 interrupt in CIMR */
-//  request_irq(IRQ_MACHSPEC | CPMVEC_TIMER1, timer_routine, IRQ_FLG_LOCK, "timer", NULL);
-  //return_value = request_irq( CPMVEC_TIMER1, timer_routine, IRQ_FLG_LOCK, "timer", NULL);
-  return_value = request_irq(CPMVEC_TIMER1 , timer_routine, IRQ_FLG_LOCK,
-          "Timer", NULL);
+  m68360_timer_irq.handler = timer_routine;
+  setup_irq(CPMVEC_TIMER1, &m68360_timer_irq);
 
   /* Start timer 1: */
   tgcr_save = (pquicc->timer_tgcr & 0xfff0) | 0x0001;
