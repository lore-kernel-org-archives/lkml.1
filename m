Return-Path: <linux-kernel-owner+w=401wt.eu-S1756118AbZG2ROA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118AbZG2ROA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 13:14:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755959AbZG2RNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 13:13:41 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:37745 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755966AbZG2RNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 13:13:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=BMCs5WEMRz++1lIpeUyrp8hv9sm+lwDilAz6m7C4mkjaZEFQ8SdDieeNnbHMVo1quW
         G68wfCEqoDLH8k55Il1KHcj5ASqhWIiIn15mmeKx8fJyK5AcruRhqVHiHR/232HnHi0q
         f0RLRTKBLm1ZVf4/vI/Ie87kdlxrOiFZ918cQ=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 3/6] tracing/function-tracer: Move trace_function() in the function tracer file
Date: Wed, 29 Jul 2009 19:13:26 +0200
Message-Id: <1248887609-5147-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1248887609-5147-1-git-send-email-fweisbec@gmail.com>
References: <1248887609-5147-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The trace_function() helper which inserts the function events into
the ring buffer is currently in trace.c
But this file is quite overloaded and the right place for this helper
is in the function tracer file.

Then move it in trace_functions.c

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c           |   27 +--------------------------
 kernel/trace/trace.h           |    1 +
 kernel/trace/trace_functions.c |   25 +++++++++++++++++++++++++
 3 files changed, 27 insertions(+), 26 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index e30e6b1..769d5cf 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -89,7 +89,7 @@ static int dummy_set_flag(u32 old_flags, u32 bit, int set)
  */
 static int tracing_disabled = 1;
 
-static DEFINE_PER_CPU(local_t, ftrace_cpu_disabled);
+DEFINE_PER_CPU(local_t, ftrace_cpu_disabled);
 
 static inline void ftrace_disable_cpu(void)
 {
@@ -921,31 +921,6 @@ void trace_current_buffer_discard_commit(struct ring_buffer_event *event)
 }
 EXPORT_SYMBOL_GPL(trace_current_buffer_discard_commit);
 
-void
-trace_function(struct trace_array *tr,
-	       unsigned long ip, unsigned long parent_ip, unsigned long flags,
-	       int pc)
-{
-	struct ftrace_event_call *call = &event_function;
-	struct ring_buffer_event *event;
-	struct ftrace_entry *entry;
-
-	/* If we are reading the ring buffer, don't trace */
-	if (unlikely(local_read(&__get_cpu_var(ftrace_cpu_disabled))))
-		return;
-
-	event = trace_buffer_lock_reserve(tr, TRACE_FN, sizeof(*entry),
-					  flags, pc);
-	if (!event)
-		return;
-	entry	= ring_buffer_event_data(event);
-	entry->ip			= ip;
-	entry->parent_ip		= parent_ip;
-
-	if (!filter_check_discard(call, entry, tr->buffer, event))
-		ring_buffer_unlock_commit(tr->buffer, event);
-}
-
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 static int __trace_graph_entry(struct trace_array *tr,
 				struct ftrace_graph_ent *trace,
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 94305c7..186543a 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -519,6 +519,7 @@ extern int DYN_FTRACE_TEST_NAME(void);
 
 extern int ring_buffer_expanded;
 extern bool tracing_selftest_disabled;
+DECLARE_PER_CPU(local_t, ftrace_cpu_disabled);
 
 #ifdef CONFIG_FTRACE_STARTUP_TEST
 extern int trace_selftest_startup_function(struct tracer *trace,
diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index 5b01b94..28d3295 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -47,6 +47,31 @@ static void function_trace_start(struct trace_array *tr)
 	tracing_reset_online_cpus(tr);
 }
 
+void
+trace_function(struct trace_array *tr,
+	       unsigned long ip, unsigned long parent_ip, unsigned long flags,
+	       int pc)
+{
+	struct ftrace_event_call *call = &event_function;
+	struct ring_buffer_event *event;
+	struct ftrace_entry *entry;
+
+	/* If we are reading the ring buffer, don't trace */
+	if (unlikely(local_read(&__get_cpu_var(ftrace_cpu_disabled))))
+		return;
+
+	event = trace_buffer_lock_reserve(tr, TRACE_FN, sizeof(*entry),
+					  flags, pc);
+	if (!event)
+		return;
+	entry	= ring_buffer_event_data(event);
+	entry->ip			= ip;
+	entry->parent_ip		= parent_ip;
+
+	if (!filter_check_discard(call, entry, tr->buffer, event))
+		ring_buffer_unlock_commit(tr->buffer, event);
+}
+
 static void
 function_trace_call_preempt_only(unsigned long ip, unsigned long parent_ip)
 {
-- 
1.6.2.3

