Return-Path: <linux-kernel-owner+w=401wt.eu-S1754865AbZEOVHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865AbZEOVHp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 17:07:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753601AbZEOVHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 17:07:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:49522 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391AbZEOVHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 17:07:18 -0400
Message-Id: <20090515210717.973776350@goodmis.org>
References: <20090515210342.488025506@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 15 May 2009 17:03:44 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Christoph Hellwig <hch@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [PATCH 2/3] tracing: add previous task state info to sched switch event
Content-Disposition: inline; filename=0002-tracing-add-previous-task-state-info-to-sched-switc.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

It is useful to see the state of a task that is being switched out.
This patch adds the output of the state of the previous task in
the context switch event.

[ Impact: see state of switched out task in context switch ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/events/sched.h |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index dd4033c..f887462 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -156,6 +156,7 @@ TRACE_EVENT(sched_switch,
 		__array(	char,	prev_comm,	TASK_COMM_LEN	)
 		__field(	pid_t,	prev_pid			)
 		__field(	int,	prev_prio			)
+		__field(	long,	prev_state			)
 		__array(	char,	next_comm,	TASK_COMM_LEN	)
 		__field(	pid_t,	next_pid			)
 		__field(	int,	next_prio			)
@@ -165,13 +166,18 @@ TRACE_EVENT(sched_switch,
 		memcpy(__entry->next_comm, next->comm, TASK_COMM_LEN);
 		__entry->prev_pid	= prev->pid;
 		__entry->prev_prio	= prev->prio;
+		__entry->prev_state	= prev->state;
 		memcpy(__entry->prev_comm, prev->comm, TASK_COMM_LEN);
 		__entry->next_pid	= next->pid;
 		__entry->next_prio	= next->prio;
 	),
 
-	TP_printk("task %s:%d [%d] ==> %s:%d [%d]",
+	TP_printk("task %s:%d [%d] (%s) ==> %s:%d [%d]",
 		__entry->prev_comm, __entry->prev_pid, __entry->prev_prio,
+		__entry->prev_state ?
+		  __print_flags(__entry->prev_state, "|",
+				1, "S", 2, "D", 4, "T", 8, "t",
+				16, "Z", 32, "X", 64, "x", 128, "W") : "R",
 		__entry->next_comm, __entry->next_pid, __entry->next_prio)
 );
 
-- 
1.6.2.4

-- 
