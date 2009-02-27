Return-Path: <linux-kernel-owner+w=401wt.eu-S1757411AbZB0IFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757411AbZB0IFv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 03:05:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754248AbZB0IFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 03:05:42 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:54683 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753682AbZB0IFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 03:05:41 -0500
Subject: Re: [patch 4/4] genirq: add support for threaded interrupt handlers
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, rostedt@goodmis.org, jonathan@jonmasters.org
In-Reply-To: <20090226234800.4977fca5.akpm@linux-foundation.org>
References: <20090226131336.423054348@linutronix.de>
	 <20090226131719.760899560@linutronix.de>
	 <20090226153216.5db66bc3.akpm@linux-foundation.org>
	 <20090226212752.332ba546@infradead.org>
	 <20090226214514.f8a58731.akpm@linux-foundation.org>
	 <1235719113.4948.1252.camel@laptop>
	 <20090226234800.4977fca5.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 27 Feb 2009 09:05:10 +0100
Message-Id: <1235721910.4948.1321.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-26 at 23:48 -0800, Andrew Morton wrote:

> > > I was actually kinda surprised by the patch - it needs moderate changes
> > > to each driver.  I'd have thought that it would be possible to arrange for
> > > _all_ drivers to have their interrupt handlers automagically called from
> > > process context with no driver changes.
> > > 
> > > Did anyone ever try that?  I think they did...
> > 
> > Yes, current preempt-rt does exactly that, as mentioned in the
> > changelog. That same changelog also mentions why this isn't such a hot
> > idea:
> > 
> > 
> > "The implementation provides an opt-in mechanism to convert drivers to
> > the threaded interrupt handler model contrary to the preempt-rt patch
> > where the threaded handlers are enabled by a brute force switch. The
> > brute force switch is suboptimal as it does not change the interrupt
> > handler -> tasklet/softirq interaction problems, but was the only way
> > which was possible for the limited man power of the preempt-rt
> > developers."
> > 
> > 
> > So the idea is that we want people to re-think and change their
> > interrupt routines to take advantage of the benefits of threaded
> > interrupts and avoid the endless context switching between threaded
> > interrupts handler, softirq/tasklet/workqueue contexts, which preempt-rt
> > now has.
> > 
> > The only way to avoid that is by pushing all softirq/tasklet/worklet
> > code into the threaded handler, and the only way to do that is by
> > reworking the drivers.
> > 
> > Since there are too many drivers to count on our few hands, we need an
> > opt-in, so that we can gradually migrate towards this scheme.
> 
> OK, fair enough, good decision.
> 
> What is the plan (if any) for integrating threaded interrupt handlers
> with softirqs?  I guess things will "just work" at present, and
> threaded softirqs happen in a later patch?

Thing is, stuff that now needs softirq could be directly done in the
threaded handler, ergo softirq usage should decline (and hopefully
disappear all together - famous last words).

We only use softirq/workqueues/tasklets because we need a preemptible
environment, which the traditional irq handler didn't provide. With
threaded interrupts we do have that.

> I'd have thought that the softirq latency could get quite a bit worse
> with this proposed threaded-irq patch?

Due to the propagation of wakeups? irq wakes up thread, thread wakes up
softirq, etc?

Yes it would, another good reason to simply use the threaded handler to
do whatever the softirq used to do, no?

> I suppose we could just run the softirq handlers directly after running
> the irq handler, from the IRQ thread.  Rather than having to poke
> softirqd all the time?

One could I suppose, except that softirqs are per-cpu and threaded
interrupts are not, so they don't map that well. We played around with
this on preempt-rt for a while, but it kept on breaking stuff.

Its all a lot more tracktable when you get to change the driver, as you
have more information.

> Thwap me if this was all in whatever-changelog-that-was as well ;)

Hehe, no you got some good points this time around ;-)

> Also...
> 
> Given that this threaded-irq code appears to be new and not very tested
> in -rt, I think it would be a good idea to convert some popular drivers
> (e1000/e1000e) so that the core code gets a good thrashing before we
> merge it.

Right, Thomas did the EHCI usb driver, the network driver you propose is
a tad hard since it relies on the whole network stack softirq stuff.
Re-working the whole net-stack to make use of threaded handlers is a
massive undertaking -- although I seem to remember someone doing it a
few years back and seeing a general performance improvement, Thomas
still got a link to that work?

But yes, it would be prudent to convert a few frequently used driver to
this model before merging I suppose.

