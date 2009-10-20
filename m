Return-Path: <linux-kernel-owner+w=401wt.eu-S1752609AbZJTQAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609AbZJTQAy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 12:00:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752484AbZJTQAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 12:00:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12750 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752193AbZJTQAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 12:00:52 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: mingo@elte.hu, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH] tracing - fix function graph trace to properly skip records
Date: Tue, 20 Oct 2009 18:00:39 +0200
Message-Id: <1256054439-24386-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

there's a case where the graph tracer might get confused and displays
"{}" brackets in a wrong way.

Sorry for long description, but I found no better way to 
describe the issue.. ;)


As the function_graph tracer goes through the trace entries (using "trace" file)
it keeps pointer to the current record and the next one:

current ->  func1 ENTRY
   next ->  func2 ENTRY
            func2 RETURN
            func1 RETURN

If it spots adjacent ENTRY and RETURN trace entries of the same function
and pid, it displays the "func2();" trace

            func1 ENTRY
current ->  func2 ENTRY 
   next ->  func2 RETURN
            func1 RETURN

and moves the next trace entry pointer behind the RETURN entry

            func1 ENTRY
current ->  func2 ENTRY 
            func2 RETURN
   next ->  func1 RETURN

so the next record peek will skip the RETURN entry and continue with
whatever is next.

It works ok but for one case. 

If the "func2()" trace does not make it to the seq_file read buffer, it needs
to be processed again in the next read.  And here comes the issue: 
the next read will see following pointers setup for func2 processing:

            func1 ENTRY
current ->  func2 ENTRY 
            func2 RETURN
   next ->  func1 RETURN

which will turn to displaying the func2 entry like: "func2() {", since the
next entry is not RETURN of the same type.  Generaly it is whatever entry 
that follows, but definitelly not the RETURN entry of the same function.

Following patch fixes the issue by skipping the entry in the last moment,
bypassing the issue to happen during the sequential reads.

wbr,
jirka


NOTE:

AFAIK patch does not affect "trace_pipe" handling, since the change is
on the ring_buffer_iter level. However the "trace_pipe" suffers from
the same issue -> when the read buffer is filled up, the current trace
entry is not copied to it. Following read will continue with next entry.
It might be harder to fix this, since "trace_pipe" in order to see next
record has to eat the current one... 

I'll look at possible solution, but any ideas are welcome.. :)



Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 include/linux/ftrace_event.h         |    1 +
 kernel/trace/trace.c                 |   29 +++++++++++++++++++++++++++++
 kernel/trace/trace_functions_graph.c |    2 +-
 3 files changed, 31 insertions(+), 1 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index d117704..7b07ad2 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -53,6 +53,7 @@ struct trace_iterator {
 	struct mutex		mutex;
 	struct ring_buffer_iter	*buffer_iter[NR_CPUS];
 	unsigned long		iter_flags;
+	bool			skip_entry;
 
 	/* The below is zeroed out in pipe_read */
 	struct trace_seq	seq;
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 026e715..b8032b4 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1490,9 +1490,35 @@ struct trace_entry *trace_find_next_entry(struct trace_iterator *iter,
 	return __find_next_entry(iter, ent_cpu, ent_ts);
 }
 
+/*
+ * Move the head pointer one trace entry forward.
+ *
+ * Used currently by the function graph trace. It needs to move across
+ * the trace "RET record" in case of adjacent ENTRY and RET records,
+ * in order to display correctly the "();" or "{}" brackets.
+ */
+static void skip_entry(struct trace_iterator *iter)
+{
+	struct ring_buffer_iter *ring_iter;
+
+	/* Don't allow ftrace to trace into the ring buffers */
+	ftrace_disable_cpu();
+
+	ring_iter = iter->buffer_iter[iter->cpu];
+	if (ring_iter)
+		ring_buffer_read(ring_iter, NULL);
+
+	iter->skip_entry = false;
+
+	ftrace_enable_cpu();
+}
+
 /* Find the next real entry, and increment the iterator to the next entry */
 static void *find_next_entry_inc(struct trace_iterator *iter)
 {
+	if (iter->skip_entry)
+		skip_entry(iter);
+
 	iter->ent = __find_next_entry(iter, &iter->cpu, &iter->ts);
 
 	if (iter->ent)
@@ -1594,6 +1620,9 @@ static void *s_start(struct seq_file *m, loff_t *pos)
 
 	atomic_inc(&trace_record_cmdline_disabled);
 
+	/* Starting new read, no record skipping is desirable. */
+	iter->skip_entry = false;
+
 	if (*pos != iter->pos) {
 		iter->ent = NULL;
 		iter->cpu = 0;
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 45e6c01..1cf80f2 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -465,7 +465,7 @@ get_return_for_leaf(struct trace_iterator *iter,
 
 	/* this is a leaf, now advance the iterator */
 	if (ring_iter)
-		ring_buffer_read(ring_iter, NULL);
+		iter->skip_entry = true;
 
 	return next;
 }
