Return-Path: <linux-kernel-owner+w=401wt.eu-S1754402AbXJXBxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402AbXJXBxc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 21:53:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752826AbXJXBxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 21:53:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50757 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752712AbXJXBxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 21:53:23 -0400
Date: Tue, 23 Oct 2007 18:53:02 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-usb-devel@lists.sourceforge.net, greg@kroah.com,
       linux-kernel@vger.kernel.org, vitalivanov@gmail.com, netwiz@crc.id.au,
       zaitcev@redhat.com
Subject: Re: USB: FIx locks and urb->status in adutux
Message-Id: <20071023185302.5ce9d187.zaitcev@redhat.com>
In-Reply-To: <200710231138.38266.oliver@neukum.org>
References: <20071022203447.db6d7950.zaitcev@redhat.com>
	<200710231138.38266.oliver@neukum.org>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Two main issues fixed here are:
 - An improper use of in-struct lock to protect an open count
 - Use of urb status for -EINPROGRESS

Also, along the way:
 - Change usb_unlink_urb to usb_kill_urb. Apparently there's no need
   to use usb_unlink_urb whatsoever in this driver, and the old use of
   usb_kill_urb was outright racy (it unlinked and immediately freed).
 - Fix indentation in adu_write. Looks like it was damaged by a script.
 - Remove sleep_on.

Signed-off-by: Pete Zaitcev <zaitcev@redhat.com>

---

Oliver, thanks for the inftdata catch. I also fixed the sleep_on.
But I left the silly dances around usb_kill_urb in, at least for now.

diff --git a/drivers/usb/misc/adutux.c b/drivers/usb/misc/adutux.c
index c567aa7..d278161 100644
--- a/drivers/usb/misc/adutux.c
+++ b/drivers/usb/misc/adutux.c
@@ -79,12 +79,22 @@ MODULE_DEVICE_TABLE(usb, device_table);
 
 #define COMMAND_TIMEOUT	(2*HZ)	/* 60 second timeout for a command */
 
