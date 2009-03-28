Return-Path: <linux-kernel-owner+w=401wt.eu-S1762151AbZC2CHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762151AbZC2CHx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 22:07:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756993AbZC2CEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 22:04:15 -0400
Received: from ozlabs.org ([203.10.76.45]:46570 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754140AbZC2CEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 22:04:08 -0400
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Sun, 29 Mar 2009 00:25:52 +1030
Subject: [PATCH 7/10] cpumask: use new cpumask_ functions in core code.
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Trond.Myklebust@netapp.com
Message-Id: <20090329020405.5CAA8DDD1B@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: cleanup

Time to clean up remaining laggards using the old cpu_ functions.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Trond.Myklebust@netapp.com
---
 drivers/base/cpu.c     |    2 +-
 include/linux/cpuset.h |    4 ++--
 kernel/sched_rt.c      |    4 ++--
 kernel/workqueue.c     |    6 +++---
 mm/allocpercpu.c       |    2 +-
 mm/vmstat.c            |    2 +-
 net/sunrpc/svc.c       |    2 +-
 7 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -119,7 +119,7 @@ static ssize_t print_cpus_map(char *buf,
 #define	print_cpus_func(type) \
 static ssize_t print_cpus_##type(struct sysdev_class *class, char *buf)	\
 {									\
-	return print_cpus_map(buf, &cpu_##type##_map);			\
+	return print_cpus_map(buf, cpu_##type##_mask);			\
 }									\
 static struct sysdev_class_attribute attr_##type##_map = 		\
 	_SYSDEV_CLASS_ATTR(type, 0444, print_cpus_##type, NULL)
diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -90,12 +90,12 @@ static inline void cpuset_cpus_allowed(s
 static inline void cpuset_cpus_allowed(struct task_struct *p,
 				       struct cpumask *mask)
 {
-	*mask = cpu_possible_map;
+	cpumask_copy(mask, cpu_possible_mask);
 }
 static inline void cpuset_cpus_allowed_locked(struct task_struct *p,
 					      struct cpumask *mask)
 {
-	*mask = cpu_possible_map;
+	cpumask_copy(mask, cpu_possible_mask);
 }
 
 static inline nodemask_t cpuset_mems_allowed(struct task_struct *p)
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -953,12 +953,12 @@ static struct task_struct *pick_next_hig
 
 static DEFINE_PER_CPU(cpumask_var_t, local_cpu_mask);
 
-static inline int pick_optimal_cpu(int this_cpu, cpumask_t *mask)
+static inline int pick_optimal_cpu(int this_cpu, const struct cpumask *mask)
 {
 	int first;
 
 	/* "this_cpu" is cheaper to preempt than a remote processor */
-	if ((this_cpu != -1) && cpu_isset(this_cpu, *mask))
+	if ((this_cpu != -1) && cpumask_test_cpu(this_cpu, mask))
 		return this_cpu;
 
 	first = cpumask_first(mask);
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -416,7 +416,7 @@ void flush_workqueue(struct workqueue_st
 	might_sleep();
 	lock_map_acquire(&wq->lockdep_map);
 	lock_map_release(&wq->lockdep_map);
-	for_each_cpu_mask_nr(cpu, *cpu_map)
+	for_each_cpu(cpu, cpu_map)
 		flush_cpu_workqueue(per_cpu_ptr(wq->cpu_wq, cpu));
 }
 EXPORT_SYMBOL_GPL(flush_workqueue);
@@ -547,7 +547,7 @@ static void wait_on_work(struct work_str
 	wq = cwq->wq;
 	cpu_map = wq_cpu_map(wq);
 
-	for_each_cpu_mask_nr(cpu, *cpu_map)
+	for_each_cpu(cpu, cpu_map)
 		wait_on_cpu_work(per_cpu_ptr(wq->cpu_wq, cpu), work);
 }
 
@@ -911,7 +911,7 @@ void destroy_workqueue(struct workqueue_
 	list_del(&wq->list);
 	spin_unlock(&workqueue_lock);
 
-	for_each_cpu_mask_nr(cpu, *cpu_map)
+	for_each_cpu(cpu, cpu_map)
 		cleanup_workqueue_thread(per_cpu_ptr(wq->cpu_wq, cpu));
  	cpu_maps_update_done();
 
diff --git a/mm/allocpercpu.c b/mm/allocpercpu.c
--- a/mm/allocpercpu.c
+++ b/mm/allocpercpu.c
@@ -139,7 +139,7 @@ void percpu_free(void *__pdata)
 {
 	if (unlikely(!__pdata))
 		return;
-	__percpu_depopulate_mask(__pdata, &cpu_possible_map);
+	__percpu_depopulate_mask(__pdata, cpu_possible_mask);
 	kfree(__percpu_disguise(__pdata));
 }
 EXPORT_SYMBOL_GPL(percpu_free);
diff --git a/mm/vmstat.c b/mm/vmstat.c
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -27,7 +27,7 @@ static void sum_vm_events(unsigned long 
 
 	memset(ret, 0, NR_VM_EVENT_ITEMS * sizeof(unsigned long));
 
-	for_each_cpu_mask_nr(cpu, *cpumask) {
+	for_each_cpu(cpu, cpumask) {
 		struct vm_event_state *this = &per_cpu(vm_event_states, cpu);
 
 		for (i = 0; i < NR_VM_EVENT_ITEMS; i++)
diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -312,7 +312,7 @@ svc_pool_map_set_cpumask(struct task_str
 	switch (m->mode) {
 	case SVC_POOL_PERCPU:
 	{
-		set_cpus_allowed_ptr(task, &cpumask_of_cpu(node));
+		set_cpus_allowed_ptr(task, cpumask_of(node));
 		break;
 	}
 	case SVC_POOL_PERNODE:


