Return-Path: <linux-kernel-owner+w=401wt.eu-S1754482AbZFZAPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482AbZFZAPp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 20:15:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756021AbZFZAOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 20:14:54 -0400
Received: from mga01.intel.com ([192.55.52.88]:46155 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755041AbZFZAOx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 20:14:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,293,1243839600"; 
   d="scan'208,223";a="469709533"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "H. Peter Anvin" <hpa@linux.intel.com>,
       "Pan, Jacob jun" <jacob.jun.pan@intel.com>
Date: Thu, 25 Jun 2009 17:14:54 -0700
Subject: [PATCH 6/9] x86: add moorestown specific setup code
Thread-Topic: [PATCH 6/9] x86: add moorestown specific setup code
Thread-Index: Acn18yGQvaXqAxNhScmP7ZWShpWn+A==
Message-ID: <43F901BD926A4E43B106BF17856F07556412B7E5@orsmsx508.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From f648870658331b0337a881a405857dfc0baee6b8 Mon Sep 17 00:00:00 2001
From: Jacob Pan <jacob.jun.pan@intel.com>
Date: Thu, 11 Jun 2009 21:01:00 -0700
Subject: [PATCH] x86: add moorestown specific setup code

Intel moorestown platform does not contain many devices found on a PC.
This patch adds x86_quirks and assigns platform feature sets for
Moorestown.

Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
---
 arch/x86/include/asm/setup.h |    8 +++
 arch/x86/kernel/Makefile     |    1 +
 arch/x86/kernel/mrst.c       |  105 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/setup.c      |    4 +-
 4 files changed, 117 insertions(+), 1 deletions(-)
 create mode 100644 arch/x86/kernel/mrst.c

diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index 7bf325a..8253b71 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -83,6 +83,14 @@ static inline int is_visws_box(void) { return 0; }
 extern struct x86_quirks *x86_quirks;
 extern unsigned long saved_video_mode;
 
+#ifdef CONFIG_MRST
+extern void mrst_early_detect(int);
+extern void setup_mrst_default_feature(void);
+#else
+static inline void mrst_early_detect(int subarch) { };
+static inline void setup_mrst_default_feature(void) { };
+#endif
+
 #ifndef CONFIG_PARAVIRT
 #define paravirt_post_allocator_init()	do {} while (0)
 #endif
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 8d1ae61..370aba5 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -103,6 +103,7 @@ obj-$(CONFIG_SCx200)		+= scx200.o
 scx200-y			+= scx200_32.o
 
 obj-$(CONFIG_OLPC)		+= olpc.o
+obj-$(CONFIG_MRST)		+= mrst.o
 
 microcode-y				:= microcode_core.o
 microcode-$(CONFIG_MICROCODE_INTEL)	+= microcode_intel.o
diff --git a/arch/x86/kernel/mrst.c b/arch/x86/kernel/mrst.c
new file mode 100644
index 0000000..56ed345
--- /dev/null
+++ b/arch/x86/kernel/mrst.c
@@ -0,0 +1,105 @@
+/*
+ * mrst.c: Intel Moorestown platform specific setup code
+ *
+ * (C) Copyright 2008 Intel Corporation
+ * Author: Jacob Pan (jacob.jun.pan@intel.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ *
+ * Note:
+ *
+ */
+#include <linux/spi/spi.h>
+#include <linux/sfi.h>
+
+#include <asm/platform_feature.h>
+#include <asm/apb_timer.h>
+#include <asm/setup.h>
+#include <asm/apic.h>
+
+static int __init mrst_pre_intr_init(void)
+{
+#ifdef CONFIG_X86_IO_APIC
+	if (platform_has(X86_PLATFORM_FEATURE_APBT)) {
+		pre_init_apic_IRQ();
+		return 1;
+	}
+#endif
+	return 0;
+}
+
+static struct x86_quirks mrst_x86_quirks = {
+	.arch_pre_intr_init		= mrst_pre_intr_init,
+	.setup_secondary_clock		= apbt_setup_secondary_clock,
+};
+
+inline void setup_mrst_default_feature(void)
+{
+	clear_all_platform_feature();
+	platform_feature_set_flag(X86_PLATFORM_FEATURE_SFI);
+	platform_feature_set_flag(X86_PLATFORM_FEATURE_IOAPIC);
+	platform_feature_set_flag(X86_PLATFORM_FEATURE_APBT);
+	platform_feature_set_flag(X86_PLATFORM_FEATURE_VRTC);
+}
+
+inline void mrst_early_detect(int subarch)
+{
+	if (subarch == X86_SUBARCH_MRST) {
+		x86_quirks = &mrst_x86_quirks;
+	}
+}
+
+static int __init sfi_parse_spib(struct sfi_table_header *table)
+{
+	struct sfi_table *sb;
+	struct sfi_spi_table_entry *pentry;
+	struct spi_board_info *info;
+	int num, i, j;
+
+	sb = (struct sfi_table *)table;
+	num = SFI_GET_ENTRY_NUM(sb, sfi_spi_table_entry);
+	pentry = (struct sfi_spi_table_entry *) sb->pentry;
+
+	info = kzalloc(num * sizeof(*info), GFP_KERNEL);
+	if (!info) {
+		pr_info("%s(): Error in kzalloc\n", __func__);
+		return -ENOMEM;
+	}
+
+	for (i = 0, j = 0; i < num; i++) {
+		if (pentry->host_num != 0)
+			continue;
+		strncpy(info[j].modalias, pentry->name, 16);
+		info[j].irq = pentry->irq_info;
+		info[j].bus_num = pentry->host_num;
+		info[j].chip_select = pentry->cs;
+		info[j].max_speed_hz = 3125000;	/* hard coded */
+
+		printk(KERN_INFO "info[%d]: name = %16s, irq = 0x%x, bus = %d,"
+			" cs = %d\n", j, info[j].modalias, info[j].irq,
+			info[j].bus_num, info[j].chip_select);
+		j++;
+		pentry++;
+	}
+	spi_register_board_info(info, j);
+	kfree(info);
+	return 0;
+
+}
+
+static int __init sfi_parse_i2cb(struct sfi_table_header *table)
+{
+	return 0;
+}
+
+static int __init mrst_platform_init(void)
+{
+	sfi_table_parse(SFI_SIG_SPIB, sfi_parse_spib);
+	sfi_table_parse(SFI_SIG_I2CB, sfi_parse_i2cb);
+	return 0;
+}
+
+postcore_initcall(mrst_platform_init);
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 1a5ef7b..9a7f2a5 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -626,7 +626,7 @@ early_param("elfcorehdr", setup_elfcorehdr);
 
 static struct x86_quirks default_x86_quirks __initdata;
 
-struct x86_quirks *x86_quirks __initdata = &default_x86_quirks;
+struct x86_quirks *x86_quirks = &default_x86_quirks;
 
 #ifdef CONFIG_X86_RESERVE_LOW_64K
 static int __init dmi_low_memory_corruption(const struct dmi_system_id *d)
@@ -681,6 +681,7 @@ void __init setup_arch(char **cmdline_p)
 #ifdef CONFIG_X86_32
 	memcpy(&boot_cpu_data, &new_cpu_data, sizeof(new_cpu_data));
 	visws_early_detect();
+	mrst_early_detect(boot_params.hdr.hardware_subarch);
 #else
 	printk(KERN_INFO "Command line: %s\n", boot_command_line);
 #endif
@@ -732,6 +733,7 @@ void __init setup_arch(char **cmdline_p)
 #endif
 
 	ARCH_SETUP
+
 	platform_feature_init_default(boot_params.hdr.hardware_subarch);
 	setup_memory_map();
 	parse_setup_data();
-- 
1.5.6.5

