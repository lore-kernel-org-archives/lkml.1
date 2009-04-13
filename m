Return-Path: <linux-kernel-owner+w=401wt.eu-S1754065AbZDMBoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065AbZDMBoq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 21:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752970AbZDMBoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 21:44:37 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59218 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877AbZDMBog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 21:44:36 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Subject: Re: [PATCH 1/1] tracing, workqueuetrace: Make workqueue tracepoints use TRACE_EVENT macro
Cc: kosaki.motohiro@jp.fujitsu.com, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <49E28D4B.5040802@cn.fujitsu.com>
References: <49E28D00.2020803@cn.fujitsu.com> <49E28D4B.5040802@cn.fujitsu.com>
Message-Id: <20090413103639.6DF4.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Mon, 13 Apr 2009 10:44:27 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

hehe, I also have similar patch in my local patch queue ;)

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
> +		__entry->thread_pid	= wq_thread->pid;
> +		__entry->work		= work;
> +		__entry->func		= work->func;
> +	),
> +
> +	TP_printk("thread=%s:%d work=%p func=%p", __entry->thread_comm,
> +		__entry->thread_pid, __entry->work, __entry->func)
> +);

please don't display raw kernel pointer.

work: unnecessary. it's internal information and func name provide enough
      information.
func: %pF can print pritty format


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
> +		__entry->thread_pid, __entry->work, __entry->func)
> +);

ditto.

and, I plan to rename this tracepoint to workqueue_handler_entry()
and create workqueue_handler_exit().

It's because stupid driver comsume many cputime in workqueue thread,
it make delay to after work. We need mesure it.


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
> -- 
> 1.5.5.3
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



