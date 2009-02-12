Return-Path: <linux-kernel-owner+w=401wt.eu-S1762000AbZBMCxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762000AbZBMCxh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 21:53:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760934AbZBMCvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 21:51:40 -0500
Received: from mga01.intel.com ([192.55.52.88]:61610 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758206AbZBMCvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 21:51:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,200,1233561600"; 
   d="scan'208";a="430659343"
From: Yu Zhao <yu.zhao@intel.com>
To: jbarnes@virtuousgeek.org, dwmw2@infradead.org
Cc: linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Yu Zhao <yu.zhao@intel.com>
Subject: [PATCH v3 2/6] VT-d: parse ATSR in DMA Remapping Reporting Structure
Date: Thu, 12 Feb 2009 20:50:34 +0800
Message-Id: <1234443038-15437-3-git-send-email-yu.zhao@intel.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <1234443038-15437-1-git-send-email-yu.zhao@intel.com>
References: <1234443038-15437-1-git-send-email-yu.zhao@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parse the Root Port ATS Capability Reporting Structure in DMA Remapping
Reporting Structure ACPI table.

Signed-off-by: Yu Zhao <yu.zhao@intel.com>
---
 drivers/pci/dmar.c          |  112 ++++++++++++++++++++++++++++++++++++++++--
 include/linux/dmar.h        |    9 ++++
 include/linux/intel-iommu.h |    1 +
 3 files changed, 116 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
index f5a662a..bd37b3c 100644
--- a/drivers/pci/dmar.c
+++ b/drivers/pci/dmar.c
@@ -254,6 +254,84 @@ rmrr_parse_dev(struct dmar_rmrr_unit *rmrru)
 	}
 	return ret;
 }
+
+static LIST_HEAD(dmar_atsr_units);
+
+static int __init dmar_parse_one_atsr(struct acpi_dmar_header *hdr)
+{
+	struct acpi_dmar_atsr *atsr;
+	struct dmar_atsr_unit *atsru;
+
+	atsr = container_of(hdr, struct acpi_dmar_atsr, header);
+	atsru = kzalloc(sizeof(*atsru), GFP_KERNEL);
+	if (!atsru)
+		return -ENOMEM;
+
+	atsru->hdr = hdr;
+	atsru->include_all = atsr->flags & 0x1;
+
+	list_add(&atsru->list, &dmar_atsr_units);
+
+	return 0;
+}
+
+static int __init atsr_parse_dev(struct dmar_atsr_unit *atsru)
+{
+	int rc;
+	struct acpi_dmar_atsr *atsr;
+
+	if (atsru->include_all)
+		return 0;
+
+	atsr = container_of(atsru->hdr, struct acpi_dmar_atsr, header);
+	rc = dmar_parse_dev_scope((void *)(atsr + 1),
+				(void *)atsr + atsr->header.length,
+				&atsru->devices_cnt, &atsru->devices,
+				atsr->segment);
+	if (rc || !atsru->devices_cnt) {
+		list_del(&atsru->list);
+		kfree(atsru);
+	}
+
+	return rc;
+}
+
+int dmar_find_matched_atsr_unit(struct pci_dev *dev)
+{
+	int i;
+	struct pci_bus *bus;
+	struct acpi_dmar_atsr *atsr;
+	struct dmar_atsr_unit *atsru;
+
+	list_for_each_entry(atsru, &dmar_atsr_units, list) {
+		atsr = container_of(atsru->hdr, struct acpi_dmar_atsr, header);
+		if (atsr->segment == pci_domain_nr(dev->bus))
+			goto found;
+	}
+
+	return 0;
+
+found:
+	for (bus = dev->bus; bus; bus = bus->parent) {
+		struct pci_dev *bridge = bus->self;
+
+		if (!bridge || !bridge->is_pcie ||
+		    bridge->pcie_type == PCI_EXP_TYPE_PCI_BRIDGE)
+			return 0;
+
+		if (bridge->pcie_type == PCI_EXP_TYPE_ROOT_PORT) {
+			for (i = 0; i < atsru->devices_cnt; i++)
+				if (atsru->devices[i] == bridge)
+					return 1;
+			break;
+		}
+	}
+
+	if (atsru->include_all)
+		return 1;
+
+	return 0;
+}
 #endif
 
 static void __init
