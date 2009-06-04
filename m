Return-Path: <linux-kernel-owner+w=401wt.eu-S1756888AbZFDMf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888AbZFDMf4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 08:35:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754078AbZFDMfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 08:35:47 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:57684 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743AbZFDMfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 08:35:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] asm-generic: add dma-mapping-linear.h
Date: Thu, 4 Jun 2009 12:35:34 +0000
User-Agent: KMail/1.11.2 (Linux/2.6.29; KDE/4.2.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <200905282104.55818.arnd@arndb.de> <200906011111.28521.arnd@arndb.de> <20090604165703N.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090604165703N.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200906041235.34686.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+iBXS++ldYoQr0PoIR727haN7c29u0Bw7tonT
 fkbdKeE4Ef9o1ctBUMH8rSH9ph4mExp7PyixpihYjCxSDlS18n
 1lloTZXUH7VXD7rRDOGKw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 June 2009 07:57:12 FUJITA Tomonori wrote:
> On Mon, 1 Jun 2009 11:11:27 +0100 Arnd Bergmann <arnd@arndb.de> wrote:
> > I've deliberately kept my asm-generic tree free from architecture specific
> > code for now, in order to make the merging process much easier.
> 
> I understand what you mean however we need to merge something
> useful. I don't say that you need to merge everything together however
> we can't know if this is useful or not unless you show how some
> architectures use it.

ok. 

> 
> > I do have branches in there that convert x86 and microblaze to use
> 
> x86? How can it use asm-generic-linear.h?

Not dma-mapping-linear.h, but a lot of other files in asm-generic. I have
a set of all the common header files in my tree, and x86 can e.g. use
ioctls.h, ipcbuf.h, mman.h, or types.h. For x86, it amounts to 15 files,
microblaze can use almost 50 of the generic files.

> > I made this up in order to deal with the different requirements of
> > the architectures I converted. In SH, it's truly device specific
> > (pci may be coherent, others are never), on cris it returns false
> > and on most others always true.
> 
> I know what you are trying here.
> 
> However, dma_cache_sync() is an exported function to drivers; which
> should be used only with a buffer returned by dma_alloc_noncoherent()
> (see DMA-API.txt). So using dma_cache_sync() in this way is confusing
> to me.

I think it is technically correct, but there are two plausible ways of
doing it, I chose the one that requires slightly less code.

I call dma_cache_sync() for streaming mappings on dma_map_* and
dma_sync_*_for_device iff the mapping is noncoherent. AFAICT, this
is the same case as dma_alloc_noncoherent, which is expected to give
out a noncoherent mapping.

It is done the same way in the existing code for avr32 and sh. The
alternative (implemented in mn10300, and xtensa) is to define a
new function for flushing a data range before a DMA and call that
unconditionally from dma_cache_sync and for noncoherent mappings
in dma_map* and dma_sync_*_for_device.
 
> > Architectures like x86 and frv could use this hook to do th
> > global flush_write_buffers() but still return zero so that
> > dma_sync_sg_for_device does not have to iterate all SG
> > elements doing nothing for them.
> > 
> > Maybe it should be named __dma_coherent_dev() to make clear
> > that it is a helper internal to dma_mapping.h and not supposed to
> > be used by device drivers.
> 
> Might be. However, we have dma_is_consistent() for a different purpose

I tried (ab)using that, but since dma_is_consistent takes a memory range,
dma_sync_sg_for_device would have to use less efficient code:

(1)
static inline void
dma_sync_sg_for_device(struct device *dev, struct scatterlist *sglist,
                      int nents, enum dma_data_direction direction)
{
       struct scatterlist *sg;
       int i;

       if (!dma_coherent_dev(dev))
               for_each_sg(sglist, sg, nents, i)
                       dma_cache_sync(dev, sg_virt(sg), sg->length, direction);

       debug_dma_sync_sg_for_device(dev, sg, nents, direction);
}

(2)
static inline void
dma_sync_sg_for_device(struct device *dev, struct scatterlist *sglist,
                      int nents, enum dma_data_direction direction)
{
       struct scatterlist *sg;
       int i;

       for_each_sg(sglist, sg, nents, i)
               if (!dma_is_consistent(dev, sg_virt(sg)))
                      dma_cache_sync(dev, sg_virt(sg), sg->length, direction);

       debug_dma_sync_sg_for_device(dev, sg, nents, direction);
}

In (1), gcc can completely eliminate the object code if dma_coherent_dev()
returns 1, or do a single branch on a nonconstant return value. In (2), we will
walk the full sg list. In some cases, gcc may be able to optimize this as well,
but not in general.

> > It took me a while to find out what the architectures do in case of
> > dma_sync_single_for_*. The noncoherent implementations all flush
> > and invalidate the dcache in _for_device, which seems reasonable.
> > 
> > In arch/sh and arch/xtensa, we also flush and invalidate the
> > dcache in *_for_cpu.
> > This does not seem to make sense to me, because there should
> > not be any valid cache lines for that region at that time. My plan 
> > was to submit patches to sh and xtensa to no longer flush the
> > dcache in _for_cpu with that argument before submitting the patch
> > to use the common code. Maybe Paul or Chris can comment on
> > whether there is any reason for the dma flush here, if there is
> > one, we probably should also flush in dma_unmap_*.
> > 
> > AFAICT, the _for_cpu hooks are only required for swiotlb
> > or for an obscure HW implementation of an IOMMU.
> 
> ? Why we don't need to remove stale cache after DMA_FROM_DEVICE
> transfer?

The way that the existing architectures handle this case is to
invalidate the cache before DMA_FROM_DEVICE transfers.
This only works if the CPU is forbidden from touching the buffer
between dma_map_*/dma_sync_*_for_device and
dma_unmap_*/dma_sync_*_for_cpu, while the device is forbidden
to touch it at any other time. I believe this is what we are expecting
the driver to enforce.

In fact, the documentation of dma_sync_single_for_cpu tells exactly that:

/*
 * Make physical memory consistent for a single streaming mode DMA
 * translation after a transfer.
 *
 * If you perform a dma_map_single() but wish to interrogate the
 * buffer using the cpu, yet do not wish to teardown the DMA mapping,
 * you must call this function before doing so.  At the next point you
 * give the DMA address back to the card, you must first perform a
 * dma_sync_single_for_device, and then the device again owns the
 * buffer.
 */

> > > > +static inline int
> > > > +dma_supported(struct device *dev, u64 mask)
> > > > +{
> > > > +	/*
> > > > +	 * we fall back to GFP_DMA when the mask isn't all 1s,
> > > > +	 * so we can't guarantee allocations that must be
> > > > +	 * within a tighter range than GFP_DMA.
> > > > +	 */
> > > > +	if (mask < 0x00ffffff)
> > > > +		return 0;
> > > 
> > > I think that this is pretty architecture specific.
> > 
> > Yes, I wondered about this one. I suspect that the same code got
> > copied blindly from x86 into all the other architectures. The
> > same code exists in arm, cris, frv and mn10300, while avr32, sh
> > and xtensa seem to assume that nobody passes a smaller than
> > 24-bit mask in there and always return 1. They clearly could not
> > handle that situation either, so the version I chose is the
> > conservative approach.
> 
> I think that it's better not have this in
> dma-mapping-linear.h. Everyone blindly copies it from x86 but they are
> not correct.

If all the architectures are wrong, then I see this as even more reason
to put a correct version into dma-mapping-linear.h. 

The existing implementations that check for 0x00ffffff all seem to
assume that dma_supported() returns whether or not
dma_alloc_consistent() will work, falling back to GFP_DMA if necessary.
In this case, we would need to check the maximum address of ZONE_DMA,
ZONE_DMA32 or ZONE_NORMAL (whichever comes first) for correctness:

static inline int
dma_supported(struct device *dev, u64 mask)
{
	/*
	 * dma_supported means that dma_alloc_{non,}coherent
	 * will succeed in finding an addressable page.
	 */
	u64 zone_dma_max_pfn;
	struct pgdat *pgdat;
	struct zone *zone;

	for_each_online_pgdat(pgdat) {
		/* the first zone on each node is most likely to fit in the mask */
		zone = pgdat->node_zones[0];
		if (populated_zone(zone) {
			max_dma_pfn = zone->zone_start_pfn + zone->spanned_pages);
			/* max_dma_pfn is actually constant, we could store it
			    somewhere instead of looking it up every time. */
			if (mask < (max_dma_pfn << PAGE_SHIFT))
				return 0;
		}
	}
	return 1;
}

The other interpretation is to tread dma_supported as meaning that dma_map_*
can succeed. Right now, we assume that it always will on the present
architectures I copied from, but that is not necessarily true if mask is smaller
than the highest physical page that can be passed into dma_map_*.

static inline int
dma_supported(struct device *dev, u64 mask)
{
	/*
	 * dma_supported means that dma_map_page and others
	 * can make any RAM address in the system visible to the device.
	 */
	if (mask < (max_pfn << PAGE_SHIFT))
		return 0;

	return 1;
}

	Arnd <><
