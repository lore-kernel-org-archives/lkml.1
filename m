Return-Path: <linux-kernel-owner+w=401wt.eu-S1753142AbZGZIUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142AbZGZIUc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 04:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753058AbZGZIUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 04:20:30 -0400
Received: from www.tglx.de ([62.245.132.106]:33820 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752819AbZGZIU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 04:20:27 -0400
Message-Id: <20090726081556.264284945@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sun, 26 Jul 2009 08:18:56 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [Patch RFC 23/37] usb: gadgetfs: Convert semaphore to mutex
References: <20090726081459.455111897@linutronix.de>
Content-Disposition: inline;
	filename=usb-gadget-inode-convert-semaphore-to-mutex.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The semaphore is used as mutex so make it a mutex.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/gadget/inode.c |   39 +++++++++++++++++++++------------------
 1 file changed, 21 insertions(+), 18 deletions(-)

Index: linux-2.6-tip/drivers/usb/gadget/inode.c
===================================================================
--- linux-2.6-tip.orig/drivers/usb/gadget/inode.c
+++ linux-2.6-tip/drivers/usb/gadget/inode.c
@@ -193,7 +193,7 @@ enum ep_state {
 };
 
 struct ep_data {
-	struct semaphore		lock;
+	struct mutex			lock;
 	enum ep_state			state;
 	atomic_t			count;
 	struct dev_data			*dev;
@@ -297,10 +297,10 @@ get_ready_ep (unsigned f_flags, struct e
 	int	val;
 
 	if (f_flags & O_NONBLOCK) {
-		if (down_trylock (&epdata->lock) != 0)
+		if (mutex_trylock(&epdata->lock) != 0)
 			goto nonblock;
 		if (epdata->state != STATE_EP_ENABLED) {
-			up (&epdata->lock);
+			mutex_unlock(&epdata->lock);
 nonblock:
 			val = -EAGAIN;
 		} else
@@ -308,7 +308,8 @@ nonblock:
 		return val;
 	}
 
-	if ((val = down_interruptible (&epdata->lock)) < 0)
+	val = mutex_lock_interruptible(&epdata->lock);
+	if (val < 0)
 		return val;
 
 	switch (epdata->state) {
@@ -322,7 +323,7 @@ nonblock:
 		// FALLTHROUGH
 	case STATE_EP_UNBOUND:			/* clean disconnect */
 		val = -ENODEV;
-		up (&epdata->lock);
+		mutex_unlock(&epdata->lock);
 	}
 	return val;
 }
@@ -392,7 +393,7 @@ ep_read (struct file *fd, char __user *b
 		if (likely (data->ep != NULL))
 			usb_ep_set_halt (data->ep);
 		spin_unlock_irq (&data->dev->lock);
-		up (&data->lock);
+		mutex_unlock(&data->lock);
 		return -EBADMSG;
 	}
 
@@ -410,7 +411,7 @@ ep_read (struct file *fd, char __user *b
 		value = -EFAULT;
 
 free1:
-	up (&data->lock);
+	mutex_unlock(&data->lock);
 	kfree (kbuf);
 	return value;
 }
@@ -435,7 +436,7 @@ ep_write (struct file *fd, const char __
 		if (likely (data->ep != NULL))
 			usb_ep_set_halt (data->ep);
 		spin_unlock_irq (&data->dev->lock);
-		up (&data->lock);
+		mutex_unlock(&data->lock);
 		return -EBADMSG;
 	}
 
@@ -454,7 +455,7 @@ ep_write (struct file *fd, const char __
 	VDEBUG (data->dev, "%s write %zu IN, status %d\n",
 		data->name, len, (int) value);
 free1:
-	up (&data->lock);
+	mutex_unlock(&data->lock);
 	kfree (kbuf);
 	return value;
 }
@@ -465,7 +466,8 @@ ep_release (struct inode *inode, struct 
 	struct ep_data		*data = fd->private_data;
 	int value;
 
-	if ((value = down_interruptible(&data->lock)) < 0)
+	value = mutex_lock_interruptible(&data->lock);
+	if (value < 0)
 		return value;
 
 	/* clean up if this can be reopened */
@@ -475,7 +477,7 @@ ep_release (struct inode *inode, struct 
 		data->hs_desc.bDescriptorType = 0;
 		usb_ep_disable(data->ep);
 	}
-	up (&data->lock);
+	mutex_unlock(&data->lock);
 	put_ep (data);
 	return 0;
 }
@@ -506,7 +508,7 @@ static long ep_ioctl(struct file *fd, un
 	} else
 		status = -ENODEV;
 	spin_unlock_irq (&data->dev->lock);
-	up (&data->lock);
+	mutex_unlock(&data->lock);
 	return status;
 }
 
@@ -672,7 +674,7 @@ fail:
 		value = -ENODEV;
 	spin_unlock_irq(&epdata->dev->lock);
 
-	up(&epdata->lock);
+	mutex_unlock(&epdata->lock);
 
 	if (unlikely(value)) {
 		kfree(priv);
@@ -764,7 +766,8 @@ ep_config (struct file *fd, const char _
 	u32			tag;
 	int			value, length = len;
 
-	if ((value = down_interruptible (&data->lock)) < 0)
+	value = mutex_lock_interruptible(&data->lock);
+	if (value < 0)
 		return value;
 
 	if (data->state != STATE_EP_READY) {
@@ -853,7 +856,7 @@ fail:
 		data->desc.bDescriptorType = 0;
 		data->hs_desc.bDescriptorType = 0;
 	}
-	up (&data->lock);
+	mutex_unlock(&data->lock);
 	return value;
 fail0:
 	value = -EINVAL;
@@ -869,7 +872,7 @@ ep_open (struct inode *inode, struct fil
 	struct ep_data		*data = inode->i_private;
 	int			value = -EBUSY;
 
-	if (down_interruptible (&data->lock) != 0)
+	if (mutex_lock_interruptible(&data->lock) != 0)
 		return -EINTR;
 	spin_lock_irq (&data->dev->lock);
 	if (data->dev->state == STATE_DEV_UNBOUND)
@@ -884,7 +887,7 @@ ep_open (struct inode *inode, struct fil
 		DBG (data->dev, "%s state %d\n",
 			data->name, data->state);
 	spin_unlock_irq (&data->dev->lock);
-	up (&data->lock);
+	mutex_unlock(&data->lock);
 	return value;
 }
 
@@ -1630,7 +1633,7 @@ static int activate_ep_files (struct dev
 		if (!data)
 			goto enomem0;
 		data->state = STATE_EP_DISABLED;
-		init_MUTEX (&data->lock);
+		mutex_init(&data->lock);
 		init_waitqueue_head (&data->wait);
 
 		strncpy (data->name, ep->name, sizeof (data->name) - 1);


