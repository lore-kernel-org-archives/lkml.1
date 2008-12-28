Return-Path: <linux-kernel-owner+w=401wt.eu-S1754766AbYL1LA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbYL1LA7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 06:00:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753584AbYL1LAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 06:00:50 -0500
Received: from sh.osrg.net ([192.16.179.4]:53820 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753568AbYL1LAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 06:00:50 -0500
Date: Sun, 28 Dec 2008 20:00:12 +0900
To: mingo@elte.hu
Cc: fujita.tomonori@lab.ntt.co.jp, jeremy@goop.org, tony.luck@intel.com,
       linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       x86@kernel.org, ian.campbell@citrix.com, beckyb@kernel.crashing.org,
       joerg.roedel@amd.com
Subject: Re: [PATCH 0 of 9] swiotlb: use phys_addr_t for pages
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20081228103419.GA7128@elte.hu>
References: <20081228093751.GC9022@elte.hu>
	<20081228190111H.fujita.tomonori@lab.ntt.co.jp>
	<20081228103419.GA7128@elte.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081228195952F.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Dec 2008 11:34:19 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> 
> > > Note that the main complication wasnt even the small variations in 
> > > signatures, but the different _semantics_: one dma_mapping_ops 
> > > implementation passed in kernel-virtual addresses, the other physical 
> > > addresses. Unifying that was invasive and non-trivial, and it can 
> > > break
> > 
> > I guess that you are talking about the dma_map_single difference between 
> > x86_32 and x86_64. As far as I know, Only x64_64 uses physical address 
> > with dma_map_single.
> 
> yes - dma_map_single() has this signature:
> 
>  static inline dma_addr_t
>  dma_map_single(struct device *hwdev, void *ptr, size_t size, int direction)
> 
> on x86 dma_mapping_ops.map_single has this signature:
> 
>         dma_addr_t      (*map_single)(struct device *hwdev, phys_addr_t ptr,
>                                 size_t size, int direction);
> 
> ia64 and powerpc uses kernel-virt addresses for map_single(). So there's 
> material semantic differences between the dma_mapping_ops implementations.

I know. And as I wrote, as far as I know, only x86 use physical
addresses with map_single.

I think except for x86, all other archs use cpu addresses because we
define dma_map_single() in the following way:

dma_addr_t
dma_map_single(struct device *dev, void *cpu_addr, size_t size,
			           enum dma_data_direction direction)


> > > stuff not at the build level but at the runtime level. We can expect 
> > > similar complications when done over 20 architectures as well.
> > 
> > We don't need to touch 20 architectures. We are talking about unifying 
> > dma_mapping_ops. Only architectures that need to handle multiple dma 
> > mapping operations use the dma_mapping_ops scheme; X86, IA64, POWERPC, 
> > SPARC, and PARISC. Unifying X86, IA64 and POWERPC is a must since they 
> > actually share dma_mapping_ops.
> 
> if it's just dma_mapping_ops - then it's those 3 architectures. But 

Well, there are 5 architectures at least, as I wrote.


> there's no reason why the various DMA bouncing implementations in other 
> architectures couldnt use the common code - for example couldnt 
> arch/arm/common/dmabounce.c use the swiotlb too?

Well, it's a different issue. I and hch are talking about
dma_mapping_ops unification. 

You brought up a different topic, DMA bouncing implementations
unification. DMA bouncing implementations unification is a very nice
cleanup. But it's not related with Becky's patch to break IA64 build
at all.


> > > But yes, it's all desired. Obviously extending swiotlb to highmem and 
> > > using it on xen and powerpc is an essential first step in the 
> > > direction of generalizing all this code.
> > 
> > No, it's not about swiotlb highmem patchset.
> > 
> > Due to this problem, IA64 and X86_64 share swiotlb in a very hacky way. 
> > We added more hacky code due to this problem again when we added VT-d 
> > support to IA64.
> > 
> > This problem has been for long time. We added ugly hacks again and again 
> > instead of fixing the root cause.
> 
> well the swiotlb highmem patches are what enable xen (and now powerpc too) 
> to make full use of the swiotlb dma bouncing facilities. And that gives a 
> common platform for unifying all the rest of the lowlevel DMA mapping APIs 
> as well.
> 
> Without that, the swiotlb code is limited, life is going on in separate 
> islands, with everyone doing their own private variations and hacks. We 
> would still probably be nowhere with this had Jeremy not sent the highmem 
> patches.

Again, you are talking about a different issue, which is not related
with Becky's patch to break IA64 build.

As I wrote, Becky's patch is a workaround for the problem that has
been for long time. It's not just about swiotlb.
