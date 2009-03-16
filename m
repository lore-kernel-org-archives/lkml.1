Return-Path: <linux-kernel-owner+w=401wt.eu-S1758013AbZCPSDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758013AbZCPSDv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 14:03:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761113AbZCPR5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 13:57:16 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:9593 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761382AbZCPR5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 13:57:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=REHQKI1GjUgBuFZTyxV1AUrbw6TEWfA/OgquQ++LWVdD7v9AXFpwXcabUiHym8iPpM
         foBQgwnp0saUTlWg7HbMz8wfdMAPACUTv4xdQVJ46alVwIxRxByVMdsr1g2Obv/BsRMc
         875j6miOny+pL3WOB9SVlVlYOqisfve3u9uT0=
Date: Mon, 16 Mar 2009 18:57:06 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kevin Shanahan <kmshanah@ucwb.org.au>, Ingo Molnar <mingo@elte.hu>,
       Avi Kivity <avi@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>, bugme-daemon@bugzilla.kernel.org
Subject: Re: [RFC][PATCH] ftrace: function graph trace context switches
Message-ID: <20090316175704.GA8393@nowhere>
References: <20090120125652.GA1457@elte.hu> <20090120130714.GA11048@elte.hu> <alpine.DEB.1.10.0901200957220.2681@gandalf.stny.rr.com> <49760E2D.2060109@redhat.com> <1232547932.4895.119.camel@kulgan.wumi.org.au> <49773275.3020203@redhat.com> <20090121151820.GA23813@elte.hu> <1232963730.4921.12.camel@kulgan.wumi.org.au> <1232969705.4863.46.camel@laptop> <1232980692.4863.104.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232980692.4863.104.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2009 at 03:38:12PM +0100, Peter Zijlstra wrote:
> On Mon, 2009-01-26 at 12:35 +0100, Peter Zijlstra wrote:
> > 
> > Another something nice would be to have ctx switches like:
> > 
> > foo-1 => bar-2 ran: ${time foo spend on the cpu} since: ${time bar
> > spend away from the cpu}
> 
> Steve, Frederic, how's this?
> 
> (compile tested only)


Hi Peter,

This patch was very useful. Would you still like to post
an updated one?

May be this feature could be a separate option so that we can
select it only when needed.

