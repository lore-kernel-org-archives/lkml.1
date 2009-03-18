Return-Path: <linux-kernel-owner+w=401wt.eu-S1758106AbZCRDeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758106AbZCRDeA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 23:34:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757321AbZCRDcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 23:32:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:53604 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755537AbZCRDcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 23:32:52 -0400
Message-Id: <20090318033249.003265651@goodmis.org>
References: <20090318031423.981603258@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 17 Mar 2009 23:14:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Miklos Szeredi <miklos@szeredi.hu>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/5] ring-buffer: add api to allow a tracer to change clock source
Content-Disposition: inline; filename=0001-ring-buffer-add-api-to-allow-a-tracer-to-change-clo.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

This patch adds a new function called ring_buffer_set_clock that
allows a tracer to assign its own clock source to the buffer.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/ring_buffer.h |    7 +++-
 kernel/trace/ring_buffer.c  |   65 +++++++++++++++++++++++++------------------
 kernel/trace/trace.c        |   21 +++++++++----
 3 files changed, 57 insertions(+), 36 deletions(-)

diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index b1a0068..9e6052b 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -118,8 +118,11 @@ unsigned long ring_buffer_overruns(struct ring_buffer *buffer);
 unsigned long ring_buffer_entries_cpu(struct ring_buffer *buffer, int cpu);
 unsigned long ring_buffer_overrun_cpu(struct ring_buffer *buffer, int cpu);
 
-u64 ring_buffer_time_stamp(int cpu);
-void ring_buffer_normalize_time_stamp(int cpu, u64 *ts);
+u64 ring_buffer_time_stamp(struct ring_buffer *buffer, int cpu);
+void ring_buffer_normalize_time_stamp(struct ring_buffer *buffer,
+				      int cpu, u64 *ts);
+void ring_buffer_set_clock(struct ring_buffer *buffer,
+			   u64 (*clock)(void));
 
 size_t ring_buffer_page_len(void *page);
 
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 58128ad..bbf5192 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -180,29 +180,6 @@ EXPORT_SYMBOL_GPL(tracing_is_on);
 
 #include "trace.h"
 
-/* Up this if you want to test the TIME_EXTENTS and normalization */
-#define DEBUG_SHIFT 0
-
-u64 ring_buffer_time_stamp(int cpu)
-{
-	u64 time;
-
-	preempt_disable_notrace();
-	/* shift to debug/test normalization and TIME_EXTENTS */
-	time = trace_clock_local() << DEBUG_SHIFT;
-	preempt_enable_no_resched_notrace();
-
-	return time;
-}
-EXPORT_SYMBOL_GPL(ring_buffer_time_stamp);
-
-void ring_buffer_normalize_time_stamp(int cpu, u64 *ts)
-{
-	/* Just stupid testing the normalize function and deltas */
-	*ts >>= DEBUG_SHIFT;
-}
-EXPORT_SYMBOL_GPL(ring_buffer_normalize_time_stamp);
-
 #define RB_EVNT_HDR_SIZE (offsetof(struct ring_buffer_event, array))
 #define RB_ALIGNMENT		4U
 #define RB_MAX_SMALL_DATA	28
@@ -374,6 +351,7 @@ struct ring_buffer {
 #ifdef CONFIG_HOTPLUG_CPU
 	struct notifier_block		cpu_notify;
 #endif
+	u64				(*clock)(void);
 };
 
 struct ring_buffer_iter {
@@ -394,6 +372,30 @@ struct ring_buffer_iter {
 		_____ret;					\
 	})
 
