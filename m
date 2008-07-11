Return-Path: <linux-kernel-owner+w=401wt.eu-S1760300AbYGKBBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760300AbYGKBBk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 21:01:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756124AbYGKA74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 20:59:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:49782 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755722AbYGKA7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 20:59:52 -0400
Message-Id: <20080711005951.384765314@goodmis.org>
References: <20080711005808.316194101@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 10 Jul 2008 20:58:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 8/8] ftrace: separate out the function enabled variable
Content-Disposition: inline; filename=ftrace-stop-trace.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the function tracer uses the global tracer_enabled variable that
is used to keep track if the tracer is enabled or not. The function tracing
startup needs to be separated out, otherwise the internal happenings of
the tracer startup is also recorded.

This patch creates a ftrace_function_enabled variable to all the starting
of the function traces to happen after everything has been started.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c |   22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

Index: linux-tip.git/kernel/trace/trace.c
===================================================================
--- linux-tip.git.orig/kernel/trace/trace.c	2008-07-10 20:26:33.000000000 -0400
+++ linux-tip.git/kernel/trace/trace.c	2008-07-10 20:38:17.000000000 -0400
@@ -96,6 +96,9 @@ static DEFINE_PER_CPU(struct trace_array
 /* tracer_enabled is used to toggle activation of a tracer */
 static int			tracer_enabled = 1;
 
+/* function tracing enabled */
+int				ftrace_function_enabled;
+
 /*
  * trace_nr_entries is the number of entries that is allocated
  * for a buffer. Note, the number of entries is always rounded
@@ -134,6 +137,7 @@ static notrace void no_trace_init(struct
 {
 	int cpu;
 
+	ftrace_function_enabled = 0;
 	if(tr->ctrl)
 		for_each_online_cpu(cpu)
 			tracing_reset(tr->data[cpu]);
@@ -985,7 +989,7 @@ function_trace_call(unsigned long ip, un
 	long disabled;
 	int cpu;
 
-	if (unlikely(!tracer_enabled))
+	if (unlikely(!ftrace_function_enabled))
 		return;
 
 	if (skip_trace(ip))
@@ -1010,11 +1014,15 @@ static struct ftrace_ops trace_ops __rea
 
 void tracing_start_function_trace(void)
 {
+	ftrace_function_enabled = 0;
 	register_ftrace_function(&trace_ops);
+	if (tracer_enabled)
+		ftrace_function_enabled = 1;
 }
 
 void tracing_stop_function_trace(void)
 {
+	ftrace_function_enabled = 0;
 	unregister_ftrace_function(&trace_ops);
 }
 #endif
@@ -1850,8 +1858,10 @@ __tracing_open(struct inode *inode, stru
 		m->private = iter;
 
 		/* stop the trace while dumping */
-		if (iter->tr->ctrl)
+		if (iter->tr->ctrl) {
 			tracer_enabled = 0;
+			ftrace_function_enabled = 0;
+		}
 
 		if (iter->trace && iter->trace->open)
 			iter->trace->open(iter);
@@ -1884,8 +1894,14 @@ int tracing_release(struct inode *inode,
 		iter->trace->close(iter);
 
 	/* reenable tracing if it was previously enabled */
-	if (iter->tr->ctrl)
+	if (iter->tr->ctrl) {
 		tracer_enabled = 1;
+		/*
+		 * It is safe to enable function tracing even if it
+		 * isn't used
+		 */
+		ftrace_function_enabled = 1;
+	}
 	mutex_unlock(&trace_types_lock);
 
 	seq_release(inode, file);

-- 
