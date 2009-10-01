Return-Path: <linux-kernel-owner+w=401wt.eu-S1755094AbZJBAST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094AbZJBAST (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 20:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755106AbZJBASF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 20:18:05 -0400
Received: from mga14.intel.com ([143.182.124.37]:24694 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754881AbZJBAR7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 20:17:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,490,1249282800"; 
   d="scan'208";a="194216220"
Message-Id: <20091001230743.949931468@sbs-t61.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Thu, 01 Oct 2009 16:06:16 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: dwmw2@infradead.org
Cc: jbarnes@virtuousgeek.org, len.brown@intel.com,
       linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 1/4] dmar: support for parsing Remapping Hardware Static Affinity structure
Content-Disposition: inline; filename=parse_rhsa_struct.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for parsing Remapping Hardware Static Affinity (RHSA) structure.
This enables identifying the association between remapping hardware units and
the corresponding proximity domain. This enables to allocate transalation
structures closer to the remapping hardware unit.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 drivers/pci/dmar.c          |   32 ++++++++++++++++++++++++++++++++
 include/acpi/actbl1.h       |   12 +++++++++++-
 include/linux/intel-iommu.h |    1 +
 3 files changed, 44 insertions(+), 1 deletion(-)

Index: tip/drivers/pci/dmar.c
===================================================================
--- tip.orig/drivers/pci/dmar.c
+++ tip/drivers/pci/dmar.c
@@ -348,12 +348,33 @@ found:
 }
 #endif
 
+static int __init
+dmar_parse_one_rhsa(struct acpi_dmar_header *header)
+{
+	struct acpi_dmar_rhsa *rhsa;
+	struct dmar_drhd_unit *drhd;
+
+	rhsa = (struct acpi_dmar_rhsa *)header;
+	for_each_drhd_unit(drhd)
+		if (drhd->reg_base_addr == rhsa->base_address) {
+			int node = acpi_map_pxm_to_node(rhsa->pxm);
+
+			if (!node_online(node))
+				node = -1;
+			drhd->iommu->node = node;
+			return 0;
+		}
+
+	return -ENODEV;
+}
+
 static void __init
 dmar_table_print_dmar_entry(struct acpi_dmar_header *header)
 {
 	struct acpi_dmar_hardware_unit *drhd;
 	struct acpi_dmar_reserved_memory *rmrr;
 	struct acpi_dmar_atsr *atsr;
+	struct acpi_dmar_rhsa *rhsa;
 
 	switch (header->type) {
 	case ACPI_DMAR_TYPE_HARDWARE_UNIT:
@@ -375,6 +396,12 @@ dmar_table_print_dmar_entry(struct acpi_
 		atsr = container_of(header, struct acpi_dmar_atsr, header);
 		printk(KERN_INFO PREFIX "ATSR flags: %#x\n", atsr->flags);
 		break;
+	case ACPI_DMAR_TYPE_RHSA:
+		rhsa = container_of(header, struct acpi_dmar_rhsa, header);
+		printk(KERN_INFO PREFIX
+		       "RHSA base: %#016Lx pxm: %#x\n",
+		       rhsa->base_address, rhsa->pxm);
+		break;
 	}
 }
 
@@ -459,6 +486,9 @@ parse_dmar_table(void)
 			ret = dmar_parse_one_atsr(entry_header);
 #endif
 			break;
+		case ACPI_DMAR_TYPE_RHSA:
+			ret = dmar_parse_one_rhsa(entry_header);
+			break;
 		default:
 			printk(KERN_WARNING PREFIX
 				"Unknown DMAR structure type\n");
@@ -658,6 +688,8 @@ int alloc_iommu(struct dmar_drhd_unit *d
 	iommu->agaw = agaw;
 	iommu->msagaw = msagaw;
 
+	iommu->node = -1;
+
 	/* the registers might be more than one page */
 	map_size = max_t(int, ecap_max_iotlb_offset(iommu->ecap),
 		cap_max_fault_reg_offset(iommu->cap));
Index: tip/include/acpi/actbl1.h
===================================================================
--- tip.orig/include/acpi/actbl1.h
+++ tip/include/acpi/actbl1.h
@@ -328,7 +328,8 @@ enum acpi_dmar_type {
 	ACPI_DMAR_TYPE_HARDWARE_UNIT = 0,
 	ACPI_DMAR_TYPE_RESERVED_MEMORY = 1,
 	ACPI_DMAR_TYPE_ATSR = 2,
-	ACPI_DMAR_TYPE_RESERVED = 3	/* 3 and greater are reserved */
+	ACPI_DMAR_TYPE_RHSA = 3,
+	ACPI_DMAR_TYPE_RESERVED = 4	/* 4 and greater are reserved */
 };
 
 struct acpi_dmar_device_scope {
@@ -401,6 +402,15 @@ struct acpi_dmar_atsr {
 
 #define ACPI_DMAR_ALL_PORTS	    (1)
 
+/* 3: Remapping Hardware Static Affinity Reporting Structure */
+
+struct acpi_dmar_rhsa {
+	struct acpi_dmar_header header;
+	u32 reserved;
+	u64 base_address;
+	u32 pxm;
+};
+
 /*******************************************************************************
  *
  * ECDT - Embedded Controller Boot Resources Table
Index: tip/include/linux/intel-iommu.h
===================================================================
--- tip.orig/include/linux/intel-iommu.h
+++ tip/include/linux/intel-iommu.h
@@ -332,6 +332,7 @@ struct intel_iommu {
 #ifdef CONFIG_INTR_REMAP
 	struct ir_table *ir_table;	/* Interrupt remapping info */
 #endif
+	int		node;
 };
 
 static inline void __iommu_flush_cache(


