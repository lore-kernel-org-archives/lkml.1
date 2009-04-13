Return-Path: <linux-kernel-owner+w=401wt.eu-S1752367AbZDMOe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367AbZDMOe2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 10:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751975AbZDMOeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 10:34:19 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:52506 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbZDMOeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 10:34:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZyKmkyx6rX9gEWIUrYgFpDjZUGF8fYU02gwO9Smi2bkGKiNQ45BkdgQ/qVVJSiN+/Y
         cL6Nj3EnLlSbU2+PStCgf54sQK33WBzRc3xbZ/L/NsZcQI+cWhl+mbaEaQ0NJluhK2Ji
         +Wf0CMYAQ4kkvq1BLN1/cZsLGoxPsHS1KEeuo=
Date: Mon, 13 Apr 2009 16:34:14 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Zhaolei <zhaolei@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Tom Zanussi <tzanussi@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] tracing, workqueuetrace: Make workqueue
	tracepoints use TRACE_EVENT macro
Message-ID: <20090413143413.GE5977@nowhere>
References: <49E28D00.2020803@cn.fujitsu.com> <49E28D4B.5040802@cn.fujitsu.com> <20090413103639.6DF4.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090413103639.6DF4.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 13, 2009 at 10:44:27AM +0900, KOSAKI Motohiro wrote:
> Hi,
> 
> hehe, I also have similar patch in my local patch queue ;)
> 
> > +TRACE_EVENT(workqueue_insertion,
> > +
> > +	TP_PROTO(struct task_struct *wq_thread, struct work_struct *work),
> > +
> > +	TP_ARGS(wq_thread, work),
> > +
> > +	TP_STRUCT__entry(
> > +		__array(	char,			thread_comm,	TASK_COMM_LEN	)
> > +		__field(	pid_t,			thread_pid			)
> > +		__field(	struct work_struct *,	work				)
> > +		__field(	work_func_t,		func				)
> > +	),
> > +
> > +	TP_fast_assign(
> > +		memcpy(__entry->thread_comm, wq_thread->comm, TASK_COMM_LEN);
> > +		__entry->thread_pid	= wq_thread->pid;
> > +		__entry->work		= work;
> > +		__entry->func		= work->func;
> > +	),
> > +
> > +	TP_printk("thread=%s:%d work=%p func=%p", __entry->thread_comm,
> > +		__entry->thread_pid, __entry->work, __entry->func)
> > +);
> 
> please don't display raw kernel pointer.
> 
> work: unnecessary. it's internal information and func name provide enough
>       information.
> func: %pF can print pritty format



Ah, you already commented out it, sorry, I haven't seen you answer :)
(Reminder for me: always check the patches with threaded view).



> 
> 
> > +
> > +TRACE_EVENT(workqueue_execution,
> > +
> > +	TP_PROTO(struct task_struct *wq_thread, struct work_struct *work),
> > +
> > +	TP_ARGS(wq_thread, work),
> > +
> > +	TP_STRUCT__entry(
> > +		__array(	char,			thread_comm,	TASK_COMM_LEN	)
> > +		__field(	pid_t,			thread_pid			)
> > +		__field(	struct work_struct *,	work				)
> > +		__field(	work_func_t,		func				)
> > +	),
> > +
> > +	TP_fast_assign(
> > +		memcpy(__entry->thread_comm, wq_thread->comm, TASK_COMM_LEN);
> > +		__entry->thread_pid	= wq_thread->pid;
> > +		__entry->work		= work;
> > +		__entry->func		= work->func;
> > +	),
> > +
> > +	TP_printk("thread=%s:%d work=%p func=%p", __entry->thread_comm,
> > +		__entry->thread_pid, __entry->work, __entry->func)
> > +);
> 
> ditto.
> 
> and, I plan to rename this tracepoint to workqueue_handler_entry()
> and create workqueue_handler_exit().
>
> It's because stupid driver comsume many cputime in workqueue thread,
> it make delay to after work. We need mesure it.



Nice idea!

Frederic.

 
> 
> > +
> > +/* Trace the creation of one workqueue thread on a cpu */
> > +TRACE_EVENT(workqueue_creation,
> > +
> > +	TP_PROTO(struct task_struct *wq_thread, int cpu),
> > +
> > +	TP_ARGS(wq_thread, cpu),
> > +
> > +	TP_STRUCT__entry(
> > +		__array(	char,	thread_comm,	TASK_COMM_LEN	)
> > +		__field(	pid_t,	thread_pid			)
> > +		__field(	int,	cpu				)
> > +	),
> > +
> > +	TP_fast_assign(
> > +		memcpy(__entry->thread_comm, wq_thread->comm, TASK_COMM_LEN);
> > +		__entry->thread_pid	= wq_thread->pid;
> > +		__entry->cpu		= cpu;
> > +	),
> > +
> > +	TP_printk("thread=%s:%d cpu=%d", __entry->thread_comm,
> > +		__entry->thread_pid, __entry->cpu)
> > +);
> > +
> > +TRACE_EVENT(workqueue_destruction,
> > +
> > +	TP_PROTO(struct task_struct *wq_thread),
> > +
> > +	TP_ARGS(wq_thread),
> > +
> > +	TP_STRUCT__entry(
> > +		__array(	char,	thread_comm,	TASK_COMM_LEN	)
> > +		__field(	pid_t,	thread_pid			)
> > +	),
> > +
> > +	TP_fast_assign(
> > +		memcpy(__entry->thread_comm, wq_thread->comm, TASK_COMM_LEN);
> > +		__entry->thread_pid	= wq_thread->pid;
> > +	),
> > +
> > +	TP_printk("thread=%s:%d", __entry->thread_comm, __entry->thread_pid)
> > +);
> > +
> > +#undef TRACE_SYSTEM
> > -- 
> > 1.5.5.3
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
> 

