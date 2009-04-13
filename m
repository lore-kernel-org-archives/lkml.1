Return-Path: <linux-kernel-owner+w=401wt.eu-S1752923AbZDMQZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923AbZDMQZv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 12:25:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752626AbZDMQZl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 12:25:41 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:56954 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569AbZDMQZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 12:25:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RyDfruKDkh1dx7Xk7FeGUlkmXmdt/MVFlBN0hA6yvMUOYWnkvci6U9KxlYbc0ecKX3
         fm2DjedVwIP0YOlZ9/nlN8bHkP3It54UgBt6OBxVAt5Gm29LKnWVAaREs9y/q+hY9Sjt
         0yvlmSGR6qGA5CJnovrEfaug+qkIgl14JzDGE=
Date: Mon, 13 Apr 2009 18:25:36 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Zhaolei <zhaolei@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Tom Zanussi <tzanussi@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v2 2/4] ftrace: introduce workqueue_handler_exit
	tracepoint and rename workqueue_execution to workqueue_handler_entry
Message-ID: <20090413162534.GI5977@nowhere>
References: <20090413125653.6E01.A69D9226@jp.fujitsu.com> <20090413145105.6E07.A69D9226@jp.fujitsu.com> <20090413145159.6E0A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090413145159.6E0A.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 13, 2009 at 02:53:01PM +0900, KOSAKI Motohiro wrote:
> Subject: [PATCH] ftrace: introduce workqueue_handler_exit tracepoint and rename workqueue_execution to workqueue_handler_entry
> 
> Entry/exit handler pair is useful common tracepoint technique. it can mesure handler consumption time.
> 
> Then, workqueue also handler-exit tracepoint and rename execution to handler-entry.
> 
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Zhaolei <zhaolei@cn.fujitsu.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Tom Zanussi <tzanussi@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---
>  include/trace/workqueue_event_types.h |   25 ++++++++++++++++++++++++-
>  kernel/trace/trace_workqueue.c        |   10 +++++-----
>  kernel/workqueue.c                    |    6 ++++--
>  3 files changed, 33 insertions(+), 8 deletions(-)
> 
> Index: b/include/trace/workqueue_event_types.h
> ===================================================================
> --- a/include/trace/workqueue_event_types.h	2009-04-13 13:10:27.000000000 +0900
> +++ b/include/trace/workqueue_event_types.h	2009-04-13 13:10:27.000000000 +0900
> @@ -32,7 +32,7 @@ TRACE_EVENT(workqueue_insertion,
>  		__entry->thread_pid, __entry->func)
>  );
>  
> -TRACE_EVENT(workqueue_execution,
> +TRACE_EVENT(workqueue_handler_entry,
>  
>  	TP_PROTO(struct task_struct *wq_thread, struct work_struct *work),
>  
> @@ -56,6 +56,29 @@ TRACE_EVENT(workqueue_execution,
>  		__entry->thread_pid, __entry->func)
>  );
>  
> +TRACE_EVENT(workqueue_handler_exit,
> +	TP_PROTO(struct task_struct *wq_thread, struct work_struct *work),
> +
> +	TP_ARGS(wq_thread, work),
> +
> +	TP_STRUCT__entry(
> +		__array(char,			thread_comm, TASK_COMM_LEN)
> +		__field(pid_t,			thread_pid)
> +		__field(struct work_struct *,	work)
> +		__field(work_func_t,		func)
> +	),
> +
> +	TP_fast_assign(
> +		memcpy(__entry->thread_comm, wq_thread->comm, TASK_COMM_LEN);
> +		__entry->thread_pid	= wq_thread->pid;
> +		__entry->work		= work;
> +		__entry->func		= work->func;
> +	),
> +
> +	TP_printk("thread=%s:%d func=%pF", __entry->thread_comm,
> +		  __entry->thread_pid, __entry->func)
> +);
> +
>  /* Trace the creation of one workqueue thread on a cpu */
>  TRACE_EVENT(workqueue_creation,
>  
> Index: b/kernel/trace/trace_workqueue.c
> ===================================================================
> --- a/kernel/trace/trace_workqueue.c	2009-04-13 13:10:19.000000000 +0900
> +++ b/kernel/trace/trace_workqueue.c	2009-04-13 13:12:36.000000000 +0900
> @@ -65,7 +65,7 @@ found:
>  
>  /* Execution of a work */
>  static void
> -probe_workqueue_execution(struct task_struct *wq_thread,
> +probe_workqueue_entry(struct task_struct *wq_thread,
>  			  struct work_struct *work)
>  {
>  	int cpu = cpumask_first(&wq_thread->cpus_allowed);
> @@ -255,13 +255,13 @@ int __init trace_workqueue_early_init(vo
>  	if (ret)
>  		goto out;
>  
> -	ret = register_trace_workqueue_execution(probe_workqueue_execution);
> +	ret = register_trace_workqueue_handler_entry(probe_workqueue_entry);
>  	if (ret)
>  		goto no_insertion;
>  
>  	ret = register_trace_workqueue_creation(probe_workqueue_creation);
>  	if (ret)
> -		goto no_execution;
> +		goto no_handler_entry;
>  
>  	ret = register_trace_workqueue_destruction(probe_workqueue_destruction);
>  	if (ret)
> @@ -276,8 +276,8 @@ int __init trace_workqueue_early_init(vo
>  
>  no_creation:
>  	unregister_trace_workqueue_creation(probe_workqueue_creation);
> -no_execution:
> -	unregister_trace_workqueue_execution(probe_workqueue_execution);
> +no_handler_entry:
> +	unregister_trace_workqueue_handler_entry(probe_workqueue_entry);
>  no_insertion:
>  	unregister_trace_workqueue_insertion(probe_workqueue_insertion);
>  out:
> Index: b/kernel/workqueue.c
> ===================================================================
> --- a/kernel/workqueue.c	2009-04-13 13:06:36.000000000 +0900
> +++ b/kernel/workqueue.c	2009-04-13 13:14:15.000000000 +0900
> @@ -262,7 +262,8 @@ int queue_delayed_work_on(int cpu, struc
>  }
>  EXPORT_SYMBOL_GPL(queue_delayed_work_on);
>  
> -DEFINE_TRACE(workqueue_execution);
> +DEFINE_TRACE(workqueue_handler_entry);
> +DEFINE_TRACE(workqueue_handler_exit);
>  
>  static void run_workqueue(struct cpu_workqueue_struct *cwq)
>  {
> @@ -282,7 +283,6 @@ static void run_workqueue(struct cpu_wor
>  		 */
>  		struct lockdep_map lockdep_map = work->lockdep_map;
>  #endif
> -		trace_workqueue_execution(cwq->thread, work);
>  		cwq->current_work = work;
>  		list_del_init(cwq->worklist.next);
>  		spin_unlock_irq(&cwq->lock);
> @@ -291,7 +291,9 @@ static void run_workqueue(struct cpu_wor
>  		work_clear_pending(work);
>  		lock_map_acquire(&cwq->wq->lockdep_map);
>  		lock_map_acquire(&lockdep_map);
> +		trace_workqueue_handler_entry(cwq->thread, work);
>  		f(work);
> +		trace_workqueue_handler_exit(cwq->thread, work);
>  		lock_map_release(&lockdep_map);
>  		lock_map_release(&cwq->wq->lockdep_map);



Whatever we choose a per work or per workqueue latency measurement
(see my comment on the second patch) this patch makes sense.

Thanks!

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

(Also adding Oleg in Cc).

