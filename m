Return-Path: <linux-kernel-owner+w=401wt.eu-S1754823AbZDMWY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823AbZDMWY6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 18:24:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754416AbZDMWY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 18:24:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:51627 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754680AbZDMWYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 18:24:24 -0400
Date: Mon, 13 Apr 2009 22:23:44 GMT
From: tip-bot for Tom Zanussi <tzanussi@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tzanussi@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tzanussi@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1239178554.10295.36.camel@tropicana>
References: <1239178554.10295.36.camel@tropicana>
Subject: [tip:tracing/core] tracing/filters: use ring_buffer_discard_commit() in filter_check_discard()
Message-ID: <tip-eb02ce017dd83985041a7e54c6449f92d53b026f@git.kernel.org>
Git-Commit-ID: eb02ce017dd83985041a7e54c6449f92d53b026f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 13 Apr 2009 22:23:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eb02ce017dd83985041a7e54c6449f92d53b026f
Gitweb:     http://git.kernel.org/tip/eb02ce017dd83985041a7e54c6449f92d53b026f
Author:     Tom Zanussi <tzanussi@gmail.com>
AuthorDate: Wed, 8 Apr 2009 03:15:54 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 14 Apr 2009 00:00:56 +0200

tracing/filters: use ring_buffer_discard_commit() in filter_check_discard()

This patch changes filter_check_discard() to make use of the new
ring_buffer_discard_commit() function and modifies the current users to
call the old commit function in the non-discard case.

It also introduces a version of filter_check_discard() that uses the
global trace buffer (filter_current_check_discard()) for those cases.

v2 changes:

- fix compile error noticed by Ingo Molnar

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: fweisbec@gmail.com
LKML-Reference: <1239178554.10295.36.camel@tropicana>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/kmemtrace.c            |   10 +++----
 kernel/trace/trace.c                |   45 ++++++++++++++++++----------------
 kernel/trace/trace.h                |   14 ++++++++--
 kernel/trace/trace_branch.c         |    5 +--
 kernel/trace/trace_events_stage_3.h |    5 +---
 kernel/trace/trace_hw_branches.c    |    4 +-
 kernel/trace/trace_power.c          |    8 +++---
 7 files changed, 48 insertions(+), 43 deletions(-)

diff --git a/kernel/trace/kmemtrace.c b/kernel/trace/kmemtrace.c
index 9419ad1..86cdf67 100644
--- a/kernel/trace/kmemtrace.c
+++ b/kernel/trace/kmemtrace.c
@@ -63,9 +63,8 @@ static inline void kmemtrace_alloc(enum kmemtrace_type_id type_id,
 	entry->gfp_flags	= gfp_flags;
 	entry->node		= node;
 
-	filter_check_discard(call, entry, event);
-
-	ring_buffer_unlock_commit(tr->buffer, event);
+	if (!filter_check_discard(call, entry, tr->buffer, event))
+		ring_buffer_unlock_commit(tr->buffer, event);
 
 	trace_wake_up();
 }
@@ -90,9 +89,8 @@ static inline void kmemtrace_free(enum kmemtrace_type_id type_id,
 	entry->call_site	= call_site;
 	entry->ptr		= ptr;
 
-	filter_check_discard(call, entry, event);
-
-	ring_buffer_unlock_commit(tr->buffer, event);
+	if (!filter_check_discard(call, entry, tr->buffer, event))
+		ring_buffer_unlock_commit(tr->buffer, event);
 
 	trace_wake_up();
 }
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index d880ab2..c0047fc 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -171,6 +171,12 @@ static struct trace_array	global_trace;
 
 static DEFINE_PER_CPU(struct trace_array_cpu, global_trace_cpu);
 
