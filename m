Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460Ab0CJH4c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 02:56:32 -0500
Received: from www.tglx.de ([62.245.132.106]:38811 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574Ab0CJH4a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 02:56:30 -0500
Date: Wed, 10 Mar 2010 08:56:22 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yong Zhang <yong.zhang@windriver.com>
cc: Lars-Peter Clausen <lars@metafoo.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] IRQ: Fix oneshot irq race between irq_finalize_oneshot
 and handle_level_irq
In-Reply-To: <20100310032102.GA2090@windriver.com>
Message-ID: <alpine.LFD.2.00.1003100848380.22855@localhost.localdomain>
References: <1268092679-18070-1-git-send-email-lars@metafoo.de> <alpine.LFD.2.00.1003091959080.22855@localhost.localdomain> <20100310032102.GA2090@windriver.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Mar 2010, Yong Zhang wrote:

> On Wed, Mar 10, 2010 at 12:22:12AM +0100, Thomas Gleixner wrote:
> > B1;2005;0cOn Tue, 9 Mar 2010, Lars-Peter Clausen wrote:
> > >  
> > > -	desc->status |= IRQ_INPROGRESS;
> > > +	desc->status |= IRQ_INPROGRESS | IRQ_ONESHOT_INPROGRESS;
> > >  	raw_spin_unlock(&desc->lock);
> > 
> > That keeps the IRQ_ONESHOT_INPROGRESS dangling for non ONESHOT
> > interrupts. Not a big deal, but not pretty either.
> >   
> > The race between the thread and the irq handler exists indeed on SMP,
> > but I think there are more fundamental issues about the state which
> > need to be addressed.
> > 
> > The first thing is that we do not mark the status MASKED when we
> > actually mask the interrupt in mask_ack_irq(). 
> > 
> > That conditional MASKED after running the primary handler is really
> > horrible - I already ranted in private at the moron who committed that
> > crime :)
> > 
> > So the following patch fixes that and the SMP race scenario:
> 
> Hi Thomas,
> 
> How about the following patch(maybe a little ugly). I think it will
> resolve your concerns.

No it does not, but you are right that it's ugly. And it is patently
wrong as well.
 
> diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
> index d70394f..23b79c6 100644
> --- a/kernel/irq/chip.c
> +++ b/kernel/irq/chip.c
> @@ -461,9 +461,24 @@ handle_level_irq(unsigned int irq, struct irq_desc *desc)
>  	raw_spin_lock(&desc->lock);
>  	mask_ack_irq(desc, irq);
>  
> -	if (unlikely(desc->status & IRQ_INPROGRESS))
> -		goto out_unlock;
> +	/*
> +	 * if we are in oneshot mode and the irq thread is running on
> +	 * another cpu, just return because the irq thread will unmask
> +	 * the irq
> +	 */
> +	if (unlikely(desc->status & IRQ_ONESHOT)) {
> +		if (unlikely(desc->status & (IRQ_INPROGRESS | IRQ_MASKED)
> +					  == IRQ_INPROGRESS | IRQ_MASKED))
> +			goto out_unlock;
> +	}
> +	else {
> +		if (unlikely(desc->status & IRQ_INPROGRESS))
> +			goto out_unlock;
> +	}

  In case of IRQ_SHOT and IRQ_INPROGRESS and the other CPU having
  unmasked the interrupt already you are reentering the handler which
  is a nono.

Thanks,

	tglx
