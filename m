Return-Path: <linux-kernel-owner+w=401wt.eu-S1751881AbXFVEES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881AbXFVEES (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 00:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751157AbXFVEEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 00:04:04 -0400
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:61944 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbXFVEED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 00:04:03 -0400
Message-Id: <20070622040136.783692883@goodmis.org>
References: <20070622040014.234651401@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 22 Jun 2007 00:00:16 -0400
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
Subject: [RFC PATCH 2/6] Split out tasklets from softirq.c
Content-Disposition: inline; filename=split-out-tasklet.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tasklets are really a separate entity from softirqs, so they
deserve their own file. Also this allows us to easily replace
tasklets for something else ;-)

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-2.6-test/include/linux/interrupt.h
===================================================================
--- linux-2.6-test.orig/include/linux/interrupt.h
+++ linux-2.6-test/include/linux/interrupt.h
@@ -13,6 +13,7 @@
 #include <linux/irqflags.h>
 #include <linux/bottom_half.h>
 #include <linux/device.h>
+#include <linux/tasklet.h>
 #include <asm/atomic.h>
 #include <asm/ptrace.h>
 #include <asm/system.h>
@@ -268,117 +269,6 @@ extern void FASTCALL(raise_softirq_irqof
 extern void FASTCALL(raise_softirq(unsigned int nr));
 
 
-/* Tasklets --- multithreaded analogue of BHs.
-
-   Main feature differing them of generic softirqs: tasklet
-   is running only on one CPU simultaneously.
-
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
-
-struct tasklet_struct
-{
-	struct tasklet_struct *next;
-	unsigned long state;
-	atomic_t count;
-	void (*func)(unsigned long);
-	unsigned long data;
-};
-
-#define DECLARE_TASKLET(name, func, data) \
-struct tasklet_struct name = { NULL, 0, ATOMIC_INIT(0), func, data }
-
-#define DECLARE_TASKLET_DISABLED(name, func, data) \
-struct tasklet_struct name = { NULL, 0, ATOMIC_INIT(1), func, data }
-
-
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
-
-static inline void tasklet_schedule(struct tasklet_struct *t)
-{
-	if (!test_and_set_bit(TASKLET_STATE_SCHED, &t->state))
-		__tasklet_schedule(t);
-}
-
-extern void FASTCALL(__tasklet_hi_schedule(struct tasklet_struct *t));
-
-static inline void tasklet_hi_schedule(struct tasklet_struct *t)
-{
-	if (!test_and_set_bit(TASKLET_STATE_SCHED, &t->state))
-		__tasklet_hi_schedule(t);
-}
-
-
-static inline void tasklet_disable_nosync(struct tasklet_struct *t)
-{
-	atomic_inc(&t->count);
-	smp_mb__after_atomic_inc();
-}
-
-static inline void tasklet_disable(struct tasklet_struct *t)
-{
-	tasklet_disable_nosync(t);
-	tasklet_unlock_wait(t);
-	smp_mb();
-}
-
-static inline void tasklet_enable(struct tasklet_struct *t)
-{
-	smp_mb__before_atomic_dec();
-	atomic_dec(&t->count);
-}
-
-static inline void tasklet_hi_enable(struct tasklet_struct *t)
-{
-	smp_mb__before_atomic_dec();
-	atomic_dec(&t->count);
-}
-
-extern void tasklet_kill(struct tasklet_struct *t);
-extern void tasklet_kill_immediate(struct tasklet_struct *t, unsigned int cpu);
-extern void tasklet_init(struct tasklet_struct *t,
-			 void (*func)(unsigned long), unsigned long data);
-
 /*
  * Autoprobing for irqs:
  *
Index: linux-2.6-test/include/linux/tasklet.h
===================================================================
--- /dev/null
+++ linux-2.6-test/include/linux/tasklet.h
@@ -0,0 +1,120 @@
+#ifndef _LINUX_TASKLET_H
+#define _LINUX_TASKLET_H
+
+/* Tasklets --- multithreaded analogue of BHs.
+
+   Main feature differing them of generic softirqs: tasklet
+   is running only on one CPU simultaneously.
+
+   Main feature differing them of BHs: different tasklets
+   may be run simultaneously on different CPUs.
+
+   Properties:
+   * If tasklet_schedule() is called, then tasklet is guaranteed
+     to be executed on some cpu at least once after this.
+   * If the tasklet is already scheduled, but its excecution is still not
+     started, it will be executed only once.
+   * If this tasklet is already running on another CPU (or schedule is called
+     from tasklet itself), it is rescheduled for later.
+   * Tasklet is strictly serialized wrt itself, but not
+     wrt another tasklets. If client needs some intertask synchronization,
+     he makes it with spinlocks.
+ */
+
+struct tasklet_struct
+{
+	struct tasklet_struct *next;
+	unsigned long state;
+	atomic_t count;
+	void (*func)(unsigned long);
+	unsigned long data;
+};
+
+#define DECLARE_TASKLET(name, func, data) \
+struct tasklet_struct name = { NULL, 0, ATOMIC_INIT(0), func, data }
+
+#define DECLARE_TASKLET_DISABLED(name, func, data) \
+struct tasklet_struct name = { NULL, 0, ATOMIC_INIT(1), func, data }
+
+
+enum
+{
+	TASKLET_STATE_SCHED,	/* Tasklet is scheduled for execution */
+	TASKLET_STATE_RUN	/* Tasklet is running (SMP only) */
+};
+
+#ifdef CONFIG_SMP
+static inline int tasklet_trylock(struct tasklet_struct *t)
+{
+	return !test_and_set_bit(TASKLET_STATE_RUN, &(t)->state);
+}
+
+static inline void tasklet_unlock(struct tasklet_struct *t)
+{
+	smp_mb__before_clear_bit(); 
+	clear_bit(TASKLET_STATE_RUN, &(t)->state);
+}
+
+static inline void tasklet_unlock_wait(struct tasklet_struct *t)
+{
+	while (test_bit(TASKLET_STATE_RUN, &(t)->state)) { barrier(); }
+}
+#else
+#define tasklet_trylock(t) 1
+#define tasklet_unlock_wait(t) do { } while (0)
+#define tasklet_unlock(t) do { } while (0)
+#endif
+
+extern void FASTCALL(__tasklet_schedule(struct tasklet_struct *t));
+
+static inline void tasklet_schedule(struct tasklet_struct *t)
+{
+	if (!test_and_set_bit(TASKLET_STATE_SCHED, &t->state))
+		__tasklet_schedule(t);
+}
+
+extern void FASTCALL(__tasklet_hi_schedule(struct tasklet_struct *t));
+
+static inline void tasklet_hi_schedule(struct tasklet_struct *t)
+{
+	if (!test_and_set_bit(TASKLET_STATE_SCHED, &t->state))
+		__tasklet_hi_schedule(t);
+}
+
+
+static inline void tasklet_disable_nosync(struct tasklet_struct *t)
+{
+	atomic_inc(&t->count);
+	smp_mb__after_atomic_inc();
+}
+
+static inline void tasklet_disable(struct tasklet_struct *t)
+{
+	tasklet_disable_nosync(t);
+	tasklet_unlock_wait(t);
+	smp_mb();
+}
+
+static inline void tasklet_enable(struct tasklet_struct *t)
+{
+	smp_mb__before_atomic_dec();
+	atomic_dec(&t->count);
+}
+
+static inline void tasklet_hi_enable(struct tasklet_struct *t)
+{
+	smp_mb__before_atomic_dec();
+	atomic_dec(&t->count);
+}
+
+extern void tasklet_kill(struct tasklet_struct *t);
+extern void tasklet_kill_immediate(struct tasklet_struct *t, unsigned int cpu);
+extern void tasklet_init(struct tasklet_struct *t,
+			 void (*func)(unsigned long), unsigned long data);
+
+#ifdef CONFIG_HOTPLUG_CPU
+void takeover_tasklets(unsigned int cpu);
+#endif /* CONFIG_HOTPLUG_CPU */
+
+#endif /* _LINUX_TASKLET_H */
+
Index: linux-2.6-test/kernel/Makefile
===================================================================
--- linux-2.6-test.orig/kernel/Makefile
+++ linux-2.6-test/kernel/Makefile
@@ -21,6 +21,7 @@ obj-$(CONFIG_FUTEX) += futex.o
 ifeq ($(CONFIG_COMPAT),y)
 obj-$(CONFIG_FUTEX) += futex_compat.o
 endif
+obj-y += tasklet.o
 obj-$(CONFIG_RT_MUTEXES) += rtmutex.o
 obj-$(CONFIG_DEBUG_RT_MUTEXES) += rtmutex-debug.o
 obj-$(CONFIG_RT_MUTEX_TESTER) += rtmutex-tester.o
Index: linux-2.6-test/kernel/softirq.c
===================================================================
--- linux-2.6-test.orig/kernel/softirq.c
+++ linux-2.6-test/kernel/softirq.c
@@ -348,144 +348,6 @@ void open_softirq(int nr, void (*action)
 	softirq_vec[nr].action = action;
 }
 
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
 static int ksoftirqd(void * __bind_cpu)
 {
 	set_user_nice(current, 19);
@@ -532,58 +394,6 @@ wait_to_die:
 	return 0;
 }
 
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
-static void takeover_tasklets(unsigned int cpu)
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
 static int __cpuinit cpu_callback(struct notifier_block *nfb,
 				  unsigned long action,
 				  void *hcpu)
Index: linux-2.6-test/kernel/tasklet.c
===================================================================
--- /dev/null
+++ linux-2.6-test/kernel/tasklet.c
@@ -0,0 +1,203 @@
+/*
+ *	linux/kernel/softirq.c
+ *
+ *	Copyright (C) 1992 Linus Torvalds
+ *
+ * Rewritten. Old one was good in 2.2, but in 2.3 it was immoral. --ANK (990903)
+ *
+ *      Removed from softirq.c by Steven Rostedt
+ */
+#include <linux/interrupt.h>
+#include <linux/cpu.h>
+
+/* Tasklets */
+struct tasklet_head
+{
+	struct tasklet_struct *list;
+};
+
+/* Some compilers disobey section attribute on statics when not
+   initialized -- RR */
+static DEFINE_PER_CPU(struct tasklet_head, tasklet_vec) = { NULL };
+static DEFINE_PER_CPU(struct tasklet_head, tasklet_hi_vec) = { NULL };
+
+void fastcall __tasklet_schedule(struct tasklet_struct *t)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	t->next = __get_cpu_var(tasklet_vec).list;
+	__get_cpu_var(tasklet_vec).list = t;
+	raise_softirq_irqoff(TASKLET_SOFTIRQ);
+	local_irq_restore(flags);
+}
+
+EXPORT_SYMBOL(__tasklet_schedule);
+
+void fastcall __tasklet_hi_schedule(struct tasklet_struct *t)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	t->next = __get_cpu_var(tasklet_hi_vec).list;
+	__get_cpu_var(tasklet_hi_vec).list = t;
+	raise_softirq_irqoff(HI_SOFTIRQ);
+	local_irq_restore(flags);
+}
+
+EXPORT_SYMBOL(__tasklet_hi_schedule);
+
+static void tasklet_action(struct softirq_action *a)
+{
+	struct tasklet_struct *list;
+
+	local_irq_disable();
+	list = __get_cpu_var(tasklet_vec).list;
+	__get_cpu_var(tasklet_vec).list = NULL;
+	local_irq_enable();
+
+	while (list) {
+		struct tasklet_struct *t = list;
+
+		list = list->next;
+
+		if (tasklet_trylock(t)) {
+			if (!atomic_read(&t->count)) {
+				if (!test_and_clear_bit(TASKLET_STATE_SCHED, &t->state))
+					BUG();
+				t->func(t->data);
+				tasklet_unlock(t);
+				continue;
+			}
+			tasklet_unlock(t);
+		}
+
+		local_irq_disable();
+		t->next = __get_cpu_var(tasklet_vec).list;
+		__get_cpu_var(tasklet_vec).list = t;
+		__raise_softirq_irqoff(TASKLET_SOFTIRQ);
+		local_irq_enable();
+	}
+}
+
+static void tasklet_hi_action(struct softirq_action *a)
+{
+	struct tasklet_struct *list;
+
+	local_irq_disable();
+	list = __get_cpu_var(tasklet_hi_vec).list;
+	__get_cpu_var(tasklet_hi_vec).list = NULL;
+	local_irq_enable();
+
+	while (list) {
+		struct tasklet_struct *t = list;
+
+		list = list->next;
+
+		if (tasklet_trylock(t)) {
+			if (!atomic_read(&t->count)) {
+				if (!test_and_clear_bit(TASKLET_STATE_SCHED, &t->state))
+					BUG();
+				t->func(t->data);
+				tasklet_unlock(t);
+				continue;
+			}
+			tasklet_unlock(t);
+		}
+
+		local_irq_disable();
+		t->next = __get_cpu_var(tasklet_hi_vec).list;
+		__get_cpu_var(tasklet_hi_vec).list = t;
+		__raise_softirq_irqoff(HI_SOFTIRQ);
+		local_irq_enable();
+	}
+}
+
+
+void tasklet_init(struct tasklet_struct *t,
+		  void (*func)(unsigned long), unsigned long data)
+{
+	t->next = NULL;
+	t->state = 0;
+	atomic_set(&t->count, 0);
+	t->func = func;
+	t->data = data;
+}
+
+EXPORT_SYMBOL(tasklet_init);
+
+void tasklet_kill(struct tasklet_struct *t)
+{
+	if (in_interrupt())
+		printk("Attempt to kill tasklet from interrupt\n");
+
+	while (test_and_set_bit(TASKLET_STATE_SCHED, &t->state)) {
+		do
+			yield();
+		while (test_bit(TASKLET_STATE_SCHED, &t->state));
+	}
+	tasklet_unlock_wait(t);
+	clear_bit(TASKLET_STATE_SCHED, &t->state);
+}
+
+EXPORT_SYMBOL(tasklet_kill);
+
+void __init softirq_init(void)
+{
+	open_softirq(TASKLET_SOFTIRQ, tasklet_action, NULL);
+	open_softirq(HI_SOFTIRQ, tasklet_hi_action, NULL);
+}
+
+#ifdef CONFIG_HOTPLUG_CPU
+/*
+ * tasklet_kill_immediate is called to remove a tasklet which can already be
+ * scheduled for execution on @cpu.
+ *
+ * Unlike tasklet_kill, this function removes the tasklet
+ * _immediately_, even if the tasklet is in TASKLET_STATE_SCHED state.
+ *
+ * When this function is called, @cpu must be in the CPU_DEAD state.
+ */
+void tasklet_kill_immediate(struct tasklet_struct *t, unsigned int cpu)
+{
+	struct tasklet_struct **i;
+
+	BUG_ON(cpu_online(cpu));
+	BUG_ON(test_bit(TASKLET_STATE_RUN, &t->state));
+
+	if (!test_bit(TASKLET_STATE_SCHED, &t->state))
+		return;
+
+	/* CPU is dead, so no lock needed. */
+	for (i = &per_cpu(tasklet_vec, cpu).list; *i; i = &(*i)->next) {
+		if (*i == t) {
+			*i = t->next;
+			return;
+		}
+	}
+	BUG();
+}
+
+void takeover_tasklets(unsigned int cpu)
+{
+	struct tasklet_struct **i;
+
+	/* CPU is dead, so no lock needed. */
+	local_irq_disable();
+
+	/* Find end, append list for that CPU. */
+	for (i = &__get_cpu_var(tasklet_vec).list; *i; i = &(*i)->next);
+	*i = per_cpu(tasklet_vec, cpu).list;
+	per_cpu(tasklet_vec, cpu).list = NULL;
+	raise_softirq_irqoff(TASKLET_SOFTIRQ);
+
+	for (i = &__get_cpu_var(tasklet_hi_vec).list; *i; i = &(*i)->next);
+	*i = per_cpu(tasklet_hi_vec, cpu).list;
+	per_cpu(tasklet_hi_vec, cpu).list = NULL;
+	raise_softirq_irqoff(HI_SOFTIRQ);
+
+	local_irq_enable();
+}
+#endif /* CONFIG_HOTPLUG_CPU */
+
+

-- 
