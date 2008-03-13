Return-Path: <linux-kernel-owner+w=401wt.eu-S1752285AbYCMEEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285AbYCMEEP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 00:04:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750807AbYCMEEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 00:04:00 -0400
Received: from relay2.sgi.com ([192.48.171.30]:55023 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750783AbYCMEEA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 00:04:00 -0400
From: akepner@sgi.com
Date: Wed, 12 Mar 2008 21:02:33 -0700
To: Tony Luck <tony.luck@intel.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jes Sorensen <jes@sgi.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       Roland Dreier <rdreier@cisco.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Grant Grundler <grundler@parisc-linux.org>,
       Michael Ellerman <michael@ellerman.id.au>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/4 v4] swiotlb: introduce swiotlb_*_attrs() functions
Message-ID: <20080313040233.GL12370@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Introduce swiotlb_{map|unmap}_{single|sg}_attrs() functions 
in anticipation of using them when redefining the ia64 machvecs.


Signed-off-by: Arthur Kepner <akepner@sgi.com>
Acked-by:  Jesse Barnes <jesse.barnes@intel.com>

---

 swiotlb.c |   50 ++++++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 42 insertions(+), 8 deletions(-)
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 4bb5a11..5776897 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -564,7 +564,8 @@ swiotlb_full(struct device *dev, size_t size, int dir, int do_panic)
  * either swiotlb_unmap_single or swiotlb_dma_sync_single is performed.
  */
 dma_addr_t
-swiotlb_map_single(struct device *hwdev, void *ptr, size_t size, int dir)
+swiotlb_map_single_attrs(struct device *hwdev, void *ptr, size_t size,
+			 int dir, struct dma_attrs *attrs)
 {
 	dma_addr_t dev_addr = virt_to_bus(ptr);
 	void *map;
@@ -597,6 +598,13 @@ swiotlb_map_single(struct device *hwdev, void *ptr, size_t size, int dir)
 
 	return dev_addr;
 }
+EXPORT_SYMBOL(swiotlb_map_single_attrs);
+
+dma_addr_t
+swiotlb_map_single(struct device *hwdev, void *ptr, size_t size, int dir)
+{
+	return swiotlb_map_single_attrs(hwdev, ptr, size, dir, NULL);
+}
 
 /*
  * Unmap a single streaming mode DMA translation.  The dma_addr and size must
@@ -607,8 +615,8 @@ swiotlb_map_single(struct device *hwdev, void *ptr, size_t size, int dir)
  * whatever the device wrote there.
  */
 void
-swiotlb_unmap_single(struct device *hwdev, dma_addr_t dev_addr, size_t size,
-		     int dir)
+swiotlb_unmap_single_attrs(struct device *hwdev, dma_addr_t dev_addr,
+			   size_t size, int dir, struct dma_attrs *attrs)
 {
 	char *dma_addr = bus_to_virt(dev_addr);
 
@@ -618,7 +626,14 @@ swiotlb_unmap_single(struct device *hwdev, dma_addr_t dev_addr, size_t size,
 	else if (dir == DMA_FROM_DEVICE)
 		dma_mark_clean(dma_addr, size);
 }
+EXPORT_SYMBOL(swiotlb_unmap_single_attrs);
 
+void
+swiotlb_unmap_single(struct device *hwdev, dma_addr_t dev_addr, size_t size,
+		     int dir)
+{
+	return swiotlb_unmap_single_attrs(hwdev, dev_addr, size, dir, NULL);
+}
 /*
  * Make physical memory consistent for a single streaming mode DMA translation
  * after a transfer.
@@ -689,6 +704,8 @@ swiotlb_sync_single_range_for_device(struct device *hwdev, dma_addr_t dev_addr,
 				  SYNC_FOR_DEVICE);
 }
 
+void swiotlb_unmap_sg_attrs(struct device *, struct scatterlist *, int, int,
+			    struct dma_attrs *);
 /*
  * Map a set of buffers described by scatterlist in streaming mode for DMA.
  * This is the scatter-gather version of the above swiotlb_map_single
@@ -706,8 +723,8 @@ swiotlb_sync_single_range_for_device(struct device *hwdev, dma_addr_t dev_addr,
  * same here.
  */
 int
-swiotlb_map_sg(struct device *hwdev, struct scatterlist *sgl, int nelems,
-	       int dir)
+swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl, int nelems,
+		     int dir, struct dma_attrs *attrs)
 {
 	struct scatterlist *sg;
 	void *addr;
@@ -725,7 +742,8 @@ swiotlb_map_sg(struct device *hwdev, struct scatterlist *sgl, int nelems,
 				/* Don't panic here, we expect map_sg users
 				   to do proper error handling. */
 				swiotlb_full(hwdev, sg->length, dir, 0);
-				swiotlb_unmap_sg(hwdev, sgl, i, dir);
+				swiotlb_unmap_sg_attrs(hwdev, sgl, i, dir,
+						       attrs);
 				sgl[0].dma_length = 0;
 				return 0;
 			}
@@ -736,14 +754,22 @@ swiotlb_map_sg(struct device *hwdev, struct scatterlist *sgl, int nelems,
 	}
 	return nelems;
 }
+EXPORT_SYMBOL(swiotlb_map_sg_attrs);
+
+int
+swiotlb_map_sg(struct device *hwdev, struct scatterlist *sgl, int nelems,
+	       int dir)
+{
+	return swiotlb_map_sg_attrs(hwdev, sgl, nelems, dir, NULL);
+}
 
 /*
  * Unmap a set of streaming mode DMA translations.  Again, cpu read rules
  * concerning calls here are the same as for swiotlb_unmap_single() above.
  */
 void
-swiotlb_unmap_sg(struct device *hwdev, struct scatterlist *sgl, int nelems,
-		 int dir)
+swiotlb_unmap_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
+		       int nelems, int dir, struct dma_attrs *attrs)
 {
 	struct scatterlist *sg;
 	int i;
@@ -758,6 +784,14 @@ swiotlb_unmap_sg(struct device *hwdev, struct scatterlist *sgl, int nelems,
 			dma_mark_clean(SG_ENT_VIRT_ADDRESS(sg), sg->dma_length);
 	}
 }
+EXPORT_SYMBOL(swiotlb_unmap_sg_attrs);
+
+void
+swiotlb_unmap_sg(struct device *hwdev, struct scatterlist *sgl, int nelems,
+		 int dir)
+{
+	return swiotlb_unmap_sg_attrs(hwdev, sgl, nelems, dir, NULL);
+}
 
 /*
  * Make physical memory consistent for a set of streaming mode DMA translations