+/* Up this if you want to test the TIME_EXTENTS and normalization */
+#define DEBUG_SHIFT 0
+
+u64 ring_buffer_time_stamp(struct ring_buffer *buffer, int cpu)
+{
+	u64 time;
+
+	preempt_disable_notrace();
+	/* shift to debug/test normalization and TIME_EXTENTS */
+	time = buffer->clock() << DEBUG_SHIFT;
+	preempt_enable_no_resched_notrace();
+
+	return time;
+}
+EXPORT_SYMBOL_GPL(ring_buffer_time_stamp);
+
+void ring_buffer_normalize_time_stamp(struct ring_buffer *buffer,
+				      int cpu, u64 *ts)
+{
+	/* Just stupid testing the normalize function and deltas */
+	*ts >>= DEBUG_SHIFT;
+}
+EXPORT_SYMBOL_GPL(ring_buffer_normalize_time_stamp);
+
 /**
  * check_pages - integrity check of buffer pages
  * @cpu_buffer: CPU buffer with pages to test
@@ -569,6 +571,7 @@ struct ring_buffer *ring_buffer_alloc(unsigned long size, unsigned flags)
 
 	buffer->pages = DIV_ROUND_UP(size, BUF_PAGE_SIZE);
 	buffer->flags = flags;
+	buffer->clock = trace_clock_local;
 
 	/* need at least two pages */
 	if (buffer->pages == 1)
@@ -645,6 +648,12 @@ ring_buffer_free(struct ring_buffer *buffer)
 }
 EXPORT_SYMBOL_GPL(ring_buffer_free);
 
+void ring_buffer_set_clock(struct ring_buffer *buffer,
+			   u64 (*clock)(void))
+{
+	buffer->clock = clock;
+}
+
 static void rb_reset_cpu(struct ring_buffer_per_cpu *cpu_buffer);
 
 static void
@@ -1191,7 +1200,7 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 			cpu_buffer->tail_page = next_page;
 
 			/* reread the time stamp */
-			*ts = ring_buffer_time_stamp(cpu_buffer->cpu);
+			*ts = ring_buffer_time_stamp(buffer, cpu_buffer->cpu);
 			cpu_buffer->tail_page->page->time_stamp = *ts;
 		}
 
@@ -1334,7 +1343,7 @@ rb_reserve_next_event(struct ring_buffer_per_cpu *cpu_buffer,
 	if (RB_WARN_ON(cpu_buffer, ++nr_loops > 1000))
 		return NULL;
 
-	ts = ring_buffer_time_stamp(cpu_buffer->cpu);
+	ts = ring_buffer_time_stamp(cpu_buffer->buffer, cpu_buffer->cpu);
 
 	/*
 	 * Only the first commit can update the timestamp.
@@ -2051,7 +2060,8 @@ rb_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
 	case RINGBUF_TYPE_DATA:
 		if (ts) {
 			*ts = cpu_buffer->read_stamp + event->time_delta;
-			ring_buffer_normalize_time_stamp(cpu_buffer->cpu, ts);
+			ring_buffer_normalize_time_stamp(buffer,
+							 cpu_buffer->cpu, ts);
 		}
 		return event;
 
@@ -2112,7 +2122,8 @@ rb_iter_peek(struct ring_buffer_iter *iter, u64 *ts)
 	case RINGBUF_TYPE_DATA:
 		if (ts) {
 			*ts = iter->read_stamp + event->time_delta;
-			ring_buffer_normalize_time_stamp(cpu_buffer->cpu, ts);
+			ring_buffer_normalize_time_stamp(buffer,
+							 cpu_buffer->cpu, ts);
 		}
 		return event;
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 8f89690..3be2f78 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -155,13 +155,6 @@ ns2usecs(cycle_t nsec)
 	return nsec;
 }
 
-cycle_t ftrace_now(int cpu)
-{
-	u64 ts = ring_buffer_time_stamp(cpu);
-	ring_buffer_normalize_time_stamp(cpu, &ts);
-	return ts;
-}
-
 /*
  * The global_trace is the descriptor that holds the tracing
  * buffers for the live tracing. For each CPU, it contains
@@ -178,6 +171,20 @@ static struct trace_array	global_trace;
 
 static DEFINE_PER_CPU(struct trace_array_cpu, global_trace_cpu);
 
+cycle_t ftrace_now(int cpu)
+{
+	u64 ts;
+
+	/* Early boot up does not have a buffer yet */
+	if (!global_trace.buffer)
+		return trace_clock_local();
+
+	ts = ring_buffer_time_stamp(global_trace.buffer, cpu);
+	ring_buffer_normalize_time_stamp(global_trace.buffer, cpu, &ts);
+
+	return ts;
+}
+
 /*
  * The max_tr is used to snapshot the global_trace when a maximum
  * latency is reached. Some tracers will use this to store a maximum
-- 
1.6.2

-- 
