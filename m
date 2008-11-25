Return-Path: <linux-kernel-owner+w=401wt.eu-S1753648AbYKYX5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648AbYKYX5m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 18:57:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751189AbYKYX5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 18:57:34 -0500
Received: from ik-out-1112.google.com ([66.249.90.182]:12056 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbYKYX5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 18:57:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=t8P/QS/3LjuciYKK4QwYrer4ud8kK0/kv53G+ZkGYQrDDflUP36qe0fIzvXLqBBeng
         zixsYlD5SWdZOphkvYaDdGOiAxJ1XXgIOFEbI39s5779G9lAPQDN6p7POip8Y31Fvkab
         Pp3nQ/wTyDRAZlsYQOWM3qZWHblocYKAzwm0o=
Message-ID: <492C90E5.8070907@gmail.com>
Date: Wed, 26 Nov 2008 00:57:25 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing/function-return-tracer: set a more human readable
 output
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: feature

This patch sets a C-like output for the function graph tracing.
For this aim, we now call two handler for each function: one on the entry
and one other on return. This way we can draw a well-ordered call stack.

The pid of the previous trace is loosely stored to be compared against
the one of the current trace to see if there were a context switch.

Without this little feature, the call tree would seem broken at
some locations.
We could use the sched_tracer to capture these sched_events but this
way of processing is much more simpler.

2 spaces have been chosen for indentation to fit the screen while deep
calls. The time of execution in nanosecs is printed just after closed
braces, it seems more easy this way to find the corresponding function.
If the time was printed as a first column, it would be not so easy to
find the corresponding function if it is called on a deep depth.

I plan to output the return value but on 32 bits CPU, the return value
can be 32 or 64, and its difficult to guess on which case we are.
I don't know what would be the better solution on X86-32: only print
eax (low-part) or even edx (high-part).

Actually it's thee same problem when a function return a 8 bits value, the
high part of eax could contain junk values...

Here is an example of trace:

sys_read() {
  fget_light() {
  } 526
  vfs_read() {
    rw_verify_area() {
      security_file_permission() {
        cap_file_permission() {
        } 519
      } 1564
    } 2640
    do_sync_read() {
      pipe_read() {
        __might_sleep() {
        } 511
        pipe_wait() {
          prepare_to_wait() {
          } 760
          deactivate_task() {
            dequeue_task() {
              dequeue_task_fair() {
                dequeue_entity() {
                  update_curr() {
                    update_min_vruntime() {
                    } 504
                  } 1587
                  clear_buddies() {
                  } 512
                  add_cfs_task_weight() {
                  } 519
                  update_min_vruntime() {
                  } 511
                } 5602
                dequeue_entity() {
                  update_curr() {
                    update_min_vruntime() {
                    } 496
                  } 1631
                  clear_buddies() {
                  } 496
                  update_min_vruntime() {
                  } 527
                } 4580
                hrtick_update() {
                  hrtick_start_fair() {
                  } 488
                } 1489
              } 13700
            } 14949
          } 16016
          msecs_to_jiffies() {
          } 496
          put_prev_task_fair() {
          } 504
          pick_next_task_fair() {
          } 489
          pick_next_task_rt() {
          } 496
          pick_next_task_fair() {
          } 489
          pick_next_task_idle() {
          } 489

------------8<---------- thread 4 ------------8<----------

finish_task_switch() {
} 1203
do_softirq() {
  __do_softirq() {
    __local_bh_disable() {
    } 669
    rcu_process_callbacks() {
      __rcu_process_callbacks() {
        cpu_quiet() {
          rcu_start_batch() {
          } 503
        } 1647
      } 3128
      __rcu_process_callbacks() {
      } 542
    } 5362
    _local_bh_enable() {
    } 587
  } 8880
} 9986
kthread_should_stop() {
} 669
deactivate_task() {
  dequeue_task() {
    dequeue_task_fair() {
      dequeue_entity() {
        update_curr() {
          calc_delta_mine() {
          } 511
          update_min_vruntime() {
          } 511
        } 2813

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/kernel/ftrace.c              |   32 +++++++----
 include/linux/ftrace.h                |   25 ++++++--
 kernel/trace/ftrace.c                 |   30 +++++-----
 kernel/trace/trace.c                  |   67 +++++++++++++++++----
 kernel/trace/trace.h                  |   28 +++++----
 kernel/trace/trace_functions_graph.c  |  104 +++++++++++++++++++++++++--------
 kernel/trace/trace_functions_return.c |   98 -------------------------------
 7 files changed, 208 insertions(+), 176 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 3595a4c..26b2d92 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -347,7 +347,7 @@ void ftrace_nmi_exit(void)
 
 /* Add a function return address to the trace stack on thread info.*/
 static int push_return_trace(unsigned long ret, unsigned long long time,
-				unsigned long func)
+				unsigned long func, int *depth)
 {
 	int index;
 
@@ -365,21 +365,22 @@ static int push_return_trace(unsigned long ret, unsigned long long time,
 	current->ret_stack[index].ret = ret;
 	current->ret_stack[index].func = func;
 	current->ret_stack[index].calltime = time;
+	*depth = index;
 
 	return 0;
 }
 
 /* Retrieve a function return address to the trace stack on thread info.*/
-static void pop_return_trace(unsigned long *ret, unsigned long long *time,
-				unsigned long *func, unsigned long *overrun)
+static void pop_return_trace(struct ftrace_graph_ret *trace, unsigned long *ret)
 {
 	int index;
 
 	index = current->curr_ret_stack;
 	*ret = current->ret_stack[index].ret;
-	*func = current->ret_stack[index].func;
-	*time = current->ret_stack[index].calltime;
-	*overrun = atomic_read(&current->trace_overrun);
+	trace->func = current->ret_stack[index].func;
+	trace->calltime = current->ret_stack[index].calltime;
+	trace->overrun = atomic_read(&current->trace_overrun);
+	trace->depth = index;
 	current->curr_ret_stack--;
 }
 
@@ -390,12 +391,13 @@ static void pop_return_trace(unsigned long *ret, unsigned long long *time,
 unsigned long ftrace_return_to_handler(void)
 {
 	struct ftrace_graph_ret trace;
-	pop_return_trace(&trace.ret, &trace.calltime, &trace.func,
-			&trace.overrun);
+	unsigned long ret;
+
+	pop_return_trace(&trace, &ret);
 	trace.rettime = cpu_clock(raw_smp_processor_id());
-	ftrace_graph_function(&trace);
+	ftrace_graph_return(&trace);
 
-	return trace.ret;
+	return ret;
 }
 
 /*
@@ -407,6 +409,7 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
 	unsigned long old;
 	unsigned long long calltime;
 	int faulted;
+	struct ftrace_graph_ent trace;
 	unsigned long return_hooker = (unsigned long)
 				&return_to_handler;
 
@@ -452,8 +455,15 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
 
 	calltime = cpu_clock(raw_smp_processor_id());
 
-	if (push_return_trace(old, calltime, self_addr) == -EBUSY)
+	if (push_return_trace(old, calltime,
+				self_addr, &trace.depth) == -EBUSY) {
 		*parent = old;
+		return;
+	}
+
+	trace.func = self_addr;
+	ftrace_graph_entry(&trace);
+
 }
 
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index b4ac734..fc2d549 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -313,26 +313,39 @@ ftrace_init_module(struct module *mod,
 
 
 /*
+ * Structure that defines an entry function trace.
+ */
+struct ftrace_graph_ent {
+	unsigned long func; /* Current function */
+	int depth;
+};
+
+/*
  * Structure that defines a return function trace.
  */
 struct ftrace_graph_ret {
-	unsigned long ret; /* Return address */
 	unsigned long func; /* Current function */
 	unsigned long long calltime;
 	unsigned long long rettime;
 	/* Number of functions that overran the depth limit for current task */
 	unsigned long overrun;
+	int depth;
 };
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 #define FTRACE_RETFUNC_DEPTH 50
 #define FTRACE_RETSTACK_ALLOC_SIZE 32
-/* Type of a callback handler of tracing return function */
-typedef void (*trace_function_graph_t)(struct ftrace_graph_ret *);
+/* Type of the callback handlers for tracing function graph*/
+typedef void (*trace_func_graph_ret_t)(struct ftrace_graph_ret *); /* return */
+typedef void (*trace_func_graph_ent_t)(struct ftrace_graph_ent *); /* entry */
+
+extern int register_ftrace_graph(trace_func_graph_ret_t retfunc,
+				trace_func_graph_ent_t entryfunc);
+
+/* The current handlers in use */
+extern trace_func_graph_ret_t ftrace_graph_return;
+extern trace_func_graph_ent_t ftrace_graph_entry;
 
-extern int register_ftrace_graph(trace_function_graph_t func);
-/* The current handler in use */
-extern trace_function_graph_t ftrace_graph_function;
 extern void unregister_ftrace_graph(void);
 
 extern void ftrace_graph_init_task(struct task_struct *t);
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 9e19976..7e2d3b9 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1498,12 +1498,13 @@ ftrace_enable_sysctl(struct ctl_table *table, int write,
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 
-static atomic_t ftrace_retfunc_active;
-
-/* The callback that hooks the return of a function */
-trace_function_graph_t ftrace_graph_function =
-			(trace_function_graph_t)ftrace_stub;
+static atomic_t ftrace_graph_active;
 
+/* The callbacks that hook a function */
+trace_func_graph_ret_t ftrace_graph_return =
+			(trace_func_graph_ret_t)ftrace_stub;
+trace_func_graph_ent_t ftrace_graph_entry =
+			(trace_func_graph_ent_t)ftrace_stub;
 
 /* Try to assign a return stack array on FTRACE_RETSTACK_ALLOC_SIZE tasks. */
 static int alloc_retstack_tasklist(struct ftrace_ret_stack **ret_stack_list)
@@ -1569,7 +1570,8 @@ static int start_graph_tracing(void)
 	return ret;
 }
 
-int register_ftrace_graph(trace_function_graph_t func)
+int register_ftrace_graph(trace_func_graph_ret_t retfunc,
+			trace_func_graph_ent_t entryfunc)
 {
 	int ret = 0;
 
@@ -1583,14 +1585,15 @@ int register_ftrace_graph(trace_function_graph_t func)
 		ret = -EBUSY;
 		goto out;
 	}
-	atomic_inc(&ftrace_retfunc_active);
+	atomic_inc(&ftrace_graph_active);
 	ret = start_graph_tracing();
 	if (ret) {
-		atomic_dec(&ftrace_retfunc_active);
+		atomic_dec(&ftrace_graph_active);
 		goto out;
 	}
 	ftrace_tracing_type = FTRACE_TYPE_RETURN;
-	ftrace_graph_function = func;
+	ftrace_graph_return = retfunc;
+	ftrace_graph_entry = entryfunc;
 	ftrace_startup();
 
 out:
@@ -1602,8 +1605,9 @@ void unregister_ftrace_graph(void)
 {
 	mutex_lock(&ftrace_sysctl_lock);
 
-	atomic_dec(&ftrace_retfunc_active);
-	ftrace_graph_function = (trace_function_graph_t)ftrace_stub;
+	atomic_dec(&ftrace_graph_active);
+	ftrace_graph_return = (trace_func_graph_ret_t)ftrace_stub;
+	ftrace_graph_entry = (trace_func_graph_ent_t)ftrace_stub;
 	ftrace_shutdown();
 	/* Restore normal tracing type */
 	ftrace_tracing_type = FTRACE_TYPE_ENTER;
@@ -1614,7 +1618,7 @@ void unregister_ftrace_graph(void)
 /* Allocate a return stack for newly created task */
 void ftrace_graph_init_task(struct task_struct *t)
 {
-	if (atomic_read(&ftrace_retfunc_active)) {
+	if (atomic_read(&ftrace_graph_active)) {
 		t->ret_stack = kmalloc(FTRACE_RETFUNC_DEPTH
 				* sizeof(struct ftrace_ret_stack),
 				GFP_KERNEL);
@@ -1638,5 +1642,3 @@ void ftrace_graph_exit_task(struct task_struct *t)
 }
 #endif
 
-
-
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index f21ab2c..9d5f7c9 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -879,14 +879,38 @@ trace_function(struct trace_array *tr, struct trace_array_cpu *data,
 }
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
-static void __trace_function_graph(struct trace_array *tr,
+static void __trace_graph_entry(struct trace_array *tr,
+				struct trace_array_cpu *data,
+				struct ftrace_graph_ent *trace,
+				unsigned long flags,
+				int pc)
+{
+	struct ring_buffer_event *event;
+	struct ftrace_graph_ent_entry *entry;
+	unsigned long irq_flags;
+
+	if (unlikely(local_read(&__get_cpu_var(ftrace_cpu_disabled))))
+		return;
+
+	event = ring_buffer_lock_reserve(global_trace.buffer, sizeof(*entry),
+					 &irq_flags);
+	if (!event)
+		return;
+	entry	= ring_buffer_event_data(event);
+	tracing_generic_entry_update(&entry->ent, flags, pc);
+	entry->ent.type			= TRACE_GRAPH_ENT;
+	entry->graph_ent			= *trace;
+	ring_buffer_unlock_commit(global_trace.buffer, event, irq_flags);
+}
+
+static void __trace_graph_return(struct trace_array *tr,
 				struct trace_array_cpu *data,
 				struct ftrace_graph_ret *trace,
 				unsigned long flags,
 				int pc)
 {
 	struct ring_buffer_event *event;
-	struct ftrace_graph_entry *entry;
+	struct ftrace_graph_ret_entry *entry;
 	unsigned long irq_flags;
 
 	if (unlikely(local_read(&__get_cpu_var(ftrace_cpu_disabled))))
@@ -898,12 +922,8 @@ static void __trace_function_graph(struct trace_array *tr,
 		return;
 	entry	= ring_buffer_event_data(event);
 	tracing_generic_entry_update(&entry->ent, flags, pc);
-	entry->ent.type			= TRACE_FN_RET;
-	entry->ip			= trace->func;
-	entry->parent_ip	= trace->ret;
-	entry->rettime		= trace->rettime;
-	entry->calltime		= trace->calltime;
-	entry->overrun		= trace->overrun;
+	entry->ent.type			= TRACE_GRAPH_RET;
+	entry->ret				= *trace;
 	ring_buffer_unlock_commit(global_trace.buffer, event, irq_flags);
 }
 #endif
@@ -1178,7 +1198,7 @@ function_trace_call(unsigned long ip, unsigned long parent_ip)
 }
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
-void trace_function_graph(struct ftrace_graph_ret *trace)
+void trace_graph_entry(struct ftrace_graph_ent *trace)
 {
 	struct trace_array *tr = &global_trace;
 	struct trace_array_cpu *data;
@@ -1193,7 +1213,28 @@ void trace_function_graph(struct ftrace_graph_ret *trace)
 	disabled = atomic_inc_return(&data->disabled);
 	if (likely(disabled == 1)) {
 		pc = preempt_count();
-		__trace_function_graph(tr, data, trace, flags, pc);
+		__trace_graph_entry(tr, data, trace, flags, pc);
+	}
+	atomic_dec(&data->disabled);
+	raw_local_irq_restore(flags);
+}
+
+void trace_graph_return(struct ftrace_graph_ret *trace)
+{
+	struct trace_array *tr = &global_trace;
+	struct trace_array_cpu *data;
+	unsigned long flags;
+	long disabled;
+	int cpu;
+	int pc;
+
+	raw_local_irq_save(flags);
+	cpu = raw_smp_processor_id();
+	data = tr->data[cpu];
+	disabled = atomic_inc_return(&data->disabled);
+	if (likely(disabled == 1)) {
+		pc = preempt_count();
+		__trace_graph_return(tr, data, trace, flags, pc);
 	}
 	atomic_dec(&data->disabled);
 	raw_local_irq_restore(flags);
@@ -2000,9 +2041,11 @@ static enum print_line_t print_trace_fmt(struct trace_iterator *iter)
 			trace_seq_print_cont(s, iter);
 		break;
 	}
-	case TRACE_FN_RET: {
+	case TRACE_GRAPH_RET: {
+		return print_graph_function(iter);
+	}
+	case TRACE_GRAPH_ENT: {
 		return print_graph_function(iter);
-		break;
 	}
 	case TRACE_BRANCH: {
 		struct trace_branch *field;
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 72b5ef8..ffe1bb1 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -25,7 +25,8 @@ enum trace_type {
 	TRACE_BRANCH,
 	TRACE_BOOT_CALL,
 	TRACE_BOOT_RET,
-	TRACE_FN_RET,
+	TRACE_GRAPH_RET,
+	TRACE_GRAPH_ENT,
 	TRACE_USER_STACK,
 	TRACE_BTS,
 
@@ -56,14 +57,16 @@ struct ftrace_entry {
 	unsigned long		parent_ip;
 };
 
+/* Function call entry */
+struct ftrace_graph_ent_entry {
+	struct trace_entry			ent;
+	struct ftrace_graph_ent		graph_ent;
+};
+
 /* Function return entry */
-struct ftrace_graph_entry {
-	struct trace_entry	ent;
-	unsigned long		ip;
-	unsigned long		parent_ip;
-	unsigned long long	calltime;
-	unsigned long long	rettime;
-	unsigned long		overrun;
+struct ftrace_graph_ret_entry {
+	struct trace_entry			ent;
+	struct ftrace_graph_ret		ret;
 };
 extern struct tracer boot_tracer;
 
@@ -264,7 +267,10 @@ extern void __ftrace_bad_type(void);
 		IF_ASSIGN(var, ent, struct trace_boot_call, TRACE_BOOT_CALL);\
 		IF_ASSIGN(var, ent, struct trace_boot_ret, TRACE_BOOT_RET);\
 		IF_ASSIGN(var, ent, struct trace_branch, TRACE_BRANCH); \
-		IF_ASSIGN(var, ent, struct ftrace_graph_entry, TRACE_FN_RET);\
+		IF_ASSIGN(var, ent, struct ftrace_graph_ent_entry,	\
+			  TRACE_GRAPH_ENT);		\
+		IF_ASSIGN(var, ent, struct ftrace_graph_ret_entry,	\
+			  TRACE_GRAPH_RET);		\
 		IF_ASSIGN(var, ent, struct bts_entry, TRACE_BTS);\
 		__ftrace_bad_type();					\
 	} while (0)
@@ -397,9 +403,9 @@ void trace_function(struct trace_array *tr,
 		    unsigned long ip,
 		    unsigned long parent_ip,
 		    unsigned long flags, int pc);
-void
-trace_function_graph(struct ftrace_graph_ret *trace);
 
+void trace_graph_return(struct ftrace_graph_ret *trace);
+void trace_graph_entry(struct ftrace_graph_ent *trace);
 void trace_bts(struct trace_array *tr,
 	       unsigned long from,
 	       unsigned long to);
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index f5bad46..b6f0cc2 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -13,6 +13,7 @@
 
 #include "trace.h"
 
+#define TRACE_GRAPH_INDENT	2
 
 #define TRACE_GRAPH_PRINT_OVERRUN	0x1
 static struct tracer_opt trace_opts[] = {
@@ -26,6 +27,8 @@ static struct tracer_flags tracer_flags = {
 	.opts = trace_opts
 };
 
+/* pid on the last trace processed */
+static pid_t last_pid = -1;
 
 static int graph_trace_init(struct trace_array *tr)
 {
@@ -33,7 +36,8 @@ static int graph_trace_init(struct trace_array *tr)
 	for_each_online_cpu(cpu)
 		tracing_reset(tr, cpu);
 
-	return register_ftrace_graph(&trace_function_graph);
+	return register_ftrace_graph(&trace_graph_return,
+					&trace_graph_entry);
 }
 
 static void graph_trace_reset(struct trace_array *tr)
@@ -41,45 +45,97 @@ static void graph_trace_reset(struct trace_array *tr)
 		unregister_ftrace_graph();
 }
 
+/* If the pid changed since the last trace, output this event */
+static int verif_pid(struct trace_seq *s, pid_t pid)
+{
+	if (last_pid != -1 && last_pid == pid)
+		return 1;
 
-enum print_line_t
-print_graph_function(struct trace_iterator *iter)
+	last_pid = pid;
+	return trace_seq_printf(s, "\n------------8<---------- thread %d"
+				    " ------------8<----------\n\n",
+				  pid);
+}
+
+static enum print_line_t
+print_graph_entry(struct ftrace_graph_ent *call, struct trace_seq *s,
+		struct trace_entry *ent)
 {
-	struct trace_seq *s = &iter->seq;
-	struct trace_entry *entry = iter->ent;
-	struct ftrace_graph_entry *field;
+	int i;
 	int ret;
 
-	if (entry->type == TRACE_FN_RET) {
-		trace_assign_type(field, entry);
-		ret = trace_seq_printf(s, "%pF -> ", (void *)field->parent_ip);
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
+	if (!verif_pid(s, ent->pid))
+		return TRACE_TYPE_PARTIAL_LINE;
 
-		ret = seq_print_ip_sym(s, field->ip,
-					trace_flags & TRACE_ITER_SYM_MASK);
+	for (i = 0; i < call->depth * TRACE_GRAPH_INDENT; i++) {
+		ret = trace_seq_printf(s, " ");
 		if (!ret)
 			return TRACE_TYPE_PARTIAL_LINE;
+	}
+
+	ret = seq_print_ip_sym(s, call->func, 0);
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	ret = trace_seq_printf(s, "() {\n");
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+	return TRACE_TYPE_HANDLED;
+}
+
+static enum print_line_t
+print_graph_return(struct ftrace_graph_ret *trace, struct trace_seq *s,
+		   struct trace_entry *ent)
+{
+	int i;
+	int ret;
+
+	if (!verif_pid(s, ent->pid))
+		return TRACE_TYPE_PARTIAL_LINE;
 
-		ret = trace_seq_printf(s, " (%llu ns)",
-					field->rettime - field->calltime);
+	for (i = 0; i < trace->depth * TRACE_GRAPH_INDENT; i++) {
+		ret = trace_seq_printf(s, " ");
 		if (!ret)
 			return TRACE_TYPE_PARTIAL_LINE;
+	}
+
+	ret = trace_seq_printf(s, "} ");
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
 
-		if (tracer_flags.val & TRACE_GRAPH_PRINT_OVERRUN) {
-			ret = trace_seq_printf(s, " (Overruns: %lu)",
-						field->overrun);
-			if (!ret)
-				return TRACE_TYPE_PARTIAL_LINE;
-		}
+	ret = trace_seq_printf(s, "%llu\n", trace->rettime - trace->calltime);
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
 
-		ret = trace_seq_printf(s, "\n");
+	if (tracer_flags.val & TRACE_GRAPH_PRINT_OVERRUN) {
+		ret = trace_seq_printf(s, " (Overruns: %lu)\n",
+					trace->overrun);
 		if (!ret)
 			return TRACE_TYPE_PARTIAL_LINE;
+	}
+	return TRACE_TYPE_HANDLED;
+}
+
+enum print_line_t
+print_graph_function(struct trace_iterator *iter)
+{
+	struct trace_seq *s = &iter->seq;
+	struct trace_entry *entry = iter->ent;
 
-		return TRACE_TYPE_HANDLED;
+	switch (entry->type) {
+	case TRACE_GRAPH_ENT: {
+		struct ftrace_graph_ent_entry *field;
+		trace_assign_type(field, entry);
+		return print_graph_entry(&field->graph_ent, s, entry);
+	}
+	case TRACE_GRAPH_RET: {
+		struct ftrace_graph_ret_entry *field;
+		trace_assign_type(field, entry);
+		return print_graph_return(&field->ret, s, entry);
+	}
+	default:
+		return TRACE_TYPE_UNHANDLED;
 	}
-	return TRACE_TYPE_UNHANDLED;
 }
 
 static struct tracer graph_trace __read_mostly = {
diff --git a/kernel/trace/trace_functions_return.c b/kernel/trace/trace_functions_return.c
deleted file mode 100644
index e00d645..0000000
--- a/kernel/trace/trace_functions_return.c
+++ /dev/null
@@ -1,98 +0,0 @@
-/*
- *
- * Function return tracer.
- * Copyright (c) 2008 Frederic Weisbecker <fweisbec@gmail.com>
- * Mostly borrowed from function tracer which
- * is Copyright (c) Steven Rostedt <srostedt@redhat.com>
- *
- */
-#include <linux/debugfs.h>
-#include <linux/uaccess.h>
-#include <linux/ftrace.h>
-#include <linux/fs.h>
-
-#include "trace.h"
-
-
-#define TRACE_RETURN_PRINT_OVERRUN	0x1
-static struct tracer_opt trace_opts[] = {
-	/* Display overruns or not */
-	{ TRACER_OPT(overrun, TRACE_RETURN_PRINT_OVERRUN) },
-	{ } /* Empty entry */
-};
-
-static struct tracer_flags tracer_flags = {
-	.val = 0, /* Don't display overruns by default */
-	.opts = trace_opts
-};
-
-
-static int return_trace_init(struct trace_array *tr)
-{
-	int cpu;
-	for_each_online_cpu(cpu)
-		tracing_reset(tr, cpu);
-
-	return register_ftrace_return(&trace_function_return);
-}
-
-static void return_trace_reset(struct trace_array *tr)
-{
-		unregister_ftrace_return();
-}
-
-
-enum print_line_t
-print_return_function(struct trace_iterator *iter)
-{
-	struct trace_seq *s = &iter->seq;
-	struct trace_entry *entry = iter->ent;
-	struct ftrace_ret_entry *field;
-	int ret;
-
-	if (entry->type == TRACE_FN_RET) {
-		trace_assign_type(field, entry);
-		ret = trace_seq_printf(s, "%pF -> ", (void *)field->parent_ip);
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
-
-		ret = seq_print_ip_sym(s, field->ip,
-					trace_flags & TRACE_ITER_SYM_MASK);
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
-
-		ret = trace_seq_printf(s, " (%llu ns)",
-					field->rettime - field->calltime);
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
-
-		if (tracer_flags.val & TRACE_RETURN_PRINT_OVERRUN) {
-			ret = trace_seq_printf(s, " (Overruns: %lu)",
-						field->overrun);
-			if (!ret)
-				return TRACE_TYPE_PARTIAL_LINE;
-		}
-
-		ret = trace_seq_printf(s, "\n");
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
-
-		return TRACE_TYPE_HANDLED;
-	}
-	return TRACE_TYPE_UNHANDLED;
-}
-
-static struct tracer return_trace __read_mostly = {
-	.name	     = "return",
-	.init	     = return_trace_init,
-	.reset	     = return_trace_reset,
-	.print_line = print_return_function,
-	.flags		= &tracer_flags,
-};
-
-static __init int init_return_trace(void)
-{
-	return register_tracer(&return_trace);
-}
-
-device_initcall(init_return_trace);
-- 
1.5.2.5
