Return-Path: <linux-kernel-owner+w=401wt.eu-S1756489AbYKQIsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489AbYKQIsv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 03:48:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752721AbYKQIsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 03:48:41 -0500
Received: from sh.osrg.net ([192.16.179.4]:42415 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752697AbYKQIsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 03:48:40 -0500
Date: Mon, 17 Nov 2008 17:47:51 +0900
To: mingo@elte.hu
Cc: fujita.tomonori@lab.ntt.co.jp, tony.luck@intel.com,
       linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
       joerg.roedel@amd.com, akpm@linux-foundation.org
Subject: Re: [PATCH] swiotlb: use coherent_dma_mask in alloc_coherent
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20081117081526.GA24603@elte.hu>
References: <20081117162445C.fujita.tomonori@lab.ntt.co.jp>
	<20081117081526.GA24603@elte.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081117174828U.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Nov 2008 09:15:26 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> 
> > This patch fixes swiotlb to use dev->coherent_dma_mask in 
> > alloc_coherent. Currently, swiotlb uses dev->dma_mask in 
> > alloc_coherent but alloc_coherent is supposed to use 
> > coherent_dma_mask. It could break drivers that uses smaller 
> > coherent_dma_mask than dma_mask (though the current code works for 
> > the majority that use the same mask for coherent_dma_mask and 
> > dma_mask).
> > 
> > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > ---
> >  lib/swiotlb.c |   10 +++++++---
> >  1 files changed, 7 insertions(+), 3 deletions(-)
> 
> Applied it with the changelog below to tip/core/urgent, thanks!
> 
> I also flagged it for v2.6.28 inclusion. This bug was caused by the 
> removal of the GFP_DMA hack in swiotlb_alloc_coherent() in this cycle. 
> I havent seen it actually reported anywhere - have you perhaps?Or have 
> you found this via code review?

This wasn't introduced by the removal of the GFP_DMA hack. It has been
for ages, I think.

I knew this issue but I thought that it's harmless and let it
alone. But Grant Grundler said that there are some devices are
troubled by this:

http://marc.info/?l=linux-kernel&m=122379585203173&w=2

I fixed VT-d about this (bb9e6d65078da2f38cfe1067cfd31a896ca867c0) but
somehow I forgot about swiotlb.

I think that it would be fine to push this to 2.6.29 since seems that
nobody hits this. But it's also fine to push it for 2.6.28 since it's
theoretically a bug fix and pretty trivial.


> Do we know roughly the range of devices/systems where there's a real 
> address range that cannot be DMA-ed to coherently, and an estimation 
> about how frequently they would be affected by this bug?

I think that if a driver hits this bug, it's likely that an user sees
kinda data corruption right after loading the driver.
