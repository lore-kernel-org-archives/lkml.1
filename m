Return-Path: <linux-kernel-owner+w=401wt.eu-S1755569Ab0ARA6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569Ab0ARA6q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 19:58:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755337Ab0ARAxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 19:53:32 -0500
Received: from hera.kernel.org ([140.211.167.34]:54376 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755335Ab0ARAxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 19:53:30 -0500
From: Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 21/40] workqueue: reimplement workqueue freeze using max_active
Date: Mon, 18 Jan 2010 09:57:33 +0900
Message-Id: <1263776272-382-22-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1263776272-382-1-git-send-email-tj@kernel.org>
References: <1263776272-382-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 18 Jan 2010 00:52:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, workqueue freezing is implemented by marking the worker
freezeable and calling try_to_freeze() from dispatch loop.
Reimplement it using cwq->limit so that the workqueue is frozen
instead of the worker.

* workqueue_struct->saved_max_active is added which stores the
  specified max_active on initialization.

* On freeze, all cwq->max_active's are quenched to zero.  Freezing is
  complete when nr_active on all cwqs reach zero.

* On thaw, all cwq->max_active's are restored to wq->saved_max_active
  and the worklist is repopulated.

This new implementation allows having single shared pool of workers
per cpu.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/workqueue.h |    7 ++
 kernel/power/process.c    |   21 +++++-
 kernel/workqueue.c        |  163 ++++++++++++++++++++++++++++++++++++++++++---
 3 files changed, 179 insertions(+), 12 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 974a232..7a260df 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -331,4 +331,11 @@ static inline long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg)
 #else
 long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg);
 #endif /* CONFIG_SMP */
+
+#ifdef CONFIG_FREEZER
+extern void freeze_workqueues_begin(void);
+extern bool freeze_workqueues_busy(void);
+extern void thaw_workqueues(void);
+#endif /* CONFIG_FREEZER */
+
 #endif
diff --git a/kernel/power/process.c b/kernel/power/process.c
index 5ade1bd..6f89afd 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -15,6 +15,7 @@
 #include <linux/syscalls.h>
 #include <linux/freezer.h>
 #include <linux/delay.h>
+#include <linux/workqueue.h>
 
 /* 
  * Timeout for stopping processes
@@ -35,6 +36,7 @@ static int try_to_freeze_tasks(bool sig_only)
 	struct task_struct *g, *p;
 	unsigned long end_time;
 	unsigned int todo;
+	bool wq_busy = false;
 	struct timeval start, end;
 	u64 elapsed_csecs64;
 	unsigned int elapsed_csecs;
@@ -42,6 +44,10 @@ static int try_to_freeze_tasks(bool sig_only)
 	do_gettimeofday(&start);
 
 	end_time = jiffies + TIMEOUT;
+
+	if (!sig_only)
+		freeze_workqueues_begin();
+
 	while (true) {
 		todo = 0;
 		read_lock(&tasklist_lock);
@@ -63,6 +69,12 @@ static int try_to_freeze_tasks(bool sig_only)
 				todo++;
 		} while_each_thread(g, p);
 		read_unlock(&tasklist_lock);
+
+		if (!sig_only) {
+			wq_busy = freeze_workqueues_busy();
+			todo += wq_busy;
+		}
+
 		if (!todo || time_after(jiffies, end_time))
 			break;
 
@@ -86,9 +98,13 @@ static int try_to_freeze_tasks(bool sig_only)
 		 */
 		printk("\n");
 		printk(KERN_ERR "Freezing of tasks failed after %d.%02d seconds "
-				"(%d tasks refusing to freeze):\n",
-				elapsed_csecs / 100, elapsed_csecs % 100, todo);
+		       "(%d tasks refusing to freeze, wq_busy=%d):\n",
+		       elapsed_csecs / 100, elapsed_csecs % 100,
+		       todo - wq_busy, wq_busy);
 		show_state();
