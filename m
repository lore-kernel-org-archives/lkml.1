Return-Path: <linux-kernel-owner+w=401wt.eu-S1753713AbYJAMr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713AbYJAMr3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 08:47:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752532AbYJAMrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 08:47:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39973 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752427AbYJAMrU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 08:47:20 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] MN10300: Fix IRQ handling
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: dhowells@redhat.com, linux-am33-list@redhat.com,
       linux-kernel@vger.kernel.org
Date: Wed, 01 Oct 2008 13:47:06 +0100
Message-ID: <20081001124706.25084.76943.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the IRQ handling on the MN10300 arch.

This patch makes a number of significant changes:

 (1) It separates the irq_chip definition for edge-triggered interrupts from
     the one for level-triggered interrupts.

     This is necessary because the MN10300 PIC latches the IRQ channel's
     interrupt request bit (GxICR_REQUEST), even after the device has ceased to
     assert its interrupt line and the interrupt channel has been disabled in
     the PIC.  So for level-triggered interrupts we need to clear this bit when
     we re-enable - which is achieved by setting GxICR_DETECT but not
     GxICR_REQUEST when writing to the register.

     Not doing this results in spurious interrupts occurring because calling
     mask_ack() at the start of handle_level_irq() is insufficient - it fails
     to clear the REQUEST latch because the device that caused the interrupt is
     still asserting its interrupt line at this point.

 (2) IRQ disablement [irq_chip::disable_irq()] shouldn't clear the interrupt
     request flag for edge-triggered interrupts lest it lose an interrupt.

 (3) IRQ unmasking [irq_chip::unmask_irq()] also shouldn't clear the interrupt
     request flag for edge-triggered interrupts lest it lose an interrupt.

 (4) The end() operation is now left to the default (no-operation) as
     __do_IRQ() is compiled out.  This may affect misrouted_irq(), but
     according to Thomas Gleixner it's the correct thing to do.

 (5) handle_level_irq() is used for edge-triggered interrupts rather than
     handle_edge_irq() as the MN10300 PIC latches interrupt events even on
     masked IRQ channels, thus rendering IRQ_PENDING unnecessary.  It is
     sufficient to call mask_ack() at the start and unmask() at the end.

 (6) For level-triggered interrupts, ack() is now NULL as it's not used, and
     there is no effective ACK function on the PIC.  mask_ack() is now the
     same as mask() as the latch continues to latch, even when the channel is
     masked.

Further, the patch discards the disable() op implementation as its now the same
as the mask() op implementation, which is used instead.

It also discards the enable() op implementations as they're now the same as
the unmask() op implementations, which are used instead.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/kernel/irq.c             |   71 +++++++++++++++++++++------------
 arch/mn10300/unit-asb2303/unit-init.c |    2 -
 arch/mn10300/unit-asb2305/unit-init.c |    2 -
 3 files changed, 47 insertions(+), 28 deletions(-)


diff --git a/arch/mn10300/kernel/irq.c b/arch/mn10300/kernel/irq.c
index 761c434..56c64cc 100644
--- a/arch/mn10300/kernel/irq.c
+++ b/arch/mn10300/kernel/irq.c
@@ -20,22 +20,8 @@ EXPORT_SYMBOL(__mn10300_irq_enabled_epsw);
 atomic_t irq_err_count;
 
 /*
- * MN10300 INTC controller operations
+ * MN10300 interrupt controller operations
  */
