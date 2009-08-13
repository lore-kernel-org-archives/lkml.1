Return-Path: <linux-kernel-owner+w=401wt.eu-S1755560AbZHMTls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560AbZHMTls (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 15:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755538AbZHMTls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 15:41:48 -0400
Received: from www.tglx.de ([62.245.132.106]:56325 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755548AbZHMTlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:41:45 -0400
Message-Id: <20090813193116.567414720@linutronix.de>
User-Agent: quilt/0.47-1
Date: Thu, 13 Aug 2009 19:40:53 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Trilok Soni <soni.trilok@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Brian Swetland <swetland@google.com>,
       Joonyoung Shim <jy0922.shim@samsung.com>, m.szyprowski@samsung.com,
       t.fujak@samsung.com, kyungmin.park@samsung.com,
       David Brownell <david-b@pacbell.net>, Daniel Ribeiro <drwyrm@gmail.com>,
       arve@android.com, Barry Song <21cnbao@gmail.com>
Subject: [RFC patch 3/3] genirq: Support nested threaded irq handling
References: <20090813191535.945521006@linutronix.de>
Content-Disposition: inline;
	filename=genirq-support-nested-threaded-irq-handling.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Interrupt chips which are behind a slow bus (i2c, spi ...) and
demultiplex other interrupt sources need to run their interrupt
handler in a thread. 

The demultiplexed interrupt handlers need to run in thread context as
well and need to finish before the demux handler thread can reenable
the interrupt line. So instead of creating separate threads which need
to synchronize with the demux handler thread we provide a function
which calls the interrupt thread function of the sub device in the
context of the demux handler thread.

To avoid that a separate thread is created for the subdevices the
function request_nested_slowbus_irq() is provided which sets a dummy
handler for the primary handler which should never be called. A flag
prevents the creation of the separate handler thread in __setup_irq().

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 include/linux/interrupt.h |    9 +++++++++
 kernel/irq/chip.c         |   44 ++++++++++++++++++++++++++++++++++++++++++++
 kernel/irq/internals.h    |    2 ++
 kernel/irq/manage.c       |   28 +++++++++++++++++++++++++++-
 4 files changed, 82 insertions(+), 1 deletion(-)

Index: linux-2.6-tip/include/linux/interrupt.h
===================================================================
--- linux-2.6-tip.orig/include/linux/interrupt.h
+++ linux-2.6-tip/include/linux/interrupt.h
@@ -52,6 +52,9 @@
  * IRQF_ONESHOT - Interrupt is not reenabled after the hardirq handler finished.
  *                Used by threaded interrupts which need to keep the
  *                irq line disabled until the threaded handler has been run.
+ * IRQF_NESTED -  Interrupt is nested into another threaded interrupt. Handler
+ *		  is called in the parent interrupt thread context
+ *
  */
 #define IRQF_DISABLED		0x00000020
 #define IRQF_SAMPLE_RANDOM	0x00000040
@@ -62,6 +65,7 @@
 #define IRQF_NOBALANCING	0x00000800
 #define IRQF_IRQPOLL		0x00001000
 #define IRQF_ONESHOT		0x00002000
+#define IRQF_NESTED		0x00004000
 
 /*
  * Bits used by threaded handlers:
@@ -125,6 +129,11 @@ request_irq(unsigned int irq, irq_handle
 	return request_threaded_irq(irq, handler, NULL, flags, name, dev);
 }
 
+extern int __must_check
+request_nested_slowbus_irq(unsigned int irq, irq_handler_t thread_fn,
+			   unsigned long irqflags, const char *devname,
+			   void *dev_id);
+
 extern void exit_irq_thread(void);
 #else
 
Index: linux-2.6-tip/kernel/irq/chip.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/chip.c
+++ linux-2.6-tip/kernel/irq/chip.c
@@ -300,6 +300,50 @@ static inline void mask_ack_irq(struct i
 }
 
 /**
+ *	handle_nested_irq - Handle a nested irq from a irq thread
+ *	@irq:	the interrupt number
+ *
+ *	Handle interrupts which are nested into a threaded interrupt
+ *	handler. The handler function is called inside the calling
+ *	threads context.
+ */
+void handle_nested_irq(unsigned int irq)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+	struct irqaction *action;
+	irqreturn_t action_ret;
+
+	might_sleep();
+
+	spin_lock_irq(&desc->lock);
+
+	kstat_incr_irqs_this_cpu(irq, desc);
+
+	action = desc->action;
+	if (unlikely(!action || (desc->status & IRQ_DISABLED)))
+		goto out_unlock;
+
+	desc->status |= IRQ_INPROGRESS;
+	spin_unlock_irq(&desc->lock);
+
+	action_ret = action->thread_fn(action->irq, action->dev_id);
+	if (!noirqdebug)
+		note_interrupt(irq, desc, action_ret);
+
+	spin_lock_irq(&desc->lock);
+	desc->status &= ~IRQ_INPROGRESS;
+
+out_unlock:
+	spin_unlock_irq(&desc->lock);
+}
+
+irqreturn_t handle_nested_irq_primary(int irq, void *dev_id)
+{
+	WARN(1, "Primary handler called for nested irq %d\n", irq);
+	return IRQ_NONE;
+}
+
+/**
  *	handle_simple_irq - Simple and software-decoded IRQs.
  *	@irq:	the interrupt number
  *	@desc:	the interrupt description structure for this irq
Index: linux-2.6-tip/kernel/irq/internals.h
===================================================================
--- linux-2.6-tip.orig/kernel/irq/internals.h
+++ linux-2.6-tip/kernel/irq/internals.h
@@ -45,6 +45,8 @@ extern int irq_select_affinity_usr(unsig
 extern void
 irq_set_thread_affinity(struct irq_desc *desc, const struct cpumask *cpumask);
 
+extern irqreturn_t handle_nested_irq_primary(int irq, void *dev_id);
+
 /*
  * Debugging printout:
  */
Index: linux-2.6-tip/kernel/irq/manage.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/manage.c
+++ linux-2.6-tip/kernel/irq/manage.c
@@ -625,7 +625,7 @@ __setup_irq(unsigned int irq, struct irq
 	/*
 	 * Threaded handler ?
 	 */
-	if (new->thread_fn) {
+	if (new->thread_fn && !(new->flags & IRQF_NESTED)) {
 		struct task_struct *t;
 
 		t = kthread_create(irq_thread, new, "irq/%d-%s", irq,
@@ -1095,3 +1095,29 @@ int request_slowbus_threaded_irq(unsigne
 	return res;
 }
 EXPORT_SYMBOL(request_slowbus_threaded_irq);
+
+/**
+ *	request_nested_slowbus_irq - allocate an interrupt line for a nested irq
+ *	@irq: Interrupt line to allocate
+ *	@thread_fn: Function called from the irq handler thread
+ *	@irqflags: Interrupt type flags
+ *	@devname: An ascii name for the claiming device
+ *	@dev_id: A cookie passed back to the handler function
+ *
+ *	This function is used for interrupts which nest into another
+ *	threaded interrupt handler, e.g. subdevice interrupts of an
+ *	interrupt controller which is connected via i2c/spi or other
+ *	slow path mechanisms. The thread_fn is called from the
+ *	demultiplexing interrupt thread via handle_nested_irq().
+ */
+int request_nested_slowbus_irq(unsigned int irq, irq_handler_t thread_fn,
+			       unsigned long irqflags, const char *devname,
+			       void *dev_id)
+{
+	irqflags |= IRQF_NESTED;
+
+	return request_threaded_slowbus_irq(irq, handle_nested_irq_primary,
+					    thread_fn, irqflags, devname,
+					    dev_id);
+}
+EXPORT_SYMBOL(request_nested_slowbus_irq);


