Return-Path: <linux-kernel-owner+w=401wt.eu-S1752598AbZGMG3I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598AbZGMG3I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 02:29:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753086AbZGMG2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 02:28:48 -0400
Received: from sh.osrg.net ([192.16.179.4]:60439 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863AbZGMG2m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 02:28:42 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: davem@davemloft.net
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       reif@earthlink.net, x86@kernel.org, tony.luck@intel.com,
       fujita.tomonori@lab.ntt.co.jp, akpm@linux-foundation.org
Subject: [PATCH 8/8] sparc: add CONFIG_DMA_API_DEBUG support
Date: Mon, 13 Jul 2009 15:26:00 +0900
Message-Id: <1247466360-13330-9-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1247466360-13330-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1247466360-13330-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 13 Jul 2009 15:27:38 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All we need to do for CONFIG_DMA_API_DEBUG support is call
dma_debug_init() in DMA code common for SPARC32 and SPARC64.

Now SPARC32 uses two dma_map_ops structures for pci and sbus so there
is not much dma stuff for SPARC32 in kernel/dma.c. kernel/ioport.c
also includes dma stuff for SPARC32. So let's put all the dma stuff
for SPARC32 in kernel/ioport.c and make kernel/dma.c common for
SPARC32 and SPARC64.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/sparc/Kconfig                   |    1 +
 arch/sparc/include/asm/dma-mapping.h |    6 ++++-
 arch/sparc/kernel/Makefile           |    2 +-
 arch/sparc/kernel/dma.c              |   37 ++++-----------------------------
 arch/sparc/kernel/ioport.c           |   27 ++++++++++++++++++++++++
 5 files changed, 39 insertions(+), 34 deletions(-)

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 5f2df99..233cff5 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -26,6 +26,7 @@ config SPARC
 	select RTC_CLASS
 	select RTC_DRV_M48T59
 	select HAVE_DMA_ATTRS
+	select HAVE_DMA_API_DEBUG
 
 config SPARC32
 	def_bool !64BIT
diff --git a/arch/sparc/include/asm/dma-mapping.h b/arch/sparc/include/asm/dma-mapping.h
index 2677818..5a8c308 100644
--- a/arch/sparc/include/asm/dma-mapping.h
+++ b/arch/sparc/include/asm/dma-mapping.h
@@ -32,8 +32,11 @@ static inline void *dma_alloc_coherent(struct device *dev, size_t size,
 				       dma_addr_t *dma_handle, gfp_t flag)
 {
 	struct dma_map_ops *ops = get_dma_ops(dev);
+	void *cpu_addr;
 
-	return ops->alloc_coherent(dev, size, dma_handle, flag);
+	cpu_addr = ops->alloc_coherent(dev, size, dma_handle, flag);
+	debug_dma_alloc_coherent(dev, size, *dma_handle, cpu_addr);
+	return cpu_addr;
 }
 
 static inline void dma_free_coherent(struct device *dev, size_t size,
@@ -41,6 +44,7 @@ static inline void dma_free_coherent(struct device *dev, size_t size,
 {
 	struct dma_map_ops *ops = get_dma_ops(dev);
 
+	debug_dma_free_coherent(dev, size, cpu_addr, dma_handle);
 	ops->free_coherent(dev, size, cpu_addr, dma_handle);
 }
 
diff --git a/arch/sparc/kernel/Makefile b/arch/sparc/kernel/Makefile
index 475ce46..29b88a5 100644
--- a/arch/sparc/kernel/Makefile
+++ b/arch/sparc/kernel/Makefile
@@ -61,7 +61,7 @@ obj-$(CONFIG_SPARC64_SMP) += cpumap.o
 obj-$(CONFIG_SPARC32)     += devres.o
 devres-y                  := ../../../kernel/irq/devres.o
 
-obj-$(CONFIG_SPARC32)     += dma.o
+obj-y                     += dma.o
 
 obj-$(CONFIG_SPARC32_PCI) += pcic.o
 
diff --git a/arch/sparc/kernel/dma.c b/arch/sparc/kernel/dma.c
index b2fa312..e1ba8ee 100644
--- a/arch/sparc/kernel/dma.c
+++ b/arch/sparc/kernel/dma.c
@@ -1,40 +1,13 @@
-/* dma.c: PCI and SBUS DMA accessors for 32-bit sparc.
- *
- * Copyright (C) 2008 David S. Miller <davem@davemloft.net>
- */
-
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/dma-mapping.h>
-#include <linux/scatterlist.h>
-#include <linux/mm.h>
+#include <linux/dma-debug.h>
 
-#ifdef CONFIG_PCI
-#include <linux/pci.h>
-#endif
+#define PREALLOC_DMA_DEBUG_ENTRIES       (1 << 15)
 
-/*
- * Return whether the given PCI device DMA address mask can be
- * supported properly.  For example, if your device can only drive the
- * low 24-bits during PCI bus mastering, then you would pass
- * 0x00ffffff as the mask to this function.
- */
-int dma_supported(struct device *dev, u64 mask)
+static int __init dma_init(void)
 {
-#ifdef CONFIG_PCI
-	if (dev->bus == &pci_bus_type)
-		return 1;
-#endif
+	dma_debug_init(PREALLOC_DMA_DEBUG_ENTRIES);
 	return 0;
 }
-EXPORT_SYMBOL(dma_supported);
-
-int dma_set_mask(struct device *dev, u64 dma_mask)
-{
-#ifdef CONFIG_PCI
-	if (dev->bus == &pci_bus_type)
-		return pci_set_dma_mask(to_pci_dev(dev), dma_mask);
-#endif
-	return -EOPNOTSUPP;
-}
-EXPORT_SYMBOL(dma_set_mask);
+fs_initcall(dma_init);
diff --git a/arch/sparc/kernel/ioport.c b/arch/sparc/kernel/ioport.c
index 1eb6043..edbea23 100644
--- a/arch/sparc/kernel/ioport.c
+++ b/arch/sparc/kernel/ioport.c
@@ -654,6 +654,33 @@ EXPORT_SYMBOL(pci32_dma_ops);
 
 #endif /* CONFIG_PCI */
 
+/*
+ * Return whether the given PCI device DMA address mask can be
+ * supported properly.  For example, if your device can only drive the
+ * low 24-bits during PCI bus mastering, then you would pass
+ * 0x00ffffff as the mask to this function.
+ */
+int dma_supported(struct device *dev, u64 mask)
+{
+#ifdef CONFIG_PCI
+	if (dev->bus == &pci_bus_type)
+		return 1;
+#endif
+	return 0;
+}
+EXPORT_SYMBOL(dma_supported);
+
+int dma_set_mask(struct device *dev, u64 dma_mask)
+{
+#ifdef CONFIG_PCI
+	if (dev->bus == &pci_bus_type)
+		return pci_set_dma_mask(to_pci_dev(dev), dma_mask);
+#endif
+	return -EOPNOTSUPP;
+}
+EXPORT_SYMBOL(dma_set_mask);
+
+
 #ifdef CONFIG_PROC_FS
 
 static int
-- 
1.6.0.6

