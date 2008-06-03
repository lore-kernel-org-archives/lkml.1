Return-Path: <linux-kernel-owner+w=401wt.eu-S1756138AbYFCRhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138AbYFCRhf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 13:37:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752996AbYFCRhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 13:37:20 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:56033 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbYFCRhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 13:37:18 -0400
Message-ID: <48458141.9020409@keyaccess.nl>
Date: Tue, 03 Jun 2008 19:37:05 +0200
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
Subject: Re: [patch 14/15] PNP: support optional IRQ resources
References: <20080530224853.976744229@ldl.fc.hp.com> <20080530224934.156287156@ldl.fc.hp.com>
In-Reply-To: <20080530224934.156287156@ldl.fc.hp.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31-05-08 00:49, Bjorn Helgaas wrote:

> This patch adds an IORESOURCE_IRQ_OPTIONAL flag for use when
> assigning resources to a device.  If the flag is set and we are
> unable to assign an IRQ to the device, we can leave the IRQ
> disabled but allow the overall resource allocation to succeed.
> 
> Some devices request an IRQ, but can run without an IRQ
> (possibly with degraded performance).  This flag lets us run
> the device without the IRQ instead of just leaving the
> device disabled.
> 
> This is a reimplementation of this previous change by Rene
> Herman <rene.herman@gmail.com>:
>     http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=3b73a223661ed137c5d3d2635f954382e94f5a43
> 
> I reimplemented this for two reasons:
>     - to prepare for converting all resource options into a single linked
>       list, as opposed to the per-resource-type lists we have now, and
>     - to preserve the order and number of resource options.
> 
> In PNPBIOS and ACPI, we configure a device by giving firmware a
> list of resource assignments.  It is important that this list
> has exactly the same number of resources, in the same order,
> as the "template" list we got from the firmware in the first
> place.
> 
> The problem of a sound card being left disabled for want of an
> IRQ was reported by Uwe Bugla <uwe.bugla@gmx.de>.

Nit -- the soundcard itself isn't left disabled, just its MPU401. It's 
only the fact that ALSA mentions this fact which triggered the report.

> Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
> 
> Index: work10/include/linux/ioport.h
> ===================================================================
> --- work10.orig/include/linux/ioport.h	2008-05-20 13:34:58.000000000 -0600
> +++ work10/include/linux/ioport.h	2008-05-20 13:39:21.000000000 -0600
> @@ -59,6 +59,7 @@ struct resource_list {
>  #define IORESOURCE_IRQ_HIGHLEVEL	(1<<2)
>  #define IORESOURCE_IRQ_LOWLEVEL		(1<<3)
>  #define IORESOURCE_IRQ_SHAREABLE	(1<<4)
> +#define IORESOURCE_IRQ_OPTIONAL		(1<<5)
>  
>  /* ISA PnP DMA specific bits (IORESOURCE_BITS) */
>  #define IORESOURCE_DMA_TYPE_MASK	(3<<0)

Andrew scooped up a patch from a previous reaction of mine that deleted 
the "ISA " from these comments. I tend to use comments as a great way of 
avoiding actually reading code (I'm silly like that) and so as to be 
burned a _bit_ less by it, I think it's good if they're accurate. In 
this case for example, one might be tempted to assume these bits were 
specific to drivers/pnp/isapnp.

<snip>

> @@ -164,10 +176,6 @@ static void quirk_ad1815_mpu_resources(s
>  	struct pnp_option *res;
>  	struct pnp_irq *irq;
>  
> -	/*
> -	 * Distribute the independent IRQ over the dependent options
> -	 */
> -
>  	res = dev->independent;
>  	if (!res)
>  		return;
> @@ -176,33 +184,10 @@ static void quirk_ad1815_mpu_resources(s
>  	if (!irq || irq->next)
>  		return;
>  
> -	res = dev->dependent;
> -	if (!res)
> -		return;
> -
> -	while (1) {
> -		struct pnp_irq *copy;
> -
> -		copy = pnp_alloc(sizeof *copy);
> -		if (!copy)
> -			break;
> -
> -		bitmap_copy(copy->map.bits, irq->map.bits, PNP_IRQ_NR);
> -		copy->flags = irq->flags;
> -
> -		copy->next = res->irq; /* Yes, this is NULL */
> -		res->irq = copy;
> -
> -		if (!res->next)
> -			break;
> -		res = res->next;
> -	}
> -	kfree(irq);
> +	irq->flags |= IORESOURCE_IRQ_OPTIONAL;
> +	dev_info(&dev->dev, "made independent IRQ optional\n");
>  
>  	res->next = quirk_isapnp_mpu_options(dev);

As commented yesterday, this line should just go. We don't need to clone 
here (we do for the other two PNP IDs, so the cloning can't go entirely).

The actual (slight) problem with it not working is in 15/15...

> -
> -	res = dev->independent;
> -	res->irq = NULL;
>  }
>  
>  static void quirk_isapnp_mpu_resources(struct pnp_dev *dev)

Rene.

