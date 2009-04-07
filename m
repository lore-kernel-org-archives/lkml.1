Return-Path: <linux-kernel-owner+w=401wt.eu-S1756444AbZDGFua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444AbZDGFua (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 01:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751277AbZDGFuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 01:50:21 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:32192 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbZDGFuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 01:50:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=VtzsUxc/6mmsukM1e0qeD8qpY9/fnv11MQwgYjiuckCZ8sVsXpok2hWT7St24XtaKf
         PexMGg1Bv6wlbmPgC9OL4EwLVDY50F1WCn3ASQscZX3aEaCvluhHPoNCsfB+UoPpukAh
         ZoP3k1ub7/nuIYe50o4MS6VPBN5YplO2YUI2U=
Subject: [PATCH] tracing/filters: use ring_buffer_discard_commit() in
 filter_check_discard()
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       fweisbec@gmail.com
Content-Type: text/plain
Date: Tue, 07 Apr 2009 00:50:15 -0500
Message-Id: <1239083415.7220.45.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes filter_check_discard() to make use of the new
ring_buffer_discard_commit() function and modifies the current users to
call the old commit function in the non-discard case.  It also
introduces a version of filter_check_discard() that uses the global
trace buffer (filter_current_check_discard()) for those cases.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>

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
index 65aba48..91cd0a5 100644
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
index 106f1f3..dc3bed6 100644
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
index cffd1e5..e052bc2 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -860,13 +860,21 @@ extern int filter_match_preds(struct ftrace_event_call *call, void *rec);
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
index c95c25d..6a38a10 100644
--- a/kernel/trace/trace_branch.c
+++ b/kernel/trace/trace_branch.c
@@ -74,9 +74,8 @@ probe_likely_condition(struct ftrace_branch_data *f, int val, int expect)
 	entry->line = f->line;
 	entry->correct = val == expect;
 
-	filter_check_discard(call, entry, event);
-
-	ring_buffer_unlock_commit(tr->buffer, event);
+	if !(filter_check_discard(call, entry, event))
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
-- 
1.5.6.3