+/*
+ * The locking scheme is a vanilla 3-lock:
+ *   adu_device.buflock: A spinlock, covers what IRQs touch.
+ *   adutux_mutex:       A Static lock to cover open_count. It would also cover
+ *                       any globals, but we don't have them in 2.6.
+ *   adu_device.mtx:     A mutex to hold across sleepers like copy_from_user.
+ *                       It covers all of adu_device, except the open_count
+ *                       and what .buflock covers.
+ */
+
 /* Structure to hold all of our device specific stuff */
 struct adu_device {
-	struct mutex		mtx; /* locks this structure */
+	struct mutex		mtx;
 	struct usb_device*	udev; /* save off the usb device pointer */
 	struct usb_interface*	interface;
-	unsigned char		minor; /* the starting minor number for this device */
+	unsigned int		minor; /* the starting minor number for this device */
 	char			serial_number[8];
 
 	int			open_count; /* number of times this port has been opened */
@@ -107,8 +117,11 @@ struct adu_device {
 	char*			interrupt_out_buffer;
 	struct usb_endpoint_descriptor* interrupt_out_endpoint;
 	struct urb*		interrupt_out_urb;
+	int			out_urb_finished;
 };
 
+static DEFINE_MUTEX(adutux_mutex);
+
 static struct usb_driver adu_driver;
 
 static void adu_debug_data(int level, const char *function, int size,
@@ -132,29 +145,36 @@ static void adu_debug_data(int level, const char *function, int size,
  */
 static void adu_abort_transfers(struct adu_device *dev)
 {
+	unsigned long flags;
+
 	dbg(2," %s : enter", __FUNCTION__);
 
-	if (dev == NULL) {
-		dbg(1," %s : dev is null", __FUNCTION__);
-		goto exit;
-	}
+	mutex_lock(&dev->mtx);
 
 	if (dev->udev == NULL) {
 		dbg(1," %s : udev is null", __FUNCTION__);
 		goto exit;
 	}
 
-	dbg(2," %s : udev state %d", __FUNCTION__, dev->udev->state);
-	if (dev->udev->state == USB_STATE_NOTATTACHED) {
-		dbg(1," %s : udev is not attached", __FUNCTION__);
-		goto exit;
-	}
-
 	/* shutdown transfer */
-	usb_unlink_urb(dev->interrupt_in_urb);
-	usb_unlink_urb(dev->interrupt_out_urb);
+
+	/* XXX Anchor these instead */
+	spin_lock_irqsave(&dev->buflock, flags);
+	if (!dev->read_urb_finished) {
+		spin_unlock_irqrestore(&dev->buflock, flags);
+		usb_kill_urb(dev->interrupt_in_urb);
+	} else
+		spin_unlock_irqrestore(&dev->buflock, flags);
+
+	spin_lock_irqsave(&dev->buflock, flags);
+	if (!dev->out_urb_finished) {
+		spin_unlock_irqrestore(&dev->buflock, flags);
+		usb_kill_urb(dev->interrupt_out_urb);
+	} else
+		spin_unlock_irqrestore(&dev->buflock, flags);
 
 exit:
+	mutex_unlock(&dev->mtx);
 	dbg(2," %s : leave", __FUNCTION__);
 }
 
@@ -162,8 +182,6 @@ static void adu_delete(struct adu_device *dev)
 {
 	dbg(2, "%s enter", __FUNCTION__);
 
-	adu_abort_transfers(dev);
-
 	/* free data structures */
 	usb_free_urb(dev->interrupt_in_urb);
 	usb_free_urb(dev->interrupt_out_urb);
@@ -239,7 +257,10 @@ static void adu_interrupt_out_callback(struct urb *urb)
 		goto exit;
 	}
 
-	wake_up_interruptible(&dev->write_wait);
+	spin_lock(&dev->buflock);
+	dev->out_urb_finished = 1;
+	wake_up(&dev->write_wait);
+	spin_unlock(&dev->buflock);
 exit:
 
 	adu_debug_data(5, __FUNCTION__, urb->actual_length,
@@ -252,12 +273,17 @@ static int adu_open(struct inode *inode, struct file *file)
 	struct adu_device *dev = NULL;
 	struct usb_interface *interface;
 	int subminor;
-	int retval = 0;
+	int retval;
 
 	dbg(2,"%s : enter", __FUNCTION__);
 
 	subminor = iminor(inode);
 
+	if ((retval = mutex_lock_interruptible(&adutux_mutex))) {
+		dbg(2, "%s : mutex lock failed", __FUNCTION__);
+		goto exit_no_lock;
+	}
+
 	interface = usb_find_interface(&adu_driver, subminor);
 	if (!interface) {
 		err("%s - error, can't find device for minor %d",
@@ -272,13 +298,6 @@ static int adu_open(struct inode *inode, struct file *file)
 		goto exit_no_device;
 	}
 
-	/* lock this device */
-	if ((retval = mutex_lock_interruptible(&dev->mtx))) {
-		dbg(2, "%s : mutex lock failed", __FUNCTION__);
-		goto exit_no_device;
-	}
-
-	/* increment our usage count for the device */
 	++dev->open_count;
 	dbg(2,"%s : open count %d", __FUNCTION__, dev->open_count);
 
@@ -297,24 +316,25 @@ static int adu_open(struct inode *inode, struct file *file)
 				 le16_to_cpu(dev->interrupt_in_endpoint->wMaxPacketSize),
 				 adu_interrupt_in_callback, dev,
 				 dev->interrupt_in_endpoint->bInterval);
-		/* dev->interrupt_in_urb->transfer_flags |= URB_ASYNC_UNLINK; */
 		dev->read_urb_finished = 0;
 		retval = usb_submit_urb(dev->interrupt_in_urb, GFP_KERNEL);
-		if (retval)
+		if (retval) {
+			dev->read_urb_finished = 1;
 			--dev->open_count;
+		}
 	}
-	mutex_unlock(&dev->mtx);
+
+	retval = 0;
 
 exit_no_device:
+	mutex_unlock(&adutux_mutex);
+exit_no_lock:
 	dbg(2,"%s : leave, return value %d ", __FUNCTION__, retval);
-
 	return retval;
 }
 
-static int adu_release_internal(struct adu_device *dev)
+static void adu_release_internal(struct adu_device *dev)
 {
-	int retval = 0;
-
 	dbg(2," %s : enter", __FUNCTION__);
 
 	/* decrement our usage count for the device */
@@ -326,12 +346,11 @@ static int adu_release_internal(struct adu_device *dev)
 	}
 
 	dbg(2," %s : leave", __FUNCTION__);
-	return retval;
 }
 
 static int adu_release(struct inode *inode, struct file *file)
 {
-	struct adu_device *dev = NULL;
+	struct adu_device *dev;
 	int retval = 0;
 
 	dbg(2," %s : enter", __FUNCTION__);
@@ -343,15 +362,13 @@ static int adu_release(struct inode *inode, struct file *file)
 	}
 
 	dev = file->private_data;
-
 	if (dev == NULL) {
  		dbg(1," %s : object is NULL", __FUNCTION__);
 		retval = -ENODEV;
 		goto exit;
 	}
 
-	/* lock our device */
-	mutex_lock(&dev->mtx); /* not interruptible */
+	mutex_lock(&adutux_mutex); /* not interruptible */
 
 	if (dev->open_count <= 0) {
 		dbg(1," %s : device not opened", __FUNCTION__);
@@ -359,19 +376,15 @@ static int adu_release(struct inode *inode, struct file *file)
 		goto exit;
 	}
 
+	adu_release_internal(dev);
 	if (dev->udev == NULL) {
 		/* the device was unplugged before the file was released */
-		mutex_unlock(&dev->mtx);
-		adu_delete(dev);
-		dev = NULL;
-	} else {
-		/* do the work */
-		retval = adu_release_internal(dev);
+		if (!dev->open_count)	/* ... and we're the last user */
+			adu_delete(dev);
 	}
 
 exit:
-	if (dev)
-		mutex_unlock(&dev->mtx);
+	mutex_unlock(&adutux_mutex);
 	dbg(2," %s : leave, return value %d", __FUNCTION__, retval);
 	return retval;
 }
