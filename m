Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173Ab0BLJf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 04:35:29 -0500
Received: from sh.osrg.net ([192.16.179.4]:35872 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751752Ab0BLJf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 04:35:27 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp,
       David Miller <davem@davemloft.net>
Subject: [PATCH -mm 1/7] sparc: unify 32bit and 64bit dma_set_mask
Date: Fri, 12 Feb 2010 18:33:26 +0900
Message-Id: <1265967212-9126-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1265967212-9126-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1265967212-9126-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 12 Feb 2010 18:35:19 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sparc has two dma_set_mask implementations for 32bit and 64bit. They
are same except for the error returned value. We can safely unify them
since the error returned value doesn't matter as long as it is
negative (as DMA-API.txt describes).

This patch also changes dma_set_mask not to call
pci_set_dma_mask. Instead, dma_set_mask does the same thing that
pci_set_dma_mask does. This change enables ut to change
pci_set_dma_mask to call dma_set_mask; we can implement
pci_set_dma_mask as pci-dma-compat.h does.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: David Miller <davem@davemloft.net>
---
 arch/sparc/include/asm/dma-mapping.h |   14 +++++++++++++-
 arch/sparc/kernel/iommu.c            |   10 ----------
 arch/sparc/kernel/ioport.c           |   11 -----------
 3 files changed, 13 insertions(+), 22 deletions(-)

diff --git a/arch/sparc/include/asm/dma-mapping.h b/arch/sparc/include/asm/dma-mapping.h
index 5a8c308..4b4a0c0 100644
--- a/arch/sparc/include/asm/dma-mapping.h
+++ b/arch/sparc/include/asm/dma-mapping.h
@@ -8,7 +8,6 @@
 #define DMA_ERROR_CODE	(~(dma_addr_t)0x0)
 
 extern int dma_supported(struct device *dev, u64 mask);
-extern int dma_set_mask(struct device *dev, u64 dma_mask);
 
 #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
 #define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
@@ -62,4 +61,17 @@ static inline int dma_get_cache_alignment(void)
 	return (1 << INTERNODE_CACHE_SHIFT);
 }
 
+static inline int dma_set_mask(struct device *dev, u64 mask)
+{
+#ifdef CONFIG_PCI
+	if (dev->bus == &pci_bus_type) {
+		if (!dev->dma_mask || !dma_supported(dev, mask))
+			return -EINVAL;
+		*dev->dma_mask = mask;
+		return 0;
+	}
+#endif
+	return -EINVAL;
+}
+
 #endif
diff --git a/arch/sparc/kernel/iommu.c b/arch/sparc/kernel/iommu.c
index 5fad949..8414549 100644
--- a/arch/sparc/kernel/iommu.c
+++ b/arch/sparc/kernel/iommu.c
@@ -862,13 +862,3 @@ int dma_supported(struct device *dev, u64 device_mask)
 	return 0;
 }
 EXPORT_SYMBOL(dma_supported);
-
-int dma_set_mask(struct device *dev, u64 dma_mask)
-{
-#ifdef CONFIG_PCI
-	if (dev->bus == &pci_bus_type)
-		return pci_set_dma_mask(to_pci_dev(dev), dma_mask);
-#endif
-	return -EINVAL;
-}
-EXPORT_SYMBOL(dma_set_mask);
diff --git a/arch/sparc/kernel/ioport.c b/arch/sparc/kernel/ioport.c
index 3c8c44f..84e5386 100644
--- a/arch/sparc/kernel/ioport.c
+++ b/arch/sparc/kernel/ioport.c
@@ -676,17 +676,6 @@ int dma_supported(struct device *dev, u64 mask)
 }
 EXPORT_SYMBOL(dma_supported);
 
-int dma_set_mask(struct device *dev, u64 dma_mask)
-{
-#ifdef CONFIG_PCI
-	if (dev->bus == &pci_bus_type)
-		return pci_set_dma_mask(to_pci_dev(dev), dma_mask);
-#endif
-	return -EOPNOTSUPP;
-}
-EXPORT_SYMBOL(dma_set_mask);
-
-
 #ifdef CONFIG_PROC_FS
 
 static int sparc_io_proc_show(struct seq_file *m, void *v)
-- 
1.5.6.5

