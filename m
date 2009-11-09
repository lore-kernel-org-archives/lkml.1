Return-Path: <linux-kernel-owner+w=401wt.eu-S1755333AbZKIXc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333AbZKIXc4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 18:32:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754747AbZKIXcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 18:32:55 -0500
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:44234 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206AbZKIXcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 18:32:55 -0500
Subject: Re: [PATCH] intel-iommu: Obey coherent_dma_mask for alloc_coherent
 on	passthrough
From: Alex Williamson <alex.williamson@hp.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Chris Wright <chrisw@sous-sol.org>,
       "Miller, Mike (OS Dev)" <mike.miller@hp.com>
In-Reply-To: <1257807747.25961.852.camel@macbook.infradead.org>
References: <20091104225359.2720.91502.stgit@nehalem.aw>
	 <20091106114130J.fujita.tomonori@lab.ntt.co.jp>
	 <1257807747.25961.852.camel@macbook.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Organization: HP OSLO R&D
Date: Mon, 09 Nov 2009 16:32:04 -0700
Message-ID: <1257809524.24450.64.camel@8530w.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-09 at 23:02 +0000, David Woodhouse wrote:
> On Fri, 2009-11-06 at 11:41 +0900, FUJITA Tomonori wrote:
> > This is fine for 2.6.32 but we'll cleanly fix this by using
> > swiotlb_dma_ops later, right?
> 
> Well, the idea was that with 'iommu=pt' we'd have passthrough mode for
> _decent_ devices, but the crappy devices without 64-bit DMA would just
> have the IOMMU enabled instead.
> 
> We can see this as a simple classification bug -- we should be checking
> pdev->coherent_dma_mask as well as pdev->dma_mask:
> 
> --- a/drivers/pci/intel-iommu.c
> +++ b/drivers/pci/intel-iommu.c
> @@ -2196,7 +2196,8 @@ static int iommu_should_identity_map(struct pci_dev *pdev, int startup)
>  	 * take them out of the 1:1 domain later.
>  	 */
>  	if (!startup)
> -		return pdev->dma_mask > DMA_BIT_MASK(32);
> +		return (pdev->dma_mask & pdev->coherent_dma_mask) < 
> +			dma_get_required_mask();
>  
>  	return 1;
>  }
> 
> That fixes the case of a 32-bit coherent_dma_mask as it was intended to
> be fixed.
> 
> Unfortunately, Alex's hardware is more broken than that. It also likes
> to do stray reads from unmapped addresses -- addresses which used to be
> mapped at some time in the past. So he really _does_ want the IOMMU
> disabled, or in passthrough mode.
> 
> But I think that's a special case and needs to be handled with a quirk,
> while the above patch actually addresses the problem we claimed we were
> trying to address.

I'm not sure what this quirk looks like, do you have something in mind?

> Handling Alex's broken hardware probably wants to be done with
> 'iommu=off' for now, and then when Chris's swiotlb fallback patches are
> done we can perhaps do something more cunning.

iommu=off means a feature regression from 2.6.31 and kills support for
being able to use VT-d for virtualization for a large percentage of
servers from a major vendor.  I don't think Chris' patches actually
address this since we don't actually know what the DMA mask is for a
device until the driver claims it.  How long do we wait before we drop
the swiotlb?  I think his patch is really intended for the "oops, the
DMAR is broken, the hardware is bad, I can't init the hardware IOMMU,
whew we can fallback to swiotlb".

> I'm slightly reluctant to put the half-arsed 'try to allocate in the
> right region for broken devices but without full swiotlb support' option
> into 2.6.32.

Since the device also makes use of RMRRs, once we have it in the
si_domain, we're stuck.  I think that means we needs swiotlb anytime
we're in passthrough mode.  That's what 2.6.31, can we get it back for
2.6.32?  Thanks,

Alex


