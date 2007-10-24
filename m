Return-Path: <linux-kernel-owner+w=401wt.eu-S1753863AbXJXPFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863AbXJXPFN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 11:05:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752377AbXJXPFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 11:05:00 -0400
Received: from flatline.sindominio.net ([82.144.4.26]:48739 "EHLO
	flatline.sindominio.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbXJXPE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 11:04:59 -0400
X-Greylist: delayed 1723 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Oct 2007 11:04:58 EDT
Date: Wed, 24 Oct 2007 16:36:21 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
       v4l-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] usbvision: Convert semaphore to mutex
Message-ID: <20071024143621.GD9824@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	v4l-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

usbvision: Convert the usbvision->lock semaphore to the mutex API


Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--

diff --git a/drivers/media/video/usbvision/usbvision-core.c b/drivers/media/video/usbvision/usbvision-core.c
index c7d5f9e..2038d40 100644
--- a/drivers/media/video/usbvision/usbvision-core.c
+++ b/drivers/media/video/usbvision/usbvision-core.c
@@ -2242,14 +2242,18 @@ static void call_usbvision_power_off(struct work_struct *work)
 	struct usb_usbvision *usbvision = container_of(work, struct usb_usbvision, powerOffWork);
 
 	PDEBUG(DBG_FUNC, "");
-	down_interruptible(&usbvision->lock);
+	if(mutex_lock_interruptible(&usbvision->lock)) {
+		return;
+	}
+
+
 	if(usbvision->user == 0) {
 		usbvision_i2c_unregister(usbvision);
 
 		usbvision_power_off(usbvision);
 		usbvision->initialized = 0;
 	}
-	up(&usbvision->lock);
+	mutex_unlock(&usbvision->lock);
 }
 
 static void usbvision_powerOffTimer(unsigned long data)
diff --git a/drivers/media/video/usbvision/usbvision-video.c b/drivers/media/video/usbvision/usbvision-video.c
index e2f3c01..f36b1bf 100644
--- a/drivers/media/video/usbvision/usbvision-video.c
+++ b/drivers/media/video/usbvision/usbvision-video.c
@@ -410,7 +410,7 @@ static int usbvision_v4l2_open(struct inode *inode, struct file *file)
 
 	/* If so far no errors then we shall start the camera */
 	if (!errCode) {
-		down(&usbvision->lock);
+		mutex_lock(&usbvision->lock);
 		if (usbvision->power == 0) {
 			usbvision_power_on(usbvision);
 			usbvision_i2c_register(usbvision);
@@ -439,7 +439,7 @@ static int usbvision_v4l2_open(struct inode *inode, struct file *file)
 				usbvision->initialized = 0;
 			}
 		}
-		up(&usbvision->lock);
+		mutex_unlock(&usbvision->lock);
 	}
 
 	if (errCode) {
@@ -467,7 +467,7 @@ static int usbvision_v4l2_close(struct inode *inode, struct file *file)
 		(struct usb_usbvision *) video_get_drvdata(dev);
 
 	PDEBUG(DBG_IO, "close");
-	down(&usbvision->lock);
+	mutex_lock(&usbvision->lock);
 
 	usbvision_audio_off(usbvision);
 	usbvision_restart_isoc(usbvision);
@@ -487,7 +487,7 @@ static int usbvision_v4l2_close(struct inode *inode, struct file *file)
 		usbvision->initialized = 0;
 	}
 
-	up(&usbvision->lock);
+	mutex_unlock(&usbvision->lock);
 
 	if (usbvision->remove_pending) {
 		printk(KERN_INFO "%s: Final disconnect\n", __FUNCTION__);
@@ -647,13 +647,13 @@ static int vidioc_s_input (struct file *file, void *priv, unsigned int input)
 	if ((input >= usbvision->video_inputs) || (input < 0) )
 		return -EINVAL;
 
-	down(&usbvision->lock);
+	mutex_lock(&usbvision->lock);
 	usbvision_muxsel(usbvision, input);
 	usbvision_set_input(usbvision);
 	usbvision_set_output(usbvision,
 			     usbvision->curwidth,
 			     usbvision->curheight);
-	up(&usbvision->lock);
+	mutex_unlock(&usbvision->lock);
 	return 0;
 }
 
