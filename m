Return-Path: <linux-kernel-owner+w=401wt.eu-S1761489AbYGRWT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761489AbYGRWT4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 18:19:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761000AbYGRWSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 18:18:34 -0400
Received: from www.tglx.de ([62.245.132.106]:52896 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760947AbYGRWSd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 18:18:33 -0400
Date: Sat, 19 Jul 2008 00:18:27 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: sasa sasa <sasak.1983@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] IRQ : bug fix in setup_irq
In-Reply-To: <aecf5e530807180321v529c95e1k91fbcffe246a0a75@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0807190013590.4316@apollo.tec.linutronix.de>
References: <aecf5e530807180321v529c95e1k91fbcffe246a0a75@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jul 2008, sasa sasa wrote:
> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> index 1f31422..ca92f97 100644
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -339,6 +339,7 @@ int setup_irq(unsigned int irq, struct irqaction *new)
>  		desc->status |= IRQ_NO_BALANCING;
> 
>  	if (!shared) {
> +		int trigger_type = 0;

No need to initialize to zero.

>  		irq_chip_set_defaults(desc->chip);
> 
>  #if defined(CONFIG_IRQ_PER_CPU)
> @@ -346,11 +347,22 @@ int setup_irq(unsigned int irq, struct irqaction *new)
>  			desc->status |= IRQ_PER_CPU;
>  #endif
> 
> +		trigger_type = new->flags & IRQF_TRIGGER_MASK;
> +
>  		/* Setup the type (level, edge polarity) if configured: */
> -		if (new->flags & IRQF_TRIGGER_MASK) {
> -			if (desc->chip && desc->chip->set_type)
> -				desc->chip->set_type(irq,
> -						new->flags & IRQF_TRIGGER_MASK);
> +		if (trigger_type) {
> +			if (desc->chip && desc->chip->set_type)	{
> +				if ((desc->chip->set_type(irq, trigger_type))) {
> +					/* Action handler gets freed but
> +					 * desc->action also needs to be
> +					 * set to NULL
> +					 */

		That's not desc->action. That's the end of the desc->action list

> +					*p = NULL;

Can we have a printk here, which tells us what went wrong ?

> +					spin_unlock_irqrestore(&desc->lock,
> +								flags);
> +					return -EBUSY;

  Please use the already existing error exit via "goto ..." instead

> +				}
> +			}
>  			else
>  				/*
>  				 * IRQF_TRIGGER_* but the PIC does not support
> @@ -571,8 +583,10 @@ int request_irq(unsigned int irq, irq_handler_t handler,
>  #endif
> 
>  	retval = setup_irq(irq, action);
> -	if (retval)
> +	if (retval) {
> +		printk(KERN_WARNING"Failed to allocate interrupt %d\n", retval);
>  		kfree(action);

We dont want to know that the setup function returned -EBUSY. We
rather want to have a printk in the path above.

Thanks,
	tglx
