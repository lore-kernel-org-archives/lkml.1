Return-Path: <linux-kernel-owner+w=401wt.eu-S1756326AbXKOFn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756326AbXKOFn0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 00:43:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751085AbXKOFnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 00:43:17 -0500
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:41001 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750895AbXKOFnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 00:43:16 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAMJrO0dMROHU/2dsb2JhbACBXI5w
Date: Thu, 15 Nov 2007 00:37:51 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@muc.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 5/8] Immediate Values - x86 Optimization
Message-ID: <20071115053751.GB26338@Krystal>
References: <20071113185800.436425570@polymtl.ca> <200711151408.46030.rusty@rustcorp.com.au> <20071115040610.GA23443@Krystal> <200711151545.19359.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <200711151545.19359.rusty@rustcorp.com.au>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 00:08:44 up 11 days, 10:14,  4 users,  load average: 0.04, 0.21,
	0.27
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Rusty Russell (rusty@rustcorp.com.au) wrote:
> On Thursday 15 November 2007 15:06:10 Mathieu Desnoyers wrote:
> > * Rusty Russell (rusty@rustcorp.com.au) wrote:
> > > A stop_machine (or lightweight variant using IPI) would be sufficient and
> > > vastly simpler.  Trying to patch NMI handlers while they're running is
> > > already crazy.
> >
> > I wouldn't mind if it was limited to the code within do_nmi(), but then
> > we would have to accept potential GPF if
> >
> > A - the NMI or MCE code calls any external kernel code (printk,
> >   notify_die, spin_lock/unlock, die_nmi, lapic_wd_event (perfctr code,
> >   calls printk too for debugging)...
> 
> Sure, but as I pointed out previously, such calls are already best effort.  
> You can do very little safely from do_nmi(), and calling printk isn't one of 
> them,

yes and no.. do_nmi uses the "bust spinlocks" exactly for this. So this
is ok by design. Other than this, we can end up mixing up the console
data output with different sources of characters, but I doubt something
really bad can happen (like a deadlock).

> nor is grabbing a spinlock (well, actually you could as long as it's 
> *only* used by NMI handlers.  See any of those?).

Yup, see arch/x86/kernel/nmi_64.c : nmi_watchdog_tick()

It defines a spinlock to "Serialise the printks". I guess it's good to
protect against other nmi watchdogs running on other CPUs concurrently,
I guess.

> 
> > Therefore, if one decides to use the immediate values to
> > leave dormant spinlock instrumentation in the kernel, I wouldn't want it
> > to have undesirable side-effects (GPF) when the instrumentation is
> > being enabled, as rare as it could be.
> 
> It's overengineered, since it's less likely than deadlock already.
> 

So should we put a warning telling "enabling tracing or profiling on a
production system that also uses NMI watchdog could potentially cause a
crash" ? The rarer a bug is, the more difficult it is to debug. It does
not make the bug hurt less when it happens.

The normal thing to do when a potential deadlock is detected is to fix
it, not to leave it there under the premise that it doesn't matter since
it happens rarely. In our case, where we know there is a potential race,
I don't see any reason not to make sure it never happens. What's the
cost of it ?

arch/x86/kernel/immediate.o : 2.4K

let's compare..

kernel/stop_machine.o : 3.9K

so I think that code size is not an issue there, especially since the
immediate values are not meant to be deployed on embedded systems.

> > > I'd keep this version up your sleeve for they day when it's needed.
> >
> > If we choose to go this way, stop_machine would have to do a sync_core()
> > on every CPU before it reactivates interrupts for this to respect
> > Intel's errata.
> 
> Yes, I don't think stop_machine is actually what you want anyway, since you 
> are happy to run in interrupt context.  An IPI-based scheme is probably 
> better, and also has the side effect of iret doing the sync you need, IIUC.
> 

Yup, looping in IPIs with interrupts disabled should do the job there.
It's just awful for interrupt latency on large SMP systems :( Being
currently bad at it is not a reason to make it worse. If we have a CPU
that is within a high latency irq disable region when we send the IPI,
we can easily end up waiting for this critical section to end with
interrupts disabled on all CPUs. The fact that we would wait for the
longest interrupt disable region with IRQs disabled implies that we
increase the maximum latency of the system, by design. I'm not sure I
would like to be the new longest record-beating IRQ off region.

Mathieu

> Hope that clarifies,
> Rusty.

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
