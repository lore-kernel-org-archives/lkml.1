Return-Path: <linux-kernel-owner+w=401wt.eu-S1760130AbXJLXvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760130AbXJLXvU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 19:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757345AbXJLXvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 19:51:11 -0400
Received: from usul.saidi.cx ([204.11.33.34]:44674 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754667AbXJLXvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 19:51:10 -0400
Message-ID: <47100864.2090208@overt.org>
Date: Fri, 12 Oct 2007 16:51:00 -0700
From: Philip Langdale <philipl@overt.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] hiddev: Add 32bit ioctl compatibilty
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-RunX1: Yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The hiddev driver currently lacks 32bit ioctl compatibility, so
if you're running with a 64bit kernel and 32bit userspace, it won't
work.

I'm pretty sure that the only thing missing is a compat_ioctl
implementation as all structs have fixed size fields.

With this change I can use revoco to configure my MX Revolution mouse.

Signed-off-by: Philip Langdale <philipl@overt.org>

--- linux-2.6.23/drivers/hid/usbhid/hiddev.c	2007-10-09 13:31:38.000000000 -0700
+++ linux-phil/drivers/hid/usbhid/hiddev.c	2007-10-12 15:02:15.000000000 -0700
@@ -34,6 +34,7 @@
 #include <linux/usb.h>
 #include <linux/hid.h>
 #include <linux/hiddev.h>
+#include <linux/compat.h>
 #include "usbhid.h"

 #ifdef CONFIG_USB_DYNAMIC_MINORS
@@ -738,6 +738,14 @@
 	return -EINVAL;
 }

+#ifdef CONFIG_COMPAT
+static long hiddev_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	struct inode *inode = file->f_path.dentry->d_inode;
+	return hiddev_ioctl(inode, file, cmd, compat_ptr(arg));
+}
+#endif
+
 static const struct file_operations hiddev_fops = {
 	.owner =	THIS_MODULE,
 	.read =		hiddev_read,
@@ -747,6 +754,9 @@
 	.release =	hiddev_release,
 	.ioctl =	hiddev_ioctl,
 	.fasync =	hiddev_fasync,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	= hiddev_compat_ioctl,
+#endif
 };

 static struct usb_class_driver hiddev_class = {
