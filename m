Return-Path: <linux-kernel-owner+w=401wt.eu-S1757300AbYLFClr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300AbYLFClr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 21:41:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754522AbYLFClj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 21:41:39 -0500
Received: from fk-out-0910.google.com ([209.85.128.186]:10569 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214AbYLFCli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 21:41:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=rpYw5El1Ukr9GRDGynh4q+XBWFm4s8tS7O3jV6FAXXjrM09QLRIDl3U/iNfdWxVaOI
         rUFpP8aRX5Ik1voEowCQvNNvsSUv+AFWnbapw4Iwo8wTD1XTqwmhhZ5U4a/vdfwBpguq
         WCxnRbHnbp+NfNgzLofxeApydoy92ux0qPTjo=
Message-ID: <4939E65D.9060800@gmail.com>
Date: Sat, 06 Dec 2008 03:41:33 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] tracing/function-graph-tracer: turn tracing_selftest_running
 into an int
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanups

Apply some suggestions of Steven Rostedt:

_turn tracing_selftest_running into a simple int (no need of an atomic_t)
_set it __read_mostly
_fix a comment style

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 7a93c66..1cc0ebf 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -44,13 +44,14 @@
 unsigned long __read_mostly	tracing_max_latency = (cycle_t)ULONG_MAX;
 unsigned long __read_mostly	tracing_thresh;
 
-/* We need to change this state when a selftest is running.
+/*
+ * We need to change this state when a selftest is running.
  * A selftest will lurk into the ring-buffer to count the
  * entries inserted during the selftest although some concurrent
  * insertions into the ring-buffer such as ftrace_printk could occurred
  * at the same time, giving false positive or negative results.
  */
-static atomic_t tracing_selftest_running = ATOMIC_INIT(0);
+static bool __read_mostly tracing_selftest_running;
 
 /* For tracers that don't implement custom flags */
 static struct tracer_opt dummy_tracer_opt[] = {
@@ -574,6 +575,8 @@ int register_tracer(struct tracer *type)
 	unlock_kernel();
 	mutex_lock(&trace_types_lock);
 
+	tracing_selftest_running = true;
+
 	for (t = trace_types; t; t = t->next) {
 		if (strcmp(type->name, t->name) == 0) {
 			/* already found */
@@ -598,7 +601,6 @@ int register_tracer(struct tracer *type)
 		struct trace_array *tr = &global_trace;
 		int i;
 
-		atomic_set(&tracing_selftest_running, 1);
 		/*
 		 * Run a selftest on this tracer.
 		 * Here we reset the trace buffer, and set the current
@@ -613,7 +615,6 @@ int register_tracer(struct tracer *type)
 		/* the test is responsible for initializing and enabling */
 		pr_info("Testing tracer %s: ", type->name);
 		ret = type->selftest(type, tr);
-		atomic_set(&tracing_selftest_running, 0);
 		/* the test is responsible for resetting too */
 		current_trace = saved_tracer;
 		if (ret) {
@@ -635,6 +636,7 @@ int register_tracer(struct tracer *type)
 		max_tracer_type_len = len;
 
  out:
+	tracing_selftest_running = false;
 	mutex_unlock(&trace_types_lock);
 	lock_kernel();
 
@@ -3605,7 +3607,7 @@ int trace_vprintk(unsigned long ip, int depth, const char *fmt, va_list args)
 	unsigned long flags, irq_flags;
 	int cpu, len = 0, size, pc;
 
-	if (tracing_disabled || atomic_read(&tracing_selftest_running))
+	if (tracing_disabled || tracing_selftest_running)
 		return 0;
 
 	pc = preempt_count();
-- 
1.5.6.3

