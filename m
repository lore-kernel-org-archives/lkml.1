Return-Path: <linux-kernel-owner+w=401wt.eu-S1762874AbXKOLGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762874AbXKOLGT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 06:06:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751313AbXKOLGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 06:06:07 -0500
Received: from ozlabs.org ([203.10.76.45]:33425 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755920AbXKOLGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 06:06:05 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [patch 5/8] Immediate Values - x86 Optimization
Date: Thu, 15 Nov 2007 22:06:06 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@muc.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20071113185800.436425570@polymtl.ca> <200711151545.19359.rusty@rustcorp.com.au> <20071115053751.GB26338@Krystal>
In-Reply-To: <20071115053751.GB26338@Krystal>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711152206.07519.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 November 2007 16:37:51 Mathieu Desnoyers wrote:
> * Rusty Russell (rusty@rustcorp.com.au) wrote:
> > On Thursday 15 November 2007 15:06:10 Mathieu Desnoyers wrote:
> > > A - the NMI or MCE code calls any external kernel code (printk,
> > >   notify_die, spin_lock/unlock, die_nmi, lapic_wd_event (perfctr code,
> > >   calls printk too for debugging)...
> >
> > Sure, but as I pointed out previously, such calls are already best
> > effort. You can do very little safely from do_nmi(), and calling printk
> > isn't one of them,
>
> yes and no.. do_nmi uses the "bust spinlocks" exactly for this. So this
> is ok by design.

Yeah, in the "machine is dying" case, we do make best effort to get the 
message out.  Worrying about a GPF on the off chance we happen to be 
modifying an immediate in that case seems crazy.

> > nor is grabbing a spinlock (well, actually you could as long as it's
> > *only* used by NMI handlers.  See any of those?).
>
> Yup, see arch/x86/kernel/nmi_64.c : nmi_watchdog_tick()
>
> It defines a spinlock to "Serialise the printks". I guess it's good to
> protect against other nmi watchdogs running on other CPUs concurrently,
> I guess.

So that when it's printing a backtrace from an NMI.

> > > Therefore, if one decides to use the immediate values to
> > > leave dormant spinlock instrumentation in the kernel, I wouldn't want
> > > it to have undesirable side-effects (GPF) when the instrumentation is
> > > being enabled, as rare as it could be.
> >
> > It's overengineered, since it's less likely than deadlock already.
>
> So should we put a warning telling "enabling tracing or profiling on a
> production system that also uses NMI watchdog could potentially cause a
> crash"

Or, "if your system is crashing, this may make it worse".

> arch/x86/kernel/immediate.o : 2.4K
>
> let's compare..
>
> kernel/stop_machine.o : 3.9K
>
> so I think that code size is not an issue there, especially since the
> immediate values are not meant to be deployed on embedded systems.

stop_machine is necessary (although it could use simplification, patches 
pending).

> Yup, looping in IPIs with interrupts disabled should do the job there.
> It's just awful for interrupt latency on large SMP systems :(

Yet you could have implemented it in the time it took us to have this 
conversation.

Just because code is clever doesn't mean it should go in.  There are enough 
things in the kernel which have to be complex that we should always be on the 
lookout for things which can be made simpler.

Cheers,
Rusty.