@@ -393,12 +406,12 @@ static ssize_t adu_read(struct file *file, __user char *buffer, size_t count,
 
 	dev = file->private_data;
 	dbg(2," %s : dev=%p", __FUNCTION__, dev);
-	/* lock this object */
+
 	if (mutex_lock_interruptible(&dev->mtx))
 		return -ERESTARTSYS;
 
 	/* verify that the device wasn't unplugged */
-	if (dev->udev == NULL || dev->minor == 0) {
+	if (dev->udev == NULL) {
 		retval = -ENODEV;
 		err("No device or device unplugged %d", retval);
 		goto exit;
@@ -452,7 +465,7 @@ static ssize_t adu_read(struct file *file, __user char *buffer, size_t count,
 				should_submit = 1;
 			} else {
 				/* even the primary was empty - we may need to do IO */
-				if (dev->interrupt_in_urb->status == -EINPROGRESS) {
+				if (!dev->read_urb_finished) {
 					/* somebody is doing IO */
 					spin_unlock_irqrestore(&dev->buflock, flags);
 					dbg(2," %s : submitted already", __FUNCTION__);
@@ -460,6 +473,7 @@ static ssize_t adu_read(struct file *file, __user char *buffer, size_t count,
 					/* we must initiate input */
 					dbg(2," %s : initiate input", __FUNCTION__);
 					dev->read_urb_finished = 0;
+					spin_unlock_irqrestore(&dev->buflock, flags);
 
 					usb_fill_int_urb(dev->interrupt_in_urb,dev->udev,
 							 usb_rcvintpipe(dev->udev,
@@ -470,14 +484,11 @@ static ssize_t adu_read(struct file *file, __user char *buffer, size_t count,
 							 dev,
 							 dev->interrupt_in_endpoint->bInterval);
 					retval = usb_submit_urb(dev->interrupt_in_urb, GFP_ATOMIC);
-					if (!retval) {
-						spin_unlock_irqrestore(&dev->buflock, flags);
-						dbg(2," %s : submitted OK", __FUNCTION__);
-					} else {
+					if (retval) {
+						dev->read_urb_finished = 1;
 						if (retval == -ENOMEM) {
 							retval = bytes_read ? bytes_read : -ENOMEM;
 						}
-						spin_unlock_irqrestore(&dev->buflock, flags);
 						dbg(2," %s : submit failed", __FUNCTION__);
 						goto exit;
 					}
@@ -486,10 +497,14 @@ static ssize_t adu_read(struct file *file, __user char *buffer, size_t count,
 				/* we wait for I/O to complete */
 				set_current_state(TASK_INTERRUPTIBLE);
 				add_wait_queue(&dev->read_wait, &wait);
-				if (!dev->read_urb_finished)
+				spin_lock_irqsave(&dev->buflock, flags);
+				if (!dev->read_urb_finished) {
+					spin_unlock_irqrestore(&dev->buflock, flags);
 					timeout = schedule_timeout(COMMAND_TIMEOUT);
-				else
+				} else {
+					spin_unlock_irqrestore(&dev->buflock, flags);
 					set_current_state(TASK_RUNNING);
+				}
 				remove_wait_queue(&dev->read_wait, &wait);
 
 				if (timeout <= 0) {
@@ -509,19 +524,23 @@ static ssize_t adu_read(struct file *file, __user char *buffer, size_t count,
 
 	retval = bytes_read;
 	/* if the primary buffer is empty then use it */
-	if (should_submit && !dev->interrupt_in_urb->status==-EINPROGRESS) {
+	spin_lock_irqsave(&dev->buflock, flags);
+	if (should_submit && dev->read_urb_finished) {
+		dev->read_urb_finished = 0;
+		spin_unlock_irqrestore(&dev->buflock, flags);
 		usb_fill_int_urb(dev->interrupt_in_urb,dev->udev,
 				 usb_rcvintpipe(dev->udev,
 				 		dev->interrupt_in_endpoint->bEndpointAddress),
-						dev->interrupt_in_buffer,
-						le16_to_cpu(dev->interrupt_in_endpoint->wMaxPacketSize),
-						adu_interrupt_in_callback,
-						dev,
-						dev->interrupt_in_endpoint->bInterval);
-		/* dev->interrupt_in_urb->transfer_flags |= URB_ASYNC_UNLINK; */
-		dev->read_urb_finished = 0;
-		usb_submit_urb(dev->interrupt_in_urb, GFP_KERNEL);
+				dev->interrupt_in_buffer,
+				le16_to_cpu(dev->interrupt_in_endpoint->wMaxPacketSize),
+				adu_interrupt_in_callback,
+				dev,
+				dev->interrupt_in_endpoint->bInterval);
+		if (usb_submit_urb(dev->interrupt_in_urb, GFP_KERNEL) != 0)
+			dev->read_urb_finished = 1;
 		/* we ignore failure */
+	} else {
+		spin_unlock_irqrestore(&dev->buflock, flags);
 	}
 
 exit:
@@ -535,24 +554,24 @@ exit:
 static ssize_t adu_write(struct file *file, const __user char *buffer,
 			 size_t count, loff_t *ppos)
 {
+	DECLARE_WAITQUEUE(waita, current);
 	struct adu_device *dev;
 	size_t bytes_written = 0;
 	size_t bytes_to_write;
 	size_t buffer_size;
+	unsigned long flags;
 	int retval;
-	int timeout = 0;
 
 	dbg(2," %s : enter, count = %Zd", __FUNCTION__, count);
 
 	dev = file->private_data;
 
-	/* lock this object */
 	retval = mutex_lock_interruptible(&dev->mtx);
 	if (retval)
 		goto exit_nolock;
 
 	/* verify that the device wasn't unplugged */
-	if (dev->udev == NULL || dev->minor == 0) {
+	if (dev->udev == NULL) {
 		retval = -ENODEV;
 		err("No device or device unplugged %d", retval);
 		goto exit;
@@ -564,42 +583,35 @@ static ssize_t adu_write(struct file *file, const __user char *buffer,
 		goto exit;
 	}
 
-
+	add_wait_queue(&dev->write_wait, &waita);
 	while (count > 0) {
-		if (dev->interrupt_out_urb->status == -EINPROGRESS) {
-			timeout = COMMAND_TIMEOUT;
+		set_current_state(TASK_INTERRUPTIBLE);
+		spin_lock_irqsave(&dev->buflock, flags);
+		if (!dev->out_urb_finished) {
+			spin_unlock_irqrestore(&dev->buflock, flags);
 
-			while (timeout > 0) {
-				if (signal_pending(current)) {
+			mutex_unlock(&dev->mtx);
+			if (signal_pending(current)) {
 				dbg(1," %s : interrupted", __FUNCTION__);
+				set_current_state(TASK_RUNNING);
 				retval = -EINTR;
-				goto exit;
+				goto exit_nolock;
+			}
+			if (schedule_timeout(COMMAND_TIMEOUT) == 0) {
+				dbg(1, "%s - command timed out.", __FUNCTION__);
+				retval = -ETIMEDOUT;
+				goto exit_nolock;
 			}
-			mutex_unlock(&dev->mtx);
-			timeout = interruptible_sleep_on_timeout(&dev->write_wait, timeout);
 			retval = mutex_lock_interruptible(&dev->mtx);
 			if (retval) {
 				retval = bytes_written ? bytes_written : retval;
 				goto exit_nolock;
 			}
-			if (timeout > 0) {
-				break;
-			}
-			dbg(1," %s : interrupted timeout: %d", __FUNCTION__, timeout);
-		}
-
-
-		dbg(1," %s : final timeout: %d", __FUNCTION__, timeout);
-
-		if (timeout == 0) {
-			dbg(1, "%s - command timed out.", __FUNCTION__);
-			retval = -ETIMEDOUT;
-			goto exit;
-		}
-
-		dbg(4," %s : in progress, count = %Zd", __FUNCTION__, count);
 
+			dbg(4," %s : in progress, count = %Zd", __FUNCTION__, count);
 		} else {
+			spin_unlock_irqrestore(&dev->buflock, flags);
+			set_current_state(TASK_RUNNING);
 			dbg(4," %s : sending, count = %Zd", __FUNCTION__, count);
 
 			/* write the data into interrupt_out_buffer from userspace */
@@ -623,10 +635,11 @@ static ssize_t adu_write(struct file *file, const __user char *buffer,
 				adu_interrupt_out_callback,
 				dev,
 				dev->interrupt_in_endpoint->bInterval);
-			/* dev->interrupt_in_urb->transfer_flags |= URB_ASYNC_UNLINK; */
 			dev->interrupt_out_urb->actual_length = bytes_to_write;
+			dev->out_urb_finished = 0;
 			retval = usb_submit_urb(dev->interrupt_out_urb, GFP_KERNEL);
 			if (retval < 0) {
+				dev->out_urb_finished = 1;
 				err("Couldn't submit interrupt_out_urb %d", retval);
 				goto exit;
 			}
@@ -637,11 +650,11 @@ static ssize_t adu_write(struct file *file, const __user char *buffer,
 			bytes_written += bytes_to_write;
 		}
 	}
+	remove_wait_queue(&dev->write_wait, &waita);
 
 	retval = bytes_written;
 
 exit:
-	/* unlock the device */
 	mutex_unlock(&dev->mtx);
 exit_nolock:
 
@@ -831,25 +844,22 @@ static void adu_disconnect(struct usb_interface *interface)
 	dbg(2," %s : enter", __FUNCTION__);
 
 	dev = usb_get_intfdata(interface);
-	usb_set_intfdata(interface, NULL);
 
+	mutex_lock(&dev->mtx);	/* not interruptible */
+	dev->udev = NULL;	/* poison */
 	minor = dev->minor;
-
-	/* give back our minor */
 	usb_deregister_dev(interface, &adu_class);
-	dev->minor = 0;
+	mutex_unlock(&dev->mtx);
 
-	mutex_lock(&dev->mtx); /* not interruptible */
+	mutex_lock(&adutux_mutex);
+	usb_set_intfdata(interface, NULL);
 
 	/* if the device is not opened, then we clean up right now */
 	dbg(2," %s : open count %d", __FUNCTION__, dev->open_count);
-	if (!dev->open_count) {
-		mutex_unlock(&dev->mtx);
+	if (!dev->open_count)
 		adu_delete(dev);
-	} else {
-		dev->udev = NULL;
-		mutex_unlock(&dev->mtx);
-	}
+
+	mutex_unlock(&adutux_mutex);
 
 	dev_info(&interface->dev, "ADU device adutux%d now disconnected\n",
 		 (minor - ADU_MINOR_BASE));
