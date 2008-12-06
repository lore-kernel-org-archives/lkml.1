Return-Path: <linux-kernel-owner+w=401wt.eu-S1757162AbYLFEox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757162AbYLFEox (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 23:44:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753635AbYLFEop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 23:44:45 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:42196 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744AbYLFEoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 23:44:44 -0500
Date: Sat, 6 Dec 2008 04:44:42 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] fix rawctl compat ioctls breakage on amd64 and itanic
Message-ID: <20081206044442.GK28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	RAW_SETBIND and RAW_GETBIND 32bit versions are fscked in interesting
ways.

1) fs/compat_ioctl.c has COMPATIBLE_IOCTL(RAW_SETBIND) followed by
HANDLE_IOCTL(RAW_SETBIND, raw_ioctl).  The latter is ignored.

2) on amd64 (and itanic) the damn thing is broken - we have int + u64 + u64
and layouts on i386 and amd64 are _not_ the same.  raw_ioctl() would
work there, but it's never called due to (1).  As it is, i386 /sbin/raw
definitely doesn't work on amd64 boxen.

3) switching to raw_ioctl() as is would *not* work on e.g. sparc64 and ppc64,
which would be rather sad, seeing that normal userland there is 32bit.
The thing is, slapping __packed on the struct in question does not DTRT -
it eliminates *all* padding.  The real solution is to use compat_u64.

4) of course, all that stuff has no business being outside of raw.c in the
first place - there should be ->compat_ioctl() for /dev/rawctl instead of
messing with compat_ioctl.c.

Patch below deals with that crap.  Builds, tested, seems to be working
fine...  I don't know if there's any point in merging that before .28-final -
it does fix a real bug, all right, but
	a) bug affects very few binaries - it's triggered by i386 binary that
does /dev/rawctl ioctls and happens to be run on amd64.
	b) the breakage had been there for about 5 years, so it's not
exactly a recent regression.
Up to you...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/drivers/char/raw.c b/drivers/char/raw.c
index 96adf28..9647b8d 100644
--- a/drivers/char/raw.c
+++ b/drivers/char/raw.c
@@ -20,6 +20,7 @@
 #include <linux/device.h>
 #include <linux/mutex.h>
 #include <linux/smp_lock.h>
+#include <linux/compat.h>
 
 #include <asm/uaccess.h>
 
@@ -128,11 +129,81 @@ raw_ioctl(struct inode *inode, struct file *filp,
 	return blkdev_ioctl(bdev, 0, command, arg);
 }
 
-static void bind_device(struct raw_config_request *rq)
+static int bind_set(int number, u64 major, u64 minor)
 {
-	device_destroy(raw_class, MKDEV(RAW_MAJOR, rq->raw_minor));
-	device_create(raw_class, NULL, MKDEV(RAW_MAJOR, rq->raw_minor), NULL,
-		      "raw%d", rq->raw_minor);
+	dev_t dev = MKDEV(major, minor);
+	struct raw_device_data *rawdev;
+	int err = 0;
+
+	if (number <= 0 || number >= MAX_RAW_MINORS)
+		return -EINVAL;
+
+	if (MAJOR(dev) != major || MINOR(dev) != minor)
+		return -EINVAL;
+
+	rawdev = &raw_devices[number];
+
+	/*
+	 * This is like making block devices, so demand the
+	 * same capability
+	 */
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	/*
+	 * For now, we don't need to check that the underlying
+	 * block device is present or not: we can do that when
+	 * the raw device is opened.  Just check that the
+	 * major/minor numbers make sense.
+	 */
+
+	if (MAJOR(dev) == 0 && dev != 0)
+		return -EINVAL;
+
+	mutex_lock(&raw_mutex);
+	if (rawdev->inuse) {
+		mutex_unlock(&raw_mutex);
+		return -EBUSY;
+	}
+	if (rawdev->binding) {
+		bdput(rawdev->binding);
+		module_put(THIS_MODULE);
+	}
+	if (!dev) {
+		/* unbind */
+		rawdev->binding = NULL;
+		device_destroy(raw_class, MKDEV(RAW_MAJOR, number));
+	} else {
+		rawdev->binding = bdget(dev);
+		if (rawdev->binding == NULL) {
+			err = -ENOMEM;
+		} else {
+			dev_t raw = MKDEV(RAW_MAJOR, number);
+			__module_get(THIS_MODULE);
+			device_destroy(raw_class, raw);
+			device_create(raw_class, NULL, raw, NULL,
+				      "raw%d", number);
+		}
+	}
+	mutex_unlock(&raw_mutex);
+	return err;
+}
+
+static int bind_get(int number, dev_t *dev)
+{
+	struct raw_device_data *rawdev;
+	struct block_device *bdev;
+
+	if (number <= 0 || number >= MAX_RAW_MINORS)
+		return -EINVAL;
+
+	rawdev = &raw_devices[number];
+
+	mutex_lock(&raw_mutex);
+	bdev = rawdev->binding;
+	*dev = bdev ? bdev->bd_dev : 0;
+	mutex_unlock(&raw_mutex);
+	return 0;
 }
 
 /*
@@ -143,103 +214,79 @@ static int raw_ctl_ioctl(struct inode *inode, struct file *filp,
 			unsigned int command, unsigned long arg)
 {
 	struct raw_config_request rq;
-	struct raw_device_data *rawdev;
-	int err = 0;
+	dev_t dev;
+	int err;
 
 	switch (command) {
 	case RAW_SETBIND:
+		if (copy_from_user(&rq, (void __user *) arg, sizeof(rq)))
+			return -EFAULT;
+
+		return bind_set(rq.raw_minor, rq.block_major, rq.block_minor);
+
 	case RAW_GETBIND:
+		if (copy_from_user(&rq, (void __user *) arg, sizeof(rq)))
+			return -EFAULT;
 
-		/* First, find out which raw minor we want */
+		err = bind_get(rq.raw_minor, &dev);
+		if (err)
+			return err;
 
