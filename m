Return-Path: <linux-kernel-owner+w=401wt.eu-S1761543AbYEVVIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761543AbYEVVIA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 17:08:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757054AbYEVVHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 17:07:52 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40490 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755651AbYEVVHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 17:07:51 -0400
Date: Thu, 22 May 2008 21:55:07 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: dwmw2@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH] mtd: Switch to unlocked_ioctl and do BKL in the mtd layer
Message-ID: <20080522215507.64481a33@core>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This helps us get to the point of removing ->ioctl and getting drivers
fixed.

Signed-off-by: Alan Cox <alan@redhat.com>

diff --git a/drivers/mtd/mtdchar.c b/drivers/mtd/mtdchar.c
index 5d3ac51..d2e63fa 100644
--- a/drivers/mtd/mtdchar.c
+++ b/drivers/mtd/mtdchar.c
@@ -14,6 +14,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
+#include <linux/smp_lock.h>
 
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/compatmac.h>
@@ -369,8 +370,7 @@ static int otp_select_filemode(struct mtd_file_info *mfi, int mode)
 # define otp_select_filemode(f,m)	-EOPNOTSUPP
 #endif
 
-static int mtd_ioctl(struct inode *inode, struct file *file,
-		     u_int cmd, u_long arg)
+static long do_mtd_ioctl(struct file *file, u_int cmd, u_long arg)
 {
 	struct mtd_file_info *mfi = file->private_data;
 	struct mtd_info *mtd = mfi->mtd;
@@ -764,12 +764,21 @@ static int mtd_ioctl(struct inode *inode, struct file *file,
 	return ret;
 } /* memory_ioctl */
 
+static long mtd_ioctl(struct file *file, u_int cmd, u_long arg)
+{
+	long ret;
+	lock_kernel();
+	ret = do_mtd_ioctl(file, cmd, arg);
+	unlock_kernel();
+	return ret;
+}
+
 static const struct file_operations mtd_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= mtd_lseek,
 	.read		= mtd_read,
 	.write		= mtd_write,
-	.ioctl		= mtd_ioctl,
+	.unlocked_ioctl	= mtd_ioctl,
 	.open		= mtd_open,
 	.release	= mtd_close,
 };
diff --git a/drivers/mtd/ubi/cdev.c b/drivers/mtd/ubi/cdev.c
index 9d6aae5..2b029cc 100644
--- a/drivers/mtd/ubi/cdev.c
+++ b/drivers/mtd/ubi/cdev.c
@@ -39,6 +39,7 @@
 #include <linux/stat.h>
 #include <linux/ioctl.h>
 #include <linux/capability.h>
+#include <linux/smp_lock.h>
 #include <mtd/ubi-user.h>
 #include <asm/uaccess.h>
 #include <asm/div64.h>
@@ -401,8 +402,8 @@ static ssize_t vol_cdev_write(struct file *file, const char __user *buf,
 	return count;
 }
 
-static int vol_cdev_ioctl(struct inode *inode, struct file *file,
-			  unsigned int cmd, unsigned long arg)
+static long do_vol_cdev_ioctl(struct file *file, unsigned int cmd,
+						unsigned long arg)
 {
 	int err = 0;
 	struct ubi_volume_desc *desc = file->private_data;
@@ -526,6 +527,18 @@ static int vol_cdev_ioctl(struct inode *inode, struct file *file,
 	return err;
 }
 
+static long vol_cdev_ioctl(struct file *file, unsigned int cmd,
+						unsigned long arg)
+{
+	long ret;
+	/* For the moment take the lock before calling as the lifetime
+	   and locking for the references are not clear */
+	lock_kernel();
+	ret = do_vol_cdev_ioctl(file, cmd, arg);
+	unlock_kernel();
+	return ret;
+}
+
 /**
  * verify_mkvol_req - verify volume creation request.
  * @ubi: UBI device description object
@@ -595,9 +608,10 @@ static int verify_rsvol_req(const struct ubi_device *ubi,
 	return 0;
 }
 
-static int ubi_cdev_ioctl(struct inode *inode, struct file *file,
-			  unsigned int cmd, unsigned long arg)
+static long ubi_cdev_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
+	struct inode *inode = file->f_path.dentry->d_inode;
 	int err = 0;
 	struct ubi_device *ubi;
 	struct ubi_volume_desc *desc;
@@ -606,9 +620,12 @@ static int ubi_cdev_ioctl(struct inode *inode, struct file *file,
 	if (!capable(CAP_SYS_RESOURCE))
 		return -EPERM;
 
+	lock_kernel();
 	ubi = ubi_get_by_major(imajor(inode));
-	if (!ubi)
+	if (!ubi) {
+		unlock_kernel();
 		return -ENODEV;
+	}
 
 	switch (cmd) {
 	/* Create volume command */
@@ -714,11 +731,12 @@ static int ubi_cdev_ioctl(struct inode *inode, struct file *file,
 	}
 
 	ubi_put_device(ubi);
+	unlock_kernel();
 	return err;
 }
 
-static int ctrl_cdev_ioctl(struct inode *inode, struct file *file,
-			   unsigned int cmd, unsigned long arg)
+static long ctrl_cdev_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
 	int err = 0;
 	void __user *argp = (void __user *)arg;
@@ -726,6 +744,7 @@ static int ctrl_cdev_ioctl(struct inode *inode, struct file *file,
 	if (!capable(CAP_SYS_RESOURCE))
 		return -EPERM;
 
+	lock_kernel();
 	switch (cmd) {
 	/* Attach an MTD device command */
 	case UBI_IOCATT:
@@ -745,7 +764,6 @@ static int ctrl_cdev_ioctl(struct inode *inode, struct file *file,
 			err = -EINVAL;
 			break;
 		}
-
 		mtd = get_mtd_device(NULL, req.mtd_num);
 		if (IS_ERR(mtd)) {
 			err = PTR_ERR(mtd);
@@ -790,20 +808,21 @@ static int ctrl_cdev_ioctl(struct inode *inode, struct file *file,
 		err = -ENOTTY;
 		break;
 	}
+	unlock_kernel();
 
 	return err;
 }
 
 /* UBI control character device operations */
 struct file_operations ubi_ctrl_cdev_operations = {
-	.ioctl = ctrl_cdev_ioctl,
+	.unlocked_ioctl = ctrl_cdev_ioctl,
 	.owner = THIS_MODULE,
 };
 
 /* UBI character device operations */
 struct file_operations ubi_cdev_operations = {
 	.owner = THIS_MODULE,
-	.ioctl = ubi_cdev_ioctl,
+	.unlocked_ioctl = ubi_cdev_ioctl,
 	.llseek = no_llseek,
 };
 
@@ -815,5 +834,5 @@ struct file_operations ubi_vol_cdev_operations = {
 	.llseek  = vol_cdev_llseek,
 	.read    = vol_cdev_read,
 	.write   = vol_cdev_write,
-	.ioctl   = vol_cdev_ioctl,
+	.unlocked_ioctl = vol_cdev_ioctl,
 };