-static void mn10300_cpupic_disable(unsigned int irq)
-{
-	u16 tmp = GxICR(irq);
-	GxICR(irq) = (tmp & GxICR_LEVEL) | GxICR_DETECT;
-	tmp = GxICR(irq);
-}
-
-static void mn10300_cpupic_enable(unsigned int irq)
-{
-	u16 tmp = GxICR(irq);
-	GxICR(irq) = (tmp & GxICR_LEVEL) | GxICR_ENABLE;
-	tmp = GxICR(irq);
-}
-
 static void mn10300_cpupic_ack(unsigned int irq)
 {
 	u16 tmp;
@@ -60,26 +46,54 @@ static void mn10300_cpupic_mask_ack(unsigned int irq)
 static void mn10300_cpupic_unmask(unsigned int irq)
 {
 	u16 tmp = GxICR(irq);
-	GxICR(irq) = (tmp & GxICR_LEVEL) | GxICR_ENABLE | GxICR_DETECT;
+	GxICR(irq) = (tmp & GxICR_LEVEL) | GxICR_ENABLE;
 	tmp = GxICR(irq);
 }
 
-static void mn10300_cpupic_end(unsigned int irq)
+static void mn10300_cpupic_unmask_clear(unsigned int irq)
 {
+	/* the MN10300 PIC latches its interrupt request bit, even after the
+	 * device has ceased to assert its interrupt line and the interrupt
+	 * channel has been disabled in the PIC, so for level-triggered
+	 * interrupts we need to clear the request bit when we re-enable */
 	u16 tmp = GxICR(irq);
-	GxICR(irq) = (tmp & GxICR_LEVEL) | GxICR_ENABLE;
+	GxICR(irq) = (tmp & GxICR_LEVEL) | GxICR_ENABLE | GxICR_DETECT;
 	tmp = GxICR(irq);
 }
 
-static struct irq_chip mn10300_cpu_pic = {
-	.name		= "cpu",
-	.disable	= mn10300_cpupic_disable,
-	.enable		= mn10300_cpupic_enable,
+/*
+ * MN10300 PIC level-triggered IRQ handling.
+ *
+ * The PIC has no 'ACK' function per se.  It is possible to clear individual
+ * channel latches, but each latch relatches whether or not the channel is
+ * masked, so we need to clear the latch when we unmask the channel.
+ *
+ * Also for this reason, we don't supply an ack() op (it's unused anyway if
+ * mask_ack() is provided), and mask_ack() just masks.
+ */
+static struct irq_chip mn10300_cpu_pic_level = {
+	.name		= "cpu_l",
+	.disable	= mn10300_cpupic_mask,
+	.enable		= mn10300_cpupic_unmask_clear,
+	.ack		= NULL,
+	.mask		= mn10300_cpupic_mask,
+	.mask_ack	= mn10300_cpupic_mask,
+	.unmask		= mn10300_cpupic_unmask_clear,
+};
+
+/*
+ * MN10300 PIC edge-triggered IRQ handling.
+ *
+ * We use the latch clearing function of the PIC as the 'ACK' function.
+ */
+static struct irq_chip mn10300_cpu_pic_edge = {
+	.name		= "cpu_e",
+	.disable	= mn10300_cpupic_mask,
+	.enable		= mn10300_cpupic_unmask,
 	.ack		= mn10300_cpupic_ack,
 	.mask		= mn10300_cpupic_mask,
 	.mask_ack	= mn10300_cpupic_mask_ack,
 	.unmask		= mn10300_cpupic_unmask,
-	.end		= mn10300_cpupic_end,
 };
 
 /*
@@ -114,7 +128,8 @@ void set_intr_level(int irq, u16 level)
  */
 void set_intr_postackable(int irq)
 {
-	set_irq_handler(irq, handle_level_irq);
+	set_irq_chip_and_handler(irq, &mn10300_cpu_pic_level,
+				 handle_level_irq);
 }
 
 /*
@@ -126,8 +141,12 @@ void __init init_IRQ(void)
 
 	for (irq = 0; irq < NR_IRQS; irq++)
 		if (irq_desc[irq].chip == &no_irq_type)
-			set_irq_chip_and_handler(irq, &mn10300_cpu_pic,
-						 handle_edge_irq);
+			/* due to the PIC latching interrupt requests, even
+			 * when the IRQ is disabled, IRQ_PENDING is superfluous
+			 * and we can use handle_level_irq() for edge-triggered
+			 * interrupts */
+			set_irq_chip_and_handler(irq, &mn10300_cpu_pic_edge,
+						 handle_level_irq);
 	unit_init_IRQ();
 }
 
diff --git a/arch/mn10300/unit-asb2303/unit-init.c b/arch/mn10300/unit-asb2303/unit-init.c
index 14b2c81..70e8cb4 100644
--- a/arch/mn10300/unit-asb2303/unit-init.c
+++ b/arch/mn10300/unit-asb2303/unit-init.c
@@ -51,7 +51,7 @@ void __init unit_init_IRQ(void)
 		switch (GET_XIRQ_TRIGGER(extnum)) {
 		case XIRQ_TRIGGER_HILEVEL:
 		case XIRQ_TRIGGER_LOWLEVEL:
-			set_irq_handler(XIRQ2IRQ(extnum), handle_level_irq);
+			set_intr_postackable(XIRQ2IRQ(extnum));
 			break;
 		default:
 			break;
diff --git a/arch/mn10300/unit-asb2305/unit-init.c b/arch/mn10300/unit-asb2305/unit-init.c
index 6a35241..72812a9 100644
--- a/arch/mn10300/unit-asb2305/unit-init.c
+++ b/arch/mn10300/unit-asb2305/unit-init.c
@@ -52,7 +52,7 @@ void __init unit_init_IRQ(void)
 		switch (GET_XIRQ_TRIGGER(extnum)) {
 		case XIRQ_TRIGGER_HILEVEL:
 		case XIRQ_TRIGGER_LOWLEVEL:
-			set_irq_handler(XIRQ2IRQ(extnum), handle_level_irq);
+			set_intr_postackable(XIRQ2IRQ(extnum));
 			break;
 		default:
 			break;

