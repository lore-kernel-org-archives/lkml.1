Return-Path: <linux-kernel-owner+w=401wt.eu-S1760013AbYCERvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760013AbYCERvo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 12:51:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752363AbYCERve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 12:51:34 -0500
Received: from sacred.ru ([62.205.161.221]:54543 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751357AbYCERvd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 12:51:33 -0500
Message-ID: <47CEDA64.1070506@openvz.org>
Date: Wed, 05 Mar 2008 20:37:40 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Paul Menage <menage@google.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>
Subject: [PATCH 5/9] Make use of permissions, returned by kobj_lookup
References: <47CED717.60406@openvz.org>
In-Reply-To: <47CED717.60406@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Wed, 05 Mar 2008 20:37:32 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now check the requesting permissions against the granted
(with the dev_t-to-kobj map) ones.

The tricky place is chrdev_open - it caches the struct cdev
on inode and thus, we have to perform lookup each time
if we are in a restricted mapping.

The task_cdev_map and task_bdev_map provide the map which
the current task is in, but now they just return NULL, which
means, that the task is not in any.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---
 block/genhd.c               |    8 +++++++-
 fs/block_dev.c              |    8 ++++++++
 fs/char_dev.c               |   18 ++++++++++++++++--
 include/linux/devscontrol.h |   12 ++++++++++++
 4 files changed, 43 insertions(+), 3 deletions(-)
 create mode 100644 include/linux/devscontrol.h

diff --git a/block/genhd.c b/block/genhd.c
index 1d1d0f2..a619158 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -8,6 +8,7 @@
 #include <linux/kdev_t.h>
 #include <linux/kernel.h>
 #include <linux/blkdev.h>
+#include <linux/devscontrol.h>
 #include <linux/init.h>
 #include <linux/spinlock.h>
 #include <linux/seq_file.h>
@@ -212,10 +213,15 @@ void unlink_gendisk(struct gendisk *disk)
  */
 struct gendisk *get_gendisk(dev_t devt, mode_t *mode, int *part)
 {
+	struct kobj_map *map;
 	struct kobject *kobj;
 	struct device *dev;
 
-	kobj = kobj_lookup(bdev_map, devt, mode, part);
+	map = task_bdev_map(current);
+	if (map == NULL)
+		map = bdev_map;
+
+	kobj = kobj_lookup(map, devt, mode, part);
 	if (kobj == NULL)
 		return NULL;
 
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 00dda91..34dc607 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -945,6 +945,14 @@ static int do_open(struct block_device *bdev, struct file *file, int for_part)
 		bdput(bdev);
 		return ret;
 	}
+
+	if ((file->f_mode & mode) != file->f_mode) {
+		unlock_kernel();
+		bdput(bdev);
+		put_disk(disk);
+		return -EACCES;
+	}
+
 	owner = disk->fops->owner;
 
 	mutex_lock_nested(&bdev->bd_mutex, for_part);
diff --git a/fs/char_dev.c b/fs/char_dev.c
index dceb579..d042446 100644
--- a/fs/char_dev.c
+++ b/fs/char_dev.c
@@ -22,6 +22,8 @@
 #include <linux/mutex.h>
 #include <linux/backing-dev.h>
 
+#include <linux/devscontrol.h>
+
 #ifdef CONFIG_KMOD
 #include <linux/kmod.h>
 #endif
@@ -361,19 +363,31 @@ static int chrdev_open(struct inode *inode, struct file *filp)
 	struct cdev *p;
 	struct cdev *new = NULL;
 	int ret = 0;
+	struct kobj_map *map;
+
+	map = task_cdev_map(current);
+	if (map == NULL)
+		map = cdev_map;
 
 	spin_lock(&cdev_lock);
 	p = inode->i_cdev;
-	if (!p) {
+	if (!p || map != cdev_map) {
 		struct kobject *kobj;
 		int idx;
 		mode_t mode;
 
 		spin_unlock(&cdev_lock);
-		kobj = kobj_lookup(cdev_map, inode->i_rdev, &mode, &idx);
+		kobj = kobj_lookup(map, inode->i_rdev, &mode, &idx);
 		if (!kobj)
 			return -ENXIO;
 		new = container_of(kobj, struct cdev, kobj);
+		BUG_ON(p != NULL && p != new);
+
+		if ((filp->f_mode & mode) != filp->f_mode) {
+			cdev_put(new);
+			return -EACCES;
+		}
+
 		spin_lock(&cdev_lock);
 		p = inode->i_cdev;
 		if (!p) {
diff --git a/include/linux/devscontrol.h b/include/linux/devscontrol.h
new file mode 100644
index 0000000..04c168b
--- /dev/null
+++ b/include/linux/devscontrol.h
@@ -0,0 +1,12 @@
+#ifndef __DEVS_CONTROL_H__
+#define __DEVS_CONTROL_H__
+static inline struct kobj_map *task_cdev_map(struct task_struct *tsk)
+{
+	return NULL;
+}
+
+static inline struct kobj_map *task_bdev_map(struct task_struct *tsk)
+{
+	return NULL;
+}
+#endif
-- 
1.5.3.4

