Return-Path: <linux-kernel-owner+w=401wt.eu-S1752537AbZKPA1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537AbZKPA1i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 19:27:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752356AbZKPA1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 19:27:37 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:53272 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306AbZKPA1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 19:27:36 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       Kay Sievers <kay.sievers@vrfy.org>, Jens Axboe <jens.axboe@oracle.com>,
       Jan Blunck <jblunck@suse.de>,
       "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 04/12] raw: partly fix compat_ioctl handling on non-x86
Date: Mon, 16 Nov 2009 00:26:59 +0000
Message-Id: <1258331227-1694-5-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1258331227-1694-1-git-send-email-arnd@arndb.de>
References: <1258331227-1694-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+Jr1TDpASpiogVANHYaqnngZiBRjHL/Cl5im4
 8PA48RHowsTNNauZ6XknChjxe4x2hZGKKhoJCQ30hycvJycy+A
 5RE1KjWa5cnAGVG+DET7g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The (compat_ioctl handling for the) raw driver is broken in
multiple ways. The RAW_SETBIND and RAW_GETBIND ioctls are
compatible between 32 and 64 bit on most architectures
but not on x86-64 and ia64 because of the different alignment
on 64 bit variables.
Defining the data structure in terms of compat_u64 rather than
using __attribute__((packed)) solves this.

Another problem is the handling of ioctl passthrough to
block devices, which is not implemented for the compat_ioctl
case and has been broken for ages. This patch does not
fix the problem but prints a diagnostic message in case
someone hits it.

Also move the conversion code into the raw driver itself
to clean up the common fs/compat_ioctl implementation.

Finally, push the big kernel lock into the ioctl functions,
since I'm touching them anyway.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Jan Blunck <jblunck@suse.de>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/char/raw.c |  157 +++++++++++++++++++++++++++++++++++++++++-----------
 fs/compat_ioctl.c  |   68 ----------------------
 2 files changed, 125 insertions(+), 100 deletions(-)

diff --git a/drivers/char/raw.c b/drivers/char/raw.c
index 64acd05..7ccf1c1 100644
--- a/drivers/char/raw.c
+++ b/drivers/char/raw.c
@@ -20,6 +20,7 @@
 #include <linux/device.h>
 #include <linux/mutex.h>
 #include <linux/smp_lock.h>
+#include <linux/compat.h>
 
 #include <asm/uaccess.h>
 
@@ -120,9 +121,8 @@ static int raw_release(struct inode *inode, struct file *filp)
 /*
  * Forward ioctls to the underlying block device.
  */
