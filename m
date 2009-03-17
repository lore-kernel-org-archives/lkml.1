Return-Path: <linux-kernel-owner+w=401wt.eu-S1754665AbZCQPlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665AbZCQPlU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 11:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753851AbZCQPlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 11:41:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:39185 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118AbZCQPlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 11:41:09 -0400
Date: Tue, 17 Mar 2009 11:41:05 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Christoph Hellwig <hch@infradead.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       "Martin J. Bligh" <mbligh@mbligh.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Larry Woodman <lwoodman@redhat.com>, Jason Baron <jbaron@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Jiaying Zhang <jiayingz@google.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 4/7] tracing: new format for specialized trace points
In-Reply-To: <20090317080801.GB9960@infradead.org>
Message-ID: <alpine.DEB.2.00.0903171136090.10274@gandalf.stny.rr.com>
References: <20090310045710.286915983@goodmis.org> <20090310045811.279394388@goodmis.org> <20090317080801.GB9960@infradead.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 17 Mar 2009, Christoph Hellwig wrote:

> On Tue, Mar 10, 2009 at 12:57:14AM -0400, Steven Rostedt wrote:
> > Here's the example. The only updated macro in this patch is the
> > sched_switch trace point.
> 
> Note that we shouldn't keep two variants around long-term, that's
> just going to cause confusion.
> 
> > The old method looked like this:
> > 
> >  TRACE_EVENT_FORMAT(sched_switch,
> >         TP_PROTO(struct rq *rq, struct task_struct *prev,
> >                 struct task_struct *next),
> >         TP_ARGS(rq, prev, next),
> >         TP_FMT("task %s:%d ==> %s:%d",
> >               prev->comm, prev->pid, next->comm, next->pid),
> >         TRACE_STRUCT(
> >                 TRACE_FIELD(pid_t, prev_pid, prev->pid)
> >                 TRACE_FIELD(int, prev_prio, prev->prio)
> >                 TRACE_FIELD_SPECIAL(char next_comm[TASK_COMM_LEN],
> >                                     next_comm,
> >                                     TP_CMD(memcpy(TRACE_ENTRY->next_comm,
> >                                                  next->comm,
> >                                                  TASK_COMM_LEN)))
> >                 TRACE_FIELD(pid_t, next_pid, next->pid)
> >                 TRACE_FIELD(int, next_prio, next->prio)
> >         ),
> >         TP_RAW_FMT("prev %d:%d ==> next %s:%d:%d")
> >         );
> > 
> > The above method is hard to read and requires two format fields.
> > 
> > The new method:
> > 
> >  /*
> >   * Tracepoint for task switches, performed by the scheduler:
> >   *
> >   * (NOTE: the 'rq' argument is not used by generic trace events,
> >   *        but used by the latency tracer plugin. )
> >   */
> >  TRACE_EVENT(sched_switch,
> > 
> > 	TP_PROTO(struct rq *rq, struct task_struct *prev,
> > 		 struct task_struct *next),
> > 
> > 	TP_ARGS(rq, prev, next),
> > 
> > 	TP_STRUCT__entry(
> > 		__array(	char,	prev_comm,	TASK_COMM_LEN	)
> > 		__field(	pid_t,	prev_pid			)
> > 		__field(	int,	prev_prio			)
> > 		__array(	char,	next_comm,	TASK_COMM_LEN	)
> > 		__field(	pid_t,	next_pid			)
> > 		__field(	int,	next_prio			)
> > 	),
> > 
> > 	TP_printk("task %s:%d [%d] ==> %s:%d [%d]",
> > 		__entry->prev_comm, __entry->prev_pid, __entry->prev_prio,
> > 		__entry->next_comm, __entry->next_pid, __entry->next_prio),
> > 
> > 	TP_fast_assign(
> > 		memcpy(__entry->next_comm, next->comm, TASK_COMM_LEN);
> > 		__entry->prev_pid	= prev->pid;
> > 		__entry->prev_prio	= prev->prio;
> > 		memcpy(__entry->prev_comm, prev->comm, TASK_COMM_LEN);
> > 		__entry->next_pid	= next->pid;
> > 		__entry->next_prio	= next->prio;
> > 	)
> >  );
> 
> While the idea behing it seems like an improvement to me, the
> implementation feel actually worse than the old one too me.  I would
> expect this to look more like:
> 
> struct trace_sched_switch {
> 	char	prev_comm[TASK_COMM_LEN],
> 	pid_t	prev_pid,
> 	int	prev_prio,
> 	char	next_comm[TASK_COMM_LEN],
> 	pid_t	next_pid,
> 	int	next_prio,
> }

We would love to do the above. The problem is that we also need a way
to automatically export the fields offset/size to userspace. Thus we use
the "__field()" and "__array()" macros to do this for us. Otherwise, we 
need to do that manually.


> 
> static void trace_sched_assign(struct trace_sched_switch *dst, struct rq *rq,
> 		struct task_struct *prev, struct task_struct *next)
> {
> 	memcpy(dst->next_comm, next->comm, TASK_COMM_LEN);
> 	dst->prev_pid	= prev->pid;
> 	dst->prev_prio	= prev->prio;
> 	memcpy(dst->prev_comm, prev->comm, TASK_COMM_LEN);
> 	dst->next_pid	= next->pid;
> 	dst->next_prio	= next->prio;
> };

This we could take out of the macro and make a function.

-- Steve

> 
> 
> TRACE_EVENT(sched_switch,
> 	trace_proto(struct rq *rq, struct task_struct *prev,
>  		    struct task_struct *next),
> 	trace_args(rq, prev, next),
> 	trace_struct(struct trace_sched_switch),
> 	trace_assign(trace_sched_assign);
> 
> 	trace_pretty_print("task %s:%d [%d] ==> %s:%d [%d]",
> 		__entry->prev_comm, __entry->prev_pid, __entry->prev_prio,
> 		__entry->next_comm, __entry->next_pid, __entry->next_prio),
> );
> 
> 
