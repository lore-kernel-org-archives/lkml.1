Return-Path: <linux-kernel-owner+w=401wt.eu-S1755921AbZJAIKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921AbZJAIKj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 04:10:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755739AbZJAIKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 04:10:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:38365 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755846AbZJAIKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 04:10:18 -0400
From: Tejun Heo <tj@kernel.org>
To: jeff@garzik.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 14/19] workqueue: (TEMPORARY) kill singlethread variant
Date: Thu,  1 Oct 2009 17:09:13 +0900
Message-Id: <1254384558-1018-15-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1254384558-1018-1-git-send-email-tj@kernel.org>
References: <1254384558-1018-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 01 Oct 2009 08:09:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is incorrect.  There are workqueue users which depend on single
thread for synchronization purpose.  Working on proper solution.

NOT_SIGNED_OFF
---
 include/linux/workqueue.h |    5 +-
 kernel/workqueue.c        |  128 ++++++++++++---------------------------------
 2 files changed, 36 insertions(+), 97 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 541c5eb..5aa0e15 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -178,7 +178,6 @@ struct execute_work {
 
 enum {
 	WQ_FREEZEABLE		= 1 << 0, /* freeze during suspend */
-	WQ_SINGLE_THREAD	= 1 << 1, /* no per-cpu worker */
 };
 
 extern struct workqueue_struct *
@@ -207,9 +206,9 @@ __create_workqueue_key(const char *name, unsigned int flags,
 #define create_workqueue(name)					\
 	__create_workqueue((name), 0)
 #define create_freezeable_workqueue(name)			\
-	__create_workqueue((name), WQ_FREEZEABLE | WQ_SINGLE_THREAD)
+	__create_workqueue((name), WQ_FREEZEABLE)
 #define create_singlethread_workqueue(name)			\
-	__create_workqueue((name), WQ_SINGLE_THREAD)
+	__create_workqueue((name), 0)
 
 extern void destroy_workqueue(struct workqueue_struct *wq);
 
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 39a04ec..6370c9b 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -47,8 +47,7 @@
  */
 
 /*
- * The per-CPU workqueue (if single thread, we always use the first
- * possible cpu).  The lower WORK_STRUCT_FLAG_BITS of
+ * The per-CPU workqueue.  The lower WORK_STRUCT_FLAG_BITS of
  * work_struct->data are used for flags and thus cwqs need to be
  * aligned at two's power of the number of flag bits.
  */
@@ -82,34 +81,9 @@ struct workqueue_struct {
 static DEFINE_SPINLOCK(workqueue_lock);
 static LIST_HEAD(workqueues);
 
-static int singlethread_cpu __read_mostly;
-static const struct cpumask *cpu_singlethread_map __read_mostly;
-/*
- * _cpu_down() first removes CPU from cpu_online_map, then CPU_DEAD
- * flushes cwq->worklist. This means that flush_workqueue/wait_on_work
- * which comes in between can't use for_each_online_cpu(). We could
- * use cpu_possible_map, the cpumask below is more a documentation
- * than optimization.
- */
-static cpumask_var_t cpu_populated_map __read_mostly;
-
-/* If it's single threaded, it isn't in the list of workqueues. */
-static inline bool is_wq_single_threaded(struct workqueue_struct *wq)
-{
-	return wq->flags & WQ_SINGLE_THREAD;
-}
-
-static const struct cpumask *wq_cpu_map(struct workqueue_struct *wq)
-{
-	return is_wq_single_threaded(wq)
-		? cpu_singlethread_map : cpu_populated_map;
-}
-
 static struct cpu_workqueue_struct *get_cwq(unsigned int cpu,
 					    struct workqueue_struct *wq)
 {
-	if (unlikely(is_wq_single_threaded(wq)))
-		cpu = singlethread_cpu;
 	return per_cpu_ptr(wq->cpu_wq, cpu);
 }
 
@@ -467,13 +441,12 @@ static int flush_cpu_workqueue(struct cpu_workqueue_struct *cwq)
  */
 void flush_workqueue(struct workqueue_struct *wq)
 {
-	const struct cpumask *cpu_map = wq_cpu_map(wq);
 	int cpu;
 
 	might_sleep();
 	lock_map_acquire(&wq->lockdep_map);
 	lock_map_release(&wq->lockdep_map);
-	for_each_cpu(cpu, cpu_map)
+	for_each_possible_cpu(cpu)
 		flush_cpu_workqueue(per_cpu_ptr(wq->cpu_wq, cpu));
 }
 EXPORT_SYMBOL_GPL(flush_workqueue);
@@ -587,7 +560,6 @@ static void wait_on_work(struct work_struct *work)
 {
 	struct cpu_workqueue_struct *cwq;
 	struct workqueue_struct *wq;
-	const struct cpumask *cpu_map;
 	int cpu;
 
 	might_sleep();
@@ -600,9 +572,8 @@ static void wait_on_work(struct work_struct *work)
 		return;
 
 	wq = cwq->wq;
-	cpu_map = wq_cpu_map(wq);
 
-	for_each_cpu(cpu, cpu_map)
+	for_each_possible_cpu(cpu)
 		wait_on_cpu_work(get_cwq(cpu, wq), work);
 }
 
@@ -801,26 +772,12 @@ int current_is_keventd(void)
 	return is_sched_workqueue(current);
 }
 
-static struct cpu_workqueue_struct *
-init_cpu_workqueue(struct workqueue_struct *wq, int cpu)
-{
-	struct cpu_workqueue_struct *cwq = per_cpu_ptr(wq->cpu_wq, cpu);
-
-	cwq->wq = wq;
-	spin_lock_init(&cwq->lock);
-	INIT_LIST_HEAD(&cwq->worklist);
-	init_waitqueue_head(&cwq->more_work);
-
-	return cwq;
-}
-
 static int create_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
 {
 	struct workqueue_struct *wq = cwq->wq;
-	const char *fmt = is_wq_single_threaded(wq) ? "%s" : "%s/%d";
 	struct task_struct *p;
 
-	p = kthread_create(worker_thread, cwq, fmt, wq->name, cpu);
+	p = kthread_create(worker_thread, cwq, "%s/%d", wq->name, cpu);
 	/*
 	 * Nobody can add the work_struct to this cwq,
 	 *	if (caller is __create_workqueue)
@@ -853,7 +810,6 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
 						const char *lock_name)
 {
 	struct workqueue_struct *wq;
-	struct cpu_workqueue_struct *cwq;
 	int err = 0, cpu;
 
 	wq = kzalloc(sizeof(*wq), GFP_KERNEL);
@@ -869,36 +825,36 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
 	lockdep_init_map(&wq->lockdep_map, lock_name, key, 0);
 	INIT_LIST_HEAD(&wq->list);
 
-	if (flags & WQ_SINGLE_THREAD) {
-		cwq = init_cpu_workqueue(wq, singlethread_cpu);
-		err = create_workqueue_thread(cwq, singlethread_cpu);
-		start_workqueue_thread(cwq, -1);
-	} else {
-		cpu_maps_update_begin();
-		/*
-		 * We must place this wq on list even if the code below fails.
-		 * cpu_down(cpu) can remove cpu from cpu_populated_map before
-		 * destroy_workqueue() takes the lock, in that case we leak
-		 * cwq[cpu]->thread.
-		 */
-		spin_lock(&workqueue_lock);
-		list_add(&wq->list, &workqueues);
-		spin_unlock(&workqueue_lock);
-		/*
-		 * We must initialize cwqs for each possible cpu even if we
-		 * are going to call destroy_workqueue() finally. Otherwise
-		 * cpu_up() can hit the uninitialized cwq once we drop the
-		 * lock.
-		 */
-		for_each_possible_cpu(cpu) {
-			cwq = init_cpu_workqueue(wq, cpu);
-			if (err || !cpu_online(cpu))
-				continue;
-			err = create_workqueue_thread(cwq, cpu);
-			start_workqueue_thread(cwq, cpu);
-		}
-		cpu_maps_update_done();
+	cpu_maps_update_begin();
+	/*
+	 * We must place this wq on list even if the code below fails.
+	 * cpu_down(cpu) can remove cpu from cpu_populated_map before
+	 * destroy_workqueue() takes the lock, in that case we leak
+	 * cwq[cpu]->thread.
+	 */
+	spin_lock(&workqueue_lock);
+	list_add(&wq->list, &workqueues);
+	spin_unlock(&workqueue_lock);
+	/*
+	 * We must initialize cwqs for each possible cpu even if we
+	 * are going to call destroy_workqueue() finally. Otherwise
+	 * cpu_up() can hit the uninitialized cwq once we drop the
+	 * lock.
+	 */
+	for_each_possible_cpu(cpu) {
+		struct cpu_workqueue_struct *cwq = per_cpu_ptr(wq->cpu_wq, cpu);
+
+		cwq->wq = wq;
+		spin_lock_init(&cwq->lock);
+		INIT_LIST_HEAD(&cwq->worklist);
+		init_waitqueue_head(&cwq->more_work);
+
+		if (err || !cpu_online(cpu))
+			continue;
+		err = create_workqueue_thread(cwq, cpu);
+		start_workqueue_thread(cwq, cpu);
 	}
+	cpu_maps_update_done();
 
 	if (err) {
 		destroy_workqueue(wq);
@@ -949,7 +905,6 @@ static void cleanup_workqueue_thread(struct cpu_workqueue_struct *cwq)
  */
 void destroy_workqueue(struct workqueue_struct *wq)
 {
-	const struct cpumask *cpu_map = wq_cpu_map(wq);
 	int cpu;
 
 	cpu_maps_update_begin();
@@ -957,7 +912,7 @@ void destroy_workqueue(struct workqueue_struct *wq)
 	list_del(&wq->list);
 	spin_unlock(&workqueue_lock);
 
-	for_each_cpu(cpu, cpu_map)
+	for_each_possible_cpu(cpu)
 		cleanup_workqueue_thread(per_cpu_ptr(wq->cpu_wq, cpu));
  	cpu_maps_update_done();
 
@@ -977,10 +932,6 @@ static int __devinit workqueue_cpu_callback(struct notifier_block *nfb,
 
 	action &= ~CPU_TASKS_FROZEN;
 
-	switch (action) {
-	case CPU_UP_PREPARE:
-		cpumask_set_cpu(cpu, cpu_populated_map);
-	}
 undo:
 	list_for_each_entry(wq, &workqueues, list) {
 		cwq = per_cpu_ptr(wq->cpu_wq, cpu);
@@ -1007,12 +958,6 @@ undo:
 		}
 	}
 
-	switch (action) {
-	case CPU_UP_CANCELED:
-	case CPU_POST_DEAD:
-		cpumask_clear_cpu(cpu, cpu_populated_map);
-	}
-
 	return ret;
 }
 
@@ -1074,11 +1019,6 @@ void __init init_workqueues(void)
 	BUILD_BUG_ON(__alignof__(struct cpu_workqueue_struct) <
 		     __alignof__(unsigned long long));
 
-	alloc_cpumask_var(&cpu_populated_map, GFP_KERNEL);
-
-	cpumask_copy(cpu_populated_map, cpu_online_mask);
-	singlethread_cpu = cpumask_first(cpu_possible_mask);
-	cpu_singlethread_map = cpumask_of(singlethread_cpu);
 	hotcpu_notifier(workqueue_cpu_callback, 0);
 	keventd_wq = create_workqueue("events");
 	BUG_ON(!keventd_wq);
-- 
1.6.4.2

