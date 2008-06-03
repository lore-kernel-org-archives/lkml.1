Return-Path: <linux-kernel-owner+w=401wt.eu-S1757403AbYFCVOF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403AbYFCVOF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 17:14:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752378AbYFCVNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 17:13:52 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:56392 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbYFCVNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 17:13:51 -0400
Message-ID: <4845B401.7020102@keyaccess.nl>
Date: Tue, 03 Jun 2008 23:13:37 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Adam Belay <ambx1@neo.rr.com>,
       Adam M Belay <abelay@mit.edu>, Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [patch 15/15] PNP: convert resource options to single linked
 list
References: <20080530224853.976744229@ldl.fc.hp.com> <20080530224934.357694359@ldl.fc.hp.com>
In-Reply-To: <20080530224934.357694359@ldl.fc.hp.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31-05-08 00:49, Bjorn Helgaas wrote:

Forgot this comment:

> --- work10.orig/drivers/pnp/quirks.c	2008-05-30 15:58:14.000000000 -0600
> +++ work10/drivers/pnp/quirks.c	2008-05-30 15:58:15.000000000 -0600

> +static struct pnp_option *pnp_clone_dependent_set(struct pnp_dev *dev,
> +						  unsigned int set)
>  {
> -	struct pnp_option *head = NULL;
> -	struct pnp_option *prev = NULL;
> -	struct pnp_option *res;
> -
> -	/*
> -	 * Build a functional IRQ-optional variant of each MPU option.
> -	 */
> -
> -	for (res = dev->dependent; res; res = res->next) {
> -		struct pnp_option *curr;
> -		struct pnp_port *port;
> -		struct pnp_port *copy_port;
> -		struct pnp_irq *irq;
> -		struct pnp_irq *copy_irq;
> -
> -		port = res->port;
> -		irq = res->irq;
> -		if (!port || !irq)
> -			continue;
> +	struct pnp_option *tail = NULL, *first_new_option = NULL;
> +	struct pnp_option *option, *new_option;
> +	unsigned int flags;
> +
> +	list_for_each_entry(option, &dev->options, list) {
> +		if (pnp_option_is_dependent(option))
> +			tail = option;
> +	}
> +	if (!tail) {
> +		dev_err(&dev->dev, "no dependent option sets\n");
> +		return NULL;
> +	}
>  
> -		copy_port = pnp_alloc(sizeof *copy_port);
> -		if (!copy_port)
> -			break;
> -
> -		copy_irq = pnp_alloc(sizeof *copy_irq);
> -		if (!copy_irq) {
> -			kfree(copy_port);
> -			break;
> -		}
> +	flags = pnp_dependent_option(dev, PNP_RES_PRIORITY_FUNCTIONAL);
> +	list_for_each_entry(option, &dev->options, list) {
> +		if (pnp_option_is_dependent(option) &&
> +		    pnp_option_set(option) == set) {
> +			new_option = kmalloc(sizeof(struct pnp_option),
> +					     GFP_KERNEL);
> +			if (!new_option) {
> +				dev_err(&dev->dev, "couldn't clone dependent "
> +					"set %d\n", set);
> +				return NULL;
> +			}
>  
> -		*copy_port = *port;
> -		copy_port->next = NULL;
> +			*new_option = *option;
> +			new_option->flags = flags;
> +			if (!first_new_option)
> +				first_new_option = new_option;
>  
> -		*copy_irq = *irq;
> -		copy_irq->flags |= IORESOURCE_IRQ_OPTIONAL;
> -		copy_irq->next = NULL;
> -
> -		curr = pnp_build_option(PNP_RES_PRIORITY_FUNCTIONAL);
> -		if (!curr) {
> -			kfree(copy_port);
> -			kfree(copy_irq);
> -			break;
> +			list_add(&new_option->list, &tail->list);
> +			tail = new_option;
>  		}
> -		curr->port = copy_port;
> -		curr->irq = copy_irq;
> -
> -		if (prev)
> -			prev->next = curr;
> -		else
> -			head = curr;
> -		prev = curr;
>  	}
> -	if (head)
> -		dev_info(&dev->dev, "adding IRQ-optional MPU options\n");
>  
> -	return head;
> +	return first_new_option;
>  }

This works, but I did the "disconnected chain build" that I did due to 
finding it particularly clumsy to add to the dependent chain while 
walking it.

This avoids actual problems due to num_sets = dev->num_dependents_sets 
in caller and the pnp_option_set(option) == set in the loop (not unlike 
the first version of the original checked for a present irq) but it's 
again checking the options it just added itself.

If you feel that's perfectly fine then <shrug> but thought I'd still 
remark on it in case it wasn't intentional.

Rene.