-static int
-raw_ioctl(struct inode *inode, struct file *filp,
-		  unsigned int command, unsigned long arg)
+static long
+raw_ioctl(struct file *filp, unsigned int command, unsigned long arg)
 {
 	struct block_device *bdev = filp->private_data;
 
@@ -140,10 +140,9 @@ static void bind_device(struct raw_config_request *rq)
  * Deal with ioctls against the raw-device control interface, to bind
  * and unbind other raw devices.
  */
-static int raw_ctl_ioctl(struct inode *inode, struct file *filp,
-			unsigned int command, unsigned long arg)
+static int do_raw_ctl_ioctl(struct file *filp,
+			unsigned int command, struct raw_config_request *rq)
 {
-	struct raw_config_request rq;
 	struct raw_device_data *rawdev;
 	int err = 0;
 
@@ -152,17 +151,11 @@ static int raw_ctl_ioctl(struct inode *inode, struct file *filp,
 	case RAW_GETBIND:
 
 		/* First, find out which raw minor we want */
-
-		if (copy_from_user(&rq, (void __user *) arg, sizeof(rq))) {
-			err = -EFAULT;
-			goto out;
-		}
-
-		if (rq.raw_minor <= 0 || rq.raw_minor >= MAX_RAW_MINORS) {
+		if (rq->raw_minor <= 0 || rq->raw_minor >= MAX_RAW_MINORS) {
 			err = -EINVAL;
 			goto out;
 		}
-		rawdev = &raw_devices[rq.raw_minor];
+		rawdev = &raw_devices[rq->raw_minor];
 
 		if (command == RAW_SETBIND) {
 			dev_t dev;
@@ -183,10 +176,10 @@ static int raw_ctl_ioctl(struct inode *inode, struct file *filp,
 			 * major/minor numbers make sense.
 			 */
 
-			dev = MKDEV(rq.block_major, rq.block_minor);
-			if ((rq.block_major == 0 && rq.block_minor != 0) ||
-					MAJOR(dev) != rq.block_major ||
-					MINOR(dev) != rq.block_minor) {
+			dev = MKDEV(rq->block_major, rq->block_minor);
+			if ((rq->block_major == 0 && rq->block_minor != 0) ||
+					MAJOR(dev) != rq->block_major ||
+					MINOR(dev) != rq->block_minor) {
 				err = -EINVAL;
 				goto out;
 			}
@@ -201,18 +194,18 @@ static int raw_ctl_ioctl(struct inode *inode, struct file *filp,
 				bdput(rawdev->binding);
 				module_put(THIS_MODULE);
 			}
-			if (rq.block_major == 0 && rq.block_minor == 0) {
+			if (rq->block_major == 0 && rq->block_minor == 0) {
 				/* unbind */
 				rawdev->binding = NULL;
 				device_destroy(raw_class,
-						MKDEV(RAW_MAJOR, rq.raw_minor));
+						MKDEV(RAW_MAJOR, rq->raw_minor));
 			} else {
 				rawdev->binding = bdget(dev);
 				if (rawdev->binding == NULL)
 					err = -ENOMEM;
 				else {
 					__module_get(THIS_MODULE);
-					bind_device(&rq);
+					bind_device(rq);
 				}
 			}
 			mutex_unlock(&raw_mutex);
@@ -222,16 +215,12 @@ static int raw_ctl_ioctl(struct inode *inode, struct file *filp,
 			mutex_lock(&raw_mutex);
 			bdev = rawdev->binding;
 			if (bdev) {
-				rq.block_major = MAJOR(bdev->bd_dev);
-				rq.block_minor = MINOR(bdev->bd_dev);
+				rq->block_major = MAJOR(bdev->bd_dev);
+				rq->block_minor = MINOR(bdev->bd_dev);
 			} else {
-				rq.block_major = rq.block_minor = 0;
+				rq->block_major = rq->block_minor = 0;
 			}
 			mutex_unlock(&raw_mutex);
-			if (copy_to_user((void __user *)arg, &rq, sizeof(rq))) {
-				err = -EFAULT;
-				goto out;
-			}
 		}
 		break;
 	default:
@@ -242,6 +231,108 @@ out:
 	return err;
 }
 
+
+static long raw_ctl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	struct raw_config_request rq;
+	int err = -EINVAL;
+
+        switch (cmd) {
+        case RAW_SETBIND:
+        case RAW_GETBIND:
+		if (copy_from_user(&rq, (void __user *)arg, sizeof(rq))) {
+			err = -EFAULT;
+			break;
+		}
+
+		lock_kernel();
+                err = do_raw_ctl_ioctl(file, cmd, &rq);
+		unlock_kernel();
+
+		if (!err && cmd == RAW_GETBIND) {
+			if (copy_to_user((void __user *)arg, &rq, sizeof(rq))) {
+				err = -EFAULT;
+			}
+		}
+                break;
+        }
+        return err;
+}
+
+#ifdef CONFIG_COMPAT
+struct compat_raw_config_request {
+	compat_int_t	raw_minor;
+	compat_u64	block_major;
+	compat_u64	block_minor;
+};
+
+static int get_raw32_request(struct raw_config_request *req,
+			     struct compat_raw_config_request __user * user_req)
+{
+	int err;
+
+	if (!access_ok (VERIFY_READ, user_req,
+			sizeof(struct compat_raw_config_request)))
+		return -EFAULT;
+
+	err  = __get_user(req->raw_minor, &user_req->raw_minor);
+	err |= __get_user(req->block_major, &user_req->block_major);
+	err |= __get_user(req->block_minor, &user_req->block_minor);
+
+	return err ? -EFAULT : 0;
+}
+
+static int set_raw32_request(struct raw_config_request *req,
+			     struct compat_raw_config_request __user * user_req)
+{
+	int err;
+
+	if (!access_ok(VERIFY_WRITE, user_req,
+			sizeof(struct compat_raw_config_request)))
+		return -EFAULT;
+
+	err  = __put_user(req->raw_minor, &user_req->raw_minor);
+	err |= __put_user(req->block_major, &user_req->block_major);
+	err |= __put_user(req->block_minor, &user_req->block_minor);
+
+	return err ? -EFAULT : 0;
+}
+
+static long raw_ctl_compat_ioctl(struct file *file, unsigned cmd, unsigned long arg)
+{
+	struct raw_config_request req;
+	struct compat_raw_config_request __user *user_req;
+	int err = -EINVAL;
+
+	user_req = compat_ptr(arg);
+	switch (cmd) {
+	case RAW_SETBIND:
+	case RAW_GETBIND:
+		if ((err = get_raw32_request(&req, user_req)))
+			return err;
+
+		lock_kernel();
+		err = do_raw_ctl_ioctl(file, cmd, &req);
+		unlock_kernel();
+
+		if ((!err) && (cmd == RAW_GETBIND)) {
+			err = set_raw32_request(&req, user_req);
+		}
+		break;
+	}
+	return err;
+}
+
+static long
+raw_compat_ioctl(struct file *filp, unsigned int command, unsigned long arg)
+{
+	/* FIXME: should pass through ioctls */
+	compat_printk("%s: no support for block ioctls\n", __func__);
+
+	return -ENOIOCTLCMD;
+}
+#endif /* CONFIG_COMPAT */
+
 static const struct file_operations raw_fops = {
 	.read	=	do_sync_read,
 	.aio_read = 	generic_file_aio_read,
@@ -249,14 +340,16 @@ static const struct file_operations raw_fops = {
 	.aio_write =	blkdev_aio_write,
 	.open	=	raw_open,
 	.release=	raw_release,
-	.ioctl	=	raw_ioctl,
+	.unlocked_ioctl	= raw_ioctl,
+	.compat_ioctl = raw_compat_ioctl,
 	.owner	=	THIS_MODULE,
 };
 
 static const struct file_operations raw_ctl_fops = {
-	.ioctl	=	raw_ctl_ioctl,
-	.open	=	raw_open,
-	.owner	=	THIS_MODULE,
+	.unlocked_ioctl	= raw_ctl_ioctl,
+	.compat_ioctl	= raw_ctl_compat_ioctl,
+	.open		= raw_open,
+	.owner		= THIS_MODULE,
 };
 
 static struct cdev raw_cdev;
diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index ed3f23c..80f1a92 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -558,70 +558,6 @@ static int do_smb_getmountuid(unsigned int fd, unsigned int cmd,
 #define HIDPGETCONNLIST	_IOR('H', 210, int)
 #define HIDPGETCONNINFO	_IOR('H', 211, int)
 
-#ifdef CONFIG_BLOCK
-struct raw32_config_request
-{
-        compat_int_t    raw_minor;
-        __u64   block_major;
-        __u64   block_minor;
-} __attribute__((packed));
-
-static int get_raw32_request(struct raw_config_request *req, struct raw32_config_request __user *user_req)
-{
-        int ret;
-
-        if (!access_ok(VERIFY_READ, user_req, sizeof(struct raw32_config_request)))
-                return -EFAULT;
-
-        ret = __get_user(req->raw_minor, &user_req->raw_minor);
-        ret |= __get_user(req->block_major, &user_req->block_major);
-        ret |= __get_user(req->block_minor, &user_req->block_minor);
-
-        return ret ? -EFAULT : 0;
-}
-
-static int set_raw32_request(struct raw_config_request *req, struct raw32_config_request __user *user_req)
-{
-	int ret;
-
-        if (!access_ok(VERIFY_WRITE, user_req, sizeof(struct raw32_config_request)))
-                return -EFAULT;
-
-        ret = __put_user(req->raw_minor, &user_req->raw_minor);
-        ret |= __put_user(req->block_major, &user_req->block_major);
-        ret |= __put_user(req->block_minor, &user_req->block_minor);
-
-        return ret ? -EFAULT : 0;
-}
-
-static int raw_ioctl(unsigned fd, unsigned cmd,
-		struct raw32_config_request __user *user_req)
-{
-        int ret;
-
-        switch (cmd) {
-        case RAW_SETBIND:
-        case RAW_GETBIND: {
-                struct raw_config_request req;
-                mm_segment_t oldfs = get_fs();
-
-                if ((ret = get_raw32_request(&req, user_req)))
-                        return ret;
-
-                set_fs(KERNEL_DS);
-                ret = sys_ioctl(fd,cmd,(unsigned long)&req);
-                set_fs(oldfs);
-
-                if ((!ret) && (cmd == RAW_GETBIND)) {
-                        ret = set_raw32_request(&req, user_req);
-                }
-                break;
-        }
-        }
-        return ret;
-}
-#endif /* CONFIG_BLOCK */
-
 struct serial_struct32 {
         compat_int_t    type;
         compat_int_t    line;
@@ -1612,10 +1548,6 @@ static long do_ioctl_trans(int fd, unsigned int cmd,
 	case MTIOCGET32:
 	case MTIOCPOS32:
 		return mt_ioctl_trans(fd, cmd, argp);
-	/* Raw devices */
-	case RAW_SETBIND:
-	case RAW_GETBIND:
-		return raw_ioctl(fd, cmd, argp);
 #endif
 	/* One SMB ioctl needs translations. */
 #define SMB_IOC_GETMOUNTUID_32 _IOR('u', 1, compat_uid_t)
-- 
1.6.3.3