@@ -261,22 +339,28 @@ dmar_table_print_dmar_entry(struct acpi_dmar_header *header)
 {
 	struct acpi_dmar_hardware_unit *drhd;
 	struct acpi_dmar_reserved_memory *rmrr;
+	struct acpi_dmar_atsr *atsr;
 
 	switch (header->type) {
 	case ACPI_DMAR_TYPE_HARDWARE_UNIT:
-		drhd = (struct acpi_dmar_hardware_unit *)header;
+		drhd = container_of(header, struct acpi_dmar_hardware_unit,
+				    header);
 		printk (KERN_INFO PREFIX
-			"DRHD (flags: 0x%08x)base: 0x%016Lx\n",
-			drhd->flags, (unsigned long long)drhd->address);
+			"DRHD base: %#016Lx flags: %#x\n",
+			(unsigned long long)drhd->address, drhd->flags);
 		break;
 	case ACPI_DMAR_TYPE_RESERVED_MEMORY:
-		rmrr = (struct acpi_dmar_reserved_memory *)header;
-
+		rmrr = container_of(header, struct acpi_dmar_reserved_memory,
+				    header);
 		printk (KERN_INFO PREFIX
-			"RMRR base: 0x%016Lx end: 0x%016Lx\n",
+			"RMRR base: %#016Lx end: %#016Lx\n",
 			(unsigned long long)rmrr->base_address,
 			(unsigned long long)rmrr->end_address);
 		break;
+	case ACPI_DMAR_TYPE_ATSR:
+		atsr = container_of(header, struct acpi_dmar_atsr, header);
+		printk(KERN_INFO PREFIX "ATSR flags: %#x\n", atsr->flags);
+		break;
 	}
 }
 
@@ -341,6 +425,11 @@ parse_dmar_table(void)
 			ret = dmar_parse_one_rmrr(entry_header);
 #endif
 			break;
+		case ACPI_DMAR_TYPE_ATSR:
+#ifdef CONFIG_DMAR
+			ret = dmar_parse_one_atsr(entry_header);
+#endif
+			break;
 		default:
 			printk(KERN_WARNING PREFIX
 				"Unknown DMAR structure type\n");
@@ -409,11 +498,19 @@ int __init dmar_dev_scope_init(void)
 #ifdef CONFIG_DMAR
 	{
 		struct dmar_rmrr_unit *rmrr, *rmrr_n;
+		struct dmar_atsr_unit *atsr, *atsr_n;
+
 		list_for_each_entry_safe(rmrr, rmrr_n, &dmar_rmrr_units, list) {
 			ret = rmrr_parse_dev(rmrr);
 			if (ret)
 				return ret;
 		}
+
+		list_for_each_entry_safe(atsr, atsr_n, &dmar_atsr_units, list) {
+			ret = atsr_parse_dev(atsr);
+			if (ret)
+				return ret;
+		}
 	}
 #endif
 
@@ -446,6 +543,9 @@ int __init dmar_table_init(void)
 #ifdef CONFIG_DMAR
 	if (list_empty(&dmar_rmrr_units))
 		printk(KERN_INFO PREFIX "No RMRR found\n");
+
+	if (list_empty(&dmar_atsr_units))
+		printk(KERN_INFO PREFIX "No ATSR found\n");
 #endif
 
 #ifdef CONFIG_INTR_REMAP
diff --git a/include/linux/dmar.h b/include/linux/dmar.h
index f284407..d3a1234 100644
--- a/include/linux/dmar.h
+++ b/include/linux/dmar.h
@@ -142,6 +142,15 @@ struct dmar_rmrr_unit {
 
 #define for_each_rmrr_units(rmrr) \
 	list_for_each_entry(rmrr, &dmar_rmrr_units, list)
+
+struct dmar_atsr_unit {
+	struct list_head list;		/* list of ATSR units */
+	struct acpi_dmar_header *hdr;	/* ACPI header */
+	struct pci_dev **devices;	/* target devices */
+	int devices_cnt;		/* target device count */
+	u8 include_all:1;		/* include all ports */
+};
+
 /* Intel DMAR  initialization functions */
 extern int intel_iommu_init(void);
 #else
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index c4f6c10..5323ad9 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -316,6 +316,7 @@ static inline void __iommu_flush_cache(
 }
 
 extern struct dmar_drhd_unit * dmar_find_matched_drhd_unit(struct pci_dev *dev);
+extern int dmar_find_matched_atsr_unit(struct pci_dev *dev);
 
 extern int alloc_iommu(struct dmar_drhd_unit *drhd);
 extern void free_iommu(struct intel_iommu *iommu);
-- 
1.6.1