-		if (copy_from_user(&rq, (void __user *) arg, sizeof(rq))) {
-			err = -EFAULT;
-			goto out;
-		}
+		rq.block_major = MAJOR(dev);
+		rq.block_minor = MINOR(dev);
 
-		if (rq.raw_minor <= 0 || rq.raw_minor >= MAX_RAW_MINORS) {
-			err = -EINVAL;
-			goto out;
-		}
-		rawdev = &raw_devices[rq.raw_minor];
-
-		if (command == RAW_SETBIND) {
-			dev_t dev;
-
-			/*
-			 * This is like making block devices, so demand the
-			 * same capability
-			 */
-			if (!capable(CAP_SYS_ADMIN)) {
-				err = -EPERM;
-				goto out;
-			}
-
-			/*
-			 * For now, we don't need to check that the underlying
-			 * block device is present or not: we can do that when
-			 * the raw device is opened.  Just check that the
-			 * major/minor numbers make sense.
-			 */
-
-			dev = MKDEV(rq.block_major, rq.block_minor);
-			if ((rq.block_major == 0 && rq.block_minor != 0) ||
-					MAJOR(dev) != rq.block_major ||
-					MINOR(dev) != rq.block_minor) {
-				err = -EINVAL;
-				goto out;
-			}
-
-			mutex_lock(&raw_mutex);
-			if (rawdev->inuse) {
-				mutex_unlock(&raw_mutex);
-				err = -EBUSY;
-				goto out;
-			}
-			if (rawdev->binding) {
-				bdput(rawdev->binding);
-				module_put(THIS_MODULE);
-			}
-			if (rq.block_major == 0 && rq.block_minor == 0) {
-				/* unbind */
-				rawdev->binding = NULL;
-				device_destroy(raw_class,
-						MKDEV(RAW_MAJOR, rq.raw_minor));
-			} else {
-				rawdev->binding = bdget(dev);
-				if (rawdev->binding == NULL)
-					err = -ENOMEM;
-				else {
-					__module_get(THIS_MODULE);
-					bind_device(&rq);
-				}
-			}
-			mutex_unlock(&raw_mutex);
-		} else {
-			struct block_device *bdev;
-
-			mutex_lock(&raw_mutex);
-			bdev = rawdev->binding;
-			if (bdev) {
-				rq.block_major = MAJOR(bdev->bd_dev);
-				rq.block_minor = MINOR(bdev->bd_dev);
-			} else {
-				rq.block_major = rq.block_minor = 0;
-			}
-			mutex_unlock(&raw_mutex);
-			if (copy_to_user((void __user *)arg, &rq, sizeof(rq))) {
-				err = -EFAULT;
-				goto out;
-			}
-		}
-		break;
-	default:
-		err = -EINVAL;
-		break;
+		if (copy_to_user((void __user *)arg, &rq, sizeof(rq)))
+			return -EFAULT;
+
+		return 0;
 	}
