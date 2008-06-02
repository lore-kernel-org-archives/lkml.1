Return-Path: <linux-kernel-owner+w=401wt.eu-S1755748AbYFBP37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748AbYFBP37 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 11:29:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbYFBP3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 11:29:51 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:17139 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587AbYFBP3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 11:29:50 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: [patch 11/15] PNP: centralize resource option allocations
Date: Mon, 2 Jun 2008 09:29:52 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Adam Belay <ambx1@neo.rr.com>,
       Adam M Belay <abelay@mit.edu>, Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>, Takashi Iwai <tiwai@suse.de>
References: <20080530224853.976744229@ldl.fc.hp.com> <20080530224933.560428539@ldl.fc.hp.com> <48432EE6.8000501@keyaccess.nl>
In-Reply-To: <48432EE6.8000501@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806020929.53939.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 01 June 2008 05:21:10 pm Rene Herman wrote:
> On 31-05-08 00:49, Bjorn Helgaas wrote:
> 
> > This patch moves all the option allocations (pnp_mem, pnp_port, etc)
> > into the pnp_register_{mem,port,irq,dma}_resource() functions.  This
> > will make it easier to rework the option data structures.
> > 
> > The non-trivial part of this patch is the IRQ handling.  The backends
> > have to allocate a local pnp_irq_mask_t bitmap, populate it, and pass
> > a pointer to pnp_register_irq_resource().
> > 
> > Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
> 
> [ ... ]
> 
> > Index: work10/drivers/pnp/isapnp/core.c
> > ===================================================================
> > --- work10.orig/drivers/pnp/isapnp/core.c	2008-05-30 13:20:36.000000000 -0600
> > +++ work10/drivers/pnp/isapnp/core.c	2008-05-30 13:23:34.000000000 -0600
> > @@ -433,20 +433,23 @@ static void __init isapnp_parse_irq_reso
> >  					     int size)
> >  {
> >  	unsigned char tmp[3];
> > -	struct pnp_irq *irq;
> >  	unsigned long bits;
> > +	int i;
> > +	pnp_irq_mask_t map;
> > +	unsigned char flags = IORESOURCE_IRQ_HIGHEDGE;
> >  
> >  	isapnp_peek(tmp, size);
> > -	irq = kzalloc(sizeof(struct pnp_irq), GFP_KERNEL);
> > -	if (!irq)
> > -		return;
> >  	bits = (tmp[1] << 8) | tmp[0];
> > -	bitmap_copy(irq->map.bits, &bits, 16);
> > +
> > +	bitmap_zero(map.bits, PNP_IRQ_NR);
> > +	for (i = 0; i < 15; i++)
> > +		if (bits & (1 << i))
> > +			__set_bit(i, map.bits);
> > +
> 
> for (i = 0; i < 16; i++) (16 instead of 15) it would seem.

Oops, typo on my part.

> And why not simply:
> 
> bitmap_zero(map.bits, PNP_IRQ_NR);
> bitmap_copy(map.bits, &bits, 16);
> 
> That last bit of the comment same for pnpbios_parse_irq_option(). Should 
>   be fine, no?

I suppose it should be fine.  It's just that I was new to the bitmap
functions and nervous about copying between bitmaps of different sizes
and getting bits in the correct places.  But I'll try to get over my
paranoia :-)

Bjorn
