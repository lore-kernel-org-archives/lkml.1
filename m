Return-Path: <linux-kernel-owner+w=401wt.eu-S1751534AbYLSFOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534AbYLSFOk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 00:14:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752356AbYLSFLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 00:11:37 -0500
Received: from az33egw02.freescale.net ([192.88.158.103]:42942 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbYLSFLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 00:11:32 -0500
From: Becky Bruce <beckyb@kernel.crashing.org>
To: mingo@elte.hu, jeremy@goop.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       ian.campbell@citrix.com, jbeulich@novell.com, joerg.roedel@amd.com,
       benh@kernel.crashing.org, Becky Bruce <beckyb@kernel.crashing.org>
Subject: [PATCH 08/11] ia64/x86/swiotlb: use enum dma_data_direciton in dma_ops
Date: Thu, 18 Dec 2008 23:11:19 -0600
Message-Id: <1229663480-10757-9-git-send-email-beckyb@kernel.crashing.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <20081218210231.GB24271@elte.hu>
References: <20081218210231.GB24271@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SWIOTLB currently uses "int" as the type of the dma direction,
not "enum dma_data_direction as documented in DMA_API.txt.  Now that
this code is about to become shared with powerpc, which uses
the enum, update the swiotlb code to use the enum as well. Doing this
requires changing all the arch's that use swiotlb use the enum also.

Signed-off-by: Becky Bruce <beckyb@kernel.crashing.org>
---
 arch/ia64/dig/dig_vtd_iommu.c       |    9 +++--
 arch/ia64/hp/common/hwsw_iommu.c    |   22 ++++++++------
 arch/ia64/hp/common/sba_iommu.c     |   12 ++++---
 arch/ia64/include/asm/dma-mapping.h |   29 +++++++++---------
 arch/ia64/include/asm/swiotlb.h     |   26 ++++++++++------
 arch/ia64/kernel/machvec.c          |    6 ++-
 arch/ia64/sn/kernel/io_common.c     |    3 +-
 arch/ia64/sn/pci/pci_dma.c          |   21 ++++++++-----
 arch/ia64/sn/pci/pcibr/pcibr_dma.c  |    3 +-
 arch/ia64/sn/pci/tioca_provider.c   |    3 +-
 arch/x86/include/asm/dma-mapping.h  |   50 ++++++++++++++++++--------------
 arch/x86/include/asm/swiotlb.h      |   24 +++++++++------
 arch/x86/include/asm/tce.h          |    3 +-
 arch/x86/kernel/amd_iommu.c         |   16 +++++-----
 arch/x86/kernel/pci-calgary_64.c    |   11 ++++---
 arch/x86/kernel/pci-gart_64.c       |   19 ++++++++----
 arch/x86/kernel/pci-nommu.c         |    4 +-
 arch/x86/kernel/pci-swiotlb_64.c    |    2 +-
 arch/x86/kernel/tce_64.c            |    3 +-
 drivers/pci/intel-iommu.c           |   13 ++++----
 include/linux/intel-iommu.h         |   12 +++++--
 include/linux/swiotlb.h             |   33 ++++++++++++---------
 lib/swiotlb.c                       |   54 ++++++++++++++++++++---------------
 23 files changed, 219 insertions(+), 159 deletions(-)

diff --git a/arch/ia64/dig/dig_vtd_iommu.c b/arch/ia64/dig/dig_vtd_iommu.c
index 1c8a079..f22daf6 100644
--- a/arch/ia64/dig/dig_vtd_iommu.c
+++ b/arch/ia64/dig/dig_vtd_iommu.c
@@ -21,7 +21,7 @@ EXPORT_SYMBOL_GPL(vtd_free_coherent);
 
 dma_addr_t
 vtd_map_single_attrs(struct device *dev, void *addr, size_t size,
-		     int dir, struct dma_attrs *attrs)
+		     enum dma_data_direction dir, struct dma_attrs *attrs)
 {
 	return intel_map_single(dev, (phys_addr_t)addr, size, dir);
 }
@@ -29,7 +29,7 @@ EXPORT_SYMBOL_GPL(vtd_map_single_attrs);
 
 void
 vtd_unmap_single_attrs(struct device *dev, dma_addr_t iova, size_t size,
-		       int dir, struct dma_attrs *attrs)
+		       enum dma_data_direction dir, struct dma_attrs *attrs)
 {
 	intel_unmap_single(dev, iova, size, dir);
 }
@@ -37,7 +37,7 @@ EXPORT_SYMBOL_GPL(vtd_unmap_single_attrs);
 
 int
 vtd_map_sg_attrs(struct device *dev, struct scatterlist *sglist, int nents,
-		 int dir, struct dma_attrs *attrs)
+		 enum dma_data_direction dir, struct dma_attrs *attrs)
 {
 	return intel_map_sg(dev, sglist, nents, dir);
 }
@@ -45,7 +45,8 @@ EXPORT_SYMBOL_GPL(vtd_map_sg_attrs);
 
 void
 vtd_unmap_sg_attrs(struct device *dev, struct scatterlist *sglist,
-		   int nents, int dir, struct dma_attrs *attrs)
+		   int nents, enum dma_data_direction dir,
+		   struct dma_attrs *attrs)
 {
 	intel_unmap_sg(dev, sglist, nents, dir);
 }
diff --git a/arch/ia64/hp/common/hwsw_iommu.c b/arch/ia64/hp/common/hwsw_iommu.c
index 2769dbf..fd5af38 100644
--- a/arch/ia64/hp/common/hwsw_iommu.c
+++ b/arch/ia64/hp/common/hwsw_iommu.c
@@ -91,8 +91,8 @@ hwsw_free_coherent (struct device *dev, size_t size, void *vaddr, dma_addr_t dma
 }
 
 dma_addr_t
