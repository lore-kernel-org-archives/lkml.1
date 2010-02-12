Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239Ab0BLJgg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 04:36:36 -0500
Received: from sh.osrg.net ([192.16.179.4]:35877 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751844Ab0BLJf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 04:35:28 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH -mm 5/7] powerpc: use generic pci_set_dma_mask and pci_set_consistent_dma_mask
Date: Fri, 12 Feb 2010 18:33:30 +0900
Message-Id: <1265967212-9126-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1265967212-9126-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1265967212-9126-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 12 Feb 2010 18:35:21 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts powerpc to use the generic pci_set_dma_mask and
pci_set_consistent_dma_mask (drivers/pci/pci.c).

The generic pci_set_dma_mask does what powerpc's pci_set_dma_mask
does.

Unlike powerpc's pci_set_consistent_dma_mask, the gneric
pci_set_consistent_dma_mask sets only coherent_dma_mask. It doesn't
work for powerpc? pci_set_consistent_dma_mask API should set only
coherent_dma_mask?

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 arch/powerpc/include/asm/dma-mapping.h |    3 ---
 arch/powerpc/kernel/pci-common.c       |   15 ---------------
 2 files changed, 0 insertions(+), 18 deletions(-)

diff --git a/arch/powerpc/include/asm/dma-mapping.h b/arch/powerpc/include/asm/dma-mapping.h
index 80a973b..c85ef23 100644
--- a/arch/powerpc/include/asm/dma-mapping.h
+++ b/arch/powerpc/include/asm/dma-mapping.h
@@ -127,9 +127,6 @@ static inline int dma_supported(struct device *dev, u64 mask)
 	return dma_ops->dma_supported(dev, mask);
 }
 
-/* We have our own implementation of pci_set_dma_mask() */
-#define HAVE_ARCH_PCI_SET_DMA_MASK
-
 static inline int dma_set_mask(struct device *dev, u64 dma_mask)
 {
 	struct dma_map_ops *dma_ops = get_dma_ops(dev);
diff --git a/arch/powerpc/kernel/pci-common.c b/arch/powerpc/kernel/pci-common.c
index cadbed6..a8bc6f2 100644
--- a/arch/powerpc/kernel/pci-common.c
+++ b/arch/powerpc/kernel/pci-common.c
@@ -63,21 +63,6 @@ struct dma_map_ops *get_pci_dma_ops(void)
 }
 EXPORT_SYMBOL(get_pci_dma_ops);
 
-int pci_set_dma_mask(struct pci_dev *dev, u64 mask)
-{
-	return dma_set_mask(&dev->dev, mask);
-}
-
-int pci_set_consistent_dma_mask(struct pci_dev *dev, u64 mask)
-{
-	int rc;
-
-	rc = dma_set_mask(&dev->dev, mask);
-	dev->dev.coherent_dma_mask = dev->dma_mask;
-
-	return rc;
-}
-
 struct pci_controller *pcibios_alloc_controller(struct device_node *dev)
 {
 	struct pci_controller *phb;
-- 
1.5.6.5

