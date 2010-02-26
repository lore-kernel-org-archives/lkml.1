Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935060Ab0BZCqJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 21:46:09 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42117 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934484Ab0BZCqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 21:46:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=E5DfbIKscXpkljLKzAB+tbCYTY+apWFbdljs565EiqGzK6rrCyUnEoTDZemr9AatAz
         nfJ4Ng0IJakxEX1njKp2tpzxy/Y6DUk+z25m13eKk1zH3dWEpQocYy+jXgVttNbUwDqL
         EFoY7IthI8y5L75zXNDWRegRHuaGHZdbaq9Bs=
Date: Fri, 26 Feb 2010 03:46:03 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tim Bird <tim.bird@am.sony.com>
Cc: Steven Rostedt <srostedt@redhat.com>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ftrace: add tracing_thresh support to function_graph
	tracer (v3)
Message-ID: <20100226024601.GG5592@nowhere>
References: <4B87098B.4040308@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B87098B.4040308@am.sony.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 25, 2010 at 03:36:43PM -0800, Tim Bird wrote:
> Add support for tracing_thresh to the function_graph tracer.  This
> version of this feature isolates the checks into new entry and
> return functions, to avoid adding more conditional code into the
> main function_graph paths.
> 
> Also, add support for specifying tracing_thresh on the kernel
> command line.  When used like so: "tracing_thresh=200 ftrace=function_graph"
> this can be used to analyse system startup.  It is important to disable
> tracing soon after boot, in order to avoid losing the trace data.
> 
> Note: the elimination of 'notrace' in the definition of '__init'
> may be controversial.  This can be removed, or made conditional,
> if it's a bit too scary, but it worked OK for me.  Tracing during
> kernel startup still works, just with no visibility of routines
> declared __init.


__init functions are notrace otherwise ftrace would hot patch
callsites of function that have disappeared.

That said, tracing __init functions is indeed interesting.
Perhaps we can handle that by removing the __init functions
from ftrace records each time we release init pages.


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



Looks like setting this, while the function graph tracer (normal
mode) is running, will have no effect. That said it's perfectly
fine as it would be pointless to change this value in the middle
of the tracing.



> +
>  unsigned long nsecs_to_usecs(unsigned long nsecs)
>  {
>  	return nsecs / 1000;
> @@ -502,9 +517,10 @@ static ssize_t trace_seq_to_buffer(struc
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
> @@ -4181,10 +4197,10 @@ static __init int tracer_init_debugfs(vo
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
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -396,9 +396,10 @@ extern int process_new_ksym_entry(char *
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
> --- a/kernel/trace/trace_functions_graph.c
> +++ b/kernel/trace/trace_functions_graph.c
> @@ -241,6 +241,14 @@ int trace_graph_entry(struct ftrace_grap
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
> @@ -287,13 +295,27 @@ void trace_graph_return(struct ftrace_gr
>  	local_irq_restore(flags);
>  }
> 
> +void trace_graph_thresh_return(struct ftrace_graph_ret *trace)
> +{
> +	if (tracing_thresh &&
> +		(trace->rettime - trace->calltime < tracing_thresh))
> +		return;
> +	else
> +		trace_graph_return(trace);
> +}
> +
>  static int graph_trace_init(struct trace_array *tr)
>  {
>  	int ret;
> 
>  	graph_array = tr;
> -	ret = register_ftrace_graph(&trace_graph_return,
> -				    &trace_graph_entry);
> +	if (tracing_thresh)
> +		ret = register_ftrace_graph(&trace_graph_thresh_return,
> +			    &trace_graph_thresh_entry);
> +	else
> +		ret = register_ftrace_graph(&trace_graph_return,
> +			    &trace_graph_entry);
> +
>  	if (ret)
>  		return ret;
>  	tracing_start_cmdline_record();
> @@ -891,7 +913,11 @@ print_graph_return(struct ftrace_graph_r
>  			return TRACE_TYPE_PARTIAL_LINE;
>  	}
> 
> -	ret = trace_seq_printf(s, "}\n");
> +	if (tracing_thresh) {
> +		ret = trace_seq_printf(s, "} (%ps)\n", (void *)trace->func);
> +	} else {
> +		ret = trace_seq_printf(s, "}\n");
> +	}



Ok, looks good to me.

Thanks.




>  	if (!ret)
>  		return TRACE_TYPE_PARTIAL_LINE;
> 
> 
> 

