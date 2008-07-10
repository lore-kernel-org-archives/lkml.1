Return-Path: <linux-kernel-owner+w=401wt.eu-S1762091AbYGJSq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762091AbYGJSq5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 14:46:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758765AbYGJSl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 14:41:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:13519 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756233AbYGJSlt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 14:41:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,339,1212390000"; 
   d="scan'208";a="306573265"
Message-Id: <20080710182236.770524000@linux-os.sc.intel.com>
References: <20080710181634.764954000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 10 Jul 2008 11:16:40 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       akpm@linux-foundation.org, arjan@linux.intel.com, andi@firstfloor.org,
       ebiederm@xmission.com, jbarnes@virtuousgeek.org, steiner@sgi.com
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 06/26] x64, x2apic/intr-remap: parse ioapic scope under vt-d structures
Content-Disposition: inline; filename=intr_remapping_ioapic_parse.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parse the vt-d device scope structures to find the mapping between IO-APICs
and the interrupt remapping hardware units.

This will be used later for enabling Interrupt-remapping for IOAPIC devices.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: tree-x86/drivers/pci/Makefile
===================================================================
--- tree-x86.orig/drivers/pci/Makefile	2008-07-10 09:51:45.000000000 -0700
+++ tree-x86/drivers/pci/Makefile	2008-07-10 09:51:57.000000000 -0700
@@ -26,6 +26,8 @@
 # Build Intel IOMMU support
 obj-$(CONFIG_DMAR) += dmar.o iova.o intel-iommu.o
 
+obj-$(CONFIG_INTR_REMAP) += dmar.o intr_remapping.o
+
 #
 # Some architectures use the generic PCI setup functions
 #
Index: tree-x86/drivers/pci/intel-iommu.h
===================================================================
--- tree-x86.orig/drivers/pci/intel-iommu.h	2008-07-10 09:51:51.000000000 -0700
+++ tree-x86/drivers/pci/intel-iommu.h	2008-07-10 09:51:57.000000000 -0700
@@ -114,6 +114,8 @@
 #define ecap_max_iotlb_offset(e) \
 	(ecap_iotlb_offset(e) + ecap_niotlb_iunits(e) * 16)
 #define ecap_coherent(e)	((e) & 0x1)
+#define ecap_eim_support(e)	((e >> 4) & 0x1)
+#define ecap_ir_support(e)	((e >> 3) & 0x1)
 
 
 /* IOTLB_REG */
Index: tree-x86/drivers/pci/intr_remapping.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ tree-x86/drivers/pci/intr_remapping.c	2008-07-10 09:51:57.000000000 -0700
@@ -0,0 +1,70 @@
+#include <linux/dmar.h>
+#include <asm/io_apic.h>
+#include "intel-iommu.h"
+#include "intr_remapping.h"
+
+static struct ioapic_scope ir_ioapic[MAX_IO_APICS];
+static int ir_ioapic_num;
+
+static int ir_parse_ioapic_scope(struct acpi_dmar_header *header,
+				 struct intel_iommu *iommu)
+{
+	struct acpi_dmar_hardware_unit *drhd;
+	struct acpi_dmar_device_scope *scope;
+	void *start, *end;
+
+	drhd = (struct acpi_dmar_hardware_unit *)header;
+
+	start = (void *)(drhd + 1);
+	end = ((void *)drhd) + header->length;
+
+	while (start < end) {
+		scope = start;
+		if (scope->entry_type == ACPI_DMAR_SCOPE_TYPE_IOAPIC) {
+			if (ir_ioapic_num == MAX_IO_APICS) {
+				printk(KERN_WARNING "Exceeded Max IO APICS\n");
+				return -1;
+			}
+
+			printk(KERN_INFO "IOAPIC id %d under DRHD base"
+			       " 0x%Lx\n", scope->enumeration_id,
+			       drhd->address);
+
+			ir_ioapic[ir_ioapic_num].iommu = iommu;
+			ir_ioapic[ir_ioapic_num].id = scope->enumeration_id;
+			ir_ioapic_num++;
+		}
+		start += scope->length;
+	}
+
+	return 0;
+}
+
+/*
+ * Finds the assocaition between IOAPIC's and its Interrupt-remapping
+ * hardware unit.
+ */
+int __init parse_ioapics_under_ir(void)
+{
+	struct dmar_drhd_unit *drhd;
+	int ir_supported = 0;
+
+	for_each_drhd_unit(drhd) {
+		struct intel_iommu *iommu = drhd->iommu;
+
+		if (ecap_ir_support(iommu->ecap)) {
+			if (ir_parse_ioapic_scope(drhd->hdr, iommu))
+				return -1;
+
+			ir_supported = 1;
+		}
+	}
+
+	if (ir_supported && ir_ioapic_num != nr_ioapics) {
+		printk(KERN_WARNING
+		       "Not all IO-APIC's listed under remapping hardware\n");
+		return -1;
+	}
+
+	return ir_supported;
+}
Index: tree-x86/include/linux/dmar.h
===================================================================
--- tree-x86.orig/include/linux/dmar.h	2008-07-10 09:51:51.000000000 -0700
+++ tree-x86/include/linux/dmar.h	2008-07-10 09:51:57.000000000 -0700
@@ -47,6 +47,7 @@
 extern int dmar_table_init(void);
 extern int early_dmar_detect(void);
 extern int dmar_dev_scope_init(void);
+extern int parse_ioapics_under_ir(void);
 
 extern struct list_head dmar_drhd_units;
 extern struct list_head dmar_rmrr_units;
Index: tree-x86/drivers/pci/dmar.c
===================================================================
--- tree-x86.orig/drivers/pci/dmar.c	2008-07-10 09:51:55.000000000 -0700
+++ tree-x86/drivers/pci/dmar.c	2008-07-10 09:51:57.000000000 -0700
@@ -423,6 +423,9 @@
 		printk(KERN_INFO PREFIX "No RMRR found\n");
 #endif
 
+#ifdef CONFIG_INTR_REMAP
+	parse_ioapics_under_ir();
+#endif
 	return 0;
 }
 
Index: tree-x86/drivers/pci/intr_remapping.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ tree-x86/drivers/pci/intr_remapping.h	2008-07-10 09:51:57.000000000 -0700
@@ -0,0 +1,6 @@
+#include "intel-iommu.h"
+
+struct ioapic_scope {
+	struct intel_iommu *iommu;
+	unsigned int id;
+};

-- 

