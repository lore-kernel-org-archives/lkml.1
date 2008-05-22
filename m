Return-Path: <linux-kernel-owner+w=401wt.eu-S1762452AbYEVVQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762452AbYEVVQ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 17:16:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759476AbYEVVQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 17:16:04 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35132 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764308AbYEVVQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 17:16:00 -0400
Date: Thu, 22 May 2008 22:03:27 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] gadget: Push BKL down into drivers
Message-ID: <20080522220327.38e2347d@core>
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

This keeps the gadget ioctl method wrapped but pushes the BKL down into
the gadget code so we can use unlocked_ioctl().

Signed-off-by: Alan Cox <alan@redhat.com>

diff --git a/drivers/usb/gadget/inode.c b/drivers/usb/gadget/inode.c
index 69b0a27..dffb249 100644
--- a/drivers/usb/gadget/inode.c
+++ b/drivers/usb/gadget/inode.c
@@ -32,6 +32,7 @@
 #include <asm/uaccess.h>
 #include <linux/slab.h>
 #include <linux/poll.h>
+#include <linux/smp_lock.h>
 
 #include <linux/device.h>
 #include <linux/moduleparam.h>
@@ -483,8 +484,7 @@ ep_release (struct inode *inode, struct file *fd)
 	return 0;
 }
 
-static int ep_ioctl (struct inode *inode, struct file *fd,
-		unsigned code, unsigned long value)
+static long ep_ioctl(struct file *fd, unsigned code, unsigned long value)
 {
 	struct ep_data		*data = fd->private_data;
 	int			status;
@@ -740,7 +740,7 @@ static const struct file_operations ep_io_operations = {
 
 	.read =		ep_read,
 	.write =	ep_write,
-	.ioctl =	ep_ioctl,
+	.unlocked_ioctl = ep_ioctl,
 	.release =	ep_release,
 
 	.aio_read =	ep_aio_read,
@@ -1294,15 +1294,18 @@ out:
        return mask;
 }
 
-static int dev_ioctl (struct inode *inode, struct file *fd,
-		unsigned code, unsigned long value)
+static long dev_ioctl (struct file *fd, unsigned code, unsigned long value)
 {
 	struct dev_data		*dev = fd->private_data;
 	struct usb_gadget	*gadget = dev->gadget;
+	long ret = -ENOTTY;
 
-	if (gadget->ops->ioctl)
-		return gadget->ops->ioctl (gadget, code, value);
-	return -ENOTTY;
+	if (gadget->ops->ioctl) {
+		lock_kernel();
+		ret = gadget->ops->ioctl (gadget, code, value);
+		unlock_kernel();
+	}
+	return ret;
 }
 
 /* used after device configuration */
@@ -1314,7 +1317,7 @@ static const struct file_operations ep0_io_operations = {
 	.write =	ep0_write,
 	.fasync =	ep0_fasync,
 	.poll =		ep0_poll,
-	.ioctl =	dev_ioctl,
+	.unlocked_ioctl =	dev_ioctl,
 	.release =	dev_release,
 };
 
@@ -1964,7 +1967,7 @@ static const struct file_operations dev_init_operations = {
 	.open =		dev_open,
 	.write =	dev_config,
 	.fasync =	ep0_fasync,
-	.ioctl =	dev_ioctl,
+	.unlocked_ioctl = dev_ioctl,
 	.release =	dev_release,
 };
 
diff --git a/drivers/usb/gadget/printer.c b/drivers/usb/gadget/printer.c
index 76be75e..b5d0c0a 100644
--- a/drivers/usb/gadget/printer.c
+++ b/drivers/usb/gadget/printer.c
@@ -827,9 +827,8 @@ printer_poll(struct file *fd, poll_table *wait)
 	return status;
 }
 
-static int
-printer_ioctl(struct inode *inode, struct file *fd, unsigned int code,
-		unsigned long arg)
+static long
+printer_ioctl(struct file *fd, unsigned int code, unsigned long arg)
 {
 	struct printer_dev	*dev = fd->private_data;
 	unsigned long		flags;
@@ -868,7 +867,7 @@ static struct file_operations printer_io_operations = {
 	.write =	printer_write,
 	.fsync =	printer_fsync,
 	.poll =		printer_poll,
-	.ioctl =	printer_ioctl,
+	.unlocked_ioctl = printer_ioctl,
 	.release =	printer_close
 };
 
