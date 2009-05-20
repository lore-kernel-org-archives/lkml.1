Return-Path: <linux-kernel-owner+w=401wt.eu-S1755781AbZETAo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781AbZETAo5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 20:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754964AbZETAou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 20:44:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:52472 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754887AbZETAou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 20:44:50 -0400
Date: Tue, 19 May 2009 20:44:50 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH][GIT PULL] tracing: add trace_stack interface
Message-ID: <alpine.DEB.2.00.0905192043090.7816@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/ftrace tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/ftrace


Steven Rostedt (1):
      tracing: add trace_stack interface

----
 include/linux/kernel.h |    2 ++
 kernel/trace/trace.c   |   15 +++++++++++++++
 2 files changed, 17 insertions(+), 0 deletions(-)
---------------------------
commit b85d1029ba534376d203c3ac83a2e5a4d6876cb6
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Tue May 19 18:54:16 2009 -0400

    tracing: add trace_stack interface
    
    This patch adds the global function
    
      void trace_stack(void)
    
    This allows a developer to find where a function is called. For example,
    if you want to know who calls __netif_reschedule, you can add
    
     static inline void __netif_reschedule(struct Qdisc *q)
     {
     	struct softnet_data *sd;
     	unsigned long flags;
    
    +	trace_stack();
     	local_irq_save(flags);
     	sd = &__get_cpu_var(softnet_data);
     	q->next_sched = sd->output_queue;
    
    And see the following in the trace output:
    
     <= __ftrace_trace_stack
     <= trace_stack
     <= __netif_schedule
     <= dev_watchdog
     <= run_timer_softirq
     <= __do_softirq
     <= call_softirq
     <= do_softirq
     <= irq_exit
    
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 883cd44..347a0f1 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -511,6 +511,7 @@ extern int
 __ftrace_vprintk(unsigned long ip, const char *fmt, va_list ap);
 
 extern void ftrace_dump(void);
+extern void trace_stack(void);
 #else
 static inline void
 ftrace_special(unsigned long arg1, unsigned long arg2, unsigned long arg3) { }
@@ -531,6 +532,7 @@ ftrace_vprintk(const char *fmt, va_list ap)
 	return 0;
 }
 static inline void ftrace_dump(void) { }
+static inline void trace_stack(void) { }
 #endif /* CONFIG_TRACING */
 
 /*
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index dd40d23..33ab502 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1046,6 +1046,21 @@ void __trace_stack(struct trace_array *tr,
 	__ftrace_trace_stack(tr, flags, skip, pc);
 }
 
+/**
+ * trace_stack - dump the stack into the trace buffer
+ *
+ * Use this to record the stack trace into the ring buffer. If you
+ * want to know a caller of a function, place a call to trace_stack
+ * and the ftrace trace file will display who the callers were.
+ */
+void trace_stack(void)
+{
+	unsigned long flags;
+
+	local_save_flags(flags);
+	__trace_stack(&global_trace, flags, 0, preempt_count());
+}
+
 static void ftrace_trace_userstack(struct trace_array *tr,
 				   unsigned long flags, int pc)
 {

