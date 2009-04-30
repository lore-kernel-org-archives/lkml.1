Return-Path: <linux-kernel-owner+w=401wt.eu-S1762140AbZD3Aah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762140AbZD3Aah (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 20:30:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760306AbZD3A1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 20:27:42 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:47689 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759668AbZD3A1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 20:27:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=JTlfDRXXkKdoPnOG/G+DS6sPgx0u8fGvcTN6f5uW2l8tZ2OKGXKsH9NMLkMlWeTb3I
         PltSWo1pDge/Uli9wCOzhhKWVnv1ASzotS9PlyW895ZlsdcH2Plovy0wU4TVhNarQ+B1
         CcOp2+te/sqmPF0eZSFWp5mrvvNd4q1jyRVic=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Tom Zanussi <tzanussi@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 09/19] workqueue_tracepoint: change tracepoint name to fit worklet and workqueue lifecycle
Date: Thu, 30 Apr 2009 02:27:10 +0200
Message-Id: <1241051240-4280-10-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1241051240-4280-1-git-send-email-fweisbec@gmail.com>
References: <1241051240-4280-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhaolei <zhaolei@cn.fujitsu.com>

Change list:
  workqueue_insertion -> worklet_insertion
  workqueue_handler_entry -> worklet_execute
  workqueue_handler_exit -> worklet_complete

Tracepoint list after change:
  worklet_insertion
  worklet_execute
  worklet_complete
  worklet_cancel
  workqueue_creation
  workqueue_flush
  workqueue_destruction

[ Impact: cleanup, change names of tracepoints to be more accurate ]

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/trace/events/workqueue.h |    6 +++---
 kernel/trace/trace_workqueue.c   |   21 ++++++++++-----------
 kernel/workqueue.c               |    6 +++---
 3 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/include/trace/events/workqueue.h b/include/trace/events/workqueue.h
index 2e77e84..fb35cc7 100644
--- a/include/trace/events/workqueue.h
+++ b/include/trace/events/workqueue.h
@@ -8,7 +8,7 @@
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM workqueue
 
-TRACE_EVENT(workqueue_insertion,
+TRACE_EVENT(worklet_insertion,
 
 	TP_PROTO(struct task_struct *wq_thread, struct work_struct *work),
 
@@ -30,7 +30,7 @@ TRACE_EVENT(workqueue_insertion,
 		__entry->thread_pid, __entry->func)
 );
 
-TRACE_EVENT(workqueue_handler_entry,
+TRACE_EVENT(worklet_execute,
 
 	TP_PROTO(struct task_struct *wq_thread, struct work_struct *work),
 
@@ -55,7 +55,7 @@ TRACE_EVENT(workqueue_handler_entry,
 );
 
 /* Declare work as void *, because we can't use work->... in after f(work) */
-TRACE_EVENT(workqueue_handler_exit,
+TRACE_EVENT(worklet_complete,
 	TP_PROTO(struct task_struct *wq_thread, void *work),
 
 	TP_ARGS(wq_thread, work),
diff --git a/kernel/trace/trace_workqueue.c b/kernel/trace/trace_workqueue.c
index 8d26db6..e3e1218 100644
--- a/kernel/trace/trace_workqueue.c
+++ b/kernel/trace/trace_workqueue.c
@@ -57,8 +57,8 @@ static DEFINE_PER_CPU(struct workqueue_global_stats, all_workqueue_stat);
  * Update record when insert a work into workqueue
  * Caller need to hold cpu_workqueue_stats spin_lock
  */
-int do_workqueue_insertion(struct cpu_workqueue_stats *cws,
-			   struct work_struct *work)
+int do_worklet_insertion(struct cpu_workqueue_stats *cws,
+			 struct work_struct *work)
 {
 	struct workfunc_stats *wfstat;
 
@@ -87,7 +87,7 @@ found:
 
 /* Insertion of a work */
 static void
-probe_workqueue_insertion(struct task_struct *wq_thread,
+probe_worklet_insertion(struct task_struct *wq_thread,
 			  struct work_struct *work)
 {
 	int cpu = cpumask_first(&wq_thread->cpus_allowed);
@@ -97,8 +97,8 @@ probe_workqueue_insertion(struct task_struct *wq_thread,
 	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
 	list_for_each_entry(node, &workqueue_cpu_stat(cpu)->list, list) {
 		if (node->pid == wq_thread->pid) {
-			/* we ignore error of do_workqueue_insertion */
-			do_workqueue_insertion(node, work);
+			/* we ignore error of do_worklet_insertion */
+			do_worklet_insertion(node, work);
 			goto found;
 		}
 	}
@@ -109,8 +109,7 @@ found:
 
 /* Execution of a work */
 static void
-probe_workqueue_entry(struct task_struct *wq_thread,
-			  struct work_struct *work)
+probe_worklet_execute(struct task_struct *wq_thread, struct work_struct *work)
 {
 	int cpu = cpumask_first(&wq_thread->cpus_allowed);
 	struct cpu_workqueue_stats *node;
@@ -369,11 +368,11 @@ int __init trace_workqueue_early_init(void)
 {
 	int ret, cpu;
 
-	ret = register_trace_workqueue_insertion(probe_workqueue_insertion);
+	ret = register_trace_worklet_insertion(probe_worklet_insertion);
 	if (ret)
 		goto out;
 
-	ret = register_trace_workqueue_handler_entry(probe_workqueue_entry);
+	ret = register_trace_worklet_execute(probe_worklet_execute);
 	if (ret)
 		goto no_insertion;
 
@@ -395,9 +394,9 @@ int __init trace_workqueue_early_init(void)
 no_creation:
 	unregister_trace_workqueue_creation(probe_workqueue_creation);
 no_handler_entry:
-	unregister_trace_workqueue_handler_entry(probe_workqueue_entry);
+	unregister_trace_worklet_execute(probe_worklet_execute);
 no_insertion:
-	unregister_trace_workqueue_insertion(probe_workqueue_insertion);
+	unregister_trace_worklet_insertion(probe_worklet_insertion);
 out:
 	pr_warning("trace_workqueue: unable to trace workqueues\n");
 
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 99a81ba..a3c9848 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -128,7 +128,7 @@ struct cpu_workqueue_struct *get_wq_data(struct work_struct *work)
 static void insert_work(struct cpu_workqueue_struct *cwq,
 			struct work_struct *work, struct list_head *head)
 {
-	trace_workqueue_insertion(cwq->thread, work);
+	trace_worklet_insertion(cwq->thread, work);
 
 	set_wq_data(work, cwq);
 	/*
@@ -287,9 +287,9 @@ static void run_workqueue(struct cpu_workqueue_struct *cwq)
 		work_clear_pending(work);
 		lock_map_acquire(&cwq->wq->lockdep_map);
 		lock_map_acquire(&lockdep_map);
-		trace_workqueue_handler_entry(cwq->thread, work);
+		trace_worklet_execute(cwq->thread, work);
 		f(work);
-		trace_workqueue_handler_exit(cwq->thread, work);
+		trace_worklet_complete(cwq->thread, work);
 		lock_map_release(&lockdep_map);
 		lock_map_release(&cwq->wq->lockdep_map);
 
-- 
1.6.2.3

