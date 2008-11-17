Return-Path: <linux-kernel-owner+w=401wt.eu-S1756137AbYKQJDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137AbYKQJDg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 04:03:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752619AbYKQJDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 04:03:18 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51590 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752349AbYKQJDQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 04:03:16 -0500
Date: Mon, 17 Nov 2008 10:02:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: tony.luck@intel.com, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org, joerg.roedel@amd.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH] swiotlb: use coherent_dma_mask in alloc_coherent
Message-ID: <20081117090259.GF28786@elte.hu>
References: <20081117162445C.fujita.tomonori@lab.ntt.co.jp> <20081117081526.GA24603@elte.hu> <20081117174828U.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081117174828U.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> On Mon, 17 Nov 2008 09:15:26 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> > 
> > > This patch fixes swiotlb to use dev->coherent_dma_mask in 
> > > alloc_coherent. Currently, swiotlb uses dev->dma_mask in 
> > > alloc_coherent but alloc_coherent is supposed to use 
> > > coherent_dma_mask. It could break drivers that uses smaller 
> > > coherent_dma_mask than dma_mask (though the current code works for 
> > > the majority that use the same mask for coherent_dma_mask and 
> > > dma_mask).
> > > 
> > > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > > ---
> > >  lib/swiotlb.c |   10 +++++++---
> > >  1 files changed, 7 insertions(+), 3 deletions(-)
> > 
> > Applied it with the changelog below to tip/core/urgent, thanks!
> > 
> > I also flagged it for v2.6.28 inclusion. This bug was caused by the 
> > removal of the GFP_DMA hack in swiotlb_alloc_coherent() in this cycle. 
> > I havent seen it actually reported anywhere - have you perhaps?Or have 
> > you found this via code review?
> 
> This wasn't introduced by the removal of the GFP_DMA hack. It has 
> been for ages, I think.

Yeah, what i mean is that our GFP_DMA hack (which we indeed had for 
years) definitely _hid_ the problem: on x86 for example it limits 
coherent DMA buffers into the DMA zone: the first 16 MB of RAM.

( Other platforms are pretty narrow about GFP_DMA too - it implies at 
  least DMA32 which is in practice often the real limit for 
  cache-coherent DMA addresses. )

So the removal of GFP_DMA flag from coherent allocations exposed us to 
this long-standing (but hidden) problem.

( And it doesnt matter that the underlying problem has been there for
  years - what matters to regression engineering is how users are
  affected by changes. )

It's nice that you noticed and fixed it, and please be on the watchout 
for such patterns in the future too and try to move fixes to the 
urgent track in such cases. Had we missed the scope of this we could 
have released v2.6.28 with a data corruptor bug on certain 
devices/systems.

> I knew this issue but I thought that it's harmless and let it alone. 
> But Grant Grundler said that there are some devices are troubled by 
> this:
> 
> http://marc.info/?l=linux-kernel&m=122379585203173&w=2

ok, so it can affect real devices, as suspected.

> I fixed VT-d about this (bb9e6d65078da2f38cfe1067cfd31a896ca867c0) 
> but somehow I forgot about swiotlb.
> 
> I think that it would be fine to push this to 2.6.29 since seems 
> that nobody hits this. But it's also fine to push it for 2.6.28 
> since it's theoretically a bug fix and pretty trivial.
>
> > Do we know roughly the range of devices/systems where there's a 
> > real address range that cannot be DMA-ed to coherently, and an 
> > estimation about how frequently they would be affected by this 
> > bug?
> 
> I think that if a driver hits this bug, it's likely that an user 
> sees kinda data corruption right after loading the driver.

Correct - hence definitely .28 material. We'd try to fix such a bug in 
.28 even if it was a much more complex fix - or we'd have reverted the 
original change that exposed the problem.

	Ingo
