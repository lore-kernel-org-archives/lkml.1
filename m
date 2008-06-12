Return-Path: <linux-kernel-owner+w=401wt.eu-S1760897AbYFLO11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760897AbYFLO11 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 10:27:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754508AbYFLO1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 10:27:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:54399 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754402AbYFLO1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 10:27:18 -0400
Subject: Re: Kernel marker has no performance impact on ia64.
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Hideo AOKI <haoki@redhat.com>, mingo@elte.hu,
       Masami Hiramatsu <mhiramat@redhat.com>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       "Frank Ch. Eigler" <fche@redhat.com>
In-Reply-To: <20080612135319.GB22348@Krystal>
References: <48447052.3030300@redhat.com>
	 <1212445965.6269.22.camel@lappy.programming.kicks-ass.net>
	 <20080602232135.GA20173@Krystal>
	 <1212618449.19205.35.camel@lappy.programming.kicks-ass.net>
	 <20080604232241.GA8488@Krystal>
	 <1212653539.19205.47.camel@lappy.programming.kicks-ass.net>
	 <20080612135319.GB22348@Krystal>
Content-Type: text/plain
Date: Thu, 12 Jun 2008 16:27:03 +0200
Message-Id: <1213280823.31518.114.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-06-12 at 09:53 -0400, Mathieu Desnoyers wrote:
> Hi Peter,
> 
> * Peter Zijlstra (peterz@infradead.org) wrote:
> > On Wed, 2008-06-04 at 19:22 -0400, Mathieu Desnoyers wrote:
> > > * Peter Zijlstra (peterz@infradead.org) wrote:
> > 
> > > > So are you proposing something like:
> > > > 
> > > > static inline void 
> > > > trace_sched_switch(struct task_struct *prev, struct task_struct *next)
> > > > {
> > > > 	trace_mark(sched_switch, prev, next);
> > > > }
> > > > 
> > > 
> > > Not exactly. Something more along the lines of
> > > 
> > > static inline void 
> > > trace_sched_switch(struct task_struct *prev, struct task_struct *next)
> > > {
> > >   /* Internal tracers. */
> > >   ftrace_sched_switch(prev, next);
> > >   othertracer_sched_switch(prev, next);
> > >   /*
> > >    * System-wide tracing. Useful information is exported here.
> > >    * Probes connecting to these markers are expected to only use the
> > >    * information provided to them for data collection purpose. Type
> > >    * casting pointers is discouraged.
> > >    */
> > > 	trace_mark(kernel_sched_switch, "prev_pid %d next_pid %d prev_state %ld",
> > >     prev->pid, next->pid, prev->state);
> > > }
> > 
> > Advantage of my method would be that ftrace (and othertracer) can use
> > the same marker and doesn't need yet another hoook.
> > 
> 
> Am I correct by saying that the method you propose completely removes
> type checking between the instrumentation site and what the probes
> expect ? If yes, this seems to be too fragile. Every time a marker would
> change, one would have to audit _every_ probes, both in-kernel and in
> modules. Adding type checking to the marker infrastructure makes
> automatic detection of these changes possible.

would be as simple as:

 git grep sched_switch

every time someone changes trace_sched_switch() arguments. Doesn't seem
too hard, you could even make checkpatch remind you to do that if it
sees a change to a trace_* function.

The down-side of runtime type checking (of which Masami's proposal is
the best so far), is that you'll still not find the breakage until
someone actually tries to use a tracer - so you'll still need the above.

> > > > dropping the silly fmt string but using the multiplex of trace_mark, and
> > > > then doing the stringify bit:
> > > > 
> > > >        "prev_pid %d next_pid %d prev_state %ld\n"
> > > > 
> > > > in the actual tracer?
> > > > 
> > > 
> > > It would make much more sense to put this formatting information along
> > > with the trace point (e.g. in a a kernel/sched-trace.h header) rather
> > > that to hide it in a tracer (loadable module) because this information
> > > is an interface to the trace point.
> > 
> > I'm not sure - it seems to me it should be part of the tracer because
> > its a detail/subset of the actual data - rendering it useless for others
> > who'd like a different set.
> > 
> 
> If it ends up elsewhere, then we have to ensure type correctness in some
> way.

