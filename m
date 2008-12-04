Return-Path: <linux-kernel-owner+w=401wt.eu-S1756488AbYLDCVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756488AbYLDCVr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 21:21:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751121AbYLDCVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 21:21:37 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:65134 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbYLDCVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 21:21:36 -0500
Date: Wed, 3 Dec 2008 21:21:34 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Tim Bird <tim.bird@am.sony.com>, Pekka Paalanen <pq@iki.fi>
Subject: Re: [PATCH] tracing/function-graph-tracer: handle ftrace_printk
 entries
In-Reply-To: <49370BF7.6040108@gmail.com>
Message-ID: <alpine.DEB.1.10.0812032113260.28153@gandalf.stny.rr.com>
References: <49370BF7.6040108@gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 3 Dec 2008, Frederic Weisbecker wrote:

> Handle the TRACE_PRINT entries from the function grapg tracer
> and output them as a C comment just below the function that called
> it, as if it was a comment inside this function.

Cool, thanks!

> 
> Example with an ftrace_printk inside might_sleep() function:
> 
> void __might_sleep(char *file, int line)
> {
> 	static unsigned long prev_jiffy;	/* ratelimiting */
> 
> 	ftrace_printk("Hi I'm a comment in might_sleep() :-)");
> 
> A chunk of a resulting trace:
> 
>  0)               |                                _reiserfs_free_block() {
>  0)               |                                  reiserfs_read_bitmap_block() {
>  0)               |                                    __bread() {
>  0)               |                                      __getblk() {
>  0)               |                                        __find_get_block() {
>  0)   0.698 us    |                                          mark_page_accessed();
>  0)   2.267 us    |                                        }
>  0)               |                                        __might_sleep() {
>  0)               |                                          /* Hi I'm a comment in might_sleep() :-) */
>  0)   1.321 us    |                                        }
>  0)   5.872 us    |                                      }
>  0)   7.313 us    |                                    }
>  0)   8.718 us    |                                  }
> 
> And this patch bring two minor fixes:
> 
> _ The newline after a switch-out task has disappeared
> _ The "|" sign just before the cpu number on task-switch has been deleted.
> 
>  0)   0.616 us    |                pick_next_task_rt();
>  0)   1.457 us    |                _spin_trylock();
>  0)   0.653 us    |                _spin_unlock();
>  0)   0.728 us    |                _spin_trylock();
>  0)   0.631 us    |                _spin_unlock();
>  0)   0.729 us    |                native_load_sp0();
>  0)   0.593 us    |                native_load_tls();
>  ------------------------------------------
>  0)    cat-2834    =>   migrati-3
>  ------------------------------------------
> 
>  0)               |    finish_task_switch() {
>  0)   0.841 us    |      _spin_unlock_irq();
>  0)   0.616 us    |      post_schedule_rt();
>  0)   3.882 us    |    }
> 
> 
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Pekka Paalanen <pq@iki.fi>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  kernel/trace/trace.c                 |   28 ++++++++++---
>  kernel/trace/trace.h                 |    4 +-
>  kernel/trace/trace_functions_graph.c |   72 +++++++++++++++++++++++++++++++++-
>  kernel/trace/trace_mmiotrace.c       |    2 +-
>  4 files changed, 97 insertions(+), 9 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 8b6409a..1ca74c0 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -3335,7 +3335,7 @@ static int mark_printk(const char *fmt, ...)
>  	int ret;
>  	va_list args;
>  	va_start(args, fmt);
> -	ret = trace_vprintk(0, fmt, args);
> +	ret = trace_vprintk(0, -1, fmt, args);
>  	va_end(args);
>  	return ret;
>  }
> @@ -3564,9 +3564,16 @@ static __init int tracer_init_debugfs(void)
>  	return 0;
>  }
>  
> -int trace_vprintk(unsigned long ip, const char *fmt, va_list args)
> +int trace_vprintk(unsigned long ip, int depth, const char *fmt, va_list args)
>  {
> -	static DEFINE_SPINLOCK(trace_buf_lock);
> +	/*
> +	 * Raw Spinlock because a normal spinlock would be traced here
> +	 * and append an irrelevant couple spin_lock_irqsave/
> +	 * spin_unlock_irqrestore traced by ftrace around this
> +	 * TRACE_PRINTK trace.
> +	 */
> +	static raw_spinlock_t trace_buf_lock =
> +				(raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
>  	static char trace_buf[TRACE_BUF_SIZE];
>  
>  	struct ring_buffer_event *event;
> @@ -3587,7 +3594,8 @@ int trace_vprintk(unsigned long ip, const char *fmt, va_list args)
>  	if (unlikely(atomic_read(&data->disabled)))
>  		goto out;
>  
> -	spin_lock_irqsave(&trace_buf_lock, flags);
> +	local_irq_save(flags);
> +	__raw_spin_lock(&trace_buf_lock);
>  	len = vsnprintf(trace_buf, TRACE_BUF_SIZE, fmt, args);

I wonder if we should add a new flag called "NOTRACE" to the new 
current->trace flags. When set, tracing is stopped for the task. Then we 
can still use spinlock here. We only want to use raw if the tracing will 
cause lockdep to fail, not just to prevent traces.

We could do something like:

  pause_trace(current); /* sets the "notrace" flag */

  unpause_trace(current); /* clears the "notrace" flag */

>  
>  	len = min(len, TRACE_BUF_SIZE-1);
> @@ -3601,13 +3609,15 @@ int trace_vprintk(unsigned long ip, const char *fmt, va_list args)
>  	tracing_generic_entry_update(&entry->ent, flags, pc);
>  	entry->ent.type			= TRACE_PRINT;
>  	entry->ip			= ip;
> +	entry->depth			= depth;
>  
>  	memcpy(&entry->buf, trace_buf, len);
>  	entry->buf[len] = 0;
>  	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
>  
>   out_unlock:
> -	spin_unlock_irqrestore(&trace_buf_lock, flags);
> +	__raw_spin_unlock(&trace_buf_lock);
> +	local_irq_restore(flags);
>  
>   out:
>  	preempt_enable_notrace();
> @@ -3625,7 +3635,13 @@ int __ftrace_printk(unsigned long ip, const char *fmt, ...)
>  		return 0;
>  
>  	va_start(ap, fmt);
> -	ret = trace_vprintk(ip, fmt, ap);
> +
> +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
> +	ret = trace_vprintk(ip, current->curr_ret_stack, fmt, ap);
> +#else
> +	ret = trace_vprintk(ip, -1, fmt, ap);
> +#endif

Could you make a macro task_curr_ret_stack(task) and in the ftrace header 
file have:

#ifdef CONFIG_FUNCTION_GRAPH_TRACER
static inline int task_curr_ret_stack(struct task_struct *task)
{
	return task->curr_ret_stack;
}
#else
static inline int task_curr_ret_stack(struct task_struct *task)
{
	return -1;
}
#endif

And then you could get rid of the #ifdefs in the code and just use:

	ret = trace_vprintk(ip, task_curr_ret_stack(current), fmt, ap);

> +
>  	va_end(ap);
>  	return ret;
>  }
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index 0565ae9..fce9889 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -117,6 +117,7 @@ struct userstack_entry {
>  struct print_entry {
>  	struct trace_entry	ent;
>  	unsigned long		ip;
> +	int			depth;
>  	char			buf[];
>  };
>  
> @@ -498,7 +499,8 @@ seq_print_ip_sym(struct trace_seq *s, unsigned long ip,
>  extern ssize_t trace_seq_to_user(struct trace_seq *s, char __user *ubuf,
>  				 size_t cnt);
>  extern long ns2usecs(cycle_t nsec);
> -extern int trace_vprintk(unsigned long ip, const char *fmt, va_list args);
> +extern int
> +trace_vprintk(unsigned long ip, int depth, const char *fmt, va_list args);
>  
>  extern unsigned long trace_flags;
>  
> diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
> index c66578f..32b7fb9 100644
> --- a/kernel/trace/trace_functions_graph.c
> +++ b/kernel/trace/trace_functions_graph.c
> @@ -173,7 +173,7 @@ verif_pid(struct trace_seq *s, pid_t pid, int cpu)
>  
>   */
>  	ret = trace_seq_printf(s,
> -		"\n ------------------------------------------\n |");
> +		" ------------------------------------------\n");
>  	if (!ret)
>  		TRACE_TYPE_PARTIAL_LINE;
>  
> @@ -477,6 +477,71 @@ print_graph_return(struct ftrace_graph_ret *trace, struct trace_seq *s,
>  	return TRACE_TYPE_HANDLED;
>  }
>  
> +static enum print_line_t
> +print_graph_comment(struct print_entry *trace, struct trace_seq *s,
> +		   struct trace_entry *ent, struct trace_iterator *iter)
> +{
> +	int i;
> +	int ret;
> +
> +	/* Pid */
> +	if (verif_pid(s, ent->pid, iter->cpu) == TRACE_TYPE_PARTIAL_LINE)
> +		return TRACE_TYPE_PARTIAL_LINE;
> +
> +	/* Cpu */
> +	if (tracer_flags.val & TRACE_GRAPH_PRINT_CPU) {
> +		ret = print_graph_cpu(s, iter->cpu);
> +		if (ret == TRACE_TYPE_PARTIAL_LINE)
> +			return TRACE_TYPE_PARTIAL_LINE;
> +	}
> +
> +	/* Proc */
> +	if (tracer_flags.val & TRACE_GRAPH_PRINT_PROC) {
> +		ret = print_graph_proc(s, ent->pid);
> +		if (ret == TRACE_TYPE_PARTIAL_LINE)
> +			return TRACE_TYPE_PARTIAL_LINE;
> +
> +		ret = trace_seq_printf(s, " | ");
> +		if (!ret)
> +			return TRACE_TYPE_PARTIAL_LINE;
> +	}
> +
> +	/* No overhead */
> +	if (tracer_flags.val & TRACE_GRAPH_PRINT_OVERHEAD) {
> +		ret = trace_seq_printf(s, "  ");
> +		if (!ret)
> +			return TRACE_TYPE_PARTIAL_LINE;
> +	}
> +
> +	/* No time */
> +	ret = trace_seq_printf(s, "            |  ");
> +	if (!ret)
> +		return TRACE_TYPE_PARTIAL_LINE;
> +
> +	/* Indentation */
> +	if (trace->depth > 0)
> +		for (i = 0; i < (trace->depth + 1) * TRACE_GRAPH_INDENT; i++) {
> +			ret = trace_seq_printf(s, " ");
> +			if (!ret)
> +				return TRACE_TYPE_PARTIAL_LINE;
> +		}
> +
> +	/* The comment */
> +	ret = trace_seq_printf(s, "/* %s", trace->buf);
> +	if (!ret)
> +		return TRACE_TYPE_PARTIAL_LINE;
> +
> +	if (ent->flags & TRACE_FLAG_CONT)
> +		trace_seq_print_cont(s, iter);
> +
> +	ret = trace_seq_printf(s, " */\n");
> +	if (!ret)
> +		return TRACE_TYPE_PARTIAL_LINE;
> +
> +	return TRACE_TYPE_HANDLED;
> +}
> +
> +
>  enum print_line_t
>  print_graph_function(struct trace_iterator *iter)
>  {
> @@ -495,6 +560,11 @@ print_graph_function(struct trace_iterator *iter)
>  		trace_assign_type(field, entry);
>  		return print_graph_return(&field->ret, s, entry, iter->cpu);
>  	}
> +	case TRACE_PRINT: {
> +		struct print_entry *field;
> +		trace_assign_type(field, entry);
> +		return print_graph_comment(field, s, entry, iter);
> +	}
>  	default:
>  		return TRACE_TYPE_UNHANDLED;
>  	}
> diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
> index 2a98a20..2fb6da6 100644
> --- a/kernel/trace/trace_mmiotrace.c
> +++ b/kernel/trace/trace_mmiotrace.c
> @@ -366,5 +366,5 @@ void mmio_trace_mapping(struct mmiotrace_map *map)
>  
>  int mmio_trace_printk(const char *fmt, va_list args)
>  {
> -	return trace_vprintk(0, fmt, args);
> +	return trace_vprintk(0, -1, fmt, args);
>  }
> -- 


Other than what I commented above.

Acked-by: Steven Rostedt <srostedt@redhat.com>

-- Steve

