Return-Path: <linux-kernel-owner+w=401wt.eu-S1763264AbZAUAwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763264AbZAUAwt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 19:52:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757431AbZAUAwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 19:52:40 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:33203 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757312AbZAUAwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 19:52:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:cc:subject;
        b=gFwKFDDmhXX+k91Jtgi/jmP6irYvxnWApHIkNvb3xs3UziPM5ZBOJTzwqmRuUXGeYd
         NNNorDzty5FKjZqw6DM651aA2a82urKZW7O6PCTKMy43oZWlFKQE+R9MON/sMjmk3Go9
         LHPEtJ7XGq0jJHxcl1cpJeK6TDL88EJ6Mq/10=
Message-ID: <497671d4.1358560a.7a83.6114@mx.google.com>
Date: Tue, 20 Jan 2009 16:52:36 -0800 (PST)
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] tracing/ftrace: add an option to not print the context info for events
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: make trace_event more convenient for tracers

All tracers (for the moment) that use the struct trace_event want to have
the context info printed before their own output: the pid/cmdline, cpu, and timestamp.

But some other tracers that want to implement their trace_event callbacks will
not necessary need these information.

This patch adds a new default-enabled trace option: TRACE_ITER_CONTEXT_INFO
When disabled through:

echo nocontext-info > /debugfs/tracing/trace_options

The pid, cpu and timestamps headers will not be printed.

IE with the sched_switch tracer with context-info (default):

            bash-2935  [001]   100.356561:   2935:120:S ==> [001]     0:140:R <idle>
          <idle>-0     [000]   100.412804:      0:140:R   + [000]    11:115:S events/0
          <idle>-0     [000]   100.412816:      0:140:R ==> [000]    11:115:R events/0
        events/0-11    [000]   100.412829:     11:115:S ==> [000]     0:140:R <idle>

Without context-info:

  2935:120:S ==> [001]     0:140:R <idle>
     0:140:R   + [000]    11:115:S events/0
     0:140:R ==> [000]    11:115:R events/0
    11:115:S ==> [000]     0:140:R <idle>

A tracer can disable it at runtime by clearing the bit TRACE_ITER_CONTEXT_INFO in trace_flags.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace.c |   61 ++++++++++++++++++++++++++++---------------------
 kernel/trace/trace.h |    3 +-
 2 files changed, 37 insertions(+), 27 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 220c264..a59ba48 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -227,7 +227,7 @@ static DECLARE_WAIT_QUEUE_HEAD(trace_wait);
 
 /* trace_flags holds trace_options default values */
 unsigned long trace_flags = TRACE_ITER_PRINT_PARENT | TRACE_ITER_PRINTK |
-	TRACE_ITER_ANNOTATE;
+	TRACE_ITER_ANNOTATE | TRACE_ITER_CONTEXT_INFO;
 
 /**
  * trace_wake_up - wake up tasks waiting for trace input
@@ -285,6 +285,7 @@ static const char *trace_options[] = {
 	"userstacktrace",
 	"sym-userobj",
 	"printk-msg-only",
+	"context-info",
 	NULL
 };
 
@@ -1487,21 +1488,23 @@ static enum print_line_t print_trace_fmt(struct trace_iterator *iter)
 
 	test_cpu_buff_start(iter);
 
-	comm = trace_find_cmdline(iter->ent->pid);
-
-	t = ns2usecs(iter->ts);
-	usec_rem = do_div(t, 1000000ULL);
-	secs = (unsigned long)t;
-
-	ret = trace_seq_printf(s, "%16s-%-5d ", comm, entry->pid);
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
-	ret = trace_seq_printf(s, "[%03d] ", iter->cpu);
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
-	ret = trace_seq_printf(s, "%5lu.%06lu: ", secs, usec_rem);
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
+	if (trace_flags & TRACE_ITER_CONTEXT_INFO) {
+		comm = trace_find_cmdline(iter->ent->pid);
+
+		t = ns2usecs(iter->ts);
+		usec_rem = do_div(t, 1000000ULL);
+		secs = (unsigned long)t;
+
+		ret = trace_seq_printf(s, "%16s-%-5d ", comm, entry->pid);
+		if (!ret)
+			return TRACE_TYPE_PARTIAL_LINE;
+		ret = trace_seq_printf(s, "[%03d] ", iter->cpu);
+		if (!ret)
+			return TRACE_TYPE_PARTIAL_LINE;
+		ret = trace_seq_printf(s, "%5lu.%06lu: ", secs, usec_rem);
+		if (!ret)
+			return TRACE_TYPE_PARTIAL_LINE;
+	}
 
 	event = ftrace_find_event(entry->type);
 	if (event && event->trace) {
@@ -1526,10 +1529,12 @@ static enum print_line_t print_raw_fmt(struct trace_iterator *iter)
 
 	entry = iter->ent;
 
-	ret = trace_seq_printf(s, "%d %d %llu ",
-		entry->pid, iter->cpu, iter->ts);
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
+	if (trace_flags & TRACE_ITER_CONTEXT_INFO) {
+		ret = trace_seq_printf(s, "%d %d %llu ",
+			entry->pid, iter->cpu, iter->ts);
+		if (!ret)
+			return TRACE_TYPE_PARTIAL_LINE;
+	}
 
 	event = ftrace_find_event(entry->type);
 	if (event && event->raw) {
@@ -1554,9 +1559,11 @@ static enum print_line_t print_hex_fmt(struct trace_iterator *iter)
 
 	entry = iter->ent;
 
-	SEQ_PUT_HEX_FIELD_RET(s, entry->pid);
-	SEQ_PUT_HEX_FIELD_RET(s, iter->cpu);
-	SEQ_PUT_HEX_FIELD_RET(s, iter->ts);
+	if (trace_flags & TRACE_ITER_CONTEXT_INFO) {
+		SEQ_PUT_HEX_FIELD_RET(s, entry->pid);
+		SEQ_PUT_HEX_FIELD_RET(s, iter->cpu);
+		SEQ_PUT_HEX_FIELD_RET(s, iter->ts);
+	}
 
 	event = ftrace_find_event(entry->type);
 	if (event && event->hex)
@@ -1591,9 +1598,11 @@ static enum print_line_t print_bin_fmt(struct trace_iterator *iter)
 
 	entry = iter->ent;
 
-	SEQ_PUT_FIELD_RET(s, entry->pid);
-	SEQ_PUT_FIELD_RET(s, entry->cpu);
-	SEQ_PUT_FIELD_RET(s, iter->ts);
+	if (trace_flags & TRACE_ITER_CONTEXT_INFO) {
+		SEQ_PUT_FIELD_RET(s, entry->pid);
+		SEQ_PUT_FIELD_RET(s, entry->cpu);
+		SEQ_PUT_FIELD_RET(s, iter->ts);
+	}
 
 	event = ftrace_find_event(entry->type);
 	if (event && event->binary)
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index b96037d..282248e 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -590,7 +590,8 @@ enum trace_iterator_flags {
 	TRACE_ITER_ANNOTATE		= 0x2000,
 	TRACE_ITER_USERSTACKTRACE       = 0x4000,
 	TRACE_ITER_SYM_USEROBJ          = 0x8000,
-	TRACE_ITER_PRINTK_MSGONLY	= 0x10000
+	TRACE_ITER_PRINTK_MSGONLY	= 0x10000,
+	TRACE_ITER_CONTEXT_INFO		= 0x20000 /* Print pid/cpu/time */
 };
 
 /*
-- 
1.6.0.4


