Return-Path: <linux-kernel-owner+w=401wt.eu-S1756583AbZDNVQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583AbZDNVQi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 17:16:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754492AbZDNVQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 17:16:29 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:35664 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292AbZDNVQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 17:16:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AFU6gO1fcXVZrO1iWN8pp6/aJFG65AgSjnh0jMAiLZlGB8cyycKA6fpY3PqWw7tCxx
         AI84VKOYmYA2CmmVEcHgY5yHP0BPVflVFcqc/LCJ44TykWpmWWqlbHpivY+0T9n3qDmK
         E1YznL9JFAfX3114ZsQ/QuodObxzQHVk51WDw=
Date: Tue, 14 Apr 2009 23:16:22 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Zhaolei <zhaolei@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Tom Zanussi <tzanussi@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 5/4] ftrace, workqueuetrace: display work name
Message-ID: <20090414211620.GB5968@nowhere>
References: <20090413125653.6E01.A69D9226@jp.fujitsu.com> <20090413145105.6E07.A69D9226@jp.fujitsu.com> <20090414125142.C63D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090414125142.C63D.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 01:03:35PM +0900, KOSAKI Motohiro wrote:
> 
> Frederic, What do you think this patch?
> ===============
> 
> Currently, event-tracer only display function name. it is enough useful.
> but some driver share work-function between multiple work_struct.
> then, work name displaying is better.
> 
> example output
> ------------------------------
> # tracer: nop
> #
> #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
> #              | |       |          |         |
>           <idle>-0     [003]  1540.844960: workqueue_insertion: thread=events/3:30 func=e1000_watchdog_task+0x0/0x6ae [e1000e] work=&adapter->watchdog_task
>           <idle>-0     [003]  1540.844964: workqueue_insertion: thread=events/3:30 func=vmstat_update+0x0/0x3f work=vmstat_work
>            <...>-30    [003]  1540.844969: workqueue_handler_entry: thread=events/3:30 latency=0ms func=e1000_watchdog_task+0x0/0x6ae [e1000e] work=&adapter-
> >watchdog_task
>            <...>-30    [003]  1540.845003: workqueue_handler_exit: thread=events/3:30 func=e1000_watchdog_task+0x0/0x6ae [e1000e] work=&adapter->watchdog_tas
> k
>            <...>-30    [003]  1540.845004: workqueue_handler_entry: thread=events/3:30 latency=0ms func=vmstat_update+0x0/0x3f work=vmstat_work
>            <...>-30    [003]  1540.845007: workqueue_handler_exit: thread=events/3:30 func=vmstat_update+0x0/0x3f work=vmstat_work
> 
> This patch increase kernel-size for work name string table.
> But actually, lockdep already have work name string table. then if you already use lockdep,
> you don't get kernel-size increasing by this patch.
> 
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Zhaolei <zhaolei@cn.fujitsu.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Tom Zanussi <tzanussi@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---


I don't know. Does it happen that frequently for a function to be used
by several works?
If so, this feature may be indeed interesting.

Thanks,
Frederic Weisbecker.



