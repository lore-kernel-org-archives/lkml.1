Return-Path: <linux-kernel-owner+w=401wt.eu-S1754851AbZAEQkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851AbZAEQkt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 11:40:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752592AbZAEQj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 11:39:56 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:47491 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754639AbZAEQjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 11:39:55 -0500
Date: Mon, 5 Jan 2009 11:39:52 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Rusty Russell <rusty@rustcorp.com.au>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpumask: convert kernel trace functions further
In-Reply-To: <200812300756.29716.rusty@rustcorp.com.au>
Message-ID: <alpine.DEB.1.10.0901051139040.27085@gandalf.stny.rr.com>
References: <200812300756.29716.rusty@rustcorp.com.au>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 30 Dec 2008, Rusty Russell wrote:

> Impact: Reduce future memory usage, use new cpumask API.
> 
> Since the last patch was created and acked, more old cpumask users
> slipped into kernel/trace.
> 
> Mostly trivial conversions, except struct trace_iterator's "started"
> member becomes a cpumask_var_t.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

In case this is needed:

Acked-by: Steven Rostedt <srostedt@redhat.com>

(just coming back from Holiday)

-- Steve

> ---
>  kernel/trace/trace.c                 |   12 +++++++++---
>  kernel/trace/trace.h                 |    2 +-
>  kernel/trace/trace_boot.c            |    2 +-
>  kernel/trace/trace_functions_graph.c |    2 +-
>  kernel/trace/trace_hw_branches.c     |    6 +++---
>  kernel/trace/trace_power.c           |    2 +-
>  6 files changed, 16 insertions(+), 10 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -1812,10 +1812,10 @@ static void test_cpu_buff_start(struct t
>  	if (!(iter->iter_flags & TRACE_FILE_ANNOTATE))
>  		return;
>  
> -	if (cpu_isset(iter->cpu, iter->started))
> +	if (cpumask_test_cpu(iter->cpu, iter->started))
>  		return;
>  
> -	cpu_set(iter->cpu, iter->started);
> +	cpumask_set_cpu(iter->cpu, iter->started);
>  	trace_seq_printf(s, "##### CPU %u buffer started ####\n", iter->cpu);
>  }
>  
> @@ -3115,10 +3115,15 @@ static int tracing_open_pipe(struct inod
>  	if (!iter)
>  		return -ENOMEM;
>  
> +	if (!alloc_cpumask_var(&iter->started, GFP_KERNEL)) {
> +		kfree(iter);
> +		return -ENOMEM;
> +	}
> +
>  	mutex_lock(&trace_types_lock);
>  
>  	/* trace pipe does not show start of buffer */
> -	cpus_setall(iter->started);
> +	cpumask_setall(iter->started);
>  
>  	iter->tr = &global_trace;
>  	iter->trace = current_trace;
> @@ -3135,6 +3140,7 @@ static int tracing_release_pipe(struct i
>  {
>  	struct trace_iterator *iter = file->private_data;
>  
> +	free_cpumask_var(iter->started);
>  	kfree(iter);
>  	atomic_dec(&tracing_reader);
>  
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -368,7 +368,7 @@ struct trace_iterator {
>  	loff_t			pos;
>  	long			idx;
>  
> -	cpumask_t		started;
> +	cpumask_var_t		started;
>  };
>  
>  int tracing_is_enabled(void);
> diff --git a/kernel/trace/trace_boot.c b/kernel/trace/trace_boot.c
> --- a/kernel/trace/trace_boot.c
> +++ b/kernel/trace/trace_boot.c
> @@ -42,7 +42,7 @@ static int boot_trace_init(struct trace_
>  	int cpu;
>  	boot_trace = tr;
>  
> -	for_each_cpu_mask(cpu, cpu_possible_map)
> +	for_each_cpu(cpu, cpu_possible_mask)
>  		tracing_reset(tr, cpu);
>  
>  	tracing_sched_switch_assign_trace(tr);
> diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
> --- a/kernel/trace/trace_functions_graph.c
> +++ b/kernel/trace/trace_functions_graph.c
> @@ -79,7 +79,7 @@ print_graph_cpu(struct trace_seq *s, int
>  	int i;
>  	int ret;
>  	int log10_this = log10_cpu(cpu);
> -	int log10_all = log10_cpu(cpus_weight_nr(cpu_online_map));
> +	int log10_all = log10_cpu(cpumask_weight(cpu_online_mask));
>  
>  
>  	/*
> diff --git a/kernel/trace/trace_hw_branches.c b/kernel/trace/trace_hw_branches.c
> --- a/kernel/trace/trace_hw_branches.c
> +++ b/kernel/trace/trace_hw_branches.c
> @@ -46,7 +46,7 @@ static void bts_trace_start(struct trace
>  
>  	tracing_reset_online_cpus(tr);
>  
> -	for_each_cpu_mask(cpu, cpu_possible_map)
> +	for_each_cpu(cpu, cpu_possible_mask)
>  		smp_call_function_single(cpu, bts_trace_start_cpu, NULL, 1);
>  }
>  
> @@ -62,7 +62,7 @@ static void bts_trace_stop(struct trace_
>  {
>  	int cpu;
>  
> -	for_each_cpu_mask(cpu, cpu_possible_map)
> +	for_each_cpu(cpu, cpu_possible_mask)
>  		smp_call_function_single(cpu, bts_trace_stop_cpu, NULL, 1);
>  }
>  
> @@ -172,7 +172,7 @@ static void trace_bts_prepare(struct tra
>  {
>  	int cpu;
>  
> -	for_each_cpu_mask(cpu, cpu_possible_map)
> +	for_each_cpu(cpu, cpu_possible_mask)
>  		smp_call_function_single(cpu, trace_bts_cpu, iter->tr, 1);
>  }
>  
> diff --git a/kernel/trace/trace_power.c b/kernel/trace/trace_power.c
> --- a/kernel/trace/trace_power.c
> +++ b/kernel/trace/trace_power.c
> @@ -39,7 +39,7 @@ static int power_trace_init(struct trace
>  
>  	trace_power_enabled = 1;
>  
> -	for_each_cpu_mask(cpu, cpu_possible_map)
> +	for_each_cpu(cpu, cpu_possible_mask)
>  		tracing_reset(tr, cpu);
>  	return 0;
>  }
> 
> 
