Return-Path: <linux-kernel-owner+w=401wt.eu-S1752566AbZGHEO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566AbZGHEO7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 00:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751108AbZGHEO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 00:14:29 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:31772 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbZGHEOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 00:14:05 -0400
From: Len Brown <lenb@kernel.org>
To: x86@kernel.org, sfi-devel@simplefirmware.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Cc: Feng Tang <feng.tang@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 05/12] SFI: add core support
Date: Wed, 08 Jul 2009 00:13:51 -0400
Message-id: <10fb28adc204382cb3b1acc99eabbb369d378a0f.1247025117.git.len.brown@intel.com>
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

drivers/sfi/sfi_core.c contains the generic SFI implementation.
It has a private header, sfi_core.h, for its own use and the
private use of future files in drivers/sfi/

Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/Makefile       |    1 +
 drivers/sfi/Makefile   |    1 +
 drivers/sfi/sfi_core.c |  385 ++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/sfi/sfi_core.h |   44 ++++++
 4 files changed, 431 insertions(+), 0 deletions(-)
 create mode 100644 drivers/sfi/Makefile
 create mode 100644 drivers/sfi/sfi_core.c
 create mode 100644 drivers/sfi/sfi_core.h

diff --git a/drivers/Makefile b/drivers/Makefile
index bc4205d..ccfa259 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -11,6 +11,7 @@ obj-$(CONFIG_PARISC)		+= parisc/
 obj-$(CONFIG_RAPIDIO)		+= rapidio/
 obj-y				+= video/
 obj-$(CONFIG_ACPI)		+= acpi/
+obj-$(CONFIG_SFI)		+= sfi/
 # PnP must come after ACPI since it will eventually need to check if acpi
 # was used and do nothing if so
 obj-$(CONFIG_PNP)		+= pnp/
