Return-Path: <linux-kernel-owner+w=401wt.eu-S1758370AbZKTEs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758370AbZKTEs0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 23:48:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755767AbZKTEsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 23:48:24 -0500
Received: from hera.kernel.org ([140.211.167.34]:45119 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753994AbZKTEsT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 23:48:19 -0500
From: Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, peterz@infradead.org, johannes@sipsolutions.net
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 19/19] workqueue: reimplement workqueue freeze using cwq->frozen_works queue
Date: Fri, 20 Nov 2009 13:46:47 +0900
Message-Id: <1258692407-8985-20-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1258692407-8985-1-git-send-email-tj@kernel.org>
References: <1258692407-8985-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, workqueue freezing is implemented by marking the worker
freezeable and calling try_to_freeze() from dispatch loop.
Reimplement it so that the workqueue is frozen instead of the worker.

* cwq->cur_worklist and cwq->frozen_works are added.  During normal
  operation cwq->cur_worklist points to cwq->worklist.

* When freezing starts, cwq->cur_worklist is switched to
  cwq->frozen_works so that new works are stored in cwq->frozen_works
  instead of being processed.

* Freezing is complete when cwq->nr_in_flight equals the number of
  works on cwq->frozen_works for all cwqs of all freezeable
  workqueues.

* Thawing is done by restoring cwq->cur_worklist to cwq->worklist and
  splicing cwq->frozen_works to cwq->worklist.

This new implementation allows having multiple shared workers per cpu.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/workqueue.h |    7 ++
 kernel/power/process.c    |   22 +++++-
 kernel/workqueue.c        |  182 ++++++++++++++++++++++++++++++++++++++++++---
 3 files changed, 199 insertions(+), 12 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 53d1410..d7efa66 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -326,4 +326,11 @@ static inline long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg)
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
index cc2e553..701e17f 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -14,6 +14,7 @@
 #include <linux/module.h>
 #include <linux/syscalls.h>
 #include <linux/freezer.h>
+#include <linux/workqueue.h>
 
 /* 
  * Timeout for stopping processes
@@ -34,6 +35,7 @@ static int try_to_freeze_tasks(bool sig_only)
 	struct task_struct *g, *p;
 	unsigned long end_time;
 	unsigned int todo;
+	bool wq_busy = false;
 	struct timeval start, end;
 	u64 elapsed_csecs64;
 	unsigned int elapsed_csecs;
@@ -41,6 +43,10 @@ static int try_to_freeze_tasks(bool sig_only)
 	do_gettimeofday(&start);
 
 	end_time = jiffies + TIMEOUT;
+
+	if (!sig_only)
+		freeze_workqueues_begin();
+
 	do {
 		todo = 0;
 		read_lock(&tasklist_lock);
@@ -62,7 +68,14 @@ static int try_to_freeze_tasks(bool sig_only)
 				todo++;
 		} while_each_thread(g, p);
 		read_unlock(&tasklist_lock);
+
 		yield();			/* Yield is okay here */
+
+		if (!sig_only) {
+			wq_busy = freeze_workqueues_busy();
+			todo += wq_busy;
+		}
+
 		if (time_after(jiffies, end_time))
 			break;
 	} while (todo);
@@ -80,9 +93,13 @@ static int try_to_freeze_tasks(bool sig_only)
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
@@ -152,6 +169,7 @@ void thaw_processes(void)
 	oom_killer_enable();
 
 	printk("Restarting tasks ... ");
+	thaw_workqueues();
 	thaw_tasks(true);
 	thaw_tasks(false);
 	schedule();
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index bbdc239..60ffe22 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -45,6 +45,10 @@
  * F: wq->flush_mutex protected.
  *
  * W: workqueue_lock protected.
+ *
+ * V: Similar to L except that operation is limited to only one
+ *    direction if workqueues are frozen (ie. can be added but can't
+ *    be removed).
  */
 
 struct cpu_workqueue_struct;
@@ -71,12 +75,14 @@ struct cpu_workqueue_struct {
 	wait_queue_head_t more_work;
 	unsigned int		cpu;
 	struct worker		*worker;
+	struct list_head	*cur_worklist;	/* L: current worklist */
 
 	struct workqueue_struct *wq;		/* I: the owning workqueue */
 	int			work_color;	/* L: current color */
 	int			flush_color;	/* L: flushing color */
 	int			nr_in_flight[WORK_COLORS];
 						/* L: nr of in_flight works */
+	struct list_head	frozen_works;	/* V: used while frozen */
 } __attribute__((aligned(1 << WORK_STRUCT_FLAG_BITS)));
 
 /*
@@ -225,6 +231,7 @@ static inline void debug_work_deactivate(struct work_struct *work) { }
 static DEFINE_SPINLOCK(workqueue_lock);
 static LIST_HEAD(workqueues);
 static DEFINE_PER_CPU(struct ida, worker_ida);
+static bool workqueue_frozen;
 
 static int worker_thread(void *__worker);
 
@@ -328,7 +335,7 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 	debug_work_activate(work);
 	spin_lock_irqsave(&cwq->lock, flags);
 	BUG_ON(!list_empty(&work->entry));
-	insert_work(cwq, work, &cwq->worklist, 0);
+	insert_work(cwq, work, cwq->cur_worklist, 0);
 	spin_unlock_irqrestore(&cwq->lock, flags);
 }
 
@@ -716,19 +723,13 @@ static int worker_thread(void *__worker)
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
 
@@ -1455,6 +1456,14 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
 	 */
 	spin_lock(&workqueue_lock);
 	list_add(&wq->list, &workqueues);
+	for_each_possible_cpu(cpu) {
+		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
+
+		if (workqueue_frozen && wq->flags & WQ_FREEZEABLE)
+			cwq->cur_worklist = &cwq->frozen_works;
+		else
+			cwq->cur_worklist = &cwq->worklist;
+	}
 	spin_unlock(&workqueue_lock);
 	/*
 	 * We must initialize cwqs for each possible cpu even if we
@@ -1471,6 +1480,7 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
 		spin_lock_init(&cwq->lock);
 		INIT_LIST_HEAD(&cwq->worklist);
 		init_waitqueue_head(&cwq->more_work);
+		INIT_LIST_HEAD(&cwq->frozen_works);
 
 		if (failed || !cpu_online(cpu))
 			continue;
@@ -1509,12 +1519,17 @@ void destroy_workqueue(struct workqueue_struct *wq)
 	int cpu;
 
 	cpu_maps_update_begin();
+
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
@@ -1527,6 +1542,7 @@ void destroy_workqueue(struct workqueue_struct *wq)
 
 		for (i = 0; i < WORK_COLORS; i++)
 			BUG_ON(cwq->nr_in_flight[i]);
+		BUG_ON(!list_empty(&cwq->frozen_works));
 	}
 
 	cpu_maps_update_done();
@@ -1633,6 +1649,152 @@ long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg)
 EXPORT_SYMBOL_GPL(work_on_cpu);
 #endif /* CONFIG_SMP */
 
+#ifdef CONFIG_FREEZER
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
+	BUG_ON(workqueue_frozen);
+	workqueue_frozen = true;
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
+			BUG_ON(cwq->cur_worklist != &cwq->worklist);
+			BUG_ON(!list_empty(&cwq->frozen_works));
+
+			cwq->cur_worklist = &cwq->frozen_works;
+
+			spin_unlock_irq(&cwq->lock);
+		}
+	}
+	spin_unlock(&workqueue_lock);
+}
+
+/**
+ * freeze_workqueues_busy - are freezeable workqueues still busy?
+ *
+ * Check whether freezing is complete.  This function must be called
+ * between freeeze_workqueues_begin() and thaw_workqueues().
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
+	BUG_ON(!workqueue_frozen);
+
+	for_each_possible_cpu(cpu) {
+		list_for_each_entry(wq, &workqueues, list) {
+			struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
+			struct work_struct *work;
+			int i, nr_in_flight;
+
+			if (!(wq->flags & WQ_FREEZEABLE))
+				continue;
+
+			spin_lock_irq(&cwq->lock);
+
+			BUG_ON(cwq->cur_worklist != &cwq->frozen_works);
+
+			nr_in_flight = 0;
+			for (i = 0; i < WORK_COLORS; i++)
+				nr_in_flight += cwq->nr_in_flight[i];
+
+			list_for_each_entry(work, &cwq->frozen_works, entry)
+				nr_in_flight--;
+
+			spin_unlock_irq(&cwq->lock);
+
+			BUG_ON(nr_in_flight < 0);
+			if (nr_in_flight) {
+				busy = true;
+				break;
+			}
+		}
+		if (busy)
+			break;
+	}
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
+	if (!workqueue_frozen)
+		goto out_unlock;
+
+	workqueue_frozen = false;
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
+			/* switch to normal work queueing */
+			BUG_ON(cwq->cur_worklist != &cwq->frozen_works);
+			cwq->cur_worklist = &cwq->worklist;
+
+			/* transfer frozen tasks to cwq worklist */
+			list_splice_tail_init(&cwq->frozen_works,
+					      &cwq->worklist);
+			wake_up(&cwq->more_work);
+
+			spin_unlock_irq(&cwq->lock);
+		}
+	}
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