+int filter_current_check_discard(struct ftrace_event_call *call, void *rec,
+				 struct ring_buffer_event *event)
+{
+	return filter_check_discard(call, rec, global_trace.buffer, event);
+}
+
 cycle_t ftrace_now(int cpu)
 {
 	u64 ts;
@@ -919,9 +925,8 @@ trace_function(struct trace_array *tr,
 	entry->ip			= ip;
 	entry->parent_ip		= parent_ip;
 
-	filter_check_discard(call, entry, event);
-
-	ring_buffer_unlock_commit(tr->buffer, event);
+	if (!filter_check_discard(call, entry, tr->buffer, event))
+		ring_buffer_unlock_commit(tr->buffer, event);
 }
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
@@ -943,8 +948,8 @@ static int __trace_graph_entry(struct trace_array *tr,
 		return 0;
 	entry	= ring_buffer_event_data(event);
 	entry->graph_ent			= *trace;
-	filter_check_discard(call, entry, event);
-	ring_buffer_unlock_commit(global_trace.buffer, event);
+	if (!filter_current_check_discard(call, entry, event))
+		ring_buffer_unlock_commit(global_trace.buffer, event);
 
 	return 1;
 }
@@ -967,8 +972,8 @@ static void __trace_graph_return(struct trace_array *tr,
 		return;
 	entry	= ring_buffer_event_data(event);
 	entry->ret				= *trace;
-	filter_check_discard(call, entry, event);
-	ring_buffer_unlock_commit(global_trace.buffer, event);
+	if (!filter_current_check_discard(call, entry, event))
+		ring_buffer_unlock_commit(global_trace.buffer, event);
 }
 #endif
 
@@ -1004,8 +1009,8 @@ static void __ftrace_trace_stack(struct trace_array *tr,
 	trace.entries		= entry->caller;
 
 	save_stack_trace(&trace);
-	filter_check_discard(call, entry, event);
-	ring_buffer_unlock_commit(tr->buffer, event);
+	if (!filter_check_discard(call, entry, tr->buffer, event))
+		ring_buffer_unlock_commit(tr->buffer, event);
 #endif
 }
 
@@ -1052,8 +1057,8 @@ static void ftrace_trace_userstack(struct trace_array *tr,
 	trace.entries		= entry->caller;
 
 	save_stack_trace_user(&trace);
-	filter_check_discard(call, entry, event);
-	ring_buffer_unlock_commit(tr->buffer, event);
+	if (!filter_check_discard(call, entry, tr->buffer, event))
+		ring_buffer_unlock_commit(tr->buffer, event);
 #endif
 }
 
@@ -1114,9 +1119,8 @@ tracing_sched_switch_trace(struct trace_array *tr,
 	entry->next_state		= next->state;
 	entry->next_cpu	= task_cpu(next);
 
-	filter_check_discard(call, entry, event);
-
-	trace_buffer_unlock_commit(tr, event, flags, pc);
+	if (!filter_check_discard(call, entry, tr->buffer, event))
+		trace_buffer_unlock_commit(tr, event, flags, pc);
 }
 
 void
@@ -1142,9 +1146,8 @@ tracing_sched_wakeup_trace(struct trace_array *tr,
 	entry->next_state		= wakee->state;
 	entry->next_cpu			= task_cpu(wakee);
 
-	filter_check_discard(call, entry, event);
-
-	ring_buffer_unlock_commit(tr->buffer, event);
+	if (!filter_check_discard(call, entry, tr->buffer, event))
+		ring_buffer_unlock_commit(tr->buffer, event);
 	ftrace_trace_stack(tr, flags, 6, pc);
 	ftrace_trace_userstack(tr, flags, pc);
 }
@@ -1285,8 +1288,8 @@ int trace_vbprintk(unsigned long ip, const char *fmt, va_list args)
 	entry->fmt			= fmt;
 
 	memcpy(entry->buf, trace_buf, sizeof(u32) * len);
-	filter_check_discard(call, entry, event);
-	ring_buffer_unlock_commit(tr->buffer, event);
+	if (!filter_check_discard(call, entry, tr->buffer, event))
+		ring_buffer_unlock_commit(tr->buffer, event);
 
 out_unlock:
 	__raw_spin_unlock(&trace_buf_lock);
@@ -1341,8 +1344,8 @@ int trace_vprintk(unsigned long ip, const char *fmt, va_list args)
 
 	memcpy(&entry->buf, trace_buf, len);
 	entry->buf[len] = 0;
-	filter_check_discard(call, entry, event);
-	ring_buffer_unlock_commit(tr->buffer, event);
+	if (!filter_check_discard(call, entry, tr->buffer, event))
+		ring_buffer_unlock_commit(tr->buffer, event);
 
  out_unlock:
 	__raw_spin_unlock(&trace_buf_lock);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index dfefffd..9729d14 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -866,13 +866,21 @@ extern int filter_match_preds(struct ftrace_event_call *call, void *rec);
 extern void filter_free_subsystem_preds(struct event_subsystem *system);
 extern int filter_add_subsystem_pred(struct event_subsystem *system,
 				     struct filter_pred *pred);
+extern int filter_current_check_discard(struct ftrace_event_call *call,
+					void *rec,
+					struct ring_buffer_event *event);
 
-static inline void
+static inline int
 filter_check_discard(struct ftrace_event_call *call, void *rec,
+		     struct ring_buffer *buffer,
 		     struct ring_buffer_event *event)
 {
-	if (unlikely(call->preds) && !filter_match_preds(call, rec))
-		ring_buffer_event_discard(event);
+	if (unlikely(call->preds) && !filter_match_preds(call, rec)) {
+		ring_buffer_discard_commit(buffer, event);
+		return 1;
+	}
+
+	return 0;
 }
 
 #define __common_field(type, item)					\
diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
index c95c25d..8e64e60 100644
--- a/kernel/trace/trace_branch.c
+++ b/kernel/trace/trace_branch.c
@@ -74,9 +74,8 @@ probe_likely_condition(struct ftrace_branch_data *f, int val, int expect)
 	entry->line = f->line;
 	entry->correct = val == expect;
 
-	filter_check_discard(call, entry, event);
-
-	ring_buffer_unlock_commit(tr->buffer, event);
+	if (!filter_check_discard(call, entry, tr->buffer, event))
+		ring_buffer_unlock_commit(tr->buffer, event);
 
  out:
 	atomic_dec(&tr->data[cpu]->disabled);
diff --git a/kernel/trace/trace_events_stage_3.h b/kernel/trace/trace_events_stage_3.h
index d2f34bf..b2b2982 100644
--- a/kernel/trace/trace_events_stage_3.h
+++ b/kernel/trace/trace_events_stage_3.h
@@ -222,11 +222,8 @@ static void ftrace_raw_event_##call(proto)				\
 									\
 	assign;								\
 									\
-	if (call->preds && !filter_match_preds(call, entry))		\
-		trace_current_buffer_discard_commit(event);		\
-	else								\
+	if (!filter_current_check_discard(call, entry, event))		\
 		trace_nowake_buffer_unlock_commit(event, irq_flags, pc); \
-									\
 }									\
 									\
 static int ftrace_raw_reg_event_##call(void)				\
