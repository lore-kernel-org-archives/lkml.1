Return-Path: <linux-kernel-owner+w=401wt.eu-S1754178AbXJWIEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178AbXJWIEr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 04:04:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753767AbXJWIET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 04:04:19 -0400
Received: from mga11.intel.com ([192.55.52.93]:14274 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753963AbXJWIEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 04:04:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,316,1188802800"; 
   d="scan'208";a="183260745"
Subject: [PATCH -v7 2/3] x86 boot: boot parameters export via sysfs
From: "Huang, Ying" <ying.huang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 23 Oct 2007 16:06:15 +0800
Message-Id: <1193126775.23935.80.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 23 Oct 2007 08:03:32.0784 (UTC) FILETIME=[3483C300:01C8154B]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch export the boot parameters via sysfs. This can be used for
debugging and kexec.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---

 Makefile_32 |    1 
 Makefile_64 |    1 
 ksysfs.c    |  236 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 setup64.c   |    2 
 setup_32.c  |    2 
 5 files changed, 240 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/kernel/Makefile_64
===================================================================
--- linux-2.6.orig/arch/x86/kernel/Makefile_64	2007-10-22 09:18:08.000000000 +0800
+++ linux-2.6/arch/x86/kernel/Makefile_64	2007-10-22 14:12:53.000000000 +0800
@@ -37,6 +37,7 @@
 obj-$(CONFIG_X86_VSMP)		+= vsmp_64.o
 obj-$(CONFIG_K8_NB)		+= k8.o
 obj-$(CONFIG_AUDIT)		+= audit_64.o
+obj-$(CONFIG_SYSFS)		+= ksysfs.o
 
 obj-$(CONFIG_MODULES)		+= module_64.o
 obj-$(CONFIG_PCI)		+= early-quirks.o
Index: linux-2.6/arch/x86/kernel/setup64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup64.c	2007-10-22 09:18:08.000000000 +0800
+++ linux-2.6/arch/x86/kernel/setup64.c	2007-10-22 14:12:14.000000000 +0800
@@ -24,7 +24,7 @@
 #include <asm/sections.h>
 #include <asm/setup.h>
 
-struct boot_params __initdata boot_params;
+struct boot_params boot_params;
 
 cpumask_t cpu_initialized __cpuinitdata = CPU_MASK_NONE;
 
Index: linux-2.6/arch/x86/kernel/ksysfs.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/arch/x86/kernel/ksysfs.c	2007-10-22 14:12:14.000000000 +0800
@@ -0,0 +1,236 @@
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
+static ssize_t boot_params_version_show(struct kset *kset, char *page)
+{
+	return sprintf(page, "0x%x\n", boot_params.hdr.version);
+}
+
+static struct subsys_attribute boot_params_version_attr = {
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
+struct setup_data_kobj
+{
+	struct kobject kobj;
+	struct setup_data *setup_data;
+	struct bin_attribute *data_attr;
+};
+
+struct setup_data_attribute {
+	struct attribute attr;
+	ssize_t (*show) (struct setup_data_kobj *setup_data_kobj, char *buf);
+};
+
+static ssize_t setup_data_type_show(struct setup_data_kobj *setup_data_kobj,
+				    char *page)
+{
+	return sprintf(page, "0x%x\n", setup_data_kobj->setup_data->type);
+}
+
+static struct setup_data_attribute setup_data_type_attr = {
+	.attr = {
+		.name = "type",
+		.mode = S_IRUGO,
+	},
+	.show = setup_data_type_show,
+};
+
+static ssize_t setup_data_attr_show(struct kobject *kobj,
+				    struct attribute *attr,
+				    char *buf)
+{
+	struct setup_data_kobj *setup_data_kobj =
+		(struct setup_data_kobj *)kobj;
+	struct setup_data_attribute *setup_data_attr =
+		(struct setup_data_attribute *)attr;
+	ssize_t error = -EIO;
+
+	if (setup_data_attr->show)
+		error = setup_data_attr->show(setup_data_kobj, buf);
+	return error;
+}
+
+static void setup_data_kobj_release(struct kobject *kobj)
+{
+	struct setup_data_kobj *setup_data_kobj =
+		(struct setup_data_kobj *)kobj;
+	kfree(setup_data_kobj->data_attr);
+	kfree(setup_data_kobj);
+}
+
+static struct sysfs_ops setup_data_attr_ops = {
+	.show = setup_data_attr_show,
+};
+
+static struct attribute *setup_data_default_attrs[] = {
+	&setup_data_type_attr.attr,
+	NULL,
+};
+
+static struct kobj_type ktype_setup_data = {
+	.release = &setup_data_kobj_release,
+	.sysfs_ops = &setup_data_attr_ops,
+	.default_attrs = setup_data_default_attrs,
+};
+
+static ssize_t setup_data_data_read(struct kobject *kobj,
+				    struct bin_attribute *bin_attr,
+				    char *buf, loff_t off, size_t count)
+{
+	struct setup_data_kobj *setup_data_kobj =
+		(struct setup_data_kobj *)kobj;
+	memcpy(buf, setup_data_kobj->setup_data->data + off, count);
+	return count;
+}
+
+decl_subsys(boot_params, NULL, NULL);
+decl_subsys(setup_data, &ktype_setup_data, NULL);
+
+static int __init setup_data_create_kobj(struct setup_data *setup_data,
+					 const char *name)
+{
+	struct setup_data_kobj *setup_data_kobj;
+	struct bin_attribute *data_attr;
+	int error;
+
+	setup_data_kobj = kzalloc(sizeof(struct setup_data_kobj), GFP_KERNEL);
+	if (!setup_data_kobj) {
+		error = -ENOMEM;
+		goto err_return;
+	}
+	setup_data_kobj->setup_data = setup_data;
+	kobject_set_name(&setup_data_kobj->kobj, "%s", name);
+	kobj_set_kset_s(setup_data_kobj, setup_data_subsys);
+	error = kobject_register(&setup_data_kobj->kobj);
+	if (error) {
+		kfree(setup_data_kobj);
+		goto err_return;
+	}
+	data_attr = kzalloc(sizeof(struct bin_attribute), GFP_KERNEL);
+	if (!data_attr) {
+		error = -ENOMEM;
+		goto err_unregister;
+	}
+	setup_data_kobj->data_attr = data_attr;
+	data_attr->attr.name = "data";
+	data_attr->attr.mode = S_IRUGO;
+	data_attr->read = setup_data_data_read;
+	data_attr->size = setup_data->len;
+	error = sysfs_create_bin_file(&setup_data_kobj->kobj,
+				      data_attr);
+	if (error)
+		goto err_unregister;
+	return 0;
+err_unregister:
+	kobject_unregister(&setup_data_kobj->kobj);
+err_return:
+	return error;
+}
+
+static void __init setup_data_kobjs_del(void)
+{
+	struct kobject *kobj;
+
+	spin_lock(&setup_data_subsys.list_lock);
+	list_for_each_entry(kobj, &setup_data_subsys.list, entry)
+		kobject_unregister(kobj);
+	spin_unlock(&setup_data_subsys.list_lock);
+}
+
+static int __init boot_params_ksysfs_init(void)
+{
+	int error;
+	struct setup_data *setup_data;
+	int n = 0;
+	char buf[8];
+
+	kobj_set_kset_s(&boot_params_subsys, kernel_subsys);
+	error = subsystem_register(&boot_params_subsys);
+	if (error)
+		goto err_return;
+	error = sysfs_create_group(&boot_params_subsys.kobj,
+				   &boot_params_attr_group);
+	if (error)
+		goto err_boot_params_subsys_unregister;
+	error = sysfs_create_bin_file(&boot_params_subsys.kobj,
+				      &boot_params_data_attr);
+	if (error)
+		goto err_boot_params_subsys_unregister;
+	kobj_set_kset_s(&setup_data_subsys, boot_params_subsys);
+	error = subsystem_register(&setup_data_subsys);
+	if (error)
+		goto err_boot_params_subsys_unregister;
+	for (setup_data = __va(boot_params.hdr.setup_data);
+	     setup_data != __va(0);
+	     setup_data = __va(setup_data->next)) {
+		sprintf(buf, "%d", n++);
+		error = setup_data_create_kobj(setup_data, buf);
+		if (error)
+			goto err_setup_data_kobjs_del;
+	}
+	return 0;
+err_setup_data_kobjs_del:
+	setup_data_kobjs_del();
+	subsystem_unregister(&setup_data_subsys);
+err_boot_params_subsys_unregister:
+	subsystem_unregister(&boot_params_subsys);
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
Index: linux-2.6/arch/x86/kernel/Makefile_32
===================================================================
--- linux-2.6.orig/arch/x86/kernel/Makefile_32	2007-10-22 09:18:08.000000000 +0800
+++ linux-2.6/arch/x86/kernel/Makefile_32	2007-10-22 14:13:06.000000000 +0800
@@ -41,6 +41,7 @@
 obj-$(CONFIG_HPET_TIMER) 	+= hpet.o
 obj-$(CONFIG_K8_NB)		+= k8.o
 obj-$(CONFIG_MGEODE_LX)		+= geode_32.o mfgpt_32.o
+obj-$(CONFIG_SYSFS)		+= ksysfs.o
 
 obj-$(CONFIG_VMI)		+= vmi_32.o vmiclock_32.o
 obj-$(CONFIG_PARAVIRT)		+= paravirt_32.o
Index: linux-2.6/arch/x86/kernel/setup_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_32.c	2007-10-22 14:09:25.000000000 +0800
+++ linux-2.6/arch/x86/kernel/setup_32.c	2007-10-22 14:12:14.000000000 +0800
@@ -125,7 +125,7 @@
 
 static char __initdata command_line[COMMAND_LINE_SIZE];
 
-struct boot_params __initdata boot_params;
+struct boot_params boot_params;
 
 #if defined(CONFIG_EDD) || defined(CONFIG_EDD_MODULE)
 struct edd edd;
