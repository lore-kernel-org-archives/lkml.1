Return-Path: <linux-kernel-owner+w=401wt.eu-S1757616AbYA3Hai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757616AbYA3Hai (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 02:30:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754760AbYA3HaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 02:30:12 -0500
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:47495 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753198AbYA3HaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 02:30:09 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=x1B77vh5Zd/2W6Lp+/6Py+0fTZsmntEgXBR76TLp2IX1pyfHbdoEZCygppgCYo0S3w84mSZFNYucZtGCaMsHVlApRsHb5n8VWfTP6P8Sm4DKodwulXhMQwigybg3wNrcbAp0t1QkKKK9KjBX0Ak1SVb37tDYNHHhBpjXNSWLbys=  ;
X-YMail-OSG: KtxcnSUVM1mhsTp_3I9aTltScAKQc1SOPsy7SdbMuHj4PWgNhozySZDy_VrxlTb9gy8FYkqBC9Ya0GKN30PhL8NuowOGjcnLoJb719W7LlWiHHprjoJegfXiVlWH
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: [RFC v2 2/5] dmaengine: Add slave DMA interface
Date: Tue, 29 Jan 2008 23:30:05 -0800
User-Agent: KMail/1.9.6
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
       Shannon Nelson <shannon.nelson@intel.com>, kernel@avr32linux.org,
       "Francis Moreau" <francis.moro@gmail.com>,
       "Paul Mundt" <lethal@linux-sh.org>,
       "Vladimir A. Barinov" <vbarinov@ru.mvista.com>,
       Pierre Ossman <drzeus-list@drzeus.cx>
References: <1201630213-31900-1-git-send-email-hskinnemoen@atmel.com> <1201630213-31900-2-git-send-email-hskinnemoen@atmel.com> <1201630213-31900-3-git-send-email-hskinnemoen@atmel.com>
In-Reply-To: <1201630213-31900-3-git-send-email-hskinnemoen@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200801292330.05874.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 January 2008, Haavard Skinnemoen wrote:
> @@ -297,6 +356,13 @@ struct dma_device {
>         struct dma_async_tx_descriptor *(*device_prep_dma_interrupt)(
>                 struct dma_chan *chan);
>  
> +       struct dma_slave_descriptor *(*device_prep_slave)(
> +               struct dma_chan *chan, dma_addr_t mem_addr,
> +               enum dma_slave_direction direction,
> +               enum dma_slave_width reg_width,
> +               size_t len, unsigned long flags);

That isn't enough options!  Check out arch/arm/plat-omap/dma.c (and
maybe OMAP5912 DMA docs [1] for not-very-recent specs) as one example.
You'll see more options that drivers need to use, including:

 - DMA priority and arbitration
 - Burst size, packing/unpacking support (for optimized memory access)
 - Multiple DMA quanta (not just reg_width, but also frames and blocks)
 - Multiple synch modes (per element/"width", frame, or block)
 - Multiple addressing modes:   pre-index, post-index, double-index, ...
 - Both descriptor-based and register based transfers
 - ... lots more ...

Example:  USB tends to use one packet per "frame" and have the DMA
request signal mean "give me the next frame".  It's sometimes been
very important to use use the tuning options to avoid some on-chip
race conditions for transfers that cross lots of internal busses and
clock domains, and to have special handling for aborting transfers
and handling "short RX" packets.


I wonder whether a unified programming interface is the right way
to approach peripheral DMA support, given such variability.  The DMAC
from Synopsys that you're working with has some of those options, but
not all of them... and other DMA controllers have their own oddities.

For memcpy() acceleration, sure -- there shouldn't be much scope for
differences.  Source, destination, bytecount ... go!  (Not that it's
anywhere *near* that quick in the current interface.)

For peripheral DMA, maybe it should be a "core plus subclasses"
approach so that platform drivers can make use hardware-specific
knowledge (SOC-specific peripheral drivers using SOC-specific DMA),
sharing core code for dma-memcpy() and DMA channel housekeeping.

- Dave

[1] http://focus.ti.com/docs/prod/folders/print/omap5912.html
    lists spru755c near the bottom; the "System DMA" section.


> +       void (*device_terminate_all)(struct dma_chan *chan);
> +
>         void (*device_dependency_added)(struct dma_chan *chan);
>         enum dma_status (*device_is_tx_complete)(struct dma_chan *chan,
>                         dma_cookie_t cookie, dma_cookie_t *last,


