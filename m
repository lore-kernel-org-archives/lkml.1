Return-Path: <linux-kernel-owner+w=401wt.eu-S1765742AbXGYOIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765742AbXGYOIx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 10:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757837AbXGYOHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 10:07:11 -0400
Received: from rex.snapgear.com ([203.143.235.140]:59456 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753086AbXGYOHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 10:07:08 -0400
Date: Thu, 26 Jul 2007 00:06:25 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200707251406.l6PE6PEp005825@goober>
To: linux-kernel@vger.kernel.org
Subject: [M68KNOMMU 04/06]: use setup_irq() in 68360 timer
Cc: gerg@uclinux.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Timer setup is done early, cannot use request_irq(), change to
using setup_irq() in the 68360 timer code.

This is also a good time to simplify the functional setup of
m68knommu timers, to clean up external use of the functions
all over the board/cpu config code.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naur linux-2.6.22/arch/m68knommu/platform/68360/config.c linux-2.6.22-uc0/arch/m68knommu/platform/68360/config.c
--- linux-2.6.22/arch/m68knommu/platform/68360/config.c	2007-07-12 15:23:02.000000000 +1000
+++ linux-2.6.22-uc0/arch/m68knommu/platform/68360/config.c	2007-07-12 15:27:01.000000000 +1000
@@ -14,14 +14,12 @@
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
-#include <linux/tty.h>
-#include <linux/console.h>
 #include <linux/interrupt.h>
+#include <linux/irq.h>
 
 #include <asm/setup.h>
 #include <asm/system.h>
 #include <asm/pgtable.h>
-#include <asm/irq.h>
 #include <asm/machdep.h>
 #include <asm/m68360.h>
 
@@ -40,8 +38,6 @@
 
 unsigned long int system_clock;
 
-void M68360_init_IRQ(void);
-
 extern QUICC *pquicc;
 
 /* TODO  DON"T Hard Code this */
@@ -49,9 +45,24 @@
 // unsigned int system_clock = 33000000l;
 extern unsigned long int system_clock; //In kernel setup.c
 
-extern void config_M68360_irq(void);
 
-void BSP_sched_init(irq_handler_t timer_routine)
+static irqreturn_t hw_tick(int irq, void *dummy)
+{
+  /* Reset Timer1 */
+  /* TSTAT &= 0; */
+
+  pquicc->timer_ter1 = 0x0002; /* clear timer event */  
+
+  return arch_timer_interrupt(irq, dummy);
+}
+
+static struct irqaction m68360_timer_irq = {
+	.name	 = "timer",
+	.flags	 = IRQF_DISABLED | IRQF_TIMER,
+	.handler = hw_tick,
+};
+
+void hw_timer_init(void)
 {
   unsigned char prescaler;
   unsigned short tgcr_save;
@@ -88,24 +99,14 @@
   /* enable timer 1 interrupt in CIMR */
 //  request_irq(IRQ_MACHSPEC | CPMVEC_TIMER1, timer_routine, IRQ_FLG_LOCK, "timer", NULL);
   //return_value = request_irq( CPMVEC_TIMER1, timer_routine, IRQ_FLG_LOCK, "timer", NULL);
-  return_value = request_irq(CPMVEC_TIMER1 , timer_routine, IRQ_FLG_LOCK,
-          "Timer", NULL);
+  setup_irq(CPMVEC_TIMER1, &m68360_timer_irq);
 
   /* Start timer 1: */
   tgcr_save = (pquicc->timer_tgcr & 0xfff0) | 0x0001;
   pquicc->timer_tgcr  = tgcr_save;
 }
 
-
-void BSP_tick(void)
-{
-  /* Reset Timer1 */
-  /* TSTAT &= 0; */
-
-  pquicc->timer_ter1 = 0x0002; /* clear timer event */  
-}
-
-unsigned long BSP_gettimeoffset (void)
+unsigned long hw_timer_offset(void)
 {
   return 0;
 }
@@ -115,17 +116,7 @@
 {
 }
 
-int BSP_hwclk(int op, struct rtc_time *t)
-{
-  if (!op) {
-    /* read */
-  } else {
-    /* write */
-  }
-  return 0;
-}
-
-int BSP_set_clock_mmss (unsigned long nowtime)
+int BSP_set_clock_mmss(unsigned long nowtime)
 {
 #if 0
   short real_seconds = nowtime % 60, real_minutes = (nowtime / 60) % 60;
