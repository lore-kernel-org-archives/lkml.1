Return-Path: <linux-kernel-owner+w=401wt.eu-S1754456AbZHFG2E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456AbZHFG2E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 02:28:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754390AbZHFG2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 02:28:00 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:53224 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391AbZHFG15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 02:27:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=pxat3mMbATp2cPJaWWEl9l1r81tkYzkWf0fTUmDO3IaNAe17uNz1ZXgmUFeuK+sD2R
         8YKwp2H94RFiFTL7W9G/ANmG5ca/d+M84RTfCNiZeJpnJN6rNpcm7SxIW5UfrAV7saKK
         +C0J/ZtQz0qnud1KurmadO6LEzc8a9sPuJgmY=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 5/7] tracing: Move sched event insertion helpers in the sched switch tracer file
Date: Thu,  6 Aug 2009 08:27:36 +0200
Message-Id: <1249540058-5528-6-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <20090802195312.GA18598@elte.hu>
References: <20090802195312.GA18598@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sched events helpers which insert the sched switch and wakeup
events into the ring buffer currently reside in trace.c
But this file is quite overloaded and the right place for these helpers
is in the sched switch tracer file.

Then move them to trace_functions.c

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c              |   56 ------------------------------------
 kernel/trace/trace_sched_switch.c |   57 +++++++++++++++++++++++++++++++++++++
 2 files changed, 57 insertions(+), 56 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index d6059a4..1b73acb 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1106,62 +1106,6 @@ __trace_special(void *__tr, void *__data,
 }
 
 void
-tracing_sched_switch_trace(struct trace_array *tr,
-			   struct task_struct *prev,
-			   struct task_struct *next,
-			   unsigned long flags, int pc)
-{
-	struct ftrace_event_call *call = &event_context_switch;
-	struct ring_buffer_event *event;
-	struct ctx_switch_entry *entry;
-
-	event = trace_buffer_lock_reserve(tr, TRACE_CTX,
-					  sizeof(*entry), flags, pc);
-	if (!event)
-		return;
-	entry	= ring_buffer_event_data(event);
-	entry->prev_pid			= prev->pid;
-	entry->prev_prio		= prev->prio;
-	entry->prev_state		= prev->state;
-	entry->next_pid			= next->pid;
-	entry->next_prio		= next->prio;
-	entry->next_state		= next->state;
-	entry->next_cpu	= task_cpu(next);
-
-	if (!filter_check_discard(call, entry, tr->buffer, event))
-		trace_buffer_unlock_commit(tr, event, flags, pc);
-}
-
-void
-tracing_sched_wakeup_trace(struct trace_array *tr,
-			   struct task_struct *wakee,
-			   struct task_struct *curr,
-			   unsigned long flags, int pc)
-{
-	struct ftrace_event_call *call = &event_wakeup;
-	struct ring_buffer_event *event;
-	struct ctx_switch_entry *entry;
-
-	event = trace_buffer_lock_reserve(tr, TRACE_WAKE,
-					  sizeof(*entry), flags, pc);
-	if (!event)
-		return;
-	entry	= ring_buffer_event_data(event);
-	entry->prev_pid			= curr->pid;
-	entry->prev_prio		= curr->prio;
-	entry->prev_state		= curr->state;
-	entry->next_pid			= wakee->pid;
-	entry->next_prio		= wakee->prio;
-	entry->next_state		= wakee->state;
-	entry->next_cpu			= task_cpu(wakee);
-
-	if (!filter_check_discard(call, entry, tr->buffer, event))
-		ring_buffer_unlock_commit(tr->buffer, event);
-	ftrace_trace_stack(tr, flags, 6, pc);
-	ftrace_trace_userstack(tr, flags, pc);
-}
-
-void
 ftrace_special(unsigned long arg1, unsigned long arg2, unsigned long arg3)
 {
 	struct trace_array *tr = &global_trace;
diff --git a/kernel/trace/trace_sched_switch.c b/kernel/trace/trace_sched_switch.c
index a98106d..e1285d7 100644
--- a/kernel/trace/trace_sched_switch.c
+++ b/kernel/trace/trace_sched_switch.c
@@ -20,6 +20,34 @@ static int			sched_ref;
 static DEFINE_MUTEX(sched_register_mutex);
 static int			sched_stopped;
 
+
+void
+tracing_sched_switch_trace(struct trace_array *tr,
+			   struct task_struct *prev,
+			   struct task_struct *next,
+			   unsigned long flags, int pc)
+{
+	struct ftrace_event_call *call = &event_context_switch;
+	struct ring_buffer_event *event;
+	struct ctx_switch_entry *entry;
+
+	event = trace_buffer_lock_reserve(tr, TRACE_CTX,
+					  sizeof(*entry), flags, pc);
+	if (!event)
+		return;
+	entry	= ring_buffer_event_data(event);
+	entry->prev_pid			= prev->pid;
+	entry->prev_prio		= prev->prio;
+	entry->prev_state		= prev->state;
+	entry->next_pid			= next->pid;
+	entry->next_prio		= next->prio;
+	entry->next_state		= next->state;
+	entry->next_cpu	= task_cpu(next);
+
+	if (!filter_check_discard(call, entry, tr->buffer, event))
+		trace_buffer_unlock_commit(tr, event, flags, pc);
+}
+
 static void
 probe_sched_switch(struct rq *__rq, struct task_struct *prev,
 			struct task_struct *next)
@@ -49,6 +77,35 @@ probe_sched_switch(struct rq *__rq, struct task_struct *prev,
 	local_irq_restore(flags);
 }
 
+void
+tracing_sched_wakeup_trace(struct trace_array *tr,
+			   struct task_struct *wakee,
+			   struct task_struct *curr,
+			   unsigned long flags, int pc)
+{
+	struct ftrace_event_call *call = &event_wakeup;
+	struct ring_buffer_event *event;
+	struct ctx_switch_entry *entry;
+
+	event = trace_buffer_lock_reserve(tr, TRACE_WAKE,
+					  sizeof(*entry), flags, pc);
+	if (!event)
+		return;
+	entry	= ring_buffer_event_data(event);
+	entry->prev_pid			= curr->pid;
+	entry->prev_prio		= curr->prio;
+	entry->prev_state		= curr->state;
+	entry->next_pid			= wakee->pid;
+	entry->next_prio		= wakee->prio;
+	entry->next_state		= wakee->state;
+	entry->next_cpu			= task_cpu(wakee);
+
+	if (!filter_check_discard(call, entry, tr->buffer, event))
+		ring_buffer_unlock_commit(tr->buffer, event);
+	ftrace_trace_stack(tr, flags, 6, pc);
+	ftrace_trace_userstack(tr, flags, pc);
+}
+
 static void
 probe_sched_wakeup(struct rq *__rq, struct task_struct *wakee, int success)
 {
-- 
1.6.2.3

