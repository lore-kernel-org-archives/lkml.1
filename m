Return-Path: <linux-kernel-owner+w=401wt.eu-S1757524AbZCRDNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524AbZCRDNa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 23:13:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757201AbZCRDNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 23:13:00 -0400
Received: from n9a.bullet.mail.mud.yahoo.com ([209.191.87.108]:23115 "HELO
	n9a.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756725AbZCRDM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 23:12:59 -0400
X-Greylist: delayed 407 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Mar 2009 23:12:59 EDT
X-Yahoo-Newman-Id: 551972.92534.bm@omp408.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=D0nZFJs17VKDTDE6uHMI0M9WWrw4j5skqT3/SOYz9X4HKlE07utomw3FJ6+Nyj/2BaEqiWPiLEAwwUOUWv9ZtBn3IUUrGPwn4Dbvjq8fFuJPWrZMakRG2lu1DiVhXyxRdkUxAaicIf8dpT9XiRvKgYZkTPRnpjRDcN+kxRXGge4=  ;
X-YMail-OSG: Leox0hcVM1nKRwwGlbtPQYxbSFqQCpHaEQs0xNUWru0PJirjzJvoCNLBSLpF9kJP8Kl4ym7a3YGqSUVNgq5alugJjtzxb._e58SKH6YqnZ_flYZlZ5uPZYJstbScEognu9_xfmdpgZ4NbQI16ki0KjBi
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: lockdep and threaded IRQs (was: ...)
Date: Tue, 17 Mar 2009 20:06:01 -0700
User-Agent: KMail/1.9.10
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>, me@felipebalbi.com,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       felipe.balbi@nokia.com, dmitry.torokhov@gmail.com, sameo@openedhand.com
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com> <200903041850.00108.david-b@pacbell.net> <alpine.LFD.2.00.0903061313470.29264@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903061313470.29264@localhost.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200903172006.01936.david-b@pacbell.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 March 2009, Thomas Gleixner wrote:
> > > The only change in the generic code which is needed is a new handler
> > > function for the chained irqs "handle_irq_simple_threaded()" which is
> > > designed to handle the calls from thread context.
> > 
> > I'm not 100% sure that's right; the dispatching is a bit quirky.
> > That is however where I'll start.

I just sent a pair of patches for that.

They address only part of the chaining issue ...
dispatching from the top level IRQ task, not how
to set it up so that toplevel IRQ doesn't wrongly
appear in interrupt statistics.


> > The top level handler (for the PIH module) could easily use a
> > "handle_irq_simple_threaded()", yes ... but the secondary (SIH)
> > handlers have a few oddball behaviors including mixes of edge
> > and level trigger modes. 
> 
> I took a closer look at this code and the more I look the more it
> confuses me.

Good thing you didn't see the earlier versions!!  ;)


> You told me that the demux handler runs the secondary handlers in its
> thread context, but looking at the code there is a work queue as well.

The workqueue is for irq_chip methods.

THAT is the fundamental squishy thing here:  when registers
associated with an irq_chip (not just the interrupting device)
are inaccessible except in task/sleeping contexts.

It means that three different things must always run in task
context:  (a) irq_chip methods, (b) IRQ flow handlers, and
(c) IRQ action handlers.


Overstating things somewhat ... your irq threading patches
are best suited for offloading code from hardirq context
into task context -- related to case (c), except here the
state needed by the action handler *can't* be accessed in
hardirq context.  But they don't much help with cases (a)
or (b), where such hardirq context was never relevant in
the first place because the irq management registers aren't
accessible there.

 
> The mask/unmask functions which are called for the secondary handlers
> are just queueing work. I really do not understand the logic here:
> 
>     primary interrupt happens
>       ->primary thread is woken up
> 
>     primary thread runs
>       -> primary thread raises secondary irq via 
>          generic_handle_irq(irq), which results in:
> 	 	 desc->handle_irq(irq, desc);

That's not quite exact; there can be more than one level
of dispatch.  In more detail (it affects answers to your
questions):

 1) Primary thread queries the PIH module (up to 8 IRQ
    status bits) to determine which SIH module(s) raised
    an interrupt.

 2) Then it does a normal dispatch -- desc->handle_irq(),
    maybe wrapped in a convenience function -- to the
    next level, specific to that SIH (not limited to
    just 8 status bits).

 3) Now, depending on how that SIH was set up, one
    of two things will happen:

    A) Dispatch through generic SIH module code; as
       with GPIO and "power" IRQs.  Interrupts for
       MMC card detect, RTC alarm, USB transciver,
       "power button", and a few other things go
       this way.  Dispatched by another indirection
       through a desc->handle_irq() invocation.

    B) Dispatch through non-generic SIH module code.
       That's how the keypad and ADC drivers work
       right now; also the battery charger, but that
       driver isn't used much yet due to HW issues.
  

> The secondary handler has is set to: handle_edge_irq and
> handle_edge_irq() does: desc->chip->ack(irq);

That's the (3A) case above.  I was never certain that
needed to be dispatched with the "edge" flow handler
instead of the "simple" one.  And it turns out that
something like "simple" can work fine, as it currently
does in case (3B).

(The trigger type for those IRQs is typically "edge".
But the "edge" flow handler doesn't seem to be the
best match.)


> But the irqchip, which is set for those secondary irqs has a NULL ack
> function. How can this work at all ?

For the PIH level, this hardware is quite odd:  there
are no ack or mask primitives at all.  At that level,
the only way to clear IRQ status is through the the
child (SIH) level status.

For the SIH level, these chips have a mode you may well
have seen on other hardware.  Reading the SIH IRQ status
register implicitly acks the pending IRQs ... "clear on
read" (COR) mode mentioned in the driver.  So no separate
ack() is needed in that case either.


> I'm probably missing something and I would appreciate if you could
> shed some light on this. An abstract description of the requirements
> of the hardware w/o any reference to the current implementation would
> be definitely helpful.

You're probably trying to avoid reading over 900 pages
of the tps65930 (public flavor of twl4030) technical
reference manual ... ;)

I'm not sure how abstract you want.  I'll hope my words
above -- possibly in conjunction with comments in the
current twl4030-irq.c code -- clarify.

- Dave


