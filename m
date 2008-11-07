Return-Path: <linux-kernel-owner+w=401wt.eu-S1751142AbYKGS6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751142AbYKGS6w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 13:58:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754819AbYKGS6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 13:58:40 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:54647 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755083AbYKGS6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 13:58:38 -0500
Date: Fri, 7 Nov 2008 13:58:32 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC v2][PATCH 2/2] Add a tracer to catch execution time of
 kernel functions
In-Reply-To: <49148214.4030607@gmail.com>
Message-ID: <alpine.DEB.1.10.0811071348310.3711@gandalf.stny.rr.com>
References: <49148214.4030607@gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 7 Nov 2008, Frederic Weisbecker wrote:

> This tracer uses the low level function return ftrace plugin to measure
> the execution time of the kernel functions.
> 
> The first field is the caller of the function, the second is the measured function, and the last
> one is the execution time in nanoseconds.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> ---
> diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> index fc4febc..f27b46b 100644
> --- a/kernel/trace/Kconfig
> +++ b/kernel/trace/Kconfig
> @@ -54,6 +54,19 @@ config FUNCTION_TRACER
>  	  (the bootup default), then the overhead of the instructions is very
>  	  small and not measurable even in micro-benchmarks.
>  
> +config FTRACE_RETURN
> +	bool "Kernel Function return Tracer"
> +	depends on !DYNAMIC_FTRACE

Why not the DYNAMIC_FTRACE?

You might want to add a HAVE_FTRACE_RETURN and just depend on that as well 
as DEBUG_KERNEL.


> +	depends on X86
> +	depends on DEBUG_KERNEL
> +	select FRAME_POINTER
> +	select TRACING
> +	help
> +	  Enable the kernel to trace a function at its return.
> +	  It's first purpose is to trace the duration of functions.
> +	  It is totally unstable and ugly at this time and only supports
> +	  one function call at a time.
> +
>  config IRQSOFF_TRACER
>  	bool "Interrupts-off Latency Tracer"
>  	default n
> diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
> index c8228b1..5cfacd5 100644
> --- a/kernel/trace/Makefile
> +++ b/kernel/trace/Makefile
> @@ -24,5 +24,6 @@ obj-$(CONFIG_NOP_TRACER) += trace_nop.o
>  obj-$(CONFIG_STACK_TRACER) += trace_stack.o
>  obj-$(CONFIG_MMIOTRACE) += trace_mmiotrace.o
>  obj-$(CONFIG_BOOT_TRACER) += trace_boot.o
> +obj-$(CONFIG_FTRACE_RETURN) += trace_functions_return.o
>  
>  libftrace-y := ftrace.o
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 896c71f..d11e4a2 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -1481,3 +1481,18 @@ ftrace_enable_sysctl(struct ctl_table *table, int write,
>  	return ret;
>  }
>  
> +#ifdef CONFIG_FTRACE_RETURN
> +void (*ftrace_function_return)(struct ftrace_retfunc *) = ftrace_return_stub;
> +void register_ftrace_return(void (*func)(struct ftrace_retfunc *))
> +{
> +	ftrace_function_return = func;

Might be cool to allow multiple functions like ftrace does. But we can do
that after we get the kinks out of the code you already have ;-)

> +}
> +
> +void unregister_ftrace_return(void)
> +{
> +	ftrace_function_return = ftrace_return_stub;

Again, I think just using ftrace_stub should be fine.


> +}
> +#endif
> +
> +
> +
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index d55ccfc..6e7f2bb 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -244,13 +244,6 @@ unsigned long nsecs_to_usecs(unsigned long nsecs)
>  	return nsecs / 1000;
>  }
>  
> -/*
> - * TRACE_ITER_SYM_MASK masks the options in trace_flags that
> - * control the output of kernel symbols.
> - */
> -#define TRACE_ITER_SYM_MASK \
> -	(TRACE_ITER_PRINT_PARENT|TRACE_ITER_SYM_OFFSET|TRACE_ITER_SYM_ADDR)

Not sure why you moved TRACE_ITER_SYM_MASK. I like it here because it is
right next to the trace_options flags.

