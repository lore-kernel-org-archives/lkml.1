Return-Path: <linux-kernel-owner+w=401wt.eu-S1754672Ab0A2UkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672Ab0A2UkA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 15:40:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755210Ab0A2Ujg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 15:39:36 -0500
Received: from www.tglx.de ([62.245.132.106]:44780 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755129Ab0A2UjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 15:39:21 -0500
Message-Id: <20100129203613.628793121@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 29 Jan 2010 20:38:59 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 07/10] usb: gadgetfs: Convert semaphore to mutex
References: <20100129203549.526478432@linutronix.de>
Content-Disposition: inline; filename=usb-gadgetfs-convert-sema.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The semaphore data->lock is semantically a mutex. Convert it to a real
mutex.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/gadget/inode.c |   39 +++++++++++++++++++++------------------
 1 file changed, 21 insertions(+), 18 deletions(-)

Index: linux-2.6-tip/drivers/usb/gadget/inode.c
===================================================================
--- linux-2.6-tip.orig/drivers/usb/gadget/inode.c
+++ linux-2.6-tip/drivers/usb/gadget/inode.c
@@ -194,7 +194,7 @@ enum ep_state {
 };
 
 struct ep_data {
-	struct semaphore		lock;
+	struct mutex			lock;
 	enum ep_state			state;
 	atomic_t			count;
 	struct dev_data			*dev;
@@ -298,10 +298,10 @@ get_ready_ep (unsigned f_flags, struct e
 	int	val;
 
 	if (f_flags & O_NONBLOCK) {
-		if (down_trylock (&epdata->lock) != 0)
+		if (!mutex_trylock(&epdata->lock))
 			goto nonblock;
 		if (epdata->state != STATE_EP_ENABLED) {
-			up (&epdata->lock);
+			mutex_unlock(&epdata->lock);
 nonblock:
 			val = -EAGAIN;
 		} else
@@ -309,7 +309,8 @@ nonblock:
 		return val;
 	}
 
-	if ((val = down_interruptible (&epdata->lock)) < 0)
+	val = mutex_lock_interruptible(&epdata->lock);
+	if (val < 0)
 		return val;
 
 	switch (epdata->state) {
@@ -323,7 +324,7 @@ nonblock:
 		// FALLTHROUGH
 	case STATE_EP_UNBOUND:			/* clean disconnect */
 		val = -ENODEV;
-		up (&epdata->lock);
+		mutex_unlock(&epdata->lock);
 	}
 	return val;
 }
@@ -393,7 +394,7 @@ ep_read (struct file *fd, char __user *b
 		if (likely (data->ep != NULL))
 			usb_ep_set_halt (data->ep);
 		spin_unlock_irq (&data->dev->lock);
-		up (&data->lock);
+		mutex_unlock(&data->lock);
 		return -EBADMSG;
 	}
 
@@ -411,7 +412,7 @@ ep_read (struct file *fd, char __user *b
 		value = -EFAULT;
 
 free1:
-	up (&data->lock);
+	mutex_unlock(&data->lock);
 	kfree (kbuf);
 	return value;
 }
@@ -436,7 +437,7 @@ ep_write (struct file *fd, const char __
 		if (likely (data->ep != NULL))
 			usb_ep_set_halt (data->ep);
 		spin_unlock_irq (&data->dev->lock);
-		up (&data->lock);
+		mutex_unlock(&data->lock);
 		return -EBADMSG;
 	}
 
@@ -455,7 +456,7 @@ ep_write (struct file *fd, const char __
 	VDEBUG (data->dev, "%s write %zu IN, status %d\n",
 		data->name, len, (int) value);
 free1:
-	up (&data->lock);
+	mutex_unlock(&data->lock);
 	kfree (kbuf);
 	return value;
 }
@@ -466,7 +467,8 @@ ep_release (struct inode *inode, struct 
 	struct ep_data		*data = fd->private_data;
 	int value;
 
-	if ((value = down_interruptible(&data->lock)) < 0)
+	value = mutex_lock_interruptible(&data->lock);
+	if (value < 0)
 		return value;
 
 	/* clean up if this can be reopened */
@@ -476,7 +478,7 @@ ep_release (struct inode *inode, struct 
 		data->hs_desc.bDescriptorType = 0;
 		usb_ep_disable(data->ep);
 	}
-	up (&data->lock);
+	mutex_unlock(&data->lock);
 	put_ep (data);
 	return 0;
 }
@@ -507,7 +509,7 @@ static long ep_ioctl(struct file *fd, un
 	} else
 		status = -ENODEV;
 	spin_unlock_irq (&data->dev->lock);
-	up (&data->lock);
+	mutex_unlock(&data->lock);
 	return status;
 }
 
@@ -673,7 +675,7 @@ fail:
 		value = -ENODEV;
 	spin_unlock_irq(&epdata->dev->lock);
 
-	up(&epdata->lock);
+	mutex_unlock(&epdata->lock);
 
 	if (unlikely(value)) {
 		kfree(priv);
@@ -765,7 +767,8 @@ ep_config (struct file *fd, const char _
 	u32			tag;
 	int			value, length = len;
 
-	if ((value = down_interruptible (&data->lock)) < 0)
+	value = mutex_lock_interruptible(&data->lock);
+	if (value < 0)
 		return value;
 
 	if (data->state != STATE_EP_READY) {
@@ -854,7 +857,7 @@ fail:
 		data->desc.bDescriptorType = 0;
 		data->hs_desc.bDescriptorType = 0;
 	}
-	up (&data->lock);
+	mutex_unlock(&data->lock);
 	return value;
 fail0:
 	value = -EINVAL;
@@ -870,7 +873,7 @@ ep_open (struct inode *inode, struct fil
 	struct ep_data		*data = inode->i_private;
 	int			value = -EBUSY;
 
-	if (down_interruptible (&data->lock) != 0)
+	if (mutex_lock_interruptible(&data->lock) != 0)
 		return -EINTR;
 	spin_lock_irq (&data->dev->lock);
 	if (data->dev->state == STATE_DEV_UNBOUND)
@@ -885,7 +888,7 @@ ep_open (struct inode *inode, struct fil
 		DBG (data->dev, "%s state %d\n",
 			data->name, data->state);
 	spin_unlock_irq (&data->dev->lock);
-	up (&data->lock);
+	mutex_unlock(&data->lock);
 	return value;
 }
 
@@ -1631,7 +1634,7 @@ static int activate_ep_files (struct dev
 		if (!data)
 			goto enomem0;
 		data->state = STATE_EP_DISABLED;
-		init_MUTEX (&data->lock);
+		mutex_init(&data->lock);
 		init_waitqueue_head (&data->wait);
 
 		strncpy (data->name, ep->name, sizeof (data->name) - 1);


