Return-Path: <linux-kernel-owner+w=401wt.eu-S1751491AbXFVEEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751491AbXFVEEc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 00:04:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751341AbXFVEEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 00:04:07 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:42257 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbXFVEEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 00:04:05 -0400
Message-Id: <20070622040137.414439610@goodmis.org>
References: <20070622040014.234651401@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 22 Jun 2007 00:00:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com,
       kuznet@ms2.inr.ac.ru
Subject: [RFC PATCH 6/6] Convert tasklets to work queues
Content-Disposition: inline; filename=tasklets-to-workqueues.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch creates an alternative for drivers from using tasklets.
It creates a "work_tasklet". When configured to use work_tasklets
instead of tasklets, instead of creating tasklets, a work queue
is made in its place.  The API is still the same, and the drivers
don't know that a work queue is being used.

This is (for now) a proof of concept approach to using work queues
instead of tasklets.  More can be done. For one thing, we could make
individual work queues for each tasklet instead of using the global
ktasklet_wq.  But for now it's just easier to do this.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>


Index: linux-2.6-test/kernel/Kconfig.preempt
===================================================================
--- linux-2.6-test.orig/kernel/Kconfig.preempt
+++ linux-2.6-test/kernel/Kconfig.preempt
@@ -63,3 +63,18 @@ config PREEMPT_BKL
 	  Say Y here if you are building a kernel for a desktop system.
 	  Say N if you are unsure.
 
+config TASKLETS_AS_WORKQUEUES
+	bool "Treat tasklets as workqueues (EXPERIMENTAL)"
+	depends on EXPERIMENTAL
+	help
+	  Tasklets are an old solution to an old problem with respect
+	  to SMP.  But today they are not necessary anymore.
+	  There are better solutions to the problem that tasklets
+	  are trying to solve.
+
+	  This option converts tasklets into workqueues and
+	  removes the tasklet softirq.  This is a clean up until
+	  we get rid of all tasklets that are currently in
+	  the kernel.
+
+	  Say Y if you are unsure and brave (not very well tested code!).
Index: linux-2.6-test/kernel/Makefile
===================================================================
--- linux-2.6-test.orig/kernel/Makefile
+++ linux-2.6-test/kernel/Makefile
@@ -21,7 +21,11 @@ obj-$(CONFIG_FUTEX) += futex.o
 ifeq ($(CONFIG_COMPAT),y)
 obj-$(CONFIG_FUTEX) += futex_compat.o
 endif
+ifeq ($(CONFIG_TASKLETS_AS_WORKQUEUES), y)
+obj-y += tasklet_work.o
+else
 obj-y += tasklet.o
+endif
 obj-$(CONFIG_RT_MUTEXES) += rtmutex.o
 obj-$(CONFIG_DEBUG_RT_MUTEXES) += rtmutex-debug.o
 obj-$(CONFIG_RT_MUTEX_TESTER) += rtmutex-tester.o
Index: linux-2.6-test/init/main.c
===================================================================
--- linux-2.6-test.orig/init/main.c
+++ linux-2.6-test/init/main.c
@@ -121,6 +121,11 @@ extern void time_init(void);
 /* Default late time init is NULL. archs can override this later. */
 void (*late_time_init)(void);
 extern void softirq_init(void);
+#ifdef CONFIG_TASKLETS_AS_WORKQUEUES
+  extern void init_tasklets(void);
+#else
+# define init_tasklets() do { } while(0)
+#endif
 
 /* Untouched command line saved by arch-specific code. */
 char __initdata boot_command_line[COMMAND_LINE_SIZE];
@@ -706,6 +711,7 @@ static void __init do_basic_setup(void)
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
@@ -1,6 +1,10 @@
 #ifndef _LINUX_TASKLET_H
 #define _LINUX_TASKLET_H
 
-#include <linux/tasklet_softirq.h>
+#ifdef CONFIG_TASKLETS_AS_WORKQUEUES
+# include <linux/tasklet_work.h>
+#else
+# include <linux/tasklet_softirq.h>
+#endif
 
 #endif
