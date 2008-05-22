Return-Path: <linux-kernel-owner+w=401wt.eu-S1761956AbYEVVCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761956AbYEVVCx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 17:02:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756608AbYEVVCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 17:02:44 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37379 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752682AbYEVVCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 17:02:43 -0400
Date: Thu, 22 May 2008 21:50:13 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com
Subject: [PATCH] hidraw: Push down BKL into ioctl handler
Message-ID: <20080522215013.374b5e5d@core>
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

In this case I simply wrapped it as code review suggests the locking
already terminally broken and I didn't want to make it first. See added
comment

Signed-off-by: Alan Cox <alan@redhat.com>

diff --git a/drivers/hid/hidraw.c b/drivers/hid/hidraw.c
index 1ca6f46..30a6c0a 100644
--- a/drivers/hid/hidraw.c
+++ b/drivers/hid/hidraw.c
@@ -30,6 +30,7 @@
 #include <linux/major.h>
 #include <linux/hid.h>
 #include <linux/mutex.h>
+#include <linux/smp_lock.h>
 
 #include <linux/hidraw.h>
 
@@ -104,6 +105,7 @@ out:
 static ssize_t hidraw_write(struct file *file, const char __user *buffer, size_t count, loff_t *ppos)
 {
 	unsigned int minor = iminor(file->f_path.dentry->d_inode);
+	/* FIXME: What stops hidraw_table going NULL */
 	struct hid_device *dev = hidraw_table[minor]->hid;
 	__u8 *buf;
 	int ret = 0;
@@ -211,35 +213,38 @@ static int hidraw_release(struct inode * inode, struct file * file)
 	return 0;
 }
 
-static int hidraw_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
+static long hidraw_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
+	struct inode *inode = file->f_path.dentry->d_inode;
 	unsigned int minor = iminor(inode);
+	long ret = 0;
+	/* FIXME: What stops hidraw_table going NULL */
 	struct hidraw *dev = hidraw_table[minor];
 	void __user *user_arg = (void __user*) arg;
 
+	lock_kernel();
 	switch (cmd) {
 		case HIDIOCGRDESCSIZE:
 			if (put_user(dev->hid->rsize, (int __user *)arg))
-				return -EFAULT;
-			return 0;
+				ret = -EFAULT;
+			break;
 
 		case HIDIOCGRDESC:
 			{
 				__u32 len;
 
 				if (get_user(len, (int __user *)arg))
-					return -EFAULT;
-
-				if (len > HID_MAX_DESCRIPTOR_SIZE - 1)
-					return -EINVAL;
-
-				if (copy_to_user(user_arg + offsetof(
-								struct hidraw_report_descriptor,
-								value[0]),
-							dev->hid->rdesc,
-							min(dev->hid->rsize, len)))
-						return -EFAULT;
-				return 0;
+					ret = -EFAULT;
+				else if (len > HID_MAX_DESCRIPTOR_SIZE - 1)
+					ret = -EINVAL;
+				else if (copy_to_user(user_arg + offsetof(
+					struct hidraw_report_descriptor,
+					value[0]),
+					dev->hid->rdesc,
+					min(dev->hid->rsize, len)))
+					ret = -EFAULT;
+				break;
 			}
 		case HIDIOCGRAWINFO:
 			{
@@ -249,15 +254,13 @@ static int hidraw_ioctl(struct inode *inode, struct file *file, unsigned int cmd
 				dinfo.vendor = dev->hid->vendor;
 				dinfo.product = dev->hid->product;
 				if (copy_to_user(user_arg, &dinfo, sizeof(dinfo)))
-					return -EFAULT;
-
-				return 0;
+					ret = -EFAULT;
+				break;
 			}
 		default:
-			printk(KERN_EMERG "hidraw: unsupported ioctl() %x\n",
-					cmd);
+			ret = -ENOTTY;
 	}
-	return -EINVAL;
+	return ret;
 }
 
 static const struct file_operations hidraw_ops = {
@@ -267,7 +270,7 @@ static const struct file_operations hidraw_ops = {
 	.poll =         hidraw_poll,
 	.open =         hidraw_open,
 	.release =      hidraw_release,
-	.ioctl =        hidraw_ioctl,
+	.unlocked_ioctl = hidraw_ioctl,
 };
 
 void hidraw_report_event(struct hid_device *hid, u8 *data, int len)
