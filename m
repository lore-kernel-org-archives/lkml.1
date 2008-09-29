Return-Path: <linux-kernel-owner+w=401wt.eu-S1750910AbYI2Ndg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750910AbYI2Ndg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 09:33:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbYI2Nd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 09:33:26 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:60998 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848AbYI2NdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 09:33:25 -0400
X-BigFish: VPS-23(zz1432R98dR1805M936fO873fnzzzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K7YLN9-03-NBM-01
Date: Mon, 29 Sep 2008 15:33:11 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: joro@8bytes.org, muli@il.ibm.com, amit.shah@redhat.com,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       iommu@lists.linux-foundation.org, dwmw2@infradead.org, mingo@redhat.com
Subject: Re: [PATCH 9/9] x86/iommu: use dma_ops_list in get_dma_ops
Message-ID: <20080929133311.GK27928@amd.com>
References: <20080928191333.GC26563@8bytes.org> <20080929093044.GB6931@il.ibm.com> <20080929093652.GQ27426@8bytes.org> <20080929221640X.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080929221640X.fujita.tomonori@lab.ntt.co.jp>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 29 Sep 2008 13:33:11.0529 (UTC) FILETIME=[EAD73D90:01C92237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2008 at 10:16:44PM +0900, FUJITA Tomonori wrote:
> On Mon, 29 Sep 2008 11:36:52 +0200
> Joerg Roedel <joro@8bytes.org> wrote:
> 
> > On Mon, Sep 29, 2008 at 12:30:44PM +0300, Muli Ben-Yehuda wrote:
> > > On Sun, Sep 28, 2008 at 09:13:33PM +0200, Joerg Roedel wrote:
> > > 
> > > > I think we should try to build a paravirtualized IOMMU for KVM
> > > > guests.  It should work this way: We reserve a configurable amount
> > > > of contiguous guest physical memory and map it dma contiguous using
> > > > some kind of hardware IOMMU. This is possible with all hardare
> > > > IOMMUs we have in the field by now, also Calgary and GART. The guest
> > > > does dma_coherent allocations from this memory directly and is done.
> > > > For map_single and map_sg 
> > > > the guest can do bounce buffering. We avoid nearly all pvdma hypercalls
> > > > with this approach, keep guest swapping working and solve also the
> > > > problems with device dma_masks and guest memory that is not contigous on
> > > > the host side.
> > > 
> > > I'm not sure I follow, but if I understand correctly with this
> > > approach the guest could only DMA into buffers that fall within the
> > > range you allocated for DMA and mapped. Isn't that a pretty nasty
> > > limitation?  The guest would need to bounce-bufer every frame that
> > > happened to not fall inside that range, with the resulting loss of
> > > performance.
> > 
> > The bounce buffering is needed for map_single/map_sg allocations. For
> > dma_alloc_coherent we can directly allocate from that range. The
> > performance loss of the bounce buffering may be lower than the
> > hypercalls we need as the alternative (we need hypercalls for map, unmap
> > and sync).
> 
> Nobody cares about the performance of dma_alloc_coherent. Only the
> performance of map_single/map_sg matters.
>
> I'm not sure how expensive the hypercalls are, but they are more
> expensive than bounce buffering coping lots of data for every I/Os?

I don't think that we can avoid bounce buffering into the guests at all
(with and without my idea of a paravirtualized IOMMU) when we want to
handle dma_masks and requests that cross guest physical pages properly.

With mapping/unmapping through hypercalls we add the world-switch
overhead to the copy-overhead. We can't avoid this when we have no
hardware support at all. But already with older IOMMUs like Calgary and
GART we can at least avoid the world-switch. And since, for example,
every 64 bit capable AMD processor has a GART we can make use of it.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

