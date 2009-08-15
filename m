Return-Path: <linux-kernel-owner+w=401wt.eu-S1751716AbZHORtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716AbZHORtY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 13:49:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751629AbZHORtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 13:49:23 -0400
Received: from www.tglx.de ([62.245.132.106]:49840 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318AbZHORtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 13:49:20 -0400
Message-Id: <20090815174537.983573932@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sat, 15 Aug 2009 17:48:43 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
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
References: <20090815174512.491425246@linutronix.de>
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
the interrupt line. So the easiest way is to run the sub device
handlers in the context of the demultiplexing handler thread.

To avoid that a separate thread is created for the subdevices the
function set_nested_irq_thread() is provided which sets the
IRQ_NESTED_THREAD flag in the interrupt descriptor.

A driver which calls request_threaded_irq() must not be aware of the
fact that the threaded handler is called in the context of the
demultiplexing handler thread. The setup code checks the
IRQ_NESTED_THREAD flag which was set from the irq chip setup code and
does not setup a separate thread for the interrupt. The primary
function which is provided by the device driver is replaced by an
internal dummy function which warns when it is called.

For the demultiplexing handler a helper function handle_nested_irq()
is provided which calls the demux interrupt thread function in the
context of the caller and does the proper interrupt accounting and
takes the interrupt disabled status of the demultiplexed subdevice
into account.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Trilok Soni <soni.trilok@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Brian Swetland <swetland@google.com>
Cc: Joonyoung Shim <jy0922.shim@samsung.com>
Cc: m.szyprowski@samsung.com
Cc: t.fujak@samsung.com
Cc: kyungmin.park@samsung.com,
Cc: David Brownell <david-b@pacbell.net>
Cc: Daniel Ribeiro <drwyrm@gmail.com>
Cc: arve@android.com
Cc: Barry Song <21cnbao@gmail.com>

---
 include/linux/irq.h    |    3 ++
 kernel/irq/chip.c      |   73 +++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/irq/internals.h |    2 +
 kernel/irq/manage.c    |   24 ++++++++++++++--
 4 files changed, 99 insertions(+), 3 deletions(-)

Index: linux-2.6-tip/include/linux/irq.h
===================================================================
--- linux-2.6-tip.orig/include/linux/irq.h
+++ linux-2.6-tip/include/linux/irq.h
@@ -70,6 +70,7 @@ typedef	void (*irq_flow_handler_t)(unsig
 #define IRQ_AFFINITY_SET	0x02000000	/* IRQ affinity was set from userspace*/
 #define IRQ_SUSPENDED		0x04000000	/* IRQ has gone through suspend sequence */
 #define IRQ_ONESHOT		0x08000000	/* IRQ is not unmasked after hardirq */
+#define IRQ_NESTED_THREAD	0x10000000	/* IRQ is nested into another, no own handler thread */
 
 #ifdef CONFIG_IRQ_PER_CPU
 # define CHECK_IRQ_PER_CPU(var) ((var) & IRQ_PER_CPU)
@@ -379,6 +380,8 @@ set_irq_chained_handler(unsigned int irq
 	__set_irq_handler(irq, handle, 1, NULL);
 }
 
+extern void set_irq_nested_thread(unsigned int irq, int nest);
+
 extern void set_irq_noprobe(unsigned int irq);
 extern void set_irq_probe(unsigned int irq);
 
Index: linux-2.6-tip/kernel/irq/chip.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/chip.c
+++ linux-2.6-tip/kernel/irq/chip.c
@@ -222,6 +222,34 @@ int set_irq_chip_data(unsigned int irq, 
 }
 EXPORT_SYMBOL(set_irq_chip_data);
 
+/**
+ *	set_irq_nested_thread - Set/Reset the IRQ_NESTED_THREAD flag of an irq
+ *
+ *	@irq:	Interrupt number
+ *	@nest:	0 to clear / 1 to set the IRQ_NESTED_THREAD flag
+ *
+ *	The IRQ_NESTED_THREAD flag indicates that on
+ *	request_threaded_irq() no separate interrupt thread should be
+ *	created for the irq as the handler are called nested in the
+ *	context of a demultiplexing interrupt handler thread.
+ */
+void set_irq_nested_thread(unsigned int irq, int nest)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+	unsigned long flags;
+
+	if (!desc)
+		return;
+
+	spin_lock_irqsave(&desc->lock, flags);
+	if (nest)
+		desc->status |= IRQ_NESTED_THREAD;
+	else
+		desc->status &= ~IRQ_NESTED_THREAD;
+	spin_unlock_irqrestore(&desc->lock, flags);
+}
+EXPORT_SYMBOL_GPL(set_irq_nested_thread);
+
 /*
  * default enable function
  */
@@ -316,6 +344,51 @@ irqreturn_t irq_oneshot_primary_handler(
 }
 EXPORT_SYMBOL_GPL(irq_oneshot_primary_handler);
 
+/*
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
+EXPORT_SYMBOL_GPL(handle_nested_irq);
+
+irqreturn_t handle_nested_irq_primary(int irq, void *dev_id)
+{
+	WARN(1, "Primary handler called for nested irq %d\n", irq);
+	return IRQ_NONE;
+}
+
 /**
  *	handle_simple_irq - Simple and software-decoded IRQs.
  *	@irq:	the interrupt number
Index: linux-2.6-tip/kernel/irq/internals.h
===================================================================
--- linux-2.6-tip.orig/kernel/irq/internals.h
+++ linux-2.6-tip/kernel/irq/internals.h
@@ -58,6 +58,8 @@ static inline void chip_bus_sync_unlock(
 		desc->chip->bus_sync_unlock(irq);
 }
 
+extern irqreturn_t handle_nested_irq_primary(int irq, void *dev_id);
+
 /*
  * Debugging printout:
  */
Index: linux-2.6-tip/kernel/irq/manage.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/manage.c
+++ linux-2.6-tip/kernel/irq/manage.c
@@ -547,7 +547,7 @@ __setup_irq(unsigned int irq, struct irq
 	struct irqaction *old, **old_ptr;
 	const char *old_name = NULL;
 	unsigned long flags;
-	int shared = 0;
+	int nested, shared = 0;
 	int ret;
 
 	if (!desc)
@@ -577,9 +577,27 @@ __setup_irq(unsigned int irq, struct irq
 		return -EINVAL;
 
 	/*
-	 * Threaded handler ?
+	 * Check whether the interrupt nests into another interrupt
+	 * thread.
 	 */
-	if (new->thread_fn) {
+	nested = desc->status & IRQ_NESTED_THREAD;
+	if (nested) {
+		if (!new->thread_fn)
+			return -EINVAL;
+		/*
+		 * Replace the primary handler which was provided from
+		 * the driver for non nested interrupt handling by the
+		 * dummy function which warns when called.
+		 */
+		new->handler = handle_nested_irq_primary;
+	}
+
+	/*
+	 * Create a handler thread when a thread function is supplied
+	 * and the interrupt does not nest into another interrupt
+	 * thread.
+	 */
+	if (new->thread_fn && !nested) {
 		struct task_struct *t;
 
 		t = kthread_create(irq_thread, new, "irq/%d-%s", irq,


