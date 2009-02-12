Return-Path: <linux-kernel-owner+w=401wt.eu-S1760717AbZBMCwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760717AbZBMCwV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 21:52:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760304AbZBMCv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 21:51:26 -0500
Received: from mga01.intel.com ([192.55.52.88]:61610 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758854AbZBMCvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 21:51:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,200,1233561600"; 
   d="scan'208";a="430659349"
From: Yu Zhao <yu.zhao@intel.com>
To: jbarnes@virtuousgeek.org, dwmw2@infradead.org
Cc: linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Yu Zhao <yu.zhao@intel.com>
Subject: [PATCH v3 3/6] VT-d: add queue invalidation fault status support
Date: Thu, 12 Feb 2009 20:50:35 +0800
Message-Id: <1234443038-15437-4-git-send-email-yu.zhao@intel.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <1234443038-15437-1-git-send-email-yu.zhao@intel.com>
References: <1234443038-15437-1-git-send-email-yu.zhao@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check fault register after submitting an queue invalidation request.

Signed-off-by: Yu Zhao <yu.zhao@intel.com>
---
 drivers/pci/dmar.c           |   63 ++++++++++++++++++++++++++++++++----------
 drivers/pci/intr_remapping.c |   21 ++++++++------
 include/linux/intel-iommu.h  |    4 ++-
 3 files changed, 63 insertions(+), 25 deletions(-)

diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
index bd37b3c..66dda07 100644
--- a/drivers/pci/dmar.c
+++ b/drivers/pci/dmar.c
@@ -671,19 +671,53 @@ static inline void reclaim_free_desc(struct q_inval *qi)
 	}
 }
 
