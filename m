Return-Path: <linux-kernel-owner+w=401wt.eu-S1754115AbYKQH6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115AbYKQH6b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 02:58:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752085AbYKQH6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 02:58:21 -0500
Received: from mail4customers.bluetone.cz ([212.158.128.5]:57418 "EHLO
	mail.bluetone.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751630AbYKQH6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 02:58:20 -0500
X-Greylist: delayed 898 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Nov 2008 02:58:20 EST
Message-ID: <492120DC.1070407@slax.org>
Date: Mon, 17 Nov 2008 08:44:28 +0100
From: Tomas M <tomas@slax.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] loop file resizable
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch against loop.c adds ability to 'resize' the loop device on the fly.
This may be practically very useful.

One practical application is a loop file with XFS filesystem, already mounted:
You can easily enlarge the file (append some bytes) and then call
ioctl(fd, LOOP_SET_CAPACITY, new);
The loop driver will learn about the new size and you can use xfs_growfs
later on, which will allow you to use full capacity of the loop
file without the need to unmount.

Please include it in mainline kernel.

Hope you like it.

Signed-off-by: Junjiro Okajima <hooanon05@yahoo.co.jp>
Signed-off-by: Tomas Matejicek <tomas@slax.org>

Tomas M
slax.org


Index: linux-2.6.27/drivers/block/loop.c
===================================================================
retrieving revision 1.1
diff -u -p -r1.1 loop.c
--- linux-2.6.27/drivers/block/loop.c	7 Nov 2008 13:07:06 -0000	1.1
+++ linux-2.6.27/drivers/block/loop.c	8 Nov 2008 03:29:47 -0000
@@ -1142,6 +1142,8 @@ static int lo_ioctl(struct inode * inode
 {
 	struct loop_device *lo = inode->i_bdev->bd_disk->private_data;
 	int err;
+	sector_t sec;
+	loff_t sz;
 
 	mutex_lock(&lo->lo_ctl_mutex);
 	switch (cmd) {
@@ -1166,6 +1168,16 @@ static int lo_ioctl(struct inode * inode
 	case LOOP_GET_STATUS64:
 		err = loop_get_status64(lo, (struct loop_info64 __user *) arg);
 		break;
+	case LOOP_SET_CAPACITY:
+		err = figure_loop_size(lo);
+		if (!err) {
+			sec = get_capacity(lo->lo_disk);
+			sz = sec << 9;
+			mutex_lock(&inode->i_bdev->bd_mutex);
+			bd_set_size(inode->i_bdev, sz);
+			mutex_unlock(&inode->i_bdev->bd_mutex);
+		}
+		break;
 	default:
 		err = lo->ioctl ? lo->ioctl(lo, cmd, arg) : -EINVAL;
 	}
@@ -1311,6 +1323,7 @@ static long lo_compat_ioctl(struct file 
 			lo, (struct compat_loop_info __user *) arg);
 		mutex_unlock(&lo->lo_ctl_mutex);
 		break;
+	case LOOP_SET_CAPACITY:
 	case LOOP_CLR_FD:
 	case LOOP_GET_STATUS64:
 	case LOOP_SET_STATUS64:
Index: linux-2.6.27/include/linux/loop.h
===================================================================
retrieving revision 1.1
diff -u -p -r1.1 loop.h
--- linux-2.6.27/include/linux/loop.h	7 Nov 2008 13:05:58 -0000	1.1
+++ linux-2.6.27/include/linux/loop.h	8 Nov 2008 03:22:36 -0000
@@ -160,5 +160,6 @@ int loop_unregister_transfer(int number)
 #define LOOP_SET_STATUS64	0x4C04
 #define LOOP_GET_STATUS64	0x4C05
 #define LOOP_CHANGE_FD		0x4C06
+#define LOOP_SET_CAPACITY	0x4C07
 
 #endif