-hwsw_map_single_attrs(struct device *dev, void *addr, size_t size, int dir,
-		       struct dma_attrs *attrs)
+hwsw_map_single_attrs(struct device *dev, void *addr, size_t size,
+		      enum dma_data_direction dir, struct dma_attrs *attrs)
 {
 	if (use_swiotlb(dev))
 		return swiotlb_map_single_attrs(dev, addr, size, dir, attrs);
@@ -103,7 +103,7 @@ EXPORT_SYMBOL(hwsw_map_single_attrs);
 
 void
 hwsw_unmap_single_attrs(struct device *dev, dma_addr_t iova, size_t size,
-			 int dir, struct dma_attrs *attrs)
+			 enum dma_data_direction dir, struct dma_attrs *attrs)
 {
 	if (use_swiotlb(dev))
 		return swiotlb_unmap_single_attrs(dev, iova, size, dir, attrs);
@@ -114,7 +114,7 @@ EXPORT_SYMBOL(hwsw_unmap_single_attrs);
 
 int
 hwsw_map_sg_attrs(struct device *dev, struct scatterlist *sglist, int nents,
-		   int dir, struct dma_attrs *attrs)
+		   enum dma_data_direction dir, struct dma_attrs *attrs)
 {
 	if (use_swiotlb(dev))
 		return swiotlb_map_sg_attrs(dev, sglist, nents, dir, attrs);
@@ -125,7 +125,7 @@ EXPORT_SYMBOL(hwsw_map_sg_attrs);
 
 void
 hwsw_unmap_sg_attrs(struct device *dev, struct scatterlist *sglist, int nents,
-		     int dir, struct dma_attrs *attrs)
+		     enum dma_data_direction dir, struct dma_attrs *attrs)
 {
 	if (use_swiotlb(dev))
 		return swiotlb_unmap_sg_attrs(dev, sglist, nents, dir, attrs);
@@ -135,7 +135,8 @@ hwsw_unmap_sg_attrs(struct device *dev, struct scatterlist *sglist, int nents,
 EXPORT_SYMBOL(hwsw_unmap_sg_attrs);
 
 void
-hwsw_sync_single_for_cpu (struct device *dev, dma_addr_t addr, size_t size, int dir)
+hwsw_sync_single_for_cpu (struct device *dev, dma_addr_t addr, size_t size,
+			  enum dma_data_direction dir)
 {
 	if (use_swiotlb(dev))
 		swiotlb_sync_single_for_cpu(dev, addr, size, dir);
@@ -144,7 +145,8 @@ hwsw_sync_single_for_cpu (struct device *dev, dma_addr_t addr, size_t size, int
 }
 
 void
-hwsw_sync_sg_for_cpu (struct device *dev, struct scatterlist *sg, int nelems, int dir)
+hwsw_sync_sg_for_cpu (struct device *dev, struct scatterlist *sg, int nelems,
+		      enum dma_data_direction dir)
 {
 	if (use_swiotlb(dev))
 		swiotlb_sync_sg_for_cpu(dev, sg, nelems, dir);
@@ -153,7 +155,8 @@ hwsw_sync_sg_for_cpu (struct device *dev, struct scatterlist *sg, int nelems, in
 }
 
 void
-hwsw_sync_single_for_device (struct device *dev, dma_addr_t addr, size_t size, int dir)
+hwsw_sync_single_for_device (struct device *dev, dma_addr_t addr, size_t size,
+			     enum dma_data_direction dir)
 {
 	if (use_swiotlb(dev))
 		swiotlb_sync_single_for_device(dev, addr, size, dir);
@@ -162,7 +165,8 @@ hwsw_sync_single_for_device (struct device *dev, dma_addr_t addr, size_t size, i
 }
 
 void
-hwsw_sync_sg_for_device (struct device *dev, struct scatterlist *sg, int nelems, int dir)
+hwsw_sync_sg_for_device (struct device *dev, struct scatterlist *sg, int nelems,
+			 enum dma_data_direction dir)
 {
 	if (use_swiotlb(dev))
 		swiotlb_sync_sg_for_device(dev, sg, nelems, dir);
diff --git a/arch/ia64/hp/common/sba_iommu.c b/arch/ia64/hp/common/sba_iommu.c
index d98f0f4..84fe18f 100644
--- a/arch/ia64/hp/common/sba_iommu.c
+++ b/arch/ia64/hp/common/sba_iommu.c
@@ -909,8 +909,8 @@ sba_mark_invalid(struct ioc *ioc, dma_addr_t iova, size_t byte_cnt)
  * See Documentation/DMA-mapping.txt
  */
 dma_addr_t
-sba_map_single_attrs(struct device *dev, void *addr, size_t size, int dir,
-		     struct dma_attrs *attrs)
+sba_map_single_attrs(struct device *dev, void *addr, size_t size,
+		     enum dma_data_direction dir, struct dma_attrs *attrs)
 {
 	struct ioc *ioc;
 	dma_addr_t iovp;
@@ -1027,7 +1027,8 @@ sba_mark_clean(struct ioc *ioc, dma_addr_t iova, size_t size)
  * See Documentation/DMA-mapping.txt
  */
 void sba_unmap_single_attrs(struct device *dev, dma_addr_t iova, size_t size,
-			    int dir, struct dma_attrs *attrs)
+			    enum dma_data_direction dir,
+			    struct dma_attrs *attrs)
 {
 	struct ioc *ioc;
 #if DELAYED_RESOURCE_CNT > 0
@@ -1423,7 +1424,7 @@ sba_coalesce_chunks(struct ioc *ioc, struct device *dev,
  * See Documentation/DMA-mapping.txt
  */
 int sba_map_sg_attrs(struct device *dev, struct scatterlist *sglist, int nents,
-		     int dir, struct dma_attrs *attrs)
+		     enum dma_data_direction dir, struct dma_attrs *attrs)
 {
 	struct ioc *ioc;
 	int coalesced, filled = 0;
@@ -1515,7 +1516,8 @@ EXPORT_SYMBOL(sba_map_sg_attrs);
  * See Documentation/DMA-mapping.txt
  */
 void sba_unmap_sg_attrs(struct device *dev, struct scatterlist *sglist,
-			int nents, int dir, struct dma_attrs *attrs)
+			int nents, enum dma_data_direction dir,
+			struct dma_attrs *attrs)
 {
 #ifdef ASSERT_PDIR_SANITY
 	struct ioc *ioc;
diff --git a/arch/ia64/include/asm/dma-mapping.h b/arch/ia64/include/asm/dma-mapping.h
index bbab7e2..7452354 100644
--- a/arch/ia64/include/asm/dma-mapping.h
+++ b/arch/ia64/include/asm/dma-mapping.h
@@ -17,32 +17,32 @@ struct dma_mapping_ops {
 	void            (*free_coherent)(struct device *dev, size_t size,
 				void *vaddr, dma_addr_t dma_handle);
 	dma_addr_t      (*map_single)(struct device *hwdev, unsigned long ptr,
-				size_t size, int direction);
+				size_t size, enum dma_data_direction direction);
 	void            (*unmap_single)(struct device *dev, dma_addr_t addr,
-				size_t size, int direction);
+				size_t size, enum dma_data_direction direction);
 	void            (*sync_single_for_cpu)(struct device *hwdev,
 				dma_addr_t dma_handle, size_t size,
-				int direction);
+				enum dma_data_direction direction);
 	void            (*sync_single_for_device)(struct device *hwdev,
 				dma_addr_t dma_handle, size_t size,
-				int direction);
+				enum dma_data_direction direction);
 	void            (*sync_single_range_for_cpu)(struct device *hwdev,
 				dma_addr_t dma_handle, unsigned long offset,
-				size_t size, int direction);
+				size_t size, enum dma_data_direction direction);
 	void            (*sync_single_range_for_device)(struct device *hwdev,
 				dma_addr_t dma_handle, unsigned long offset,
-				size_t size, int direction);
+				size_t size, enum dma_data_direction direction);
 	void            (*sync_sg_for_cpu)(struct device *hwdev,
 				struct scatterlist *sg, int nelems,
-				int direction);
+				enum dma_data_direction direction);
 	void            (*sync_sg_for_device)(struct device *hwdev,
 				struct scatterlist *sg, int nelems,
-				int direction);
+				enum dma_data_direction direction);
 	int             (*map_sg)(struct device *hwdev, struct scatterlist *sg,
-				int nents, int direction);
+				int nents, enum dma_data_direction direction);
 	void            (*unmap_sg)(struct device *hwdev,
 				struct scatterlist *sg, int nents,
-				int direction);
+				enum dma_data_direction direction);
 	int             (*dma_supported_op)(struct device *hwdev, u64 mask);
 	int		is_phys;
 };
@@ -70,25 +70,26 @@ dma_free_noncoherent(struct device *dev, size_t size, void *cpu_addr,
 }
 #define dma_map_single_attrs	platform_dma_map_single_attrs
 static inline dma_addr_t dma_map_single(struct device *dev, void *cpu_addr,
-					size_t size, int dir)
+					size_t size,
+					enum dma_data_direction dir)
 {
 	return dma_map_single_attrs(dev, cpu_addr, size, dir, NULL);
 }
 #define dma_map_sg_attrs	platform_dma_map_sg_attrs
 static inline int dma_map_sg(struct device *dev, struct scatterlist *sgl,
-			     int nents, int dir)
+			     int nents, enum dma_data_direction dir)
 {
 	return dma_map_sg_attrs(dev, sgl, nents, dir, NULL);
 }
 #define dma_unmap_single_attrs	platform_dma_unmap_single_attrs
 static inline void dma_unmap_single(struct device *dev, dma_addr_t cpu_addr,
-				    size_t size, int dir)
+				    size_t size, enum dma_data_direction dir)
 {
 	return dma_unmap_single_attrs(dev, cpu_addr, size, dir, NULL);
 }
 #define dma_unmap_sg_attrs	platform_dma_unmap_sg_attrs
 static inline void dma_unmap_sg(struct device *dev, struct scatterlist *sgl,
-				int nents, int dir)
+				int nents, enum dma_data_direction dir)
 {
 	return dma_unmap_sg_attrs(dev, sgl, nents, dir, NULL);
 }
