Return-Path: <linux-kernel-owner+w=401wt.eu-S1754760AbZAJGh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbZAJGh2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 01:37:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751005AbZAJGhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 01:37:14 -0500
Received: from mail00d.mail.t-online.hu ([84.2.42.5]:56660 "EHLO
	mail00d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbZAJGhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 01:37:13 -0500
Message-ID: <49684215.40307@freemail.hu>
Date: Sat, 10 Jan 2009 07:37:09 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] block: validate parameters of exported functions
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail00d.mail.t-online.hu 32721; Body=2 Fuz1=2
	Fuz2=2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

Check the parameters of the exported functions in genhd.c agains NULL.
The checks are done with BUG_ON() so they will only act if CONFIG_BUG=y.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
--- linux-2.6.28/block/genhd.c.orig	2008-12-25 00:26:37.000000000 +0100
+++ linux-2.6.28/block/genhd.c	2009-01-10 07:12:45.000000000 +0100
@@ -58,6 +58,7 @@ struct hd_struct *disk_get_part(struct g

 	if (unlikely(partno < 0))
 		return NULL;
+	BUG_ON(!disk);

 	rcu_read_lock();

@@ -90,6 +91,9 @@ void disk_part_iter_init(struct disk_par
 {
 	struct disk_part_tbl *ptbl;

+	BUG_ON(!piter);
+	BUG_ON(!disk);
+
 	rcu_read_lock();
 	ptbl = rcu_dereference(disk->part_tbl);

@@ -123,6 +127,8 @@ struct hd_struct *disk_part_iter_next(st
 	struct disk_part_tbl *ptbl;
 	int inc, end;

+	BUG_ON(!piter);
+
 	/* put the last partition */
 	disk_put_part(piter->part);
 	piter->part = NULL;
@@ -176,6 +182,7 @@ EXPORT_SYMBOL_GPL(disk_part_iter_next);
  */
 void disk_part_iter_exit(struct disk_part_iter *piter)
 {
+	BUG_ON(!piter);
 	disk_put_part(piter->part);
 	piter->part = NULL;
 }
@@ -201,6 +208,8 @@ struct hd_struct *disk_map_sector_rcu(st
 	struct disk_part_tbl *ptbl;
 	int i;

+	BUG_ON(!disk);
+
 	ptbl = rcu_dereference(disk->part_tbl);

 	for (i = 1; i < ptbl->len; i++) {
@@ -375,6 +384,9 @@ int blk_alloc_devt(struct hd_struct *par
 	struct gendisk *disk = part_to_disk(part);
 	int idx, rc;

+	BUG_ON(!part);
+	BUG_ON(!devt);
+
 	/* in consecutive minor range? */
 	if (part->partno < disk->minors) {
 		*devt = MKDEV(disk->major, disk->first_minor + part->partno);
@@ -487,6 +499,8 @@ void add_disk(struct gendisk *disk)
 	dev_t devt;
 	int retval;

+	BUG_ON(!disk);
+
 	/* minors == 0 indicates to use ext devt from part0 and should
 	 * be accompanied with EXT_DEVT flag.  Make sure all
 	 * parameters make sense.
@@ -526,6 +540,8 @@ EXPORT_SYMBOL(del_gendisk);	/* in partit

 void unlink_gendisk(struct gendisk *disk)
 {
+	BUG_ON(!disk);
+	BUG_ON(!disk->queue);
 	sysfs_remove_link(&disk_to_dev(disk)->kobj, "bdi");
 	bdi_unregister(&disk->queue->backing_dev_info);
 	blk_unregister_queue(disk);
@@ -544,6 +560,8 @@ struct gendisk *get_gendisk(dev_t devt,
 {
 	struct gendisk *disk = NULL;

+	BUG_ON(!partno);
+
 	if (MAJOR(devt) != BLOCK_EXT_MAJOR) {
 		struct kobject *kobj;

@@ -1127,6 +1145,8 @@ struct kobject *get_disk(struct gendisk
 	struct module *owner;
 	struct kobject *kobj;

+	BUG_ON(!disk);
+
 	if (!disk->fops)
 		return NULL;
 	owner = disk->fops->owner;
@@ -1153,6 +1173,7 @@ EXPORT_SYMBOL(put_disk);

 void set_device_ro(struct block_device *bdev, int flag)
 {
+	BUG_ON(!bdev);
 	bdev->bd_part->policy = flag;
 }

