Return-Path: <linux-kernel-owner+w=401wt.eu-S1758656AbZBZDH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758656AbZBZDH3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 22:07:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752959AbZBZDHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 22:07:18 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:54879 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600AbZBZDHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 22:07:16 -0500
Date: Wed, 25 Feb 2009 22:07:10 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jason Baron <jbaron@redhat.com>, Martin Bligh <mbligh@google.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/2] tracing: rename DEFINE_TRACE_FMT to just
 TRACE_FORMAT
In-Reply-To: <20090225230742.GA21928@Krystal>
Message-ID: <alpine.DEB.2.00.0902252152090.12697@gandalf.stny.rr.com>
References: <20090225221304.097297742@goodmis.org> <20090225221345.005866537@goodmis.org> <20090225230742.GA21928@Krystal>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 25 Feb 2009, Mathieu Desnoyers wrote:

> * Steven Rostedt (rostedt@goodmis.org) wrote:
> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > There's been a bit confusion to whether DEFINE/DECLARE_TRACE_FMT should
> > be a DEFINE or a DECLARE. Ingo Molnar suggested simply calling it
> > TRACE_FORMAT.
> > 
> > Reported-by: Ingo Molnar <mingo@elte.hu>
> > Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> > ---
> >  include/linux/tracepoint.h        |    2 +-
> >  include/trace/sched_event_types.h |   26 +++++++++++++-------------
> >  kernel/trace/trace_events.h       |    4 ++--
> >  3 files changed, 16 insertions(+), 16 deletions(-)
> > 
> > diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
> > index 34ae464..3de09fa 100644
> > --- a/include/linux/tracepoint.h
> > +++ b/include/linux/tracepoint.h
> > @@ -153,7 +153,7 @@ static inline void tracepoint_synchronize_unregister(void)
> >  	synchronize_sched();
> >  }
> >  
> > -#define DEFINE_TRACE_FMT(name, proto, args, fmt)		\
> > +#define TRACE_FORMAT(name, proto, args, fmt)		\
> >  	DECLARE_TRACE(name, TPPROTO(proto), TPARGS(args))
> >  
> 
> Hi Steven,
> 
> Just to synchronize.. Does the tree you are basing your work on has both
> DEFINE_TRACE and DECLARE_TRACE ? If yes, then I think your TRACE_FORMAT
> should be put in the .c files (not in the headers) and add the format
> string to a supplementary tracepoint field (passed as a supplementary
> parameter to DEFINE_TRACE). Then this format string would become
> available to all tracers which connect to the tracepoints.

There is a DEFINE_TRACE. But those are nicely allocated in files spread
out in the kernel. For example, in kernel/sched.c:

DEFINE_TRACE(sched_wait_task);
DEFINE_TRACE(sched_wakeup);
DEFINE_TRACE(sched_wakeup_new);
DEFINE_TRACE(sched_switch);
DEFINE_TRACE(sched_migrate_task);

and in kernel/fork.c:

DEFINE_TRACE(sched_process_fork);

and in kernel/kthread.c:

DEFINE_TRACE(sched_kthread_stop);
DEFINE_TRACE(sched_kthread_stop_ret);


Since DECLARE_TRACE already has the proto type and names of the variables,
it is easier to work with them in the headers.

Note, any tracer can access these strings. That is what the event tracer 
does:

in kernel/trace/trace_event.h:

