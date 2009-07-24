Return-Path: <linux-kernel-owner+w=401wt.eu-S1752634AbZGXKk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634AbZGXKk7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 06:40:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542AbZGXKk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 06:40:58 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53871 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752365AbZGXKk5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 06:40:57 -0400
Message-ID: <4A699061.6010501@cn.fujitsu.com>
Date: Fri, 24 Jul 2009 18:43:45 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH 2/3] Apply walltime-supporting functions to trace system
References: <4A698F90.90501@cn.fujitsu.com>
In-Reply-To: <4A698F90.90501@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We modified ring-buffer function's arguments to support walltime recording.
There function's caller site needs to be updated to support it.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 include/linux/ftrace_event.h |    1 +
 kernel/trace/trace.c         |   25 +++++++++++++++----------
 kernel/trace/trace.h         |    3 ++-
 kernel/trace/trace_output.c  |    2 +-
 4 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 5c093ff..4ffd87a 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -58,6 +58,7 @@ struct trace_iterator {
 	struct trace_entry	*ent;
 	int			cpu;
 	u64			ts;
+	struct timespec		timespec;
 
 	loff_t			pos;
 	long			idx;
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 22787b3..af25bec 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1399,7 +1399,8 @@ static void trace_iterator_increment(struct trace_iterator *iter)
 }
 
 static struct trace_entry *
-peek_next_entry(struct trace_iterator *iter, int cpu, u64 *ts)
+peek_next_entry(struct trace_iterator *iter, int cpu, u64 *ts,
+		struct timespec *timespec)
 {
 	struct ring_buffer_event *event;
 	struct ring_buffer_iter *buf_iter = iter->buffer_iter[cpu];
@@ -1408,9 +1409,9 @@ peek_next_entry(struct trace_iterator *iter, int cpu, u64 *ts)
 	ftrace_disable_cpu();
 
 	if (buf_iter)
-		event = ring_buffer_iter_peek(buf_iter, ts, NULL);
+		event = ring_buffer_iter_peek(buf_iter, ts, timespec);
 	else
-		event = ring_buffer_peek(iter->tr->buffer, cpu, ts, NULL);
+		event = ring_buffer_peek(iter->tr->buffer, cpu, ts, timespec);
 
 	ftrace_enable_cpu();
 
@@ -1418,7 +1419,8 @@ peek_next_entry(struct trace_iterator *iter, int cpu, u64 *ts)
 }
 
 static struct trace_entry *
-__find_next_entry(struct trace_iterator *iter, int *ent_cpu, u64 *ent_ts)
+__find_next_entry(struct trace_iterator *iter, int *ent_cpu, u64 *ent_ts,
+		  struct timespec *timespec)
 {
 	struct ring_buffer *buffer = iter->tr->buffer;
 	struct trace_entry *ent, *next = NULL;
@@ -1434,7 +1436,7 @@ __find_next_entry(struct trace_iterator *iter, int *ent_cpu, u64 *ent_ts)
 	if (cpu_file > TRACE_PIPE_ALL_CPU) {
 		if (ring_buffer_empty_cpu(buffer, cpu_file))
 			return NULL;
-		ent = peek_next_entry(iter, cpu_file, ent_ts);
+		ent = peek_next_entry(iter, cpu_file, ent_ts, timespec);
 		if (ent_cpu)
 			*ent_cpu = cpu_file;
 
@@ -1446,7 +1448,7 @@ __find_next_entry(struct trace_iterator *iter, int *ent_cpu, u64 *ent_ts)
 		if (ring_buffer_empty_cpu(buffer, cpu))
 			continue;
 
-		ent = peek_next_entry(iter, cpu, &ts);
+		ent = peek_next_entry(iter, cpu, &ts, timespec);
 
 		/*
 		 * Pick the entry with the smallest timestamp:
@@ -1469,15 +1471,17 @@ __find_next_entry(struct trace_iterator *iter, int *ent_cpu, u64 *ent_ts)
 
 /* Find the next real entry, without updating the iterator itself */
 struct trace_entry *trace_find_next_entry(struct trace_iterator *iter,
-					  int *ent_cpu, u64 *ent_ts)
+					  int *ent_cpu, u64 *ent_ts,
+					  struct timespec *timespec)
 {
-	return __find_next_entry(iter, ent_cpu, ent_ts);
+	return __find_next_entry(iter, ent_cpu, ent_ts, timespec);
 }
 
 /* Find the next real entry, and increment the iterator to the next entry */
 static void *find_next_entry_inc(struct trace_iterator *iter)
 {
-	iter->ent = __find_next_entry(iter, &iter->cpu, &iter->ts);
+	iter->ent = __find_next_entry(iter, &iter->cpu, &iter->ts,
+				      &iter->timespec);
 
 	if (iter->ent)
 		trace_iterator_increment(iter);
@@ -1489,7 +1493,8 @@ static void trace_consume(struct trace_iterator *iter)
 {
 	/* Don't allow ftrace to trace into the ring buffers */
 	ftrace_disable_cpu();
-	ring_buffer_consume(iter->tr->buffer, iter->cpu, &iter->ts, NULL);
+	ring_buffer_consume(iter->tr->buffer, iter->cpu, &iter->ts,
+			    &iter->timespec);
 	ftrace_enable_cpu();
 }
 
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 06886a0..fb3dcc8 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -452,7 +452,8 @@ struct trace_entry *tracing_get_trace_entry(struct trace_array *tr,
 						struct trace_array_cpu *data);
 
 struct trace_entry *trace_find_next_entry(struct trace_iterator *iter,
-					  int *ent_cpu, u64 *ent_ts);
+					  int *ent_cpu, u64 *ent_ts,
+					  struct timespec *timtspec);
 
 void tracing_generic_entry_update(struct trace_entry *entry,
 				  unsigned long flags,
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index e0c2545..f5c7f0c 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -519,7 +519,7 @@ int trace_print_lat_context(struct trace_iterator *iter)
 	struct trace_seq *s = &iter->seq;
 	struct trace_entry *entry = iter->ent,
 			   *next_entry = trace_find_next_entry(iter, NULL,
-							       &next_ts);
+							       &next_ts, NULL);
 	unsigned long verbose = (trace_flags & TRACE_ITER_VERBOSE);
 	unsigned long abs_usecs = ns2usecs(iter->ts - iter->tr->time_start);
 	unsigned long rel_usecs;
-- 
1.5.5.3


