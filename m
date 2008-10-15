Return-Path: <linux-kernel-owner+w=401wt.eu-S1754874AbYJOCIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874AbYJOCIs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 22:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751751AbYJOCIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 22:08:39 -0400
Received: from gw.goop.org ([64.81.55.164]:55277 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751656AbYJOCIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 22:08:38 -0400
Message-ID: <48F55097.4070802@goop.org>
Date: Tue, 14 Oct 2008 19:08:23 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Joerg Roedel <joerg.roedel@amd.com>, Jan Beulich <jbeulich@novell.com>,
       Tony Luck <tony.luck@intel.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] swiotlb: create appropriate common header for swiotlb
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

swiotlb.c was moved into lib/ as a generic service, but its prototypes
are still in asm-x86.  Move the common parts to linux/swiotlb.h, and
update the users accordingly.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>
Cc: Jan Beulich <jbeulich@novell.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/kernel/aperture_64.c    |    1 
 arch/x86/kernel/pci-calgary_64.c |    1 
 arch/x86/kernel/pci-dma.c        |    1 
 arch/x86/kernel/pci-gart_64.c    |    2 -
 arch/x86/kernel/pci-swiotlb_64.c |    2 -
 drivers/pci/dmar.c               |    1 
 drivers/pci/intel-iommu.c        |    1 
 drivers/pci/xen-iommu.c          |    2 -
 include/asm-x86/dma-mapping.h    |    1 
 include/asm-x86/swiotlb.h        |   42 -------------------------------
 include/linux/swiotlb.h          |   50 ++++++++++++++++++++++++++++++++++++++
 lib/swiotlb.c                    |    3 --
 12 files changed, 59 insertions(+), 48 deletions(-)

===================================================================
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -16,6 +16,7 @@
 #include <linux/mmzone.h>
 #include <linux/pci_ids.h>
 #include <linux/pci.h>
+#include <linux/swiotlb.h>
 #include <linux/bitops.h>
 #include <linux/ioport.h>
 #include <linux/suspend.h>
===================================================================
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -36,6 +36,7 @@
 #include <linux/pci.h>
 #include <linux/delay.h>
 #include <linux/scatterlist.h>
+#include <linux/swiotlb.h>
 #include <linux/iommu-helper.h>
 
 #include <asm/iommu.h>
===================================================================
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -1,6 +1,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/dmar.h>
 #include <linux/bootmem.h>
+#include <linux/swiotlb.h>
 #include <linux/pci.h>
 
 #include <asm/proto.h>
===================================================================
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -21,6 +21,7 @@
 #include <linux/pci.h>
 #include <linux/module.h>
 #include <linux/topology.h>
+#include <linux/swiotlb.h>
 #include <linux/interrupt.h>
 #include <linux/bitops.h>
 #include <linux/kdebug.h>
@@ -35,7 +36,6 @@
 #include <asm/iommu.h>
 #include <asm/gart.h>
 #include <asm/cacheflush.h>
-#include <asm/swiotlb.h>
 #include <asm/dma.h>
 #include <asm/k8.h>
 
===================================================================
--- a/arch/x86/kernel/pci-swiotlb_64.c
+++ b/arch/x86/kernel/pci-swiotlb_64.c
@@ -3,10 +3,10 @@
 #include <linux/pci.h>
 #include <linux/cache.h>
 #include <linux/module.h>
+#include <linux/swiotlb.h>
 #include <linux/dma-mapping.h>
 
 #include <asm/iommu.h>
-#include <asm/swiotlb.h>
 #include <asm/dma.h>
 
 int swiotlb __read_mostly;
===================================================================
--- a/drivers/pci/dmar.c
+++ b/drivers/pci/dmar.c
@@ -29,6 +29,7 @@
 #include <linux/pci.h>
 #include <linux/dmar.h>
 #include <linux/timer.h>
+#include <linux/swiotlb.h>
 #include "iova.h"
 #include "intel-iommu.h"
 
===================================================================
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -29,6 +29,7 @@
 #include <linux/sysdev.h>
 #include <linux/spinlock.h>
 #include <linux/pci.h>
+#include <linux/swiotlb.h>
 #include <linux/dmar.h>
 #include <linux/dma-mapping.h>
 #include <linux/mempool.h>
===================================================================
--- a/drivers/pci/xen-iommu.c
+++ b/drivers/pci/xen-iommu.c
@@ -5,6 +5,7 @@
 #include <linux/module.h>
 #include <linux/version.h>
 #include <linux/scatterlist.h>
+#include <linux/swiotlb.h>
 #include <linux/io.h>
 #include <linux/bug.h>
 
@@ -13,7 +14,6 @@
 #include <xen/xen-ops.h>
 
 #include <asm/iommu.h>
-#include <asm/swiotlb.h>
 #include <asm/tlbflush.h>
 
 #define IOMMU_BUG_ON(test)				\
===================================================================
--- a/include/asm-x86/dma-mapping.h
+++ b/include/asm-x86/dma-mapping.h
@@ -8,7 +8,6 @@
 
 #include <linux/scatterlist.h>
 #include <asm/io.h>
-#include <asm/swiotlb.h>
 #include <asm-generic/dma-coherent.h>
 
 extern dma_addr_t bad_dma_address;
===================================================================
--- a/include/asm-x86/swiotlb.h
+++ b/include/asm-x86/swiotlb.h
@@ -1,47 +1,5 @@
 #ifndef ASM_X86__SWIOTLB_H
 #define ASM_X86__SWIOTLB_H
