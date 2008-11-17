Return-Path: <linux-kernel-owner+w=401wt.eu-S1754957AbYKQJZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957AbYKQJZp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 04:25:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752391AbYKQJZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 04:25:36 -0500
Received: from sh.osrg.net ([192.16.179.4]:53077 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752290AbYKQJZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 04:25:35 -0500
Date: Mon, 17 Nov 2008 18:25:11 +0900
To: mingo@elte.hu
Cc: fujita.tomonori@lab.ntt.co.jp, tony.luck@intel.com,
       linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
       joerg.roedel@amd.com, akpm@linux-foundation.org
Subject: Re: [PATCH] swiotlb: use coherent_dma_mask in alloc_coherent
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20081117090259.GF28786@elte.hu>
References: <20081117081526.GA24603@elte.hu>
	<20081117174828U.fujita.tomonori@lab.ntt.co.jp>
	<20081117090259.GF28786@elte.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081117182545G.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Nov 2008 10:02:59 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> 
> > On Mon, 17 Nov 2008 09:15:26 +0100
> > Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > 
> > > * FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> > > 
> > > > This patch fixes swiotlb to use dev->coherent_dma_mask in 
> > > > alloc_coherent. Currently, swiotlb uses dev->dma_mask in 
> > > > alloc_coherent but alloc_coherent is supposed to use 
> > > > coherent_dma_mask. It could break drivers that uses smaller 
> > > > coherent_dma_mask than dma_mask (though the current code works for 
> > > > the majority that use the same mask for coherent_dma_mask and 
> > > > dma_mask).
> > > > 
> > > > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > > > ---
> > > >  lib/swiotlb.c |   10 +++++++---
> > > >  1 files changed, 7 insertions(+), 3 deletions(-)
> > > 
> > > Applied it with the changelog below to tip/core/urgent, thanks!
> > > 
> > > I also flagged it for v2.6.28 inclusion. This bug was caused by the 
> > > removal of the GFP_DMA hack in swiotlb_alloc_coherent() in this cycle. 
> > > I havent seen it actually reported anywhere - have you perhaps?Or have 
> > > you found this via code review?
> > 
> > This wasn't introduced by the removal of the GFP_DMA hack. It has 
> > been for ages, I think.
> 
> Yeah, what i mean is that our GFP_DMA hack (which we indeed had for 
> years) definitely _hid_ the problem: on x86 for example it limits 
> coherent DMA buffers into the DMA zone: the first 16 MB of RAM.

Ah, I see. I misunderstood what you meant.


> ( Other platforms are pretty narrow about GFP_DMA too - it implies at 
>   least DMA32 which is in practice often the real limit for 
>   cache-coherent DMA addresses. )
> 
> So the removal of GFP_DMA flag from coherent allocations exposed us to 
> this long-standing (but hidden) problem.

Yes, you are right. But it's pretty hard to hit this bug since x86_64
rarely uses swiotlb_alloc_coherent. pci-swiotlb_64.c tries
dma_generic_alloc_coherent first and then, only if it fails, it uses
swiotlb_alloc_coherent. dma_generic_alloc_coherent usually succeeds.

Before removing the GFP_DMA hack (the dma_alloc_coherent rewrite),
x86_64 rarely used swiotlb_alloc_coherent too because
swiotlb_alloc_coherent was used only if dma_alloc_coherent fails.
This issue was hidden by dma_alloc_coherent and GFP_DMA hack.
