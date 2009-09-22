Return-Path: <linux-kernel-owner+w=401wt.eu-S1752654AbZIVCn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654AbZIVCn5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 22:43:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752060AbZIVCnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 22:43:47 -0400
Received: from ozlabs.org ([203.10.76.45]:59265 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751629AbZIVCnp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 22:43:45 -0400
Date: Tue, 22 Sep 2009 12:42:32 +1000
From: Anton Blanchard <anton@samba.org>
To: Frederic Weisbecker <fweisbec@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] tracing/workqueue: Rename workqueue_execute to
	worklet_entry and add worklet_exit
Message-ID: <20090922024232.GC31801@kryten>
References: <20090922023920.GA31801@kryten> <20090922024033.GB31801@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090922024033.GB31801@kryten>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Keep a common naming convention for tracing the latency of events such as
softirq_entry/softirq_exit.

Based on a patch from KOSAKI Motohiro.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: linux.trees.git/kernel/workqueue.c
===================================================================
--- linux.trees.git.orig/kernel/workqueue.c	2009-09-14 09:43:00.000000000 +1000
+++ linux.trees.git/kernel/workqueue.c	2009-09-14 09:45:45.000000000 +1000
@@ -279,7 +279,6 @@ static void run_workqueue(struct cpu_wor
 		 */
 		struct lockdep_map lockdep_map = work->lockdep_map;
 #endif
-		trace_workqueue_execution(cwq->thread, work);
 		cwq->current_work = work;
 		list_del_init(cwq->worklist.next);
 		spin_unlock_irq(&cwq->lock);
@@ -288,7 +287,9 @@ static void run_workqueue(struct cpu_wor
 		work_clear_pending(work);
 		lock_map_acquire(&cwq->wq->lockdep_map);
 		lock_map_acquire(&lockdep_map);
+		trace_worklet_entry(cwq->thread, work);
 		f(work);
+		trace_worklet_exit(cwq->thread, work);
 		lock_map_release(&lockdep_map);
 		lock_map_release(&cwq->wq->lockdep_map);
 
Index: linux.trees.git/include/trace/events/workqueue.h
===================================================================
--- linux.trees.git.orig/include/trace/events/workqueue.h	2009-09-14 09:45:41.000000000 +1000
+++ linux.trees.git/include/trace/events/workqueue.h	2009-09-14 09:45:45.000000000 +1000
@@ -30,7 +30,7 @@ TRACE_EVENT(workqueue_insertion,
 		__entry->thread_pid, __entry->func)
 );
 
-TRACE_EVENT(workqueue_execution,
+TRACE_EVENT(worklet_entry,
 
 	TP_PROTO(struct task_struct *wq_thread, struct work_struct *work),
 
@@ -52,6 +52,27 @@ TRACE_EVENT(workqueue_execution,
 		__entry->thread_pid, __entry->func)
 );
 
+/* Declare work as void *, because we can't use work->... in after f(work) */
+TRACE_EVENT(worklet_exit,
+
+	TP_PROTO(struct task_struct *wq_thread, void *work),
+
+	TP_ARGS(wq_thread, work),
+
+	TP_STRUCT__entry(
+		__array(char,		thread_comm,	TASK_COMM_LEN)
+		__field(pid_t,		thread_pid)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->thread_comm, wq_thread->comm, TASK_COMM_LEN);
+		__entry->thread_pid	= wq_thread->pid;
+	),
+
+	TP_printk("thread=%s:%d", __entry->thread_comm,
+		  __entry->thread_pid)
+);
+
 /* Trace the creation of one workqueue thread on a cpu */
 TRACE_EVENT(workqueue_creation,
 
Index: linux.trees.git/kernel/trace/trace_workqueue.c
===================================================================
--- linux.trees.git.orig/kernel/trace/trace_workqueue.c	2009-09-01 15:11:04.000000000 +1000
+++ linux.trees.git/kernel/trace/trace_workqueue.c	2009-09-14 09:45:45.000000000 +1000
@@ -69,7 +69,7 @@ found:
 
 /* Execution of a work */
 static void
-probe_workqueue_execution(struct task_struct *wq_thread,
+probe_worklet_entry(struct task_struct *wq_thread,
 			  struct work_struct *work)
 {
 	int cpu = cpumask_first(&wq_thread->cpus_allowed);
@@ -262,13 +262,13 @@ int __init trace_workqueue_early_init(vo
 	if (ret)
 		goto out;
 
-	ret = register_trace_workqueue_execution(probe_workqueue_execution);
+	ret = register_trace_worklet_entry(probe_worklet_entry);
 	if (ret)
 		goto no_insertion;
 
 	ret = register_trace_workqueue_creation(probe_workqueue_creation);
 	if (ret)
-		goto no_execution;
+		goto no_entry;
 
 	ret = register_trace_workqueue_destruction(probe_workqueue_destruction);
 	if (ret)
@@ -283,8 +283,8 @@ int __init trace_workqueue_early_init(vo
 
 no_creation:
 	unregister_trace_workqueue_creation(probe_workqueue_creation);
-no_execution:
-	unregister_trace_workqueue_execution(probe_workqueue_execution);
+no_entry:
+	unregister_trace_worklet_entry(probe_worklet_entry);
 no_insertion:
 	unregister_trace_workqueue_insertion(probe_workqueue_insertion);
 out:
