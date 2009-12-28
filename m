Return-Path: <linux-kernel-owner+w=401wt.eu-S1751762AbZL1GMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762AbZL1GMy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 01:12:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751691AbZL1GMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 01:12:44 -0500
Received: from mga03.intel.com ([143.182.124.21]:7038 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631AbZL1GMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 01:12:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="227061018"
From: Huang Ying <ying.huang@intel.com>
To: lenb@kernel.org
Cc: ak@linux.intel.com, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, Huang Ying <ying.huang@intel.com>
Subject: [PATCH 3/5] ACPI, APEI, HEST table parsing
Date: Mon, 28 Dec 2009 14:12:22 +0800
Message-Id: <1261980744-4450-4-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1261980744-4450-3-git-send-email-ying.huang@intel.com>
References: <1261980744-4450-1-git-send-email-ying.huang@intel.com>
 <1261980744-4450-2-git-send-email-ying.huang@intel.com>
 <1261980744-4450-3-git-send-email-ying.huang@intel.com>
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
 drivers/acpi/apei/Makefile        |    2 +-
 drivers/acpi/apei/apei-base.c     |   17 ++++
 drivers/acpi/apei/apei-internal.h |    2 +
 drivers/acpi/apei/hest.c          |  147 +++++++++++++++++++++++++++++++++++++
 include/acpi/apei.h               |   13 +++
 5 files changed, 180 insertions(+), 1 deletions(-)
 create mode 100644 drivers/acpi/apei/hest.c
 create mode 100644 include/acpi/apei.h

diff --git a/drivers/acpi/apei/Makefile b/drivers/acpi/apei/Makefile
index 6f41dfc..a883292 100644
--- a/drivers/acpi/apei/Makefile
+++ b/drivers/acpi/apei/Makefile
@@ -1,3 +1,3 @@
 obj-$(CONFIG_ACPI_APEI)		+= apei.o
 
-apei-y := apei-base.o
+apei-y := apei-base.o hest.o
diff --git a/drivers/acpi/apei/apei-base.c b/drivers/acpi/apei/apei-base.c
index d13871b..c35fec7 100644
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
@@ -552,9 +555,21 @@ EXPORT_SYMBOL_GPL(apei_exec_collect_resources);
 
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
@@ -567,6 +582,8 @@ static void __exit apei_exit(void)
 module_init(apei_init);
 module_exit(apei_exit);
 
+module_param(hest_disable, int, 0444);
+
 MODULE_AUTHOR("Huang Ying");
 MODULE_DESCRIPTION("ACPI Platform Error Interface support");
 MODULE_LICENSE("GPL");
diff --git a/drivers/acpi/apei/apei-internal.h b/drivers/acpi/apei/apei-internal.h
index 9fcf128..1ab6598 100644
--- a/drivers/acpi/apei/apei-internal.h
+++ b/drivers/acpi/apei/apei-internal.h
@@ -6,6 +6,8 @@
 #ifndef APEI_INTERNAL_H
 #define APEI_INTERNAL_H
 
+int hest_init(void);
+
 struct apei_exec_context;
 
 typedef int (*apei_exec_ins_func_t)(struct apei_exec_context *ctx,
diff --git a/drivers/acpi/apei/hest.c b/drivers/acpi/apei/hest.c
new file mode 100644
index 0000000..f872e54
--- /dev/null
+++ b/drivers/acpi/apei/hest.c
@@ -0,0 +1,147 @@
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
+			pr_info(HEST_PFX FW_WARN "Unknown or unused hardware "
+				"error source type: %d\n", hest_hdr->type);
+			return -EINVAL;
+		}
+		if ((void *)hest_hdr + len >
+		    (void *)hest_tab + hest_tab->header.length) {
+			pr_info(HEST_PFX FW_BUG "Table contents overflow!\n");
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
diff --git a/include/acpi/apei.h b/include/acpi/apei.h
new file mode 100644
index 0000000..631a1ad
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
-- 
1.6.5

