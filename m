Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121Ab0CKImH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 03:42:07 -0500
Received: from www.tglx.de ([62.245.132.106]:36277 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090Ab0CKImE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 03:42:04 -0500
Date: Thu, 11 Mar 2010 09:41:45 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yong Zhang <yong.zhang@windriver.com>
cc: Lars-Peter Clausen <lars@metafoo.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] IRQ: Fix oneshot irq race between irq_finalize_oneshot
 and handle_level_irq
In-Reply-To: <20100311025533.GB8389@windriver.com>
Message-ID: <alpine.LFD.2.00.1003110927450.22855@localhost.localdomain>
References: <1268092679-18070-1-git-send-email-lars@metafoo.de> <alpine.LFD.2.00.1003091959080.22855@localhost.localdomain> <20100310032102.GA2090@windriver.com> <alpine.LFD.2.00.1003100848380.22855@localhost.localdomain>
 <20100311025533.GB8389@windriver.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Mar 2010, Yong Zhang wrote:

> On Wed, Mar 10, 2010 at 08:56:22AM +0100, Thomas Gleixner wrote:
> > > How about the following patch(maybe a little ugly). I think it will
> > > resolve your concerns.
> > 
> > No it does not, but you are right that it's ugly. And it is patently
> > wrong as well.
> >  
> > > diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
> > > index d70394f..23b79c6 100644
> > > --- a/kernel/irq/chip.c
> > > +++ b/kernel/irq/chip.c
> > > @@ -461,9 +461,24 @@ handle_level_irq(unsigned int irq, struct irq_desc *desc)
> > >  	raw_spin_lock(&desc->lock);
> > >  	mask_ack_irq(desc, irq);
> 
> I must say this patch isn't based on your previous one in which
> mask_ack_irq() is modified to flag IRQ_MASKED.
>
> I let IRQ_MASKED serialise interrupt-handler and irq-thread in oneshot
> mode. 

And I said in a previous mail, that magically covering stuff with
inconsistent status information is the wrong way to fix it. 

The IRQ_MASKED state is inconsistent in the current code and that
needs to be fixed first.

And your patch does solve nothing at all. It merily violates the
semantics of non reentrant interrupt handlers.

> > >  
> > > -	if (unlikely(desc->status & IRQ_INPROGRESS))
> > > -		goto out_unlock;
> > > +	/*
> > > +	 * if we are in oneshot mode and the irq thread is running on
> > > +	 * another cpu, just return because the irq thread will unmask
> > > +	 * the irq
> > > +	 */
> > > +	if (unlikely(desc->status & IRQ_ONESHOT)) {
> > > +		if (unlikely(desc->status & (IRQ_INPROGRESS | IRQ_MASKED)
> > > +					  == IRQ_INPROGRESS | IRQ_MASKED))
> > > +			goto out_unlock;
> > > +	}
> > > +	else {
> > > +		if (unlikely(desc->status & IRQ_INPROGRESS))
> > > +			goto out_unlock;
> > > +	}
> > 
> >   In case of IRQ_SHOT and IRQ_INPROGRESS and the other CPU having
> >   unmasked the interrupt already you are reentering the handler which
> >   is a nono.
> 
> I have thought of that kind of reentering you point above,
> if IRQ_MASKED is cleared by irq_finalize_oneshot(), the thread_fn()
> is done as well as the hardware opration. If another irq comes in,
> the reentering does happen, but I think it's harmless because at
> this time we just set IRQTF_RUNTHREAD and IRQ_MASKED and wake
> irq thread up and then the irq thread loops for another time.
> So irq will not return unmask in case of oneshot.

No, it is _NOT_ harmless. interrupt handlers are guaranteed _NOT_ to
be reentered. That's why we check the INPROGRESS flag. 

And you totally miss the case which caused the disussion in the first
place: When the thread finishes _before_ the hard irq handler on the
other CPU has set IRQ_MASKED. So this patch solves nothing at all, it
just makes stuff worse than it was.

Here is the solution which solves the inconsistent lock state _AND_
the reentrancy race.

http://git.kernel.org/?p=linux/kernel/git/tip/linux-2.6-tip.git;a=commit;h=0b1adaa031a55e44f5dd942f234bf09d28e8a0d6

The change log has a full explanation of the scenarios.

Thanks,

	tglx
