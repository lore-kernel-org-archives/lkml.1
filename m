Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968016Ab0B0I4M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 03:56:12 -0500
Received: from mail-ew0-f220.google.com ([209.85.219.220]:41839 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967989Ab0B0I4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 03:56:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IVVjxMaOZle0jJRrfeUqA5xgx1hD22Tq8jfkXPnskQVKmBnpkngt7QPTw5AauA8LX7
         NK5w9ulnWORMXsPsarOqik1n6XUk2Wqb2fLQwiAxSCfzc9I5snBi6u6jFOlyiXrOktfl
         s5lnmcexHXyWF2jdM1ILQy1S2t74okAo9k2PM=
Date: Sat, 27 Feb 2010 09:55:58 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Tim Bird <tim.bird@am.sony.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH][RFC] ftrace: add tracing_thresh support to
	function_graph tracer (v3)
Message-ID: <20100227085551.GA5130@nowhere>
References: <1267234355.6328.155.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267234355.6328.155.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 26, 2010 at 08:32:35PM -0500, Steven Rostedt wrote:
> Frederic,
> 
> Can you take look at this patch, and if you agree, can you give it your
> ACK?  Applying this on top of my pull request gives a nice output:
> 
> [root@bxrhel51 tracing]# echo 300 > tracing_thresh 
> [root@bxrhel51 tracing]# cat trace | head -30
> # tracer: function_graph
> #
> # CPU  DURATION                  FUNCTION CALLS
> # |     |   |                     |   |   |   |
>  1) ! 3630.044 us |          } (__dentry_open)
>  1) ! 3632.456 us |        } (nameidata_to_filp)
>  1) ! 3685.980 us |      } (do_filp_open)
>  1) ! 3701.625 us |    } (do_sys_open)
>  1) ! 3702.830 us |  } (sys_open)
>  ------------------------------------------
>  1)   bash-4190    =>   events/-16  
>  ------------------------------------------
> 
>  1) ! 4152.329 us |  } (schedule)
>  ------------------------------------------
>  1)   events/-16   =>   bash-4190   
>  ------------------------------------------
> 
>  1) ! 461.230 us  |            } (_raw_spin_unlock_irqrestore)
>  1) ! 466.865 us  |          } (tty_ldisc_try)
>  1) ! 468.948 us  |        } (tty_ldisc_ref_wait)
>  0) ! 333.541 us  |                  } (walk_tg_tree)
>  0) ! 339.638 us  |                } (update_shares)
>  0) ! 488.176 us  |              } (rebalance_domains)
>  0) ! 490.382 us  |            } (run_rebalance_domains)
>  0) ! 532.406 us  |          } (__do_softirq)
>  0) ! 536.246 us  |        } (do_softirq)
>  0) ! 540.842 us  |      } (irq_exit)
>  0) ! 593.286 us  |    } (smp_apic_timer_interrupt)



Cool!



> 
> 
> 
> (note, I forgot to update the changelog, I'll do that next)
> 
> -- Steve
> 
> 
> commit c020a9a11ec44e0c81f1aa16781d2d42c6c5e560
> Author: Tim Bird <tim.bird@am.sony.com>
> Date:   Thu Feb 25 15:36:43 2010 -0800
> 
>     ftrace: add tracing_thresh support to function_graph tracer (v3)
>     
>     Add support for tracing_thresh to the function_graph tracer.  This
>     version of this feature isolates the checks into new entry and
>     return functions, to avoid adding more conditional code into the
>     main function_graph paths.
>     
>     Also, add support for specifying tracing_thresh on the kernel
>     command line.  When used like so: "tracing_thresh=200 ftrace=function_graph"
>     this can be used to analyse system startup.  It is important to disable
>     tracing soon after boot, in order to avoid losing the trace data.
>     
>     Note: the elimination of 'notrace' in the definition of '__init'
>     may be controversial.  This can be removed, or made conditional,
>     if it's a bit too scary, but it worked OK for me.  Tracing during
>     kernel startup still works, just with no visibility of routines
>     declared __init.
>     
>     Signed-off-by: Tim Bird <tim.bird@am.sony.com>
>     LKML-Reference: <4B87098B.4040308@am.sony.com>
>     Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 032c57c..34ead59 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -374,6 +374,21 @@ static int __init set_buf_size(char *str)
>  }
>  __setup("trace_buf_size=", set_buf_size);
>  
> +static int __init set_tracing_thresh(char *str)
> +{
> +	unsigned long threshhold;
> +	int ret;
> +
> +	if (!str)
> +		return 0;
> +	ret = strict_strtoul(str, 0, &threshhold);
> +	if (ret < 0)
> +		return 0;
> +	tracing_thresh = threshhold * 1000;
> +	return 1;
> +}
> +__setup("tracing_thresh=", set_tracing_thresh);
> +
>  unsigned long nsecs_to_usecs(unsigned long nsecs)
>  {
>  	return nsecs / 1000;
> @@ -579,9 +594,10 @@ static ssize_t trace_seq_to_buffer(struct trace_seq *s, void *buf, size_t cnt)
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
> @@ -4248,10 +4264,10 @@ static __init int tracer_init_debugfs(void)
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
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index fd05bca..1bc8cd1 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -396,9 +396,10 @@ extern int process_new_ksym_entry(char *ksymname, int op, unsigned long addr);
>  
>  extern unsigned long nsecs_to_usecs(unsigned long nsecs);
>  
> +extern unsigned long tracing_thresh;
> +
>  #ifdef CONFIG_TRACER_MAX_TRACE
>  extern unsigned long tracing_max_latency;
> -extern unsigned long tracing_thresh;
>  
>  void update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu);
>  void update_max_tr_single(struct trace_array *tr,
> diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
> index e998a82..aaf580c 100644
> --- a/kernel/trace/trace_functions_graph.c
> +++ b/kernel/trace/trace_functions_graph.c
> @@ -237,6 +237,14 @@ int trace_graph_entry(struct ftrace_graph_ent *trace)
>  	return ret;
>  }
>  
> +int trace_graph_thresh_entry(struct ftrace_graph_ent *trace)
> +{
> +	if (tracing_thresh)
> +		return 1;
> +	else
> +		return trace_graph_entry(trace);
> +}
> +
>  static void __trace_graph_return(struct trace_array *tr,
>  				struct ftrace_graph_ret *trace,
>  				unsigned long flags,
> @@ -290,13 +298,26 @@ void set_graph_array(struct trace_array *tr)
>  	smp_mb();
>  }
>  
> +void trace_graph_thresh_return(struct ftrace_graph_ret *trace)
> +{
> +	if (tracing_thresh &&
> +	    (trace->rettime - trace->calltime < tracing_thresh))
> +		return;
> +	else
> +		trace_graph_return(trace);
> +}
> +
>  static int graph_trace_init(struct trace_array *tr)
>  {
>  	int ret;
>  
>  	set_graph_array(tr);
> -	ret = register_ftrace_graph(&trace_graph_return,
> -				    &trace_graph_entry);
> +	if (tracing_thresh)
> +		ret = register_ftrace_graph(&trace_graph_thresh_return,
> +					    &trace_graph_thresh_entry);
> +	else
> +		ret = register_ftrace_graph(&trace_graph_return,
> +					    &trace_graph_entry);
>  	if (ret)
>  		return ret;
>  	tracing_start_cmdline_record();
> 
> 


The parts that deal with the tracing_thresh file and the output
seem missing?

Other than that this all looks good to me.

Thanks.

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