@@ -664,10 +664,10 @@ static int vidioc_s_std (struct file *file, void *priv, v4l2_std_id *id)
 		(struct usb_usbvision *) video_get_drvdata(dev);
 	usbvision->tvnormId=*id;
 
-	down(&usbvision->lock);
+	mutex_lock(&usbvision->lock);
 	call_i2c_clients(usbvision, VIDIOC_S_STD,
 			 &usbvision->tvnormId);
-	up(&usbvision->lock);
+	mutex_unlock(&usbvision->lock);
 	/* propagate the change to the decoder */
 	usbvision_muxsel(usbvision, usbvision->ctl_input);
 
@@ -1083,9 +1083,9 @@ static int vidioc_s_fmt_cap(struct file *file, void *priv,
 	usbvision->curFrame = NULL;
 
 	/* by now we are committed to the new data... */
-	down(&usbvision->lock);
+	mutex_lock(&usbvision->lock);
 	usbvision_set_output(usbvision, vf->fmt.pix.width, vf->fmt.pix.height);
-	up(&usbvision->lock);
+	mutex_unlock(&usbvision->lock);
 
 	return 0;
 }
@@ -1211,16 +1211,16 @@ static int usbvision_v4l2_mmap(struct file *file, struct vm_area_struct *vma)
 
 	PDEBUG(DBG_MMAP, "mmap");
 
-	down(&usbvision->lock);
+	mutex_lock(&usbvision->lock);
 
 	if (!USBVISION_IS_OPERATIONAL(usbvision)) {
-		up(&usbvision->lock);
+		mutex_unlock(&usbvision->lock);
 		return -EFAULT;
 	}
 
 	if (!(vma->vm_flags & VM_WRITE) ||
 	    size != PAGE_ALIGN(usbvision->max_frame_size)) {
-		up(&usbvision->lock);
+		mutex_unlock(&usbvision->lock);
 		return -EINVAL;
 	}
 
@@ -1232,7 +1232,7 @@ static int usbvision_v4l2_mmap(struct file *file, struct vm_area_struct *vma)
 	if (i == usbvision->num_frames) {
 		PDEBUG(DBG_MMAP,
 		       "mmap: user supplied mapping address is out of range");
-		up(&usbvision->lock);
+		mutex_unlock(&usbvision->lock);
 		return -EINVAL;
 	}
 
@@ -1245,7 +1245,7 @@ static int usbvision_v4l2_mmap(struct file *file, struct vm_area_struct *vma)
 
 		if (vm_insert_page(vma, start, vmalloc_to_page(pos))) {
 			PDEBUG(DBG_MMAP, "mmap: vm_insert_page failed");
-			up(&usbvision->lock);
+			mutex_unlock(&usbvision->lock);
 			return -EAGAIN;
 		}
 		start += PAGE_SIZE;
@@ -1253,7 +1253,7 @@ static int usbvision_v4l2_mmap(struct file *file, struct vm_area_struct *vma)
 		size -= PAGE_SIZE;
 	}
 
-	up(&usbvision->lock);
+	mutex_unlock(&usbvision->lock);
 	return 0;
 }
 
@@ -1271,7 +1271,7 @@ static int usbvision_radio_open(struct inode *inode, struct file *file)
 
 	PDEBUG(DBG_IO, "%s:", __FUNCTION__);
 
-	down(&usbvision->lock);
+	mutex_lock(&usbvision->lock);
 
 	if (usbvision->user) {
 		err("%s: Someone tried to open an already opened USBVision Radio!", __FUNCTION__);
@@ -1307,7 +1307,7 @@ static int usbvision_radio_open(struct inode *inode, struct file *file)
 			usbvision->initialized = 0;
 		}
 	}
-	up(&usbvision->lock);
+	mutex_unlock(&usbvision->lock);
 	return errCode;
 }
 
@@ -1321,7 +1321,7 @@ static int usbvision_radio_close(struct inode *inode, struct file *file)
 
 	PDEBUG(DBG_IO, "");
 
-	down(&usbvision->lock);
+	mutex_lock(&usbvision->lock);
 
 	/* Set packet size to 0 */
 	usbvision->ifaceAlt=0;
