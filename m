Return-Path: <linux-kernel-owner+w=401wt.eu-S1757230AbZEVImd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230AbZEVImd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 04:42:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754667AbZEVIl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 04:41:59 -0400
Received: from mga14.intel.com ([143.182.124.37]:42752 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754899AbZEVIlx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 04:41:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,232,1241420400"; 
   d="scan'208";a="145786388"
From: Weidong Han <weidong.han@intel.com>
To: mingo@elte.hu, dwmw2@infradead.org, suresh.b.siddha@intel.com
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       kvm@vger.kernel.org, ebiederm@xmission.com,
       Weidong Han <weidong.han@intel.com>
Subject: [PATCH v3 2/2] Intel-IOMMU, intr-remap: source-id checking
Date: Sat, 23 May 2009 00:41:15 +0800
Message-Id: <1243010475-7411-3-git-send-email-weidong.han@intel.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1243010475-7411-1-git-send-email-weidong.han@intel.com>
References: <1243010475-7411-1-git-send-email-weidong.han@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To support domain-isolation usages, the platform hardware must be
capable of uniquely identifying the requestor (source-id) for each
interrupt message. Without source-id checking for interrupt remapping
, a rouge guest/VM with assigned devices can launch interrupt attacks
to bring down anothe guest/VM or the VMM itself.

This patch adds source-id checking for interrupt remapping, and then
really isolates interrupts for guests/VMs with assigned devices.

Because PCI subsystem is not initialized yet when set up IOAPIC
entries, use read_pci_config_byte to access PCI config space directly.

Signed-off-by: Weidong Han <weidong.han@intel.com>
---
 arch/x86/kernel/apic/io_apic.c |    6 ++
 drivers/pci/intr_remapping.c   |  120 +++++++++++++++++++++++++++++++++++++++-
 drivers/pci/intr_remapping.h   |    2 +
 include/linux/dmar.h           |   11 ++++
 4 files changed, 136 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index ed6a91c..f33e39c 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1411,6 +1411,9 @@ int setup_ioapic_entry(int apic_id, int irq,
 		irte.vector = vector;
 		irte.dest_id = IRTE_DEST(destination);
 
+		/* Set source-id of interrupt request */
+		set_ioapic_sid(&irte, apic_id);
+
 		modify_irte(irq, &irte);
 
 		ir_entry->index2 = (index >> 15) & 0x1;
@@ -3285,6 +3288,9 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq, struct msi_ms
 		irte.vector = cfg->vector;
 		irte.dest_id = IRTE_DEST(dest);
 
+		/* Set source-id of interrupt request */
+		set_msi_sid(&irte, pdev);
+
 		modify_irte(irq, &irte);
 
 		msg->address_hi = MSI_ADDR_BASE_HI;
diff --git a/drivers/pci/intr_remapping.c b/drivers/pci/intr_remapping.c
index a2ccb62..adac430 100644
--- a/drivers/pci/intr_remapping.c
+++ b/drivers/pci/intr_remapping.c
@@ -10,6 +10,8 @@
 #include <linux/intel-iommu.h>
 #include "intr_remapping.h"
 #include <acpi/acpi.h>
+#include <asm/pci-direct.h>
+#include "pci.h"
 
 static struct ioapic_scope ir_ioapic[MAX_IO_APICS];
 static int ir_ioapic_num;
@@ -418,6 +420,91 @@ int free_irte(int irq)
 	return rc;
 }
 
+/*
+ * source validation type
+ */
+#define SVT_NO_VERIFY		0x0  /* no verification is required */
+#define SVT_VERIFY_SID_SQ	0x1  /* verify using SID and SQ fiels */
+#define SVT_VERIFY_BUS		0x2  /* verify bus of request-id */
+
+/*
+ * source-id qualifier
+ */
+#define SQ_ALL_16	0x0  /* verify all 16 bits of request-id */
+#define SQ_13_IGNORE_1	0x1  /* verify most significant 13 bits, ignore
+			      * the third least significant bit
+			      */
+#define SQ_13_IGNORE_2	0x2  /* verify most significant 13 bits, ignore
+			      * the second and third least significant bits
+			      */
+#define SQ_13_IGNORE_3	0x3  /* verify most significant 13 bits, ignore
+			      * the least three significant bits
+			      */
+
+/*
+ * set SVT, SQ and SID fields of irte to verify
+ * source ids of interrupt requests
+ */
+static void set_irte_sid(struct irte *irte, unsigned int svt,
+			 unsigned int sq, unsigned int sid)
+{
+	irte->svt = svt;
+	irte->sq = sq;
+	irte->sid = sid;
+}
+
+int set_ioapic_sid(struct irte *irte, int apic)
+{
+	int i;
+	u16 sid = 0;
+
+	if (!irte)
+		return -1;
+
+	for (i = 0; i < MAX_IO_APICS; i++) {
+		if (ir_ioapic[i].id == apic) {
+			sid = (ir_ioapic[i].bus << 8) | ir_ioapic[i].devfn;
+			break;
+		}
+	}
+
+	if (sid == 0) {
+		pr_warning("Failed to set source-id of IOAPIC (%d)\n", apic);
+		return -1;
+	}
+
+	set_irte_sid(irte, 1, 0, sid);
+
+	return 0;
+}
+
+int set_msi_sid(struct irte *irte, struct pci_dev *dev)
+{
+	struct pci_dev *bridge;
+
+	if (!irte || !dev)
+		return -1;
+
+	/* PCIe device or Root Complex integrated PCI device */
+	if (dev->is_pcie || !dev->bus->parent) {
+		set_irte_sid(irte, SVT_VERIFY_SID_SQ, SQ_ALL_16,
+			     (dev->bus->number << 8) | dev->devfn);
+		return 0;
+	}
+
+	bridge = pci_find_upstream_pcie_bridge(dev);
+	if (bridge) {
+		if (bridge->is_pcie) /* this is a PCIE-to-PCI/PCIX bridge */
+			set_irte_sid(irte, SVT_VERIFY_BUS, SQ_ALL_16,
+				(bridge->bus->number << 8) | dev->bus->number);
+		else /* this is a legacy PCI bridge */
+			set_irte_sid(irte, SVT_VERIFY_SID_SQ, SQ_ALL_16,
+				(bridge->bus->number << 8) | bridge->devfn);
+	}
+
+	return 0;
+}
+
 static void iommu_set_intr_remapping(struct intel_iommu *iommu, int mode)
 {
 	u64 addr;
@@ -626,6 +713,35 @@ error:
 	return -1;
 }
 
+static void ir_parse_one_ioapic_scope(struct acpi_dmar_device_scope *scope,
+				      struct intel_iommu *iommu)
+{
+	struct acpi_dmar_pci_path *path;
+	u8 bus;
+	int count;
+
+	bus = scope->bus;
+	path = (struct acpi_dmar_pci_path *)(scope + 1);
+	count = (scope->length - sizeof(struct acpi_dmar_device_scope))
+		/ sizeof(struct acpi_dmar_pci_path);
+
+	while (--count > 0) {
+		/*
+		 * Access PCI directly due to the PCI
+		 * subsystem isn't initialized yet.
+		 */
+		bus = read_pci_config_byte(bus, path->dev, path->fn,
+					   PCI_SECONDARY_BUS);
+		path++;
+	}
+
+	ir_ioapic[ir_ioapic_num].bus   = bus;
+	ir_ioapic[ir_ioapic_num].devfn = PCI_DEVFN(path->dev, path->fn);
+	ir_ioapic[ir_ioapic_num].iommu = iommu;
+	ir_ioapic[ir_ioapic_num].id    = scope->enumeration_id;
+	ir_ioapic_num++;
+}
+
 static int ir_parse_ioapic_scope(struct acpi_dmar_header *header,
 				 struct intel_iommu *iommu)
 {
@@ -650,9 +766,7 @@ static int ir_parse_ioapic_scope(struct acpi_dmar_header *header,
 			       " 0x%Lx\n", scope->enumeration_id,
 			       drhd->address);
 
-			ir_ioapic[ir_ioapic_num].iommu = iommu;
-			ir_ioapic[ir_ioapic_num].id = scope->enumeration_id;
-			ir_ioapic_num++;
+			ir_parse_one_ioapic_scope(scope, iommu);
 		}
 		start += scope->length;
 	}
