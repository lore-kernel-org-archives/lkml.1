Return-Path: <linux-kernel-owner+w=401wt.eu-S1757686AbZJBSH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757686AbZJBSH0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 14:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757597AbZJBSHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 14:07:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:41689 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754908AbZJBSHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 14:07:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,495,1249282800"; 
   d="scan'208";a="454070727"
Message-Id: <20091002180257.600389229@sbs-t61.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Fri, 02 Oct 2009 11:01:21 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: dwmw2@infradead.org
Cc: jbarnes@virtuousgeek.org, len.brown@intel.com,
       linux-kernel@vger.kernel.org, rdreier@cisco.com,
       Suresh Siddha <suresh.b.siddha@intel.com>
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
 drivers/pci/dmar.c          |   24 +++++++++++++++++++++++-
 include/linux/intel-iommu.h |    1 +
 2 files changed, 24 insertions(+), 1 deletion(-)

Index: iommu-2.6/drivers/pci/dmar.c
===================================================================
--- iommu-2.6.orig/drivers/pci/dmar.c
+++ iommu-2.6/drivers/pci/dmar.c
@@ -348,6 +348,26 @@ found:
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
+			int node = acpi_map_pxm_to_node(rhsa->proximity_domain);
+
+			if (!node_online(node))
+				node = -1;
+			drhd->iommu->node = node;
+		return 0;
+	}
+
+	return -ENODEV;
+}
+
 static void __init
 dmar_table_print_dmar_entry(struct acpi_dmar_header *header)
 {
@@ -467,7 +487,7 @@ parse_dmar_table(void)
 #endif
 			break;
 		case ACPI_DMAR_HARDWARE_AFFINITY:
-			/* We don't do anything with RHSA (yet?) */
+			ret = dmar_parse_one_rhsa(entry_header);
 			break;
 		default:
 			printk(KERN_WARNING PREFIX
@@ -677,6 +697,8 @@ int alloc_iommu(struct dmar_drhd_unit *d
 	iommu->agaw = agaw;
 	iommu->msagaw = msagaw;
 
+	iommu->node = -1;
+
 	/* the registers might be more than one page */
 	map_size = max_t(int, ecap_max_iotlb_offset(iommu->ecap),
 		cap_max_fault_reg_offset(iommu->cap));
Index: iommu-2.6/include/linux/intel-iommu.h
===================================================================
--- iommu-2.6.orig/include/linux/intel-iommu.h
+++ iommu-2.6/include/linux/intel-iommu.h
@@ -332,6 +332,7 @@ struct intel_iommu {
 #ifdef CONFIG_INTR_REMAP
 	struct ir_table *ir_table;	/* Interrupt remapping info */
 #endif
+	int		node;
 };
 
 static inline void __iommu_flush_cache(


