Return-Path: <linux-kernel-owner+w=401wt.eu-S1753909AbZKPRR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbZKPRR0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 12:17:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753679AbZKPRRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 12:17:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:33394 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753736AbZKPRRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 12:17:21 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       torvalds@linux-foundation.org, avi@redhat.com, peterz@infradead.org,
       andi@firstfloor.org, fweisbec@gmail.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 17/21] workqueue: simple reimplementation of SINGLE_THREAD workqueue
Date: Tue, 17 Nov 2009 02:15:22 +0900
Message-Id: <1258391726-30264-18-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1258391726-30264-1-git-send-email-tj@kernel.org>
References: <1258391726-30264-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SINGLE_THREAD workqueues are used to reduce the number of worker
threads and ease synchronization.  The first reason will be irrelevant
with concurrency managed workqueue implementation.  Simplify
SINGLE_THREAD implementation by creating the workqueues the same but
making the worker grab mutex before actually executing works on the
workqueue.  In the long run, most SINGLE_THREAD workqueues will be
replaced with generic ones.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c |  151 ++++++++++++++++++----------------------------------
 1 files changed, 52 insertions(+), 99 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 5392939..82b03a1 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -33,6 +33,7 @@
 #include <linux/kallsyms.h>
 #include <linux/debug_locks.h>
 #include <linux/lockdep.h>
+#include <linux/mutex.h>
 
 /*
  * Structure fields follow one of the following exclusion rules.
@@ -71,6 +72,7 @@ struct workqueue_struct {
 	struct cpu_workqueue_struct *cpu_wq;	/* I: cwq's */
 	struct list_head	list;		/* W: list of all workqueues */
 	const char		*name;		/* I: workqueue name */
+	struct mutex		single_thread_mutex; /* for SINGLE_THREAD wq */
 #ifdef CONFIG_LOCKDEP
 	struct lockdep_map	lockdep_map;
 #endif
@@ -190,34 +192,9 @@ static inline void debug_work_deactivate(struct work_struct *work) { }
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
 
@@ -410,6 +387,8 @@ EXPORT_SYMBOL_GPL(queue_delayed_work_on);
 static void process_one_work(struct cpu_workqueue_struct *cwq,
 			     struct work_struct *work)
 {
+	struct workqueue_struct *wq = cwq->wq;
+	bool single_thread = wq->flags & WQ_SINGLE_THREAD;
 	work_func_t f = work->func;
 #ifdef CONFIG_LOCKDEP
 	/*
@@ -430,11 +409,18 @@ static void process_one_work(struct cpu_workqueue_struct *cwq,
 
 	BUG_ON(get_wq_data(work) != cwq);
 	work_clear_pending(work);
-	lock_map_acquire(&cwq->wq->lockdep_map);
+	lock_map_acquire(&wq->lockdep_map);
 	lock_map_acquire(&lockdep_map);
-	f(work);
+
+	if (unlikely(single_thread)) {
+		mutex_lock(&wq->single_thread_mutex);
+		f(work);
+		mutex_unlock(&wq->single_thread_mutex);
+	} else
+		f(work);
+
 	lock_map_release(&lockdep_map);
-	lock_map_release(&cwq->wq->lockdep_map);
+	lock_map_release(&wq->lockdep_map);
 
 	if (unlikely(in_atomic() || lockdep_depth(current) > 0)) {
 		printk(KERN_ERR "BUG: workqueue leaked lock or atomic: "
@@ -569,14 +555,13 @@ static int flush_cpu_workqueue(struct cpu_workqueue_struct *cwq)
  */
 void flush_workqueue(struct workqueue_struct *wq)
 {
-	const struct cpumask *cpu_map = wq_cpu_map(wq);
 	int cpu;
 
 	might_sleep();
 	lock_map_acquire(&wq->lockdep_map);
 	lock_map_release(&wq->lockdep_map);
-	for_each_cpu(cpu, cpu_map)
-		flush_cpu_workqueue(per_cpu_ptr(wq->cpu_wq, cpu));
+	for_each_possible_cpu(cpu)
+		flush_cpu_workqueue(get_cwq(cpu, wq));
 }
 EXPORT_SYMBOL_GPL(flush_workqueue);
 
@@ -694,7 +679,6 @@ static void wait_on_work(struct work_struct *work)
 {
 	struct cpu_workqueue_struct *cwq;
 	struct workqueue_struct *wq;
-	const struct cpumask *cpu_map;
 	int cpu;
 
 	might_sleep();
@@ -707,9 +691,8 @@ static void wait_on_work(struct work_struct *work)
 		return;
 
 	wq = cwq->wq;
-	cpu_map = wq_cpu_map(wq);
 
-	for_each_cpu(cpu, cpu_map)
+	for_each_possible_cpu(cpu)
 		wait_on_cpu_work(get_cwq(cpu, wq), work);
 }
 
@@ -942,7 +925,7 @@ int current_is_keventd(void)
 
 	BUG_ON(!keventd_wq);
 
-	cwq = per_cpu_ptr(keventd_wq->cpu_wq, cpu);
+	cwq = get_cwq(cpu, keventd_wq);
 	if (current == cwq->thread)
 		ret = 1;
 
@@ -950,26 +933,12 @@ int current_is_keventd(void)
 
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
@@ -1002,7 +971,6 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
 						const char *lock_name)
 {
 	struct workqueue_struct *wq;
-	struct cpu_workqueue_struct *cwq;
 	int err = 0, cpu;
 
 	wq = kzalloc(sizeof(*wq), GFP_KERNEL);
@@ -1015,39 +983,40 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
 
 	wq->flags = flags;
 	wq->name = name;
+	mutex_init(&wq->single_thread_mutex);
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
+		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
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
@@ -1098,7 +1067,6 @@ static void cleanup_workqueue_thread(struct cpu_workqueue_struct *cwq)
  */
 void destroy_workqueue(struct workqueue_struct *wq)
 {
-	const struct cpumask *cpu_map = wq_cpu_map(wq);
 	int cpu;
 
 	cpu_maps_update_begin();
@@ -1106,8 +1074,8 @@ void destroy_workqueue(struct workqueue_struct *wq)
 	list_del(&wq->list);
 	spin_unlock(&workqueue_lock);
 
-	for_each_cpu(cpu, cpu_map)
-		cleanup_workqueue_thread(per_cpu_ptr(wq->cpu_wq, cpu));
+	for_each_possible_cpu(cpu)
+		cleanup_workqueue_thread(get_cwq(cpu, wq));
  	cpu_maps_update_done();
 
 	free_percpu(wq->cpu_wq);
@@ -1126,13 +1094,9 @@ static int __devinit workqueue_cpu_callback(struct notifier_block *nfb,
 
 	action &= ~CPU_TASKS_FROZEN;
 
-	switch (action) {
-	case CPU_UP_PREPARE:
-		cpumask_set_cpu(cpu, cpu_populated_map);
-	}
 undo:
 	list_for_each_entry(wq, &workqueues, list) {
-		cwq = per_cpu_ptr(wq->cpu_wq, cpu);
+		cwq = get_cwq(cpu, wq);
 
 		switch (action) {
 		case CPU_UP_PREPARE:
@@ -1156,12 +1120,6 @@ undo:
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
 
@@ -1223,11 +1181,6 @@ void __init init_workqueues(void)
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

