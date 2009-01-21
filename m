Return-Path: <linux-kernel-owner+w=401wt.eu-S1755560AbZAUX6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560AbZAUX6W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 18:58:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754388AbZAUX6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 18:58:09 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:42888 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754269AbZAUX6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 18:58:08 -0500
Message-Id: <20090121235805.771064570@goodmis.org>
References: <20090121235306.224764198@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 21 Jan 2009 18:53:07 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/5] trace: do not disable wake up tracer on output of trace
Content-Disposition: inline; filename=0001-trace-do-not-disable-wake-up-tracer-on-output-of-tr.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: fix to erased trace output

To try not to have the outputing of a trace interfere with the wakeup
tracer, it would disable tracing while the output was printing. But
if a trace had started when it was disabled, it can show a partial
trace. To try to solve this, on closing of the tracer, it would
clear the trace buffer.

The latency tracers (wakeup and irqsoff) have two buffers. One for
recording and one for holding the max trace that is printed. The
clearing of the trace above should only affect the recording buffer.
But for some reason it would move the erased trace to the print
buffer. Probably due to a race with the closing of the trace and
the saving ofhe max race.

The above is all pretty useless, and if the user does not want the
printing of the trace to be traced itself, then the user can manual
disable tracing. This patch removes all the code that tries to keep
the output of the tracer from modifying the trace.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace_sched_wakeup.c |   33 ++-------------------------------
 1 files changed, 2 insertions(+), 31 deletions(-)

diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index 42ae1e7..e27adef 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -262,12 +262,6 @@ out:
 	atomic_dec(&wakeup_trace->data[cpu]->disabled);
 }
 
-/*
- * save_tracer_enabled is used to save the state of the tracer_enabled
- * variable when we disable it when we open a trace output file.
- */
-static int save_tracer_enabled;
-
 static void start_wakeup_tracer(struct trace_array *tr)
 {
 	int ret;
@@ -306,13 +300,10 @@ static void start_wakeup_tracer(struct trace_array *tr)
 
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
 
 	return;
 fail_deprobe_wake_new:
@@ -324,7 +315,6 @@ fail_deprobe:
 static void stop_wakeup_tracer(struct trace_array *tr)
 {
 	tracer_enabled = 0;
-	save_tracer_enabled = 0;
 	unregister_ftrace_function(&trace_ops);
 	unregister_trace_sched_switch(probe_wakeup_sched_switch);
 	unregister_trace_sched_wakeup_new(probe_wakeup);
@@ -350,28 +340,11 @@ static void wakeup_tracer_start(struct trace_array *tr)
 {
 	wakeup_reset(tr);
 	tracer_enabled = 1;
-	save_tracer_enabled = 1;
 }
 
 static void wakeup_tracer_stop(struct trace_array *tr)
 {
 	tracer_enabled = 0;
-	save_tracer_enabled = 0;
-}
-
-static void wakeup_tracer_open(struct trace_iterator *iter)
-{
-	/* stop the trace while dumping */
-	tracer_enabled = 0;
-}
-
-static void wakeup_tracer_close(struct trace_iterator *iter)
-{
-	/* forget about any processes we were recording */
-	if (save_tracer_enabled) {
-		wakeup_reset(iter->tr);
-		tracer_enabled = 1;
-	}
 }
 
 static struct tracer wakeup_tracer __read_mostly =
@@ -381,8 +354,6 @@ static struct tracer wakeup_tracer __read_mostly =
 	.reset		= wakeup_tracer_reset,
 	.start		= wakeup_tracer_start,
 	.stop		= wakeup_tracer_stop,
-	.open		= wakeup_tracer_open,
-	.close		= wakeup_tracer_close,
 	.print_max	= 1,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    = trace_selftest_startup_wakeup,
-- 
1.5.6.5

-- 
