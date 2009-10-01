Return-Path: <linux-kernel-owner+w=401wt.eu-S932123AbZJAINn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123AbZJAINn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 04:13:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932116AbZJAINl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 04:13:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:38399 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755804AbZJAIKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 04:10:33 -0400
From: Tejun Heo <tj@kernel.org>
To: jeff@garzik.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 03/19] scheduler: implement workqueue scheduler class
Date: Thu,  1 Oct 2009 17:09:02 +0900
Message-Id: <1254384558-1018-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1254384558-1018-1-git-send-email-tj@kernel.org>
References: <1254384558-1018-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 01 Oct 2009 08:09:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement workqueue scheduler class.  Workqueue sched_class inherits
fair sched_class and behaves exactly the same as sched_class except
that it has two callback functions which get called when a task is put
to sleep and wakes up and doesn't allow switching to different
scheduler class.

workqueue sched_class can only be selected by calling
switch_sched_workqueue() when the current sched_class is fair.
workqueue is updated to select workqueue sched_class for all workers.
Both scheduler callbacks are noop now.  They'll be used to implement
concurrency-managed workqueue.

This patch also updates current_is_keventd() to check for the
scheduler class instead of directly matching the keventd workers, so
the function will return true for any workqueue workers.  For the
current users, this shouldn't be a problem.

NOT_SIGNED_OFF_YET
---
 include/linux/sched.h    |    1 +
 kernel/sched.c           |    1 +
 kernel/sched_fair.c      |   59 +++++++++++++--------
 kernel/sched_workqueue.c |  130 ++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched_workqueue.h |   17 ++++++
 kernel/workqueue.c       |   34 ++++++++----
 6 files changed, 207 insertions(+), 35 deletions(-)
 create mode 100644 kernel/sched_workqueue.c
 create mode 100644 kernel/sched_workqueue.h

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 02f505d..cbebadf 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1952,6 +1952,7 @@ extern int idle_cpu(int cpu);
 extern int sched_setscheduler(struct task_struct *, int, struct sched_param *);
 extern int sched_setscheduler_nocheck(struct task_struct *, int,
 				      struct sched_param *);
+extern void sched_setscheduler_workqueue(struct task_struct *p);
 extern struct task_struct *idle_task(int cpu);
 extern struct task_struct *curr_task(int cpu);
 extern void set_curr_task(int cpu, struct task_struct *p);
diff --git a/kernel/sched.c b/kernel/sched.c
index 66d918a..4e3e789 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1819,6 +1819,7 @@ static void calc_load_account_active(struct rq *this_rq);
 #include "sched_idletask.c"
 #include "sched_fair.c"
 #include "sched_rt.c"
+#include "sched_workqueue.c"
 #ifdef CONFIG_SCHED_DEBUG
 # include "sched_debug.c"
 #endif
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index a12d1bd..eb116f0 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1961,37 +1961,50 @@ unsigned int get_rr_interval_fair(struct task_struct *task)
 /*
  * All the scheduling class methods:
  */
