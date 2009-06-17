Return-Path: <linux-kernel-owner+w=401wt.eu-S1756117AbZFQG7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117AbZFQG7n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 02:59:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754232AbZFQG7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 02:59:36 -0400
Received: from cantor.suse.de ([195.135.220.2]:44029 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753904AbZFQG7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 02:59:36 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] Fix error handling in add_disk
Date: Wed, 17 Jun 2009 12:31:10 +0530
User-Agent: KMail/1.11.1 (Linux/2.6.27.23-0.1-default; KDE/4.2.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906171231.10438.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix error handling in add_disk. Also add WARN_ON()'s in case
of error, which can be removed once the callers handle the error.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

diff --git a/block/genhd.c b/block/genhd.c
index fe7ccc0..555cbbe 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -472,11 +472,11 @@ static char *bdevt_str(dev_t devt, char *buf)
  * range must be nonzero
  * The hash chain is sorted on range, so that subranges can override.
  */
-void blk_register_region(dev_t devt, unsigned long range, struct module *module,
+int blk_register_region(dev_t devt, unsigned long range, struct module *module,
 			 struct kobject *(*probe)(dev_t, int *, void *),
 			 int (*lock)(dev_t, void *), void *data)
 {
-	kobj_map(bdev_map, devt, range, module, probe, lock, data);
+	return kobj_map(bdev_map, devt, range, module, probe, lock, data);
 }
 
 EXPORT_SYMBOL(blk_register_region);
@@ -511,9 +511,9 @@ static int exact_lock(dev_t devt, void *data)
  * This function registers the partitioning information in @disk
  * with the kernel.
  *
- * FIXME: error handling
+ * TODO: Remove WARN_ON()'s when all the callers handle the error.
  */
-void add_disk(struct gendisk *disk)
+int add_disk(struct gendisk *disk)
 {
 	struct backing_dev_info *bdi;
 	dev_t devt;
@@ -531,7 +531,7 @@ void add_disk(struct gendisk *disk)
 	retval = blk_alloc_devt(&disk->part0, &devt);
 	if (retval) {
 		WARN_ON(1);
-		return;
+		goto err_out;
 	}
 	disk_to_dev(disk)->devt = devt;
 
@@ -541,16 +541,40 @@ void add_disk(struct gendisk *disk)
 	disk->major = MAJOR(devt);
 	disk->first_minor = MINOR(devt);
 
-	blk_register_region(disk_devt(disk), disk->minors, NULL,
+	retval = blk_register_region(disk_devt(disk), disk->minors, NULL,
 			    exact_match, exact_lock, disk);
+	if (retval) {
+		WARN_ON(1);
+		goto err_free_devt;
+	}
+
 	register_disk(disk);
-	blk_register_queue(disk);
+
+	retval = blk_register_queue(disk);
+	if (retval) {
+		WARN_ON(1);
+		goto err_free_region;
+	}
 
 	bdi = &disk->queue->backing_dev_info;
 	bdi_register_dev(bdi, disk_devt(disk));
 	retval = sysfs_create_link(&disk_to_dev(disk)->kobj, &bdi->dev->kobj,
 				   "bdi");
-	WARN_ON(retval);
+	if (retval) {
+		WARN_ON(1);
+		goto err_free_queue;
+	}
+
+	return 0;
+
+err_free_queue:
+	blk_unregister_queue(disk);
+err_free_region:
+	blk_unregister_region(disk_devt(disk), disk->minors);
+err_free_devt:
+	blk_free_devt(disk_devt(disk));
+err_out:
+	return retval;
 }
 
 EXPORT_SYMBOL(add_disk);
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 149fda2..df3344a 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -339,7 +339,7 @@ static inline void part_dec_in_flight(struct hd_struct *part)
 extern void part_round_stats(int cpu, struct hd_struct *part);
 
 /* block/genhd.c */
-extern void add_disk(struct gendisk *disk);
+extern int add_disk(struct gendisk *disk);
 extern void del_gendisk(struct gendisk *gp);
 extern void unlink_gendisk(struct gendisk *gp);
 extern struct gendisk *get_gendisk(dev_t dev, int *partno);
@@ -534,7 +534,7 @@ extern struct gendisk *alloc_disk_node(int minors, int node_id);
 extern struct gendisk *alloc_disk(int minors);
 extern struct kobject *get_disk(struct gendisk *disk);
 extern void put_disk(struct gendisk *disk);
-extern void blk_register_region(dev_t devt, unsigned long range,
+extern int blk_register_region(dev_t devt, unsigned long range,
 			struct module *module,
 			struct kobject *(*probe)(dev_t, int *, void *),
 			int (*lock)(dev_t, void *),

