Return-Path: <linux-kernel-owner+w=401wt.eu-S1762055AbYFLNxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762055AbYFLNxb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 09:53:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753038AbYFLNxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 09:53:24 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:33011 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752998AbYFLNxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 09:53:22 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtMEAEbFUEhMQW1O/2dsb2JhbACBW6wY
Date: Thu, 12 Jun 2008 09:53:19 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Hideo AOKI <haoki@redhat.com>, mingo@elte.hu,
       Masami Hiramatsu <mhiramat@redhat.com>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: Kernel marker has no performance impact on ia64.
Message-ID: <20080612135319.GB22348@Krystal>
References: <48447052.3030300@redhat.com> <1212445965.6269.22.camel@lappy.programming.kicks-ass.net> <20080602232135.GA20173@Krystal> <1212618449.19205.35.camel@lappy.programming.kicks-ass.net> <20080604232241.GA8488@Krystal> <1212653539.19205.47.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1212653539.19205.47.camel@lappy.programming.kicks-ass.net>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:32:14 up 7 days, 18:13,  3 users,  load average: 0.91, 1.84,
	1.39
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Wed, 2008-06-04 at 19:22 -0400, Mathieu Desnoyers wrote:
> > * Peter Zijlstra (peterz@infradead.org) wrote:
> 
> > > So are you proposing something like:
> > > 
> > > static inline void 
> > > trace_sched_switch(struct task_struct *prev, struct task_struct *next)
> > > {
> > > 	trace_mark(sched_switch, prev, next);
> > > }
> > > 
> > 
> > Not exactly. Something more along the lines of
> > 
> > static inline void 
> > trace_sched_switch(struct task_struct *prev, struct task_struct *next)
> > {
> >   /* Internal tracers. */
> >   ftrace_sched_switch(prev, next);
> >   othertracer_sched_switch(prev, next);
> >   /*
> >    * System-wide tracing. Useful information is exported here.
> >    * Probes connecting to these markers are expected to only use the
> >    * information provided to them for data collection purpose. Type
> >    * casting pointers is discouraged.
> >    */
> > 	trace_mark(kernel_sched_switch, "prev_pid %d next_pid %d prev_state %ld",
> >     prev->pid, next->pid, prev->state);
> > }
> 
> Advantage of my method would be that ftrace (and othertracer) can use
> the same marker and doesn't need yet another hoook.
> 

Am I correct by saying that the method you propose completely removes
type checking between the instrumentation site and what the probes
expect ? If yes, this seems to be too fragile. Every time a marker would
change, one would have to audit _every_ probes, both in-kernel and in
modules. Adding type checking to the marker infrastructure makes
automatic detection of these changes possible.

> > > dropping the silly fmt string but using the multiplex of trace_mark, and
> > > then doing the stringify bit:
> > > 
> > >        "prev_pid %d next_pid %d prev_state %ld\n"
> > > 
> > > in the actual tracer?
> > > 
> > 
> > It would make much more sense to put this formatting information along
> > with the trace point (e.g. in a a kernel/sched-trace.h header) rather
> > that to hide it in a tracer (loadable module) because this information
> > is an interface to the trace point.
> 
> I'm not sure - it seems to me it should be part of the tracer because
> its a detail/subset of the actual data - rendering it useless for others
> who'd like a different set.
> 

If it ends up elsewhere, then we have to ensure type correctness in some
way.

> > > IMHO the 'type safety' of the fmt string is over-rated, since it cannot
> > > distinguish between a task_struct * or a bio *, both are a pointers -
> > > and half arsed type safely is worse than no type safety.
> > > 
> > 
> > I totally agree with you that not having the capacity to inspect pointer
> > types is a problem for tracers which wants to receive the "raw" pointer
> > and deal with the data they need like big boys. On the other hand, it
> > requires them to be closely tied to the kernel internals and therefore
> > it makes sense to call them directly from the tracing site, thus
> > bypassing the marker format string.
> > 
> > However, letting the marker specify the data format so a tracer could
> > format it into a memory buffer (in a binary or text format, depending on
> > the implementation) or so that a tool like systemtap can use this
> > identified information without having to be closely tied to the kernel
> > makes sense to me.
> 
> So s-tap is meant to parse this sting and interpret the varargs without
> being closely tied to the kernel? - Somehow that doesn't make me feel
> warm and fuzzy. That not only ties userspace to the information present
> in the marker, but to the actual string as well.
> 
> The stronger you make this bind the less I like it.
> 

Well, the string contains each field name and type. Therefore, SystemTAP
can hook on a marker and parse the string looking for some elements by
passing a NULL format string upon probe registration. Alternatively, it
can provide the exact format string expected when it registers its probe
to the marker and a check will be done to verify that the format string
passed along with the registered probe matches the marker format string.

Also, about what you said earlier in this thread :
"Regular trace points can be custom made; this has the advantages that
it raises the implementation barrier and hopefully that encourages some
thought in the process. It also avoid the code from growing into
something that looks like someone had a long night of debugging."

Before it has been moved to the markers, LTTng was once designed with
custom-made code to save the trace information through custom hooks. To
help maintainers instrument their own subsystem and do the right choice
without being a tracing expert, we created a code generator which
generated this custom code for each trace point given a description of
the trace points. It turned out that keeping this duplicate list of
trace points was cumbersome and that the generated code did eat a lot of
instruction cache. This is why to turned to markers, so we could re-use
a common infrastructure to serialize the data into trace buffers. We
turned to the marker format string to allow the types to serialize to be
parsed efficiently by the tracer. I strongly recommend not to declare
the types associated with a kernel trace point in two unrelated
locations without type checking in-between them (e.g. trace_mark in
kernel code, string in the tracer module), because it would then become
harder to track consistency when the code changes.

However, I would not be against an hybrid of Masami's proposal and
current markers, which I will propose in reply to his email.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
