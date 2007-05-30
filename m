Return-Path: <linux-kernel-owner+w=401wt.eu-S1759006AbXE3W3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759006AbXE3W3Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 18:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750825AbXE3W3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 18:29:17 -0400
Received: from mga03.intel.com ([143.182.124.21]:9587 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746AbXE3W3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 18:29:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,595,1170662400"; 
   d="scan'208";a="233825006"
From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH] dma-mapping: prevent dma dependent code from linking on
	!HAS_DMA archs
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, cornelia.huck@de.ibm.com,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       linville@tuxdriver.com, kyle@parisc-linux.org,
       James.Bottomley@SteelEye.com, htejun@gmail.com, jeff@garzik.org,
       geert@linux-m68k.org, zippel@linux-m68k.org, spyro@f2s.com,
       ysato@users.sourceforge.jp
Date: Wed, 30 May 2007 15:29:14 -0700
Message-ID: <20070530222914.29322.98331.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <0C7297FA1D2D244A9C7F6959C0BF1E5201EC6BE2@azsmsx413.amr.corp.intel.com>
References: <0C7297FA1D2D244A9C7F6959C0BF1E5201EC6BE2@azsmsx413.amr.corp.intel.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Continuing the work started in 411f0f3edc141a582190d3605cadd1d993abb6df ...

This enables code with a dma path, that compiles away, to build without
requiring additional code factoring.  It also prevents code that calls
dma_alloc_coherent and dma_free_coherent from linking whereas previously
the code would hit a BUG() at run time.  Finally, it allows archs that set
!HAS_DMA to delete their asm/dma-mapping.h file.

Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: Kyle McMartin <kyle@parisc-linux.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: <geert@linux-m68k.org>
Cc: <zippel@linux-m68k.org>
Cc: <spyro@f2s.com>
Cc: <ysato@users.sourceforge.jp>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 arch/arm26/Kconfig                       |    3 +
 arch/h8300/Kconfig                       |    3 +
 arch/m32r/Kconfig                        |    3 +
 drivers/dma/Kconfig                      |    2 -
 include/asm-arm26/dma-mapping.h          |    2 -
 include/asm-generic/dma-mapping-broken.h |   82 ++++++++++++++++++++++++++----
 include/asm-h8300/dma-mapping.h          |    1 
 include/asm-m32r/dma-mapping.h           |    6 --
 include/asm-s390/dma-mapping.h           |   12 ----
 include/linux/dma-mapping.h              |    4 +
 10 files changed, 84 insertions(+), 34 deletions(-)

diff --git a/arch/arm26/Kconfig b/arch/arm26/Kconfig
index 20688bc..9044f33 100644
--- a/arch/arm26/Kconfig
+++ b/arch/arm26/Kconfig
@@ -17,6 +17,9 @@ config MMU
 	bool
 	default y
 
+config NO_DMA
+	def_bool y
+
 config ARCH_ACORN
         bool
         default y
diff --git a/arch/h8300/Kconfig b/arch/h8300/Kconfig
index 618dbad..e35f74e 100644
--- a/arch/h8300/Kconfig
+++ b/arch/h8300/Kconfig
@@ -68,6 +68,9 @@ config TIME_LOW_RES
 config NO_IOPORT
 	def_bool y
 
+config NO_DMA
+	def_bool y
+
 config ISA
 	bool
 	default y
diff --git a/arch/m32r/Kconfig b/arch/m32r/Kconfig
index c3bb8a7..8ccf3e4 100644
--- a/arch/m32r/Kconfig
+++ b/arch/m32r/Kconfig
@@ -31,6 +31,9 @@ config GENERIC_IRQ_PROBE
 config NO_IOPORT
 	def_bool y
 
+config NO_DMA
+	def_bool y
+
 source "init/Kconfig"
 
 
diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 72be6c6..59305bc 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -3,7 +3,7 @@
 #
 
 menu "DMA Engine support"
-	depends on !S390
+	depends on HAS_DMA
 
 config DMA_ENGINE
 	bool "Support for DMA engines"
diff --git a/include/asm-arm26/dma-mapping.h b/include/asm-arm26/dma-mapping.h
deleted file mode 100644
index a95eae0..0000000
--- a/include/asm-arm26/dma-mapping.h
+++ /dev/null
@@ -1,2 +0,0 @@
-#include <asm-generic/dma-mapping-broken.h>
-
diff --git a/include/asm-generic/dma-mapping-broken.h b/include/asm-generic/dma-mapping-broken.h
index 29413d3..e2468f8 100644
--- a/include/asm-generic/dma-mapping-broken.h
+++ b/include/asm-generic/dma-mapping-broken.h
@@ -1,24 +1,82 @@
 #ifndef _ASM_GENERIC_DMA_MAPPING_H
 #define _ASM_GENERIC_DMA_MAPPING_H
 
