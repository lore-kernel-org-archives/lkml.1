Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548Ab0BLJgi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 04:36:38 -0500
Received: from sh.osrg.net ([192.16.179.4]:35876 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829Ab0BLJf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 04:35:28 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp,
       Russell King <linux@arm.linux.org.uk>
Subject: [PATCH -mm 6/7] arm: use generic pci_set_dma_mask and pci_set_consistent_dma_mask
Date: Fri, 12 Feb 2010 18:33:31 +0900
Message-Id: <1265967212-9126-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1265967212-9126-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1265967212-9126-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 12 Feb 2010 18:35:21 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts arm to the generic pci_set_dma_mask and
pci_set_consistent_dma_mask (removes HAVE_ARCH_PCI_SET_DMA_MASK for
dmabounce).

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Russell King <linux@arm.linux.org.uk>
---
 arch/arm/common/it8152.c                     |   27 --------------------------
 arch/arm/include/asm/dma-mapping.h           |    8 +++++++
 arch/arm/mach-ixp4xx/common-pci.c            |   26 -------------------------
 arch/arm/mach-ixp4xx/include/mach/hardware.h |    5 ----
 arch/arm/mach-pxa/include/mach/hardware.h    |    1 -
 5 files changed, 8 insertions(+), 59 deletions(-)

diff --git a/arch/arm/common/it8152.c b/arch/arm/common/it8152.c
index 2793447..ee1d3b8 100644
--- a/arch/arm/common/it8152.c
+++ b/arch/arm/common/it8152.c
@@ -272,33 +272,6 @@ int dma_needs_bounce(struct device *dev, dma_addr_t dma_addr, size_t size)
 		((dma_addr + size - PHYS_OFFSET) >= SZ_64M);
 }
 
-/*
- * We override these so we properly do dmabounce otherwise drivers
- * are able to set the dma_mask to 0xffffffff and we can no longer
- * trap bounces. :(
- *
- * We just return true on everyhing except for < 64MB in which case
- * we will fail miseralby and die since we can't handle that case.
- */
-int pci_set_dma_mask(struct pci_dev *dev, u64 mask)
-{
-	dev_dbg(&dev->dev, "%s: %llx\n", __func__, mask);
-	if (mask >= PHYS_OFFSET + SZ_64M - 1)
-		return 0;
-
-	return -EIO;
-}
-
-int
-pci_set_consistent_dma_mask(struct pci_dev *dev, u64 mask)
-{
-	dev_dbg(&dev->dev, "%s: %llx\n", __func__, mask);
-	if (mask >= PHYS_OFFSET + SZ_64M - 1)
-		return 0;
-
-	return -EIO;
-}
-
 int __init it8152_pci_setup(int nr, struct pci_sys_data *sys)
 {
 	it8152_io.start = IT8152_IO_BASE + 0x12000;
diff --git a/arch/arm/include/asm/dma-mapping.h b/arch/arm/include/asm/dma-mapping.h
index a96300b..f6a138d 100644
--- a/arch/arm/include/asm/dma-mapping.h
+++ b/arch/arm/include/asm/dma-mapping.h
@@ -88,6 +88,14 @@ static inline int dma_supported(struct device *dev, u64 mask)
 
 static inline int dma_set_mask(struct device *dev, u64 dma_mask)
 {
+#ifdef CONFIG_DMABOUNCE
+	if (dev->archdata.dmabounce) {
+		if (dma_mask >= ISA_DMA_THRESHOLD)
+			return 0;
+		else
+			return -EIO;
+	}
+#endif
 	if (!dev->dma_mask || !dma_supported(dev, dma_mask))
 		return -EIO;
 
diff --git a/arch/arm/mach-ixp4xx/common-pci.c b/arch/arm/mach-ixp4xx/common-pci.c
index c4a0159..e318153 100644
--- a/arch/arm/mach-ixp4xx/common-pci.c
+++ b/arch/arm/mach-ixp4xx/common-pci.c
@@ -502,32 +502,6 @@ struct pci_bus * __devinit ixp4xx_scan_bus(int nr, struct pci_sys_data *sys)
 	return pci_scan_bus(sys->busnr, &ixp4xx_ops, sys);
 }
 
-/*
- * We override these so we properly do dmabounce otherwise drivers
- * are able to set the dma_mask to 0xffffffff and we can no longer
- * trap bounces. :(
- *
- * We just return true on everyhing except for < 64MB in which case 
- * we will fail miseralby and die since we can't handle that case.
- */
-int
-pci_set_dma_mask(struct pci_dev *dev, u64 mask)
-{
-	if (mask >= SZ_64M - 1 )
-		return 0;
-
-	return -EIO;
-}
-    
-int
-pci_set_consistent_dma_mask(struct pci_dev *dev, u64 mask)
-{
-	if (mask >= SZ_64M - 1 )
-		return 0;
-
-	return -EIO;
-}
-
 EXPORT_SYMBOL(ixp4xx_pci_read);
 EXPORT_SYMBOL(ixp4xx_pci_write);
 
diff --git a/arch/arm/mach-ixp4xx/include/mach/hardware.h b/arch/arm/mach-ixp4xx/include/mach/hardware.h
index f9d1c43..f91ca6d 100644
--- a/arch/arm/mach-ixp4xx/include/mach/hardware.h
+++ b/arch/arm/mach-ixp4xx/include/mach/hardware.h
@@ -26,11 +26,6 @@
 #define PCIBIOS_MAX_MEM		0x4BFFFFFF
 #endif
 
-/*
- * We override the standard dma-mask routines for bouncing.
- */
-#define	HAVE_ARCH_PCI_SET_DMA_MASK
-
 #define pcibios_assign_all_busses()	1
 
 /* Register locations and bits */
diff --git a/arch/arm/mach-pxa/include/mach/hardware.h b/arch/arm/mach-pxa/include/mach/hardware.h
index e741bf1..7515757 100644
--- a/arch/arm/mach-pxa/include/mach/hardware.h
+++ b/arch/arm/mach-pxa/include/mach/hardware.h
@@ -314,7 +314,6 @@ extern unsigned long get_clock_tick_rate(void);
 #define PCIBIOS_MIN_IO		0
 #define PCIBIOS_MIN_MEM		0
 #define pcibios_assign_all_busses()	1
-#define HAVE_ARCH_PCI_SET_DMA_MASK	1
 #endif
 
 
-- 
1.5.6.5

