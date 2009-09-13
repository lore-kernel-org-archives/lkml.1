Return-Path: <linux-kernel-owner+w=401wt.eu-S1755081AbZIMDrI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081AbZIMDrI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 23:47:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755050AbZIMDrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 23:47:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:58309 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992AbZIMDqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 23:46:35 -0400
Message-Id: <20090913034637.740668573@goodmis.org>
References: <20090913034302.134417216@goodmis.org>
User-Agent: quilt/0.46-1
Date: Sat, 12 Sep 2009 23:43:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 6/6] tracing: add filter event logic to special, mmiotrace and boot tracers
Content-Disposition: inline; filename=0006-tracing-add-filter-event-logic-to-special-mmiotrace-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Now that the pluging tracers use macros to create the structures and
automate the exporting of their formats to the format files, they also
automatically get a filter file.

This patch adds the code to implement the filter logic in the trace
recordings.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c           |    5 ++++-
 kernel/trace/trace_boot.c      |    8 ++++++--
 kernel/trace/trace_mmiotrace.c |   10 ++++++++--
 3 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index ef82a7f..fd52a19 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1206,6 +1206,7 @@ ftrace_trace_special(void *__tr,
 		     unsigned long arg1, unsigned long arg2, unsigned long arg3,
 		     int pc)
 {
+	struct ftrace_event_call *call = &event_special;
 	struct ring_buffer_event *event;
 	struct trace_array *tr = __tr;
 	struct ring_buffer *buffer = tr->buffer;
@@ -1219,7 +1220,9 @@ ftrace_trace_special(void *__tr,
 	entry->arg1			= arg1;
 	entry->arg2			= arg2;
 	entry->arg3			= arg3;
-	trace_buffer_unlock_commit(buffer, event, 0, pc);
+
+	if (!filter_check_discard(call, entry, buffer, event))
+		trace_buffer_unlock_commit(buffer, event, 0, pc);
 }
 
 void
diff --git a/kernel/trace/trace_boot.c b/kernel/trace/trace_boot.c
index 19bfc75..c21d5f3 100644
--- a/kernel/trace/trace_boot.c
+++ b/kernel/trace/trace_boot.c
@@ -129,6 +129,7 @@ struct tracer boot_tracer __read_mostly =
 
 void trace_boot_call(struct boot_trace_call *bt, initcall_t fn)
 {
+	struct ftrace_event_call *call = &event_boot_call;
 	struct ring_buffer_event *event;
 	struct ring_buffer *buffer;
 	struct trace_boot_call *entry;
@@ -150,13 +151,15 @@ void trace_boot_call(struct boot_trace_call *bt, initcall_t fn)
 		goto out;
 	entry	= ring_buffer_event_data(event);
 	entry->boot_call = *bt;
-	trace_buffer_unlock_commit(buffer, event, 0, 0);
+	if (!filter_check_discard(call, entry, buffer, event))
+		trace_buffer_unlock_commit(buffer, event, 0, 0);
  out:
 	preempt_enable();
 }
 
 void trace_boot_ret(struct boot_trace_ret *bt, initcall_t fn)
 {
+	struct ftrace_event_call *call = &event_boot_ret;
 	struct ring_buffer_event *event;
 	struct ring_buffer *buffer;
 	struct trace_boot_ret *entry;
@@ -175,7 +178,8 @@ void trace_boot_ret(struct boot_trace_ret *bt, initcall_t fn)
 		goto out;
 	entry	= ring_buffer_event_data(event);
 	entry->boot_ret = *bt;
-	trace_buffer_unlock_commit(buffer, event, 0, 0);
+	if (!filter_check_discard(call, entry, buffer, event))
+		trace_buffer_unlock_commit(buffer, event, 0, 0);
  out:
 	preempt_enable();
 }
diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
index c4c9bbd..0acd834 100644
--- a/kernel/trace/trace_mmiotrace.c
+++ b/kernel/trace/trace_mmiotrace.c
@@ -307,6 +307,7 @@ static void __trace_mmiotrace_rw(struct trace_array *tr,
 				struct trace_array_cpu *data,
 				struct mmiotrace_rw *rw)
 {
+	struct ftrace_event_call *call = &event_mmiotrace_rw;
 	struct ring_buffer *buffer = tr->buffer;
 	struct ring_buffer_event *event;
 	struct trace_mmiotrace_rw *entry;
@@ -320,7 +321,9 @@ static void __trace_mmiotrace_rw(struct trace_array *tr,
 	}
 	entry	= ring_buffer_event_data(event);
 	entry->rw			= *rw;
-	trace_buffer_unlock_commit(buffer, event, 0, pc);
+
+	if (!filter_check_discard(call, entry, buffer, event))
+		trace_buffer_unlock_commit(buffer, event, 0, pc);
 }
 
 void mmio_trace_rw(struct mmiotrace_rw *rw)
@@ -334,6 +337,7 @@ static void __trace_mmiotrace_map(struct trace_array *tr,
 				struct trace_array_cpu *data,
 				struct mmiotrace_map *map)
 {
+	struct ftrace_event_call *call = &event_mmiotrace_map;
 	struct ring_buffer *buffer = tr->buffer;
 	struct ring_buffer_event *event;
 	struct trace_mmiotrace_map *entry;
@@ -347,7 +351,9 @@ static void __trace_mmiotrace_map(struct trace_array *tr,
 	}
 	entry	= ring_buffer_event_data(event);
 	entry->map			= *map;
-	trace_buffer_unlock_commit(buffer, event, 0, pc);
+
+	if (!filter_check_discard(call, entry, buffer, event))
+		trace_buffer_unlock_commit(buffer, event, 0, pc);
 }
 
 void mmio_trace_mapping(struct mmiotrace_map *map)
-- 
1.6.3.3

-- 
