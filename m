Return-Path: <linux-kernel-owner+w=401wt.eu-S1753866AbYLVScP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866AbYLVScP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 13:32:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753941AbYLVS3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 13:29:00 -0500
Received: from gw.goop.org ([64.81.55.164]:44725 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752986AbYLVS25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 13:28:57 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 9 of 9] ia64/x86/swiotlb: use enum dma_data_direciton in
	dma_ops
X-Mercurial-Node: f6036ee29f1af95beec1325e9a2efa6c23af1093
Message-Id: <f6036ee29f1af95beec1.1229970371@abulafia.goop.org>
In-Reply-To: <patchbomb.1229970362@abulafia.goop.org>
Date: Mon, 22 Dec 2008 10:26:11 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>,
       Becky Bruce <beckyb@kernel.crashing.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Becky Bruce <beckyb@kernel.crashing.org>

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
--- a/arch/ia64/dig/dig_vtd_iommu.c
+++ b/arch/ia64/dig/dig_vtd_iommu.c
@@ -21,7 +21,7 @@
 
 dma_addr_t
 vtd_map_single_attrs(struct device *dev, void *addr, size_t size,
-		     int dir, struct dma_attrs *attrs)
+		     enum dma_data_direction dir, struct dma_attrs *attrs)
 {
 	return intel_map_single(dev, (phys_addr_t)addr, size, dir);
 }
@@ -29,7 +29,7 @@
 
 void
 vtd_unmap_single_attrs(struct device *dev, dma_addr_t iova, size_t size,
-		       int dir, struct dma_attrs *attrs)
+		       enum dma_data_direction dir, struct dma_attrs *attrs)
 {
 	intel_unmap_single(dev, iova, size, dir);
 }
@@ -37,7 +37,7 @@
 
 int
 vtd_map_sg_attrs(struct device *dev, struct scatterlist *sglist, int nents,
-		 int dir, struct dma_attrs *attrs)
+		 enum dma_data_direction dir, struct dma_attrs *attrs)
 {
 	return intel_map_sg(dev, sglist, nents, dir);
 }
@@ -45,7 +45,8 @@
 
 void
 vtd_unmap_sg_attrs(struct device *dev, struct scatterlist *sglist,
-		   int nents, int dir, struct dma_attrs *attrs)
+		   int nents, enum dma_data_direction dir,
+		   struct dma_attrs *attrs)
 {
 	intel_unmap_sg(dev, sglist, nents, dir);
 }
diff --git a/arch/ia64/hp/common/hwsw_iommu.c b/arch/ia64/hp/common/hwsw_iommu.c
--- a/arch/ia64/hp/common/hwsw_iommu.c
+++ b/arch/ia64/hp/common/hwsw_iommu.c
@@ -91,8 +91,8 @@
 }
 
 dma_addr_t