+
+		thaw_workqueues();
+
 		read_lock(&tasklist_lock);
 		do_each_thread(g, p) {
 			task_lock(p);
@@ -158,6 +174,7 @@ void thaw_processes(void)
 	oom_killer_enable();
 
 	printk("Restarting tasks ... ");
+	thaw_workqueues();
 	thaw_tasks(true);
 	thaw_tasks(false);
 	schedule();
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 0c9c01d..eca3925 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -78,7 +78,7 @@ struct cpu_workqueue_struct {
 	int			nr_in_flight[WORK_NR_COLORS];
 						/* L: nr of in_flight works */
 	int			nr_active;	/* L: nr of active works */
-	int			max_active;	/* I: max active works */
+	int			max_active;	/* L: max active works */
 	struct list_head	delayed_works;	/* L: delayed works */
 };
 
@@ -108,6 +108,7 @@ struct workqueue_struct {
 	struct list_head	flusher_queue;	/* F: flush waiters */
 	struct list_head	flusher_overflow; /* F: flush overflow list */
 
+	int			saved_max_active; /* I: saved cwq max_active */
 	const char		*name;		/* I: workqueue name */
 #ifdef CONFIG_LOCKDEP
 	struct lockdep_map	lockdep_map;
@@ -228,6 +229,7 @@ static inline void debug_work_deactivate(struct work_struct *work) { }
 static DEFINE_SPINLOCK(workqueue_lock);
 static LIST_HEAD(workqueues);
 static DEFINE_PER_CPU(struct ida, worker_ida);
+static bool workqueue_freezing;		/* W: have wqs started freezing? */
 
 static int worker_thread(void *__worker);
 
@@ -739,19 +741,13 @@ static int worker_thread(void *__worker)
 	struct cpu_workqueue_struct *cwq = worker->cwq;
 	DEFINE_WAIT(wait);
 
-	if (cwq->wq->flags & WQ_FREEZEABLE)
-		set_freezable();
-
 	for (;;) {
 		prepare_to_wait(&cwq->more_work, &wait, TASK_INTERRUPTIBLE);
-		if (!freezing(current) &&
-		    !kthread_should_stop() &&
+		if (!kthread_should_stop() &&
 		    list_empty(&cwq->worklist))
 			schedule();
 		finish_wait(&cwq->more_work, &wait);
 
-		try_to_freeze();
-
 		if (kthread_should_stop())
 			break;
 
@@ -1504,6 +1500,7 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
 		goto err;
 
 	wq->flags = flags;
+	wq->saved_max_active = max_active;
 	mutex_init(&wq->flush_mutex);
 	atomic_set(&wq->nr_cwqs_to_flush, 0);
 	INIT_LIST_HEAD(&wq->flusher_queue);
@@ -1548,8 +1545,19 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
 		wq = NULL;
 	}
 
+	/*
+	 * workqueue_lock protects global freeze state and workqueues
+	 * list.  Grab it, set max_active accordingly and add the new
+	 * workqueue to workqueues list.
+	 */
 	spin_lock(&workqueue_lock);
+
+	if (workqueue_freezing && wq->flags & WQ_FREEZEABLE)
+		for_each_possible_cpu(cpu)
+			get_cwq(cpu, wq)->max_active = 0;
+
 	list_add(&wq->list, &workqueues);
+
 	spin_unlock(&workqueue_lock);
 
 	return wq;
@@ -1572,12 +1580,16 @@ void destroy_workqueue(struct workqueue_struct *wq)
 {
 	int cpu;
 
+	flush_workqueue(wq);
+
+	/*
+	 * wq list is used to freeze wq, remove from list after
+	 * flushing is complete in case freeze races us.
+	 */
 	spin_lock(&workqueue_lock);
 	list_del(&wq->list);
 	spin_unlock(&workqueue_lock);
 
-	flush_workqueue(wq);
-
 	for_each_possible_cpu(cpu) {
 		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
 		int i;
@@ -1676,6 +1688,137 @@ long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg)
 EXPORT_SYMBOL_GPL(work_on_cpu);
 #endif /* CONFIG_SMP */
 
+#ifdef CONFIG_FREEZER
+
+/**
+ * freeze_workqueues_begin - begin freezing workqueues
+ *
+ * Start freezing workqueues.  After this function returns, all
+ * freezeable workqueues will queue new works to their frozen_works
+ * list instead of the cwq ones.
+ *
+ * CONTEXT:
+ * Grabs and releases workqueue_lock and cwq->lock's.
+ */
+void freeze_workqueues_begin(void)
+{
+	struct workqueue_struct *wq;
+	unsigned int cpu;
+
+	spin_lock(&workqueue_lock);
+
+	BUG_ON(workqueue_freezing);
+	workqueue_freezing = true;
+
+	for_each_possible_cpu(cpu) {
+		list_for_each_entry(wq, &workqueues, list) {
+			struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
+
+			spin_lock_irq(&cwq->lock);
+
+			if (wq->flags & WQ_FREEZEABLE)
+				cwq->max_active = 0;
+
+			spin_unlock_irq(&cwq->lock);
+		}
+	}
+
+	spin_unlock(&workqueue_lock);
+}
+
+/**
+ * freeze_workqueues_busy - are freezeable workqueues still busy?
+ *
+ * Check whether freezing is complete.  This function must be called
+ * between freeze_workqueues_begin() and thaw_workqueues().
+ *
+ * CONTEXT:
+ * Grabs and releases workqueue_lock.
+ *
+ * RETURNS:
+ * %true if some freezeable workqueues are still busy.  %false if
+ * freezing is complete.
+ */
+bool freeze_workqueues_busy(void)
+{
+	struct workqueue_struct *wq;
+	unsigned int cpu;
+	bool busy = false;
+
+	spin_lock(&workqueue_lock);
+
+	BUG_ON(!workqueue_freezing);
+
+	for_each_possible_cpu(cpu) {
+		/*
+		 * nr_active is monotonically decreasing.  It's safe
+		 * to peek without lock.
+		 */
+		list_for_each_entry(wq, &workqueues, list) {
+			struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
+
+			if (!(wq->flags & WQ_FREEZEABLE))
+				continue;
+
+			BUG_ON(cwq->nr_active < 0);
+			if (cwq->nr_active) {
+				busy = true;
+				goto out_unlock;
+			}
+		}
+	}
+out_unlock:
+	spin_unlock(&workqueue_lock);
+	return busy;
+}
+
+/**
+ * thaw_workqueues - thaw workqueues
+ *
+ * Thaw workqueues.  Normal queueing is restored and all collected
+ * frozen works are transferred to their respective cwq worklists.
+ *
+ * CONTEXT:
+ * Grabs and releases workqueue_lock and cwq->lock's.
+ */
+void thaw_workqueues(void)
+{
+	struct workqueue_struct *wq;
+	unsigned int cpu;
+
+	spin_lock(&workqueue_lock);
+
+	if (!workqueue_freezing)
+		goto out_unlock;
+
+	for_each_possible_cpu(cpu) {
+		list_for_each_entry(wq, &workqueues, list) {
+			struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
+
+			if (!(wq->flags & WQ_FREEZEABLE))
+				continue;
+
+			spin_lock_irq(&cwq->lock);
+
+			/* restore max_active and repopulate worklist */
+			cwq->max_active = wq->saved_max_active;
+
+			while (!list_empty(&cwq->delayed_works) &&
+			       cwq->nr_active < cwq->max_active)
+				cwq_activate_first_delayed(cwq);
+
+			wake_up(&cwq->more_work);
+
+			spin_unlock_irq(&cwq->lock);
+		}
+	}
+
+	workqueue_freezing = false;
+out_unlock:
+	spin_unlock(&workqueue_lock);
+}
+#endif /* CONFIG_FREEZER */
+
 void __init init_workqueues(void)
 {
 	unsigned int cpu;
-- 
1.6.4.2

