Return-Path: <linux-kernel-owner+w=401wt.eu-S1754442AbZGFTRo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442AbZGFTRo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 15:17:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752851AbZGFTRh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 15:17:37 -0400
Received: from www.tglx.de ([62.245.132.106]:44657 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752719AbZGFTRg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 15:17:36 -0400
Date: Mon, 6 Jul 2009 21:17:02 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Zhaolei <zhaolei@cn.fujitsu.com>, kosaki.motohiro@jp.fujitsu.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/3] ftrace: add tracepoint for itimer
In-Reply-To: <4A51C6F9.3080100@cn.fujitsu.com>
Message-ID: <alpine.LFD.2.00.0907062104240.19480@localhost.localdomain>
References: <4A51C5C2.20802@cn.fujitsu.com> <4A51C6F9.3080100@cn.fujitsu.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Jul 2009, Xiao Guangrong wrote:
> +TRACE_EVENT(itimer_state,
> +
> +	TP_PROTO(int which, struct itimerval *value, cputime_t expires),
> +
> +	TP_ARGS(which, value, expires),
> +
> +	TP_STRUCT__entry(
> +		__field(	int,		which		)
> +		__field(	void *,		timer		)
> +		__field(	int,		state		)
> +		__field(	cputime_t,	expires		)
> +		__field(	long,		value_sec	)
> +		__field(	long,		value_usec	)
> +		__field(	long,		interval_sec	)
> +		__field(	long,		interval_usec	)
> +		__string(	comm,		current->comm	)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->which		= which;
> +		__entry->timer		= which == ITIMER_REAL ?
> +						&current->signal->real_timer : NULL;

  Why do we need this information at all ? There is no value in the
  address of real_timer AFAICT.
  
> +		__entry->state		= (value->it_value.tv_sec != 0 ||
> +					   value->it_value.tv_usec != 0) ? 1 : 0;

  Redundant information. You store the values anyway.

> +		__entry->expires	= which == ITIMER_REAL ? 0 : expires;

  Why not initializing "nval" in do_setitimer() to 0 and store it
  unconditionally in the trace.

> +		__entry->value_sec	= value->it_value.tv_sec;
> +		__entry->value_usec	= value->it_value.tv_usec;
> +		__entry->interval_sec	= value->it_interval.tv_sec;
> +		__entry->interval_usec	= value->it_interval.tv_usec;
> +		__assign_str(comm, current->comm);

  The tracer is recording current->comm already, so where is the value
  of another instance ?

> +TRACE_EVENT(itimer_expire,
> +
> +	TP_PROTO(int which, struct task_struct *task, struct pid *pid, cputime_t now),
> +
> +	TP_ARGS(which, task, pid, now),
> +
> +	TP_STRUCT__entry(
> +		__field(	int ,		which			)
> +		__field(	cputime_t,	now			)
> +		__array(	char,		comm,	TASK_COMM_LEN	)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->which	= which;
> +		__entry->now	= now;
> +		if (pid)
> +			strcpy(__entry->comm, pid_task(pid, PIDTYPE_PID)->comm);
> +		else
> +			strcpy(__entry->comm, task->comm);

  It's sufficient to store task->pid.

Thanks,

	tglx
