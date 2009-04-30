Return-Path: <linux-kernel-owner+w=401wt.eu-S1762595AbZD3AeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762595AbZD3AeO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 20:34:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761454AbZD3A2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 20:28:05 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:4720 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761575AbZD3A2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 20:28:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ryDi6sB2ob6juR3XBX16acoymMAENs+rdN7LFdsSVWOVS7VOtaqS3NIM8jrdZqb5bQ
         ImfT+bTBO60OBM8SIKpkFdsD+/ULXfpU5sgitXurrRMnTw9IHGkAaKJJXPgsnQsuLllO
         c8CRJVs9ih71aZPjBuJdAI25f9GsBmAruflmw=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Zhao Lei <zhaolei@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Tom Zanussi <tzanussi@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 18/19] tracing/workqueue: use the original cpu affinity on probe_workqueue_destruction
Date: Thu, 30 Apr 2009 02:27:19 +0200
Message-Id: <1241051240-4280-19-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1241051240-4280-1-git-send-email-fweisbec@gmail.com>
References: <1241051240-4280-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, when a cpu workqueue thread is cleaned up, we retrieve its cpu
affinity by looking its task::cpus_allowed mask field.

But the cpu is no longer available on CPU_POST_DEAD case and this
task has been migrated, therefore its cpus_allowed mask has changed
and does not contain this cpu anymore. It means that we are looking
at the wrong cpu list to find it.

We solve it here by passing the original cpu of the workqueue thread to
cleanup_workqueue_thread() and to trace_workqueue_destruction().

[ Impact: fix possible memory leak ]

Reported-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 include/trace/events/workqueue.h |    6 ++++--
 kernel/trace/trace_workqueue.c   |    4 +---
 kernel/workqueue.c               |    8 ++++----
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/trace/events/workqueue.h b/include/trace/events/workqueue.h
index e4c74f2..49608c7 100644
--- a/include/trace/events/workqueue.h
+++ b/include/trace/events/workqueue.h
@@ -175,18 +175,20 @@ TRACE_EVENT(workqueue_flush,
 
 TRACE_EVENT(workqueue_destruction,
 
-	TP_PROTO(struct task_struct *wq_thread),
+	TP_PROTO(struct task_struct *wq_thread, int cpu),
 
-	TP_ARGS(wq_thread),
+	TP_ARGS(wq_thread, cpu),
 
 	TP_STRUCT__entry(
 		__array(char,	thread_comm,	TASK_COMM_LEN)
 		__field(pid_t,	thread_pid)
+		__field(int,	cpu)
 	),
 
 	TP_fast_assign(
 		memcpy(__entry->thread_comm, wq_thread->comm, TASK_COMM_LEN);
 		__entry->thread_pid	= wq_thread->pid;
+		__entry->cpu		= cpu;
 	),
 
 	TP_printk("thread=%s:%d", __entry->thread_comm, __entry->thread_pid)
diff --git a/kernel/trace/trace_workqueue.c b/kernel/trace/trace_workqueue.c
index f39c5d3..eafb4a5 100644
--- a/kernel/trace/trace_workqueue.c
+++ b/kernel/trace/trace_workqueue.c
@@ -272,10 +272,8 @@ static void free_workqueue_stats(struct cpu_workqueue_stats *stat)
 }
 
 /* Destruction of a cpu workqueue thread */
-static void probe_workqueue_destruction(struct task_struct *wq_thread)
+static void probe_workqueue_destruction(struct task_struct *wq_thread, int cpu)
 {
-	/* Workqueue only execute on one cpu */
-	int cpu = cpumask_first(&wq_thread->cpus_allowed);
 	struct cpu_workqueue_stats *node;
 	unsigned long flags;
 
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 0cc14b9..7112850 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -869,7 +869,7 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
 }
 EXPORT_SYMBOL_GPL(__create_workqueue_key);
 
-static void cleanup_workqueue_thread(struct cpu_workqueue_struct *cwq)
+static void cleanup_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
 {
 	/*
 	 * Our caller is either destroy_workqueue() or CPU_POST_DEAD,
@@ -892,7 +892,7 @@ static void cleanup_workqueue_thread(struct cpu_workqueue_struct *cwq)
 	 * checks list_empty(), and a "normal" queue_work() can't use
 	 * a dead CPU.
 	 */
-	trace_workqueue_destruction(cwq->thread);
+	trace_workqueue_destruction(cwq->thread, cpu);
 	kthread_stop(cwq->thread);
 	cwq->thread = NULL;
 }
@@ -914,7 +914,7 @@ void destroy_workqueue(struct workqueue_struct *wq)
 	spin_unlock(&workqueue_lock);
 
 	for_each_cpu(cpu, cpu_map)
-		cleanup_workqueue_thread(per_cpu_ptr(wq->cpu_wq, cpu));
+		cleanup_workqueue_thread(per_cpu_ptr(wq->cpu_wq, cpu), cpu);
  	cpu_maps_update_done();
 
 	free_percpu(wq->cpu_wq);
@@ -958,7 +958,7 @@ undo:
 		case CPU_UP_CANCELED:
 			start_workqueue_thread(cwq, -1);
 		case CPU_POST_DEAD:
-			cleanup_workqueue_thread(cwq);
+			cleanup_workqueue_thread(cwq, cpu);
 			break;
 		}
 	}
-- 
1.6.2.3

