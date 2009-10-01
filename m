Return-Path: <linux-kernel-owner+w=401wt.eu-S932069AbZJAIKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932069AbZJAIKo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 04:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755905AbZJAIKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 04:10:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:38403 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755816AbZJAIKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 04:10:36 -0400
From: Tejun Heo <tj@kernel.org>
To: jeff@garzik.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 18/19] workqueue: reimplement workqueue freeze using cwq->frozen_works queue
Date: Thu,  1 Oct 2009 17:09:17 +0900
Message-Id: <1254384558-1018-19-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1254384558-1018-1-git-send-email-tj@kernel.org>
References: <1254384558-1018-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 01 Oct 2009 08:09:45 +0000 (UTC)
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

NOT_SIGNED_OFF_YET
---
 include/linux/workqueue.h |    7 ++
 kernel/power/process.c    |   21 +++++-
 kernel/workqueue.c        |  173 +++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 194 insertions(+), 7 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index a6136ca..351466d 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -299,4 +299,11 @@ static inline long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg)
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
index 9d26a0a..18d4835 100644
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
 	while (true) {
 		todo = 0;
 		read_lock(&tasklist_lock);
@@ -62,6 +68,12 @@ static int try_to_freeze_tasks(bool sig_only)
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
 
@@ -85,9 +97,13 @@ static int try_to_freeze_tasks(bool sig_only)
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
@@ -157,6 +173,7 @@ void thaw_processes(void)
 	oom_killer_enable();
 
 	printk("Restarting tasks ... ");
+	thaw_workqueues();
 	thaw_tasks(true);
 	thaw_tasks(false);
 	schedule();
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index e234604..097da97 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -44,6 +44,10 @@
  * L: cwq->lock protected.  Access with cwq->lock held.
  *
  * W: workqueue_lock protected.
+ *
+ * V: Similar to L except that operation is limited to only one
+ *    direction if workqueues are frozen (ie. can be added but can't
+ *    be removed).
  */
 
 struct cpu_workqueue_struct;
@@ -69,10 +73,12 @@ struct cpu_workqueue_struct {
 	unsigned int		cpu;
 	struct worker		*worker;
 
+	struct list_head	*cur_worklist;	/* L: current worklist */
 	int			nr_in_flight;	/* L: nr of in_flight works */
 	unsigned int		flush_color;	/* L: current flush color */
 	int			flush_cnt;	/* L: in-progress flush count */
 	struct workqueue_struct *wq;		/* I: the owning workqueue */
+	struct list_head	frozen_works;	/* V: used while frozen */
 } __attribute__((aligned(1 << WORK_STRUCT_FLAG_BITS)));
 
 /*
@@ -97,6 +103,7 @@ struct workqueue_struct {
 /* Serializes the accesses to the list of workqueues. */
 static DEFINE_SPINLOCK(workqueue_lock);
 static LIST_HEAD(workqueues);
+static bool workqueue_frozen;
 
 static int worker_thread(void *__worker);
 
@@ -180,7 +187,7 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 
 	spin_lock_irqsave(&cwq->lock, flags);
 	BUG_ON(!list_empty(&work->entry));
-	insert_work(cwq, work, &cwq->worklist, 0);
+	insert_work(cwq, work, cwq->cur_worklist, 0);
 	spin_unlock_irqrestore(&cwq->lock, flags);
 }
 
@@ -545,8 +552,6 @@ static int worker_thread(void *__worker)
 			schedule();
 		finish_wait(&cwq->more_work, &wait);
 
-		try_to_freeze();
-
 		if (kthread_should_stop())
 			break;
 
@@ -1048,6 +1053,14 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
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
@@ -1063,6 +1076,7 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
 		spin_lock_init(&cwq->lock);
 		INIT_LIST_HEAD(&cwq->worklist);
 		init_waitqueue_head(&cwq->more_work);
+		INIT_LIST_HEAD(&cwq->frozen_works);
 
 		if (failed || !cpu_online(cpu))
 			continue;
@@ -1099,12 +1113,17 @@ void destroy_workqueue(struct workqueue_struct *wq)
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
 
@@ -1114,6 +1133,7 @@ void destroy_workqueue(struct workqueue_struct *wq)
 			cwq->worker = NULL;
 		}
 		BUG_ON(cwq->nr_in_flight);
+		BUG_ON(!list_empty(&cwq->frozen_works));
 	}
 
  	cpu_maps_update_done();
@@ -1217,6 +1237,149 @@ long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg)
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
+			int nr_in_flight;
+
+			if (!(wq->flags & WQ_FREEZEABLE))
+				continue;
+
+			spin_lock_irq(&cwq->lock);
+
+			BUG_ON(cwq->cur_worklist != &cwq->frozen_works);
+
+			nr_in_flight = cwq->nr_in_flight;
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
+			list_splice_tail(&cwq->frozen_works, &cwq->worklist);
+			INIT_LIST_HEAD(&cwq->frozen_works);
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
 	/*
-- 
1.6.4.2

