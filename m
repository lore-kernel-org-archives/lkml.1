Return-Path: <linux-kernel-owner+w=401wt.eu-S1756386AbZAEPBD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386AbZAEPBD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 10:01:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756001AbZAEO7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 09:59:51 -0500
Received: from mo11.iij4u.or.jp ([210.138.174.79]:54729 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755863AbZAEO7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 09:59:48 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: tony.luck@intel.com, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 2/3] convert X86 and IA64 to use generic dma_map_ops struct
Date: Mon,  5 Jan 2009 23:59:02 +0900
Message-Id: <1231167543-20259-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1231167543-20259-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1231167543-20259-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1231167543-20259-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts X86 and IA64 to use include/linux/dma-mapping.h.

It's a bit large but pretty boring. The major change for X86 is
converting 'int dir' to 'enum dma_data_direction dir' in DMA mapping
operations. The major changes for IA64 is using map_page and
unmap_page instead of map_single and unmap_single.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/ia64/dig/Makefile              |    4 +-
 arch/ia64/dig/dig_vtd_iommu.c       |   77 ------------------
 arch/ia64/hp/common/hwsw_iommu.c    |    6 +-
 arch/ia64/hp/common/sba_iommu.c     |   46 ++++++++----
 arch/ia64/include/asm/dma-mapping.h |  107 ++++++++------------------
 arch/ia64/include/asm/machvec.h     |   12 ++-
 arch/ia64/kernel/dma-mapping.c      |    4 +-
 arch/ia64/kernel/machvec.c          |    8 +-
 arch/ia64/kernel/pci-dma.c          |   49 ++++++++----
 arch/ia64/kernel/pci-swiotlb.c      |   32 +++++---
 arch/ia64/sn/pci/pci_dma.c          |   58 +++++++-------
 arch/x86/include/asm/device.h       |    2 +-
 arch/x86/include/asm/dma-mapping.h  |  146 +++++++++++++----------------------
 arch/x86/include/asm/iommu.h        |    2 +-
 arch/x86/kernel/amd_iommu.c         |    8 +-
 arch/x86/kernel/pci-calgary_64.c    |   15 ++--
 arch/x86/kernel/pci-dma.c           |    4 +-
 arch/x86/kernel/pci-gart_64.c       |   14 ++--
 arch/x86/kernel/pci-nommu.c         |    5 +-
 arch/x86/kernel/pci-swiotlb_64.c    |    6 +-
 drivers/pci/intel-iommu.c           |    9 +-
 include/linux/intel-iommu.h         |    6 +-
 include/linux/swiotlb.h             |   18 +++--
 lib/swiotlb.c                       |   18 +++--
 24 files changed, 278 insertions(+), 378 deletions(-)
 delete mode 100644 arch/ia64/dig/dig_vtd_iommu.c

diff --git a/arch/ia64/dig/Makefile b/arch/ia64/dig/Makefile
index 5c02838..2f7cadd 100644
--- a/arch/ia64/dig/Makefile
+++ b/arch/ia64/dig/Makefile
@@ -7,8 +7,8 @@
 
 obj-y := setup.o
 ifeq ($(CONFIG_DMAR), y)
-obj-$(CONFIG_IA64_GENERIC) += machvec.o machvec_vtd.o dig_vtd_iommu.o
+obj-$(CONFIG_IA64_GENERIC) += machvec.o machvec_vtd.o
 else
 obj-$(CONFIG_IA64_GENERIC) += machvec.o
 endif
-obj-$(CONFIG_IA64_DIG_VTD) += dig_vtd_iommu.o
+
diff --git a/arch/ia64/dig/dig_vtd_iommu.c b/arch/ia64/dig/dig_vtd_iommu.c
deleted file mode 100644
index fdb8ba9..0000000
--- a/arch/ia64/dig/dig_vtd_iommu.c
+++ /dev/null
@@ -1,77 +0,0 @@
-#include <linux/types.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/dma-mapping.h>
-#include <linux/intel-iommu.h>
-
-void *
-vtd_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
-		 gfp_t flags)
-{
-	return intel_alloc_coherent(dev, size, dma_handle, flags);
-}
-EXPORT_SYMBOL_GPL(vtd_alloc_coherent);
-
-void
-vtd_free_coherent(struct device *dev, size_t size, void *vaddr,
-		 dma_addr_t dma_handle)
-{
-	intel_free_coherent(dev, size, vaddr, dma_handle);
-}
-EXPORT_SYMBOL_GPL(vtd_free_coherent);
-
-dma_addr_t
-vtd_map_single_attrs(struct device *dev, void *addr, size_t size,
-		     int dir, struct dma_attrs *attrs)
-{
-	return intel_map_single(dev, (phys_addr_t)addr, size, dir);
-}
-EXPORT_SYMBOL_GPL(vtd_map_single_attrs);
-
-void
-vtd_unmap_single_attrs(struct device *dev, dma_addr_t iova, size_t size,
-		       int dir, struct dma_attrs *attrs)
-{
-	intel_unmap_single(dev, iova, size, dir);
-}
-EXPORT_SYMBOL_GPL(vtd_unmap_single_attrs);
-
-int
-vtd_map_sg_attrs(struct device *dev, struct scatterlist *sglist, int nents,
-		 int dir, struct dma_attrs *attrs)
-{
-	return intel_map_sg(dev, sglist, nents, dir);
-}
-EXPORT_SYMBOL_GPL(vtd_map_sg_attrs);
-
-void
-vtd_unmap_sg_attrs(struct device *dev, struct scatterlist *sglist,
-		   int nents, int dir, struct dma_attrs *attrs)
-{
-	intel_unmap_sg(dev, sglist, nents, dir);
-}
-EXPORT_SYMBOL_GPL(vtd_unmap_sg_attrs);
-
-int
-vtd_dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
-{
-	return 0;
-}
-EXPORT_SYMBOL_GPL(vtd_dma_mapping_error);
-
-extern int iommu_dma_supported(struct device *dev, u64 mask);
-
-struct dma_mapping_ops vtd_dma_ops = {
-	.alloc_coherent		= vtd_alloc_coherent,
-	.free_coherent		= vtd_free_coherent,
-	.map_single_attrs	= vtd_map_single_attrs,
-	.unmap_single_attrs	= vtd_unmap_single_attrs,
-	.map_sg_attrs		= vtd_map_sg_attrs,
-	.unmap_sg_attrs		= vtd_unmap_sg_attrs,
-	.sync_single_for_cpu	= machvec_dma_sync_single,
-	.sync_sg_for_cpu	= machvec_dma_sync_sg,
-	.sync_single_for_device	= machvec_dma_sync_single,
-	.sync_sg_for_device	= machvec_dma_sync_sg,
-	.dma_supported_op	= iommu_dma_supported,
-	.mapping_error		= vtd_dma_mapping_error,
-};
diff --git a/arch/ia64/hp/common/hwsw_iommu.c b/arch/ia64/hp/common/hwsw_iommu.c
index e5bbeba..e4a80d8 100644
--- a/arch/ia64/hp/common/hwsw_iommu.c
+++ b/arch/ia64/hp/common/hwsw_iommu.c
@@ -17,7 +17,7 @@
 #include <linux/swiotlb.h>
 #include <asm/machvec.h>
 
-extern struct dma_mapping_ops sba_dma_ops, swiotlb_dma_ops;
+extern struct dma_map_ops sba_dma_ops, swiotlb_dma_ops;
 
 /* swiotlb declarations & definitions: */
 extern int swiotlb_late_init_with_default_size (size_t size);
@@ -30,10 +30,10 @@ extern int swiotlb_late_init_with_default_size (size_t size);
 static inline int use_swiotlb(struct device *dev)
 {
 	return dev && dev->dma_mask &&
-		!sba_dma_ops.dma_supported_op(dev, *dev->dma_mask);
+		!sba_dma_ops.dma_supported(dev, *dev->dma_mask);
 }
 
