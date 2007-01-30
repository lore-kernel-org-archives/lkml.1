Return-Path: <linux-kernel-owner+w=401wt.eu-S965470AbXA3JeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965470AbXA3JeR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 04:34:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965471AbXA3JeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 04:34:17 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46596 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965470AbXA3JeQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 04:34:16 -0500
Date: Tue, 30 Jan 2007 10:33:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@osdl.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: [patch] genirq: do not mask interrupts by default
Message-ID: <20070130093302.GA24436@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -3.7
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-3.7 required=5.9 tests=ALL_TRUSTED,BAYES_05 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-0.4 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0125]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [patch] genirq: do not mask interrupts by default
From: Ingo Molnar <mingo@elte.hu>

never mask interrupts immediately upon request. Disabling interrupts in 
high-performance codepaths is rare, and on the other hand this change 
could recover lost edges (or even other types of lost interrupts) by 
conservatively only masking interrupts after they happen. (NOTE: with 
this change the highlevel irq-disable code still soft-disables this IRQ 
line - and if such an interrupt happens then the IRQ flow handler keeps 
the IRQ masked.)

mark i8529A controllers as 'never loses an edge'.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/i386/kernel/i8259.c   |    1 +
 arch/x86_64/kernel/i8259.c |    1 +
 kernel/irq/chip.c          |   17 ++++++++++-------
 3 files changed, 12 insertions(+), 7 deletions(-)

Index: linux/arch/i386/kernel/i8259.c
===================================================================
--- linux.orig/arch/i386/kernel/i8259.c
+++ linux/arch/i386/kernel/i8259.c
@@ -41,6 +41,7 @@ static void mask_and_ack_8259A(unsigned 
 static struct irq_chip i8259A_chip = {
 	.name		= "XT-PIC",
 	.mask		= disable_8259A_irq,
+	.disable	= disable_8259A_irq,
 	.unmask		= enable_8259A_irq,
 	.mask_ack	= mask_and_ack_8259A,
 };
Index: linux/arch/x86_64/kernel/i8259.c
===================================================================
--- linux.orig/arch/x86_64/kernel/i8259.c
+++ linux/arch/x86_64/kernel/i8259.c
@@ -103,6 +103,7 @@ static void mask_and_ack_8259A(unsigned 
 static struct irq_chip i8259A_chip = {
 	.name		= "XT-PIC",
 	.mask		= disable_8259A_irq,
+	.disable	= disable_8259A_irq,
 	.unmask		= enable_8259A_irq,
 	.mask_ack	= mask_and_ack_8259A,
 };
Index: linux/kernel/irq/chip.c
===================================================================
--- linux.orig/kernel/irq/chip.c
+++ linux/kernel/irq/chip.c
@@ -202,10 +202,6 @@ static void default_enable(unsigned int 
  */
 static void default_disable(unsigned int irq)
 {
-	struct irq_desc *desc = irq_desc + irq;
-
-	if (!(desc->status & IRQ_DELAYED_DISABLE))
-		desc->chip->mask(irq);
 }
 
 /*
@@ -270,13 +266,18 @@ handle_simple_irq(unsigned int irq, stru
 
 	if (unlikely(desc->status & IRQ_INPROGRESS))
 		goto out_unlock;
-	desc->status &= ~(IRQ_REPLAY | IRQ_WAITING);
 	kstat_cpu(cpu).irqs[irq]++;
 
 	action = desc->action;
-	if (unlikely(!action || (desc->status & IRQ_DISABLED)))
+	if (unlikely(!action || (desc->status & IRQ_DISABLED))) {
+		if (desc->chip->mask)
+			desc->chip->mask(irq);
+		desc->status &= ~(IRQ_REPLAY | IRQ_WAITING);
+		desc->status |= IRQ_PENDING;
 		goto out_unlock;
+	}
 
+	desc->status &= ~(IRQ_REPLAY | IRQ_WAITING | IRQ_PENDING);
 	desc->status |= IRQ_INPROGRESS;
 	spin_unlock(&desc->lock);
 
@@ -368,11 +369,13 @@ handle_fasteoi_irq(unsigned int irq, str
 
 	/*
 	 * If its disabled or no action available
-	 * keep it masked and get out of here
+	 * then mask it and get out of here:
 	 */
 	action = desc->action;
 	if (unlikely(!action || (desc->status & IRQ_DISABLED))) {
 		desc->status |= IRQ_PENDING;
+		if (desc->chip->mask)
+			desc->chip->mask(irq);
 		goto out;
 	}

----- End forwarded message -----
