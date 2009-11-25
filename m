Return-Path: <linux-kernel-owner+w=401wt.eu-S933034AbZKYAJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933034AbZKYAJ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 19:09:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932779AbZKYAJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 19:09:57 -0500
Received: from sh.osrg.net ([192.16.179.4]:36518 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932769AbZKYAJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 19:09:57 -0500
Date: Wed, 25 Nov 2009 09:05:00 +0900
To: yinghai@kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] x86: fix iommu=soft boot option
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4B0C7257.3070609@kernel.org>
References: <20091125084611O.fujita.tomonori@lab.ntt.co.jp>
	<4B0C7257.3070609@kernel.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20091125090441G.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 25 Nov 2009 09:05:00 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Nov 2009 15:55:03 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

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

I know but it's GART problem.

'iommu=soft' means that the kernel must use swiotlb. All the IOMMU
drivers except for GART works properly.

Documentation/x86/x86_64/boot-options.txt says:

  General iommu options:
    off                Don't initialize and use any kind of IOMMU.
    noforce            Don't force hardware IOMMU usage when it is not needed.
                       (default).
    force              Force the use of the hardware IOMMU even when it is
                       not actually needed (e.g. because < 3 GB memory).
    soft               Use software bounce buffering (SWIOTLB) (default for
                       Intel machines). This can be used to prevent the usage
                       of an available hardware IOMMU.


> 2. if BIOS does not have correct gart setting, Kernel will use swiotlb
> 
> for AMD 64bit, MEM > 4g, no AGP, no "iommu=soft"
> 1. if BIOS have correct gart setting, Kernel will use gart
> 2. if BIOS does not have correct gart setting, Kernel will allocate some RAM, and set range in AMD NB, and use gart iommu
> 
> YH
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
