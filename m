Return-Path: <linux-kernel-owner+w=401wt.eu-S1030180AbXDVWtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030180AbXDVWtt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 18:49:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030950AbXDVWts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 18:49:48 -0400
Received: from mail.gmx.net ([213.165.64.20]:46904 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1030180AbXDVWts (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 18:49:48 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1+9gr8acX+9El/I8naBqopkYhQPYL0/NfM968kYOo
	fHD5pximOV4te+
Date: Mon, 23 Apr 2007 00:49:43 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: James Bottomley <James.Bottomley@SteelEye.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Mikael Starvik <starvik@axis.com>
Subject: Re: [PATCH] dma_declare_coherent_memory wrong allocation
In-Reply-To: <Pine.LNX.4.60.0704222202050.4127@poirot.grange>
Message-ID: <Pine.LNX.4.60.0704230045440.10258@poirot.grange>
References: <Pine.LNX.4.60.0704132000030.5919@poirot.grange>
 <1177260725.4268.9.camel@mulgrave.il.steeleye.com>
 <Pine.LNX.4.60.0704222202050.4127@poirot.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Apr 2007, Guennadi Liakhovetski wrote:

> to also allow for size not an integer number of pages as Andrew noticed? 
> This could be done in 2 patches:

patch 2:

---
Fix bitmap allocation and size non-multiple of PAGE_SIZE in 
dma_declare_coherent_memory implementations. i386 compile-tested.

Signed-off-by: G. Liakhovetski <g.liakhovetski@gmx.de>

diff --git a/arch/i386/kernel/pci-dma.c b/arch/i386/kernel/pci-dma.c
index 3ebcea0..0a9317a 100644
--- a/arch/i386/kernel/pci-dma.c
+++ b/arch/i386/kernel/pci-dma.c
@@ -76,8 +76,8 @@ int dma_declare_coherent_memory(struct device *dev, dma_addr_t bus_addr,
 				dma_addr_t device_addr, size_t size, int flags)
 {
 	void __iomem *mem_base = NULL;
-	int pages = size >> PAGE_SHIFT;
-	int bitmap_size = (pages + 31)/32;
+	int pages = DIV_ROUND_UP(size, PAGE_SIZE);
+	int bitmap_size = BITS_TO_LONGS(pages) * BYTES_PER_LONG;
 
 	if ((flags & (DMA_MEMORY_MAP | DMA_MEMORY_IO)) == 0)
 		goto out;
diff --git a/arch/cris/arch-v32/drivers/pci/dma.c b/arch/cris/arch-v32/drivers/pci/dma.c
index d634347..99f760e 100644
--- a/arch/cris/arch-v32/drivers/pci/dma.c
+++ b/arch/cris/arch-v32/drivers/pci/dma.c
@@ -75,8 +75,8 @@ int dma_declare_coherent_memory(struct device *dev, dma_addr_t bus_addr,
 				dma_addr_t device_addr, size_t size, int flags)
 {
 	void __iomem *mem_base;
-	int pages = size >> PAGE_SHIFT;
-	int bitmap_size = (pages + 31)/32;
+	int pages = DIV_ROUND_UP(size, PAGE_SIZE);
+	int bitmap_size = BITS_TO_LONGS(pages) * BYTES_PER_LONG;
 
 	if ((flags & (DMA_MEMORY_MAP | DMA_MEMORY_IO)) == 0)
 		goto out;
