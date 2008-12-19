Return-Path: <linux-kernel-owner+w=401wt.eu-S1753470AbYLSQDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470AbYLSQDJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 11:03:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751645AbYLSQBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 11:01:50 -0500
Received: from relay2.sgi.com ([192.48.179.30]:35413 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751086AbYLSQBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 11:01:47 -0500
Message-Id: <20081219160145.011014000@polaris-admin.engr.sgi.com>
References: <20081219160144.697518000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 19 Dec 2008 08:01:46 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 2/8] cpumask: convert kernel/workqueue.c
Content-Disposition: inline; filename=cpumask:convert-kernel_workqueue.c.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: Reduce memory usage, use new cpumask API.

In this case, we replace cpu_populated_map with a cpumask_var_t rather
than a bitmap because there's an obvious init function for workqueues
which happens after kmalloc is available.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 kernel/workqueue.c |   39 +++++++++++++++++++++------------------
 1 file changed, 21 insertions(+), 18 deletions(-)

--- linux-2.6-for-ingo.orig/kernel/workqueue.c
+++ linux-2.6-for-ingo/kernel/workqueue.c
@@ -73,15 +73,15 @@ static DEFINE_SPINLOCK(workqueue_lock);
 static LIST_HEAD(workqueues);
 
 static int singlethread_cpu __read_mostly;
-static cpumask_t cpu_singlethread_map __read_mostly;
+static const struct cpumask *cpu_singlethread_map __read_mostly;
 /*
- * _cpu_down() first removes CPU from cpu_online_map, then CPU_DEAD
+ * _cpu_down() first removes CPU from cpu_online_mask, then CPU_DEAD
  * flushes cwq->worklist. This means that flush_workqueue/wait_on_work
  * which comes in between can't use for_each_online_cpu(). We could
- * use cpu_possible_map, the cpumask below is more a documentation
+ * use cpu_possible_mask, the cpumask below is more a documentation
  * than optimization.
  */
-static cpumask_t cpu_populated_map __read_mostly;
+static cpumask_var_t cpu_populated_map __read_mostly;
 
 /* If it's single threaded, it isn't in the list of workqueues. */
 static inline int is_single_threaded(struct workqueue_struct *wq)
@@ -89,10 +89,10 @@ static inline int is_single_threaded(str
 	return wq->singlethread;
 }
 
-static const cpumask_t *wq_cpu_map(struct workqueue_struct *wq)
+static const struct cpumask *wq_cpu_map(struct workqueue_struct *wq)
 {
 	return is_single_threaded(wq)
-		? &cpu_singlethread_map : &cpu_populated_map;
+		? cpu_singlethread_map : cpu_populated_map;
 }
 
 static
@@ -410,13 +410,13 @@ static int flush_cpu_workqueue(struct cp
  */
 void flush_workqueue(struct workqueue_struct *wq)
 {
-	const cpumask_t *cpu_map = wq_cpu_map(wq);
+	const struct cpumask *cpu_map = wq_cpu_map(wq);
 	int cpu;
 
 	might_sleep();
 	lock_map_acquire(&wq->lockdep_map);
 	lock_map_release(&wq->lockdep_map);
-	for_each_cpu_mask_nr(cpu, *cpu_map)
+	for_each_cpu(cpu, cpu_map)
 		flush_cpu_workqueue(per_cpu_ptr(wq->cpu_wq, cpu));
 }
 EXPORT_SYMBOL_GPL(flush_workqueue);
@@ -532,7 +532,7 @@ static void wait_on_work(struct work_str
 {
 	struct cpu_workqueue_struct *cwq;
 	struct workqueue_struct *wq;
-	const cpumask_t *cpu_map;
+	const struct cpumask *cpu_map;
 	int cpu;
 
 	might_sleep();
@@ -547,7 +547,7 @@ static void wait_on_work(struct work_str
 	wq = cwq->wq;
 	cpu_map = wq_cpu_map(wq);
 
-	for_each_cpu_mask_nr(cpu, *cpu_map)
+	for_each_cpu(cpu, cpu_map)
 		wait_on_cpu_work(per_cpu_ptr(wq->cpu_wq, cpu), work);
 }
 
@@ -778,7 +778,7 @@ static int create_workqueue_thread(struc
 	 *	if (caller is __create_workqueue)
 	 *		nobody should see this wq
 	 *	else // caller is CPU_UP_PREPARE
-	 *		cpu is not on cpu_online_map
+	 *		cpu is not on cpu_online_mask
 	 * so we can abort safely.
 	 */
 	if (IS_ERR(p))
@@ -903,7 +903,7 @@ static void cleanup_workqueue_thread(str
  */
 void destroy_workqueue(struct workqueue_struct *wq)
 {
-	const cpumask_t *cpu_map = wq_cpu_map(wq);
+	const struct cpumask *cpu_map = wq_cpu_map(wq);
 	int cpu;
 
 	cpu_maps_update_begin();
@@ -911,7 +911,7 @@ void destroy_workqueue(struct workqueue_
 	list_del(&wq->list);
 	spin_unlock(&workqueue_lock);
 
-	for_each_cpu_mask_nr(cpu, *cpu_map)
+	for_each_cpu(cpu, cpu_map)
 		cleanup_workqueue_thread(per_cpu_ptr(wq->cpu_wq, cpu));
  	cpu_maps_update_done();
 
@@ -933,7 +933,7 @@ static int __devinit workqueue_cpu_callb
 
 	switch (action) {
 	case CPU_UP_PREPARE:
-		cpu_set(cpu, cpu_populated_map);
+		cpumask_set_cpu(cpu, cpu_populated_map);
 	}
 undo:
 	list_for_each_entry(wq, &workqueues, list) {
@@ -964,7 +964,7 @@ undo:
 	switch (action) {
 	case CPU_UP_CANCELED:
 	case CPU_POST_DEAD:
-		cpu_clear(cpu, cpu_populated_map);
+		cpumask_clear_cpu(cpu, cpu_populated_map);
 	}
 
 	return ret;
@@ -1017,9 +1017,12 @@ EXPORT_SYMBOL_GPL(work_on_cpu);
 
 void __init init_workqueues(void)
 {
-	cpu_populated_map = cpu_online_map;
-	singlethread_cpu = first_cpu(cpu_possible_map);
-	cpu_singlethread_map = cpumask_of_cpu(singlethread_cpu);
+	alloc_cpumask_var(&cpu_populated_map, GFP_KERNEL);
+	cpumask_copy(cpu_populated_map, cpu_online_mask);
+
+	singlethread_cpu = cpumask_first(cpu_possible_mask);
+	cpu_singlethread_map = cpumask_of(singlethread_cpu);
+
 	hotcpu_notifier(workqueue_cpu_callback, 0);
 	keventd_wq = create_workqueue("events");
 	BUG_ON(!keventd_wq);

-- 
