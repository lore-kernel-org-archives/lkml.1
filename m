Return-Path: <linux-kernel-owner+w=401wt.eu-S1762222AbZD3Abt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762222AbZD3Abt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 20:31:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761502AbZD3A1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 20:27:48 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:48086 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761387AbZD3A1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 20:27:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=SpzvYP4r6m7A2wF6qMxkAmU7mO/tLnNLAoCEyK98JDngF/dPjGeVP41/cjB/lr75sa
         1mI89Hmrksa+WRnY+oJjXFSNJCbHn0BR47QN1VPLyPgvBbgMeF1NO9DcbuLogmwcAfo1
         LouGIx4agz5C8LAMSUYdKLnDq6Jrj7vAMcFns=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Tom Zanussi <tzanussi@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Oleg Nesterov <oleg@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 12/19] tracing/workqueue: avoid accessing task_struct's member variable in stat file read
Date: Thu, 30 Apr 2009 02:27:13 +0200
Message-Id: <1241051240-4280-13-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1241051240-4280-1-git-send-email-fweisbec@gmail.com>
References: <1241051240-4280-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhaolei <zhaolei@cn.fujitsu.com>

Workqueue task may be destroyed when we read the stat file.
We should avoid getting information from task_struct this time.

[ Impact: fix possible NULL pointer dereference ]

Reported-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
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
1.6.2.3

