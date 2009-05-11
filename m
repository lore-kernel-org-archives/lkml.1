Return-Path: <linux-kernel-owner+w=401wt.eu-S1760801AbZEKW7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760801AbZEKW7c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 18:59:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758607AbZEKW7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 18:59:22 -0400
Received: from sh.osrg.net ([192.16.179.4]:37741 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758582AbZEKW7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 18:59:21 -0400
Date: Tue, 12 May 2009 07:59:02 +0900
To: arnd@arndb.de
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tony.luck@intel.com, linux-ia64@vger.kernel.org
Subject: Re: [PATCH -tip 1/5] add asm-generic/dma-mappig.h
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <200905071238.05110.arnd@arndb.de>
References: <1241670948-5818-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1241670948-5818-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<200905071238.05110.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090512080018N.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 12 May 2009 07:59:02 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 May 2009 12:38:04 +0200
Arnd Bergmann <arnd@arndb.de> wrote:

> On Thursday 07 May 2009, FUJITA Tomonori wrote:
> > This header file provides some generic dma mapping function
> > definitions for the users of struct dma_map_ops.
> > 
> > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> 
> I'm currently trying to add asm-generic variants for all of
> the common headers. One of my goals there is to make them
> as complete as possible, i.e. if a header file in asm-generic
> has the same name as one in any of the architectures, it should
> IMHO provide the same (full) API.

I see.


> I would therefore suggest that you either rename the file to
> something like dma-mapping-common.h or add some template
> functions that can be overriden per architecture, like
> 
> #ifndef dma_get_ops
> static inline struct dma_map_ops *get_dma_ops(struct device *dev)
> {
> 	return dma_ops;
> }
> #endif
> #ifndef dma_alloc_coherent
> /*
>  * to be defined out of line
>  */
> extern void *dma_alloc_coherent(struct device *dev, size_t size,
> 		dma_addr_t *dma_handle, gfp_t gfp);
> #endif
> 
> Then an architecture can opt-in to do things like:
> 
> #define dma_get_ops dma_get_ops
> static inline struct dma_map_ops *get_dma_ops(struct device *dev)
> {
> 	return dev->archdata.dma_ops;
> }
> 
> before the #include <asm-generic/dma-mapping.h>

It doesn't fit for what we want with dma-mapping.h and looks really
ugly.

ok, I'll go with something like include/linux/dma-mapping-common.h.


> > +static inline dma_addr_t dma_map_single_attrs(struct device *dev, void *ptr,
> > +					      size_t size,
> > +					      enum dma_data_direction dir,
> > +					      struct dma_attrs *attrs)
> > +{
> > +	struct dma_map_ops *ops = get_dma_ops(dev);
> > +	dma_addr_t addr;
> > +
> > +	kmemcheck_mark_initialized(ptr, size);
> > +	BUG_ON(!valid_dma_direction(dir));
> > +	addr = ops->map_page(dev, virt_to_page(ptr),
> > +			     (unsigned long)ptr & ~PAGE_MASK, size,
> > +			     dir, NULL);
> > +	debug_dma_map_page(dev, virt_to_page(ptr),
> > +			   (unsigned long)ptr & ~PAGE_MASK, size,
> > +			   dir, addr, true);
> > +	return addr;
> > +}
> 
> You are not passing the dma_attrs down here, which I think you need to,
> if any of the architectures using this file want to support DMA attributes.

Yeah, thanks. It's my silly mistake. IA64 needs dma_attrs so of course
we heed to pass it down here.
