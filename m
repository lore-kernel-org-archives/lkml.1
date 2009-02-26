Return-Path: <linux-kernel-owner+w=401wt.eu-S1756581AbZBZNaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581AbZBZNaR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 08:30:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754602AbZBZN2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 08:28:54 -0500
Received: from www.tglx.de ([62.245.132.106]:46810 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754125AbZBZN2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 08:28:52 -0500
Message-Id: <20090226131719.760899560@linutronix.de>
User-Agent: quilt/0.47-1
Date: Thu, 26 Feb 2009 13:28:23 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jon Masters <jonathan@jonmasters.org>
Subject: [patch 4/4] genirq: add support for threaded interrupt handlers
References: <20090226131336.423054348@linutronix.de>
Content-Disposition: inline; filename=genirq-threaded-irq-handler-support.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add suppport for threaded interrupt handlers. This is a more strict
separation of the primary interrupt handler, which runs in hard
interrupt context, and the real interrupt handler, which handles the
real device functionality, than the existing hardirq/softirq
separation.

The primary hard interrupt context handler solely checks whether the
interrupt originates from the device or not. In case the interrupt is
asserted by the device the handler disables the interrupt on the
device level. This must be the only functionality of the primary
handler and this restriction has to be carefully monitored to avoid
unresolvable locking scenarios with a fully preemptible kernel.

The threaded handler allows to integrate hardware related
functionality and softirq/tasklet functions in the handler
thread.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Peter Zijlstra <peterz@infradead.org>

---
 include/linux/interrupt.h |   33 +++++++++++
 include/linux/irqreturn.h |    2 
 include/linux/sched.h     |    3 +
 kernel/exit.c             |    2 
 kernel/irq/handle.c       |   43 ++++++++++++--
 kernel/irq/manage.c       |  136 +++++++++++++++++++++++++++++++++++++++++++---
 6 files changed, 208 insertions(+), 11 deletions(-)

Index: linux-2.6-tip/include/linux/interrupt.h
===================================================================
--- linux-2.6-tip.orig/include/linux/interrupt.h
+++ linux-2.6-tip/include/linux/interrupt.h
@@ -49,6 +49,7 @@
  * IRQF_IRQPOLL - Interrupt is used for polling (only the interrupt that is
  *                registered first in an shared interrupt is considered for
  *                performance reasons)
+ * IRQF_THREADED - request threaded interrupt handler
  */
 #define IRQF_DISABLED		0x00000020
 #define IRQF_SAMPLE_RANDOM	0x00000040
@@ -58,6 +59,20 @@
 #define IRQF_PERCPU		0x00000400
 #define IRQF_NOBALANCING	0x00000800
 #define IRQF_IRQPOLL		0x00001000
+#define IRQF_THREADED		0x00002000
+
+/*
+ * Bits used by threaded handlers:
+ * IRQTF_RUNTHREAD - signals that the interrupt handler thread should run
+ * IRQTF_WARNED    - warning rate limit when a threaded handler is
+ *		     requested to run in hard interrupt context
+ * IRQTF_DIED      - handler thread died
+ */
+enum {
+	IRQTF_RUNTHREAD,
+	IRQTF_WARNED,
+	IRQTF_DIED,
+};
 
 typedef irqreturn_t (*irq_handler_t)(int, void *);
 
@@ -71,6 +86,8 @@ struct irqaction {
 	struct irqaction *next;
 	int irq;
 	struct proc_dir_entry *dir;
+	struct task_struct *thread;
+	unsigned long thread_flags;
 };
 
 extern irqreturn_t no_action(int cpl, void *dev_id);
@@ -87,6 +104,15 @@ request_irq(unsigned int irq, irq_handle
 	return request_irq_quickcheck(irq, handler, NULL, flags, name, dev);
 }
 
+static inline int __must_check
+request_threaded_irq(unsigned int irq, irq_handler_t handler,
+		     irq_handler_t quick_check_handler,
+		     unsigned long flags, const char *name, void *dev)
+{
+	return request_irq_quickcheck(irq, handler, quick_check_handler,
+				    flags | IRQF_THREADED, name, dev);
+}
+
 extern void free_irq(unsigned int, void *);
 
 struct device;
@@ -96,6 +122,13 @@ extern int __must_check devm_request_irq
 			    const char *devname, void *dev_id);
 extern void devm_free_irq(struct device *dev, unsigned int irq, void *dev_id);
 
