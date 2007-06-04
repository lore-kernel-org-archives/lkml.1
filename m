Return-Path: <linux-kernel-owner+w=401wt.eu-S1762215AbXFDWdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762215AbXFDWdm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 18:33:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761365AbXFDWbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 18:31:55 -0400
Received: from mga05.intel.com ([192.55.52.89]:1270 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761356AbXFDWbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 18:31:53 -0400
X-ExtLoopCount2: 2 from 172.25.110.8
X-IronPort-AV: E=Sophos;i="4.16,382,1175497200"; 
   d="scan'208";a="253154395"
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,382,1175497200"; 
   d="scan'208";a="93415311"
Message-Id: <20070604210644.672651000@askeshav-devel.jf.intel.com>
References: <20070604210242.079459000@askeshav-devel.jf.intel.com>
User-Agent: quilt/0.46-1
Date: Mon, 04 Jun 2007 14:02:50 -0700
From: anil.s.keshavamurthy@intel.com
To: linux-kernel@vger.kernel.org
Cc: akpm@osdl.org, ak@suse.de, gregkh@suse.de, muli@il.ibm.com,
       asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       anil.s.keshavamurthy@intel.com, arjan@linux.intel.com,
       ashok.raj@intel.com, shaohua.li@intel.com, davem@davemloft.net
Subject: [Intel-IOMMU 08/10] DMAR fault handling support
Content-Disposition: inline; filename=dmar_fault_handling_support.patch
X-OriginalArrivalTime: 04 Jun 2007 21:24:02.0635 (UTC) FILETIME=[AC4AA9B0:01C7A6EE]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	MSI interrupt handler registrations and fault handling support
for Intel-IOMMU hadrware.

Signed-off-by: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
---
 Documentation/Intel-IOMMU.txt |   17 +++
 arch/x86_64/kernel/io_apic.c  |   59 ++++++++++++
 drivers/pci/intel-iommu.c     |  194 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/dmar.h          |   12 ++
 4 files changed, 281 insertions(+), 1 deletion(-)

Index: linux-2.6.22-rc3/Documentation/Intel-IOMMU.txt
===================================================================
--- linux-2.6.22-rc3.orig/Documentation/Intel-IOMMU.txt	2007-06-04 12:40:29.000000000 -0700
+++ linux-2.6.22-rc3/Documentation/Intel-IOMMU.txt	2007-06-04 12:40:58.000000000 -0700
@@ -63,6 +63,15 @@
 The same is true for peer to peer transactions. Hence we reserve the
 address from PCI MMIO ranges so they are not allocated for IOVA addresses.
 
+
+Fault reporting
+---------------
+When errors are reported, the DMA engine signals via an interrupt. The fault
+reason and device that caused it with fault reason is printed on console.
+
+See below for sample.
+
+
 Boot Message Sample
 -------------------
 
@@ -85,6 +94,14 @@
 
 PCI-DMA: Using DMAR IOMMU
 
+Fault reporting
+---------------
+
+DMAR:[DMA Write] Request device [00:02.0] fault addr 6df084000
+DMAR:[fault reason 05] PTE Write access is not set
+DMAR:[DMA Write] Request device [00:02.0] fault addr 6df084000
+DMAR:[fault reason 05] PTE Write access is not set
+
 TBD
 ----
 
Index: linux-2.6.22-rc3/arch/x86_64/kernel/io_apic.c
===================================================================
--- linux-2.6.22-rc3.orig/arch/x86_64/kernel/io_apic.c	2007-06-04 12:19:13.000000000 -0700
+++ linux-2.6.22-rc3/arch/x86_64/kernel/io_apic.c	2007-06-04 12:40:58.000000000 -0700
@@ -31,6 +31,7 @@
 #include <linux/sysdev.h>
 #include <linux/msi.h>
 #include <linux/htirq.h>
+#include <linux/dmar.h>
 #ifdef CONFIG_ACPI
 #include <acpi/acpi_bus.h>
 #endif
@@ -1972,8 +1973,64 @@
 	destroy_irq(irq);
 }
 
