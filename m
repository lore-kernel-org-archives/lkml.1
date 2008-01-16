Return-Path: <linux-kernel-owner+w=401wt.eu-S1754579AbYAPUW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579AbYAPUW1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 15:22:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752606AbYAPUWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 15:22:18 -0500
Received: from tomts16.bellnexxia.net ([209.226.175.4]:46414 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752602AbYAPUWR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 15:22:17 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aj0KAHT2jUdMROHU/2dsb2JhbACBWJAPnEM
Date: Wed, 16 Jan 2008 15:17:13 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
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
Message-ID: <20080116201713.GA14336@Krystal>
References: <20080115220824.GB22242@Krystal> <Pine.LNX.4.58.0801151717250.29090@gandalf.stny.rr.com> <20080116031730.GA2164@Krystal> <Pine.LNX.4.58.0801152238130.19680@gandalf.stny.rr.com> <20080116145604.GB31329@Krystal> <Pine.LNX.4.58.0801161003010.15758@gandalf.stny.rr.com> <20080116152838.GA970@Krystal> <Pine.LNX.4.58.0801161041010.15998@gandalf.stny.rr.com> <20080116170011.GA3651@Krystal> <Pine.LNX.4.58.0801161428180.14368@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <Pine.LNX.4.58.0801161428180.14368@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:57:23 up 74 days,  1:02,  7 users,  load average: 0.15, 0.19,
	0.18
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
 ...
> >
> > > >
> > > > - Disable preemption at the read-side :
> > > >   it makes sure the pointer I get will point to a data structure that
> > > >   will never change while I am in the preempt disabled code. (see *)
> > > > - I use per-cpu data to allow the read-side to be as fast as possible
> > > >   (only need to disable preemption, does not race against other CPUs and
> > > >   won't generate cache line bouncing). It also allows dealing with
> > > >   unsynchronized TSCs if needed.
> > > > - Periodical write side : it's called from an IPI running on each CPU.
> > > >
> > > > (*) We expect the read-side (preempt off region) to last shorter than
> > > > the interval between IPI updates so we can guarantee the data structure
> > > > it uses won't be modified underneath it. Since the IPI update is
> > > > launched each seconds or so (depends on the frequency of the counter we
> > > > are trying to extend), it's more than ok.
> > >
> > > One thing I want to clear up. The major difference between this
> > > latency_tracer and LTTng is what we consider fast paths.  The latency
> > > tracer is recording things like enabling and disabling interrupts, preempt
> > > count changes, or simply profiling all function calls.  Those are what I
> > > consider fast paths.  The slow path WRT the latency_tracer are things like
> > > context switches.  This is why I don't have a problem with copying the
> > > comm at context switch time. Because that _is_ a slow path for the latency
> > > tracer.
> >
> > LTTng hooks in the lockdep tracer to trace irq on/off, spinlocks, etc..
> > in flight recorder mode, we have nothing to write to disk and therefore
> > we can handle very frequent events. We then do the analysis off-line
> > using the last MB written in the buffers. The advantage is that the
> > kernel dumbly writes data to a buffer : we therefore move the complexity
> > to user-space.
> 
> But you would still need to do something in case you want this information
> dumped to console on a kernel crash.  Of course you can rely on kexec, but
> if the kexec fails (which is possible) then you lose all the information.
> Having the ability to dump the output to console on a crash is one of the
> benefits of latency_tracer that I want to keep.
> 

There has been some integration done between LTTng and the "crash" tool
to extract the buffers from a crashed kernel. I am not an expert in
crash buffer extraction though, but I guess all the available mechanisms
depend on kexec and could show the limits you are referring to.

If you really want to pretty-print the information to the console, I
would propose that you leave that part of the problem to a different
output module. The core of the latency tracer could keep the minimum
information. Then, when a dump is triggered, it either sends the
information to LTTng or to your console pretty-printer.

However, I would not call the pretty-printer a "tracer" module per-se.
We would have to accept that it is a bit more tied to the kernel
internals than the latency tracer. My goal is to separate the core
"profiling" module from the optional "pretty-printing" module as much as
possible so the latency tracer core could be reused by other output
modules.

> 
> >
> > I agree that some kind of tracing, like the one you are doing, might be
> > done more efficiently if you do a first clever analysis phase directly
> > in the kernel without writing the raw high event rate data in memory
> > buffers. However, I believe that it would be more powerful if we combine
> > the two approaches rather than trying to do everything in or out of the
> > kernel.  LTTng could provide the comm names, priorities, etc, and your
> > tracer could provide the top X list of processes that had a bad
> > behavior. It would mean that the complete overall information would be
> > made available after a post-processing phase done in an analysis tool
> > like LTTV, but I don't see any problem with it.
> 
> Of course you don't see any problem with it, because you know LTTV and
> LTTng very well ;-)
> 
> latency_tracer has been very detrimental in solving -rt patch latencies by
> telling the customer to run with latency trace on, and then having them
> simply set a few sysctl variables and run their app.  By combining this
> with LTTng, I wouldn't know how to start with telling a customer how to
> analyze the problem.
> 
> Simply put, latency_tracer has a much smaller learning curve than LTTng.
> Not to mention, a smaller footprint. The tracer here is very focused on
> what to do, and is not meant to be a general profiling tool as LTTng is.
> 
> In-other-words, latency_tracer is LTTng-lite ;-)
> 

If LTTng is already ported to your specific kernel, the learning-curve
is not big at all. Here is what the latency_tracer over LTTng guide
could look like :

Well, once you have LTTng in your kernel and have compiled and installed
the ltt-control and lttv packages (configure, make, make install), all
that would be needed is :

(there may be some bits in the QUICKSTART GUIDE on
http://ltt.polymtl.ca, like adding the debugfs mount to fstab and make sure
the LTTng modules are loaded)

#arm all the markers
ltt-armall
#start lttng tracing
lttctl -n test -t /tmp/trace1 -d -l /mnt/debugfs/ltt

-> start latency tracer
-> stop latency tracer
-> trigger latency tracer dump

While the tracing is active, trigger the condition...

(rince, repeat, can handle multiple latency tracer dumps)

#stop lttng tracing
lttctl -n test -R
#disarm all markers
ltt-disarmall

You can easily test the trace with :
lttv -m textDump -t /tmp/trace1

Your users would issue something like :

lttv -m latencytracerDump -t /tmp/trace1

that's it. LatencytracerDump would be a new specialized plugin, inspired
from the generic textDump.c plugin and from the state.c module (for
hooking on specific events rather that on _all_ events). It would
generate a text output from the trace collected at each latency tracer
dump.

Mathieu


-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
