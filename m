Return-Path: <linux-kernel-owner+w=401wt.eu-S1755975AbZIKTKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975AbZIKTKV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 15:10:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754411AbZIKTKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 15:10:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51490 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752779AbZIKTKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 15:10:18 -0400
Date: Fri, 11 Sep 2009 21:10:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] irq/threaded for v2.6.32
Message-ID: <20090911191008.GA15620@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest irq-threaded-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq-threaded-for-linus

 Thanks,

	Ingo

------------------>
Thomas Gleixner (4):
      genirq: Add oneshot support
      genirq: Add buslock support
      genirq: Support nested threaded irq handling
      genirq: Do not mask oneshot edge type interrupts


 include/linux/interrupt.h |    4 ++
 include/linux/irq.h       |   10 ++++
 kernel/irq/chip.c         |   74 ++++++++++++++++++++++++++++++++-
 kernel/irq/internals.h    |   13 ++++++
 kernel/irq/manage.c       |  102 +++++++++++++++++++++++++++++++++++++++++----
 5 files changed, 194 insertions(+), 9 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 35e7df1..1ac57e5 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -50,6 +50,9 @@
  * IRQF_IRQPOLL - Interrupt is used for polling (only the interrupt that is
  *                registered first in an shared interrupt is considered for
  *                performance reasons)
+ * IRQF_ONESHOT - Interrupt is not reenabled after the hardirq handler finished.
+ *                Used by threaded interrupts which need to keep the
+ *                irq line disabled until the threaded handler has been run.
  */
 #define IRQF_DISABLED		0x00000020
 #define IRQF_SAMPLE_RANDOM	0x00000040
@@ -59,6 +62,7 @@
 #define IRQF_PERCPU		0x00000400
 #define IRQF_NOBALANCING	0x00000800
 #define IRQF_IRQPOLL		0x00001000
+#define IRQF_ONESHOT		0x00002000
 
 /*
  * Bits used by threaded handlers:
diff --git a/include/linux/irq.h b/include/linux/irq.h
index cb2e77a..8778ee9 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -69,6 +69,8 @@ typedef	void (*irq_flow_handler_t)(unsigned int irq,
 #define IRQ_MOVE_PCNTXT		0x01000000	/* IRQ migration from process context */
 #define IRQ_AFFINITY_SET	0x02000000	/* IRQ affinity was set from userspace*/
 #define IRQ_SUSPENDED		0x04000000	/* IRQ has gone through suspend sequence */
+#define IRQ_ONESHOT		0x08000000	/* IRQ is not unmasked after hardirq */
+#define IRQ_NESTED_THREAD	0x10000000	/* IRQ is nested into another, no own handler thread */
 
 #ifdef CONFIG_IRQ_PER_CPU
 # define CHECK_IRQ_PER_CPU(var) ((var) & IRQ_PER_CPU)
@@ -100,6 +102,9 @@ struct msi_desc;
  * @set_type:		set the flow type (IRQ_TYPE_LEVEL/etc.) of an IRQ
  * @set_wake:		enable/disable power-management wake-on of an IRQ
  *
+ * @bus_lock:		function to lock access to slow bus (i2c) chips
+ * @bus_sync_unlock:	function to sync and unlock slow bus (i2c) chips
+ *
  * @release:		release function solely used by UML
  * @typename:		obsoleted by name, kept as migration helper
  */
@@ -123,6 +128,9 @@ struct irq_chip {
 	int		(*set_type)(unsigned int irq, unsigned int flow_type);
 	int		(*set_wake)(unsigned int irq, unsigned int on);
 
+	void		(*bus_lock)(unsigned int irq);
+	void		(*bus_sync_unlock)(unsigned int irq);
+
 	/* Currently used only by UML, might disappear one day.*/
 #ifdef CONFIG_IRQ_RELEASE_METHOD
 	void		(*release)(unsigned int irq, void *dev_id);
@@ -379,6 +387,8 @@ set_irq_chained_handler(unsigned int irq,
 	__set_irq_handler(irq, handle, 1, NULL);
 }
 
+extern void set_irq_nested_thread(unsigned int irq, int nest);
+
 extern void set_irq_noprobe(unsigned int irq);
 extern void set_irq_probe(unsigned int irq);
 
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 13c68e7..c166019 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -222,6 +222,34 @@ int set_irq_chip_data(unsigned int irq, void *data)
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
@@ -299,6 +327,45 @@ static inline void mask_ack_irq(struct irq_desc *desc, int irq)
 	}
 }
 
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
 /**
  *	handle_simple_irq - Simple and software-decoded IRQs.
  *	@irq:	the interrupt number
@@ -382,7 +449,10 @@ handle_level_irq(unsigned int irq, struct irq_desc *desc)
 
 	spin_lock(&desc->lock);
 	desc->status &= ~IRQ_INPROGRESS;
-	if (!(desc->status & IRQ_DISABLED) && desc->chip->unmask)
+
+	if (unlikely(desc->status & IRQ_ONESHOT))
+		desc->status |= IRQ_MASKED;
+	else if (!(desc->status & IRQ_DISABLED) && desc->chip->unmask)
 		desc->chip->unmask(irq);
 out_unlock:
 	spin_unlock(&desc->lock);
@@ -572,6 +642,7 @@ __set_irq_handler(unsigned int irq, irq_flow_handler_t handle, int is_chained,
 		desc->chip = &dummy_irq_chip;
 	}
 
+	chip_bus_lock(irq, desc);
 	spin_lock_irqsave(&desc->lock, flags);
 
 	/* Uninstall? */
