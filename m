Return-Path: <linux-kernel-owner+w=401wt.eu-S1754254AbZDMPY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254AbZDMPY2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 11:24:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752225AbZDMPYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 11:24:20 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:42343 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbZDMPYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 11:24:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OzbkFK9l+1c7nNqOUhcfy/2LDnGRkx5D+KHYsTZwsOVTYqG3xQn1XFeAxEaugFY9qQ
         tED/j4bD2GDXapfro42n1A+7MQ8tGily1Gs/YbfbkfIV3T7zC1nGm2x2OUqNlMgJn29/
         e91jvMbSxyvFEXavGprAIBWM8ticyDby9Ij6E=
Date: Mon, 13 Apr 2009 17:24:14 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Zhaolei <zhaolei@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Tom Zanussi <tzanussi@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/4] ftrace, workqueuetrace: Make workqueue
	tracepoints use TRACE_EVENT macro
Message-ID: <20090413152412.GG5977@nowhere>
References: <49E2B656.1020308@cn.fujitsu.com> <20090413125653.6E01.A69D9226@jp.fujitsu.com> <20090413145105.6E07.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090413145105.6E07.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 13, 2009 at 02:52:05PM +0900, KOSAKI Motohiro wrote:
> From: Zhao Lei <zhaolei@cn.fujitsu.com>
> Subject: [PATCH v2] ftrace, workqueuetrace: Make workqueue tracepoints use TRACE_EVENT macro
> 
> TRACE_EVENT is a more generic way to define tracepoints.
> Doing so adds these new capabilities to this tracepoint:
> 
>   - zero-copy and per-cpu splice() tracing
>   - binary tracing without printf overhead
>   - structured logging records exposed under /debug/tracing/events
>   - trace events embedded in function tracer output and other plugins
>   - user-defined, per tracepoint filter expressions
> 
> Then, this patch convert DEFINE_TRACE to TRACE_EVENT in workqueue related tracepoint.
> 


Kosaki-san, you might also want to credit your changes in this patch.
Something like:

[v2: kosaki@jp.fujitsu.com: print the function names instead of addr, and
zap the work addr]


 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> Signed-off-by: KOSAKI Motohiro <kosaki@jp.fujitsu.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Tom Zanussi <tzanussi@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---