Sure, idealy we'd want compile time type safety. We'd want
trace_sched_switch()'s arguments to match trace_sched_switch_handler()'s
arguments, and a compile time error if this is not the case.

However - we cannot seem to get that. Runtime type safety just doesn't
help this case.

But the point I was making here is that:

  trace_sched_switch(prev->pid, next->pid, next->state)

could be useless for some other tracer who'd want:

  trace_sched_switch(prev->vruntime, next->vruntime)

Also, the ->pid stuff isn't even alive on the normal code path, so
adding that to the marker also bloats the code generated there.

So by using the marker:

  trace_sched_switch(prev, next)

We can have various tracers that display different information and avoid
livelyness issues.

> > > > IMHO the 'type safety' of the fmt string is over-rated, since it cannot
> > > > distinguish between a task_struct * or a bio *, both are a pointers -
> > > > and half arsed type safely is worse than no type safety.
> > > > 
> > > 
> > > I totally agree with you that not having the capacity to inspect pointer
> > > types is a problem for tracers which wants to receive the "raw" pointer
> > > and deal with the data they need like big boys. On the other hand, it
> > > requires them to be closely tied to the kernel internals and therefore
> > > it makes sense to call them directly from the tracing site, thus
> > > bypassing the marker format string.
> > > 
> > > However, letting the marker specify the data format so a tracer could
> > > format it into a memory buffer (in a binary or text format, depending on
> > > the implementation) or so that a tool like systemtap can use this
> > > identified information without having to be closely tied to the kernel
> > > makes sense to me.
> > 
> > So s-tap is meant to parse this sting and interpret the varargs without
> > being closely tied to the kernel? - Somehow that doesn't make me feel
> > warm and fuzzy. That not only ties userspace to the information present
> > in the marker, but to the actual string as well.
> > 
> > The stronger you make this bind the less I like it.
> > 
> 
> Well, the string contains each field name and type. Therefore, SystemTAP
> can hook on a marker and parse the string looking for some elements by
> passing a NULL format string upon probe registration. Alternatively, it
> can provide the exact format string expected when it registers its probe
> to the marker and a check will be done to verify that the format string
> passed along with the registered probe matches the marker format string.

Yes, I get that, its one of the ugliest things I've met in this whole
marker story. Why can't stap not insert a normal trace handler that
extracts the information from prev/next it wants?

> Also, about what you said earlier in this thread :
> "Regular trace points can be custom made; this has the advantages that
> it raises the implementation barrier and hopefully that encourages some
> thought in the process. It also avoid the code from growing into
> something that looks like someone had a long night of debugging."
> 
> Before it has been moved to the markers, LTTng was once designed with
> custom-made code to save the trace information through custom hooks. To
> help maintainers instrument their own subsystem and do the right choice
> without being a tracing expert,

>  we created a code generator which
> generated this custom code for each trace point given a description of
> the trace points.

>  It turned out that keeping this duplicate list of
> trace points was cumbersome and that the generated code did eat a lot of
> instruction cache. 

Well, your last proposal of static inline functions basically returns
thereto. So what was cumbersome about it?

The I$ issue is unfortunate indeed - but it seems to be the price to pay
for compile time type safety.

As for that code-generator, that seems a sane idea, esp if the input
file is simply a regular C header file with trace point definitions.

> This is why to turned to markers, so we could re-use
> a common infrastructure to serialize the data into trace buffers. We
> turned to the marker format string to allow the types to serialize to be
> parsed efficiently by the tracer. I strongly recommend not to declare
> the types associated with a kernel trace point in two unrelated
> locations without type checking in-between them (e.g. trace_mark in
> kernel code, string in the tracer module), because it would then become
> harder to track consistency when the code changes.

I see the value of trace_mark() in debugging sessions, but merging these
things is like merging the resulting code file after a printk debugging
session.

> However, I would not be against an hybrid of Masami's proposal and
> current markers, which I will propose in reply to his email.

Ah - I'm looking forward..

