Return-Path: <linux-kernel-owner+w=401wt.eu-S1759185AbZGHEPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759185AbZGHEPx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 00:15:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751274AbZGHEOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 00:14:35 -0400
Received: from vms173019pub.verizon.net ([206.46.173.19]:46912 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbZGHEOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 00:14:09 -0400
From: Len Brown <lenb@kernel.org>
To: x86@kernel.org, sfi-devel@simplefirmware.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Cc: Feng Tang <feng.tang@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 09/12] SFI: Enable SFI to parse ACPI tables
Date: Wed, 08 Jul 2009 00:13:55 -0400
Message-id: <5ab9dd34acc6209c5b6a3c754075e408e5298a2d.1247025117.git.len.brown@intel.com>
X-Mailer: git-send-email 1.6.3.3.385.g60647
In-reply-to: <1247026438-20891-1-git-send-email-lenb@kernel.org>
References: <1247026438-20891-1-git-send-email-lenb@kernel.org>
In-reply-to: <8e4a93858bce74ed3080dd607aa471023f1a2737.1247025117.git.len.brown@intel.com>
References: <8e4a93858bce74ed3080dd607aa471023f1a2737.1247025117.git.len.brown@intel.com>
X-Patchwork-Hint: ignore
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Feng Tang <feng.tang@intel.com>

Extend SFI to access standard ACPI tables.
(eg. the PCI MCFG) using sfi_acpi_table_parse().

Note that this is _not_ a hybrid ACPI + SFI mode.
The platform boots in either ACPI mode or SFI mode.

SFI runs only with acpi_disabled=1, which can be set
at build-time via CONFIG_ACPI=n, or at boot time by
the failure to find ACPI platform support.

So this extension simply allows SFI-platforms to
re-use existing standard table formats that happen to
be defined to live in ACPI envelopes.

Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/sfi/Makefile     |    2 +
 drivers/sfi/sfi_acpi.c   |  151 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/sfi/sfi_core.c   |    2 +
 include/linux/sfi_acpi.h |   60 ++++++++++++++++++
 4 files changed, 215 insertions(+), 0 deletions(-)
 create mode 100644 drivers/sfi/sfi_acpi.c
 create mode 100644 include/linux/sfi_acpi.h

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
index 0000000..0cc2332
--- /dev/null
+++ b/drivers/sfi/sfi_acpi.c
@@ -0,0 +1,151 @@
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
+#define KMSG_COMPONENT "SFI"
+#define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
+
+#include <linux/kernel.h>
+#include <acpi/acpi.h>
+#include <linux/sfi.h>
+
+#include "sfi_core.h"
+
+/*
+ * SFI can access ACPI-defined tables via an optional ACPI XSDT.
+ *
+ * This allows re-use, and avoids re-definition, of standard tables.
+ * For example, the "MCFG" table is defined by PCI, reserved by ACPI,
+ * and is expected to be present many SFI-only systems.
+ */
+
+static struct acpi_table_xsdt *xsdt_va;
+
+#define XSDT_GET_NUM_ENTRIES(ptable, entry_type) \
+	((ptable->header.length - sizeof(struct acpi_table_header)) / \
+	(sizeof(entry_type)))
+
+/*
+ * sfi_acpi_parse_xsdt()
+ *
+ * Parse the ACPI XSDT for later access by sfi_acpi_table_parse().
+ */
+static int __init sfi_acpi_parse_xsdt(struct sfi_table_header *table)
+{
+	int tbl_cnt, i;
+	xsdt_va = (struct acpi_table_xsdt *)table;
+
+	tbl_cnt = XSDT_GET_NUM_ENTRIES(xsdt_va, u64);
+
+	for (i = 0; i < tbl_cnt; i++) {
+		if (sfi_check_table(xsdt_va->table_offset_entry[i])) {
+			disable_sfi();
+			return -1;
+		}
+	}
+
+	return 0;
+}
+
+int __init sfi_acpi_init(void)
+{
+	sfi_table_parse(SFI_SIG_XSDT, NULL, NULL, 0, sfi_acpi_parse_xsdt);
+	return 0;
+}
+
+static struct acpi_table_header *sfi_acpi_get_table(char *signature,
+			char *oem_id, char *oem_table_id, unsigned int flags)
+{
+	struct acpi_table_header *th;
+	u32 tbl_cnt, i;
+	u64 pa;
+
+	tbl_cnt = XSDT_GET_NUM_ENTRIES(xsdt_va, u64);
+
+	for (i = 0; i < tbl_cnt; i++) {
+		pa = xsdt_va->table_offset_entry[i];
+
+		th = (struct acpi_table_header *)sfi_map_table(pa);
+		if (!th)
+			return NULL;
+
+		if (strncmp(th->signature, signature, SFI_SIGNATURE_SIZE))
+			goto loop_continue;
+
+		if (oem_id && strncmp(th->oem_id, oem_id, SFI_OEM_ID_SIZE))
+			goto loop_continue;
+
+		if (oem_table_id && strncmp(th->oem_table_id, oem_table_id,
+						SFI_OEM_TABLE_ID_SIZE))
+			goto loop_continue;
+
+		return th;      /* success */
+loop_continue:
+		sfi_unmap_table((struct sfi_table_header *)th);
+	}
+
+	return NULL;
+}
+
+static void sfi_acpi_put_table(struct acpi_table_header *table)
+{
+	sfi_put_table((struct sfi_table_header *)table);
+}
+
+/*
+ * sfi_acpi_table_parse()
+ *
+ * find specified table in XSDT, run handler on it and return its return value
+ */
+int sfi_acpi_table_parse(char *signature, char *oem_id, char *oem_table_id,
+		 unsigned int flags, int(*handler)(struct acpi_table_header *))
+{
+	int ret = 0;
+	struct acpi_table_header *table = NULL;
+
+	if (sfi_disabled)
+		return -1;
+
+	table = sfi_acpi_get_table(signature, oem_id, oem_table_id, flags);
+	if (!table)
+		return -EINVAL;
+
+	ret = handler(table);
+	sfi_acpi_put_table(table);
+	return ret;
+}
diff --git a/drivers/sfi/sfi_core.c b/drivers/sfi/sfi_core.c
index 8939215..f411a02 100644
--- a/drivers/sfi/sfi_core.c
+++ b/drivers/sfi/sfi_core.c
@@ -369,6 +369,8 @@ void __init sfi_init_late(void)
 	/* use ioremap now after it is ready */
 	sfi_use_ioremap = 1;
 	syst_va = sfi_map_memory(syst_pa, length);
+
+	sfi_acpi_init();
 }
 
 static int __init sfi_parse_cmdline(char *arg)
diff --git a/include/linux/sfi_acpi.h b/include/linux/sfi_acpi.h
new file mode 100644
index 0000000..d19a00a
--- /dev/null
+++ b/include/linux/sfi_acpi.h
@@ -0,0 +1,60 @@
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
+#include <acpi/acpi.h>		/* struct acpi_table_header */
+
+int sfi_acpi_table_parse(char *signature, char *oem_id, char* oem_table_id,
+	uint flag, int (*handler)(struct acpi_table_header *));
+
+#else /* !CONFIG_SFI */
+
+static inline int sfi_acpi_table_parse(char *signature, char *oem_id,
+	char *oem_table_id, unsigned int flags,
+	int (*handler)(struct acpi_table_header *))
+{
+	return -1;
+}
+
+#endif	/* CONFIG_SFI */
+
+#endif	/*_LINUX_SFI_ACPI_H*/
-- 
1.6.0.6

