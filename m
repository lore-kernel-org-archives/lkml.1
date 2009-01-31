Return-Path: <linux-kernel-owner+w=401wt.eu-S1761357AbZAaDD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761357AbZAaDD5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 22:03:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756716AbZAaCra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 21:47:30 -0500
Received: from kroah.org ([198.145.64.141]:55295 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756723AbZAaCrU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 21:47:20 -0500
Date: Fri, 30 Jan 2009 18:42:42 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Alan Stern <stern@rowland.harvard.edu>
Subject: [patch 14/43] USB: fix char-device disconnect handling
Message-ID: <20090131024242.GO12368@kroah.com>
References: <20090131022548.656772939@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-fix-char-device-disconnect-handling.patch"
In-Reply-To: <20090131024158.GA12368@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 501950d846218ed80a776d2aae5aed9c8b92e778 upstream.

This patch (as1198) fixes a conceptual bug: Somewhere along the line
we managed to confuse USB class devices with USB char devices.  As a
result, the code to send a disconnect signal to userspace would not be
built if both CONFIG_USB_DEVICE_CLASS and CONFIG_USB_DEVICEFS were
disabled.

The usb_fs_classdev_common_remove() routine has been renamed to
usbdev_remove() and it is now called whenever any USB device is
removed, not just when a class device is unregistered.  The notifier
registration and unregistration calls are no longer conditionally
compiled.  And since the common removal code will always be called as
part of the char device interface, there's no need to call it again as
part of the usbfs interface; thus the invocation of
usb_fs_classdev_common_remove() has been taken out of
usbfs_remove_device().

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-by: Alon Bar-Lev <alon.barlev@gmail.com>
Tested-by: Alon Bar-Lev <alon.barlev@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/devio.c |   20 ++++++++++++--------
 drivers/usb/core/inode.c |    1 -
 drivers/usb/core/usb.h   |    1 -
 3 files changed, 12 insertions(+), 10 deletions(-)

--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -1703,7 +1703,7 @@ const struct file_operations usbdev_file
 	.release =	usbdev_release,
 };
 
-void usb_fs_classdev_common_remove(struct usb_device *udev)
+static void usbdev_remove(struct usb_device *udev)
 {
 	struct dev_state *ps;
 	struct siginfo sinfo;
@@ -1745,10 +1745,15 @@ static void usb_classdev_remove(struct u
 {
 	if (dev->usb_classdev)
 		device_unregister(dev->usb_classdev);
-	usb_fs_classdev_common_remove(dev);
 }
 
-static int usb_classdev_notify(struct notifier_block *self,
+#else
+#define usb_classdev_add(dev)		0
+#define usb_classdev_remove(dev)	do {} while (0)
+
+#endif
+
+static int usbdev_notify(struct notifier_block *self,
 			       unsigned long action, void *dev)
 {
 	switch (action) {
@@ -1758,15 +1763,15 @@ static int usb_classdev_notify(struct no
 		break;
 	case USB_DEVICE_REMOVE:
 		usb_classdev_remove(dev);
+		usbdev_remove(dev);
 		break;
 	}
 	return NOTIFY_OK;
 }
 
 static struct notifier_block usbdev_nb = {
-	.notifier_call = 	usb_classdev_notify,
+	.notifier_call = 	usbdev_notify,
 };
-#endif
 
 static struct cdev usb_device_cdev;
 
@@ -1801,9 +1806,8 @@ int __init usb_devio_init(void)
 	 * to /sys/dev
 	 */
 	usb_classdev_class->dev_kobj = NULL;
-
-	usb_register_notify(&usbdev_nb);
 #endif
+	usb_register_notify(&usbdev_nb);
 out:
 	return retval;
 
@@ -1814,8 +1818,8 @@ error_cdev:
 
 void usb_devio_cleanup(void)
 {
-#ifdef CONFIG_USB_DEVICE_CLASS
 	usb_unregister_notify(&usbdev_nb);
+#ifdef CONFIG_USB_DEVICE_CLASS
 	class_destroy(usb_classdev_class);
 #endif
 	cdev_del(&usb_device_cdev);
--- a/drivers/usb/core/inode.c
+++ b/drivers/usb/core/inode.c
@@ -718,7 +718,6 @@ static void usbfs_remove_device(struct u
 		fs_remove_file (dev->usbfs_dentry);
 		dev->usbfs_dentry = NULL;
 	}
-	usb_fs_classdev_common_remove(dev);
 }
 
 static int usbfs_notify(struct notifier_block *self, unsigned long action, void *dev)
--- a/drivers/usb/core/usb.h
+++ b/drivers/usb/core/usb.h
@@ -148,7 +148,6 @@ extern struct usb_driver usbfs_driver;
 extern const struct file_operations usbfs_devices_fops;
 extern const struct file_operations usbdev_file_operations;
 extern void usbfs_conn_disc_event(void);
-extern void usb_fs_classdev_common_remove(struct usb_device *udev);
 
 extern int usb_devio_init(void);
 extern void usb_devio_cleanup(void);

