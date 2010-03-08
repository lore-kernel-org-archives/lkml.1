Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273Ab0CHT3z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 14:29:55 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:46499 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115Ab0CHT3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 14:29:48 -0500
X-Authority-Analysis: v=1.0 c=1 a=FomgQ1NC3-kA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=20KFwNOVAAAA:8 a=Pq0ifNNEoAOb59RbF00A:9 a=KW-hTgaHOvDFo03e2MYA:7 a=o0dmV4CHxZ-OIrvJ3ECzECVyCYgA:4 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 1/4] tracing: adding ftrace events for graph tracer
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Jiri Olsa <jolsa@redhat.com>
Cc: mingo@elte.hu, fweisbec@gmail.com, linux-kernel@vger.kernel.org
In-Reply-To: <1266843422-18288-2-git-send-email-jolsa@redhat.com>
References: <1266843422-18288-1-git-send-email-jolsa@redhat.com>
	 <1266843422-18288-2-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 08 Mar 2010 14:29:46 -0500
Message-ID: <1268076586.10871.1859.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-22 at 13:56 +0100, Jiri Olsa wrote:
> hi,
> 
> this patch adds ftrace events for graph tracer, so the graph output
> could be shared within other tracers.
> 

Sorry but NAK to this,

What use to be:

 2) + 25.633 us   |                        }
 3) ! 252.132 us  |              } /* do_softirq */
 2) ! 898.211 us  |                      } /* rcu_process_callbacks */
 2)               |                      /* softirq_exit: vec=9 [action=RCU] */
 3)   5.534 us    |              rcu_irq_exit();
 2)   6.405 us    |                      preempt_schedule();
 3)   5.221 us    |              idle_cpu();
 2)   6.014 us    |                      rcu_bh_qs();
 3) ! 289.729 us  |            } /* irq_exit */
 2)               |                      /* softirq_entry: vec=1 [action=TIMER] */
 3) ! 860.416 us  |          } /* smp_apic_timer_interrupt */
 3)   <========== |
 2)   5.785 us    |                      preempt_schedule();


Is now:

      gdmgreeter-3382  [002]   119.609346:  2) + 25.633 us   |                        }
           pcscd-2849  [003]   119.609352:  3) ! 252.132 us  |              } /* do_softirq */
      gdmgreeter-3382  [002]   119.609353:  2) ! 898.211 us  |                      } /* rcu_process_callbacks */
      gdmgreeter-3382  [002]   119.609357: softirq_exit: vec=9 [action=RCU]
           pcscd-2849  [003]   119.609360:  3)   5.534 us    |              rcu_irq_exit();
      gdmgreeter-3382  [002]   119.609363:  2)   6.405 us    |                      preempt_schedule();
           pcscd-2849  [003]   119.609370:  3)   5.221 us    |              idle_cpu();
      gdmgreeter-3382  [002]   119.609376:  2)   6.014 us    |                      rcu_bh_qs();
           pcscd-2849  [003]   119.609383:  3) ! 289.729 us  |            } /* irq_exit */
      gdmgreeter-3382  [002]   119.609387: softirq_entry: vec=1 [action=TIMER]
           pcscd-2849  [003]   119.609389:  3) ! 860.416 us  |          } /* smp_apic_timer_interrupt */
 3)   <========== |
      gdmgreeter-3382  [002]   119.609393:  2)   5.785 us    |                      preempt_schedule();


Keep the function graph output as is. You can still add the event
callbacks but do not remove the print_line of the function graph tracer.
That simply breaks what we worked hard to format nicely.

-- Steve


> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> ---
>  kernel/trace/trace.h                 |    3 ++-
>  kernel/trace/trace_functions_graph.c |   25 ++++++++++++++++++++++---
>  2 files changed, 24 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index b477fce..1feda87 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -490,7 +490,8 @@ extern int trace_clock_id;
>  
>  /* Standard output formatting function used for function return traces */
>  #ifdef CONFIG_FUNCTION_GRAPH_TRACER
> -extern enum print_line_t print_graph_function(struct trace_iterator *iter);
> +extern enum print_line_t print_graph_function(struct trace_iterator *iter,
> +					      int flags);
>  extern enum print_line_t
>  trace_print_graph_duration(unsigned long long duration, struct trace_seq *s);
>  
> diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
> index 616b135..41cec17 100644
> --- a/kernel/trace/trace_functions_graph.c
> +++ b/kernel/trace/trace_functions_graph.c
> @@ -38,7 +38,7 @@ struct fgraph_data {
>  #define TRACE_GRAPH_PRINT_OVERHEAD	0x4
>  #define TRACE_GRAPH_PRINT_PROC		0x8
>  #define TRACE_GRAPH_PRINT_DURATION	0x10
> -#define TRACE_GRAPH_PRINT_ABS_TIME	0X20
> +#define TRACE_GRAPH_PRINT_ABS_TIME	0x20
>  
>  static struct tracer_opt trace_opts[] = {
>  	/* Display overruns? (for self-debug purpose) */
> @@ -985,7 +985,7 @@ print_graph_comment(struct trace_seq *s,  struct trace_entry *ent,
>  
> 
>  enum print_line_t
> -print_graph_function(struct trace_iterator *iter)
> +print_graph_function(struct trace_iterator *iter, int flags)
>  {
>  	struct ftrace_graph_ent_entry *field;
>  	struct fgraph_data *data = iter->private;
> @@ -1143,6 +1143,16 @@ static void graph_trace_close(struct trace_iterator *iter)
>  	}
>  }
>  
> +static struct trace_event graph_trace_entry_event = {
> +	.type		= TRACE_GRAPH_ENT,
> +	.trace		= print_graph_function,
> +};
> +
> +static struct trace_event graph_trace_ret_event = {
> +	.type		= TRACE_GRAPH_RET,
> +	.trace		= print_graph_function,
> +};
> +
>  static struct tracer graph_trace __read_mostly = {
>  	.name		= "function_graph",
>  	.open		= graph_trace_open,
> @@ -1152,7 +1162,6 @@ static struct tracer graph_trace __read_mostly = {
>  	.wait_pipe	= poll_wait_pipe,
>  	.init		= graph_trace_init,
>  	.reset		= graph_trace_reset,
> -	.print_line	= print_graph_function,
>  	.print_header	= print_graph_headers,
>  	.flags		= &tracer_flags,
>  #ifdef CONFIG_FTRACE_SELFTEST
> @@ -1164,6 +1173,16 @@ static __init int init_graph_trace(void)
>  {
>  	max_bytes_for_cpu = snprintf(NULL, 0, "%d", nr_cpu_ids - 1);
>  
> +	if (!register_ftrace_event(&graph_trace_entry_event)) {
> +		pr_warning("Warning: could not register graph trace events\n");
> +		return 1;
> +	}
> +
> +	if (!register_ftrace_event(&graph_trace_ret_event)) {
> +		pr_warning("Warning: could not register graph trace events\n");
> +		return 1;
> +	}
> +
>  	return register_tracer(&graph_trace);
>  }
>  

