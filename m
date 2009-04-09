Return-Path: <linux-kernel-owner+w=401wt.eu-S934234AbZDIToz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934234AbZDIToz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 15:44:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758221AbZDIToo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 15:44:44 -0400
Received: from sh.osrg.net ([192.16.179.4]:52091 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758144AbZDIToo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 15:44:44 -0400
Date: Fri, 10 Apr 2009 04:43:55 +0900
To: jeremy@goop.org
Cc: fujita.tomonori@lab.ntt.co.jp, galak@kernel.crashing.org,
       hch@infradead.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       ian.campbell@citrix.com, beckyb@kernel.crashing.org
Subject: Re: [PATCH 4/7] swiotlb: Allow arch override of
 address_needs_mapping
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <49DE4A37.3080702@goop.org>
References: <49DD3C9C.7060101@goop.org>
	<20090410033357S.fujita.tomonori@lab.ntt.co.jp>
	<49DE4A37.3080702@goop.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090410044403M.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 10 Apr 2009 04:43:56 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 09 Apr 2009 12:19:19 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> FUJITA Tomonori wrote:
> >> Well, Becky's patches also added the hwdev argument to them, so 
> >> presumably the powerpc implementation needs that (different 
> >> devices/buses have differing views of physical memory, I guess).
> >>     
> >
> > Until I see the ppc specific swiotlb patchset, I'm not sure but I
> > think that we can remove phys_to_bus in swiotlb.
> >   
> 
> Kumar's comment was: "For our SoC chips we don't need any mapping 
> between phys & bus.  However something like PCI does have a mapping (a 
> simple offset)."

I meant that swiotlb doesn't need to use phys_to_bus stuff. But I as
said, I'm not sure until I see the ppc swiotlb code.


> Kumar, could a single system have different phys<->bus mappings on a 
> single system, or could it differ from device to device (or bus to bus)?
> 
> > Even if we need phys_to_bus, we can remove the rest of __weak tricks
> > for only dom0. And we can make phys_to_bus arch-specific. Then we
> > don't need any __weak tricks in swiotlb (and x86's swiotlb). dom0
> > support adds many hacks to swiotlb.
> >   
> 
> Well, we'd still need a way to do hook the swiotlb_alloc(_boot) 
> allocation.  At the moment its effectively arch-specific because x86 
> only uses swiotlb_alloc_boot(), and ia64 only uses swiotlb_alloc().  One 
> option would be to simply make that function arch-defined, which would 
> remove the need for any kind of override mechanism in lib/swiotlb; that 
> would match the handling of phys_to_bus.  And its more appealing if we 
> manage to drop swiotlb_alloc_boot, so there's only a single function for 
> the arches to worry about.
> 
> > Yeah, ISA DMA comment is misleading. swiotlb can't handle it. And it
> > doesn't need to handle it because the block layer can thanks to
> > the bouncing (the network layer does the similar, I think).
> >
> > As you said, we could remove the latter though I'm not sure.
> >   
> 
> It would take a bit of rearranging the x86 swiotlb/iommu init sequence, 
> but I don't think it would be too complex.  I'll look into it.

Unfortunately, not that simple. IA64_64 and x86 share the iommu init
sequence. So you need to look at both. I put some cleanups on it in
30-rc1. But I need to do more cleanups.



