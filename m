Return-Path: <linux-kernel-owner+w=401wt.eu-S1756128AbYIQQ4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128AbYIQQ4y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 12:56:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755266AbYIQQxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 12:53:21 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:65038 "EHLO
	WA4EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755204AbYIQQxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 12:53:18 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j64h)
X-Spam-TCS-SCL: 3:0
X-FB-SS: 5,
X-WSS-ID: 0K7CMW6-04-URN-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: linux-kernel@vger.kernel.org
CC: iommu@lists.linux-foundation.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 16/23] AMD IOMMU: avoid unnecessary low zone allocation in alloc_coherent
Date: Wed, 17 Sep 2008 18:52:50 +0200
Message-ID: <1221670377-19295-17-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1221670377-19295-1-git-send-email-joerg.roedel@amd.com>
References: <1221670377-19295-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 17 Sep 2008 16:52:58.0151 (UTC) FILETIME=[D6779B70:01C918E5]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

x86's common alloc_coherent (dma_alloc_coherent in dma-mapping.h) sets
up the gfp flag according to the device dma_mask but AMD IOMMU doesn't
need it for devices that the IOMMU can do virtual mappings for. This
patch avoids unnecessary low zone allocation.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 8c97360..963b8bb 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1173,6 +1173,9 @@ static void *alloc_coherent(struct device *dev, size_t size,
 	if (!check_device(dev))
 		return NULL;
 
+	if (!get_device_resources(dev, &iommu, &domain, &devid))
+		flag &= ~(__GFP_DMA | __GFP_HIGHMEM | __GFP_DMA32);
+
 	virt_addr = (void *)__get_free_pages(flag, get_order(size));
 	if (!virt_addr)
 		return 0;
@@ -1180,8 +1183,6 @@ static void *alloc_coherent(struct device *dev, size_t size,
 	memset(virt_addr, 0, size);
 	paddr = virt_to_phys(virt_addr);
 
-	get_device_resources(dev, &iommu, &domain, &devid);
-
 	if (!iommu || !domain) {
 		*dma_addr = (dma_addr_t)paddr;
 		return virt_addr;
-- 
1.5.6.4


