Return-Path: <linux-kernel-owner+w=401wt.eu-S932630AbXJLFvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932630AbXJLFvd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 01:51:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759982AbXJLFuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 01:50:40 -0400
Received: from mga09.intel.com ([134.134.136.24]:24604 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759989AbXJLFuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 01:50:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,264,1188802800"; 
   d="scan'208";a="170466895"
Subject: [PATCH -mm -v5 2/3] i386/x86_64 boot: boot parameters export via
	sysfs
From: "Huang, Ying" <ying.huang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>, akpm@linux-foundation.org,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 12 Oct 2007 13:52:33 +0800
Message-Id: <1192168353.17539.44.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 12 Oct 2007 05:50:19.0195 (UTC) FILETIME=[C56BA0B0:01C80C93]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch export the boot parameters via sysfs. This can be used for
debugging and kexec.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---

 i386/kernel/Makefile    |    1 
 i386/kernel/ksysfs.c    |  267 ++++++++++++++++++++++++++++++++++++++++++++++++
 i386/kernel/setup.c     |    2 
 x86_64/kernel/Makefile  |    1 
 x86_64/kernel/setup64.c |    2 
 5 files changed, 271 insertions(+), 2 deletions(-)

Index: linux-2.6.23-rc8/arch/x86_64/kernel/Makefile
===================================================================
--- linux-2.6.23-rc8.orig/arch/x86_64/kernel/Makefile	2007-10-12 11:20:29.000000000 +0800
+++ linux-2.6.23-rc8/arch/x86_64/kernel/Makefile	2007-10-12 11:21:05.000000000 +0800
@@ -39,6 +39,7 @@
 obj-$(CONFIG_K8_NB)		+= k8.o
 obj-$(CONFIG_AUDIT)		+= audit.o
 obj-$(CONFIG_STACK_UNWIND)	+= unwind.o
+obj-$(CONFIG_SYSFS)		+= ../../i386/kernel/ksysfs.o
 
 obj-$(CONFIG_MODULES)		+= module.o
 obj-$(CONFIG_PCI)		+= early-quirks.o
Index: linux-2.6.23-rc8/arch/x86_64/kernel/setup64.c
===================================================================
--- linux-2.6.23-rc8.orig/arch/x86_64/kernel/setup64.c	2007-10-12 11:20:29.000000000 +0800
+++ linux-2.6.23-rc8/arch/x86_64/kernel/setup64.c	2007-10-12 11:21:05.000000000 +0800
@@ -24,7 +24,7 @@
 #include <asm/sections.h>
 #include <asm/setup.h>
 
-struct boot_params __initdata boot_params;
+struct boot_params boot_params;
 
 cpumask_t cpu_initialized __cpuinitdata = CPU_MASK_NONE;
 
Index: linux-2.6.23-rc8/arch/i386/kernel/ksysfs.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.23-rc8/arch/i386/kernel/ksysfs.c	2007-10-12 11:21:05.000000000 +0800
@@ -0,0 +1,267 @@
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
+#include <linux/highmem.h>
+
+#include <asm/setup.h>
+
+static unsigned long copy_from_phys(void *to, unsigned long from_phys,
+				    unsigned long n)
+{
+	struct page *page;
+	void *from;
+	unsigned long remain = n, offset, trunck;
+
+	while (remain) {
+		page = pfn_to_page(from_phys >> PAGE_SHIFT);
+		from = kmap_atomic(page, KM_USER0);
+		offset = from_phys & ~PAGE_MASK;
+		if (remain > PAGE_SIZE - offset)
+			trunck = PAGE_SIZE - offset;
+		else
+			trunck = remain;
+		memcpy(to, from + offset, trunck);
+		kunmap_atomic(from, KM_USER0);
+		to += trunck;
+		from_phys += trunck;
+		remain -= trunck;
+	}
+	return n;
+}
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
+	unsigned long pa_setup_data;
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
+	struct setup_data data;
+	copy_from_phys(&data, setup_data_kobj->pa_setup_data, sizeof(data));
+	return sprintf(page, "0x%x\n", data.type);
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
+	count = copy_from_phys(buf, setup_data_kobj->pa_setup_data +
+			       sizeof(struct setup_data) + off, count);
+	return count;
+}
+
+decl_subsys(boot_params, NULL, NULL);
+decl_subsys(setup_data, &ktype_setup_data, NULL);
+
+static int __init setup_data_create_kobj(struct setup_data *setup_data,
+					 unsigned long pa_setup_data,
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
+	setup_data_kobj->pa_setup_data = pa_setup_data;
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
+	struct setup_data setup_data;
+	unsigned long pa_setup_data;
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
+	pa_setup_data = boot_params.hdr.setup_data;
+	while (pa_setup_data) {
+		copy_from_phys(&setup_data, pa_setup_data, sizeof(setup_data));
+		sprintf(buf, "%d", n++);
+		error = setup_data_create_kobj(&setup_data, pa_setup_data, buf);
+		if (error)
+			goto err_setup_data_kobjs_del;
+		pa_setup_data = setup_data.next;
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
Index: linux-2.6.23-rc8/arch/i386/kernel/Makefile
===================================================================
--- linux-2.6.23-rc8.orig/arch/i386/kernel/Makefile	2007-10-12 11:20:29.000000000 +0800
+++ linux-2.6.23-rc8/arch/i386/kernel/Makefile	2007-10-12 11:21:05.000000000 +0800
@@ -44,6 +44,7 @@
 obj-$(CONFIG_K8_NB)		+= k8.o
 obj-$(CONFIG_MGEODE_LX)		+= geode.o mfgpt.o
 obj-$(CONFIG_STACK_UNWIND)	+= unwind.o
+obj-$(CONFIG_SYSFS)		+= ksysfs.o
 
 obj-$(CONFIG_VMI)		+= vmi.o vmiclock.o
 obj-$(CONFIG_PARAVIRT)		+= paravirt.o
Index: linux-2.6.23-rc8/arch/i386/kernel/setup.c
===================================================================
--- linux-2.6.23-rc8.orig/arch/i386/kernel/setup.c	2007-10-12 11:20:29.000000000 +0800
+++ linux-2.6.23-rc8/arch/i386/kernel/setup.c	2007-10-12 11:21:05.000000000 +0800
@@ -126,7 +126,7 @@
 
 static char __initdata command_line[COMMAND_LINE_SIZE];
 
-struct boot_params __initdata boot_params;
+struct boot_params boot_params;
 
 #if defined(CONFIG_EDD) || defined(CONFIG_EDD_MODULE)
 struct edd edd;
