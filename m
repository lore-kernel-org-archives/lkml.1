Return-Path: <linux-kernel-owner+w=401wt.eu-S1753859AbZKCX6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859AbZKCX6V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 18:58:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752986AbZKCX6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 18:58:20 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41607 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752142AbZKCX6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 18:58:19 -0500
Date: Tue, 3 Nov 2009 15:57:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Alex Williamson <alex.williamson@hp.com>, iommu@lists.linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Miller, Mike (OS Dev)" <mike.miller@hp.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] intel-iommu: Fix alloc_coherent for pass-through
 devices
Message-Id: <20091103155734.b5ee1fed.akpm@linux-foundation.org>
In-Reply-To: <1256226541.2990.87.camel@macbook.infradead.org>
References: <1256182910.2842.36.camel@2710p.home>
	<1256192928.2990.10.camel@macbook.infradead.org>
	<1256214241.2842.50.camel@2710p.home>
	<1256222867.2990.47.camel@macbook.infradead.org>
	<1256223676.3615.68.camel@8530w.home>
	<1256226541.2990.87.camel@macbook.infradead.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Oct 2009 00:49:01 +0900
David Woodhouse <dwmw2@infradead.org> wrote:

> On Thu, 2009-10-22 at 09:01 -0600, Alex Williamson wrote:
> > On Thu, 2009-10-22 at 23:47 +0900, David Woodhouse wrote:
> > > On Thu, 2009-10-22 at 06:24 -0600, Alex Williamson wrote:
> > > > The coherent_dma_mask is independent of the dma_mask and can be set
> > > > separately by the device.  The default for any device that doesn't
> > > > specify one is 32bits.  iommu_should_identity_map() only checks the
> > > > dma_mask, not the coherent_dma_mask. 
> > > 
> > > Are you telling me that this particular device supports only a 32-bit
> > > coherent DMA mask, but that it _does_ support a 64-bit DMA mask for
> > > non-coherent DMA? On x86?
> > 
> > Yes, yes.  AFAIK, this is not that exceptional.
> 
> Tomonori-san's explanation makes that make a little more sense. :)
> 
> > > >  BTW, we skip RMRR setup when doing hardware pass-through, but I can't
> > > > find where they get reloaded if we then end up removing the device
> > > > from the si_domain.  Is this another issue?
> > > 
> > > Maybe, theoretically. In practice, the whole RMRR thing is just broken
> > > by design anyway. We have to quiesce the offending devices before we
> > > turn on the IOMMU, because BIOSes tend to leave things out of the RMRR
> > > table... and then crash in SMM mode when their DMA goes AWOL. 
> > 
> > Hmm, we've had a lot of trouble getting our RMRRs to reflect shared
> > memory regions correctly, so I'm reluctant to just drop them like that.
> 
> For devices which are still doing DMA on behalf of the BIOS when the
> kernel is _running_? And for which the Linux kernel has an active driver
> of its own _too_?
> 
> Words cannot describe the horror of what you seem to be telling me...
> 
> It would be possible for us to rescan the RMRR tables when we take a
> device out of the si_domain, if we _really_ have to. But I'm going to
> want a strand of hair from the engineer responsible for that design, for
> my voodoo doll.
> 
> > Another issue, iommu_should_identity_map() only dumps devices if their
> > dma_mask is 32bit or less, but being greater than 32bits does not imply
> > 64bit DMA support.  If the device exports a DMA mask that's less than
> > the physical address width of the processor, you might be in trouble
> > (for example, a 40bit dma_mask on a platform that supports 44bits for
> > physical memory). 
> 
> That should be comparing against the maximum physical memory address
> rather than against DMA_BIT_MASK(32). I thought I'd done that, actually
> -- but it seems not.
> 
> That approach isn't perfect if memory above the threshold is later
> hotplugged -- but I'm prepared to declare that if you deliberately
> disable the IOMMU and then insert memory at a higher address than your
> devices can cope with, you get to keep both pieces.
> 
> >  Maybe dropping swiotlb out of the picture isn't such
> > a clean solution?  Thanks,
> 
> Well, there are _other_ reasons why we want to keep swiotlb around --
> the case where a BIOS bug causes us to have to abort the VT-d setup and
> fall back to swiotlb. Currently we fall back to nommu and die horribly.
> 
> You don't really need full swiotlb support for the case you're
> describing, do you? Using dma_generic_alloc_coherent() ought to be
> perfectly sufficient?
> 
> diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
> index b1e97e6..773a662 100644
> --- a/drivers/pci/intel-iommu.c
> +++ b/drivers/pci/intel-iommu.c
> @@ -2765,6 +2765,10 @@ static void *intel_alloc_coherent(struct device *hwdev, size_t size,
>  	void *vaddr;
>  	int order;
>  
> +	if (iommu_no_mapping(hwdev))
> +		return dma_generic_alloc_coherent(hwdev, size, dma_handle,
> +						  flags);
> +
>  	size = PAGE_ALIGN(size);
>  	order = get_order(size);
>  	flags &= ~(GFP_DMA | GFP_DMA32);
> 
> (That won't build on IA64)
> 

This is a box-killing post-2.6.31 regression, yes?

Alex appears to have disappeared on us, making it rather hard to fix
this up promptly.

