Return-Path: <linux-kernel-owner+w=401wt.eu-S1753965AbYKUEcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965AbYKUEcR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 23:32:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752588AbYKUEb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 23:31:58 -0500
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:38518 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338AbYKUEb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 23:31:57 -0500
From: hooanon05@yahoo.co.jp
Subject: [PATCH v2] loop file resizable 
To: Andrew Morton <akpm@linux-foundation.org>
Cc: tomas@slax.org, linux-kernel@vger.kernel.org, akinobu.mita@gmail.com,
       util-linux-ng@vger.kernel.org
In-Reply-To: <20081120132654.4c649eb0.akpm@linux-foundation.org>
References: <492120DC.1070407@slax.org> <20081118164207.137e92be.akpm@linux-foundation.org> <16149.1227066661@jrobl> <20081120132654.4c649eb0.akpm@linux-foundation.org>
Date: Fri, 21 Nov 2008 13:31:45 +0900
Message-ID: <12362.1227241905@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Revise the patch to be available to the latest linux-2.6.git tree.

----------------------------------------------------------------------
Add the ability to 'resize' the loop device on the fly.
This may be practically very useful.

One practical application is a loop file with XFS filesystem, already mounted:
You can easily enlarge the file (append some bytes) and then call
ioctl(fd, LOOP_SET_CAPACITY, new);
The loop driver will learn about the new size and you can use xfs_growfs
later on, which will allow you to use full capacity of the loop
file without the need to unmount.

Signed-off-by: J. R. Okajima <hooanon05@yahoo.co.jp>
Signed-off-by: Tomas Matejicek <tomas@slax.org>
---
 drivers/block/loop.c |   26 ++++++++++++++++++++++++++
 include/linux/loop.h |    1 +
 2 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 5c4ee70..a034bf9 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1137,6 +1137,28 @@ loop_get_status64(struct loop_device *lo, struct loop_info64 __user *arg) {
 	return err;
 }
 
+static int loop_set_capacity(struct loop_device *lo, struct block_device *bdev)
+{
+	int err;
+	sector_t sec;
+	loff_t sz;
+
+	err = -ENXIO;
+	if (unlikely(lo->lo_state != Lo_bound))
+		goto out;
+	err = figure_loop_size(lo);
+	if (unlikely(err))
+		goto out;
+	sec = get_capacity(lo->lo_disk);
+	sz = sec << 9;
+	mutex_lock(&bdev->bd_mutex);
+	bd_set_size(bdev, sz);
+	mutex_unlock(&bdev->bd_mutex);
+
+ out:
+	return err;
+}
+
 static int lo_ioctl(struct block_device *bdev, fmode_t mode,
 	unsigned int cmd, unsigned long arg)
 {
@@ -1166,6 +1188,9 @@ static int lo_ioctl(struct block_device *bdev, fmode_t mode,
 	case LOOP_GET_STATUS64:
 		err = loop_get_status64(lo, (struct loop_info64 __user *) arg);
 		break;
+	case LOOP_SET_CAPACITY:
+		err = loop_set_capacity(lo, bdev);
+		break;
 	default:
 		err = lo->ioctl ? lo->ioctl(lo, cmd, arg) : -EINVAL;
 	}
@@ -1311,6 +1336,7 @@ static int lo_compat_ioctl(struct block_device *bdev, fmode_t mode,
 			lo, (struct compat_loop_info __user *) arg);
 		mutex_unlock(&lo->lo_ctl_mutex);
 		break;
+	case LOOP_SET_CAPACITY:
 	case LOOP_CLR_FD:
 	case LOOP_GET_STATUS64:
 	case LOOP_SET_STATUS64:
diff --git a/include/linux/loop.h b/include/linux/loop.h
index 46169a7..e9e002a 100644
--- a/include/linux/loop.h
+++ b/include/linux/loop.h
@@ -160,5 +160,6 @@ int loop_unregister_transfer(int number);
 #define LOOP_SET_STATUS64	0x4C04
 #define LOOP_GET_STATUS64	0x4C05
 #define LOOP_CHANGE_FD		0x4C06
+#define LOOP_SET_CAPACITY	0x4C07
 
 #endif
-- 
