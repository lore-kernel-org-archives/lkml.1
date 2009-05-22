Return-Path: <linux-kernel-owner+w=401wt.eu-S1758712AbZEVMXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758712AbZEVMXx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 08:23:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758468AbZEVMW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 08:22:28 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:21662 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758103AbZEVMWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 08:22:22 -0400
X-BigFish: VPS3(zzzz1202hzzz32i43j)
X-FB-SS: 5,
X-WSS-ID: 0KK1P0U-01-JR1-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 03/12] amd-iommu: handle page table allocation failures in dma_ops code
Date: Fri, 22 May 2009 14:21:24 +0200
Message-ID: <1242994893-28902-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1242994893-28902-1-git-send-email-joerg.roedel@amd.com>
References: <1242994893-28902-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 22 May 2009 12:21:32.0752 (UTC) FILETIME=[D7A52D00:01C9DAD7]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ impact: preperation for extended address allocator ]

The code will be required when the aperture size increases dynamically.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   20 ++++++++++++++++++--
 1 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index ded79f7..a467add 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1193,6 +1193,8 @@ static dma_addr_t dma_ops_domain_map(struct amd_iommu *iommu,
 	paddr &= PAGE_MASK;
 
 	pte  = dma_ops_get_pte(dom, address);
+	if (!pte)
+		return bad_dma_address;
 
 	__pte = paddr | IOMMU_PTE_P | IOMMU_PTE_FC;
 
@@ -1248,7 +1250,7 @@ static dma_addr_t __map_single(struct device *dev,
 			       u64 dma_mask)
 {
 	dma_addr_t offset = paddr & ~PAGE_MASK;
-	dma_addr_t address, start;
+	dma_addr_t address, start, ret;
 	unsigned int pages;
 	unsigned long align_mask = 0;
 	int i;
@@ -1271,7 +1273,10 @@ static dma_addr_t __map_single(struct device *dev,
 
 	start = address;
 	for (i = 0; i < pages; ++i) {
-		dma_ops_domain_map(iommu, dma_dom, start, paddr, dir);
+		ret = dma_ops_domain_map(iommu, dma_dom, start, paddr, dir);
+		if (ret == bad_dma_address)
+			goto out_unmap;
+
 		paddr += PAGE_SIZE;
 		start += PAGE_SIZE;
 	}
@@ -1287,6 +1292,17 @@ static dma_addr_t __map_single(struct device *dev,
 
 out:
 	return address;
+
+out_unmap:
+
+	for (--i; i >= 0; --i) {
+		start -= PAGE_SIZE;
+		dma_ops_domain_unmap(iommu, dma_dom, start);
+	}
+
+	dma_ops_free_addresses(dma_dom, address, pages);
+
+	return bad_dma_address;
 }
 
 /*
-- 
1.6.3.1


