Return-Path: <linux-kernel-owner+w=401wt.eu-S1757504AbZBFPrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757504AbZBFPrp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 10:47:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758629AbZBFPrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 10:47:20 -0500
Received: from mx2.redhat.com ([66.187.237.31]:56639 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758109AbZBFPrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 10:47:19 -0500
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, avi@redhat.com,
       akataria@vmware.com
Subject: [PATCH 2/2] show hypervisor information on sysfs
Date: Fri,  6 Feb 2009 10:46:57 -0500
Message-Id: <1233935217-24090-3-git-send-email-glommer@redhat.com>
In-Reply-To: <1233935217-24090-2-git-send-email-glommer@redhat.com>
References: <1233935217-24090-1-git-send-email-glommer@redhat.com>
 <1233935217-24090-2-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is useful to easily grab information about whether or not
we're running on top of a hypervisor. And in case affirmative,
which one.

This patch shows it in /sys/hypervisor (and as a site effect, allow
it to be directly selectable).

Signed-off-by: Glauber Costa <glommer@redhat.com>
---
 arch/x86/include/asm/hypervisor.h |    1 +
 arch/x86/kernel/cpu/hypervisor.c  |    2 ++
 drivers/base/Kconfig              |    2 +-
 drivers/base/hypervisor.c         |   34 ++++++++++++++++++++++++++++++++++
 4 files changed, 38 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/hypervisor.h b/arch/x86/include/asm/hypervisor.h
index 369f5c5..5a9cc18 100644
--- a/arch/x86/include/asm/hypervisor.h
+++ b/arch/x86/include/asm/hypervisor.h
@@ -22,5 +22,6 @@
 
 extern unsigned long get_hypervisor_tsc_freq(void);
 extern void init_hypervisor(struct cpuinfo_x86 *c);
+extern void set_hypervisor_name(const char *name);
 
 #endif
diff --git a/arch/x86/kernel/cpu/hypervisor.c b/arch/x86/kernel/cpu/hypervisor.c
index ee1b228..29cf98c 100644
--- a/arch/x86/kernel/cpu/hypervisor.c
+++ b/arch/x86/kernel/cpu/hypervisor.c
@@ -31,8 +31,10 @@ detect_hypervisor_vendor(struct cpuinfo_x86 *c)
 {
 	if (vmware_platform()) {
 		c->x86_hyper_vendor = X86_HYPER_VENDOR_VMWARE;
+		set_hypervisor_name("VMware");
 	} else if (kvm_para_available()) {
 		c->x86_hyper_vendor = X86_HYPER_VENDOR_KVM;
+		set_hypervisor_name("KVM");
 	} else {
 		c->x86_hyper_vendor = X86_HYPER_VENDOR_NONE;
 	}
diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index 8f006f9..209e03a 100644
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -123,7 +123,7 @@ config DEBUG_DEVRES
 	  If you are unsure about this, Say N here.
 
 config SYS_HYPERVISOR
-	bool
+	bool "/sys/hypervisor interface"
 	default n
 
 endmenu
diff --git a/drivers/base/hypervisor.c b/drivers/base/hypervisor.c
index 6428cba..dcf6f25 100644
--- a/drivers/base/hypervisor.c
+++ b/drivers/base/hypervisor.c
@@ -4,6 +4,7 @@
  * Copyright (C) IBM Corp. 2006
  * Copyright (C) 2007 Greg Kroah-Hartman <gregkh@suse.de>
  * Copyright (C) 2007 Novell Inc.
+ * Copyright (C) 2009 Glauber Costa, Red Hat Inc.
  *
  * This file is released under the GPLv2
  */
@@ -15,10 +16,43 @@
 struct kobject *hypervisor_kobj;
 EXPORT_SYMBOL_GPL(hypervisor_kobj);
 
+static const char *hv_string;
+
+static inline const char *get_hypervisor_name(void)
+{
+	if (!hv_string)
+		return "none";
+	else
+		return hv_string;
+}
+
+void set_hypervisor_name(const char *name)
+{
+	hv_string = name;
+}
+
+static ssize_t hyper_name_show(struct kobject *kobj,
+			       struct kobj_attribute *attr, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%s\n", get_hypervisor_name());
+}
+
+static struct kobj_attribute hyper_name_attr =
+	__ATTR(hypervisor_name, S_IRUGO, hyper_name_show, NULL);
+
+
 int __init hypervisor_init(void)
 {
+	int ret;
 	hypervisor_kobj = kobject_create_and_add("hypervisor", NULL);
 	if (!hypervisor_kobj)
 		return -ENOMEM;
+
+	ret = sysfs_create_file(hypervisor_kobj, &hyper_name_attr.attr);
+	if (ret) {
+		printk(KERN_WARNING "could not create hyper_name file\n");
+		return ret;
+	}
+
 	return 0;
 }
-- 
1.5.6.5

