Return-Path: <linux-kernel-owner+w=401wt.eu-S1762776AbYGJSsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762776AbYGJSsw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 14:48:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759228AbYGJSmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 14:42:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:47658 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759040AbYGJSmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 14:42:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,339,1212390000"; 
   d="scan'208";a="352525771"
Message-Id: <20080710182236.337449000@linux-os.sc.intel.com>
References: <20080710181634.764954000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 10 Jul 2008 11:16:37 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       akpm@linux-foundation.org, arjan@linux.intel.com, andi@firstfloor.org,
       ebiederm@xmission.com, jbarnes@virtuousgeek.org, steiner@sgi.com
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 03/26] x64, x2apic/intr-remap: code re-structuring, to be used by both DMA and Interrupt remapping
Content-Disposition: inline; filename=parse_iommus_early.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allocate the iommu during the parse of DMA remapping hardware
definition structures. And also, introduce routines for device
scope initialization which will be explicitly called during
dma-remapping initialization.

These will be used for enabling interrupt remapping separately from the
existing DMA-remapping enabling sequence.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: tree-x86/drivers/pci/dmar.c
===================================================================
--- tree-x86.orig/drivers/pci/dmar.c	2008-07-10 09:51:49.000000000 -0700
+++ tree-x86/drivers/pci/dmar.c	2008-07-10 09:51:51.000000000 -0700
@@ -174,19 +174,37 @@
 	struct acpi_dmar_hardware_unit *drhd;
 	struct dmar_drhd_unit *dmaru;
 	int ret = 0;
-	static int include_all;
 
 	dmaru = kzalloc(sizeof(*dmaru), GFP_KERNEL);
 	if (!dmaru)
 		return -ENOMEM;
 
+	dmaru->hdr = header;
 	drhd = (struct acpi_dmar_hardware_unit *)header;
 	dmaru->reg_base_addr = drhd->address;
 	dmaru->include_all = drhd->flags & 0x1; /* BIT0: INCLUDE_ALL */
 
+	ret = alloc_iommu(dmaru);
+	if (ret) {
+		kfree(dmaru);
+		return ret;
+	}
+	dmar_register_drhd_unit(dmaru);
+	return 0;
+}
+
+static int __init
+dmar_parse_dev(struct dmar_drhd_unit *dmaru)
+{
+	struct acpi_dmar_hardware_unit *drhd;
+	static int include_all;
+	int ret;
+
+	drhd = (struct acpi_dmar_hardware_unit *) dmaru->hdr;
+
 	if (!dmaru->include_all)
 		ret = dmar_parse_dev_scope((void *)(drhd + 1),
-				((void *)drhd) + header->length,
+				((void *)drhd) + drhd->header.length,
 				&dmaru->devices_cnt, &dmaru->devices,
 				drhd->segment);
 	else {
@@ -199,10 +217,10 @@
 		include_all = 1;
 	}
 
-	if (ret || (dmaru->devices_cnt == 0 && !dmaru->include_all))
+	if (ret || (dmaru->devices_cnt == 0 && !dmaru->include_all)) {
+		list_del(&dmaru->list);
 		kfree(dmaru);
-	else
-		dmar_register_drhd_unit(dmaru);
+	}
 	return ret;
 }
 
@@ -211,23 +229,35 @@
 {
 	struct acpi_dmar_reserved_memory *rmrr;
 	struct dmar_rmrr_unit *rmrru;
-	int ret = 0;
 
 	rmrru = kzalloc(sizeof(*rmrru), GFP_KERNEL);
 	if (!rmrru)
 		return -ENOMEM;
 
+	rmrru->hdr = header;
 	rmrr = (struct acpi_dmar_reserved_memory *)header;
 	rmrru->base_address = rmrr->base_address;
 	rmrru->end_address = rmrr->end_address;
+
+	dmar_register_rmrr_unit(rmrru);
+	return 0;
+}
+
+static int __init
+rmrr_parse_dev(struct dmar_rmrr_unit *rmrru)
+{
+	struct acpi_dmar_reserved_memory *rmrr;
+	int ret;
+
+	rmrr = (struct acpi_dmar_reserved_memory *) rmrru->hdr;
 	ret = dmar_parse_dev_scope((void *)(rmrr + 1),
-		((void *)rmrr) + header->length,
+		((void *)rmrr) + rmrr->header.length,
 		&rmrru->devices_cnt, &rmrru->devices, rmrr->segment);
 
-	if (ret || (rmrru->devices_cnt == 0))
+	if (ret || (rmrru->devices_cnt == 0)) {
+		list_del(&rmrru->list);
 		kfree(rmrru);
-	else
-		dmar_register_rmrr_unit(rmrru);
+	}
 	return ret;
 }
 
@@ -333,15 +363,42 @@
 	return NULL;
 }
 
