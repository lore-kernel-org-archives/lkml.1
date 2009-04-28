Return-Path: <linux-kernel-owner+w=401wt.eu-S1757973AbZD1K6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757973AbZD1K6P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 06:58:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755551AbZD1K54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 06:57:56 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54610 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754346AbZD1K5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 06:57:54 -0400
Message-ID: <49F6E10A.5050203@cn.fujitsu.com>
Date: Tue, 28 Apr 2009 18:57:14 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Tom Zanussi <tzanussi@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/4] tracing/workqueue: Add max execution time mesurement
 for per worklet
References: <49F6DFB5.2040901@cn.fujitsu.com>
In-Reply-To: <49F6DFB5.2040901@cn.fujitsu.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

It is useful for driver-developer and system administrator to
know which worklet runs how many time.

Change Log:
v1: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
    add max execution time mesurement for per workqueue
v2: Zhao Lei <zhaolei@cn.fujitsu.com>
    add max execution time mesurement for per worklet instead of workqueue

Output is like:
 # CPU INSERTED EXECUTED M_EXECus TASKNAME:PID
 #  |     |        |        |      `-WORKFUNC
 #  |     |        |        |        |
     0      905      973          events/0:5
     0        1        1       37  |-reg_todo+0x0/0x41f
     0       13       12     2033  |-rt_worker_func+0x0/0x219
     0       49       48     3157  |-mce_work_fn+0x0/0x31
     0       14       13      939  |-check_corruption+0x0/0x2a
     0      707      706     3826  |-vmstat_update+0x0/0x33
     0        1        1     1846  |-power_supply_changed_work+0x0/0x3c
     0       11       11     2879  |-console_callback+0x0/0xe1
     0       30       29     1579  |-do_cache_clean+0x0/0x37
     0       74       74     2841  |-test_work+0x0/0x53
     0        3        2      252  |-rekey_seq_generator+0x0/0x5a
     0        1        1       21  |-grace_ender+0x0/0x14
     0        1        1     3701  `-flush_to_ldisc+0x0/0x15d
     0        0        0          cpuset:6
     0      658      658          khelper:7
     0      658      658     5735  `-__call_usermodehelper+0x0/0x77
     0        0        0          netns:11
 ...

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 kernel/trace/trace_workqueue.c |   83 +++++++++++++++++++++++++++++++++------
 1 files changed, 70 insertions(+), 13 deletions(-)

diff --git a/kernel/trace/trace_workqueue.c b/kernel/trace/trace_workqueue.c
index b995bc0..30b0075 100644
--- a/kernel/trace/trace_workqueue.c
+++ b/kernel/trace/trace_workqueue.c
@@ -24,6 +24,17 @@ struct workfunc_stats {
 	/* Protected by cpu workqueue lock */
 	unsigned int			inserted;
 	unsigned int			executed;
+
+	/*
+	 * save latest work_struct's pointer to use as identifier in
+	 * probe_worklet_complete, because we can't use work_struct->...
+	 * after worklet got executed
+	 */
+	void				*work;
+
+	/* save execution time temporarily for calculate executed time */
+	u64				start_time;
+	u64				max_executed_time;
 };
 
 /* A cpu workqueue thread */
@@ -143,6 +154,8 @@ found_wq:
 	list_for_each_entry(wfnode, &node->workfunclist, list)
 		if (wfnode->func == work->func) {
 			wfnode->executed++;
+			wfnode->start_time = trace_clock_global();
+			wfnode->work = work;
 			goto found_wf;
 		}
 	pr_debug("trace_workqueue: worklet not found\n");
@@ -153,6 +166,43 @@ end:
 	spin_unlock_irqrestore(&workqueue_cpu_stat(cpu)->lock, flags);
 }
 
