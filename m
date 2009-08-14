Return-Path: <linux-kernel-owner+w=401wt.eu-S1753895AbZHNUlK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895AbZHNUlK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 16:41:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753819AbZHNUlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 16:41:08 -0400
Received: from vms173015pub.verizon.net ([206.46.173.15]:41264 "EHLO
	vms173015pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267AbZHNUkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 16:40:52 -0400
From: Len Brown <lenb@kernel.org>
To: x86@kernel.org, sfi-devel@simplefirmware.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Cc: Feng Tang <feng.tang@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 09/11] SFI: add capability to parse ACPI tables
Date: Fri, 14 Aug 2009 16:38:13 -0400
Message-id: <a955f53d46c3f61803fede27bf90835487fbe456.1250281826.git.len.brown@intel.com>
X-Mailer: git-send-email 1.6.4.122.g6ffd7
In-reply-to: <1250282295-25216-1-git-send-email-lenb@kernel.org>
References: <1250282295-25216-1-git-send-email-lenb@kernel.org>
In-reply-to: <0763223ab0ef5c0016b7a179c1acccaabbefea02.1250281826.git.len.brown@intel.com>
References: <0763223ab0ef5c0016b7a179c1acccaabbefea02.1250281826.git.len.brown@intel.com>
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
 drivers/sfi/sfi_acpi.c   |  175 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/sfi_acpi.h |   93 ++++++++++++++++++++++++
 2 files changed, 268 insertions(+), 0 deletions(-)
 create mode 100644 drivers/sfi/sfi_acpi.c
 create mode 100644 include/linux/sfi_acpi.h

