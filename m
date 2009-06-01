Return-Path: <linux-kernel-owner+w=401wt.eu-S1758666AbZFARRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758666AbZFARRs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 13:17:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755548AbZFARRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 13:17:22 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:61974 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756934AbZFARRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 13:17:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=rfRc3FOtCRx+SO566ZAkJWKPPZsqF/L4SHofVlnJYFcpu36MAymu9pJgpqp3SPU3Il
         5OdJGnaUeQjNvoebIHwXqH0AE6rybRmhROpn0yqdToPDlmYOB2OtfAUvuXd6jP0YtY48
         C6Ld9xF39FRO7fQcF5G2GVzEPiKsH3Z9TSDb8=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Oleg Nesterov <oleg@redhat.com>, Anton Blanchard <anton@samba.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/5] tracing/workqueue: get rid of searching last executed worklet in probe_worklet_complete()
Date: Mon,  1 Jun 2009 19:17:13 +0200
Message-Id: <1243876637-6616-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1243876637-6616-1-git-send-email-fweisbec@gmail.com>
References: <1243876637-6616-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhaolei <zhaolei@cn.fujitsu.com>

We don't need to search the worklet which was latest executed
inside the workqueue's worklet list.

Instead, we can use a pointer in cpu_workqueue_stats to remember
which worklet was last executed.

Thanks Oleg for pointing it out.

Changelog:
v1->v2: Oleg pointed out that if searching executed workfunc_stats failed
in probe_worklet_execute(), for example, workfunc_stats's memory allocation
failed previously, cpu_workqueue_stats->last_workfunc is not set to correct
value, and it will cause wrong accessing in probe_worklet_complete().
This problem is fixed in v2.

[ Impact: make worklet tracing faster ]

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Reported-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace_workqueue.c |   39 ++++++++++++++++-----------------------
 1 files changed, 16 insertions(+), 23 deletions(-)

diff --git a/kernel/trace/trace_workqueue.c b/kernel/trace/trace_workqueue.c
index c67be60..740de3b 100644
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
@@ -163,9 +163,10 @@ found_wq:
 		if (wfnode->func == work->func) {
 			wfnode->executed++;
 			wfnode->start_time = trace_clock_global();
-			wfnode->work = work;
+			node->last_workfunc = wfnode;
 			goto found_wf;
 		}
+	node->last_workfunc = NULL;
 	pr_debug("trace_workqueue: worklet not found\n");
 	goto end;
 
@@ -180,7 +181,7 @@ probe_worklet_complete(struct task_struct *wq_thread, void *work)
 {
 	int cpu = cpumask_first(&wq_thread->cpus_allowed);
 	struct cpu_workqueue_stats *node;
-	struct workfunc_stats *wfnode;
+	u64 executed_time;
 	unsigned long flags;
 
 	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
@@ -192,22 +193,14 @@ probe_worklet_complete(struct task_struct *wq_thread, void *work)
 	goto end;
 
 found_wq:
-	list_for_each_entry(wfnode, &node->workfunclist, list) {
-		u64 executed_time;
+	if (!node->last_workfunc)
+		goto end;
 
-		if (wfnode->work != work)
-			continue;
+	executed_time = trace_clock_global() - node->last_workfunc->start_time;
+	node->last_workfunc->total_time += executed_time;
+	if (executed_time > node->last_workfunc->max_executed_time)
+		node->last_workfunc->max_executed_time = executed_time;
 
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
1.6.2.3

