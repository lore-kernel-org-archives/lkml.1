Return-Path: <linux-kernel-owner+w=401wt.eu-S1758927AbZFWHQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758927AbZFWHQT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 03:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758552AbZFWHP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 03:15:28 -0400
Received: from vms173013pub.verizon.net ([206.46.173.13]:43819 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758554AbZFWHP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 03:15:26 -0400
X-Greylist: delayed 2469 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Jun 2009 03:15:26 EDT
From: Len Brown <lenb@kernel.org>
To: sfi-devel@simplefirmware.org, linux-kernel@vger.kernel.org
Cc: Feng Tang <feng.tang@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 2/8] SFI: include/linux/sfi.h
Date: Tue, 23 Jun 2009 03:14:00 -0400
Message-id: <b3fb5fa65a532941d61a8c8415495f752aac540d.1245740912.git.len.brown@intel.com>
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

linux/include/sfi.h defines everything that customers
of SFI need to know in order to use the SFI suport in  the kernel.

The primary API is sfi_table_parse(), where a driver or another part
of the kernel can supply a handler to parse the named table.

Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 include/linux/sfi.h |  161 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 161 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/sfi.h

diff --git a/include/linux/sfi.h b/include/linux/sfi.h
new file mode 100644
index 0000000..2164fc1
--- /dev/null
+++ b/include/linux/sfi.h
@@ -0,0 +1,161 @@
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
+#ifndef _LINUX_SFI_H
+#define _LINUX_SFI_H
+
+#ifdef	CONFIG_SFI
+
+#define SFI_SYST_SEARCH_BEGIN		0x000E0000
+#define SFI_SYST_SEARCH_END		0x000FFFFF
+
+/* Table signatures reserved by the SFI specification */
+#define SFI_SIG_SYST		"SYST"
+#define SFI_SIG_FREQ		"FREQ"
+#define SFI_SIG_IDLE		"IDLE"
+#define SFI_SIG_CPUS		"CPUS"
+#define SFI_SIG_MTMR		"MTMR"
+#define SFI_SIG_MRTC		"MRTC"
+#define SFI_SIG_MMAP		"MMAP"
+#define SFI_SIG_APIC		"APIC"
+#define SFI_SIG_XSDT		"XSDT"	/* ACPI Extended System Description Table */
+#define SFI_SIG_WAKE		"WAKE"
+
+#define SFI_SIGNATURE_SIZE	4
+#define SFI_OEM_ID_SIZE		6
+#define SFI_OEM_TABLE_ID_SIZE	8
+
+#define SFI_GET_ENTRY_NUM(ptable, entry) \
+	((ptable->header.length - sizeof(struct sfi_table_header)) / \
+	(sizeof(struct entry)))
+/*
+ * Table structures must be byte-packed to match the SFI specification,
+ * as they are provided by the BIOS.
+ */
+#pragma pack(1)
+struct sfi_table_header {
+	char signature[SFI_SIGNATURE_SIZE];
+	u32 length;
+	u8 revision;
+	u8 checksum;
+	char oem_id[SFI_OEM_ID_SIZE];
+	char oem_table_id[SFI_OEM_TABLE_ID_SIZE];
+};
+
+struct sfi_table_simple {
+	struct sfi_table_header header;
+	u64 pentry[1];
+};
+
+/* comply with UEFI spec 2.1 */
+struct sfi_mem_entry {
+	u32 type;
+	u64 phy_start;
+	u64 vir_start;
+	u64 pages;
+	u64 attrib;
+};
+
+struct sfi_cpu_table_entry {
+	u32 apicid;
+};
+
+struct sfi_cstate_table_entry {
+	u32 hint;	/* MWAIT hint */
+	u32 latency;	/* latency in ms */
+};
+
+struct sfi_apic_table_entry {
+	u64 phy_addr;	/* phy base addr for APIC reg */
+};
+
+struct sfi_freq_table_entry {
+	u32 freq;
+	u32 latency;	/* transition latency in ms */
+	u32 ctrl_val;	/* value to write to PERF_CTL to enter this state */
+};
+
+struct sfi_wake_table_entry {
+	u64 phy_addr;
+};
+
+struct sfi_timer_table_entry {
+	u64 phy_addr;	/* phy base addr for the timer */
+	u32 freq;	/* in HZ */
+	u32 irq;
+};
+
+struct sfi_rtc_table_entry {
+	u64 phy_addr;	/* phy base addr for the RTC */
+	u32 irq;
+};
+#pragma pack()
+
+extern int __init sfi_init_memory_map(void);
+extern int __init sfi_init(void);
+extern int __init sfi_platform_init(void);
+extern void __init sfi_init_late(void);
+
+typedef int (*sfi_table_handler) (struct sfi_table_header *table);
+
+int sfi_table_parse(char *signature, char *oem_id, char* oem_table_id,
+	uint flag, sfi_table_handler handler);
+
+void __init __iomem *
+arch_early_ioremap(unsigned long phys, unsigned long size);
+void __init arch_early_iounmap(void __iomem *virt, unsigned long size);
+
+
+extern int sfi_disabled;
+static inline void disable_sfi(void) { sfi_disabled = 1; }
+
+
+#else /* !CONFIG_SFI */
+
+static inline int sfi_init_memory_map(void) { return -1; }
+static inline int sfi_init(void) { return 0; }
+static inline void sfi_init_late(void)	{}
+#define sfi_disabled	0
+
+static inline int sfi_table_parse(char *signature, char *oem_id, char* oem_table_id,
+	unsigned int flags, sfi_table_handler handler) { return -1; }
+
+#endif	/* CONFIG_SFI */
+
+#endif	/*_LINUX_SFI_H*/
-- 
1.6.0.6

