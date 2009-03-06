Return-Path: <linux-kernel-owner+w=401wt.eu-S1755748AbZCFOmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748AbZCFOmX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 09:42:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754464AbZCFOmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 09:42:10 -0500
Received: from www.tglx.de ([62.245.132.106]:39806 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752428AbZCFOmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 09:42:08 -0500
Date: Fri, 6 Mar 2009 15:40:51 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: David Brownell <david-b@pacbell.net>
cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>, me@felipebalbi.com,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       felipe.balbi@nokia.com, dmitry.torokhov@gmail.com, sameo@openedhand.com
Subject: Re: lockdep and threaded IRQs (was: ...)
In-Reply-To: <200903041850.00108.david-b@pacbell.net>
Message-ID: <alpine.LFD.2.00.0903061313470.29264@localhost.localdomain>
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com> <200903021542.25153.david-b@pacbell.net> <alpine.LFD.2.00.0903031207240.29264@localhost.localdomain> <200903041850.00108.david-b@pacbell.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1342223903-1236345916=:29264"
Content-ID: <alpine.LFD.2.00.0903061507500.29264@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1342223903-1236345916=:29264
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.LFD.2.00.0903061507501.29264@localhost.localdomain>

David,

On Wed, 4 Mar 2009, David Brownell wrote:

> On Tuesday 03 March 2009, Thomas Gleixner wrote:
> > > 
> > > > [patch 0/4] genirq: add infrastructure for threaded interrupt handlers V2
> > > 
> > > I did check them out, as noted earlier in this thread.
> > > 
> > > The significant omission is lack of support for chaining
> > > such threads.  Example, an I2C device that exposes
> > > several dozen IRQs with mask/ack/... operations that
> > > require I2C access.
> > 
> > Well, the significant omission is on your side.
> 
> The facts don't quite match up with that story though ... for
> starters, as I've already pointed out in this thread, I didn't
> write that code (or even "create a private form of abuse" as 
> you put it).  My name isn't even on the copyright. 
> 
> I did however clean it up a lot, in hope that such cleanup
> would make later updates easier.  Anyone could tell such
> updates would be needed.  In fact ...

Sorry, did not realize that it was not your design in the first place.
 
> Your IRQ threading patches appeared well after this driver went
> to mainline.  So I did talk to "us" about those problems, earlier,
> but it doesn't seem to have gotten your attention until now.

Fair enough. I did not realize the horror of this chip until now. From
what you told me at KS I figured it would be a halfways straight
forward thing.
 
> You're referring to the second issue.  The code in
> question doesn't actually have any dependency on
> hardirq context though.

Err. handle_IRQ_event was never meant to run in thread context,
neither the handle_TYPE functions.
 
> Assuming all IRQ configuring and dispatching runs with IRQs
> disabled.  Your threaded IRQ patches kick in only *after*
> dispatching has been done.  So it affects just one of the
> three main unusual bits of behavior involved here.
> 
> Which mess were you thinking of?  :)

None, there is no mess in the irq code.
 
> > The problem you described is straight forward and as I said before
> > it's not rocket science to provide support for that in the genirq
> > code. Your use case does not need to use the chained handler setup at
> > all, it just needs to request the main IRQ as a simple type and handle
> > the ack/mask/unmask from the two handler parts.
> 
> When there is a "main IRQ" that calls the handlers, that's
> exactly what chaining involves ...

And how does this rabulistic nit picking help us here ? :)

Again: the chained_handler functionality was never designed to run in
a thread.
 
> > The only change in the generic code which is needed is a new handler
> > function for the chained irqs "handle_irq_simple_threaded()" which is
> > designed to handle the calls from thread context.
> 
> I'm not 100% sure that's right; the dispatching is a bit quirky.
> That is however where I'll start.
> 
> The top level handler (for the PIH module) could easily use a
> "handle_irq_simple_threaded()", yes ... but the secondary (SIH)
> handlers have a few oddball behaviors including mixes of edge
> and level trigger modes. 

I took a closer look at this code and the more I look the more it
confuses me.

You told me that the demux handler runs the secondary handlers in its
thread context, but looking at the code there is a work queue as well.

The mask/unmask functions which are called for the secondary handlers
are just queueing work. I really do not understand the logic here:

    primary interrupt happens
      ->primary thread is woken up

    primary thread runs
      -> primary thread raises secondary irq via 
         generic_handle_irq(irq), which results in:
	 	 desc->handle_irq(irq, desc);
 
The secondary handler has is set to: handle_edge_irq and
handle_edge_irq() does: desc->chip->ack(irq);

But the irqchip, which is set for those secondary irqs has a NULL ack
function. How can this work at all ?

I'm probably missing something and I would appreciate if you could
shed some light on this. An abstract description of the requirements
of the hardware w/o any reference to the current implementation would
be definitely helpful.

Thanks,

	tglx

--8323328-1342223903-1236345916=:29264--
