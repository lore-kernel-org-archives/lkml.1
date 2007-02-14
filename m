Return-Path: <linux-kernel-owner+w=401wt.eu-S932517AbXBNUCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932517AbXBNUCv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 15:02:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932526AbXBNUCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 15:02:51 -0500
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:4697 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932517AbXBNUCu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 15:02:50 -0500
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 8/28] Modules: only add drivers/ direcory if needed
Date: Wed, 14 Feb 2007 21:03:39 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200702142103.40471.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, 

> @@ -1163,7 +1155,8 @@ static void mod_kobject_remove(struct module *mod)
>  {
>         module_remove_modinfo_attrs(mod);
>         module_param_sysfs_remove(mod);
> -       kobject_unregister(mod->mkobj.drivers_dir);
> +       if (mod->mkobj.drivers_dir)
> +               kobject_unregister(mod->mkobj.drivers_dir);
>  
>         kobject_unregister(&mod->mkobj.kobj);
>  }

This change looks superfluous on top of patch 1/28 where you'll find

 void kobject_unregister(struct kobject * kobj)
 {
+       if (!kobj)
+               return;

I went a bit further and prepared a patch removing all redundant
kobject_unregister argument checks.



Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/base/class.c  |    3 +--
 fs/partitions/check.c |    9 +++------
 kernel/module.c       |    8 ++------
 3 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/base/class.c b/drivers/base/class.c
index 96def1d..1417e5c 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -163,8 +163,7 @@ int class_register(struct class * cls)
 void class_unregister(struct class * cls)
 {
 	pr_debug("device class '%s': unregistering\n", cls->name);
-	if (cls->virtual_dir)
-		kobject_unregister(cls->virtual_dir);
+	kobject_unregister(cls->virtual_dir);
 	remove_class_attrs(cls);
 	subsystem_unregister(&cls->subsys);
 }
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index ac32a2e..22d38ff 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -358,8 +358,7 @@ void delete_partition(struct gendisk *disk, int part)
 	p->ios[0] = p->ios[1] = 0;
 	p->sectors[0] = p->sectors[1] = 0;
 	sysfs_remove_link(&p->kobj, "subsystem");
-	if (p->holder_dir)
-		kobject_unregister(p->holder_dir);
+	kobject_unregister(p->holder_dir);
 	kobject_uevent(&p->kobj, KOBJ_REMOVE);
 	kobject_del(&p->kobj);
 	kobject_put(&p->kobj);
@@ -603,10 +602,8 @@ void del_gendisk(struct gendisk *disk)
 	disk->stamp = 0;

 	kobject_uevent(&disk->kobj, KOBJ_REMOVE);
-	if (disk->holder_dir)
-		kobject_unregister(disk->holder_dir);
-	if (disk->slave_dir)
-		kobject_unregister(disk->slave_dir);
+	kobject_unregister(disk->holder_dir);
+	kobject_unregister(disk->slave_dir);
 	if (disk->driverfs_dev) {
 		char *disk_name = make_block_name(disk);
 		sysfs_remove_link(&disk->kobj, "device");
diff --git a/kernel/module.c b/kernel/module.c
index 8a94e05..53f10e8 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1174,11 +1174,8 @@ static void mod_kobject_remove(struct module *mod)
 {
 	module_remove_modinfo_attrs(mod);
 	module_param_sysfs_remove(mod);
-	if (mod->mkobj.drivers_dir)
-		kobject_unregister(mod->mkobj.drivers_dir);
-	if (mod->holders_dir)
-		kobject_unregister(mod->holders_dir);
-
+	kobject_unregister(mod->mkobj.drivers_dir);
+	kobject_unregister(mod->holders_dir);
 	kobject_unregister(&mod->mkobj.kobj);
 }

--
1.4.4.4

Regards,

	Mariusz Koz³owski
