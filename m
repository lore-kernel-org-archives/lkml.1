Return-Path: <linux-kernel-owner+w=401wt.eu-S1757688AbYA3J11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757688AbYA3J11 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 04:27:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753281AbYA3J1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 04:27:12 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:58359 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751227AbYA3J1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 04:27:08 -0500
Date: Wed, 30 Jan 2008 10:27:06 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: David Brownell <david-b@pacbell.net>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
       Shannon Nelson <shannon.nelson@intel.com>, kernel@avr32linux.org,
       "Francis Moreau" <francis.moro@gmail.com>,
       "Paul Mundt" <lethal@linux-sh.org>,
       "Vladimir A. Barinov" <vbarinov@ru.mvista.com>,
       Pierre Ossman <drzeus-list@drzeus.cx>
Subject: Re: [RFC v2 2/5] dmaengine: Add slave DMA interface
Message-ID: <20080130102706.15c88346@dhcp-252-066.norway.atmel.com>
In-Reply-To: <200801292330.05874.david-b@pacbell.net>
References: <1201630213-31900-1-git-send-email-hskinnemoen@atmel.com>
	<1201630213-31900-2-git-send-email-hskinnemoen@atmel.com>
	<1201630213-31900-3-git-send-email-hskinnemoen@atmel.com>
	<200801292330.05874.david-b@pacbell.net>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jan 2008 23:30:05 -0800
David Brownell <david-b@pacbell.net> wrote:

> On Tuesday 29 January 2008, Haavard Skinnemoen wrote:
> > @@ -297,6 +356,13 @@ struct dma_device {
> >         struct dma_async_tx_descriptor *(*device_prep_dma_interrupt)(
> >                 struct dma_chan *chan);
> >  
> > +       struct dma_slave_descriptor *(*device_prep_slave)(
> > +               struct dma_chan *chan, dma_addr_t mem_addr,
> > +               enum dma_slave_direction direction,
> > +               enum dma_slave_width reg_width,
> > +               size_t len, unsigned long flags);
> 
> That isn't enough options!  Check out arch/arm/plat-omap/dma.c (and
> maybe OMAP5912 DMA docs [1] for not-very-recent specs) as one example.
> You'll see more options that drivers need to use, including:
> 
>  - DMA priority and arbitration
>  - Burst size, packing/unpacking support (for optimized memory access)
>  - Multiple DMA quanta (not just reg_width, but also frames and blocks)
>  - Multiple synch modes (per element/"width", frame, or block)
>  - Multiple addressing modes:   pre-index, post-index, double-index, ...
>  - Both descriptor-based and register based transfers
>  - ... lots more ...

Ok, I didn't bother to check the specs, as I think your main argument
is that these options vary from controller to controller, so we need to
make this extensible.

Not all options are specific to DMA slave transfers either, although
most of them are probably more important in this context.

Descriptor-based vs. register-based transfers sounds like something the
DMA engine driver is free to decide on its own.

> Example:  USB tends to use one packet per "frame" and have the DMA
> request signal mean "give me the next frame".  It's sometimes been
> very important to use use the tuning options to avoid some on-chip
> race conditions for transfers that cross lots of internal busses and
> clock domains, and to have special handling for aborting transfers
> and handling "short RX" packets.

Is it enough to set these options on a per-channel basis, or do they
have to be per-transfer?

> I wonder whether a unified programming interface is the right way
> to approach peripheral DMA support, given such variability.  The DMAC
> from Synopsys that you're working with has some of those options, but
> not all of them... and other DMA controllers have their own oddities.

Yes, but I still think it's worthwhile to have a common interface to
common functionality. Drivers for hardware that does proper flow
control won't need to mess with priority and arbitration settings
anyway, although they could do it in order to tweak performance. So a
plain "write this memory block to the TX register of this slave"
interface will be useful in many cases.

> For memcpy() acceleration, sure -- there shouldn't be much scope for
> differences.  Source, destination, bytecount ... go!  (Not that it's
> anywhere *near* that quick in the current interface.)

Well, I can imagine copying scatterlists may be useful too. Also, some
controllers support "stride" (or "scatter-gather", as Synopsys calls
it), which can be useful for framebuffer bitblt acceleration, for
example.

> For peripheral DMA, maybe it should be a "core plus subclasses"
> approach so that platform drivers can make use hardware-specific
> knowledge (SOC-specific peripheral drivers using SOC-specific DMA),
> sharing core code for dma-memcpy() and DMA channel housekeeping.

I mostly agree, but I think providing basic DMA slave transfers only
through extensions will cause maintenance nightmares for the drivers
using it. But I suppose we could have something along the lines of
"core plus standard subclasses plus SOC-specific subclasses"...

We already have something along those lines through the capabilities
mask, taking care of the "standard subclasses" part. How about we add
some kind of type ID to struct dma_device so that a driver can use
container_of() to get at the extended bits if it recognizes the type?

Haavard
