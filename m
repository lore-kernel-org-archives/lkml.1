Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935956Ab0BZMVS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 07:21:18 -0500
Received: from hera.kernel.org ([140.211.167.34]:43355 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935928Ab0BZMOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 07:14:31 -0500
From: Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org,
       oleg@redhat.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 16/43] workqueue: kill cpu_populated_map
Date: Fri, 26 Feb 2010 21:22:53 +0900
Message-Id: <1267187000-18791-17-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1267187000-18791-1-git-send-email-tj@kernel.org>
References: <1267187000-18791-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Feb 2010 12:13:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Worker management is about to be overhauled.  Simplify things by
removing cpu_populated_map, creating workers for all possible cpus and
making single threaded workqueues behave more like multi threaded
ones.

After this patch, all cwqs are always initialized, all workqueues are
linked on the workqueues list and workers for all possibles cpus
always exist.  This also makes CPU hotplug support simpler - rebinding
workers on CPU_ONLINE and flushing on CPU_POST_DEAD are enough.

While at it, make get_cwq() always return the cwq for the specified
cpu, add target_cwq() for cases where single thread distinction is
necessary and drop all direct usage of per_cpu_ptr() on wq->cpu_wq.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c |  165 +++++++++++++++++-----------------------------------
 1 files changed, 54 insertions(+), 111 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 7c7dfa1..c5d5ffe 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -189,34 +189,19 @@ static DEFINE_SPINLOCK(workqueue_lock);
 static LIST_HEAD(workqueues);
 
 static int singlethread_cpu __read_mostly;
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
 
-static const struct cpumask *wq_cpu_map(struct workqueue_struct *wq)
+static struct cpu_workqueue_struct *get_cwq(unsigned int cpu,
+					    struct workqueue_struct *wq)
 {
-	return is_wq_single_threaded(wq)
-		? cpu_singlethread_map : cpu_populated_map;
+	return per_cpu_ptr(wq->cpu_wq, cpu);
 }
 
-static struct cpu_workqueue_struct *get_cwq(unsigned int cpu,
-					    struct workqueue_struct *wq)
+static struct cpu_workqueue_struct *target_cwq(unsigned int cpu,
+					       struct workqueue_struct *wq)
 {
-	if (unlikely(is_wq_single_threaded(wq)))
+	if (unlikely(wq->flags & WQ_SINGLE_THREAD))
 		cpu = singlethread_cpu;
-	return per_cpu_ptr(wq->cpu_wq, cpu);
+	return get_cwq(cpu, wq);
 }
 
 /*
@@ -279,7 +264,7 @@ static void insert_work(struct cpu_workqueue_struct *cwq,
 static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 			 struct work_struct *work)
 {
-	struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
+	struct cpu_workqueue_struct *cwq = target_cwq(cpu, wq);
 	unsigned long flags;
 
 	debug_work_activate(work);
@@ -383,7 +368,7 @@ int queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
 		timer_stats_timer_set_start_info(&dwork->timer);
 
 		/* This stores cwq for the moment, for the timer_fn */
-		set_wq_data(work, get_cwq(raw_smp_processor_id(), wq), 0);
+		set_wq_data(work, target_cwq(raw_smp_processor_id(), wq), 0);
 		timer->expires = jiffies + delay;
 		timer->data = (unsigned long)dwork;
 		timer->function = delayed_work_timer_fn;
@@ -574,14 +559,13 @@ static int flush_cpu_workqueue(struct cpu_workqueue_struct *cwq)
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
 
@@ -699,7 +683,6 @@ static void wait_on_work(struct work_struct *work)
 {
 	struct cpu_workqueue_struct *cwq;
 	struct workqueue_struct *wq;
-	const struct cpumask *cpu_map;
 	int cpu;
 
 	might_sleep();
@@ -712,9 +695,8 @@ static void wait_on_work(struct work_struct *work)
 		return;
 
 	wq = cwq->wq;
-	cpu_map = wq_cpu_map(wq);
 
-	for_each_cpu(cpu, cpu_map)
+	for_each_possible_cpu(cpu)
 		wait_on_cpu_work(get_cwq(cpu, wq), work);
 }
 
@@ -947,7 +929,7 @@ int current_is_keventd(void)
 
 	BUG_ON(!keventd_wq);
 
-	cwq = per_cpu_ptr(keventd_wq->cpu_wq, cpu);
+	cwq = get_cwq(cpu, keventd_wq);
 	if (current == cwq->thread)
 		ret = 1;
 
