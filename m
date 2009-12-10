Return-Path: <linux-kernel-owner+w=401wt.eu-S1760541AbZLJHRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760541AbZLJHRT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 02:17:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760485AbZLJHRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 02:17:10 -0500
Received: from mga09.intel.com ([134.134.136.24]:5330 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756005AbZLJHQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 02:16:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,373,1257148800"; 
   d="scan'208";a="474490002"
Subject: [PATCH 3/5 -v2] acpi, apei, HEST table parsing
From: Huang Ying <ying.huang@intel.com>
To: lenb@kernel.org
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Dec 2009 15:16:59 +0800
Message-ID: <1260429419.15264.395.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HEST describes error sources in detail; communicating operational
parameters (i.e. severity levels, masking bits, and threshold values)
to OS as necessary. It also allows the platform to report error
sources for which OS would typically not implement support (for
example, chipset-specific error registers).

HEST information may be needed by other subsystems. For example, HEST
PCIE AER error source information describes whether a PCIE root port
works in "firmware first" mode, this is needed by general PCIE AER
error subsystem. So a public HEST tabling parsing interface is
provided.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 drivers/acpi/apei/Makefile        |    2 
 drivers/acpi/apei/apei-base.c     |   20 +++++
 drivers/acpi/apei/apei-internal.h |    3 
 drivers/acpi/apei/hest.c          |  151 ++++++++++++++++++++++++++++++++++++++
 include/acpi/apei.h               |   13 +++
 5 files changed, 188 insertions(+), 1 deletion(-)
 create mode 100644 drivers/acpi/apei/hest.c
 create mode 100644 include/acpi/apei.h

--- a/drivers/acpi/apei/Makefile
+++ b/drivers/acpi/apei/Makefile
@@ -1,3 +1,3 @@
 obj-$(CONFIG_ACPI_APEI)		+= apei.o
 
-apei-y := apei-base.o
+apei-y := apei-base.o hest.o
--- a/drivers/acpi/apei/apei-base.c
+++ b/drivers/acpi/apei/apei-base.c
@@ -48,6 +48,9 @@
 struct dentry *apei_debug_dir;
 EXPORT_SYMBOL_GPL(apei_debug_dir);
 
+int hest_disable;
+EXPORT_SYMBOL(hest_disable);
+
 /*
  * APEI ERST (Error Record Serialization Table) and EINJ (Error
  * INJection) interpreter framework.
@@ -546,21 +549,38 @@ EXPORT_SYMBOL_GPL(apei_exec_collect_reso
 
 static int __init apei_init(void)
 {
+	int rc;
+
 	apei_debug_dir = debugfs_create_dir("apei", NULL);
 	if (!apei_debug_dir)
 		return -ENOMEM;
+	if (!hest_disable) {
+		rc = hest_init();
+		if (rc) {
+			hest_disable = 1;
+			if (rc != -ENODEV)
+				pr_err(
+				"ACPI: APEI: Failed to initialize Hardware "
+				"Error Source Table (HEST) subsystem\n");
+		}
+	}
 
 	return 0;
 }
 
 static void __exit apei_exit(void)
 {
+	if (!hest_disable)
+		hest_exit();
+
 	debugfs_remove_recursive(apei_debug_dir);
 }
 
 module_init(apei_init);
 module_exit(apei_exit);
 
+module_param(hest_disable, int, 0444);
+
 MODULE_AUTHOR("Huang Ying");
 MODULE_DESCRIPTION("ACPI Platform Error Interface support");
 MODULE_LICENSE("GPL");
--- a/drivers/acpi/apei/apei-internal.h
+++ b/drivers/acpi/apei/apei-internal.h
@@ -6,6 +6,9 @@
 #ifndef APEI_INTERNAL_H
 #define APEI_INTERNAL_H
 
+int hest_init(void);
+void hest_exit(void);
+
 struct apei_exec_context;
 
 typedef int (*apei_exec_ins_func_t)(struct apei_exec_context *ctx,
--- /dev/null
+++ b/drivers/acpi/apei/hest.c
@@ -0,0 +1,151 @@
+/*
+ * APEI Hardware Error Souce Table support
+ *
+ * HEST describes error sources in detail; communicates operational
+ * parameters (i.e. severity levels, masking bits, and threshold
+ * values) to OS as necessary. It also allows the platform to report
+ * error sources for which OS would typically not implement support
+ * (for example, chipset-specific error registers).
+ *
+ * For more information about HEST, please refer to ACPI Specification
+ * version 4.0, section 17.3.2.
+ *
+ * Copyright 2009 Intel Corp.
+ *   Author: Huang Ying <ying.huang@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation;
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/acpi.h>
+#include <linux/kdebug.h>
+#include <linux/highmem.h>
+#include <linux/io.h>
+#include <acpi/apei.h>
+
+#include "apei-internal.h"
+
+#define HEST_PFX "HEST: "
+
+/* HEST table parsing */
+
+static struct acpi_table_hest *hest_tab;
+
+static int hest_void_parse(struct acpi_hest_header *hest_hdr, void *data)
+{
+	return 0;
+}
+
+static int hest_esrc_len_tab[ACPI_HEST_TYPE_RESERVED] = {
+	[ACPI_HEST_TYPE_IA32_CHECK] = -1,	/* need further calculation */
+	[ACPI_HEST_TYPE_IA32_CORRECTED_CHECK] = -1,
+	[ACPI_HEST_TYPE_IA32_NMI] = sizeof(struct acpi_hest_ia_nmi),
+	[ACPI_HEST_TYPE_AER_ROOT_PORT] = sizeof(struct acpi_hest_aer_root),
+	[ACPI_HEST_TYPE_AER_ENDPOINT] = sizeof(struct acpi_hest_aer),
+	[ACPI_HEST_TYPE_AER_BRIDGE] = sizeof(struct acpi_hest_aer_bridge),
+	[ACPI_HEST_TYPE_GENERIC_ERROR] = sizeof(struct acpi_hest_generic),
+};
+
+static int hest_esrc_len(struct acpi_hest_header *hest_hdr)
+{
+	u16 hest_type = hest_hdr->type;
+	int len;
+
+	if (hest_type >= ACPI_HEST_TYPE_RESERVED)
+		return 0;
+
+	len = hest_esrc_len_tab[hest_type];
+
+	if (hest_type == ACPI_HEST_TYPE_IA32_CORRECTED_CHECK) {
+		struct acpi_hest_ia_corrected *cmc;
+		cmc = (struct acpi_hest_ia_corrected *)hest_hdr;
+		len = sizeof(*cmc) + cmc->num_hardware_banks *
+			sizeof(struct acpi_hest_ia_error_bank);
+	} else if (hest_type == ACPI_HEST_TYPE_IA32_CHECK) {
+		struct acpi_hest_ia_machine_check *mc;
+		mc = (struct acpi_hest_ia_machine_check *)hest_hdr;
+		len = sizeof(*mc) + mc->num_hardware_banks *
+			sizeof(struct acpi_hest_ia_error_bank);
+	}
+	BUG_ON(len == -1);
+
+	return len;
+};
+
+int apei_hest_parse(apei_hest_func_t func, void *data)
+{
+	struct acpi_hest_header *hest_hdr;
+	int i, rc, len;
+
+	if (hest_disable)
+		return -EINVAL;
+
+	hest_hdr = (struct acpi_hest_header *)(hest_tab + 1);
+	for (i = 0; i < hest_tab->error_source_count; i++) {
+		len = hest_esrc_len(hest_hdr);
+		if (!len) {
+			pr_info(HEST_PFX "Unknown or unused hardware error "
+				"source type: %d\n", hest_hdr->type);
+			return -EINVAL;
+		}
+		if ((void *)hest_hdr + len >
+		    (void *)hest_tab + hest_tab->header.length) {
+			pr_info(HEST_PFX "Table contents overflow!\n");
+			return -EINVAL;
+		}
+
+		rc = func(hest_hdr, data);
+		if (rc)
+			return rc;
+
+		hest_hdr = (void *)hest_hdr + len;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(apei_hest_parse);
+
+int __init hest_init(void)
+{
+	acpi_status status;
+	int rc;
+
+	if (acpi_disabled)
+		return -ENODEV;
+
+	status = acpi_get_table(ACPI_SIG_HEST, 0,
+				(struct acpi_table_header **)&hest_tab);
+	if (status == AE_NOT_FOUND) {
+		pr_info(HEST_PFX "Table is not found!\n");
+		return -ENODEV;
+	} else if (ACPI_FAILURE(status)) {
+		const char *msg = acpi_format_exception(status);
+		pr_info(HEST_PFX "Failed to get table, %s\n", msg);
+		return -EINVAL;
+	}
+
+	rc = apei_hest_parse(hest_void_parse, NULL);
+	if (rc)
+		return rc;
+
+	pr_info(HEST_PFX "HEST table parsing is initialized.\n");
+
+	return 0;
+}
+
+void __exit hest_exit(void)
+{
+}
--- /dev/null
+++ b/include/acpi/apei.h
@@ -0,0 +1,13 @@
+/*
+ * apei.h - ACPI Platform Error Interface
+ */
+
+#ifndef ACPI_APEI_H
+#define ACPI_APEI_H
+
+extern int hest_disable;
+
+typedef int (*apei_hest_func_t)(struct acpi_hest_header *hest_hdr, void *data);
+int apei_hest_parse(apei_hest_func_t func, void *data);
+
+#endif