@@ -591,6 +662,7 @@ __set_irq_handler(unsigned int irq, irq_flow_handler_t handle, int is_chained,
 		desc->chip->startup(irq);
 	}
 	spin_unlock_irqrestore(&desc->lock, flags);
+	chip_bus_sync_unlock(irq, desc);
 }
 EXPORT_SYMBOL_GPL(__set_irq_handler);
 
diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index e70ed55..1b5d742 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -44,6 +44,19 @@ extern int irq_select_affinity_usr(unsigned int irq);
 
 extern void irq_set_thread_affinity(struct irq_desc *desc);
 
+/* Inline functions for support of irq chips on slow busses */
+static inline void chip_bus_lock(unsigned int irq, struct irq_desc *desc)
+{
+	if (unlikely(desc->chip->bus_lock))
+		desc->chip->bus_lock(irq);
+}
+
+static inline void chip_bus_sync_unlock(unsigned int irq, struct irq_desc *desc)
+{
+	if (unlikely(desc->chip->bus_sync_unlock))
+		desc->chip->bus_sync_unlock(irq);
+}
+
 /*
  * Debugging printout:
  */
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index d222515..e485cea 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -230,9 +230,11 @@ void disable_irq_nosync(unsigned int irq)
 	if (!desc)
 		return;
 
+	chip_bus_lock(irq, desc);
 	spin_lock_irqsave(&desc->lock, flags);
 	__disable_irq(desc, irq, false);
 	spin_unlock_irqrestore(&desc->lock, flags);
+	chip_bus_sync_unlock(irq, desc);
 }
 EXPORT_SYMBOL(disable_irq_nosync);
 
@@ -294,7 +296,8 @@ void __enable_irq(struct irq_desc *desc, unsigned int irq, bool resume)
  *	matches the last disable, processing of interrupts on this
  *	IRQ line is re-enabled.
  *
- *	This function may be called from IRQ context.
+ *	This function may be called from IRQ context only when
+ *	desc->chip->bus_lock and desc->chip->bus_sync_unlock are NULL !
  */
 void enable_irq(unsigned int irq)
 {
@@ -304,9 +307,11 @@ void enable_irq(unsigned int irq)
 	if (!desc)
 		return;
 
+	chip_bus_lock(irq, desc);
 	spin_lock_irqsave(&desc->lock, flags);
 	__enable_irq(desc, irq, false);
 	spin_unlock_irqrestore(&desc->lock, flags);
+	chip_bus_sync_unlock(irq, desc);
 }
 EXPORT_SYMBOL(enable_irq);
 
@@ -436,6 +441,26 @@ int __irq_set_trigger(struct irq_desc *desc, unsigned int irq,
 	return ret;
 }
 
