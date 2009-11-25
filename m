Return-Path: <linux-kernel-owner+w=401wt.eu-S1758627AbZKYK15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758627AbZKYK15 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 05:27:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751622AbZKYK14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 05:27:56 -0500
Received: from 8bytes.org ([88.198.83.132]:47014 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386AbZKYK14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 05:27:56 -0500
X-Greylist: delayed 603 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Nov 2009 05:27:55 EST
Date: Wed, 25 Nov 2009 11:17:57 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] x86: fix iommu=soft boot option
Message-ID: <20091125101757.GC20489@8bytes.org>
References: <20091125084611O.fujita.tomonori@lab.ntt.co.jp> <4B0C7257.3070609@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B0C7257.3070609@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 03:55:03PM -0800, Yinghai Lu wrote:
> FUJITA Tomonori wrote:
> > "x86: Handle HW IOMMU initialization failure gracefully" patchset
> > handled this option properly however somehow I broke it during cleanup
> > after that. Sorry.
> > 
> > =
> > From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > Subject: [PATCH -tip] x86: fix iommu=soft boot option
> > 
> > iommu=soft boot option forces the kernel to use swiotlb.
> > 
> > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > ---
> >  arch/x86/kernel/pci-swiotlb.c |    4 +++-
> >  1 files changed, 3 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/pci-swiotlb.c b/arch/x86/kernel/pci-swiotlb.c
> > index e36e71d..e3c0a66 100644
> > --- a/arch/x86/kernel/pci-swiotlb.c
> > +++ b/arch/x86/kernel/pci-swiotlb.c
> > @@ -50,6 +50,8 @@ static struct dma_map_ops swiotlb_dma_ops = {
> >   */
> >  int __init pci_swiotlb_init(void)
> >  {
> > +	int use_swiotlb = swiotlb | swiotlb_force;
> > +
> >  	/* don't initialize swiotlb if iommu=off (no_iommu=1) */
> >  #ifdef CONFIG_X86_64
> >  	if (!no_iommu && max_pfn > MAX_DMA32_PFN)
> > @@ -63,5 +65,5 @@ int __init pci_swiotlb_init(void)
> >  		dma_ops = &swiotlb_dma_ops;
> >  	}
> >  
> > -	return swiotlb_force;
> > +	return use_swiotlb;
> >  }
> 
> before your cleanup patchset:
> for AMD 64bit, MEM > 4g, no AGP, iommu=soft
> 1. if BIOS have correct gart setting, Kernel will use gart
> 2. if BIOS does not have correct gart setting, Kernel will use swiotlb
> 
> for AMD 64bit, MEM > 4g, no AGP, no "iommu=soft"
> 1. if BIOS have correct gart setting, Kernel will use gart
> 2. if BIOS does not have correct gart setting, Kernel will allocate some RAM, and set range in AMD NB, and use gart iommu

The swiotlb is used as a dma-api backend always when 'iommu=soft' is specified,
at least the code I read without the cleanup patchset. The cleanup patchset
broke that in some places. Now I need to pass swiotlb=force to achieve the same
for AMD IOMMU. The above patch fixes this.
But that iommu=soft will prevent the kernel from fixing up broken gart settings
is new to me. Where have you seen this behavior?

	Joerg