-/* This is used for archs that do not support DMA */
+/* define the dma api to allow compilation but not linking of
+ * dma dependent code.  Code that depends on the dma-mapping
+ * API needs to set 'depends on HAS_DMA' in its Kconfig
+ */
 
-static inline void *
+struct scatterlist;
+
+extern void *
 dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
-		   gfp_t flag)
-{
-	BUG();
-	return NULL;
-}
+		   gfp_t flag);
 
-static inline void
+extern void
 dma_free_coherent(struct device *dev, size_t size, void *cpu_addr,
-		    dma_addr_t dma_handle)
-{
-	BUG();
-}
+		    dma_addr_t dma_handle);
 
 #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
 #define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
 
+extern dma_addr_t
+dma_map_single(struct device *dev, void *ptr, size_t size,
+	       enum dma_data_direction direction);
+
+extern void
+dma_unmap_single(struct device *dev, dma_addr_t dma_addr, size_t size,
+		 enum dma_data_direction direction);
+
+extern int
+dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
+	   enum dma_data_direction direction);
+
+extern void
+dma_unmap_sg(struct device *dev, struct scatterlist *sg, int nhwentries,
+	     enum dma_data_direction direction);
+
+extern dma_addr_t
+dma_map_page(struct device *dev, struct page *page, unsigned long offset,
+	     size_t size, enum dma_data_direction direction);
+
+extern void
+dma_unmap_page(struct device *dev, dma_addr_t dma_address, size_t size,
+	       enum dma_data_direction direction);
+
+extern void
+dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle, size_t size,
+			enum dma_data_direction direction);
+
+extern void
+dma_sync_single_range_for_cpu(struct device *dev, dma_addr_t dma_handle,
+			      unsigned long offset, size_t size,
+			      enum dma_data_direction direction);
+
+extern void
+dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg, int nelems,
+		    enum dma_data_direction direction);
+
+#define dma_sync_single_for_device dma_sync_single_for_cpu
+#define dma_sync_single_range_for_device dma_sync_single_range_for_cpu
+#define dma_sync_sg_for_device dma_sync_sg_for_cpu
+
+extern int
+dma_mapping_error(dma_addr_t dma_addr);
+
+extern int
+dma_supported(struct device *dev, u64 mask);
+
+extern int
+dma_set_mask(struct device *dev, u64 mask);
+
+extern int
+dma_get_cache_alignment(void);
+
+extern int
+dma_is_consistent(struct device *dev, dma_addr_t dma_handle);
+
+extern void
+dma_cache_sync(struct device *dev, void *vaddr, size_t size,
+	       enum dma_data_direction direction);
+
 #endif /* _ASM_GENERIC_DMA_MAPPING_H */
diff --git a/include/asm-h8300/dma-mapping.h b/include/asm-h8300/dma-mapping.h
deleted file mode 100644
index d00e400..0000000
--- a/include/asm-h8300/dma-mapping.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/dma-mapping-broken.h>
diff --git a/include/asm-m32r/dma-mapping.h b/include/asm-m32r/dma-mapping.h
deleted file mode 100644
index f9b58eb..0000000
--- a/include/asm-m32r/dma-mapping.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_M32R_DMA_MAPPING_H
-#define _ASM_M32R_DMA_MAPPING_H
-
-#include <asm-generic/dma-mapping-broken.h>
-
-#endif /* _ASM_M32R_DMA_MAPPING_H */
diff --git a/include/asm-s390/dma-mapping.h b/include/asm-s390/dma-mapping.h
deleted file mode 100644
index 3f8c12f..0000000
--- a/include/asm-s390/dma-mapping.h
+++ /dev/null
@@ -1,12 +0,0 @@
-/*
- *  include/asm-s390/dma-mapping.h
- *
- *  S390 version
- *
- *  This file exists so that #include <dma-mapping.h> doesn't break anything.
- */
-
-#ifndef _ASM_DMA_MAPPING_H
-#define _ASM_DMA_MAPPING_H
-
-#endif /* _ASM_DMA_MAPPING_H */
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 9a663c6..2dc21cb 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -31,7 +31,11 @@ static inline int valid_dma_direction(int dma_direction)
 		(dma_direction == DMA_FROM_DEVICE));
 }
 
+#ifdef CONFIG_HAS_DMA
 #include <asm/dma-mapping.h>
+#else
+#include <asm-generic/dma-mapping-broken.h>
+#endif
 
 /* Backwards compat, remove in 2.7.x */
 #define dma_sync_single		dma_sync_single_for_cpu
