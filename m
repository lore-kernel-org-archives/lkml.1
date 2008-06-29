Return-Path: <linux-kernel-owner+w=401wt.eu-S1757291AbYF2Qus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757291AbYF2Qus (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 12:50:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756226AbYF2Qtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 12:49:51 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:40400 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753663AbYF2Qtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 12:49:39 -0400
Date: Sun, 29 Jun 2008 20:51:31 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gautham R Shenoy <ego@in.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Max Krasnyansky <maxk@qualcomm.com>, Paul Jackson <pj@sgi.com>,
       Paul Menage <menage@google.com>, Peter Zijlstra <peterz@infradead.org>,
       Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] workqueues: make get_online_cpus() useable for work->func()
Message-ID: <20080629165131.GA11215@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

workqueue_cpu_callback(CPU_DEAD) flushes cwq->thread under
cpu_maps_update_begin(). This means that the multithreaded workqueues can't
use get_online_cpus() due to the possible deadlock, very bad and very old
problem.

Introduce the new state, CPU_POST_DEAD, which is called after
cpu_hotplug_done() but before cpu_maps_update_done().

Change workqueue_cpu_callback() to use CPU_POST_DEAD instead of CPU_DEAD.
This means that create/destroy functions can't rely on get_online_cpus()
any longer and should take cpu_add_remove_lock instead.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

 include/linux/notifier.h |    2 ++
 kernel/cpu.c             |    5 +++++
 kernel/workqueue.c       |   18 +++++++++---------
 3 files changed, 16 insertions(+), 9 deletions(-)

--- 26-rc2/include/linux/notifier.h~WQ_4_GET_ONLINE_CPUS	2008-05-18 15:44:16.000000000 +0400
+++ 26-rc2/include/linux/notifier.h	2008-05-18 15:44:16.000000000 +0400
@@ -213,6 +213,8 @@ static inline int notifier_to_errno(int 
 #define CPU_DEAD		0x0007 /* CPU (unsigned)v dead */
 #define CPU_DYING		0x0008 /* CPU (unsigned)v not running any task,
 				        * not handling interrupts, soon dead */
+#define CPU_POST_DEAD		0x0009 /* CPU (unsigned)v dead, cpu_hotplug
+					* lock is dropped */
 
 /* Used for CPU hotplug events occuring while tasks are frozen due to a suspend
  * operation in progress
--- 26-rc2/kernel/cpu.c~WQ_4_GET_ONLINE_CPUS	2008-05-18 15:44:18.000000000 +0400
+++ 26-rc2/kernel/cpu.c	2008-06-29 20:03:19.000000000 +0400
@@ -261,6 +261,11 @@ out_allowed:
 	set_cpus_allowed_ptr(current, &old_allowed);
 out_release:
 	cpu_hotplug_done();
+	if (!err) {
+		if (raw_notifier_call_chain(&cpu_chain, CPU_POST_DEAD | mod,
+					    hcpu) == NOTIFY_BAD)
+			BUG();
+	}
 	return err;
 }
 
--- 26-rc2/kernel/workqueue.c~WQ_4_GET_ONLINE_CPUS	2008-06-29 18:34:06.000000000 +0400
+++ 26-rc2/kernel/workqueue.c	2008-06-29 19:36:27.000000000 +0400
@@ -791,7 +791,7 @@ struct workqueue_struct *__create_workqu
 		err = create_workqueue_thread(cwq, singlethread_cpu);
 		start_workqueue_thread(cwq, -1);
 	} else {
-		get_online_cpus();
+		cpu_maps_update_begin();
 		spin_lock(&workqueue_lock);
 		list_add(&wq->list, &workqueues);
 		spin_unlock(&workqueue_lock);
@@ -803,7 +803,7 @@ struct workqueue_struct *__create_workqu
 			err = create_workqueue_thread(cwq, cpu);
 			start_workqueue_thread(cwq, cpu);
 		}
-		put_online_cpus();
+		cpu_maps_update_done();
 	}
 
 	if (err) {
@@ -817,8 +817,8 @@ EXPORT_SYMBOL_GPL(__create_workqueue_key
 static void cleanup_workqueue_thread(struct cpu_workqueue_struct *cwq)
 {
 	/*
-	 * Our caller is either destroy_workqueue() or CPU_DEAD,
-	 * get_online_cpus() protects cwq->thread.
+	 * Our caller is either destroy_workqueue() or CPU_POST_DEAD,
+	 * cpu_add_remove_lock protects cwq->thread.
 	 */
 	if (cwq->thread == NULL)
 		return;
@@ -828,7 +828,7 @@ static void cleanup_workqueue_thread(str
 
 	flush_cpu_workqueue(cwq);
 	/*
-	 * If the caller is CPU_DEAD and cwq->worklist was not empty,
+	 * If the caller is CPU_POST_DEAD and cwq->worklist was not empty,
 	 * a concurrent flush_workqueue() can insert a barrier after us.
 	 * However, in that case run_workqueue() won't return and check
 	 * kthread_should_stop() until it flushes all work_struct's.
@@ -852,14 +852,14 @@ void destroy_workqueue(struct workqueue_
 	const cpumask_t *cpu_map = wq_cpu_map(wq);
 	int cpu;
 
-	get_online_cpus();
+	cpu_maps_update_begin();
 	spin_lock(&workqueue_lock);
 	list_del(&wq->list);
 	spin_unlock(&workqueue_lock);
 
 	for_each_cpu_mask(cpu, *cpu_map)
 		cleanup_workqueue_thread(per_cpu_ptr(wq->cpu_wq, cpu));
-	put_online_cpus();
+	cpu_maps_update_done();
 
 	free_percpu(wq->cpu_wq);
 	kfree(wq);
@@ -898,7 +898,7 @@ static int __devinit workqueue_cpu_callb
 
 		case CPU_UP_CANCELED:
 			start_workqueue_thread(cwq, -1);
-		case CPU_DEAD:
+		case CPU_POST_DEAD:
 			cleanup_workqueue_thread(cwq);
 			break;
 		}
@@ -906,7 +906,7 @@ static int __devinit workqueue_cpu_callb
 
 	switch (action) {
 	case CPU_UP_CANCELED:
-	case CPU_DEAD:
+	case CPU_POST_DEAD:
 		cpu_clear(cpu, cpu_populated_map);
 	}
 

