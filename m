Return-Path: <linux-kernel-owner+w=401wt.eu-S1761139AbYCYVj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761139AbYCYVj7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 17:39:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752940AbYCYViX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 17:38:23 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34047 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760254AbYCYViW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 17:38:22 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, kvm-devel@lists.sourceforge.net, avi@qumranet.com,
       amit.shah@qumranet.com
Subject: [PATCH 02/20] x86: implement dma_map_single through dma_ops
Date: Tue, 25 Mar 2008 18:36:21 -0300
Message-Id: <1206480999-21767-3-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.2.2532.gdeda
In-Reply-To: <1206480999-21767-2-git-send-email-gcosta@redhat.com>
References: <1206480999-21767-1-git-send-email-gcosta@redhat.com>
 <1206480999-21767-2-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That's already the name of the game for x86_64. For i386,
we add a pci-base_32.c, that will hold the default operations.
The function call itself goes through dma-mapping.h , the common
header

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/Makefile         |    1 +
 arch/x86/kernel/pci-base_32.c    |   20 ++++++++++++++++++++
 include/asm-x86/dma-mapping.h    |   10 ++++++++++
 include/asm-x86/dma-mapping_32.h |   10 ----------
 include/asm-x86/dma-mapping_64.h |    9 ---------
 5 files changed, 31 insertions(+), 19 deletions(-)
 create mode 100644 arch/x86/kernel/pci-base_32.c

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 340221f..95fbf57 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -27,6 +27,7 @@ obj-y			+= pci-dma_$(BITS).o  bootflag.o e820_$(BITS).o
 obj-y			+= quirks.o i8237.o topology.o kdebugfs.o
 obj-y			+= alternative.o i8253.o
 obj-$(CONFIG_X86_64)	+= pci-nommu_64.o bugs_64.o
+obj-$(CONFIG_X86_32)	+= pci-base_32.o
 obj-y			+= tsc_$(BITS).o io_delay.o rtc.o
 
 obj-y				+= process.o
diff --git a/arch/x86/kernel/pci-base_32.c b/arch/x86/kernel/pci-base_32.c
new file mode 100644
index 0000000..b613d73
--- /dev/null
+++ b/arch/x86/kernel/pci-base_32.c
@@ -0,0 +1,20 @@
+#include <linux/mm.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/dma-mapping.h>
+#include <asm/dma-mapping.h>
+
+static dma_addr_t pci32_map_single(struct device *dev, void *ptr,
+				   size_t size, int direction)
+{
+	WARN_ON(size == 0);
+	flush_write_buffers();
+	return virt_to_phys(ptr);
+}
+
+static const struct dma_mapping_ops pci32_dma_ops = {
+	.map_single = pci32_map_single,
+};
+
+const struct dma_mapping_ops *dma_ops = &pci32_dma_ops;
+EXPORT_SYMBOL(dma_ops);
diff --git a/include/asm-x86/dma-mapping.h b/include/asm-x86/dma-mapping.h
index aebd178..d320244 100644
--- a/include/asm-x86/dma-mapping.h
+++ b/include/asm-x86/dma-mapping.h
@@ -50,10 +50,20 @@ struct dma_mapping_ops {
 	int		is_phys;
 };
 
+extern const struct dma_mapping_ops *dma_ops;
+
 #ifdef CONFIG_X86_32
 # include "dma-mapping_32.h"
 #else
 # include "dma-mapping_64.h"
 #endif
 
+static inline dma_addr_t
+dma_map_single(struct device *hwdev, void *ptr, size_t size,
+	       int direction)
+{
+	BUG_ON(!valid_dma_direction(direction));
+	return dma_ops->map_single(hwdev, ptr, size, direction);
+}
+
 #endif
diff --git a/include/asm-x86/dma-mapping_32.h b/include/asm-x86/dma-mapping_32.h
index 55f01bd..b496306 100644
--- a/include/asm-x86/dma-mapping_32.h
+++ b/include/asm-x86/dma-mapping_32.h
@@ -17,16 +17,6 @@ void *dma_alloc_coherent(struct device *dev, size_t size,
 void dma_free_coherent(struct device *dev, size_t size,
 			 void *vaddr, dma_addr_t dma_handle);
 
-static inline dma_addr_t
-dma_map_single(struct device *dev, void *ptr, size_t size,
-	       enum dma_data_direction direction)
-{
-	BUG_ON(!valid_dma_direction(direction));
-	WARN_ON(size == 0);
-	flush_write_buffers();
-	return virt_to_phys(ptr);
-}
-
 static inline void
 dma_unmap_single(struct device *dev, dma_addr_t dma_addr, size_t size,
 		 enum dma_data_direction direction)
diff --git a/include/asm-x86/dma-mapping_64.h b/include/asm-x86/dma-mapping_64.h
index 369188a..969a7da 100644
--- a/include/asm-x86/dma-mapping_64.h
+++ b/include/asm-x86/dma-mapping_64.h
@@ -2,7 +2,6 @@
 #define _X8664_DMA_MAPPING_H 1
 
 extern dma_addr_t bad_dma_address;
-extern const struct dma_mapping_ops* dma_ops;
 extern int iommu_merge;
 
 static inline int dma_mapping_error(dma_addr_t dma_addr)
@@ -24,14 +23,6 @@ extern void *dma_alloc_coherent(struct device *dev, size_t size,
 extern void dma_free_coherent(struct device *dev, size_t size, void *vaddr,
 			      dma_addr_t dma_handle);
 
-static inline dma_addr_t
-dma_map_single(struct device *hwdev, void *ptr, size_t size,
-	       int direction)
-{
-	BUG_ON(!valid_dma_direction(direction));
-	return dma_ops->map_single(hwdev, ptr, size, direction);
-}
-
 static inline void
 dma_unmap_single(struct device *dev, dma_addr_t addr,size_t size,
 		 int direction)
-- 
1.5.0.6