-#endif /* CONFIG_PCI_MSI */
+#ifdef CONFIG_DMAR
+#ifdef CONFIG_SMP
+static void dmar_msi_set_affinity(unsigned int irq, cpumask_t mask)
+{
+	struct irq_cfg *cfg = irq_cfg + irq;
+	struct msi_msg msg;
+	unsigned int dest;
+	cpumask_t tmp;
+
+	cpus_and(tmp, mask, cpu_online_map);
+	if (cpus_empty(tmp))
+		return;
+
+	if (assign_irq_vector(irq, mask))
+		return;
+
+	cpus_and(tmp, cfg->domain, mask);
+	dest = cpu_mask_to_apicid(tmp);
+
+	dmar_msi_read(irq, &msg);
+
+	msg.data &= ~MSI_DATA_VECTOR_MASK;
+	msg.data |= MSI_DATA_VECTOR(cfg->vector);
+	msg.address_lo &= ~MSI_ADDR_DEST_ID_MASK;
+	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
+
+	dmar_msi_write(irq, &msg);
+	irq_desc[irq].affinity = mask;
+}
+#endif /* CONFIG_SMP */
+
+struct irq_chip dmar_msi_type = {
+	.name = "DMAR_MSI",
+	.unmask = dmar_msi_unmask,
+	.mask = dmar_msi_mask,
+	.ack = ack_apic_edge,
+#ifdef CONFIG_SMP
+	.set_affinity = dmar_msi_set_affinity,
+#endif
+	.retrigger = ioapic_retrigger_irq,
+};
+
+int arch_setup_dmar_msi(unsigned int irq)
+{
+	int ret;
+	struct msi_msg msg;
+
+	ret = msi_compose_msg(NULL, irq, &msg);
+	if (ret < 0)
+		return ret;
+	dmar_msi_write(irq, &msg);
+	set_irq_chip_and_handler_name(irq, &dmar_msi_type, handle_edge_irq,
+		"edge");
+	return 0;
+}
+#endif
 
+#endif /* CONFIG_PCI_MSI */
 /*
  * Hypertransport interrupt support
  */
Index: linux-2.6.22-rc3/drivers/pci/intel-iommu.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/pci/intel-iommu.c	2007-06-04 12:40:41.000000000 -0700
+++ linux-2.6.22-rc3/drivers/pci/intel-iommu.c	2007-06-04 12:40:58.000000000 -0700
@@ -684,6 +684,196 @@
 	return 0;
 }
 
