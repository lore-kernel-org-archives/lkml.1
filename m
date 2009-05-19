Return-Path: <linux-kernel-owner+w=401wt.eu-S1755046AbZESKcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046AbZESKcm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 06:32:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753224AbZESKcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 06:32:32 -0400
Received: from mga03.intel.com ([143.182.124.21]:40240 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752701AbZESKcD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 06:32:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,214,1241420400"; 
   d="scan'208";a="144423504"
From: Weidong Han <weidong.han@intel.com>
To: mingo@elte.hu, dwmw2@infradead.org, suresh.b.siddha@intel.com
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       kvm@vger.kernel.org, Weidong Han <weidong.han@intel.com>
Subject: [PATCH v2 2/2] Intel-IOMMU, intr-remap: source-id checking
Date: Wed, 20 May 2009 02:31:52 +0800
Message-Id: <1242757912-6041-3-git-send-email-weidong.han@intel.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1242757912-6041-1-git-send-email-weidong.han@intel.com>
References: <1242757912-6041-1-git-send-email-weidong.han@intel.com>
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
 arch/x86/kernel/apic/io_apic.c |    6 +++
 drivers/pci/intr_remapping.c   |   90 ++++++++++++++++++++++++++++++++++++++-
 drivers/pci/intr_remapping.h   |    2 +
 include/linux/dmar.h           |   11 +++++
 4 files changed, 106 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 30da617..3d10c68 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1559,6 +1559,9 @@ int setup_ioapic_entry(int apic_id, int irq,
 		irte.vector = vector;
 		irte.dest_id = IRTE_DEST(destination);
 
+		/* Set source-id of interrupt request */
+		set_ioapic_sid(&irte, apic_id);
+
 		modify_irte(irq, &irte);
 
 		ir_entry->index2 = (index >> 15) & 0x1;
@@ -3329,6 +3332,9 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq, struct msi_ms
 		irte.vector = cfg->vector;
 		irte.dest_id = IRTE_DEST(dest);
 
+		/* Set source-id of interrupt request */
+		set_msi_sid(&irte, pdev);
+
 		modify_irte(irq, &irte);
 
 		msg->address_hi = MSI_ADDR_BASE_HI;
diff --git a/drivers/pci/intr_remapping.c b/drivers/pci/intr_remapping.c
index 946e170..9ef7b0d 100644
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
@@ -405,6 +407,61 @@ int free_irte(int irq)
 	return rc;
 }
 
+int set_ioapic_sid(struct irte *irte, int apic)
+{
+	int i;
+	u16 sid = 0;
+
+	if (!irte)
+		return -1;
+
+	for (i = 0; i < MAX_IO_APICS; i++)
+		if (ir_ioapic[i].id == apic) {
+			sid = (ir_ioapic[i].bus << 8) | ir_ioapic[i].devfn;
+			break;
+		}
+
+	if (sid == 0) {
+		printk(KERN_WARNING "Failed to set source-id of "
+		       "I/O APIC (%d), because it is not under "
+		       "any DRHD\n", apic);
+		return -1;
+	}
+
+	irte->svt = 1; /* requestor ID verification SID/SQ */
+	irte->sq = 0;  /* comparing all 16-bit of SID */
+	irte->sid = sid;
+
+	return 0;
+}
+
+int set_msi_sid(struct irte *irte, struct pci_dev *dev)
+{
+	struct pci_dev *tmp;
+
+	if (!irte || !dev)
+		return -1;
+
+	tmp = pci_find_upstream_pcie_bridge(dev);
+	if (!tmp) { /* PCIE device or integrated PCI device */
+		irte->svt = 1; /* verify requestor ID verification SID/SQ */
+		irte->sq = 0;  /* comparing all 16-bit of SID */
+		irte->sid = (dev->bus->number << 8) | dev->devfn;
+		return 0;
+	}
+
+	if (tmp->is_pcie) { /* this is a PCIE-to-PCI/PCIX bridge */
+		irte->svt = 2; /* verify request ID verification SID */
+		irte->sid = (tmp->bus->number << 8) | dev->bus->number;
+	} else { /* this is a legacy PCI bridge */
+		irte->svt = 1; /* verify requestor ID verification SID/SQ */
+		irte->sq = 0;  /* comparing all 16-bit of SID */
+		irte->sid = (tmp->bus->number << 8) | tmp->devfn;
+	}
+
+	return 0;
+}
+
 static void iommu_set_intr_remapping(struct intel_iommu *iommu, int mode)
 {
 	u64 addr;
@@ -610,6 +667,35 @@ error:
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
+	ir_ioapic[ir_ioapic_num].bus = bus;
+	ir_ioapic[ir_ioapic_num].devfn = PCI_DEVFN(path->dev, path->fn);
+	ir_ioapic[ir_ioapic_num].iommu = iommu;
+	ir_ioapic[ir_ioapic_num].id = scope->enumeration_id;
+	ir_ioapic_num++;
+}
+
 static int ir_parse_ioapic_scope(struct acpi_dmar_header *header,
 				 struct intel_iommu *iommu)
 {
@@ -634,9 +720,7 @@ static int ir_parse_ioapic_scope(struct acpi_dmar_header *header,
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
index ca48f0d..dd35780 100644
--- a/drivers/pci/intr_remapping.h
+++ b/drivers/pci/intr_remapping.h
@@ -3,6 +3,8 @@
 struct ioapic_scope {
 	struct intel_iommu *iommu;
 	unsigned int id;
+	u8 bus;			/* PCI bus number */
+	u8 devfn;		/* PCI devfn number */
 };
 
 #define IR_X2APIC_MODE(mode) (mode ? (1 << 11) : 0)
diff --git a/include/linux/dmar.h b/include/linux/dmar.h
index e397dc3..7d27284 100644
--- a/include/linux/dmar.h
+++ b/include/linux/dmar.h
@@ -125,6 +125,8 @@ extern int free_irte(int irq);
 extern int irq_remapped(int irq);
 extern struct intel_iommu *map_dev_to_ir(struct pci_dev *dev);
 extern struct intel_iommu *map_ioapic_to_ir(int apic);
+extern int set_ioapic_sid(struct irte *irte, int apic);
+extern int set_msi_sid(struct irte *irte, struct pci_dev *dev);
 #else
 static inline int alloc_irte(struct intel_iommu *iommu, int irq, u16 count)
 {
@@ -155,6 +157,15 @@ static inline struct intel_iommu *map_ioapic_to_ir(int apic)
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
 #define intr_remapping_enabled		(0)
-- 
1.6.0.4

