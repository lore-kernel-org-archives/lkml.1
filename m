Return-Path: <linux-kernel-owner+w=401wt.eu-S1756961AbYKQCXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756961AbYKQCXe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 21:23:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755594AbYKQCWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 21:22:49 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:33660 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756774AbYKQCWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 21:22:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=kbvWsFsrXbzEMPBnfjZC9n3U4UBSjCgsxgnFUOmqQDF1BsS5Nbn5jZFllwnWOW58uS
         KaM594a8t/5GIAABno0y88tJqe4sJIrpYEOg2Ezbw7mORS9sXHAgrtkv5Pqgn/kAtGrr
         MAOpi6tZ4BIhuKh/dqW37wJxnjLCyDYSlyRac=
Message-ID: <4920D571.4050007@gmail.com>
Date: Mon, 17 Nov 2008 03:22:41 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] tracing/function-return-tracer: add the overrun field
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: help to find the better depth of trace

We decided to arbitrary define the depth of function return trace as "20".
Perhaps this is not enough. To help finding an optimal depth, we measure now
the overrun: the number of functions that have been missed for the current thread.
By default this is not displayed, we have to do set a particular flag on the return
tracer: echo overrun > /debug/tracing/trace_options
And the overrun will be printed on the right.

As the trace shows below, the current 20 depth is not enough.

update_wall_time+0x37f/0x8c0 -> update_xtime_cache (345 ns) (Overruns: 2838)
update_wall_time+0x384/0x8c0 -> clocksource_get_next (1141 ns) (Overruns: 2838)
do_timer+0x23/0x100 -> update_wall_time (3882 ns) (Overruns: 2838)
tick_do_update_jiffies64+0xbf/0x160 -> do_timer (5339 ns) (Overruns: 2838)
tick_sched_timer+0x6a/0xf0 -> tick_do_update_jiffies64 (7209 ns) (Overruns: 2838)
vgacon_set_cursor_size+0x98/0x120 -> native_io_delay (2613 ns) (Overruns: 274)
vgacon_cursor+0x16e/0x1d0 -> vgacon_set_cursor_size (33151 ns) (Overruns: 274)
set_cursor+0x5f/0x80 -> vgacon_cursor (36432 ns) (Overruns: 274)
con_flush_chars+0x34/0x40 -> set_cursor (38790 ns) (Overruns: 274)
release_console_sem+0x1ec/0x230 -> up (721 ns) (Overruns: 274)
release_console_sem+0x225/0x230 -> wake_up_klogd (316 ns) (Overruns: 274)
con_flush_chars+0x39/0x40 -> release_console_sem (2996 ns) (Overruns: 274)
con_write+0x22/0x30 -> con_flush_chars (46067 ns) (Overruns: 274)
n_tty_write+0x1cc/0x360 -> con_write (292670 ns) (Overruns: 274)
smp_apic_timer_interrupt+0x2a/0x90 -> native_apic_mem_write (330 ns) (Overruns: 274)
irq_enter+0x17/0x70 -> idle_cpu (413 ns) (Overruns: 274)
smp_apic_timer_interrupt+0x2f/0x90 -> irq_enter (1525 ns) (Overruns: 274)
ktime_get_ts+0x40/0x70 -> getnstimeofday (465 ns) (Overruns: 274)
ktime_get_ts+0x60/0x70 -> set_normalized_timespec (436 ns) (Overruns: 274)
ktime_get+0x16/0x30 -> ktime_get_ts (2501 ns) (Overruns: 274)
hrtimer_interrupt+0x77/0x1a0 -> ktime_get (3439 ns) (Overruns: 274)

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/include/asm/thread_info.h    |    7 ++++++
 arch/x86/kernel/ftrace.c              |   10 ++++++--
 include/linux/ftrace.h                |    2 +
 include/linux/sched.h                 |    1 +
 kernel/trace/trace.c                  |    1 +
 kernel/trace/trace.h                  |    1 +
 kernel/trace/trace_functions_return.c |   38 +++++++++++++++++++++++++++-----
 7 files changed, 51 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index a711583..e90e81e 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -21,6 +21,7 @@ struct task_struct;
 struct exec_domain;
 #include <asm/processor.h>
 #include <asm/ftrace.h>
