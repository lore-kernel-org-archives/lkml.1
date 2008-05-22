Return-Path: <linux-kernel-owner+w=401wt.eu-S1759202AbYEVVfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759202AbYEVVfv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 17:35:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764026AbYEVVeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 17:34:50 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37309 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762915AbYEVVes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 17:34:48 -0400
Date: Thu, 22 May 2008 22:22:17 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com,
       linux-usb@vger.kernel.org
Subject: [PATCH] hiddev: Switch to unlocked_ioctl
Message-ID: <20080522222217.3a785487@core>
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

Push down the BKL. In some cases compat_ioctl already doesn't take the
BKL so we don't either. Some of the locking here seems already dubious
and object lifetimes want documenting

Signed-off-by: Alan Cox <alan@redhat.com>

diff --git a/drivers/hid/usbhid/hiddev.c b/drivers/hid/usbhid/hiddev.c
index 95cc192..fe4f364 100644
--- a/drivers/hid/usbhid/hiddev.c
+++ b/drivers/hid/usbhid/hiddev.c
@@ -406,6 +406,7 @@ static noinline int hiddev_ioctl_usage(struct hiddev *hiddev, unsigned int cmd,
 	uref_multi = kmalloc(sizeof(struct hiddev_usage_ref_multi), GFP_KERNEL);
 	if (!uref_multi)
 		return -ENOMEM;
+	lock_kernel();
 	uref = &uref_multi->uref;
 	if (cmd == HIDIOCGUSAGES || cmd == HIDIOCSUSAGES) {
 		if (copy_from_user(uref_multi, user_arg,
@@ -501,12 +502,15 @@ static noinline int hiddev_ioctl_usage(struct hiddev *hiddev, unsigned int cmd,
 		}
 
 goodreturn:
+		unlock_kernel();
 		kfree(uref_multi);
 		return 0;
 fault:
+		unlock_kernel();
 		kfree(uref_multi);
 		return -EFAULT;
 inval:
+		unlock_kernel();
 		kfree(uref_multi);
 		return -EINVAL;
 	}
@@ -540,7 +544,7 @@ static noinline int hiddev_ioctl_string(struct hiddev *hiddev, unsigned int cmd,
 	return len;
 }
 
-static int hiddev_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
+static long hiddev_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct hiddev_list *list = file->private_data;
 	struct hiddev *hiddev = list->hiddev;
@@ -555,7 +559,10 @@ static int hiddev_ioctl(struct inode *inode, struct file *file, unsigned int cmd
 	struct usbhid_device *usbhid = hid->driver_data;
 	void __user *user_arg = (void __user *)arg;
 	int i;
+	
+	/* Called without BKL by compat methods so no BKL taken */
 
+	/* FIXME: Who or what stop this racing with a disconnect ?? */
 	if (!hiddev->exist)
 		return -EIO;
 
@@ -768,7 +775,7 @@ static const struct file_operations hiddev_fops = {
 	.poll =		hiddev_poll,
 	.open =		hiddev_open,
 	.release =	hiddev_release,
-	.ioctl =	hiddev_ioctl,
+	.unlocked_ioctl =	hiddev_ioctl,
 	.fasync =	hiddev_fasync,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= hiddev_compat_ioctl,
