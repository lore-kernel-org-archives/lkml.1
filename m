Return-Path: <linux-kernel-owner+w=401wt.eu-S1761748AbXLNIVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761748AbXLNIVT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 03:21:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753978AbXLNIVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 03:21:08 -0500
Received: from mga03.intel.com ([143.182.124.21]:30722 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753622AbXLNIVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 03:21:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,165,1196668800"; 
   d="scan'208";a="340944724"
Subject: [PATCH -mm -v3] x86 boot : export boot_params via sysfs
From: "Huang, Ying" <ying.huang@intel.com>
To: Greg KH <greg@kroah.com>, akpm@linux-foundation.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, Andi Kleen <ak@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 14 Dec 2007 16:16:46 +0800
Message-Id: <1197620206.12999.12.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 14 Dec 2007 08:16:59.0985 (UTC) FILETIME=[B31FDC10:01C83E29]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch export the boot parameters via sysfs. This can be used for
debugging and kexec.

The files added are as follow:

/sys/kernel/boot_params/data	: binary file for struct boot_params
/sys/kernel/boot_params/version	: boot protocol version

This patch is based on 2.6.24-rc5-mm1 and has been tested on i386 and
x86_64 platoform.

This patch is based on the Peter Anvin's proposal.


v3:

- Use updated API: kobject_create_and_add.

v2:

- Add document in Document/ABI.


Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 Documentation/ABI/testing/sysfs-kernel-boot_params |   14 +++
 arch/x86/kernel/Makefile_32                        |    1 
 arch/x86/kernel/Makefile_64                        |    1 
 arch/x86/kernel/ksysfs.c                           |   88 +++++++++++++++++++++
 arch/x86/kernel/setup64.c                          |    2 
 arch/x86/kernel/setup_32.c                         |    2 
 6 files changed, 106 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/Makefile_64
+++ b/arch/x86/kernel/Makefile_64
@@ -40,6 +40,7 @@ obj-$(CONFIG_X86_VSMP)		+= vsmp_64.o
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
@@ -0,0 +1,88 @@
+/*
+ * Architecture specific sysfs attributes in /sys/kernel
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
+static struct kobj_attribute boot_params_version_attr =
+	__ATTR(version, S_IRUGO, boot_params_version_show, NULL);
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
+	boot_params_kobj = kobject_create_and_add("boot_params", kernel_kobj);
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
@@ -45,6 +45,7 @@ obj-$(CONFIG_EARLY_PRINTK)	+= early_prin
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
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-kernel-boot_params
@@ -0,0 +1,14 @@
+What:		/sys/kernel/boot_params
+Date:		December 2007
+Contact:	Huang Ying <ying.huang@intel.com>
+Description:
+		The /sys/kernel/boot_params directory contains two
+		files: "data" and "version". It is used to export the
+		kernel boot parameters of x86 platform to user space
+		for debugging and kexec. The "data" file is the binary
+		representation of struct boot_params. The "version"
+		file is the string representation of boot protocol
+		version.
+
+Users:
+		Kexec Mailing List <kexec@lists.infradead.org>

