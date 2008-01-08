Return-Path: <linux-kernel-owner+w=401wt.eu-S1757938AbYAHClY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757938AbYAHClY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 21:41:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754339AbYAHClP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 21:41:15 -0500
Received: from relay2.sgi.com ([192.48.171.30]:58439 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752383AbYAHClO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 21:41:14 -0500
From: akepner@sgi.com
Date: Mon, 7 Jan 2008 18:39:47 -0800
To: Tony Luck <tony.luck@intel.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Roland Dreier <rdreier@cisco.com>,
       James Bottomley <James.Bottomley@steeleye.com>,
       David Miller <davem@davemloft.net>, Muli Ben-Yehuda <muli@il.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC/PARTIAL PATCH 3/3] dma: x86_64 allow "attributes" to be used by dma_map_*
Message-ID: <20080108023947.GS23661@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Allow dma "attributes" to be passed to dma_map_*/dma_unmap_*
implementations on x86_64.

Signed-off-by: Arthur Kepner <akepner@sgi.com>

--

 arch/x86/kernel/pci-calgary_64.c |   13 ++++++++-----
 arch/x86/kernel/pci-gart_64.c    |   27 +++++++++++++++++----------
 arch/x86/kernel/pci-nommu_64.c   |    8 ++++----
 drivers/pci/intel-iommu.c        |   10 ++++++----
 include/asm-x86/dma-mapping_64.h |   27 ++++++++++++++++-----------
 include/asm-x86/swiotlb.h        |    8 ++++----
 6 files changed, 55 insertions(+), 38 deletions(-)

diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index 6bf1f71..f742384 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -36,6 +36,7 @@
 #include <linux/pci.h>
 #include <linux/delay.h>
 #include <linux/scatterlist.h>
+#include <linux/dma-direction.h>
 #include <asm/gart.h>
 #include <asm/calgary.h>
 #include <asm/tce.h>
