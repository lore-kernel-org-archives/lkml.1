Return-Path: <linux-kernel-owner+w=401wt.eu-S1758458AbZKYISq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758458AbZKYISq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 03:18:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758390AbZKYISp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 03:18:45 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58596 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758410AbZKYISp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 03:18:45 -0500
Date: Wed, 25 Nov 2009 09:18:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] x86: fix iommu=soft boot option
Message-ID: <20091125081832.GA1822@elte.hu>
References: <20091125084611O.fujita.tomonori@lab.ntt.co.jp>
 <4B0C7257.3070609@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B0C7257.3070609@kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

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

So the question is, how many people relied on the previous behavior of 
'iommu=soft' not really falling back to the swiotlb code but preventing 
the quirk from running.

Are you aware of specific versions of distributions adding iommu=soft 
and relying on that? Should we be careful about changing the previous 
behavior?

	Ingo
