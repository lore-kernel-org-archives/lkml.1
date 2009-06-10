Return-Path: <linux-kernel-owner+w=401wt.eu-S1758571AbZFJRAN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758571AbZFJRAN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 13:00:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755640AbZFJQ76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 12:59:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:59496 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958AbZFJQ75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 12:59:57 -0400
Message-Id: <20090610165958.668708357@goodmis.org>
References: <20090610165306.794813861@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 10 Jun 2009 12:53:07 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mel@csn.ul.ie>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: [PATCH 01/11] tracing: add entry size to iterator
Content-Disposition: inline; filename=0001-tracing-add-entry-size-to-iterator.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

In order to test against corruption of records, the size of the entry
needs to be passed to callbacks. This patch places the entry size
into a new field of the iterator "ent_size", that print call backs
can access.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h |    1 +
 kernel/trace/trace.c         |   39 ++++++++++++++++++++++++---------------
 2 files changed, 25 insertions(+), 15 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 5c093ff..c03befb 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -56,6 +56,7 @@ struct trace_iterator {
 	/* The below is zeroed out in pipe_read */
 	struct trace_seq	seq;
 	struct trace_entry	*ent;
+	unsigned int		ent_size;
 	int			cpu;
 	u64			ts;
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index cae34c6..d83036d 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1398,7 +1398,7 @@ static void trace_iterator_increment(struct trace_iterator *iter)
 	ftrace_enable_cpu();
 }
 
-static struct trace_entry *
+static struct ring_buffer_event *
 peek_next_entry(struct trace_iterator *iter, int cpu, u64 *ts)
 {
 	struct ring_buffer_event *event;
@@ -1414,15 +1414,17 @@ peek_next_entry(struct trace_iterator *iter, int cpu, u64 *ts)
 
 	ftrace_enable_cpu();
 
-	return event ? ring_buffer_event_data(event) : NULL;
+	return event;
 }
 
 static struct trace_entry *
-__find_next_entry(struct trace_iterator *iter, int *ent_cpu, u64 *ent_ts)
+__find_next_entry(struct trace_iterator *iter, int *ent_cpu, u64 *ent_ts,
+		  unsigned int *ent_size)
 {
 	struct ring_buffer *buffer = iter->tr->buffer;
-	struct trace_entry *ent, *next = NULL;
+	struct ring_buffer_event *event, *next = NULL;
 	int cpu_file = iter->cpu_file;
+	struct trace_entry *ent;
 	u64 next_ts = 0, ts;
 	int next_cpu = -1;
 	int cpu;
@@ -1434,11 +1436,9 @@ __find_next_entry(struct trace_iterator *iter, int *ent_cpu, u64 *ent_ts)
 	if (cpu_file > TRACE_PIPE_ALL_CPU) {
 		if (ring_buffer_empty_cpu(buffer, cpu_file))
 			return NULL;
-		ent = peek_next_entry(iter, cpu_file, ent_ts);
-		if (ent_cpu)
-			*ent_cpu = cpu_file;
-
-		return ent;
+		next_cpu = cpu_file;
+		next = peek_next_entry(iter, cpu_file, &next_ts);
+		goto out;
 	}
 
 	for_each_tracing_cpu(cpu) {
@@ -1446,38 +1446,47 @@ __find_next_entry(struct trace_iterator *iter, int *ent_cpu, u64 *ent_ts)
 		if (ring_buffer_empty_cpu(buffer, cpu))
 			continue;
 
-		ent = peek_next_entry(iter, cpu, &ts);
+		event = peek_next_entry(iter, cpu, &ts);
 
 		/*
 		 * Pick the entry with the smallest timestamp:
 		 */
-		if (ent && (!next || ts < next_ts)) {
-			next = ent;
+		if (event && (!next || ts < next_ts)) {
+			next = event;
 			next_cpu = cpu;
 			next_ts = ts;
 		}
 	}
 
+ out:
 	if (ent_cpu)
 		*ent_cpu = next_cpu;
 
 	if (ent_ts)
 		*ent_ts = next_ts;
 
-	return next;
+	if (!next)
+		return NULL;
+
+	ent = ring_buffer_event_data(next);
+	if (ent_size)
+		*ent_size = ring_buffer_event_length(next);
+
+	return ent;
 }
 
 /* Find the next real entry, without updating the iterator itself */
 struct trace_entry *trace_find_next_entry(struct trace_iterator *iter,
 					  int *ent_cpu, u64 *ent_ts)
 {
-	return __find_next_entry(iter, ent_cpu, ent_ts);
+	return __find_next_entry(iter, ent_cpu, ent_ts, NULL);
 }
 
 /* Find the next real entry, and increment the iterator to the next entry */
 static void *find_next_entry_inc(struct trace_iterator *iter)
 {
-	iter->ent = __find_next_entry(iter, &iter->cpu, &iter->ts);
+	iter->ent = __find_next_entry(iter, &iter->cpu, &iter->ts,
+				      &iter->ent_size);
 
 	if (iter->ent)
 		trace_iterator_increment(iter);
-- 
1.6.3.1

-- 
