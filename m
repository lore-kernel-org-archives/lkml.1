Return-Path: <linux-kernel-owner+w=401wt.eu-S1763253AbXF0To1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763253AbXF0To1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 15:44:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760125AbXF0Tnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 15:43:39 -0400
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:50409 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758408AbXF0Tnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 15:43:37 -0400
Message-Id: <20070627194328.383900689@goodmis.org>
References: <20070627193633.025544061@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 27 Jun 2007 15:36:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, kuznet@ms2.inr.ac.ru,
       Jonathan Corbet <corbet@lwn.net>,
       Arjan van de Ven <arjan@infradead.org>, Arnd Bergmann <arnd@arndb.de>
Subject: [RFC PATCH 8/8] Convert tasklets to work queues
Content-Disposition: inline; filename=tasklets-to-workqueues.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces the tasklet implementation with a work
queue implementation while keeping the tasklet API.
The API is still the same, and the drivers don't know that a
work queue is being used.

This is (for now) a proof of concept approach to using work queues
instead of tasklets.  More can be done. For one thing, we could make
individual work queues for each tasklet instead of using the global
ktasklet_wq.  But for now it's just easier to do this.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>


Index: linux-2.6-test/kernel/Makefile
===================================================================
--- linux-2.6-test.orig/kernel/Makefile
+++ linux-2.6-test/kernel/Makefile
@@ -21,7 +21,7 @@ obj-$(CONFIG_FUTEX) += futex.o
 ifeq ($(CONFIG_COMPAT),y)
 obj-$(CONFIG_FUTEX) += futex_compat.o
 endif
-obj-y += tasklet.o
+obj-y += tasklet_work.o
 obj-$(CONFIG_RT_MUTEXES) += rtmutex.o
 obj-$(CONFIG_DEBUG_RT_MUTEXES) += rtmutex-debug.o
 obj-$(CONFIG_RT_MUTEX_TESTER) += rtmutex-tester.o
Index: linux-2.6-test/init/main.c
===================================================================
--- linux-2.6-test.orig/init/main.c
+++ linux-2.6-test/init/main.c
@@ -120,7 +120,7 @@ EXPORT_SYMBOL(system_state);
 extern void time_init(void);
 /* Default late time init is NULL. archs can override this later. */
 void (*late_time_init)(void);
-extern void softirq_init(void);
+extern void init_tasklets(void);
 
 /* Untouched command line saved by arch-specific code. */
 char __initdata boot_command_line[COMMAND_LINE_SIZE];
