Return-Path: <linux-kernel-owner+w=401wt.eu-S932082AbZFIVz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082AbZFIVz1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 17:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758729AbZFIVxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 17:53:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:56764 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757085AbZFIVxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 17:53:38 -0400
Message-Id: <20090609215340.207386644@goodmis.org>
References: <20090609215211.307980196@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 09 Jun 2009 17:52:19 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
       Christoph Hellwig <hch@infradead.org>, Rik van Riel <riel@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Jiaying Zhang <jiayingz@google.com>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 8/8] tracing: add entry size to iterator
Content-Disposition: inline; filename=0008-tracing-add-entry-size-to-iterator.patch
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
index d963a78..1802459 100644
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