diff --git a/drivers/sfi/sfi_acpi.c b/drivers/sfi/sfi_acpi.c
new file mode 100644
index 0000000..34aba30
--- /dev/null
+++ b/drivers/sfi/sfi_acpi.c
@@ -0,0 +1,175 @@
+/* sfi_acpi.c Simple Firmware Interface - ACPI extensions */
+
+/*
+
+  This file is provided under a dual BSD/GPLv2 license.  When using or
+  redistributing this file, you may do so under either license.
+
+  GPL LICENSE SUMMARY
+
+  Copyright(c) 2009 Intel Corporation. All rights reserved.
+
+  This program is free software; you can redistribute it and/or modify
+  it under the terms of version 2 of the GNU General Public License as
+  published by the Free Software Foundation.
+
+  This program is distributed in the hope that it will be useful, but
+  WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+  General Public License for more details.
+
+  You should have received a copy of the GNU General Public License
+  along with this program; if not, write to the Free Software
+  Foundation, Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+  The full GNU General Public License is included in this distribution
+  in the file called LICENSE.GPL.
+
+  BSD LICENSE
+
+  Copyright(c) 2009 Intel Corporation. All rights reserved.
+
+  Redistribution and use in source and binary forms, with or without
+  modification, are permitted provided that the following conditions
+  are met:
+
+    * Redistributions of source code must retain the above copyright
+      notice, this list of conditions and the following disclaimer.
+    * Redistributions in binary form must reproduce the above copyright
+      notice, this list of conditions and the following disclaimer in
+      the documentation and/or other materials provided with the
+      distribution.
+    * Neither the name of Intel Corporation nor the names of its
+      contributors may be used to endorse or promote products derived
+      from this software without specific prior written permission.
+
+  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+
+*/
+
+#define KMSG_COMPONENT "SFI"
+#define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
+
+#include <linux/kernel.h>
+#include <acpi/acpi.h>
+
+#include <linux/sfi.h>
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
+static struct acpi_table_xsdt *xsdt_va __read_mostly;
+
+#define XSDT_GET_NUM_ENTRIES(ptable, entry_type) \
+	((ptable->header.length - sizeof(struct acpi_table_header)) / \
+	(sizeof(entry_type)))
+
+static inline struct sfi_table_header *acpi_to_sfi_th(
+				struct acpi_table_header *th)
+{
+	return (struct sfi_table_header *)th;
+}
+
+static inline struct acpi_table_header *sfi_to_acpi_th(
+				struct sfi_table_header *th)
+{
+	return (struct acpi_table_header *)th;
+}
+
+/*
+ * sfi_acpi_parse_xsdt()
+ *
+ * Parse the ACPI XSDT for later access by sfi_acpi_table_parse().
+ */
+static int __init sfi_acpi_parse_xsdt(struct sfi_table_header *th)
+{
+	struct sfi_table_key key = SFI_ANY_KEY;
+	int tbl_cnt, i;
+	void *ret;
+
+	xsdt_va = (struct acpi_table_xsdt *)th;
+	tbl_cnt = XSDT_GET_NUM_ENTRIES(xsdt_va, u64);
+	for (i = 0; i < tbl_cnt; i++) {
+		ret = sfi_check_table(xsdt_va->table_offset_entry[i], &key);
+		if (IS_ERR(ret)) {
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
+	struct sfi_table_key xsdt_key = { .sig = SFI_SIG_XSDT };
+
+	sfi_table_parse(SFI_SIG_XSDT, NULL, NULL, sfi_acpi_parse_xsdt);
+
+	/* Only call the get_table to keep the table mapped */
+	xsdt_va = (struct acpi_table_xsdt *)sfi_get_table(&xsdt_key);
+	return 0;
+}
+
+static struct acpi_table_header *sfi_acpi_get_table(struct sfi_table_key *key)
+{
+	u32 tbl_cnt, i;
+	void *ret;
+
+	tbl_cnt = XSDT_GET_NUM_ENTRIES(xsdt_va, u64);
+	for (i = 0; i < tbl_cnt; i++) {
+		ret = sfi_check_table(xsdt_va->table_offset_entry[i], key);
+		if (!IS_ERR(ret) && ret)
+			return sfi_to_acpi_th(ret);
+	}
+
+	return NULL;
+}
+
+static void sfi_acpi_put_table(struct acpi_table_header *table)
+{
+	sfi_put_table(acpi_to_sfi_th(table));
+}
+
+/*
+ * sfi_acpi_table_parse()
+ *
+ * Find specified table in XSDT, run handler on it and return its return value
+ */
+int sfi_acpi_table_parse(char *signature, char *oem_id, char *oem_table_id,
+			int(*handler)(struct acpi_table_header *))
+{
+	struct acpi_table_header *table = NULL;
+	struct sfi_table_key key;
+	int ret = 0;
+
+	if (sfi_disabled)
+		return -1;
+
+	key.sig = signature;
+	key.oem_id = oem_id;
+	key.oem_table_id = oem_table_id;
+
+	table = sfi_acpi_get_table(&key);
+	if (!table)
+		return -EINVAL;
+
+	ret = handler(table);
+	sfi_acpi_put_table(table);
+	return ret;
+}
diff --git a/include/linux/sfi_acpi.h b/include/linux/sfi_acpi.h
new file mode 100644
index 0000000..c4a5a8c
--- /dev/null
+++ b/include/linux/sfi_acpi.h
@@ -0,0 +1,93 @@
+/* sfi.h Simple Firmware Interface */
+
+/*
+
+  This file is provided under a dual BSD/GPLv2 license.  When using or
+  redistributing this file, you may do so under either license.
+
+  GPL LICENSE SUMMARY
+
+  Copyright(c) 2009 Intel Corporation. All rights reserved.
+
+  This program is free software; you can redistribute it and/or modify
+  it under the terms of version 2 of the GNU General Public License as
+  published by the Free Software Foundation.
+
+  This program is distributed in the hope that it will be useful, but
+  WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+  General Public License for more details.
+
+  You should have received a copy of the GNU General Public License
+  along with this program; if not, write to the Free Software
+  Foundation, Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+  The full GNU General Public License is included in this distribution
+  in the file called LICENSE.GPL.
+
+  BSD LICENSE
+
+  Copyright(c) 2009 Intel Corporation. All rights reserved.
+
+  Redistribution and use in source and binary forms, with or without
+  modification, are permitted provided that the following conditions
+  are met:
+
+    * Redistributions of source code must retain the above copyright
+      notice, this list of conditions and the following disclaimer.
+    * Redistributions in binary form must reproduce the above copyright
+      notice, this list of conditions and the following disclaimer in
+      the documentation and/or other materials provided with the
+      distribution.
+    * Neither the name of Intel Corporation nor the names of its
+      contributors may be used to endorse or promote products derived
+      from this software without specific prior written permission.
+
+  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+
+*/
+
+#ifndef _LINUX_SFI_ACPI_H
+#define _LINUX_SFI_ACPI_H
+
+#ifdef CONFIG_SFI
+#include <acpi/acpi.h>		/* struct acpi_table_header */
+
+extern int sfi_acpi_table_parse(char *signature, char *oem_id,
+				char *oem_table_id,
+				int (*handler)(struct acpi_table_header *));
+
+static inline int acpi_sfi_table_parse(char *signature,
+				int (*handler)(struct acpi_table_header *))
+{
+	if (!acpi_table_parse(signature, handler))
+		return 0;
+
+	return sfi_acpi_table_parse(signature, NULL, NULL, handler);
+}
+#else /* !CONFIG_SFI */
+
+static inline int sfi_acpi_table_parse(char *signature, char *oem_id,
+				char *oem_table_id,
+				int (*handler)(struct acpi_table_header *))
+{
+	return -1;
+}
+
+static inline int acpi_sfi_table_parse(char *signature,
+				int (*handler)(struct acpi_table_header *))
+{
+	return acpi_table_parse(signature, handler);
+}
+#endif /* !CONFIG_SFI */
+
+#endif /*_LINUX_SFI_ACPI_H*/
-- 
1.6.0.6

