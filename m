Return-Path: <linux-kernel-owner+w=401wt.eu-S1758700AbZKZHF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758700AbZKZHF0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 02:05:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757740AbZKZHF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 02:05:26 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:63394 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756136AbZKZHFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 02:05:25 -0500
Message-ID: <4B0E289F.5010104@cn.fujitsu.com>
Date: Thu, 26 Nov 2009 15:05:03 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/9] tracing: Convert some workqueue events to DEFINE_EVENT
References: <4B0E2807.4060102@cn.fujitsu.com>
In-Reply-To: <4B0E2807.4060102@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use TRACE_EVENT_TEMPLATE to remove duplicate code:

   text    data     bss     dec     hex filename
  13171     800      72   14043    36db kernel/workqueue.o.old
  12243     800      68   13111    3337 kernel/workqueue.o

Two events are converted:

  workqueue: workqueue_insertion, workqueue_execution

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 include/trace/events/workqueue.h |   22 +++++++---------------
 1 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/include/trace/events/workqueue.h b/include/trace/events/workqueue.h
index e4612db..6da8d1b 100644
--- a/include/trace/events/workqueue.h
+++ b/include/trace/events/workqueue.h
@@ -8,7 +8,7 @@
 #include <linux/sched.h>
 #include <linux/tracepoint.h>
 
-TRACE_EVENT(workqueue_insertion,
+TRACE_EVENT_TEMPLATE(workqueue,
 
 	TP_PROTO(struct task_struct *wq_thread, struct work_struct *work),
 
@@ -30,26 +30,18 @@ TRACE_EVENT(workqueue_insertion,
 		__entry->thread_pid, __entry->func)
 );
 
-TRACE_EVENT(workqueue_execution,
+DEFINE_EVENT(workqueue, workqueue_insertion,
 
 	TP_PROTO(struct task_struct *wq_thread, struct work_struct *work),
 
-	TP_ARGS(wq_thread, work),
+	TP_ARGS(wq_thread, work)
+);
 
-	TP_STRUCT__entry(
-		__array(char,		thread_comm,	TASK_COMM_LEN)
-		__field(pid_t,		thread_pid)
-		__field(work_func_t,	func)
-	),
+DEFINE_EVENT(workqueue, workqueue_execution,
 
-	TP_fast_assign(
-		memcpy(__entry->thread_comm, wq_thread->comm, TASK_COMM_LEN);
-		__entry->thread_pid	= wq_thread->pid;
-		__entry->func		= work->func;
-	),
+	TP_PROTO(struct task_struct *wq_thread, struct work_struct *work),
 
-	TP_printk("thread=%s:%d func=%pf", __entry->thread_comm,
-		__entry->thread_pid, __entry->func)
+	TP_ARGS(wq_thread, work)
 );
 
 /* Trace the creation of one workqueue thread on a cpu */
-- 
1.6.3

