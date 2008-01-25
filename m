Return-Path: <linux-kernel-owner+w=401wt.eu-S1759601AbYAYHw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759601AbYAYHw6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:52:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761438AbYAYHgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:36:12 -0500
Received: from mx2.suse.de ([195.135.220.15]:49904 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761450AbYAYHgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:36:10 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 094/196] kset: convert block_subsys to use kset_create
Date: Thu, 24 Jan 2008 23:32:03 -0800
Message-Id: <1201246425-5058-15-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dynamically create the kset instead of declaring it statically.  We also
rename block_subsys to block_kset to catch all users of this symbol
with a build error instead of an easy-to-ignore build warning.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 block/genhd.c         |   34 ++++++++++++++++------------------
 fs/partitions/check.c |    6 +++---
 2 files changed, 19 insertions(+), 21 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 32227b7..69aa738 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -17,7 +17,8 @@
 #include <linux/buffer_head.h>
 #include <linux/mutex.h>
 
-struct kset block_subsys;
+struct kset *block_kset;
+static struct kset_uevent_ops block_uevent_ops;
 static DEFINE_MUTEX(block_subsys_lock);
 
 /*
@@ -221,7 +222,7 @@ void __init printk_all_partitions(void)
 
 	mutex_lock(&block_subsys_lock);
 	/* For each block device... */
-	list_for_each_entry(sgp, &block_subsys.list, kobj.entry) {
+	list_for_each_entry(sgp, &block_kset->list, kobj.entry) {
 		char buf[BDEVNAME_SIZE];
 		/*
 		 * Don't show empty devices or things that have been surpressed
@@ -270,7 +271,7 @@ static void *part_start(struct seq_file *part, loff_t *pos)
 	loff_t l = *pos;
 
 	mutex_lock(&block_subsys_lock);
-	list_for_each(p, &block_subsys.list)
+	list_for_each(p, &block_kset->list)
 		if (!l--)
 			return list_entry(p, struct gendisk, kobj.entry);
 	return NULL;
@@ -280,7 +281,7 @@ static void *part_next(struct seq_file *part, void *v, loff_t *pos)
 {
 	struct list_head *p = ((struct gendisk *)v)->kobj.entry.next;
 	++*pos;
-	return p==&block_subsys.list ? NULL :
+	return p==&block_kset->list ? NULL :
 		list_entry(p, struct gendisk, kobj.entry);
 }
 
@@ -295,7 +296,7 @@ static int show_partition(struct seq_file *part, void *v)
 	int n;
 	char buf[BDEVNAME_SIZE];
 
-	if (&sgp->kobj.entry == block_subsys.list.next)
+	if (&sgp->kobj.entry == block_kset->list.next)
 		seq_puts(part, "major minor  #blocks  name\n\n");
 
 	/* Don't show non-partitionable removeable devices or empty devices */
@@ -345,15 +346,14 @@ static struct kobject *base_probe(dev_t dev, int *part, void *data)
 
 static int __init genhd_device_init(void)
 {
-	int err;
-
 	bdev_map = kobj_map_init(base_probe, &block_subsys_lock);
 	blk_dev_init();
-	err = subsystem_register(&block_subsys);
-	if (err < 0)
-		printk(KERN_WARNING "%s: subsystem_register error: %d\n",
-			__FUNCTION__, err);
-	return err;
+	block_kset = kset_create_and_add("block", &block_uevent_ops, NULL);
+	if (!block_kset) {
+		printk(KERN_WARNING "%s: kset_create error\n", __FUNCTION__);
+		return -ENOMEM;
+	}
+	return 0;
 }
 
 subsys_initcall(genhd_device_init);
@@ -584,8 +584,6 @@ static struct kset_uevent_ops block_uevent_ops = {
 	.uevent		= block_uevent,
 };
 
-decl_subsys(block, &block_uevent_ops);
-
 /*
  * aggregate disk stat collector.  Uses the same stats that the sysfs
  * entries do, above, but makes them available through one seq_file.
@@ -603,7 +601,7 @@ static void *diskstats_start(struct seq_file *part, loff_t *pos)
 	struct list_head *p;
 
 	mutex_lock(&block_subsys_lock);
-	list_for_each(p, &block_subsys.list)
+	list_for_each(p, &block_kset->list)
 		if (!k--)
 			return list_entry(p, struct gendisk, kobj.entry);
 	return NULL;
@@ -613,7 +611,7 @@ static void *diskstats_next(struct seq_file *part, void *v, loff_t *pos)
 {
 	struct list_head *p = ((struct gendisk *)v)->kobj.entry.next;
 	++*pos;
-	return p==&block_subsys.list ? NULL :
+	return p==&block_kset->list ? NULL :
 		list_entry(p, struct gendisk, kobj.entry);
 }
 
@@ -629,7 +627,7 @@ static int diskstats_show(struct seq_file *s, void *v)
 	int n = 0;
 
 	/*
-	if (&sgp->kobj.entry == block_subsys.kset.list.next)
+	if (&sgp->kobj.entry == block_kset->list.next)
 		seq_puts(s,	"major minor name"
 				"     rio rmerge rsect ruse wio wmerge "
 				"wsect wuse running use aveq"
@@ -721,7 +719,7 @@ struct gendisk *alloc_disk_node(int minors, int node_id)
 			}
 		}
 		disk->minors = minors;
-		disk->kobj.kset = &block_subsys;
+		disk->kobj.kset = block_kset;
 		disk->kobj.ktype = &ktype_block;
 		kobject_init(&disk->kobj);
 		rand_initialize_disk(disk);
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 69685bb..9184215 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -316,7 +316,7 @@ static struct attribute * default_attrs[] = {
 	NULL,
 };
 
-extern struct kset block_subsys;
+extern struct kset *block_kset;
 
 static void part_release(struct kobject *kobj)
 {
@@ -393,7 +393,7 @@ void add_partition(struct gendisk *disk, int part, sector_t start, sector_t len,
 	kobject_add(&p->kobj);
 	if (!disk->part_uevent_suppress)
 		kobject_uevent(&p->kobj, KOBJ_ADD);
-	sysfs_create_link(&p->kobj, &block_subsys.kobj, "subsystem");
+	sysfs_create_link(&p->kobj, &block_kset->kobj, "subsystem");
 	if (flags & ADDPART_FLAG_WHOLEDISK) {
 		static struct attribute addpartattr = {
 			.name = "whole_disk",
@@ -448,7 +448,7 @@ static int disk_sysfs_symlinks(struct gendisk *disk)
 			goto err_out_dev_link;
 	}
 
-	err = sysfs_create_link(&disk->kobj, &block_subsys.kobj,
+	err = sysfs_create_link(&disk->kobj, &block_kset->kobj,
 				"subsystem");
 	if (err)
 		goto err_out_disk_name_lnk;
-- 
1.5.3.8

