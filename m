Return-Path: <linux-kernel-owner+w=401wt.eu-S1757472AbZFDH5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472AbZFDH5a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 03:57:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755589AbZFDH5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 03:57:21 -0400
Received: from sh.osrg.net ([192.16.179.4]:41490 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754186AbZFDH5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 03:57:20 -0400
Date: Thu, 4 Jun 2009 16:57:12 +0900
To: arnd@arndb.de
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, lethal@linux-sh.org, chris@zankel.net
Subject: Re: [PATCH] asm-generic: add dma-mapping-linear.h
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <200906011111.28521.arnd@arndb.de>
References: <200905282104.55818.arnd@arndb.de>
	<20090601130319A.fujita.tomonori@lab.ntt.co.jp>
	<200906011111.28521.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090604165703N.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 04 Jun 2009 16:57:14 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Jun 2009 11:11:27 +0100
Arnd Bergmann <arnd@arndb.de> wrote:

> On Monday 01 June 2009, FUJITA Tomonori wrote:
> > On Thu, 28 May 2009 21:04:55 +0100
> > > I've added this version to
> > > git://git.kernel.org/pub/scm/linux/kernel/git/arnd/asm-generic#next
> > > 
> > > I also have patches to convert the existing architectures to use
> > > it, but I plan to submit those to the arch maintainers once asm-generic
> > > series has been merged.
> > 
> > IMO, this need to be merged with some users. We don't want to merge
> > something that nobody wants to use.
> 
> I've deliberately kept my asm-generic tree free from architecture specific
> code for now, in order to make the merging process much easier.

I understand what you mean however we need to merge something
useful. I don't say that you need to merge everything together however
we can't know if this is useful or not unless you show how some
architectures use it.


> I do have branches in there that convert x86 and microblaze to use

x86? How can it use asm-generic-linear.h?


> all the files that they can share with the generic implementation
> and the plan is to do more of those over time, but to avoid dealing
> with all arch maintainers at the same time.
> 
> Would it be ok for you if I only do this on microblaze for now (which
> does not have a dma-mapping.h yet) and leave the conversion of
> more architectures for later?
> Otherwise, I'd probably just skip dma-mapping.h in its entirety
> because there is a different is a simpler alternative for new architectures
> (setting CONFIG_NO_DMA).

At least one architecture sounds fine to me.


> > > +static inline dma_addr_t
> > > +dma_map_single(struct device *dev, void *ptr, size_t size,
> > > +	       enum dma_data_direction direction)
> > > +{
> > > +	dma_addr_t dma_addr = virt_to_bus(ptr);
> > > +	BUG_ON(!valid_dma_direction(direction));
> > > +
> > > +	if (!dma_coherent_dev(dev))
> > > +		dma_cache_sync(dev, ptr, size, direction);
> > 
> > Where can I find dma_coherent_dev?
> > 
> > I don't fancy this since this is architecture-specific stuff (not
> > generic things).
> 
> I made this up in order to deal with the different requirements of
> the architectures I converted. In SH, it's truly device specific
> (pci may be coherent, others are never), on cris it returns false
> and on most others always true.

I know what you are trying here.

However, dma_cache_sync() is an exported function to drivers; which
should be used only with a buffer returned by dma_alloc_noncoherent()
(see DMA-API.txt). So using dma_cache_sync() in this way is confusing
to me.

I might misunderstand dma_cache_sync (recently I learned what it
should do).


> Architectures like x86 and frv could use this hook to do th
> global flush_write_buffers() but still return zero so that
> dma_sync_sg_for_device does not have to iterate all SG
> elements doing nothing for them.
> 
> Maybe it should be named __dma_coherent_dev() to make clear
> that it is a helper internal to dma_mapping.h and not supposed to
> be used by device drivers.

Might be. However, we have dma_is_consistent() for a different purpose
so it might be confusing anyway.


> > > +static inline void
> > > +dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle, size_t size,
> > > +			enum dma_data_direction direction)
> > > +{
> > > +	debug_dma_sync_single_for_cpu(dev, dma_handle, size, direction);
> > > +}
> > > +
> > > +static inline void
> > > +dma_sync_single_range_for_cpu(struct device *dev, dma_addr_t dma_handle,
> > > +			      unsigned long offset, size_t size,
> > > +			      enum dma_data_direction direction)
> > > +{
> > > +	debug_dma_sync_single_range_for_cpu(dev, dma_handle,
> > > +					    offset, size, direction);
> > > +}
> > 
> > This looks wrong. You put dma_coherent_dev hook in sync_*_for_device
> > but why you don't need it sync_*_for_cpu. It's architecture
> > specific. Some need both, some need either, and some need nothing.
> 
> It took me a while to find out what the architectures do in case of
> dma_sync_single_for_*. The noncoherent implementations all flush
> and invalidate the dcache in _for_device, which seems reasonable.
> 
> In arch/sh and arch/xtensa, we also flush and invalidate the
> dcache in *_for_cpu.
> This does not seem to make sense to me, because there should
> not be any valid cache lines for that region at that time. My plan 
> was to submit patches to sh and xtensa to no longer flush the
> dcache in _for_cpu with that argument before submitting the patch
> to use the common code. Maybe Paul or Chris can comment on
> whether there is any reason for the dma flush here, if there is
> one, we probably should also flush in dma_unmap_*.
> 
> AFAICT, the _for_cpu hooks are only required for swiotlb
> or for an obscure HW implementation of an IOMMU.

? Why we don't need to remove stale cache after DMA_FROM_DEVICE
transfer?


> > > +static inline int
> > > +dma_supported(struct device *dev, u64 mask)
> > > +{
> > > +	/*
> > > +	 * we fall back to GFP_DMA when the mask isn't all 1s,
> > > +	 * so we can't guarantee allocations that must be
> > > +	 * within a tighter range than GFP_DMA.
> > > +	 */
> > > +	if (mask < 0x00ffffff)
> > > +		return 0;
> > 
> > I think that this is pretty architecture specific.
> 
> Yes, I wondered about this one. I suspect that the same code got
> copied blindly from x86 into all the other architectures. The
> same code exists in arm, cris, frv and mn10300, while avr32, sh
> and xtensa seem to assume that nobody passes a smaller than
> 24-bit mask in there and always return 1. They clearly could not
> handle that situation either, so the version I chose is the
> conservative approach.

I think that it's better not have this in
dma-mapping-linear.h. Everyone blindly copies it from x86 but they are
not correct.

