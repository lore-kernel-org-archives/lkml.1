Return-Path: <linux-kernel-owner+w=401wt.eu-S1757215AbYISAkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215AbYISAkR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 20:40:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755981AbYISAkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 20:40:04 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51485 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755788AbYISAkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 20:40:03 -0400
Date: Fri, 19 Sep 2008 02:44:31 +0200
From: Andi Kleen <andi@firstfloor.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: andi@firstfloor.org, mingo@elte.hu, joerg.roedel@amd.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] fix GART to respect device's dma_mask about virtual mappings
Message-ID: <20080919004431.GS25711@one.firstfloor.org>
References: <20080917002404.GG25711@one.firstfloor.org> <20080918035726F.fujita.tomonori@lab.ntt.co.jp> <20080918182029.GO25711@one.firstfloor.org> <20080919071534C.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080919071534C.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2008 at 07:15:59AM +0900, FUJITA Tomonori wrote:
> On Thu, 18 Sep 2008 20:20:29 +0200
> Andi Kleen <andi@firstfloor.org> wrote:
> 
> > > The falling back mechanism was moved to pci-nommu from the common code
> > > since it doesn't work for other IOMMUs that always need virtual
> > 
> > There's no fallback for _map_sg/_map_single. All the fallback to GFP
> > only works for coherent allocations, but not for streaming mappings.
> 
> Yeah, so the falling back mechanism was moved to pci-nommu's
> alloc_coherent.

Sure, but that doesn't help for map_single/map_sg. The two cases are
quite different.

> > To make this "fully robust" for masks < 32bit you would need to implement 
> > a new swiotlb that uses GFP_DMA allocations as fallback (or use the DMA 
> > allocator's swiotlb which can actually handle this)
> 
> Do you mean if GART's alloc_coherent can't find a virtual address that
> a device can access to, it should try GFP_DMA allocations as fallback?

It used to at least, that is how I wrote it. That is it did all GFP_DMA,
GFP_DMA32, swiotlb, ZONE_NORMAL based on a fallback scheme.



> 
> GART could but why GART should do? If full IOMMUs' alloc_coherent

The GART is somewhere in the 4GB range so you cannot use it to 
map anything < 4GB.

Also GART is pretty small (and it's not a isolating) IOMMU so 
if you can get direct memory allocation that fits you should 
definitely do that.


> can't find a virtual address that a device can access to, it's
> failure. No fallback is for them. Why can't GART use the same logic?

GART uses the same logic, but only for alloc_cohernet, not for
 map_sg/map_single and masks < 4GB.

> Yeah, GART is not a full IOMMU, so it can have a fallback for this
> case. But why can't GART work in the same way other IOMMUs?

Because GART cannot remap to addresses < 4GB reliably.

The big difference to the other IOMMUs is that it's only a tiny memory
hole somewhere near the 4GB boundary, not a full remapper of the full 
4GB space.


> 
> > So you're right now basically checking for something that you cannot
> > fix. And also you try to check for (but not handle) something that even 
> > 32bit x86 doesn't handle. So if some driver relied on you checking
> > for it on 64bit it wouldn't work on 32bit x86 which would be a bad 
> > thing.
> 
> What does '32bit x86 doesn't handle' mean? pci-nommu's alloc_coherent
> can handle < 32bit bit mask in the fallback path.

Yes it does, just map_sg/map_single doesn't.  And your patch changed
that in GART and that is what I objected too.

> 
> Or you are talking about '_map_sg/_map_single'? If so, as we
> discussed, < 32bit bit mask can be handled in else where. The patch

I don't hink it can, unless you want to write another swiotlb using
GFP_DMA (or use the dma allocator). That is because the swiotlb
has the same limitation as GART. It cannot reliably remap to < 4GB.

-Andi
