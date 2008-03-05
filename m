Return-Path: <linux-kernel-owner+w=401wt.eu-S1761895AbYCERfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761895AbYCERfu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 12:35:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755411AbYCERfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 12:35:34 -0500
Received: from sacred.ru ([62.205.161.221]:34511 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757836AbYCERfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 12:35:31 -0500
Message-ID: <47CED9A3.2050508@openvz.org>
Date: Wed, 05 Mar 2008 20:34:27 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Paul Menage <menage@google.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>
Subject: [PATCH 4/9] Make kobj_lookup() return the mapping's permissions
References: <47CED717.60406@openvz.org>
In-Reply-To: <47CED717.60406@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Wed, 05 Mar 2008 20:34:19 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kobj_lookup() searches the kobject by its dev_t. Since this
mapping is going to be restricted with permissions, make the
kobj_lookup() return the mapping's permissions.

Currently the mode returned is unused.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---
 block/genhd.c            |    4 ++--
 drivers/base/map.c       |    8 ++++++--
 fs/block_dev.c           |    3 ++-
 fs/char_dev.c            |    4 +++-
 include/linux/genhd.h    |    2 +-
 include/linux/kobj_map.h |    2 +-
 6 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 9a7a903..1d1d0f2 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -210,12 +210,12 @@ void unlink_gendisk(struct gendisk *disk)
  * This function gets the structure containing partitioning
  * information for the given device @dev.
  */
-struct gendisk *get_gendisk(dev_t devt, int *part)
+struct gendisk *get_gendisk(dev_t devt, mode_t *mode, int *part)
 {
 	struct kobject *kobj;
 	struct device *dev;
 
-	kobj = kobj_lookup(bdev_map, devt, part);
+	kobj = kobj_lookup(bdev_map, devt, mode, part);
 	if (kobj == NULL)
 		return NULL;
 
diff --git a/drivers/base/map.c b/drivers/base/map.c
index c7e28a1..285a2d2 100644
--- a/drivers/base/map.c
+++ b/drivers/base/map.c
@@ -117,7 +117,8 @@ void kobj_unmap(struct kobj_map *domain, dev_t dev, unsigned long range)
 	kfree(found);
 }
 
-struct kobject *kobj_lookup(struct kobj_map *domain, dev_t dev, int *index)
+struct kobject *kobj_lookup(struct kobj_map *domain, dev_t dev, mode_t *mode,
+		int *index)
 {
 	struct kobject *kobj;
 	struct probe *p;
@@ -149,8 +150,11 @@ retry:
 		kobj = probe(dev, index, data);
 		/* Currently ->owner protects _only_ ->probe() itself. */
 		module_put(owner);
-		if (kobj)
+		if (kobj) {
+			if (mode)
+				*mode = p->mode;
 			return kobj;
+		}
 		goto retry;
 	}
 	mutex_unlock(domain->lock);
diff --git a/fs/block_dev.c b/fs/block_dev.c
index a0e9596..00dda91 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -934,11 +934,12 @@ static int do_open(struct block_device *bdev, struct file *file, int for_part)
 	struct module *owner = NULL;
 	struct gendisk *disk;
 	int ret = -ENXIO;
+	mode_t mode;
 	int part;
 
 	file->f_mapping = bdev->bd_inode->i_mapping;
 	lock_kernel();
-	disk = get_gendisk(bdev->bd_dev, &part);
+	disk = get_gendisk(bdev->bd_dev, &mode, &part);
 	if (!disk) {
 		unlock_kernel();
 		bdput(bdev);
diff --git a/fs/char_dev.c b/fs/char_dev.c
index 68e510b..dceb579 100644
--- a/fs/char_dev.c
+++ b/fs/char_dev.c
@@ -367,8 +367,10 @@ static int chrdev_open(struct inode *inode, struct file *filp)
 	if (!p) {
 		struct kobject *kobj;
 		int idx;
+		mode_t mode;
+
 		spin_unlock(&cdev_lock);
-		kobj = kobj_lookup(cdev_map, inode->i_rdev, &idx);
+		kobj = kobj_lookup(cdev_map, inode->i_rdev, &mode, &idx);
 		if (!kobj)
 			return -ENXIO;
 		new = container_of(kobj, struct cdev, kobj);
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 09a3b18..e09df44 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -371,7 +371,7 @@ extern int get_blkdev_list(char *, int);
 extern void add_disk(struct gendisk *disk);
 extern void del_gendisk(struct gendisk *gp);
 extern void unlink_gendisk(struct gendisk *gp);
-extern struct gendisk *get_gendisk(dev_t dev, int *part);
+extern struct gendisk *get_gendisk(dev_t dev, mode_t *mode, int *part);
 
 extern void set_device_ro(struct block_device *bdev, int flag);
 extern void set_disk_ro(struct gendisk *disk, int flag);
diff --git a/include/linux/kobj_map.h b/include/linux/kobj_map.h
index bafe178..867f307 100644
--- a/include/linux/kobj_map.h
+++ b/include/linux/kobj_map.h
@@ -8,7 +8,7 @@ struct kobj_map;
 int kobj_map(struct kobj_map *, dev_t, unsigned long, struct module *,
 	     kobj_probe_t *, int (*)(dev_t, void *), void *);
 void kobj_unmap(struct kobj_map *, dev_t, unsigned long);
-struct kobject *kobj_lookup(struct kobj_map *, dev_t, int *);
+struct kobject *kobj_lookup(struct kobj_map *, dev_t, mode_t *, int *);
 struct kobj_map *kobj_map_init(kobj_probe_t *, struct mutex *);
 
 #endif
-- 
1.5.3.4