+/*
+ * Default primary interrupt handler for threaded interrupts. Is
+ * assigned as primary handler when request_threaded_irq is called
+ * with handler == NULL. Useful for oneshot interrupts.
+ */
+static irqreturn_t irq_default_primary_handler(int irq, void *dev_id)
+{
+	return IRQ_WAKE_THREAD;
+}
+
+/*
+ * Primary handler for nested threaded interrupts. Should never be
+ * called.
+ */
+static irqreturn_t irq_nested_primary_handler(int irq, void *dev_id)
+{
+	WARN(1, "Primary handler called for nested irq %d\n", irq);
+	return IRQ_NONE;
+}
+
 static int irq_wait_for_interrupt(struct irqaction *action)
 {
 	while (!kthread_should_stop()) {
@@ -451,6 +476,23 @@ static int irq_wait_for_interrupt(struct irqaction *action)
 	return -1;
 }
 
+/*
+ * Oneshot interrupts keep the irq line masked until the threaded
+ * handler finished. unmask if the interrupt has not been disabled and
+ * is marked MASKED.
+ */
+static void irq_finalize_oneshot(unsigned int irq, struct irq_desc *desc)
+{
+	chip_bus_lock(irq, desc);
+	spin_lock_irq(&desc->lock);
+	if (!(desc->status & IRQ_DISABLED) && (desc->status & IRQ_MASKED)) {
+		desc->status &= ~IRQ_MASKED;
+		desc->chip->unmask(irq);
+	}
+	spin_unlock_irq(&desc->lock);
+	chip_bus_sync_unlock(irq, desc);
+}
+
 #ifdef CONFIG_SMP
 /*
  * Check whether we need to change the affinity of the interrupt thread.
@@ -492,7 +534,7 @@ static int irq_thread(void *data)
 	struct sched_param param = { .sched_priority = MAX_USER_RT_PRIO/2, };
 	struct irqaction *action = data;
 	struct irq_desc *desc = irq_to_desc(action->irq);
-	int wake;
+	int wake, oneshot = desc->status & IRQ_ONESHOT;
 
 	sched_setscheduler(current, SCHED_FIFO, &param);
 	current->irqaction = action;
@@ -518,6 +560,9 @@ static int irq_thread(void *data)
 			spin_unlock_irq(&desc->lock);
 
 			action->thread_fn(action->irq, action->dev_id);
+
+			if (oneshot)
+				irq_finalize_oneshot(action->irq, desc);
 		}
 
 		wake = atomic_dec_and_test(&desc->threads_active);
@@ -565,7 +610,7 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 	struct irqaction *old, **old_ptr;
 	const char *old_name = NULL;
 	unsigned long flags;
-	int shared = 0;
+	int nested, shared = 0;
 	int ret;
 
 	if (!desc)
@@ -590,10 +635,32 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 		rand_initialize_irq(irq);
 	}
 
+	/* Oneshot interrupts are not allowed with shared */
+	if ((new->flags & IRQF_ONESHOT) && (new->flags & IRQF_SHARED))
+		return -EINVAL;
+
+	/*
+	 * Check whether the interrupt nests into another interrupt
+	 * thread.
+	 */
+	nested = desc->status & IRQ_NESTED_THREAD;
+	if (nested) {
+		if (!new->thread_fn)
+			return -EINVAL;
+		/*
+		 * Replace the primary handler which was provided from
+		 * the driver for non nested interrupt handling by the
+		 * dummy function which warns when called.
+		 */
+		new->handler = irq_nested_primary_handler;
+	}
+
 	/*
-	 * Threaded handler ?
+	 * Create a handler thread when a thread function is supplied
+	 * and the interrupt does not nest into another interrupt
+	 * thread.
 	 */
-	if (new->thread_fn) {
+	if (new->thread_fn && !nested) {
 		struct task_struct *t;
 
 		t = kthread_create(irq_thread, new, "irq/%d-%s", irq,
@@ -663,9 +730,12 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 			desc->status |= IRQ_PER_CPU;
 #endif
 
-		desc->status &= ~(IRQ_AUTODETECT | IRQ_WAITING |
+		desc->status &= ~(IRQ_AUTODETECT | IRQ_WAITING | IRQ_ONESHOT |
 				  IRQ_INPROGRESS | IRQ_SPURIOUS_DISABLED);
 
+		if (new->flags & IRQF_ONESHOT)
+			desc->status |= IRQ_ONESHOT;
+
 		if (!(desc->status & IRQ_NOAUTOEN)) {
 			desc->depth = 0;
 			desc->status &= ~IRQ_DISABLED;
@@ -869,7 +939,14 @@ EXPORT_SYMBOL_GPL(remove_irq);
  */
 void free_irq(unsigned int irq, void *dev_id)
 {
+	struct irq_desc *desc = irq_to_desc(irq);
+
+	if (!desc)
+		return;
+
+	chip_bus_lock(irq, desc);
 	kfree(__free_irq(irq, dev_id));
+	chip_bus_sync_unlock(irq, desc);
 }
 EXPORT_SYMBOL(free_irq);
 
@@ -878,6 +955,8 @@ EXPORT_SYMBOL(free_irq);
  *	@irq: Interrupt line to allocate
  *	@handler: Function to be called when the IRQ occurs.
  *		  Primary handler for threaded interrupts
+ *		  If NULL and thread_fn != NULL the default
+ *		  primary handler is installed
  *	@thread_fn: Function called from the irq handler thread
  *		    If NULL, no irq thread is created
  *	@irqflags: Interrupt type flags
@@ -957,8 +1036,12 @@ int request_threaded_irq(unsigned int irq, irq_handler_t handler,
 
 	if (desc->status & IRQ_NOREQUEST)
 		return -EINVAL;
-	if (!handler)
-		return -EINVAL;
+
+	if (!handler) {
+		if (!thread_fn)
+			return -EINVAL;
+		handler = irq_default_primary_handler;
+	}
 
 	action = kzalloc(sizeof(struct irqaction), GFP_KERNEL);
 	if (!action)
@@ -970,7 +1053,10 @@ int request_threaded_irq(unsigned int irq, irq_handler_t handler,
 	action->name = devname;
 	action->dev_id = dev_id;
 
+	chip_bus_lock(irq, desc);
 	retval = __setup_irq(irq, desc, action);
+	chip_bus_sync_unlock(irq, desc);
+
 	if (retval)
 		kfree(action);
 
