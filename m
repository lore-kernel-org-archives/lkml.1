Return-Path: <linux-kernel-owner+w=401wt.eu-S1752455AbZEGGN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455AbZEGGN6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 02:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752941AbZEGGNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 02:13:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:13966 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751954AbZEGGN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 02:13:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,307,1239001200"; 
   d="scan'208";a="688212922"
From: Weidong Han <weidong.han@intel.com>
To: dwmw2@infradead.org, suresh.b.siddha@intel.com, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       kvm@vger.kernel.org, Weidong Han <weidong.han@intel.com>
Subject: [PATCH 2/2] Intel-IOMMU, intr-remap: source-id checking
Date: Thu,  7 May 2009 14:16:36 +0800
Message-Id: <1241676996-27406-2-git-send-email-weidong.han@intel.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1241676996-27406-1-git-send-email-weidong.han@intel.com>
References: <1241676996-27406-1-git-send-email-weidong.han@intel.com>
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

Signed-off-by: Weidong Han <weidong.han@intel.com>
---
 arch/x86/kernel/apic/io_apic.c |    6 +++
 drivers/pci/intr_remapping.c   |   98 ++++++++++++++++++++++++++++++++++++++++
 drivers/pci/intr_remapping.h   |    2 +
 include/linux/dmar.h           |   11 +++++
 4 files changed, 117 insertions(+), 0 deletions(-)

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
index 946e170..825bca2 100644
--- a/drivers/pci/intr_remapping.c
+++ b/drivers/pci/intr_remapping.c
@@ -10,6 +10,7 @@
 #include <linux/intel-iommu.h>
 #include "intr_remapping.h"
 #include <acpi/acpi.h>
+#include "pci.h"
 
 static struct ioapic_scope ir_ioapic[MAX_IO_APICS];
 static int ir_ioapic_num;
@@ -405,6 +406,61 @@ int free_irte(int irq)
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
+	if (tmp->is_pcie) { /* this is a PCIE-to-PCI bridge */
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
@@ -616,6 +672,10 @@ static int ir_parse_ioapic_scope(struct acpi_dmar_header *header,
 	struct acpi_dmar_hardware_unit *drhd;
 	struct acpi_dmar_device_scope *scope;
 	void *start, *end;
+	struct acpi_dmar_pci_path *path;
+	struct pci_bus *bus;
+	struct pci_dev *pdev = NULL;
+	int count;
 
 	drhd = (struct acpi_dmar_hardware_unit *)header;
 
@@ -634,6 +694,44 @@ static int ir_parse_ioapic_scope(struct acpi_dmar_header *header,
 			       " 0x%Lx\n", scope->enumeration_id,
 			       drhd->address);
 
+			bus = pci_find_bus(drhd->segment, scope->bus);
+			path = (struct acpi_dmar_pci_path *)(scope + 1);
+			count = (scope->length -
+				 sizeof(struct acpi_dmar_device_scope))
+				/ sizeof(struct acpi_dmar_pci_path);
+
+			while (count) {
+				if (pdev)
+					pci_dev_put(pdev);
+
+				if (!bus)
+					break;
+
+				pdev = pci_get_slot(bus,
+					PCI_DEVFN(path->dev, path->fn));
+				if (!pdev)
+					break;
+
+				path++;
+				count--;
+				bus = pdev->subordinate;
+			}
+
+			if (pdev) { /* PCI discoverable IOAPIC*/
+				ir_ioapic[ir_ioapic_num].bus =
+					pdev->bus->number;
+				ir_ioapic[ir_ioapic_num].devfn = pdev->devfn;
+			} else { /* Not PCI discoverable IOAPIC */
+				if (!bus)
+					ir_ioapic[ir_ioapic_num].bus =
+						scope->bus;
+				else
+					ir_ioapic[ir_ioapic_num].bus =
+						bus->number;
+				ir_ioapic[ir_ioapic_num].devfn =
+					PCI_DEVFN(path->dev, path->fn);
+			}
+
 			ir_ioapic[ir_ioapic_num].iommu = iommu;
 			ir_ioapic[ir_ioapic_num].id = scope->enumeration_id;
 			ir_ioapic_num++;
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

