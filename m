Return-Path: <linux-kernel-owner+w=401wt.eu-S1752832AbYIJLUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832AbYIJLUT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 07:20:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbYIJLUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 07:20:05 -0400
Received: from mo10.iij4u.or.jp ([210.138.174.78]:56455 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752014AbYIJLUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 07:20:04 -0400
Date: Wed, 10 Sep 2008 20:19:40 +0900
To: joerg.roedel@amd.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: [PATCH] x86: avoid unnecessary low zone allocation in AMD IOMMU's
 alloc_coherent
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080910201851R.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is for tip/iommu.

btw, Joery, what happens if map_sg (or map_single) gets
not-DMA-capable buffer in the case of !iommu || !domain?


==
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] x86: avoid unnecessary low zone allocation in AMD IOMMU's alloc_coherent

x86's common alloc_coherent (dma_alloc_coherent in dma-mapping.h) sets
up the gfp flag according to the device dma_mask but AMD IOMMU doesn't
need it for devices that the IOMMU can do virtual mappings for. This
patch avoids unnecessary low zone allocation.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/kernel/amd_iommu.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 01c68c3..8efd249 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -999,6 +999,11 @@ static void *alloc_coherent(struct device *dev, size_t size,
 	u16 devid;
 	phys_addr_t paddr;
 
+	get_device_resources(dev, &iommu, &domain, &devid);
+
+	if (iommu && domain)
+		flag &= ~(__GFP_DMA | __GFP_HIGHMEM | __GFP_DMA32);
+
 	virt_addr = (void *)__get_free_pages(flag, get_order(size));
 	if (!virt_addr)
 		return 0;
@@ -1006,8 +1011,6 @@ static void *alloc_coherent(struct device *dev, size_t size,
 	memset(virt_addr, 0, size);
 	paddr = virt_to_phys(virt_addr);
 
-	get_device_resources(dev, &iommu, &domain, &devid);
-
 	if (!iommu || !domain) {
 		*dma_addr = (dma_addr_t)paddr;
 		return virt_addr;
-- 
1.5.4.2

