Return-Path: <linux-kernel-owner+w=401wt.eu-S1756058AbXJXCFB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058AbXJXCFB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 22:05:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753704AbXJXCEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 22:04:08 -0400
Received: from rex.snapgear.com ([203.143.235.140]:34296 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753512AbXJXCEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 22:04:07 -0400
Date: Wed, 24 Oct 2007 12:03:25 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200710240203.l9O23P8O016648@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: cleanup 68360 startup code
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up 68360 timer support code. Removed header includes not needed.
Remove use of old m68knommu timer function pointers. Use common function
naming for 68328 timer functions.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naurp linux-2.6.23/arch/m68knommu/platform/68360/config.c linux-2.6.23-uc0/arch/m68knommu/platform/68360/config.c
--- linux-2.6.23/arch/m68knommu/platform/68360/config.c	2007-10-19 10:30:56.000000000 +1000
+++ linux-2.6.23-uc0/arch/m68knommu/platform/68360/config.c	2007-10-19 10:35:41.000000000 +1000
@@ -14,8 +14,6 @@
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
-#include <linux/tty.h>
-#include <linux/console.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 
@@ -40,8 +38,6 @@ extern void m360_cpm_reset(void);
 
 unsigned long int system_clock;
 
-void M68360_init_IRQ(void);
-
 extern QUICC *pquicc;
 
 /* TODO  DON"T Hard Code this */
@@ -49,14 +45,24 @@ extern QUICC *pquicc;
 // unsigned int system_clock = 33000000l;
 extern unsigned long int system_clock; //In kernel setup.c
 
-extern void config_M68360_irq(void);
+
+static irqreturn_t hw_tick(int irq, void *dummy)
+{
+  /* Reset Timer1 */
+  /* TSTAT &= 0; */
+
+  pquicc->timer_ter1 = 0x0002; /* clear timer event */
+
+  return arch_timer_interrupt(irq, dummy);
+}
 
 static struct irqaction m68360_timer_irq = {
-	.name    = "timer",
-	.flags   = IRQF_DISABLED | IRQF_TIMER,
+	.name	 = "timer",
+	.flags	 = IRQF_DISABLED | IRQF_TIMER,
+	.handler = hw_tick,
 };
 
-void BSP_sched_init(irq_handler_t timer_routine)
+void hw_timer_init(void)
 {
   unsigned char prescaler;
   unsigned short tgcr_save;
@@ -90,7 +96,6 @@ void BSP_sched_init(irq_handler_t timer_
   pquicc->timer_ter1 = 0x0003; /* clear timer events */
 
   /* enable timer 1 interrupt in CIMR */
-  m68360_timer_irq.handler = timer_routine;
   setup_irq(CPMVEC_TIMER1, &m68360_timer_irq);
 
   /* Start timer 1: */
@@ -98,16 +103,7 @@ void BSP_sched_init(irq_handler_t timer_
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
@@ -117,17 +113,7 @@ void BSP_gettod (int *yearp, int *monp, 
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
@@ -200,11 +186,6 @@ void config_BSP(char *command, int len)
   scc1_hwaddr = "\00\01\02\03\04\05";
 #endif
  
-  mach_sched_init      = BSP_sched_init;
-  mach_tick            = BSP_tick;
-  mach_gettimeoffset   = BSP_gettimeoffset;
   mach_gettod          = BSP_gettod;
-  mach_hwclk           = NULL;
-  mach_set_clock_mmss  = NULL;
   mach_reset           = BSP_reset;
 }
