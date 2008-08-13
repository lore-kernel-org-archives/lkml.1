Return-Path: <linux-kernel-owner+w=401wt.eu-S1753696AbYHMMrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696AbYHMMrW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 08:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753151AbYHMMrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 08:47:10 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:4877 "EHLO
	WA4EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374AbYHMMrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 08:47:08 -0400
X-BigFish: VPS-23(zz1432R98dR1805M936fQ873fnzz10d3izz2f39iz32i6bh43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0K5JI67-04-XE9-01
Date: Wed, 13 Aug 2008 14:46:36 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       muli@il.ibm.com
Subject: Re: [PATCH 1/7] x86: add alloc_coherent dma_ops callback to GART driver
Message-ID: <20080813124636.GH14993@amd.com>
References: <1218554657-16070-1-git-send-email-joerg.roedel@amd.com> <1218554657-16070-2-git-send-email-joerg.roedel@amd.com> <20080813094535T.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080813094535T.fujita.tomonori@lab.ntt.co.jp>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 13 Aug 2008 12:46:37.0195 (UTC) FILETIME=[9FDF75B0:01C8FD42]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2008 at 09:45:54AM +0900, FUJITA Tomonori wrote:
> On Tue, 12 Aug 2008 17:24:11 +0200
> Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> > ---
> >  arch/x86/kernel/pci-gart_64.c |   21 +++++++++++++++++++++
> >  1 files changed, 21 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
> > index cdab678..55cc388 100644
> > --- a/arch/x86/kernel/pci-gart_64.c
> > +++ b/arch/x86/kernel/pci-gart_64.c
> > @@ -499,6 +499,26 @@ error:
> >  	return 0;
> >  }
> >  
> > +/* allocate and map a coherent mapping */
> > +static void *
> > +gart_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_addr,
> > +		    gfp_t flag)
> > +{
> > +	void *vaddr;
> > +
> > +	vaddr = (void *)__get_free_pages(flag, get_order(size));
> > +	if (!vaddr)
> > +		return NULL;
> > +
> > +	*dma_addr = gart_map_single(dev, __pa(vaddr), size, DMA_BIDIRECTIONAL);
> > +	if (*dma_addr != bad_dma_address)
> > +		return vaddr;
> > +
> > +	free_pages((unsigned long)vaddr, get_order(size));
> > +
> > +	return NULL;
> > +}
> > +
> >  static int no_agp;
> 
> It would be better to return a size-aligned memory as DMA-mapping.txt
> says (though I don't think that it doesn't matter much):
> 
> http://lkml.org/lkml/2008/8/8/555

Agreed. I try to change the patchset so it returns size aligned dma
addresses.
 
> I also think that x86 IOMMUs need to handle DMA_*BIT_MASK properly,
> don't we?

Shouldn't this be done by the IOMMUs using your iommu_area_alloc()
function? Or do I misunderstand something?

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

