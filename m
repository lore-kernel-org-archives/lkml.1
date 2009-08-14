Return-Path: <linux-kernel-owner+w=401wt.eu-S1756172AbZHNVds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172AbZHNVds (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 17:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755885AbZHNVds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 17:33:48 -0400
Received: from vms173007pub.verizon.net ([206.46.173.7]:22610 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755256AbZHNVdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 17:33:46 -0400
From: Len Brown <lenb@kernel.org>
To: x86@kernel.org, sfi-devel@simplefirmware.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Cc: Feng Tang <feng.tang@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 10/11] x86: add arch-specific SFI support
Date: Fri, 14 Aug 2009 16:38:14 -0400
Message-id: <3c8fbc2e3a5e5930d1e88baf82b36b095f712445.1250281826.git.len.brown@intel.com>
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

arch/x86/kernel/sfi.c serves the dual-purpose of supporting the
SFI core with arch specific code, as well as a home for the
arch-specific code that uses SFI.

analogous to ACPI, drivers/sfi/Kconfig is pulled in by arch/x86/Kconfig

Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Cc: x86@kernel.org
---
 arch/x86/Kconfig         |    2 +
 arch/x86/kernel/Makefile |    1 +
 arch/x86/kernel/setup.c  |    3 +
 arch/x86/kernel/sfi.c    |  133 ++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 139 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/kernel/sfi.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 13ffa5d..d8ba424 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1683,6 +1683,8 @@ source "kernel/power/Kconfig"
 
 source "drivers/acpi/Kconfig"
 
+source "drivers/sfi/Kconfig"
+
 config X86_APM_BOOT
 	bool
 	default y
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 430d5b2..6321afa 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -55,6 +55,7 @@ obj-y				+= step.o
 obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
 obj-y				+= cpu/
 obj-y				+= acpi/
+obj-$(CONFIG_SFI)		+= sfi.o
 obj-y				+= reboot.o
 obj-$(CONFIG_MCA)		+= mca_32.o
 obj-$(CONFIG_X86_MSR)		+= msr.o
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 63f32d2..d784ea2 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -27,6 +27,7 @@
 #include <linux/screen_info.h>
 #include <linux/ioport.h>
 #include <linux/acpi.h>
+#include <linux/sfi.h>
 #include <linux/apm_bios.h>
 #include <linux/initrd.h>
 #include <linux/bootmem.h>
@@ -990,6 +991,8 @@ void __init setup_arch(char **cmdline_p)
 	 */
 	acpi_boot_init();
 
+	sfi_init();
+
 #if defined(CONFIG_X86_MPPARSE) || defined(CONFIG_X86_VISWS)
 	/*
 	 * get boot-time SMP configuration:
diff --git a/arch/x86/kernel/sfi.c b/arch/x86/kernel/sfi.c
new file mode 100644
index 0000000..761df3f
--- /dev/null
+++ b/arch/x86/kernel/sfi.c
@@ -0,0 +1,133 @@
+/*
+ * sfi.c - x86 architecture SFI support.
+ *
+ * Copyright (c) 2009, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ */
+
+#define KMSG_COMPONENT "SFI"
+#define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
+
+#include <linux/bootmem.h>
+#include <linux/cpumask.h>
+#include <linux/module.h>
+#include <linux/acpi.h>
+#include <linux/init.h>
+#include <linux/efi.h>
+#include <linux/irq.h>
+#include <linux/sfi.h>
+#include <linux/io.h>
+
+#include <asm/io_apic.h>
+#include <asm/pgtable.h>
+#include <asm/mpspec.h>
+#include <asm/setup.h>
+#include <asm/apic.h>
+#include <asm/e820.h>
+
+#ifdef CONFIG_X86_LOCAL_APIC
+static unsigned long sfi_lapic_addr __initdata = APIC_DEFAULT_PHYS_BASE;
+
+void __init mp_sfi_register_lapic_address(unsigned long address)
+{
+	mp_lapic_addr = address;
+
+	set_fixmap_nocache(FIX_APIC_BASE, mp_lapic_addr);
+	if (boot_cpu_physical_apicid == -1U)
+		boot_cpu_physical_apicid = read_apic_id();
+
+	pr_info("Boot CPU = %d\n", boot_cpu_physical_apicid);
+}
+
+/* All CPUs enumerated by SFI must be present and enabled */
+void __cpuinit mp_sfi_register_lapic(u8 id)
+{
+	int boot_cpu = 0;
+
+	if (MAX_APICS - id <= 0) {
+		pr_warning("Processor #%d invalid (max %d)\n",
+			id, MAX_APICS);
+		return;
+	}
+
+	if (id == boot_cpu_physical_apicid)
+		boot_cpu = 1;
+	pr_info("registering lapic[%d]\n", id);
+
+	generic_processor_info(id, GET_APIC_VERSION(apic_read(APIC_LVR)));
+}
+
+static int __init sfi_parse_cpus(struct sfi_table_header *table)
+{
+	struct sfi_table_simple *sb;
+	struct sfi_cpu_table_entry *pentry;
+	int i;
+	int cpu_num;
+
+	sb = (struct sfi_table_simple *)table;
+	cpu_num = SFI_GET_NUM_ENTRIES(sb, struct sfi_cpu_table_entry);
+	pentry = (struct sfi_cpu_table_entry *)sb->pentry;
+
+	for (i = 0; i < cpu_num; i++) {
+		mp_sfi_register_lapic(pentry->apic_id);
+		pentry++;
+	}
+
+	smp_found_config = 1;
+	return 0;
+}
+#endif /* CONFIG_X86_LOCAL_APIC */
+
+#ifdef CONFIG_X86_IO_APIC
+static u32 gsi_base;
+
+static int __init sfi_parse_ioapic(struct sfi_table_header *table)
+{
+	struct sfi_table_simple *sb;
+	struct sfi_apic_table_entry *pentry;
+	int i, num;
+
+	sb = (struct sfi_table_simple *)table;
+	num = SFI_GET_NUM_ENTRIES(sb, struct sfi_apic_table_entry);
+	pentry = (struct sfi_apic_table_entry *)sb->pentry;
+
+	for (i = 0; i < num; i++) {
+		mp_register_ioapic(i, pentry->phys_addr, gsi_base);
+		gsi_base += io_apic_get_redir_entries(i);
+		pentry++;
+	}
+
+	WARN(pic_mode, KERN_WARNING
+		"SFI: pic_mod shouldn't be 1 when IOAPIC table is present\n");
+	pic_mode = 0;
+	return 0;
+}
+#endif /* CONFIG_X86_IO_APIC */
+
+/*
+ * sfi_platform_init(): register lapics & io-apics
+ */
+int __init sfi_platform_init(void)
+{
+#ifdef CONFIG_X86_LOCAL_APIC
+	mp_sfi_register_lapic_address(sfi_lapic_addr);
+	sfi_table_parse(SFI_SIG_CPUS, NULL, NULL, sfi_parse_cpus);
+#endif
+#ifdef CONFIG_X86_IO_APIC
+	sfi_table_parse(SFI_SIG_APIC, NULL, NULL, sfi_parse_ioapic);
+#endif
+	return 0;
+}
-- 
1.6.0.6

