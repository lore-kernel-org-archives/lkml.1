Return-Path: <linux-kernel-owner+w=401wt.eu-S1763471AbYGBJSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763471AbYGBJSo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 05:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755737AbYGBJSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 05:18:14 -0400
Received: from mail28.messagelabs.com ([216.82.249.131]:3737 "EHLO
	mail28.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755041AbYGBJSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 05:18:07 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-3.tower-28.messagelabs.com!1214990286!4388611!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.14]
Date: Wed, 2 Jul 2008 11:17:57 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: <linux-kernel@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] handle failure of irqchip->set_type in setup_irq
Message-ID: <20080702091757.GA1144@digi.com>
References: <20080625131101.GA6205@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080625131101.GA6205@digi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 02 Jul 2008 09:17:59.0560 (UTC) FILETIME=[856E7080:01C8DC24]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

[extending the Cc: list]

Uwe Kleine-König wrote:
> set_type returns an int but currently setup_irq ignores that.
> 
> To save me from undoing some changes setting the IRQ_NO_BALANCING bit in
> desc->flags, setting IRQ_PER_CPU in desc->status and adding the new
> action to desc is only done after set_type succeeded.
> 
> Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
> ---
> Hello,
> 
> in my case set_type returns an error because gpio-key tries to use
> IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING and my irq-chip can only do
> one of these.

up to now I didn't get any response for this patch.  It addresses a real
problem for my platform so I really like to have a fix in.

In mmotm of 2008-07-01-21-57 kernel/irq/manage.c is touched[1],
too, but git was able to automerge the change correctly when applying it
on top of mmotm.

For your convenience you can find the patch again at the end of this
mail.

Andrew:  Do you can take this patch into mm?

Best regards
Uwe

[1] kernel/irq/manage.c is modified by linux-next patch.  The relevant
    commit is:
	1840475... genirq: Expose default irq affinity mask (take 3)


> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> index 46d6611..bc990a1 100644
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -281,6 +281,7 @@ int setup_irq(unsigned int irq, struct irqaction *new)
>  	const char *old_name = NULL;
>  	unsigned long flags;
>  	int shared = 0;
> +	int ret;
>  
>  	if (irq >= NR_IRQS)
>  		return -EINVAL;
> @@ -338,26 +339,23 @@ int setup_irq(unsigned int irq, struct irqaction *new)
>  		shared = 1;
>  	}
>  
> -	*p = new;
> -
> -	/* Exclude IRQ from balancing */
> -	if (new->flags & IRQF_NOBALANCING)
> -		desc->status |= IRQ_NO_BALANCING;
> -
>  	if (!shared) {
>  		irq_chip_set_defaults(desc->chip);
>  
> -#if defined(CONFIG_IRQ_PER_CPU)
> -		if (new->flags & IRQF_PERCPU)
> -			desc->status |= IRQ_PER_CPU;
> -#endif
> -
>  		/* Setup the type (level, edge polarity) if configured: */
>  		if (new->flags & IRQF_TRIGGER_MASK) {
> -			if (desc->chip && desc->chip->set_type)
> -				desc->chip->set_type(irq,
> +			if (desc->chip && desc->chip->set_type) {
> +				ret = desc->chip->set_type(irq,
>  						new->flags & IRQF_TRIGGER_MASK);
> -			else
> +				if (ret) {
> +					pr_err("setting flow type for irq %u "
> +							"failed\n", irq);
> +					spin_unlock_irqrestore(&desc->lock,
> +							flags);
> +					return ret;
> +				}
> +
> +			} else
>  				/*
>  				 * IRQF_TRIGGER_* but the PIC does not support
>  				 * multiple flow-types?
> @@ -369,6 +367,11 @@ int setup_irq(unsigned int irq, struct irqaction *new)
>  		} else
>  			compat_irq_chip_set_default_handler(desc);
>  
> +#if defined(CONFIG_IRQ_PER_CPU)
> +		if (new->flags & IRQF_PERCPU)
> +			desc->status |= IRQ_PER_CPU;
> +#endif
> +
>  		desc->status &= ~(IRQ_AUTODETECT | IRQ_WAITING |
>  				  IRQ_INPROGRESS | IRQ_SPURIOUS_DISABLED);
>  
> @@ -383,6 +386,13 @@ int setup_irq(unsigned int irq, struct irqaction *new)
>  			/* Undo nested disables: */
>  			desc->depth = 1;
>  	}
> +
> +	*p = new;
> +
> +	/* Exclude IRQ from balancing */
> +	if (new->flags & IRQF_NOBALANCING)
> +		desc->status |= IRQ_NO_BALANCING;
> +
>  	/* Reset broken irq detection when installing new handler */
>  	desc->irq_count = 0;
>  	desc->irqs_unhandled = 0;

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
