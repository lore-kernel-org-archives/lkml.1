Return-Path: <linux-kernel-owner+w=401wt.eu-S1761857AbZD3Acj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761857AbZD3Acj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 20:32:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761494AbZD3A1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 20:27:53 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:48086 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761454AbZD3A1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 20:27:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=HmbEEQQXReK6sxlxczbdWN7V5KBKRC2VZCbYRirleu/2MzK/SOI5n/YEY8sSVjL3qa
         Hd8Rd66i4ajpxNyTfHHZ9ZwvztvD95o3pRzK0Q92EBBmGGuy5Kff/3V7hrRC96Wo2UqU
         CPNUiCKx9D1GlY7bgEXDNZ0o6yLpgKtPrMtLY=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Zhao Lei <zhaolei@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Tom Zanussi <tzanussi@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 14/19] tracing/workqueue: add max execution time mesurement for per worklet
Date: Thu, 30 Apr 2009 02:27:15 +0200
Message-Id: <1241051240-4280-15-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1241051240-4280-1-git-send-email-fweisbec@gmail.com>
References: <1241051240-4280-1-git-send-email-fweisbec@gmail.com>
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

[ Impact: provide per-worklet latency measurement ]

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 kernel/trace/trace_workqueue.c |   83 +++++++++++++++++++++++++++++++++------
 1 files changed, 70 insertions(+), 13 deletions(-)

diff --git a/kernel/trace/trace_workqueue.c b/kernel/trace/trace_workqueue.c
index b995bc0..798a738 100644
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
1.6.2.3