+static inline int irq_thread_should_run(struct irqaction *action)
+{
+	return test_and_clear_bit(IRQTF_RUNTHREAD, &action->flags);
+}
+
+extern void exit_irq_thread(struct task_struct *tsk);
+
 /*
  * On lockdep we dont want to enable hardirqs in hardirq
  * context. Use local_irq_enable_in_hardirq() to annotate
Index: linux-2.6-tip/include/linux/irqreturn.h
===================================================================
--- linux-2.6-tip.orig/include/linux/irqreturn.h
+++ linux-2.6-tip/include/linux/irqreturn.h
@@ -6,11 +6,13 @@
  * @IRQ_NONE		interrupt was not from this device
  * @IRQ_HANDLED		interrupt was handled by this device
  * @IRQ_NEEDS_HANDLING	quick check handler requests to run real handler
+ * @IRQ_WAKE_THREAD	quick check handler requests to wake the handler thread
  */
 enum irqreturn {
 	IRQ_NONE,
 	IRQ_HANDLED,
 	IRQ_NEEDS_HANDLING,
+	IRQ_WAKE_THREAD,
 };
 
 typedef enum irqreturn irqreturn_t;
Index: linux-2.6-tip/include/linux/sched.h
===================================================================
--- linux-2.6-tip.orig/include/linux/sched.h
+++ linux-2.6-tip/include/linux/sched.h
@@ -1307,6 +1307,9 @@ struct task_struct {
 /* Protection of (de-)allocation: mm, files, fs, tty, keyrings */
 	spinlock_t alloc_lock;
 
+	/* IRQ handler threads */
+	struct irqaction *irqaction;
+
 	/* Protection of the PI data structures: */
 	spinlock_t pi_lock;
 
Index: linux-2.6-tip/kernel/exit.c
===================================================================
--- linux-2.6-tip.orig/kernel/exit.c
+++ linux-2.6-tip/kernel/exit.c
@@ -1040,6 +1040,8 @@ NORET_TYPE void do_exit(long code)
 		schedule();
 	}
 
+	exit_irq_thread(tsk);
+
 	exit_signals(tsk);  /* sets PF_EXITING */
 	/*
 	 * tsk->flags are checked in the futex code to protect against
Index: linux-2.6-tip/kernel/irq/handle.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/handle.c
+++ linux-2.6-tip/kernel/irq/handle.c
@@ -360,13 +360,46 @@ irqreturn_t handle_IRQ_event(unsigned in
 			ret = IRQ_NEEDS_HANDLING;
 
 		switch (ret) {
-		default:
+		case IRQ_NEEDS_HANDLING:
+			if (!(action->flags & IRQF_THREADED)) {
+				ret = action->handler(irq, action->dev_id);
+				if (ret == IRQ_HANDLED)
+					status |= action->flags;
+				break;
+			}
+			/*
+			 * Warn once when a quick check handler asked
+			 * for invoking the threaded (main) handler
+			 * directly
+			 */
+			WARN(!test_and_set_bit(IRQTF_WARNED,
+					       &action->thread_flags),
+			     "IRQ %d requested to run threaded handler "
+			     "in hard interrupt context\n", irq);
+
+			/* Fall through and wake the thread */
+		case IRQ_WAKE_THREAD:
+			/*
+			 * In case the thread crashed and was killed
+			 * we just pretend that we handled the
+			 * interrupt. The quick check handler has
+			 * disabled the device interrupt, so no irq
+			 * storm is lurking.
+			 */
+			if (likely(!test_bit(IRQTF_DIED,
+					     &action->thread_flags))) {
+				set_bit(IRQTF_RUNTHREAD, &action->thread_flags);
+				wake_up_process(action->thread);
+			}
+
+			/*
+			 * Set it to handled so the spurious check
+			 * does not trigger.
+			 */
+			ret = IRQ_HANDLED;
 			break;
 
-		case IRQ_NEEDS_HANDLING:
-			ret = action->handler(irq, action->dev_id);
-			if (ret == IRQ_HANDLED)
-				status |= action->flags;
+		default:
 			break;
 		}
 		retval |= ret;
Index: linux-2.6-tip/kernel/irq/manage.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/manage.c
+++ linux-2.6-tip/kernel/irq/manage.c
@@ -8,10 +8,12 @@
  */
 
 #include <linux/irq.h>
