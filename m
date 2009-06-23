Return-Path: <linux-kernel-owner+w=401wt.eu-S1758456AbZFWHPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758456AbZFWHPL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 03:15:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757947AbZFWHOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 03:14:35 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:14135 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758248AbZFWHOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 03:14:34 -0400
From: Len Brown <lenb@kernel.org>
To: sfi-devel@simplefirmware.org, linux-kernel@vger.kernel.org
Cc: Feng Tang <feng.tang@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 6/8] SFI: add ACPI extensions
Date: Tue, 23 Jun 2009 03:14:04 -0400
Message-id: <505434cf34f7438a65262060df88b0638511684d.1245740912.git.len.brown@intel.com>
X-Mailer: git-send-email 1.6.3.3.334.g916e1
In-reply-to: <1245741246-6503-1-git-send-email-lenb@kernel.org>
References: <1245741246-6503-1-git-send-email-lenb@kernel.org>
In-reply-to: <7425334c8329b15bec7cb4ecd0b17af042e97465.1245740912.git.len.brown@intel.com>
References: <7425334c8329b15bec7cb4ecd0b17af042e97465.1245740912.git.len.brown@intel.com>
X-Patchwork-Hint: ignore
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Feng Tang <feng.tang@intel.com>

Extend SFI to access standard ACPI tables
such as the PCI MCFG using sfi_acpi_table_parse().

Note that SFI runs only with acpi_disabled=1,
but is independent of CONFIG_ACPI.

Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/tables.c       |    3 +
 drivers/sfi/Makefile        |    2 +
 drivers/sfi/sfi_acpi.c      |   94 +++++++++++++++++++++++++++++++++++++++++++
 include/acpi/acpi_drivers.h |    3 +
 include/linux/acpi.h        |    5 +-
 include/linux/sfi_acpi.h    |   56 +++++++++++++++++++++++++
 6 files changed, 161 insertions(+), 2 deletions(-)
 create mode 100644 drivers/sfi/sfi_acpi.c
 create mode 100644 include/linux/sfi_acpi.h

diff --git a/drivers/acpi/tables.c b/drivers/acpi/tables.c
index 646d39c..921746f 100644
--- a/drivers/acpi/tables.c
+++ b/drivers/acpi/tables.c
@@ -277,6 +277,9 @@ int __init acpi_table_parse(char *id, acpi_table_handler handler)
 	struct acpi_table_header *table = NULL;
 	acpi_size tbl_size;
 
+	if (acpi_disabled)
+		return 1;
+
 	if (!handler)
 		return -EINVAL;
 
diff --git a/drivers/sfi/Makefile b/drivers/sfi/Makefile
index f176470..2343732 100644
--- a/drivers/sfi/Makefile
+++ b/drivers/sfi/Makefile
@@ -1 +1,3 @@
+obj-y	+= sfi_acpi.o
 obj-y	+= sfi_core.o
+
diff --git a/drivers/sfi/sfi_acpi.c b/drivers/sfi/sfi_acpi.c
new file mode 100644
index 0000000..f972785
--- /dev/null
+++ b/drivers/sfi/sfi_acpi.c
@@ -0,0 +1,94 @@
+/* sfi_acpi.c Simple Firmware Interface - ACPI extensions */
+
+/*
+ * Copyright (C) 2009, Intel Corp.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions, and the following disclaimer,
+ *    without modification.
+ * 2. Redistributions in binary form must reproduce at minimum a disclaimer
+ *    substantially similar to the "NO WARRANTY" disclaimer below
+ *    ("Disclaimer") and any redistribution must be conditioned upon
+ *    including a substantially similar Disclaimer requirement for further
+ *    binary redistribution.
+ * 3. Neither the names of the above-listed copyright holders nor the names
+ *    of any contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * Alternatively, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") version 2 as published by the Free
+ * Software Foundation.
+ *
+ * NO WARRANTY
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * HOLDERS OR CONTRIBUTORS BE LIABLE FOR SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
+ * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
+ * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+ * POSSIBILITY OF SUCH DAMAGES.
+ */
+
+#include <linux/acpi.h>
+#include <linux/kernel.h>
+#include <linux/sfi.h>
+#include "sfi_core.h"
+
+#undef PREFIX
+#define PREFIX	"SFI: "
+
+/*
+ * SFI can access ACPI-defined tables via an optional ACPI XSDT.
+ *
+ * This allows re-use, and avoids re-definition, of standard tables.
+ * For example, the "MCFG" table is defined by PCI, reserved by ACPI,
+ * and is expected to be present many SFI-only systems.
+ */
+
+/*
+ * sfi_acpi_parse_xsdt()
+ *
+ * Parse the ACPI XSDT for later access by sfi_acpi_table_parse().
+ */
+static int __init sfi_acpi_parse_xsdt(struct sfi_table_header *table)
+{
+	int num_entries, i;
+
+	struct acpi_table_xsdt *xsdt = (struct acpi_table_xsdt *) table;
+
+	BUG_ON(!xsdt);
+
+	num_entries = (xsdt->header.length - sizeof(struct acpi_table_header) /
+		sizeof(u64));
+
+	pr_debug(PREFIX "XSDT has %d entries\n", num_entries);
+
+	for (i = 0; i < num_entries; i++)
+		sfi_tb_install_table(xsdt->table_offset_entry[i], SFI_ACPI_TABLE);
+
+	return 0;
+}
+
+int sfi_acpi_init()
+{
+	sfi_table_parse(SFI_SIG_XSDT, NULL, NULL, 0, sfi_acpi_parse_xsdt);
+	return 0;
+}
+/*
+ * sfi_acpi_table_parse()
+ */
+int sfi_acpi_table_parse(char *signature, char *oem_id, char* oem_table_id,
+        unsigned int flags, acpi_table_handler handler)
+{
+	return sfi_table_parse(signature, oem_id, oem_table_id, SFI_ACPI_TABLE,
+		(sfi_table_handler)handler);
+}
+
diff --git a/include/acpi/acpi_drivers.h b/include/acpi/acpi_drivers.h
index 0352c8f..5d84a17 100644
--- a/include/acpi/acpi_drivers.h
+++ b/include/acpi/acpi_drivers.h
@@ -29,6 +29,8 @@
 #include <linux/acpi.h>
 #include <acpi/acpi_bus.h>
 