+/* iommu interrupt handling. Most stuff are MSI-like. */
+
+static char *fault_reason_strings[] =
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
+	"Unknown"
+};
+#define MAX_FAULT_REASON_IDX 	ARRAY_SIZE(fault_reason_strings)
+
+char *dmar_get_fault_reason(u8 fault_reason)
+{
+	if (fault_reason > MAX_FAULT_REASON_IDX)
+		return fault_reason_strings[MAX_FAULT_REASON_IDX];
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
+	dmar_writel(iommu->reg, DMAR_FECTL_REG, 0);
+	/* Read a reg to force flush the post write */
+	dmar_readl(iommu->reg, DMAR_FECTL_REG);
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
+	dmar_writel(iommu->reg, DMAR_FECTL_REG, DMA_FECTL_IM);
+	/* Read a reg to force flush the post write */
+	dmar_readl(iommu->reg, DMAR_FECTL_REG);
+	spin_unlock_irqrestore(&iommu->register_lock, flag);
+}
+
+void dmar_msi_write(int irq, struct msi_msg *msg)
+{
+	struct intel_iommu *iommu = get_irq_data(irq);
+	unsigned long flag;
+
+	spin_lock_irqsave(&iommu->register_lock, flag);
+	dmar_writel(iommu->reg, DMAR_FEDATA_REG, msg->data);
+	dmar_writel(iommu->reg, DMAR_FEADDR_REG, msg->address_lo);
+	dmar_writel(iommu->reg, DMAR_FEUADDR_REG, msg->address_hi);
+	spin_unlock_irqrestore(&iommu->register_lock, flag);
+}
+
+void dmar_msi_read(int irq, struct msi_msg *msg)
+{
+	struct intel_iommu *iommu = get_irq_data(irq);
+	unsigned long flag;
+
+	spin_lock_irqsave(&iommu->register_lock, flag);
+	msg->data = dmar_readl(iommu->reg, DMAR_FEDATA_REG);
+	msg->address_lo = dmar_readl(iommu->reg, DMAR_FEADDR_REG);
+	msg->address_hi = dmar_readl(iommu->reg, DMAR_FEUADDR_REG);
+	spin_unlock_irqrestore(&iommu->register_lock, flag);
+}
+
+static int iommu_page_fault_do_one(struct intel_iommu *iommu, int type,
+		u8 fault_reason, u16 source_id, u64 addr)
+{
+	char *reason;
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
+static irqreturn_t iommu_page_fault(int irq, void *dev_id)
+{
+	struct intel_iommu *iommu = dev_id;
+	int reg, fault_index;
+	u32 fault_status;
+	unsigned long flag;
+
+	spin_lock_irqsave(&iommu->register_lock, flag);
+	fault_status = dmar_readl(iommu->reg, DMAR_FSTS_REG);
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
+		data = dmar_readl(iommu->reg, reg +
+				fault_index * PRIMARY_FAULT_REG_LEN + 12);
+		if (!(data & DMA_FRCD_F))
+			break;
+
+		fault_reason = dma_frcd_fault_reason(data);
+		type = dma_frcd_type(data);
+
+		data = dmar_readl(iommu->reg, reg +
+				fault_index * PRIMARY_FAULT_REG_LEN + 8);
+		source_id = dma_frcd_source_id(data);
+
+		guest_addr = dmar_readq(iommu->reg, reg +
+				fault_index * PRIMARY_FAULT_REG_LEN);
+		guest_addr = dma_frcd_page_addr(guest_addr);
+		/* clear the fault */
+		dmar_writel(iommu->reg, reg +
+			fault_index * PRIMARY_FAULT_REG_LEN + 12, DMA_FRCD_F);
+
+		spin_unlock_irqrestore(&iommu->register_lock, flag);
+
+		iommu_page_fault_do_one(iommu, type, fault_reason,
+				source_id, guest_addr);
+
+		fault_index++;
+		if (fault_index > cap_num_fault_regs(iommu->cap))
+			fault_index = 0;
+		spin_lock_irqsave(&iommu->register_lock, flag);
+	}
+clear_overflow:
+	/* clear primary fault overflow */
+	fault_status = dmar_readl(iommu->reg, DMAR_FSTS_REG);
+	if (fault_status & DMA_FSTS_PFO)
+		dmar_writel(iommu->reg, DMAR_FSTS_REG, DMA_FSTS_PFO);
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
+	iommu_page_fault(irq, iommu);
+
+	ret = request_irq(irq, iommu_page_fault, 0, iommu->name, iommu);
+	if (ret)
+		printk(KERN_ERR "IOMMU: can't request irq\n");
+	return ret;
+}
+
 static int iommu_init_domains(struct intel_iommu *iommu)
 {
 	unsigned long ndomains;
@@ -1436,6 +1626,10 @@
 
 		iommu_flush_write_buffer(iommu);
 
+		ret = dmar_set_interrupt(iommu);
+		if (ret)
+			goto error;
+
 		iommu_set_root_entry(iommu);
 
 		iommu_flush_context_global(iommu, 0);
Index: linux-2.6.22-rc3/include/linux/dmar.h
===================================================================
--- linux-2.6.22-rc3.orig/include/linux/dmar.h	2007-06-04 12:40:29.000000000 -0700
+++ linux-2.6.22-rc3/include/linux/dmar.h	2007-06-04 12:40:58.000000000 -0700
@@ -28,6 +28,18 @@
 
 struct intel_iommu;
 
+extern char *dmar_get_fault_reason(u8 fault_reason);
+
+/* Can't use the common MSI interrupt functions
+ * since DMAR is not a pci device
+ */
+extern void dmar_msi_unmask(unsigned int irq);
+extern void dmar_msi_mask(unsigned int irq);
+extern void dmar_msi_read(int irq, struct msi_msg *msg);
+extern void dmar_msi_write(int irq, struct msi_msg *msg);
+extern int dmar_set_interrupt(struct intel_iommu *iommu);
+extern int arch_setup_dmar_msi(unsigned int irq);
+
 /* Intel IOMMU detection and initialization functions */
 extern void detect_intel_iommu(void);
 extern int intel_iommu_init(void);

-- 
