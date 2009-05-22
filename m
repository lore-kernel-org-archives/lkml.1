Return-Path: <linux-kernel-owner+w=401wt.eu-S1757951AbZEVMPE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757951AbZEVMPE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 08:15:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757485AbZEVMOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 08:14:24 -0400
Received: from sh.osrg.net ([192.16.179.4]:34341 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757856AbZEVMOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 08:14:22 -0400
Date: Fri, 22 May 2009 21:12:49 +0900
To: arnd@arndb.de
Cc: fujita.tomonori@lab.ntt.co.jp, jgarzik@pobox.com, hancockrwd@gmail.com,
       htejun@gmail.com, alan@lxorguk.ukuu.org.uk, flar@allandria.com,
       schmitz@biophys.uni-duesseldorf.de, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, takata@linux-m32r.org, geert@linux-m68k.org,
       linux-m68k@vger.kernel.org, ysato@users.sourceforge.jp
Subject: Re: [PATCH] asm-generic: add a dma-mapping.h file
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <200905191822.48420.arnd@arndb.de>
References: <200905181645.26305.arnd@arndb.de>
	<20090519074355P.fujita.tomonori@lab.ntt.co.jp>
	<200905191822.48420.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090522211258Q.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 22 May 2009 21:12:52 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 May 2009 18:22:47 +0200
Arnd Bergmann <arnd@arndb.de> wrote:

> On Tuesday 19 May 2009, FUJITA Tomonori wrote:
> > > Would you agree to a patch that works with the same
> > > code on e.g. arm, microblaze, mn10300 and sh and
> > > uses only a few #ifdefs?
> > 
> > Having such helper for a linear mapping might be helpful but your
> > approach is wrong.
> 
> Do you like this approach better? I've merged a few architectures
> that were relatively simple. This file should be usable by all
> architectures that have a linear mapping and are either fully coherent
> (like cris) or just require flushing the dcache when passing a
> buffer to the device.
> 
> It's become pretty obvious where some of my bugs were in the previous
> code, I hopefully did better this time and maybe you find the rest.
> I've also added the dma debugging stuff in here and fixed a number
> of bugs in all the different architectures on the way, but I can
> send separate patches for those before doing the merge.
> 
> I've also tried merging frv and m68k, but they have some peculiarities
> that made it slightly harder.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
>  include/asm-generic/dma-mapping-linear.h |  391 +++++++++++++++++++++++++++++
>  arch/avr32/include/asm/dma-mapping.h     |  408 ++++---------------------------
>  arch/blackfin/include/asm/dma-mapping.h  |  118 +-------
>  arch/cris/include/asm/dma-mapping.h      |  194 +-------------
>  arch/mn10300/include/asm/dma-mapping.h   |  266 ++------------------
>  arch/sh/include/asm/dma-mapping.h        |  258 ++-----------------
>  arch/xtensa/include/asm/dma-mapping.h    |  220 +++-------------
>  7 files changed, 606 insertions(+), 1249 deletions(-)
> 
> diff --git a/include/asm-generic/dma-mapping-linear.h b/include/asm-generic/dma-mapping-linear.h
> new file mode 100644
> index 0000000..13f37db
> --- /dev/null
> +++ b/include/asm-generic/dma-mapping-linear.h
> @@ -0,0 +1,391 @@
> +#ifndef __ASM_GENERIC_DMA_MAPPING_H
> +#define __ASM_GENERIC_DMA_MAPPING_H
> +
> +#include <linux/mm.h>
> +#include <linux/device.h>
> +#include <linux/dma-debug.h>
> +#include <linux/scatterlist.h>
> +#include <asm/cacheflush.h>
> +#include <asm/io.h>
> +
> +#ifdef CONFIG_DMA_COHERENT
> +/*
> + * An architecture should override these if it needs to
> + * perform cache flushes before passing bus addresses
> + * to a device.
> + * It can either do a full flush in dma_coherent_dev
> + * and return 1 from there, or implement more specific
> + * synchronization in dma_cache_sync, which will be
> + * applied separately to each sg element.
> + */
> +static inline int
> +dma_coherent_dev(struct device *dev)
> +{
> +	return 1;
> +}
> +
> +static inline void
> +dma_cache_sync(struct device *dev, void *cpu_addr, size_t size,
> +	       enum dma_data_direction direction)
> +{
> +}
> +
> +/**
> + * dma_alloc_coherent - allocate consistent memory for DMA
> + * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
> + * @size: required memory size
> + * @handle: bus-specific DMA address
> + *
> + * Allocate some uncached, unbuffered memory for a device for
> + * performing DMA.  This function allocates pages, and will
> + * return the CPU-viewed address, and sets @handle to be the
> + * device-viewed address.
> + */
> +void *dma_alloc_coherent(struct device *dev, size_t size,
> +				dma_addr_t *dma_handle, gfp_t flag)
> +{
> +	void *ret;
> +	struct page *page;
> +	int node = dev_to_node(dev);
> +
> +	/* ignore region specifiers */
> +	flag  &= ~(__GFP_HIGHMEM);
> +
> +	page = alloc_pages_node(node, flag, get_order(size));
> +	if (page == NULL)
> +		return NULL;
> +	ret = page_address(page);
> +	memset(ret, 0, size);
> +	*dma_handle = virt_to_abs(ret) + get_dma_direct_offset(dev);
> +
> +	return ret;
> +}

I don't think that this works for all architectures because a returned
buffer of alloc_pages_node might not be DMA-capable. Needs to use the
coherent_dma_mask here. See x86's dma_alloc_coherent and Alpha's
pci-noop.c (there might be other examples).

I think that having a generic header for simple mapping functions
(dma_map_single, dma_map_page, dma_map_sg, etc) would be useful but
I'm not sure if we can't have a generic version of
dma_alloc_coherent. There are lots of architectures that do
architecture-specific things. For example, you replaced avr32
dma-mapping.h except for dma_alloc_coherent, which seems to be can't
be generic.

BTW, it looks odd to add dma_debug to dma_map_single, etc but not
dma_alloc_coherent. ;)

