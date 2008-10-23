Return-Path: <linux-kernel-owner+w=401wt.eu-S1754399AbYJWLri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399AbYJWLri (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 07:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbYJWLra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 07:47:30 -0400
Received: from sh.osrg.net ([192.16.179.4]:58138 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785AbYJWLr3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 07:47:29 -0400
Date: Thu, 23 Oct 2008 20:46:55 +0900
To: mingo@elte.hu
Cc: tiwai@suse.de, fujita.tomonori@lab.ntt.co.jp, svens@stackframe.org,
       joerg.roedel@amd.com, linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: swiotlb_alloc_coherent: allocated memory is out of range for
	device
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20081023101557.GA30302@elte.hu>
References: <s5h63nj51j2.wl%tiwai@suse.de>
	<s5hfxmnjzg5.wl%tiwai@suse.de>
	<20081023101557.GA30302@elte.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081023204706X.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Oct 2008 12:15:57 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Takashi Iwai <tiwai@suse.de> wrote:
> 
> > At Thu, 23 Oct 2008 07:22:09 +0200,
> > I wrote:
> > > 
> > > > The current dma_alloc_coherent (asm-x86/dma-mapping.h) handles the gfp
> > > > flags in the exact same way as the old dma_alloc_coherent
> > > > (pci-dma.c). Neither sets GFP_DMA even if coherent_dma_mask is
> > > > 24bits. The old code is fine because of the GFP_DMA retry
> > > > mechanism. But if coherent_dma_mask is 24bits, there is no point to go
> > > > into the GFP_DMA retry mechanism. We should use GFP_DMA in the first
> > > > place.
> > > > 
> > > > How about the following patch?
> > > 
> > > I'll give it a try later (the machine is in my office).
> > 
> > The patch seems working fine.  Thanks!
> > 
> > Tested-by: Takashi Iwai <tiwai@suse.de>
> 
> thanks guys - i've queued it up in tip/core/urgent and will send a pull 
> request to Linus later today.

Thanks, I can't find the commit right now so I'm not sure if you need
the patch description but anyway, here's a sane format of the patch.

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] x86: use GFP_DMA for 24bit coherent_dma_mask

dma_alloc_coherent (include/asm-x86/dma-mapping.h) avoids GFP_DMA
allocation first and if the allocated address is not fit for the
device's coherent_dma_mask, then dma_alloc_coherent does GFP_DMA
allocation. This is because dma_alloc_coherent avoids precious GFP_DMA
zone if possible. This is also how the old dma_alloc_coherent
(arch/x86/kernel/pci-dma.c) works.

However, if the coherent_dma_mask of a device is 24bit, there is no
point to go into the above GFP_DMA retry mechanism. We had better use
GFP_DMA in the first place.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Tested-by: Takashi Iwai <tiwai@suse.de>
---
 include/asm-x86/dma-mapping.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/include/asm-x86/dma-mapping.h b/include/asm-x86/dma-mapping.h
index 219c33d..05fcec5 100644
--- a/include/asm-x86/dma-mapping.h
+++ b/include/asm-x86/dma-mapping.h
@@ -255,9 +255,11 @@ static inline unsigned long dma_alloc_coherent_mask(struct device *dev,
 
 static inline gfp_t dma_alloc_coherent_gfp_flags(struct device *dev, gfp_t gfp)
 {
-#ifdef CONFIG_X86_64
 	unsigned long dma_mask = dma_alloc_coherent_mask(dev, gfp);
 
+	if (dma_mask <= DMA_24BIT_MASK)
+		gfp |= GFP_DMA;
+#ifdef CONFIG_X86_64
 	if (dma_mask <= DMA_32BIT_MASK && !(gfp & GFP_DMA))
 		gfp |= GFP_DMA32;
 #endif
-- 
1.5.5.GIT

