Return-Path: <linux-kernel-owner+w=401wt.eu-S1760723AbZLOSJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760723AbZLOSJU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 13:09:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759935AbZLOSJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 13:09:18 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:50647 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760671AbZLOSJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 13:09:17 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
Date: Tue, 15 Dec 2009 19:08:50 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
References: <20091214125729.6d699d94.akpm@linux-foundation.org>
In-Reply-To: <20091214125729.6d699d94.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912151908.50827.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/8ERBzpoYV5z6qtRnmY1MJNlFVkkUy0yZBP2G
 LMe6V1VDM2Hs7eF6WOkvvU+TGGIhufQAxQPbbKIu3ppbv28LiB
 gKE0SxjIX7uQ+PRmmTg9A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>
Date: Mon, 14 Dec 2009 12:57:55 -0800
Subject: [PATCH] raw: fix rawctl compat ioctls breakage on amd64 and itanic

RAW_SETBIND and RAW_GETBIND 32bit versions are fscked in interesting ways.

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

[akpm@linux-foundation.org: coding-style fixes]

[arnd@arndb.de:]
Another problem is the handling of ioctl passthrough to
block devices, which is not implemented for the compat_ioctl
case and has been broken for ages. This patch does not
fix the problem but prints a diagnostic message in case
someone hits it.

Finally, push the big kernel lock into the ioctl functions,
since we're touching them anyway.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---

On Monday 14 December 2009, Andrew Morton wrote:
> 
> Arnd, I've been minding this patch for a while, but `md: move
> compat_ioctl handling into md.c' broke it.

I've added the additional changes I had in my patch to Al's version now
and updated it to apply against the current fs/compat_ioctl.c.

This now takes the BKL explicitly in both native and compat mode,
as my version did, and does not take it for the passthrough ioctls
to blockdev, which just takes it again anyway.

For everything else, my version was now as clean as this one,
since I basically moved the code over from fs/compat_ioctl.c
but did not perform all the cleanup that Al did.

	Arnd

diff --git a/drivers/char/raw.c b/drivers/char/raw.c
index 64acd05..026f5e1 100644
--- a/drivers/char/raw.c
+++ b/drivers/char/raw.c
@@ -20,6 +20,7 @@
 #include <linux/device.h>
 #include <linux/mutex.h>
 #include <linux/smp_lock.h>
+#include <linux/compat.h>
 
 #include <asm/uaccess.h>
 
@@ -120,143 +121,211 @@ static int raw_release(struct inode *inode, struct file *filp)
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
+	if (MAJOR(dev) == 0 && dev)
+		return -EINVAL;
+
+	if (MAJOR(dev) != major || MINOR(dev) != minor)
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
  * Deal with ioctls against the raw-device control interface, to bind
  * and unbind other raw devices.
  */
-static int raw_ctl_ioctl(struct inode *inode, struct file *filp,
-			unsigned int command, unsigned long arg)
+static long raw_ctl_ioctl(struct file *file, unsigned int command, unsigned long arg)
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
+		lock_kernel();
+		err = bind_set(rq.raw_minor, rq.block_major, rq.block_minor);
+		unlock_kernel();
+		return err;
+
 	case RAW_GETBIND:
+		if (copy_from_user(&rq, (void __user *) arg, sizeof(rq)))
+			return -EFAULT;
 
-		/* First, find out which raw minor we want */
+		lock_kernel();
+		err = bind_get(rq.raw_minor, &dev);
+		unlock_kernel();
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
+struct compat_raw_config_request {
+	compat_int_t	raw_minor;
+	compat_u64	block_major;
+	compat_u64	block_minor;
+};
+
+static long raw_ctl_compat_ioctl(struct file *file, unsigned int command, unsigned long arg)
+{
+	struct compat_raw_config_request __user *user_rq = compat_ptr(arg);
+	struct compat_raw_config_request rq;
+	dev_t dev;
+	int err;
+
+	switch (command) {
+	case RAW_SETBIND:
+		if (copy_from_user(&rq, user_rq, sizeof(rq)))
+			return -EFAULT;
+
+		lock_kernel();
+		err = bind_set(rq.raw_minor, rq.block_major, rq.block_minor);
+		unlock_kernel();
+
+		return err;
+
+	case RAW_GETBIND:
+		if (copy_from_user(&rq, user_rq, sizeof(rq)))
+			return -EFAULT;
+
+		lock_kernel();
+		err = bind_get(rq.raw_minor, &dev);
+		unlock_kernel();
+		if (err)
+			return err;
+
+		rq.block_major = MAJOR(dev);
+		rq.block_minor = MINOR(dev);
+
+		if (copy_to_user(user_rq, &rq, sizeof(rq)))
+			return -EFAULT;
+
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static long
+raw_compat_ioctl(struct file *filp, unsigned int command, unsigned long arg)
+{
+	/* FIXME: should pass through ioctls */
+	compat_printk("%s: no support for block ioctls\n", __func__);
+
+	return -ENOIOCTLCMD;
 }
+#endif /* CONFIG_COMPAT */
 
 static const struct file_operations raw_fops = {
-	.read	=	do_sync_read,
-	.aio_read = 	generic_file_aio_read,
-	.write	=	do_sync_write,
-	.aio_write =	blkdev_aio_write,
-	.open	=	raw_open,
-	.release=	raw_release,
-	.ioctl	=	raw_ioctl,
-	.owner	=	THIS_MODULE,
+	.read		= do_sync_read,
+	.aio_read	= generic_file_aio_read,
+	.write		= do_sync_write,
+	.aio_write	= blkdev_aio_write,
+	.open		= raw_open,
+	.release	= raw_release,
+	.unlocked_ioctl	= raw_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	= raw_compat_ioctl,
+#endif
+	.owner		= THIS_MODULE,
 };
 
 static const struct file_operations raw_ctl_fops = {
-	.ioctl	=	raw_ctl_ioctl,
-	.open	=	raw_open,
-	.owner	=	THIS_MODULE,
+	.unlocked_ioctl	= raw_ctl_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	= raw_ctl_compat_ioctl,
+#endif
+	.open		= raw_open,
+	.owner		= THIS_MODULE,
 };
 
 static struct cdev raw_cdev;
diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 4c0e5e6..ad97a13 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -524,70 +524,6 @@ static int mt_ioctl_trans(unsigned int fd, unsigned int cmd, void __user *argp)
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
@@ -1064,9 +1000,6 @@ COMPATIBLE_IOCTL(SOUND_MIXER_PRIVATE5)
 COMPATIBLE_IOCTL(SOUND_MIXER_GETLEVELS)
 COMPATIBLE_IOCTL(SOUND_MIXER_SETLEVELS)
 COMPATIBLE_IOCTL(OSS_GETVERSION)
-/* Raw devices */
-COMPATIBLE_IOCTL(RAW_SETBIND)
-COMPATIBLE_IOCTL(RAW_GETBIND)
 /* Watchdog */
 COMPATIBLE_IOCTL(WDIOC_GETSUPPORT)
 COMPATIBLE_IOCTL(WDIOC_GETSTATUS)
@@ -1306,10 +1239,6 @@ static long do_ioctl_trans(int fd, unsigned int cmd,
 	case MTIOCGET32:
 	case MTIOCPOS32:
 		return mt_ioctl_trans(fd, cmd, argp);
-	/* Raw devices */
-	case RAW_SETBIND:
-	case RAW_GETBIND:
-		return raw_ioctl(fd, cmd, argp);
 #endif
 	/* Serial */
 	case TIOCGSERIAL:
