Return-Path: <linux-kernel-owner+w=401wt.eu-S1752377AbYKSDvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377AbYKSDvX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 22:51:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751483AbYKSDvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 22:51:14 -0500
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:57299 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbYKSDvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 22:51:14 -0500
From: hooanon05@yahoo.co.jp
Subject: Re: [PATCH] loop file resizable 
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tomas M <tomas@slax.org>, linux-kernel@vger.kernel.org,
       Akinobu Mita <akinobu.mita@gmail.com>
In-Reply-To: <20081118164207.137e92be.akpm@linux-foundation.org>
References: <492120DC.1070407@slax.org> <20081118164207.137e92be.akpm@linux-foundation.org>
Date: Wed, 19 Nov 2008 12:51:01 +0900
Message-ID: <16149.1227066661@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Andrew Morton:
> > --- linux-2.6.27/drivers/block/loop.c	7 Nov 2008 13:07:06 -0000	1.1
> > +++ linux-2.6.27/drivers/block/loop.c	8 Nov 2008 03:29:47 -0000
> > @@ -1142,6 +1142,8 @@ static int lo_ioctl(struct inode * inode
> >  {
> >  	struct loop_device *lo = inode->i_bdev->bd_disk->private_data;
> >  	int err;
> > +	sector_t sec;
> > +	loff_t sz;
> >  
> >  	mutex_lock(&lo->lo_ctl_mutex);
> >  	switch (cmd) {
> > @@ -1166,6 +1168,16 @@ static int lo_ioctl(struct inode * inode
> >  	case LOOP_GET_STATUS64:
> >  		err = loop_get_status64(lo, (struct loop_info64 __user *) arg);
> >  		break;
> > +	case LOOP_SET_CAPACITY:
> > +		err = figure_loop_size(lo);
> > +		if (!err) {
> 
> It would be neater to declare `sec' and `sz' here.

Here is the updated one.
- new function loop_set_capacity().
- return an error when the backend file is not set.


J. R. Okajima

----------------------------------------------------------------------

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

Index: linux-2.6.27/drivers/block/loop.c
===================================================================
retrieving revision 1.1
retrieving revision 1.3
diff -u -p -r1.1 -r1.3
--- linux-2.6.27/drivers/block/loop.c	7 Nov 2008 13:07:06 -0000	1.1
+++ linux-2.6.27/drivers/block/loop.c	19 Nov 2008 03:42:54 -0000	1.3
@@ -1137,6 +1137,28 @@ loop_get_status64(struct loop_device *lo
 	return err;
 }
 
+static int loop_set_capacity(struct loop_device *lo, struct block_device *bdev)
+{
+	int err;
+	sector_t sec;
+	loff_t sz;
+
+	err = -ENXIO;
+	if (lo->lo_state != Lo_bound)
+		goto out;
+	err = figure_loop_size(lo);
+	if (err)
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
 static int lo_ioctl(struct inode * inode, struct file * file,
 	unsigned int cmd, unsigned long arg)
 {
@@ -1166,6 +1188,9 @@ static int lo_ioctl(struct inode * inode
 	case LOOP_GET_STATUS64:
 		err = loop_get_status64(lo, (struct loop_info64 __user *) arg);
 		break;
+	case LOOP_SET_CAPACITY:
+		err = loop_set_capacity(lo, inode->i_bdev);
+		break;
 	default:
 		err = lo->ioctl ? lo->ioctl(lo, cmd, arg) : -EINVAL;
 	}
@@ -1311,6 +1336,7 @@ static long lo_compat_ioctl(struct file 
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
retrieving revision 1.2
diff -u -p -r1.1 -r1.2
--- linux-2.6.27/include/linux/loop.h	7 Nov 2008 13:05:58 -0000	1.1
+++ linux-2.6.27/include/linux/loop.h	8 Nov 2008 04:47:20 -0000	1.2
@@ -160,5 +160,6 @@ int loop_unregister_transfer(int number)
 #define LOOP_SET_STATUS64	0x4C04
 #define LOOP_GET_STATUS64	0x4C05
 #define LOOP_CHANGE_FD		0x4C06
+#define LOOP_SET_CAPACITY	0x4C07
 
 #endif
