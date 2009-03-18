Return-Path: <linux-kernel-owner+w=401wt.eu-S1757542AbZCRDHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542AbZCRDHT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 23:07:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756997AbZCRDGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 23:06:15 -0400
Received: from n10.bullet.mail.mud.yahoo.com ([209.191.125.208]:25002 "HELO
	n10.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755912AbZCRDGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 23:06:10 -0400
X-Yahoo-Newman-Id: 510193.73083.bm@omp411.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=17VHscnfPS+NdXCPwnYdsgbR0G93jODT9yxiQu91jKLoGk2QNQnNea05ZDBZ8ITQhUNRF/OtF0K8d1rcBk3GzXdM7xOf0hSGAf68F4vbDBU0ts66Pe82HFCYtqyJnPG++wfmzVfy4zabie+PzeLeZcxREKboPaAbv6R/MRlTDVk=  ;
X-YMail-OSG: p2gFf0oVM1mIyNOzR3LRtxqAnyk.uBUWqiS7G6W6P3KK.cyMUaC8ZR9FZ4kOsXnGpuwqDySBoYh05dg5MI7CWRB7ZnszSPH2s8iX1.SC2yE_BjSLMpqHsp7RT6ccba07dUfvtHe9KI2b3zyRkBWwwgGW13BhMmdnFwmg8CZDX2kI6fuUI5YBMOBYa1PddRTrSwdJCXn6kIddZzIKZtp90tb4OvvG80Bnlkeqlw--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
Subject: [patch/rfc 1/2] GENIRQ: add handle_threaded_irq() flow handler
Date: Tue, 17 Mar 2009 19:19:47 -0700
User-Agent: KMail/1.9.10
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, me@felipebalbi.com,
       dmitry.torokhov@gmail.com, sameo@openedhand.com
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com> <20090303004427.GA8638@elte.hu> <200903171914.53688.david-b@pacbell.net>
In-Reply-To: <200903171914.53688.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903171919.48030.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Define a new flow handler, handle_threaded_irq(), for IRQ threads
to use when chaining IRQs.

Unlike existing flow handlers, handle_simple_irq() and siblings,
this one is used only from sleep-capable contexts.  It always calls
irqaction handlers from that same (shared) sleep-capable context.

This is independent of Thomas' irq threading patchset, and can be
viewed as a complement to it.  This adds support for IRQs whose
handlers must *ONLY* ever run in thread contexts ... instead of
offloading code from hardirq context into a thread.  Another way
this differs is that it doesn't create more kernel threads; it
only leverages an existing thread.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 include/linux/irq.h |    7 ++++-
 kernel/irq/chip.c   |   61 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 66 insertions(+), 2 deletions(-)

--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -283,8 +283,8 @@ static inline int irq_balancing_disabled
 extern int handle_IRQ_event(unsigned int irq, struct irqaction *action);
 
 /*
- * Built-in IRQ handlers for various IRQ types,
- * callable via desc->chip->handle_irq()
+ * IRQ flow handlers for various IRQ types, callable via
+ * generic_handle_irq*() or desc->handle_irq()
  */
 extern void handle_level_irq(unsigned int irq, struct irq_desc *desc);
 extern void handle_fasteoi_irq(unsigned int irq, struct irq_desc *desc);
@@ -293,6 +293,9 @@ extern void handle_simple_irq(unsigned i
 extern void handle_percpu_irq(unsigned int irq, struct irq_desc *desc);
 extern void handle_bad_irq(unsigned int irq, struct irq_desc *desc);
 
+/* Flow handler that must only be called from sleeping context */
+extern void handle_threaded_irq(unsigned int irq, struct irq_desc *desc);
+
 /*
  * Monolithic do_IRQ implementation.
  */
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -295,6 +295,67 @@ static inline void mask_ack_irq(struct i
 }
 
 /**
+ *	handle_threaded_irq - flow handler reusing current irq thread
+ *	@irq:	the interrupt number
+ *	@desc:	the interrupt description structure for this irq
+ *	Context: irq thread, with IRQs enabled
+ *
+ *	IRQ threads which demultiplex IRQs may use this flow handler
+ *	to chain those demultiplexed IRQs to subsidiary handlers, when
+ *	all that IRQ dispatch logic must run in sleeping contexts.
+ *
+ *	Examples include some multifunction I2C and SPI based devices
+ *	(where access to registers, including ones involved in IRQ
+ *	dispatching, requires sleeping) that have multiple independent
+ *	maskable interupts.
+ *
+ *	The irq thread using this flow handler must handle any ack,
+ *	clear, mask or unmask issues needed.
+ */
+void
+handle_threaded_irq(unsigned int irq, struct irq_desc *desc)
+{
+	struct irqaction *action;
+	irqreturn_t action_ret;
+
+	spin_lock_irq(&desc->lock);
+
+	if (unlikely(desc->status & IRQ_INPROGRESS))
+		goto out_unlock;
+	desc->status &= ~(IRQ_REPLAY | IRQ_WAITING);
+	kstat_incr_irqs_this_cpu(irq, desc);
+
+	action = desc->action;
+	if (unlikely(!action || (desc->status & IRQ_DISABLED)))
+		goto out_unlock;
+
+	desc->status |= IRQ_INPROGRESS;
+	spin_unlock_irq(&desc->lock);
+
+	/* simplified handle_IRQ_event():  no random sampling;
+	 * IRQs are always enabled so action->handler may sleep;
+	 * no hooks for handing off to yet another irq thread.
+	 */
+	action_ret = IRQ_NONE;
+	do {
+		/* REVISIT can we get some explicit knowledge that this
+		 * handler expects to run in thread context?  Maybe an
+		 * IRQF_THREADED check, or a new handler type ...
+		 */
+		action_ret |= action->handler(irq, action->dev_id);
+		action = action->next;
+	} while (action);
+
+	if (!noirqdebug)
+		note_interrupt(irq, desc, action_ret);
+
+	spin_lock_irq(&desc->lock);
+	desc->status &= ~IRQ_INPROGRESS;
+out_unlock:
+	spin_unlock_irq(&desc->lock);
+}
+
+/**
  *	handle_simple_irq - Simple and software-decoded IRQs.
  *	@irq:	the interrupt number
  *	@desc:	the interrupt description structure for this irq