-hwsw_map_single_attrs(struct device *dev, void *addr, size_t size, int dir,
-		       struct dma_attrs *attrs)
+hwsw_map_single_attrs(struct device *dev, void *addr, size_t size,
+		      enum dma_data_direction dir, struct dma_attrs *attrs)
 {
 	if (use_swiotlb(dev))
 		return swiotlb_map_single_attrs(dev, addr, size, dir, attrs);
@@ -103,7 +103,7 @@
 
 void
 hwsw_unmap_single_attrs(struct device *dev, dma_addr_t iova, size_t size,
-			 int dir, struct dma_attrs *attrs)
+			 enum dma_data_direction dir, struct dma_attrs *attrs)
 {
 	if (use_swiotlb(dev))
 		return swiotlb_unmap_single_attrs(dev, iova, size, dir, attrs);
@@ -114,7 +114,7 @@
 
 int
 hwsw_map_sg_attrs(struct device *dev, struct scatterlist *sglist, int nents,
-		   int dir, struct dma_attrs *attrs)
+		   enum dma_data_direction dir, struct dma_attrs *attrs)
 {
 	if (use_swiotlb(dev))
 		return swiotlb_map_sg_attrs(dev, sglist, nents, dir, attrs);
@@ -125,7 +125,7 @@
 
 void
 hwsw_unmap_sg_attrs(struct device *dev, struct scatterlist *sglist, int nents,
-		     int dir, struct dma_attrs *attrs)
+		     enum dma_data_direction dir, struct dma_attrs *attrs)
 {
 	if (use_swiotlb(dev))
 		return swiotlb_unmap_sg_attrs(dev, sglist, nents, dir, attrs);
@@ -135,7 +135,8 @@
 EXPORT_SYMBOL(hwsw_unmap_sg_attrs);
 
 void
-hwsw_sync_single_for_cpu (struct device *dev, dma_addr_t addr, size_t size, int dir)
+hwsw_sync_single_for_cpu (struct device *dev, dma_addr_t addr, size_t size,
+			  enum dma_data_direction dir)
 {
 	if (use_swiotlb(dev))
 		swiotlb_sync_single_for_cpu(dev, addr, size, dir);
@@ -144,7 +145,8 @@
 }
 
 void
-hwsw_sync_sg_for_cpu (struct device *dev, struct scatterlist *sg, int nelems, int dir)
+hwsw_sync_sg_for_cpu (struct device *dev, struct scatterlist *sg, int nelems,
+		      enum dma_data_direction dir)
 {
 	if (use_swiotlb(dev))
 		swiotlb_sync_sg_for_cpu(dev, sg, nelems, dir);
@@ -153,7 +155,8 @@
 }
 
 void
-hwsw_sync_single_for_device (struct device *dev, dma_addr_t addr, size_t size, int dir)
+hwsw_sync_single_for_device (struct device *dev, dma_addr_t addr, size_t size,
+			     enum dma_data_direction dir)
 {
 	if (use_swiotlb(dev))
 		swiotlb_sync_single_for_device(dev, addr, size, dir);
@@ -162,7 +165,8 @@
 }
 
 void
-hwsw_sync_sg_for_device (struct device *dev, struct scatterlist *sg, int nelems, int dir)
+hwsw_sync_sg_for_device (struct device *dev, struct scatterlist *sg, int nelems,
+			 enum dma_data_direction dir)
 {
 	if (use_swiotlb(dev))
 		swiotlb_sync_sg_for_device(dev, sg, nelems, dir);
diff --git a/arch/ia64/hp/common/sba_iommu.c b/arch/ia64/hp/common/sba_iommu.c
--- a/arch/ia64/hp/common/sba_iommu.c
+++ b/arch/ia64/hp/common/sba_iommu.c
@@ -909,8 +909,8 @@
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
@@ -1027,7 +1027,8 @@
  * See Documentation/DMA-mapping.txt
  */
 void sba_unmap_single_attrs(struct device *dev, dma_addr_t iova, size_t size,
-			    int dir, struct dma_attrs *attrs)
+			    enum dma_data_direction dir,
+			    struct dma_attrs *attrs)
 {
 	struct ioc *ioc;
 #if DELAYED_RESOURCE_CNT > 0
@@ -1423,7 +1424,7 @@
  * See Documentation/DMA-mapping.txt
  */
 int sba_map_sg_attrs(struct device *dev, struct scatterlist *sglist, int nents,
-		     int dir, struct dma_attrs *attrs)
+		     enum dma_data_direction dir, struct dma_attrs *attrs)
 {
 	struct ioc *ioc;
 	int coalesced, filled = 0;
@@ -1515,7 +1516,8 @@
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
--- a/arch/ia64/include/asm/dma-mapping.h
+++ b/arch/ia64/include/asm/dma-mapping.h
@@ -17,32 +17,32 @@
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
@@ -70,25 +70,26 @@
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
--- a/arch/ia64/kernel/machvec.c
+++ b/arch/ia64/kernel/machvec.c
@@ -75,14 +75,16 @@
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
--- a/arch/ia64/sn/kernel/io_common.c
+++ b/arch/ia64/sn/kernel/io_common.c
@@ -60,7 +60,8 @@
 }
 
 static void
-sn_default_pci_unmap(struct pci_dev *pdev, dma_addr_t addr, int direction)
+sn_default_pci_unmap(struct pci_dev *pdev, dma_addr_t addr,
+		     enum dma_data_direction direction)
 {
 	return;
 }
diff --git a/arch/ia64/sn/pci/pci_dma.c b/arch/ia64/sn/pci/pci_dma.c
--- a/arch/ia64/sn/pci/pci_dma.c
+++ b/arch/ia64/sn/pci/pci_dma.c
@@ -174,7 +174,8 @@
  *       figure out how to save dmamap handle so can use two step.
  */
 dma_addr_t sn_dma_map_single_attrs(struct device *dev, void *cpu_addr,
-				   size_t size, int direction,
+				   size_t size,
+				   enum dma_data_direction direction,
 				   struct dma_attrs *attrs)
 {
 	dma_addr_t dma_addr;
@@ -216,7 +217,8 @@
  * coherent, so we just need to free any ATEs associated with this mapping.
  */
 void sn_dma_unmap_single_attrs(struct device *dev, dma_addr_t dma_addr,
-			       size_t size, int direction,
+			       size_t size,
+			       enum dma_data_direction direction,
 			       struct dma_attrs *attrs)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
@@ -239,7 +241,7 @@
  * Unmap a set of streaming mode DMA translations.
  */
 void sn_dma_unmap_sg_attrs(struct device *dev, struct scatterlist *sgl,
-			   int nhwentries, int direction,
+			   int nhwentries, enum dma_data_direction direction,
 			   struct dma_attrs *attrs)
 {
 	int i;
@@ -273,7 +275,8 @@
  * Maps each entry of @sg for DMA.
  */
 int sn_dma_map_sg_attrs(struct device *dev, struct scatterlist *sgl,
-			int nhwentries, int direction, struct dma_attrs *attrs)
+			int nhwentries, enum dma_data_direction direction,
+			struct dma_attrs *attrs)
 {
 	unsigned long phys_addr;
 	struct scatterlist *saved_sg = sgl, *sg;
@@ -323,28 +326,30 @@
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
--- a/arch/ia64/sn/pci/pcibr/pcibr_dma.c
+++ b/arch/ia64/sn/pci/pcibr/pcibr_dma.c
@@ -205,7 +205,8 @@
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
--- a/arch/ia64/sn/pci/tioca_provider.c
+++ b/arch/ia64/sn/pci/tioca_provider.c
@@ -467,7 +467,8 @@
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
--- a/arch/x86/include/asm/dma-mapping.h
+++ b/arch/x86/include/asm/dma-mapping.h
@@ -25,32 +25,36 @@
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
@@ -91,7 +95,7 @@
 
 static inline dma_addr_t
 dma_map_single(struct device *hwdev, void *ptr, size_t size,
-	       int direction)
+	       enum dma_data_direction direction)
 {
 	struct dma_mapping_ops *ops = get_dma_ops(hwdev);
 
@@ -102,7 +106,7 @@
 
 static inline void
 dma_unmap_single(struct device *dev, dma_addr_t addr, size_t size,
-		 int direction)
+		 enum dma_data_direction direction)
 {
 	struct dma_mapping_ops *ops = get_dma_ops(dev);
 
@@ -113,7 +117,7 @@
 
 static inline int
 dma_map_sg(struct device *hwdev, struct scatterlist *sg,
-	   int nents, int direction)
+	   int nents, enum dma_data_direction direction)
 {
 	struct dma_mapping_ops *ops = get_dma_ops(hwdev);
 
@@ -123,7 +127,7 @@
 
 static inline void
 dma_unmap_sg(struct device *hwdev, struct scatterlist *sg, int nents,
-	     int direction)
+	     enum dma_data_direction direction)
 {
 	struct dma_mapping_ops *ops = get_dma_ops(hwdev);
 
@@ -134,7 +138,7 @@
 
 static inline void
 dma_sync_single_for_cpu(struct device *hwdev, dma_addr_t dma_handle,
-			size_t size, int direction)
+			size_t size, enum dma_data_direction direction)
 {
 	struct dma_mapping_ops *ops = get_dma_ops(hwdev);
 
@@ -146,7 +150,7 @@
 
 static inline void
 dma_sync_single_for_device(struct device *hwdev, dma_addr_t dma_handle,
-			   size_t size, int direction)
+			   size_t size, enum dma_data_direction direction)
 {
 	struct dma_mapping_ops *ops = get_dma_ops(hwdev);
 
@@ -158,7 +162,8 @@
 
 static inline void
 dma_sync_single_range_for_cpu(struct device *hwdev, dma_addr_t dma_handle,
-			      unsigned long offset, size_t size, int direction)
+			      unsigned long offset, size_t size,
+			      enum dma_data_direction direction)
 {
 	struct dma_mapping_ops *ops = get_dma_ops(hwdev);
 
@@ -172,7 +177,7 @@
 static inline void
 dma_sync_single_range_for_device(struct device *hwdev, dma_addr_t dma_handle,
 				 unsigned long offset, size_t size,
-				 int direction)
+				 enum dma_data_direction direction)
 {
 	struct dma_mapping_ops *ops = get_dma_ops(hwdev);
 
@@ -185,7 +190,7 @@
 
 static inline void
 dma_sync_sg_for_cpu(struct device *hwdev, struct scatterlist *sg,
-		    int nelems, int direction)
+		    int nelems, enum dma_data_direction direction)
 {
 	struct dma_mapping_ops *ops = get_dma_ops(hwdev);
 
@@ -197,7 +202,7 @@
 
 static inline void
 dma_sync_sg_for_device(struct device *hwdev, struct scatterlist *sg,
-		       int nelems, int direction)
+		       int nelems, enum dma_data_direction direction)
 {
 	struct dma_mapping_ops *ops = get_dma_ops(hwdev);
 
@@ -210,7 +215,7 @@
 
 static inline dma_addr_t dma_map_page(struct device *dev, struct page *page,
 				      size_t offset, size_t size,
-				      int direction)
+				      enum dma_data_direction direction)
 {
 	struct dma_mapping_ops *ops = get_dma_ops(dev);
 
@@ -220,7 +225,8 @@
 }
 
 static inline void dma_unmap_page(struct device *dev, dma_addr_t addr,
-				  size_t size, int direction)
+				  size_t size,
+				  enum dma_data_direction direction)
 {
 	dma_unmap_single(dev, addr, size, direction);
 }
diff --git a/arch/x86/include/asm/swiotlb.h b/arch/x86/include/asm/swiotlb.h
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
--- a/arch/x86/include/asm/tce.h
+++ b/arch/x86/include/asm/tce.h
@@ -39,7 +39,8 @@
 #define TCE_RPN_MASK     0x0000fffffffff000ULL
 
 extern void tce_build(struct iommu_table *tbl, unsigned long index,
-		      unsigned int npages, unsigned long uaddr, int direction);
+		      unsigned int npages, unsigned long uaddr,
+		      enum dma_data_direction direction);
 extern void tce_free(struct iommu_table *tbl, long index, unsigned int npages);
 extern void * __init alloc_tce_table(void);
 extern void __init free_tce_table(void *tbl);
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -873,7 +873,7 @@
 				     struct dma_ops_domain *dom,
 				     unsigned long address,
 				     phys_addr_t paddr,
