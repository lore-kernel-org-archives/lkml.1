Return-Path: <linux-kernel-owner+w=401wt.eu-S1758463AbZD1Kya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758463AbZD1Kya (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 06:54:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756255AbZD1KyV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 06:54:21 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51900 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754712AbZD1KyU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 06:54:20 -0400
Message-ID: <49F6E036.5020705@cn.fujitsu.com>
Date: Tue, 28 Apr 2009 18:53:42 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Tom Zanussi <tzanussi@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/4] tracing/workqueue: Avoid accessing task_struct's member
 variable in stat file read
References: <49F6DFB5.2040901@cn.fujitsu.com>
In-Reply-To: <49F6DFB5.2040901@cn.fujitsu.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Workqueue task maybe destroyed when read stat file.
We should avoid getting information from task_struct this time.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Reported-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/trace_workqueue.c |   50 ++++++++++++++++++++--------------------
 1 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/kernel/trace/trace_workqueue.c b/kernel/trace/trace_workqueue.c
index 7a07d17..51ed57e 100644
--- a/kernel/trace/trace_workqueue.c
+++ b/kernel/trace/trace_workqueue.c
@@ -28,14 +28,22 @@ struct workfunc_stats {
 
 /* A cpu workqueue thread */
 struct cpu_workqueue_stats {
-	struct list_head            list;
-	int		            cpu;
-	pid_t			    pid;
+	struct list_head	list;
+	int			cpu;
+
 	/* Protected by cpu workqueue lock */
-	unsigned int	            inserted;
-	unsigned int		    executed;
+	unsigned int		inserted;
+	unsigned int		executed;
 	/* list of struct workfunc_stats in this workqueue */
-	struct list_head            workfunclist;
+	struct list_head	workfunclist;
+
+	/*
+	 * the task maybe destroyed when we read stat file
+	 * we define it to void * because we only use it as a identifier
+	 */
+	void			*task;
+	int			pid;
+	char			comm[TASK_COMM_LEN];
 };
 
 /* List of workqueue threads on one cpu */
@@ -93,7 +101,7 @@ probe_worklet_enqueue(struct task_struct *wq_thread, struct work_struct *work,
 
 	spin_lock_irqsave(&workqueue_cpu_stat(wqcpu)->lock, flags);
 	list_for_each_entry(node, &workqueue_cpu_stat(wqcpu)->list, list) {
-		if (node->pid == wq_thread->pid) {
+		if (node->task == wq_thread) {
 			/* we ignore error of do_worklet_insertion */
 			do_worklet_enqueue(node, work);
 			goto found;
@@ -124,7 +132,7 @@ probe_worklet_execute(struct task_struct *wq_thread, struct work_struct *work)
 	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
 
 	list_for_each_entry(node, &workqueue_cpu_stat(cpu)->list, list)
-		if (node->pid == wq_thread->pid) {
+		if (node->task == wq_thread) {
 			node->executed++;
 			goto found_wq;
 		}
@@ -163,7 +171,9 @@ static void probe_workqueue_creation(struct task_struct *wq_thread, int cpu)
 	INIT_LIST_HEAD(&cws->list);
 	cws->cpu = cpu;
 
+	cws->task = wq_thread;
 	cws->pid = wq_thread->pid;
+	strncpy(cws->comm, wq_thread->comm, TASK_COMM_LEN);
 	INIT_LIST_HEAD(&cws->workfunclist);
 
 	/*
@@ -204,7 +214,7 @@ static void probe_workqueue_destruction(struct task_struct *wq_thread)
 				 list) {
 		struct workfunc_stats *wfstat, *wfstatnext;
 
-		if (node->pid != wq_thread->pid)
+		if (node->task != wq_thread)
 			continue;
 
 		list_for_each_entry_safe(wfstat, wfstatnext,
@@ -304,25 +314,15 @@ static int workqueue_stat_show(struct seq_file *s, void *p)
 {
 	struct workfunc_stats *wfstat = p;
 	struct cpu_workqueue_stats *cws = wfstat->parent;
-	struct pid *pid;
-	struct task_struct *tsk;
 
 	if (!wfstat->func) {
 		/* It is first dummy node, need to print workqueue info */
-		pid = find_get_pid(cws->pid);
-		if (pid) {
-			tsk = get_pid_task(pid, PIDTYPE_PID);
-			if (tsk) {
-				seq_printf(s, "%3d %6d     %6u       %s:%d\n",
-					   cws->cpu,
-					   cws->inserted,
-					   cws->executed,
-					   tsk->comm,
-					   cws->pid);
-				put_task_struct(tsk);
-			}
-			put_pid(pid);
-		}
+		seq_printf(s, "%3d %6d     %6u       %s:%d\n",
+			   cws->cpu,
+			   cws->inserted,
+			   cws->executed,
+			   cws->comm,
+			   cws->pid);
 	} else {
 		/* It is effect node, need to print workfunc info */
 		int lastwf = list_is_last(&wfstat->list, &cws->workfunclist);
-- 
1.5.5.3