-struct dma_mapping_ops *hwsw_dma_get_ops(struct device *dev)
+struct dma_map_ops *hwsw_dma_get_ops(struct device *dev)
 {
 	if (use_swiotlb(dev))
 		return &swiotlb_dma_ops;
diff --git a/arch/ia64/hp/common/sba_iommu.c b/arch/ia64/hp/common/sba_iommu.c
index 29e7206..129b62e 100644
--- a/arch/ia64/hp/common/sba_iommu.c
+++ b/arch/ia64/hp/common/sba_iommu.c
@@ -909,11 +909,13 @@ sba_mark_invalid(struct ioc *ioc, dma_addr_t iova, size_t byte_cnt)
  *
  * See Documentation/DMA-mapping.txt
  */
-static dma_addr_t
-sba_map_single_attrs(struct device *dev, void *addr, size_t size, int dir,
-		     struct dma_attrs *attrs)
+static dma_addr_t sba_map_page(struct device *dev, struct page *page,
+			       unsigned long poff, size_t size,
+			       enum dma_data_direction dir,
+			       struct dma_attrs *attrs)
 {
 	struct ioc *ioc;
+	void *addr = page_address(page) + poff;
 	dma_addr_t iovp;
 	dma_addr_t offset;
 	u64 *pdir_start;
@@ -992,6 +994,14 @@ sba_map_single_attrs(struct device *dev, void *addr, size_t size, int dir,
 	return SBA_IOVA(ioc, iovp, offset);
 }
 
+static dma_addr_t sba_map_single_attrs(struct device *dev, void *addr,
+				       size_t size, enum dma_data_direction dir,
+				       struct dma_attrs *attrs)
+{
+	return sba_map_page(dev, virt_to_page(addr),
+			    (unsigned long)addr & ~PAGE_MASK, size, dir, attrs);
+}
+
 #ifdef ENABLE_MARK_CLEAN
 static SBA_INLINE void
 sba_mark_clean(struct ioc *ioc, dma_addr_t iova, size_t size)
@@ -1026,8 +1036,8 @@ sba_mark_clean(struct ioc *ioc, dma_addr_t iova, size_t size)
  *
  * See Documentation/DMA-mapping.txt
  */
-static void sba_unmap_single_attrs(struct device *dev, dma_addr_t iova, size_t size,
-				   int dir, struct dma_attrs *attrs)
+static void sba_unmap_page(struct device *dev, dma_addr_t iova, size_t size,
+			   enum dma_data_direction dir, struct dma_attrs *attrs)
 {
 	struct ioc *ioc;
 #if DELAYED_RESOURCE_CNT > 0
@@ -1095,6 +1105,12 @@ static void sba_unmap_single_attrs(struct device *dev, dma_addr_t iova, size_t s
 #endif /* DELAYED_RESOURCE_CNT == 0 */
 }
 
+void sba_unmap_single_attrs(struct device *dev, dma_addr_t iova, size_t size,
+			    enum dma_data_direction dir, struct dma_attrs *attrs)
+{
+	sba_unmap_page(dev, iova, size, dir, attrs);
+}
+
 /**
  * sba_alloc_coherent - allocate/map shared mem for DMA
  * @dev: instance of PCI owned by the driver that's asking.
@@ -1423,7 +1439,8 @@ sba_coalesce_chunks(struct ioc *ioc, struct device *dev,
  * See Documentation/DMA-mapping.txt
  */
 static int sba_map_sg_attrs(struct device *dev, struct scatterlist *sglist,
-			    int nents, int dir, struct dma_attrs *attrs)
+			    int nents, enum dma_data_direction dir,
+			    struct dma_attrs *attrs)
 {
 	struct ioc *ioc;
 	int coalesced, filled = 0;
@@ -1514,7 +1531,8 @@ static int sba_map_sg_attrs(struct device *dev, struct scatterlist *sglist,
  * See Documentation/DMA-mapping.txt
  */
 static void sba_unmap_sg_attrs(struct device *dev, struct scatterlist *sglist,
-			       int nents, int dir, struct dma_attrs *attrs)
+			       int nents, enum dma_data_direction dir,
+			       struct dma_attrs *attrs)
 {
 #ifdef ASSERT_PDIR_SANITY
 	struct ioc *ioc;
@@ -2062,7 +2080,7 @@ static struct acpi_driver acpi_sba_ioc_driver = {
 	},
 };
 
-extern struct dma_mapping_ops swiotlb_dma_ops;
+extern struct dma_map_ops swiotlb_dma_ops;
 
 static int __init
 sba_init(void)
@@ -2176,18 +2194,18 @@ sba_page_override(char *str)
 
 __setup("sbapagesize=",sba_page_override);
 
-struct dma_mapping_ops sba_dma_ops = {
+struct dma_map_ops sba_dma_ops = {
 	.alloc_coherent		= sba_alloc_coherent,
 	.free_coherent		= sba_free_coherent,
-	.map_single_attrs	= sba_map_single_attrs,
-	.unmap_single_attrs	= sba_unmap_single_attrs,
-	.map_sg_attrs		= sba_map_sg_attrs,
-	.unmap_sg_attrs		= sba_unmap_sg_attrs,
+	.map_page		= sba_map_page,
+	.unmap_page		= sba_unmap_page,
+	.map_sg			= sba_map_sg_attrs,
+	.unmap_sg		= sba_unmap_sg_attrs,
 	.sync_single_for_cpu	= machvec_dma_sync_single,
 	.sync_sg_for_cpu	= machvec_dma_sync_sg,
 	.sync_single_for_device	= machvec_dma_sync_single,
 	.sync_sg_for_device	= machvec_dma_sync_sg,
-	.dma_supported_op	= sba_dma_supported,
+	.dma_supported		= sba_dma_supported,
 	.mapping_error		= sba_dma_mapping_error,
 };
 
diff --git a/arch/ia64/include/asm/dma-mapping.h b/arch/ia64/include/asm/dma-mapping.h
index bac3159..d6230f5 100644
--- a/arch/ia64/include/asm/dma-mapping.h
+++ b/arch/ia64/include/asm/dma-mapping.h
@@ -9,73 +9,21 @@
 #include <linux/scatterlist.h>
 #include <asm/swiotlb.h>
 
-struct dma_mapping_ops {
-	int             (*mapping_error)(struct device *dev,
-					 dma_addr_t dma_addr);
-	void*           (*alloc_coherent)(struct device *dev, size_t size,
-				dma_addr_t *dma_handle, gfp_t gfp);
-	void            (*free_coherent)(struct device *dev, size_t size,
-				void *vaddr, dma_addr_t dma_handle);
-	dma_addr_t      (*map_single)(struct device *hwdev, unsigned long ptr,
-				size_t size, int direction);
-	void            (*unmap_single)(struct device *dev, dma_addr_t addr,
-				size_t size, int direction);
-	dma_addr_t      (*map_single_attrs)(struct device *dev, void *cpu_addr,
-					    size_t size, int direction,
-					    struct dma_attrs *attrs);
-	void		(*unmap_single_attrs)(struct device *dev,
-					      dma_addr_t dma_addr,
-					      size_t size, int direction,
-					      struct dma_attrs *attrs);
-	void            (*sync_single_for_cpu)(struct device *hwdev,
-				dma_addr_t dma_handle, size_t size,
-				int direction);
-	void            (*sync_single_for_device)(struct device *hwdev,
-				dma_addr_t dma_handle, size_t size,
-				int direction);
-	void            (*sync_single_range_for_cpu)(struct device *hwdev,
-				dma_addr_t dma_handle, unsigned long offset,
-				size_t size, int direction);
-	void            (*sync_single_range_for_device)(struct device *hwdev,
-				dma_addr_t dma_handle, unsigned long offset,
-				size_t size, int direction);
-	void            (*sync_sg_for_cpu)(struct device *hwdev,
-				struct scatterlist *sg, int nelems,
-				int direction);
-	void            (*sync_sg_for_device)(struct device *hwdev,
-				struct scatterlist *sg, int nelems,
-				int direction);
-	int             (*map_sg)(struct device *hwdev, struct scatterlist *sg,
-				int nents, int direction);
-	void            (*unmap_sg)(struct device *hwdev,
-				struct scatterlist *sg, int nents,
-				int direction);
-	int             (*map_sg_attrs)(struct device *dev,
-					struct scatterlist *sg, int nents,
-					int direction, struct dma_attrs *attrs);
-	void            (*unmap_sg_attrs)(struct device *dev,
-					  struct scatterlist *sg, int nents,
-					  int direction,
-					  struct dma_attrs *attrs);
-	int             (*dma_supported_op)(struct device *hwdev, u64 mask);
-	int		is_phys;
-};
-
-extern struct dma_mapping_ops *dma_ops;
+extern struct dma_map_ops *dma_ops;
 extern struct ia64_machine_vector ia64_mv;
 extern void set_iommu_machvec(void);
 
 static inline void *dma_alloc_coherent(struct device *dev, size_t size,
 				       dma_addr_t *daddr, gfp_t gfp)
 {
-	struct dma_mapping_ops *ops = platform_dma_get_ops(dev);
+	struct dma_map_ops *ops = platform_dma_get_ops(dev);
 	return ops->alloc_coherent(dev, size, daddr, gfp | GFP_DMA);
 }
 
 static inline void dma_free_coherent(struct device *dev, size_t size,
 				     void *caddr, dma_addr_t daddr)
 {
-	struct dma_mapping_ops *ops = platform_dma_get_ops(dev);
+	struct dma_map_ops *ops = platform_dma_get_ops(dev);
 	ops->free_coherent(dev, size, caddr, daddr);
 }
 
@@ -87,8 +35,10 @@ static inline dma_addr_t dma_map_single_attrs(struct device *dev,
 					      enum dma_data_direction dir,
 					      struct dma_attrs *attrs)
 {
-	struct dma_mapping_ops *ops = platform_dma_get_ops(dev);
-	return ops->map_single_attrs(dev, caddr, size, dir, attrs);
+	struct dma_map_ops *ops = platform_dma_get_ops(dev);
+	return ops->map_page(dev, virt_to_page(caddr),
+			     (unsigned long)caddr & ~PAGE_MASK, size,
+			     dir, attrs);
 }
 
 static inline void dma_unmap_single_attrs(struct device *dev, dma_addr_t daddr,
@@ -96,8 +46,8 @@ static inline void dma_unmap_single_attrs(struct device *dev, dma_addr_t daddr,
 					  enum dma_data_direction dir,
 					  struct dma_attrs *attrs)
 {
-	struct dma_mapping_ops *ops = platform_dma_get_ops(dev);
-	ops->unmap_single_attrs(dev, daddr, size, dir, attrs);
+	struct dma_map_ops *ops = platform_dma_get_ops(dev);
+	ops->unmap_page(dev, daddr, size, dir, attrs);
 }
 
 #define dma_map_single(d, a, s, r) dma_map_single_attrs(d, a, s, r, NULL)
@@ -107,8 +57,8 @@ static inline int dma_map_sg_attrs(struct device *dev, struct scatterlist *sgl,
 				   int nents, enum dma_data_direction dir,
 				   struct dma_attrs *attrs)
 {
-	struct dma_mapping_ops *ops = platform_dma_get_ops(dev);
-	return ops->map_sg_attrs(dev, sgl, nents, dir, attrs);
+	struct dma_map_ops *ops = platform_dma_get_ops(dev);
+	return ops->map_sg(dev, sgl, nents, dir, attrs);
 }
 
 static inline void dma_unmap_sg_attrs(struct device *dev,
@@ -116,8 +66,8 @@ static inline void dma_unmap_sg_attrs(struct device *dev,
 				      enum dma_data_direction dir,
 				      struct dma_attrs *attrs)
 {
-	struct dma_mapping_ops *ops = platform_dma_get_ops(dev);
-	ops->unmap_sg_attrs(dev, sgl, nents, dir, attrs);
+	struct dma_map_ops *ops = platform_dma_get_ops(dev);
+	ops->unmap_sg(dev, sgl, nents, dir, attrs);
 }
 
 #define dma_map_sg(d, s, n, r) dma_map_sg_attrs(d, s, n, r, NULL)
@@ -127,7 +77,7 @@ static inline void dma_sync_single_for_cpu(struct device *dev, dma_addr_t daddr,
 					   size_t size,
 					   enum dma_data_direction dir)
 {
-	struct dma_mapping_ops *ops = platform_dma_get_ops(dev);
+	struct dma_map_ops *ops = platform_dma_get_ops(dev);
 	ops->sync_single_for_cpu(dev, daddr, size, dir);
 }
 
@@ -135,7 +85,7 @@ static inline void dma_sync_sg_for_cpu(struct device *dev,
 				       struct scatterlist *sgl,
 				       int nents, enum dma_data_direction dir)
 {
-	struct dma_mapping_ops *ops = platform_dma_get_ops(dev);
+	struct dma_map_ops *ops = platform_dma_get_ops(dev);
 	ops->sync_sg_for_cpu(dev, sgl, nents, dir);
 }
 
@@ -144,7 +94,7 @@ static inline void dma_sync_single_for_device(struct device *dev,
 					      size_t size,
 					      enum dma_data_direction dir)
 {
-	struct dma_mapping_ops *ops = platform_dma_get_ops(dev);
+	struct dma_map_ops *ops = platform_dma_get_ops(dev);
 	ops->sync_single_for_device(dev, daddr, size, dir);
 }
 
@@ -153,20 +103,29 @@ static inline void dma_sync_sg_for_device(struct device *dev,
 					  int nents,
 					  enum dma_data_direction dir)
 {
-	struct dma_mapping_ops *ops = platform_dma_get_ops(dev);
+	struct dma_map_ops *ops = platform_dma_get_ops(dev);
 	ops->sync_sg_for_device(dev, sgl, nents, dir);
 }
 
 static inline int dma_mapping_error(struct device *dev, dma_addr_t daddr)
 {
-	struct dma_mapping_ops *ops = platform_dma_get_ops(dev);
+	struct dma_map_ops *ops = platform_dma_get_ops(dev);
 	return ops->mapping_error(dev, daddr);
 }
 
-#define dma_map_page(dev, pg, off, size, dir)				\
-	dma_map_single(dev, page_address(pg) + (off), (size), (dir))
-#define dma_unmap_page(dev, dma_addr, size, dir)			\
-	dma_unmap_single(dev, dma_addr, size, dir)
+static inline dma_addr_t dma_map_page(struct device *dev, struct page *page,
+				      size_t offset, size_t size,
+				      enum dma_data_direction dir)
+{
+	struct dma_map_ops *ops = platform_dma_get_ops(dev);
+	return ops->map_page(dev, page, offset, size, dir, NULL);
+}
+
+static inline void dma_unmap_page(struct device *dev, dma_addr_t addr,
+				  size_t size, enum dma_data_direction dir)
+{
+	dma_unmap_single(dev, addr, size, dir);
+}
 
 /*
  * Rest of this file is part of the "Advanced DMA API".  Use at your own risk.
@@ -180,8 +139,8 @@ static inline int dma_mapping_error(struct device *dev, dma_addr_t daddr)
 
 static inline int dma_supported(struct device *dev, u64 mask)
 {
-	struct dma_mapping_ops *ops = platform_dma_get_ops(dev);
-	return ops->dma_supported_op(dev, mask);
+	struct dma_map_ops *ops = platform_dma_get_ops(dev);
+	return ops->dma_supported(dev, mask);
 }
 
 static inline int
diff --git a/arch/ia64/include/asm/machvec.h b/arch/ia64/include/asm/machvec.h
index 95e1708..e8442c7 100644
--- a/arch/ia64/include/asm/machvec.h
+++ b/arch/ia64/include/asm/machvec.h
@@ -11,7 +11,6 @@
 #define _ASM_IA64_MACHVEC_H
 
 #include <linux/types.h>
-#include <linux/swiotlb.h>
 
 /* forward declarations: */
 struct device;
@@ -24,6 +23,7 @@ struct task_struct;
 struct pci_dev;
 struct msi_desc;
 struct dma_attrs;
+enum dma_data_direction;
 
 typedef void ia64_mv_setup_t (char **);
 typedef void ia64_mv_cpu_init_t (void);
@@ -45,7 +45,7 @@ typedef void ia64_mv_kernel_launch_event_t(void);
 
 /* DMA-mapping interface: */
 typedef void ia64_mv_dma_init (void);
-typedef struct dma_mapping_ops *ia64_mv_dma_get_ops(struct device *);
+typedef struct dma_map_ops *ia64_mv_dma_get_ops(struct device *);
 
 /*
  * WARNING: The legacy I/O space is _architected_.  Platforms are
@@ -97,8 +97,10 @@ machvec_noop_bus (struct pci_bus *bus)
 
 extern void machvec_setup (char **);
 extern void machvec_timer_interrupt (int, void *);
-extern void machvec_dma_sync_single (struct device *, dma_addr_t, size_t, int);
-extern void machvec_dma_sync_sg (struct device *, struct scatterlist *, int, int);
+extern void machvec_dma_sync_single(struct device *, dma_addr_t, size_t,
+				    enum dma_data_direction);
+extern void machvec_dma_sync_sg(struct device *, struct scatterlist *, int,
+				enum dma_data_direction);
 extern void machvec_tlb_migrate_finish (struct mm_struct *);
 
 # if defined (CONFIG_IA64_HP_SIM)
@@ -250,7 +252,7 @@ extern void machvec_init_from_cmdline(const char *cmdline);
 # endif /* CONFIG_IA64_GENERIC */
 
 extern void swiotlb_dma_init(void);
-extern struct dma_mapping_ops *dma_get_ops(struct device *);
+extern struct dma_map_ops *dma_get_ops(struct device *);
 
 /*
  * Define default versions so we can extend machvec for new platforms without having
diff --git a/arch/ia64/kernel/dma-mapping.c b/arch/ia64/kernel/dma-mapping.c
index 427f696..7060e13 100644
--- a/arch/ia64/kernel/dma-mapping.c
+++ b/arch/ia64/kernel/dma-mapping.c
@@ -1,9 +1,9 @@
 #include <linux/dma-mapping.h>
 
-struct dma_mapping_ops *dma_ops;
+struct dma_map_ops *dma_ops;
 EXPORT_SYMBOL(dma_ops);
 
-struct dma_mapping_ops *dma_get_ops(struct device *dev)
+struct dma_map_ops *dma_get_ops(struct device *dev)
 {
 	return dma_ops;
 }
diff --git a/arch/ia64/kernel/machvec.c b/arch/ia64/kernel/machvec.c
index 7ccb228..d41a40e 100644
--- a/arch/ia64/kernel/machvec.c
+++ b/arch/ia64/kernel/machvec.c
@@ -1,5 +1,5 @@
 #include <linux/module.h>
-
+#include <linux/dma-mapping.h>
 #include <asm/machvec.h>
 #include <asm/system.h>
 
@@ -75,14 +75,16 @@ machvec_timer_interrupt (int irq, void *dev_id)
 EXPORT_SYMBOL(machvec_timer_interrupt);
 
 void
-machvec_dma_sync_single (struct device *hwdev, dma_addr_t dma_handle, size_t size, int dir)
+machvec_dma_sync_single(struct device *hwdev, dma_addr_t dma_handle, size_t size,
+			enum dma_data_direction dir)
 {
 	mb();
 }
 EXPORT_SYMBOL(machvec_dma_sync_single);
 
 void
-machvec_dma_sync_sg (struct device *hwdev, struct scatterlist *sg, int n, int dir)
+machvec_dma_sync_sg(struct device *hwdev, struct scatterlist *sg, int n,
+		    enum dma_data_direction dir)
 {
 	mb();
 }
diff --git a/arch/ia64/kernel/pci-dma.c b/arch/ia64/kernel/pci-dma.c
index 640669e..b30209e 100644
--- a/arch/ia64/kernel/pci-dma.c
+++ b/arch/ia64/kernel/pci-dma.c
@@ -41,21 +41,7 @@ struct device fallback_dev = {
 	.dma_mask = &fallback_dev.coherent_dma_mask,
 };
 
-extern struct dma_mapping_ops vtd_dma_ops;
-
-void __init pci_iommu_alloc(void)
-{
-	dma_ops = &vtd_dma_ops;
-	/*
-	 * The order of these functions is important for
-	 * fall-back/fail-over reasons
-	 */
-	detect_intel_iommu();
-
-#ifdef CONFIG_SWIOTLB
-	pci_swiotlb_init();
-#endif
-}
+extern struct dma_map_ops intel_dma_ops;
 
 static int __init pci_iommu_init(void)
 {
@@ -81,10 +67,10 @@ iommu_dma_init(void)
 
 int iommu_dma_supported(struct device *dev, u64 mask)
 {
-	struct dma_mapping_ops *ops = platform_dma_get_ops(dev);
+	struct dma_map_ops *ops = platform_dma_get_ops(dev);
 
-	if (ops->dma_supported_op)
-		return ops->dma_supported_op(dev, mask);
+	if (ops->dma_supported)
+		return ops->dma_supported(dev, mask);
 
 	/* Copied from i386. Doesn't make much sense, because it will
 	   only work for pci_alloc_coherent.
@@ -113,4 +99,31 @@ int iommu_dma_supported(struct device *dev, u64 mask)
 }
 EXPORT_SYMBOL(iommu_dma_supported);
 
+static int vtd_dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
+{
+	return 0;
+}
+
+void __init pci_iommu_alloc(void)
+{
+	dma_ops = &intel_dma_ops;
+
+	dma_ops->sync_single_for_cpu = machvec_dma_sync_single;
+	dma_ops->sync_sg_for_cpu = machvec_dma_sync_sg;
+	dma_ops->sync_single_for_device = machvec_dma_sync_single;
+	dma_ops->sync_sg_for_device = machvec_dma_sync_sg;
+	dma_ops->dma_supported = iommu_dma_supported;
+	dma_ops->mapping_error = vtd_dma_mapping_error;
+
+	/*
+	 * The order of these functions is important for
+	 * fall-back/fail-over reasons
+	 */
+	detect_intel_iommu();
+
+#ifdef CONFIG_SWIOTLB
+	pci_swiotlb_init();
+#endif
+}
+
 #endif
diff --git a/arch/ia64/kernel/pci-swiotlb.c b/arch/ia64/kernel/pci-swiotlb.c
index 9f172c8..6bf8f66 100644
--- a/arch/ia64/kernel/pci-swiotlb.c
+++ b/arch/ia64/kernel/pci-swiotlb.c
@@ -16,24 +16,36 @@ EXPORT_SYMBOL(swiotlb);
 /* Set this to 1 if there is a HW IOMMU in the system */
 int iommu_detected __read_mostly;
 
-struct dma_mapping_ops swiotlb_dma_ops = {
+static dma_addr_t swiotlb_map_page(struct device *dev, struct page *page,
+				   unsigned long offset, size_t size,
+				   enum dma_data_direction dir,
+				   struct dma_attrs *attrs)
+{
+	return swiotlb_map_single_attrs(dev, page_address(page) + offset, size,
+					dir, attrs);
+}
+
+static void swiotlb_unmap_page(struct device *dev, dma_addr_t dma_handle,
+			       size_t size, enum dma_data_direction dir,
+			       struct dma_attrs *attrs)
+{
+	swiotlb_unmap_single_attrs(dev, dma_handle, size, dir, attrs);
+}
+
+struct dma_map_ops swiotlb_dma_ops = {
 	.alloc_coherent = swiotlb_alloc_coherent,
 	.free_coherent = swiotlb_free_coherent,
-	.map_single = swiotlb_map_single,
-	.unmap_single = swiotlb_unmap_single,
-	.map_single_attrs = swiotlb_map_single_attrs,
-	.unmap_single_attrs = swiotlb_unmap_single_attrs,
-	.map_sg_attrs = swiotlb_map_sg_attrs,
-	.unmap_sg_attrs	= swiotlb_unmap_sg_attrs,
+	.map_page = swiotlb_map_page,
+	.unmap_page = swiotlb_unmap_page,
+	.map_sg = swiotlb_map_sg_attrs,
+	.unmap_sg = swiotlb_unmap_sg_attrs,
 	.sync_single_for_cpu = swiotlb_sync_single_for_cpu,
 	.sync_single_for_device = swiotlb_sync_single_for_device,
 	.sync_single_range_for_cpu = swiotlb_sync_single_range_for_cpu,
 	.sync_single_range_for_device = swiotlb_sync_single_range_for_device,
 	.sync_sg_for_cpu = swiotlb_sync_sg_for_cpu,
 	.sync_sg_for_device = swiotlb_sync_sg_for_device,
-	.map_sg = swiotlb_map_sg,
-	.unmap_sg = swiotlb_unmap_sg,
-	.dma_supported_op = swiotlb_dma_supported,
+	.dma_supported = swiotlb_dma_supported,
 	.mapping_error = swiotlb_dma_mapping_error,
 };
 
diff --git a/arch/ia64/sn/pci/pci_dma.c b/arch/ia64/sn/pci/pci_dma.c
index efdd694..9c788f9 100644
--- a/arch/ia64/sn/pci/pci_dma.c
+++ b/arch/ia64/sn/pci/pci_dma.c
@@ -10,7 +10,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/dma-attrs.h>
 #include <linux/dma-mapping.h>
 #include <asm/dma.h>
 #include <asm/sn/intr.h>
@@ -171,10 +170,12 @@ static void sn_dma_free_coherent(struct device *dev, size_t size, void *cpu_addr
  * TODO: simplify our interface;
  *       figure out how to save dmamap handle so can use two step.
  */
-static dma_addr_t sn_dma_map_single_attrs(struct device *dev, void *cpu_addr,
-					  size_t size, int direction,
-					  struct dma_attrs *attrs)
+static dma_addr_t sn_dma_map_page(struct device *dev, struct page *page,
+				  unsigned long offset, size_t size,
+				  enum dma_data_direction dir,
+				  struct dma_attrs *attrs)
 {
+	void *cpu_addr = page_address(page) + offset;
 	dma_addr_t dma_addr;
 	unsigned long phys_addr;
 	struct pci_dev *pdev = to_pci_dev(dev);
@@ -212,20 +213,20 @@ static dma_addr_t sn_dma_map_single_attrs(struct device *dev, void *cpu_addr,
  * by @dma_handle into the coherence domain.  On SN, we're always cache
  * coherent, so we just need to free any ATEs associated with this mapping.
  */
-static void sn_dma_unmap_single_attrs(struct device *dev, dma_addr_t dma_addr,
-				      size_t size, int direction,
-				      struct dma_attrs *attrs)
+static void sn_dma_unmap_page(struct device *dev, dma_addr_t dma_addr,
+			      size_t size, enum dma_data_direction dir,
+			      struct dma_attrs *attrs)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct sn_pcibus_provider *provider = SN_PCIDEV_BUSPROVIDER(pdev);
 
 	BUG_ON(dev->bus != &pci_bus_type);
 
-	provider->dma_unmap(pdev, dma_addr, direction);
+	provider->dma_unmap(pdev, dma_addr, dir);
 }
 
 /**
- * sn_dma_unmap_sg_attrs - unmap a DMA scatterlist
+ * sn_dma_unmap_sg - unmap a DMA scatterlist
  * @dev: device to unmap
  * @sg: scatterlist to unmap
  * @nhwentries: number of scatterlist entries
@@ -234,9 +235,9 @@ static void sn_dma_unmap_single_attrs(struct device *dev, dma_addr_t dma_addr,
  *
  * Unmap a set of streaming mode DMA translations.
  */
-static void sn_dma_unmap_sg_attrs(struct device *dev, struct scatterlist *sgl,
-				  int nhwentries, int direction,
-				  struct dma_attrs *attrs)
+static void sn_dma_unmap_sg(struct device *dev, struct scatterlist *sgl,
+			    int nhwentries, enum dma_data_direction dir,
+			    struct dma_attrs *attrs)
 {
 	int i;
 	struct pci_dev *pdev = to_pci_dev(dev);
@@ -246,14 +247,14 @@ static void sn_dma_unmap_sg_attrs(struct device *dev, struct scatterlist *sgl,
 	BUG_ON(dev->bus != &pci_bus_type);
 
 	for_each_sg(sgl, sg, nhwentries, i) {
-		provider->dma_unmap(pdev, sg->dma_address, direction);
+		provider->dma_unmap(pdev, sg->dma_address, dir);
 		sg->dma_address = (dma_addr_t) NULL;
 		sg->dma_length = 0;
 	}
 }
 
 /**
- * sn_dma_map_sg_attrs - map a scatterlist for DMA
+ * sn_dma_map_sg - map a scatterlist for DMA
  * @dev: device to map for
  * @sg: scatterlist to map
  * @nhwentries: number of entries
@@ -267,8 +268,9 @@ static void sn_dma_unmap_sg_attrs(struct device *dev, struct scatterlist *sgl,
  *
  * Maps each entry of @sg for DMA.
  */
-static int sn_dma_map_sg_attrs(struct device *dev, struct scatterlist *sgl,
-			       int nhwentries, int direction, struct dma_attrs *attrs)
+static int sn_dma_map_sg(struct device *dev, struct scatterlist *sgl,
+			 int nhwentries, enum dma_data_direction dir,
+			 struct dma_attrs *attrs)
 {
 	unsigned long phys_addr;
 	struct scatterlist *saved_sg = sgl, *sg;
@@ -305,8 +307,7 @@ static int sn_dma_map_sg_attrs(struct device *dev, struct scatterlist *sgl,
 			 * Free any successfully allocated entries.
 			 */
 			if (i > 0)
-				sn_dma_unmap_sg_attrs(dev, saved_sg, i,
-						      direction, attrs);
+				sn_dma_unmap_sg(dev, saved_sg, i, dir, attrs);
 			return 0;
 		}
 
@@ -317,25 +318,26 @@ static int sn_dma_map_sg_attrs(struct device *dev, struct scatterlist *sgl,
 }
 
 static void sn_dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle,
-				       size_t size, int direction)
+				       size_t size, enum dma_data_direction dir)
 {
 	BUG_ON(dev->bus != &pci_bus_type);
 }
 
 static void sn_dma_sync_single_for_device(struct device *dev, dma_addr_t dma_handle,
-					  size_t size, int direction)
+					  size_t size,
+					  enum dma_data_direction dir)
 {
 	BUG_ON(dev->bus != &pci_bus_type);
 }
 
 static void sn_dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg,
-				   int nelems, int direction)
+				   int nelems, enum dma_data_direction dir)
 {
 	BUG_ON(dev->bus != &pci_bus_type);
 }
 
 static void sn_dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
-				      int nelems, int direction)
+				      int nelems, enum dma_data_direction dir)
 {
 	BUG_ON(dev->bus != &pci_bus_type);
 }
@@ -455,19 +457,19 @@ int sn_pci_legacy_write(struct pci_bus *bus, u16 port, u32 val, u8 size)
 	return ret;
 }
 
-static struct dma_mapping_ops sn_dma_ops = {
+static struct dma_map_ops sn_dma_ops = {
 	.alloc_coherent		= sn_dma_alloc_coherent,
 	.free_coherent		= sn_dma_free_coherent,
-	.map_single_attrs	= sn_dma_map_single_attrs,
-	.unmap_single_attrs	= sn_dma_unmap_single_attrs,
-	.map_sg_attrs		= sn_dma_map_sg_attrs,
-	.unmap_sg_attrs		= sn_dma_unmap_sg_attrs,
+	.map_page		= sn_dma_map_page,
+	.unmap_page		= sn_dma_unmap_page,
+	.map_sg			= sn_dma_map_sg,
+	.unmap_sg		= sn_dma_unmap_sg,
 	.sync_single_for_cpu 	= sn_dma_sync_single_for_cpu,
 	.sync_sg_for_cpu	= sn_dma_sync_sg_for_cpu,
 	.sync_single_for_device = sn_dma_sync_single_for_device,
 	.sync_sg_for_device	= sn_dma_sync_sg_for_device,
 	.mapping_error		= sn_dma_mapping_error,
-	.dma_supported_op	= sn_dma_supported,
+	.dma_supported		= sn_dma_supported,
 };
 
 void sn_dma_init(void)
diff --git a/arch/x86/include/asm/device.h b/arch/x86/include/asm/device.h
index 3c034f4..4994a20 100644
--- a/arch/x86/include/asm/device.h
+++ b/arch/x86/include/asm/device.h
@@ -6,7 +6,7 @@ struct dev_archdata {
 	void	*acpi_handle;
 #endif
 #ifdef CONFIG_X86_64
-struct dma_mapping_ops *dma_ops;
+struct dma_map_ops *dma_ops;
 #endif
 #ifdef CONFIG_DMAR
 	void *iommu; /* hook for IOMMU specific extension */
diff --git a/arch/x86/include/asm/dma-mapping.h b/arch/x86/include/asm/dma-mapping.h
index a0cb867..c59fc6e 100644
--- a/arch/x86/include/asm/dma-mapping.h
+++ b/arch/x86/include/asm/dma-mapping.h
@@ -18,50 +18,9 @@ extern int iommu_merge;
 extern struct device x86_dma_fallback_dev;
 extern int panic_on_overflow;
 
-struct dma_mapping_ops {
-	int             (*mapping_error)(struct device *dev,
-					 dma_addr_t dma_addr);
-	void*           (*alloc_coherent)(struct device *dev, size_t size,
-				dma_addr_t *dma_handle, gfp_t gfp);
-	void            (*free_coherent)(struct device *dev, size_t size,
-				void *vaddr, dma_addr_t dma_handle);
-	void            (*sync_single_for_cpu)(struct device *hwdev,
-				dma_addr_t dma_handle, size_t size,
-				int direction);
-	void            (*sync_single_for_device)(struct device *hwdev,
-				dma_addr_t dma_handle, size_t size,
-				int direction);
-	void            (*sync_single_range_for_cpu)(struct device *hwdev,
-				dma_addr_t dma_handle, unsigned long offset,
-				size_t size, int direction);
-	void            (*sync_single_range_for_device)(struct device *hwdev,
-				dma_addr_t dma_handle, unsigned long offset,
-				size_t size, int direction);
-	void            (*sync_sg_for_cpu)(struct device *hwdev,
-				struct scatterlist *sg, int nelems,
-				int direction);
-	void            (*sync_sg_for_device)(struct device *hwdev,
-				struct scatterlist *sg, int nelems,
-				int direction);
-	int             (*map_sg)(struct device *hwdev, struct scatterlist *sg,
-				int nents, int direction);
-	void            (*unmap_sg)(struct device *hwdev,
-				struct scatterlist *sg, int nents,
-				int direction);
-	dma_addr_t	(*map_page)(struct device *dev, struct page *page,
-				    unsigned long offset, size_t size,
-				    enum dma_data_direction dir,
-				    struct dma_attrs *attrs);
-	void 		(*unmap_page)(struct device *dev, dma_addr_t dma_handle,
-				      size_t size, enum dma_data_direction dir,
-				      struct dma_attrs *attrs);
-	int             (*dma_supported)(struct device *hwdev, u64 mask);
-	int		is_phys;
-};
-
-extern struct dma_mapping_ops *dma_ops;
-
-static inline struct dma_mapping_ops *get_dma_ops(struct device *dev)
+extern struct dma_map_ops *dma_ops;
+
+static inline struct dma_map_ops *get_dma_ops(struct device *dev)
 {
 #ifdef CONFIG_X86_32
 	return dma_ops;
@@ -76,7 +35,7 @@ static inline struct dma_mapping_ops *get_dma_ops(struct device *dev)
 /* Make sure we keep the same behaviour */
 static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
-	struct dma_mapping_ops *ops = get_dma_ops(dev);
+	struct dma_map_ops *ops = get_dma_ops(dev);
 	if (ops->mapping_error)
 		return ops->mapping_error(dev, dma_addr);
 
@@ -95,139 +54,140 @@ extern void *dma_generic_alloc_coherent(struct device *dev, size_t size,
 
 static inline dma_addr_t
 dma_map_single(struct device *hwdev, void *ptr, size_t size,
-	       int direction)
+	       enum dma_data_direction dir)
 {
-	struct dma_mapping_ops *ops = get_dma_ops(hwdev);
+	struct dma_map_ops *ops = get_dma_ops(hwdev);
 
-	BUG_ON(!valid_dma_direction(direction));
+	BUG_ON(!valid_dma_direction(dir));
 	kmemcheck_mark_initialized(ptr, size);
 	return ops->map_page(hwdev, virt_to_page(ptr),
 			     (unsigned long)ptr & ~PAGE_MASK, size,
-			     direction, NULL);
+			     dir, NULL);
 }
 
 static inline void
 dma_unmap_single(struct device *dev, dma_addr_t addr, size_t size,
-		 int direction)
+		 enum dma_data_direction dir)
 {
-	struct dma_mapping_ops *ops = get_dma_ops(dev);
+	struct dma_map_ops *ops = get_dma_ops(dev);
 
-	BUG_ON(!valid_dma_direction(direction));
+	BUG_ON(!valid_dma_direction(dir));
 	if (ops->unmap_page)
-		ops->unmap_page(dev, addr, size, direction, NULL);
+		ops->unmap_page(dev, addr, size, dir, NULL);
 }
 
 static inline int
 dma_map_sg(struct device *hwdev, struct scatterlist *sg,
-	   int nents, int direction)
+	   int nents, enum dma_data_direction dir)
 {
-	struct dma_mapping_ops *ops = get_dma_ops(hwdev);
+	struct dma_map_ops *ops = get_dma_ops(hwdev);
 
-	BUG_ON(!valid_dma_direction(direction));
-	return ops->map_sg(hwdev, sg, nents, direction);
+	BUG_ON(!valid_dma_direction(dir));
+	return ops->map_sg(hwdev, sg, nents, dir, NULL);
 }
 
 static inline void
 dma_unmap_sg(struct device *hwdev, struct scatterlist *sg, int nents,
-	     int direction)
+	     enum dma_data_direction dir)
 {
-	struct dma_mapping_ops *ops = get_dma_ops(hwdev);
+	struct dma_map_ops *ops = get_dma_ops(hwdev);
 
-	BUG_ON(!valid_dma_direction(direction));
+	BUG_ON(!valid_dma_direction(dir));
 	if (ops->unmap_sg)
-		ops->unmap_sg(hwdev, sg, nents, direction);
+		ops->unmap_sg(hwdev, sg, nents, dir, NULL);
 }
 
 static inline void
 dma_sync_single_for_cpu(struct device *hwdev, dma_addr_t dma_handle,
-			size_t size, int direction)
+			size_t size, enum dma_data_direction dir)
 {
-	struct dma_mapping_ops *ops = get_dma_ops(hwdev);
+	struct dma_map_ops *ops = get_dma_ops(hwdev);
 
-	BUG_ON(!valid_dma_direction(direction));
+	BUG_ON(!valid_dma_direction(dir));
 	if (ops->sync_single_for_cpu)
-		ops->sync_single_for_cpu(hwdev, dma_handle, size, direction);
+		ops->sync_single_for_cpu(hwdev, dma_handle, size, dir);
 	flush_write_buffers();
 }
 
 static inline void
 dma_sync_single_for_device(struct device *hwdev, dma_addr_t dma_handle,
-			   size_t size, int direction)
+			   size_t size, enum dma_data_direction dir)
 {
-	struct dma_mapping_ops *ops = get_dma_ops(hwdev);
+	struct dma_map_ops *ops = get_dma_ops(hwdev);
 
-	BUG_ON(!valid_dma_direction(direction));
+	BUG_ON(!valid_dma_direction(dir));
 	if (ops->sync_single_for_device)
-		ops->sync_single_for_device(hwdev, dma_handle, size, direction);
+		ops->sync_single_for_device(hwdev, dma_handle, size, dir);
 	flush_write_buffers();
 }
 
 static inline void
 dma_sync_single_range_for_cpu(struct device *hwdev, dma_addr_t dma_handle,
-			      unsigned long offset, size_t size, int direction)
+			      unsigned long offset, size_t size,
+			      enum dma_data_direction dir)
 {
-	struct dma_mapping_ops *ops = get_dma_ops(hwdev);
+	struct dma_map_ops *ops = get_dma_ops(hwdev);
 
-	BUG_ON(!valid_dma_direction(direction));
+	BUG_ON(!valid_dma_direction(dir));
 	if (ops->sync_single_range_for_cpu)
 		ops->sync_single_range_for_cpu(hwdev, dma_handle, offset,
-					       size, direction);
+					       size, dir);
 	flush_write_buffers();
 }
 
 static inline void
 dma_sync_single_range_for_device(struct device *hwdev, dma_addr_t dma_handle,
 				 unsigned long offset, size_t size,
-				 int direction)
+				 enum dma_data_direction dir)
 {
-	struct dma_mapping_ops *ops = get_dma_ops(hwdev);
+	struct dma_map_ops *ops = get_dma_ops(hwdev);
 
-	BUG_ON(!valid_dma_direction(direction));
+	BUG_ON(!valid_dma_direction(dir));
 	if (ops->sync_single_range_for_device)
 		ops->sync_single_range_for_device(hwdev, dma_handle,
-						  offset, size, direction);
+						  offset, size, dir);
 	flush_write_buffers();
 }
 
 static inline void
 dma_sync_sg_for_cpu(struct device *hwdev, struct scatterlist *sg,
-		    int nelems, int direction)
+		    int nelems, enum dma_data_direction dir)
 {
-	struct dma_mapping_ops *ops = get_dma_ops(hwdev);
+	struct dma_map_ops *ops = get_dma_ops(hwdev);
 
-	BUG_ON(!valid_dma_direction(direction));
+	BUG_ON(!valid_dma_direction(dir));
 	if (ops->sync_sg_for_cpu)
-		ops->sync_sg_for_cpu(hwdev, sg, nelems, direction);
+		ops->sync_sg_for_cpu(hwdev, sg, nelems, dir);
 	flush_write_buffers();
 }
 
 static inline void
 dma_sync_sg_for_device(struct device *hwdev, struct scatterlist *sg,
-		       int nelems, int direction)
+		       int nelems, enum dma_data_direction dir)
 {
-	struct dma_mapping_ops *ops = get_dma_ops(hwdev);
+	struct dma_map_ops *ops = get_dma_ops(hwdev);
 
-	BUG_ON(!valid_dma_direction(direction));
+	BUG_ON(!valid_dma_direction(dir));
 	if (ops->sync_sg_for_device)
-		ops->sync_sg_for_device(hwdev, sg, nelems, direction);
+		ops->sync_sg_for_device(hwdev, sg, nelems, dir);
 
 	flush_write_buffers();
 }
 
 static inline dma_addr_t dma_map_page(struct device *dev, struct page *page,
 				      size_t offset, size_t size,
-				      int direction)
+				      enum dma_data_direction dir)
 {
-	struct dma_mapping_ops *ops = get_dma_ops(dev);
+	struct dma_map_ops *ops = get_dma_ops(dev);
 
-	BUG_ON(!valid_dma_direction(direction));
-	return ops->map_page(dev, page, offset, size, direction, NULL);
+	BUG_ON(!valid_dma_direction(dir));
+	return ops->map_page(dev, page, offset, size, dir, NULL);
 }
 
 static inline void dma_unmap_page(struct device *dev, dma_addr_t addr,
-				  size_t size, int direction)
+				  size_t size, enum dma_data_direction dir)
 {
-	dma_unmap_single(dev, addr, size, direction);
+	dma_unmap_single(dev, addr, size, dir);
 }
 
 static inline void
