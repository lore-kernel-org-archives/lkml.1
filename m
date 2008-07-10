Return-Path: <linux-kernel-owner+w=401wt.eu-S1762868AbYGJStI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762868AbYGJStI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 14:49:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759239AbYGJSmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 14:42:12 -0400
Received: from mga11.intel.com ([192.55.52.93]:47658 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759081AbYGJSmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 14:42:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,339,1212390000"; 
   d="scan'208";a="352525772"
Message-Id: <20080710182236.479700000@linux-os.sc.intel.com>
References: <20080710181634.764954000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 10 Jul 2008 11:16:38 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       akpm@linux-foundation.org, arjan@linux.intel.com, andi@firstfloor.org,
       ebiederm@xmission.com, jbarnes@virtuousgeek.org, steiner@sgi.com
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 04/26] x64, x2apic/intr-remap: use CONFIG_DMAR for DMA-remapping specific code
Content-Disposition: inline; filename=config_dmar_for_dma_remapping_specific_code.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DMA remapping specific code covered with CONFIG_DMAR in
the generic code which will also be used later for enabling Interrupt-remapping.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: tree-x86/drivers/pci/dmar.c
===================================================================
--- tree-x86.orig/drivers/pci/dmar.c	2008-07-10 09:51:51.000000000 -0700
+++ tree-x86/drivers/pci/dmar.c	2008-07-10 09:51:53.000000000 -0700
@@ -39,7 +39,6 @@
  * these units are not supported by the architecture.
  */
 LIST_HEAD(dmar_drhd_units);
-LIST_HEAD(dmar_rmrr_units);
 
 static struct acpi_table_header * __initdata dmar_tbl;
 
@@ -55,11 +54,6 @@
 		list_add(&drhd->list, &dmar_drhd_units);
 }
 
-static void __init dmar_register_rmrr_unit(struct dmar_rmrr_unit *rmrr)
-{
-	list_add(&rmrr->list, &dmar_rmrr_units);
-}
-
 static int __init dmar_parse_one_dev_scope(struct acpi_dmar_device_scope *scope,
 					   struct pci_dev **dev, u16 segment)
 {
@@ -224,6 +218,15 @@
 	return ret;
 }
 
+#ifdef CONFIG_DMAR
+LIST_HEAD(dmar_rmrr_units);
+
+static void __init dmar_register_rmrr_unit(struct dmar_rmrr_unit *rmrr)
+{
+	list_add(&rmrr->list, &dmar_rmrr_units);
+}
+
+
 static int __init
 dmar_parse_one_rmrr(struct acpi_dmar_header *header)
 {
@@ -260,6 +263,7 @@
 	}
 	return ret;
 }
+#endif
 
 static void __init
 dmar_table_print_dmar_entry(struct acpi_dmar_header *header)
@@ -284,6 +288,7 @@
 	}
 }
 
+
 /**
  * parse_dmar_table - parses the DMA reporting table
  */
@@ -316,7 +321,9 @@
 			ret = dmar_parse_one_drhd(entry_header);
 			break;
 		case ACPI_DMAR_TYPE_RESERVED_MEMORY:
+#ifdef CONFIG_DMAR
 			ret = dmar_parse_one_rmrr(entry_header);
+#endif
 			break;
 		default:
 			printk(KERN_WARNING PREFIX
@@ -366,7 +373,6 @@
 int __init dmar_dev_scope_init(void)
 {
 	struct dmar_drhd_unit *drhd;
-	struct dmar_rmrr_unit *rmrr;
 	int ret = -ENODEV;
 
 	for_each_drhd_unit(drhd) {
@@ -375,11 +381,16 @@
 			return ret;
 	}
 
-	for_each_rmrr_units(rmrr) {
-		ret = rmrr_parse_dev(rmrr);
-		if (ret)
-			return ret;
+#ifdef CONFIG_DMAR
+	{
+		struct dmar_rmrr_unit *rmrr;
+		for_each_rmrr_units(rmrr) {
+			ret = rmrr_parse_dev(rmrr);
+			if (ret)
+				return ret;
+		}
 	}
+#endif
 
 	return ret;
 }
@@ -407,10 +418,12 @@
 		return -ENODEV;
 	}
 
+#ifdef CONFIG_DMAR
 	if (list_empty(&dmar_rmrr_units)) {
 		printk(KERN_INFO PREFIX "No RMRR found\n");
 		return -ENODEV;
 	}
+#endif
 
 	return 0;
 }

-- 