diff --git a/drivers/pci/intr_remapping.h b/drivers/pci/intr_remapping.h
index ca48f0d..63a263c 100644
--- a/drivers/pci/intr_remapping.h
+++ b/drivers/pci/intr_remapping.h
@@ -3,6 +3,8 @@
 struct ioapic_scope {
 	struct intel_iommu *iommu;
 	unsigned int id;
+	unsigned int bus;	/* PCI bus number */
+	unsigned int devfn;	/* PCI devfn number */
 };
 
 #define IR_X2APIC_MODE(mode) (mode ? (1 << 11) : 0)
diff --git a/include/linux/dmar.h b/include/linux/dmar.h
index cd83d2a..0acc73c 100644
--- a/include/linux/dmar.h
+++ b/include/linux/dmar.h
@@ -126,6 +126,8 @@ extern int free_irte(int irq);
 extern int irq_remapped(int irq);
 extern struct intel_iommu *map_dev_to_ir(struct pci_dev *dev);
 extern struct intel_iommu *map_ioapic_to_ir(int apic);
+extern int set_ioapic_sid(struct irte *irte, int apic);
+extern int set_msi_sid(struct irte *irte, struct pci_dev *dev);
 #else
 static inline int alloc_irte(struct intel_iommu *iommu, int irq, u16 count)
 {
@@ -156,6 +158,15 @@ static inline struct intel_iommu *map_ioapic_to_ir(int apic)
 {
 	return NULL;
 }
+static inline int set_ioapic_sid(struct irte *irte, int apic)
+{
+	return 0;
+}
+static inline int set_msi_sid(struct irte *irte, struct pci_dev *dev)
+{
+	return 0;
+}
+
 #define irq_remapped(irq)		(0)
 #define enable_intr_remapping(mode)	(-1)
 #define disable_intr_remapping()	(0)
-- 
1.6.0.4

