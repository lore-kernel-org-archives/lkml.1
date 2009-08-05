Return-Path: <linux-kernel-owner+w=401wt.eu-S1755614AbZHEFK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614AbZHEFK7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 01:10:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755524AbZHEFKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 01:10:23 -0400
Received: from sh.osrg.net ([192.16.179.4]:38953 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755339AbZHEFKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 01:10:13 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linuxppc-dev@lists.ozlabs.org, benh@kernel.crashing.org
Cc: galak@kernel.crashing.orga, beckyb@kernel.crashing.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu,
       fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH -v2 6/7] powerpc: handle SWIOTLB mapping error properly
Date: Wed,  5 Aug 2009 14:08:27 +0900
Message-Id: <1249448908-18985-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1249448908-18985-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1249448908-18985-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 05 Aug 2009 14:09:55 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/powerpc/include/asm/dma-mapping.h |    5 +++++
 arch/powerpc/kernel/dma-swiotlb.c      |    3 ++-
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/include/asm/dma-mapping.h b/arch/powerpc/include/asm/dma-mapping.h
index 91217e4..4bd41b4 100644
--- a/arch/powerpc/include/asm/dma-mapping.h
+++ b/arch/powerpc/include/asm/dma-mapping.h
@@ -143,6 +143,11 @@ static inline void dma_free_coherent(struct device *dev, size_t size,
 
 static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
+	struct dma_map_ops *dma_ops = get_dma_ops(dev);
+
+	if (dma_ops->mapping_error)
+		return dma_ops->mapping_error(dev, dma_addr);
+
 #ifdef CONFIG_PPC64
 	return (dma_addr == DMA_ERROR_CODE);
 #else
diff --git a/arch/powerpc/kernel/dma-swiotlb.c b/arch/powerpc/kernel/dma-swiotlb.c
index d1143a6..e96cbbd 100644
--- a/arch/powerpc/kernel/dma-swiotlb.c
+++ b/arch/powerpc/kernel/dma-swiotlb.c
@@ -42,7 +42,8 @@ struct dma_map_ops swiotlb_dma_ops = {
 	.sync_single_range_for_cpu = swiotlb_sync_single_range_for_cpu,
 	.sync_single_range_for_device = swiotlb_sync_single_range_for_device,
 	.sync_sg_for_cpu = swiotlb_sync_sg_for_cpu,
-	.sync_sg_for_device = swiotlb_sync_sg_for_device
+	.sync_sg_for_device = swiotlb_sync_sg_for_device,
+	.mapping_error = swiotlb_dma_mapping_error,
 };
 
 void pci_dma_dev_setup_swiotlb(struct pci_dev *pdev)
-- 
1.6.0.6

