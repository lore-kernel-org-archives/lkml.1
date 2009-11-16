Return-Path: <linux-kernel-owner+w=401wt.eu-S1753414AbZKPA2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414AbZKPA2N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 19:28:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753382AbZKPA2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 19:28:12 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:58069 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377AbZKPA2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 19:28:07 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
       "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
       "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
       Wolfram Sang <w.sang@pengutronix.de>, linux-i2c@vger.kernel.org
Subject: [PATCH 07/12] i2cdev: move compat_ioctl handling into driver
Date: Mon, 16 Nov 2009 00:27:02 +0000
Message-Id: <1258331227-1694-8-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1258331227-1694-1-git-send-email-arnd@arndb.de>
References: <1258331227-1694-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19B+7+R6pNI2y6fEn7038MmY4CHulDgKWZY2Va
 iCL0L2yHBNQctAXAUL7eeOQVZ7+zGLRwzOXEJv5gaKKRjZ5azr
 b7gxhQemjoagWG2hDeqWg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doing all the compat_ioctl handling in the i2c driver itself
removes special cases from fs/compat_ioctl.c and makes it possible
to optimize this case better.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>
Cc: "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>
Cc: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-i2c@vger.kernel.org
---
 drivers/i2c/i2c-dev.c |  117 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/compat_ioctl.c     |  119 -------------------------------------------------
 2 files changed, 117 insertions(+), 119 deletions(-)

diff --git a/drivers/i2c/i2c-dev.c b/drivers/i2c/i2c-dev.c
index 7e13d2d..fde0c9e 100644
--- a/drivers/i2c/i2c-dev.c
+++ b/drivers/i2c/i2c-dev.c
@@ -35,6 +35,7 @@
 #include <linux/i2c.h>
 #include <linux/i2c-dev.h>
 #include <linux/smp_lock.h>
+#include <linux/compat.h>
 #include <linux/jiffies.h>
 #include <asm/uaccess.h>
 
@@ -439,6 +440,119 @@ static long i2cdev_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	return 0;
 }
 
