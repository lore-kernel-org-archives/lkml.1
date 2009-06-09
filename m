Return-Path: <linux-kernel-owner+w=401wt.eu-S1755354AbZFIOOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354AbZFIOOh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 10:14:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751524AbZFIOO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 10:14:29 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45629 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878AbZFIOO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 10:14:28 -0400
Date: Tue, 9 Jun 2009 10:13:09 -0400
From: Jason Baron <jbaron@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       peterz@infradead.org, mathieu.desnoyers@polymtl.ca, jiayingz@google.com,
       mbligh@google.com, roland@redhat.com, fche@redhat.com
Subject: Re: [PATCH 2/2] convert to syscall tracepoints
Message-ID: <20090609141309.GA3111@redhat.com>
References: <cover.1244222378.git.jbaron@redhat.com> <af4031af81ce372eac2be125dabc2ea746b4308b.1244222378.git.jbaron@redhat.com> <20090607132936.GC12088@elte.hu> <20090608202406.GA3181@redhat.com> <20090608204056.GA26832@elte.hu> <20090608211150.GC3181@redhat.com> <20090608212526.GA22049@elte.hu> <20090608213833.GD3181@redhat.com> <20090608230234.GA5758@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090608230234.GA5758@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 09, 2009 at 01:02:35AM +0200, Frederic Weisbecker wrote:
> On Mon, Jun 08, 2009 at 05:38:33PM -0400, Jason Baron wrote:
> > On Mon, Jun 08, 2009 at 11:25:26PM +0200, Ingo Molnar wrote:
> > > > On Mon, Jun 08, 2009 at 10:40:56PM +0200, Ingo Molnar wrote:
> > > > > * Jason Baron <jbaron@redhat.com> wrote:
> > > > > 
> > > > > > +#ifdef __NR_time
> > > > > > +trace_event_syscall(1, time, time_t __user *, tloc);
> > > > > > +#endif
> > > > > > +
> > > > > > +#ifdef __NR_stime
> > > > > > +trace_event_syscall(1, stime, time_t __user *, tptr);
> > > > > > +#endif
> > > > > > +
> > > > > > +#ifdef __NR_gettimeofday
> > > > > > +trace_event_syscall(2, gettimeofday, struct timeval __user *, tv, struct timezone __user *, tz);
> > > > > > +#endif
> > > > > 
> > > > > This could be reduced to a single line: just add a Kconfig entry 
> > > > > (say TRACE_SYSCALL_TRACEPOINTS) wether an arch supports syscall 
> > > > > tracepoints, enable it on a sane arch, make sure it has all the 
> > > > > syscalls and list them ...
> > > > > 
> > > > > As more architectures turn on SYSCALL_TRACEPOINTS, they'll have to 
> > > > > resolve any deviations in syscall entry points. Ideally we'd have 
> > > > > one generic table that covers 95% of all syscalls, and the remaining 
> > > > > 5% in some architecture specific #ifdef section.
> > > > > 
> > > > 
> > > > true, but this implementation works for all arches now, why would 
> > > > want to slowly add this over time? [...]
> > > 
> > > Because the current solution is butt-ugly ...
> > > 
> > > > [...] I think its unnecessary work that could be error prone.
> > > 
> > > This area needs cleanups - making it messier doesnt help. (I've 
> > > Cc:-ed hpa - he has expressed interest in auto-generating all the 
> > > syscall related details from another angle ...)
> > > 
> > > > > But, more generally, i'm not at all convinced that we need _any_ 
> > > > > of this enumeration. Look how much the above lines duplicate 
> > > > > DEFINE_SYSCALL macros. Why arent those macros re-used?
> > > > 
> > > > The DEFINE_SYSCALL() are located all over the code in various .c files.
> > > 
> > > yes, and that's good.
> > > 
> > > > Thus, if we define the tracpoints via the DEFINE_SYSCALL() macros 
> > > > we are going to have 'static inline functions' (which is how 
> > > > tracepoints are implemented) defined in all these .c files. Now, I 
> > > > need to call all these 'static inline functions' from ptrace.c. 
> > > > How do I do that? [...]
> > > 
> > > And that's bad.
> > > 
> > > We dont want a per syscall tracepoint call site. AT ALL.
> > > 
> > > We want to collect the record information, we want to construct 
> > > /debug/tracing/events/syscalls/ directories with all the proper 
> > > tracepoint-lookalike entries, and then we want to use the 
> > > _existing_, _zero overhead_ method implemented by Frederic to get 
> > > per syscall functionality.
> > > 
> > 
> > Yes, this can easily be done....but that wasn't the problem I was
> > interested in solving. I wanted a per syscall tracepoint site. I thought
> > I had been making that clear all along...Please notice that the
> > implementation I've proposed obtains the syscall number, and then jumps
> > to the appropriate tracepoint and then exits. Its quite efficient. In
> > fact, I've enabled all of the syscalls using my proposed method and
> > running tbench I'm able to get more throughput then using the current
> > syscall method. I've also done 'getpid()' loops and seen no performance
> > difference between the approaches. I'm happy to run any other
> > benchmarks...
> > 
> > > Have you looked at how the syscall attributes information is 
> > > constructed by using .section tricks? See: 
> > > kernel/trace/trace_syscalls.c.
> > > 
> > 
> > yes, I believe I understand the problem space. I had been talking about
> > a per-syscall tracepoint all along...maybe I wasn't clear...
> > 
> > thanks,
> > 
> > -Jason
> 
> 
> Ok, I understand the problem.
> Well, the fact is that we can use the artifact from the current syscall tracer
> to solve a part of this problem.
> 
> Currently the syscall tracer does the following:
> 
> - create a section with all syscalls informations, provided by DEFINE_SYSCALL()
>   That includes the size, type, name of parameters.
> 
> - map a table during the boot which resolves a syscall number to its information
>   in the syscall metadata section
> 
> - uses a generic "trace_syscall()" (or something like that) in ptrace.c (x86)
>   which gather informations from the current syscalls (get from the mapped table)
>   and then send the trace to the ring buffer.
> 
> - have a pretty printing (well, not that much actually) callback which, again,
>   retrieve the syscall information from its number after getting the trace from
>   the ring buffer. And then the raw field values aree printed, with the field
>   names, and their types, optionally.
> 
> Now what I would suggest to avoid this whole listing of syscalls in your patch
> is to avoid the use of hardcoded tracepoints.
> 
> We can't really use TRACE_EVENT() here without using the listing you did.
> Instead, you could define a custom struct ftrace_event_call from DEFINE_SYSCALL().
> 
> In regfunc() you can turn on TIF_FTRACE (using a refcounter).
> 
> The struct trace_event ftrace_event_type can reuse the existing output callback
> for syscall tracing which retrieve the syscall informations.
> 
> void ftrace_raw_event_##call() can be replaced by calling directly the existing
> generic callback for syscall tracing trace insertion.
> 
> And the arch mapping table can resolve a syscall number to its matching
> event.
> 

hmmm..so I presume this would layer on 2 tracepoints? One in syscall
entry and one in exit, presumably passing a 'struct pt_regs'? I think
the refcounter would also have to be deeper in the tracepoint
infrastructure since the event tracing wouldn't be the only potential
user of these tracepoints.

thanks,

-Jason
