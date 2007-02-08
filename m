Return-Path: <linux-kernel-owner+w=401wt.eu-S965719AbXBHAj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965719AbXBHAj6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 19:39:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965717AbXBHAjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 19:39:51 -0500
Received: from ns2.suse.de ([195.135.220.15]:34028 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422843AbXBHAbz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 19:31:55 -0500
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 8/28] Modules: only add drivers/ direcory if needed
Date: Wed,  7 Feb 2007 16:29:56 -0800
Message-Id: <11708946472324-git-send-email-greg@kroah.com>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <11708946432920-git-send-email-greg@kroah.com>
References: <20070208002908.GA4796@kroah.com> <11708946163722-git-send-email-greg@kroah.com> <1170894620889-git-send-email-greg@kroah.com> <11708946251265-git-send-email-greg@kroah.com> <11708946283719-git-send-email-greg@kroah.com> <11708946362677-git-send-email-greg@kroah.com> <11708946391465-git-send-email-greg@kroah.com> <11708946432920-git-send-email-greg@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@suse.de>

This changes the module core to only create the drivers/ directory if we
are going to put something in it.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/module.c |   20 +++++++++++---------
 kernel/params.c |    1 -
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 0f4489a..9de4209 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1131,12 +1131,6 @@ static int mod_sysfs_setup(struct module *mod,
 	if (err)
 		goto out;
 
-	mod->mkobj.drivers_dir = kobject_add_dir(&mod->mkobj.kobj, "drivers");
-	if (!mod->mkobj.drivers_dir) {
-		err = -ENOMEM;
-		goto out_unreg;
-	}
-
 	err = module_param_sysfs_setup(mod, kparam, num_params);
 	if (err)
 		goto out_unreg_drivers;
@@ -1151,8 +1145,6 @@ static int mod_sysfs_setup(struct module *mod,
 out_unreg_param:
 	module_param_sysfs_remove(mod);
 out_unreg_drivers:
-	kobject_unregister(mod->mkobj.drivers_dir);
-out_unreg:
 	kobject_del(&mod->mkobj.kobj);
 	kobject_put(&mod->mkobj.kobj);
 out:
@@ -1163,7 +1155,8 @@ static void mod_kobject_remove(struct module *mod)
 {
 	module_remove_modinfo_attrs(mod);
 	module_param_sysfs_remove(mod);
-	kobject_unregister(mod->mkobj.drivers_dir);
+	if (mod->mkobj.drivers_dir)
+		kobject_unregister(mod->mkobj.drivers_dir);
 
 	kobject_unregister(&mod->mkobj.kobj);
 }
@@ -2340,6 +2333,14 @@ static char *make_driver_name(struct device_driver *drv)
 	return driver_name;
 }
 
+static void module_create_drivers_dir(struct module_kobject *mk)
+{
+	if (!mk || mk->drivers_dir)
+		return;
+
+	mk->drivers_dir = kobject_add_dir(&mk->kobj, "drivers");
+}
+
 void module_add_driver(struct module *mod, struct device_driver *drv)
 {
 	char *driver_name;
@@ -2367,6 +2368,7 @@ void module_add_driver(struct module *mod, struct device_driver *drv)
 	no_warn = sysfs_create_link(&drv->kobj, &mk->kobj, "module");
 	driver_name = make_driver_name(drv);
 	if (driver_name) {
+		module_create_drivers_dir(mk);
 		no_warn = sysfs_create_link(mk->drivers_dir, &drv->kobj,
 					    driver_name);
 		kfree(driver_name);
diff --git a/kernel/params.c b/kernel/params.c
index 737b7c5..cbaac85 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -565,7 +565,6 @@ static void __init kernel_param_sysfs_setup(const char *name,
 	ret = kobject_add(&mk->kobj);
 	BUG_ON(ret < 0);
 	param_sysfs_setup(mk, kparam, num_params, name_skip);
-	mk->drivers_dir = kobject_add_dir(&mk->kobj, "drivers");
 	kobject_uevent(&mk->kobj, KOBJ_ADD);
 }
 
-- 
1.4.4.4