+#ifdef CONFIG_COMPAT
+struct i2c_msg32 {
+	u16 addr;
+	u16 flags;
+	u16 len;
+	compat_caddr_t buf;
+};
+
+struct i2c_rdwr_ioctl_data32 {
+	compat_caddr_t msgs; /* struct i2c_msg __user *msgs */
+	u32 nmsgs;
+};
+
+struct i2c_smbus_ioctl_data32 {
+	u8 read_write;
+	u8 command;
+	u32 size;
+	compat_caddr_t data; /* union i2c_smbus_data *data */
+};
+
+struct i2c_rdwr_aligned {
+	struct i2c_rdwr_ioctl_data cmd;
+	struct i2c_msg msgs[0];
+};
+
+static int compat_i2c_rdwr_ioctl(struct file *filp, unsigned int cmd,
+			struct i2c_rdwr_ioctl_data32    __user *udata)
+{
+	struct i2c_rdwr_aligned		__user *tdata;
+	struct i2c_msg			__user *tmsgs;
+	struct i2c_msg32		__user *umsgs;
+	compat_caddr_t			datap;
+	int				nmsgs, i;
+
+	if (get_user(nmsgs, &udata->nmsgs))
+		return -EFAULT;
+	if (nmsgs > I2C_RDRW_IOCTL_MAX_MSGS)
+		return -EINVAL;
+
+	if (get_user(datap, &udata->msgs))
+		return -EFAULT;
+	umsgs = compat_ptr(datap);
+
+	tdata = compat_alloc_user_space(sizeof(*tdata) +
+				      nmsgs * sizeof(struct i2c_msg));
+	tmsgs = &tdata->msgs[0];
+
+	if (put_user(nmsgs, &tdata->cmd.nmsgs) ||
+	    put_user(tmsgs, &tdata->cmd.msgs))
+		return -EFAULT;
+
+	for (i = 0; i < nmsgs; i++) {
+		if (copy_in_user(&tmsgs[i].addr, &umsgs[i].addr, 3*sizeof(u16)))
+			return -EFAULT;
+		if (get_user(datap, &umsgs[i].buf) ||
+		    put_user(compat_ptr(datap), &tmsgs[i].buf))
+			return -EFAULT;
+	}
+	return i2cdev_ioctl(filp, cmd, (unsigned long)tdata);
+}
+
+static int compat_i2c_smbus_ioctl(struct file *filp, unsigned int cmd,
+			struct i2c_smbus_ioctl_data32   __user *udata)
+{
+	struct i2c_smbus_ioctl_data	__user *tdata;
+	compat_caddr_t			datap;
+
+	tdata = compat_alloc_user_space(sizeof(*tdata));
+	if (tdata == NULL)
+		return -ENOMEM;
+	if (!access_ok(VERIFY_WRITE, tdata, sizeof(*tdata)))
+		return -EFAULT;
+
+	if (!access_ok(VERIFY_READ, udata, sizeof(*udata)))
+		return -EFAULT;
+
+	if (__copy_in_user(&tdata->read_write, &udata->read_write, 2 * sizeof(u8)))
+		return -EFAULT;
+	if (__copy_in_user(&tdata->size, &udata->size, 2 * sizeof(u32)))
+		return -EFAULT;
+	if (__get_user(datap, &udata->data) ||
+	    __put_user(compat_ptr(datap), &tdata->data))
+		return -EFAULT;
+
+	return i2cdev_ioctl(filp, cmd, (unsigned long)tdata);
+}
+
+static int compat_i2c_funcs(struct file *filp, unsigned int cmd,
+			compat_ulong_t __user *argp)
+{
+	struct i2c_client *client = filp->private_data;
+	compat_ulong_t funcs;
+	funcs = i2c_get_functionality(client->adapter);
+	return put_user(funcs, argp);
+}
+
+static long i2cdev_compat_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+{
+	void __user *argp = compat_ptr(arg);
+
+	switch (cmd) {
+	case I2C_FUNCS:
+		return compat_i2c_funcs(filp, cmd, argp);
+	case I2C_RDWR:
+		return compat_i2c_rdwr_ioctl(filp, cmd, argp);
+	case I2C_SMBUS:
+		return compat_i2c_smbus_ioctl(filp, cmd, argp);
+	}
+
+	return i2cdev_ioctl(filp, cmd, arg);
+}
+#endif /* CONFIG_COMPAT */
+
 static int i2cdev_open(struct inode *inode, struct file *file)
 {
 	unsigned int minor = iminor(inode);
@@ -501,6 +615,9 @@ static const struct file_operations i2cdev_fops = {
 	.read		= i2cdev_read,
 	.write		= i2cdev_write,
 	.unlocked_ioctl	= i2cdev_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	= i2cdev_compat_ioctl,
+#endif
 	.open		= i2cdev_open,
 	.release	= i2cdev_release,
 };
diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index a762fb1..b419459 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -117,21 +117,6 @@
 #include <asm/fbio.h>
 #endif
 
-static int w_long(unsigned int fd, unsigned int cmd,
-		compat_ulong_t __user *argp)
-{
-	mm_segment_t old_fs = get_fs();
-	int err;
-	unsigned long val;
-
-	set_fs (KERNEL_DS);
-	err = sys_ioctl(fd, cmd, (unsigned long)&val);
-	set_fs (old_fs);
-	if (!err && put_user(val, argp))
-		return -EFAULT;
-	return err;
-}
-
 struct compat_video_event {
 	int32_t		type;
 	compat_time_t	timestamp;
@@ -691,96 +676,6 @@ static int do_usbdevfs_discsignal(unsigned int fd, unsigned int cmd,
         return err;
 }
 
-/*
- * I2C layer ioctls
- */
-
-struct i2c_msg32 {
-	u16 addr;
-	u16 flags;
-	u16 len;
-	compat_caddr_t buf;
-};
-
-struct i2c_rdwr_ioctl_data32 {
-	compat_caddr_t msgs; /* struct i2c_msg __user *msgs */
-	u32 nmsgs;
-};
-
-struct i2c_smbus_ioctl_data32 {
-	u8 read_write;
-	u8 command;
-	u32 size;
-	compat_caddr_t data; /* union i2c_smbus_data *data */
-};
-
-struct i2c_rdwr_aligned {
-	struct i2c_rdwr_ioctl_data cmd;
-	struct i2c_msg msgs[0];
-};
-
-static int do_i2c_rdwr_ioctl(unsigned int fd, unsigned int cmd,
-			struct i2c_rdwr_ioctl_data32    __user *udata)
-{
-	struct i2c_rdwr_aligned		__user *tdata;
-	struct i2c_msg			__user *tmsgs;
-	struct i2c_msg32		__user *umsgs;
-	compat_caddr_t			datap;
-	int				nmsgs, i;
-
-	if (get_user(nmsgs, &udata->nmsgs))
-		return -EFAULT;
-	if (nmsgs > I2C_RDRW_IOCTL_MAX_MSGS)
-		return -EINVAL;
-
-	if (get_user(datap, &udata->msgs))
-		return -EFAULT;
-	umsgs = compat_ptr(datap);
-
-	tdata = compat_alloc_user_space(sizeof(*tdata) +
-				      nmsgs * sizeof(struct i2c_msg));
-	tmsgs = &tdata->msgs[0];
-
-	if (put_user(nmsgs, &tdata->cmd.nmsgs) ||
-	    put_user(tmsgs, &tdata->cmd.msgs))
-		return -EFAULT;
-
-	for (i = 0; i < nmsgs; i++) {
-		if (copy_in_user(&tmsgs[i].addr, &umsgs[i].addr, 3*sizeof(u16)))
-			return -EFAULT;
-		if (get_user(datap, &umsgs[i].buf) ||
-		    put_user(compat_ptr(datap), &tmsgs[i].buf))
-			return -EFAULT;
-	}
-	return sys_ioctl(fd, cmd, (unsigned long)tdata);
-}
-
-static int do_i2c_smbus_ioctl(unsigned int fd, unsigned int cmd,
-			struct i2c_smbus_ioctl_data32   __user *udata)
-{
-	struct i2c_smbus_ioctl_data	__user *tdata;
-	compat_caddr_t			datap;
-
-	tdata = compat_alloc_user_space(sizeof(*tdata));
-	if (tdata == NULL)
-		return -ENOMEM;
-	if (!access_ok(VERIFY_WRITE, tdata, sizeof(*tdata)))
-		return -EFAULT;
-
-	if (!access_ok(VERIFY_READ, udata, sizeof(*udata)))
-		return -EFAULT;
-
-	if (__copy_in_user(&tdata->read_write, &udata->read_write, 2 * sizeof(u8)))
-		return -EFAULT;
-	if (__copy_in_user(&tdata->size, &udata->size, 2 * sizeof(u32)))
-		return -EFAULT;
-	if (__get_user(datap, &udata->data) ||
-	    __put_user(compat_ptr(datap), &tdata->data))
-		return -EFAULT;
-
-	return sys_ioctl(fd, cmd, (unsigned long)tdata);
-}
-
 #define RTC_IRQP_READ32		_IOR('p', 0x0b, compat_ulong_t)
 #define RTC_IRQP_SET32		_IOW('p', 0x0c, compat_ulong_t)
 #define RTC_EPOCH_READ32	_IOR('p', 0x0d, compat_ulong_t)
@@ -1341,13 +1236,6 @@ COMPATIBLE_IOCTL(USBDEVFS_SUBMITURB32)
 COMPATIBLE_IOCTL(USBDEVFS_REAPURB32)
 COMPATIBLE_IOCTL(USBDEVFS_REAPURBNDELAY32)
 COMPATIBLE_IOCTL(USBDEVFS_CLEAR_HALT)
-/* i2c */
-COMPATIBLE_IOCTL(I2C_SLAVE)
-COMPATIBLE_IOCTL(I2C_SLAVE_FORCE)
-COMPATIBLE_IOCTL(I2C_TENBIT)
-COMPATIBLE_IOCTL(I2C_PEC)
-COMPATIBLE_IOCTL(I2C_RETRIES)
-COMPATIBLE_IOCTL(I2C_TIMEOUT)
 /* hiddev */
 COMPATIBLE_IOCTL(HIDIOCGVERSION)
 COMPATIBLE_IOCTL(HIDIOCAPPLICATION)
@@ -1533,13 +1421,6 @@ static long do_ioctl_trans(int fd, unsigned int cmd,
 		return do_usbdevfs_bulk(fd, cmd, argp);
 	case USBDEVFS_DISCSIGNAL32:
 		return do_usbdevfs_discsignal(fd, cmd, argp);
-	/* i2c */
-	case I2C_FUNCS:
-		return w_long(fd, cmd, argp);
-	case I2C_RDWR:
-		return do_i2c_rdwr_ioctl(fd, cmd, argp);
-	case I2C_SMBUS:
-		return do_i2c_smbus_ioctl(fd, cmd, argp);
 	/* Not implemented in the native kernel */
 	case RTC_IRQP_READ32:
 	case RTC_IRQP_SET32:
-- 
1.6.3.3