+#include <linux/kthread.h>
 #include <linux/module.h>
 #include <linux/random.h>
 #include <linux/interrupt.h>
 #include <linux/slab.h>
+#include <linux/sched.h>
 
 #include "internals.h"
 
@@ -27,6 +29,12 @@ cpumask_var_t irq_default_affinity;
  *	holding a resource the IRQ handler may need you will deadlock.
  *
  *	This function may be called - with care - from IRQ context.
+ *
+ *	Note: with threaded interrupt handlers synchronize_irq does
+ *	_NOT_ guarantee that the handler thread is in a quiescent
+ *	state. There is no general solution for this as threaded
+ *	handlers can sleep and have other fancy states which are not
+ *	that simple to track as the hardirq handler.
  */
 void synchronize_irq(unsigned int irq)
 {
@@ -72,6 +80,18 @@ int irq_can_set_affinity(unsigned int ir
 	return 1;
 }
 
+static void
+irq_set_thread_affinity(struct irq_desc *desc, const struct cpumask *cpumask)
+{
+	struct irqaction *action = desc->action;
+
+	while (action) {
+		if (action->thread)
+			set_cpus_allowed_ptr(action->thread, cpumask);
+		action = action->next;
+	}
+}
+
 /**
  *	irq_set_affinity - Set the irq affinity of a given irq
  *	@irq:		Interrupt to set affinity
@@ -100,6 +120,7 @@ int irq_set_affinity(unsigned int irq, c
 	cpumask_copy(desc->affinity, cpumask);
 	desc->chip->set_affinity(irq, cpumask);
 #endif
+	irq_set_thread_affinity(desc, cpumask);
 	desc->status |= IRQ_AFFINITY_SET;
 	spin_unlock_irqrestore(&desc->lock, flags);
 	return 0;
@@ -150,6 +171,8 @@ int irq_select_affinity_usr(unsigned int
 
 	spin_lock_irqsave(&desc->lock, flags);
 	ret = setup_affinity(irq, desc);
+	if (!ret)
+		irq_set_thread_affinity(desc, &desc->affinity);
 	spin_unlock_irqrestore(&desc->lock, flags);
 
 	return ret;
@@ -385,6 +408,58 @@ int __irq_set_trigger(struct irq_desc *d
 }
 
 /*
+ * Interrupt handler thread
+ */
+static int irq_thread(void *data)
+{
+	struct irqaction *action = data;
+	struct sched_param param = { 0, };
+
+	/*
+	 * Set irq thread priority to SCHED_FIFO prio 50:
+	 */
+	param.sched_priority = MAX_USER_RT_PRIO/2;
+	sched_setscheduler(current, SCHED_FIFO, &param);
+
+	current->irqaction = action;
+
+	while (!kthread_should_stop()) {
+		set_current_state(TASK_INTERRUPTIBLE);
+		if (irq_thread_should_run(action) && current->irqaction) {
+			__set_current_state(TASK_RUNNING);
+			action->handler(action->irq, action->dev_id);
+		} else
+			schedule();
+	}
+	/*
+	 * Clear irqaction. Otherwise exit_irq_thread() would make
+	 * fuzz about an active irq thread going into nirvana.
+	 */
+	current->irqaction = NULL;
+	return 0;
+}
+
+/*
+ * Called from do_exit()
+ */
+void exit_irq_thread(struct task_struct *tsk)
+{
+	if (!tsk->irqaction)
+		return;
+
+	printk(KERN_ERR
+	       "exiting task \"%s\" (%d) is an active IRQ thread (irq %d)\n",
+	       tsk->comm ? tsk->comm : "", tsk->pid, tsk->irqaction->irq);
+
+	/*
+	 * Set the THREAD DIED flag to prevent further wakeups of the
+	 * soon to be gone threaded handler.
+	 */
+	set_bit(IRQTF_DIED, &tsk->irqaction->flags);
+	tsk->irqaction = NULL;
+}
+
+/*
  * Internal function to register an irqaction - typically used to
  * allocate special interrupts that are part of the architecture.
  */
@@ -402,6 +477,11 @@ __setup_irq(unsigned int irq, struct irq
 
 	if (desc->chip == &no_irq_chip)
 		return -ENOSYS;
+
+	/* Threaded interrupts need a quickcheck handler */
+	if ((new->flags & IRQF_THREADED) && !new->quick_check_handler)
+		return -EINVAL;
+
 	/*
 	 * Some drivers like serial.c use request_irq() heavily,
 	 * so we have to be careful not to interfere with a
@@ -420,6 +500,26 @@ __setup_irq(unsigned int irq, struct irq
 	}
 
 	/*
+	 * Threaded handler ?
+	 */
+	if (new->flags & IRQF_THREADED) {
+		struct task_struct *t;
+
+		t = kthread_create(irq_thread, new, "irq/%d-%s", irq,
+				   new->name);
+		if (IS_ERR(t))
+			return PTR_ERR(t);
+		/*
+		 * We keep the reference to the task struct even if
+		 * the thread dies to avoid that the interrupt code
+		 * references an already gone task_struct.
+		 */
+		get_task_struct(t);
+		new->thread = t;
+		wake_up_process(t);
+	}
+
+	/*
 	 * The following block of code has to be executed atomically
 	 */
 	spin_lock_irqsave(&desc->lock, flags);
@@ -461,10 +561,8 @@ __setup_irq(unsigned int irq, struct irq
 			ret = __irq_set_trigger(desc, irq,
 					new->flags & IRQF_TRIGGER_MASK);
 
-			if (ret) {
-				spin_unlock_irqrestore(&desc->lock, flags);
-				return ret;
-			}
+			if (ret)
+				goto out_thread;
 		} else
 			compat_irq_chip_set_default_handler(desc);
 #if defined(CONFIG_IRQ_PER_CPU)
@@ -532,8 +630,19 @@ mismatch:
 		dump_stack();
 	}
 #endif
+	ret = -EBUSY;
+
+out_thread:
 	spin_unlock_irqrestore(&desc->lock, flags);
-	return -EBUSY;
+	if (new->thread) {
+		struct task_struct *t = new->thread;
+
+		new->thread = NULL;
+		if (likely(!test_bit(IRQTF_DIED, &new->thread_flags)))
+			kthread_stop(t);
+		put_task_struct(t);
+	}
+	return ret;
 }
 
 /**
@@ -568,6 +677,7 @@ void free_irq(unsigned int irq, void *de
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	struct irqaction *action, **action_ptr;
+	struct task_struct *irqthread;
 	unsigned long flags;
 
 	WARN(in_interrupt(), "Trying to free IRQ %d from IRQ context!\n", irq);
@@ -614,6 +724,12 @@ void free_irq(unsigned int irq, void *de
 		else
 			desc->chip->disable(irq);
 	}
+
+	irqthread = action->thread;
+	action->thread = NULL;
+	if (irqthread)
+		irqthread->irqaction = NULL;
+
 	spin_unlock_irqrestore(&desc->lock, flags);
 
 	unregister_handler_proc(irq, action);
@@ -621,6 +737,12 @@ void free_irq(unsigned int irq, void *de
 	/* Make sure it's not being used on another CPU: */
 	synchronize_irq(irq);
 
