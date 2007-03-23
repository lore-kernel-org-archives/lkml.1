Return-Path: <linux-kernel-owner+w=401wt.eu-S1753400AbXCWTBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400AbXCWTBw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 15:01:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751067AbXCWTBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 15:01:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32799 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753394AbXCWTB1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 15:01:27 -0400
Message-Id: <20070323190111.630752000@strauss.suse.de>
References: <20070323164447.659982000@strauss.suse.de>
User-Agent: quilt/0.46-14
Date: Fri, 23 Mar 2007 17:44:48 +0100
From: Bernhard Walle <bwalle@suse.de>
To: Andrew Morton <akpm@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 1/7] Add IRQF_IRQPOLL_IRQ flag (common code)
Content-Disposition: inline; filename=IRQF_IRQPOLL_IRQ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a IRQF_IRQPOLL_IRQ flag that the interrupt registration code
could use for the interrupt it wants to use for IRQ polling.

Because this must not be the timer interrupt, an additional flag was added
instead of re-using the IRQF_TIMER constant. Until all architectures will have
an IRQF_IRQPOLL_IRQ interrupt, irq == 0 will stay as alternative as it should
not break anything.

Also, note_interrupt() is called on CPU-specific interrupts to be used as
interrupt source for IRQ polling.


Signed-off-by: Bernhard Walle <bwalle@suse.de>
---
 include/linux/interrupt.h |    4 ++++
 kernel/irq/handle.c       |    2 ++
 kernel/irq/spurious.c     |    4 +++-
 3 files changed, 9 insertions(+), 1 deletion(-)

Index: linux-2.6.21-rc4-mm1/include/linux/interrupt.h
===================================================================
--- linux-2.6.21-rc4-mm1.orig/include/linux/interrupt.h
+++ linux-2.6.21-rc4-mm1/include/linux/interrupt.h
@@ -44,6 +44,9 @@
  * IRQF_TIMER - Flag to mark this interrupt as timer interrupt
  * IRQF_PERCPU - Interrupt is per cpu
  * IRQF_NOBALANCING - Flag to exclude this interrupt from irq balancing
+ * IRQF_IRQPOLL_IRQ - Interrupt is used for polling (only the interrupt that is
+ *                    registered first in an shared interrupt is considered for
+ *                    performance reasons)
  */
 #define IRQF_DISABLED		0x00000020
 #define IRQF_SAMPLE_RANDOM	0x00000040
@@ -52,6 +55,7 @@
 #define IRQF_TIMER		0x00000200
 #define IRQF_PERCPU		0x00000400
 #define IRQF_NOBALANCING	0x00000800
+#define IRQF_IRQPOLL_IRQ	0x00001000
 
 /*
  * Migration helpers. Scheduled for removal in 1/2007
Index: linux-2.6.21-rc4-mm1/kernel/irq/handle.c
===================================================================
--- linux-2.6.21-rc4-mm1.orig/kernel/irq/handle.c
+++ linux-2.6.21-rc4-mm1/kernel/irq/handle.c
@@ -180,6 +180,8 @@ fastcall unsigned int __do_IRQ(unsigned 
 		if (desc->chip->ack)
 			desc->chip->ack(irq);
 		action_ret = handle_IRQ_event(irq, desc->action);
+		if (!noirqdebug)
+			note_interrupt(irq, desc, action_ret);
 		desc->chip->end(irq);
 		return 1;
 	}
Index: linux-2.6.21-rc4-mm1/kernel/irq/spurious.c
===================================================================
--- linux-2.6.21-rc4-mm1.orig/kernel/irq/spurious.c
+++ linux-2.6.21-rc4-mm1/kernel/irq/spurious.c
@@ -146,7 +146,9 @@ void note_interrupt(unsigned int irq, st
 
 	if (unlikely(irqfixup)) {
 		/* Don't punish working computers */
-		if ((irqfixup == 2 && irq == 0) || action_ret == IRQ_NONE) {
+		if ((irqfixup == 2 && ((irq == 0) ||
+				(desc->action->flags & IRQF_IRQPOLL_IRQ))) ||
+				action_ret == IRQ_NONE) {
 			int ok = misrouted_irq(irq);
 			if (action_ret == IRQ_NONE)
 				desc->irqs_unhandled -= ok;

-- 
