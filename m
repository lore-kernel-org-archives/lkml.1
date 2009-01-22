Return-Path: <linux-kernel-owner+w=401wt.eu-S1755461AbZAVUVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461AbZAVUVV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 15:21:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbZAVUVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 15:21:12 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:58133 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbZAVUVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 15:21:11 -0500
Message-Id: <20090122202109.574158313@goodmis.org>
References: <20090122202030.210768976@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 22 Jan 2009 15:20:31 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/2] trace: remove internal irqsoff disabling for trace output
Content-Disposition: inline; filename=0001-trace-remove-internal-irqsoff-disabling-for-trace-o.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: cleanup of duplicate features

The trace output disables the ring buffer and prevents tracing to
occur. The code in irqsoff to do the same thing is no longer needed.
This patch removes it.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace_irqsoff.c |   34 ++--------------------------------
 1 files changed, 2 insertions(+), 32 deletions(-)

diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index 62a78d9..ed344b0 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -353,28 +353,18 @@ void trace_preempt_off(unsigned long a0, unsigned long a1)
 }
 #endif /* CONFIG_PREEMPT_TRACER */
 
-/*
- * save_tracer_enabled is used to save the state of the tracer_enabled
- * variable when we disable it when we open a trace output file.
- */
-static int save_tracer_enabled;
-
 static void start_irqsoff_tracer(struct trace_array *tr)
 {
 	register_ftrace_function(&trace_ops);
-	if (tracing_is_enabled()) {
+	if (tracing_is_enabled())
 		tracer_enabled = 1;
-		save_tracer_enabled = 1;
-	} else {
+	else
 		tracer_enabled = 0;
-		save_tracer_enabled = 0;
-	}
 }
 
 static void stop_irqsoff_tracer(struct trace_array *tr)
 {
 	tracer_enabled = 0;
-	save_tracer_enabled = 0;
 	unregister_ftrace_function(&trace_ops);
 }
 
@@ -395,25 +385,11 @@ static void irqsoff_tracer_reset(struct trace_array *tr)
 static void irqsoff_tracer_start(struct trace_array *tr)
 {
 	tracer_enabled = 1;
-	save_tracer_enabled = 1;
 }
 
 static void irqsoff_tracer_stop(struct trace_array *tr)
 {
 	tracer_enabled = 0;
-	save_tracer_enabled = 0;
-}
-
-static void irqsoff_tracer_open(struct trace_iterator *iter)
-{
-	/* stop the trace while dumping */
-	tracer_enabled = 0;
-}
-
-static void irqsoff_tracer_close(struct trace_iterator *iter)
-{
-	/* restart tracing */
-	tracer_enabled = save_tracer_enabled;
 }
 
 #ifdef CONFIG_IRQSOFF_TRACER
@@ -431,8 +407,6 @@ static struct tracer irqsoff_tracer __read_mostly =
 	.reset		= irqsoff_tracer_reset,
 	.start		= irqsoff_tracer_start,
 	.stop		= irqsoff_tracer_stop,
-	.open		= irqsoff_tracer_open,
-	.close		= irqsoff_tracer_close,
 	.print_max	= 1,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    = trace_selftest_startup_irqsoff,
@@ -459,8 +433,6 @@ static struct tracer preemptoff_tracer __read_mostly =
 	.reset		= irqsoff_tracer_reset,
 	.start		= irqsoff_tracer_start,
 	.stop		= irqsoff_tracer_stop,
-	.open		= irqsoff_tracer_open,
-	.close		= irqsoff_tracer_close,
 	.print_max	= 1,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    = trace_selftest_startup_preemptoff,
@@ -489,8 +461,6 @@ static struct tracer preemptirqsoff_tracer __read_mostly =
 	.reset		= irqsoff_tracer_reset,
 	.start		= irqsoff_tracer_start,
 	.stop		= irqsoff_tracer_stop,
-	.open		= irqsoff_tracer_open,
-	.close		= irqsoff_tracer_close,
 	.print_max	= 1,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    = trace_selftest_startup_preemptirqsoff,
-- 
1.5.6.5

-- 
