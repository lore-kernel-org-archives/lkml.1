Return-Path: <linux-kernel-owner+w=401wt.eu-S1754120AbXDMSIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120AbXDMSIb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 14:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754121AbXDMSIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 14:08:31 -0400
Received: from mail.gmx.net ([213.165.64.20]:50217 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754120AbXDMSIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 14:08:30 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1/eGgx6YDveSsfkgXiDQ7nWdJcZ+S1on/IHPDX0Al
	DZQKNWn/DkQ1a1
Date: Fri, 13 Apr 2007 20:08:28 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: James Bottomley <James.Bottomley@SteelEye.com>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] dma_declare_coherent_memory wrong allocation
Message-ID: <Pine.LNX.4.60.0704132000030.5919@poirot.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Either I've finally gone blind on this Friday 13th or... Looks like this 
almost 3 year old function has a bug. Patch below compile-tested... in a 
way.

Thanks
Guennadi
---
Guennadi Liakhovetski

dma_declare_coherent_memory() allocates a bitmap 1 bit per page, it 
calculates the bitmap size based on size of long, but allocates bytes...

Signed-off-by: G. Liakhovetski <g.liakhovetski@gmx.de>

diff --git a/arch/i386/kernel/pci-dma.c b/arch/i386/kernel/pci-dma.c
index 3ebcea0..3d55226 100644
--- a/arch/i386/kernel/pci-dma.c
+++ b/arch/i386/kernel/pci-dma.c
@@ -77,7 +77,7 @@ int dma_declare_coherent_memory(struct device *dev, dma_addr_t bus_addr,
 {
 	void __iomem *mem_base = NULL;
 	int pages = size >> PAGE_SHIFT;
-	int bitmap_size = (pages + 31)/32;
+	int bitmap_size = DIV_ROUND_UP(pages, 8);
 
 	if ((flags & (DMA_MEMORY_MAP | DMA_MEMORY_IO)) == 0)
 		goto out;