diff --git a/arch/ia64/include/asm/swiotlb.h b/arch/ia64/include/asm/swiotlb.h
index fb79423..81c5629 100644
--- a/arch/ia64/include/asm/swiotlb.h
+++ b/arch/ia64/include/asm/swiotlb.h
@@ -6,35 +6,41 @@
 /* SWIOTLB interface */
 
 extern dma_addr_t swiotlb_map_single(struct device *hwdev, void *ptr,
-				     size_t size, int dir);
+				     size_t size,
+				     enum dma_data_direction  dir);
 extern void *swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 				    dma_addr_t *dma_handle, gfp_t flags);
 extern void swiotlb_unmap_single(struct device *hwdev, dma_addr_t dev_addr,
-				 size_t size, int dir);
+				 size_t size,
+				 enum dma_data_direction  dir);
 extern void swiotlb_sync_single_for_cpu(struct device *hwdev,
 					dma_addr_t dev_addr,
-					size_t size, int dir);
+					size_t size,
+					enum dma_data_direction dir);
 extern void swiotlb_sync_single_for_device(struct device *hwdev,
 					   dma_addr_t dev_addr,
-					   size_t size, int dir);
+					   size_t size,
+					   enum dma_data_direction dir);
 extern void swiotlb_sync_single_range_for_cpu(struct device *hwdev,
 					      dma_addr_t dev_addr,
 					      unsigned long offset,
-					      size_t size, int dir);
+					      size_t size,
+					      enum dma_data_direction dir);
 extern void swiotlb_sync_single_range_for_device(struct device *hwdev,
 						 dma_addr_t dev_addr,
 						 unsigned long offset,
-						 size_t size, int dir);
+						 size_t size,
+						 enum dma_data_direction dir);
 extern void swiotlb_sync_sg_for_cpu(struct device *hwdev,
 				    struct scatterlist *sg, int nelems,
-				    int dir);
+				    enum dma_data_direction dir);
 extern void swiotlb_sync_sg_for_device(struct device *hwdev,
 				       struct scatterlist *sg, int nelems,
-				       int dir);
+				       enum dma_data_direction dir);
 extern int swiotlb_map_sg(struct device *hwdev, struct scatterlist *sg,
-			  int nents, int direction);
+			  int nents, enum dma_data_direction direction);
 extern void swiotlb_unmap_sg(struct device *hwdev, struct scatterlist *sg,
-			     int nents, int direction);
+			     int nents, enum dma_data_direction direction);
 extern int swiotlb_dma_mapping_error(struct device *hwdev, dma_addr_t dma_addr);
 extern void swiotlb_free_coherent(struct device *hwdev, size_t size,
 				  void *vaddr, dma_addr_t dma_handle);
diff --git a/arch/ia64/kernel/machvec.c b/arch/ia64/kernel/machvec.c
index 7ccb228..2c0f867 100644
--- a/arch/ia64/kernel/machvec.c
+++ b/arch/ia64/kernel/machvec.c
@@ -75,14 +75,16 @@ machvec_timer_interrupt (int irq, void *dev_id)
 EXPORT_SYMBOL(machvec_timer_interrupt);
 
 void
-machvec_dma_sync_single (struct device *hwdev, dma_addr_t dma_handle, size_t size, int dir)
+machvec_dma_sync_single (struct device *hwdev, dma_addr_t dma_handle,
+			 size_t size, enum dma_data_direction dir)
 {
 	mb();
 }
 EXPORT_SYMBOL(machvec_dma_sync_single);
 
 void
-machvec_dma_sync_sg (struct device *hwdev, struct scatterlist *sg, int n, int dir)
+machvec_dma_sync_sg (struct device *hwdev, struct scatterlist *sg, int n,
+		     enum dma_data_direction dir)
 {
 	mb();
 }
diff --git a/arch/ia64/sn/kernel/io_common.c b/arch/ia64/sn/kernel/io_common.c
index 8a924a5..c8c2b04 100644
--- a/arch/ia64/sn/kernel/io_common.c
+++ b/arch/ia64/sn/kernel/io_common.c
@@ -60,7 +60,8 @@ sn_default_pci_map(struct pci_dev *pdev, unsigned long paddr, size_t size, int t
 }
 
 static void
-sn_default_pci_unmap(struct pci_dev *pdev, dma_addr_t addr, int direction)
+sn_default_pci_unmap(struct pci_dev *pdev, dma_addr_t addr,
+		     enum dma_data_direction direction)
 {
 	return;
 }
diff --git a/arch/ia64/sn/pci/pci_dma.c b/arch/ia64/sn/pci/pci_dma.c
index 53ebb64..87e903d 100644
--- a/arch/ia64/sn/pci/pci_dma.c
+++ b/arch/ia64/sn/pci/pci_dma.c
@@ -174,7 +174,8 @@ EXPORT_SYMBOL(sn_dma_free_coherent);
  *       figure out how to save dmamap handle so can use two step.
  */
 dma_addr_t sn_dma_map_single_attrs(struct device *dev, void *cpu_addr,
-				   size_t size, int direction,
+				   size_t size,
+				   enum dma_data_direction direction,
 				   struct dma_attrs *attrs)
 {
 	dma_addr_t dma_addr;
@@ -216,7 +217,8 @@ EXPORT_SYMBOL(sn_dma_map_single_attrs);
  * coherent, so we just need to free any ATEs associated with this mapping.
  */
 void sn_dma_unmap_single_attrs(struct device *dev, dma_addr_t dma_addr,
-			       size_t size, int direction,
+			       size_t size,
+			       enum dma_data_direction direction,
 			       struct dma_attrs *attrs)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
@@ -239,7 +241,7 @@ EXPORT_SYMBOL(sn_dma_unmap_single_attrs);
  * Unmap a set of streaming mode DMA translations.
  */
 void sn_dma_unmap_sg_attrs(struct device *dev, struct scatterlist *sgl,
-			   int nhwentries, int direction,
+			   int nhwentries, enum dma_data_direction direction,
 			   struct dma_attrs *attrs)
 {
 	int i;
@@ -273,7 +275,8 @@ EXPORT_SYMBOL(sn_dma_unmap_sg_attrs);
  * Maps each entry of @sg for DMA.
  */
 int sn_dma_map_sg_attrs(struct device *dev, struct scatterlist *sgl,
-			int nhwentries, int direction, struct dma_attrs *attrs)
+			int nhwentries, enum dma_data_direction direction,
+			struct dma_attrs *attrs)
 {
 	unsigned long phys_addr;
 	struct scatterlist *saved_sg = sgl, *sg;
@@ -323,28 +326,30 @@ int sn_dma_map_sg_attrs(struct device *dev, struct scatterlist *sgl,
 EXPORT_SYMBOL(sn_dma_map_sg_attrs);
 
 void sn_dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle,
-				size_t size, int direction)
+				size_t size,
+				enum dma_data_direction direction)
 {
 	BUG_ON(dev->bus != &pci_bus_type);
 }
 EXPORT_SYMBOL(sn_dma_sync_single_for_cpu);
 
 void sn_dma_sync_single_for_device(struct device *dev, dma_addr_t dma_handle,
-				   size_t size, int direction)
+				   size_t size,
+				   enum dma_data_direction direction)
 {
 	BUG_ON(dev->bus != &pci_bus_type);
 }
 EXPORT_SYMBOL(sn_dma_sync_single_for_device);
 
 void sn_dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg,