#undef DECLARE_TRACE_FMT
#define DECLARE_TRACE_FMT(call, proto, args, fmt, fmt_args)             \
static void ftrace_event_##call(proto)                                  \
{                                                                       \
        event_trace_printk(_RET_IP_, "(%s) " fmt "\n", #call, fmt_args); \
}                                                                       \
                                                                        \
static int ftrace_reg_event_##call(void)                                \
{                                                                       \
        int ret;                                                        \
                                                                        \
        ret = register_trace_##call(ftrace_event_##call);               \
        if (!ret)                                                       \
                pr_info("event trace: Could not activate trace point "  \
                        "probe to " #call);                             \
        return ret;                                                     \
}                                                                       \
                                                                        \
static void ftrace_unreg_event_##call(void)                             \
{                                                                       \
        unregister_trace_##call(ftrace_event_##call);                   \
}                                                                       \
                                                                        \
static struct ftrace_event_call __used                                  \
__attribute__((__aligned__(4)))                                         \
__attribute__((section("_ftrace_events"))) event_##call = {             \
        .name                   = #call,                                \
        .regfunc                = ftrace_reg_event_##call,              \
        .unregfunc              = ftrace_unreg_event_##call,            \
}

And now in events.c:

/* trace/<type>.h here */
#include <trace/sched.h>

#include "trace_events.h"

/* trace/<type>_event_types.h here */
#include <trace/sched_event_types.h>


This makes it very easy to tap into the events. Just by adding these 
headers, I automatically have the events registered, and the ability to 
read the trace points.


> 
> Your probe could then connect to the tracepoint just like any other
> probe, and use the new "format" string available in the tracepoint data
> structure.

But how would it know to read it? The idea is to automatically have the
trace point appear to the tracer, and not have to worry about how to
parse the string.

-- Steve

> 
> This format string would indeed be NULL if tracepoints are declared
> without any format string.
> 
> What do you think of this proposal ?
> 
> Mathieu
> 
> 
> >  #endif
> > diff --git a/include/trace/sched_event_types.h b/include/trace/sched_event_types.h
> > index a4f6629..a3d3d66 100644
> > --- a/include/trace/sched_event_types.h
> > +++ b/include/trace/sched_event_types.h
> > @@ -1,72 +1,72 @@
> >  
> >  /* use <trace/sched.h> instead */
> > -#ifndef DEFINE_TRACE_FMT
> > +#ifndef TRACE_FORMAT
> >  # error Do not include this file directly.
> >  # error Unless you know what you are doing.
> >  #endif
> >  
> > -DEFINE_TRACE_FMT(sched_kthread_stop,
> > +TRACE_FORMAT(sched_kthread_stop,
> >  	TPPROTO(struct task_struct *t),
> >  	TPARGS(t),
> >  	TPFMT("task %s:%d", t->comm, t->pid));
> >  
> > -DEFINE_TRACE_FMT(sched_kthread_stop_ret,
> > +TRACE_FORMAT(sched_kthread_stop_ret,
> >  	TPPROTO(int ret),
> >  	TPARGS(ret),
> >  	TPFMT("ret=%d", ret));
> >  
> > -DEFINE_TRACE_FMT(sched_wait_task,
> > +TRACE_FORMAT(sched_wait_task,
> >  	TPPROTO(struct rq *rq, struct task_struct *p),
> >  	TPARGS(rq, p),
> >  	TPFMT("task %s:%d", p->comm, p->pid));
> >  
> > -DEFINE_TRACE_FMT(sched_wakeup,
> > +TRACE_FORMAT(sched_wakeup,
> >  	TPPROTO(struct rq *rq, struct task_struct *p, int success),
> >  	TPARGS(rq, p, success),
> >  	TPFMT("task %s:%d %s",
> >  	      p->comm, p->pid, success?"succeeded":"failed"));
> >  
> > -DEFINE_TRACE_FMT(sched_wakeup_new,
> > +TRACE_FORMAT(sched_wakeup_new,
> >  	TPPROTO(struct rq *rq, struct task_struct *p, int success),
> >  	TPARGS(rq, p, success),
> >  	TPFMT("task %s:%d",
> >  	      p->comm, p->pid, success?"succeeded":"failed"));
> >  
> > -DEFINE_TRACE_FMT(sched_switch,
> > +TRACE_FORMAT(sched_switch,
> >  	TPPROTO(struct rq *rq, struct task_struct *prev,
> >  		struct task_struct *next),
> >  	TPARGS(rq, prev, next),
> >  	TPFMT("task %s:%d ==> %s:%d",
> >  	      prev->comm, prev->pid, next->comm, next->pid));
> >  
> > -DEFINE_TRACE_FMT(sched_migrate_task,
> > +TRACE_FORMAT(sched_migrate_task,
> >  	TPPROTO(struct task_struct *p, int orig_cpu, int dest_cpu),
> >  	TPARGS(p, orig_cpu, dest_cpu),
> >  	TPFMT("task %s:%d from: %d  to: %d",
> >  	      p->comm, p->pid, orig_cpu, dest_cpu));
> >  
> > -DEFINE_TRACE_FMT(sched_process_free,
> > +TRACE_FORMAT(sched_process_free,
> >  	TPPROTO(struct task_struct *p),
> >  	TPARGS(p),
> >  	TPFMT("task %s:%d", p->comm, p->pid));
> >  
> > -DEFINE_TRACE_FMT(sched_process_exit,
> > +TRACE_FORMAT(sched_process_exit,
> >  	TPPROTO(struct task_struct *p),
> >  	TPARGS(p),
> >  	TPFMT("task %s:%d", p->comm, p->pid));
> >  
> > -DEFINE_TRACE_FMT(sched_process_wait,
> > +TRACE_FORMAT(sched_process_wait,
> >  	TPPROTO(struct pid *pid),
> >  	TPARGS(pid),
> >  	TPFMT("pid %d", pid));
> >  
> > -DEFINE_TRACE_FMT(sched_process_fork,
> > +TRACE_FORMAT(sched_process_fork,
> >  	TPPROTO(struct task_struct *parent, struct task_struct *child),
> >  	TPARGS(parent, child),
> >  	TPFMT("parent %s:%d  child %s:%d",
> >  	      parent->comm, parent->pid, child->comm, child->pid));
> >  
> > -DEFINE_TRACE_FMT(sched_signal_send,
> > +TRACE_FORMAT(sched_signal_send,
> >  	TPPROTO(int sig, struct task_struct *p),
> >  	TPARGS(sig, p),
> >  	TPFMT("sig: %d   task %s:%d", sig, p->comm, p->pid));
> > diff --git a/kernel/trace/trace_events.h b/kernel/trace/trace_events.h
> > index cb8455b..deb95e5 100644
> > --- a/kernel/trace/trace_events.h
> > +++ b/kernel/trace/trace_events.h
> > @@ -17,8 +17,8 @@ struct ftrace_event_call {
> >  #undef TPFMT
> >  #define TPFMT(fmt, args...)	fmt "\n", ##args
> >  
> > -#undef DEFINE_TRACE_FMT
> > -#define DEFINE_TRACE_FMT(call, proto, args, fmt)			\
> > +#undef TRACE_FORMAT
> > +#define TRACE_FORMAT(call, proto, args, fmt)				\
> >  static void ftrace_event_##call(proto)					\
> >  {									\
> >  	event_trace_printk(_RET_IP_, "(" #call ") " fmt);		\
> > -- 
> > 1.5.6.5
> > 
> > -- 
> > 
> 
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> 
> 
