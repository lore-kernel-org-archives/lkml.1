Return-Path: <linux-kernel-owner+w=401wt.eu-S1757283AbYIDMwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283AbYIDMwR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 08:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755882AbYIDMv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 08:51:59 -0400
Received: from sh.osrg.net ([192.16.179.4]:53851 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753191AbYIDMv6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 08:51:58 -0400
Date: Thu, 4 Sep 2008 21:50:19 +0900
To: joerg.roedel@amd.com
Cc: fujita.tomonori@lab.ntt.co.jp, joro@8bytes.org, tony.luck@intel.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       mingo@redhat.com, kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 1/3] x86: remove the NULL device hack in dma-mapping.h
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080904100035.GS3189@amd.com>
References: <20080903200114.GC16706@8bytes.org>
	<20080904130800O.fujita.tomonori@lab.ntt.co.jp>
	<20080904100035.GS3189@amd.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080904215030Y.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Sep 2008 12:00:35 +0200
Joerg Roedel <joerg.roedel@amd.com> wrote:

> On Thu, Sep 04, 2008 at 01:11:46PM +0900, FUJITA Tomonori wrote:
> > On Wed, 3 Sep 2008 22:01:14 +0200
> > Joerg Roedel <joro@8bytes.org> wrote:
> > 
> > > On Thu, Sep 04, 2008 at 03:04:23AM +0900, FUJITA Tomonori wrote:
> > > > dma_alloc_coherent in dma-mapping.h has a hack to use
> > > > x86_dma_fallback_dev if a pointer to a device is NULL. Some of IOMMUs
> > > > don't need such hack. The hack also makes it difficult for IOMMUs to
> > > > make a proper decision because the hack hides the information.
> > > 
> > > I don't think its the right way to work around shortcomings of the
> > > generic code in the architecture specific implementations. Especially
> > > when the generic code can be easily fixed like in this case.
> > 
> > Well, the generic code should not have such work around.
> 
> I don't see that as a workaround. It is the best what we can do to
> handle device dma_masks with the current Linux page allocator (if we
> don't have hardware dma translation).

It's a hack. What swiotlb should do is allocating from only swiotlb's
memory area (I agree with Andi about this). dma_mask is irrelevant for
it. The current swiotlb_alloc_coherent is a bit wrong though I don't
like to bother IA64 people.


> > > > +static void *x86_swiotlb_alloc_coherent(struct device *dev, size_t size,
> > > > +					dma_addr_t *dma_handle, gfp_t gfp)
> > > > +{
> > > > +	if (!dev) {
> > > > +		dev = &x86_dma_fallback_dev;
> > > > +		gfp |= GFP_DMA;
> > > > +	}
> > > 
> > > This really should be checked in the generic x86 dma_alloc_coherent
> > > function.
> > 
> > I don't think so. Any motherboards with the recent IOMMUs support ISA?
> 
> Not that I am aware of. But as we both know there are people who do
> corner case tests with the dma-api functions like passing their own
> created devices or even NULL to it an look what happens :-)

That's the wrong way to use DMA API. We don't need to care about
it. The only reason we handle it now is for the ancient code.


> We have to handle this case in _every_ IOMMU implemention. So the
> generic function is the right place for this check, imho.

As I said, I don't think that every IOMMU need to handle it. Well,
it's a minor issue. I don't care much so handling it in a generic code
is fine. But as I pointed out in another mail, the fallback device has
DMA_32BIT_MASK so hiding it in dma-mapping.h makes it difficult to
make pci-dma.c work as before.
