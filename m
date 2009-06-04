Return-Path: <linux-kernel-owner+w=401wt.eu-S1756583AbZFDPF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583AbZFDPF0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 11:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754021AbZFDPFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 11:05:16 -0400
Received: from sh.osrg.net ([192.16.179.4]:35545 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653AbZFDPFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 11:05:15 -0400
Date: Fri, 5 Jun 2009 00:05:10 +0900
To: arnd@arndb.de
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH] asm-generic: add dma-mapping-linear.h
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <200906041235.34686.arnd@arndb.de>
References: <200906011111.28521.arnd@arndb.de>
	<20090604165703N.fujita.tomonori@lab.ntt.co.jp>
	<200906041235.34686.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090605000424E.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 05 Jun 2009 00:05:10 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Jun 2009 12:35:34 +0000
Arnd Bergmann <arnd@arndb.de> wrote:

> > > I do have branches in there that convert x86 and microblaze to use
> > 
> > x86? How can it use asm-generic-linear.h?
> 
> Not dma-mapping-linear.h, but a lot of other files in asm-generic. I have
> a set of all the common header files in my tree, and x86 can e.g. use
> ioctls.h, ipcbuf.h, mman.h, or types.h. For x86, it amounts to 15 files,
> microblaze can use almost 50 of the generic files.

I see, but I'm not sure why dma-mapping-linear needs to be merged with
them together.


> > > I made this up in order to deal with the different requirements of
> > > the architectures I converted. In SH, it's truly device specific
> > > (pci may be coherent, others are never), on cris it returns false
> > > and on most others always true.
> > 
> > I know what you are trying here.
> > 
> > However, dma_cache_sync() is an exported function to drivers; which
> > should be used only with a buffer returned by dma_alloc_noncoherent()
> > (see DMA-API.txt). So using dma_cache_sync() in this way is confusing
> > to me.
> 
> I think it is technically correct, but there are two plausible ways of
> doing it, I chose the one that requires slightly less code.
> 
> I call dma_cache_sync() for streaming mappings on dma_map_* and
> dma_sync_*_for_device iff the mapping is noncoherent. AFAICT, this
> is the same case as dma_alloc_noncoherent, which is expected to give
> out a noncoherent mapping.

If I correctly understand DMA-API.txt, dma_alloc_noncoherent can
return either consistent or non-consistent memory. On architectures
that return consistent memory via dma_alloc_noncoherent,
dma_cache_sync should be null. dma_cache_sync() is supposed to be used
only with the returned buffers of dma_alloc_noncoherent().


> It is done the same way in the existing code for avr32 and sh. The
> alternative (implemented in mn10300, and xtensa) is to define a
> new function for flushing a data range before a DMA and call that
> unconditionally from dma_cache_sync and for noncoherent mappings
> in dma_map* and dma_sync_*_for_device.
>  
> > > Architectures like x86 and frv could use this hook to do th
> > > global flush_write_buffers() but still return zero so that
> > > dma_sync_sg_for_device does not have to iterate all SG
> > > elements doing nothing for them.
> > > 
> > > Maybe it should be named __dma_coherent_dev() to make clear
> > > that it is a helper internal to dma_mapping.h and not supposed to
> > > be used by device drivers.
> > 
> > Might be. However, we have dma_is_consistent() for a different purpose
> 
> I tried (ab)using that, but since dma_is_consistent takes a memory range,
> dma_sync_sg_for_device would have to use less efficient code:
> 
> (1)
> static inline void
> dma_sync_sg_for_device(struct device *dev, struct scatterlist *sglist,
>                       int nents, enum dma_data_direction direction)
> {
>        struct scatterlist *sg;
>        int i;
> 
>        if (!dma_coherent_dev(dev))
>                for_each_sg(sglist, sg, nents, i)
>                        dma_cache_sync(dev, sg_virt(sg), sg->length, direction);
> 
>        debug_dma_sync_sg_for_device(dev, sg, nents, direction);
> }
> 
> (2)
> static inline void
> dma_sync_sg_for_device(struct device *dev, struct scatterlist *sglist,
>                       int nents, enum dma_data_direction direction)
> {
>        struct scatterlist *sg;
>        int i;
> 
>        for_each_sg(sglist, sg, nents, i)
>                if (!dma_is_consistent(dev, sg_virt(sg)))
>                       dma_cache_sync(dev, sg_virt(sg), sg->length, direction);

I don't think you can do such; dma_is_consistent can be used only with
dma_alloc_noncoherent.

> 
>        debug_dma_sync_sg_for_device(dev, sg, nents, direction);
> }
> 
> In (1), gcc can completely eliminate the object code if dma_coherent_dev()
> returns 1, or do a single branch on a nonconstant return value. In (2), we will
> walk the full sg list. In some cases, gcc may be able to optimize this as well,
> but not in general.