@@ -955,26 +937,12 @@ int current_is_keventd(void)
 
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
@@ -1006,8 +974,8 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
 						struct lock_class_key *key,
 						const char *lock_name)
 {
+	bool singlethread = flags & WQ_SINGLE_THREAD;
 	struct workqueue_struct *wq;
-	struct cpu_workqueue_struct *cwq;
 	int err = 0, cpu;
 
 	wq = kzalloc(sizeof(*wq), GFP_KERNEL);
@@ -1023,41 +991,40 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
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
+	cpu_maps_update_begin();
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
+		if (err)
+			continue;
+		err = create_workqueue_thread(cwq, cpu);
+		if (cpu_online(cpu) && !singlethread)
 			start_workqueue_thread(cwq, cpu);
-		}
-		cpu_maps_update_done();
+		else
+			start_workqueue_thread(cwq, -1);
 	}
+	cpu_maps_update_done();
 
 	if (err) {
 		destroy_workqueue(wq);
 		wq = NULL;
 	}
+
+	spin_lock(&workqueue_lock);
+	list_add(&wq->list, &workqueues);
+	spin_unlock(&workqueue_lock);
+
 	return wq;
 err:
 	if (wq) {
@@ -1103,17 +1070,14 @@ static void cleanup_workqueue_thread(struct cpu_workqueue_struct *cwq)
  */
 void destroy_workqueue(struct workqueue_struct *wq)
 {
-	const struct cpumask *cpu_map = wq_cpu_map(wq);
 	int cpu;
 
-	cpu_maps_update_begin();
 	spin_lock(&workqueue_lock);
 	list_del(&wq->list);
 	spin_unlock(&workqueue_lock);
 
-	for_each_cpu(cpu, cpu_map)
-		cleanup_workqueue_thread(per_cpu_ptr(wq->cpu_wq, cpu));
- 	cpu_maps_update_done();
+	for_each_possible_cpu(cpu)
+		cleanup_workqueue_thread(get_cwq(cpu, wq));
 
 	free_percpu(wq->cpu_wq);
 	kfree(wq);
@@ -1127,47 +1091,30 @@ static int __devinit workqueue_cpu_callback(struct notifier_block *nfb,
 	unsigned int cpu = (unsigned long)hcpu;
 	struct cpu_workqueue_struct *cwq;
 	struct workqueue_struct *wq;
-	int ret = NOTIFY_OK;
 
 	action &= ~CPU_TASKS_FROZEN;
 
-	switch (action) {
-	case CPU_UP_PREPARE:
-		cpumask_set_cpu(cpu, cpu_populated_map);
-	}
-undo:
 	list_for_each_entry(wq, &workqueues, list) {
-		cwq = per_cpu_ptr(wq->cpu_wq, cpu);
+		if (wq->flags & WQ_SINGLE_THREAD)
+			continue;
 
-		switch (action) {
-		case CPU_UP_PREPARE:
-			if (!create_workqueue_thread(cwq, cpu))
-				break;
-			printk(KERN_ERR "workqueue [%s] for %i failed\n",
-				wq->name, cpu);
-			action = CPU_UP_CANCELED;
-			ret = NOTIFY_BAD;
-			goto undo;
+		cwq = get_cwq(cpu, wq);
 
+		switch (action) {
 		case CPU_ONLINE:
-			start_workqueue_thread(cwq, cpu);
+			__set_cpus_allowed(cwq->thread, get_cpu_mask(cpu),
+					   true);
 			break;
 
-		case CPU_UP_CANCELED:
-			start_workqueue_thread(cwq, -1);
 		case CPU_POST_DEAD:
-			cleanup_workqueue_thread(cwq);
+			lock_map_acquire(&cwq->wq->lockdep_map);
+			lock_map_release(&cwq->wq->lockdep_map);
+			flush_cpu_workqueue(cwq);
 			break;
 		}
 	}
 
-	switch (action) {
-	case CPU_UP_CANCELED:
-	case CPU_POST_DEAD:
-		cpumask_clear_cpu(cpu, cpu_populated_map);
-	}
-
-	return ret;
+	return NOTIFY_OK;
 }
 
 #ifdef CONFIG_SMP
@@ -1219,11 +1166,7 @@ EXPORT_SYMBOL_GPL(work_on_cpu);
 
 void __init init_workqueues(void)
 {
-	alloc_cpumask_var(&cpu_populated_map, GFP_KERNEL);
-
-	cpumask_copy(cpu_populated_map, cpu_online_mask);
 	singlethread_cpu = cpumask_first(cpu_possible_mask);
-	cpu_singlethread_map = cpumask_of(singlethread_cpu);
 	hotcpu_notifier(workqueue_cpu_callback, 0);
 	keventd_wq = create_workqueue("events");
 	BUG_ON(!keventd_wq);
-- 
1.6.4.2

