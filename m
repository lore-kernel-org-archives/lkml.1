Return-Path: <linux-kernel-owner+w=401wt.eu-S1759046AbYFJKYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759046AbYFJKYQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 06:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753513AbYFJKYB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 06:24:01 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46166 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752770AbYFJKYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 06:24:00 -0400
Date: Tue, 10 Jun 2008 12:23:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Miquel van Smoorenburg <mikevs@xs4all.net>
Cc: linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] 2.6.26-rc: x86: pci-dma.c: use __GFP_NO_OOM instead of
	__GFP_NORETRY
Message-ID: <20080610102347.GC19136@elte.hu>
References: <20080526234940.GA1376@xs4all.net> <20080527014720.6db68517.akpm@linux-foundation.org> <20080528024727.GB20824@one.firstfloor.org> <1211963485.28138.14.camel@localhost.localdomain> <20080602101547.GD7459@elte.hu> <1212682484.4332.7.camel@n2o.xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1212682484.4332.7.camel@n2o.xs4all.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Miquel van Smoorenburg <mikevs@xs4all.net> wrote:

> On Mon, 2008-06-02 at 12:15 +0200, Ingo Molnar wrote:
> > * Miquel van Smoorenburg <mikevs@xs4all.net> wrote:
> > 
> > > Okay, so how about this then ?
> >
> > 
> > applied to tip/pci-for-jesse for more testing. Thanks,
> 
> I've thought about it a bit more, and I think the actual patch that 
> really does what everybody wants is this one instead:

applied a delta patch version of the one below to tip/pci-for-jesse. 
Thanks,

	Ingo

> [PATCH] x86: pci-dma.c: don't always add __GFP_NORETRY to gfp
> 
> Currently arch/x86/kernel/pci-dma.c always adds __GFP_NORETRY
> to the allocation flags, because it wants to be reasonably
> sure not to deadlock when calling alloc_pages().
> 
> But really that should only be done in two cases:
> - when allocating memory in the lower 16 MB DMA zone.
>   If there's no free memory there, waiting or OOM killing is of no use
> - when optimistically trying an allocation in the DMA32 zone
>   when dma_mask < DMA_32BIT_MASK hoping that the allocation
>   happens to fall within the limits of the dma_mask
> 
> Also blindly adding __GFP_NORETRY to the the gfp variable might
> not be a good idea since we then also use it when calling
> dma_ops->alloc_coherent(). Clearing it might also not be a
> good idea, dma_alloc_coherent()'s caller might have set it
> on purpose. The gfp variable should not be clobbered.
> 
> Signed-off-by: Miquel van Smoorenburg <miquels@cistron.nl>
> 
> --- linux-2.6.26-rc4.orig/arch/x86/kernel/pci-dma.c	2008-05-26 20:08:11.000000000 +0200
> +++ linux-2.6.26-rc4/arch/x86/kernel/pci-dma.c	2008-06-05 17:51:41.000000000 +0200
> @@ -378,6 +378,7 @@ dma_alloc_coherent(struct device *dev, s
>  	struct page *page;
>  	unsigned long dma_mask = 0;
>  	dma_addr_t bus;
> +	int noretry = 0;
>  
>  	/* ignore region specifiers */
>  	gfp &= ~(__GFP_DMA | __GFP_HIGHMEM | __GFP_DMA32);
> @@ -397,20 +398,25 @@ dma_alloc_coherent(struct device *dev, s
>  	if (dev->dma_mask == NULL)
>  		return NULL;
>  
> -	/* Don't invoke OOM killer */
> -	gfp |= __GFP_NORETRY;
> +	/* Don't invoke OOM killer or retry in lower 16MB DMA zone */
> +	if (gfp & __GFP_DMA)
> +		noretry = 1;
>  
>  #ifdef CONFIG_X86_64
>  	/* Why <=? Even when the mask is smaller than 4GB it is often
>  	   larger than 16MB and in this case we have a chance of
>  	   finding fitting memory in the next higher zone first. If
>  	   not retry with true GFP_DMA. -AK */
> -	if (dma_mask <= DMA_32BIT_MASK && !(gfp & GFP_DMA))
> +	if (dma_mask <= DMA_32BIT_MASK && !(gfp & GFP_DMA)) {
>  		gfp |= GFP_DMA32;
> +		if (dma_mask < DMA_32BIT_MASK)
> +			noretry = 1;
> +	}
>  #endif
>  
>   again:
> -	page = dma_alloc_pages(dev, gfp, get_order(size));
> +	page = dma_alloc_pages(dev,
> +		noretry ? gfp | __GFP_NORETRY : gfp, get_order(size));
>  	if (page == NULL)
>  		return NULL;
>  
> 
