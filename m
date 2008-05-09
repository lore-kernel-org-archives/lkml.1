Return-Path: <linux-kernel-owner+w=401wt.eu-S1756466AbYEII6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756466AbYEII6u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 04:58:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752449AbYEII6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 04:58:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46680 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752262AbYEII6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 04:58:40 -0400
Date: Fri, 9 May 2008 10:58:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Takashi Iwai <tiwai@suse.de>
Cc: Rene Herman <rene.herman@keyaccess.nl>, Glauber Costa <gcosta@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Pete Clements <clem@clem.clem-digital.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       ALSA devel <alsa-devel@alsa-project.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: 2.6.26-rc1 regression: ISA DMA broken (bisected)
Message-ID: <20080509085824.GF2592@elte.hu>
References: <4823AAF2.7070102@keyaccess.nl> <s5hzlr0105c.wl%tiwai@suse.de> <20080509085511.GE2592@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080509085511.GE2592@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> good catch! Queued it up for testing. Jesse, do you concur?

here's the patch below, tidied up.

	Ingo

------------------------------->
Subject: x86/pci: fix broken ISA DMA
From: Takashi Iwai <tiwai@suse.de>
Date: Fri, 09 May 2008 08:06:55 +0200

Rene Herman reported:

> commit 8779f2fc3b84ebb6c5181fb13d702e9944c16069
>
> "x86: don't try to allocate from DMA zone at first"
>
> breaks all of ISA DMA. Or all of ALSA ISA DMA at least. All
> ISA soundcards are silent following that commit -- no error
> messages, everything appears fine, just silence.

That patch is buggy. We had an implicit assumption that
dev = NULL for ISA devices that require 24bit DMA.

The recent work on x86 dma_alloc_coherent() breaks the ISA DMA buffer
allocation, which is represented by "dev = NULL" and requires 24bit
DMA implicitly.

Bisected-by: Rene Herman <rene.herman@keyaccess.nl>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/pci-dma.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

Index: linux-x86.q/arch/x86/kernel/pci-dma.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/pci-dma.c
+++ linux-x86.q/arch/x86/kernel/pci-dma.c
@@ -386,11 +386,13 @@ dma_alloc_coherent(struct device *dev, s
 	if (dma_alloc_from_coherent_mem(dev, size, dma_handle, &memory))
 		return memory;
 
-	if (!dev)
+	if (!dev) {
 		dev = &fallback_dev;
+		gfp |= GFP_DMA;
+	}
 	dma_mask = dev->coherent_dma_mask;
 	if (dma_mask == 0)
-		dma_mask = DMA_32BIT_MASK;
+		dma_mask = (gfp & GFP_DMA) ? DMA_24BIT_MASK : DMA_32BIT_MASK;
 
 	/* Device not DMA able */
 	if (dev->dma_mask == NULL)
@@ -404,7 +406,7 @@ dma_alloc_coherent(struct device *dev, s
 	   larger than 16MB and in this case we have a chance of
 	   finding fitting memory in the next higher zone first. If
 	   not retry with true GFP_DMA. -AK */
-	if (dma_mask <= DMA_32BIT_MASK)
+	if (dma_mask <= DMA_32BIT_MASK && !(gfp & GFP_DMA))
 		gfp |= GFP_DMA32;
 #endif
 
