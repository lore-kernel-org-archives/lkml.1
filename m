Return-Path: <linux-kernel-owner+w=401wt.eu-S1754789AbZESPdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789AbZESPdR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 11:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753176AbZESPdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 11:33:09 -0400
Received: from sh.osrg.net ([192.16.179.4]:36842 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753059AbZESPdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 11:33:08 -0400
Date: Wed, 20 May 2009 00:30:17 +0900
To: mingo@elte.hu
Cc: fujita.tomonori@lab.ntt.co.jp, jeremy@goop.org, x86@kernel.org,
       linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       gregkh@suse.de, okir@suse.de
Subject: Re: Where do we stand with the Xen patches?
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090519130300.GB6238@elte.hu>
References: <20090518084052.GD10687@elte.hu>
	<20090519142626X.fujita.tomonori@lab.ntt.co.jp>
	<20090519130300.GB6238@elte.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090520002955R.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 20 May 2009 00:30:17 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 May 2009 15:03:00 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> > If we really need to merge dom0 support, then dom0 should have the 
> > own IOMMU implementation instead of adding any hacks to swiotlb 
> > (as I said long time ago). Yeah, there might be some duplication 
> > between swiotlb and the Xen IOMMU but IMO it's better to have 
> > clean code with some duplication rather than ugly unified code; 
> > unification makes sense only if we do cleanly.
> 
> Well, but since we merged PowerPC highmem support ... the precedent 
> is there already that the swiotlb code can be librarized and 
> generalized some more, right?

No,

The highmem support is ok for me (I was against the initial highmem
patchset but Becky's highmem patchset was much cleaner and we merged
it).

Due to dom0 support, we can't use architecture abstraction (such as
arch/include/asm/):

http://marc.info/?l=linux-kernel&m=124271086910299&w=2


We also need hacks for memory allocation due to dom0 support.


> What is the fundamental difference between a DMA32 device on native 
> hardware using lib/swiotlb.c to bounce IO directed to/from a high 
> address over buffers in a low, DMA-capable address, and between a 
> Xen Dom0 instance using the same functionality to DMA buffers?
> 
> The payback is significant: Linux drivers can be used basically 
> as-is (as far as their DMA functionality goes) in a Xen dom0 guest.
> 
> There's really just two non-standard Xen features compared to the 
> PowerPC-highmem use:
> 
>  - special allocation
> 
>  - non-standard virtual/physical/bus memory translations
> 
> The latter is understandable - Xen cannot do the (mostly-) linear 
> transformations that (most) platforms can do in their address 
> transformation primitives. But other than the non-linearity, it's a 
> "mapping" just as much.
> 
> The special allocator is arguably a bit of a hack - Xen should 
> _probably_ recognize GFP_DMA32 allocations at the page allocator 
> level and rearrange buffers there.
> 
> So realizing that dom0 _has_ to have guest OS help here, the best 
> possible design seems to be to minimalize the Xen cross section to 
> Linux, while still keeping it fast enough. And that seems to be 
> these two straightforward hooks: 'ready buffers for DMA' and 'map 
> addresses'. As long as we'll want to have swiotlb code in the 
> kernel, we'll deal with such primitives anyway - so there doesnt 
> seem to be a significant mainteinance drag here.

We need these hooks but as I wrote above, they are
architecture-specific and we should handle them with the architecture
abstraction (as we handle similar problems) however we can't due to
dom0 support.