@@ -563,7 +563,6 @@ asmlinkage void __init start_kernel(void
 	pidhash_init();
 	init_timers();
 	hrtimers_init();
-	softirq_init();
 	timekeeping_init();
 	time_init();
 	profile_init();
@@ -706,6 +705,7 @@ static void __init do_basic_setup(void)
 {
 	/* drivers will send hotplug events */
 	init_workqueues();
+	init_tasklets();
 	usermodehelper_init();
 	driver_init();
 	init_irq_proc();
Index: linux-2.6-test/include/linux/tasklet.h
===================================================================
--- linux-2.6-test.orig/include/linux/tasklet.h
+++ linux-2.6-test/include/linux/tasklet.h
@@ -1,79 +1,45 @@
-#ifndef _LINUX_TASKLET_H
-#define _LINUX_TASKLET_H
+#ifndef _LINUX_WORK_TASKLET_H
+#define _LINUX_WORK_TASKLET_H
 
-/* Tasklets --- multithreaded analogue of BHs.
+#include <linux/workqueue.h>
 
-   Main feature differing them of generic softirqs: tasklet
-   is running only on one CPU simultaneously.
+extern void work_tasklet_exec(struct work_struct *work);
 
-   Main feature differing them of BHs: different tasklets
-   may be run simultaneously on different CPUs.
-
-   Properties:
-   * If tasklet_schedule() is called, then tasklet is guaranteed
-     to be executed on some cpu at least once after this.
-   * If the tasklet is already scheduled, but its excecution is still not
-     started, it will be executed only once.
-   * If this tasklet is already running on another CPU (or schedule is called
-     from tasklet itself), it is rescheduled for later.
-   * Tasklet is strictly serialized wrt itself, but not
-     wrt another tasklets. If client needs some intertask synchronization,
-     he makes it with spinlocks.
- */
+enum
+{
+	TASKLET_STATE_PENDING	/* Tasklet is pending */
+};
+
+#define TASKLET_STATEF_PENDING	(1 << TASKLET_STATE_PENDING)
 
 struct tasklet_struct
 {
-	struct tasklet_struct *next;
+	struct work_struct work;
+	struct list_head list;
 	unsigned long state;
 	atomic_t count;
 	void (*func)(unsigned long);
 	unsigned long data;
+	char *n;
 };
 
-enum
-{
-	TASKLET_STATE_SCHED,	/* Tasklet is scheduled for execution */
-	TASKLET_STATE_RUN	/* Tasklet is running (SMP only) */
-};
-
-#ifdef CONFIG_SMP
-static inline int tasklet_trylock(struct tasklet_struct *t)
-{
-	return !test_and_set_bit(TASKLET_STATE_RUN, &(t)->state);
-}
-
-static inline void tasklet_unlock(struct tasklet_struct *t)
-{
-	smp_mb__before_clear_bit(); 
-	clear_bit(TASKLET_STATE_RUN, &(t)->state);
-}
-
-static inline void tasklet_unlock_wait(struct tasklet_struct *t)
-{
-	while (test_bit(TASKLET_STATE_RUN, &(t)->state)) { barrier(); }
-}
-#else
-#define tasklet_trylock(t) 1
-#define tasklet_unlock_wait(t) do { } while (0)
-#define tasklet_unlock(t) do { } while (0)
-#endif
-
-extern void FASTCALL(__tasklet_schedule(struct tasklet_struct *t));
+extern struct workqueue_struct *ktaskletd_wq;
 
 static inline void tasklet_schedule(struct tasklet_struct *t)
 {
-	if (!test_and_set_bit(TASKLET_STATE_SCHED, &t->state))
-		__tasklet_schedule(t);
+	WARN_ON_ONCE(!ktaskletd_wq);
+	queue_work(ktaskletd_wq, &t->work);
 }
+#define tasklet_hi_schedule tasklet_schedule
 
-extern void FASTCALL(__tasklet_hi_schedule(struct tasklet_struct *t));
-
-static inline void tasklet_hi_schedule(struct tasklet_struct *t)
+static inline void fastcall tasklet_enable(struct tasklet_struct *t)
 {
-	if (!test_and_set_bit(TASKLET_STATE_SCHED, &t->state))
-		__tasklet_hi_schedule(t);
+	if (!atomic_dec_and_test(&t->count))
+		return;
+	if (test_and_clear_bit(TASKLET_STATE_PENDING, &t->state))
+		tasklet_schedule(t);
 }
-
+#define tasklet_hi_enable tasklet_enable
 
 static inline void tasklet_disable_nosync(struct tasklet_struct *t)
 {
@@ -84,35 +50,35 @@ static inline void tasklet_disable_nosyn
 static inline void tasklet_disable(struct tasklet_struct *t)
 {
 	tasklet_disable_nosync(t);
-	tasklet_unlock_wait(t);
-	smp_mb();
-}
-
-static inline void tasklet_enable(struct tasklet_struct *t)
-{
-	smp_mb__before_atomic_dec();
-	atomic_dec(&t->count);
+	flush_workqueue(ktaskletd_wq);
+	/* flush_workqueue should provide us a barrier */
 }
 
-static inline void tasklet_hi_enable(struct tasklet_struct *t)
+static inline int tasklet_is_scheduled(struct tasklet_struct *t)
 {
-	smp_mb__before_atomic_dec();
-	atomic_dec(&t->count);
+	int ret;
+	ret = work_pending(&t->work);
+	return ret;
 }
 
-static inline int tasklet_is_scheduled(struct tasklet_struct *t)
+static inline void tasklet_kill(struct tasklet_struct *t)
 {
-	return test_bit(TASKLET_STATE_SCHED, &t->state);
+	flush_workqueue(ktaskletd_wq);
 }
 
-extern void tasklet_kill(struct tasklet_struct *t);
-extern void tasklet_kill_immediate(struct tasklet_struct *t, unsigned int cpu);
 extern void tasklet_init(struct tasklet_struct *t,
 			 void (*func)(unsigned long), unsigned long data);
 
-#ifdef CONFIG_HOTPLUG_CPU
-void takeover_tasklets(unsigned int cpu);
-#endif /* CONFIG_HOTPLUG_CPU */
+static inline void tasklet_unlock(struct tasklet_struct *t)
+{
+	static int once;
 
-#endif /* _LINUX_TASKLET_H */
+	if (!once) {
+		once = 1;
+		printk(KERN_ERR
+		       "tasklet_unlocked called - sign of buggy code\n");
+		dump_stack();
+	}
+}
 
+#endif /* _LINUX_WORK_TASKLET_H */
Index: linux-2.6-test/kernel/tasklet_work.c
===================================================================
--- /dev/null
+++ linux-2.6-test/kernel/tasklet_work.c
@@ -0,0 +1,59 @@
+/*
+ *	linux/kernel/tasklet_work.c
+ *
+ *	Copyright (C) 2007 Steven Rostedt, Red Hat
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/tasklet.h>
+
+struct workqueue_struct *ktaskletd_wq;
+EXPORT_SYMBOL(ktaskletd_wq);
+
+void work_tasklet_exec(struct work_struct *work)
+{
+	struct tasklet_struct *t =
+		container_of(work, struct tasklet_struct, work);
+
+	if (unlikely(atomic_read(&t->count))) {
+		set_bit(TASKLET_STATE_PENDING, &t->state);
+		/* Make sure bit is visible before checking count */
+		smp_mb();
+		/* make sure we were not just enabled (count == 0) */
+		if (likely(atomic_read(&t->count)))
+			goto out;
+		/* did the enable schedule us? */
+		if (!test_and_clear_bit(TASKLET_STATE_PENDING, &t->state))
+			goto out;
+	}
+
+	local_bh_disable();
+	t->func(t->data);
+	local_bh_enable();
+
+out:
+	return;
+}
+EXPORT_SYMBOL(work_tasklet_exec);
+
+void __init init_tasklets(void)
+{
+	ktaskletd_wq = create_workqueue("tasklets");
+	BUG_ON(!ktaskletd_wq);
+}
+
+void tasklet_init(struct tasklet_struct *t,
+		  void (*func)(unsigned long), unsigned long data)
+{
+	INIT_WORK(&t->work, work_tasklet_exec);
+	INIT_LIST_HEAD(&t->list);
+	t->state = 0;
+	atomic_set(&t->count, 0);
+	t->func = func;
+	t->data = data;
+	t->n = "anonymous";
+	pr_debug("anonymous tasklet %p set at %p\n",
+		t, __builtin_return_address(0));
+}
+EXPORT_SYMBOL(tasklet_init);
Index: linux-2.6-test/kernel/tasklet.c
===================================================================
--- linux-2.6-test.orig/kernel/tasklet.c
+++ /dev/null
@@ -1,203 +0,0 @@
-/*
- *	linux/kernel/softirq.c
- *
- *	Copyright (C) 1992 Linus Torvalds
- *
- * Rewritten. Old one was good in 2.2, but in 2.3 it was immoral. --ANK (990903)
- *
- *      Removed from softirq.c by Steven Rostedt
- */
-#include <linux/interrupt.h>
-#include <linux/cpu.h>
-
-/* Tasklets */
-struct tasklet_head
-{
-	struct tasklet_struct *list;
-};
-
-/* Some compilers disobey section attribute on statics when not
-   initialized -- RR */
-static DEFINE_PER_CPU(struct tasklet_head, tasklet_vec) = { NULL };
-static DEFINE_PER_CPU(struct tasklet_head, tasklet_hi_vec) = { NULL };
-
-void fastcall __tasklet_schedule(struct tasklet_struct *t)
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-	t->next = __get_cpu_var(tasklet_vec).list;
-	__get_cpu_var(tasklet_vec).list = t;
-	raise_softirq_irqoff(TASKLET_SOFTIRQ);
-	local_irq_restore(flags);
-}
-
-EXPORT_SYMBOL(__tasklet_schedule);
-
-void fastcall __tasklet_hi_schedule(struct tasklet_struct *t)
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-	t->next = __get_cpu_var(tasklet_hi_vec).list;
-	__get_cpu_var(tasklet_hi_vec).list = t;
-	raise_softirq_irqoff(HI_SOFTIRQ);
-	local_irq_restore(flags);
-}
-
-EXPORT_SYMBOL(__tasklet_hi_schedule);
-
-static void tasklet_action(struct softirq_action *a)
-{
-	struct tasklet_struct *list;
-
-	local_irq_disable();
-	list = __get_cpu_var(tasklet_vec).list;
-	__get_cpu_var(tasklet_vec).list = NULL;
-	local_irq_enable();
-
-	while (list) {
-		struct tasklet_struct *t = list;
-
-		list = list->next;
-
-		if (tasklet_trylock(t)) {
-			if (!atomic_read(&t->count)) {
-				if (!test_and_clear_bit(TASKLET_STATE_SCHED, &t->state))
-					BUG();
-				t->func(t->data);
-				tasklet_unlock(t);
-				continue;
-			}
-			tasklet_unlock(t);
-		}
-
-		local_irq_disable();
-		t->next = __get_cpu_var(tasklet_vec).list;
-		__get_cpu_var(tasklet_vec).list = t;
-		__raise_softirq_irqoff(TASKLET_SOFTIRQ);
-		local_irq_enable();
-	}
-}
-
-static void tasklet_hi_action(struct softirq_action *a)
-{
-	struct tasklet_struct *list;
-
-	local_irq_disable();
-	list = __get_cpu_var(tasklet_hi_vec).list;
-	__get_cpu_var(tasklet_hi_vec).list = NULL;
-	local_irq_enable();
-
-	while (list) {
-		struct tasklet_struct *t = list;
-
-		list = list->next;
-
-		if (tasklet_trylock(t)) {
-			if (!atomic_read(&t->count)) {
-				if (!test_and_clear_bit(TASKLET_STATE_SCHED, &t->state))
-					BUG();
-				t->func(t->data);
-				tasklet_unlock(t);
-				continue;
-			}
-			tasklet_unlock(t);
-		}
-
-		local_irq_disable();
-		t->next = __get_cpu_var(tasklet_hi_vec).list;
-		__get_cpu_var(tasklet_hi_vec).list = t;
-		__raise_softirq_irqoff(HI_SOFTIRQ);
-		local_irq_enable();
-	}
-}
-
-
-void tasklet_init(struct tasklet_struct *t,
-		  void (*func)(unsigned long), unsigned long data)
-{
-	t->next = NULL;
-	t->state = 0;
-	atomic_set(&t->count, 0);
-	t->func = func;
-	t->data = data;
-}
-
-EXPORT_SYMBOL(tasklet_init);
-
-void tasklet_kill(struct tasklet_struct *t)
-{
-	if (in_interrupt())
-		printk("Attempt to kill tasklet from interrupt\n");
-
-	while (test_and_set_bit(TASKLET_STATE_SCHED, &t->state)) {
-		do
-			yield();
-		while (test_bit(TASKLET_STATE_SCHED, &t->state));
-	}
-	tasklet_unlock_wait(t);
-	clear_bit(TASKLET_STATE_SCHED, &t->state);
-}
-
-EXPORT_SYMBOL(tasklet_kill);
-
-void __init softirq_init(void)
-{
-	open_softirq(TASKLET_SOFTIRQ, tasklet_action, NULL);
-	open_softirq(HI_SOFTIRQ, tasklet_hi_action, NULL);
-}
-
-#ifdef CONFIG_HOTPLUG_CPU
-/*
- * tasklet_kill_immediate is called to remove a tasklet which can already be
- * scheduled for execution on @cpu.
- *
- * Unlike tasklet_kill, this function removes the tasklet
- * _immediately_, even if the tasklet is in TASKLET_STATE_SCHED state.
- *
- * When this function is called, @cpu must be in the CPU_DEAD state.
- */
-void tasklet_kill_immediate(struct tasklet_struct *t, unsigned int cpu)
-{
-	struct tasklet_struct **i;
-
-	BUG_ON(cpu_online(cpu));
-	BUG_ON(test_bit(TASKLET_STATE_RUN, &t->state));
-
-	if (!test_bit(TASKLET_STATE_SCHED, &t->state))
-		return;
-
-	/* CPU is dead, so no lock needed. */
-	for (i = &per_cpu(tasklet_vec, cpu).list; *i; i = &(*i)->next) {
-		if (*i == t) {
-			*i = t->next;
-			return;
-		}
-	}
-	BUG();
-}
-
-void takeover_tasklets(unsigned int cpu)
-{
-	struct tasklet_struct **i;
-
-	/* CPU is dead, so no lock needed. */
-	local_irq_disable();
-
-	/* Find end, append list for that CPU. */
-	for (i = &__get_cpu_var(tasklet_vec).list; *i; i = &(*i)->next);
-	*i = per_cpu(tasklet_vec, cpu).list;
-	per_cpu(tasklet_vec, cpu).list = NULL;
-	raise_softirq_irqoff(TASKLET_SOFTIRQ);
-
-	for (i = &__get_cpu_var(tasklet_hi_vec).list; *i; i = &(*i)->next);
-	*i = per_cpu(tasklet_hi_vec, cpu).list;
-	per_cpu(tasklet_hi_vec, cpu).list = NULL;
-	raise_softirq_irqoff(HI_SOFTIRQ);
-
-	local_irq_enable();
-}
-#endif /* CONFIG_HOTPLUG_CPU */
-
-
Index: linux-2.6-test/kernel/softirq.c
===================================================================
--- linux-2.6-test.orig/kernel/softirq.c
+++ linux-2.6-test/kernel/softirq.c
@@ -425,7 +425,6 @@ static int __cpuinit cpu_callback(struct
 		p = per_cpu(ksoftirqd, hotcpu);
 		per_cpu(ksoftirqd, hotcpu) = NULL;
 		kthread_stop(p);
-		takeover_tasklets(hotcpu);
 		break;
 #endif /* CONFIG_HOTPLUG_CPU */
  	}

-- 
