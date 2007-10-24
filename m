Return-Path: <linux-kernel-owner+w=401wt.eu-S1753301AbXJXFh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301AbXJXFh2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 01:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754181AbXJXFhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 01:37:21 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:45380 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754019AbXJXFhT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 01:37:19 -0400
Date: Wed, 24 Oct 2007 11:07:16 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Rusty Russel <rusty@rustcorp.com.au>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: [RFC PATCH 4/5] Remove CPU_DEAD/CPU_UP_CANCELLED handling from workqueue.c
Message-ID: <20071024053716.GD27074@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20071024052931.GA22722@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071024052931.GA22722@in.ibm.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

cleanup_workqueue_thread() in the CPU_DEAD and CPU_UP_CANCELLED path
will cause a deadlock if the worker thread is executing a work item
which is blocked on get_online_cpus(). This will lead to a irrecoverable
hang. 

Solution is not to cleanup the worker thread. Instead let it remain
even after the cpu goes offline. Since no one can queue any work
on an offlined cpu, this thread will be forever sleeping, untill
someone onlines the cpu.

With get_online_cpus()/put_online_cpus(), we can eliminate
the workqueue_mutex and reintroduce the workqueue_lock,
which is a spinlock which serializes the accesses to the 
workqueues list.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
---
 kernel/workqueue.c |   49 ++++++++++++++++++-------------------------------
 1 file changed, 18 insertions(+), 31 deletions(-)

Index: linux-2.6.23/kernel/workqueue.c
===================================================================
--- linux-2.6.23.orig/kernel/workqueue.c
+++ linux-2.6.23/kernel/workqueue.c
@@ -30,6 +30,7 @@
 #include <linux/hardirq.h>
 #include <linux/mempolicy.h>
 #include <linux/freezer.h>
+#include <linux/cpumask.h>
 #include <linux/kallsyms.h>
 #include <linux/debug_locks.h>
 #include <linux/lockdep.h>
@@ -67,9 +68,8 @@ struct workqueue_struct {
 #endif
 };
 
-/* All the per-cpu workqueues on the system, for hotplug cpu to add/remove
-   threads to each one as cpus come/go. */
-static DEFINE_MUTEX(workqueue_mutex);
+/* Serializes accesses to the workqueues list. */
+static DEFINE_SPINLOCK(workqueue_lock);
 static LIST_HEAD(workqueues);
 
 static int singlethread_cpu __read_mostly;
@@ -712,7 +712,7 @@ static void start_workqueue_thread(struc
 
 	if (p != NULL) {
 		if (cpu >= 0)
-			kthread_bind(p, cpu);
+			set_cpus_allowed(p, cpumask_of_cpu(cpu));
 		wake_up_process(p);
 	}
 }
@@ -748,9 +748,9 @@ struct workqueue_struct *__create_workqu
 		start_workqueue_thread(cwq, -1);
 	} else {
 		get_online_cpus();
-		mutex_lock(&workqueue_mutex);
+		spin_lock(&workqueue_lock);
 		list_add(&wq->list, &workqueues);
-		mutex_unlock(&workqueue_mutex);
+		spin_unlock(&workqueue_lock);
 
 		for_each_possible_cpu(cpu) {
 			cwq = init_cpu_workqueue(wq, cpu);
@@ -773,26 +773,19 @@ EXPORT_SYMBOL_GPL(__create_workqueue_key
 static void cleanup_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
 {
 	/*
-	 * Our caller is either destroy_workqueue() or CPU_DEAD,
-	 * workqueue_mutex protects cwq->thread
+	 * Our caller is destroy_workqueue().  So warn on a double
+	 * destroy.
 	 */
-	if (cwq->thread == NULL)
+	if (cwq->thread == NULL) {
+		WARN_ON(1);
 		return;
+	}
 
 	lock_acquire(&cwq->wq->lockdep_map, 0, 0, 0, 2, _THIS_IP_);
 	lock_release(&cwq->wq->lockdep_map, 1, _THIS_IP_);
 
 	flush_cpu_workqueue(cwq);
-	/*
-	 * If the caller is CPU_DEAD and cwq->worklist was not empty,
-	 * a concurrent flush_workqueue() can insert a barrier after us.
-	 * However, in that case run_workqueue() won't return and check
-	 * kthread_should_stop() until it flushes all work_struct's.
-	 * When ->worklist becomes empty it is safe to exit because no
-	 * more work_structs can be queued on this cwq: flush_workqueue
-	 * checks list_empty(), and a "normal" queue_work() can't use
-	 * a dead CPU.
-	 */
+
 	kthread_stop(cwq->thread);
 	cwq->thread = NULL;
 }
@@ -810,9 +803,9 @@ void destroy_workqueue(struct workqueue_
 	int cpu;
 
 	get_online_cpus();
-	mutex_lock(&workqueue_mutex);
+	spin_lock(&workqueue_lock);
 	list_del(&wq->list);
-	mutex_unlock(&workqueue_mutex);
+	spin_unlock(&workqueue_lock);
 	put_online_cpus();
 
 	for_each_cpu_mask(cpu, *cpu_map) {
@@ -842,33 +835,27 @@ static int __devinit workqueue_cpu_callb
 		cpu_set(cpu, cpu_populated_map);
 	}
 
-	mutex_lock(&workqueue_mutex);
 	list_for_each_entry(wq, &workqueues, list) {
 		cwq = per_cpu_ptr(wq->cpu_wq, cpu);
 
 		switch (action) {
 		case CPU_UP_PREPARE:
+			if (likely(cwq->thread != NULL))
+				break;
 			if (!create_workqueue_thread(cwq, cpu))
 				break;
 			printk(KERN_ERR "workqueue [%s] for %i failed\n",
 				wq->name, cpu);
 			ret = NOTIFY_BAD;
-			goto out_unlock;
+			goto out;
 
 		case CPU_ONLINE:
 			start_workqueue_thread(cwq, cpu);
 			break;
-
-		case CPU_UP_CANCELED:
-			start_workqueue_thread(cwq, -1);
-		case CPU_DEAD:
-			cleanup_workqueue_thread(cwq, cpu);
-			break;
 		}
 	}
 
-out_unlock:
-	mutex_unlock(&workqueue_mutex);
+out:
 	return ret;
 }
 
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
