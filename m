Return-Path: <linux-kernel-owner+w=401wt.eu-S1760776AbZCWSZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760776AbZCWSZQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 14:25:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760257AbZCWSYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 14:24:30 -0400
Received: from www.tglx.de ([62.245.132.106]:57624 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759995AbZCWSY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 14:24:27 -0400
Message-Id: <20090323172835.250505802@linutronix.de>
User-Agent: quilt/0.47-1
Date: Mon, 23 Mar 2009 18:23:09 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Christoph Hellwig <hch@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>,
       Jon Masters <jonathan@jonmasters.org>,
       Sven Dietrich <sdietrich@suse.de>, David Brownell <david-b@pacbell.net>
Subject: [patch 1/2] genirq: add threaded interrupt handler support
References: <20090323172814.548471871@linutronix.de>
Content-Disposition: inline; filename=genirq-add-threaded-irq-handlers.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for threaded interrupt handlers:

A device driver can request that its main interrupt handler runs in a
thread. To achive this the device driver requests the interrupt with
request_threaded_irq() and provides additionally to the handler a
thread function. The handler function is called in hard interrupt
context and needs to check whether the interrupt originated from the
device. If the interrupt originated from the device then the handler
can either return IRQ_HANDLED or IRQ_WAKE_THREAD. IRQ_HANDLED is
returned when no further action is required. IRQ_WAKE_THREAD causes
the genirq code to invoke the threaded (main) handler. When
IRQ_WAKE_THREAD is returned handler must have disabled the interrupt
on the device level. This is mandatory for shared interrupt handlers,
but we need to do it as well for obscure x86 hardware where disabling
an interrupt on the IO_APIC level redirects the interrupt to the
legacy PIC interrupt lines.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/hardirq.h   |    2 
 include/linux/interrupt.h |   37 ++++++++
 include/linux/irq.h       |    5 +
 include/linux/irqreturn.h |    2 
 include/linux/sched.h     |    5 +
 kernel/exit.c             |    2 
 kernel/irq/handle.c       |   31 +++++++
 kernel/irq/manage.c       |  193 ++++++++++++++++++++++++++++++++++++++++++----
 8 files changed, 260 insertions(+), 17 deletions(-)

Index: linux-2.6-tip/include/linux/hardirq.h
===================================================================
--- linux-2.6-tip.orig/include/linux/hardirq.h
+++ linux-2.6-tip/include/linux/hardirq.h
@@ -105,7 +105,7 @@
 # define IRQ_EXIT_OFFSET HARDIRQ_OFFSET
 #endif
 
-#ifdef CONFIG_SMP
+#if defined(CONFIG_SMP) || defined(CONFIG_GENERIC_HARDIRQS)
 extern void synchronize_irq(unsigned int irq);
 #else
 # define synchronize_irq(irq)	barrier()
Index: linux-2.6-tip/include/linux/interrupt.h
===================================================================
--- linux-2.6-tip.orig/include/linux/interrupt.h
+++ linux-2.6-tip/include/linux/interrupt.h
@@ -59,6 +59,16 @@
 #define IRQF_NOBALANCING	0x00000800
 #define IRQF_IRQPOLL		0x00001000
 
+/*
+ * Bits used by threaded handlers:
+ * IRQTF_RUNTHREAD - signals that the interrupt handler thread should run
+ * IRQTF_DIED      - handler thread died
+ */
+enum {
+	IRQTF_RUNTHREAD,
+	IRQTF_DIED,
+};
+
 typedef irqreturn_t (*irq_handler_t)(int, void *);
 
 /**
@@ -71,6 +81,9 @@ typedef irqreturn_t (*irq_handler_t)(int
  * @next:	pointer to the next irqaction for shared interrupts
  * @irq:	interrupt number
  * @dir:	pointer to the proc/irq/NN/name entry
+ * @thread_fn:	interupt handler function for threaded interrupts
+ * @thread:	thread pointer for threaded interrupts
+ * @thread_flags:	flags related to @thread
  */
 struct irqaction {
 	irq_handler_t handler;
@@ -81,11 +94,31 @@ struct irqaction {
 	struct irqaction *next;
 	int irq;
 	struct proc_dir_entry *dir;
+	irq_handler_t thread_fn;
+	struct task_struct *thread;
+	unsigned long thread_flags;
 };
 
 extern irqreturn_t no_action(int cpl, void *dev_id);
-extern int __must_check request_irq(unsigned int, irq_handler_t handler,
-		       unsigned long, const char *, void *);
+
+extern int __must_check
+request_threaded_irq(unsigned int irq, irq_handler_t handler,
+		     irq_handler_t thread_fn,
+		     unsigned long flags, const char *name, void *dev);
+
+static inline int __must_check
+request_irq(unsigned int irq, irq_handler_t handler, unsigned long flags,
+	    const char *name, void *dev)
+{
+	return request_threaded_irq(irq, handler, NULL, flags, name, dev);
+}
+
+#ifdef CONFIG_GENERIC_HARDIRQS
+extern void exit_irq_thread(void);
+#else
+static inline void exit_irq_thread(void) { }
+#endif
+
 extern void free_irq(unsigned int, void *);
 
 struct device;
Index: linux-2.6-tip/include/linux/irq.h
===================================================================
--- linux-2.6-tip.orig/include/linux/irq.h
+++ linux-2.6-tip/include/linux/irq.h
@@ -20,6 +20,7 @@
 #include <linux/irqreturn.h>
 #include <linux/irqnr.h>
 #include <linux/errno.h>
+#include <linux/wait.h>
 
 #include <asm/irq.h>
 #include <asm/ptrace.h>
@@ -155,6 +156,8 @@ struct irq_2_iommu;
  * @affinity:		IRQ affinity on SMP
  * @cpu:		cpu index useful for balancing
  * @pending_mask:	pending rebalanced interrupts
+ * @threads_active:	number of irqaction threads currently running
+ * @wait_for_threads:	wait queue for sync_irq to wait for threaded handlers
  * @dir:		/proc/irq/ procfs entry
  * @name:		flow handler name for /proc/interrupts output
  */
@@ -186,6 +189,8 @@ struct irq_desc {
 	cpumask_var_t		pending_mask;
 #endif
 #endif
+	atomic_t		threads_active;
+	wait_queue_head_t       wait_for_threads;
 #ifdef CONFIG_PROC_FS
 	struct proc_dir_entry	*dir;
 #endif
Index: linux-2.6-tip/include/linux/irqreturn.h
===================================================================
--- linux-2.6-tip.orig/include/linux/irqreturn.h
+++ linux-2.6-tip/include/linux/irqreturn.h
@@ -5,10 +5,12 @@
  * enum irqreturn
  * @IRQ_NONE		interrupt was not from this device
  * @IRQ_HANDLED		interrupt was handled by this device
+ * @IRQ_WAKE_THREAD	handler requests to wake the handler thread
  */
 enum irqreturn {
 	IRQ_NONE,
 	IRQ_HANDLED,
+	IRQ_WAKE_THREAD,
 };
 
 typedef enum irqreturn irqreturn_t;
Index: linux-2.6-tip/include/linux/sched.h
===================================================================
--- linux-2.6-tip.orig/include/linux/sched.h
+++ linux-2.6-tip/include/linux/sched.h
@@ -1292,6 +1292,11 @@ struct task_struct {
 /* Protection of (de-)allocation: mm, files, fs, tty, keyrings */
 	spinlock_t alloc_lock;
 
+#ifdef CONFIG_GENERIC_HARDIRQS
+	/* IRQ handler threads */
+	struct irqaction *irqaction;
+#endif
+
 	/* Protection of the PI data structures: */
 	spinlock_t pi_lock;
 
Index: linux-2.6-tip/kernel/exit.c
===================================================================
--- linux-2.6-tip.orig/kernel/exit.c
+++ linux-2.6-tip/kernel/exit.c
@@ -1037,6 +1037,8 @@ NORET_TYPE void do_exit(long code)
 		schedule();
 	}
 
+	exit_irq_thread();
+
 	exit_signals(tsk);  /* sets PF_EXITING */
 	/*
 	 * tsk->flags are checked in the futex code to protect against
Index: linux-2.6-tip/kernel/irq/handle.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/handle.c
+++ linux-2.6-tip/kernel/irq/handle.c
@@ -358,8 +358,37 @@ irqreturn_t handle_IRQ_event(unsigned in
 
 	do {
 		ret = action->handler(irq, action->dev_id);
-		if (ret == IRQ_HANDLED)
+
+		switch (ret) {
+		case IRQ_WAKE_THREAD:
+			/*
+			 * Wake up the handler thread for this
+			 * action. In case the thread crashed and was
+			 * killed we just pretend that we handled the
+			 * interrupt. The hardirq handler above has
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
+			/* Fall through to add to randomness */
+		case IRQ_HANDLED:
 			status |= action->flags;
+			break;
+
+		default:
+			break;
+		}
+
 		retval |= ret;
 		action = action->next;
 	} while (action);
Index: linux-2.6-tip/kernel/irq/manage.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/manage.c
+++ linux-2.6-tip/kernel/irq/manage.c
@@ -8,16 +8,15 @@
  */
 
 #include <linux/irq.h>
+#include <linux/kthread.h>
 #include <linux/module.h>
 #include <linux/random.h>
 #include <linux/interrupt.h>
 #include <linux/slab.h>
+#include <linux/sched.h>
 
 #include "internals.h"
 
-#if defined(CONFIG_SMP) && defined(CONFIG_GENERIC_HARDIRQS)
-cpumask_var_t irq_default_affinity;
-
 /**
  *	synchronize_irq - wait for pending IRQ handlers (on other CPUs)
  *	@irq: interrupt number to wait for
@@ -53,9 +52,18 @@ void synchronize_irq(unsigned int irq)
 
 		/* Oops, that failed? */
 	} while (status & IRQ_INPROGRESS);