+int __init dmar_dev_scope_init(void)
+{
+	struct dmar_drhd_unit *drhd;
+	struct dmar_rmrr_unit *rmrr;
+	int ret = -ENODEV;
+
+	for_each_drhd_unit(drhd) {
+		ret = dmar_parse_dev(drhd);
+		if (ret)
+			return ret;
+	}
+
+	for_each_rmrr_units(rmrr) {
+		ret = rmrr_parse_dev(rmrr);
+		if (ret)
+			return ret;
+	}
+
+	return ret;
+}
+
 
 int __init dmar_table_init(void)
 {
-
+	static int dmar_table_initialized;
 	int ret;
 
+	if (dmar_table_initialized)
+		return 0;
+
+	dmar_table_initialized = 1;
+
 	ret = parse_dmar_table();
 	if (ret) {
-		printk(KERN_INFO PREFIX "parse DMAR table failure.\n");
+		if (ret != -ENODEV)
+			printk(KERN_INFO PREFIX "parse DMAR table failure.\n");
 		return ret;
 	}
 
@@ -377,7 +434,7 @@
 	return (ACPI_SUCCESS(status) ? 1 : 0);
 }
 
-struct intel_iommu *alloc_iommu(struct dmar_drhd_unit *drhd)
+int alloc_iommu(struct dmar_drhd_unit *drhd)
 {
 	struct intel_iommu *iommu;
 	int map_size;
@@ -386,7 +443,7 @@
 
 	iommu = kzalloc(sizeof(*iommu), GFP_KERNEL);
 	if (!iommu)
-		return NULL;
+		return -ENOMEM;
 
 	iommu->seq_id = iommu_allocated++;
 
@@ -419,10 +476,10 @@
 	spin_lock_init(&iommu->register_lock);
 
 	drhd->iommu = iommu;
-	return iommu;
+	return 0;
 error:
 	kfree(iommu);
-	return NULL;
+	return -1;
 }
 
 void free_iommu(struct intel_iommu *iommu)
Index: tree-x86/drivers/pci/intel-iommu.c
===================================================================
--- tree-x86.orig/drivers/pci/intel-iommu.c	2008-07-10 09:51:49.000000000 -0700
+++ tree-x86/drivers/pci/intel-iommu.c	2008-07-10 09:51:51.000000000 -0700
@@ -1665,11 +1665,8 @@
 	for_each_drhd_unit(drhd) {
 		if (drhd->ignored)
 			continue;
-		iommu = alloc_iommu(drhd);
-		if (!iommu) {
-			ret = -ENOMEM;
-			goto error;
-		}
+
+		iommu = drhd->iommu;
 
 		ret = iommu_init_domains(iommu);
 		if (ret)
@@ -2324,6 +2321,9 @@
 	if (dmar_table_init())
 		return 	-ENODEV;
 
+	if (dmar_dev_scope_init())
+		return 	-ENODEV;
+
 	iommu_init_mempool();
 	dmar_init_reserved_ranges();
 
Index: tree-x86/include/linux/dmar.h
===================================================================
--- tree-x86.orig/include/linux/dmar.h	2008-07-10 09:51:45.000000000 -0700
+++ tree-x86/include/linux/dmar.h	2008-07-10 09:51:51.000000000 -0700
@@ -46,12 +46,14 @@
 
 extern int dmar_table_init(void);
 extern int early_dmar_detect(void);
+extern int dmar_dev_scope_init(void);
 
 extern struct list_head dmar_drhd_units;
 extern struct list_head dmar_rmrr_units;
 
 struct dmar_drhd_unit {
 	struct list_head list;		/* list of drhd units	*/
+	struct  acpi_dmar_header *hdr;	/* ACPI header		*/
 	u64	reg_base_addr;		/* register base address*/
 	struct	pci_dev **devices; 	/* target device array	*/
 	int	devices_cnt;		/* target device count	*/
@@ -62,6 +64,7 @@
 
 struct dmar_rmrr_unit {
 	struct list_head list;		/* list of rmrr units	*/
+	struct acpi_dmar_header *hdr;	/* ACPI header		*/
 	u64	base_address;		/* reserved base address*/
 	u64	end_address;		/* reserved end address */
 	struct pci_dev **devices;	/* target devices */
@@ -72,6 +75,8 @@
 	list_for_each_entry(drhd, &dmar_drhd_units, list)
 #define for_each_rmrr_units(rmrr) \
 	list_for_each_entry(rmrr, &dmar_rmrr_units, list)
+
+extern int alloc_iommu(struct dmar_drhd_unit *);
 #else
 static inline void detect_intel_iommu(void)
 {
@@ -81,6 +86,9 @@
 {
 	return -ENODEV;
 }
-
+static inline int dmar_table_init(void)
+{
+	return -ENODEV;
+}
 #endif /* !CONFIG_DMAR */
 #endif /* __DMAR_H__ */
Index: tree-x86/drivers/pci/intel-iommu.h
===================================================================
--- tree-x86.orig/drivers/pci/intel-iommu.h	2008-07-10 09:51:49.000000000 -0700
+++ tree-x86/drivers/pci/intel-iommu.h	2008-07-10 09:51:51.000000000 -0700
@@ -199,7 +199,7 @@
 
 extern struct dmar_drhd_unit * dmar_find_matched_drhd_unit(struct pci_dev *dev);
 
-extern struct intel_iommu *alloc_iommu(struct dmar_drhd_unit *drhd);
+extern int alloc_iommu(struct dmar_drhd_unit *drhd);
 extern void free_iommu(struct intel_iommu *iommu);
 
 #endif

-- 

