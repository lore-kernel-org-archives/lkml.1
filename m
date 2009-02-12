Return-Path: <linux-kernel-owner+w=401wt.eu-S1761684AbZBMCwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761684AbZBMCwi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 21:52:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760589AbZBMCv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 21:51:29 -0500
Received: from mga01.intel.com ([192.55.52.88]:61626 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758927AbZBMCvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 21:51:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,200,1233561600"; 
   d="scan'208";a="430659373"
From: Yu Zhao <yu.zhao@intel.com>
To: jbarnes@virtuousgeek.org, dwmw2@infradead.org
Cc: linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Yu Zhao <yu.zhao@intel.com>
Subject: [PATCH v3 4/6] VT-d: add device IOTLB invalidation support
Date: Thu, 12 Feb 2009 20:50:36 +0800
Message-Id: <1234443038-15437-5-git-send-email-yu.zhao@intel.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <1234443038-15437-1-git-send-email-yu.zhao@intel.com>
References: <1234443038-15437-1-git-send-email-yu.zhao@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support device IOTLB invalidation to flush the translation cached in the
Endpoint.

Signed-off-by: Yu Zhao <yu.zhao@intel.com>
---
 drivers/pci/dmar.c          |   63 ++++++++++++++++++++++++++++++++++++++++--
 include/linux/intel-iommu.h |   13 ++++++++-
 2 files changed, 72 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
index 66dda07..93b38e7 100644
--- a/drivers/pci/dmar.c
+++ b/drivers/pci/dmar.c
@@ -664,7 +664,8 @@ void free_iommu(struct intel_iommu *iommu)
  */
 static inline void reclaim_free_desc(struct q_inval *qi)
 {
-	while (qi->desc_status[qi->free_tail] == QI_DONE) {
+	while (qi->desc_status[qi->free_tail] == QI_DONE ||
+	       qi->desc_status[qi->free_tail] == QI_ABORT) {
 		qi->desc_status[qi->free_tail] = QI_FREE;
 		qi->free_tail = (qi->free_tail + 1) % QI_LENGTH;
 		qi->free_cnt++;
@@ -674,10 +675,13 @@ static inline void reclaim_free_desc(struct q_inval *qi)
 static int qi_check_fault(struct intel_iommu *iommu, int index)
 {
 	u32 fault;
-	int head;
+	int head, tail;
 	struct q_inval *qi = iommu->qi;
 	int wait_index = (index + 1) % QI_LENGTH;
 
+	if (qi->desc_status[wait_index] == QI_ABORT)
+		return -EAGAIN;
+
 	fault = readl(iommu->reg + DMAR_FSTS_REG);
 
 	/*
@@ -701,6 +705,32 @@ static int qi_check_fault(struct intel_iommu *iommu, int index)
 		}
 	}
 
+	/*
+	 * If ITE happens, all pending wait_desc commands are aborted.
+	 * No new descriptors are fetched until the ITE is cleared.
+	 */
+	if (fault & DMA_FSTS_ITE) {
+		head = readl(iommu->reg + DMAR_IQH_REG);
+		head = ((head >> DMAR_IQ_OFFSET) - 1 + QI_LENGTH) % QI_LENGTH;
+		head |= 1;
+		tail = readl(iommu->reg + DMAR_IQT_REG);
+		tail = ((tail >> DMAR_IQ_OFFSET) - 1 + QI_LENGTH) % QI_LENGTH;
+
+		writel(DMA_FSTS_ITE, iommu->reg + DMAR_FSTS_REG);
+
+		do {
+			if (qi->desc_status[head] == QI_IN_USE)
+				qi->desc_status[head] = QI_ABORT;
+			head = (head - 2 + QI_LENGTH) % QI_LENGTH;
+		} while (head != tail);
+
+		if (qi->desc_status[wait_index] == QI_ABORT)
+			return -EAGAIN;
+	}
+
+	if (fault & DMA_FSTS_ICE)
+		writel(DMA_FSTS_ICE, iommu->reg + DMAR_FSTS_REG);
+
 	return 0;
 }
 
@@ -710,7 +740,7 @@ static int qi_check_fault(struct intel_iommu *iommu, int index)
  */
 int qi_submit_sync(struct qi_desc *desc, struct intel_iommu *iommu)
 {
-	int rc = 0;
+	int rc;
 	struct q_inval *qi = iommu->qi;
 	struct qi_desc *hw, wait_desc;
 	int wait_index, index;
@@ -721,6 +751,9 @@ int qi_submit_sync(struct qi_desc *desc, struct intel_iommu *iommu)
 
 	hw = qi->desc;
 
+restart:
+	rc = 0;
+
 	spin_lock_irqsave(&qi->q_lock, flags);
 	while (qi->free_cnt < 3) {
 		spin_unlock_irqrestore(&qi->q_lock, flags);
@@ -775,6 +808,9 @@ int qi_submit_sync(struct qi_desc *desc, struct intel_iommu *iommu)
 	reclaim_free_desc(qi);
 	spin_unlock_irqrestore(&qi->q_lock, flags);
 
+	if (rc == -EAGAIN)
+		goto restart;
+
 	return rc;
 }
 
@@ -841,6 +877,27 @@ int qi_flush_iotlb(struct intel_iommu *iommu, u16 did, u64 addr,
 	return qi_submit_sync(&desc, iommu);
 }
 
+int qi_flush_dev_iotlb(struct intel_iommu *iommu, u16 sid, u16 qdep,
+			u64 addr, unsigned mask)
+{
+	struct qi_desc desc;
+
+	if (mask) {
+		BUG_ON(addr & ((1 << (VTD_PAGE_SHIFT + mask)) - 1));
+		addr |= (1 << (VTD_PAGE_SHIFT + mask - 1)) - 1;
+		desc.high = QI_DEV_IOTLB_ADDR(addr) | QI_DEV_IOTLB_SIZE;
+	} else
+		desc.high = QI_DEV_IOTLB_ADDR(addr);
+
+	if (qdep >= QI_DEV_IOTLB_MAX_INVS)
+		qdep = 0;
+
+	desc.low = QI_DEV_IOTLB_SID(sid) | QI_DEV_IOTLB_QDEP(qdep) |
+		   QI_DIOTLB_TYPE;
+
+	return qi_submit_sync(&desc, iommu);
+}
+
 /*
  * Enable Queued Invalidation interface. This is a must to support
  * interrupt-remapping. Also used by DMA-remapping, which replaces
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index 0a220c9..d82bdac 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -196,6 +196,8 @@ static inline void dmar_writeq(void __iomem *addr, u64 val)
 #define DMA_FSTS_PPF ((u32)2)
 #define DMA_FSTS_PFO ((u32)1)
 #define DMA_FSTS_IQE (1 << 4)
+#define DMA_FSTS_ICE (1 << 5)
+#define DMA_FSTS_ITE (1 << 6)
 #define dma_fsts_fault_record_index(s) (((s) >> 8) & 0xff)
 
 /* FRCD_REG, 32 bits access */
@@ -224,7 +226,8 @@ do {									\
 enum {
 	QI_FREE,
 	QI_IN_USE,
-	QI_DONE
+	QI_DONE,
+	QI_ABORT
 };
 
 #define QI_CC_TYPE		0x1
@@ -253,6 +256,12 @@ enum {
 #define QI_CC_DID(did)		(((u64)did) << 16)
 #define QI_CC_GRAN(gran)	(((u64)gran) >> (DMA_CCMD_INVL_GRANU_OFFSET-4))
 
+#define QI_DEV_IOTLB_SID(sid)	((u64)((sid) & 0xffff) << 32)
+#define QI_DEV_IOTLB_QDEP(qdep)	(((qdep) & 0x1f) << 16)
+#define QI_DEV_IOTLB_ADDR(addr)	((u64)(addr) & VTD_PAGE_MASK)
+#define QI_DEV_IOTLB_SIZE	1
+#define QI_DEV_IOTLB_MAX_INVS	32
+
 struct qi_desc {
 	u64 low, high;
 };
@@ -330,6 +339,8 @@ extern int qi_flush_context(struct intel_iommu *iommu, u16 did, u16 sid,
 extern int qi_flush_iotlb(struct intel_iommu *iommu, u16 did, u64 addr,
 			  unsigned int size_order, u64 type,
 			  int non_present_entry_flush);
+extern int qi_flush_dev_iotlb(struct intel_iommu *iommu, u16 sid, u16 qdep,
+			       u64 addr, unsigned mask);
 
 extern int qi_submit_sync(struct qi_desc *desc, struct intel_iommu *iommu);
 
-- 
1.6.1

