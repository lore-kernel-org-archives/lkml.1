Return-Path: <linux-kernel-owner+w=401wt.eu-S935952AbZDISg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935952AbZDISg1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 14:36:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760273AbZDISfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 14:35:37 -0400
Received: from sh.osrg.net ([192.16.179.4]:56783 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758244AbZDISfe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 14:35:34 -0400
Date: Fri, 10 Apr 2009 03:34:48 +0900
To: jeremy@goop.org
Cc: fujita.tomonori@lab.ntt.co.jp, galak@kernel.crashing.org,
       hch@infradead.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       ian.campbell@citrix.com, beckyb@kernel.crashing.org
Subject: Re: [PATCH 4/7] swiotlb: Allow arch override of
 address_needs_mapping
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <49DD3C9C.7060101@goop.org>
References: <49DD3041.8020808@goop.org>
	<20090409083752I.fujita.tomonori@lab.ntt.co.jp>
	<49DD3C9C.7060101@goop.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090410033357S.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 10 Apr 2009 03:34:49 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 08 Apr 2009 17:09:00 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> FUJITA Tomonori wrote:
> > On Wed, 08 Apr 2009 16:16:17 -0700
> > Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> >
> >   
> >> FUJITA Tomonori wrote:
> >>     
> >>>> Becky's patches of last week also added __weak annotations to 
> >>>> swiotlb_bus_to_virt, virt_to_bus and bus_to_phys; added the hwdev 
> >>>> parameter to swiotlb_bus_to_phys; and added a weak 
> >>>> swiotlb_arch_address_needs_mapping.  I assume that was needed because 
> >>>> powerpc needs non-trivial implementations for those functions.
> >>>>     
> >>>>         
> >>> Hmm, what she added are wrappers of virt_to_bus and bus_to_virt. We
> >>> can remove these and directly use virt_to_bus and bus_to_virt.
> >>>   
> >>>       
> >> In general those interfaces are deprecated.  Are we un-deprecating 
> >> them?  Or do you mean adding virt<->bus to dma_ops?
> >>     
> >
> > Hmm, these interfaces are wrong for drivers surely because they can't
> > handle dma mapping properly. However, they are exactly what swiotlb
> > needs (swiotlb doesn't need to care about dma mapping).
> 
> It needs to care about the mapping from phys to bus.  On x86 they're 
> identical, but on powerpc there can be at least an offset between them.
> 
> >  Until 2.6.28,
> > swiotlb has used them. They are with IA64, X86_64 and PPC_32, I think.
> >   
> 
> Well, Becky's patches also added the hwdev argument to them, so 
> presumably the powerpc implementation needs that (different 
> devices/buses have differing views of physical memory, I guess).

Until I see the ppc specific swiotlb patchset, I'm not sure but I
think that we can remove phys_to_bus in swiotlb.

Even if we need phys_to_bus, we can remove the rest of __weak tricks
for only dom0. And we can make phys_to_bus arch-specific. Then we
don't need any __weak tricks in swiotlb (and x86's swiotlb). dom0
support adds many hacks to swiotlb.


> > I'm not sure what you mean. And I don't think ppc wants swiotlb_alloc.
> >   
> 
> No, its something we need for Xen.  I was thinking that swiotlb could 
> allocate its memory with dma_alloc_coherent(NULL, size, ...).  That 
> would allocate via x86_fallback_device, which would not have the right 
> behaviour (it would set GFP_DMA, for a start), and would end up hitting 
> the uninitialized dma_ops.  So the idea doesn't really work; it would 
> need swiotlb to define another placeholder  device who's alloc_coherent 
> operation could be overridden, and it all gets pretty ugly.

It doesn't work. And swiotlb's alloc_coherent needs to be
arch-specific because the page allocator can't handle dma mask.


> As an aside, I'm also wondering why there's a distinction between 
> swiotlb_alloc() and swiotlb_alloc_boot().  The latter allocates from 
> bootmem, but I don't see what's wrong with allocating from slab a little 
> bit later, once it has been initialized.  The comment mentions something 
> about allocating ISA DMA memory, but the code doesn't make any attempt 
> to allocate the buffer below 16MB (its generally much larger than 16MB 
> anyway).

Yeah, ISA DMA comment is misleading. swiotlb can't handle it. And it
doesn't need to handle it because the block layer can thanks to
the bouncing (the network layer does the similar, I think).

As you said, we could remove the latter though I'm not sure.
