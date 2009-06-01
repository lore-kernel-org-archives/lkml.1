Return-Path: <linux-kernel-owner+w=401wt.eu-S1754283AbZFAHvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283AbZFAHvs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 03:51:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752632AbZFAHvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 03:51:40 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51723 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbZFAHvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 03:51:39 -0400
Date: Mon, 1 Jun 2009 08:51:14 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH] asm-generic: add dma-mapping-linear.h
Message-ID: <20090601075114.GA29107@flint.arm.linux.org.uk>
Mail-Followup-To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
	arnd@arndb.de, linux-kernel@vger.kernel.org,
	linux-arch@vger.kernel.org
References: <200905282104.55818.arnd@arndb.de> <20090601130319A.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090601130319A.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 01, 2009 at 01:02:42PM +0900, FUJITA Tomonori wrote:
> Where can I find dma_coherent_dev?
> 
> I don't fancy this since this is architecture-specific stuff (not
> generic things).

It _is_ very architecture specific.  The coherent-ness of devices hardly
depends on the device itself.  Eg, PCI devices on x86 are coherent, but
on ARM they aren't.

> > +static inline void
> > +dma_unmap_single(struct device *dev, dma_addr_t dma_addr, size_t size,
> > +		 enum dma_data_direction direction)
> > +{
> > +	debug_dma_unmap_page(dev, dma_addr, size, direction, true);

Future ARMs will need to do something on unmaps.

> > +static inline void
> > +dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle, size_t size,
> > +			enum dma_data_direction direction)
> > +{
> > +	debug_dma_sync_single_for_cpu(dev, dma_handle, size, direction);
> > +}
> > +
> > +static inline void
> > +dma_sync_single_range_for_cpu(struct device *dev, dma_addr_t dma_handle,
> > +			      unsigned long offset, size_t size,
> > +			      enum dma_data_direction direction)
> > +{
> > +	debug_dma_sync_single_range_for_cpu(dev, dma_handle,
> > +					    offset, size, direction);
> > +}
> 
> This looks wrong. You put dma_coherent_dev hook in sync_*_for_device
> but why you don't need it sync_*_for_cpu. It's architecture
> specific. Some need both, some need either, and some need nothing.

If you're non-coherent, you need to implement the sync APIs.

> > +static inline int
> > +dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
> > +{
> > +	return 0;

So mappings never fail?

> > +}
> > +
> > +/*
> > + * Return whether the given device DMA address mask can be supported
> > + * properly.  For example, if your device can only drive the low 24-bits
> > + * during bus mastering, then you would pass 0x00ffffff as the mask
> > + * to this function.
> > + */
> > +static inline int
> > +dma_supported(struct device *dev, u64 mask)
> > +{
> > +	/*
> > +	 * we fall back to GFP_DMA when the mask isn't all 1s,
> > +	 * so we can't guarantee allocations that must be
> > +	 * within a tighter range than GFP_DMA.
> > +	 */
> > +	if (mask < 0x00ffffff)
> > +		return 0;
> 
> I think that this is pretty architecture specific.

It is - it depends exactly on how you setup the DMA zone and whether
all your RAM is DMA-able.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