-out:
-	return err;
+
+	return -EINVAL;
+}
+
+#ifdef CONFIG_COMPAT
+struct raw32_config_request
+{
+        compat_int_t	raw_minor;
+        compat_u64	block_major;
+        compat_u64	block_minor;
+};
+
+static long raw_ctl_compat_ioctl(struct file *file, unsigned int cmd,
+				unsigned long arg)
+{
+	struct raw32_config_request __user *user_req = compat_ptr(arg);
+	struct raw32_config_request rq;
+	dev_t dev;
+	int err = 0;
+
+	switch (cmd) {
+	case RAW_SETBIND:
+		if (copy_from_user(&rq, user_req, sizeof(rq)))
+			return -EFAULT;
+
+		return bind_set(rq.raw_minor, rq.block_major, rq.block_minor);
+
+	case RAW_GETBIND:
+		if (copy_from_user(&rq, user_req, sizeof(rq)))
+			return -EFAULT;
+
+		err = bind_get(rq.raw_minor, &dev);
+		if (err)
+			return err;
+
+		rq.block_major = MAJOR(dev);
+		rq.block_minor = MINOR(dev);
+
+		if (copy_to_user(user_req, &rq, sizeof(rq)))
+			return -EFAULT;
+
+		return 0;
+	}
+
+	return -EINVAL;
 }
+#endif
 
 static const struct file_operations raw_fops = {
 	.read	=	do_sync_read,
@@ -254,6 +301,9 @@ static const struct file_operations raw_fops = {
 
 static const struct file_operations raw_ctl_fops = {
 	.ioctl	=	raw_ctl_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl =	raw_ctl_compat_ioctl,
+#endif
 	.open	=	raw_open,
 	.owner	=	THIS_MODULE,
 };
diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 5235c67..f5f7b59 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -1445,73 +1445,6 @@ static int mtd_rw_oob(unsigned int fd, unsigned int cmd, unsigned long arg)
 	return err;
 }	
 
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
-static int raw_ioctl(unsigned fd, unsigned cmd, unsigned long arg)
-{
-        int ret;
-
-        switch (cmd) {
-        case RAW_SETBIND:
-        case RAW_GETBIND: {
-                struct raw_config_request req;
-                struct raw32_config_request __user *user_req = compat_ptr(arg);
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
-        default:
-                ret = sys_ioctl(fd, cmd, arg);
-                break;
-        }
-        return ret;
-}
-#endif /* CONFIG_BLOCK */
-
 struct serial_struct32 {
         compat_int_t    type;
         compat_int_t    line;
@@ -2297,9 +2230,6 @@ COMPATIBLE_IOCTL(AUTOFS_IOC_EXPIRE)
 COMPATIBLE_IOCTL(AUTOFS_IOC_EXPIRE_MULTI)
 COMPATIBLE_IOCTL(AUTOFS_IOC_PROTOSUBVER)
 COMPATIBLE_IOCTL(AUTOFS_IOC_ASKUMOUNT)
-/* Raw devices */
-COMPATIBLE_IOCTL(RAW_SETBIND)
-COMPATIBLE_IOCTL(RAW_GETBIND)
 /* SMB ioctls which do not need any translations */
 COMPATIBLE_IOCTL(SMB_IOC_NEWCONN)
 /* Little a */
@@ -2639,11 +2569,6 @@ HANDLE_IOCTL(SONET_SETFRAMING, do_atm_ioctl)
 HANDLE_IOCTL(SONET_GETFRAMING, do_atm_ioctl)
 HANDLE_IOCTL(SONET_GETFRSENSE, do_atm_ioctl)
 /* block stuff */
-#ifdef CONFIG_BLOCK
-/* Raw devices */
-HANDLE_IOCTL(RAW_SETBIND, raw_ioctl)
-HANDLE_IOCTL(RAW_GETBIND, raw_ioctl)
-#endif
 /* Serial */
 HANDLE_IOCTL(TIOCGSERIAL, serial_struct_ioctl)
 HANDLE_IOCTL(TIOCSSERIAL, serial_struct_ioctl)
