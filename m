Return-Path: <linux-kernel-owner+w=401wt.eu-S1760724AbYFNKlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760724AbYFNKlr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 06:41:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754987AbYFNKkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 06:40:24 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:49986 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553AbYFNKkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 06:40:14 -0400
Message-ID: <4853814D.4010309@keyaccess.nl>
Date: Sat, 14 Jun 2008 10:29:01 +0200
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
Subject: Re: [patch 15/18] PNP: support optional IRQ resources
References: <20080604220933.168145536@ldl.fc.hp.com> <20080604221129.758385014@ldl.fc.hp.com>
In-Reply-To: <20080604221129.758385014@ldl.fc.hp.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: 1.0 (+)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05-06-08 00:09, Bjorn Helgaas wrote:

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
> The problem of a sound card MPU401 being left disabled for want of
> an IRQ was reported by Uwe Bugla <uwe.bugla@gmx.de>.
> 
> Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

You rework this again in the later patch doing the final switch over 
after which things end up right but also already at this point:

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

... this line should just go.

Previously "res" ended up as the last dependent set through the while 
loop but now it's the independendent set which in this previous setup of 
things shouldn't even have a ->next. Just deleting this line makes this 
patch fine and

Acked-by: Rene Herman <rene.herman@gmail.com>

Rene.

