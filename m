Return-Path: <linux-kernel-owner+w=401wt.eu-S1757351AbXFFIYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757351AbXFFIYU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 04:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752884AbXFFIYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 04:24:08 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39298 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505AbXFFIYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 04:24:05 -0400
Subject: Re: [PATCH] lib:  Replace calls to __get_free_pages() with
	__get_dma_pages().
From: Peter Zijlstra <peterz@infradead.org>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0706060350040.29202@localhost.localdomain>
References: <Pine.LNX.4.64.0706051657350.20029@localhost.localdomain>
	 <20070605170601.67bc2939.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0706060350040.29202@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 06 Jun 2007 10:24:01 +0200
Message-Id: <1181118241.7348.173.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-06 at 03:56 -0400, Robert P. J. Day wrote:
> On Tue, 5 Jun 2007, Andrew Morton wrote:
> 
> > On Tue, 5 Jun 2007 16:58:57 -0400 (EDT)
> > "Robert P. J. Day" <rpjday@mindspring.com> wrote:
> >
> > > Replace a couple calls to __get_free_pages() with the corresponding
> > > calls to __get_dma_pages().
> > >
> > > Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
> > >
> > > ---
> > >
> > >   that's the lot of them.
> > >
> > > diff --git a/lib/swiotlb.c b/lib/swiotlb.c
> > > index 10c13ad..8fc38dc 100644
> > > --- a/lib/swiotlb.c
> > > +++ b/lib/swiotlb.c
> > > @@ -201,8 +201,7 @@ swiotlb_late_init_with_default_size(size_t default_size)
> > >  	bytes = io_tlb_nslabs << IO_TLB_SHIFT;
> > >
> > >  	while ((SLABS_PER_PAGE << order) > IO_TLB_MIN_SLABS) {
> > > -		io_tlb_start = (char *)__get_free_pages(GFP_DMA | __GFP_NOWARN,
> > > -		                                        order);
> > > +		io_tlb_start = (char *)__get_dma_pages(__GFP_NOWARN, order);
> >
> > __get_dma_pages() is just pointless obfuscation.  I think it'd be better to
> > go the other way: open-code the GFP_DMA at all callsites then send
> > __get_dma_pages() bitbucketwards.
> 
> ok, it's easy enough to put together a patch that rids the tree of the
> superfluous __get_dma_pages() call.  but in converting back to a call
> to __get_free_pages(), which of the two zone modifiers should be added
> -- "GFP_DMA" or "__GFP_DMA" -- since they're currently defined
> equivalently in include/linux/gfp.h.  and there's definitely a mixture
> of usage in the tree at the moment:
> 
> $ grep -r "get_free.*GFP_DMA" *
> arch/s390/kernel/smp.c:                 __get_free_pages(GFP_KERNEL | GFP_DMA,
> drivers/net/arm/ep93xx_eth.c:           page = (void *)__get_free_page(GFP_KERNEL | GFP_DMA);
> drivers/net/arm/ep93xx_eth.c:           page = (void *)__get_free_page(GFP_KERNEL | GFP_DMA);
> drivers/s390/net/qeth_main.c:                   ptr = (void *) __get_free_page(GFP_KERNEL|GFP_DMA);
> drivers/s390/net/claw.c:                        (void *)__get_free_pages(__GFP_DMA,
> drivers/s390/net/claw.c:                        (void *)__get_free_pages(__GFP_DMA,
> drivers/s390/net/claw.c:                   p_buff=(void *)__get_free_pages(__GFP_DMA,
> drivers/s390/net/claw.c:                        (void *)__get_free_pages(__GFP_DMA,
> drivers/s390/net/claw.c:                        p_buff = (void *)__get_free_pages(__GFP_DMA,
> drivers/s390/block/dasd.c:      device->ccw_mem = (void *) __get_free_pages(GFP_ATOMIC | GFP_DMA, 1);
> drivers/s390/char/tty3270.c:                    __get_free_pages(GFP_KERNEL|GFP_DMA, 0);
> drivers/s390/char/sclp_cpi.c:   sccb = (struct cpi_sccb *) __get_free_page(GFP_KERNEL | GFP_DMA);
> drivers/s390/cio/cmf.c:         mem = (void*)__get_free_pages(GFP_KERNEL | GFP_DMA,
> include/linux/gfp.h:            __get_free_pages((gfp_mask) | GFP_DMA,(order))
> lib/swiotlb.c:          io_tlb_start = (char *)__get_free_pages(GFP_DMA | __GFP_NOWARN,
> lib/swiotlb.c:  io_tlb_overflow_buffer = (void *)__get_free_pages(GFP_DMA,
> 
>   i'm guessing "GFP_DMA" would be the right choice, which means that,
> for consistency, the calls using __GFP_DMA should be switched over as
> well.  guidance, anyone?

FWIW I prefer:

  GFP_KERNEL | __GFP_DMA
  GFP_ATOMIC | __GFP_DMA

and

  GFP_DMA

That is, when used as a modifier use __GFP_, when used as a class use
GFP_.