Thanks,
Frederic.

 
> ---
>  include/linux/ftrace.h               |    5 ++
>  kernel/sched_fair.c                  |    1 -
>  kernel/trace/Kconfig                 |    1 +
>  kernel/trace/trace.c                 |   51 +++++++++++++++++++
>  kernel/trace/trace.h                 |   10 ++++
>  kernel/trace/trace_functions_graph.c |   88 ++++++++++++++-------------------
>  6 files changed, 104 insertions(+), 52 deletions(-)
> 
> diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
> index 9f7880d..411b027 100644
> --- a/include/linux/ftrace.h
> +++ b/include/linux/ftrace.h
> @@ -381,6 +381,11 @@ struct ftrace_graph_ret {
>  	int depth;
>  };
>  
> +struct ftrace_graph_switch {
> +	pid_t prev, next;
> +	u64 ran, since;
> +};
> +
>  #ifdef CONFIG_FUNCTION_GRAPH_TRACER
>  
>  /*
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index f34cf42..fa477ac 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -530,7 +530,6 @@ update_stats_wait_end(struct cfs_rq *cfs_rq, struct sched_entity *se)
>  	schedstat_set(se->wait_count, se->wait_count + 1);
>  	schedstat_set(se->wait_sum, se->wait_sum +
>  			rq_of(cfs_rq)->clock - se->wait_start);
> -	schedstat_set(se->wait_start, 0);
>  }
>  
>  static inline void
> diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> index dde1d46..7aa1c13 100644
> --- a/kernel/trace/Kconfig
> +++ b/kernel/trace/Kconfig
> @@ -67,6 +67,7 @@ config FUNCTION_GRAPH_TRACER
>  	bool "Kernel Function Graph Tracer"
>  	depends on HAVE_FUNCTION_GRAPH_TRACER
>  	depends on FUNCTION_TRACER
> +	select SCHEDSTATS
>  	default y
>  	help
>  	  Enable the kernel to trace a function at both its return
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 2129ab9..380a334 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -31,6 +31,7 @@
>  #include <linux/fs.h>
>  #include <linux/kprobes.h>
>  #include <linux/writeback.h>
> +#include <linux/sched.h>
>  
>  #include <linux/stacktrace.h>
>  #include <linux/ring_buffer.h>
> @@ -820,6 +821,35 @@ static void __trace_graph_return(struct trace_array *tr,
>  	entry->ret				= *trace;
>  	ring_buffer_unlock_commit(global_trace.buffer, event, irq_flags);
>  }
> +
> +static void __trace_graph_switch(struct trace_array *tr,
> +				 struct trace_array_cpu *data,
> +				 unsigned long flags, int pc,
> +				 struct task_struct *prev,
> +				 struct task_struct *next)
> +{
> +	struct ring_buffer_event *event;
> +	struct ftrace_graph_switch_entry *entry;
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
> +	entry->ent.type			= TRACE_GRAPH_SWITCH;
> +	entry->ctx.prev = prev->pid;
> +	entry->ctx.next = next->pid;
> +	entry->ctx.ran = prev->se.sum_exec_runtime -
> +		    prev->se.prev_sum_exec_runtime;
> +	entry->ctx.since = next->se.exec_start - next->se.wait_start;
> +
> +	ring_buffer_unlock_commit(global_trace.buffer, event, irq_flags);
> +}
>  #endif
>  
>  void
> @@ -1097,6 +1127,27 @@ void trace_graph_return(struct ftrace_graph_ret *trace)
>  	atomic_dec(&data->disabled);
>  	local_irq_restore(flags);
>  }
> +
> +void trace_graph_switch(struct task_struct *prev, struct task_struct *next)
> +{
> +	struct trace_array *tr = &global_trace;
> +	struct trace_array_cpu *data;
> +	unsigned long flags;
> +	long disabled;
> +	int cpu;
> +	int pc;
> +
> +	local_irq_save(flags);
> +	cpu = raw_smp_processor_id();
> +	data = tr->data[cpu];
> +	disabled = atomic_inc_return(&data->disabled);
> +	if (likely(disabled == 1)) {
> +		pc = preempt_count();
> +		__trace_graph_switch(tr, data, flags, pc, prev, next);
> +	}
> +	atomic_dec(&data->disabled);
> +	local_irq_restore(flags);
> +}
>  #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
>  
>  enum trace_file_type {
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index b96037d..781fbce 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -27,6 +27,7 @@ enum trace_type {
>  	TRACE_BOOT_RET,
>  	TRACE_GRAPH_RET,
>  	TRACE_GRAPH_ENT,
> +	TRACE_GRAPH_SWITCH,
>  	TRACE_USER_STACK,
>  	TRACE_HW_BRANCHES,
>  	TRACE_KMEM_ALLOC,
> @@ -71,6 +72,12 @@ struct ftrace_graph_ret_entry {
>  	struct trace_entry			ent;
>  	struct ftrace_graph_ret		ret;
>  };
> +
> +struct ftrace_graph_switch_entry {
> +	struct trace_entry		ent;
> +	struct ftrace_graph_switch	ctx;
> +};
> +
>  extern struct tracer boot_tracer;
>  
>  /*
> @@ -295,6 +302,8 @@ extern void __ftrace_bad_type(void);
>  			  TRACE_GRAPH_ENT);		\
>  		IF_ASSIGN(var, ent, struct ftrace_graph_ret_entry,	\
>  			  TRACE_GRAPH_RET);		\
> +		IF_ASSIGN(var, ent, struct ftrace_graph_switch_entry,	\
> +			  TRACE_GRAPH_SWITCH);		\
>  		IF_ASSIGN(var, ent, struct hw_branch_entry, TRACE_HW_BRANCHES);\
>   		IF_ASSIGN(var, ent, struct trace_power, TRACE_POWER); \
>  		IF_ASSIGN(var, ent, struct kmemtrace_alloc_entry,	\
> @@ -438,6 +447,7 @@ void trace_function(struct trace_array *tr,
>  
>  void trace_graph_return(struct ftrace_graph_ret *trace);
>  int trace_graph_entry(struct ftrace_graph_ent *trace);
> +void trace_graph_switch(struct task_struct *prev, struct task_struct *next);
>  
>  void tracing_start_cmdline_record(void);
>  void tracing_stop_cmdline_record(void);
> diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
> index 66fc7b8..cf6494b 100644
> --- a/kernel/trace/trace_functions_graph.c
> +++ b/kernel/trace/trace_functions_graph.c
> @@ -10,6 +10,7 @@
>  #include <linux/uaccess.h>
>  #include <linux/ftrace.h>
>  #include <linux/fs.h>
> +#include <trace/sched.h>
>  
>  #include "trace.h"
>  #include "trace_output.h"
> @@ -158,28 +159,13 @@ print_graph_proc(struct trace_seq *s, pid_t pid)
>  	return TRACE_TYPE_HANDLED;
>  }
>  
> -
> -/* If the pid changed since the last trace, output this event */
>  static enum print_line_t
> -verif_pid(struct trace_seq *s, pid_t pid, int cpu, pid_t *last_pids_cpu)
> +print_graph_switch(struct ftrace_graph_switch_entry *field, struct trace_seq *s,
> +			struct trace_iterator *iter)
>  {
> -	pid_t prev_pid;
> -	pid_t *last_pid;
> +	int cpu = iter->cpu;
>  	int ret;
>  
> -	if (!last_pids_cpu)
> -		return TRACE_TYPE_HANDLED;
> -
> -	last_pid = per_cpu_ptr(last_pids_cpu, cpu);
> -
> -	if (*last_pid == pid)
> -		return TRACE_TYPE_HANDLED;
> -
> -	prev_pid = *last_pid;
> -	*last_pid = pid;
> -
> -	if (prev_pid == -1)
> -		return TRACE_TYPE_HANDLED;
>  /*
>   * Context-switch trace line:
>  
> @@ -197,7 +183,7 @@ verif_pid(struct trace_seq *s, pid_t pid, int cpu, pid_t *last_pids_cpu)
>  	if (ret == TRACE_TYPE_PARTIAL_LINE)
>  		TRACE_TYPE_PARTIAL_LINE;
>  
> -	ret = print_graph_proc(s, prev_pid);
> +	ret = print_graph_proc(s, field->ctx.prev);
>  	if (ret == TRACE_TYPE_PARTIAL_LINE)
>  		TRACE_TYPE_PARTIAL_LINE;
>  
> @@ -205,16 +191,21 @@ verif_pid(struct trace_seq *s, pid_t pid, int cpu, pid_t *last_pids_cpu)
>  	if (!ret)
>  		TRACE_TYPE_PARTIAL_LINE;
>  
> -	ret = print_graph_proc(s, pid);
> +	ret = print_graph_proc(s, field->ctx.next);
>  	if (ret == TRACE_TYPE_PARTIAL_LINE)
>  		TRACE_TYPE_PARTIAL_LINE;
>  
> +	ret = trace_seq_printf(s, "  ran: %Lu, since: %Lu",
> +			field->ctx.ran, field->ctx.since);
> +	if (!ret)
> +		TRACE_TYPE_PARTIAL_LINE;
> +
>  	ret = trace_seq_printf(s,
>  		"\n ------------------------------------------\n\n");
>  	if (!ret)
>  		TRACE_TYPE_PARTIAL_LINE;
>  
> -	return ret;
> +	return TRACE_TYPE_HANDLED;
>  }
>  
>  static bool
> @@ -471,14 +462,9 @@ print_graph_entry(struct ftrace_graph_ent_entry *field, struct trace_seq *s,
>  {
>  	int ret;
>  	int cpu = iter->cpu;
> -	pid_t *last_entry = iter->private;
>  	struct trace_entry *ent = iter->ent;
>  	struct ftrace_graph_ent *call = &field->graph_ent;
>  
> -	/* Pid */
> -	if (verif_pid(s, ent->pid, cpu, last_entry) == TRACE_TYPE_PARTIAL_LINE)
> -		return TRACE_TYPE_PARTIAL_LINE;
> -
>  	/* Interrupt */
>  	ret = print_graph_irq(s, call->func, TRACE_GRAPH_ENT, cpu, ent->pid);
>  	if (ret == TRACE_TYPE_PARTIAL_LINE)
> @@ -523,12 +509,8 @@ print_graph_return(struct ftrace_graph_ret *trace, struct trace_seq *s,
>  	int i;
>  	int ret;
>  	int cpu = iter->cpu;
> -	pid_t *last_pid = iter->private;
>  	unsigned long long duration = trace->rettime - trace->calltime;
>  
> -	/* Pid */
> -	if (verif_pid(s, ent->pid, cpu, last_pid) == TRACE_TYPE_PARTIAL_LINE)
> -		return TRACE_TYPE_PARTIAL_LINE;
>  
>  	/* Absolute time */
>  	if (tracer_flags.val & TRACE_GRAPH_PRINT_ABS_TIME) {
> @@ -600,7 +582,6 @@ print_graph_comment(struct print_entry *trace, struct trace_seq *s,
>  	int i;
>  	int ret;
>  	int cpu = iter->cpu;
> -	pid_t *last_pid = iter->private;
>  
>  	/* Absolute time */
>  	if (tracer_flags.val & TRACE_GRAPH_PRINT_ABS_TIME) {
> @@ -609,10 +590,6 @@ print_graph_comment(struct print_entry *trace, struct trace_seq *s,
>  			return TRACE_TYPE_PARTIAL_LINE;
>  	}
>  
> -	/* Pid */
> -	if (verif_pid(s, ent->pid, cpu, last_pid) == TRACE_TYPE_PARTIAL_LINE)
> -		return TRACE_TYPE_PARTIAL_LINE;
> -
>  	/* Cpu */
>  	if (tracer_flags.val & TRACE_GRAPH_PRINT_CPU) {
>  		ret = print_graph_cpu(s, cpu);
> @@ -677,6 +654,11 @@ print_graph_function(struct trace_iterator *iter)
>  	struct trace_entry *entry = iter->ent;
>  
>  	switch (entry->type) {
> +	case TRACE_GRAPH_SWITCH: {
> +		struct ftrace_graph_switch_entry *field;
> +		trace_assign_type(field, entry);
> +		return print_graph_switch(field, s, iter);
> +	}
>  	case TRACE_GRAPH_ENT: {
>  		struct ftrace_graph_ent_entry *field;
>  		trace_assign_type(field, entry);
> @@ -724,34 +706,38 @@ static void print_graph_headers(struct seq_file *s)
>  	seq_printf(s, "               |   |   |   |\n");
>  }
>  
> -static void graph_trace_open(struct trace_iterator *iter)
> +static void probe_sched_switch(struct rq *rq,
> +			       struct task_struct *prev,
> +			       struct task_struct *next)
>  {
> -	/* pid on the last trace processed */
> -	pid_t *last_pid = alloc_percpu(pid_t);
> -	int cpu;
> +	trace_graph_switch(prev, next);
> +}
>  
> -	if (!last_pid)
> -		pr_warning("function graph tracer: not enough memory\n");
> -	else
> -		for_each_possible_cpu(cpu) {
> -			pid_t *pid = per_cpu_ptr(last_pid, cpu);
> -			*pid = -1;
> -		}
> +static DEFINE_MUTEX(graph_trace_mutex);
> +static int graph_trace_ref;
>  
> -	iter->private = last_pid;
> +static void graph_trace_start(struct trace_array *tr)
> +{
> +	mutex_lock(&graph_trace_mutex);
> +	if (!(graph_trace_ref++))
> +		register_trace_sched_switch(probe_sched_switch);
> +	mutex_unlock(&graph_trace_mutex);
>  }
>  
> -static void graph_trace_close(struct trace_iterator *iter)
> +static void graph_trace_stop(struct trace_array *tr)
>  {
> -	percpu_free(iter->private);
> +	mutex_lock(&graph_trace_mutex);
> +	if (!(--graph_trace_ref))
> +		unregister_trace_sched_switch(probe_sched_switch);
> +	mutex_unlock(&graph_trace_mutex);
>  }
>  
>  static struct tracer graph_trace __read_mostly = {
>  	.name	     	= "function_graph",
> -	.open		= graph_trace_open,
> -	.close		= graph_trace_close,
>  	.init	     	= graph_trace_init,
>  	.reset	     	= graph_trace_reset,
> +	.start		= graph_trace_start,
> +	.stop		= graph_trace_stop,
>  	.print_line	= print_graph_function,
>  	.print_header	= print_graph_headers,
>  	.flags		= &tracer_flags,
> 
> 

