Return-Path: <linux-kernel-owner+w=401wt.eu-S1756331AbZAPE4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756331AbZAPE4V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 23:56:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757003AbZAPEyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 23:54:24 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:45776 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756168AbZAPEyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 23:54:20 -0500
Message-Id: <20090116045418.272102432@goodmis.org>
References: <20090116045342.748642160@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 15 Jan 2009 23:53:46 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 4/6] ftrace: combine stack trace in function call
Content-Disposition: inline; filename=0004-ftrace-combine-stack-trace-in-function-call.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: less likely to interleave function and stack traces

This patch does replaces the separate stack trace on function with
a record function and stack trace together. This will switch between
the function only recording to a function and stack recording.

Also some whitespace fix ups as well.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace_functions.c |   61 +++++++++++++++++++++++----------------
 1 files changed, 36 insertions(+), 25 deletions(-)

diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index 2dce3c7..61d0b73 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -133,6 +133,7 @@ function_stack_trace_call(unsigned long ip, unsigned long parent_ip)
 
 	if (likely(disabled == 1)) {
 		pc = preempt_count();
+		trace_function(tr, data, ip, parent_ip, flags, pc);
 		/*
 		 * skip over 5 funcs:
 		 *    __ftrace_trace_stack,
@@ -154,24 +155,6 @@ static struct ftrace_ops trace_ops __read_mostly =
 	.func = function_trace_call,
 };
 
-void tracing_start_function_trace(void)
-{
-	ftrace_function_enabled = 0;
-
-	if (trace_flags & TRACE_ITER_PREEMPTONLY)
-		trace_ops.func = function_trace_call_preempt_only;
-	else
-		trace_ops.func = function_trace_call;
-
-	register_ftrace_function(&trace_ops);
-	ftrace_function_enabled = 1;
-}
-
-void tracing_stop_function_trace(void)
-{
-	ftrace_function_enabled = 0;
-	unregister_ftrace_function(&trace_ops);
-}
 static struct ftrace_ops trace_stack_ops __read_mostly =
 {
 	.func = function_stack_trace_call,
@@ -194,6 +177,31 @@ static struct tracer_flags func_flags = {
 	.opts = func_opts
 };
 
+void tracing_start_function_trace(void)
+{
+	ftrace_function_enabled = 0;
+
+	if (trace_flags & TRACE_ITER_PREEMPTONLY)
+		trace_ops.func = function_trace_call_preempt_only;
+	else
+		trace_ops.func = function_trace_call;
+
+	if (func_flags.val & TRACE_FUNC_OPT_STACK)
+		register_ftrace_function(&trace_stack_ops);
+	else
+		register_ftrace_function(&trace_ops);
+
+	ftrace_function_enabled = 1;
+}
+
+void tracing_stop_function_trace(void)
+{
+	ftrace_function_enabled = 0;
+	/* OK if they are not registered */
+	unregister_ftrace_function(&trace_stack_ops);
+	unregister_ftrace_function(&trace_ops);
+}
+
 static int func_set_flag(u32 old_flags, u32 bit, int set)
 {
 	if (bit == TRACE_FUNC_OPT_STACK) {
@@ -201,10 +209,13 @@ static int func_set_flag(u32 old_flags, u32 bit, int set)
 		if (!!set == !!(func_flags.val & TRACE_FUNC_OPT_STACK))
 			return 0;
 
-		if (set)
+		if (set) {
+			unregister_ftrace_function(&trace_ops);
 			register_ftrace_function(&trace_stack_ops);
-		else
+		} else {
 			unregister_ftrace_function(&trace_stack_ops);
+			register_ftrace_function(&trace_ops);
+		}
 
 		return 0;
 	}
@@ -214,14 +225,14 @@ static int func_set_flag(u32 old_flags, u32 bit, int set)
 
 static struct tracer function_trace __read_mostly =
 {
-	.name	     = "function",
-	.init	     = function_trace_init,
-	.reset	     = function_trace_reset,
-	.start	     = function_trace_start,
+	.name		= "function",
+	.init		= function_trace_init,
+	.reset		= function_trace_reset,
+	.start		= function_trace_start,
 	.flags		= &func_flags,
 	.set_flag	= func_set_flag,
 #ifdef CONFIG_FTRACE_SELFTEST
-	.selftest    = trace_selftest_startup_function,
+	.selftest	= trace_selftest_startup_function,
 #endif
 };
 
-- 
1.5.6.5

-- 