+#ifdef	CONFIG_ACPI
+
 #define ACPI_MAX_STRING			80
 
 /*
@@ -157,4 +159,5 @@ static inline void unregister_hotplug_dock_device(acpi_handle handle)
 }
 #endif
 
+#endif /* CONFIG_ACPI */
 #endif /*__ACPI_DRIVERS_H__*/
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index bf17681..be418f1 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -27,7 +27,6 @@
 
 #include <linux/ioport.h>	/* for struct resource */
 
-#ifdef	CONFIG_ACPI
 
 #ifndef _LINUX
 #define _LINUX
@@ -43,6 +42,9 @@
 #include <asm/acpi.h>
 #include <linux/dmi.h>
 
+typedef int (*acpi_table_handler) (struct acpi_table_header *table);
+
+#ifdef	CONFIG_ACPI
 
 enum acpi_irq_model_id {
 	ACPI_IRQ_MODEL_PIC = 0,
@@ -74,7 +76,6 @@ enum acpi_address_range_id {
 
 /* Table Handlers */
 
-typedef int (*acpi_table_handler) (struct acpi_table_header *table);
 
 typedef int (*acpi_table_entry_handler) (struct acpi_subtable_header *header, const unsigned long end);
 
diff --git a/include/linux/sfi_acpi.h b/include/linux/sfi_acpi.h
new file mode 100644
index 0000000..7a49380
--- /dev/null
+++ b/include/linux/sfi_acpi.h
@@ -0,0 +1,56 @@
+/* sfi.h Simple Firmware Interface */
+
+/*
+ * Copyright (C) 2009, Intel Corp.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions, and the following disclaimer,
+ *    without modification.
+ * 2. Redistributions in binary form must reproduce at minimum a disclaimer
+ *    substantially similar to the "NO WARRANTY" disclaimer below
+ *    ("Disclaimer") and any redistribution must be conditioned upon
+ *    including a substantially similar Disclaimer requirement for further
+ *    binary redistribution.
+ * 3. Neither the names of the above-listed copyright holders nor the names
+ *    of any contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * Alternatively, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") version 2 as published by the Free
+ * Software Foundation.
+ *
+ * NO WARRANTY
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * HOLDERS OR CONTRIBUTORS BE LIABLE FOR SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
+ * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
+ * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+ * POSSIBILITY OF SUCH DAMAGES.
+ */
+
+#ifndef _LINUX_SFI_ACPI_H
+#define _LINUX_SFI_ACPI_H
+
+#ifdef	CONFIG_SFI
+#include <linux/acpi.h>		/* acpi_table_handler */
+
+int sfi_acpi_table_parse(char *signature, char *oem_id, char* oem_table_id,
+	uint flag, acpi_table_handler handler);
+
+#else /* !CONFIG_SFI */
+
+static inline int sfi_acpi_table_parse(char *signature, char *oem_id, char* oem_table_id,
+	unsigned int flags, acpi_table_handler handler) { return -1; }
+
+#endif	/* CONFIG_SFI */
+
+#endif	/*_LINUX_SFI_ACPI_H*/
-- 
1.6.0.6

