Return-Path: <linux-kernel-owner+w=401wt.eu-S1755415Ab0ARAxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415Ab0ARAxr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 19:53:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755374Ab0ARAxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 19:53:39 -0500
Received: from hera.kernel.org ([140.211.167.34]:54398 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755364Ab0ARAxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 19:53:37 -0500
From: Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 29/40] workqueue: add system_wq and system_single_wq
Date: Mon, 18 Jan 2010 09:57:41 +0900
Message-Id: <1263776272-382-30-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1263776272-382-1-git-send-email-tj@kernel.org>
References: <1263776272-382-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 18 Jan 2010 00:52:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename keventd_wq to system_wq and export it.  Also add
system_single_wq which guarantees that a work isn't executed on
multiple cpus concurrently.  These workqueues will be used by future
patches to update workqueue users.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/workqueue.h |   19 +++++++++++++++++++
 kernel/workqueue.c        |   30 +++++++++++++++++++-----------
 2 files changed, 38 insertions(+), 11 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index f43a260..265207d 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -218,6 +218,25 @@ enum {
 	WQ_MAX_ACTIVE		= 256,    /* I like 256, better ideas? */
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
+ * system_single_wq is single-CPU multi-threaded and guarantees that a
+ * work item is not executed in parallel by multiple CPUs.  Queue
+ * flushing might take relatively long.
+ */
+extern struct workqueue_struct *system_wq;
+extern struct workqueue_struct *system_long_wq;
+extern struct workqueue_struct *system_single_wq;
+
 extern struct workqueue_struct *
 __create_workqueue_key(const char *name, unsigned int flags, int max_active,
 		       struct lock_class_key *key, const char *lock_name);
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 9833774..233278c 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -208,6 +208,13 @@ struct workqueue_struct {
 #endif
 };
 
+struct workqueue_struct *system_wq __read_mostly;
+struct workqueue_struct *system_long_wq __read_mostly;
+struct workqueue_struct *system_single_wq __read_mostly;
+EXPORT_SYMBOL_GPL(system_wq);
+EXPORT_SYMBOL_GPL(system_long_wq);
+EXPORT_SYMBOL_GPL(system_single_wq);
+
 #define for_each_busy_worker(worker, i, pos, gcwq)			\
 	for (i = 0; i < BUSY_WORKER_HASH_SIZE; i++)			\
 		hlist_for_each_entry(worker, pos, &gcwq->busy_hash[i], hentry)
@@ -2148,8 +2155,6 @@ int cancel_delayed_work_sync(struct delayed_work *dwork)
 }
 EXPORT_SYMBOL(cancel_delayed_work_sync);
 
-static struct workqueue_struct *keventd_wq __read_mostly;
-
 /**
  * schedule_work - put work task in global workqueue
  * @work: job to be done
@@ -2163,7 +2168,7 @@ static struct workqueue_struct *keventd_wq __read_mostly;
  */
 int schedule_work(struct work_struct *work)
 {
-	return queue_work(keventd_wq, work);
+	return queue_work(system_wq, work);
 }
 EXPORT_SYMBOL(schedule_work);
 
@@ -2176,7 +2181,7 @@ EXPORT_SYMBOL(schedule_work);
  */
 int schedule_work_on(int cpu, struct work_struct *work)
 {
-	return queue_work_on(cpu, keventd_wq, work);
+	return queue_work_on(cpu, system_wq, work);
 }
 EXPORT_SYMBOL(schedule_work_on);
 
@@ -2191,7 +2196,7 @@ EXPORT_SYMBOL(schedule_work_on);
 int schedule_delayed_work(struct delayed_work *dwork,
 					unsigned long delay)
 {
-	return queue_delayed_work(keventd_wq, dwork, delay);
+	return queue_delayed_work(system_wq, dwork, delay);
 }
 EXPORT_SYMBOL(schedule_delayed_work);
 
@@ -2204,7 +2209,7 @@ EXPORT_SYMBOL(schedule_delayed_work);
 void flush_delayed_work(struct delayed_work *dwork)
 {
 	if (del_timer_sync(&dwork->timer)) {
-		__queue_work(get_cpu(), keventd_wq, &dwork->work);
+		__queue_work(get_cpu(), system_wq, &dwork->work);
 		put_cpu();
 	}
 	flush_work(&dwork->work);
@@ -2223,7 +2228,7 @@ EXPORT_SYMBOL(flush_delayed_work);
 int schedule_delayed_work_on(int cpu,
 			struct delayed_work *dwork, unsigned long delay)
 {
-	return queue_delayed_work_on(cpu, keventd_wq, dwork, delay);
+	return queue_delayed_work_on(cpu, system_wq, dwork, delay);
 }
 EXPORT_SYMBOL(schedule_delayed_work_on);
 
@@ -2264,7 +2269,7 @@ int schedule_on_each_cpu(work_func_t func)
 
 void flush_scheduled_work(void)
 {
-	flush_workqueue(keventd_wq);
+	flush_workqueue(system_wq);
 }
 EXPORT_SYMBOL(flush_scheduled_work);
 
@@ -2296,7 +2301,7 @@ EXPORT_SYMBOL_GPL(execute_in_process_context);
 
 int keventd_up(void)
 {
-	return keventd_wq != NULL;
+	return system_wq != NULL;
 }
 
 static struct cpu_workqueue_struct *alloc_cwqs(void)
@@ -3090,6 +3095,9 @@ void __init init_workqueues(void)
 		spin_unlock_irq(&gcwq->lock);
 	}
 
-	keventd_wq = __create_workqueue("events", 0, WQ_MAX_ACTIVE);
-	BUG_ON(!keventd_wq);
+	system_wq = __create_workqueue("events", 0, WQ_MAX_ACTIVE);
+	system_long_wq = __create_workqueue("events_long", 0, WQ_MAX_ACTIVE);
+	system_single_wq = __create_workqueue("events_single", WQ_SINGLE_CPU,
+					      WQ_MAX_ACTIVE);
+	BUG_ON(!system_wq || !system_long_wq || !system_single_wq);
 }
-- 
1.6.4.2

