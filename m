Return-Path: <linux-kernel-owner+w=401wt.eu-S1760141AbYAYHjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760141AbYAYHjx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:39:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758749AbYAYHSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:18:37 -0500
Received: from cantor.suse.de ([195.135.220.2]:52952 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759170AbYAYHSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:18:35 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 070/196] kset: convert /sys/power to use kset_create
Date: Thu, 24 Jan 2008 23:10:08 -0800
Message-Id: <1201245134-4876-70-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dynamically create the kset instead of declaring it statically.  We also
rename power_subsys to power_kset to catch all users of the variable and
we properly export it so that people don't have to guess that it really
is present in the system.

The pseries code is wierd, why is it createing /sys/power if CONFIG_PM
is disabled?  Oh well, stupid big boxes ignoring config options...

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/arm/mach-omap1/pm.c               |    3 +--
 arch/powerpc/platforms/pseries/power.c |   14 ++++++--------
 include/linux/kobject.h                |    2 ++
 kernel/power/disk.c                    |    2 +-
 kernel/power/main.c                    |   11 +++++------
 kernel/power/power.h                   |    2 --
 6 files changed, 15 insertions(+), 19 deletions(-)

diff --git a/arch/arm/mach-omap1/pm.c b/arch/arm/mach-omap1/pm.c
index 3bf01e2..402113c 100644
--- a/arch/arm/mach-omap1/pm.c
+++ b/arch/arm/mach-omap1/pm.c
@@ -97,7 +97,6 @@ static struct subsys_attribute sleep_while_idle_attr = {
 	.store  = omap_pm_sleep_while_idle_store,
 };
 
-extern struct kset power_subsys;
 static void (*omap_sram_idle)(void) = NULL;
 static void (*omap_sram_suspend)(unsigned long r0, unsigned long r1) = NULL;
 
@@ -726,7 +725,7 @@ static int __init omap_pm_init(void)
 	omap_pm_init_proc();
 #endif
 
-	error = subsys_create_file(&power_subsys, &sleep_while_idle_attr);
+	error = subsys_create_file(power_kset, &sleep_while_idle_attr);
 	if (error)
 		printk(KERN_ERR "subsys_create_file failed: %d\n", error);
 
diff --git a/arch/powerpc/platforms/pseries/power.c b/arch/powerpc/platforms/pseries/power.c
index 08d7a50..c36febe 100644
--- a/arch/powerpc/platforms/pseries/power.c
+++ b/arch/powerpc/platforms/pseries/power.c
@@ -57,7 +57,7 @@ static struct subsys_attribute auto_poweron_attr = {
 };
 
 #ifndef CONFIG_PM
-decl_subsys(power, NULL);
+struct kset *power_kset;
 
 static struct attribute *g[] = {
         &auto_poweron_attr.attr,
@@ -70,18 +70,16 @@ static struct attribute_group attr_group = {
 
 static int __init pm_init(void)
 {
-        int error = subsystem_register(&power_subsys);
-        if (!error)
-                error = sysfs_create_group(&power_subsys.kobj, &attr_group);
-        return error;
+	power_kset = kset_create_and_add("power", NULL, NULL);
+	if (!power_kset)
+		return -ENOMEM;
+	return sysfs_create_group(&power_kset->kobj, &attr_group);
 }
 core_initcall(pm_init);
 #else
-extern struct kset power_subsys;
-
 static int __init apo_pm_init(void)
 {
-	return (subsys_create_file(&power_subsys, &auto_poweron_attr));
+	return (subsys_create_file(power_kset, &auto_poweron_attr));
 }
 __initcall(apo_pm_init);
 #endif
diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index f2483f6..a6dd669 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -198,6 +198,8 @@ struct kset _name##_subsys = { \
 extern struct kset *kernel_kset;
 /* The global /sys/hypervisor/ kobject for people to chain off of */
 extern struct kobject *hypervisor_kobj;
+/* The global /sys/power/ kset for people to chain off of */
+extern struct kset *power_kset;
 
 extern int __must_check subsystem_register(struct kset *);
 extern void subsystem_unregister(struct kset *);
diff --git a/kernel/power/disk.c b/kernel/power/disk.c
index 05b6479..c3f0e61 100644
--- a/kernel/power/disk.c
+++ b/kernel/power/disk.c
@@ -708,7 +708,7 @@ static struct attribute_group attr_group = {
 
 static int __init pm_disk_init(void)
 {
-	return sysfs_create_group(&power_subsys.kobj, &attr_group);
+	return sysfs_create_group(&power_kset->kobj, &attr_group);
 }
 
 core_initcall(pm_disk_init);
diff --git a/kernel/power/main.c b/kernel/power/main.c
index 1ef31c9..dce2d76 100644
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -276,8 +276,7 @@ EXPORT_SYMBOL(pm_suspend);
 
 #endif /* CONFIG_SUSPEND */
 
-decl_subsys(power, NULL);
-
+struct kset *power_kset;
 
 /**
  *	state - control system power state.
@@ -386,10 +385,10 @@ static struct attribute_group attr_group = {
 
 static int __init pm_init(void)
 {
-	int error = subsystem_register(&power_subsys);
-	if (!error)
-		error = sysfs_create_group(&power_subsys.kobj,&attr_group);
-	return error;
+	power_kset = kset_create_and_add("power", NULL, NULL);
+	if (!power_kset)
+		return -ENOMEM;
+	return sysfs_create_group(&power_kset->kobj, &attr_group);
 }
 
 core_initcall(pm_init);
diff --git a/kernel/power/power.h b/kernel/power/power.h
index 195dc46..1083e6b 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -63,8 +63,6 @@ static struct subsys_attribute _name##_attr = {	\
 	.store	= _name##_store,		\
 }
 
-extern struct kset power_subsys;
-
 /* Preferred image size in bytes (default 500 MB) */
 extern unsigned long image_size;
 extern int in_suspend;
-- 
1.5.3.8

