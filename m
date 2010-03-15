Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935080Ab0COG6F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 02:58:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:23847 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756997Ab0COG57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 02:57:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,641,1262592000"; 
   d="scan'208,217";a="604418761"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
       linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
       ying.huang@intel.com
Subject: [PATCH -v3 1/2] ACPI, APEI, Make APEI core configurable built-in instead of module
Date: Mon, 15 Mar 2010 14:57:40 +0800
Message-Id: <1268636261-31554-2-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1268636261-31554-1-git-send-email-ying.huang@intel.com>
References: <1268636261-31554-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PCIE AER optionally depends on APEI HEST tabling parsing. If AER is
built-in, HEST should be built-in or not configured at all instead of
module. It is hard to express this elegantly in Kconfig. It is better
to make APEI code part configurable built-in instead of module.

On the other hand, APEI core code is used for hardware error
processing. It may run in very bad condition. It is reasonable to keep
it built-in if enabled.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 Documentation/kernel-parameters.txt |   10 ++++----
 drivers/acpi/apei/Kconfig           |    2 -
 drivers/acpi/apei/apei-base.c       |   42 +++++-------------------------------
 drivers/acpi/apei/apei-internal.h   |    4 ---
 drivers/acpi/apei/einj.c            |    2 -
 drivers/acpi/apei/hest.c            |   34 ++++++++++++++++++++++++-----
 6 files changed, 42 insertions(+), 52 deletions(-)

--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -347,11 +347,6 @@ and is between 256 and 4096 characters.
 			not play well with APC CPU idle - disable it if you have
 			APC and your system crashes randomly.
 
-	apei.hest_disable= [ACPI]
-			Disable Hardware Error Source Table (HEST) support,
-			corresponding firmware-first mode error processing
-			logic will be disabled.
-
 	apic=		[APIC,X86-32] Advanced Programmable Interrupt Controller
 			Change the output verbosity whilst booting
 			Format: { quiet (default) | verbose | debug }
@@ -853,6 +848,11 @@ and is between 256 and 4096 characters.
 	hd=		[EIDE] (E)IDE hard drive subsystem geometry
 			Format: <cyl>,<head>,<sect>
 
+	hest_disable	[ACPI]
+			Disable Hardware Error Source Table (HEST) support,
+			corresponding firmware-first mode error processing
+			logic will be disabled.
+
 	highmem=nn[KMG]	[KNL,BOOT] forces the highmem zone to have an exact
 			size of <nn>. This works even on boxes that have no
 			highmem otherwise. This also works to reduce highmem
--- a/drivers/acpi/apei/Kconfig
+++ b/drivers/acpi/apei/Kconfig
@@ -1,5 +1,5 @@
 config ACPI_APEI
-	tristate "ACPI Platform Error Interface (APEI)"
+	bool "ACPI Platform Error Interface (APEI)"
 	depends on X86
 	help
 	  APEI allows to report errors (for example from the chipset)
--- a/drivers/acpi/apei/apei-base.c
+++ b/drivers/acpi/apei/apei-base.c
@@ -45,12 +45,6 @@
 
 #define APEI_PFX "APEI: "
 
