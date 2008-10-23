Return-Path: <linux-kernel-owner+w=401wt.eu-S1758373AbYJWChQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758373AbYJWChQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 22:37:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758085AbYJWCgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 22:36:46 -0400
Received: from sh.osrg.net ([192.16.179.4]:33167 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758030AbYJWCgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 22:36:45 -0400
Date: Thu, 23 Oct 2008 11:36:20 +0900
To: tiwai@suse.de
Cc: fujita.tomonori@lab.ntt.co.jp, svens@stackframe.org, joerg.roedel@amd.com,
       mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: swiotlb_alloc_coherent: allocated memory is out of range for
 device
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <s5hfxmon4aj.wl%tiwai@suse.de>
References: <s5hmygwn89z.wl%tiwai@suse.de>
	<20081022221321J.fujita.tomonori@lab.ntt.co.jp>
	<s5hfxmon4aj.wl%tiwai@suse.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081023113618T.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2008 15:32:52 +0200
Takashi Iwai <tiwai@suse.de> wrote:

> > About the bug that you hit, I suspect that dma_map_coherent() in
> > asm-x86/dma-mapping.h doesn't set gfp flags correctly.
> > 
> > dma_map_coherent() calls swiotlb_alloc_coherent with the flags GFP_DMA
> > set? parport driver set dev->coherent_dma_mask properly?
> 
> The parport driver itself passes always GFP_KERNEL.  So I added
> GFP_DMA in my initial patch as a workaround.

Hmm, have you actually tried your patch?

dma_alloc_coherent clears the gfp zone flags that the callers pass. So
even if a driver passes GFP_DMA, swiotlb_alloc_coherent doesn't get
GFP_DMA. So I'm not sure how your patch fixes the parport problem.


The current dma_alloc_coherent (asm-x86/dma-mapping.h) handles the gfp
flags in the exact same way as the old dma_alloc_coherent
(pci-dma.c). Neither sets GFP_DMA even if coherent_dma_mask is
24bits. The old code is fine because of the GFP_DMA retry
mechanism. But if coherent_dma_mask is 24bits, there is no point to go
into the GFP_DMA retry mechanism. We should use GFP_DMA in the first
place.

How about the following patch?


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