Index: linux-2.6-test/include/linux/tasklet_work.h
===================================================================
--- /dev/null
+++ linux-2.6-test/include/linux/tasklet_work.h
@@ -0,0 +1,62 @@
+#ifndef _LINUX_WORK_TASKLET_H
+#define _LINUX_WORK_TASKLET_H
+
+#ifndef _LINUX_INTERRUPT_H
+# error "Do not include this header directly! use linux/interrupt.h"
+#endif
+
+#include <linux/workqueue.h>
+
+extern void work_tasklet_exec(struct work_struct *work);
+
+struct tasklet_struct
+{
+	struct work_struct work;
+	struct list_head list;
+	unsigned long state;
+	atomic_t count;
+	void (*func)(unsigned long);
+	unsigned long data;
+	char *n;
+};
+
+#define DECLARE_TASKLET(name, func, data)				\
+	struct tasklet_struct name = {					\
+		__WORK_INITIALIZER((name).work, work_tasklet_exec),	\
+		LIST_HEAD_INIT((name).list),				\
+		0,							\
+		ATOMIC_INIT(0),						\
+		func,							\
+		data,							\
+		#name							\
+	}
+
+#define DECLARE_TASKLET_DISABLED(name, func, data)			\
+	struct tasklet_struct name = {					\
+		__WORK_INITIALIZER((name).work, work_tasklet_exec),	\
+		LIST_HEAD_INIT((name).list),				\
+		0,							\
+		ATOMIC_INIT(1),						\
+		func,							\
+		data,							\
+ 		#name							\
+	}
+
+void tasklet_schedule(struct tasklet_struct *t);
+#define tasklet_hi_schedule tasklet_schedule
+extern fastcall void tasklet_enable(struct tasklet_struct *t);
+#define tasklet_hi_enable tasklet_enable
+
+void tasklet_disable_nosync(struct tasklet_struct *t);
+void tasklet_disable(struct tasklet_struct *t);
+
+extern int tasklet_is_scheduled(struct tasklet_struct *t);
+
+extern void tasklet_kill(struct tasklet_struct *t);
+extern void tasklet_kill_immediate(struct tasklet_struct *t, unsigned int cpu);
+extern void tasklet_init(struct tasklet_struct *t,
+			 void (*func)(unsigned long), unsigned long data);
+void takeover_tasklets(unsigned int cpu);
+
+
+#endif /* _LINUX_WORK_TASKLET_H */
Index: linux-2.6-test/kernel/tasklet_work.c
===================================================================
--- /dev/null
+++ linux-2.6-test/kernel/tasklet_work.c
@@ -0,0 +1,138 @@
+/*
+ *	linux/kernel/work_tasklet.c
+ *
+ *	Copyright (C) 2007 Steven Rostedt, Red Hat
+ *
+ */
+
+#include <linux/interrupt.h>
+
+static struct workqueue_struct *ktaskletd_wq;
+
+enum
+{
+	TASKLET_STATE_SCHED,	/* Tasklet is scheduled for execution */
+	TASKLET_STATE_RUN,	/* Tasklet is running (SMP only) */
+	TASKLET_STATE_PENDING	/* Tasklet is pending */
+};
+
+#define TASKLET_STATEF_SCHED	(1 << TASKLET_STATE_SCHED)
+#define TASKLET_STATEF_RUN	(1 << TASKLET_STATE_RUN)
+#define TASKLET_STATEF_PENDING	(1 << TASKLET_STATE_PENDING)
+
+void tasklet_schedule(struct tasklet_struct *t)
+{
+	BUG_ON(!ktaskletd_wq);
+	pr_debug("scheduling tasklet %s %p\n", t->n, t);
+	queue_work(ktaskletd_wq, &t->work);
+}
+
+EXPORT_SYMBOL(tasklet_schedule);
+
+int tasklet_is_scheduled(struct tasklet_struct *t)
+{
+	int ret;
+	ret = work_pending(&t->work);
+	pr_debug("sched %s pending=%d\n", t->n, ret);
+	return ret;
+}
+
+EXPORT_SYMBOL(tasklet_is_scheduled);
+
+void tasklet_disable_nosync(struct tasklet_struct *t)
+{
+	pr_debug("disable tasklet %s %p\n", t->n, t);
+	atomic_inc(&t->count);
+	smp_mb__after_atomic_inc();
+}
+
+EXPORT_SYMBOL(tasklet_disable_nosync);
+
+void tasklet_disable(struct tasklet_struct *t)
+{
+	tasklet_disable_nosync(t);
+	pr_debug("flush tasklet %s %p\n", t->n, t);
+	flush_workqueue(ktaskletd_wq);
+	smp_mb();
+}
+
+EXPORT_SYMBOL(tasklet_disable);
+
+void work_tasklet_exec(struct work_struct *work)
+{
+	struct tasklet_struct *t =
+		container_of(work, struct tasklet_struct, work);
+
+	if (unlikely(atomic_read(&t->count))) {
+		pr_debug("tasklet disabled %s %p\n", t->n, t);
+		set_bit(TASKLET_STATE_PENDING, &t->state);
+		smp_mb();
+		/* make sure we were not just enabled */
+		if (likely(atomic_read(&t->count)))
+			goto out;
+		clear_bit(TASKLET_STATE_PENDING, &t->state);
+	}
+
+	local_bh_disable();
+	pr_debug("run tasklet %s %p\n", t->n, t);
+	t->func(t->data);
+	local_bh_enable();
+
+out:
+	return;
+}
+
+EXPORT_SYMBOL(work_tasklet_exec);
+
+void __init softirq_init(void)
+{
+}
+
+void init_tasklets(void)
+{
+	ktaskletd_wq = create_workqueue("tasklets");
+	BUG_ON(!ktaskletd_wq);
+}
+
+void takeover_tasklets(unsigned int cpu)
+{
+	pr_debug("Implement takeover tasklets??\n");
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
+
+EXPORT_SYMBOL(tasklet_init);
+
+void fastcall tasklet_enable(struct tasklet_struct *t)
+{
+	pr_debug("enable tasklet %s (count was %d)\n",
+		 t->n, atomic_read(&t->count));
+	if (!atomic_dec_and_test(&t->count))
+		return;
+	if (test_and_clear_bit(TASKLET_STATE_PENDING, &t->state)) {
+		pr_debug("tasklet %s was pending\n", t->n);
+		tasklet_schedule(t);
+	}
+}
+
+EXPORT_SYMBOL(tasklet_enable);
+
+void tasklet_kill(struct tasklet_struct *t)
+{
+	pr_debug("kill tasklet %s\n", t->n);
+	flush_workqueue(ktaskletd_wq);
+}
+
+EXPORT_SYMBOL(tasklet_kill);

-- 
