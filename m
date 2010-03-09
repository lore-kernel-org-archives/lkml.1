Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751760Ab0CIGQL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 01:16:11 -0500
Received: from mail-yw0-f189.google.com ([209.85.211.189]:53625 "EHLO
	mail-yw0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526Ab0CIGPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 01:15:54 -0500
From: Eli Lindsey <eli@siliconsprawl.com>
To: gregkh@suse.de, d@teklibre.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Eli Lindsey <eli@siliconsprawl.com>
Subject: [PATCH 4/4] staging: frontier: switch semaphores to mutexes
Date: Tue,  9 Mar 2010 00:15:33 -0600
Message-Id: <1268115333-7971-4-git-send-email-eli@siliconsprawl.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1268115333-7971-3-git-send-email-eli@siliconsprawl.com>
References: <1268115333-7971-1-git-send-email-eli@siliconsprawl.com>
 <1268115333-7971-2-git-send-email-eli@siliconsprawl.com>
 <1268115333-7971-3-git-send-email-eli@siliconsprawl.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the use of semaphores in alphatrack.c and tranzport.c to
mutexes at the suggestion of checkpatch.pl

Signed-off-by: Eli Lindsey <eli@siliconsprawl.com>
---
 drivers/staging/frontier/alphatrack.c |   28 ++++++++++++++--------------
 drivers/staging/frontier/tranzport.c  |   28 ++++++++++++++--------------
 2 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/frontier/alphatrack.c b/drivers/staging/frontier/alphatrack.c
index ce4d663..4e52105 100644
--- a/drivers/staging/frontier/alphatrack.c
+++ b/drivers/staging/frontier/alphatrack.c
@@ -134,7 +134,7 @@ MODULE_PARM_DESC(min_interrupt_out_interval,
 /* Structure to hold all of our device specific stuff */
 
 struct usb_alphatrack {
-	struct semaphore sem;	/* locks this structure */
+	struct mutex mtx;	/* locks this structure */
 	struct usb_interface *intf;	/* save off the usb interface pointer */
 	int open_count;		/* number of times this port has been opened */
 
@@ -347,7 +347,7 @@ static int usb_alphatrack_open(struct inode *inode, struct file *file)
 	}
 
 	/* lock this device */
-	if (down_interruptible(&dev->sem)) {
+	if (mutex_lock_interruptible(&dev->mtx)) {
 		retval = -ERESTARTSYS;
 		goto unlock_disconnect_exit;
 	}
@@ -390,7 +390,7 @@ static int usb_alphatrack_open(struct inode *inode, struct file *file)
 	file->private_data = dev;
 
 unlock_exit:
-	up(&dev->sem);
+	mutex_unlock(&dev->mtx);
 
 unlock_disconnect_exit:
 	mutex_unlock(&disconnect_mutex);
@@ -413,7 +413,7 @@ static int usb_alphatrack_release(struct inode *inode, struct file *file)
 		goto exit;
 	}
 
-	if (down_interruptible(&dev->sem)) {
+	if (mutex_lock_interruptible(&dev->mtx)) {
 		retval = -ERESTARTSYS;
 		goto exit;
 	}
@@ -425,7 +425,7 @@ static int usb_alphatrack_release(struct inode *inode, struct file *file)
 
 	if (dev->intf == NULL) {
 		/* the device was unplugged before the file was released */
-		up(&dev->sem);
+		mutex_unlock(&dev->mtx);
 		/* unlock here as usb_alphatrack_delete frees dev */
 		usb_alphatrack_delete(dev);
 		retval = -ENODEV;
@@ -441,7 +441,7 @@ static int usb_alphatrack_release(struct inode *inode, struct file *file)
 	dev->open_count = 0;
 
 unlock_exit:
-	up(&dev->sem);
+	mutex_unlock(&dev->mtx);
 
 exit:
 	return retval;
@@ -486,7 +486,7 @@ static ssize_t usb_alphatrack_read(struct file *file, char __user *buffer,
 		goto exit;
 
 	/* lock this object */
-	if (down_interruptible(&dev->sem)) {
+	if (mutex_lock_interruptible(&dev->mtx)) {
 		retval = -ERESTARTSYS;
 		goto exit;
 	}
@@ -532,7 +532,7 @@ static ssize_t usb_alphatrack_read(struct file *file, char __user *buffer,
 
 unlock_exit:
 	/* unlock the device */
-	up(&dev->sem);
+	mutex_unlock(&dev->mtx);
 
 exit:
 	return retval;
@@ -556,7 +556,7 @@ static ssize_t usb_alphatrack_write(struct file *file,
 		goto exit;
 
 	/* lock this object */
-	if (down_interruptible(&dev->sem)) {
+	if (mutex_lock_interruptible(&dev->mtx)) {
 		retval = -ERESTARTSYS;
 		goto exit;
 	}
@@ -627,7 +627,7 @@ static ssize_t usb_alphatrack_write(struct file *file,
 
 unlock_exit:
 	/* unlock the device */
-	up(&dev->sem);
+	mutex_unlock(&dev->mtx);
 
 exit:
 	return retval;
@@ -678,7 +678,7 @@ static int usb_alphatrack_probe(struct usb_interface *intf,
 		dev_err(&intf->dev, "Out of memory\n");
 		goto exit;
 	}
-	init_MUTEX(&dev->sem);
+	mutex_init(&dev->mtx);
 	dev->intf = intf;
 	init_waitqueue_head(&dev->read_wait);
 	init_waitqueue_head(&dev->write_wait);
@@ -835,7 +835,7 @@ static void usb_alphatrack_disconnect(struct usb_interface *intf)
 	dev = usb_get_intfdata(intf);
 	usb_set_intfdata(intf, NULL);
 
-	down(&dev->sem);
+	mutex_lock(&dev->mtx);
 
 	minor = intf->minor;
 
@@ -844,11 +844,11 @@ static void usb_alphatrack_disconnect(struct usb_interface *intf)
 
 	/* if the device is not opened, then we clean up right now */
 	if (!dev->open_count) {
-		up(&dev->sem);
+		mutex_unlock(&dev->mtx);
 		usb_alphatrack_delete(dev);
 	} else {
 		dev->intf = NULL;
-		up(&dev->sem);
+		mutex_unlock(&dev->mtx);
 	}
 
 	atomic_set(&dev->writes_pending, 0);
diff --git a/drivers/staging/frontier/tranzport.c b/drivers/staging/frontier/tranzport.c
index f9ab4f3..eed74f0 100644
--- a/drivers/staging/frontier/tranzport.c
+++ b/drivers/staging/frontier/tranzport.c
@@ -123,7 +123,7 @@ struct tranzport_cmd {
 /* Structure to hold all of our device specific stuff */
 
 struct usb_tranzport {
-	struct semaphore sem;	/* locks this structure */
+	struct mutex mtx;	/* locks this structure */
 	struct usb_interface *intf;	/* save off the usb interface pointer */
 	int open_count;		/* number of times this port opened */
 	struct tranzport_cmd (*ring_buffer)[RING_BUFFER_SIZE];
@@ -367,7 +367,7 @@ static int usb_tranzport_open(struct inode *inode, struct file *file)
 	}
 
 	/* lock this device */
-	if (down_interruptible(&dev->sem)) {
+	if (mutex_lock_interruptible(&dev->mtx)) {
 		retval = -ERESTARTSYS;
 		goto unlock_disconnect_exit;
 	}
@@ -411,7 +411,7 @@ static int usb_tranzport_open(struct inode *inode, struct file *file)
 	file->private_data = dev;
 
 unlock_exit:
-	up(&dev->sem);
+	mutex_unlock(&dev->mtx);
 
 unlock_disconnect_exit:
 	mutex_unlock(&disconnect_mutex);
@@ -434,7 +434,7 @@ static int usb_tranzport_release(struct inode *inode, struct file *file)
 		goto exit;
 	}
 
-	if (down_interruptible(&dev->sem)) {
+	if (mutex_lock_interruptible(&dev->mtx)) {
 		retval = -ERESTARTSYS;
 		goto exit;
 	}
@@ -446,7 +446,7 @@ static int usb_tranzport_release(struct inode *inode, struct file *file)
 
 	if (dev->intf == NULL) {
 		/* the device was unplugged before the file was released */
-		up(&dev->sem);
+		mutex_unlock(&dev->mtx);
 		/* unlock here as usb_tranzport_delete frees dev */
 		usb_tranzport_delete(dev);
 		retval = -ENODEV;
@@ -462,7 +462,7 @@ static int usb_tranzport_release(struct inode *inode, struct file *file)
 	dev->open_count = 0;
 
 unlock_exit:
-	up(&dev->sem);
+	mutex_unlock(&dev->mtx);
 
 exit:
 	return retval;
@@ -512,7 +512,7 @@ static ssize_t usb_tranzport_read(struct file *file, char __user *buffer,
 		goto exit;
 
 	/* lock this object */
-	if (down_interruptible(&dev->sem)) {
+	if (mutex_lock_interruptible(&dev->mtx)) {
 		retval = -ERESTARTSYS;
 		goto exit;
 	}
@@ -660,7 +660,7 @@ retval = 8;
 
 unlock_exit:
 /* unlock the device */
-up(&dev->sem);
+mutex_unlock(&dev->mtx);
 
 exit:
 return retval;
@@ -684,7 +684,7 @@ static ssize_t usb_tranzport_write(struct file *file,
 		goto exit;
 
 	/* lock this object */
-	if (down_interruptible(&dev->sem)) {
+	if (mutex_lock_interruptible(&dev->mtx)) {
 		retval = -ERESTARTSYS;
 		goto exit;
 	}
@@ -753,7 +753,7 @@ static ssize_t usb_tranzport_write(struct file *file,
 
 unlock_exit:
 	/* unlock the device */
-	up(&dev->sem);
+	mutex_unlock(&dev->mtx);
 
 exit:
 	return retval;
@@ -802,7 +802,7 @@ static int usb_tranzport_probe(struct usb_interface *intf,
 		dev_err(&intf->dev, "Out of memory\n");
 		goto exit;
 	}
-	init_MUTEX(&dev->sem);
+	mutex_init(&dev->mtx);
 	dev->intf = intf;
 	init_waitqueue_head(&dev->read_wait);
 	init_waitqueue_head(&dev->write_wait);
@@ -942,18 +942,18 @@ static void usb_tranzport_disconnect(struct usb_interface *intf)
 	mutex_lock(&disconnect_mutex);
 	dev = usb_get_intfdata(intf);
 	usb_set_intfdata(intf, NULL);
-	down(&dev->sem);
+	mutex_lock(&dev->mtx);
 	minor = intf->minor;
 	/* give back our minor */
 	usb_deregister_dev(intf, &usb_tranzport_class);
 
 	/* if the device is not opened, then we clean up right now */
 	if (!dev->open_count) {
-		up(&dev->sem);
+		mutex_unlock(&dev->mtx);
 		usb_tranzport_delete(dev);
 	} else {
 		dev->intf = NULL;
-		up(&dev->sem);
+		mutex_unlock(&dev->mtx);
 	}
 
 	mutex_unlock(&disconnect_mutex);
-- 
1.6.3.3

