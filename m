Return-Path: <linux-kernel-owner+w=401wt.eu-S1762857AbXKCAHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762857AbXKCAHm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 20:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762022AbXKCABe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 20:01:34 -0400
Received: from ns2.suse.de ([195.135.220.15]:34846 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762013AbXKCABd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 20:01:33 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 22/54] kset: convert /sys/devices/system to use kset_create
Date: Fri,  2 Nov 2007 16:59:00 -0700
Message-Id: <1194047972-9850-22-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <20071102235758.GA9803@kroah.com>
References: <20071102235758.GA9803@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dynamically create the kset instead of declaring it statically.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/sys.c |   28 ++++++++++++----------------
 1 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/drivers/base/sys.c b/drivers/base/sys.c
index 7693c95..600db58 100644
--- a/drivers/base/sys.c
+++ b/drivers/base/sys.c
@@ -126,19 +126,16 @@ void sysdev_class_remove_file(struct sysdev_class *c,
 }
 EXPORT_SYMBOL_GPL(sysdev_class_remove_file);
 
-/*
- * declare system_subsys
- */
-static decl_subsys(system, NULL);
+static struct kset *system_kset;
 
 int sysdev_class_register(struct sysdev_class * cls)
 {
 	pr_debug("Registering sysdev class '%s'\n",
 		 kobject_name(&cls->kset.kobj));
 	INIT_LIST_HEAD(&cls->drivers);
-	cls->kset.kobj.parent = &system_subsys.kobj;
+	cls->kset.kobj.parent = &system_kset->kobj;
 	cls->kset.kobj.ktype = &ktype_sysdev_class;
-	cls->kset.kobj.kset = &system_subsys;
+	cls->kset.kobj.kset = system_kset;
 	return kset_register(&cls->kset);
 }
 
@@ -297,8 +294,7 @@ void sysdev_shutdown(void)
 	pr_debug("Shutting Down System Devices\n");
 
 	mutex_lock(&sysdev_drivers_lock);
-	list_for_each_entry_reverse(cls, &system_subsys.list,
-				    kset.kobj.entry) {
+	list_for_each_entry_reverse(cls, &system_kset->list, kset.kobj.entry) {
 		struct sys_device * sysdev;
 
 		pr_debug("Shutting down type '%s':\n",
@@ -360,9 +356,7 @@ int sysdev_suspend(pm_message_t state)
 
 	pr_debug("Suspending System Devices\n");
 
-	list_for_each_entry_reverse(cls, &system_subsys.list,
-				    kset.kobj.entry) {
-
+	list_for_each_entry_reverse(cls, &system_kset->list, kset.kobj.entry) {
 		pr_debug("Suspending type '%s':\n",
 			 kobject_name(&cls->kset.kobj));
 
@@ -413,8 +407,7 @@ aux_driver:
 	}
 
 	/* resume other classes */
-	list_for_each_entry_continue(cls, &system_subsys.list,
-					kset.kobj.entry) {
+	list_for_each_entry_continue(cls, &system_kset->list, kset.kobj.entry) {
 		list_for_each_entry(err_dev, &cls->kset.list, kobj.entry) {
 			pr_debug(" %s\n", kobject_name(&err_dev->kobj));
 			__sysdev_resume(err_dev);
@@ -439,7 +432,7 @@ int sysdev_resume(void)
 
 	pr_debug("Resuming System Devices\n");
 
-	list_for_each_entry(cls, &system_subsys.list, kset.kobj.entry) {
+	list_for_each_entry(cls, &system_kset->list, kset.kobj.entry) {
 		struct sys_device * sysdev;
 
 		pr_debug("Resuming type '%s':\n",
@@ -457,8 +450,11 @@ int sysdev_resume(void)
 
 int __init system_bus_init(void)
 {
-	system_subsys.kobj.parent = &devices_kset->kobj;
-	return subsystem_register(&system_subsys);
+	system_kset = kset_create_and_register("system", NULL,
+					       NULL, devices_kset);
+	if (IS_ERR(system_kset))
+		return PTR_ERR(system_kset);
+	return 0;
 }
 
 EXPORT_SYMBOL_GPL(sysdev_register);
-- 
1.5.3.4