-			    int nelems, int direction)
+			    int nelems, enum dma_data_direction direction)
 {
 	BUG_ON(dev->bus != &pci_bus_type);
 }
 EXPORT_SYMBOL(sn_dma_sync_sg_for_cpu);
 
 void sn_dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
-			       int nelems, int direction)
+			       int nelems, enum dma_data_direction direction)
 {
 	BUG_ON(dev->bus != &pci_bus_type);
 }
diff --git a/arch/ia64/sn/pci/pcibr/pcibr_dma.c b/arch/ia64/sn/pci/pcibr/pcibr_dma.c
index e626e50..c87d57e 100644
--- a/arch/ia64/sn/pci/pcibr/pcibr_dma.c
+++ b/arch/ia64/sn/pci/pcibr/pcibr_dma.c
@@ -205,7 +205,8 @@ pcibr_dmatrans_direct32(struct pcidev_info * info,
  * DMA mappings for Direct 64 and 32 do not have any DMA maps.
  */
 void
-pcibr_dma_unmap(struct pci_dev *hwdev, dma_addr_t dma_handle, int direction)
+pcibr_dma_unmap(struct pci_dev *hwdev, dma_addr_t dma_handle,
+		enum dma_data_direction direction)
 {
 	struct pcidev_info *pcidev_info = SN_PCIDEV_INFO(hwdev);
 	struct pcibus_info *pcibus_info =
diff --git a/arch/ia64/sn/pci/tioca_provider.c b/arch/ia64/sn/pci/tioca_provider.c
index 7916512..64b46f3 100644
--- a/arch/ia64/sn/pci/tioca_provider.c
+++ b/arch/ia64/sn/pci/tioca_provider.c
@@ -467,7 +467,8 @@ map_return:
  * resources to release.
  */
 static void
-tioca_dma_unmap(struct pci_dev *pdev, dma_addr_t bus_addr, int dir)
+tioca_dma_unmap(struct pci_dev *pdev, dma_addr_t bus_addr,
+		enum dma_data_direction dir)
 {
 	int i, entry;
 	struct tioca_common *tioca_common;
diff --git a/arch/x86/include/asm/dma-mapping.h b/arch/x86/include/asm/dma-mapping.h
index 40d155d..84c7e77 100644
--- a/arch/x86/include/asm/dma-mapping.h
+++ b/arch/x86/include/asm/dma-mapping.h
@@ -25,32 +25,36 @@ struct dma_mapping_ops {
 	void            (*free_coherent)(struct device *dev, size_t size,
 				void *vaddr, dma_addr_t dma_handle);
 	dma_addr_t      (*map_single)(struct device *hwdev, phys_addr_t ptr,
-				size_t size, int direction);
+				size_t size,
+				enum dma_data_direction direction);
 	void            (*unmap_single)(struct device *dev, dma_addr_t addr,
-				size_t size, int direction);
+				size_t size,
+				enum dma_data_direction direction);
 	void            (*sync_single_for_cpu)(struct device *hwdev,
 				dma_addr_t dma_handle, size_t size,
-				int direction);
+				enum dma_data_direction direction);
 	void            (*sync_single_for_device)(struct device *hwdev,
 				dma_addr_t dma_handle, size_t size,
-				int direction);
+				enum dma_data_direction direction);
 	void            (*sync_single_range_for_cpu)(struct device *hwdev,
 				dma_addr_t dma_handle, unsigned long offset,
-				size_t size, int direction);
+				size_t size,
+				enum dma_data_direction direction);
 	void            (*sync_single_range_for_device)(struct device *hwdev,
 				dma_addr_t dma_handle, unsigned long offset,
-				size_t size, int direction);
+				size_t size,
+				enum dma_data_direction direction);
 	void            (*sync_sg_for_cpu)(struct device *hwdev,
 				struct scatterlist *sg, int nelems,
-				int direction);
+				enum dma_data_direction direction);
 	void            (*sync_sg_for_device)(struct device *hwdev,
 				struct scatterlist *sg, int nelems,
-				int direction);
+				enum dma_data_direction direction);
 	int             (*map_sg)(struct device *hwdev, struct scatterlist *sg,
-				int nents, int direction);
+				int nents, enum dma_data_direction direction);
 	void            (*unmap_sg)(struct device *hwdev,
 				struct scatterlist *sg, int nents,
-				int direction);
+				enum dma_data_direction direction);
 	int             (*dma_supported)(struct device *hwdev, u64 mask);
 	int		is_phys;
 };
