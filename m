Return-Path: <linux-kernel-owner+w=401wt.eu-S1755512AbYAQUIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512AbYAQUIv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 15:08:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752092AbYAQUIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 15:08:43 -0500
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:60780 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbYAQUIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 15:08:42 -0500
Date: Thu, 17 Jan 2008 15:08:33 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>, Paul Mackerras <paulus@samba.org>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [RFC PATCH 16/22 -v2] add get_monotonic_cycles
In-Reply-To: <20080116201713.GA14336@Krystal>
Message-ID: <Pine.LNX.4.58.0801171440360.28350@gandalf.stny.rr.com>
References: <20080115220824.GB22242@Krystal> <Pine.LNX.4.58.0801151717250.29090@gandalf.stny.rr.com>
 <20080116031730.GA2164@Krystal> <Pine.LNX.4.58.0801152238130.19680@gandalf.stny.rr.com>
 <20080116145604.GB31329@Krystal> <Pine.LNX.4.58.0801161003010.15758@gandalf.stny.rr.com>
 <20080116152838.GA970@Krystal> <Pine.LNX.4.58.0801161041010.15998@gandalf.stny.rr.com>
 <20080116170011.GA3651@Krystal> <Pine.LNX.4.58.0801161428180.14368@gandalf.stny.rr.com>
 <20080116201713.GA14336@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > >
> > > > One thing I want to clear up. The major difference between this
> > > > latency_tracer and LTTng is what we consider fast paths.  The latency
> > > > tracer is recording things like enabling and disabling interrupts, preempt
> > > > count changes, or simply profiling all function calls.  Those are what I
> > > > consider fast paths.  The slow path WRT the latency_tracer are things like
> > > > context switches.  This is why I don't have a problem with copying the
> > > > comm at context switch time. Because that _is_ a slow path for the latency
> > > > tracer.
> > >
> > > LTTng hooks in the lockdep tracer to trace irq on/off, spinlocks, etc..
> > > in flight recorder mode, we have nothing to write to disk and therefore
> > > we can handle very frequent events. We then do the analysis off-line
> > > using the last MB written in the buffers. The advantage is that the
> > > kernel dumbly writes data to a buffer : we therefore move the complexity
> > > to user-space.
> >
> > But you would still need to do something in case you want this information
> > dumped to console on a kernel crash.  Of course you can rely on kexec, but
> > if the kexec fails (which is possible) then you lose all the information.
> > Having the ability to dump the output to console on a crash is one of the
> > benefits of latency_tracer that I want to keep.
> >
>
> There has been some integration done between LTTng and the "crash" tool
> to extract the buffers from a crashed kernel. I am not an expert in
> crash buffer extraction though, but I guess all the available mechanisms
> depend on kexec and could show the limits you are referring to.
>
> If you really want to pretty-print the information to the console, I
> would propose that you leave that part of the problem to a different
> output module. The core of the latency tracer could keep the minimum
> information. Then, when a dump is triggered, it either sends the
> information to LTTng or to your console pretty-printer.
>
> However, I would not call the pretty-printer a "tracer" module per-se.
> We would have to accept that it is a bit more tied to the kernel
> internals than the latency tracer. My goal is to separate the core
> "profiling" module from the optional "pretty-printing" module as much as
> possible so the latency tracer core could be reused by other output
> modules.

Mathieu,

I've been thinking about the context switch marker, and the printf format
field you have:

        prepare_task_switch(rq, prev, next);
+       trace_mark(kernel_sched_schedule,
+               "prev_pid %d next_pid %d prev_state %ld",
+               prev->pid, next->pid, prev->state);
        mm = next->mm;


Now I see that this is great for your tracer, since all your hook would
need to do is:

static notrace void simple_trace(const struct marker *mdata,
				void *private_data,
				const char *format, ...)
{
	va_list ap;

	va_start(ap, format);
	simple_trace_record(ap, format);
	va_end(ap);
}

And you could hook this up to all your traces. Wonderful!

But...

Tracers that want to do a bit more work, like recording timings and seeing
if we hit some max somewhere, can't do much with that pretty print data.
For example, I like to record the priority of a task that is being swapped
out as well as the one being swapped in. But with this, all I can get is
the priority of the prev task (since it is still current).

You told me that I should put hooks into where the priority gets modified,
so that I can trace it there at a non hot path. Well, I have some issues
with this.

1) to me it's a management nightmare. Yes, I could hook into lttng, but
that too is too much. That takes me back to the days when COTS became the
new buzzword, and we ended up having to incorporate COTS products into
things better left done in house. The end result was more glue code than
what would happen if it was simple done in house, and a product that was
totally inefficient.

2) this requires we put a marker at all the places that might change the
data we want the snapshot of at the marker (here being prio at context
switch time). I could imaging some new code comes into the kernel that
modifies priority but the author has no idea about having to update the
trace marker, and the trace output ends up showing stale data. And this
would cause the poor bastard that needs to maintain this code to debug the
tracer on top of the code they are maintaining. Which simply would end up
where that poor bastard will lose all confidence in the tracer and would
simply give up on it.

I know that if we did something like:

	trace_mark(kernel_sched_schedule,
		"prev %p next %p",
		prev, next);

It would be useless for the simple recording, because what the user would
see is just two meaningless pointer numbers.

So, at a minimum, I'd like to at least have meta data attached:

	trace_mark(kernel_sched_schedule,
		"prev_pid %d next_pid %d prev_state %ld\0"
		"prev %p next %p",
		prev->pid, next->pid, prev->state,
		prev, next);

This would allow for both the nice pretty print of your trace, as well as
allowing other tracers to get to better meta data.
The '\0' would keep your tracer from recording the extra data, and we
could add some way to ignore the parameters in the printf to let other
traces get straight to the meta data.

Actually here, since prev == current, we could omit that.

Just a thought.

-- Steve