@@ -273,7 +233,7 @@ static inline void *
 dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
 		gfp_t gfp)
 {
-	struct dma_mapping_ops *ops = get_dma_ops(dev);
+	struct dma_map_ops *ops = get_dma_ops(dev);
 	void *memory;
 
 	gfp &= ~(__GFP_DMA | __GFP_HIGHMEM | __GFP_DMA32);
@@ -299,7 +259,7 @@ dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
 static inline void dma_free_coherent(struct device *dev, size_t size,
 				     void *vaddr, dma_addr_t bus)
 {
-	struct dma_mapping_ops *ops = get_dma_ops(dev);
+	struct dma_map_ops *ops = get_dma_ops(dev);
 
 	WARN_ON(irqs_disabled());       /* for portability */
 
diff --git a/arch/x86/include/asm/iommu.h b/arch/x86/include/asm/iommu.h
index a6ee9e6..af326a2 100644
--- a/arch/x86/include/asm/iommu.h
+++ b/arch/x86/include/asm/iommu.h
@@ -3,7 +3,7 @@
 
 extern void pci_iommu_shutdown(void);
 extern void no_iommu_init(void);
-extern struct dma_mapping_ops nommu_dma_ops;
+extern struct dma_map_ops nommu_dma_ops;
 extern int force_iommu, no_iommu;
 extern int iommu_detected;
 
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index a5dedb6..008e522 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1394,7 +1394,8 @@ static int map_sg_no_iommu(struct device *dev, struct scatterlist *sglist,
  * lists).
  */
 static int map_sg(struct device *dev, struct scatterlist *sglist,
-		  int nelems, int dir)
+		  int nelems, enum dma_data_direction dir,
+		  struct dma_attrs *attrs)
 {
 	unsigned long flags;
 	struct amd_iommu *iommu;
@@ -1461,7 +1462,8 @@ unmap:
  * lists).
  */
 static void unmap_sg(struct device *dev, struct scatterlist *sglist,
-		     int nelems, int dir)
+		     int nelems, enum dma_data_direction dir,
+		     struct dma_attrs *attrs)
 {
 	unsigned long flags;
 	struct amd_iommu *iommu;
@@ -1648,7 +1650,7 @@ static void prealloc_protection_domains(void)
 	}
 }
 
