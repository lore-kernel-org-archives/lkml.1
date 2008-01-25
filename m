Return-Path: <linux-kernel-owner+w=401wt.eu-S1761483AbYAYHiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761483AbYAYHiP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:38:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758942AbYAYHSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:18:21 -0500
Received: from cantor.suse.de ([195.135.220.2]:52903 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758937AbYAYHST (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:18:19 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 066/196] kset: convert /sys/devices/system to use kset_create
Date: Thu, 24 Jan 2008 23:10:04 -0800
Message-Id: <1201245134-4876-66-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dynamically create the kset instead of declaring it statically.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/sys.c |   27 +++++++++++----------------
 1 files changed, 11 insertions(+), 16 deletions(-)

diff --git a/drivers/base/sys.c b/drivers/base/sys.c
index 7693c95..29eadc6 100644
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
@@ -457,8 +450,10 @@ int sysdev_resume(void)
 
 int __init system_bus_init(void)
 {
-	system_subsys.kobj.parent = &devices_kset->kobj;
-	return subsystem_register(&system_subsys);
+	system_kset = kset_create_and_add("system", NULL, &devices_kset->kobj);
+	if (!system_kset)
+		return -ENOMEM;
+	return 0;
 }
 
 EXPORT_SYMBOL_GPL(sysdev_register);
-- 
1.5.3.8

