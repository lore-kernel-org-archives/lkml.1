Return-Path: <linux-kernel-owner+w=401wt.eu-S1753447AbYIVTNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447AbYIVTNT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 15:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750899AbYIVTNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 15:13:09 -0400
Received: from sh.osrg.net ([192.16.179.4]:35134 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794AbYIVTNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 15:13:08 -0400
Date: Tue, 23 Sep 2008 04:12:33 +0900
To: andi@firstfloor.org
Cc: fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu, joerg.roedel@amd.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] fix GART to respect device's dma_mask about
 virtual mappings
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080919004431.GS25711@one.firstfloor.org>
References: <20080918182029.GO25711@one.firstfloor.org>
	<20080919071534C.fujita.tomonori@lab.ntt.co.jp>
	<20080919004431.GS25711@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080923041203Q.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Sep 2008 02:44:31 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> On Fri, Sep 19, 2008 at 07:15:59AM +0900, FUJITA Tomonori wrote:
> > On Thu, 18 Sep 2008 20:20:29 +0200
> > Andi Kleen <andi@firstfloor.org> wrote:
> > 
> > > > The falling back mechanism was moved to pci-nommu from the common code
> > > > since it doesn't work for other IOMMUs that always need virtual
> > > 
> > > There's no fallback for _map_sg/_map_single. All the fallback to GFP
> > > only works for coherent allocations, but not for streaming mappings.
> > 
> > Yeah, so the falling back mechanism was moved to pci-nommu's
> > alloc_coherent.
> 
> Sure, but that doesn't help for map_single/map_sg. The two cases are
> quite different.

Sure, I have no intention to mix two cases.


> > > To make this "fully robust" for masks < 32bit you would need to implement 
> > > a new swiotlb that uses GFP_DMA allocations as fallback (or use the DMA 
> > > allocator's swiotlb which can actually handle this)
> > 
> > Do you mean if GART's alloc_coherent can't find a virtual address that
> > a device can access to, it should try GFP_DMA allocations as fallback?
> 
> It used to at least, that is how I wrote it. That is it did all GFP_DMA,
> GFP_DMA32, swiotlb, ZONE_NORMAL based on a fallback scheme.

Ok, after you told me that GART cannot remap to addresses < 4GB
reliably, I understand that GART's alloc_coherent needs to work in the
old way.

I'll take care of it. Well, I need to take care of SWIOTLB about this
issue, I guess.


> > GART could but why GART should do? If full IOMMUs' alloc_coherent
> 
> The GART is somewhere in the 4GB range so you cannot use it to 
> map anything < 4GB.
> 
> Also GART is pretty small (and it's not a isolating) IOMMU so 
> if you can get direct memory allocation that fits you should 
> definitely do that.
> 
> 
> > can't find a virtual address that a device can access to, it's
> > failure. No fallback is for them. Why can't GART use the same logic?
> 
> GART uses the same logic, but only for alloc_cohernet, not for
>  map_sg/map_single and masks < 4GB.
> 
> > Yeah, GART is not a full IOMMU, so it can have a fallback for this
> > case. But why can't GART work in the same way other IOMMUs?
> 
> Because GART cannot remap to addresses < 4GB reliably.
> 
> The big difference to the other IOMMUs is that it's only a tiny memory
> hole somewhere near the 4GB boundary, not a full remapper of the full 
> 4GB space.
> 
> 
> > 
> > > So you're right now basically checking for something that you cannot
> > > fix. And also you try to check for (but not handle) something that even 
> > > 32bit x86 doesn't handle. So if some driver relied on you checking
> > > for it on 64bit it wouldn't work on 32bit x86 which would be a bad 
> > > thing.
> > 
> > What does '32bit x86 doesn't handle' mean? pci-nommu's alloc_coherent
> > can handle < 32bit bit mask in the fallback path.
> 
> Yes it does, just map_sg/map_single doesn't.  And your patch changed
> that in GART and that is what I objected too.

Sure, pci-nommu's map_sg/map_single doesn't handle it. But we handle
this issue somewhere else (like b44 keeps own DMA buffer)?

If I understand your logic correctly,

1. not all map_sg/map_single (e.g. pci-nommu) can't handle it.
2. we already have workarounds for it somewhere else so
map_sg/map_single don't need to handle it.
3. I changed GART map_sg/map_signle to handle it. I thought if it
can handle it, for example, b44 doesn't go the workaround path. It
would be a good thing.
4. But GART cannot remap to addresses < 4GB reliably, so my above
argument doesn't always work.
5. Then my patch doesn't break anything but it's almost meaningless.


Again GART cannot remap to addresses < 4GB reliably, then I have to
say that I agree with you.


> > Or you are talking about '_map_sg/_map_single'? If so, as we
> > discussed, < 32bit bit mask can be handled in else where. The patch
> 
> I don't hink it can, unless you want to write another swiotlb using
> GFP_DMA (or use the dma allocator). That is because the swiotlb
> has the same limitation as GART. It cannot reliably remap to < 4GB.

As I wrote above, 'else where' meant to something like b44's own DMA
hack.
