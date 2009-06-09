Return-Path: <linux-kernel-owner+w=401wt.eu-S932222AbZFIVz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932222AbZFIVz6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 17:55:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758526AbZFIVxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 17:53:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:56783 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757335AbZFIVxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 17:53:39 -0400
Message-Id: <20090609215339.587618355@goodmis.org>
References: <20090609215211.307980196@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 09 Jun 2009 17:52:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
       Christoph Hellwig <hch@infradead.org>, Rik van Riel <riel@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Jiaying Zhang <jiayingz@google.com>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 5/8] tracing/events: modify sched print to new format
Content-Disposition: inline; filename=0005-tracing-events-modify-sched-print-to-new-format.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Use new format for better parsing of sched events.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/events/sched.h |   49 ++++++++++++++---------------------------
 1 files changed, 17 insertions(+), 32 deletions(-)

diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index 24ab5bc..beb1584 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -26,7 +26,7 @@ TRACE_EVENT(sched_kthread_stop,
 		__entry->pid	= t->pid;
 	),
 
-	TP_printk("task %s:%d", __entry->comm, __entry->pid)
+	TP_FORMAT("task <strarray:comm>:<int:pid>")
 );
 
 /*
@@ -46,7 +46,7 @@ TRACE_EVENT(sched_kthread_stop_ret,
 		__entry->ret	= ret;
 	),
 
-	TP_printk("ret %d", __entry->ret)
+	TP_FORMAT("ret <int:ret>")
 );
 
 /*
@@ -73,8 +73,7 @@ TRACE_EVENT(sched_wait_task,
 		__entry->prio	= p->prio;
 	),
 
-	TP_printk("task %s:%d [%d]",
-		  __entry->comm, __entry->pid, __entry->prio)
+	TP_FORMAT("task <strarray:comm>:<int:pid> [<int:prio>]")
 );
 
 /*
@@ -103,9 +102,7 @@ TRACE_EVENT(sched_wakeup,
 		__entry->success	= success;
 	),
 
-	TP_printk("task %s:%d [%d] success=%d",
-		  __entry->comm, __entry->pid, __entry->prio,
-		  __entry->success)
+	TP_FORMAT("task <strarray:comm>:<int:pid> [<int:prio>] success=<int:success>")
 );
 
 /*
@@ -134,9 +131,7 @@ TRACE_EVENT(sched_wakeup_new,
 		__entry->success	= success;
 	),
 
-	TP_printk("task %s:%d [%d] success=%d",
-		  __entry->comm, __entry->pid, __entry->prio,
-		  __entry->success)
+	TP_FORMAT("task <strarray:comm>:<int:pid> [<int:prio>] success=<int:success>")
 );
 
 /*
@@ -172,14 +167,10 @@ TRACE_EVENT(sched_switch,
 		__entry->next_prio	= next->prio;
 	),
 
-	TP_printk("task %s:%d [%d] (%s) ==> %s:%d [%d]",
-		__entry->prev_comm, __entry->prev_pid, __entry->prev_prio,
-		__entry->prev_state ?
-		  __print_flags(__entry->prev_state, "|",
-				{ 1, "S"} , { 2, "D" }, { 4, "T" }, { 8, "t" },
-				{ 16, "Z" }, { 32, "X" }, { 64, "x" },
-				{ 128, "W" }) : "R",
-		__entry->next_comm, __entry->next_pid, __entry->next_prio)
+	TP_FORMAT("task <strarray:prev_comm>:<int:prev_pid> [<int:prev_prio>] "
+		  "(<mask:prev_state:|:0=R,1=S,2=D,4=T,8=t,16=Z,32=X,64=x,128=W>)"
+		  " ==> "
+		  "task <strarray:next_comm>:<int:next_pid> [<int:next_prio>]")
 );
 
 /*
@@ -207,9 +198,8 @@ TRACE_EVENT(sched_migrate_task,
 		__entry->dest_cpu	= dest_cpu;
 	),
 
-	TP_printk("task %s:%d [%d] from: %d  to: %d",
-		  __entry->comm, __entry->pid, __entry->prio,
-		  __entry->orig_cpu, __entry->dest_cpu)
+	TP_FORMAT("task <strarray:comm>:<int:pid> [<int:prio>] "
+		  "from: <int:orig_cpu>  to: <int:dest_cpu>")
 );
 
 /*
@@ -233,8 +223,7 @@ TRACE_EVENT(sched_process_free,
 		__entry->prio		= p->prio;
 	),
 
-	TP_printk("task %s:%d [%d]",
-		  __entry->comm, __entry->pid, __entry->prio)
+	TP_FORMAT("task <strarray:comm>:<int:pid> [<int:prio>]")
 );
 
 /*
@@ -258,8 +247,7 @@ TRACE_EVENT(sched_process_exit,
 		__entry->prio		= p->prio;
 	),
 
-	TP_printk("task %s:%d [%d]",
-		  __entry->comm, __entry->pid, __entry->prio)
+	TP_FORMAT("task <strarray:comm>:<int:pid> [<int:prio>]")
 );
 
 /*
@@ -283,8 +271,7 @@ TRACE_EVENT(sched_process_wait,
 		__entry->prio		= current->prio;
 	),
 
-	TP_printk("task %s:%d [%d]",
-		  __entry->comm, __entry->pid, __entry->prio)
+	TP_FORMAT("task <strarray:comm>:<int:pid> [<int:prio>]")
 );
 
 /*
@@ -310,9 +297,8 @@ TRACE_EVENT(sched_process_fork,
 		__entry->child_pid	= child->pid;
 	),
 
-	TP_printk("parent %s:%d  child %s:%d",
-		__entry->parent_comm, __entry->parent_pid,
-		__entry->child_comm, __entry->child_pid)
+	TP_FORMAT("parent <strarray:parent_comm>:<int:parent_pid>"
+		  "  child <strarray:child_comm>:<int:child_pid>")
 );
 
 /*
@@ -336,8 +322,7 @@ TRACE_EVENT(sched_signal_send,
 		__entry->sig	= sig;
 	),
 
-	TP_printk("sig: %d  task %s:%d",
-		  __entry->sig, __entry->comm, __entry->pid)
+	TP_FORMAT("sig: <int:sig>  task <strarray:comm>:<int:pid>")
 );
 
 #endif /* _TRACE_SCHED_H */
-- 
1.6.3.1

-- 