+static int qi_check_fault(struct intel_iommu *iommu, int index)
+{
+	u32 fault;
+	int head;
+	struct q_inval *qi = iommu->qi;
+	int wait_index = (index + 1) % QI_LENGTH;
+
+	fault = readl(iommu->reg + DMAR_FSTS_REG);
+
+	/*
+	 * If IQE happens, the head points to the descriptor associated
+	 * with the error. No new descriptors are fetched until the IQE
+	 * is cleared.
+	 */
+	if (fault & DMA_FSTS_IQE) {
+		head = readl(iommu->reg + DMAR_IQH_REG);
+		if ((head >> DMAR_IQ_OFFSET) == index) {
+			printk(KERN_ERR "VT-d detected invalid descriptor: "
+				"low=%llx, high=%llx\n",
+				(unsigned long long)qi->desc[index].low,
+				(unsigned long long)qi->desc[index].high);
+			memcpy(&qi->desc[index], &qi->desc[wait_index],
+					sizeof(struct qi_desc));
+			__iommu_flush_cache(iommu, &qi->desc[index],
+					sizeof(struct qi_desc));
+			writel(DMA_FSTS_IQE, iommu->reg + DMAR_FSTS_REG);
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
 /*
  * Submit the queued invalidation descriptor to the remapping
  * hardware unit and wait for its completion.
  */
-void qi_submit_sync(struct qi_desc *desc, struct intel_iommu *iommu)
+int qi_submit_sync(struct qi_desc *desc, struct intel_iommu *iommu)
 {
+	int rc = 0;
 	struct q_inval *qi = iommu->qi;
 	struct qi_desc *hw, wait_desc;
 	int wait_index, index;
 	unsigned long flags;
 
 	if (!qi)
-		return;
+		return 0;
 
 	hw = qi->desc;
 
@@ -701,7 +735,8 @@ void qi_submit_sync(struct qi_desc *desc, struct intel_iommu *iommu)
 
 	hw[index] = *desc;
 
-	wait_desc.low = QI_IWD_STATUS_DATA(2) | QI_IWD_STATUS_WRITE | QI_IWD_TYPE;
+	wait_desc.low = QI_IWD_STATUS_DATA(QI_DONE) |
+			QI_IWD_STATUS_WRITE | QI_IWD_TYPE;
 	wait_desc.high = virt_to_phys(&qi->desc_status[wait_index]);
 
 	hw[wait_index] = wait_desc;
@@ -712,13 +747,11 @@ void qi_submit_sync(struct qi_desc *desc, struct intel_iommu *iommu)
 	qi->free_head = (qi->free_head + 2) % QI_LENGTH;
 	qi->free_cnt -= 2;
 
-	spin_lock(&iommu->register_lock);
 	/*
 	 * update the HW tail register indicating the presence of
 	 * new descriptors.
 	 */
-	writel(qi->free_head << 4, iommu->reg + DMAR_IQT_REG);
-	spin_unlock(&iommu->register_lock);
+	writel(qi->free_head << DMAR_IQ_OFFSET, iommu->reg + DMAR_IQT_REG);
 
 	while (qi->desc_status[wait_index] != QI_DONE) {
 		/*
@@ -728,6 +761,10 @@ void qi_submit_sync(struct qi_desc *desc, struct intel_iommu *iommu)
 		 * a deadlock where the interrupt context can wait indefinitely
 		 * for free slots in the queue.
 		 */
+		rc = qi_check_fault(iommu, index);
+		if (rc)
+			break;
+
 		spin_unlock(&qi->q_lock);
 		cpu_relax();
 		spin_lock(&qi->q_lock);
@@ -737,6 +774,8 @@ void qi_submit_sync(struct qi_desc *desc, struct intel_iommu *iommu)
 
 	reclaim_free_desc(qi);
 	spin_unlock_irqrestore(&qi->q_lock, flags);
+
+	return rc;
 }
 
 /*
@@ -749,13 +788,13 @@ void qi_global_iec(struct intel_iommu *iommu)
 	desc.low = QI_IEC_TYPE;
 	desc.high = 0;
 
+	/* should never fail */
 	qi_submit_sync(&desc, iommu);
 }
 
 int qi_flush_context(struct intel_iommu *iommu, u16 did, u16 sid, u8 fm,
 		     u64 type, int non_present_entry_flush)
 {
-
 	struct qi_desc desc;
 
 	if (non_present_entry_flush) {
@@ -769,10 +808,7 @@ int qi_flush_context(struct intel_iommu *iommu, u16 did, u16 sid, u8 fm,
 			| QI_CC_GRAN(type) | QI_CC_TYPE;
 	desc.high = 0;
 
-	qi_submit_sync(&desc, iommu);
-
-	return 0;
-
+	return qi_submit_sync(&desc, iommu);
 }
 
 int qi_flush_iotlb(struct intel_iommu *iommu, u16 did, u64 addr,
@@ -802,10 +838,7 @@ int qi_flush_iotlb(struct intel_iommu *iommu, u16 did, u64 addr,
 	desc.high = QI_IOTLB_ADDR(addr) | QI_IOTLB_IH(ih)
 		| QI_IOTLB_AM(size_order);
 
-	qi_submit_sync(&desc, iommu);
-
-	return 0;
-
+	return qi_submit_sync(&desc, iommu);
 }
 
 /*
diff --git a/drivers/pci/intr_remapping.c b/drivers/pci/intr_remapping.c
index f78371b..45effc5 100644
--- a/drivers/pci/intr_remapping.c
+++ b/drivers/pci/intr_remapping.c
@@ -207,7 +207,7 @@ int alloc_irte(struct intel_iommu *iommu, int irq, u16 count)
 	return index;
 }
 
-static void qi_flush_iec(struct intel_iommu *iommu, int index, int mask)
+static int qi_flush_iec(struct intel_iommu *iommu, int index, int mask)
 {
 	struct qi_desc desc;
 
@@ -215,7 +215,7 @@ static void qi_flush_iec(struct intel_iommu *iommu, int index, int mask)
 		   | QI_IEC_SELECTIVE;
 	desc.high = 0;
 
-	qi_submit_sync(&desc, iommu);
+	return qi_submit_sync(&desc, iommu);
 }
 
 int map_irq_to_irte_handle(int irq, u16 *sub_handle)
@@ -283,6 +283,7 @@ int clear_irte_irq(int irq, struct intel_iommu *iommu, u16 index)
 
 int modify_irte(int irq, struct irte *irte_modified)
 {
+	int rc;
 	int index;
 	struct irte *irte;
 	struct intel_iommu *iommu;
@@ -303,14 +304,15 @@ int modify_irte(int irq, struct irte *irte_modified)
 	set_64bit((unsigned long *)irte, irte_modified->low | (1 << 1));
 	__iommu_flush_cache(iommu, irte, sizeof(*irte));
 
-	qi_flush_iec(iommu, index, 0);
-
+	rc = qi_flush_iec(iommu, index, 0);
 	spin_unlock(&irq_2_ir_lock);
-	return 0;
+
+	return rc;
 }
 
 int flush_irte(int irq)
 {
+	int rc;
 	int index;
 	struct intel_iommu *iommu;
 	struct irq_2_iommu *irq_iommu;
@@ -326,10 +328,10 @@ int flush_irte(int irq)
 
 	index = irq_iommu->irte_index + irq_iommu->sub_handle;
 
-	qi_flush_iec(iommu, index, irq_iommu->irte_mask);
+	rc = qi_flush_iec(iommu, index, irq_iommu->irte_mask);
 	spin_unlock(&irq_2_ir_lock);
 
-	return 0;
+	return rc;
 }
 
 struct intel_iommu *map_ioapic_to_ir(int apic)
@@ -355,6 +357,7 @@ struct intel_iommu *map_dev_to_ir(struct pci_dev *dev)
 
 int free_irte(int irq)
 {
+	int rc = 0;
 	int index, i;
 	struct irte *irte;
 	struct intel_iommu *iommu;
@@ -375,7 +378,7 @@ int free_irte(int irq)
 	if (!irq_iommu->sub_handle) {
 		for (i = 0; i < (1 << irq_iommu->irte_mask); i++)
 			set_64bit((unsigned long *)irte, 0);
-		qi_flush_iec(iommu, index, irq_iommu->irte_mask);
+		rc = qi_flush_iec(iommu, index, irq_iommu->irte_mask);
 	}
 
 	irq_iommu->iommu = NULL;
@@ -385,7 +388,7 @@ int free_irte(int irq)
 
 	spin_unlock(&irq_2_ir_lock);
 
-	return 0;
+	return rc;
 }
 
 static void iommu_set_intr_remapping(struct intel_iommu *iommu, int mode)
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index 5323ad9..0a220c9 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -53,6 +53,7 @@
 #define	DMAR_PHMLIMIT_REG 0x78	/* pmrr high limit */
 #define DMAR_IQH_REG	0x80	/* Invalidation queue head register */
 #define DMAR_IQT_REG	0x88	/* Invalidation queue tail register */
+#define DMAR_IQ_OFFSET	4	/* Invalidation queue head/tail offset */
 #define DMAR_IQA_REG	0x90	/* Invalidation queue addr register */
 #define DMAR_ICS_REG	0x98	/* Invalidation complete status register */
 #define DMAR_IRTA_REG	0xb8    /* Interrupt remapping table addr register */
@@ -194,6 +195,7 @@ static inline void dmar_writeq(void __iomem *addr, u64 val)
 /* FSTS_REG */
 #define DMA_FSTS_PPF ((u32)2)
 #define DMA_FSTS_PFO ((u32)1)
+#define DMA_FSTS_IQE (1 << 4)
 #define dma_fsts_fault_record_index(s) (((s) >> 8) & 0xff)
 
 /* FRCD_REG, 32 bits access */
@@ -329,7 +331,7 @@ extern int qi_flush_iotlb(struct intel_iommu *iommu, u16 did, u64 addr,
 			  unsigned int size_order, u64 type,
 			  int non_present_entry_flush);
 
-extern void qi_submit_sync(struct qi_desc *desc, struct intel_iommu *iommu);
+extern int qi_submit_sync(struct qi_desc *desc, struct intel_iommu *iommu);
 
 extern void *intel_alloc_coherent(struct device *, size_t, dma_addr_t *, gfp_t);
 extern void intel_free_coherent(struct device *, size_t, void *, dma_addr_t);
-- 
1.6.1