-static const struct sched_class fair_sched_class = {
-	.identity		= &fair_sched_class,
-	.next			= &idle_sched_class,
-	.enqueue_task		= enqueue_task_fair,
-	.dequeue_task		= dequeue_task_fair,
-	.yield_task		= yield_task_fair,
-
-	.check_preempt_curr	= check_preempt_wakeup,
-
-	.pick_next_task		= pick_next_task_fair,
-	.put_prev_task		= put_prev_task_fair,
+#define FAIR_SCHED_CLASS_INIT_BASE					\
+	.identity		= &fair_sched_class,			\
+	.next			= &idle_sched_class,			\
+	.enqueue_task		= enqueue_task_fair,			\
+	.dequeue_task		= dequeue_task_fair,			\
+	.yield_task		= yield_task_fair,			\
+									\
+	.check_preempt_curr	= check_preempt_wakeup,			\
+									\
+	.pick_next_task		= pick_next_task_fair,			\
+	.put_prev_task		= put_prev_task_fair,			\
+									\
+	.set_curr_task          = set_curr_task_fair,			\
+	.task_tick		= task_tick_fair,			\
+	.task_new		= task_new_fair,			\
+									\
+	.prio_changed		= prio_changed_fair,			\
+	.switched_to		= switched_to_fair,			\
+									\
+	.get_rr_interval	= get_rr_interval_fair,
 
 #ifdef CONFIG_SMP
-	.select_task_rq		= select_task_rq_fair,
-
-	.load_balance		= load_balance_fair,
+#define FAIR_SCHED_CLASS_INIT_SMP					\
+	.select_task_rq		= select_task_rq_fair,			\
+	.load_balance		= load_balance_fair,			\
 	.move_one_task		= move_one_task_fair,
+#else
+#define FAIR_SCHED_CLASS_INIT_SMP
 #endif
 
-	.set_curr_task          = set_curr_task_fair,
-	.task_tick		= task_tick_fair,
-	.task_new		= task_new_fair,
-
-	.prio_changed		= prio_changed_fair,
-	.switched_to		= switched_to_fair,
-
-	.get_rr_interval	= get_rr_interval_fair,
-
 #ifdef CONFIG_FAIR_GROUP_SCHED
+#define FAIR_SCHED_CLASS_INIT_GROUP					\
 	.moved_group		= moved_group_fair,
+#else
+#define FAIR_SCHED_CLASS_INIT_GROUP
 #endif
+
+#define FAIR_SCHED_CLASS_INIT						\
+	FAIR_SCHED_CLASS_INIT_BASE					\
+	FAIR_SCHED_CLASS_INIT_SMP					\
+	FAIR_SCHED_CLASS_INIT_GROUP
+
+static const struct sched_class fair_sched_class = {
+	FAIR_SCHED_CLASS_INIT
 };
 
 #ifdef CONFIG_SCHED_DEBUG
diff --git a/kernel/sched_workqueue.c b/kernel/sched_workqueue.c
new file mode 100644
index 0000000..d8d6cb2
--- /dev/null
+++ b/kernel/sched_workqueue.c
@@ -0,0 +1,130 @@
+/*
+ * kernel/sched_workqueue.c - workqueue scheduler class
+ *
+ * Copyright (C) 2009		SUSE Linux Products GmbH
+ * Copyright (C) 2009		Tejun Heo <tj@kernel.org>
+ *
+ * This file is released under the GPLv2.
+ *
+ * This scheduler class wraps the fair class and provide scheduling
+ * hints to workqueue to help it maintain proper level of concurrency.
+ * Other than calling workqueue hook functions and disallowing
+ * switching to other classes, this scheduler class is identical to
+ * the fair class.
+ */
+#include "sched_workqueue.h"
+
+static void enqueue_task_wq(struct rq *rq, struct task_struct *p, int wakeup)
+{
+	if (wakeup)
+		sched_workqueue_worker_wakeup(p);
+
+	return enqueue_task_fair(rq, p, wakeup);
+}
+
+static void dequeue_task_wq(struct rq *rq, struct task_struct *p, int sleep)
+{
+	if (sleep)
+		sched_workqueue_worker_sleep(p);
+
+	return dequeue_task_fair(rq, p, sleep);
+}
+
+static void switched_from_wq(struct rq *this_rq, struct task_struct *task,
+			     int running)
+{
+	BUG();	/* no can do */
+}
+
+/*
+ * If you want to add more override methods, please check sched.c
+ * _CAREFULLY_ before doing so.  There are several places where fair
+ * sched specific optimizations are made and the overrides might not
+ * work as expected.
+ */
+static const struct sched_class workqueue_sched_class = {
+	FAIR_SCHED_CLASS_INIT
+	.enqueue_task		= enqueue_task_wq,
+	.dequeue_task		= dequeue_task_wq,
+	.switched_from		= switched_from_wq,
+};
+
+/**
+ * sched_workqueue_wake_up_process - wake up a process from sched callbacks
+ * @p: task to wake up
+ *
+ * Wake up @p.  This function can only be called from workqueue
+ * scheduler callbacks and can only wake up tasks which are bound to
+ * the cpu in question.
+ *
+ * CONTEXT:
+ * workqueue scheduler callbacks.
+ *
+ * RETURNS:
+ * true if @p was waken up, false if @p was already awake.
+ */
+bool sched_workqueue_wake_up_process(struct task_struct *p)
+{
+	struct rq *rq = task_rq(p);
+	bool success = false;
+
+	assert_spin_locked(&rq->lock);
+
+	if (!p->se.on_rq) {
+		schedstat_inc(p, se.nr_wakeups);
+		schedstat_inc(p, se.nr_wakeups_local);
+		activate_task(rq, p, 1);
+		success = true;
+	}
+
+	trace_sched_wakeup(rq, p, success);
+	p->state = TASK_RUNNING;
+#ifdef CONFIG_SMP
+	if (p->sched_class->task_wake_up)
+		p->sched_class->task_wake_up(rq, p);
+#endif
+	return success;
+}
+
+/**
+ * switch_sched_workqueue - switch workqueue scheduler class
+ * @p: target task
+ * @enable: enable or disable sched_workqueue
+ *
+ * Switch @p to or from workqueue scheduler class.  @p is assumed to
+ * have either fair or one of its alias classes on entry.
+ *
+ * CONTEXT:
+ * !in_interrupt().
+ */
+void switch_sched_workqueue(struct task_struct *p, bool enable)
+{
+	struct sched_param sched_param = { .sched_priority = 0 };
+	struct rq *rq;
+	unsigned long flags;
+
+	rq = task_rq_lock(p, &flags);
+	BUG_ON(!sched_class_equal(p->sched_class, &fair_sched_class));
+	p->sched_class = enable ? &workqueue_sched_class : &fair_sched_class;
+	task_rq_unlock(rq, &flags);
+
+	BUG_ON(sched_setscheduler_nocheck(p, SCHED_NORMAL, &sched_param));
+}
+
+/**
+ * is_sched_workqueue - test whether a task is in workqueue scheduler class
+ * @p: target task
+ *
+ * Tests whether @p is in workqueue scheduler class.
+ *
+ * CONTEXT:
+ * The caller is responsible for ensuring that @p doesn't go away or
+ * change scheduler class.
+ *
+ * RETURNS:
+ * true if @p is in workerqueue scheduler class, false otherwise.
+ */
+bool is_sched_workqueue(struct task_struct *p)
+{
+	return p->sched_class == &workqueue_sched_class;
+}
diff --git a/kernel/sched_workqueue.h b/kernel/sched_workqueue.h
new file mode 100644
index 0000000..5a52a4f
--- /dev/null
+++ b/kernel/sched_workqueue.h
@@ -0,0 +1,17 @@
+/*
+ * kernel/sched_workqueue.h - workqueue scheduler class interface
+ *
+ * Copyright (C) 2009		SUSE Linux Products GmbH
+ * Copyright (C) 2009		Tejun Heo <tj@kernel.org>
+ *
+ * This file is released under the GPLv2.
+ *
+ * This is interface between sched_workqueue and workqueue.  Read
+ * comments in sched_workqueue.c and workqueue.c for details.
+ */
+void sched_workqueue_worker_wakeup(struct task_struct *task);
+void sched_workqueue_worker_sleep(struct task_struct *task);
+
+bool sched_workqueue_wake_up_process(struct task_struct *p);
+void switch_sched_workqueue(struct task_struct *p, bool enable);
+bool is_sched_workqueue(struct task_struct *p);
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index addfe2d..b56737b 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -36,6 +36,8 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/workqueue.h>
 
+#include "sched_workqueue.h"
+
 /*
  * The per-CPU workqueue (if single thread, we always use the first
  * possible cpu).
@@ -125,6 +127,22 @@ struct cpu_workqueue_struct *get_wq_data(struct work_struct *work)
 	return (void *) (atomic_long_read(&work->data) & WORK_STRUCT_WQ_DATA_MASK);
 }
 
+/*
+ * Scheduler callbacks.  These functions are called during schedule()
+ * with rq lock held.  Don't try to acquire any lock and only access
+ * fields which are safe with preemption disabled from local cpu.
+ */
+
+/* called when a worker task wakes up from sleep */
+void sched_workqueue_worker_wakeup(struct task_struct *task)
+{
+}
+
+/* called when a worker task goes into sleep */
+void sched_workqueue_worker_sleep(struct task_struct *task)
+{
+}
+
 static void insert_work(struct cpu_workqueue_struct *cwq,
 			struct work_struct *work, struct list_head *head)
 {
@@ -314,6 +332,9 @@ static int worker_thread(void *__cwq)
 	struct cpu_workqueue_struct *cwq = __cwq;
 	DEFINE_WAIT(wait);
 
+	/* set workqueue scheduler */
+	switch_sched_workqueue(current, true);
+
 	if (cwq->wq->freezeable)
 		set_freezable();
 
@@ -726,18 +747,7 @@ int keventd_up(void)
 
 int current_is_keventd(void)
 {
-	struct cpu_workqueue_struct *cwq;
-	int cpu = raw_smp_processor_id(); /* preempt-safe: keventd is per-cpu */
-	int ret = 0;
-
-	BUG_ON(!keventd_wq);
-
-	cwq = per_cpu_ptr(keventd_wq->cpu_wq, cpu);
-	if (current == cwq->thread)
-		ret = 1;
-
-	return ret;
-
+	return is_sched_workqueue(current);
 }
 
 static struct cpu_workqueue_struct *
-- 
1.6.4.2