@@ -1337,7 +1337,7 @@ static int usbvision_radio_close(struct inode *inode, struct file *file)
 		usbvision->initialized = 0;
 	}
 
-	up(&usbvision->lock);
+	mutex_unlock(&usbvision->lock);
 
 	if (usbvision->remove_pending) {
 		printk(KERN_INFO "%s: Final disconnect\n", __FUNCTION__);
@@ -1644,7 +1644,7 @@ static struct usb_usbvision *usbvision_alloc(struct usb_device *dev)
 
 	usbvision->dev = dev;
 
-	init_MUTEX(&usbvision->lock);	/* to 1 == available */
+	mutex_init(&usbvision->lock);	/* available */
 
 	// prepare control urb for control messages during interrupts
 	usbvision->ctrlUrb = usb_alloc_urb(USBVISION_URB_FRAMES, GFP_KERNEL);
@@ -1679,13 +1679,13 @@ static void usbvision_release(struct usb_usbvision *usbvision)
 {
 	PDEBUG(DBG_PROBE, "");
 
-	down(&usbvision->lock);
+	mutex_lock(&usbvision->lock);
 
 	usbvision_reset_powerOffTimer(usbvision);
 
 	usbvision->initialized = 0;
 
-	up(&usbvision->lock);
+	mutex_unlock(&usbvision->lock);
 
 	usbvision_remove_sysfs(usbvision->vdev);
 	usbvision_unregister_video(usbvision);
@@ -1799,7 +1799,7 @@ static int __devinit usbvision_probe(struct usb_interface *intf,
 	}
 	PDEBUG(DBG_PROBE, "bridgeType %d", usbvision->bridgeType);
 
-	down(&usbvision->lock);
+	mutex_lock(&usbvision->lock);
 
 	/* compute alternate max packet sizes */
 	uif = dev->actconfig->interface[0];
@@ -1843,7 +1843,7 @@ static int __devinit usbvision_probe(struct usb_interface *intf,
 	usbvision->streaming = Stream_Off;
 	usbvision_register_video(usbvision);
 	usbvision_configure_video(usbvision);
-	up(&usbvision->lock);
+	mutex_unlock(&usbvision->lock);
 
 
 	usb_set_intfdata (intf, usbvision);
@@ -1874,7 +1874,7 @@ static void __devexit usbvision_disconnect(struct usb_interface *intf)
 	}
 	usb_set_intfdata (intf, NULL);
 
-	down(&usbvision->lock);
+	mutex_lock(&usbvision->lock);
 
 	// At this time we ask to cancel outstanding URBs
 	usbvision_stop_isoc(usbvision);
@@ -1888,7 +1888,7 @@ static void __devexit usbvision_disconnect(struct usb_interface *intf)
 	usb_put_dev(usbvision->dev);
 	usbvision->dev = NULL;	// USB device is no more
 
-	up(&usbvision->lock);
+	mutex_unlock(&usbvision->lock);
 
 	if (usbvision->user) {
 		printk(KERN_INFO "%s: In use, disconnect pending\n",
diff --git a/drivers/media/video/usbvision/usbvision.h b/drivers/media/video/usbvision/usbvision.h
index c5b6c50..0fe4bff 100644
--- a/drivers/media/video/usbvision/usbvision.h
+++ b/drivers/media/video/usbvision/usbvision.h
@@ -34,6 +34,7 @@
 #include <linux/list.h>
 #include <linux/usb.h>
 #include <linux/i2c.h>
+#include <linux/mutex.h>
 #include <media/v4l2-common.h>
 #include <media/tuner.h>
 #include <linux/videodev2.h>
@@ -396,7 +397,7 @@ struct usb_usbvision {
 	unsigned char iface;						/* Video interface number */
 	unsigned char ifaceAlt;			/* Alt settings */
 	unsigned char Vin_Reg2_Preset;
-	struct semaphore lock;
+	struct mutex lock;
 	struct timer_list powerOffTimer;
 	struct work_struct powerOffWork;
 	int power;							/* is the device powered on? */
 
-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

        Representation of the world, like the world itself, is
        the work of men; they describe it from their own point
         of view, which they  confuse with the absolute truth
                          (Simone de Beauvoir)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
