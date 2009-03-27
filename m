Return-Path: <linux-kernel-owner+w=401wt.eu-S1761974AbZC0Wxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761974AbZC0Wxa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 18:53:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755878AbZC0WxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 18:53:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:58703 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758012AbZC0WxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 18:53:18 -0400
Date: Fri, 27 Mar 2009 18:53:13 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Jason Baron <jbaron@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, ltt-dev@lists.casi.polymtl.ca,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [patch 2/9] LTTng instrumentation - irq
In-Reply-To: <20090326182721.GA6399@Krystal>
Message-ID: <alpine.DEB.2.00.0903261435320.28807@gandalf.stny.rr.com>
References: <20090324155625.420966314@polymtl.ca> <20090324160148.080628193@polymtl.ca> <20090324173354.GC3129@redhat.com> <20090324175049.GC31117@elte.hu> <20090324175750.GE3129@redhat.com> <20090324191252.GA11665@elte.hu> <20090324201146.GA4350@Krystal>
 <alpine.DEB.2.00.0903242153080.22830@gandalf.stny.rr.com> <20090326182721.GA6399@Krystal>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 26 Mar 2009, Mathieu Desnoyers wrote:

> * Steven Rostedt (rostedt@goodmis.org) wrote:
> > 
> > On Tue, 24 Mar 2009, Mathieu Desnoyers wrote:
> > > 
> > > This is actually a very good example of what Christoph Hellwig, Peter
> > > Zijlstra and myself have been trying to warn you about the TRACE_EVENT
> > > macro : it exports the tracepoints to userspace, and thus makes them a
> > > userspace-visible API, when those tracepoints should be tied to the
> > > kernel code and nothing else. An adaptation layer should provide the
> > > abstractions that makes the information presented to the user more
> > > "logical".
> > 
> > Let me correct you here. TRACE_EVENT does ***NOT*** export anything to 
> > userspace. There is no code what so ever in TRACE_EVENT that does so.
> > 
> 
> Except the comment on top of TRACE_EVENT() in tracepoint.h maybe ?
> 
>  *      *
>  *      * Fast binary tracing: define the trace record via
>  *      * TP_STRUCT__entry(). You can think about it like a
>  *      * regular C structure local variable definition.
>  *      *
>  *      * This is how the trace record is structured and will
>  *      * be saved into the ring buffer. These are the fields
>  *      * that will be exposed to user-space in
>  *      * /debug/tracing/events/<*>/format.
> 
> You don't need to have code within the infrastructure to actually export
> stuff to userspace. Stating in the API that you some information will be
> presented to userspace counts.

That is done by ftrace not TRACE_EVENT.

> 
> > Now, ftrace does export information using TRACE_EVENT to userspace. But 
> > that is the way ftrace wants to handle it. There's nothing needed to 
> > export to userspace. What is exported, is exported ***BECAUSE*** it can 
> > change. I'll only try to keep the format that is exported the same. But 
> > nothing should rely on what the format represents staying the same.
> > 
> > If someone adds a TRACE_EVENT, you can uses it to record you data, anyway
> > you like. Ftrace will use it to show how to read the binary data, which
> > is only needed if you want to do that. It uses the print format to print
> > to the console in case of failure. Or to the trace file, which by the way
> > can also change without notice.
> 
> Hrm, so you are planning to add, in
> include/trace/sched_event_types.h, things like :
> 
> TRACE_EVENT(sched_kthread_stop,
> 
>         TP_PROTO(struct task_struct *t),
> 
>         TP_ARGS(t),
> 
>         TP_STRUCT__entry(
>                 __array(        char,   comm,   TASK_COMM_LEN   )
>                 __field(        pid_t,  pid                     )
>         ),
> 
>         TP_fast_assign(
>                 memcpy(__entry->comm, t->comm, TASK_COMM_LEN);
>                 __entry->pid    = t->pid;
>         ),
> 
>         TP_printk("task %s:%d", __entry->comm, __entry->pid)
> );
> 
> Actually specifying that the TP_STRUCT__entry, TP_fast_assign and
> TP_printk are specific to ftrace and should not be considered as a
> stable API, am I correct ?

