Return-Path: <linux-kernel-owner+w=401wt.eu-S1754256AbYIBXxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256AbYIBXxV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 19:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754743AbYIBXxB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 19:53:01 -0400
Received: from mga14.intel.com ([143.182.124.37]:26866 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754646AbYIBXw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 19:52:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,320,1217833200"; 
   d="scan'208";a="40775981"
Message-Id: <20080902234759.694485000@linux-os.sc.intel.com>
References: <20080902234759.554038000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 02 Sep 2008 16:46:59 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 2/2] x2apic: fix using early fixmap mapping for DMAR table parsing
Content-Disposition: inline; filename=dmar_fix_fixmap_mapping.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <yhlu.kernel@gmail.com>
Subject: x2apic, dmar: fix using early fixmap mapping for DMAR table parsing

Very early detection of the DMAR tables will setup fixmap mapping. For
parsing these tables later (while enabling dma and/or interrupt remapping),
early fixmap mapping shouldn't be used. Fix it by calling table detection
routines again, which will call generic apci_get_table() for setting up
the correct mapping.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: tip/drivers/pci/dmar.c
===================================================================
--- tip.orig/drivers/pci/dmar.c	2008-09-02 16:04:04.000000000 -0700
+++ tip/drivers/pci/dmar.c	2008-09-02 16:41:31.000000000 -0700
@@ -289,6 +289,24 @@
 	}
 }
 
+/**
+ * dmar_table_detect - checks to see if the platform supports DMAR devices
+ */
+static int __init dmar_table_detect(void)
+{
+	acpi_status status = AE_OK;
+
+	/* if we could find DMAR table, then there are DMAR devices */
+	status = acpi_get_table(ACPI_SIG_DMAR, 0,
+				(struct acpi_table_header **)&dmar_tbl);
+
+	if (ACPI_SUCCESS(status) && !dmar_tbl) {
+		printk (KERN_WARNING PREFIX "Unable to map DMAR\n");
+		status = AE_NOT_FOUND;
+	}
+
+	return (ACPI_SUCCESS(status) ? 1 : 0);
+}
 
 /**
  * parse_dmar_table - parses the DMA reporting table
@@ -300,6 +318,12 @@
 	struct acpi_dmar_header *entry_header;
 	int ret = 0;
 
+	/*
+	 * Do it again, earlier dmar_tbl mapping could be mapped with
+	 * fixed map.
+	 */
+	dmar_table_detect();
+
 	dmar = (struct acpi_table_dmar *)dmar_tbl;
 	if (!dmar)
 		return -ENODEV;
@@ -430,30 +454,11 @@
 	return 0;
 }
 
-/**
- * early_dmar_detect - checks to see if the platform supports DMAR devices
- */
-int __init early_dmar_detect(void)
-{
-	acpi_status status = AE_OK;
-
-	/* if we could find DMAR table, then there are DMAR devices */
-	status = acpi_get_table(ACPI_SIG_DMAR, 0,
-				(struct acpi_table_header **)&dmar_tbl);
-
-	if (ACPI_SUCCESS(status) && !dmar_tbl) {
-		printk (KERN_WARNING PREFIX "Unable to map DMAR\n");
-		status = AE_NOT_FOUND;
-	}
-
-	return (ACPI_SUCCESS(status) ? 1 : 0);
-}
-
 void __init detect_intel_iommu(void)
 {
 	int ret;
 
-	ret = early_dmar_detect();
+	ret = dmar_table_detect();
 
 #ifdef CONFIG_DMAR
 	{
@@ -479,14 +484,16 @@
 			       " x2apic support\n");
 
 			dmar_disabled = 1;
-			return;
+			goto end;
 		}
 
 		if (ret && !no_iommu && !iommu_detected && !swiotlb &&
 		    !dmar_disabled)
 			iommu_detected = 1;
 	}
+end:
 #endif
+	dmar_tbl = NULL;
 }
 
 
Index: tip/include/linux/dmar.h
===================================================================
--- tip.orig/include/linux/dmar.h	2008-09-02 16:04:04.000000000 -0700
+++ tip/include/linux/dmar.h	2008-09-02 16:40:40.000000000 -0700
@@ -45,7 +45,6 @@
 	list_for_each_entry(drhd, &dmar_drhd_units, list)
 
 extern int dmar_table_init(void);
-extern int early_dmar_detect(void);
 extern int dmar_dev_scope_init(void);
 
 /* Intel IOMMU detection */

-- 