+#include <asm/atomic.h>
 
 struct thread_info {
 	struct task_struct	*task;		/* main task structure */
@@ -45,6 +46,11 @@ struct thread_info {
 	int		curr_ret_stack;
 	/* Stack of return addresses for return function tracing */
 	struct ftrace_ret_stack	ret_stack[FTRACE_RET_STACK_SIZE];
+	/*
+	 * Number of functions that haven't been traced
+	 * because of depth overrun.
+	 */
+	atomic_t	trace_overrun;
 #endif
 };
 
@@ -61,6 +67,7 @@ struct thread_info {
 		.fn = do_no_restart_syscall,	\
 	},					\
 	.curr_ret_stack = -1,\
+	.trace_overrun	= ATOMIC_INIT(0)	\
 }
 #else
 #define INIT_THREAD_INFO(tsk)			\
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 924153e..356bb1e 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -353,8 +353,10 @@ static int push_return_trace(unsigned long ret, unsigned long long time,
 	struct thread_info *ti = current_thread_info();
 
 	/* The return trace stack is full */
-	if (ti->curr_ret_stack == FTRACE_RET_STACK_SIZE - 1)
+	if (ti->curr_ret_stack == FTRACE_RET_STACK_SIZE - 1) {
+		atomic_inc(&ti->trace_overrun);
 		return -EBUSY;
+	}
 
 	index = ++ti->curr_ret_stack;
 	barrier();
@@ -367,7 +369,7 @@ static int push_return_trace(unsigned long ret, unsigned long long time,
 
 /* Retrieve a function return address to the trace stack on thread info.*/
 static void pop_return_trace(unsigned long *ret, unsigned long long *time,
-				unsigned long *func)
+				unsigned long *func, unsigned long *overrun)
 {
 	int index;
 
@@ -376,6 +378,7 @@ static void pop_return_trace(unsigned long *ret, unsigned long long *time,
 	*ret = ti->ret_stack[index].ret;
 	*func = ti->ret_stack[index].func;
 	*time = ti->ret_stack[index].calltime;
+	*overrun = atomic_read(&ti->trace_overrun);
 	ti->curr_ret_stack--;
 }
 
@@ -386,7 +389,8 @@ static void pop_return_trace(unsigned long *ret, unsigned long long *time,
 unsigned long ftrace_return_to_handler(void)
 {
 	struct ftrace_retfunc trace;
-	pop_return_trace(&trace.ret, &trace.calltime, &trace.func);
+	pop_return_trace(&trace.ret, &trace.calltime, &trace.func,
+			&trace.overrun);
 	trace.rettime = cpu_clock(raw_smp_processor_id());
 	ftrace_function_return(&trace);
 
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index f1af1aa..f7ba4ea 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -318,6 +318,8 @@ struct ftrace_retfunc {
 	unsigned long func; /* Current function */
 	unsigned long long calltime;
 	unsigned long long rettime;
+	/* Number of functions that overran the depth limit for current task */
+	unsigned long overrun;
 };
 
 #ifdef CONFIG_FUNCTION_RET_TRACER
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 979da3c..deba0ed 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2013,6 +2013,7 @@ static inline void setup_thread_stack(struct task_struct *p, struct task_struct
 	 * used.
 	 */
 	task_thread_info(p)->curr_ret_stack = -1;
+	atomic_set(&task_thread_info(p)->trace_overrun, 0);
 #endif
 }
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 8c4eb80..c13e4ec 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -833,6 +833,7 @@ static void __trace_function_return(struct trace_array *tr,
 	entry->parent_ip	= trace->ret;
 	entry->rettime		= trace->rettime;
 	entry->calltime		= trace->calltime;
+	entry->overrun		= trace->overrun;
 	ring_buffer_unlock_commit(global_trace.buffer, event, irq_flags);
 }
 #endif
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index fc06485..0eb20f1 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -60,6 +60,7 @@ struct ftrace_ret_entry {
 	unsigned long		parent_ip;
 	unsigned long long	calltime;
 	unsigned long long	rettime;
+	unsigned long		overrun;
 };
 extern struct tracer boot_tracer;
 
diff --git a/kernel/trace/trace_functions_return.c b/kernel/trace/trace_functions_return.c
index a68564a..e00d645 100644
--- a/kernel/trace/trace_functions_return.c
+++ b/kernel/trace/trace_functions_return.c
@@ -14,6 +14,19 @@
 #include "trace.h"
 
 
+#define TRACE_RETURN_PRINT_OVERRUN	0x1
+static struct tracer_opt trace_opts[] = {
+	/* Display overruns or not */
+	{ TRACER_OPT(overrun, TRACE_RETURN_PRINT_OVERRUN) },
+	{ } /* Empty entry */
+};
+
+static struct tracer_flags tracer_flags = {
+	.val = 0, /* Don't display overruns by default */
+	.opts = trace_opts
+};
+
+
 static int return_trace_init(struct trace_array *tr)
 {
 	int cpu;
@@ -42,26 +55,39 @@ print_return_function(struct trace_iterator *iter)
 		ret = trace_seq_printf(s, "%pF -> ", (void *)field->parent_ip);
 		if (!ret)
 			return TRACE_TYPE_PARTIAL_LINE;
+
 		ret = seq_print_ip_sym(s, field->ip,
 					trace_flags & TRACE_ITER_SYM_MASK);
 		if (!ret)
 			return TRACE_TYPE_PARTIAL_LINE;
-		ret = trace_seq_printf(s, " (%llu ns)\n",
+
+		ret = trace_seq_printf(s, " (%llu ns)",
 					field->rettime - field->calltime);
 		if (!ret)
 			return TRACE_TYPE_PARTIAL_LINE;
-		else
-			return TRACE_TYPE_HANDLED;
+
+		if (tracer_flags.val & TRACE_RETURN_PRINT_OVERRUN) {
+			ret = trace_seq_printf(s, " (Overruns: %lu)",
+						field->overrun);
+			if (!ret)
+				return TRACE_TYPE_PARTIAL_LINE;
+		}
+
+		ret = trace_seq_printf(s, "\n");
+		if (!ret)
+			return TRACE_TYPE_PARTIAL_LINE;
+
+		return TRACE_TYPE_HANDLED;
 	}
 	return TRACE_TYPE_UNHANDLED;
 }
 
-static struct tracer return_trace __read_mostly =
-{
+static struct tracer return_trace __read_mostly = {
 	.name	     = "return",
 	.init	     = return_trace_init,
 	.reset	     = return_trace_reset,
-	.print_line = print_return_function
+	.print_line = print_return_function,
+	.flags		= &tracer_flags,
 };
 
 static __init int init_return_trace(void)
-- 
1.5.2.5
