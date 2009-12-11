Return-Path: <linux-kernel-owner+w=401wt.eu-S1760953AbZLKSmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760953AbZLKSmY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 13:42:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759302AbZLKSmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 13:42:17 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:43689 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759270AbZLKSmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 13:42:12 -0500
X-Authority-Analysis: v=1.0 c=1 a=Q7YcljQkFlEA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=OgLSKUWxS4_PA794gIYA:9 a=3GlOiBP8vADkVQawvLUA:7 a=bR1nEU-z9w9EGw0opfZ5J8L_dMcA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20091211184212.782017598@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 11 Dec 2009 13:40:19 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/2] [PATCH 1/2] tracing: Add trace_dump_stack()
References: <20091211184018.738768739@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Add-trace_dump_stack.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

I've been asked a few times about how to find out what is calling
some location in the kernel. One way is to use dynamic function tracing
and implement the func_stack_trace. But this only finds out who is
calling a particular function. It does not tell you who is calling
that function and entering a specific if conditional.

I have myself implemented a quick version of trace_dump_stack() for
this purpose a few times, and just needed it now. This is when I realized
that this would be a good tool to have in the kernel like trace_printk().

Using trace_dump_stack() is similar to dump_stack() except that it
writes to the trace buffer instead and can be used in critical locations.

For example:

@@ -5485,8 +5485,12 @@ need_resched_nonpreemptible:
 	if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
 		if (unlikely(signal_pending_state(prev->state, prev)))
 			prev->state = TASK_RUNNING;
-		else
+		else {
 			deactivate_task(rq, prev, 1);
+			trace_printk("Deactivating task %s:%d\n",
+				     prev->comm, prev->pid);
+			trace_dump_stack();
+		}
 		switch_count = &prev->nvcsw;
 	}

Produces:

           <...>-3249  [001]   296.105269: schedule: Deactivating task ntpd:3249
           <...>-3249  [001]   296.105270: <stack trace>
 => schedule
 => schedule_hrtimeout_range
 => poll_schedule_timeout
 => do_select
 => core_sys_select
 => sys_select
 => system_call_fastpath

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/kernel.h |    2 ++
 kernel/trace/trace.c   |   16 ++++++++++++++++
 2 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 3fa4c59..5ad4199 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -492,6 +492,8 @@ extern int
 __trace_printk(unsigned long ip, const char *fmt, ...)
 	__attribute__ ((format (printf, 2, 3)));
 
+extern void trace_dump_stack(void);
+
 /*
  * The double __builtin_constant_p is because gcc will give us an error
  * if we try to allocate the static variable to fmt if it is not a
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 88bd9ae..f531301 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1151,6 +1151,22 @@ void __trace_stack(struct trace_array *tr, unsigned long flags, int skip,
 	__ftrace_trace_stack(tr->buffer, flags, skip, pc);
 }
 
+/**
+ * trace_dump_stack - record a stack back trace in the trace buffer
+ */
+void trace_dump_stack(void)
+{
+	unsigned long flags;
+
+	if (tracing_disabled || tracing_selftest_running)
+		return 0;
+
+	local_save_flags(flags);
+
+	/* skipping 3 traces, seems to get us at the caller of this function */
+	__ftrace_trace_stack(global_trace.buffer, flags, 3, preempt_count());
+}
+
 void
 ftrace_trace_userstack(struct ring_buffer *buffer, unsigned long flags, int pc)
 {
-- 
1.6.5


