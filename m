Return-Path: <linux-kernel-owner+w=401wt.eu-S1764259AbYARW0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764259AbYARW0v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 17:26:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758568AbYARW0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 17:26:43 -0500
Received: from tomts20.bellnexxia.net ([209.226.175.74]:46423 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755359AbYARW0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 17:26:42 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAL+2kEdMROHU/2dsb2JhbACBV5AQnTU
Date: Fri, 18 Jan 2008 17:26:37 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, Steven Rostedt <srostedt@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Daniel Walker <dwalker@mvista.com>
Subject: Re: [RFC PATCH 16/22 -v2] add get_monotonic_cycles
Message-ID: <20080118222637.GA30900@Krystal>
References: <20080116145604.GB31329@Krystal> <Pine.LNX.4.58.0801161003010.15758@gandalf.stny.rr.com> <20080116152838.GA970@Krystal> <Pine.LNX.4.58.0801161041010.15998@gandalf.stny.rr.com> <20080116170011.GA3651@Krystal> <Pine.LNX.4.58.0801161428180.14368@gandalf.stny.rr.com> <20080116201713.GA14336@Krystal> <Pine.LNX.4.58.0801171440360.28350@gandalf.stny.rr.com> <20080117203740.GA24397@redhat.com> <Pine.LNX.4.58.0801171555120.28350@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0801171555120.28350@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:31:29 up 76 days,  2:36,  6 users,  load average: 4.12, 1.71,
	1.16
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> On Thu, 17 Jan 2008, Frank Ch. Eigler wrote:
> 
> > Hi -
> >
> > On Thu, Jan 17, 2008 at 03:08:33PM -0500, Steven Rostedt wrote:
> > > [...]
> > > +       trace_mark(kernel_sched_schedule,
> > > +               "prev_pid %d next_pid %d prev_state %ld",
> > > +               prev->pid, next->pid, prev->state);
> > > [...]
> > > But...
> > >
> > > Tracers that want to do a bit more work, like recording timings and seeing
> > > if we hit some max somewhere, can't do much with that pretty print data.
> >
> > If you find yourself wanting to perform computations like finding
> > maxima, or responding right there as opposed to later during userspace
> > trace data extraction, then you're trending toward a tool like
> > systemtap.
> 
> Yes, very much so. I'm working on getting the latency_tracer from the -rt
> patch into something suitable for mainline. We need to calculate the max
> latencies on the fly. If we hit a max, then we save it off, otherwise, we
> blow away the trace and start again.
> 
> >
> > > [...]
> > > So, at a minimum, I'd like to at least have meta data attached:
> > > 	trace_mark(kernel_sched_schedule,
> > > 		"prev_pid %d next_pid %d prev_state %ld\0"
> > > 		"prev %p next %p",
> > > 		prev->pid, next->pid, prev->state,
> > > 		prev, next);
> > >
> > > This would allow for both the nice pretty print of your trace, as well as
> > > allowing other tracers to get to better meta data.
> >
> > Yes, more self-contained marker events are necessary for meaningful
> > in-situ processing.  That needs to be balanced by the increased cost
> > for computing and passing the extra parameters, multiplied the event
> > occurrence rate.
> 
> The cost is only done when the marker is armed. Since the marker is an
> unlikely, and will be placed at the end of the function.
> 
> >
> > In this case, the prev/next pointers are sufficient to compute the
> > other values.  For particularly performance-critical markers, it may
> > not be unreasonable to expect the callback functions to dereference
> > such pointers for pretty-printing or other processing.
> 
> This was exactly my point to Mathieu, but I think he has LTTng very much
> coupled with the markers. I haven't played with LTTng (yet), but from what
> I've read (Mathieu, correct me if I'm wrong), it seems that all the
> markers become visible to userspace, and the user can simple turn them on
> or off. LTTng doesn't need any knowledge of the marker since the marker
> contains how to print the information.
> 
> So* by placing a "prev %p next %p" as the only information, we lose out on
> this automated way LTTng works. Because the two pointers are just
> meaningless numbers to the user.
> 

Exactly. We have, at the marker site :

- a marker identifier
- format string containing field names and types
- arguments

I would like to keep that as much in a straight line as possible with
what ends up in the trace.

However, I see that it limits what can be done by in-kernel tracers. And
by the way, I also suffer from the same kind of limitation in LTTng. Here
is an example :

I would like to replace blktrace (actually, I already have a quite
complete implementation). However, there is some code ran in the kernel
to "prepare" the information for the trace which is blktrace specific.
Since this code is not required to run when tracing is disabled, it can
be seen as "glue-code" between the kernel tracing point and the
extraction of data to trace.

What looked like the less intrusive solution was to create inline
functions that consist of branches over code considered unlikely (could
be a function call) where the glue-code is executed to prepare the data.
It's a bit like what the markers are doing, except that there is no
marker name associated and no format string : the subsystem being traced
must enable its tracing features by itself (could be a /proc file). It
makes sense, since this type of code has to be subsystem-specific
anyway.

But I have not seen a lot of situations where that kind of glue-code was
needed, so I think it makes sense to keep markers simple to use and
efficient for the common case.

Then, in this glue-code, we can put trace_mark() and calls to in-kernel
tracers.

Since the markers are eventually meant to become an API visible from
user-space, I think it makes sense to keep it clean. If an in-kernel
tracer needs extra information, I think it would make sense for it to
get it from a mechanism that does not make the exported information
visible to user-space.

What do you think ?


> >
> > > The '\0' would keep your tracer from recording the extra data, and we
> > > could add some way to ignore the parameters in the printf to let other
> > > traces get straight to the meta data.
> >
> > This \0 hack is perhaps too clever.  Much of the cost of the extra
> > parameters is already paid by the time that a simpleminded tracing
> > callback function starts going through the string.  Also, I believe
> > the systemtap marker interface would break if the format strings were
> > not singly terminated ordinary strings.
> 
> Well, actually when I first wrote this letter, I used "--" as a delimiter
> to allow a tool to hide the pretty stuff. But then I thought about the
> "clever hack" with the '\0',  The "--" may be better since it wont break
> systemtap.
> 

It could be done I guess. But it looks a bit ugly. :) I would rather
prefer to export the "pretty stuff" through an interface not involving
markers. Or if there is a way to separate the "callback" mechanism from
the "export to user-space" API parts of the markers, I am open to
proposals.

Mathieu

> -- Steve
> 
> * dvhart - bah!
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