No they are not specific to ftrace. I said they are used by ftrace.
They can be modified at will by the maintainer.  The macros makes the 
updates automatic for ftrace.

> 
> Then only when ftrace is built in the kernel do we have 
> kernel/trace/events.c including the holy include/trace/trace_events.h,
> which includes all the trace_events headers, and then including
> kernel/trace/trace_events_stage_{1,2,3}.h to override the TRACE_EVENT
> macro and create the callbacks for each TRACE_EVENT statements.

Currently ftrace is the only user of the include/trace/trace_events.h 
Others are welcome to do what they wish.

> 
> Then big problem with this is that, whether you like it or not, you
> *are* adding an API to the tracepoints, but just validating the types
> when ftrace is being built. If you want to add an API to the
> tracepoints, then the type verification should be done _even when ftrace
> is disabled_.

It's an internal API not a user space one. Internal APIs are fine, and can 
change whenever we want.

> 
> Therefore, the TRACE_EVENT in tracepoint.h should map to macros that
> would verify the argument types.

We could do that too.

> 
> I think it's ok to specify that the arguments of a given TRACE_EVENT may
> change without notice. We have to say it explicitly in the TRACE_EVENT
> header though.

Sure, I totally agree.

> 
> And while we talk about this, I also wonder why we won't simply embed
> the result of the TP_fast_assign and TP_printk in the tracepoint
> unlikely branch ? This would skip a function call in the tracing fast
> path, and would save the overhead of a whole function call when tracing
> is active. But that implies more bounds between tracepoints and data
> output, but given you are already declaring this in the same API, I
> don't see the problem anymore.

I'm not exactly what you mean here?  You mean to add it at the location in 
the code? If that is the case, I disagree. Since we don't want to clutter 
code with trace point data. It is nice to keep it out in separate headers.

This is what we also think about #ifdefs, it is better to have static 
inlines in headers that to clutter the code with them.

> 
> About the struct ftrace_raw_##name created in stage 1, I think the
> padding at the end of the structure is a complete waste of space. You
> should probably have a look at the ltt-type-serializer.[ch] in LTTng.

I don't know what padding you are talking about.

> 
> I am still unsure that the approach you take with TRACE_EVENT, which I
> would call "automatically generating code using header and macro
> tricks", is in the end easier to review than the simple C callback
> approach I have taken in LTTng, adding the "glue" in the
> DEFINE_MARKER_TP() macros to connect a specific C callback to the actual
> tracepoint.
> 
> The good thing about your approach is that everyting about a trace event
> can be declared within the same macro. In LTTng, I have to create probe
> modules and write stuff like :
> 
> void probe_irq_softirq_exit(struct softirq_action *h,
>         struct softirq_action *softirq_vec);
> 
> DEFINE_MARKER_TP(kernel, softirq_exit, irq_softirq_exit,
>         probe_irq_softirq_exit, "softirq_id #1u%lu");
> 
> void probe_irq_softirq_exit(struct softirq_action *h,
>         struct softirq_action *softirq_vec)
> {
>         struct marker *marker;
>         unsigned char data;
> 
>         data = ((unsigned long)h - (unsigned long)softirq_vec) / sizeof(*h);
> 
>         marker = &GET_MARKER(kernel, softirq_exit);
>         ltt_specialized_trace(marker, marker->single.probe_private,
>                 &data, sizeof(data), sizeof(data));
> }
> 
> by hand, and then the kernel softirq_exit event is shown in
> debugfs/ltt/markers/kernel/softirq_exit/. But I don't see the big win
> you get by doing it in TRACE_EVENT, especially if it is not
> type-verified when ftrace is disabled, compared to adding those
> callbacks in standard kernel modules, which is a coding-style we have
> been used to for years.

Well, I originally had it like you did above. But I found that if I did
that, the number of events would be greatly limited. Once I added this
infrastructure, a bunch of events were able to be made quickly.

As for the type checking, that should be easy to add. Don't need ftrace to 
do it.

-- Steve


> 
> I haven't seen much automatically generated code around in the kernel
> tree, maybe there is a good reason ? I can't wait to see the first
> kernel JIT based on ftrace. ;-)
> 
> Mathieu
> 
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> 
