Return-Path: <linux-kernel-owner+w=401wt.eu-S1765723AbXEWN0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765723AbXEWN0d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 09:26:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759199AbXEWN0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 09:26:16 -0400
Received: from [198.99.130.12] ([198.99.130.12]:34360 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756706AbXEWN0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 09:26:15 -0400
Date: Wed, 23 May 2007 09:18:59 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Deal with IRQs having different IRQF_DISABLED
Message-ID: <20070523131859.GA5686@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

handle_IRQ_event either enables IRQs or leaves them disabled for the
entire chain.  However, there is nothing in request_irq or setup_irq
which ensures that all IRQs in a chain will have the same
IRQF_DISABLED.

This seems like a bug to me.  Below are two possible fixes -
enable/disable IRQs for each action or refuse to register an IRQ if
there is a mismatched IRQF_DISABLED.

-- 
Work email - jdike at linux dot intel dot com

Refuse to register an IRQ if it has a mismatched IRQF_DISABLED with
what's already in the IRQ chain.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 kernel/irq/manage.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: linux-2.6.21-mm/kernel/irq/manage.c
===================================================================
--- linux-2.6.21-mm.orig/kernel/irq/manage.c	2007-05-23 09:01:16.000000000 -0400
+++ linux-2.6.21-mm/kernel/irq/manage.c	2007-05-23 09:02:28.000000000 -0400
@@ -301,6 +301,14 @@ int setup_irq(unsigned int irq, struct i
 			goto mismatch;
 		}
 
+		/*
+		 * Handlers must agree on disabling IRQs since
+		 * handle_IRQ_event leaves IRQs either on or off for
+		 * the entire chain.
+		 */
+		if ((old->flags ^ new->flags) & IRQF_DISABLED)
+			goto mismatch;
+
 #if defined(CONFIG_IRQ_PER_CPU)
 		/* All handlers must agree on per-cpuness */
 		if ((old->flags & IRQF_PERCPU) !=


Move the enabling/disabling of IRQs into the loop so that actions with
differing IRQF_DISABLED get the IRQ enabling that they asked for.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 kernel/irq/handle.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

Index: linux-2.6.21-mm/kernel/irq/handle.c
===================================================================
--- linux-2.6.21-mm.orig/kernel/irq/handle.c	2007-05-16 18:21:18.000000000 -0400
+++ linux-2.6.21-mm/kernel/irq/handle.c	2007-05-23 09:02:57.000000000 -0400
@@ -133,20 +133,21 @@ irqreturn_t handle_IRQ_event(unsigned in
 
 	handle_dynamic_tick(action);
 
-	if (!(action->flags & IRQF_DISABLED))
-		local_irq_enable_in_hardirq();
-
 	do {
+		if (!(action->flags & IRQF_DISABLED))
+			local_irq_enable_in_hardirq();
+
 		ret = action->handler(irq, action->dev_id);
 		if (ret == IRQ_HANDLED)
 			status |= action->flags;
 		retval |= ret;
 		action = action->next;
+
+		local_irq_disable();
 	} while (action);
 
 	if (status & IRQF_SAMPLE_RANDOM)
 		add_interrupt_randomness(irq);
-	local_irq_disable();
 
 	return retval;
 }
