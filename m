Return-Path: <linux-kernel-owner+w=401wt.eu-S1764741AbZDBCr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764741AbZDBCr4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 22:47:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753327AbZDBCrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 22:47:47 -0400
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:55249 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753307AbZDBCrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 22:47:45 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmEFAG/B00lMQW1W/2dsb2JhbACBUs0ngj+BPgY
Date: Wed, 1 Apr 2009 22:42:39 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
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
Message-ID: <20090402024239.GA18557@Krystal>
References: <20090324155625.420966314@polymtl.ca> <20090324160148.080628193@polymtl.ca> <20090324173354.GC3129@redhat.com> <20090324175049.GC31117@elte.hu> <20090324175750.GE3129@redhat.com> <20090324191252.GA11665@elte.hu> <20090324201146.GA4350@Krystal> <alpine.DEB.2.00.0903242153080.22830@gandalf.stny.rr.com> <20090326182721.GA6399@Krystal> <alpine.DEB.2.00.0903261435320.28807@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0903261435320.28807@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 22:19:05 up 32 days, 22:45,  1 user,  load average: 0.09, 0.10,
	0.10
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> On Thu, 26 Mar 2009, Mathieu Desnoyers wrote:
> 
> > * Steven Rostedt (rostedt@goodmis.org) wrote:
> > > 
> > > On Tue, 24 Mar 2009, Mathieu Desnoyers wrote:
> > > > 
> > > > This is actually a very good example of what Christoph Hellwig, Peter
> > > > Zijlstra and myself have been trying to warn you about the TRACE_EVENT
> > > > macro : it exports the tracepoints to userspace, and thus makes them a
> > > > userspace-visible API, when those tracepoints should be tied to the
> > > > kernel code and nothing else. An adaptation layer should provide the
> > > > abstractions that makes the information presented to the user more
> > > > "logical".
> > > 
> > > Let me correct you here. TRACE_EVENT does ***NOT*** export anything to 
> > > userspace. There is no code what so ever in TRACE_EVENT that does so.
> > > 
> > 
> > Except the comment on top of TRACE_EVENT() in tracepoint.h maybe ?
> > 
> >  *      *
> >  *      * Fast binary tracing: define the trace record via
> >  *      * TP_STRUCT__entry(). You can think about it like a
> >  *      * regular C structure local variable definition.
> >  *      *
> >  *      * This is how the trace record is structured and will
> >  *      * be saved into the ring buffer. These are the fields
> >  *      * that will be exposed to user-space in
> >  *      * /debug/tracing/events/<*>/format.
> > 
> > You don't need to have code within the infrastructure to actually export
> > stuff to userspace. Stating in the API that you some information will be
> > presented to userspace counts.
> 
> That is done by ftrace not TRACE_EVENT.
> 

This comment and API is exposed within the kernel by TRACE_EVENT, and
its content is used by ftrace actually. But anyway, if it gets us
tracepoints into the kernel, and we can find a way that eventually LTTng
could piggyback on that information, I'm for it.

