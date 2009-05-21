Return-Path: <linux-kernel-owner+w=401wt.eu-S1753608AbZEUK5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608AbZEUK5g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 06:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbZEUK52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 06:57:28 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57715 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752265AbZEUK52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 06:57:28 -0400
Message-ID: <4A153345.3040905@cn.fujitsu.com>
Date: Thu, 21 May 2009 18:56:05 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Tom Zanussi <tzanussi@gmail.com>, Oleg Nesterov <oleg@redhat.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing/workqueue: Get rid of searching last executed worklet
 in probe_worklet_complete()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need search workqueue's worklet list for worklet which was latest
executed, instead, we can use a pointer in cpu_workqueue_stats to remember
which worklet was just executed.

Thanks Oleg for pointing it out.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Reported-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/trace_workqueue.c |   37 +++++++++++++------------------------
 1 files changed, 13 insertions(+), 24 deletions(-)

diff --git a/kernel/trace/trace_workqueue.c b/kernel/trace/trace_workqueue.c
index c67be60..d90f9ac 100644
--- a/kernel/trace/trace_workqueue.c
+++ b/kernel/trace/trace_workqueue.c
@@ -25,13 +25,6 @@ struct workfunc_stats {
 	unsigned int			inserted;
 	unsigned int			executed;
 
-	/*
-	 * save latest work_struct's pointer to use as identifier in
-	 * probe_worklet_complete, because we can't use work_struct->...
-	 * after worklet got executed
-	 */
-	void				*work;
-
 	/* save execution time temporarily for calculate executed time */
 	u64				start_time;
 	u64				max_executed_time;
@@ -46,10 +39,17 @@ struct cpu_workqueue_stats {
 	/* Protected by cpu workqueue lock */
 	unsigned int		inserted;
 	unsigned int		executed;
+
 	/* list of struct workfunc_stats in this workqueue */
 	struct list_head	workfunclist;
 
 	/*
+	 * pointer to last executed worklet's workfunc_stats in this workqueue,
+	 * used by probe_worklet_complete()
+	 */
+	struct workfunc_stats *last_workfunc;
+
+	/*
 	 * the task maybe destroyed when we read stat file
 	 * we define it to void * because we only use it as a identifier
 	 */
@@ -163,7 +163,7 @@ found_wq:
 		if (wfnode->func == work->func) {
 			wfnode->executed++;
 			wfnode->start_time = trace_clock_global();
-			wfnode->work = work;
+			node->last_workfunc = wfnode;
 			goto found_wf;
 		}
 	pr_debug("trace_workqueue: worklet not found\n");
@@ -180,7 +180,7 @@ probe_worklet_complete(struct task_struct *wq_thread, void *work)
 {
 	int cpu = cpumask_first(&wq_thread->cpus_allowed);
 	struct cpu_workqueue_stats *node;
-	struct workfunc_stats *wfnode;
+	u64 executed_time;
 	unsigned long flags;
 
 	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
@@ -192,22 +192,11 @@ probe_worklet_complete(struct task_struct *wq_thread, void *work)
 	goto end;
 
 found_wq:
-	list_for_each_entry(wfnode, &node->workfunclist, list) {
-		u64 executed_time;
+	executed_time = trace_clock_global() - node->last_workfunc->start_time;
+	node->last_workfunc->total_time += executed_time;
+	if (executed_time > node->last_workfunc->max_executed_time)
+		node->last_workfunc->max_executed_time = executed_time;
 
-		if (wfnode->work != work)
-			continue;
-
-		executed_time = trace_clock_global() - wfnode->start_time;
-		wfnode->total_time += executed_time;
-		if (executed_time > wfnode->max_executed_time)
-			wfnode->max_executed_time = executed_time;
-		goto found_wf;
-	}
-	pr_debug("trace_workqueue: worklet not found\n");
-	goto end;
-
-found_wf:
 end:
 	spin_unlock_irqrestore(&workqueue_cpu_stat(cpu)->lock, flags);
 }
-- 
1.5.5.3


