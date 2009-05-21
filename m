Return-Path: <linux-kernel-owner+w=401wt.eu-S1756730AbZEUDSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730AbZEUDSk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 23:18:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755368AbZEUDRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 23:17:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:38782 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755015AbZEUDRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 23:17:49 -0400
Message-Id: <20090521031748.981343235@goodmis.org>
References: <20090521031711.494593605@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 20 May 2009 23:17:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, Jason Baron <jbaron@redhat.com>
Subject: [PATCH 2/5] tracing: add previous task state info to sched switch event
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
 include/trace/events/sched.h |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index dd4033c..24ab5bc 100644
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
@@ -165,13 +166,19 @@ TRACE_EVENT(sched_switch,
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
+				{ 1, "S"} , { 2, "D" }, { 4, "T" }, { 8, "t" },
+				{ 16, "Z" }, { 32, "X" }, { 64, "x" },
+				{ 128, "W" }) : "R",
 		__entry->next_comm, __entry->next_pid, __entry->next_prio)
 );
 
-- 
1.6.2.4

-- 