diff --git a/drivers/sfi/Makefile b/drivers/sfi/Makefile
new file mode 100644
index 0000000..f176470
--- /dev/null
+++ b/drivers/sfi/Makefile
@@ -0,0 +1 @@
+obj-y	+= sfi_core.o
diff --git a/drivers/sfi/sfi_core.c b/drivers/sfi/sfi_core.c
new file mode 100644
index 0000000..f9a9849
--- /dev/null
+++ b/drivers/sfi/sfi_core.c
@@ -0,0 +1,385 @@
+/* sfi_core.c Simple Firmware Interface - core internals */
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
+#include <linux/bootmem.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/string.h>
+#include <linux/errno.h>
+#include <linux/types.h>
+#include <linux/acpi.h>
+#include <linux/init.h>
+#include <linux/irq.h>
+#include <linux/smp.h>
+#include <linux/sfi.h>
+
+#include <asm/pgtable.h>
+
+#include "sfi_core.h"
+
+#define ON_SAME_PAGE(addr1, addr2) \
+	(((unsigned long)(addr1) & PAGE_MASK) == \
+	((unsigned long)(addr2) & PAGE_MASK))
+#define TABLE_ON_PAGE(page, table, size) (ON_SAME_PAGE(page, table) && \
+				ON_SAME_PAGE(page, table + size))
+
+int sfi_disabled __read_mostly;
+EXPORT_SYMBOL(sfi_disabled);
+
+static u64 syst_pa __read_mostly;
+static struct sfi_table_simple *syst_va __read_mostly;
+
+/*
+ * FW creates and saves the SFI tables in memory. When these tables get
+ * used, they may need to be mapped to virtual address space, and the mapping
+ * can happen before or after the ioremap() is ready, so a flag is needed
+ * to indicating this
+ */
+static u32 sfi_use_ioremap __read_mostly;
+
+static void __iomem *sfi_map_memory(u64 phys, u32 size)
+{
+	if (!phys || !size)
+		return NULL;
+
+	if (sfi_use_ioremap)
+		return ioremap(phys, size);
+	else
+		return early_ioremap(phys, size);
+}
+
+static void sfi_unmap_memory(void __iomem *virt, u32 size)
+{
+	if (!virt || !size)
+		return;
+
+	if (sfi_use_ioremap)
+		iounmap(virt);
+	else
+		early_iounmap(virt, size);
+}
+
+static void sfi_print_table_header(unsigned long long pa,
+				struct sfi_table_header *header)
+{
+	pr_info("%4.4s %llX, %04X (v%d %6.6s %8.8s)\n",
+		header->signature, pa,
+		header->length, header->revision, header->oem_id,
+		header->oem_table_id);
+}
+
+/*
+ * sfi_verify_table()
+ * sanity check table lengh, calculate checksum
+ */
+static __init int sfi_verify_table(struct sfi_table_header *table)
+{
+
+	u8 checksum = 0;
+	u8 *puchar = (u8 *)table;
+	u32 length = table->length;
+
+	/* Sanity check table length against arbitrary 1MB limit */
+	if (length > 0x100000) {
+		pr_err("Invalid table length 0x%x\n", length);
+		return -1;
+	}
+
+	while (length--)
+		checksum += *puchar++;
+
+	if (checksum) {
+		pr_err("Checksum %2.2X should be %2.2X\n",
+			table->checksum, table->checksum - checksum);
+		return -1;
+	}
+	return 0;
+}
+
+/*
+ * sfi_map_table()
+ *
+ * Return address of mapped table
+ * Check for common case that we can re-use mapping to SYST,
+ * which requires syst_pa, syst_va to be initialized.
+ */
+struct sfi_table_header *sfi_map_table(u64 pa)
+{
+	struct sfi_table_header *th;
+	u32 length;
+
+	if (!TABLE_ON_PAGE(syst_pa, pa, sizeof(struct sfi_table_header)))
+		th = sfi_map_memory(pa, sizeof(struct sfi_table_header));
+	else
+		th = (void *)syst_va - (syst_pa - pa);
+
+	 /* If table fits on same page as its header, we are done */
+	if (TABLE_ON_PAGE(th, th, th->length))
+		return th;
+
+	/* entire table does not fit on same page as SYST */
+	length = th->length;
+	if (!TABLE_ON_PAGE(syst_pa, pa, sizeof(struct sfi_table_header)))
+		sfi_unmap_memory(th, sizeof(struct sfi_table_header));
+
+	return sfi_map_memory(pa, length);
+}
+
+/*
+ * sfi_unmap_table()
+ *
+ * undoes effect of sfi_map_table() by unmapping table
+ * if it did not completely fit on same page as SYST.
+ */
+void sfi_unmap_table(struct sfi_table_header *th)
+{
+	if (!TABLE_ON_PAGE(syst_va, th, th->length))
+		sfi_unmap_memory(th, TABLE_ON_PAGE(th, th, th->length) ?
+					sizeof(*th) : th->length);
+}
+
+/*
+ * sfi_get_table()
+ *
+ * Search SYST for the specified table.
+ * return the mapped table
+ */
+static struct sfi_table_header *sfi_get_table(char *signature, char *oem_id,
+		char *oem_table_id, unsigned int flags)
+{
+	struct sfi_table_header *th;
+	u32 tbl_cnt, i;
+
+	tbl_cnt = SFI_GET_NUM_ENTRIES(syst_va, u64);
+
+	for (i = 0; i < tbl_cnt; i++) {
+		th = sfi_map_table(syst_va->pentry[i]);
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
+		return th;	/* success */
+loop_continue:
+		sfi_unmap_table(th);
+	}
+
+	return NULL;
+}
+
+void sfi_put_table(struct sfi_table_header *table)
+{
+	if (!ON_SAME_PAGE(((void *)table + table->length),
+		(void *)syst_va + syst_va->header.length)
+		&& !ON_SAME_PAGE(table, syst_va))
+		sfi_unmap_memory(table, table->length);
+}
+
+/* find table with signature, run handler on it */
+int sfi_table_parse(char *signature, char *oem_id, char *oem_table_id,
+			unsigned int flags, sfi_table_handler handler)
+{
+	int ret = 0;
+	struct sfi_table_header *table = NULL;
+
+	if (sfi_disabled || !handler || !signature)
+		return -EINVAL;
+
+	table = sfi_get_table(signature, oem_id, oem_table_id, flags);
+	if (!table)
+		return -EINVAL;
+
+	ret = handler(table);
+	sfi_put_table(table);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(sfi_table_parse);
+
+/*
+ * sfi_check_table(pa)
+ */
+int __init sfi_check_table(u64 pa)
+{
+	struct sfi_table_header *th;
+	int ret;
+
+	th = sfi_map_table(pa);
+	if (!th)
+		return -1;
+
+	sfi_print_table_header(pa, th);
+	ret = sfi_verify_table(th);
+
+	sfi_unmap_table(th);
+
+	return ret;
+}
+
+/*
+ * sfi_parse_syst()
+ * checksum all the tables in SYST and print their headers
+ *
+ * success: set syst_va, return 0
+ */
+static int __init sfi_parse_syst(void)
+{
+	int tbl_cnt, i;
+
+	syst_va = sfi_map_memory(syst_pa, sizeof(struct sfi_table_simple));
+	if (!syst_va)
+		return -1;
+
+	tbl_cnt = SFI_GET_NUM_ENTRIES(syst_va, u64);
+	for (i = 0; i < tbl_cnt; i++) {
+		if (sfi_check_table(syst_va->pentry[i]))
+			return -1;
+	}
+
+	return 0;
+}
+
+/*
+ * The OS finds the System Table by searching 16-byte boundaries between
+ * physical address 0x000E0000 and 0x000FFFFF. The OS shall search this region
+ * starting at the low address and shall stop searching when the 1st valid SFI
+ * System Table is found.
+ *
+ * success: set syst_pa, return 0
+ * fail: return -1
+ */
+static __init int sfi_find_syst(void)
+{
+	unsigned long offset, len;
+	void *start;
+
+	len = SFI_SYST_SEARCH_END - SFI_SYST_SEARCH_BEGIN;
+	start = sfi_map_memory(SFI_SYST_SEARCH_BEGIN, len);
+	if (!start)
+		return -1;
+
+	for (offset = 0; offset < len; offset += 16) {
+		struct sfi_table_header *syst_hdr;
+
+		syst_hdr = start + offset;
+		if (strncmp(syst_hdr->signature, SFI_SIG_SYST,
+				SFI_SIGNATURE_SIZE))
+			continue;
+
+		if (syst_hdr->length > PAGE_SIZE)
+			continue;
+
+		sfi_print_table_header(SFI_SYST_SEARCH_BEGIN + offset,
+					syst_hdr);
+
+		if (sfi_verify_table(syst_hdr))
+			continue;
+
+		/*
+		 * Enforce SFI spec mandate that SYST reside within a page.
+		 */
+		if (!ON_SAME_PAGE(syst_pa, syst_pa + syst_hdr->length)) {
+			pr_debug("SYST 0x%llx + 0x%x crosses page\n",
+					syst_pa, syst_hdr->length);
+			continue;
+		}
+
+		/* success */
+		syst_pa = SFI_SYST_SEARCH_BEGIN + offset;
+		sfi_unmap_memory(start, len);
+		return 0;
+	}
+
+	sfi_unmap_memory(start, len);
+	return -1;
+}
+
+void __init sfi_init(void)
+{
+	if (!acpi_disabled)
+		disable_sfi();
+
+	if (sfi_disabled)
+		return;
+
+	pr_info("Simple Firmware Interface v0.7 http://simplefirmware.org\n");
+
+	if (sfi_find_syst() || sfi_parse_syst())
+		disable_sfi();
+
+	return;
+}
+
+void __init sfi_init_late(void)
+{
+	int length;
+
+	if (sfi_disabled)
+		return;
+
+	length = syst_va->header.length;
+	sfi_unmap_memory(syst_va, sizeof(struct sfi_table_simple));
+
+	/* use ioremap now after it is ready */
+	sfi_use_ioremap = 1;
+	syst_va = sfi_map_memory(syst_pa, length);
+}
+
+static int __init sfi_parse_cmdline(char *arg)
+{
+	if (!arg)
+		return -EINVAL;
+
+	if (!strcmp(arg, "off"))
+		sfi_disabled = 1;
+
+	return 0;
+}
+
+early_param("sfi", sfi_parse_cmdline);
diff --git a/drivers/sfi/sfi_core.h b/drivers/sfi/sfi_core.h
new file mode 100644
index 0000000..cb599bf
--- /dev/null
+++ b/drivers/sfi/sfi_core.h
@@ -0,0 +1,44 @@
+/* sfi_core.h Simple Firmware Interface, internal header */
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
+extern int __init sfi_acpi_init(void);
+extern int sfi_check_table(u64 paddr);
+extern void sfi_put_table(struct sfi_table_header *table);
+extern struct sfi_table_header *sfi_map_table(u64 pa);
+extern void sfi_unmap_table(struct sfi_table_header *th);
-- 
1.6.0.6

