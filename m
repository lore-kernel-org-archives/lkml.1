Return-Path: <linux-kernel-owner+w=401wt.eu-S1756763AbYIDKBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763AbYIDKBq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 06:01:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754280AbYIDKBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 06:01:37 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:5872 "EHLO
	SG2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316AbYIDKBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 06:01:36 -0400
X-BigFish: VPS-30(zz1432R98dR1805M936fQzz10d3izzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K6O16C-03-EBP-01
Date: Thu, 4 Sep 2008 12:00:35 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: joro@8bytes.org, tony.luck@intel.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, mingo@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 1/3] x86: remove the NULL device hack in dma-mapping.h
Message-ID: <20080904100035.GS3189@amd.com>
References: <1220465065-10533-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1220465065-10533-2-git-send-email-fujita.tomonori@lab.ntt.co.jp> <20080903200114.GC16706@8bytes.org> <20080904130800O.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080904130800O.fujita.tomonori@lab.ntt.co.jp>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 04 Sep 2008 10:00:35.0575 (UTC) FILETIME=[135F6070:01C90E75]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2008 at 01:11:46PM +0900, FUJITA Tomonori wrote:
> On Wed, 3 Sep 2008 22:01:14 +0200
> Joerg Roedel <joro@8bytes.org> wrote:
> 
> > On Thu, Sep 04, 2008 at 03:04:23AM +0900, FUJITA Tomonori wrote:
> > > dma_alloc_coherent in dma-mapping.h has a hack to use
> > > x86_dma_fallback_dev if a pointer to a device is NULL. Some of IOMMUs
> > > don't need such hack. The hack also makes it difficult for IOMMUs to
> > > make a proper decision because the hack hides the information.
> > 
> > I don't think its the right way to work around shortcomings of the
> > generic code in the architecture specific implementations. Especially
> > when the generic code can be easily fixed like in this case.
> 
> Well, the generic code should not have such work around.

I don't see that as a workaround. It is the best what we can do to
handle device dma_masks with the current Linux page allocator (if we
don't have hardware dma translation).

> As I wrote in another mail, you try to bring back the tricks used in
> arch/x86/kernel/pci-dma.c to lib/swiotlb.c. I try to bring back them
> to arch/x86/kernel/pci-swiotlb.c.

As I said, I don't see that as a 'hack'. It is also what the fixme
comment in the swiotlb alloc_coherent function stated, that this
function has to handle the DMA mask of the device.

> > > +static void *x86_swiotlb_alloc_coherent(struct device *dev, size_t size,
> > > +					dma_addr_t *dma_handle, gfp_t gfp)
> > > +{
> > > +	if (!dev) {
> > > +		dev = &x86_dma_fallback_dev;
> > > +		gfp |= GFP_DMA;
> > > +	}
> > 
> > This really should be checked in the generic x86 dma_alloc_coherent
> > function.
> 
> I don't think so. Any motherboards with the recent IOMMUs support ISA?

Not that I am aware of. But as we both know there are people who do
corner case tests with the dma-api functions like passing their own
created devices or even NULL to it an look what happens :-)
We have to handle this case in _every_ IOMMU implemention. So the
generic function is the right place for this check, imho.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

