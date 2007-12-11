Return-Path: <linux-kernel-owner+w=401wt.eu-S1753108AbXLKIuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108AbXLKIuT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 03:50:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751624AbXLKIuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 03:50:05 -0500
Received: from mga02.intel.com ([134.134.136.20]:18965 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014AbXLKIuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 03:50:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,150,1196668800"; 
   d="scan'208";a="240380112"
Subject: [PATCH -mm] x86 boot : export boot_params via sysfs
From: "Huang, Ying" <ying.huang@intel.com>
To: akpm@linux-foundation.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 11 Dec 2007 16:49:09 +0000
Message-Id: <1197391749.17188.8.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 11 Dec 2007 08:49:26.0973 (UTC) FILETIME=[BC6166D0:01C83BD2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch export the boot parameters via sysfs. This can be used for
debugging and kexec.

The files added are as follow:

/sys/kernel/boot_params/data	: binary file for struct boot_params
/sys/kernel/boot_params/version	: boot protocol version

This patch is based on 2.6.24-rc4-mm1 and has been tested on i386 and
x86_64 platoform.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/kernel/Makefile_32 |    1 
 arch/x86/kernel/Makefile_64 |    1 
 arch/x86/kernel/ksysfs.c    |   94 ++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/setup64.c   |    2 
 arch/x86/kernel/setup_32.c  |    2 
 5 files changed, 98 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/Makefile_64
+++ b/arch/x86/kernel/Makefile_64
@@ -39,6 +39,7 @@ obj-$(CONFIG_X86_VSMP)		+= vsmp_64.o
 obj-$(CONFIG_K8_NB)		+= k8.o
 obj-$(CONFIG_AUDIT)		+= audit_64.o
 obj-$(CONFIG_EFI)		+= efi.o efi_64.o efi_stub_64.o
+obj-$(CONFIG_SYSFS)		+= ksysfs.o
 
 obj-$(CONFIG_MODULES)		+= module_64.o
 obj-$(CONFIG_PCI)		+= early-quirks.o
--- a/arch/x86/kernel/setup64.c
+++ b/arch/x86/kernel/setup64.c
@@ -24,7 +24,7 @@
 #include <asm/sections.h>
 #include <asm/setup.h>
 
-struct boot_params __initdata boot_params;
+struct boot_params boot_params;
 
 cpumask_t cpu_initialized __cpuinitdata = CPU_MASK_NONE;
 
--- /dev/null
+++ b/arch/x86/kernel/ksysfs.c
@@ -0,0 +1,94 @@
+/*
+ * arch/i386/ksysfs.c - architecture specific sysfs attributes in /sys/kernel
+ *
+ * Copyright (C) 2007, Intel Corp.
+ *      Huang Ying <ying.huang@intel.com>
+ *
+ * This file is released under the GPLv2
+ */
+
+#include <linux/kobject.h>
+#include <linux/string.h>
+#include <linux/sysfs.h>
+#include <linux/init.h>
+#include <linux/stat.h>
+#include <linux/mm.h>
+
+#include <asm/setup.h>
+
+static ssize_t boot_params_version_show(struct kobject *kobj,
+					struct kobj_attribute *attr, char *buf)
+{
+	return sprintf(buf, "0x%04x\n", boot_params.hdr.version);
+}
+
+static struct kobj_attribute boot_params_version_attr = {
+	.attr = {
+		.name = "version",
+		.mode = S_IRUGO,
+	},
+	.show = boot_params_version_show,
+};
+
+static struct attribute *boot_params_attrs[] = {
+	&boot_params_version_attr.attr,
+	NULL
+};
+
+static struct attribute_group boot_params_attr_group = {
+	.attrs = boot_params_attrs,
+};
+
+static ssize_t boot_params_data_read(struct kobject *kobj,
+				     struct bin_attribute *bin_attr,
+				     char *buf, loff_t off, size_t count)
+{
+	memcpy(buf, (void *)&boot_params + off, count);
+	return count;
+}
+
+static struct bin_attribute boot_params_data_attr = {
+	.attr = {
+		.name = "data",
+		.mode = S_IRUGO,
+	},
+	.read = boot_params_data_read,
+	.size = sizeof(boot_params),
+};
+
+static int __init boot_params_ksysfs_init(void)
+{
+	int error;
+	struct kobject *boot_params_kobj;
+
+	boot_params_kobj = kobject_create_and_register("boot_params",
+						       kernel_kobj);
+	if (!boot_params_kobj) {
+		error = -ENOMEM;
+		goto err_return;
+	}
+	error = sysfs_create_group(boot_params_kobj,
+				   &boot_params_attr_group);
+	if (error)
+		goto err_boot_params_subsys_unregister;
+	error = sysfs_create_bin_file(boot_params_kobj,
+				      &boot_params_data_attr);
+	if (error)
+		goto err_boot_params_subsys_unregister;
+	return 0;
+err_boot_params_subsys_unregister:
+	kobject_unregister(boot_params_kobj);
+err_return:
+	return error;
+}
+
+static int __init arch_ksysfs_init(void)
+{
+	int error;
+
+	error = boot_params_ksysfs_init();
+
+	return error;
+}
+
+arch_initcall(arch_ksysfs_init);
--- a/arch/x86/kernel/Makefile_32
+++ b/arch/x86/kernel/Makefile_32
@@ -44,6 +44,7 @@ obj-$(CONFIG_EARLY_PRINTK)	+= early_prin
 obj-$(CONFIG_HPET_TIMER) 	+= hpet.o
 obj-$(CONFIG_K8_NB)		+= k8.o
 obj-$(CONFIG_MGEODE_LX)		+= geode_32.o mfgpt_32.o
+obj-$(CONFIG_SYSFS)		+= ksysfs.o
 
 obj-$(CONFIG_VMI)		+= vmi_32.o vmiclock_32.o
 obj-$(CONFIG_PARAVIRT)		+= paravirt_32.o
--- a/arch/x86/kernel/setup_32.c
+++ b/arch/x86/kernel/setup_32.c
@@ -194,7 +194,7 @@ unsigned long saved_videomode;
 
 static char __initdata command_line[COMMAND_LINE_SIZE];
 
-struct boot_params __initdata boot_params;
+struct boot_params boot_params;
 
 #if defined(CONFIG_EDD) || defined(CONFIG_EDD_MODULE)
 struct edd edd;
