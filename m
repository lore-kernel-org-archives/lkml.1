Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968139Ab0B0KCb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 05:02:31 -0500
Received: from mail-ww0-f46.google.com ([74.125.82.46]:58783 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968104Ab0B0KC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 05:02:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WkDJ3xVAswKXdgWn91Wy+O5jbjeO2+tG7UMFhly4tw3IL1vMqTkoikw3ulHsk6k8E0
         gOfupJ6avHUPA9VKFBgwRqWzjBxKIJHYVBjNKEHp7x1tn3UJLrA7qnOsHlv0Qaz3Fzxa
         1j7JQS/U3D8QE4cr6JGdwnVOvWoCZyRGp4WBw=
Date: Sat, 27 Feb 2010 11:02:25 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Tim Bird <tim.bird@am.sony.com>
Subject: Re: [PATCH][GIT PULL] ftrace: Add function names to dangling } in
	function graph tracer
Message-ID: <20100227100223.GB5130@nowhere>
References: <1267230439.6328.149.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267230439.6328.149.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 26, 2010 at 07:27:19PM -0500, Steven Rostedt wrote:
> commit f1c7f517a5dc23bce07efa5ed55e2c074ed9d4ba
> Author: Steven Rostedt <srostedt@redhat.com>
> Date:   Fri Feb 26 17:08:16 2010 -0500
> 
>     ftrace: Add function names to dangling } in function graph tracer
>     
>     The function graph tracer is currently the most invasive tracer
>     in the ftrace family. It can easily overflow the buffer even with
>     10megs per CPU. This means that events can often be lost.
>     
>     On start up, or after events are lost, if the function return is
>     recorded but the function enter was lost, all we get to see is the
>     exiting '}'.
>     
>     Here is how a typical trace output starts:
>     
>      [tracing] cat trace
>      # tracer: function_graph
>      #
>      # CPU  DURATION                  FUNCTION CALLS
>      # |     |   |                     |   |   |   |
>       0) + 91.897 us   |                  }
>       0) ! 567.961 us  |                }
>       0)   <========== |
>       0) ! 579.083 us  |                _raw_spin_lock_irqsave();
>       0)   4.694 us    |                _raw_spin_unlock_irqrestore();
>       0) ! 594.862 us  |              }
>       0) ! 603.361 us  |            }
>       0) ! 613.574 us  |          }
>       0) ! 623.554 us  |        }
>       0)   3.653 us    |        fget_light();
>       0)               |        sock_poll() {
>     
>     There are a series of '}' with no matching "func() {". There's no information
>     to what functions these ending brackets belong to.
>     
>     This patch adds a stack on the per cpu structure used in outputting
>     the function graph tracer to keep track of what function was outputted.
>     Then on a function exit event, it checks the depth to see if the
>     function exit has a matching entry event. If it does, then it only
>     prints the '}', otherwise it adds the function name after the '}'.
>     
>     This allows function exit events to show what function they belong to
>     at trace output startup, when the entry was lost due to ring buffer
>     overflow, or even after a new task is scheduled in.
>     
>     Here is what the above trace will look like after this patch:
>     
>      [tracing] cat trace
>      # tracer: function_graph
>      #
>      # CPU  DURATION                  FUNCTION CALLS
>      # |     |   |                     |   |   |   |
>       0) + 91.897 us   |                  } (irq_exit)
>       0) ! 567.961 us  |                } (smp_apic_timer_interrupt)
>       0)   <========== |
>       0) ! 579.083 us  |                _raw_spin_lock_irqsave();
>       0)   4.694 us    |                _raw_spin_unlock_irqrestore();
>       0) ! 594.862 us  |              } (add_wait_queue)
>       0) ! 603.361 us  |            } (__pollwait)
>       0) ! 613.574 us  |          } (tcp_poll)
>       0) ! 623.554 us  |        } (sock_poll)
>       0)   3.653 us    |        fget_light();
>       0)               |        sock_poll() {



That's a good idea.



>     
>     Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
> index 112561d..e998a82 100644
> --- a/kernel/trace/trace_functions_graph.c
> +++ b/kernel/trace/trace_functions_graph.c
> @@ -18,6 +18,7 @@ struct fgraph_cpu_data {
>  	pid_t		last_pid;
>  	int		depth;
>  	int		ignore;
> +	unsigned long	enter_funcs[FTRACE_RETFUNC_DEPTH];
>  };
>  
>  struct fgraph_data {
> @@ -670,15 +671,21 @@ print_graph_entry_leaf(struct trace_iterator *iter,
>  	duration = graph_ret->rettime - graph_ret->calltime;
>  
>  	if (data) {
> +		struct fgraph_cpu_data *cpu_data;
>  		int cpu = iter->cpu;
> -		int *depth = &(per_cpu_ptr(data->cpu_data, cpu)->depth);
> +
> +		cpu_data = per_cpu_ptr(data->cpu_data, cpu);
>  
>  		/*
>  		 * Comments display at + 1 to depth. Since
>  		 * this is a leaf function, keep the comments
>  		 * equal to this depth.
>  		 */
> -		*depth = call->depth - 1;
> +		cpu_data->depth = call->depth - 1;
> +
> +		/* No need to keep this function around for this depth */
> +		if (call->depth < FTRACE_RETFUNC_DEPTH)



Do you really need to check that? call->depth >= FTRACE_RETFUNC_DEPTH
are not recorded.



> +			cpu_data->enter_funcs[call->depth] = 0;
>  	}
>  
>  	/* Overhead */
> @@ -718,10 +725,15 @@ print_graph_entry_nested(struct trace_iterator *iter,
>  	int i;
>  
>  	if (data) {
> +		struct fgraph_cpu_data *cpu_data;
>  		int cpu = iter->cpu;
> -		int *depth = &(per_cpu_ptr(data->cpu_data, cpu)->depth);
>  
> -		*depth = call->depth;
> +		cpu_data = per_cpu_ptr(data->cpu_data, cpu);
> +		cpu_data->depth = call->depth;
> +
> +		/* Save this function pointer to see if the exit matches */
> +		if (call->depth < FTRACE_RETFUNC_DEPTH)
> +			cpu_data->enter_funcs[call->depth] = call->func;
>  	}
>  
>  	/* No overhead */
> @@ -851,18 +863,28 @@ print_graph_return(struct ftrace_graph_ret *trace, struct trace_seq *s,
>  	struct fgraph_data *data = iter->private;
>  	pid_t pid = ent->pid;
>  	int cpu = iter->cpu;
> +	int func_match = 1;
>  	int ret;
>  	int i;
>  
>  	if (data) {
> -		int *depth = &(per_cpu_ptr(data->cpu_data, cpu)->depth);
> +		struct fgraph_cpu_data *cpu_data;
> +		int cpu = iter->cpu;
> +
> +		cpu_data = per_cpu_ptr(data->cpu_data, cpu);
>  
>  		/*
>  		 * Comments display at + 1 to depth. This is the
>  		 * return from a function, we now want the comments
>  		 * to display at the same level of the bracket.
>  		 */
> -		*depth = trace->depth - 1;
> +		cpu_data->depth = trace->depth - 1;
> +
> +		if (trace->depth < FTRACE_RETFUNC_DEPTH) {
> +			if (cpu_data->enter_funcs[trace->depth] != trace->func)
> +				func_match = 0;
> +			cpu_data->enter_funcs[trace->depth] = 0;
> +		}
>  	}
>  
>  	if (print_graph_prologue(iter, s, 0, 0))
> @@ -887,9 +909,21 @@ print_graph_return(struct ftrace_graph_ret *trace, struct trace_seq *s,
>  			return TRACE_TYPE_PARTIAL_LINE;
>  	}
>  
> -	ret = trace_seq_printf(s, "}\n");
> -	if (!ret)
> -		return TRACE_TYPE_PARTIAL_LINE;
> +	/*
> +	 * If the return function does not have a matching entry,
> +	 * then the entry was lost. Instead of just printing
> +	 * the '}' and letting the user guess what function this
> +	 * belongs to, write out the function name.
> +	 */
> +	if (func_match) {
> +		ret = trace_seq_printf(s, "}\n");
> +		if (!ret)
> +			return TRACE_TYPE_PARTIAL_LINE;
> +	} else {
> +		ret = trace_seq_printf(s, "} (%ps)\n", (void *)trace->func);
> +		if (!ret)
> +			return TRACE_TYPE_PARTIAL_LINE;
> +	}
>  
>  	/* Overrun */
>  	if (tracer_flags.val & TRACE_GRAPH_PRINT_OVERRUN) {
> 
> 


Very nice!

