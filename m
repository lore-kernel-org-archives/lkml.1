Return-Path: <linux-kernel-owner+w=401wt.eu-S1763405AbYEVVTI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763405AbYEVVTI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 17:19:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763353AbYEVVSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 17:18:32 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44083 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760573AbYEVVSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 17:18:30 -0400
Date: Thu, 22 May 2008 22:06:02 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [PATCH] iowarrior: Push down BKL
Message-ID: <20080522220602.31397da8@core>
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

I'm pretty sure the mutex is sufficient for all locking but will come
back to that later if the USB folks don't beat me to it. For now get rid
of the old BKL ioctl method and wrap the ioctl handler

Signed-off-by: Alan Cox <alan@redhat.com>

diff --git a/drivers/usb/misc/iowarrior.c b/drivers/usb/misc/iowarrior.c
index 1cb54a2..e6ca997 100644
--- a/drivers/usb/misc/iowarrior.c
+++ b/drivers/usb/misc/iowarrior.c
@@ -474,8 +474,8 @@ exit:
 /**
  *	iowarrior_ioctl
  */
-static int iowarrior_ioctl(struct inode *inode, struct file *file,
-			   unsigned int cmd, unsigned long arg)
+static long iowarrior_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
 	struct iowarrior *dev = NULL;
 	__u8 *buffer;
@@ -493,6 +493,7 @@ static int iowarrior_ioctl(struct inode *inode, struct file *file,
 		return -ENOMEM;
 
 	/* lock this object */
+	lock_kernel();
 	mutex_lock(&dev->mutex);
 
 	/* verify that the device wasn't unplugged */
@@ -584,6 +585,7 @@ static int iowarrior_ioctl(struct inode *inode, struct file *file,
 error_out:
 	/* unlock the device */
 	mutex_unlock(&dev->mutex);
+	unlock_kernel();
 	kfree(buffer);
 	return retval;
 }
@@ -719,7 +721,7 @@ static const struct file_operations iowarrior_fops = {
 	.owner = THIS_MODULE,
 	.write = iowarrior_write,
 	.read = iowarrior_read,
-	.ioctl = iowarrior_ioctl,
+	.unlocked_ioctl = iowarrior_ioctl,
 	.open = iowarrior_open,
 	.release = iowarrior_release,
 	.poll = iowarrior_poll,
