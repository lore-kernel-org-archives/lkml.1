Return-Path: <linux-kernel-owner+w=401wt.eu-S1762970AbYEVWBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762970AbYEVWBa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 18:01:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760483AbYEVWBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 18:01:18 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56092 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759123AbYEVWBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 18:01:16 -0400
Date: Thu, 22 May 2008 22:48:48 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] sisusb: Push down the BKL
Message-ID: <20080522224848.318ea9a9@core>
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

This is another case where the lock_kernel appears to be unneccessary and
could be removed with a bit more investigative work

Signed-off-by: Alan Cox <alan@redhat.com>

diff --git a/drivers/usb/misc/sisusbvga/sisusb.c b/drivers/usb/misc/sisusbvga/sisusb.c
index cb7fa0e..8dca796 100644
--- a/drivers/usb/misc/sisusbvga/sisusb.c
+++ b/drivers/usb/misc/sisusbvga/sisusb.c
@@ -2982,9 +2982,8 @@ sisusb_handle_command(struct sisusb_usb_data *sisusb, struct sisusb_command *y,
 	return retval;
 }
 
-static int
-sisusb_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-							unsigned long arg)
+static long
+sisusb_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct sisusb_usb_data *sisusb;
 	struct sisusb_info x;
@@ -2995,6 +2994,7 @@ sisusb_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 	if (!(sisusb = (struct sisusb_usb_data *)file->private_data))
 		return -ENODEV;
 
+	lock_kernel();
 	mutex_lock(&sisusb->lock);
 
 	/* Sanity check */
@@ -3053,6 +3053,7 @@ sisusb_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 
 err_out:
 	mutex_unlock(&sisusb->lock);
+	unlock_kernel();
 	return retval;
 }
 
@@ -3066,9 +3067,7 @@ sisusb_compat_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
 		case SISUSB_GET_CONFIG_SIZE:
 		case SISUSB_GET_CONFIG:
 		case SISUSB_COMMAND:
-			lock_kernel();
-			retval = sisusb_ioctl(f->f_path.dentry->d_inode, f, cmd, arg);
-			unlock_kernel();
+			retval = sisusb_ioctl(f, cmd, arg);
 			return retval;
 
 		default:
@@ -3087,7 +3086,7 @@ static const struct file_operations usb_sisusb_fops = {
 #ifdef SISUSB_NEW_CONFIG_COMPAT
 	.compat_ioctl = sisusb_compat_ioctl,
 #endif
-	.ioctl =	sisusb_ioctl
+	.unlocked_ioctl = sisusb_ioctl
 };
 
 static struct usb_class_driver usb_sisusb_class = {