> > 
> > > Now, ftrace does export information using TRACE_EVENT to userspace. But 
> > > that is the way ftrace wants to handle it. There's nothing needed to 
> > > export to userspace. What is exported, is exported ***BECAUSE*** it can 
> > > change. I'll only try to keep the format that is exported the same. But 
> > > nothing should rely on what the format represents staying the same.
> > > 
> > > If someone adds a TRACE_EVENT, you can uses it to record you data, anyway
> > > you like. Ftrace will use it to show how to read the binary data, which
> > > is only needed if you want to do that. It uses the print format to print
> > > to the console in case of failure. Or to the trace file, which by the way
> > > can also change without notice.
> > 
> > Hrm, so you are planning to add, in
> > include/trace/sched_event_types.h, things like :
> > 
> > TRACE_EVENT(sched_kthread_stop,
> > 
> >         TP_PROTO(struct task_struct *t),
> > 
> >         TP_ARGS(t),
> > 
> >         TP_STRUCT__entry(
> >                 __array(        char,   comm,   TASK_COMM_LEN   )
> >                 __field(        pid_t,  pid                     )
> >         ),
> > 
> >         TP_fast_assign(
> >                 memcpy(__entry->comm, t->comm, TASK_COMM_LEN);
> >                 __entry->pid    = t->pid;
> >         ),
> > 
> >         TP_printk("task %s:%d", __entry->comm, __entry->pid)
> > );
> > 
> > Actually specifying that the TP_STRUCT__entry, TP_fast_assign and
> > TP_printk are specific to ftrace and should not be considered as a
> > stable API, am I correct ?
> 
> No they are not specific to ftrace. I said they are used by ftrace.
> They can be modified at will by the maintainer.  The macros makes the 
> updates automatic for ftrace.
> 

Eventually we might want to combine the lttng probes I have and these
TP_STRUCT__entry and TP_fast_assign.

> > 
> > Then only when ftrace is built in the kernel do we have 
> > kernel/trace/events.c including the holy include/trace/trace_events.h,
> > which includes all the trace_events headers, and then including
> > kernel/trace/trace_events_stage_{1,2,3}.h to override the TRACE_EVENT
> > macro and create the callbacks for each TRACE_EVENT statements.
> 
> Currently ftrace is the only user of the include/trace/trace_events.h 
> Others are welcome to do what they wish.
> 
> > 
> > Then big problem with this is that, whether you like it or not, you
> > *are* adding an API to the tracepoints, but just validating the types
> > when ftrace is being built. If you want to add an API to the
> > tracepoints, then the type verification should be done _even when ftrace
> > is disabled_.
> 
> It's an internal API not a user space one. Internal APIs are fine, and can 
> change whenever we want.
> 

Well, I think we should consider the ftrace user-space data consumer as
part of this "internal" api then, event if it crosses the
kernel-userspace boundary. If we agree that this is what need and want
to do, I'm fine with it.

> > 
> > Therefore, the TRACE_EVENT in tracepoint.h should map to macros that
> > would verify the argument types.
> 
> We could do that too.
> 
> > 
> > I think it's ok to specify that the arguments of a given TRACE_EVENT may
> > change without notice. We have to say it explicitly in the TRACE_EVENT
> > header though.
> 
> Sure, I totally agree.
> 
> > 
> > And while we talk about this, I also wonder why we won't simply embed
> > the result of the TP_fast_assign and TP_printk in the tracepoint
> > unlikely branch ? This would skip a function call in the tracing fast
> > path, and would save the overhead of a whole function call when tracing
> > is active. But that implies more bounds between tracepoints and data
> > output, but given you are already declaring this in the same API, I
> > don't see the problem anymore.
> 
> I'm not exactly what you mean here?  You mean to add it at the location in 
> the code? If that is the case, I disagree. Since we don't want to clutter 
> code with trace point data. It is nice to keep it out in separate headers.
> 
> This is what we also think about #ifdefs, it is better to have static 
> inlines in headers that to clutter the code with them.
> 

Yes, leaving the body of the tracing out of the kernel objects as much
as possible is a good thing, because it won't pollute the original
kernel functions too much and will leave the compiler do its
optimisations in peace. So we agree that we should not go as far as to
embed the result of TP_fast_assign and TP_printk into the caller.

> > 
> > About the struct ftrace_raw_##name created in stage 1, I think the
> > padding at the end of the structure is a complete waste of space. You
> > should probably have a look at the ltt-type-serializer.[ch] in LTTng.
> 
> I don't know what padding you are talking about.

If you declare a struct with :

struct {
	void *a;
	char b;
};

the structure is then 2 * sizeof(void *) in size, because the end of the
structure is aligned on the largest type within the structure. In a
standard C program memory layout, this makes perfect sense, because
we often declare arrays of structures and we expect the next item to be
aligned on the largest type. Therefore, the beginning and the end of the
structure are aligned on such largest type.

