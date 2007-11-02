Return-Path: <linux-kernel-owner+w=401wt.eu-S932168AbXKCAIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932168AbXKCAIu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 20:08:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762083AbXKCABu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 20:01:50 -0400
Received: from mx2.suse.de ([195.135.220.15]:34863 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762075AbXKCABt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 20:01:49 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 26/54] kset: convert /sys/power to use kset_create
Date: Fri,  2 Nov 2007 16:59:04 -0700
Message-Id: <1194047972-9850-26-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <20071102235758.GA9803@kroah.com>
References: <20071102235758.GA9803@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
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
 arch/powerpc/platforms/pseries/power.c |   15 +++++++--------
 include/linux/kobject.h                |    2 ++
 kernel/power/disk.c                    |    2 +-
 kernel/power/main.c                    |   12 ++++++------
 kernel/power/power.h                   |    2 --
 6 files changed, 17 insertions(+), 19 deletions(-)

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
index 08d7a50..bf35de4 100644
--- a/arch/powerpc/platforms/pseries/power.c
+++ b/arch/powerpc/platforms/pseries/power.c
@@ -25,6 +25,7 @@
 #include <linux/string.h>
 #include <linux/errno.h>
 #include <linux/init.h>
+#include <linux/err.h>
 
 unsigned long rtas_poweron_auto; /* default and normal state is 0 */
 
@@ -57,7 +58,7 @@ static struct subsys_attribute auto_poweron_attr = {
 };
 
 #ifndef CONFIG_PM
-decl_subsys(power, NULL);
+struct kset *power_kset;
 
 static struct attribute *g[] = {
         &auto_poweron_attr.attr,
@@ -70,18 +71,16 @@ static struct attribute_group attr_group = {
 
 static int __init pm_init(void)
 {
-        int error = subsystem_register(&power_subsys);
-        if (!error)
-                error = sysfs_create_group(&power_subsys.kobj, &attr_group);
-        return error;
+	power_kset = kset_create_and_register("power", NULL, NULL, NULL);
+	if (IS_ERR(power_kset))
+		return PTR_ERR(power_kset);
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
index 63a6bf9..8f4a38c 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -192,6 +192,8 @@ struct kset _name##_subsys = { \
 extern struct kset *kernel_kset;
 /* The global /sys/hypervisor/ kset for people to chain off of */
 extern struct kset *hypervisor_kset;
+/* The global /sys/power/ kset for people to chain off of */
+extern struct kset *power_kset;
 
 extern int __must_check subsystem_register(struct kset *);
 extern void subsystem_unregister(struct kset *);
diff --git a/kernel/power/disk.c b/kernel/power/disk.c
index 8b15f77..05fbe67 100644
--- a/kernel/power/disk.c
+++ b/kernel/power/disk.c
@@ -698,7 +698,7 @@ static struct attribute_group attr_group = {
 
 static int __init pm_disk_init(void)
 {
-	return sysfs_create_group(&power_subsys.kobj, &attr_group);
+	return sysfs_create_group(&power_kset->kobj, &attr_group);
 }
 
 core_initcall(pm_disk_init);
diff --git a/kernel/power/main.c b/kernel/power/main.c
index ce9bf12..6651a3c 100644
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -21,6 +21,7 @@
 #include <linux/freezer.h>
 #include <linux/vmstat.h>
 #include <linux/syscalls.h>
+#include <linux/err.h>
 
 #include "power.h"
 
@@ -273,8 +274,7 @@ EXPORT_SYMBOL(pm_suspend);
 
 #endif /* CONFIG_SUSPEND */
 
-decl_subsys(power, NULL);
-
+struct kset *power_kset;
 
 /**
  *	state - control system power state.
@@ -383,10 +383,10 @@ static struct attribute_group attr_group = {
 
 static int __init pm_init(void)
 {
-	int error = subsystem_register(&power_subsys);
-	if (!error)
-		error = sysfs_create_group(&power_subsys.kobj,&attr_group);
-	return error;
+	power_kset = kset_create_and_register("power", NULL, NULL, NULL);
+	if (IS_ERR(power_kset))
+		return PTR_ERR(power_kset);
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
1.5.3.4

