Return-Path: <linux-kernel-owner+w=401wt.eu-S1754641AbZLBO20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641AbZLBO20 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 09:28:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754600AbZLBO2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 09:28:25 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:65087 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584AbZLBO2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 09:28:24 -0500
Subject: Re: [tip:perf/core] tracing: Add DEFINE_EVENT(),
 DEFINE_SINGLE_EVENT() support to docbook
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, mathieu.desnoyers@polymtl.ca,
       linux-kernel@vger.kernel.org, randy.dunlap@oracle.com,
       wcohen@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
       jbaron@redhat.com, mhiramat@redhat.com,
       linux-tip-commits@vger.kernel.org, Christoph Hellwig <hch@lst.de>
In-Reply-To: <20091202140128.GA2611@elte.hu>
References: <200912011718.nB1HIn7t011371@int-mx04.intmail.prod.int.phx2.redhat.com>
	 <tip-3a9089fd78367e2c6c815129030b790a0f5c2715@git.kernel.org>
	 <1259761934.12870.12.camel@gandalf.stny.rr.com>
	 <20091202140128.GA2611@elte.hu>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Wed, 02 Dec 2009 09:28:29 -0500
Message-Id: <1259764109.12870.37.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-02 at 15:01 +0100, Ingo Molnar wrote:

> >  DECLARE_CLASS_AND_DEFINE_EVENT()
> 
> Hm, that's a bit too long. How about 'DEFINE_CLASS_EVENT()' as a 
> compromise? It's similarly short-ish to TRACE_EVENT(), and it also 
> conveys the fact that we create both a class and an event there.
> 
> The full series would thus be:
> 
> 	DECLARE_EVENT_CLASS
> 	DEFINE_EVENT
> 	DEFINE_CLASS_EVENT
> 
> hm?

I thought about that too, but it actually makes it more confusing.
Because, looking at this with a fresh POV, I would think that after I
declare a class, I would use DEFINE_CLASS_EVENT with that class.

But that is looking at it out of context. Since the parameters show
exactly what is going on, it may be fine.

I really would like to get a comment from somebody not developing
tracers but using them. Because I think we are so ingrained in this,
that we have lost the outsider's POV.


So, with the above names, this is an example:

DECLARE_EVENT_CLASS(sched_wakeup_template,

        TP_PROTO(struct rq *rq, struct task_struct *p, int success),

        TP_ARGS(rq, p, success),

        TP_STRUCT__entry(
                __array(        char,   comm,   TASK_COMM_LEN   )
                __field(        pid_t,  pid                     )
                __field(        int,    prio                    )
                __field(        int,    success                 )
                __field(        int,    target_cpu              )
        ),

        TP_fast_assign(
                memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
                __entry->pid            = p->pid;
                __entry->prio           = p->prio;
                __entry->success        = success;
                __entry->target_cpu     = task_cpu(p);
        ),

        TP_printk("comm=%s pid=%d prio=%d success=%d target_cpu=%03d",
                  __entry->comm, __entry->pid, __entry->prio,
                  __entry->success, __entry->target_cpu)
);

DEFINE_EVENT(sched_wakeup_template, sched_wakeup,
             TP_PROTO(struct rq *rq, struct task_struct *p, int success),
             TP_ARGS(rq, p, success));

DEFINE_CLASS_EVENT(sched_switch,

        TP_PROTO(struct rq *rq, struct task_struct *prev,
                 struct task_struct *next),

        TP_ARGS(rq, prev, next),

        TP_STRUCT__entry(
                __array(        char,   prev_comm,      TASK_COMM_LEN   )
                __field(        pid_t,  prev_pid                        )
                __field(        int,    prev_prio                       )
                __field(        long,   prev_state                      )
                __array(        char,   next_comm,      TASK_COMM_LEN   )
                __field(        pid_t,  next_pid                        )
                __field(        int,    next_prio                       )
        ),

        TP_fast_assign(
                memcpy(__entry->next_comm, next->comm, TASK_COMM_LEN);
                __entry->prev_pid       = prev->pid;
                __entry->prev_prio      = prev->prio;
                __entry->prev_state     = prev->state;
                memcpy(__entry->prev_comm, prev->comm, TASK_COMM_LEN);
                __entry->next_pid       = next->pid;
                __entry->next_prio      = next->prio;
        ),

        TP_printk("prev_comm=%s prev_pid=%d prev_prio=%d prev_state=%s ==> next_comm=%s next_pid=%d next_prio=%d",
                __entry->prev_comm, __entry->prev_pid, __entry->prev_prio,
                __entry->prev_state ?
                  __print_flags(__entry->prev_state, "|",
                                { 1, "S"} , { 2, "D" }, { 4, "T" }, { 8, "t" },
                                { 16, "Z" }, { 32, "X" }, { 64, "x" },
                                { 128, "W" }) : "R",
                __entry->next_comm, __entry->next_pid, __entry->next_prio)
);

Anyone have any comments to whether or not the above is good or bad?

-- Steve