-
-#include <asm/dma-mapping.h>
-
-/* SWIOTLB interface */
-
-extern dma_addr_t swiotlb_map_single(struct device *hwdev, void *ptr,
-				     size_t size, int dir);
-extern void *swiotlb_alloc_coherent(struct device *hwdev, size_t size,
-				    dma_addr_t *dma_handle, gfp_t flags);
-extern void swiotlb_unmap_single(struct device *hwdev, dma_addr_t dev_addr,
-				 size_t size, int dir);
-extern void swiotlb_sync_single_for_cpu(struct device *hwdev,
-					dma_addr_t dev_addr,
-					size_t size, int dir);
-extern void swiotlb_sync_single_for_device(struct device *hwdev,
-					   dma_addr_t dev_addr,
-					   size_t size, int dir);
-extern void swiotlb_sync_single_range_for_cpu(struct device *hwdev,
-					      dma_addr_t dev_addr,
-					      unsigned long offset,
-					      size_t size, int dir);
-extern void swiotlb_sync_single_range_for_device(struct device *hwdev,
-						 dma_addr_t dev_addr,
-						 unsigned long offset,
-						 size_t size, int dir);
-extern void swiotlb_sync_sg_for_cpu(struct device *hwdev,
-				    struct scatterlist *sg, int nelems,
-				    int dir);
-extern void swiotlb_sync_sg_for_device(struct device *hwdev,
-				       struct scatterlist *sg, int nelems,
-				       int dir);
-extern int swiotlb_map_sg(struct device *hwdev, struct scatterlist *sg,
-			  int nents, int direction);
-extern void swiotlb_unmap_sg(struct device *hwdev, struct scatterlist *sg,
-			     int nents, int direction);
-extern int swiotlb_dma_mapping_error(struct device *hwdev, dma_addr_t dma_addr);
-extern void swiotlb_free_coherent(struct device *hwdev, size_t size,
-				  void *vaddr, dma_addr_t dma_handle);
-extern int swiotlb_dma_supported(struct device *hwdev, u64 mask);
-extern void swiotlb_init(void);
-
-extern int swiotlb_force;
 
 #ifdef CONFIG_SWIOTLB
 extern int swiotlb;
===================================================================
--- /dev/null
+++ b/include/linux/swiotlb.h
@@ -0,0 +1,50 @@
+#ifndef LINUX__SWIOTLB_H
+#define LINUX__SWIOTLB_H
+
+#include <asm/swiotlb.h>
+
+/* SWIOTLB interface */
+
+extern dma_addr_t swiotlb_map_single(struct device *hwdev, void *ptr,
+				     size_t size, int dir);
+extern void *swiotlb_alloc_coherent(struct device *hwdev, size_t size,
+				    dma_addr_t *dma_handle, gfp_t flags);
+extern void swiotlb_unmap_single(struct device *hwdev, dma_addr_t dev_addr,
+				 size_t size, int dir);
+extern void swiotlb_sync_single_for_cpu(struct device *hwdev,
+					dma_addr_t dev_addr,
+					size_t size, int dir);
+extern void swiotlb_sync_single_for_device(struct device *hwdev,
+					   dma_addr_t dev_addr,
+					   size_t size, int dir);
+extern void swiotlb_sync_single_range_for_cpu(struct device *hwdev,
+					      dma_addr_t dev_addr,
+					      unsigned long offset,
+					      size_t size, int dir);
+extern void swiotlb_sync_single_range_for_device(struct device *hwdev,
+						 dma_addr_t dev_addr,
+						 unsigned long offset,
+						 size_t size, int dir);
+extern void swiotlb_sync_sg_for_cpu(struct device *hwdev,
+				    struct scatterlist *sg, int nelems,
+				    int dir);
+extern void swiotlb_sync_sg_for_device(struct device *hwdev,
+				       struct scatterlist *sg, int nelems,
+				       int dir);
+extern int swiotlb_map_sg(struct device *hwdev, struct scatterlist *sg,
+			  int nents, int direction);
+extern void swiotlb_unmap_sg(struct device *hwdev, struct scatterlist *sg,
+			     int nents, int direction);
+extern void swiotlb_unmap_sg_attrs(struct device *hwdev,
+				   struct scatterlist *sgl,
+				   int nelems, int dir,
+				   struct dma_attrs *attrs);
+extern int swiotlb_dma_mapping_error(struct device *hwdev, dma_addr_t dma_addr);
+extern void swiotlb_free_coherent(struct device *hwdev, size_t size,
+				  void *vaddr, dma_addr_t dma_handle);
+extern int swiotlb_dma_supported(struct device *hwdev, u64 mask);
+extern void swiotlb_init(void);
+
+extern int swiotlb_force;
+
+#endif /* LINUX__SWIOTLB_H */
===================================================================
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -22,6 +22,7 @@
 #include <linux/module.h>
 #include <linux/spinlock.h>
 #include <linux/string.h>
+#include <linux/swiotlb.h>
 #include <linux/types.h>
 #include <linux/ctype.h>
 
@@ -685,8 +686,6 @@
 				  SYNC_FOR_DEVICE);
 }
 
-void swiotlb_unmap_sg_attrs(struct device *, struct scatterlist *, int, int,
-			    struct dma_attrs *);
 /*
  * Map a set of buffers described by scatterlist in streaming mode for DMA.
  * This is the scatter-gather version of the above swiotlb_map_single


