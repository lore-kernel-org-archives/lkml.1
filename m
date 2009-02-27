Return-Path: <linux-kernel-owner+w=401wt.eu-S1758116AbZB0IQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758116AbZB0IQf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 03:16:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755037AbZB0IQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 03:16:26 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51628 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755026AbZB0IQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 03:16:26 -0500
Date: Fri, 27 Feb 2009 00:15:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, rostedt@goodmis.org, jonathan@jonmasters.org
Subject: Re: [patch 4/4] genirq: add support for threaded interrupt handlers
Message-Id: <20090227001532.5dd84c2d.akpm@linux-foundation.org>
In-Reply-To: <1235721910.4948.1321.camel@laptop>
References: <20090226131336.423054348@linutronix.de>
	<20090226131719.760899560@linutronix.de>
	<20090226153216.5db66bc3.akpm@linux-foundation.org>
	<20090226212752.332ba546@infradead.org>
	<20090226214514.f8a58731.akpm@linux-foundation.org>
	<1235719113.4948.1252.camel@laptop>
	<20090226234800.4977fca5.akpm@linux-foundation.org>
	<1235721910.4948.1321.camel@laptop>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Feb 2009 09:05:10 +0100 Peter Zijlstra <peterz@infradead.org> wrote:

> > What is the plan (if any) for integrating threaded interrupt handlers
> > with softirqs?  I guess things will "just work" at present, and
> > threaded softirqs happen in a later patch?
> 
> Thing is, stuff that now needs softirq could be directly done in the
> threaded handler, ergo softirq usage should decline (and hopefully
> disappear all together - famous last words).
> 
> We only use softirq/workqueues/tasklets because we need a preemptible
> environment, which the traditional irq handler didn't provide. With
> threaded interrupts we do have that.

ah.  I was specifically thinking of net/core/dev.c.  That's our
heaviest user of interrupts and softirqs, I expect?

> > I'd have thought that the softirq latency could get quite a bit worse
> > with this proposed threaded-irq patch?
> 
> Due to the propagation of wakeups? irq wakes up thread, thread wakes up
> softirq, etc?
> 
> Yes it would, another good reason to simply use the threaded handler to
> do whatever the softirq used to do, no?
> 
> > I suppose we could just run the softirq handlers directly after running
> > the irq handler, from the IRQ thread.  Rather than having to poke
> > softirqd all the time?
> 
> One could I suppose, except that softirqs are per-cpu and threaded
> interrupts are not, so they don't map that well. We played around with
> this on preempt-rt for a while, but it kept on breaking stuff.
> 
> Its all a lot more tracktable when you get to change the driver, as you
> have more information.
> 
> > Thwap me if this was all in whatever-changelog-that-was as well ;)
> 
> Hehe, no you got some good points this time around ;-)
> 
> > Also...
> > 
> > Given that this threaded-irq code appears to be new and not very tested
> > in -rt, I think it would be a good idea to convert some popular drivers
> > (e1000/e1000e) so that the core code gets a good thrashing before we
> > merge it.
> 
> Right, Thomas did the EHCI usb driver, the network driver you propose is
> a tad hard since it relies on the whole network stack softirq stuff.
> Re-working the whole net-stack to make use of threaded handlers is a
> massive undertaking

oh.  That rather changes the perspective on the whole exercise.  hrm.

> -- although I seem to remember someone doing it a
> few years back and seeing a general performance improvement, Thomas
> still got a link to that work?
> 
> But yes, it would be prudent to convert a few frequently used driver to
> this model before merging I suppose.
