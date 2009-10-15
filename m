Return-Path: <linux-kernel-owner+w=401wt.eu-S935523AbZJOU3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935523AbZJOU3p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 16:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935513AbZJOU3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 16:29:45 -0400
Received: from www.tglx.de ([62.245.132.106]:52497 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935249AbZJOU3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 16:29:43 -0400
Message-Id: <20091015202758.523050101@linutronix.de>
User-Agent: quilt/0.47-1
Date: Thu, 15 Oct 2009 20:28:48 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: ALan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
       David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
Subject: [patch 4/5] mtd: Remove BKL and convert to unlocked_ioctl
References: <20091015202722.372890083@linutronix.de>
Content-Disposition: inline;
	filename=mtd-remove-bkl-and-convert-to-unlocked-ioctl.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mtd_open() got lock/unlock kernel from the big BKL push down, but it
never relied on the BKL serialization as get_mtd_device() takes care
of serialization vs. device init/teardown.

mtd_ioctl() is safe w/o the BKL as well. The data which is copied from
the mtd data structure is either set up during device initialization
or statistics which have never been protected by the BKL against
concurrent modification. The mtd functions which are called from
various ioctl commands are safe as well.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org
---
 drivers/mtd/mtdchar.c |   30 ++++++++----------------------
 1 file changed, 8 insertions(+), 22 deletions(-)

Index: linux-2.6-tip/drivers/mtd/mtdchar.c
===================================================================
--- linux-2.6-tip.orig/drivers/mtd/mtdchar.c
+++ linux-2.6-tip/drivers/mtd/mtdchar.c
@@ -12,7 +12,6 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
-#include <linux/smp_lock.h>
 #include <linux/backing-dev.h>
 #include <linux/compat.h>
 
@@ -74,18 +73,14 @@ static int mtd_open(struct inode *inode,
 	if ((file->f_mode & FMODE_WRITE) && (minor & 1))
 		return -EACCES;
 
-	lock_kernel();
 	mtd = get_mtd_device(NULL, devnum);
 
-	if (IS_ERR(mtd)) {
-		ret = PTR_ERR(mtd);
-		goto out;
-	}
+	if (IS_ERR(mtd))
+		return PTR_ERR(mtd);
 
 	if (mtd->type == MTD_ABSENT) {
 		put_mtd_device(mtd);
-		ret = -ENODEV;
-		goto out;
+		return -ENODEV;
 	}
 
 	if (mtd->backing_dev_info)
@@ -94,21 +89,17 @@ static int mtd_open(struct inode *inode,
 	/* You can't open it RW if it's not a writeable device */
 	if ((file->f_mode & FMODE_WRITE) && !(mtd->flags & MTD_WRITEABLE)) {
 		put_mtd_device(mtd);
-		ret = -EACCES;
-		goto out;
+		return -EACCES;
 	}
 
 	mfi = kzalloc(sizeof(*mfi), GFP_KERNEL);
 	if (!mfi) {
 		put_mtd_device(mtd);
-		ret = -ENOMEM;
-		goto out;
+		return -ENOMEM;
 	}
 	mfi->mtd = mtd;
 	file->private_data = mfi;
 
-out:
-	unlock_kernel();
 	return ret;
 } /* mtd_open */
 
@@ -450,13 +441,12 @@ static int mtd_do_readoob(struct mtd_inf
 	return ret;
 }
 
-static int mtd_ioctl(struct inode *inode, struct file *file,
-		     u_int cmd, u_long arg)
+static long mtd_ioctl(struct file *file, u_int cmd, u_long arg)
 {
 	struct mtd_file_info *mfi = file->private_data;
 	struct mtd_info *mtd = mfi->mtd;
 	void __user *argp = (void __user *)arg;
-	int ret = 0;
+	long ret = 0;
 	u_long size;
 	struct mtd_info_user info;
 
@@ -842,8 +832,6 @@ static long mtd_compat_ioctl(struct file
 	void __user *argp = compat_ptr(arg);
 	int ret = 0;
 
-	lock_kernel();
-
 	switch (cmd) {
 	case MEMWRITEOOB32:
 	{
@@ -877,8 +865,6 @@ static long mtd_compat_ioctl(struct file
 		ret = mtd_ioctl(inode, file, cmd, (unsigned long)argp);
 	}
 
-	unlock_kernel();
-
 	return ret;
 }
 
@@ -942,7 +928,7 @@ static const struct file_operations mtd_
 	.llseek		= mtd_lseek,
 	.read		= mtd_read,
 	.write		= mtd_write,
-	.ioctl		= mtd_ioctl,
+	.unlocked_ioctl	= mtd_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= mtd_compat_ioctl,
 #endif


