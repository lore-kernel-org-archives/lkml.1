Return-Path: <linux-kernel-owner+w=401wt.eu-S1753206AbYI1TNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206AbYI1TNp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 15:13:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751606AbYI1TNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 15:13:36 -0400
Received: from 8bytes.org ([88.198.83.132]:49940 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152AbYI1TNf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 15:13:35 -0400
Date: Sun, 28 Sep 2008 21:13:33 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>, Amit Shah <amit.shah@redhat.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       iommu@lists.linux-foundation.org, David Woodhouse <dwmw2@infradead.org>,
       Ingo Molnar <mingo@redhat.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 9/9] x86/iommu: use dma_ops_list in get_dma_ops
Message-ID: <20080928191333.GC26563@8bytes.org>
References: <1222107681-8185-1-git-send-email-joerg.roedel@amd.com> <200809261326.19261.amit.shah@redhat.com> <20080926085924.GC27928@amd.com> <200809261619.51637.amit.shah@redhat.com> <20080926123243.GE27928@amd.com> <20080927001321.GI9118@il.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080927001321.GI9118@il.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 27, 2008 at 03:13:21AM +0300, Muli Ben-Yehuda wrote:
> On Fri, Sep 26, 2008 at 02:32:43PM +0200, Joerg Roedel wrote:
> 
> > Ok, the allocation only matters for dma_alloc_coherent. Fujita
> > introduced a generic software-based dma_alloc_coherent recently
> > which you can use for that. I think implementing PVDMA into an own
> > dma_ops backend and multiplex it using my patches introduces less
> > overhead than an additional layer over the current dma_ops
> > implementation.
> 
> I'm not sure what you have in mind, but I agree with Amit that
> conceptually pvdma should be called after the guest's "native" dma_ops
> have done their thing. This is not just for nommu, consider a guest
> that is using an (emulated) hardware IOMMU, or that wants to use
> swiotlb. We can't replicate their functionality in the pv_dma_ops
> layer, we have to let them run first and then pass deal with whatever
> we get back.

I have something in mind what I discussed with Amit at the last KVM
forum. The idea was not ready at the event but meanwhile it has matured
a bit.
I think we should try to build a paravirtualized IOMMU for KVM guests.
It should work this way: We reserve a configurable amount of contiguous
guest physical memory and map it dma contiguous using some kind of
hardware IOMMU. This is possible with all hardare IOMMUs we have in the
field by now, also Calgary and GART. The guest does dma_coherent
allocations from this memory directly and is done. For map_single and map_sg
the guest can do bounce buffering. We avoid nearly all pvdma hypercalls
with this approach, keep guest swapping working and solve also the
problems with device dma_masks and guest memory that is not contigous on
the host side.
For systems without any kind of hardware IOMMU we can extend the
interface to support bounce buffering between host and guest (in this
case we can not avoid the hypercalls). This means that the host
reserves the memory for the DMA transaction (also recognizing the
dma_mask) and copies it from/to the guest directly upon the dma_*_sync
calls.
This is what I have in mind and want to propose. Maybe we can discuss
these ideas here. I think since there are many systems out there with
some kind of hardware IOMMUs (every 64bit AMD processor has a GART) we
should really consider this approach.

> > Another two questions to your approach: What happens if a
> > dma_alloc_coherent allocation crosses page boundarys and the gpa's
> > are not contiguous in host memory? How will dma masks be handled?
> 
> That's a very good question. The host will need to be aware of a
> device's DMA capabilities in order to return I/O addresses (which
> could be hpa's if you don't have an IOMMU) that satisfy them. That's
> quite a pain.

True. And I fear we don't get a simple and clean interface with this
approach.

Joerg

