Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679Ab0CKC4Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 21:56:16 -0500
Received: from mail.windriver.com ([147.11.1.11]:63486 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926Ab0CKC4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 21:56:15 -0500
Date: Thu, 11 Mar 2010 10:55:33 +0800
From: Yong Zhang <yong.zhang@windriver.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Lars-Peter Clausen <lars@metafoo.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] IRQ: Fix oneshot irq race between
 irq_finalize_oneshot and handle_level_irq
Message-ID: <20100311025533.GB8389@windriver.com>
Reply-To: Yong Zhang <yong.zhang@windriver.com>
References: <1268092679-18070-1-git-send-email-lars@metafoo.de>
 <alpine.LFD.2.00.1003091959080.22855@localhost.localdomain>
 <20100310032102.GA2090@windriver.com>
 <alpine.LFD.2.00.1003100848380.22855@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1003100848380.22855@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 11 Mar 2010 02:55:35.0013 (UTC) FILETIME=[524A2950:01CAC0C6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 10, 2010 at 08:56:22AM +0100, Thomas Gleixner wrote:
> > How about the following patch(maybe a little ugly). I think it will
> > resolve your concerns.
> 
> No it does not, but you are right that it's ugly. And it is patently
> wrong as well.
>  
> > diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
> > index d70394f..23b79c6 100644
> > --- a/kernel/irq/chip.c
> > +++ b/kernel/irq/chip.c
> > @@ -461,9 +461,24 @@ handle_level_irq(unsigned int irq, struct irq_desc *desc)
> >  	raw_spin_lock(&desc->lock);
> >  	mask_ack_irq(desc, irq);

I must say this patch isn't based on your previous one in which
mask_ack_irq() is modified to flag IRQ_MASKED.
I let IRQ_MASKED serialise interrupt-handler and irq-thread in oneshot
mode. 

> >  
> > -	if (unlikely(desc->status & IRQ_INPROGRESS))
> > -		goto out_unlock;
> > +	/*
> > +	 * if we are in oneshot mode and the irq thread is running on
> > +	 * another cpu, just return because the irq thread will unmask
> > +	 * the irq
> > +	 */
> > +	if (unlikely(desc->status & IRQ_ONESHOT)) {
> > +		if (unlikely(desc->status & (IRQ_INPROGRESS | IRQ_MASKED)
> > +					  == IRQ_INPROGRESS | IRQ_MASKED))
> > +			goto out_unlock;
> > +	}
> > +	else {
> > +		if (unlikely(desc->status & IRQ_INPROGRESS))
> > +			goto out_unlock;
> > +	}
> 
>   In case of IRQ_SHOT and IRQ_INPROGRESS and the other CPU having
>   unmasked the interrupt already you are reentering the handler which
>   is a nono.

I have thought of that kind of reentering you point above,
if IRQ_MASKED is cleared by irq_finalize_oneshot(), the thread_fn()
is done as well as the hardware opration. If another irq comes in,
the reentering does happen, but I think it's harmless because at
this time we just set IRQTF_RUNTHREAD and IRQ_MASKED and wake
irq thread up and then the irq thread loops for another time.
So irq will not return unmask in case of oneshot.

If I miss something, correct me please.

Thanks,
Yong