-static struct dma_mapping_ops amd_iommu_dma_ops = {
+static struct dma_map_ops amd_iommu_dma_ops = {
 	.alloc_coherent = alloc_coherent,
 	.free_coherent = free_coherent,
 	.map_page = map_page,
diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index 756138b..755c21e 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -380,8 +380,9 @@ static inline struct iommu_table *find_iommu_table(struct device *dev)
 	return tbl;
 }
 
-static void calgary_unmap_sg(struct device *dev,
-	struct scatterlist *sglist, int nelems, int direction)
+static void calgary_unmap_sg(struct device *dev, struct scatterlist *sglist,
+			     int nelems,enum dma_data_direction dir,
+			     struct dma_attrs *attrs)
 {
 	struct iommu_table *tbl = find_iommu_table(dev);
 	struct scatterlist *s;
@@ -404,7 +405,8 @@ static void calgary_unmap_sg(struct device *dev,
 }
 
 static int calgary_map_sg(struct device *dev, struct scatterlist *sg,
-	int nelems, int direction)
+			  int nelems, enum dma_data_direction dir,
+			  struct dma_attrs *attrs)
 {
 	struct iommu_table *tbl = find_iommu_table(dev);
 	struct scatterlist *s;
@@ -429,15 +431,14 @@ static int calgary_map_sg(struct device *dev, struct scatterlist *sg,
 		s->dma_address = (entry << PAGE_SHIFT) | s->offset;
 
 		/* insert into HW table */
-		tce_build(tbl, entry, npages, vaddr & PAGE_MASK,
-			  direction);
+		tce_build(tbl, entry, npages, vaddr & PAGE_MASK, dir);
 
 		s->dma_length = s->length;
 	}
 
 	return nelems;
 error:
-	calgary_unmap_sg(dev, sg, nelems, direction);
+	calgary_unmap_sg(dev, sg, nelems, dir, NULL);
 	for_each_sg(sg, s, nelems, i) {
 		sg->dma_address = bad_dma_address;
 		sg->dma_length = 0;
@@ -518,7 +519,7 @@ static void calgary_free_coherent(struct device *dev, size_t size,
 	free_pages((unsigned long)vaddr, get_order(size));
 }
 
-static struct dma_mapping_ops calgary_dma_ops = {
+static struct dma_map_ops calgary_dma_ops = {
 	.alloc_coherent = calgary_alloc_coherent,
 	.free_coherent = calgary_free_coherent,
 	.map_sg = calgary_map_sg,
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 19a1044..0d75c12 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -12,7 +12,7 @@
 
 static int forbid_dac __read_mostly;
 
-struct dma_mapping_ops *dma_ops;
+struct dma_map_ops *dma_ops;
 EXPORT_SYMBOL(dma_ops);
 
 static int iommu_sac_force __read_mostly;
@@ -224,7 +224,7 @@ early_param("iommu", iommu_setup);
 
 int dma_supported(struct device *dev, u64 mask)
 {
-	struct dma_mapping_ops *ops = get_dma_ops(dev);
+	struct dma_map_ops *ops = get_dma_ops(dev);
 
 #ifdef CONFIG_PCI
 	if (mask > 0xffffffff && forbid_dac > 0) {
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index 9c557c0..8cb3e45 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -302,8 +302,8 @@ static void gart_unmap_page(struct device *dev, dma_addr_t dma_addr,
 /*
  * Wrapper for pci_unmap_single working with scatterlists.
  */
-static void
-gart_unmap_sg(struct device *dev, struct scatterlist *sg, int nents, int dir)
+static void gart_unmap_sg(struct device *dev, struct scatterlist *sg, int nents,
+			  enum dma_data_direction dir, struct dma_attrs *attrs)
 {
 	struct scatterlist *s;
 	int i;
@@ -333,7 +333,7 @@ static int dma_map_sg_nonforce(struct device *dev, struct scatterlist *sg,
 			addr = dma_map_area(dev, addr, s->length, dir, 0);
 			if (addr == bad_dma_address) {
 				if (i > 0)
-					gart_unmap_sg(dev, sg, i, dir);
+					gart_unmap_sg(dev, sg, i, dir, NULL);
 				nents = 0;
 				sg[0].dma_length = 0;
 				break;
@@ -404,8 +404,8 @@ dma_map_cont(struct device *dev, struct scatterlist *start, int nelems,
  * DMA map all entries in a scatterlist.
  * Merge chunks that have page aligned sizes into a continuous mapping.
  */
-static int
-gart_map_sg(struct device *dev, struct scatterlist *sg, int nents, int dir)
+static int gart_map_sg(struct device *dev, struct scatterlist *sg, int nents,
+		       enum dma_data_direction dir, struct dma_attrs *attrs)
 {
 	struct scatterlist *s, *ps, *start_sg, *sgmap;
 	int need = 0, nextneed, i, out, start;
@@ -472,7 +472,7 @@ gart_map_sg(struct device *dev, struct scatterlist *sg, int nents, int dir)
 
 error:
 	flush_gart();
-	gart_unmap_sg(dev, sg, out, dir);
+	gart_unmap_sg(dev, sg, out, dir, NULL);
 
 	/* When it was forced or merged try again in a dumb way */
 	if (force_iommu || iommu_merge) {
@@ -711,7 +711,7 @@ static __init int init_k8_gatt(struct agp_kern_info *info)
 	return -1;
 }
 
-static struct dma_mapping_ops gart_dma_ops = {
+static struct dma_map_ops gart_dma_ops = {
 	.map_sg				= gart_map_sg,
 	.unmap_sg			= gart_unmap_sg,
 	.map_page			= gart_map_page,
diff --git a/arch/x86/kernel/pci-nommu.c b/arch/x86/kernel/pci-nommu.c
index d42b69c..fe50214 100644
--- a/arch/x86/kernel/pci-nommu.c
+++ b/arch/x86/kernel/pci-nommu.c
@@ -54,7 +54,8 @@ static dma_addr_t nommu_map_page(struct device *dev, struct page *page,
  * the same here.
  */
 static int nommu_map_sg(struct device *hwdev, struct scatterlist *sg,
-	       int nents, int direction)
+			int nents, enum dma_data_direction dir,
+			struct dma_attrs *attrs)
 {
 	struct scatterlist *s;
 	int i;
@@ -78,7 +79,7 @@ static void nommu_free_coherent(struct device *dev, size_t size, void *vaddr,
 	free_pages((unsigned long)vaddr, get_order(size));
 }
 
-struct dma_mapping_ops nommu_dma_ops = {
+struct dma_map_ops nommu_dma_ops = {
 	.alloc_coherent = dma_generic_alloc_coherent,
 	.free_coherent = nommu_free_coherent,
 	.map_sg = nommu_map_sg,
diff --git a/arch/x86/kernel/pci-swiotlb_64.c b/arch/x86/kernel/pci-swiotlb_64.c
index 3ae354c..3f0d992 100644
--- a/arch/x86/kernel/pci-swiotlb_64.c
+++ b/arch/x86/kernel/pci-swiotlb_64.c
@@ -67,7 +67,7 @@ static void *x86_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 	return swiotlb_alloc_coherent(hwdev, size, dma_handle, flags);
 }
 
-struct dma_mapping_ops swiotlb_dma_ops = {
+struct dma_map_ops swiotlb_dma_ops = {
 	.mapping_error = swiotlb_dma_mapping_error,
 	.alloc_coherent = x86_swiotlb_alloc_coherent,
 	.free_coherent = swiotlb_free_coherent,
@@ -77,8 +77,8 @@ struct dma_mapping_ops swiotlb_dma_ops = {
 	.sync_single_range_for_device = swiotlb_sync_single_range_for_device,
 	.sync_sg_for_cpu = swiotlb_sync_sg_for_cpu,
 	.sync_sg_for_device = swiotlb_sync_sg_for_device,
-	.map_sg = swiotlb_map_sg,
-	.unmap_sg = swiotlb_unmap_sg,
+	.map_sg = swiotlb_map_sg_attrs,
+	.unmap_sg = swiotlb_unmap_sg_attrs,
 	.map_page = swiotlb_map_page,
 	.unmap_page = swiotlb_unmap_page,
 	.dma_supported = NULL,
diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index da273e4..b9a5629 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -2441,7 +2441,8 @@ void intel_free_coherent(struct device *hwdev, size_t size, void *vaddr,
 #define SG_ENT_VIRT_ADDRESS(sg)	(sg_virt((sg)))
 
 void intel_unmap_sg(struct device *hwdev, struct scatterlist *sglist,
-		    int nelems, int dir)
+		    int nelems, enum dma_data_direction dir,
+		    struct dma_attrs *attrs)
 {
 	int i;
 	struct pci_dev *pdev = to_pci_dev(hwdev);
@@ -2499,7 +2500,7 @@ static int intel_nontranslate_map_sg(struct device *hddev,
 }
 
 int intel_map_sg(struct device *hwdev, struct scatterlist *sglist, int nelems,
-		 int dir)
+		 enum dma_data_direction dir, struct dma_attrs *attrs)
 {
 	void *addr;
 	int i;
@@ -2579,15 +2580,13 @@ int intel_map_sg(struct device *hwdev, struct scatterlist *sglist, int nelems,
 	return nelems;
 }
 
-static struct dma_mapping_ops intel_dma_ops = {
+struct dma_map_ops intel_dma_ops = {
 	.alloc_coherent = intel_alloc_coherent,
 	.free_coherent = intel_free_coherent,
 	.map_sg = intel_map_sg,
 	.unmap_sg = intel_unmap_sg,
-#ifdef CONFIG_X86_64
 	.map_page = intel_map_page,
 	.unmap_page = intel_unmap_page,
-#endif
 };
 
 static inline int iommu_domain_cache_init(void)
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index c4f6c10..a254db1 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -334,7 +334,9 @@ extern void *intel_alloc_coherent(struct device *, size_t, dma_addr_t *, gfp_t);
 extern void intel_free_coherent(struct device *, size_t, void *, dma_addr_t);
 extern dma_addr_t intel_map_single(struct device *, phys_addr_t, size_t, int);
 extern void intel_unmap_single(struct device *, dma_addr_t, size_t, int);
-extern int intel_map_sg(struct device *, struct scatterlist *, int, int);
-extern void intel_unmap_sg(struct device *, struct scatterlist *, int, int);
+extern int intel_map_sg(struct device *, struct scatterlist *, int,
+			enum dma_data_direction, struct dma_attrs *);
+extern void intel_unmap_sg(struct device *, struct scatterlist *, int,
+			   enum dma_data_direction, struct dma_attrs *);
 
 #endif
diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index dedd3c0..0567c3d 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -66,36 +66,38 @@ swiotlb_unmap_sg(struct device *hwdev, struct scatterlist *sg, int nents,
 
 extern int
 swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl, int nelems,
-		     int dir, struct dma_attrs *attrs);
+		     enum dma_data_direction dir, struct dma_attrs *attrs);
 
 extern void
 swiotlb_unmap_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
-		       int nelems, int dir, struct dma_attrs *attrs);
+		       int nelems, enum dma_data_direction dir,
+		       struct dma_attrs *attrs);
 
 extern void
 swiotlb_sync_single_for_cpu(struct device *hwdev, dma_addr_t dev_addr,
-			    size_t size, int dir);
+			    size_t size, enum dma_data_direction dir);
 
 extern void
 swiotlb_sync_sg_for_cpu(struct device *hwdev, struct scatterlist *sg,
-			int nelems, int dir);
+			int nelems, enum dma_data_direction dir);
 
 extern void
 swiotlb_sync_single_for_device(struct device *hwdev, dma_addr_t dev_addr,
-			       size_t size, int dir);
+			       size_t size, enum dma_data_direction dir);
 
 extern void
 swiotlb_sync_sg_for_device(struct device *hwdev, struct scatterlist *sg,
-			   int nelems, int dir);
+			   int nelems, enum dma_data_direction dir);
 
 extern void
 swiotlb_sync_single_range_for_cpu(struct device *hwdev, dma_addr_t dev_addr,
-				  unsigned long offset, size_t size, int dir);
+				  unsigned long offset, size_t size,
+				  enum dma_data_direction dir);
 
 extern void
 swiotlb_sync_single_range_for_device(struct device *hwdev, dma_addr_t dev_addr,
 				     unsigned long offset, size_t size,
-				     int dir);
+				     enum dma_data_direction dir);
 
 extern int
 swiotlb_dma_mapping_error(struct device *hwdev, dma_addr_t dma_addr);
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 48deef7..d047de9 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -736,7 +736,7 @@ swiotlb_sync_single(struct device *hwdev, dma_addr_t dev_addr,
 
 void
 swiotlb_sync_single_for_cpu(struct device *hwdev, dma_addr_t dev_addr,
-			    size_t size, int dir)
+			    size_t size, enum dma_data_direction dir)
 {
 	swiotlb_sync_single(hwdev, dev_addr, size, dir, SYNC_FOR_CPU);
 }
@@ -744,7 +744,7 @@ EXPORT_SYMBOL(swiotlb_sync_single_for_cpu);
 
 void
 swiotlb_sync_single_for_device(struct device *hwdev, dma_addr_t dev_addr,
-			       size_t size, int dir)
+			       size_t size, enum dma_data_direction dir)
 {
 	swiotlb_sync_single(hwdev, dev_addr, size, dir, SYNC_FOR_DEVICE);
 }
@@ -769,7 +769,8 @@ swiotlb_sync_single_range(struct device *hwdev, dma_addr_t dev_addr,
 
 void
 swiotlb_sync_single_range_for_cpu(struct device *hwdev, dma_addr_t dev_addr,
-				  unsigned long offset, size_t size, int dir)
+				  unsigned long offset, size_t size,
+				  enum dma_data_direction dir)
 {
 	swiotlb_sync_single_range(hwdev, dev_addr, offset, size, dir,
 				  SYNC_FOR_CPU);
@@ -778,7 +779,8 @@ EXPORT_SYMBOL_GPL(swiotlb_sync_single_range_for_cpu);
 
 void
 swiotlb_sync_single_range_for_device(struct device *hwdev, dma_addr_t dev_addr,
-				     unsigned long offset, size_t size, int dir)
+				     unsigned long offset, size_t size,
+				     enum dma_data_direction dir)
 {
 	swiotlb_sync_single_range(hwdev, dev_addr, offset, size, dir,
 				  SYNC_FOR_DEVICE);
@@ -803,7 +805,7 @@ EXPORT_SYMBOL_GPL(swiotlb_sync_single_range_for_device);
  */
 int
 swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl, int nelems,
-		     int dir, struct dma_attrs *attrs)
+		     enum dma_data_direction dir, struct dma_attrs *attrs)
 {
 	struct scatterlist *sg;
 	int i;
@@ -850,7 +852,7 @@ EXPORT_SYMBOL(swiotlb_map_sg);
  */
 void
 swiotlb_unmap_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
-		       int nelems, int dir, struct dma_attrs *attrs)
+		       int nelems, enum dma_data_direction dir, struct dma_attrs *attrs)
 {
 	struct scatterlist *sg;
 	int i;
@@ -902,7 +904,7 @@ swiotlb_sync_sg(struct device *hwdev, struct scatterlist *sgl,
 
 void
 swiotlb_sync_sg_for_cpu(struct device *hwdev, struct scatterlist *sg,
-			int nelems, int dir)
+			int nelems, enum dma_data_direction dir)
 {
 	swiotlb_sync_sg(hwdev, sg, nelems, dir, SYNC_FOR_CPU);
 }
@@ -910,7 +912,7 @@ EXPORT_SYMBOL(swiotlb_sync_sg_for_cpu);
 
 void
 swiotlb_sync_sg_for_device(struct device *hwdev, struct scatterlist *sg,
-			   int nelems, int dir)
+			   int nelems, enum dma_data_direction dir)
 {
 	swiotlb_sync_sg(hwdev, sg, nelems, dir, SYNC_FOR_DEVICE);
 }
-- 
1.6.0.6

