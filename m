Return-Path: <linux-kernel-owner+w=401wt.eu-S1757205AbYGNHu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757205AbYGNHu3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 03:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756816AbYGNHth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 03:49:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:36865 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755707AbYGNHtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 03:49:31 -0400
From: Tejun Heo <tj@kernel.org>
To: jens.axboe@oracle.com, James.Bottomley@HansenPartnership.com,
       bharrosh@panasas.com, greg.freemyer@gmail.com,
       linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, liml@rtr.ca,
       viro@ftp.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 09/13] block: kill GENHD_FL_FAIL and use part0->make_it_fail
Date: Mon, 14 Jul 2008 16:48:09 +0900
Message-Id: <1216021693-483-10-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1216021693-483-1-git-send-email-tj@kernel.org>
References: <1216021693-483-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 14 Jul 2008 07:49:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GENHD_FL_FAIL for disk is what make_it_fail is for parts.  Kill it and
use part0->make_it_fail.  Sysfs node handling is unified too.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-core.c      |    5 +++--
 block/genhd.c         |   30 +-----------------------------
 fs/partitions/check.c |   10 +++++-----
 include/linux/genhd.h |    9 +++++++--
 4 files changed, 16 insertions(+), 38 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 511b8c7..332d695 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1262,8 +1262,9 @@ __setup("fail_make_request=", setup_fail_make_request);
 
 static int should_fail_request(struct bio *bio)
 {
-	if ((bio->bi_bdev->bd_disk->flags & GENHD_FL_FAIL) ||
-	    bio->bi_bdev->bd_part->make_it_fail)
+	struct hd_struct *part = bio->bi_bdev->bd_part;
+
+	if (part_to_disk(part)->part0.make_it_fail || part->make_it_fail)
 		return should_fail(&fail_make_request, bio->bi_size);
 
 	return 0;
diff --git a/block/genhd.c b/block/genhd.c
index ff33b8c..21b8535 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -762,34 +762,6 @@ static ssize_t disk_stat_show(struct device *dev,
 		jiffies_to_msecs(disk_stat_read(disk, time_in_queue)));
 }
 
-#ifdef CONFIG_FAIL_MAKE_REQUEST
-static ssize_t disk_fail_show(struct device *dev,
-			      struct device_attribute *attr, char *buf)
-{
-	struct gendisk *disk = dev_to_disk(dev);
-
-	return sprintf(buf, "%d\n", disk->flags & GENHD_FL_FAIL ? 1 : 0);
-}
-
-static ssize_t disk_fail_store(struct device *dev,
-			       struct device_attribute *attr,
-			       const char *buf, size_t count)
-{
-	struct gendisk *disk = dev_to_disk(dev);
-	int i;
-
-	if (count > 0 && sscanf(buf, "%d", &i) > 0) {
-		if (i == 0)
-			disk->flags &= ~GENHD_FL_FAIL;
-		else
-			disk->flags |= GENHD_FL_FAIL;
-	}
-
-	return count;
-}
-
-#endif
-
 static DEVICE_ATTR(range, S_IRUGO, disk_range_show, NULL);
 static DEVICE_ATTR(ext_range, S_IRUGO, disk_ext_range_show, NULL);
 static DEVICE_ATTR(removable, S_IRUGO, disk_removable_show, NULL);
@@ -798,7 +770,7 @@ static DEVICE_ATTR(capability, S_IRUGO, disk_capability_show, NULL);
 static DEVICE_ATTR(stat, S_IRUGO, disk_stat_show, NULL);
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 static struct device_attribute dev_attr_fail =
-	__ATTR(make-it-fail, S_IRUGO|S_IWUSR, disk_fail_show, disk_fail_store);
+	__ATTR(make-it-fail, S_IRUGO|S_IWUSR, part_fail_show, part_fail_store);
 #endif
 
 static struct attribute *disk_attrs[] = {
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 931d366..ddd0258 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -237,17 +237,17 @@ static ssize_t part_stat_show(struct device *dev,
 }
 
 #ifdef CONFIG_FAIL_MAKE_REQUEST
-static ssize_t part_fail_show(struct device *dev,
-			      struct device_attribute *attr, char *buf)
+ssize_t part_fail_show(struct device *dev,
+		       struct device_attribute *attr, char *buf)
 {
 	struct hd_struct *p = dev_to_part(dev);
 
 	return sprintf(buf, "%d\n", p->make_it_fail);
 }
 
-static ssize_t part_fail_store(struct device *dev,
-			       struct device_attribute *attr,
-			       const char *buf, size_t count)
+ssize_t part_fail_store(struct device *dev,
+			struct device_attribute *attr,
+			const char *buf, size_t count)
 {
 	struct hd_struct *p = dev_to_part(dev);
 	int i;
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 8c94f17..61448a9 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -112,8 +112,6 @@ struct hd_struct {
 #define GENHD_FL_CD				8
 #define GENHD_FL_UP				16
 #define GENHD_FL_SUPPRESS_PARTITION_INFO	32
-#define GENHD_FL_FAIL				64
-
 
 struct gendisk {
 	/* major, first_minor, minors and ext_minors are input
@@ -582,6 +580,13 @@ extern void blk_unregister_region(dev_t devt, unsigned long range);
 
 extern ssize_t part_size_show(struct device *dev,
 			      struct device_attribute *attr, char *buf);
+#ifdef CONFIG_FAIL_MAKE_REQUEST
+extern ssize_t part_fail_show(struct device *dev,
+			      struct device_attribute *attr, char *buf);
+extern ssize_t part_fail_store(struct device *dev,
+			       struct device_attribute *attr,
+			       const char *buf, size_t count);
+#endif /* CONFIG_FAIL_MAKE_REQUEST */
 
 #else /* CONFIG_BLOCK */
 
-- 
1.5.4.5