> -
>  /* These must match the bit postions in trace_iterator_flags */
>  static const char *trace_options[] = {
>  	"print-parent",
> @@ -813,6 +806,33 @@ trace_function(struct trace_array *tr, struct trace_array_cpu *data,
>  	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
>  }
>  
> +static void __trace_function_return(struct trace_array *tr,
> +							 struct trace_array_cpu *data,
> +							 struct ftrace_retfunc *trace,
> +							 unsigned long flags,
> +							 int pc)
> +{
> +	struct ring_buffer_event *event;
> +	struct ftrace_ret_entry *entry;
> +	unsigned long irq_flags;
> +
> +	if (unlikely(local_read(&__get_cpu_var(ftrace_cpu_disabled))))
> +		return;
> +
> +	event = ring_buffer_lock_reserve(global_trace.buffer, sizeof(*entry),
> +					 &irq_flags);
> +	if (!event)
> +		return;
> +	entry	= ring_buffer_event_data(event);
> +	tracing_generic_entry_update(&entry->ent, flags, pc);
> +	entry->ent.type			= TRACE_FN_RET;
> +	entry->ip			= trace->func;
> +	entry->parent_ip	= trace->ret;
> +	entry->rettime		= trace->rettime;
> +	entry->calltime		= trace->calltime;
> +	ring_buffer_unlock_commit(global_trace.buffer, event, irq_flags);
> +}
> +
>  void
>  ftrace(struct trace_array *tr, struct trace_array_cpu *data,
>         unsigned long ip, unsigned long parent_ip, unsigned long flags,
> @@ -1039,6 +1059,27 @@ function_trace_call(unsigned long ip, unsigned long parent_ip)
>  	raw_local_irq_restore(flags);
>  }
>  
> +void trace_function_return(struct ftrace_retfunc *trace)
> +{
> +	struct trace_array *tr = &global_trace;
> +	struct trace_array_cpu *data;
> +	unsigned long flags;
> +	long disabled;
> +	int cpu;
> +	int pc;
> +
> +	raw_local_irq_save(flags);
> +	cpu = raw_smp_processor_id();
> +	data = tr->data[cpu];
> +	disabled = atomic_inc_return(&data->disabled);
> +	if (likely(disabled)) {

You need a test of disabled == 1, otherwise it is always true ;-)

> +		pc = preempt_count();
> +		__trace_function_return(tr, data, trace, flags, pc);
> +	}
> +	atomic_dec(&data->disabled);
> +	raw_local_irq_restore(flags);
> +}
> +
>  static struct ftrace_ops trace_ops __read_mostly =
>  {
>  	.func = function_trace_call,
> @@ -1286,7 +1327,7 @@ seq_print_sym_offset(struct trace_seq *s, const char *fmt,
>  # define IP_FMT "%016lx"
>  #endif
>  
> -static int
> +int
>  seq_print_ip_sym(struct trace_seq *s, unsigned long ip, unsigned long sym_flags)
>  {
>  	int ret;
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index 3422489..ebf1722 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -22,6 +22,7 @@ enum trace_type {
>  	TRACE_MMIO_RW,
>  	TRACE_MMIO_MAP,
>  	TRACE_BOOT,
> +	TRACE_FN_RET,
>  
>  	__TRACE_LAST_TYPE
>  };
> @@ -48,6 +49,15 @@ struct ftrace_entry {
>  	unsigned long		ip;
>  	unsigned long		parent_ip;
>  };
> +
> +/* Function return entry */
> +struct ftrace_ret_entry {
> +	struct trace_entry	ent;
> +	unsigned long		ip;
> +	unsigned long		parent_ip;
> +	unsigned long long	calltime;
> +	unsigned long long	rettime;
> +};
>  extern struct tracer boot_tracer;
>  extern struct tracer sched_switch_trace; /* Used by the boot tracer */
>  
> @@ -220,6 +230,7 @@ extern void __ftrace_bad_type(void);
>  		IF_ASSIGN(var, ent, struct trace_mmiotrace_map,		\
>  			  TRACE_MMIO_MAP);				\
>  		IF_ASSIGN(var, ent, struct trace_boot, TRACE_BOOT);	\
> +		IF_ASSIGN(var, ent, struct ftrace_ret_entry, TRACE_FN_RET); \
>  		__ftrace_bad_type();					\
>  	} while (0)
>  
> @@ -322,6 +333,8 @@ void trace_function(struct trace_array *tr,
>  		    unsigned long ip,
>  		    unsigned long parent_ip,
>  		    unsigned long flags, int pc);
> +void
> +trace_function_return(struct ftrace_retfunc *trace);
>  
>  void tracing_start_cmdline_record(void);
>  void tracing_stop_cmdline_record(void);
> @@ -391,6 +404,15 @@ extern void *head_page(struct trace_array_cpu *data);
>  extern int trace_seq_printf(struct trace_seq *s, const char *fmt, ...);
>  extern void trace_seq_print_cont(struct trace_seq *s,
>  				 struct trace_iterator *iter);
> +
> +/*
> + * TRACE_ITER_SYM_MASK masks the options in trace_flags that
> + * control the output of kernel symbols.
> + */
> +#define TRACE_ITER_SYM_MASK \
> +	(TRACE_ITER_PRINT_PARENT|TRACE_ITER_SYM_OFFSET|TRACE_ITER_SYM_ADDR)
> +extern int
> +seq_print_ip_sym(struct trace_seq *s, unsigned long ip, unsigned long sym_flags);
>  extern ssize_t trace_seq_to_user(struct trace_seq *s, char __user *ubuf,
>  				 size_t cnt);
>  extern long ns2usecs(cycle_t nsec);
> diff --git a/kernel/trace/trace_functions_return.c b/kernel/trace/trace_functions_return.c
> new file mode 100644
> index 0000000..b62491d
> --- /dev/null
> +++ b/kernel/trace/trace_functions_return.c
> @@ -0,0 +1,98 @@
> +/*
> + * 
> + * Function return tracer.
> + * Copyright (c) 2008 Frederic Weisbecker <fweisbec@gmail.com>
> + * Mostly borrowed from function tracer which 
> + * is Copyright (c) Steven Rostedt <srostedt@redhat.com>
> + *
> + */
> +#include <linux/debugfs.h>
> +#include <linux/uaccess.h>
> +#include <linux/ftrace.h>
> +#include <linux/fs.h>
> +
> +#include "trace.h"
> +
> +struct trace_array *ret_trace;
> +
> +
> +
> +static void start_return_trace(struct trace_array *tr)
> +{
> +	register_ftrace_return(&trace_function_return);
> +}
> +
> +static void stop_return_trace(struct trace_array *tr)
> +{
> +	unregister_ftrace_return();
> +}
> +
> +static void return_trace_init(struct trace_array *tr)
> +{
> +	int cpu;
> +	for_each_online_cpu(cpu)
> +		tracing_reset(tr, cpu);
> +	ret_trace = tr;
> +
> +	if (tr->ctrl)
> +		start_return_trace(tr);
> +}
> +
> +static void return_trace_reset(struct trace_array *tr)
> +{
> +	if (tr->ctrl)
> +		stop_return_trace(tr);
> +}
> +
> +static void return_trace_ctrl_update(struct trace_array *tr)
> +{
> +	if (tr->ctrl)
> +		start_return_trace(tr);
> +	else
> +		stop_return_trace(tr);
> +}
> +
> +typedef void (*func_t)(void);
> +
> +static enum print_line_t
> +print_return(struct trace_iterator *iter)
> +{
> +	struct trace_seq *s = &iter->seq;
> +	struct trace_entry *entry = iter->ent;
> +	struct ftrace_ret_entry *field;
> +	int ret;
> +
> +	if (entry->type == TRACE_FN_RET) {
> +		trace_assign_type(field, entry);
> +		ret = trace_seq_printf(s, "%pF -> ", (func_t)field->parent_ip);
> +		if (!ret)
> +			return TRACE_TYPE_PARTIAL_LINE;
> +		ret = seq_print_ip_sym(s, field->ip,
> +					trace_flags & TRACE_ITER_SYM_MASK);
> +		if (!ret)
> +			return TRACE_TYPE_PARTIAL_LINE;
> +		ret = trace_seq_printf(s, " (%llu ns)\n",
> +					field->rettime - field->calltime);
> +		if (!ret)
> +			return TRACE_TYPE_PARTIAL_LINE;
> +		else
> +			return TRACE_TYPE_HANDLED;
> +	}
> +	return TRACE_TYPE_UNHANDLED;
> +}
> +
> +static struct tracer return_trace __read_mostly =
> +{
> +	.name	     = "return",
> +	.init	     = return_trace_init,
> +	.reset	     = return_trace_reset,
> +	.ctrl_update = return_trace_ctrl_update,
> +	.print_line = print_return

Can you just add the case statement in the trace.c code to call your print 
function. Otherwise, all we get is your output. It would be nice to let 
all tracers use this.

-- Steve

> +};
> +
> +static __init int init_return_trace(void)
> +{
> +	return register_tracer(&return_trace);
> +}
> +
> +device_initcall(init_return_trace);
> 
> 