However, in a trace, given we will typically write a compact header
(lttng event headers are 32-bits) after the structure, it makes no
sense to re-align on sizeof(void*) after the data.

Therefore, in LTTng, I have declared special structures for event
payloads, e.g. :

(include/linux/ltt-type-serializer.h from the LTTng tree)

struct serialize_long_char {
        unsigned long f1;
        unsigned char f2;
        unsigned char end_field[0];
} LTT_ALIGN;

Where LTT_ALIGN maps either to nothing or __attribute__((packed)),
depending if the architecture supports efficient unaligned writes or
not.

The size of the structure can then be obtained with :

#define serialize_sizeof(type)  offsetof(typeof(type), end_field)

I hope this explanation makes it clearer.

> 
> > 
> > I am still unsure that the approach you take with TRACE_EVENT, which I
> > would call "automatically generating code using header and macro
> > tricks", is in the end easier to review than the simple C callback
> > approach I have taken in LTTng, adding the "glue" in the
> > DEFINE_MARKER_TP() macros to connect a specific C callback to the actual
> > tracepoint.
> > 
> > The good thing about your approach is that everyting about a trace event
> > can be declared within the same macro. In LTTng, I have to create probe
> > modules and write stuff like :
> > 
> > void probe_irq_softirq_exit(struct softirq_action *h,
> >         struct softirq_action *softirq_vec);
> > 
> > DEFINE_MARKER_TP(kernel, softirq_exit, irq_softirq_exit,
> >         probe_irq_softirq_exit, "softirq_id #1u%lu");
> > 
> > void probe_irq_softirq_exit(struct softirq_action *h,
> >         struct softirq_action *softirq_vec)
> > {
> >         struct marker *marker;
> >         unsigned char data;
> > 
> >         data = ((unsigned long)h - (unsigned long)softirq_vec) / sizeof(*h);
> > 
> >         marker = &GET_MARKER(kernel, softirq_exit);
> >         ltt_specialized_trace(marker, marker->single.probe_private,
> >                 &data, sizeof(data), sizeof(data));
> > }
> > 
> > by hand, and then the kernel softirq_exit event is shown in
> > debugfs/ltt/markers/kernel/softirq_exit/. But I don't see the big win
> > you get by doing it in TRACE_EVENT, especially if it is not
> > type-verified when ftrace is disabled, compared to adding those
> > callbacks in standard kernel modules, which is a coding-style we have
> > been used to for years.
> 
> Well, I originally had it like you did above. But I found that if I did
> that, the number of events would be greatly limited. Once I added this
> infrastructure, a bunch of events were able to be made quickly.
> 
> As for the type checking, that should be easy to add. Don't need ftrace to 
> do it.
> 

Ideally we should find a way to integrate the new instrumentation so
it's useful for both ftrace and lttng. I have already started to discuss
with the Fujitsu team to ask them if they have time to extend the
LTTng instrumentation following recommendations from Ingo. We plan to
duplicate a bit of work for now, adding the LTTng probes and also the
ftrace format strings, until we can bring the two infrastructures
closer.

I should be able to get back to more serious coding in about 2 months,
after the core of my Ph.D. thesis is finished. I will then be able to
concentrate on LTTng integration as much as I want to. Meanwhile, I am
ready to work with you and the Fujitsu team to gradually improve LTTng
instrumentation, while I switch my main output language from C to
English. :-)

Thanks,

Mathieu

> -- Steve
> 
> 
> > 
> > I haven't seen much automatically generated code around in the kernel
> > tree, maybe there is a good reason ? I can't wait to see the first
> > kernel JIT based on ftrace. ;-)
> > 
> > Mathieu
> > 
> > -- 
> > Mathieu Desnoyers
> > OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> > 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
