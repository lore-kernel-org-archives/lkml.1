Return-Path: <linux-kernel-owner+w=401wt.eu-S1760685AbZCWVBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760685AbZCWVBw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 17:01:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754122AbZCWVBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 17:01:43 -0400
Received: from www.tglx.de ([62.245.132.106]:55443 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753698AbZCWVBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 17:01:42 -0400
Date: Mon, 23 Mar 2009 21:59:37 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Christoph Hellwig <hch@infradead.org>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>,
       Jon Masters <jonathan@jonmasters.org>,
       Sven Dietrich <sdietrich@suse.de>, David Brownell <david-b@pacbell.net>
Subject: genirq: add threaded interrupt handler support - review fixups
In-Reply-To: <alpine.LFD.2.00.0903232005380.29264@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0903232156140.29264@localhost.localdomain>
References: <20090323172814.548471871@linutronix.de> <20090323172835.250505802@linutronix.de> <20090323185618.GA11432@infradead.org> <alpine.LFD.2.00.0903232005380.29264@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delta patch to address the review comments.

      - Implement warning when IRQ_WAKE_THREAD is requested and no
        thread handler installed
      - coding style fixes

Pointed-out-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <20090323185618.GA11432@infradead.org>

Index: linux-2.6-tip/include/linux/interrupt.h
===================================================================
--- linux-2.6-tip.orig/include/linux/interrupt.h
+++ linux-2.6-tip/include/linux/interrupt.h
@@ -63,10 +63,12 @@
  * Bits used by threaded handlers:
  * IRQTF_RUNTHREAD - signals that the interrupt handler thread should run
  * IRQTF_DIED      - handler thread died
+ * IRQTF_WARNED    - warning "IRQ_WAKE_THREAD w/o thread_fn" has been printed
  */
 enum {
 	IRQTF_RUNTHREAD,
 	IRQTF_DIED,
+	IRQTF_WARNED,
 };
 
 typedef irqreturn_t (*irq_handler_t)(int, void *);
Index: linux-2.6-tip/kernel/irq/handle.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/handle.c
+++ linux-2.6-tip/kernel/irq/handle.c
@@ -338,6 +338,15 @@ irqreturn_t no_action(int cpl, void *dev
 	return IRQ_NONE;
 }
 
+static void warn_no_thread(unsigned int irq, struct irqaction *action)
+{
+	if (test_and_set_bit(IRQTF_WARNED, &action->thread_flags))
+		return;
+
+	printk(KERN_WARNING "IRQ %d device %s returned IRQ_WAKE_THREAD "
+	       "but no thread function available.", irq, action->name);
+}
+
 /**
  * handle_IRQ_event - irq action chain handler
  * @irq:	the interrupt number
@@ -361,6 +370,21 @@ irqreturn_t handle_IRQ_event(unsigned in
 		switch (ret) {
 		case IRQ_WAKE_THREAD:
 			/*
+			 * Set result to handled so the spurious check
+			 * does not trigger.
+			 */
+			ret = IRQ_HANDLED;
+
+			/*
+			 * Catch drivers which return WAKE_THREAD but
+			 * did not set up a thread function
+			 */
+			if (unlikely(!action->thread_fn)) {
+				warn_no_thread(irq, action);
+				break;
+			}
+
+			/*
 			 * Wake up the handler thread for this
 			 * action. In case the thread crashed and was
 			 * killed we just pretend that we handled the
@@ -374,11 +398,6 @@ irqreturn_t handle_IRQ_event(unsigned in
 				wake_up_process(action->thread);
 			}
 
-			/*
-			 * Set it to handled so the spurious check
-			 * does not trigger.
-			 */
-			ret = IRQ_HANDLED;
 			/* Fall through to add to randomness */
 		case IRQ_HANDLED:
 			status |= action->flags;
Index: linux-2.6-tip/kernel/irq/manage.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/manage.c
+++ linux-2.6-tip/kernel/irq/manage.c
@@ -407,20 +407,17 @@ int __irq_set_trigger(struct irq_desc *d
 	return ret;
 }
 
-static inline int irq_thread_should_run(struct irqaction *action)
-{
-	return test_and_clear_bit(IRQTF_RUNTHREAD, &action->thread_flags);
-}
-
 static int irq_wait_for_interrupt(struct irqaction *action)
 {
 	while (!kthread_should_stop()) {
 		set_current_state(TASK_INTERRUPTIBLE);
-		if (irq_thread_should_run(action)) {
+
+		if (test_and_clear_bit(IRQTF_RUNTHREAD,
+				       &action->thread_flags)) {
 			__set_current_state(TASK_RUNNING);
 			return 0;
-		} else
-			schedule();
+		}
+		schedule();
 	}
 	return -1;
 }
@@ -820,8 +817,8 @@ EXPORT_SYMBOL(free_irq);
  *	@irq: Interrupt line to allocate
  *	@handler: Function to be called when the IRQ occurs.
  *		  Primary handler for threaded interrupts
- *      @thread_fn: Function called from the irq handler thread
- *                  If NULL, no irq thread is created
+ *	@thread_fn: Function called from the irq handler thread
+ *		    If NULL, no irq thread is created
  *	@irqflags: Interrupt type flags
  *	@devname: An ascii name for the claiming device
  *	@dev_id: A cookie passed back to the handler function