-struct dentry *apei_debug_dir;
-EXPORT_SYMBOL_GPL(apei_debug_dir);
-
-int hest_disable;
-EXPORT_SYMBOL(hest_disable);
-
 /*
  * APEI ERST (Error Record Serialization Table) and EINJ (Error
  * INJection) interpreter framework.
@@ -553,37 +547,13 @@ int apei_exec_collect_resources(struct a
 }
 EXPORT_SYMBOL_GPL(apei_exec_collect_resources);
 
-static int __init apei_init(void)
+struct dentry *apei_get_debugfs_dir(void)
 {
-	int rc;
-
-	apei_debug_dir = debugfs_create_dir("apei", NULL);
-	if (!apei_debug_dir)
-		return -ENOMEM;
-	if (!hest_disable) {
-		rc = hest_init();
-		if (rc) {
-			hest_disable = 1;
-			if (rc != -ENODEV)
-				pr_err(
-				"ACPI: APEI: Failed to initialize Hardware "
-				"Error Source Table (HEST) subsystem\n");
-		}
-	}
+	static struct dentry *dapei;
 
-	return 0;
-}
+	if (!dapei)
+		dapei = debugfs_create_dir("apei", NULL);
 
-static void __exit apei_exit(void)
-{
-	debugfs_remove_recursive(apei_debug_dir);
+	return dapei;
 }
-
-module_init(apei_init);
-module_exit(apei_exit);
-
-module_param(hest_disable, int, 0444);
-
-MODULE_AUTHOR("Huang Ying");
-MODULE_DESCRIPTION("ACPI Platform Error Interface support");
-MODULE_LICENSE("GPL");
+EXPORT_SYMBOL_GPL(apei_get_debugfs_dir);
--- a/drivers/acpi/apei/apei-internal.h
+++ b/drivers/acpi/apei/apei-internal.h
@@ -6,8 +6,6 @@
 #ifndef APEI_INTERNAL_H
 #define APEI_INTERNAL_H
 
-int hest_init(void);
-
 struct apei_exec_context;
 
 typedef int (*apei_exec_ins_func_t)(struct apei_exec_context *ctx,
@@ -93,5 +91,5 @@ int apei_exec_collect_resources(struct a
 				struct apei_resources *resources);
 
 struct dentry;
-extern struct dentry *apei_debug_dir;
+struct dentry *apei_get_debugfs_dir(void);
 #endif
--- a/drivers/acpi/apei/einj.c
+++ b/drivers/acpi/apei/einj.c
@@ -409,7 +409,7 @@ static int __init einj_init(void)
 	}
 
 	rc = -ENOMEM;
-	einj_debug_dir = debugfs_create_dir("einj", apei_debug_dir);
+	einj_debug_dir = debugfs_create_dir("einj", apei_get_debugfs_dir());
 	if (!einj_debug_dir)
 		goto err_cleanup;
 	fentry = debugfs_create_file("available_error_type", S_IRUSR,
--- a/drivers/acpi/apei/hest.c
+++ b/drivers/acpi/apei/hest.c
@@ -40,6 +40,9 @@
 
 #define HEST_PFX "HEST: "
 
+int hest_disable;
+EXPORT_SYMBOL_GPL(hest_disable);
+
 /* HEST table parsing */
 
 static struct acpi_table_hest *hest_tab;
@@ -118,30 +121,49 @@ int apei_hest_parse(apei_hest_func_t fun
 }
 EXPORT_SYMBOL_GPL(apei_hest_parse);
 
-int __init hest_init(void)
+static int __init setup_hest_disable(char *str)
+{
+	hest_disable = 1;
+	return 0;
+}
+
+__setup("hest_disable", setup_hest_disable);
+
+static int __init hest_init(void)
 {
 	acpi_status status;
-	int rc;
+	int rc = 0;
 
 	if (acpi_disabled)
-		return -ENODEV;
+		goto err;
+
+	if (hest_disable) {
+		pr_info(HEST_PFX "HEST tabling parsing is disabled.\n");
+		goto err;
+	}
 
 	status = acpi_get_table(ACPI_SIG_HEST, 0,
 				(struct acpi_table_header **)&hest_tab);
 	if (status == AE_NOT_FOUND) {
 		pr_info(HEST_PFX "Table is not found!\n");
-		return -ENODEV;
+		goto err;
 	} else if (ACPI_FAILURE(status)) {
 		const char *msg = acpi_format_exception(status);
 		pr_info(HEST_PFX "Failed to get table, %s\n", msg);
-		return -EINVAL;
+		rc = -EINVAL;
+		goto err;
 	}
 
 	rc = apei_hest_parse(hest_void_parse, NULL);
 	if (rc)
-		return rc;
+		goto err;
 
 	pr_info(HEST_PFX "HEST table parsing is initialized.\n");
 
 	return 0;
+err:
+	hest_disable = 1;
+	return rc;
 }
+
+subsys_initcall(hest_init);
