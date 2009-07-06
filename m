Return-Path: <linux-kernel-owner+w=401wt.eu-S1755100AbZGFXXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100AbZGFXXw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 19:23:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752781AbZGFXXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 19:23:43 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:42693 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757AbZGFXXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 19:23:42 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzzz2fh6bh63h)
X-Spam-TCS-SCL: 2:0
X-FB-SS: 5,
Message-ID: <4A528769.5020200@am.sony.com>
Date: Mon, 6 Jul 2009 16:23:21 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: linux kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] ftrace: Add duration filtering to function graph tracer
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Jul 2009 23:23:21.0936 (UTC) FILETIME=[C0C08D00:01C9FE90]
X-SEL-encryption-scan: scanned
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add duration filtering to the function graph tracer.

The duration filter value is set in the 'tracing_thresh'
pseudo-file.  Values are in microseconds (as is customary
for that file).

This adds ring_buffer_peek_previous(), used to help
remove the function entry event from the trace log,
where this is possible.

To use:
 $ cd <debugfs tracing directory>
 $ echo 100 >tracing_thresh
 $ echo function_graph >current_tracer
 $ cat trace

Signed-off-by: Tim Bird <tim.bird@am.sony.com>
---
 include/linux/ring_buffer.h |    3 ++
 kernel/trace/ring_buffer.c  |   33 ++++++++++++++++++++++++++++++
 kernel/trace/trace.c        |   47 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 83 insertions(+)

--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -136,6 +136,9 @@ int ring_buffer_write(struct ring_buffer
 struct ring_buffer_event *
 ring_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts);
 struct ring_buffer_event *
+ring_buffer_peek_previous(struct ring_buffer *buffer,
+			  struct ring_buffer_event *event, int length);
+struct ring_buffer_event *
 ring_buffer_consume(struct ring_buffer *buffer, int cpu, u64 *ts);

 struct ring_buffer_iter *
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2523,6 +2523,39 @@ ring_buffer_peek(struct ring_buffer *buf
 }

 /**
+ * ring_buffer_peek_previous - peek at the previous event in the ring buffer
+ * @buffer: The ring buffer to read
+ * @length: The presumed length of the previous event
+ *
+ * This will return the previous data event in the buffer, unless
+ * we are at the beginning of the buffer.
+ */
+struct ring_buffer_event *
+ring_buffer_peek_previous(struct ring_buffer *buffer,
+		struct ring_buffer_event *event, int length)
+{
+	int cpu;
+	struct ring_buffer_per_cpu *cpu_buffer;
+	struct ring_buffer_event *prev_event;
+
+	cpu = raw_smp_processor_id();
+	cpu_buffer = buffer->buffers[cpu];
+
+	prev_event = (void *)event - length - RB_EVNT_HDR_SIZE;
+
+	/* abort if event type != DATA */
+	if (prev_event->type_len > RINGBUF_TYPE_DATA_TYPE_LEN_MAX)
+		return 0;
+
+	/* abort if prev_event < buffer start */
+	if ((void *)prev_event < (void *)cpu_buffer->commit_page)
+		return 0;
+
+	return prev_event;
+}
+
+
+/**
  * ring_buffer_iter_peek - peek at the next event to be read
  * @iter: The ring buffer iterator
  * @ts: The timestamp counter of this event.
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -971,6 +971,38 @@ static int __trace_graph_entry(struct tr
 	return 1;
 }

+/* Try to remove the function entry event for the current (return) event from
+ * the ringbuffer.  Note that the current event has already been discarded.
+ * Rewinding the write position of the buffer to overwrite the entry event
+ * can only be done if the entry event immediately precedes the return
+ * event in the trace buffer.
+ *
+ * This should be true about 99% of the time.
+ *
+ * This is an operation fraught with peril.
+ *
+ * The reason for doing this is to save space in the trace buffer when a
+ * tracing_thresh filter is used.
+ */
+static void trace_buffer_discard_func_entry(struct ring_buffer_event *cur_event,
+	struct ftrace_graph_ret_entry *cur_entry)
+{
+	struct ring_buffer_event *prev_event;
+	struct ftrace_graph_ent_entry *prev_entry;
+	unsigned long func;
+
+	func = cur_entry->ret.func;
+	prev_event = ring_buffer_peek_previous(global_trace.buffer, cur_event,
+			sizeof(*prev_entry));
+	if (!prev_event)
+		return;
+
+	prev_entry = ring_buffer_event_data(prev_event);
+	if (func == prev_entry->graph_ent.func) {
+		ring_buffer_event_discard(prev_event);
+	}
+}
+
 static void __trace_graph_return(struct trace_array *tr,
 				struct ftrace_graph_ret *trace,
 				unsigned long flags,
@@ -979,6 +1011,7 @@ static void __trace_graph_return(struct
 	struct ftrace_event_call *call = &event_funcgraph_exit;
 	struct ring_buffer_event *event;
 	struct ftrace_graph_ret_entry *entry;
+	unsigned long long duration;

 	if (unlikely(local_read(&__get_cpu_var(ftrace_cpu_disabled))))
 		return;
@@ -989,6 +1022,20 @@ static void __trace_graph_return(struct
 		return;
 	entry	= ring_buffer_event_data(event);
 	entry->ret				= *trace;
+
+	/* do some special handling for duration filtering */
+	if (tracing_thresh) {
+		duration = trace->rettime - trace->calltime;
+		if (duration < tracing_thresh) {
+			/* abort this item (func exit event) */
+			ring_buffer_discard_commit(global_trace.buffer, event);
+
+			/* try to remove entry event from ring buffer also */
+			trace_buffer_discard_func_entry(event, entry);
+			return;
+		}
+	}
+
 	if (!filter_current_check_discard(call, entry, event))
 		ring_buffer_unlock_commit(global_trace.buffer, event);
 }

