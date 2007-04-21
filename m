Return-Path: <linux-kernel-owner+w=401wt.eu-S1030715AbXDULBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030715AbXDULBT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 07:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030694AbXDULBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 07:01:18 -0400
Received: from mail.gmx.net ([213.165.64.20]:59687 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1030690AbXDULBQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 07:01:16 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1+9iQFE7Pm9PVKfHPCZE+eOy1aTB82LyZZQPcnUEB
	FvpL07vSR4UfPL
Date: Sat, 21 Apr 2007 13:01:14 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: James Bottomley <James.Bottomley@SteelEye.com>,
       linux-kernel@vger.kernel.org, starvik@axis.com
Subject: Re: [PATCH] dma_declare_coherent_memory wrong allocation
In-Reply-To: <20070421000817.124e917b.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.60.0704211251050.14499@poirot.grange>
References: <Pine.LNX.4.60.0704132000030.5919@poirot.grange>
 <20070421000817.124e917b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Apr 2007, Andrew Morton wrote:

> On Fri, 13 Apr 2007 20:08:28 +0200 (CEST) Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> 
> > Hi
> > 
> > Either I've finally gone blind on this Friday 13th or... Looks like this 
> > almost 3 year old function has a bug. Patch below compile-tested... in a 
> > way.

[patch skipped]

> Looks that way to me, too.

Then I'll dare suggest arch/cris - the second and last arch implementing 
this API - has the same problem. Maintainer added to cc:, patch below.

> It also hopes like hell that `size' was a multiple of PAGE_SIZE.

Well, this API seems to have a bigger problem: it is difficult to get to 
SoC/bus-local memory from several child devices. Even if I do implement 
that DMA_MEMORY_INCLUDES_CHILDREN flag, 1) you do not always have the 
desired device as your immediate parent, 2) you have to ref-count it. For 
example, I was trying to use SoC-local SRAM on PXA270 from the 
framebuffer, but fb-devices on PXA are either platform devices, or 
sometimes get other parents. So, looks like another way to get to the SoC 
node is needed...

Thanks
Guennadi
---
Guennadi Liakhovetski

Fix dma_declare_coherent_memory wrong allocation for cris/arch-v32
    
arch/cris/arch-v32 seems to have copy-pasted the bug from arch/i386 fixed 
with an earlier patch - allocate bitmap in bytes, not words.
    
Signed-off-by: G. Liakhovetski <g.liakhovetski@gmx.de>

diff --git a/arch/cris/arch-v32/drivers/pci/dma.c b/arch/cris/arch-v32/drivers/pci/dma.c
index 70d3bf0..d634347 100644
--- a/arch/cris/arch-v32/drivers/pci/dma.c
+++ b/arch/cris/arch-v32/drivers/pci/dma.c
@@ -76,7 +76,7 @@ int dma_declare_coherent_memory(struct device *dev, dma_addr_t bus_addr,
 {
 	void __iomem *mem_base;
 	int pages = size >> PAGE_SHIFT;
-	int bitmap_size = (pages + 31)/32;
+	int bitmap_size = DIV_ROUND_UP(pages, 8);
 
 	if ((flags & (DMA_MEMORY_MAP | DMA_MEMORY_IO)) == 0)
 		goto out;
