Return-Path: <linux-kernel-owner+w=401wt.eu-S1755917AbZFUV7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917AbZFUV7q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 17:59:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753970AbZFUV7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 17:59:36 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:39009 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818AbZFUV7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 17:59:35 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH] MD: md, fix lock imbalance
Date: Sun, 21 Jun 2009 23:59:36 +0200
Message-Id: <1245621576-27066-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add unlock and put to one of fail paths in md_alloc.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/md/md.c |   26 +++++++++++++++-----------
 1 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 0f11fd1..6264933 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3833,7 +3833,7 @@ static int md_alloc(dev_t dev, char *name)
 	int partitioned;
 	int shift;
 	int unit;
-	int error;
+	int error, ret;
 
 	if (!mddev)
 		return -ENODEV;
@@ -3849,9 +3849,8 @@ static int md_alloc(dev_t dev, char *name)
 
 	mutex_lock(&disks_mutex);
 	if (mddev->gendisk) {
-		mutex_unlock(&disks_mutex);
-		mddev_put(mddev);
-		return -EEXIST;
+		ret = -EEXIST;
+		goto unlock;
 	}
 
 	if (name) {
@@ -3864,16 +3863,16 @@ static int md_alloc(dev_t dev, char *name)
 			if (mddev2->gendisk &&
 			    strcmp(mddev2->gendisk->disk_name, name) == 0) {
 				spin_unlock(&all_mddevs_lock);
-				return -EEXIST;
+				ret = -EEXIST;
+				goto unlock;
 			}
 		spin_unlock(&all_mddevs_lock);
 	}
 
 	mddev->queue = blk_alloc_queue(GFP_KERNEL);
 	if (!mddev->queue) {
-		mutex_unlock(&disks_mutex);
-		mddev_put(mddev);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto unlock;
 	}
 	mddev->queue->queuedata = mddev;
 
@@ -3887,8 +3886,8 @@ static int md_alloc(dev_t dev, char *name)
 		mutex_unlock(&disks_mutex);
 		blk_cleanup_queue(mddev->queue);
 		mddev->queue = NULL;
-		mddev_put(mddev);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto put;
 	}
 	disk->major = MAJOR(mddev->unit);
 	disk->first_minor = unit << shift;
@@ -3918,8 +3917,13 @@ static int md_alloc(dev_t dev, char *name)
 		kobject_uevent(&mddev->kobj, KOBJ_ADD);
 		mddev->sysfs_state = sysfs_get_dirent(mddev->kobj.sd, "array_state");
 	}
+	ret = 0;
+put:
 	mddev_put(mddev);
-	return 0;
+	return ret;
+unlock:
+	mutex_unlock(&disks_mutex);
+	goto put;
 }
 
 static struct kobject *md_probe(dev_t dev, int *part, void *data)
-- 
1.6.3.2