>  include/trace/trace_event_types.h     |    1 
>  include/trace/trace_events.h          |    1 
>  include/trace/workqueue.h             |   19 ------
>  include/trace/workqueue_event_types.h |  101 ++++++++++++++++++++++++++++++++++
>  4 files changed, 105 insertions(+), 17 deletions(-)
>  create mode 100644 include/trace/workqueue_event_types.h
> 
> Index: b/include/trace/trace_event_types.h
> ===================================================================
> --- a/include/trace/trace_event_types.h	2009-04-13 12:11:00.000000000 +0900
> +++ b/include/trace/trace_event_types.h	2009-04-13 12:18:56.000000000 +0900
> @@ -5,3 +5,4 @@
>  #include <trace/lockdep_event_types.h>
>  #include <trace/skb_event_types.h>
>  #include <trace/kmem_event_types.h>
> +#include <trace/workqueue_event_types.h>
> Index: b/include/trace/trace_events.h
> ===================================================================
> --- a/include/trace/trace_events.h	2009-04-13 12:11:00.000000000 +0900
> +++ b/include/trace/trace_events.h	2009-04-13 12:18:56.000000000 +0900
> @@ -5,3 +5,4 @@
>  #include <trace/lockdep.h>
>  #include <trace/skb.h>
>  #include <trace/kmem.h>
> +#include <trace/workqueue.h>
> Index: b/include/trace/workqueue.h
> ===================================================================
> --- a/include/trace/workqueue.h	2009-04-13 12:08:59.000000000 +0900
> +++ b/include/trace/workqueue.h	2009-04-13 12:18:56.000000000 +0900
> @@ -1,25 +1,10 @@
>  #ifndef __TRACE_WORKQUEUE_H
>  #define __TRACE_WORKQUEUE_H
>  
> -#include <linux/tracepoint.h>
>  #include <linux/workqueue.h>
>  #include <linux/sched.h>
> +#include <linux/tracepoint.h>
>  
> -DECLARE_TRACE(workqueue_insertion,
> -	   TP_PROTO(struct task_struct *wq_thread, struct work_struct *work),
> -	   TP_ARGS(wq_thread, work));
> -
> -DECLARE_TRACE(workqueue_execution,
> -	   TP_PROTO(struct task_struct *wq_thread, struct work_struct *work),
> -	   TP_ARGS(wq_thread, work));
> -
> -/* Trace the creation of one workqueue thread on a cpu */
> -DECLARE_TRACE(workqueue_creation,
> -	   TP_PROTO(struct task_struct *wq_thread, int cpu),
> -	   TP_ARGS(wq_thread, cpu));
> -
> -DECLARE_TRACE(workqueue_destruction,
> -	   TP_PROTO(struct task_struct *wq_thread),
> -	   TP_ARGS(wq_thread));
> +#include <trace/workqueue_event_types.h>
>  
>  #endif /* __TRACE_WORKQUEUE_H */
> Index: b/include/trace/workqueue_event_types.h
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ b/include/trace/workqueue_event_types.h	2009-04-13 12:25:16.000000000 +0900
> @@ -0,0 +1,101 @@
> +
> +/* use <trace/workqueue.h> instead */
> +#ifndef TRACE_EVENT
> +# error Do not include this file directly.
> +# error Unless you know what you are doing.
> +#endif
> +
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM workqueue
> +
> +TRACE_EVENT(workqueue_insertion,
> +
> +	TP_PROTO(struct task_struct *wq_thread, struct work_struct *work),
> +
> +	TP_ARGS(wq_thread, work),
> +
> +	TP_STRUCT__entry(
> +		__array(char,			thread_comm,	TASK_COMM_LEN)
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
> +		__entry->thread_pid, __entry->func)
> +);
> +
> +TRACE_EVENT(workqueue_execution,
> +
> +	TP_PROTO(struct task_struct *wq_thread, struct work_struct *work),
> +
> +	TP_ARGS(wq_thread, work),
> +
> +	TP_STRUCT__entry(
> +		__array(char,			thread_comm,	TASK_COMM_LEN)
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
> +		__entry->thread_pid, __entry->func)
> +);
> +
> +/* Trace the creation of one workqueue thread on a cpu */
> +TRACE_EVENT(workqueue_creation,
> +
> +	TP_PROTO(struct task_struct *wq_thread, int cpu),
> +
> +	TP_ARGS(wq_thread, cpu),
> +
> +	TP_STRUCT__entry(
> +		__array(char,	thread_comm,	TASK_COMM_LEN)
> +		__field(pid_t,	thread_pid)
> +		__field(int,	cpu)
> +	),
> +
> +	TP_fast_assign(
> +		memcpy(__entry->thread_comm, wq_thread->comm, TASK_COMM_LEN);
> +		__entry->thread_pid	= wq_thread->pid;
> +		__entry->cpu		= cpu;
> +	),
> +
> +	TP_printk("thread=%s:%d cpu=%d", __entry->thread_comm,
> +		__entry->thread_pid, __entry->cpu)
> +);
> +
> +TRACE_EVENT(workqueue_destruction,
> +
> +	TP_PROTO(struct task_struct *wq_thread),
> +
> +	TP_ARGS(wq_thread),
> +
> +	TP_STRUCT__entry(
> +		__array(char,	thread_comm,	TASK_COMM_LEN)
> +		__field(pid_t,	thread_pid)
> +	),
> +
> +	TP_fast_assign(
> +		memcpy(__entry->thread_comm, wq_thread->comm, TASK_COMM_LEN);
> +		__entry->thread_pid	= wq_thread->pid;
> +	),
> +
> +	TP_printk("thread=%s:%d", __entry->thread_comm, __entry->thread_pid)
> +);
> +
> +#undef TRACE_SYSTEM
> 
> 


Thank you both!

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