+	if (irqthread) {
+		if (!test_bit(IRQTF_DIED, &action->thread_flags))
+			kthread_stop(irqthread);
+		put_task_struct(irqthread);
+	}
+
 #ifdef CONFIG_DEBUG_SHIRQ
 	/*
 	 * It's a shared IRQ -- the driver ought to be prepared for an IRQ
@@ -647,7 +769,8 @@ EXPORT_SYMBOL(free_irq);
  *		  Primary handler for threaded interrupts
  *      @quick_check_handler: Function called before the real interrupt
  *			handler. It checks if the interrupt originated
- *			from the device. This can be NULL.
+ *			from the device. This can be NULL, but is mandatory
+ *			for threaded interrupt handlers.
  *	@irqflags: Interrupt type flags
  *	@devname: An ascii name for the claiming device
  *	@dev_id: A cookie passed back to the handler function
@@ -672,6 +795,7 @@ EXPORT_SYMBOL(free_irq);
  *	IRQF_DISABLED	Disable local interrupts while processing
  *	IRQF_SAMPLE_RANDOM	The interrupt can be used for entropy
  *	IRQF_TRIGGER_*		Specify active edge(s) or level
+ *      IRQF_THREADED           Interrupt is threaded
  *
  */
 int request_irq_quickcheck(unsigned int irq, irq_handler_t handler,


