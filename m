Return-Path: <linux-kernel-owner+w=401wt.eu-S1762028AbZD3AaP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762028AbZD3AaP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 20:30:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761259AbZD3A1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 20:27:40 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:49710 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760859AbZD3A1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 20:27:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=esaPqwxLpq9N8Huk1bbo357RKvgMyobirw3uCsSfX1spbm96yt0bPcrb6QyDsXXoO8
         HR7MY8C0zw72f5YeyEIHKjIsuGvOgFUxc5qBPDiehKbbkAsvEVNa0feeSaSOYNashMRO
         blx+63AsrLyUFJHbwdBZCLPRL9Mnmk229UMJM=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Tom Zanussi <tzanussi@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 08/19] workqueue_tracepoint: add workqueue_flush and worklet_cancel tracepoint
Date: Thu, 30 Apr 2009 02:27:09 +0200
Message-Id: <1241051240-4280-9-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1241051240-4280-1-git-send-email-fweisbec@gmail.com>
References: <1241051240-4280-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhaolei <zhaolei@cn.fujitsu.com>

Ingo Molnar <mingo@elte.hu> wrote:
> This allows the understanding of the life cycle of a workqueue and
> of worklets that enter that workqueue.

[ Impact: provide finer grained details about life of worklets ]

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/trace/events/workqueue.h |   36 ++++++++++++++++++++++++++++++++++++
 kernel/workqueue.c               |    4 ++++
 2 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/include/trace/events/workqueue.h b/include/trace/events/workqueue.h
index 36f4939..2e77e84 100644
--- a/include/trace/events/workqueue.h
+++ b/include/trace/events/workqueue.h
@@ -76,6 +76,23 @@ TRACE_EVENT(workqueue_handler_exit,
 		  __entry->thread_pid, __entry->work)
 );
 
+TRACE_EVENT(worklet_cancel,
+
+	TP_PROTO(struct work_struct *work),
+
+	TP_ARGS(work),
+
+	TP_STRUCT__entry(
+		__field(work_func_t,	func)
+	),
+
+	TP_fast_assign(
+		__entry->func	= work->func;
+	),
+
+	TP_printk("func=%pF", __entry->func)
+);
+
 /* Trace the creation of one workqueue thread on a cpu */
 TRACE_EVENT(workqueue_creation,
 
@@ -99,6 +116,25 @@ TRACE_EVENT(workqueue_creation,
 		__entry->thread_pid, __entry->cpu)
 );
 
+TRACE_EVENT(workqueue_flush,
+
+	TP_PROTO(struct task_struct *wq_thread),
+
+	TP_ARGS(wq_thread),
+
+	TP_STRUCT__entry(
+		__array(char,	thread_comm,	TASK_COMM_LEN)
+		__field(pid_t,	thread_pid)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->thread_comm, wq_thread->comm, TASK_COMM_LEN);
+		__entry->thread_pid	= wq_thread->pid;
+	),
+
+	TP_printk("thread=%s:%d", __entry->thread_comm, __entry->thread_pid)
+);
+
 TRACE_EVENT(workqueue_destruction,
 
 	TP_PROTO(struct task_struct *wq_thread),
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index fbcdfa2..99a81ba 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -366,6 +366,8 @@ static int flush_cpu_workqueue(struct cpu_workqueue_struct *cwq)
 	int active = 0;
 	struct wq_barrier barr;
 
+	trace_workqueue_flush(cwq->thread);
+
 	WARN_ON(cwq->thread == current);
 
 	spin_lock_irq(&cwq->lock);
@@ -542,6 +544,8 @@ static int __cancel_work_timer(struct work_struct *work,
 {
 	int ret;
 
+	trace_worklet_cancel(work);
+
 	do {
 		ret = (timer && likely(del_timer(timer)));
 		if (!ret)
-- 
1.6.2.3

