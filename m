Return-Path: <linux-kernel-owner+w=401wt.eu-S1760949AbYAYHap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760949AbYAYHap (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:30:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759045AbYAYHQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:16:59 -0500
Received: from ns2.suse.de ([195.135.220.15]:47590 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759022AbYAYHQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:16:58 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 046/196] kobject: get rid of kobject_add_dir
Date: Thu, 24 Jan 2008 23:09:44 -0800
Message-Id: <1201245134-4876-46-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kobject_create_and_add is the same as kobject_add_dir, so drop
kobject_add_dir.


Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/core.c     |    3 ++-
 fs/partitions/check.c   |    6 +++---
 include/linux/kobject.h |    1 -
 kernel/module.c         |    6 +++---
 lib/kobject.c           |   12 ------------
 5 files changed, 8 insertions(+), 20 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index c8f2ac0..992eba3 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -562,7 +562,8 @@ static struct kobject *virtual_device_parent(struct device *dev)
 	static struct kobject *virtual_dir = NULL;
 
 	if (!virtual_dir)
-		virtual_dir = kobject_add_dir(&devices_subsys.kobj, "virtual");
+		virtual_dir = kobject_create_and_add("virtual",
+						     &devices_subsys.kobj);
 
 	return virtual_dir;
 }
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 722e12e..69685bb 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -335,7 +335,7 @@ static inline void partition_sysfs_add_subdir(struct hd_struct *p)
 	struct kobject *k;
 
 	k = kobject_get(&p->kobj);
-	p->holder_dir = kobject_add_dir(k, "holders");
+	p->holder_dir = kobject_create_and_add("holders", k);
 	kobject_put(k);
 }
 
@@ -344,8 +344,8 @@ static inline void disk_sysfs_add_subdirs(struct gendisk *disk)
 	struct kobject *k;
 
 	k = kobject_get(&disk->kobj);
-	disk->holder_dir = kobject_add_dir(k, "holders");
-	disk->slave_dir = kobject_add_dir(k, "slaves");
+	disk->holder_dir = kobject_create_and_add("holders", k);
+	disk->slave_dir = kobject_create_and_add("slaves", k);
 	kobject_put(k);
 }
 
diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index 33e7a61..7b09136 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -105,7 +105,6 @@ extern void kobject_put(struct kobject *);
 
 extern struct kobject *kobject_kset_add_dir(struct kset *kset,
 					    struct kobject *, const char *);
-extern struct kobject *kobject_add_dir(struct kobject *, const char *);
 
 extern char * kobject_get_path(struct kobject *, gfp_t);
 
diff --git a/kernel/module.c b/kernel/module.c
index 68df797..5514277 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1122,7 +1122,7 @@ static void add_notes_attrs(struct module *mod, unsigned int nsect,
 		++loaded;
 	}
 
-	notes_attrs->dir = kobject_add_dir(&mod->mkobj.kobj, "notes");
+	notes_attrs->dir = kobject_create_and_add("notes", &mod->mkobj.kobj);
 	if (!notes_attrs->dir)
 		goto out;
 
@@ -1243,7 +1243,7 @@ int mod_sysfs_setup(struct module *mod,
 	if (err)
 		goto out;
 
-	mod->holders_dir = kobject_add_dir(&mod->mkobj.kobj, "holders");
+	mod->holders_dir = kobject_create_and_add("holders", &mod->mkobj.kobj);
 	if (!mod->holders_dir) {
 		err = -ENOMEM;
 		goto out_unreg;
@@ -2521,7 +2521,7 @@ static void module_create_drivers_dir(struct module_kobject *mk)
 	if (!mk || mk->drivers_dir)
 		return;
 
-	mk->drivers_dir = kobject_add_dir(&mk->kobj, "drivers");
+	mk->drivers_dir = kobject_create_and_add("drivers", &mk->kobj);
 }
 
 void module_add_driver(struct module *mod, struct device_driver *drv)
diff --git a/lib/kobject.c b/lib/kobject.c
index 98422a3..96b61d9 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -713,18 +713,6 @@ struct kobject *kobject_kset_add_dir(struct kset *kset,
 }
 
 /**
- *	kobject_add_dir - add sub directory of object.
- *	@parent:	object in which a directory is created.
- *	@name:	directory name.
- *
- *	Add a plain directory object as child of given object.
- */
-struct kobject *kobject_add_dir(struct kobject *parent, const char *name)
-{
-	return kobject_create_and_add(name, parent);
-}
-
-/**
  *	kset_init - initialize a kset for use
  *	@k:	kset 
  */
-- 
1.5.3.8

