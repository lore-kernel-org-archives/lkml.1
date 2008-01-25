Return-Path: <linux-kernel-owner+w=401wt.eu-S1761026AbYAYH5E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761026AbYAYH5E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:57:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761882AbYAYHgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:36:52 -0500
Received: from mail.suse.de ([195.135.220.2]:55412 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761518AbYAYHgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:36:51 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 104/196] driver core: make /sys/power a kobject
Date: Thu, 24 Jan 2008 23:32:13 -0800
Message-Id: <1201246425-5058-25-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/sys/power should not be a kset, that's overkill.  This patch renames it
to power_kset and fixes up all usages of it in the tree.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/arm/mach-omap1/pm.c               |    2 +-
 arch/powerpc/platforms/pseries/power.c |   10 +++++-----
 include/linux/kobject.h                |    4 ++--
 kernel/power/disk.c                    |    2 +-
 kernel/power/main.c                    |    8 ++++----
 5 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/arm/mach-omap1/pm.c b/arch/arm/mach-omap1/pm.c
index 63edafb..d9805e3 100644
--- a/arch/arm/mach-omap1/pm.c
+++ b/arch/arm/mach-omap1/pm.c
@@ -719,7 +719,7 @@ static int __init omap_pm_init(void)
 	omap_pm_init_proc();
 #endif
 
-	error = sysfs_create_file(&power_kset->kobj, &sleep_while_idle_attr);
+	error = sysfs_create_file(power_kobj, &sleep_while_idle_attr);
 	if (error)
 		printk(KERN_ERR "sysfs_create_file failed: %d\n", error);
 
diff --git a/arch/powerpc/platforms/pseries/power.c b/arch/powerpc/platforms/pseries/power.c
index 90706cf..e95fc15 100644
--- a/arch/powerpc/platforms/pseries/power.c
+++ b/arch/powerpc/platforms/pseries/power.c
@@ -53,7 +53,7 @@ static struct kobj_attribute auto_poweron_attr =
 	__ATTR(auto_poweron, 0644, auto_poweron_show, auto_poweron_store);
 
 #ifndef CONFIG_PM
-struct kset *power_kset;
+struct kobject *power_kobj;
 
 static struct attribute *g[] = {
         &auto_poweron_attr.attr,
@@ -66,16 +66,16 @@ static struct attribute_group attr_group = {
 
 static int __init pm_init(void)
 {
-	power_kset = kset_create_and_add("power", NULL, NULL);
-	if (!power_kset)
+	power_kobj = kobject_create_and_add("power", NULL);
+	if (!power_kobj)
 		return -ENOMEM;
-	return sysfs_create_group(&power_kset->kobj, &attr_group);
+	return sysfs_create_group(power_kobj, &attr_group);
 }
 core_initcall(pm_init);
 #else
 static int __init apo_pm_init(void)
 {
-	return (sysfs_create_file(&power_kset->kobj, &auto_poweron_attr));
+	return (sysfs_create_file(power_kobj, &auto_poweron_attr));
 }
 __initcall(apo_pm_init);
 #endif
diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index 78c851b..bb68684 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -202,8 +202,8 @@ extern struct kobject * kset_find_obj(struct kset *, const char *);
 extern struct kobject *kernel_kobj;
 /* The global /sys/hypervisor/ kobject for people to chain off of */
 extern struct kobject *hypervisor_kobj;
-/* The global /sys/power/ kset for people to chain off of */
-extern struct kset *power_kset;
+/* The global /sys/power/ kobject for people to chain off of */
+extern struct kobject *power_kobj;
 /* The global /sys/firmware/ kobject for people to chain off of */
 extern struct kobject *firmware_kobj;
 
diff --git a/kernel/power/disk.c b/kernel/power/disk.c
index ef5aa2c..b138b43 100644
--- a/kernel/power/disk.c
+++ b/kernel/power/disk.c
@@ -714,7 +714,7 @@ static struct attribute_group attr_group = {
 
 static int __init pm_disk_init(void)
 {
-	return sysfs_create_group(&power_kset->kobj, &attr_group);
+	return sysfs_create_group(power_kobj, &attr_group);
 }
 
 core_initcall(pm_disk_init);
diff --git a/kernel/power/main.c b/kernel/power/main.c
index b813949..efc0836 100644
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -276,7 +276,7 @@ EXPORT_SYMBOL(pm_suspend);
 
 #endif /* CONFIG_SUSPEND */
 
-struct kset *power_kset;
+struct kobject *power_kobj;
 
 /**
  *	state - control system power state.
@@ -389,10 +389,10 @@ static struct attribute_group attr_group = {
 
 static int __init pm_init(void)
 {
-	power_kset = kset_create_and_add("power", NULL, NULL);
-	if (!power_kset)
+	power_kobj = kobject_create_and_add("power", NULL);
+	if (!power_kobj)
 		return -ENOMEM;
-	return sysfs_create_group(&power_kset->kobj, &attr_group);
+	return sysfs_create_group(power_kobj, &attr_group);
 }
 
 core_initcall(pm_init);
-- 
1.5.3.8