@@ -382,7 +383,7 @@ static inline struct iommu_table *find_iommu_table(struct device *dev)
 }
 
 static void calgary_unmap_sg(struct device *dev,
-	struct scatterlist *sglist, int nelems, int direction)
+	struct scatterlist *sglist, int nelems, u32 flags)
 {
 	struct iommu_table *tbl = find_iommu_table(dev);
 	struct scatterlist *s;
@@ -421,7 +422,7 @@ static int calgary_nontranslate_map_sg(struct device* dev,
 }
 
 static int calgary_map_sg(struct device *dev, struct scatterlist *sg,
-	int nelems, int direction)
+	int nelems, u32 flags)
 {
 	struct iommu_table *tbl = find_iommu_table(dev);
 	struct scatterlist *s;
@@ -429,6 +430,7 @@ static int calgary_map_sg(struct device *dev, struct scatterlist *sg,
 	unsigned int npages;
 	unsigned long entry;
 	int i;
+	enum dma_data_direction direction = dma_flags_get_dir(flags);
 
 	if (!translation_enabled(tbl))
 		return calgary_nontranslate_map_sg(dev, sg, nelems, direction);
@@ -457,7 +459,7 @@ static int calgary_map_sg(struct device *dev, struct scatterlist *sg,
 
 	return nelems;
 error:
-	calgary_unmap_sg(dev, sg, nelems, direction);
+	calgary_unmap_sg(dev, sg, nelems, flags);
 	for_each_sg(sg, s, nelems, i) {
 		sg->dma_address = bad_dma_address;
 		sg->dma_length = 0;
@@ -466,12 +468,13 @@ error:
 }
 
 static dma_addr_t calgary_map_single(struct device *dev, void *vaddr,
-	size_t size, int direction)
+	size_t size, u32 flags)
 {
 	dma_addr_t dma_handle = bad_dma_address;
 	unsigned long uaddr;
 	unsigned int npages;
 	struct iommu_table *tbl = find_iommu_table(dev);
+	enum dma_data_direction direction = dma_flags_get_dir(flags);
 
 	uaddr = (unsigned long)vaddr;
 	npages = num_dma_pages(uaddr, size);
@@ -485,7 +488,7 @@ static dma_addr_t calgary_map_single(struct device *dev, void *vaddr,
 }
 
 static void calgary_unmap_single(struct device *dev, dma_addr_t dma_handle,
-	size_t size, int direction)
+	size_t size, u32 flags)
 {
 	struct iommu_table *tbl = find_iommu_table(dev);
 	unsigned int npages;
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index 06bcba5..da7336a 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -25,6 +25,7 @@
 #include <linux/bitops.h>
 #include <linux/kdebug.h>
 #include <linux/scatterlist.h>
+#include <linux/dma-direction.h>
 #include <asm/atomic.h>
 #include <asm/io.h>
 #include <asm/mtrr.h>
@@ -230,15 +231,17 @@ static dma_addr_t dma_map_area(struct device *dev, dma_addr_t phys_mem,
 }
 
 static dma_addr_t gart_map_simple(struct device *dev, char *buf,
-				 size_t size, int dir)
+				 size_t size, u32 flags)
 {
+	enum dma_data_direction dir = dma_flags_get_dir(flags);
 	dma_addr_t map = dma_map_area(dev, virt_to_bus(buf), size, dir);
 	flush_gart();
 	return map;
 }
 
 /* Map a single area into the IOMMU */
-static dma_addr_t gart_map_single(struct device *dev, void *addr, size_t size, int dir)
+static dma_addr_t gart_map_single(struct device *dev, void *addr, size_t size, 
+				  u32 flags)
 {
 	unsigned long phys_mem, bus;
 
@@ -249,7 +252,7 @@ static dma_addr_t gart_map_single(struct device *dev, void *addr, size_t size, i
 	if (!need_iommu(dev, phys_mem, size))
 		return phys_mem; 
 
-	bus = gart_map_simple(dev, addr, size, dir);
+	bus = gart_map_simple(dev, addr, size, flags);
 	return bus; 
 }
 
@@ -257,7 +260,7 @@ static dma_addr_t gart_map_single(struct device *dev, void *addr, size_t size, i
  * Free a DMA mapping.
  */
 static void gart_unmap_single(struct device *dev, dma_addr_t dma_addr,
-		      size_t size, int direction)
+		      size_t size, u32 flags)
 {
 	unsigned long iommu_page;
 	int npages;
@@ -278,10 +281,12 @@ static void gart_unmap_single(struct device *dev, dma_addr_t dma_addr,
 /*
  * Wrapper for pci_unmap_single working with scatterlists.
  */
-static void gart_unmap_sg(struct device *dev, struct scatterlist *sg, int nents, int dir)
+static void gart_unmap_sg(struct device *dev, struct scatterlist *sg, 
+			  int nents, u32 flags)
 {
 	struct scatterlist *s;
 	int i;
+	enum dma_data_direction dir = dma_flags_get_dir(flags);
 
 	for_each_sg(sg, s, nents, i) {
 		if (!s->dma_length || !s->length)
@@ -292,10 +297,11 @@ static void gart_unmap_sg(struct device *dev, struct scatterlist *sg, int nents,
 
 /* Fallback for dma_map_sg in case of overflow */
 static int dma_map_sg_nonforce(struct device *dev, struct scatterlist *sg,
-			       int nents, int dir)
+			       int nents, u32 flags)
 {
 	struct scatterlist *s;
 	int i;
+	enum dma_data_direction dir = dma_flags_get_dir(flags);
 
 #ifdef CONFIG_IOMMU_DEBUG
 	printk(KERN_DEBUG "dma_map_sg overflow\n");
@@ -307,7 +313,7 @@ static int dma_map_sg_nonforce(struct device *dev, struct scatterlist *sg,
 			addr = dma_map_area(dev, addr, s->length, dir);
 			if (addr == bad_dma_address) { 
 				if (i > 0) 
-					gart_unmap_sg(dev, sg, i, dir);
+					gart_unmap_sg(dev, sg, i, flags);
 				nents = 0; 
 				sg[0].dma_length = 0;
 				break;
@@ -376,7 +382,7 @@ static inline int dma_map_cont(struct scatterlist *start, int nelems,
  * Merge chunks that have page aligned sizes into a continuous mapping. 
  */
 static int gart_map_sg(struct device *dev, struct scatterlist *sg, int nents,
-			int dir)
+		       u32 flags)
 {
 	int i;
 	int out;
@@ -384,6 +390,7 @@ static int gart_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 	unsigned long pages = 0;
 	int need = 0, nextneed;
 	struct scatterlist *s, *ps, *start_sg, *sgmap;
+	enum dma_data_direction dir = dma_flags_get_dir(flags);
 
 	if (nents == 0) 
 		return 0;
@@ -435,10 +442,10 @@ static int gart_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 
 error:
 	flush_gart();
-	gart_unmap_sg(dev, sg, out, dir);
+	gart_unmap_sg(dev, sg, out, flags);
 	/* When it was forced or merged try again in a dumb way */
 	if (force_iommu || iommu_merge) {
-		out = dma_map_sg_nonforce(dev, sg, nents, dir);
+		out = dma_map_sg_nonforce(dev, sg, nents, flags);
 		if (out > 0)
 			return out;
 	}
diff --git a/arch/x86/kernel/pci-nommu_64.c b/arch/x86/kernel/pci-nommu_64.c
index ab08e18..6c31163 100644
--- a/arch/x86/kernel/pci-nommu_64.c
+++ b/arch/x86/kernel/pci-nommu_64.c
@@ -27,7 +27,7 @@ check_addr(char *name, struct device *hwdev, dma_addr_t bus, size_t size)
 
 static dma_addr_t
 nommu_map_single(struct device *hwdev, void *ptr, size_t size,
-	       int direction)
+	       u32 flags)
 {
 	dma_addr_t bus = virt_to_bus(ptr);
 	if (!check_addr("map_single", hwdev, bus, size))
@@ -36,7 +36,7 @@ nommu_map_single(struct device *hwdev, void *ptr, size_t size,
 }
 
 static void nommu_unmap_single(struct device *dev, dma_addr_t addr,size_t size,
-			int direction)
+			u32 flags)
 {
 }
 
@@ -56,7 +56,7 @@ static void nommu_unmap_single(struct device *dev, dma_addr_t addr,size_t size,
  * the same here.
  */
 static int nommu_map_sg(struct device *hwdev, struct scatterlist *sg,
-	       int nents, int direction)
+	       int nents, u32 flags)
 {
 	struct scatterlist *s;
 	int i;
@@ -76,7 +76,7 @@ static int nommu_map_sg(struct device *hwdev, struct scatterlist *sg,
  * pci_unmap_single() above.
  */
 static void nommu_unmap_sg(struct device *dev, struct scatterlist *sg,
-		  int nents, int dir)
+		  int nents, u32 flags)
 {
 }
 
diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index e079a52..934e199 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -1825,7 +1825,7 @@ get_valid_domain_for_dev(struct pci_dev *pdev)
 }
 
 static dma_addr_t intel_map_single(struct device *hwdev, void *addr,
-	size_t size, int dir)
+	size_t size, u32 flags)
 {
 	struct pci_dev *pdev = to_pci_dev(hwdev);
 	int ret;
@@ -1833,6 +1833,7 @@ static dma_addr_t intel_map_single(struct device *hwdev, void *addr,
 	unsigned long start_addr;
 	struct iova *iova;
 	int prot = 0;
+	enum dma_data_direction dir = dma_flags_get_dir(flags);
 
 	BUG_ON(dir == DMA_NONE);
 	if (pdev->dev.archdata.iommu == DUMMY_DEVICE_DOMAIN_INFO)
@@ -1892,7 +1893,7 @@ error:
 }
 
 static void intel_unmap_single(struct device *dev, dma_addr_t dev_addr,
-	size_t size, int dir)
+	size_t size, u32 flags)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct dmar_domain *domain;
@@ -1963,7 +1964,7 @@ static void intel_free_coherent(struct device *hwdev, size_t size,
 
 #define SG_ENT_VIRT_ADDRESS(sg)	(sg_virt((sg)))
 static void intel_unmap_sg(struct device *hwdev, struct scatterlist *sglist,
-	int nelems, int dir)
+	int nelems, u32 flags)
 {
 	int i;
 	struct pci_dev *pdev = to_pci_dev(hwdev);
@@ -2017,7 +2018,7 @@ static int intel_nontranslate_map_sg(struct device *hddev,
 }
 
 static int intel_map_sg(struct device *hwdev, struct scatterlist *sglist,
-				int nelems, int dir)
+			int nelems, u32 flags)
 {
 	void *addr;
 	int i;
@@ -2030,6 +2031,7 @@ static int intel_map_sg(struct device *hwdev, struct scatterlist *sglist,
 	int ret;
 	struct scatterlist *sg;
 	unsigned long start_addr;
+	enum dma_data_direction dir = dma_flags_get_dir(flags);
 
 	BUG_ON(dir == DMA_NONE);
 	if (pdev->dev.archdata.iommu == DUMMY_DEVICE_DOMAIN_INFO)
diff --git a/include/asm-x86/dma-mapping_64.h b/include/asm-x86/dma-mapping_64.h
index ecd0f61..4bf1359 100644
--- a/include/asm-x86/dma-mapping_64.h
+++ b/include/asm-x86/dma-mapping_64.h
@@ -7,6 +7,7 @@
  */
 
 #include <linux/scatterlist.h>
+#include <linux/dma-direction.h>
 #include <asm/io.h>
 #include <asm/swiotlb.h>
 
@@ -17,12 +18,12 @@ struct dma_mapping_ops {
 	void            (*free_coherent)(struct device *dev, size_t size,
                                 void *vaddr, dma_addr_t dma_handle);
 	dma_addr_t      (*map_single)(struct device *hwdev, void *ptr,
-                                size_t size, int direction);
+                                size_t size, u32 flags);
 	/* like map_single, but doesn't check the device mask */
 	dma_addr_t      (*map_simple)(struct device *hwdev, char *ptr,
-                                size_t size, int direction);
+                                size_t size, u32 flags);
 	void            (*unmap_single)(struct device *dev, dma_addr_t addr,
-		                size_t size, int direction);
+		                size_t size, u32 flags);
 	void            (*sync_single_for_cpu)(struct device *hwdev,
 		                dma_addr_t dma_handle, size_t size,
 				int direction);
@@ -42,10 +43,10 @@ struct dma_mapping_ops {
 				struct scatterlist *sg, int nelems,
 				int direction);
 	int             (*map_sg)(struct device *hwdev, struct scatterlist *sg,
-		                int nents, int direction);
+		                int nents, u32 flags);
 	void            (*unmap_sg)(struct device *hwdev,
 				struct scatterlist *sg, int nents,
-				int direction);
+				u32 flags);
 	int             (*dma_supported)(struct device *hwdev, u64 mask);
 	int		is_phys;
 };
@@ -75,22 +76,24 @@ extern void dma_free_coherent(struct device *dev, size_t size, void *vaddr,
 
 static inline dma_addr_t
 dma_map_single(struct device *hwdev, void *ptr, size_t size,
-	       int direction)
+	       u32 flags)
 {
+	enum dma_data_direction direction = dma_flags_get_dir(flags);
 	BUG_ON(!valid_dma_direction(direction));
 	return dma_ops->map_single(hwdev, ptr, size, direction);
 }
 
 static inline void
 dma_unmap_single(struct device *dev, dma_addr_t addr,size_t size,
-		 int direction)
+		 u32 flags)
 {
+	enum dma_data_direction direction = dma_flags_get_dir(flags);
 	BUG_ON(!valid_dma_direction(direction));
 	dma_ops->unmap_single(dev, addr, size, direction);
 }
 
-#define dma_map_page(dev,page,offset,size,dir) \
-	dma_map_single((dev), page_address(page)+(offset), (size), (dir))
+#define dma_map_page(dev,page,offset,size,flags) \
+	dma_map_single((dev), page_address(page)+(offset), (size), (flags))
 
 #define dma_unmap_page dma_unmap_single
 
@@ -163,16 +166,18 @@ dma_sync_sg_for_device(struct device *hwdev, struct scatterlist *sg,
 }
 
 static inline int
-dma_map_sg(struct device *hwdev, struct scatterlist *sg, int nents, int direction)
+dma_map_sg(struct device *hwdev, struct scatterlist *sg, int nents, u32 flags)
 {
+	enum dma_data_direction direction = dma_flags_get_dir(flags);
 	BUG_ON(!valid_dma_direction(direction));
 	return dma_ops->map_sg(hwdev, sg, nents, direction);
 }
 
 static inline void
 dma_unmap_sg(struct device *hwdev, struct scatterlist *sg, int nents,
-	     int direction)
+	     u32 flags)
 {
+	enum dma_data_direction direction = dma_flags_get_dir(flags);
 	BUG_ON(!valid_dma_direction(direction));
 	dma_ops->unmap_sg(hwdev, sg, nents, direction);
 }
diff --git a/include/asm-x86/swiotlb.h b/include/asm-x86/swiotlb.h
index f9c5895..ad3ea99 100644
--- a/include/asm-x86/swiotlb.h
+++ b/include/asm-x86/swiotlb.h
@@ -6,11 +6,11 @@
 /* SWIOTLB interface */
 
 extern dma_addr_t swiotlb_map_single(struct device *hwdev, void *ptr,
-				     size_t size, int dir);
+				     size_t size, u32 flags);
 extern void *swiotlb_alloc_coherent(struct device *hwdev, size_t size,
                        dma_addr_t *dma_handle, gfp_t flags);
 extern void swiotlb_unmap_single(struct device *hwdev, dma_addr_t dev_addr,
-				  size_t size, int dir);
+				  size_t size, u32 flags);
 extern void swiotlb_sync_single_for_cpu(struct device *hwdev,
 					 dma_addr_t dev_addr,
 					 size_t size, int dir);
@@ -32,9 +32,9 @@ extern void swiotlb_sync_sg_for_device(struct device *hwdev,
 					struct scatterlist *sg, int nelems,
 					int dir);
 extern int swiotlb_map_sg(struct device *hwdev, struct scatterlist *sg,
-		      int nents, int direction);
+		      int nents, u32 flags);
 extern void swiotlb_unmap_sg(struct device *hwdev, struct scatterlist *sg,
-			 int nents, int direction);
+			 int nents, u32 flags);
 extern int swiotlb_dma_mapping_error(dma_addr_t dma_addr);
 extern void swiotlb_free_coherent (struct device *hwdev, size_t size,
 				   void *vaddr, dma_addr_t dma_handle);

-- 
Arthur

