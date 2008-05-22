Return-Path: <linux-kernel-owner+w=401wt.eu-S934565AbYEVVUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934565AbYEVVUu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 17:20:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761397AbYEVVUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 17:20:21 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44085 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764477AbYEVVUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 17:20:19 -0400
Date: Thu, 22 May 2008 22:07:51 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] usblcd: Push down BKL into driver
Message-ID: <20080522220751.599d73ee@core>
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

I'm pretty sure this can be eliminated however I couldn't prove (or find)
what stopped the device vanishing mid IOCTL_GET_HARD_VERSION. Perhaps a
USB wizard could double check that and see if the lock_kernel can go
entirely.

Signed-off-by: Alan Cox <alan@redhat.com>

diff --git a/drivers/usb/misc/usblcd.c b/drivers/usb/misc/usblcd.c
index 7f7021e..2db4228 100644
--- a/drivers/usb/misc/usblcd.c
+++ b/drivers/usb/misc/usblcd.c
@@ -146,7 +146,7 @@ static ssize_t lcd_read(struct file *file, char __user * buffer, size_t count, l
 	return retval;
 }
 
-static int lcd_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
+static long lcd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct usb_lcd *dev;
 	u16 bcdDevice;
@@ -158,12 +158,14 @@ static int lcd_ioctl(struct inode *inode, struct file *file, unsigned int cmd, u
 	
 	switch (cmd) {
 	case IOCTL_GET_HARD_VERSION:
+		lock_kernel();
 		bcdDevice = le16_to_cpu((dev->udev)->descriptor.bcdDevice);
 		sprintf(buf,"%1d%1d.%1d%1d",
 			(bcdDevice & 0xF000)>>12,
 			(bcdDevice & 0xF00)>>8,
 			(bcdDevice & 0xF0)>>4,
 			(bcdDevice & 0xF));
+		unlock_kernel();
 		if (copy_to_user((void __user *)arg,buf,strlen(buf))!=0)
 			return -EFAULT;
 		break;
@@ -272,7 +274,7 @@ static const struct file_operations lcd_fops = {
         .read =         lcd_read,
         .write =        lcd_write,
         .open =         lcd_open,
-	.ioctl =        lcd_ioctl,
+	.unlocked_ioctl = lcd_ioctl,
         .release =      lcd_release,
 };
 
