Return-Path: <linux-kernel-owner+w=401wt.eu-S1753323AbYAHSYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbYAHSYq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 13:24:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752090AbYAHSYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 13:24:38 -0500
Received: from relay2.sgi.com ([192.48.171.30]:43368 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750907AbYAHSYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 13:24:37 -0500
From: akepner@sgi.com
Date: Tue, 8 Jan 2008 10:23:09 -0800
To: Christoph Hellwig <hch@infradead.org>
Cc: Tony Luck <tony.luck@intel.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Roland Dreier <rdreier@cisco.com>,
       James Bottomley <James.Bottomley@steeleye.com>,
       David Miller <davem@davemloft.net>, Muli Ben-Yehuda <muli@il.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC/PARTIAL PATCH 0/3] dma: passing "attributes" to dma_map_* routines
Message-ID: <20080108182309.GA23661@sgi.com>
References: <20080108023222.GP23661@sgi.com> <20080108175054.GA25168@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080108175054.GA25168@infradead.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2008 at 05:50:54PM +0000, Christoph Hellwig wrote:
> ...
> Onething I've missed with these patches is drivers actually using
> it.  What driver actually needs it and why don't you send patches
> for them?

Some IB drivers need this. Here's an example with the ib_mthca 
driver.

-- 

 drivers/infiniband/core/umem.c               |   10 +++++----
 drivers/infiniband/hw/mthca/mthca_provider.c |   16 +++++++++++++-
 drivers/infiniband/hw/mthca/mthca_user.h     |    9 +++++++-
 include/rdma/ib_umem.h                       |    4 +--
 include/rdma/ib_verbs.h                      |   30 ++++++++++++++++-----------
 5 files changed, 49 insertions(+), 20 deletions(-)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index 4e3128f..709345f 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -35,7 +35,7 @@
  */
 
 #include <linux/mm.h>
-#include <linux/dma-mapping.h>
+#include <linux/dma-direction.h>
 #include <linux/sched.h>
 #include <linux/hugetlb.h>
 
