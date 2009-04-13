Return-Path: <linux-kernel-owner+w=401wt.eu-S1753114AbZDMON5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114AbZDMON5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 10:13:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750802AbZDMONr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 10:13:47 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:60404 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbZDMONr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 10:13:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=EKnTzXjDhweYJMu/ozbHEiogOVJQoAS0I3CnGtyq8CTg+0LD3EoBnfH5bPBgHhSED7
         KPh1S8gnPpnta72u9/XCA/kAM7p/etyWRWOETyWVKztRmXW6VoVjD23WJJpchz9Ss6rl
         luQa+2ypU5wI+U95giucjY9Ms77rBKMScMxCg=
Date: Mon, 13 Apr 2009 16:13:42 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] tracing, workqueuetrace: Make workqueue
	tracepoints use TRACE_EVENT macro
Message-ID: <20090413141341.GB5977@nowhere>
References: <49E28D00.2020803@cn.fujitsu.com> <49E28D4B.5040802@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E28D4B.5040802@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 13, 2009 at 08:54:35AM +0800, Zhaolei wrote:
> TRACE_EVENT is a more generic way to define tracepoints.
> Doing so adds these new capabilities to this tracepoint:
> 
>   - zero-copy and per-cpu splice() tracing
>   - binary tracing without printf overhead
>   - structured logging records exposed under /debug/tracing/events
>   - trace events embedded in function tracer output and other plugins
>   - user-defined, per tracepoint filter expressions
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> ---
>  include/trace/trace_event_types.h     |    1 +
>  include/trace/trace_events.h          |    1 +
>  include/trace/workqueue.h             |   19 +------
>  include/trace/workqueue_event_types.h |  101 +++++++++++++++++++++++++++++++++
>  4 files changed, 105 insertions(+), 17 deletions(-)
>  create mode 100644 include/trace/workqueue_event_types.h
> 
> diff --git a/include/trace/trace_event_types.h b/include/trace/trace_event_types.h
> index 552a50e..2babba4 100644
> --- a/include/trace/trace_event_types.h
> +++ b/include/trace/trace_event_types.h
> @@ -5,3 +5,4 @@
>  #include <trace/lockdep_event_types.h>
>  #include <trace/skb_event_types.h>
>  #include <trace/kmem_event_types.h>
> +#include <trace/workqueue_event_types.h>
> diff --git a/include/trace/trace_events.h b/include/trace/trace_events.h
> index 13d6b85..2e0f58c 100644
> --- a/include/trace/trace_events.h
> +++ b/include/trace/trace_events.h
> @@ -5,3 +5,4 @@
>  #include <trace/lockdep.h>
>  #include <trace/skb.h>
>  #include <trace/kmem.h>
> +#include <trace/workqueue.h>
> diff --git a/include/trace/workqueue.h b/include/trace/workqueue.h
> index 7626523..ecb58f4 100644
> --- a/include/trace/workqueue.h
> +++ b/include/trace/workqueue.h
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
> diff --git a/include/trace/workqueue_event_types.h b/include/trace/workqueue_event_types.h
> new file mode 100644
> index 0000000..ff65d47
> --- /dev/null
> +++ b/include/trace/workqueue_event_types.h
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
> +		__array(	char,			thread_comm,	TASK_COMM_LEN	)
> +		__field(	pid_t,			thread_pid			)
> +		__field(	struct work_struct *,	work				)
> +		__field(	work_func_t,		func				)
> +	),
> +
> +	TP_fast_assign(
> +		memcpy(__entry->thread_comm, wq_thread->comm, TASK_COMM_LEN);



This is not about your patch but I see this pattern happen often. We should
start think about a way to use tracing_record_cmdline for that.



> +		__entry->thread_pid	= wq_thread->pid;
> +		__entry->work		= work;
> +		__entry->func		= work->func;
> +	),
> +
> +	TP_printk("thread=%s:%d work=%p func=%p", __entry->thread_comm,



These pointer addresses are not very useful to display.
We can zap work and display the func as a %pF.

Not related to your patch: only the name of the func is useful,
not its asm offset. A format for raw func name without offset would
start to become very handy. I remember Andrew talked about that by the past.

I wonder which format we could use for that. %pf ?



> +		__entry->thread_pid, __entry->work, __entry->func)
> +);
> +
> +TRACE_EVENT(workqueue_execution,
> +
> +	TP_PROTO(struct task_struct *wq_thread, struct work_struct *work),
> +
> +	TP_ARGS(wq_thread, work),
> +
> +	TP_STRUCT__entry(
> +		__array(	char,			thread_comm,	TASK_COMM_LEN	)
> +		__field(	pid_t,			thread_pid			)
> +		__field(	struct work_struct *,	work				)
> +		__field(	work_func_t,		func				)
> +	),
> +
> +	TP_fast_assign(
> +		memcpy(__entry->thread_comm, wq_thread->comm, TASK_COMM_LEN);
> +		__entry->thread_pid	= wq_thread->pid;
> +		__entry->work		= work;
> +		__entry->func		= work->func;
> +	),
> +
> +	TP_printk("thread=%s:%d work=%p func=%p", __entry->thread_comm,


ditto.


> +		__entry->thread_pid, __entry->work, __entry->func)
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
> +		__array(	char,	thread_comm,	TASK_COMM_LEN	)
> +		__field(	pid_t,	thread_pid			)
> +		__field(	int,	cpu				)
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
> +		__array(	char,	thread_comm,	TASK_COMM_LEN	)
> +		__field(	pid_t,	thread_pid			)
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


But the rest looks fine.

Thanks!
Frederic.