@@ -91,7 +95,7 @@ extern void *dma_generic_alloc_coherent(struct device *dev, size_t size,
 
 static inline dma_addr_t
 dma_map_single(struct device *hwdev, void *ptr, size_t size,
-	       int direction)
+	       enum dma_data_direction direction)
 {
 	struct dma_mapping_ops *ops = get_dma_ops(hwdev);
 
@@ -102,7 +106,7 @@ dma_map_single(struct device *hwdev, void *ptr, size_t size,
 
 static inline void
 dma_unmap_single(struct device *dev, dma_addr_t addr, size_t size,
-		 int direction)
+		 enum dma_data_direction direction)
 {
 	struct dma_mapping_ops *ops = get_dma_ops(dev);
 
@@ -113,7 +117,7 @@ dma_unmap_single(struct device *dev, dma_addr_t addr, size_t size,
 
 static inline int
 dma_map_sg(struct device *hwdev, struct scatterlist *sg,
-	   int nents, int direction)
+	   int nents, enum dma_data_direction direction)
 {
 	struct dma_mapping_ops *ops = get_dma_ops(hwdev);
 
@@ -123,7 +127,7 @@ dma_map_sg(struct device *hwdev, struct scatterlist *sg,
 
 static inline void
 dma_unmap_sg(struct device *hwdev, struct scatterlist *sg, int nents,
-	     int direction)
+	     enum dma_data_direction direction)
 {
 	struct dma_mapping_ops *ops = get_dma_ops(hwdev);
 
@@ -134,7 +138,7 @@ dma_unmap_sg(struct device *hwdev, struct scatterlist *sg, int nents,
 
 static inline void
 dma_sync_single_for_cpu(struct device *hwdev, dma_addr_t dma_handle,
-			size_t size, int direction)
+			size_t size, enum dma_data_direction direction)
 {
 	struct dma_mapping_ops *ops = get_dma_ops(hwdev);
 
@@ -146,7 +150,7 @@ dma_sync_single_for_cpu(struct device *hwdev, dma_addr_t dma_handle,
 
 static inline void
 dma_sync_single_for_device(struct device *hwdev, dma_addr_t dma_handle,
-			   size_t size, int direction)
+			   size_t size, enum dma_data_direction direction)
 {
 	struct dma_mapping_ops *ops = get_dma_ops(hwdev);
 
@@ -158,7 +162,8 @@ dma_sync_single_for_device(struct device *hwdev, dma_addr_t dma_handle,
 
 static inline void
 dma_sync_single_range_for_cpu(struct device *hwdev, dma_addr_t dma_handle,
-			      unsigned long offset, size_t size, int direction)
+			      unsigned long offset, size_t size,
+			      enum dma_data_direction direction)
 {
 	struct dma_mapping_ops *ops = get_dma_ops(hwdev);
 
@@ -172,7 +177,7 @@ dma_sync_single_range_for_cpu(struct device *hwdev, dma_addr_t dma_handle,
 static inline void
 dma_sync_single_range_for_device(struct device *hwdev, dma_addr_t dma_handle,
 				 unsigned long offset, size_t size,
-				 int direction)
+				 enum dma_data_direction direction)
 {
 	struct dma_mapping_ops *ops = get_dma_ops(hwdev);
 
@@ -185,7 +190,7 @@ dma_sync_single_range_for_device(struct device *hwdev, dma_addr_t dma_handle,
 
 static inline void
 dma_sync_sg_for_cpu(struct device *hwdev, struct scatterlist *sg,
-		    int nelems, int direction)
+		    int nelems, enum dma_data_direction direction)
 {
 	struct dma_mapping_ops *ops = get_dma_ops(hwdev);
 
@@ -197,7 +202,7 @@ dma_sync_sg_for_cpu(struct device *hwdev, struct scatterlist *sg,
 
 static inline void
 dma_sync_sg_for_device(struct device *hwdev, struct scatterlist *sg,
-		       int nelems, int direction)
+		       int nelems, enum dma_data_direction direction)
 {
 	struct dma_mapping_ops *ops = get_dma_ops(hwdev);
 
@@ -210,7 +215,7 @@ dma_sync_sg_for_device(struct device *hwdev, struct scatterlist *sg,
 
 static inline dma_addr_t dma_map_page(struct device *dev, struct page *page,
 				      size_t offset, size_t size,
-				      int direction)
+				      enum dma_data_direction direction)
 {
 	struct dma_mapping_ops *ops = get_dma_ops(dev);
 
@@ -220,7 +225,8 @@ static inline dma_addr_t dma_map_page(struct device *dev, struct page *page,
 }
 
 static inline void dma_unmap_page(struct device *dev, dma_addr_t addr,
-				  size_t size, int direction)
+				  size_t size,
+				  enum dma_data_direction direction)
 {
 	dma_unmap_single(dev, addr, size, direction);
 }
diff --git a/arch/x86/include/asm/swiotlb.h b/arch/x86/include/asm/swiotlb.h
index 51fb2c7..c51b25e 100644
--- a/arch/x86/include/asm/swiotlb.h
+++ b/arch/x86/include/asm/swiotlb.h
@@ -6,35 +6,39 @@
 /* SWIOTLB interface */
 
 extern dma_addr_t swiotlb_map_single(struct device *hwdev, void *ptr,
-				     size_t size, int dir);
+				     size_t size, enum dma_data_direction dir);
 extern void *swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 				    dma_addr_t *dma_handle, gfp_t flags);
 extern void swiotlb_unmap_single(struct device *hwdev, dma_addr_t dev_addr,
-				 size_t size, int dir);
+				 size_t size, enum dma_data_direction dir);
 extern void swiotlb_sync_single_for_cpu(struct device *hwdev,
 					dma_addr_t dev_addr,
-					size_t size, int dir);
+					size_t size,
+					enum dma_data_direction dir);
 extern void swiotlb_sync_single_for_device(struct device *hwdev,
 					   dma_addr_t dev_addr,
-					   size_t size, int dir);
+					   size_t size,
+					   enum dma_data_direction dir);
 extern void swiotlb_sync_single_range_for_cpu(struct device *hwdev,
 					      dma_addr_t dev_addr,
 					      unsigned long offset,
-					      size_t size, int dir);
+					      size_t size,
+					      enum dma_data_direction dir);
 extern void swiotlb_sync_single_range_for_device(struct device *hwdev,
 						 dma_addr_t dev_addr,
 						 unsigned long offset,
-						 size_t size, int dir);
+						 size_t size,
+						 enum dma_data_direction dir);
 extern void swiotlb_sync_sg_for_cpu(struct device *hwdev,
 				    struct scatterlist *sg, int nelems,
-				    int dir);
+				    enum dma_data_direction dir);
 extern void swiotlb_sync_sg_for_device(struct device *hwdev,
 				       struct scatterlist *sg, int nelems,
-				       int dir);
+				       enum dma_data_direction dir);
 extern int swiotlb_map_sg(struct device *hwdev, struct scatterlist *sg,
-			  int nents, int direction);
+			  int nents, enum dma_data_direction direction);
 extern void swiotlb_unmap_sg(struct device *hwdev, struct scatterlist *sg,
-			     int nents, int direction);
+			     int nents, enum dma_data_direction direction);
 extern int swiotlb_dma_mapping_error(struct device *hwdev, dma_addr_t dma_addr);
 extern void swiotlb_free_coherent(struct device *hwdev, size_t size,
 				  void *vaddr, dma_addr_t dma_handle);
