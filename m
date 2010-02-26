Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936049Ab0BZMUW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 07:20:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:43388 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935915Ab0BZMOi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 07:14:38 -0500
From: Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org,
       oleg@redhat.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 33/43] workqueue: add system_wq, system_long_wq and system_nrt_wq
Date: Fri, 26 Feb 2010 21:23:10 +0900
Message-Id: <1267187000-18791-34-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1267187000-18791-1-git-send-email-tj@kernel.org>
References: <1267187000-18791-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Feb 2010 12:13:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename keventd_wq to system_wq and export it.  Also add system_long_wq
and system_nrt_wq.  The former is to host long running works
separately (so that flush_scheduled_work() dosen't take so long) and
the latter guarantees any queued work item is never executed in
parallel by multiple CPUs.  These workqueues will be used by future
patches to update workqueue users.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/workqueue.h |   19 +++++++++++++++++++
 kernel/workqueue.c        |   30 +++++++++++++++++++-----------
 2 files changed, 38 insertions(+), 11 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index b13abe0..0b0a828 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -231,6 +231,25 @@ enum {
 	WQ_DFL_ACTIVE		= WQ_MAX_ACTIVE / 2,
 };
 
+/*
+ * System-wide workqueues which are always present.
+ *
+ * system_wq is the one used by schedule[_delayed]_work[_on]().
+ * Multi-CPU multi-threaded.  There are users which expect relatively
+ * short queue flush time.  Don't queue works which can run for too
+ * long.
+ *
+ * system_long_wq is similar to system_wq but may host long running
+ * works.  Queue flushing might take relatively long.
+ *
+ * system_nrt_wq is non-reentrant and guarantees that any given work
+ * item is never executed in parallel by multiple CPUs.  Queue
+ * flushing might take relatively long.
+ */
+extern struct workqueue_struct *system_wq;
+extern struct workqueue_struct *system_long_wq;
+extern struct workqueue_struct *system_nrt_wq;
+
 extern struct workqueue_struct *
 __create_workqueue_key(const char *name, unsigned int flags, int max_active,
 		       struct lock_class_key *key, const char *lock_name);
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 1e15b9a..7264ae7 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -209,6 +209,13 @@ struct workqueue_struct {
 #endif
 };
 
+struct workqueue_struct *system_wq __read_mostly;
+struct workqueue_struct *system_long_wq __read_mostly;
+struct workqueue_struct *system_nrt_wq __read_mostly;
+EXPORT_SYMBOL_GPL(system_wq);
+EXPORT_SYMBOL_GPL(system_long_wq);
+EXPORT_SYMBOL_GPL(system_nrt_wq);
+
 #define for_each_busy_worker(worker, i, pos, gcwq)			\
 	for (i = 0; i < BUSY_WORKER_HASH_SIZE; i++)			\
 		hlist_for_each_entry(worker, pos, &gcwq->busy_hash[i], hentry)
@@ -2227,8 +2234,6 @@ int cancel_delayed_work_sync(struct delayed_work *dwork)
 }
 EXPORT_SYMBOL(cancel_delayed_work_sync);
 
-static struct workqueue_struct *keventd_wq __read_mostly;
-
 /**
  * schedule_work - put work task in global workqueue
  * @work: job to be done
@@ -2242,7 +2247,7 @@ static struct workqueue_struct *keventd_wq __read_mostly;
  */
 int schedule_work(struct work_struct *work)
 {
-	return queue_work(keventd_wq, work);
+	return queue_work(system_wq, work);
 }
 EXPORT_SYMBOL(schedule_work);
 
@@ -2255,7 +2260,7 @@ EXPORT_SYMBOL(schedule_work);
  */
 int schedule_work_on(int cpu, struct work_struct *work)
 {
-	return queue_work_on(cpu, keventd_wq, work);
+	return queue_work_on(cpu, system_wq, work);
 }
 EXPORT_SYMBOL(schedule_work_on);
 
@@ -2270,7 +2275,7 @@ EXPORT_SYMBOL(schedule_work_on);
 int schedule_delayed_work(struct delayed_work *dwork,
 					unsigned long delay)
 {
-	return queue_delayed_work(keventd_wq, dwork, delay);
+	return queue_delayed_work(system_wq, dwork, delay);
 }
 EXPORT_SYMBOL(schedule_delayed_work);
 
@@ -2283,7 +2288,7 @@ EXPORT_SYMBOL(schedule_delayed_work);
 void flush_delayed_work(struct delayed_work *dwork)
 {
 	if (del_timer_sync(&dwork->timer)) {
-		__queue_work(get_cpu(), keventd_wq, &dwork->work);
+		__queue_work(get_cpu(), system_wq, &dwork->work);
 		put_cpu();
 	}
 	flush_work(&dwork->work);
@@ -2302,7 +2307,7 @@ EXPORT_SYMBOL(flush_delayed_work);
 int schedule_delayed_work_on(int cpu,
 			struct delayed_work *dwork, unsigned long delay)
 {
-	return queue_delayed_work_on(cpu, keventd_wq, dwork, delay);
+	return queue_delayed_work_on(cpu, system_wq, dwork, delay);
 }
 EXPORT_SYMBOL(schedule_delayed_work_on);
 
@@ -2343,7 +2348,7 @@ int schedule_on_each_cpu(work_func_t func)
 
 void flush_scheduled_work(void)
 {
-	flush_workqueue(keventd_wq);
+	flush_workqueue(system_wq);
 }
 EXPORT_SYMBOL(flush_scheduled_work);
 
@@ -2375,7 +2380,7 @@ EXPORT_SYMBOL_GPL(execute_in_process_context);
 
 int keventd_up(void)
 {
-	return keventd_wq != NULL;
+	return system_wq != NULL;
 }
 
 static struct cpu_workqueue_struct *alloc_cwqs(void)
@@ -3186,6 +3191,9 @@ void __init init_workqueues(void)
 		spin_unlock_irq(&gcwq->lock);
 	}
 
-	keventd_wq = __create_workqueue("events", 0, WQ_DFL_ACTIVE);
-	BUG_ON(!keventd_wq);
+	system_wq = __create_workqueue("events", 0, WQ_DFL_ACTIVE);
+	system_long_wq = __create_workqueue("events_long", 0, WQ_DFL_ACTIVE);
+	system_nrt_wq = __create_workqueue("events_nrt", WQ_NON_REENTRANT,
+					   WQ_DFL_ACTIVE);
+	BUG_ON(!system_wq || !system_long_wq || !system_nrt_wq);
 }
-- 
1.6.4.2

