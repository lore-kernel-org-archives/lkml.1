Return-Path: <linux-kernel-owner+w=401wt.eu-S937236AbXGMT1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937236AbXGMT1U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 15:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758828AbXGMT1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 15:27:11 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:39837
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757364AbXGMT1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 15:27:09 -0400
Date: Fri, 13 Jul 2007 21:28:31 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: gregkh@suse.de, linux-usb-users@lists.sourceforge.net,
       linux-usb-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 4/5] use mutex instead of semaphore in the Adutux driver
Message-ID: <20070713192831.GH18159@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	gregkh@suse.de, linux-usb-users@lists.sourceforge.net,
	linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
References: <20070713192023.GD18159@traven>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070713192023.GD18159@traven>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The Adutux driver uses a semaphore as mutex. Use the mutex API
instead of the (binary) semaphore.

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--

diff --git a/drivers/usb/misc/adutux.c b/drivers/usb/misc/adutux.c
index d72c42e..274d08e 100644
--- a/drivers/usb/misc/adutux.c
+++ b/drivers/usb/misc/adutux.c
@@ -24,6 +24,7 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/usb.h>
+#include <linux/mutex.h>
 #include <asm/uaccess.h>
 
 #ifdef CONFIG_USB_DEBUG
@@ -80,7 +81,7 @@ MODULE_DEVICE_TABLE(usb, device_table);
 
 /* Structure to hold all of our device specific stuff */
 struct adu_device {
-	struct semaphore	sem; /* locks this structure */
+	struct mutex		mtx; /* locks this structure */
 	struct usb_device*	udev; /* save off the usb device pointer */
 	struct usb_interface*	interface;
 	unsigned char		minor; /* the starting minor number for this device */
@@ -269,8 +270,8 @@ static int adu_open(struct inode *inode, struct file *file)
 	}
 
 	/* lock this device */
-	if ((retval = down_interruptible(&dev->sem))) {
-		dbg(2, "%s : sem down failed", __FUNCTION__);
+	if ((retval = mutex_lock_interruptible(&dev->mtx))) {
+		dbg(2, "%s : mutex lock failed", __FUNCTION__);
 		goto exit_no_device;
 	}
 
@@ -299,7 +300,7 @@ static int adu_open(struct inode *inode, struct file *file)
 		if (retval)
 			--dev->open_count;
 	}
-	up(&dev->sem);
+	mutex_unlock(&dev->mtx);
 
 exit_no_device:
 	dbg(2,"%s : leave, return value %d ", __FUNCTION__, retval);
@@ -347,7 +348,7 @@ static int adu_release(struct inode *inode, struct file *file)
 	}
 
 	/* lock our device */
-	down(&dev->sem); /* not interruptible */
+	mutex_lock(&dev->mtx); /* not interruptible */
 
 	if (dev->open_count <= 0) {
 		dbg(1," %s : device not opened", __FUNCTION__);
@@ -357,7 +358,7 @@ static int adu_release(struct inode *inode, struct file *file)
 
 	if (dev->udev == NULL) {
 		/* the device was unplugged before the file was released */
-		up(&dev->sem);
+		mutex_unlock(&dev->mtx);
 		adu_delete(dev);
 		dev = NULL;
 	} else {
@@ -367,7 +368,7 @@ static int adu_release(struct inode *inode, struct file *file)
 
 exit:
 	if (dev)
-		up(&dev->sem);
+		mutex_unlock(&dev->mtx);
 	dbg(2," %s : leave, return value %d", __FUNCTION__, retval);
 	return retval;
 }
@@ -390,7 +391,7 @@ static ssize_t adu_read(struct file *file, __user char *buffer, size_t count,
 	dev = file->private_data;
 	dbg(2," %s : dev=%p", __FUNCTION__, dev);
 	/* lock this object */
-	if (down_interruptible(&dev->sem))
+	if (mutex_lock_interruptible(&dev->mtx))
 		return -ERESTARTSYS;
 
 	/* verify that the device wasn't unplugged */
@@ -522,7 +523,7 @@ static ssize_t adu_read(struct file *file, __user char *buffer, size_t count,
 
 exit:
 	/* unlock the device */
-	up(&dev->sem);
+	mutex_unlock(&dev->mtx);
 
 	dbg(2," %s : leave, return value %d", __FUNCTION__, retval);
 	return retval;
@@ -543,7 +544,7 @@ static ssize_t adu_write(struct file *file, const __user char *buffer,
 	dev = file->private_data;
 
 	/* lock this object */
-	retval = down_interruptible(&dev->sem);
+	retval = mutex_lock_interruptible(&dev->mtx);
 	if (retval)
 		goto exit_nolock;
 
@@ -571,9 +572,9 @@ static ssize_t adu_write(struct file *file, const __user char *buffer,
 				retval = -EINTR;
 				goto exit;
 			}
-			up(&dev->sem);
+			mutex_unlock(&dev->mtx);
 			timeout = interruptible_sleep_on_timeout(&dev->write_wait, timeout);
-			retval = down_interruptible(&dev->sem);
+			retval = mutex_lock_interruptible(&dev->mtx);
 			if (retval) {
 				retval = bytes_written ? bytes_written : retval;
 				goto exit_nolock;
@@ -638,7 +639,7 @@ static ssize_t adu_write(struct file *file, const __user char *buffer,
 
 exit:
 	/* unlock the device */
-	up(&dev->sem);
+	mutex_unlock(&dev->mtx);
 exit_nolock:
 
 	dbg(2," %s : leave, return value %d", __FUNCTION__, retval);
@@ -698,7 +699,7 @@ static int adu_probe(struct usb_interface *interface,
 		goto exit;
 	}
 
-	init_MUTEX(&dev->sem);
+	mutex_init(&dev->mtx);
 	spin_lock_init(&dev->buflock);
 	dev->udev = udev;
 	init_waitqueue_head(&dev->read_wait);
@@ -835,16 +836,16 @@ static void adu_disconnect(struct usb_interface *interface)
 	usb_deregister_dev(interface, &adu_class);
 	dev->minor = 0;
 
-	down(&dev->sem); /* not interruptible */
+	mutex_lock(&dev->mtx); /* not interruptible */
 
 	/* if the device is not opened, then we clean up right now */
 	dbg(2," %s : open count %d", __FUNCTION__, dev->open_count);
 	if (!dev->open_count) {
-		up(&dev->sem);
+		mutex_unlock(&dev->mtx);
 		adu_delete(dev);
 	} else {
 		dev->udev = NULL;
-		up(&dev->sem);
+		mutex_unlock(&dev->mtx);
 	}
 
 	dev_info(&interface->dev, "ADU device adutux%d now disconnected",

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

      The assumption that what currently exists must necessarily
        exist is the acid that corrodes all visionary thinking
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