diff --git a/arch/x86/include/asm/tce.h b/arch/x86/include/asm/tce.h
index 7a6677c..644b60a 100644
--- a/arch/x86/include/asm/tce.h
+++ b/arch/x86/include/asm/tce.h
@@ -39,7 +39,8 @@ struct iommu_table;
 #define TCE_RPN_MASK     0x0000fffffffff000ULL
 
 extern void tce_build(struct iommu_table *tbl, unsigned long index,
-		      unsigned int npages, unsigned long uaddr, int direction);
+		      unsigned int npages, unsigned long uaddr,
+		      enum dma_data_direction direction);
 extern void tce_free(struct iommu_table *tbl, long index, unsigned int npages);
 extern void * __init alloc_tce_table(void);
 extern void __init free_tce_table(void *tbl);
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index ce948aa..13ec5d8 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -872,7 +872,7 @@ static dma_addr_t dma_ops_domain_map(struct amd_iommu *iommu,
 				     struct dma_ops_domain *dom,
 				     unsigned long address,
 				     phys_addr_t paddr,
-				     int direction)
+				     enum dma_data_direction direction)
 {
 	u64 *pte, __pte;
 
@@ -932,7 +932,7 @@ static dma_addr_t __map_single(struct device *dev,
 			       struct dma_ops_domain *dma_dom,
 			       phys_addr_t paddr,
 			       size_t size,
-			       int dir,
+			       enum dma_data_direction dir,
 			       bool align,
 			       u64 dma_mask)
 {
@@ -979,7 +979,7 @@ static void __unmap_single(struct amd_iommu *iommu,
 			   struct dma_ops_domain *dma_dom,
 			   dma_addr_t dma_addr,
 			   size_t size,
-			   int dir)
+			   enum dma_data_direction dir)
 {
 	dma_addr_t i, start;
 	unsigned int pages;
@@ -1008,7 +1008,7 @@ static void __unmap_single(struct amd_iommu *iommu,
  * The exported map_single function for dma_ops.
  */
 static dma_addr_t map_single(struct device *dev, phys_addr_t paddr,
-			     size_t size, int dir)
+			     size_t size, enum dma_data_direction dir)
 {
 	unsigned long flags;
 	struct amd_iommu *iommu;
@@ -1046,7 +1046,7 @@ out:
  * The exported unmap_single function for dma_ops.
  */
 static void unmap_single(struct device *dev, dma_addr_t dma_addr,
-			 size_t size, int dir)
+			 size_t size, enum dma_data_direction dir)
 {
 	unsigned long flags;
 	struct amd_iommu *iommu;
@@ -1072,7 +1072,7 @@ static void unmap_single(struct device *dev, dma_addr_t dma_addr,
  * device which is not handled by an AMD IOMMU in the system.
  */
 static int map_sg_no_iommu(struct device *dev, struct scatterlist *sglist,
-			   int nelems, int dir)
+			   int nelems, enum dma_data_direction dir)
 {
 	struct scatterlist *s;
 	int i;
@@ -1090,7 +1090,7 @@ static int map_sg_no_iommu(struct device *dev, struct scatterlist *sglist,
  * lists).
  */
 static int map_sg(struct device *dev, struct scatterlist *sglist,
-		  int nelems, int dir)
+		  int nelems, enum dma_data_direction dir)
 {
 	unsigned long flags;
 	struct amd_iommu *iommu;
@@ -1152,7 +1152,7 @@ unmap:
  * lists).
  */
 static void unmap_sg(struct device *dev, struct scatterlist *sglist,
-		     int nelems, int dir)
+		     int nelems, enum dma_data_direction dir)
 {
 	unsigned long flags;
 	struct amd_iommu *iommu;
diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index d28bbdc..76a55c0 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -297,7 +297,8 @@ static unsigned long iommu_range_alloc(struct device *dev,
 }
 
 static dma_addr_t iommu_alloc(struct device *dev, struct iommu_table *tbl,
-			      void *vaddr, unsigned int npages, int direction)
+			      void *vaddr, unsigned int npages,
+			      enum dma_data_direction direction)
 {
 	unsigned long entry;
 	dma_addr_t ret = bad_dma_address;
@@ -381,7 +382,7 @@ static inline struct iommu_table *find_iommu_table(struct device *dev)
 }
 
 static void calgary_unmap_sg(struct device *dev,
-	struct scatterlist *sglist, int nelems, int direction)
+	struct scatterlist *sglist, int nelems, enum dma_data_direction dir)
 {
 	struct iommu_table *tbl = find_iommu_table(dev);
 	struct scatterlist *s;
@@ -404,7 +405,7 @@ static void calgary_unmap_sg(struct device *dev,
 }
 
 static int calgary_map_sg(struct device *dev, struct scatterlist *sg,
-	int nelems, int direction)
+	int nelems, enum dma_data_direction direction)
 {
 	struct iommu_table *tbl = find_iommu_table(dev);
 	struct scatterlist *s;
@@ -446,7 +447,7 @@ error:
 }
 
 static dma_addr_t calgary_map_single(struct device *dev, phys_addr_t paddr,
-	size_t size, int direction)
+	size_t size, enum dma_data_direction direction)
 {
 	void *vaddr = phys_to_virt(paddr);
 	unsigned long uaddr;
@@ -460,7 +461,7 @@ static dma_addr_t calgary_map_single(struct device *dev, phys_addr_t paddr,
 }
 
 static void calgary_unmap_single(struct device *dev, dma_addr_t dma_handle,
-	size_t size, int direction)
+	size_t size, enum dma_data_direction direction)
 {
 	struct iommu_table *tbl = find_iommu_table(dev);
 	unsigned int npages;
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index ba7ad83..f3cd99b 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -188,7 +188,8 @@ static void dump_leak(void)
 # define CLEAR_LEAK(x)
 #endif
 
-static void iommu_full(struct device *dev, size_t size, int dir)
+static void
+iommu_full(struct device *dev, size_t size, enum dma_data_direction dir)
 {
 	/*
 	 * Ran out of IOMMU space for this operation. This is very bad.
@@ -231,7 +232,8 @@ nonforced_iommu(struct device *dev, unsigned long addr, size_t size)
  * Caller needs to check if the iommu is needed and flush.
  */
 static dma_addr_t dma_map_area(struct device *dev, dma_addr_t phys_mem,
-				size_t size, int dir, unsigned long align_mask)
+			       size_t size, enum dma_data_direction dir,
+			       unsigned long align_mask)
 {
 	unsigned long npages = iommu_num_pages(phys_mem, size, PAGE_SIZE);
 	unsigned long iommu_page = alloc_iommu(dev, npages, align_mask);
@@ -256,7 +258,8 @@ static dma_addr_t dma_map_area(struct device *dev, dma_addr_t phys_mem,
 
 /* Map a single area into the IOMMU */
 static dma_addr_t
-gart_map_single(struct device *dev, phys_addr_t paddr, size_t size, int dir)
+gart_map_single(struct device *dev, phys_addr_t paddr, size_t size,
+		enum dma_data_direction dir)
 {
 	unsigned long bus;
 
@@ -276,7 +279,7 @@ gart_map_single(struct device *dev, phys_addr_t paddr, size_t size, int dir)
  * Free a DMA mapping.
  */
 static void gart_unmap_single(struct device *dev, dma_addr_t dma_addr,
-			      size_t size, int direction)
+			      size_t size, enum dma_data_direction direction)
 {
 	unsigned long iommu_page;
 	int npages;
@@ -299,7 +302,8 @@ static void gart_unmap_single(struct device *dev, dma_addr_t dma_addr,
  * Wrapper for pci_unmap_single working with scatterlists.
  */
 static void
-gart_unmap_sg(struct device *dev, struct scatterlist *sg, int nents, int dir)
+gart_unmap_sg(struct device *dev, struct scatterlist *sg, int nents,
+	      enum dma_data_direction dir)
 {
 	struct scatterlist *s;
 	int i;
@@ -313,7 +317,7 @@ gart_unmap_sg(struct device *dev, struct scatterlist *sg, int nents, int dir)
 
 /* Fallback for dma_map_sg in case of overflow */
 static int dma_map_sg_nonforce(struct device *dev, struct scatterlist *sg,
-			       int nents, int dir)
+			       int nents, enum dma_data_direction dir)
 {
 	struct scatterlist *s;
 	int i;
@@ -401,7 +405,8 @@ dma_map_cont(struct device *dev, struct scatterlist *start, int nelems,
  * Merge chunks that have page aligned sizes into a continuous mapping.
  */
 static int
-gart_map_sg(struct device *dev, struct scatterlist *sg, int nents, int dir)
+gart_map_sg(struct device *dev, struct scatterlist *sg, int nents,
+	    enum dma_data_direction dir)
 {
 	struct scatterlist *s, *ps, *start_sg, *sgmap;
 	int need = 0, nextneed, i, out, start;
diff --git a/arch/x86/kernel/pci-nommu.c b/arch/x86/kernel/pci-nommu.c
index c70ab5a..a4c6b7f 100644
--- a/arch/x86/kernel/pci-nommu.c
+++ b/arch/x86/kernel/pci-nommu.c
@@ -27,7 +27,7 @@ check_addr(char *name, struct device *hwdev, dma_addr_t bus, size_t size)
 
 static dma_addr_t
 nommu_map_single(struct device *hwdev, phys_addr_t paddr, size_t size,
-	       int direction)
+		 enum dma_data_direction direction)
 {
 	dma_addr_t bus = paddr;
 	WARN_ON(size == 0);
@@ -54,7 +54,7 @@ nommu_map_single(struct device *hwdev, phys_addr_t paddr, size_t size,
  * the same here.
  */
 static int nommu_map_sg(struct device *hwdev, struct scatterlist *sg,
-	       int nents, int direction)
+			int nents, enum dma_data_direction direction)
 {
 	struct scatterlist *s;
 	int i;
diff --git a/arch/x86/kernel/pci-swiotlb_64.c b/arch/x86/kernel/pci-swiotlb_64.c
index 3c539d1..c400a0b 100644
--- a/arch/x86/kernel/pci-swiotlb_64.c
+++ b/arch/x86/kernel/pci-swiotlb_64.c
@@ -13,7 +13,7 @@ int swiotlb __read_mostly;
 
 static dma_addr_t
 swiotlb_map_single_phys(struct device *hwdev, phys_addr_t paddr, size_t size,
-			int direction)
+			enum dma_data_direction direction)
 {
 	return swiotlb_map_single(hwdev, phys_to_virt(paddr), size, direction);
 }
diff --git a/arch/x86/kernel/tce_64.c b/arch/x86/kernel/tce_64.c
index 9e540fe..29bc5b6 100644
--- a/arch/x86/kernel/tce_64.c
+++ b/arch/x86/kernel/tce_64.c
@@ -46,7 +46,8 @@ static inline void flush_tce(void* tceaddr)
 }
 
 void tce_build(struct iommu_table *tbl, unsigned long index,
-	unsigned int npages, unsigned long uaddr, int direction)
+	unsigned int npages, unsigned long uaddr,
+	enum dma_data_direction direction)
 {
 	u64* tp;
 	u64 t;
diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 213a5c8..0232293 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -1997,7 +1997,8 @@ get_valid_domain_for_dev(struct pci_dev *pdev)
 }
 
 static dma_addr_t __intel_map_single(struct device *hwdev, phys_addr_t paddr,
-				     size_t size, int dir, u64 dma_mask)
+				     size_t size,
+				     enum dma_data_direction dir, u64 dma_mask)
 {
 	struct pci_dev *pdev = to_pci_dev(hwdev);
 	struct dmar_domain *domain;
@@ -2059,7 +2060,7 @@ error:
 }
 
 dma_addr_t intel_map_single(struct device *hwdev, phys_addr_t paddr,
-			    size_t size, int dir)
+			    size_t size, enum dma_data_direction dir)
 {
 	return __intel_map_single(hwdev, paddr, size, dir,
 				  to_pci_dev(hwdev)->dma_mask);
@@ -2124,7 +2125,7 @@ static void add_unmap(struct dmar_domain *dom, struct iova *iova)
 }
 
 void intel_unmap_single(struct device *dev, dma_addr_t dev_addr, size_t size,
-			int dir)
+			enum dma_data_direction dir)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct dmar_domain *domain;
@@ -2204,7 +2205,7 @@ void intel_free_coherent(struct device *hwdev, size_t size, void *vaddr,
 #define SG_ENT_VIRT_ADDRESS(sg)	(sg_virt((sg)))
 
 void intel_unmap_sg(struct device *hwdev, struct scatterlist *sglist,
-		    int nelems, int dir)
+		    int nelems, enum dma_data_direction dir)
 {
 	int i;
 	struct pci_dev *pdev = to_pci_dev(hwdev);
@@ -2244,7 +2245,7 @@ void intel_unmap_sg(struct device *hwdev, struct scatterlist *sglist,
 }
 
 static int intel_nontranslate_map_sg(struct device *hddev,
-	struct scatterlist *sglist, int nelems, int dir)
+	struct scatterlist *sglist, int nelems, enum dma_data_direction dir)
 {
 	int i;
 	struct scatterlist *sg;
@@ -2258,7 +2259,7 @@ static int intel_nontranslate_map_sg(struct device *hddev,
 }
 
 int intel_map_sg(struct device *hwdev, struct scatterlist *sglist, int nelems,
-		 int dir)
+		 enum dma_data_direction dir)
 {
 	void *addr;
 	int i;
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index 1bff7bf..eba544e 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -350,9 +350,13 @@ static inline int intel_iommu_found(void)
 
 extern void *intel_alloc_coherent(struct device *, size_t, dma_addr_t *, gfp_t);
 extern void intel_free_coherent(struct device *, size_t, void *, dma_addr_t);
-extern dma_addr_t intel_map_single(struct device *, phys_addr_t, size_t, int);
-extern void intel_unmap_single(struct device *, dma_addr_t, size_t, int);
-extern int intel_map_sg(struct device *, struct scatterlist *, int, int);
-extern void intel_unmap_sg(struct device *, struct scatterlist *, int, int);
+extern dma_addr_t intel_map_single(struct device *, phys_addr_t, size_t,
+				   enum dma_data_direction);
+extern void intel_unmap_single(struct device *, dma_addr_t, size_t,
+			       enum dma_data_direction);
+extern int intel_map_sg(struct device *, struct scatterlist *, int,
+			enum dma_data_direction);
+extern void intel_unmap_sg(struct device *, struct scatterlist *, int,
+			   enum dma_data_direction);
 
 #endif
diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index b18ec55..f4d1be3 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -19,60 +19,65 @@ swiotlb_free_coherent(struct device *hwdev, size_t size,
 		      void *vaddr, dma_addr_t dma_handle);
 
 extern dma_addr_t
-swiotlb_map_single(struct device *hwdev, void *ptr, size_t size, int dir);
+swiotlb_map_single(struct device *hwdev, void *ptr, size_t size,
+		   enum dma_data_direction dir);
 
 extern void
 swiotlb_unmap_single(struct device *hwdev, dma_addr_t dev_addr,
-		     size_t size, int dir);
+		     size_t size, enum dma_data_direction dir);
 
 extern dma_addr_t
 swiotlb_map_single_attrs(struct device *hwdev, void *ptr, size_t size,
-			 int dir, struct dma_attrs *attrs);
+			 enum dma_data_direction dir,
+			 struct dma_attrs *attrs);
 
 extern void
 swiotlb_unmap_single_attrs(struct device *hwdev, dma_addr_t dev_addr,
-			   size_t size, int dir, struct dma_attrs *attrs);
+			   size_t size, enum dma_data_direction dir,
+			   struct dma_attrs *attrs);
 
 extern int
 swiotlb_map_sg(struct device *hwdev, struct scatterlist *sg, int nents,
-	       int direction);
+	       enum dma_data_direction direction);
 
 extern void
 swiotlb_unmap_sg(struct device *hwdev, struct scatterlist *sg, int nents,
-		 int direction);
+		 enum dma_data_direction direction);
 
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
index ab5d3d7..fc906d5 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -350,7 +350,8 @@ void swiotlb_bounce(phys_addr_t phys, char *dma_addr, size_t size,
  * Allocates bounce buffer and returns its kernel virtual address.
  */
 static void *
-map_single(struct device *hwdev, phys_addr_t phys, size_t size, int dir)
+map_single(struct device *hwdev, phys_addr_t phys, size_t size,
+	   enum dma_data_direction dir)
 {
 	unsigned long flags;
 	char *dma_addr;
@@ -452,7 +453,8 @@ found:
  * dma_addr is the kernel virtual address of the bounce buffer to unmap.
  */
 static void
-unmap_single(struct device *hwdev, char *dma_addr, size_t size, int dir)
+unmap_single(struct device *hwdev, char *dma_addr, size_t size,
+	     enum dma_data_direction dir)
 {
 	unsigned long flags;
 	int i, count, nslots = ALIGN(size, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT;
@@ -493,7 +495,7 @@ unmap_single(struct device *hwdev, char *dma_addr, size_t size, int dir)
 
 static void
 sync_single(struct device *hwdev, char *dma_addr, size_t size,
-	    int dir, int target)
+	    enum dma_data_direction dir, int target)
 {
 	int index = (dma_addr - io_tlb_start) >> IO_TLB_SHIFT;
 	phys_addr_t phys = io_tlb_orig_addr[index];
@@ -583,7 +585,8 @@ swiotlb_free_coherent(struct device *hwdev, size_t size, void *vaddr,
 }
 
 static void
-swiotlb_full(struct device *dev, size_t size, int dir, int do_panic)
+swiotlb_full(struct device *dev, size_t size, enum dma_data_direction dir,
+	     int do_panic)
 {
 	/*
 	 * Ran out of IOMMU space for this operation. This is very bad.
@@ -612,7 +615,7 @@ swiotlb_full(struct device *dev, size_t size, int dir, int do_panic)
  */
 dma_addr_t
 swiotlb_map_single_attrs(struct device *hwdev, void *ptr, size_t size,
-			 int dir, struct dma_attrs *attrs)
+			 enum dma_data_direction dir, struct dma_attrs *attrs)
 {
 	dma_addr_t dev_addr = virt_to_dma_addr(hwdev, ptr);
 	void *map;
@@ -649,7 +652,8 @@ swiotlb_map_single_attrs(struct device *hwdev, void *ptr, size_t size,
 EXPORT_SYMBOL(swiotlb_map_single_attrs);
 
 dma_addr_t
-swiotlb_map_single(struct device *hwdev, void *ptr, size_t size, int dir)
+swiotlb_map_single(struct device *hwdev, void *ptr, size_t size,
+		   enum dma_data_direction dir)
 {
 	return swiotlb_map_single_attrs(hwdev, ptr, size, dir, NULL);
 }
@@ -664,7 +668,8 @@ swiotlb_map_single(struct device *hwdev, void *ptr, size_t size, int dir)
  */
 void
 swiotlb_unmap_single_attrs(struct device *hwdev, dma_addr_t dev_addr,
-			   size_t size, int dir, struct dma_attrs *attrs)
+			   size_t size, enum dma_data_direction dir,
+			   struct dma_attrs *attrs)
 {
 	char *dma_addr = dma_addr_to_virt(hwdev, dev_addr);
 
@@ -678,7 +683,7 @@ EXPORT_SYMBOL(swiotlb_unmap_single_attrs);
 
 void
 swiotlb_unmap_single(struct device *hwdev, dma_addr_t dev_addr, size_t size,
-		     int dir)
+		     enum dma_data_direction dir)
 {
 	return swiotlb_unmap_single_attrs(hwdev, dev_addr, size, dir, NULL);
 }
@@ -694,7 +699,7 @@ swiotlb_unmap_single(struct device *hwdev, dma_addr_t dev_addr, size_t size,
  */
 static void
 swiotlb_sync_single(struct device *hwdev, dma_addr_t dev_addr,
-		    size_t size, int dir, int target)
+		    size_t size, enum dma_data_direction dir, int target)
 {
 	char *dma_addr = dma_addr_to_virt(hwdev, dev_addr);
 
@@ -707,14 +712,14 @@ swiotlb_sync_single(struct device *hwdev, dma_addr_t dev_addr,
 
 void
 swiotlb_sync_single_for_cpu(struct device *hwdev, dma_addr_t dev_addr,
-			    size_t size, int dir)
+			    size_t size, enum dma_data_direction dir)
 {
 	swiotlb_sync_single(hwdev, dev_addr, size, dir, SYNC_FOR_CPU);
 }
 
 void
 swiotlb_sync_single_for_device(struct device *hwdev, dma_addr_t dev_addr,
-			       size_t size, int dir)
+			       size_t size, enum dma_data_direction dir)
 {
 	swiotlb_sync_single(hwdev, dev_addr, size, dir, SYNC_FOR_DEVICE);
 }
@@ -725,7 +730,7 @@ swiotlb_sync_single_for_device(struct device *hwdev, dma_addr_t dev_addr,
 static void
 swiotlb_sync_single_range(struct device *hwdev, dma_addr_t dev_addr,
 			  unsigned long offset, size_t size,
-			  int dir, int target)
+			  enum dma_data_direction dir, int target)
 {
 	char *dma_addr = dma_addr_to_virt(hwdev, dev_addr) + offset;
 
@@ -738,7 +743,8 @@ swiotlb_sync_single_range(struct device *hwdev, dma_addr_t dev_addr,
 
 void
 swiotlb_sync_single_range_for_cpu(struct device *hwdev, dma_addr_t dev_addr,
-				  unsigned long offset, size_t size, int dir)
+				  unsigned long offset, size_t size,
+				  enum dma_data_direction dir)
 {
 	swiotlb_sync_single_range(hwdev, dev_addr, offset, size, dir,
 				  SYNC_FOR_CPU);
@@ -746,14 +752,15 @@ swiotlb_sync_single_range_for_cpu(struct device *hwdev, dma_addr_t dev_addr,
 
 void
 swiotlb_sync_single_range_for_device(struct device *hwdev, dma_addr_t dev_addr,
-				     unsigned long offset, size_t size, int dir)
+				     unsigned long offset, size_t size,
+				     enum dma_data_direction dir)
 {
 	swiotlb_sync_single_range(hwdev, dev_addr, offset, size, dir,
 				  SYNC_FOR_DEVICE);
 }
 
-void swiotlb_unmap_sg_attrs(struct device *, struct scatterlist *, int, int,
-			    struct dma_attrs *);
+void swiotlb_unmap_sg_attrs(struct device *, struct scatterlist *, int,
+			    enum dma_data_direction, struct dma_attrs *);
 /*
  * Map a set of buffers described by scatterlist in streaming mode for DMA.
  * This is the scatter-gather version of the above swiotlb_map_single
@@ -772,7 +779,7 @@ void swiotlb_unmap_sg_attrs(struct device *, struct scatterlist *, int, int,
  */
 int
 swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl, int nelems,
-		     int dir, struct dma_attrs *attrs)
+		     enum dma_data_direction dir, struct dma_attrs *attrs)
 {
 	struct scatterlist *sg;
 	dma_addr_t dev_addr;
@@ -806,7 +813,7 @@ EXPORT_SYMBOL(swiotlb_map_sg_attrs);
 
 int
 swiotlb_map_sg(struct device *hwdev, struct scatterlist *sgl, int nelems,
-	       int dir)
+	       enum dma_data_direction dir)
 {
 	return swiotlb_map_sg_attrs(hwdev, sgl, nelems, dir, NULL);
 }
@@ -817,7 +824,8 @@ swiotlb_map_sg(struct device *hwdev, struct scatterlist *sgl, int nelems,
  */
 void
 swiotlb_unmap_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
-		       int nelems, int dir, struct dma_attrs *attrs)
+		       int nelems, enum dma_data_direction dir,
+		       struct dma_attrs *attrs)
 {
 	struct scatterlist *sg;
 	int i;
@@ -837,7 +845,7 @@ EXPORT_SYMBOL(swiotlb_unmap_sg_attrs);
 
 void
 swiotlb_unmap_sg(struct device *hwdev, struct scatterlist *sgl, int nelems,
-		 int dir)
+		 enum dma_data_direction dir)
 {
 	return swiotlb_unmap_sg_attrs(hwdev, sgl, nelems, dir, NULL);
 }
@@ -851,7 +859,7 @@ swiotlb_unmap_sg(struct device *hwdev, struct scatterlist *sgl, int nelems,
  */
 static void
 swiotlb_sync_sg(struct device *hwdev, struct scatterlist *sgl,
-		int nelems, int dir, int target)
+		int nelems, enum dma_data_direction dir, int target)
 {
 	struct scatterlist *sg;
 	int i;
@@ -870,14 +878,14 @@ swiotlb_sync_sg(struct device *hwdev, struct scatterlist *sgl,
 
 void
 swiotlb_sync_sg_for_cpu(struct device *hwdev, struct scatterlist *sg,
-			int nelems, int dir)
+			int nelems, enum dma_data_direction dir)
 {
 	swiotlb_sync_sg(hwdev, sg, nelems, dir, SYNC_FOR_CPU);
 }
 
 void
 swiotlb_sync_sg_for_device(struct device *hwdev, struct scatterlist *sg,
-			   int nelems, int dir)
+			   int nelems, enum dma_data_direction dir)
 {
 	swiotlb_sync_sg(hwdev, sg, nelems, dir, SYNC_FOR_DEVICE);
 }
-- 
1.5.6.5