-				     int direction)
+				     enum dma_data_direction direction)
 {
 	u64 *pte, __pte;
 
@@ -933,7 +933,7 @@
 			       struct dma_ops_domain *dma_dom,
 			       phys_addr_t paddr,
 			       size_t size,
-			       int dir,
+			       enum dma_data_direction dir,
 			       bool align,
 			       u64 dma_mask)
 {
@@ -980,7 +980,7 @@
 			   struct dma_ops_domain *dma_dom,
 			   dma_addr_t dma_addr,
 			   size_t size,
-			   int dir)
+			   enum dma_data_direction dir)
 {
 	dma_addr_t i, start;
 	unsigned int pages;
@@ -1010,7 +1010,7 @@
  * The exported map_single function for dma_ops.
  */
 static dma_addr_t map_single(struct device *dev, phys_addr_t paddr,
-			     size_t size, int dir)
+			     size_t size, enum dma_data_direction dir)
 {
 	unsigned long flags;
 	struct amd_iommu *iommu;
@@ -1048,7 +1048,7 @@
  * The exported unmap_single function for dma_ops.
  */
 static void unmap_single(struct device *dev, dma_addr_t dma_addr,
-			 size_t size, int dir)
+			 size_t size, enum dma_data_direction dir)
 {
 	unsigned long flags;
 	struct amd_iommu *iommu;
@@ -1074,7 +1074,7 @@
  * device which is not handled by an AMD IOMMU in the system.
  */
 static int map_sg_no_iommu(struct device *dev, struct scatterlist *sglist,
-			   int nelems, int dir)
+			   int nelems, enum dma_data_direction dir)
 {
 	struct scatterlist *s;
 	int i;
@@ -1092,7 +1092,7 @@
  * lists).
  */
 static int map_sg(struct device *dev, struct scatterlist *sglist,
-		  int nelems, int dir)
+		  int nelems, enum dma_data_direction dir)
 {
 	unsigned long flags;
 	struct amd_iommu *iommu;
@@ -1154,7 +1154,7 @@
  * lists).
  */
 static void unmap_sg(struct device *dev, struct scatterlist *sglist,
-		     int nelems, int dir)
+		     int nelems, enum dma_data_direction dir)
 {
 	unsigned long flags;
 	struct amd_iommu *iommu;
diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -297,7 +297,8 @@
 }
 
 static dma_addr_t iommu_alloc(struct device *dev, struct iommu_table *tbl,
-			      void *vaddr, unsigned int npages, int direction)
+			      void *vaddr, unsigned int npages,
+			      enum dma_data_direction direction)
 {
 	unsigned long entry;
 	dma_addr_t ret = bad_dma_address;
@@ -381,7 +382,7 @@
 }
 
 static void calgary_unmap_sg(struct device *dev,
-	struct scatterlist *sglist, int nelems, int direction)
+	struct scatterlist *sglist, int nelems, enum dma_data_direction dir)
 {
 	struct iommu_table *tbl = find_iommu_table(dev);
 	struct scatterlist *s;
@@ -404,7 +405,7 @@
 }
 
 static int calgary_map_sg(struct device *dev, struct scatterlist *sg,
-	int nelems, int direction)
+	int nelems, enum dma_data_direction direction)
 {
 	struct iommu_table *tbl = find_iommu_table(dev);
 	struct scatterlist *s;
@@ -446,7 +447,7 @@
 }
 
 static dma_addr_t calgary_map_single(struct device *dev, phys_addr_t paddr,
-	size_t size, int direction)
+	size_t size, enum dma_data_direction direction)
 {
 	void *vaddr = phys_to_virt(paddr);
 	unsigned long uaddr;
@@ -460,7 +461,7 @@
 }
 
 static void calgary_unmap_single(struct device *dev, dma_addr_t dma_handle,
-	size_t size, int direction)
+	size_t size, enum dma_data_direction direction)
 {
 	struct iommu_table *tbl = find_iommu_table(dev);
 	unsigned int npages;
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -188,7 +188,8 @@
 # define CLEAR_LEAK(x)
 #endif
 
-static void iommu_full(struct device *dev, size_t size, int dir)
+static void
+iommu_full(struct device *dev, size_t size, enum dma_data_direction dir)
 {
 	/*
 	 * Ran out of IOMMU space for this operation. This is very bad.
@@ -231,7 +232,8 @@
  * Caller needs to check if the iommu is needed and flush.
  */
 static dma_addr_t dma_map_area(struct device *dev, dma_addr_t phys_mem,
-				size_t size, int dir, unsigned long align_mask)
+			       size_t size, enum dma_data_direction dir,
+			       unsigned long align_mask)
 {
 	unsigned long npages = iommu_num_pages(phys_mem, size, PAGE_SIZE);
 	unsigned long iommu_page = alloc_iommu(dev, npages, align_mask);
@@ -256,7 +258,8 @@
 
 /* Map a single area into the IOMMU */
 static dma_addr_t
-gart_map_single(struct device *dev, phys_addr_t paddr, size_t size, int dir)
+gart_map_single(struct device *dev, phys_addr_t paddr, size_t size,
+		enum dma_data_direction dir)
 {
 	unsigned long bus;
 
@@ -276,7 +279,7 @@
  * Free a DMA mapping.
  */
 static void gart_unmap_single(struct device *dev, dma_addr_t dma_addr,
-			      size_t size, int direction)
+			      size_t size, enum dma_data_direction direction)
 {
 	unsigned long iommu_page;
 	int npages;
@@ -299,7 +302,8 @@
  * Wrapper for pci_unmap_single working with scatterlists.
  */
 static void
-gart_unmap_sg(struct device *dev, struct scatterlist *sg, int nents, int dir)
+gart_unmap_sg(struct device *dev, struct scatterlist *sg, int nents,
+	      enum dma_data_direction dir)
 {
 	struct scatterlist *s;
 	int i;
@@ -313,7 +317,7 @@
 
 /* Fallback for dma_map_sg in case of overflow */
 static int dma_map_sg_nonforce(struct device *dev, struct scatterlist *sg,
-			       int nents, int dir)
+			       int nents, enum dma_data_direction dir)
 {
 	struct scatterlist *s;
 	int i;
@@ -401,7 +405,8 @@
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
--- a/arch/x86/kernel/pci-nommu.c
+++ b/arch/x86/kernel/pci-nommu.c
@@ -27,7 +27,7 @@
 
 static dma_addr_t
 nommu_map_single(struct device *hwdev, phys_addr_t paddr, size_t size,
-	       int direction)
+		 enum dma_data_direction direction)
 {
 	dma_addr_t bus = paddr;
 	WARN_ON(size == 0);
@@ -54,7 +54,7 @@
  * the same here.
  */
 static int nommu_map_sg(struct device *hwdev, struct scatterlist *sg,
-	       int nents, int direction)
+			int nents, enum dma_data_direction direction)
 {
 	struct scatterlist *s;
 	int i;
diff --git a/arch/x86/kernel/pci-swiotlb_64.c b/arch/x86/kernel/pci-swiotlb_64.c
--- a/arch/x86/kernel/pci-swiotlb_64.c
+++ b/arch/x86/kernel/pci-swiotlb_64.c
@@ -40,7 +40,7 @@
 
 static dma_addr_t
 swiotlb_map_single_phys(struct device *hwdev, phys_addr_t paddr, size_t size,
-			int direction)
+			enum dma_data_direction direction)
 {
 	return swiotlb_map_single(hwdev, phys_to_virt(paddr), size, direction);
 }
diff --git a/arch/x86/kernel/tce_64.c b/arch/x86/kernel/tce_64.c
--- a/arch/x86/kernel/tce_64.c
+++ b/arch/x86/kernel/tce_64.c
@@ -46,7 +46,8 @@
 }
 
 void tce_build(struct iommu_table *tbl, unsigned long index,
-	unsigned int npages, unsigned long uaddr, int direction)
+	unsigned int npages, unsigned long uaddr,
+	enum dma_data_direction direction)
 {
 	u64* tp;
 	u64 t;
diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -1819,7 +1819,8 @@
 }
 
 static dma_addr_t __intel_map_single(struct device *hwdev, phys_addr_t paddr,
-				     size_t size, int dir, u64 dma_mask)
+				     size_t size,
+				     enum dma_data_direction dir, u64 dma_mask)
 {
 	struct pci_dev *pdev = to_pci_dev(hwdev);
 	struct dmar_domain *domain;
@@ -1881,7 +1882,7 @@
 }
 
 dma_addr_t intel_map_single(struct device *hwdev, phys_addr_t paddr,
-			    size_t size, int dir)
+			    size_t size, enum dma_data_direction dir)
 {
 	return __intel_map_single(hwdev, paddr, size, dir,
 				  to_pci_dev(hwdev)->dma_mask);
@@ -1946,7 +1947,7 @@
 }
 
 void intel_unmap_single(struct device *dev, dma_addr_t dev_addr, size_t size,
-			int dir)
+			enum dma_data_direction dir)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct dmar_domain *domain;
@@ -2026,7 +2027,7 @@
 #define SG_ENT_VIRT_ADDRESS(sg)	(sg_virt((sg)))
 
 void intel_unmap_sg(struct device *hwdev, struct scatterlist *sglist,
-		    int nelems, int dir)
+		    int nelems, enum dma_data_direction dir)
 {
 	int i;
 	struct pci_dev *pdev = to_pci_dev(hwdev);
@@ -2066,7 +2067,7 @@
 }
 
 static int intel_nontranslate_map_sg(struct device *hddev,
-	struct scatterlist *sglist, int nelems, int dir)
+	struct scatterlist *sglist, int nelems, enum dma_data_direction dir)
 {
 	int i;
 	struct scatterlist *sg;
@@ -2080,7 +2081,7 @@
 }
 
 int intel_map_sg(struct device *hwdev, struct scatterlist *sglist, int nelems,
-		 int dir)
+		 enum dma_data_direction dir)
 {
 	void *addr;
 	int i;
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -355,9 +355,13 @@
 
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
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -42,60 +42,65 @@
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
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -373,7 +373,8 @@
  * Allocates bounce buffer and returns its kernel virtual address.
  */
 static void *
-map_single(struct device *hwdev, phys_addr_t phys, size_t size, int dir)
+map_single(struct device *hwdev, phys_addr_t phys, size_t size,
+	   enum dma_data_direction dir)
 {
 	unsigned long flags;
 	char *dma_addr;
@@ -479,7 +480,8 @@
  * dma_addr is the kernel virtual address of the bounce buffer to unmap.
  */
 static void
-unmap_single(struct device *hwdev, char *dma_addr, size_t size, int dir)
+unmap_single(struct device *hwdev, char *dma_addr, size_t size,
+	     enum dma_data_direction dir)
 {
 	unsigned long flags;
 	int i, count, nslots = ALIGN(size, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT;
@@ -520,7 +522,7 @@
 
 static void
 sync_single(struct device *hwdev, char *dma_addr, size_t size,
-	    int dir, int target)
+	    enum dma_data_direction dir, int target)
 {
 	int index = (dma_addr - io_tlb_start) >> IO_TLB_SHIFT;
 	phys_addr_t phys = io_tlb_orig_addr[index];
@@ -610,7 +612,8 @@
 }
 
 static void
-swiotlb_full(struct device *dev, size_t size, int dir, int do_panic)
+swiotlb_full(struct device *dev, size_t size, enum dma_data_direction dir,
+	     int do_panic)
 {
 	/*
 	 * Ran out of IOMMU space for this operation. This is very bad.
@@ -639,7 +642,7 @@
  */
 dma_addr_t
 swiotlb_map_single_attrs(struct device *hwdev, void *ptr, size_t size,
-			 int dir, struct dma_attrs *attrs)
+			 enum dma_data_direction dir, struct dma_attrs *attrs)
 {
 	dma_addr_t dev_addr = swiotlb_virt_to_bus(hwdev, ptr);
 	void *map;
@@ -676,7 +679,8 @@
 EXPORT_SYMBOL(swiotlb_map_single_attrs);
 
 dma_addr_t
-swiotlb_map_single(struct device *hwdev, void *ptr, size_t size, int dir)
+swiotlb_map_single(struct device *hwdev, void *ptr, size_t size,
+		   enum dma_data_direction dir)
 {
 	return swiotlb_map_single_attrs(hwdev, ptr, size, dir, NULL);
 }
@@ -691,7 +695,8 @@
  */
 void
 swiotlb_unmap_single_attrs(struct device *hwdev, dma_addr_t dev_addr,
-			   size_t size, int dir, struct dma_attrs *attrs)
+			   size_t size, enum dma_data_direction dir,
+			   struct dma_attrs *attrs)
 {
 	char *dma_addr = swiotlb_bus_to_virt(dev_addr);
 
@@ -705,7 +710,7 @@
 
 void
 swiotlb_unmap_single(struct device *hwdev, dma_addr_t dev_addr, size_t size,
-		     int dir)
+		     enum dma_data_direction dir)
 {
 	return swiotlb_unmap_single_attrs(hwdev, dev_addr, size, dir, NULL);
 }
@@ -721,7 +726,7 @@
  */
 static void
 swiotlb_sync_single(struct device *hwdev, dma_addr_t dev_addr,
-		    size_t size, int dir, int target)
+		    size_t size, enum dma_data_direction dir, int target)
 {
 	char *dma_addr = swiotlb_bus_to_virt(dev_addr);
 
@@ -734,14 +739,14 @@
 
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
@@ -752,7 +757,7 @@
 static void
 swiotlb_sync_single_range(struct device *hwdev, dma_addr_t dev_addr,
 			  unsigned long offset, size_t size,
-			  int dir, int target)
+			  enum dma_data_direction dir, int target)
 {
 	char *dma_addr = swiotlb_bus_to_virt(dev_addr) + offset;
 
@@ -765,7 +770,8 @@
 
 void
 swiotlb_sync_single_range_for_cpu(struct device *hwdev, dma_addr_t dev_addr,
-				  unsigned long offset, size_t size, int dir)
+				  unsigned long offset, size_t size,
+				  enum dma_data_direction dir)
 {
 	swiotlb_sync_single_range(hwdev, dev_addr, offset, size, dir,
 				  SYNC_FOR_CPU);
@@ -773,14 +779,15 @@
 
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
@@ -799,7 +806,7 @@
  */
 int
 swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl, int nelems,
-		     int dir, struct dma_attrs *attrs)
+		     enum dma_data_direction dir, struct dma_attrs *attrs)
 {
 	struct scatterlist *sg;
 	int i;
@@ -834,7 +841,7 @@
 
 int
 swiotlb_map_sg(struct device *hwdev, struct scatterlist *sgl, int nelems,
-	       int dir)
+	       enum dma_data_direction dir)
 {
 	return swiotlb_map_sg_attrs(hwdev, sgl, nelems, dir, NULL);
 }
@@ -845,7 +852,8 @@
  */
 void
 swiotlb_unmap_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
-		       int nelems, int dir, struct dma_attrs *attrs)
+		       int nelems, enum dma_data_direction dir,
+		       struct dma_attrs *attrs)
 {
 	struct scatterlist *sg;
 	int i;
@@ -864,7 +872,7 @@
 
 void
 swiotlb_unmap_sg(struct device *hwdev, struct scatterlist *sgl, int nelems,
-		 int dir)
+		 enum dma_data_direction dir)
 {
 	return swiotlb_unmap_sg_attrs(hwdev, sgl, nelems, dir, NULL);
 }
@@ -878,7 +886,7 @@
  */
 static void
 swiotlb_sync_sg(struct device *hwdev, struct scatterlist *sgl,
-		int nelems, int dir, int target)
+		int nelems, enum dma_data_direction dir, int target)
 {
 	struct scatterlist *sg;
 	int i;
@@ -896,14 +904,14 @@
 
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


