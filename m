Return-Path: <linux-kernel-owner+w=401wt.eu-S1755186AbZBUDjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186AbZBUDjd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 22:39:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751142AbZBUDjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 22:39:24 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:47447 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569AbZBUDjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 22:39:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GvZ9UWgWMgdJ2Gese34t6HMjOp2iI8OaADGPBti7LF+N3brMhIf+FgztyVlvypoRc5
         zR/RVW289iDbQTqRHPd9ceODoFIpm4N6Kesp5M2BCCczWmY5fuV13NZF1Ht8hvhKS5oW
         NVor4C6pZj+HzcEvGfEopgXm2bHRrtSg6A4Zg=
Date: Sat, 21 Feb 2009 04:39:17 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jason Baron <jbaron@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, mingo@elte.hu,
       rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       acme@ghostprotocols.net, compudj@krystal.dyndns.org
Subject: Re: [PATCH] new irq tracer
Message-ID: <20090221033915.GB5771@nowhere>
References: <20090218195328.GA3112@redhat.com> <1234991725.4799.1.camel@laptop> <20090218213545.GB3112@redhat.com> <1234993580.4799.11.camel@laptop> <20090218220201.GG24507@redhat.com> <1234995035.4799.14.camel@laptop> <20090220195236.GB3104@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090220195236.GB3104@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 20, 2009 at 02:52:36PM -0500, Jason Baron wrote:
> On Wed, Feb 18, 2009 at 11:10:35PM +0100, Peter Zijlstra wrote:
> > On Wed, 2009-02-18 at 17:02 -0500, Frank Ch. Eigler wrote:
> > 
> > > > I really am having a difficult time seeing the use in such narrow
> > > > tracers.
> > > 
> > > Part of the problem may come from defining "tracers" as something
> > > limited to ftrace engines.  Once such tracepoints are in the kernel,
> > > more powerful analytical tools may be attached to them.
> > 
> > ftrace graph tracer is by far the most powerful thing I've seen, there's
> > nothing limiting about ftrace.
> > 
> > What is limiting are these puny little tracers that have no real value.
> > 
> > A much better purpose for these tracepoints would be augmenting data in
> > existing tracers like the graph/function/sched tracer.
> > 
> 
> ok...using these two tracepoints i've augmented the graph tracer to add
> a new column that prints the irq # and handler we're in, or -1
> otherwise. its a new 'funcgraph-irq' in 'trace_options', sample output:
> 
> 
>  1) #-1:none        2.323 us    |                                  native_apic_mem_write();
>  1) #-1:none      + 21.891 us   |                                }
>  1) #-1:none                    |                                handle_IRQ_event() {


My dream would be to see:

1)                             |                                handle_IRQ_event(29:ahci) {


But it's not possible for now, not until we have the hashtable.
Anyway, instead of having #-1:none, it would be better to have nothing
in case of user context (or softirq).

Or actually why not just an ftrace_printk when the probe is on?
Since it immediately follows the call to handle_IRQ_event, we would have the
following displayed:

1)           |                                handle_IRQ_event() {
1)           |                                  /* 29 : ahci */

Because ftrace_printk send TRACE_PRINT entries which are displayed like this
by the function graph tracer.
It would be much more light than a whole column.


