Return-Path: <linux-kernel-owner+w=401wt.eu-S1763264AbYGBJu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763264AbYGBJu2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 05:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753870AbYGBJuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 05:50:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54531 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753508AbYGBJuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 05:50:16 -0400
Date: Wed, 2 Jul 2008 02:49:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
Cc: <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] handle failure of irqchip->set_type in setup_irq
Message-Id: <20080702024926.59488cc7.akpm@linux-foundation.org>
In-Reply-To: <20080702091757.GA1144@digi.com>
References: <20080625131101.GA6205@digi.com>
	<20080702091757.GA1144@digi.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jul 2008 11:17:57 +0200 Uwe Kleine-K__nig <Uwe.Kleine-Koenig@digi.com> wrote:

> Hello,
> 
> [extending the Cc: list]
> 
> Uwe Kleine-K__nig wrote:
> > set_type returns an int but currently setup_irq ignores that.
> > 
> > To save me from undoing some changes setting the IRQ_NO_BALANCING bit in
> > desc->flags, setting IRQ_PER_CPU in desc->status and adding the new
> > action to desc is only done after set_type succeeded.
> > 
> > Signed-off-by: Uwe Kleine-K__nig <Uwe.Kleine-Koenig@digi.com>
> > ---
> > Hello,
> > 
> > in my case set_type returns an error because gpio-key tries to use
> > IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING and my irq-chip can only do
> > one of these.
> 
> up to now I didn't get any response for this patch.  It addresses a real
> problem for my platform so I really like to have a fix in.
> 
> In mmotm of 2008-07-01-21-57 kernel/irq/manage.c is touched[1],
> too, but git was able to automerge the change correctly when applying it
> on top of mmotm.
> 
> For your convenience you can find the patch again at the end of this
> mail.
> 
> Andrew:  Do you can take this patch into mm?
> 

>From a brief squint the patch seems to be reasonable.  But the
changelog is a bit mangled.  Perhaps you could have another go when
resending it.  Explan more clearly under what circumststances your
->set_type() implementation can fail and why you require the core code
to handle this.

Perhaps we want a dump_stack() on the error path so we can see who
goofed.  Or a print_symbol() of desc->chip->set_type.  Or perhaps not.

Did you check that all the current ->set_type() implementations are
returning zero?


> 
> [1] kernel/irq/manage.c is modified by linux-next patch.  The relevant
>     commit is:
> 	1840475... genirq: Expose default irq affinity mask (take 3)
> 
> 
> > diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> > index 46d6611..bc990a1 100644
> > --- a/kernel/irq/manage.c
> > +++ b/kernel/irq/manage.c
> > @@ -281,6 +281,7 @@ int setup_irq(unsigned int irq, struct irqaction *new)
> >  	const char *old_name = NULL;
> >  	unsigned long flags;
> >  	int shared = 0;
> > +	int ret;
> >  
> >  	if (irq >= NR_IRQS)
> >  		return -EINVAL;
> > @@ -338,26 +339,23 @@ int setup_irq(unsigned int irq, struct irqaction *new)
> >  		shared = 1;
> >  	}
> >  
> > -	*p = new;
> > -
> > -	/* Exclude IRQ from balancing */
> > -	if (new->flags & IRQF_NOBALANCING)
> > -		desc->status |= IRQ_NO_BALANCING;
> > -
> >  	if (!shared) {
> >  		irq_chip_set_defaults(desc->chip);
> >  
> > -#if defined(CONFIG_IRQ_PER_CPU)
> > -		if (new->flags & IRQF_PERCPU)
> > -			desc->status |= IRQ_PER_CPU;
> > -#endif
> > -
> >  		/* Setup the type (level, edge polarity) if configured: */
> >  		if (new->flags & IRQF_TRIGGER_MASK) {
> > -			if (desc->chip && desc->chip->set_type)
> > -				desc->chip->set_type(irq,
> > +			if (desc->chip && desc->chip->set_type) {
> > +				ret = desc->chip->set_type(irq,
> >  						new->flags & IRQF_TRIGGER_MASK);
> > -			else
> > +				if (ret) {
> > +					pr_err("setting flow type for irq %u "
> > +							"failed\n", irq);
> > +					spin_unlock_irqrestore(&desc->lock,
> > +							flags);
> > +					return ret;
> > +				}
> > +
> > +			} else
> >  				/*
> >  				 * IRQF_TRIGGER_* but the PIC does not support
> >  				 * multiple flow-types?
> > @@ -369,6 +367,11 @@ int setup_irq(unsigned int irq, struct irqaction *new)
> >  		} else
> >  			compat_irq_chip_set_default_handler(desc);
> >  
> > +#if defined(CONFIG_IRQ_PER_CPU)
> > +		if (new->flags & IRQF_PERCPU)
> > +			desc->status |= IRQ_PER_CPU;
> > +#endif
> > +
> >  		desc->status &= ~(IRQ_AUTODETECT | IRQ_WAITING |
> >  				  IRQ_INPROGRESS | IRQ_SPURIOUS_DISABLED);
> >  
> > @@ -383,6 +386,13 @@ int setup_irq(unsigned int irq, struct irqaction *new)
> >  			/* Undo nested disables: */
> >  			desc->depth = 1;
> >  	}
> > +
> > +	*p = new;
> > +
> > +	/* Exclude IRQ from balancing */
> > +	if (new->flags & IRQF_NOBALANCING)
> > +		desc->status |= IRQ_NO_BALANCING;
> > +
> >  	/* Reset broken irq detection when installing new handler */
> >  	desc->irq_count = 0;
> >  	desc->irqs_unhandled = 0;

