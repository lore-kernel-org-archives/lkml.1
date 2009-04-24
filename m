Return-Path: <linux-kernel-owner+w=401wt.eu-S1755264AbZDXLpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264AbZDXLpm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 07:45:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751235AbZDXLpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 07:45:33 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62873 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750886AbZDXLpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 07:45:33 -0400
Message-ID: <49F1A63D.1070202@cn.fujitsu.com>
Date: Fri, 24 Apr 2009 19:45:01 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/4] workqueue_tracepoint: Add workqueue_flush and worklet_cancel
 tracepoint
References: <20090415085310.AC0D.A69D9226@jp.fujitsu.com> <20090415011533.GI5968@nowhere> <20090415141250.AC46.A69D9226@jp.fujitsu.com> <49E8282A.6010004@cn.fujitsu.com> <49E82CA7.2040606@cn.fujitsu.com> <20090417134557.GA23493@elte.hu> <49F1A59B.3080206@cn.fujitsu.com>
In-Reply-To: <49F1A59B.3080206@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> wrote:
> This allows the understanding of the life cycle of a workqueue and
> of worklets that enter that workqueue.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
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
1.5.5.3


