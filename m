Return-Path: <linux-kernel-owner+w=401wt.eu-S1758555AbYBPRTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758555AbYBPRTh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 12:19:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757287AbYBPRTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 12:19:23 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:33383 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756471AbYBPRTW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 12:19:22 -0500
Date: Sat, 16 Feb 2008 20:22:59 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dipankar Sarma <dipankar@in.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Jarek Poplawski <jarkao2@o2.pl>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] workqueues: shrink cpu_populated_map when CPU dies
Message-ID: <20080216172259.GA18524@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When cpu_populated_map was introduced, it was supposed that cwq->thread can
survive after CPU_DEAD, that is why we never shrink cpu_populated_map.

This is not very nice, we can safely remove the already dead CPU from the map.
The only required change is that destroy_workqueue() must hold the hotplug lock
until it destroys all cwq->thread's, to protect the cpu_populated_map. We could
make the local copy of cpu mask and drop the lock, but sizeof(cpumask_t) may be
very large.

Also, fix the comment near queue_work(). Unless _cpu_down() happens we do
guarantee the cpu-affinity of the work_struct, and we have users which rely on
this.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/kernel/workqueue.c~2_WQ_CPU_MAP	2008-02-15 16:59:18.000000000 +0300
+++ 25/kernel/workqueue.c	2008-02-16 19:33:03.000000000 +0300
@@ -158,8 +158,8 @@ static void __queue_work(struct cpu_work
  *
  * Returns 0 if @work was already on a queue, non-zero otherwise.
  *
- * We queue the work to the CPU it was submitted, but there is no
- * guarantee that it will be processed by that CPU.
+ * We queue the work to the CPU it was submitted, but if CPU dies
+ * it can be processed by another CPU.
  */
 int queue_work(struct workqueue_struct *wq, struct work_struct *work)
 {
@@ -813,12 +813,12 @@ void destroy_workqueue(struct workqueue_
 	spin_lock(&workqueue_lock);
 	list_del(&wq->list);
 	spin_unlock(&workqueue_lock);
-	put_online_cpus();
 
 	for_each_cpu_mask(cpu, *cpu_map) {
 		cwq = per_cpu_ptr(wq->cpu_wq, cpu);
 		cleanup_workqueue_thread(cwq, cpu);
 	}
+	put_online_cpus();
 
 	free_percpu(wq->cpu_wq);
 	kfree(wq);
@@ -836,7 +836,6 @@ static int __devinit workqueue_cpu_callb
 	action &= ~CPU_TASKS_FROZEN;
 
 	switch (action) {
-
 	case CPU_UP_PREPARE:
 		cpu_set(cpu, cpu_populated_map);
 	}
@@ -864,6 +863,12 @@ static int __devinit workqueue_cpu_callb
 		}
 	}
 
+	switch (action) {
+	case CPU_UP_CANCELED:
+	case CPU_DEAD:
+		cpu_clear(cpu, cpu_populated_map);
+	}
+
 	return NOTIFY_OK;
 }
 

