Return-Path: <linux-kernel-owner+w=401wt.eu-S964942AbZIEA2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964942AbZIEA2M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:28:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934695AbZIEA2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:28:04 -0400
Received: from kroah.org ([198.145.64.141]:42223 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934639AbZIEAVL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:21:11 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 17:14:54 2009
Message-Id: <20090905001454.610825030@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 17:14:22 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Fenghua Yu <fenghua.yu@intel.com>
Subject: [patch 47/71] Bug Fix arch/ia64/kernel/pci-dma.c: fix recursive dma_supported() call in iommu_dma_supported()
References: <20090905001335.106974681@mini.kroah.org>
Content-Disposition: inline; filename=bug-fix-arch-ia64-kernel-pci-dma.c-fix-recursive-dma_supported-call-in-iommu_dma_supported.patch
In-Reply-To: <20090905001824.GA18171@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Fenghua Yu <[fenghua.yu@intel.com]>

commit 51b89f7a6615eca184aa0b85db5781d931e9c8d1 upstream.

In commit 160c1d8e40866edfeae7d68816b7005d70acf391,
dma_ops->dma_supported = iommu_dma_supported;

This dma_ops->dma_supported is first called in platform_dma_init() during kernel
boot. Then dma_ops->dma_supported will be called recursively in
iommu_dma_supported.

Kernel can not boot because kernel can not get out of iommu_dma_supported until
it runs out of stack memory.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/ia64/kernel/pci-dma.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/arch/ia64/kernel/pci-dma.c
+++ b/arch/ia64/kernel/pci-dma.c
@@ -67,11 +67,6 @@ iommu_dma_init(void)
 
 int iommu_dma_supported(struct device *dev, u64 mask)
 {
-	struct dma_map_ops *ops = platform_dma_get_ops(dev);
-
-	if (ops->dma_supported)
-		return ops->dma_supported(dev, mask);
-
 	/* Copied from i386. Doesn't make much sense, because it will
 	   only work for pci_alloc_coherent.
 	   The caller just has to use GFP_DMA in this case. */