>  include/linux/workqueue.h             |   34 +++++++++++++++++++++++++++++++++-
>  include/trace/workqueue_event_types.h |   23 ++++++++++++++++-------
>  kernel/workqueue.c                    |    2 +-
>  3 files changed, 50 insertions(+), 9 deletions(-)
> 
> Index: b/include/linux/workqueue.h
> ===================================================================
> --- a/include/linux/workqueue.h	2009-04-14 11:57:05.000000000 +0900
> +++ b/include/linux/workqueue.h	2009-04-14 12:53:57.000000000 +0900
> @@ -22,6 +22,11 @@ typedef void (*work_func_t)(struct work_
>   */
>  #define work_data_bits(work) ((unsigned long *)(&(work)->data))
>  
> +#if defined(CONFIG_WORKQUEUE_TRACER) || defined(CONFIG_EVENT_TRACING)
> +#define HAVE_WORK_TRACE 1
> +#endif
> +
> +
>  struct work_struct {
>  	atomic_long_t data;
>  #define WORK_STRUCT_PENDING 0		/* T if work item pending execution */
> @@ -32,8 +37,9 @@ struct work_struct {
>  #ifdef CONFIG_LOCKDEP
>  	struct lockdep_map lockdep_map;
>  #endif
> -#ifdef CONFIG_WORKQUEUE_TRACER
> +#ifdef HAVE_WORK_TRACE
>  	unsigned long expected_time;
> +	char *name;
>  #endif
>  };
>  
> @@ -65,11 +71,19 @@ struct execute_work {
>  #define __WORK_INIT_LOCKDEP_MAP(n, k)
>  #endif
>  
> +#ifdef HAVE_WORK_TRACE
> +#define __WORK_INIT_NAME(_work, _name)				\
> +	.name = _name,
> +#else
> +#define __WORK_INIT_NAME(_work, _name)
> +#endif
> +
>  #define __WORK_INITIALIZER(n, f) {				\
>  	.data = WORK_DATA_INIT(),				\
>  	.entry	= { &(n).entry, &(n).entry },			\
>  	.func = (f),						\
>  	__WORK_INIT_LOCKDEP_MAP(#n, &(n))			\
> +	__WORK_INIT_NAME(&n, #n)				\
>  	}
>  
>  #define __DELAYED_WORK_INITIALIZER(n, f) {			\
> @@ -94,6 +108,18 @@ struct execute_work {
>  #define PREPARE_DELAYED_WORK(_work, _func)			\
>  	PREPARE_WORK(&(_work)->work, (_func))
>  
> +#ifdef HAVE_WORK_TRACE
> +#define SET_WORK_NAME(_work, _name)				\
> +	do {							\
> +		(_work)->name = (_name);			\
> +	} while (0)
> +
> +#else /*!HAVE_WORK_TRACE*/
> +#define SET_WORK_NAME(_work, name)
> +#endif /*!HAVE_WORK_TRACE*/
> +
> +
> +
>  /*
>   * initialize all of a work item in one go
>   *
> @@ -110,6 +136,7 @@ struct execute_work {
>  		lockdep_init_map(&(_work)->lockdep_map, #_work, &__key, 0);\
>  		INIT_LIST_HEAD(&(_work)->entry);			\
>  		PREPARE_WORK((_work), (_func));				\
> +		SET_WORK_NAME((_work), #_work);				\
>  	} while (0)
>  #else
>  #define INIT_WORK(_work, _func)						\
> @@ -117,6 +144,7 @@ struct execute_work {
>  		(_work)->data = (atomic_long_t) WORK_DATA_INIT();	\
>  		INIT_LIST_HEAD(&(_work)->entry);			\
>  		PREPARE_WORK((_work), (_func));				\
> +		SET_WORK_NAME((_work), #_work);				\
>  	} while (0)
>  #endif
>  
> @@ -124,24 +152,28 @@ struct execute_work {
>  	do {							\
>  		INIT_WORK(&(_work)->work, (_func));		\
>  		init_timer(&(_work)->timer);			\
> +		SET_WORK_NAME(&(_work)->work, #_work);		\
>  	} while (0)
>  
>  #define INIT_DELAYED_WORK_ON_STACK(_work, _func)		\
>  	do {							\
>  		INIT_WORK(&(_work)->work, (_func));		\
>  		init_timer_on_stack(&(_work)->timer);		\
> +		SET_WORK_NAME(&(_work)->work, #_work);		\
>  	} while (0)
>  
>  #define INIT_DELAYED_WORK_DEFERRABLE(_work, _func)			\
>  	do {							\
>  		INIT_WORK(&(_work)->work, (_func));		\
>  		init_timer_deferrable(&(_work)->timer);		\
> +		SET_WORK_NAME(&(_work)->work, #_work);		\
>  	} while (0)
>  
>  #define INIT_DELAYED_WORK_ON_STACK(_work, _func)		\
>  	do {							\
>  		INIT_WORK(&(_work)->work, (_func));		\
>  		init_timer_on_stack(&(_work)->timer);		\
> +		SET_WORK_NAME(&(_work)->work, #_work);		\
>  	} while (0)
>  
>  /**
> Index: b/include/trace/workqueue_event_types.h
> ===================================================================
> --- a/include/trace/workqueue_event_types.h	2009-04-14 11:57:05.000000000 +0900
> +++ b/include/trace/workqueue_event_types.h	2009-04-14 12:15:26.000000000 +0900
> @@ -19,6 +19,7 @@ TRACE_EVENT(workqueue_insertion,
>  		__field(pid_t,			thread_pid)
>  		__field(struct work_struct *,	work)
>  		__field(work_func_t,		func)
> +		__field(char*,			workname)
>  	),
>  
>  	TP_fast_assign(
> @@ -26,10 +27,12 @@ TRACE_EVENT(workqueue_insertion,
>  		__entry->thread_pid	= wq_thread->pid;
>  		__entry->work		= work;
>  		__entry->func		= work->func;
> +		__entry->workname	= work->name;
>  	),
>  
> -	TP_printk("thread=%s:%d func=%pF", __entry->thread_comm,
> -		__entry->thread_pid, __entry->func)
> +	TP_printk("thread=%s:%d func=%pF work=%s",
> +		  __entry->thread_comm, __entry->thread_pid,
> +		  __entry->func, __entry->workname)
>  );
>  
>  TRACE_EVENT(workqueue_handler_entry,
> @@ -45,6 +48,7 @@ TRACE_EVENT(workqueue_handler_entry,
>  		__field(work_func_t,		func)
>  		__field(unsigned long,		expected_time)
>  		__field(unsigned long,		actual_time)
> +		__field(char*,			workname)
>  	),
>  
>  	TP_fast_assign(
> @@ -54,12 +58,14 @@ TRACE_EVENT(workqueue_handler_entry,
>  		__entry->func		= work->func;
>  		__entry->expected_time	= work->expected_time;
>  		__entry->actual_time	= jiffies;
> +		__entry->workname	= work->name;
>  	),
>  
> -	TP_printk("thread=%s:%d latency=%lums func=%pF", __entry->thread_comm,
> -		  __entry->thread_pid,
> +	TP_printk("thread=%s:%d latency=%lums func=%pF work=%s",
> +		  __entry->thread_comm, __entry->thread_pid,
>  		  jiffies_to_msecs(__entry->actual_time-__entry->expected_time),
> -		  __entry->func)
> +		  __entry->func,
> +		  __entry->workname)
>  );
>  
>  TRACE_EVENT(workqueue_handler_exit,
> @@ -72,6 +78,7 @@ TRACE_EVENT(workqueue_handler_exit,
>  		__field(pid_t,			thread_pid)
>  		__field(struct work_struct *,	work)
>  		__field(work_func_t,		func)
> +		__field(char*,			workname)
>  	),
>  
>  	TP_fast_assign(
> @@ -79,10 +86,12 @@ TRACE_EVENT(workqueue_handler_exit,
>  		__entry->thread_pid	= wq_thread->pid;
>  		__entry->work		= work;
>  		__entry->func		= work->func;
> +		__entry->workname	= work->name;
>  	),
>  
> -	TP_printk("thread=%s:%d func=%pF", __entry->thread_comm,
> -		  __entry->thread_pid, __entry->func)
> +	TP_printk("thread=%s:%d func=%pF work=%s",
> +		  __entry->thread_comm, __entry->thread_pid,
> +		  __entry->func, __entry->workname)
>  );
>  
>  /* Trace the creation of one workqueue thread on a cpu */
> Index: b/kernel/workqueue.c
> ===================================================================
> --- a/kernel/workqueue.c	2009-04-14 11:57:05.000000000 +0900
> +++ b/kernel/workqueue.c	2009-04-14 11:59:52.000000000 +0900
> @@ -82,7 +82,7 @@ static const struct cpumask *cpu_singlet
>   */
>  static cpumask_var_t cpu_populated_map __read_mostly;
>  
> -#ifdef CONFIG_WORKQUEUE_TRACER
> +#if HAVE_WORK_TRACE
>  static void set_expected_time(struct work_struct *work,
>  			      unsigned long expected_jiffies)
>  {
> 
> 