diff --git a/kernel/trace/trace_hw_branches.c b/kernel/trace/trace_hw_branches.c
index e6b275b..8683d50 100644
--- a/kernel/trace/trace_hw_branches.c
+++ b/kernel/trace/trace_hw_branches.c
@@ -195,8 +195,8 @@ void trace_hw_branch(u64 from, u64 to)
 	entry->ent.type = TRACE_HW_BRANCHES;
 	entry->from = from;
 	entry->to   = to;
-	filter_check_discard(call, entry, event);
-	trace_buffer_unlock_commit(tr, event, 0, 0);
+	if (!filter_check_discard(call, entry, tr->buffer, event))
+		trace_buffer_unlock_commit(tr, event, 0, 0);
 
  out:
 	atomic_dec(&tr->data[cpu]->disabled);
diff --git a/kernel/trace/trace_power.c b/kernel/trace/trace_power.c
index 8ce7d7d..810a5b7 100644
--- a/kernel/trace/trace_power.c
+++ b/kernel/trace/trace_power.c
@@ -55,8 +55,8 @@ static void probe_power_end(struct power_trace *it)
 		goto out;
 	entry	= ring_buffer_event_data(event);
 	entry->state_data = *it;
-	filter_check_discard(call, entry, event);
-	trace_buffer_unlock_commit(tr, event, 0, 0);
+	if (!filter_check_discard(call, entry, tr->buffer, event))
+		trace_buffer_unlock_commit(tr, event, 0, 0);
  out:
 	preempt_enable();
 }
@@ -87,8 +87,8 @@ static void probe_power_mark(struct power_trace *it, unsigned int type,
 		goto out;
 	entry	= ring_buffer_event_data(event);
 	entry->state_data = *it;
-	filter_check_discard(call, entry, event);
-	trace_buffer_unlock_commit(tr, event, 0, 0);
+	if (!filter_check_discard(call, entry, tr->buffer, event))
+		trace_buffer_unlock_commit(tr, event, 0, 0);
  out:
 	preempt_enable();
 }
