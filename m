Return-Path: <linux-kernel-owner+w=401wt.eu-S965540AbXA3O5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965540AbXA3O5T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 09:57:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965573AbXA3O5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 09:57:19 -0500
Received: from il.qumranet.com ([62.219.232.206]:51231 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965540AbXA3O5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 09:57:18 -0500
Subject: [PATCH 5/5] KVM: Host suspend/resume support
From: Avi Kivity <avi@qumranet.com>
Date: Tue, 30 Jan 2007 14:57:17 -0000
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, mingo@elte.hu
References: <45BF5B96.1070007@qumranet.com>
In-Reply-To: <45BF5B96.1070007@qumranet.com>
Message-Id: <20070130145717.00D1BA0014@il.qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add the necessary callbacks to suspend and resume a host running kvm.  This
is just a repeat of the cpu hotplug/unplug work.

Signed-off-by: Avi Kivity <avi@qumranet.com>

Index: linux-2.6/drivers/kvm/kvm_main.c
===================================================================
--- linux-2.6.orig/drivers/kvm/kvm_main.c
+++ linux-2.6/drivers/kvm/kvm_main.c
@@ -34,6 +34,7 @@
 #include <linux/highmem.h>
 #include <linux/file.h>
 #include <asm/desc.h>
+#include <linux/sysdev.h>
 #include <linux/cpu.h>
 
 #include "x86_emulate.h"
@@ -2116,6 +2117,30 @@ static void kvm_exit_debug(void)
 	debugfs_remove(debugfs_dir);
 }
 
+static int kvm_suspend(struct sys_device *dev, pm_message_t state)
+{
+	decache_vcpus_on_cpu(raw_smp_processor_id());
+	on_each_cpu(kvm_arch_ops->hardware_disable, 0, 0, 1);
+	return 0;
+}
+
+static int kvm_resume(struct sys_device *dev)
+{
+	on_each_cpu(kvm_arch_ops->hardware_enable, 0, 0, 1);
+	return 0;
+}
+
+static struct sysdev_class kvm_sysdev_class = {
+	set_kset_name("kvm"),
+	.suspend = kvm_suspend,
+	.resume = kvm_resume,
+};
+
+static struct sys_device kvm_sysdev = {
+	.id = 0,
+	.cls = &kvm_sysdev_class,
+};
+
 hpa_t bad_page_address;
 
 int kvm_init_arch(struct kvm_arch_ops *ops, struct module *module)
@@ -2148,6 +2173,14 @@ int kvm_init_arch(struct kvm_arch_ops *o
 		goto out_free_1;
 	register_reboot_notifier(&kvm_reboot_notifier);
 
+	r = sysdev_class_register(&kvm_sysdev_class);
+	if (r)
+		goto out_free_2;
+
+	r = sysdev_register(&kvm_sysdev);
+	if (r)
+		goto out_free_3;
+
 	kvm_chardev_ops.owner = module;
 
 	r = misc_register(&kvm_dev);
@@ -2159,6 +2192,10 @@ int kvm_init_arch(struct kvm_arch_ops *o
 	return r;
 
 out_free:
+	sysdev_unregister(&kvm_sysdev);
+out_free_3:
+	sysdev_class_unregister(&kvm_sysdev_class);
+out_free_2:
 	unregister_reboot_notifier(&kvm_reboot_notifier);
 	unregister_cpu_notifier(&kvm_cpu_notifier);
 out_free_1:
@@ -2170,8 +2207,10 @@ out_free_1:
 void kvm_exit_arch(void)
 {
 	misc_deregister(&kvm_dev);
-
+	sysdev_unregister(&kvm_sysdev);
+	sysdev_class_unregister(&kvm_sysdev_class);
 	unregister_reboot_notifier(&kvm_reboot_notifier);
+	unregister_cpu_notifier(&kvm_cpu_notifier);
 	on_each_cpu(kvm_arch_ops->hardware_disable, 0, 0, 1);
 	kvm_arch_ops->hardware_unsetup();
 	kvm_arch_ops = NULL;