@@ -72,9 +72,10 @@ static void __ib_umem_release(struct ib_device *dev, struct ib_umem *umem, int d
  * @addr: userspace virtual address to start at
  * @size: length of region to pin
  * @access: IB_ACCESS_xxx flags for memory being pinned
+ * @dmabarrier: set "dmabarrier" attribute on this memory
  */
 struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
-			    size_t size, int access)
+			    size_t size, int access, int dmabarrier)
 {
 	struct ib_umem *umem;
 	struct page **page_list;
@@ -87,6 +88,8 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 	int ret;
 	int off;
 	int i;
+	u32 flags = dma_flags_set_dir_attr(DMA_BIDIRECTIONAL, 
+					   dmabarrier ? DMA_ATTR_BARRIER : 0);
 
 	if (!can_do_mlock())
 		return ERR_PTR(-EPERM);
@@ -176,8 +179,7 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 
 			chunk->nmap = ib_dma_map_sg(context->device,
 						    &chunk->page_list[0],
-						    chunk->nents,
-						    DMA_BIDIRECTIONAL);
+						    chunk->nents, flags);
 			if (chunk->nmap <= 0) {
 				for (i = 0; i < chunk->nents; ++i)
 					put_page(sg_page(&chunk->page_list[i]));
diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
index 6bcde1c..7907671 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -1017,17 +1017,31 @@ static struct ib_mr *mthca_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	struct mthca_dev *dev = to_mdev(pd->device);
 	struct ib_umem_chunk *chunk;
 	struct mthca_mr *mr;
+	struct mthca_reg_mr ucmd;
 	u64 *pages;
 	int shift, n, len;
 	int i, j, k;
 	int err = 0;
 	int write_mtt_size;
 
+	if (ib_copy_from_udata(&ucmd, udata, sizeof ucmd))
+		return ERR_PTR(-EFAULT);
+
 	mr = kmalloc(sizeof *mr, GFP_KERNEL);
 	if (!mr)
 		return ERR_PTR(-ENOMEM);
 
-	mr->umem = ib_umem_get(pd->uobject->context, start, length, acc);
+#define _DEBUG_IT_
+#ifdef  _DEBUG_IT_
+	{
+	printk(KERN_CRIT "%s: ucmd.mr_attrs & MTHCA_MR_DMAFLUSH = %d\n",
+		__FUNCTION__, ucmd.mr_attrs & MTHCA_MR_DMAFLUSH);
+	}
+#endif /* _DEBUG_IT_ */
+
+	mr->umem = ib_umem_get(pd->uobject->context, start, length, acc, 
+			       ucmd.mr_attrs & MTHCA_MR_DMAFLUSH);
+
 	if (IS_ERR(mr->umem)) {
 		err = PTR_ERR(mr->umem);
 		goto err;
diff --git a/drivers/infiniband/hw/mthca/mthca_user.h b/drivers/infiniband/hw/mthca/mthca_user.h
index 02cc0a7..76effe3 100644
--- a/drivers/infiniband/hw/mthca/mthca_user.h
+++ b/drivers/infiniband/hw/mthca/mthca_user.h
@@ -41,7 +41,7 @@
  * Increment this value if any changes that break userspace ABI
  * compatibility are made.
  */
-#define MTHCA_UVERBS_ABI_VERSION	1
+#define MTHCA_UVERBS_ABI_VERSION	2
 
 /*
  * Make sure that all structs defined in this file remain laid out so
@@ -61,6 +61,13 @@ struct mthca_alloc_pd_resp {
 	__u32 reserved;
 };
 
+struct mthca_reg_mr {
+	__u32 mr_attrs;
+#define MTHCA_MR_DMAFLUSH 0x1  /* flush in-flight DMA on a write to
+				 * memory region */
+	__u32 reserved;
+};
+
 struct mthca_create_cq {
 	__u32 lkey;
 	__u32 pdn;
diff --git a/include/rdma/ib_umem.h b/include/rdma/ib_umem.h
index 2229842..ac3542e 100644
--- a/include/rdma/ib_umem.h
+++ b/include/rdma/ib_umem.h
@@ -62,7 +62,7 @@ struct ib_umem_chunk {
 #ifdef CONFIG_INFINIBAND_USER_MEM
 
 struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
-			    size_t size, int access);
+			    size_t size, int access, int dmabarrier);
 void ib_umem_release(struct ib_umem *umem);
 int ib_umem_page_count(struct ib_umem *umem);
 
@@ -72,7 +72,7 @@ int ib_umem_page_count(struct ib_umem *umem);
 
 static inline struct ib_umem *ib_umem_get(struct ib_ucontext *context,
 					  unsigned long addr, size_t size,
-					  int access) {
+					  int access, int dmabarrier) {
 	return ERR_PTR(-EINVAL);
 }
 static inline void ib_umem_release(struct ib_umem *umem) { }
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 11f3960..2d7bb9e 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1483,11 +1483,12 @@ static inline int ib_dma_mapping_error(struct ib_device *dev, u64 dma_addr)
  */
 static inline u64 ib_dma_map_single(struct ib_device *dev,
 				    void *cpu_addr, size_t size,
-				    enum dma_data_direction direction)
+				    u32 flags)
 {
+	enum dma_data_direction direction = dma_flags_get_dir(flags);
 	if (dev->dma_ops)
 		return dev->dma_ops->map_single(dev, cpu_addr, size, direction);
-	return dma_map_single(dev->dma_device, cpu_addr, size, direction);
+	return dma_map_single(dev->dma_device, cpu_addr, size, flags);
 }
 
 /**
@@ -1499,12 +1500,13 @@ static inline u64 ib_dma_map_single(struct ib_device *dev,
  */
 static inline void ib_dma_unmap_single(struct ib_device *dev,
 				       u64 addr, size_t size,
-				       enum dma_data_direction direction)
+				       u32 flags)
 {
+	enum dma_data_direction direction = dma_flags_get_dir(flags);
 	if (dev->dma_ops)
 		dev->dma_ops->unmap_single(dev, addr, size, direction);
 	else
-		dma_unmap_single(dev->dma_device, addr, size, direction);
+		dma_unmap_single(dev->dma_device, addr, size, flags);
 }
 
 /**
@@ -1519,11 +1521,12 @@ static inline u64 ib_dma_map_page(struct ib_device *dev,
 				  struct page *page,
 				  unsigned long offset,
 				  size_t size,
-					 enum dma_data_direction direction)
+				  u32 flags)
 {
+	enum dma_data_direction direction = dma_flags_get_dir(flags);
 	if (dev->dma_ops)
 		return dev->dma_ops->map_page(dev, page, offset, size, direction);
-	return dma_map_page(dev->dma_device, page, offset, size, direction);
+	return dma_map_page(dev->dma_device, page, offset, size, flags);
 }
 
 /**
@@ -1535,12 +1538,13 @@ static inline u64 ib_dma_map_page(struct ib_device *dev,
  */
 static inline void ib_dma_unmap_page(struct ib_device *dev,
 				     u64 addr, size_t size,
-				     enum dma_data_direction direction)
+				     u32 flags)
 {
+	enum dma_data_direction direction = dma_flags_get_dir(flags);
 	if (dev->dma_ops)
 		dev->dma_ops->unmap_page(dev, addr, size, direction);
 	else
-		dma_unmap_page(dev->dma_device, addr, size, direction);
+		dma_unmap_page(dev->dma_device, addr, size, flags);
 }
 
 /**
@@ -1552,11 +1556,12 @@ static inline void ib_dma_unmap_page(struct ib_device *dev,
  */
 static inline int ib_dma_map_sg(struct ib_device *dev,
 				struct scatterlist *sg, int nents,
-				enum dma_data_direction direction)
+				u32 flags)
 {
+	enum dma_data_direction direction = dma_flags_get_dir(flags);
 	if (dev->dma_ops)
 		return dev->dma_ops->map_sg(dev, sg, nents, direction);
-	return dma_map_sg(dev->dma_device, sg, nents, direction);
+	return dma_map_sg(dev->dma_device, sg, nents, flags);
 }
 
 /**
@@ -1568,12 +1573,13 @@ static inline int ib_dma_map_sg(struct ib_device *dev,
  */
 static inline void ib_dma_unmap_sg(struct ib_device *dev,
 				   struct scatterlist *sg, int nents,
-				   enum dma_data_direction direction)
+				   u32 flags)
 {
+	enum dma_data_direction direction = dma_flags_get_dir(flags);
 	if (dev->dma_ops)
 		dev->dma_ops->unmap_sg(dev, sg, nents, direction);
 	else
-		dma_unmap_sg(dev->dma_device, sg, nents, direction);
+		dma_unmap_sg(dev->dma_device, sg, nents, flags);
 }
 
 /**


-- 
Arthur