>  1) #29:ahci        1.938 us    |                                  irq_to_desc();
>  1) #29:ahci        2.626 us    |                                  runqueue_is_locked();
>  1) #29:ahci      + 21.173 us   |                                          }
> 		.
> 		.
> 		.
>  1) #29:ahci      + 32.047 us   |                                        }
>  1) #29:ahci      + 43.746 us   |                                      }
>  1) #29:ahci      + 51.634 us   |                                    }
>  1) #29:ahci      + 61.954 us   |                                  }
>  1) #-1:none        1.014 us    |                                  runqueue_is_locked();
>  1) #-1:none                    |                                  __wake_up() {
>  1) #-1:none        0.920 us    |                                    _spin_lock_irqsave();
>  1) #-1:none        1.028 us    |                                    __wake_up_common();
> 
> 
> This seems to work pretty well - although it does get confused by
> certain preemption events which it can't handle...I think this can make
> the logs more readable. I can probably get it working if ppl thinks its
> valuable...or have better ways of implementing it. Code is below.
> 
> thanks,
> 
> -Jason
> 
> 
> diff --git a/include/trace/irq.h b/include/trace/irq.h
> new file mode 100644
> index 0000000..ecec94a
> --- /dev/null
> +++ b/include/trace/irq.h
> @@ -0,0 +1,25 @@
> +#ifndef _TRACE_IRQ_H
> +#define _TRACE_IRQ_H
> +
> +#include <linux/interrupt.h>
> +#include <linux/tracepoint.h>
> +
> +enum {
> +        IRQ_ENTRY = 0,
> +        IRQ_EXIT = 1,
> +};
> +
> +struct irq_trace {
> +	int type;
> +	int irq;
> +	char irq_name[10];
> +};
> +
> +DECLARE_TRACE(irq_entry,
> +	TPPROTO(unsigned int id),
> +	TPARGS(id));
> +DECLARE_TRACE(irq_exit,
> +	TPPROTO(unsigned int id, irqreturn_t retval),
> +	TPARGS(id, retval));
> +
> +#endif /* _TRACE_IRQ_H */
> diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
> index fdff380..34053b5 100644
> --- a/kernel/irq/handle.c
> +++ b/kernel/irq/handle.c
> @@ -18,6 +18,7 @@
>  #include <linux/rculist.h>
>  #include <linux/hash.h>
>  #include <linux/bootmem.h>
> +#include <trace/irq.h>
>  
>  #include "internals.h"
>  
> @@ -338,6 +339,9 @@ irqreturn_t no_action(int cpl, void *dev_id)
>  	return IRQ_NONE;
>  }
>  
> +DEFINE_TRACE(irq_entry);
> +DEFINE_TRACE(irq_exit);
> +
>  /**
>   * handle_IRQ_event - irq action chain handler
>   * @irq:	the interrupt number
> @@ -354,7 +358,9 @@ irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action)
>  		local_irq_enable_in_hardirq();
>  
>  	do {
> +		trace_irq_entry(irq);
>  		ret = action->handler(irq, action->dev_id);
> +		trace_irq_exit(irq, ret);
>  		if (ret == IRQ_HANDLED)
>  			status |= action->flags;
>  		retval |= ret;
> diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
> index 627090b..58b9f7e 100644
> --- a/kernel/trace/Makefile
> +++ b/kernel/trace/Makefile
> @@ -38,5 +38,6 @@ obj-$(CONFIG_POWER_TRACER) += trace_power.o
>  obj-$(CONFIG_KMEMTRACE) += kmemtrace.o
>  obj-$(CONFIG_WORKQUEUE_TRACER) += trace_workqueue.o
>  obj-$(CONFIG_BLK_DEV_IO_TRACE)	+= blktrace.o
> +obj-$(CONFIG_IRQ_TRACER) += trace_irq.o
>  
>  libftrace-y := ftrace.o
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index dbff020..6a34aaa 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -11,6 +11,7 @@
>  #include <trace/boot.h>
>  #include <trace/kmemtrace.h>
>  #include <trace/power.h>
> +#include <trace/irq.h>
>  
>  enum trace_type {
>  	__TRACE_FIRST_TYPE = 0,
> @@ -33,6 +34,7 @@ enum trace_type {
>  	TRACE_KMEM_ALLOC,
>  	TRACE_KMEM_FREE,
>  	TRACE_POWER,
> +	TRACE_IRQ,
>  	TRACE_BLK,
>  
>  	__TRACE_LAST_TYPE,
> @@ -173,6 +175,11 @@ struct trace_power {
>  	struct power_trace	state_data;
>  };
>  
> +struct trace_irq {
> +	struct trace_entry	ent;
> +	struct irq_trace	irq_data;
> +};
> +
>  struct kmemtrace_alloc_entry {
>  	struct trace_entry	ent;
>  	enum kmemtrace_type_id type_id;
> @@ -298,6 +305,7 @@ extern void __ftrace_bad_type(void);
>  			  TRACE_GRAPH_RET);		\
>  		IF_ASSIGN(var, ent, struct hw_branch_entry, TRACE_HW_BRANCHES);\
>   		IF_ASSIGN(var, ent, struct trace_power, TRACE_POWER); \
> +		IF_ASSIGN(var, ent, struct trace_irq, TRACE_IRQ);	\
>  		IF_ASSIGN(var, ent, struct kmemtrace_alloc_entry,	\
>  			  TRACE_KMEM_ALLOC);	\
>  		IF_ASSIGN(var, ent, struct kmemtrace_free_entry,	\
> diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
> index 519a0ca..4c4c777 100644
> --- a/kernel/trace/trace_functions_graph.c
> +++ b/kernel/trace/trace_functions_graph.c
> @@ -10,10 +10,19 @@
>  #include <linux/uaccess.h>
>  #include <linux/ftrace.h>
>  #include <linux/fs.h>
> +#include <trace/irq.h>
>  
>  #include "trace.h"
>  #include "trace_output.h"
>  
> +
> +struct per_cpu_irq_data {
> +	int irq_num;
> +	char action_str[10];
> +};
> +static struct per_cpu_irq_data cpu_irq_data[NR_CPUS];
> +static struct trace_array *graph_trace_tr;
> +
>  #define TRACE_GRAPH_INDENT	2
>  
>  /* Flag options */
> @@ -23,6 +32,7 @@
>  #define TRACE_GRAPH_PRINT_PROC		0x8
>  #define TRACE_GRAPH_PRINT_DURATION	0x10
>  #define TRACE_GRAPH_PRINT_ABS_TIME	0X20
> +#define TRACE_GRAPH_PRINT_IRQ		0X40
>  
>  static struct tracer_opt trace_opts[] = {
>  	/* Display overruns? (for self-debug purpose) */
> @@ -37,6 +47,8 @@ static struct tracer_opt trace_opts[] = {
>  	{ TRACER_OPT(funcgraph-duration, TRACE_GRAPH_PRINT_DURATION) },
>  	/* Display absolute time of an entry */
>  	{ TRACER_OPT(funcgraph-abstime, TRACE_GRAPH_PRINT_ABS_TIME) },
> +	/* Display irq number, -1 otherwise */
> +	{ TRACER_OPT(funcgraph-irq, TRACE_GRAPH_PRINT_IRQ) },
>  	{ } /* Empty entry */
>  };
>  
> @@ -52,10 +64,17 @@ static struct tracer_flags tracer_flags = {
>  
>  static int graph_trace_init(struct trace_array *tr)
>  {
> +	int i;
>  	int ret = register_ftrace_graph(&trace_graph_return,
>  					&trace_graph_entry);
>  	if (ret)
>  		return ret;
> +	graph_trace_tr = tr;
> +	for (i=0;i<NR_CPUS;i++) {
> +		cpu_irq_data[i].irq_num = -1;
> +		sprintf(cpu_irq_data[i].action_str, "none");
> +                cpu_irq_data[i].action_str[4] = '\0';
> +	}
>  	tracing_start_cmdline_record();
>  
>  	return 0;
> @@ -63,6 +82,7 @@ static int graph_trace_init(struct trace_array *tr)
>  
>  static void graph_trace_reset(struct trace_array *tr)
>  {
> +	graph_trace_tr = tr;
>  	tracing_stop_cmdline_record();
>  	unregister_ftrace_graph();
>  }
> @@ -110,6 +130,27 @@ print_graph_cpu(struct trace_seq *s, int cpu)
>  	return TRACE_TYPE_HANDLED;
>  }
>  
> +#define TRACE_GRAPH_IRQ_LENGTH     14
> +
> +static enum print_line_t
> +print_graph_irqnum(struct trace_seq *s, int cpu)
> +{
> +	char irq_str[TRACE_GRAPH_IRQ_LENGTH];
> +	int len, ret;
> +
> +	len = snprintf(irq_str, TRACE_GRAPH_IRQ_LENGTH, "#%d:%s", cpu_irq_data[cpu].irq_num, cpu_irq_data[cpu].action_str);
> +	ret = trace_seq_printf(s, "%s", irq_str);	
> +	if (!ret)
> +		return TRACE_TYPE_PARTIAL_LINE;
> +	while (len < TRACE_GRAPH_IRQ_LENGTH) {
> +		ret = trace_seq_printf(s, " ");
> +                if (!ret)
> +			return TRACE_TYPE_PARTIAL_LINE;
> +		len++;
> +	}
> +	return TRACE_TYPE_HANDLED;
> +}
> +
>  #define TRACE_GRAPH_PROCINFO_LENGTH	14
>  
>  static enum print_line_t
> @@ -504,6 +545,13 @@ print_graph_entry(struct ftrace_graph_ent_entry *field, struct trace_seq *s,
>  			return TRACE_TYPE_PARTIAL_LINE;
>  	}
>  
> +	/* irq */
> +	if (tracer_flags.val & TRACE_GRAPH_PRINT_IRQ) {
> +		ret = print_graph_irqnum(s, cpu);
> +		if (ret == TRACE_TYPE_PARTIAL_LINE)
> +			return TRACE_TYPE_PARTIAL_LINE;
> +	}
> +
>  	/* Proc */
>  	if (tracer_flags.val & TRACE_GRAPH_PRINT_PROC) {
>  		ret = print_graph_proc(s, ent->pid);
> @@ -551,6 +599,13 @@ print_graph_return(struct ftrace_graph_ret *trace, struct trace_seq *s,
>  			return TRACE_TYPE_PARTIAL_LINE;
>  	}
>  
> +	/* irq */
> +	if (tracer_flags.val & TRACE_GRAPH_PRINT_IRQ) {
> +		ret = print_graph_irqnum(s, cpu);
> +		if (ret == TRACE_TYPE_PARTIAL_LINE)
> +			return TRACE_TYPE_PARTIAL_LINE;
> +	}
> +
>  	/* Proc */
>  	if (tracer_flags.val & TRACE_GRAPH_PRINT_PROC) {
>  		ret = print_graph_proc(s, ent->pid);
> @@ -627,6 +682,13 @@ print_graph_comment(struct print_entry *trace, struct trace_seq *s,
>  			return TRACE_TYPE_PARTIAL_LINE;
>  	}
>  
> +	/* irq */
> +	if (tracer_flags.val & TRACE_GRAPH_PRINT_IRQ) {
> +		ret = print_graph_irqnum(s, cpu);
> +		if (ret == TRACE_TYPE_PARTIAL_LINE)
> +			return TRACE_TYPE_PARTIAL_LINE;
> +	}
> +
>  	/* Proc */
>  	if (tracer_flags.val & TRACE_GRAPH_PRINT_PROC) {
>  		ret = print_graph_proc(s, ent->pid);
> @@ -699,6 +761,22 @@ print_graph_function(struct trace_iterator *iter)
>  		trace_assign_type(field, entry);
>  		return print_graph_comment(field, s, entry, iter);
>  	}
> +	case TRACE_IRQ: {
> +		struct trace_irq *field;
> +		int cpu = iter->cpu;
> +
> +        	trace_assign_type(field, entry);
> +		if (field->irq_data.type == IRQ_ENTRY) {
> +			cpu_irq_data[cpu].irq_num = field->irq_data.irq;	
> +			strncpy(cpu_irq_data[cpu].action_str,field->irq_data.irq_name, 9);
> +			cpu_irq_data[cpu].action_str[9] = '\0';
> +		} else {
> +			cpu_irq_data[cpu].irq_num = -1;
> +			sprintf(cpu_irq_data[cpu].action_str, "none");
> +			cpu_irq_data[cpu].action_str[4] = '\0';
> +		}
> +		return TRACE_TYPE_HANDLED;
> +	}
>  	default:
>  		return TRACE_TYPE_UNHANDLED;
>  	}
> @@ -753,6 +831,67 @@ static void graph_trace_close(struct trace_iterator *iter)
>  	percpu_free(iter->private);
>  }
>  
> +static void probe_irq_exit(unsigned int irq, irqreturn_t retval)
> +{
> +        struct ring_buffer_event *event;
> +        struct trace_irq *entry;
> +
> +        event = trace_buffer_lock_reserve(graph_trace_tr, TRACE_IRQ,
> +                                          sizeof(*entry), 0, 0);
> +        if (!event)
> +                return;
> +        entry   = ring_buffer_event_data(event);
> +        entry->irq_data.type = IRQ_EXIT;
> +        trace_buffer_unlock_commit(graph_trace_tr, event, 0, 0);
> +}
> +
> +static void probe_irq_entry(unsigned int id)
> +{
> +        struct ring_buffer_event *event;
> +        struct trace_irq *entry;
> +	struct irq_desc *desc;
> +
> +        event = trace_buffer_lock_reserve(graph_trace_tr, TRACE_IRQ,
> +                                          sizeof(*entry), 0, 0);
> +        if (!event)
> +                return;
> +        entry   = ring_buffer_event_data(event);
> +        entry->irq_data.irq = id;
> +        entry->irq_data.type = IRQ_ENTRY;
> +	desc = irq_to_desc(id);
> +	strncpy(entry->irq_data.irq_name, desc->action->name, 9);
> +	entry->irq_data.irq_name[9] = '\0';
> +        trace_buffer_unlock_commit(graph_trace_tr, event, 0, 0);
> +}
> +
> +static int graph_trace_set_flag(u32 old_flags, u32 bit, int set)
> +{
> +	int ret = 0;
> +
> +        if (bit == TRACE_GRAPH_PRINT_IRQ) {
> +		/* do nothing if already set */
> +		//if (!!set == !!(func_flags.val & TRACE_GRAPH_PRINT_IRQ))
> +                //        return 0;
> +		if (set) {
> +			ret = register_trace_irq_entry(probe_irq_entry);
> +        		if (ret) {
> +                		pr_info("irq trace: irq entry tracepoint failed to register\n");
> +                		return ret;
> +			}
> +			ret = register_trace_irq_exit(probe_irq_exit);
> +			if (ret) {
> +				pr_info("irq trace: irq exit tracepoint failed to register\n");
> +				unregister_trace_irq_entry(probe_irq_entry);
> +				return ret;
> +			}
> +		} else {
> +			unregister_trace_irq_entry(probe_irq_entry);	
> +			unregister_trace_irq_exit(probe_irq_exit);
> +		}
> +	}
> +	return ret;
> +}
> +
>  static struct tracer graph_trace __read_mostly = {
>  	.name	     	= "function_graph",
>  	.open		= graph_trace_open,
> @@ -762,6 +901,7 @@ static struct tracer graph_trace __read_mostly = {
>  	.print_line	= print_graph_function,
>  	.print_header	= print_graph_headers,
>  	.flags		= &tracer_flags,
> +	.set_flag       = graph_trace_set_flag,
>  #ifdef CONFIG_FTRACE_SELFTEST
>  	.selftest	= trace_selftest_startup_function_graph,
>  #endif
> 

