Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441Ab0BKXKl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 18:10:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4095 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757413Ab0BKXKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 18:10:39 -0500
Subject: Re: [PATCH 1/1] ftrace - add support for tracing_thresh to
 function_graph tracer
From: Steven Rostedt <srostedt@redhat.com>
To: Tim Bird <tim.bird@am.sony.com>
Cc: linux kernel <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <4B7338BF.1070505@am.sony.com>
References: <4B733721.3030503@am.sony.com>  <4B7338BF.1070505@am.sony.com>
Content-Type: text/plain
Organization: Red Hat
Date: Thu, 11 Feb 2010 18:10:31 -0500
Message-Id: <1265929831.2737.340.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-10 at 14:52 -0800, Tim Bird wrote:
> On 02/10/2010 02:45 PM, Tim Bird wrote:
> (a bunch of format_flowed garbage)
> 
> Sorry - I updated my mail client and forgot to disable the format_flowed
> option.
> 
> Here's the patch again, hopefully in better format this time.
> 
> This adds support for 'tracing_thresh' to the existing function_graph
> tracer.  When 'tracing_thresh' is in effect, function entry events are
> not stored - only function exits are stored.  This prevents filtered
> functions from filling up the log. An extra option is added to allow
> showing the function name with the exit event.  (Otherwise, all you
> get are closing braces.)
> 
> Note that the 'funcgraph-exit' display option is valuable by itself,
> since it makes the output much more 'grep-able'.
> 
> Signed-off-by: Tim Bird <tim.bird@am.sony.com>
> --
>  trace.c                 |    5 +++--
>  trace_functions_graph.c |   20 +++++++++++++++++++-
>  2 files changed, 22 insertions(+), 3 deletions(-)
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 0df1b0f..aa39f8e 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -502,9 +502,10 @@ static ssize_t trace_seq_to_buffer(struct trace_seq *s, void *buf, size_t cnt)
>  static arch_spinlock_t ftrace_max_lock =
>  	(arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
>  
> +unsigned long __read_mostly	tracing_thresh;
> +
>  #ifdef CONFIG_TRACER_MAX_TRACE
>  unsigned long __read_mostly	tracing_max_latency;
> -unsigned long __read_mostly	tracing_thresh;
>  
>  /*
>   * Copy the new maximum trace into the separate maximum-trace
> @@ -4176,10 +4177,10 @@ static __init int tracer_init_debugfs(void)
>  #ifdef CONFIG_TRACER_MAX_TRACE
>  	trace_create_file("tracing_max_latency", 0644, d_tracer,
>  			&tracing_max_latency, &tracing_max_lat_fops);
> +#endif
>  
>  	trace_create_file("tracing_thresh", 0644, d_tracer,
>  			&tracing_thresh, &tracing_max_lat_fops);
> -#endif
>  
>  	trace_create_file("README", 0444, d_tracer,
>  			NULL, &tracing_readme_fops);
> diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
> index b1342c5..e019e32 100644
> --- a/kernel/trace/trace_functions_graph.c
> +++ b/kernel/trace/trace_functions_graph.c
> @@ -39,6 +39,7 @@ struct fgraph_data {
>  #define TRACE_GRAPH_PRINT_PROC		0x8
>  #define TRACE_GRAPH_PRINT_DURATION	0x10
>  #define TRACE_GRAPH_PRINT_ABS_TIME	0X20
> +#define TRACE_GRAPH_PRINT_FUNC_EXIT	0X40
>  
>  static struct tracer_opt trace_opts[] = {
>  	/* Display overruns? (for self-debug purpose) */
> @@ -53,6 +54,8 @@ static struct tracer_opt trace_opts[] = {
>  	{ TRACER_OPT(funcgraph-duration, TRACE_GRAPH_PRINT_DURATION) },
>  	/* Display absolute time of an entry */
>  	{ TRACER_OPT(funcgraph-abstime, TRACE_GRAPH_PRINT_ABS_TIME) },
> +	/* Display function name on exit, instead of just closing brace */
> +	{ TRACER_OPT(funcgraph-exit, TRACE_GRAPH_PRINT_FUNC_EXIT) },
>  	{ } /* Empty entry */

I wonder if this should be enabled on start up of the function graph
tracer if the threshold is set?

Otherwise people will wonder WTF?

That's what I did when I tried it out and saw:

 2) + 64.633 us   |                }
 2) + 67.193 us   |              }
 ------------------------------------------
 2)  sendmai-3295  =>    <idle>-0   
 ------------------------------------------

 2) + 15.370 us   |                }
 2) + 25.633 us   |              }
 2) + 29.831 us   |            }
 2) + 36.641 us   |          }
 2) + 31.860 us   |              }
 2) + 33.669 us   |            }
 2) + 36.804 us   |          }
 2) + 79.140 us   |        }
 2)   <========== |
 2) + 81.486 us   |      }



I went back to read your change log and said, Oh! I missed that.

Turned it on, and now it is:

 1) ! 116.424 us  |    smp_apic_timer_interrupt();
 1)   <========== |
 1) ! 154948.1 us |  mwait_idle();
 1) + 17.456 us   |  tick_nohz_restart_sched_tick();
 ------------------------------------------
 1)    <idle>-0    =>   pcscd-3182  
 ------------------------------------------

 1) ! 998960.9 us |        schedule();
 1) ! 998973.3 us |      do_nanosleep();
 1) ! 998975.2 us |    hrtimer_nanosleep();
 1) ! 998977.6 us |  sys_nanosleep();
 1) + 31.927 us   |            link_path_walk();
 1) + 36.168 us   |          path_walk();


-- Steve

>  };
>  
> @@ -202,6 +205,8 @@ static int __trace_graph_entry(struct trace_array *tr,
>  	return 1;
>  }
>  
> +extern unsigned long __read_mostly tracing_thresh;
> +
>  int trace_graph_entry(struct ftrace_graph_ent *trace)
>  {
>  	struct trace_array *tr = graph_array;
> @@ -221,6 +226,10 @@ int trace_graph_entry(struct ftrace_graph_ent *trace)
>  	if (!ftrace_graph_addr(trace->func))
>  		return 0;
>  
> +	/* if tracing duration, only save function exits (omit function entries in log) */
> +	if (tracing_thresh)
> +		return 1;
> +
>  	local_irq_save(flags);
>  	cpu = raw_smp_processor_id();
>  	data = tr->data[cpu];
> @@ -254,6 +263,10 @@ static void __trace_graph_return(struct trace_array *tr,
>  	if (unlikely(__this_cpu_read(per_cpu_var(ftrace_cpu_disabled))))
>  		return;
>  
> +	if (tracing_thresh &&
> +		(trace->rettime - trace->calltime < tracing_thresh))
> +		return;
> +
>  	event = trace_buffer_lock_reserve(buffer, TRACE_GRAPH_RET,
>  					  sizeof(*entry), flags, pc);
>  	if (!event)
> @@ -891,7 +904,12 @@ print_graph_return(struct ftrace_graph_ret *trace, struct trace_seq *s,
>  			return TRACE_TYPE_PARTIAL_LINE;
>  	}
>  
> -	ret = trace_seq_printf(s, "}\n");
> +	if (tracer_flags.val & TRACE_GRAPH_PRINT_FUNC_EXIT) {
> +		ret = trace_seq_printf(s, "%ps();\n", (void *)trace->func);
> +	} else {
> +		ret = trace_seq_printf(s, "}\n");
> +	}
> +
>  	if (!ret)
>  		return TRACE_TYPE_PARTIAL_LINE;
>  
> 
> 
> 
> 