+
+	/*
+	 * We made sure that no hardirq handler is running. Now verify
+	 * that no threaded handlers are active.
+	 */
+	wait_event(desc->wait_for_threads, !atomic_read(&desc->threads_active));
 }
 EXPORT_SYMBOL(synchronize_irq);
 
+#ifdef CONFIG_SMP
+cpumask_var_t irq_default_affinity;
+
 /**
  *	irq_can_set_affinity - Check if the affinity of a given irq can be set
  *	@irq:		Interrupt to check
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
+		irq_set_thread_affinity(desc, desc->affinity);
 	spin_unlock_irqrestore(&desc->lock, flags);
 
 	return ret;
@@ -384,6 +407,93 @@ int __irq_set_trigger(struct irq_desc *d
 	return ret;
 }
 
+static inline int irq_thread_should_run(struct irqaction *action)
+{
+	return test_and_clear_bit(IRQTF_RUNTHREAD, &action->thread_flags);
+}
+
+static int irq_wait_for_interrupt(struct irqaction *action)
+{
+	while (!kthread_should_stop()) {
+		set_current_state(TASK_INTERRUPTIBLE);
+		if (irq_thread_should_run(action)) {
+			__set_current_state(TASK_RUNNING);
+			return 0;
+		} else
+			schedule();
+	}
+	return -1;
+}
+
+/*
+ * Interrupt handler thread
+ */
+static int irq_thread(void *data)
+{
+	struct sched_param param = { .sched_priority = MAX_USER_RT_PRIO/2, };
+	struct irqaction *action = data;
+	struct irq_desc *desc = irq_to_desc(action->irq);
+	int wake;
+
+	sched_setscheduler(current, SCHED_FIFO, &param);
+	current->irqaction = action;
+
+	while (!irq_wait_for_interrupt(action)) {
+
+		atomic_inc(&desc->threads_active);
+
+		spin_lock_irq(&desc->lock);
+		if (unlikely(desc->status & IRQ_DISABLED)) {
+			/*
+			 * CHECKME: We might need a dedicated
+			 * IRQ_THREAD_PENDING flag here, which
+			 * retriggers the thread in check_irq_resend()
+			 * but AFAICT IRQ_PENDING should be fine as it
+			 * retriggers the interrupt itself --- tglx
+			 */
+			desc->status |= IRQ_PENDING;
+			spin_unlock_irq(&desc->lock);
+		} else {
+			spin_unlock_irq(&desc->lock);
+
+			action->thread_fn(action->irq, action->dev_id);
+		}
+
+		wake = atomic_dec_and_test(&desc->threads_active);
+
+		if (wake && waitqueue_active(&desc->wait_for_threads))
+			wake_up(&desc->wait_for_threads);
+	}
+
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
+void exit_irq_thread(void)
+{
+	struct task_struct *tsk = current;
+
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
+}
+
 /*
  * Internal function to register an irqaction - typically used to
  * allocate special interrupts that are part of the architecture.
@@ -420,6 +531,26 @@ __setup_irq(unsigned int irq, struct irq
 	}
 
 	/*
+	 * Threaded handler ?
+	 */
+	if (new->thread_fn) {
+		struct task_struct *t;
+
+		t = kthread_create(irq_thread, new, "irq/%d-%s", irq,
+				   new->name);
+		if (IS_ERR(t))
+			return PTR_ERR(t);
+		/*
+		 * We keep the reference to the task struct even if
+		 * the thread dies to avoid that the interrupt code
+		 * references an already freed task_struct.
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
@@ -456,15 +587,15 @@ __setup_irq(unsigned int irq, struct irq
 	if (!shared) {
 		irq_chip_set_defaults(desc->chip);
 
+		init_waitqueue_head(&desc->wait_for_threads);
+
 		/* Setup the type (level, edge polarity) if configured: */
 		if (new->flags & IRQF_TRIGGER_MASK) {
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
@@ -532,8 +663,19 @@ mismatch:
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
@@ -559,6 +701,7 @@ static struct irqaction *__free_irq(unsi
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	struct irqaction *action, **action_ptr;
+	struct task_struct *irqthread;
 	unsigned long flags;
 
 	WARN(in_interrupt(), "Trying to free IRQ %d from IRQ context!\n", irq);
@@ -605,6 +748,10 @@ static struct irqaction *__free_irq(unsi
 		else
 			desc->chip->disable(irq);
 	}
+
+	irqthread = action->thread;
+	action->thread = NULL;
+
 	spin_unlock_irqrestore(&desc->lock, flags);
 
 	unregister_handler_proc(irq, action);
@@ -612,6 +759,12 @@ static struct irqaction *__free_irq(unsi
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
@@ -664,9 +817,12 @@ void free_irq(unsigned int irq, void *de
 EXPORT_SYMBOL(free_irq);
 
 /**
- *	request_irq - allocate an interrupt line
+ *	request_threaded_irq - allocate an interrupt line
  *	@irq: Interrupt line to allocate
- *	@handler: Function to be called when the IRQ occurs
+ *	@handler: Function to be called when the IRQ occurs.
+ *		  Primary handler for threaded interrupts
+ *      @thread_fn: Function called from the irq handler thread
+ *                  If NULL, no irq thread is created
  *	@irqflags: Interrupt type flags
  *	@devname: An ascii name for the claiming device
  *	@dev_id: A cookie passed back to the handler function
@@ -678,6 +834,15 @@ EXPORT_SYMBOL(free_irq);
  *	raises, you must take care both to initialise your hardware
  *	and to set up the interrupt handler in the right order.
  *
+ *	If you want to set up a threaded irq handler for your device
+ *	then you need to supply @handler and @thread_fn. @handler ist
+ *	still called in hard interrupt context and has to check
+ *	whether the interrupt originates from the device. If yes it
+ *	needs to disable the interrupt on the device and return
+ *	IRQ_THREAD_WAKE which will wake up the handler thread and run
+ *	@thread_fn. This split handler design is necessary to support
+ *	shared interrupts.
+ *
  *	Dev_id must be globally unique. Normally the address of the
  *	device data structure is used as the cookie. Since the handler
  *	receives this value it makes sense to use it.
@@ -693,8 +858,9 @@ EXPORT_SYMBOL(free_irq);
  *	IRQF_TRIGGER_*		Specify active edge(s) or level
  *
  */
-int request_irq(unsigned int irq, irq_handler_t handler,
-		unsigned long irqflags, const char *devname, void *dev_id)
+int request_threaded_irq(unsigned int irq, irq_handler_t handler,
+			 irq_handler_t thread_fn, unsigned long irqflags,
+			 const char *devname, void *dev_id)
 {
 	struct irqaction *action;
 	struct irq_desc *desc;
@@ -742,6 +908,7 @@ int request_irq(unsigned int irq, irq_ha
 		return -ENOMEM;
 
 	action->handler = handler;
+	action->thread_fn = thread_fn;
 	action->flags = irqflags;
 	action->name = devname;
 	action->dev_id = dev_id;
@@ -771,4 +938,4 @@ int request_irq(unsigned int irq, irq_ha
 #endif
 	return retval;
 }
-EXPORT_SYMBOL(request_irq);
+EXPORT_SYMBOL(request_threaded_irq);


