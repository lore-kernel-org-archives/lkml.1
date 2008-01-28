Return-Path: <linux-kernel-owner+w=401wt.eu-S1754206AbYA1Eez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206AbYA1Eez (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 23:34:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754541AbYA1Edi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 23:33:38 -0500
Received: from warlock.qualcomm.com ([129.46.50.49]:41107 "EHLO
	warlock.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923AbYA1Eda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 23:33:30 -0500
X-Greylist: delayed 666 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Jan 2008 23:33:28 EST
From: maxk@qualcomm.com
To: linux-kernel@vger.kernel.org
Cc: Max Krasnyansky <maxk@qualcomm.com>
Subject: [PATCH] [CPUISOL] Support for workqueue isolation
Date: Sun, 27 Jan 2008 20:09:41 -0800
Message-Id: <1201493382-29804-5-git-send-email-maxk@qualcomm.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1201493382-29804-4-git-send-email-maxk@qualcomm.com>
References: <1201493382-29804-1-git-send-email-maxk@qualcomm.com>
 <1201493382-29804-2-git-send-email-maxk@qualcomm.com>
 <1201493382-29804-3-git-send-email-maxk@qualcomm.com>
 <1201493382-29804-4-git-send-email-maxk@qualcomm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Max Krasnyansky <maxk@qualcomm.com>

I'm sure this one is going to be controversial for a lot of folks here.
So let me explain :).
What this patch is trying to address is the case when a high priority
realtime (FIFO, RR) user-space thread is using 100% CPU for extended periods
of time. In which case kernel workqueue threads do not get a chance to run and
entire machine essentially hangs because other CPUs are waiting for scheduled
workqueues to flush.
This use case is perfectly valid if one is using a CPU as a dedicated engine
(crunching numbers, hard realtime, etc). Think of it as an SPE in the Cell processor.
Which is what CPU isolation enables in first place.
Most kernel subsystems do not rely on the per CPU workqueues. In fact we already
have support for single threaded workqueues, this patch just makes it automatic.
Some subsystems namely OProfile do rely on per CPU workqueues and do not work when
this feature is enabled. It does not result in crashes or anything OProfile is just
unable to collect stats from isolated CPUs. Hence this feature is marked as
experimental.
There is zero overhead if CPU workqueue isolation is disabled.
Better ideas/suggestions on how to handle use case described above are welcome
of course.

Signed-off-by: Max Krasnyansky <maxk@qualcomm.com>
---
 kernel/workqueue.c |   30 +++++++++++++++++++++++-------
 1 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 52db48e..ed2f09b 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -35,6 +35,16 @@
 #include <linux/lockdep.h>
 
 /*
+ * Stub out cpu_isolated() if isolated CPUs are allowed to 
+ * run workqueues.
+ */
+#ifdef CONFIG_CPUISOL_WORKQUEUE
+#define cpu_unusable(cpu) cpu_isolated(cpu)
+#else
+#define cpu_unusable(cpu) (0)
+#endif
+
+/*
  * The per-CPU workqueue (if single thread, we always use the first
  * possible cpu).
  */
@@ -97,7 +107,7 @@ static const cpumask_t *wq_cpu_map(struct workqueue_struct *wq)
 static
 struct cpu_workqueue_struct *wq_per_cpu(struct workqueue_struct *wq, int cpu)
 {
-	if (unlikely(is_single_threaded(wq)))
+	if (unlikely(is_single_threaded(wq)) || cpu_unusable(cpu))
 		cpu = singlethread_cpu;
 	return per_cpu_ptr(wq->cpu_wq, cpu);
 }
@@ -229,9 +239,11 @@ int queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
 		timer->data = (unsigned long)dwork;
 		timer->function = delayed_work_timer_fn;
 
-		if (unlikely(cpu >= 0))
+		if (unlikely(cpu >= 0)) {
+			if (cpu_unusable(cpu))
+				cpu = singlethread_cpu;
 			add_timer_on(timer, cpu);
-		else
+		} else
 			add_timer(timer);
 		ret = 1;
 	}
@@ -605,7 +617,8 @@ int schedule_on_each_cpu(work_func_t func)
 	get_online_cpus();
 	for_each_online_cpu(cpu) {
 		struct work_struct *work = per_cpu_ptr(works, cpu);
-
+		if (cpu_unusable(cpu))
+			continue;
 		INIT_WORK(work, func);
 		set_bit(WORK_STRUCT_PENDING, work_data_bits(work));
 		__queue_work(per_cpu_ptr(keventd_wq->cpu_wq, cpu), work);
@@ -754,7 +767,7 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
 
 		for_each_possible_cpu(cpu) {
 			cwq = init_cpu_workqueue(wq, cpu);
-			if (err || !cpu_online(cpu))
+			if (err || !cpu_online(cpu) || cpu_unusable(cpu))
 				continue;
 			err = create_workqueue_thread(cwq, cpu);
 			start_workqueue_thread(cwq, cpu);
@@ -833,8 +846,11 @@ static int __devinit workqueue_cpu_callback(struct notifier_block *nfb,
 	struct cpu_workqueue_struct *cwq;
 	struct workqueue_struct *wq;
 
-	action &= ~CPU_TASKS_FROZEN;
+	if (cpu_unusable(cpu))
+		return NOTIFY_OK;
 
+	action &= ~CPU_TASKS_FROZEN;
+	
 	switch (action) {
 
 	case CPU_UP_PREPARE:
@@ -869,7 +885,7 @@ static int __devinit workqueue_cpu_callback(struct notifier_block *nfb,
 
 void __init init_workqueues(void)
 {
-	cpu_populated_map = cpu_online_map;
+	cpus_andnot(cpu_populated_map, cpu_online_map, cpu_isolated_map);
 	singlethread_cpu = first_cpu(cpu_possible_map);
 	cpu_singlethread_map = cpumask_of_cpu(singlethread_cpu);
 	hotcpu_notifier(workqueue_cpu_callback, 0);
-- 
1.5.3.7

