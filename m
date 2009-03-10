Return-Path: <linux-kernel-owner+w=401wt.eu-S1754023AbZCJIzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023AbZCJIzi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 04:55:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753027AbZCJIz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 04:55:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37168 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752539AbZCJIz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 04:55:27 -0400
Date: Tue, 10 Mar 2009 09:54:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
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
       Larry Woodman <lwoodman@redhat.com>, Jason Baron <jbaron@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Jiaying Zhang <jiayingz@google.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 4/7] tracing: new format for specialized trace points
Message-ID: <20090310085418.GB3097@elte.hu>
References: <20090310045710.286915983@goodmis.org> <20090310045811.279394388@goodmis.org> <20090310144700.A48E.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090310144700.A48E.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> Hi Steven,
> 
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
> Could you please write the documentation how to make new 
> tracepont and use various TP_ macro? Some developer (include 
> me) plan to add new tracepoint. but these macro usage is a bit 
> difficult.

Sure, here's a commented/annotated variant:

  /*
   * We define a tracepoint, its arguments, its printk format
   * and its 'fast binay record' layout.
   *
   * Firstly, name your tracepoint via TRACE_EVENT(name : the 
   * 'subsystem_event' notation is fine.
   *
   * Think about this whole construct as the 
   * 'trace_sched_switch() function' from now on.
   */
 
  TRACE_EVENT(sched_switch,

        /*
         * A function has a regular function arguments 
         * prototype, declare it via TP_PROTO():
         */
 	TP_PROTO(struct rq *rq, struct task_struct *prev,
 		 struct task_struct *next),
 
        /*
         * Define the call signature of the 'function'. 
	 * (Design sidenote: we use this instead of a
	 *  TP_PROTO1/TP_PROTO2/TP_PROTO3 ugliness.)
         */
 	TP_ARGS(rq, prev, next),
 
        /*
         * Fast binary tracing: define the trace record via 
         * TP_STRUCT__entry(). You can think about it like a 
         * regular C structure local variable definition.
         *
         * This is how the trace record is structured and will
         * be saved into the ring buffer. These are the fields
         * that will be exposed to user-space in 
         * /debug/tracing/events/*/format.
         *
         * The declared 'local variable' is called '__entry'
         */
 	TP_STRUCT__entry(
 		__array(	char,	prev_comm,	TASK_COMM_LEN	)
 		__field(	pid_t,	prev_pid			)
 		__field(	int,	prev_prio			)
 		__array(	char,	next_comm,	TASK_COMM_LEN	)
 		__field(	pid_t,	next_pid			)
 		__field(	int,	next_prio			)
 	),

        /*
         * Assign the entry into the trace record, by embedding 
         * a full C statement block into TP_fast_assign(). You 
         * can refer to the trace record as '__entry' - 
         * otherwise you can put arbitrary C code in here.
         *
         * Note: this C code will execute every time a trace event 
         * happens, on an active tracepoint.
         */
 	TP_fast_assign(
 		memcpy(__entry->next_comm, next->comm, TASK_COMM_LEN);
 		__entry->prev_pid	= prev->pid;
 		__entry->prev_prio	= prev->prio;
 		memcpy(__entry->prev_comm, prev->comm, TASK_COMM_LEN);
 		__entry->next_pid	= next->pid;
 		__entry->next_prio	= next->prio;
 	)

        /*
         * Formatted output of a trace record via TP_printk(). 
         * This is how the tracepoint will appear under ftrace 
         * plugins that make use of this tracepoint.
         *
         * (raw-binary tracing wont actually perform this step.)
         */
 	TP_printk("task %s:%d [%d] ==> %s:%d [%d]",
 		__entry->prev_comm, __entry->prev_pid, __entry->prev_prio,
 		__entry->next_comm, __entry->next_pid, __entry->next_prio),

  );

This macro construct is thus used for the regular printk format 
tracing setup, it is used to construct a function pointer based 
tracepoint callback (this is used by programmatic plugins and 
can also by used by generic instrumentation like SystemTap), and 
it is also used to expose a structured trace record in 
/debug/tracing/events/.

Steve: i flipped around TP_fast_assign() and TP_printk() in the 
example above because it makes more sense that way. (we first 
assign the record, then we print it out) I suspect we should 
flip it around in the code too.

	Ingo