+/* Complete of a work */
+static void
+probe_worklet_complete(struct task_struct *wq_thread, void *work)
+{
+	int cpu = cpumask_first(&wq_thread->cpus_allowed);
+	struct cpu_workqueue_stats *node;
+	struct workfunc_stats *wfnode;
+	unsigned long flags;
+
+	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
+
+	list_for_each_entry(node, &workqueue_cpu_stat(cpu)->list, list)
+		if (node->task == wq_thread)
+			goto found_wq;
+	pr_debug("trace_workqueue: workqueue not found\n");
+	goto end;
+
+found_wq:
+	list_for_each_entry(wfnode, &node->workfunclist, list) {
+		u64 executed_time;
+
+		if (wfnode->work != work)
+			continue;
+
+		executed_time = trace_clock_global() - wfnode->start_time;
+		if (executed_time > wfnode->max_executed_time)
+			wfnode->max_executed_time = executed_time;
+		goto found_wf;
+	}
+	pr_debug("trace_workqueue: worklet not found\n");
+	goto end;
+
+found_wf:
+end:
+	spin_unlock_irqrestore(&workqueue_cpu_stat(cpu)->lock, flags);
+}
+
 /* Creation of a cpu workqueue thread */
 static void probe_workqueue_creation(struct task_struct *wq_thread, int cpu)
 {
@@ -316,7 +366,7 @@ static int workqueue_stat_show(struct seq_file *s, void *p)
 
 	if (!wfstat->func) {
 		/* It is first dummy node, need to print workqueue info */
-		seq_printf(s, "%3d %6d     %6u       %s:%d\n",
+		seq_printf(s, "  %3d   %6d   %6u          %s:%d\n",
 			   cws->cpu,
 			   cws->inserted,
 			   cws->executed,
@@ -325,10 +375,11 @@ static int workqueue_stat_show(struct seq_file *s, void *p)
 	} else {
 		/* It is effect node, need to print workfunc info */
 		int lastwf = list_is_last(&wfstat->list, &cws->workfunclist);
-		seq_printf(s, "%3d %6d     %6u        %c-%pF\n",
+		seq_printf(s, "  %3d   %6d   %6u   %6llu  %c-%pF\n",
 			cws->cpu,
 			wfstat->inserted,
 			wfstat->executed,
+			ns2usecs(wfstat->max_executed_time),
 			lastwf ? '`' : '|',
 			wfstat->func);
 	}
@@ -338,9 +389,9 @@ static int workqueue_stat_show(struct seq_file *s, void *p)
 
 static int workqueue_stat_headers(struct seq_file *s)
 {
-	seq_printf(s, "# CPU  INSERTED  EXECUTED   TASKNAME:PID\n");
-	seq_printf(s, "# |      |         |        `-WORKFUNC\n");
-	seq_printf(s, "# |      |         |          |\n");
+	seq_printf(s, "# CPU INSERTED EXECUTED M_EXECus	 TASKNAME:PID\n");
+	seq_printf(s, "#  |     |        |        |      `-WORKFUNC\n");
+	seq_printf(s, "#  |     |        |        |        |\n");
 	return 0;
 }
 
@@ -379,19 +430,23 @@ int __init trace_workqueue_early_init(void)
 	ret = register_trace_worklet_enqueue_delayed(
 		probe_worklet_enqueue_delayed);
 	if (ret)
-		goto no_enqueue;
+		goto out_worklet_enqueue;
 
 	ret = register_trace_worklet_execute(probe_worklet_execute);
 	if (ret)
-		goto no_enqueue_delayed;
+		goto out_worklet_enqueue_delayed;
+
+	ret = register_trace_worklet_complete(probe_worklet_complete);
+	if (ret)
+		goto out_worklet_execute;
 
 	ret = register_trace_workqueue_creation(probe_workqueue_creation);
 	if (ret)
-		goto no_handler_entry;
+		goto out_worklet_complete;
 
 	ret = register_trace_workqueue_destruction(probe_workqueue_destruction);
 	if (ret)
-		goto no_creation;
+		goto out_workqueue_creation;
 
 	for_each_possible_cpu(cpu) {
 		spin_lock_init(&workqueue_cpu_stat(cpu)->lock);
@@ -400,13 +455,15 @@ int __init trace_workqueue_early_init(void)
 
 	return 0;
 
-no_creation:
+out_workqueue_creation:
 	unregister_trace_workqueue_creation(probe_workqueue_creation);
-no_handler_entry:
+out_worklet_complete:
+	unregister_trace_worklet_complete(probe_worklet_complete);
+out_worklet_execute:
 	unregister_trace_worklet_execute(probe_worklet_execute);
-no_enqueue_delayed:
+out_worklet_enqueue_delayed:
 	unregister_trace_worklet_enqueue_delayed(probe_worklet_enqueue_delayed);
-no_enqueue:
+out_worklet_enqueue:
 	unregister_trace_worklet_enqueue(probe_worklet_enqueue);
 out:
 	pr_warning("trace_workqueue: unable to trace workqueues\n");
-- 
1.5.5.3


