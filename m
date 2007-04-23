Return-Path: <linux-kernel-owner+w=401wt.eu-S1752311AbXDWUp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311AbXDWUp2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 16:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752306AbXDWUp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 16:45:27 -0400
Received: from mail.gmx.net ([213.165.64.20]:54549 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751965AbXDWUp1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 16:45:27 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX195zkUYyFd5BtffOQOvESZGUuWAU/PpjnXDm46eQA
	hp4mgdPNVe1fN2
Date: Mon, 23 Apr 2007 22:45:21 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: James Bottomley <James.Bottomley@SteelEye.com>
cc: linux-kernel@vger.kernel.org, jayalk@intworks.biz,
       akpm@linux-foundation.org
Subject: Re: [PATCH] dma_declare_coherent_memory wrong allocation
In-Reply-To: <1177343905.6284.22.camel@mulgrave>
Message-ID: <Pine.LNX.4.60.0704232239250.12939@poirot.grange>
References: <Pine.LNX.4.60.0704132000030.5919@poirot.grange> 
 <1177260725.4268.9.camel@mulgrave.il.steeleye.com> 
 <Pine.LNX.4.60.0704222202050.4127@poirot.grange> <1177343905.6284.22.camel@mulgrave>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Apr 2007, James Bottomley wrote:

> On Mon, 2007-04-23 at 00:45 +0200, Guennadi Liakhovetski wrote:
> > Right, thinko. How about using his:
> > 
> > +	int pages = DIV_ROUND_UP(size, PAGE_SIZE);
> 
> Actually, no ... this has to be size >> PAGE_SHIFT.  The reason being
> that the  allocator is designed to allocate pages out of a device memory
> buffer.  If the size isn't a multiple of page size, we have to round
> down (we can't allocate the last page if the memory we have is only part
> of a page).
> 
> I suppose if you want to catch the unlikely nutcase where size <
> PAGE_SIZE you could
> 
> if (unlikely(pages == 0))
> 	goto out;
> 
> > +	int bitmap_size = BITS_TO_LONGS(pages) * BYTES_PER_LONG;
> 
> This is fine, except the BYTES_PER_LONG.  Traditionally, we do this with
> sizeof(long).  The only reason to have a #define for it is if it has to
> be used in a macro (the compiler does sizeof() not the preprocessor).
> 
> How about just a simple
> 
> int bitmap_size = BITS_TO_LONGS(pages) * sizeof(long);

Ok, version 3, small, and hopefully, beautiful:

dma_declare_coherent_memory() allocates a bitmap 1 bit per page, it 
calculates the bitmap size based on size of long, but allocates bytes...
Thanks to James Bottomley for clarifications and corrections.

Signed-off-by: G. Liakhovetski <g.liakhovetski@gmx.de>

diff --git a/arch/cris/arch-v32/drivers/pci/dma.c b/arch/cris/arch-v32/drivers/pci/dma.c
index 70d3bf0..832fc63 100644
--- a/arch/cris/arch-v32/drivers/pci/dma.c
+++ b/arch/cris/arch-v32/drivers/pci/dma.c
@@ -76,7 +76,7 @@ int dma_declare_coherent_memory(struct device *dev, dma_addr_t bus_addr,
 {
 	void __iomem *mem_base;
 	int pages = size >> PAGE_SHIFT;
-	int bitmap_size = (pages + 31)/32;
+	int bitmap_size = BITS_TO_LONGS(pages) * sizeof(long);
 
 	if ((flags & (DMA_MEMORY_MAP | DMA_MEMORY_IO)) == 0)
 		goto out;
diff --git a/arch/i386/kernel/pci-dma.c b/arch/i386/kernel/pci-dma.c
index 3ebcea0..30b754f 100644
--- a/arch/i386/kernel/pci-dma.c
+++ b/arch/i386/kernel/pci-dma.c
@@ -77,7 +77,7 @@ int dma_declare_coherent_memory(struct device *dev, dma_addr_t bus_addr,
 {
 	void __iomem *mem_base = NULL;
 	int pages = size >> PAGE_SHIFT;
-	int bitmap_size = (pages + 31)/32;
+	int bitmap_size = BITS_TO_LONGS(pages) * sizeof(long);
 
 	if ((flags & (DMA_MEMORY_MAP | DMA_MEMORY_IO)) == 0)
 		goto out;

