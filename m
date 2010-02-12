Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372Ab0BLJfb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 04:35:31 -0500
Received: from sh.osrg.net ([192.16.179.4]:35875 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805Ab0BLJf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 04:35:28 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH -mm 7/7] pci: move pci_set_dma_mask and pci_set_consistent_dma_mask to pci-dma-compat.h
Date: Fri, 12 Feb 2010 18:33:32 +0900
Message-Id: <1265967212-9126-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1265967212-9126-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1265967212-9126-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 12 Feb 2010 18:35:21 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can use pci-dma-compat.h to implement pci_set_dma_mask and
pci_set_consistent_dma_mask as we do with the other PCI DMA API.

We can remove HAVE_ARCH_PCI_SET_DMA_MASK too.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 drivers/pci/pci.c                    |   28 ----------------------------
 include/asm-generic/pci-dma-compat.h |   13 ++++++++++---
 include/linux/pci.h                  |    2 --
 3 files changed, 10 insertions(+), 33 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index aacb86f..57af999 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -2114,32 +2114,6 @@ void pci_msi_off(struct pci_dev *dev)
 	}
 }
 
-#ifndef HAVE_ARCH_PCI_SET_DMA_MASK
-/*
- * These can be overridden by arch-specific implementations
- */
-int
-pci_set_dma_mask(struct pci_dev *dev, u64 mask)
-{
-	int ret = dma_set_mask(&dev->dev, mask);
-	if (ret)
-		return ret;
-	dev_dbg(&dev->dev, "using %dbit DMA mask\n", fls64(mask));
-	return 0;
-}
-
-int
-pci_set_consistent_dma_mask(struct pci_dev *dev, u64 mask)
-{
-	int ret = dma_set_coherent_mask(&dev->dev, mask);
-	if (ret)
-		return ret;
-
-	dev_dbg(&dev->dev, "using %dbit consistent DMA mask\n", fls64(mask));
-	return 0;
-}
-#endif
-
 #ifndef HAVE_ARCH_PCI_SET_DMA_MAX_SEGMENT_SIZE
 int pci_set_dma_max_seg_size(struct pci_dev *dev, unsigned int size)
 {
@@ -2857,8 +2831,6 @@ EXPORT_SYMBOL(pci_set_mwi);
 EXPORT_SYMBOL(pci_try_set_mwi);
 EXPORT_SYMBOL(pci_clear_mwi);
 EXPORT_SYMBOL_GPL(pci_intx);
-EXPORT_SYMBOL(pci_set_dma_mask);
-EXPORT_SYMBOL(pci_set_consistent_dma_mask);
 EXPORT_SYMBOL(pci_assign_resource);
 EXPORT_SYMBOL(pci_find_parent_resource);
 EXPORT_SYMBOL(pci_select_bars);
diff --git a/include/asm-generic/pci-dma-compat.h b/include/asm-generic/pci-dma-compat.h
index 37b3706..ddfa9c5 100644
--- a/include/asm-generic/pci-dma-compat.h
+++ b/include/asm-generic/pci-dma-compat.h
@@ -6,9 +6,6 @@
 
 #include <linux/dma-mapping.h>
 
-/* note pci_set_dma_mask isn't here, since it's a public function
- * exported from drivers/pci, use dma_supported instead */
-
 static inline int
 pci_dma_supported(struct pci_dev *hwdev, u64 mask)
 {
@@ -104,4 +101,14 @@ pci_dma_mapping_error(struct pci_dev *pdev, dma_addr_t dma_addr)
 	return dma_mapping_error(&pdev->dev, dma_addr);
 }
 
+static inline int pci_set_dma_mask(struct pci_dev *dev, u64 mask)
+{
+	return dma_set_mask(&dev->dev, mask);
+}
+
+static inline int pci_set_consistent_dma_mask(struct pci_dev *dev, u64 mask)
+{
+	return dma_set_coherent_mask(&dev->dev, mask);
+}
+
 #endif
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 032f42c..12b8aff 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -720,8 +720,6 @@ int pci_try_set_mwi(struct pci_dev *dev);
 void pci_clear_mwi(struct pci_dev *dev);
 void pci_intx(struct pci_dev *dev, int enable);
 void pci_msi_off(struct pci_dev *dev);
-int pci_set_dma_mask(struct pci_dev *dev, u64 mask);
-int pci_set_consistent_dma_mask(struct pci_dev *dev, u64 mask);
 int pci_set_dma_max_seg_size(struct pci_dev *dev, unsigned int size);
 int pci_set_dma_seg_boundary(struct pci_dev *dev, unsigned long mask);
 int pcix_get_max_mmrbc(struct pci_dev *dev);
-- 
1.5.6.5

