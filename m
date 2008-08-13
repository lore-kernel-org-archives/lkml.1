Return-Path: <linux-kernel-owner+w=401wt.eu-S1754592AbYHMUsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbYHMUsp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 16:48:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752242AbYHMUsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 16:48:37 -0400
Received: from sh.osrg.net ([192.16.179.4]:42245 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751636AbYHMUsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 16:48:36 -0400
Date: Thu, 14 Aug 2008 05:46:34 +0900
To: joerg.roedel@amd.com
Cc: fujita.tomonori@lab.ntt.co.jp, mingo@redhat.com, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, muli@il.ibm.com
Subject: Re: [PATCH 1/7] x86: add alloc_coherent dma_ops callback to GART
 driver
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080813124636.GH14993@amd.com>
References: <1218554657-16070-2-git-send-email-joerg.roedel@amd.com>
	<20080813094535T.fujita.tomonori@lab.ntt.co.jp>
	<20080813124636.GH14993@amd.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080814054636K.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Aug 2008 14:46:36 +0200
Joerg Roedel <joerg.roedel@amd.com> wrote:

> On Wed, Aug 13, 2008 at 09:45:54AM +0900, FUJITA Tomonori wrote:
> > On Tue, 12 Aug 2008 17:24:11 +0200
> > Joerg Roedel <joerg.roedel@amd.com> wrote:
> > 
> > > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> > > ---
> > >  arch/x86/kernel/pci-gart_64.c |   21 +++++++++++++++++++++
> > >  1 files changed, 21 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
> > > index cdab678..55cc388 100644
> > > --- a/arch/x86/kernel/pci-gart_64.c
> > > +++ b/arch/x86/kernel/pci-gart_64.c
> > > @@ -499,6 +499,26 @@ error:
> > >  	return 0;
> > >  }
> > >  
> > > +/* allocate and map a coherent mapping */
> > > +static void *
> > > +gart_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_addr,
> > > +		    gfp_t flag)
> > > +{
> > > +	void *vaddr;
> > > +
> > > +	vaddr = (void *)__get_free_pages(flag, get_order(size));
> > > +	if (!vaddr)
> > > +		return NULL;
> > > +
> > > +	*dma_addr = gart_map_single(dev, __pa(vaddr), size, DMA_BIDIRECTIONAL);
> > > +	if (*dma_addr != bad_dma_address)
> > > +		return vaddr;
> > > +
> > > +	free_pages((unsigned long)vaddr, get_order(size));
> > > +
> > > +	return NULL;
> > > +}
> > > +
> > >  static int no_agp;
> > 
> > It would be better to return a size-aligned memory as DMA-mapping.txt
> > says (though I don't think that it doesn't matter much):
> > 
> > http://lkml.org/lkml/2008/8/8/555
> 
> Agreed. I try to change the patchset so it returns size aligned dma
> addresses.
>  
> > I also think that x86 IOMMUs need to handle DMA_*BIT_MASK properly,
> > don't we?
> 
> Shouldn't this be done by the IOMMUs using your iommu_area_alloc()
> function? Or do I misunderstand something?

iommu_area_alloc works but IOMMUs need to use it
properly. arch/powerpc/kernel/iommu.c is a good example.
