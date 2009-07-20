Return-Path: <linux-kernel-owner+w=401wt.eu-S1754032AbZGTU02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032AbZGTU02 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 16:26:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752995AbZGTU00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 16:26:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:34525 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418AbZGTU0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 16:26:25 -0400
Date: Mon, 20 Jul 2009 16:26:24 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>,
       =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
Subject: Re: [PATCH] sched: Provide iowait counters
In-Reply-To: <1248120676.23509.41.camel@laptop>
Message-ID: <alpine.DEB.2.00.0907201622140.26208@gandalf.stny.rr.com>
References: <4A64B813.1080506@linux.intel.com>  <1248117369.23509.33.camel@laptop>  <alpine.DEB.2.00.0907201540550.26208@gandalf.stny.rr.com> <1248120676.23509.41.camel@laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 20 Jul 2009, Peter Zijlstra wrote:
> > 
> > How would the TRACE_EVENT look exactly? Would there be anything different 
> > in the trace point location itself?
> 
> Something like:
> 
> TRACE_EVENT(sched_iowait,
> 
> 	TP_PROTO(struct task_struct *p, u64 time),
> 
> 	TP_ARGS(p, time),
> 
> 	TP_STRUCT__entry(
> 		__field(pid_t, pid )
> 		__field(u64,   time)
> 	),
> 
> 	TP_fast_assign(
> 		__entry->pid	= p->pid;
> 		__entry->time	= time;
> 
> 		__perf_count(time);
> 	),
> 
> 	TP_printk("task %d waited for IO for %Lu ns",
> 		__entry->pid, __entry->time)
> );
> 
> Something like the below, except that its probably borken in interesting
> ways..
> 
> ---
>  include/trace/ftrace.h |   19 ++++++++++++++-----
>  kernel/perf_counter.c  |    6 +++---
>  2 files changed, 17 insertions(+), 8 deletions(-)
> 
> diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
> index 1867553..7e550a2 100644
> --- a/include/trace/ftrace.h
> +++ b/include/trace/ftrace.h
> @@ -447,11 +447,20 @@ static inline int ftrace_get_offsets_##call(				\
>  #define TP_FMT(fmt, args...)	fmt "\n", ##args
>  
>  #ifdef CONFIG_EVENT_PROFILE
> -#define _TRACE_PROFILE(call, proto, args)				\
> +
> +#undef __perf_addr
> +#define __perf_addr(a) addr = (a)
> +
> +#undef __perf_count
> +#define __perf_count(c) count = (c)
> +	
> +#define _TRACE_PROFILE(call, proto, args, assign)			\
>  static void ftrace_profile_##call(proto)				\
>  {									\
> -	extern void perf_tpcounter_event(int);				\
> -	perf_tpcounter_event(event_##call.id);				\
> +	extern void perf_tpcounter_event(int, u64, u64);		\
> +	u64 addr = 0, count = 1;					\
> +	{ assign; }							\
> +	perf_tpcounter_event(event_##call.id, addr, count);		\

The problem here is that the assign also will do the :

       TP_fast_assign(
               __entry->pid    = p->pid;
               __entry->time   = time;

part, thus you will probably get errors in processing the __entry part.

What about doing instead:

 TRACE_EVENT(sched_iowait,
 
 	TP_PROTO(struct task_struct *p, u64 time),
 
 	TP_ARGS(p, time),
 
 	TP_STRUCT__entry(
 		__field(pid_t, pid )
 		__field(u64,   time)
 	),
 
 	TP_fast_assign(
 		__entry->pid	= p->pid;
 		__entry->time	= time;
 
 	) __perf_count(time),

 	TP_printk("task %d waited for IO for %Lu ns",
 		__entry->pid, __entry->time)
 );
 
Then we could simply do:

#undef __perf_count
#define __perf_count(a)

[ do all the ftrace event work ]

#undef TP_fast_assign
#define TP_fast_assign(a...)

#undef __perf_count
#define __perf_count(c) count = (c);


-- Steve


>  }									\
>  									\
>  static int ftrace_profile_enable_##call(struct ftrace_event_call *event_call) \
> @@ -476,7 +485,7 @@ static void ftrace_profile_disable_##call(struct ftrace_event_call *event_call)\
>  	.profile_disable = ftrace_profile_disable_##call,
>  
>  #else
> -#define _TRACE_PROFILE(call, proto, args)
> +#define _TRACE_PROFILE(call, proto, args, assign)
>  #define _TRACE_PROFILE_INIT(call)
>  #endif
>  
> @@ -502,7 +511,7 @@ static void ftrace_profile_disable_##call(struct ftrace_event_call *event_call)\
>  
>  #undef TRACE_EVENT
>  #define TRACE_EVENT(call, proto, args, tstruct, assign, print)		\
> -_TRACE_PROFILE(call, PARAMS(proto), PARAMS(args))			\
> +_TRACE_PROFILE(call, PARAMS(proto), PARAMS(args), PARAMS(assign))	\
>  									\
>  static struct ftrace_event_call event_##call;				\
>  									\
> diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
> index 5498890..879a6ce 100644
> --- a/kernel/perf_counter.c
> +++ b/kernel/perf_counter.c
> @@ -3680,17 +3680,17 @@ static const struct pmu perf_ops_task_clock = {
>  };
>  
>  #ifdef CONFIG_EVENT_PROFILE
> -void perf_tpcounter_event(int event_id)
> +void perf_tpcounter_event(int event_id, u64 addr, u64 count)
>  {
>  	struct perf_sample_data data = {
>  		.regs = get_irq_regs(),
> -		.addr = 0,
> +		.addr = addr,
>  	};
>  
>  	if (!data.regs)
>  		data.regs = task_pt_regs(current);
>  
> -	do_perf_swcounter_event(PERF_TYPE_TRACEPOINT, event_id, 1, 1, &data);
> +	do_perf_swcounter_event(PERF_TYPE_TRACEPOINT, event_id, count, 1, &data);
>  }
>  EXPORT_SYMBOL_GPL(perf_tpcounter_event);
>  
> 
> 
> 
