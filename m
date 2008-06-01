Return-Path: <linux-kernel-owner+w=401wt.eu-S1754774AbYFAXSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774AbYFAXSQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 19:18:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752522AbYFAXSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 19:18:00 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:35713 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487AbYFAXR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 19:17:59 -0400
Message-ID: <48432EE6.8000501@keyaccess.nl>
Date: Mon, 02 Jun 2008 01:21:10 +0200
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
Subject: Re: [patch 11/15] PNP: centralize resource option allocations
References: <20080530224853.976744229@ldl.fc.hp.com> <20080530224933.560428539@ldl.fc.hp.com>
In-Reply-To: <20080530224933.560428539@ldl.fc.hp.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31-05-08 00:49, Bjorn Helgaas wrote:

> This patch moves all the option allocations (pnp_mem, pnp_port, etc)
> into the pnp_register_{mem,port,irq,dma}_resource() functions.  This
> will make it easier to rework the option data structures.
> 
> The non-trivial part of this patch is the IRQ handling.  The backends
> have to allocate a local pnp_irq_mask_t bitmap, populate it, and pass
> a pointer to pnp_register_irq_resource().
> 
> Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

[ ... ]

> Index: work10/drivers/pnp/isapnp/core.c
> ===================================================================
> --- work10.orig/drivers/pnp/isapnp/core.c	2008-05-30 13:20:36.000000000 -0600
> +++ work10/drivers/pnp/isapnp/core.c	2008-05-30 13:23:34.000000000 -0600
> @@ -433,20 +433,23 @@ static void __init isapnp_parse_irq_reso
>  					     int size)
>  {
>  	unsigned char tmp[3];
> -	struct pnp_irq *irq;
>  	unsigned long bits;
> +	int i;
> +	pnp_irq_mask_t map;
> +	unsigned char flags = IORESOURCE_IRQ_HIGHEDGE;
>  
>  	isapnp_peek(tmp, size);
> -	irq = kzalloc(sizeof(struct pnp_irq), GFP_KERNEL);
> -	if (!irq)
> -		return;
>  	bits = (tmp[1] << 8) | tmp[0];
> -	bitmap_copy(irq->map.bits, &bits, 16);
> +
> +	bitmap_zero(map.bits, PNP_IRQ_NR);
> +	for (i = 0; i < 15; i++)
> +		if (bits & (1 << i))
> +			__set_bit(i, map.bits);
> +

for (i = 0; i < 16; i++) (16 instead of 15) it would seem.

And why not simply:

bitmap_zero(map.bits, PNP_IRQ_NR);
bitmap_copy(map.bits, &bits, 16);

That last bit of the comment same for pnpbios_parse_irq_option(). Should 
  be fine, no?

>  static __init void pnpbios_parse_port_option(struct pnp_dev *dev,
>  					     unsigned char *p, int size,
>  					     struct pnp_option *option)
>  {
> -	struct pnp_port *port;
> +	resource_size_t min, max, align, len, flags;

unsigned char flags;

All the rest:

Acked-by: Rene Herman <rene.herman@gmail.com>

Rene.
