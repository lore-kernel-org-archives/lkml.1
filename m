Return-Path: <linux-kernel-owner+w=401wt.eu-S1762380AbZCQAbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762380AbZCQAbk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 20:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758397AbZCQA23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 20:28:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:57059 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759895AbZCQA2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 20:28:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,375,1233561600"; 
   d="scan'208";a="395024222"
Message-Id: <20090317001320.004502000@linux-os.sc.intel.com>
References: <20090317000452.805772000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Mon, 16 Mar 2009 17:04:54 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, dwmw2@infradead.org,
       yinghai@kernel.org, steiner@sgi.com
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 02/13] dmar: move page fault handling code to dmar.c
Content-Disposition: inline; filename=move_page_fault_to_dmar.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move page fault handling code to dmar.c
This will be shared both by DMA-remapping and Intr-remapping code.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: tip/drivers/pci/intel-iommu.c
===================================================================
--- tip.orig/drivers/pci/intel-iommu.c
+++ tip/drivers/pci/intel-iommu.c
@@ -1004,194 +1004,6 @@ static int iommu_disable_translation(str
 	return 0;
 }
 
-/* iommu interrupt handling. Most stuff are MSI-like. */
-
-static const char *fault_reason_strings[] =
-{
-	"Software",
-	"Present bit in root entry is clear",
-	"Present bit in context entry is clear",
-	"Invalid context entry",
-	"Access beyond MGAW",
-	"PTE Write access is not set",
-	"PTE Read access is not set",
-	"Next page table ptr is invalid",
-	"Root table address invalid",
-	"Context table ptr is invalid",
-	"non-zero reserved fields in RTP",
-	"non-zero reserved fields in CTP",
-	"non-zero reserved fields in PTE",
-};
-#define MAX_FAULT_REASON_IDX 	(ARRAY_SIZE(fault_reason_strings) - 1)
-
-const char *dmar_get_fault_reason(u8 fault_reason)
-{
-	if (fault_reason > MAX_FAULT_REASON_IDX)
-		return "Unknown";
-	else
-		return fault_reason_strings[fault_reason];
-}
-
-void dmar_msi_unmask(unsigned int irq)
-{
-	struct intel_iommu *iommu = get_irq_data(irq);
-	unsigned long flag;
-
-	/* unmask it */
-	spin_lock_irqsave(&iommu->register_lock, flag);
-	writel(0, iommu->reg + DMAR_FECTL_REG);
-	/* Read a reg to force flush the post write */
-	readl(iommu->reg + DMAR_FECTL_REG);
-	spin_unlock_irqrestore(&iommu->register_lock, flag);
-}
-
-void dmar_msi_mask(unsigned int irq)
-{
-	unsigned long flag;
-	struct intel_iommu *iommu = get_irq_data(irq);
-
-	/* mask it */
-	spin_lock_irqsave(&iommu->register_lock, flag);
-	writel(DMA_FECTL_IM, iommu->reg + DMAR_FECTL_REG);
-	/* Read a reg to force flush the post write */
-	readl(iommu->reg + DMAR_FECTL_REG);
-	spin_unlock_irqrestore(&iommu->register_lock, flag);
-}
-
-void dmar_msi_write(int irq, struct msi_msg *msg)
-{
-	struct intel_iommu *iommu = get_irq_data(irq);
-	unsigned long flag;
-
-	spin_lock_irqsave(&iommu->register_lock, flag);
-	writel(msg->data, iommu->reg + DMAR_FEDATA_REG);
-	writel(msg->address_lo, iommu->reg + DMAR_FEADDR_REG);
-	writel(msg->address_hi, iommu->reg + DMAR_FEUADDR_REG);
-	spin_unlock_irqrestore(&iommu->register_lock, flag);
-}
-
-void dmar_msi_read(int irq, struct msi_msg *msg)
-{
-	struct intel_iommu *iommu = get_irq_data(irq);
-	unsigned long flag;
-
-	spin_lock_irqsave(&iommu->register_lock, flag);
-	msg->data = readl(iommu->reg + DMAR_FEDATA_REG);
-	msg->address_lo = readl(iommu->reg + DMAR_FEADDR_REG);
-	msg->address_hi = readl(iommu->reg + DMAR_FEUADDR_REG);
-	spin_unlock_irqrestore(&iommu->register_lock, flag);
-}
-
-static int iommu_page_fault_do_one(struct intel_iommu *iommu, int type,
-		u8 fault_reason, u16 source_id, unsigned long long addr)
-{
-	const char *reason;
-
-	reason = dmar_get_fault_reason(fault_reason);
-
-	printk(KERN_ERR
-		"DMAR:[%s] Request device [%02x:%02x.%d] "
-		"fault addr %llx \n"
-		"DMAR:[fault reason %02d] %s\n",
-		(type ? "DMA Read" : "DMA Write"),
-		(source_id >> 8), PCI_SLOT(source_id & 0xFF),
-		PCI_FUNC(source_id & 0xFF), addr, fault_reason, reason);
-	return 0;
-}
-
-#define PRIMARY_FAULT_REG_LEN (16)
-static irqreturn_t iommu_page_fault(int irq, void *dev_id)
-{
-	struct intel_iommu *iommu = dev_id;
-	int reg, fault_index;
-	u32 fault_status;
-	unsigned long flag;
-
-	spin_lock_irqsave(&iommu->register_lock, flag);
-	fault_status = readl(iommu->reg + DMAR_FSTS_REG);
-
-	/* TBD: ignore advanced fault log currently */
-	if (!(fault_status & DMA_FSTS_PPF))
-		goto clear_overflow;
-
-	fault_index = dma_fsts_fault_record_index(fault_status);
-	reg = cap_fault_reg_offset(iommu->cap);
-	while (1) {
-		u8 fault_reason;
-		u16 source_id;
-		u64 guest_addr;
-		int type;
-		u32 data;
-
-		/* highest 32 bits */
-		data = readl(iommu->reg + reg +
-				fault_index * PRIMARY_FAULT_REG_LEN + 12);
-		if (!(data & DMA_FRCD_F))
-			break;
-
-		fault_reason = dma_frcd_fault_reason(data);
-		type = dma_frcd_type(data);
-
-		data = readl(iommu->reg + reg +
-				fault_index * PRIMARY_FAULT_REG_LEN + 8);
-		source_id = dma_frcd_source_id(data);
-
-		guest_addr = dmar_readq(iommu->reg + reg +
-				fault_index * PRIMARY_FAULT_REG_LEN);
-		guest_addr = dma_frcd_page_addr(guest_addr);
-		/* clear the fault */
-		writel(DMA_FRCD_F, iommu->reg + reg +
-			fault_index * PRIMARY_FAULT_REG_LEN + 12);
-
-		spin_unlock_irqrestore(&iommu->register_lock, flag);
-
-		iommu_page_fault_do_one(iommu, type, fault_reason,
-				source_id, guest_addr);
-
-		fault_index++;
-		if (fault_index > cap_num_fault_regs(iommu->cap))
-			fault_index = 0;
-		spin_lock_irqsave(&iommu->register_lock, flag);
-	}
-clear_overflow:
-	/* clear primary fault overflow */
-	fault_status = readl(iommu->reg + DMAR_FSTS_REG);
-	if (fault_status & DMA_FSTS_PFO)
-		writel(DMA_FSTS_PFO, iommu->reg + DMAR_FSTS_REG);
-
-	spin_unlock_irqrestore(&iommu->register_lock, flag);
-	return IRQ_HANDLED;
-}
-
-int dmar_set_interrupt(struct intel_iommu *iommu)
-{
-	int irq, ret;
-
-	irq = create_irq();
-	if (!irq) {
-		printk(KERN_ERR "IOMMU: no free vectors\n");
-		return -EINVAL;
-	}
-
-	set_irq_data(irq, iommu);
-	iommu->irq = irq;
-
-	ret = arch_setup_dmar_msi(irq);
-	if (ret) {
-		set_irq_data(irq, NULL);
-		iommu->irq = 0;
-		destroy_irq(irq);
-		return 0;
-	}
-
-	/* Force fault register is cleared */
-	iommu_page_fault(irq, iommu);
-
-	ret = request_irq(irq, iommu_page_fault, 0, iommu->name, iommu);
-	if (ret)
-		printk(KERN_ERR "IOMMU: can't request irq\n");
-	return ret;
-}
 
 static int iommu_init_domains(struct intel_iommu *iommu)
 {
Index: tip/drivers/pci/dmar.c
===================================================================
--- tip.orig/drivers/pci/dmar.c
+++ tip/drivers/pci/dmar.c
@@ -31,6 +31,8 @@
 #include <linux/iova.h>
 #include <linux/intel-iommu.h>
 #include <linux/timer.h>
+#include <linux/irq.h>
+#include <linux/interrupt.h>
 
 #undef PREFIX
 #define PREFIX "DMAR:"
@@ -812,3 +814,192 @@ int dmar_enable_qi(struct intel_iommu *i
 
 	return 0;
 }
+
+/* iommu interrupt handling. Most stuff are MSI-like. */
+
+static const char *fault_reason_strings[] =
+{
+	"Software",
+	"Present bit in root entry is clear",
+	"Present bit in context entry is clear",
+	"Invalid context entry",
+	"Access beyond MGAW",
+	"PTE Write access is not set",
+	"PTE Read access is not set",
+	"Next page table ptr is invalid",
+	"Root table address invalid",
+	"Context table ptr is invalid",
+	"non-zero reserved fields in RTP",
+	"non-zero reserved fields in CTP",
+	"non-zero reserved fields in PTE",
+};
+#define MAX_FAULT_REASON_IDX 	(ARRAY_SIZE(fault_reason_strings) - 1)
+
+const char *dmar_get_fault_reason(u8 fault_reason)
+{
+	if (fault_reason > MAX_FAULT_REASON_IDX)
+		return "Unknown";
+	else
+		return fault_reason_strings[fault_reason];
+}
+
+void dmar_msi_unmask(unsigned int irq)
+{
+	struct intel_iommu *iommu = get_irq_data(irq);
+	unsigned long flag;
+
+	/* unmask it */
+	spin_lock_irqsave(&iommu->register_lock, flag);
+	writel(0, iommu->reg + DMAR_FECTL_REG);
+	/* Read a reg to force flush the post write */
+	readl(iommu->reg + DMAR_FECTL_REG);
+	spin_unlock_irqrestore(&iommu->register_lock, flag);
+}
+
+void dmar_msi_mask(unsigned int irq)
+{
+	unsigned long flag;
+	struct intel_iommu *iommu = get_irq_data(irq);
+
+	/* mask it */
+	spin_lock_irqsave(&iommu->register_lock, flag);
+	writel(DMA_FECTL_IM, iommu->reg + DMAR_FECTL_REG);
+	/* Read a reg to force flush the post write */
+	readl(iommu->reg + DMAR_FECTL_REG);
+	spin_unlock_irqrestore(&iommu->register_lock, flag);
+}
+
+void dmar_msi_write(int irq, struct msi_msg *msg)
+{
+	struct intel_iommu *iommu = get_irq_data(irq);
+	unsigned long flag;
+
+	spin_lock_irqsave(&iommu->register_lock, flag);
+	writel(msg->data, iommu->reg + DMAR_FEDATA_REG);
+	writel(msg->address_lo, iommu->reg + DMAR_FEADDR_REG);
+	writel(msg->address_hi, iommu->reg + DMAR_FEUADDR_REG);
+	spin_unlock_irqrestore(&iommu->register_lock, flag);
+}
+
+void dmar_msi_read(int irq, struct msi_msg *msg)
+{
+	struct intel_iommu *iommu = get_irq_data(irq);
+	unsigned long flag;
+
+	spin_lock_irqsave(&iommu->register_lock, flag);
+	msg->data = readl(iommu->reg + DMAR_FEDATA_REG);
+	msg->address_lo = readl(iommu->reg + DMAR_FEADDR_REG);
+	msg->address_hi = readl(iommu->reg + DMAR_FEUADDR_REG);
+	spin_unlock_irqrestore(&iommu->register_lock, flag);
+}
+
+static int dmar_fault_do_one(struct intel_iommu *iommu, int type,
+		u8 fault_reason, u16 source_id, unsigned long long addr)
+{
+	const char *reason;
+
+	reason = dmar_get_fault_reason(fault_reason);
+
+	printk(KERN_ERR
+		"DMAR:[%s] Request device [%02x:%02x.%d] "
+		"fault addr %llx \n"
+		"DMAR:[fault reason %02d] %s\n",
+		(type ? "DMA Read" : "DMA Write"),
+		(source_id >> 8), PCI_SLOT(source_id & 0xFF),
+		PCI_FUNC(source_id & 0xFF), addr, fault_reason, reason);
+	return 0;
+}
+
+#define PRIMARY_FAULT_REG_LEN (16)
+static irqreturn_t dmar_fault(int irq, void *dev_id)
+{
+	struct intel_iommu *iommu = dev_id;
+	int reg, fault_index;
+	u32 fault_status;
+	unsigned long flag;
+
+	spin_lock_irqsave(&iommu->register_lock, flag);
+	fault_status = readl(iommu->reg + DMAR_FSTS_REG);
+
+	/* TBD: ignore advanced fault log currently */
+	if (!(fault_status & DMA_FSTS_PPF))
+		goto clear_overflow;
+
+	fault_index = dma_fsts_fault_record_index(fault_status);
+	reg = cap_fault_reg_offset(iommu->cap);
+	while (1) {
+		u8 fault_reason;
+		u16 source_id;
+		u64 guest_addr;
+		int type;
+		u32 data;
+
+		/* highest 32 bits */
+		data = readl(iommu->reg + reg +
+				fault_index * PRIMARY_FAULT_REG_LEN + 12);
+		if (!(data & DMA_FRCD_F))
+			break;
+
+		fault_reason = dma_frcd_fault_reason(data);
+		type = dma_frcd_type(data);
+
+		data = readl(iommu->reg + reg +
+				fault_index * PRIMARY_FAULT_REG_LEN + 8);
+		source_id = dma_frcd_source_id(data);
+
+		guest_addr = dmar_readq(iommu->reg + reg +
+				fault_index * PRIMARY_FAULT_REG_LEN);
+		guest_addr = dma_frcd_page_addr(guest_addr);
+		/* clear the fault */
+		writel(DMA_FRCD_F, iommu->reg + reg +
+			fault_index * PRIMARY_FAULT_REG_LEN + 12);
+
+		spin_unlock_irqrestore(&iommu->register_lock, flag);
+
+		dmar_fault_do_one(iommu, type, fault_reason,
+				source_id, guest_addr);
+
+		fault_index++;
+		if (fault_index > cap_num_fault_regs(iommu->cap))
+			fault_index = 0;
+		spin_lock_irqsave(&iommu->register_lock, flag);
+	}
+clear_overflow:
+	/* clear primary fault overflow */
+	fault_status = readl(iommu->reg + DMAR_FSTS_REG);
+	if (fault_status & DMA_FSTS_PFO)
+		writel(DMA_FSTS_PFO, iommu->reg + DMAR_FSTS_REG);
+
+	spin_unlock_irqrestore(&iommu->register_lock, flag);
+	return IRQ_HANDLED;
+}
+
+int dmar_set_interrupt(struct intel_iommu *iommu)
+{
+	int irq, ret;
+
+	irq = create_irq();
+	if (!irq) {
+		printk(KERN_ERR "IOMMU: no free vectors\n");
+		return -EINVAL;
+	}
+
+	set_irq_data(irq, iommu);
+	iommu->irq = irq;
+
+	ret = arch_setup_dmar_msi(irq);
+	if (ret) {
+		set_irq_data(irq, NULL);
+		iommu->irq = 0;
+		destroy_irq(irq);
+		return 0;
+	}
+
+	/* Force fault register is cleared */
+	dmar_fault(irq, iommu);
+
+	ret = request_irq(irq, dmar_fault, 0, iommu->name, iommu);
+	if (ret)
+		printk(KERN_ERR "IOMMU: can't request irq\n");
+	return ret;
+}

-- 

