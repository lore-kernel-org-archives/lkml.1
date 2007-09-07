Return-Path: <linux-kernel-owner+w=401wt.eu-S965626AbXIGNUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965626AbXIGNUG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 09:20:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965280AbXIGNTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 09:19:55 -0400
Received: from 30.5.221.87.dynamic.jazztel.es ([87.221.5.30]:49785 "EHLO
	traven.no-ip.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965116AbXIGNTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 09:19:53 -0400
X-Greylist: delayed 540 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Sep 2007 09:19:52 EDT
Date: Fri, 7 Sep 2007 15:10:54 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: gregkh@suse.de, linux-usb-users@lists.sourceforge.net,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 2/2] ELAN U132 Host Controller Driver: convert
	scheduler_lock to mutex
Message-ID: <20070907131054.GL3081@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	gregkh@suse.de, linux-usb-users@lists.sourceforge.net,
	linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
References: <20070906210922.GC3081@traven> <20070906211958.GE3081@traven>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070906211958.GE3081@traven>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A corrected version of the patch, the first one contained context
removed by the first patch of this serie

--

The ELAN U132 Host Controller Driver uses the semaphore scheduler_lock
as mutex. Use the mutex API instead of the (binary) semaphore.

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--

--- linux-2.6/drivers/usb/host/u132-hcd.c.orig	2007-09-07 15:04:11.000000000 +0200
+++ linux-2.6/drivers/usb/host/u132-hcd.c	2007-09-07 15:05:21.000000000 +0200
@@ -185,7 +185,7 @@
         struct kref kref;
         struct list_head u132_list;
         struct mutex sw_lock;
-        struct semaphore scheduler_lock;
+        struct mutex scheduler_lock;
         struct u132_platform_data *board;
         struct platform_device *platform_dev;
         struct u132_ring ring[MAX_U132_RINGS];
@@ -536,12 +536,12 @@
                 endp->active = 0;
                 spin_unlock_irqrestore(&endp->queue_lock.slock, irqs);
                 kfree(urbq);
-        } down(&u132->scheduler_lock);
+        } mutex_lock(&u132->scheduler_lock);
         ring = endp->ring;
         ring->in_use = 0;
         u132_ring_cancel_work(u132, ring);
         u132_ring_queue_work(u132, ring, 0);
-        up(&u132->scheduler_lock);
+        mutex_unlock(&u132->scheduler_lock);
         u132_endp_put_kref(u132, endp);
         usb_hcd_giveback_urb(hcd, urb);
         return;
@@ -633,22 +633,22 @@
         struct u132 *u132 = endp->u132;
         u8 address = u132->addr[endp->usb_addr].address;
         struct u132_udev *udev = &u132->udev[address];
-        down(&u132->scheduler_lock);
+        mutex_lock(&u132->scheduler_lock);
         if (u132->going > 1) {
                 dev_err(&u132->platform_dev->dev, "device has been removed %d\n"
                         , u132->going);
-                up(&u132->scheduler_lock);
+                mutex_unlock(&u132->scheduler_lock);
                 u132_hcd_forget_urb(u132, endp, urb, -ENODEV);
                 return;
         } else if (endp->dequeueing) {
                 endp->dequeueing = 0;
-                up(&u132->scheduler_lock);
+                mutex_unlock(&u132->scheduler_lock);
                 u132_hcd_giveback_urb(u132, endp, urb, -EINTR);
                 return;
         } else if (u132->going > 0) {
                 dev_err(&u132->platform_dev->dev, "device is being removed urb="
                         "%p status=%d\n", urb, urb->status);
-                up(&u132->scheduler_lock);
+                mutex_unlock(&u132->scheduler_lock);
                 u132_hcd_giveback_urb(u132, endp, urb, -ENODEV);
                 return;
         } else if (urb->status == -EINPROGRESS) {
@@ -667,7 +667,7 @@
                                 1 & toggle_bits);
                         if (urb->actual_length > 0) {
                                 int retval;
-                                up(&u132->scheduler_lock);
+                                mutex_unlock(&u132->scheduler_lock);
                                 retval = edset_single(u132, ring, endp, urb,
                                         address, endp->toggle_bits,
                                         u132_hcd_interrupt_recv);
@@ -682,7 +682,7 @@
                                         msecs_to_jiffies(urb->interval);
                                 u132_ring_cancel_work(u132, ring);
                                 u132_ring_queue_work(u132, ring, 0);
-                                up(&u132->scheduler_lock);
+                                mutex_unlock(&u132->scheduler_lock);
                                 u132_endp_put_kref(u132, endp);
                         }
                         return;
@@ -691,7 +691,7 @@
                         endp->toggle_bits = toggle_bits;
                         usb_settoggle(udev->usb_device, endp->usb_endp, 0,
                                 1 & toggle_bits);
-                        up(&u132->scheduler_lock);
+                        mutex_unlock(&u132->scheduler_lock);
                         u132_hcd_giveback_urb(u132, endp, urb, 0);
                         return;
                 } else {
@@ -711,7 +711,7 @@
                                         "g back INTERRUPT %s\n", urb,
                                         cc_to_text[condition_code]);
                         }
-                        up(&u132->scheduler_lock);
+                        mutex_unlock(&u132->scheduler_lock);
                         u132_hcd_giveback_urb(u132, endp, urb,
                                 cc_to_error[condition_code]);
                         return;
@@ -719,7 +719,7 @@
         } else {
                 dev_err(&u132->platform_dev->dev, "CALLBACK called urb=%p statu"
                         "s=%d\n", urb, urb->status);
-                up(&u132->scheduler_lock);
+                mutex_unlock(&u132->scheduler_lock);
                 u132_hcd_giveback_urb(u132, endp, urb, urb->status);
                 return;
         }
@@ -732,22 +732,22 @@
         struct u132_endp *endp = data;
         struct u132 *u132 = endp->u132;
         u8 address = u132->addr[endp->usb_addr].address;
-        down(&u132->scheduler_lock);
+        mutex_lock(&u132->scheduler_lock);
         if (u132->going > 1) {
                 dev_err(&u132->platform_dev->dev, "device has been removed %d\n"
                         , u132->going);
-                up(&u132->scheduler_lock);
+                mutex_unlock(&u132->scheduler_lock);
                 u132_hcd_forget_urb(u132, endp, urb, -ENODEV);
                 return;
         } else if (endp->dequeueing) {
                 endp->dequeueing = 0;
-                up(&u132->scheduler_lock);
+                mutex_unlock(&u132->scheduler_lock);
                 u132_hcd_giveback_urb(u132, endp, urb, -EINTR);
                 return;
         } else if (u132->going > 0) {
                 dev_err(&u132->platform_dev->dev, "device is being removed urb="
                         "%p status=%d\n", urb, urb->status);
-                up(&u132->scheduler_lock);
+                mutex_unlock(&u132->scheduler_lock);
                 u132_hcd_giveback_urb(u132, endp, urb, -ENODEV);
                 return;
         } else if (urb->status == -EINPROGRESS) {
@@ -756,7 +756,7 @@
                 endp->toggle_bits = toggle_bits;
                 if (urb->transfer_buffer_length > urb->actual_length) {
                         int retval;
-                        up(&u132->scheduler_lock);
+                        mutex_unlock(&u132->scheduler_lock);
                         retval = edset_output(u132, ring, endp, urb, address,
                                 endp->toggle_bits, u132_hcd_bulk_output_sent);
                         if (retval == 0) {
@@ -764,14 +764,14 @@
                                 u132_hcd_giveback_urb(u132, endp, urb, retval);
                         return;
                 } else {
-                        up(&u132->scheduler_lock);
+                        mutex_unlock(&u132->scheduler_lock);
                         u132_hcd_giveback_urb(u132, endp, urb, 0);
                         return;
                 }
         } else {
                 dev_err(&u132->platform_dev->dev, "CALLBACK called urb=%p statu"
                         "s=%d\n", urb, urb->status);
-                up(&u132->scheduler_lock);
+                mutex_unlock(&u132->scheduler_lock);
                 u132_hcd_giveback_urb(u132, endp, urb, urb->status);
                 return;
         }
@@ -785,22 +785,22 @@
         struct u132 *u132 = endp->u132;
         u8 address = u132->addr[endp->usb_addr].address;
         struct u132_udev *udev = &u132->udev[address];
-        down(&u132->scheduler_lock);
+        mutex_lock(&u132->scheduler_lock);
         if (u132->going > 1) {
                 dev_err(&u132->platform_dev->dev, "device has been removed %d\n"
                         , u132->going);
-                up(&u132->scheduler_lock);
+                mutex_unlock(&u132->scheduler_lock);
                 u132_hcd_forget_urb(u132, endp, urb, -ENODEV);
                 return;
         } else if (endp->dequeueing) {
                 endp->dequeueing = 0;
-                up(&u132->scheduler_lock);
+                mutex_unlock(&u132->scheduler_lock);
                 u132_hcd_giveback_urb(u132, endp, urb, -EINTR);
                 return;
         } else if (u132->going > 0) {
                 dev_err(&u132->platform_dev->dev, "device is being removed urb="
                         "%p status=%d\n", urb, urb->status);
-                up(&u132->scheduler_lock);
+                mutex_unlock(&u132->scheduler_lock);
                 u132_hcd_giveback_urb(u132, endp, urb, -ENODEV);
                 return;
         } else if (urb->status == -EINPROGRESS) {
@@ -818,7 +818,7 @@
                         endp->toggle_bits = toggle_bits;
                         usb_settoggle(udev->usb_device, endp->usb_endp, 0,
                                 1 & toggle_bits);
-                        up(&u132->scheduler_lock);
+                        mutex_unlock(&u132->scheduler_lock);
                         retval = usb_ftdi_elan_edset_input(u132->platform_dev,
                                 ring->number, endp, urb, address,
                                 endp->usb_endp, endp->toggle_bits,
@@ -831,7 +831,7 @@
                         endp->toggle_bits = toggle_bits;
                         usb_settoggle(udev->usb_device, endp->usb_endp, 0,
                                 1 & toggle_bits);
-                        up(&u132->scheduler_lock);
+                        mutex_unlock(&u132->scheduler_lock);
                         u132_hcd_giveback_urb(u132, endp, urb,
                                 cc_to_error[condition_code]);
                         return;
@@ -840,7 +840,7 @@
                         endp->toggle_bits = toggle_bits;
                         usb_settoggle(udev->usb_device, endp->usb_endp, 0,
                                 1 & toggle_bits);
-                        up(&u132->scheduler_lock);
+                        mutex_unlock(&u132->scheduler_lock);
                         u132_hcd_giveback_urb(u132, endp, urb, 0);
                         return;
                 } else if (condition_code == TD_DATAUNDERRUN) {
@@ -850,13 +850,13 @@
                         dev_warn(&u132->platform_dev->dev, "urb=%p(SHORT NOT OK"
                                 ") giving back BULK IN %s\n", urb,
                                 cc_to_text[condition_code]);
-                        up(&u132->scheduler_lock);
+                        mutex_unlock(&u132->scheduler_lock);
                         u132_hcd_giveback_urb(u132, endp, urb, 0);
                         return;
                 } else if (condition_code == TD_CC_STALL) {
                         endp->toggle_bits = 0x2;
                         usb_settoggle(udev->usb_device, endp->usb_endp, 0, 0);
-                        up(&u132->scheduler_lock);
+                        mutex_unlock(&u132->scheduler_lock);
                         u132_hcd_giveback_urb(u132, endp, urb,
                                 cc_to_error[condition_code]);
                         return;
@@ -866,7 +866,7 @@
                         dev_err(&u132->platform_dev->dev, "urb=%p giving back B"
                                 "ULK IN code=%d %s\n", urb, condition_code,
                                 cc_to_text[condition_code]);
-                        up(&u132->scheduler_lock);
+                        mutex_unlock(&u132->scheduler_lock);
                         u132_hcd_giveback_urb(u132, endp, urb,
                                 cc_to_error[condition_code]);
                         return;
@@ -874,7 +874,7 @@
         } else {
                 dev_err(&u132->platform_dev->dev, "CALLBACK called urb=%p statu"
                         "s=%d\n", urb, urb->status);
-                up(&u132->scheduler_lock);
+                mutex_unlock(&u132->scheduler_lock);
                 u132_hcd_giveback_urb(u132, endp, urb, urb->status);
                 return;
         }
@@ -886,32 +886,32 @@
 {
         struct u132_endp *endp = data;
         struct u132 *u132 = endp->u132;
-        down(&u132->scheduler_lock);
+        mutex_lock(&u132->scheduler_lock);
         if (u132->going > 1) {
                 dev_err(&u132->platform_dev->dev, "device has been removed %d\n"
                         , u132->going);
-                up(&u132->scheduler_lock);
+                mutex_unlock(&u132->scheduler_lock);
                 u132_hcd_forget_urb(u132, endp, urb, -ENODEV);
                 return;
         } else if (endp->dequeueing) {
                 endp->dequeueing = 0;
-                up(&u132->scheduler_lock);
+                mutex_unlock(&u132->scheduler_lock);
                 u132_hcd_giveback_urb(u132, endp, urb, -EINTR);
                 return;
         } else if (u132->going > 0) {
                 dev_err(&u132->platform_dev->dev, "device is being removed urb="
                         "%p status=%d\n", urb, urb->status);
-                up(&u132->scheduler_lock);
+                mutex_unlock(&u132->scheduler_lock);
                 u132_hcd_giveback_urb(u132, endp, urb, -ENODEV);
                 return;
         } else if (urb->status == -EINPROGRESS) {
-                up(&u132->scheduler_lock);
+                mutex_unlock(&u132->scheduler_lock);
                 u132_hcd_giveback_urb(u132, endp, urb, 0);
                 return;
         } else {
                 dev_err(&u132->platform_dev->dev, "CALLBACK called urb=%p statu"
                         "s=%d\n", urb, urb->status);
-                up(&u132->scheduler_lock);
+                mutex_unlock(&u132->scheduler_lock);
                 u132_hcd_giveback_urb(u132, endp, urb, urb->status);
                 return;
         }
@@ -924,22 +924,22 @@
         struct u132_endp *endp = data;
         struct u132 *u132 = endp->u132;
         u8 address = u132->addr[endp->usb_addr].address;
-        down(&u132->scheduler_lock);
+        mutex_lock(&u132->scheduler_lock);
         if (u132->going > 1) {
                 dev_err(&u132->platform_dev->dev, "device has been removed %d\n"
                         , u132->going);
-                up(&u132->scheduler_lock);
+                mutex_unlock(&u132->scheduler_lock);
                 u132_hcd_forget_urb(u132, endp, urb, -ENODEV);
                 return;
         } else if (endp->dequeueing) {
                 endp->dequeueing = 0;
-                up(&u132->scheduler_lock);
+                mutex_unlock(&u132->scheduler_lock);
                 u132_hcd_giveback_urb(u132, endp, urb, -EINTR);
                 return;
         } else if (u132->going > 0) {
                 dev_err(&u132->platform_dev->dev, "device is being removed urb="
                         "%p status=%d\n", urb, urb->status);
-                up(&u132->scheduler_lock);
+                mutex_unlock(&u132->scheduler_lock);
                 u132_hcd_giveback_urb(u132, endp, urb, -ENODEV);
                 return;
         } else if (urb->status == -EINPROGRESS) {
@@ -955,7 +955,7 @@
                         TD_DATAUNDERRUN) && ((urb->transfer_flags &
                         URB_SHORT_NOT_OK) == 0))) {
                         int retval;
-                        up(&u132->scheduler_lock);
+                        mutex_unlock(&u132->scheduler_lock);
                         retval = usb_ftdi_elan_edset_empty(u132->platform_dev,
                                 ring->number, endp, urb, address,
                                 endp->usb_endp, 0x3,
@@ -965,14 +965,14 @@
                                 u132_hcd_giveback_urb(u132, endp, urb, retval);
                         return;
                 } else if (condition_code == TD_CC_STALL) {
-                        up(&u132->scheduler_lock);
+                        mutex_unlock(&u132->scheduler_lock);
                         dev_warn(&u132->platform_dev->dev, "giving back SETUP I"
                                 "NPUT STALL urb %p\n", urb);
                         u132_hcd_giveback_urb(u132, endp, urb,
                                 cc_to_error[condition_code]);
                         return;
                 } else {
-                        up(&u132->scheduler_lock);
+                        mutex_unlock(&u132->scheduler_lock);
                         dev_err(&u132->platform_dev->dev, "giving back SETUP IN"
                                 "PUT %s urb %p\n", cc_to_text[condition_code],
                                 urb);
@@ -983,7 +983,7 @@
         } else {
                 dev_err(&u132->platform_dev->dev, "CALLBACK called urb=%p statu"
                         "s=%d\n", urb, urb->status);
-                up(&u132->scheduler_lock);
+                mutex_unlock(&u132->scheduler_lock);
                 u132_hcd_giveback_urb(u132, endp, urb, urb->status);
                 return;
         }
@@ -995,32 +995,32 @@
 {
         struct u132_endp *endp = data;
         struct u132 *u132 = endp->u132;
-        down(&u132->scheduler_lock);
+        mutex_lock(&u132->scheduler_lock);
         if (u132->going > 1) {
                 dev_err(&u132->platform_dev->dev, "device has been removed %d\n"
                         , u132->going);
-                up(&u132->scheduler_lock);
+                mutex_unlock(&u132->scheduler_lock);
                 u132_hcd_forget_urb(u132, endp, urb, -ENODEV);
                 return;
         } else if (endp->dequeueing) {
                 endp->dequeueing = 0;
-                up(&u132->scheduler_lock);
+                mutex_unlock(&u132->scheduler_lock);
                 u132_hcd_giveback_urb(u132, endp, urb, -EINTR);
                 return;
         } else if (u132->going > 0) {
                 dev_err(&u132->platform_dev->dev, "device is being removed urb="
                         "%p status=%d\n", urb, urb->status);
-                up(&u132->scheduler_lock);
+                mutex_unlock(&u132->scheduler_lock);
                 u132_hcd_giveback_urb(u132, endp, urb, -ENODEV);
                 return;
         } else if (urb->status == -EINPROGRESS) {
-                up(&u132->scheduler_lock);
+                mutex_unlock(&u132->scheduler_lock);
                 u132_hcd_giveback_urb(u132, endp, urb, 0);
                 return;
         } else {
                 dev_err(&u132->platform_dev->dev, "CALLBACK called urb=%p statu"
                         "s=%d\n", urb, urb->status);
-                up(&u132->scheduler_lock);
+                mutex_unlock(&u132->scheduler_lock);
                 u132_hcd_giveback_urb(u132, endp, urb, urb->status);
                 return;
         }
@@ -1033,29 +1033,29 @@
         struct u132_endp *endp = data;
         struct u132 *u132 = endp->u132;
         u8 address = u132->addr[endp->usb_addr].address;
-        down(&u132->scheduler_lock);
+        mutex_lock(&u132->scheduler_lock);
         if (u132->going > 1) {
                 dev_err(&u132->platform_dev->dev, "device has been removed %d\n"
                         , u132->going);
-                up(&u132->scheduler_lock);
+                mutex_unlock(&u132->scheduler_lock);
                 u132_hcd_forget_urb(u132, endp, urb, -ENODEV);
                 return;
         } else if (endp->dequeueing) {
                 endp->dequeueing = 0;
-                up(&u132->scheduler_lock);
+                mutex_unlock(&u132->scheduler_lock);
                 u132_hcd_giveback_urb(u132, endp, urb, -EINTR);
                 return;
         } else if (u132->going > 0) {
                 dev_err(&u132->platform_dev->dev, "device is being removed urb="
                         "%p status=%d\n", urb, urb->status);
-                up(&u132->scheduler_lock);
+                mutex_unlock(&u132->scheduler_lock);
                 u132_hcd_giveback_urb(u132, endp, urb, -ENODEV);
                 return;
         } else if (urb->status == -EINPROGRESS) {
                 if (usb_pipein(urb->pipe)) {
                         int retval;
                         struct u132_ring *ring = endp->ring;
-                        up(&u132->scheduler_lock);
+                        mutex_unlock(&u132->scheduler_lock);
                         retval = usb_ftdi_elan_edset_input(u132->platform_dev,
                                 ring->number, endp, urb, address,
                                 endp->usb_endp, 0,
@@ -1067,7 +1067,7 @@
                 } else {
                         int retval;
                         struct u132_ring *ring = endp->ring;
-                        up(&u132->scheduler_lock);
+                        mutex_unlock(&u132->scheduler_lock);
                         retval = usb_ftdi_elan_edset_input(u132->platform_dev,
                                 ring->number, endp, urb, address,
                                 endp->usb_endp, 0,
@@ -1080,7 +1080,7 @@
         } else {
                 dev_err(&u132->platform_dev->dev, "CALLBACK called urb=%p statu"
                         "s=%d\n", urb, urb->status);
-                up(&u132->scheduler_lock);
+                mutex_unlock(&u132->scheduler_lock);
                 u132_hcd_giveback_urb(u132, endp, urb, urb->status);
                 return;
         }
@@ -1094,34 +1094,34 @@
         struct u132 *u132 = endp->u132;
         u8 address = u132->addr[endp->usb_addr].address;
         struct u132_udev *udev = &u132->udev[address];
-        down(&u132->scheduler_lock);
+        mutex_lock(&u132->scheduler_lock);
         if (u132->going > 1) {
                 dev_err(&u132->platform_dev->dev, "device has been removed %d\n"
                         , u132->going);
-                up(&u132->scheduler_lock);
+                mutex_unlock(&u132->scheduler_lock);
                 u132_hcd_forget_urb(u132, endp, urb, -ENODEV);
                 return;
         } else if (endp->dequeueing) {
                 endp->dequeueing = 0;
-                up(&u132->scheduler_lock);
+                mutex_unlock(&u132->scheduler_lock);
                 u132_hcd_giveback_urb(u132, endp, urb, -EINTR);
                 return;
         } else if (u132->going > 0) {
                 dev_err(&u132->platform_dev->dev, "device is being removed urb="
                         "%p status=%d\n", urb, urb->status);
-                up(&u132->scheduler_lock);
+                mutex_unlock(&u132->scheduler_lock);
                 u132_hcd_giveback_urb(u132, endp, urb, -ENODEV);
                 return;
         } else if (urb->status == -EINPROGRESS) {
                 u132->addr[0].address = 0;
                 endp->usb_addr = udev->usb_addr;
-                up(&u132->scheduler_lock);
+                mutex_unlock(&u132->scheduler_lock);
                 u132_hcd_giveback_urb(u132, endp, urb, 0);
                 return;
         } else {
                 dev_err(&u132->platform_dev->dev, "CALLBACK called urb=%p statu"
                         "s=%d\n", urb, urb->status);
-                up(&u132->scheduler_lock);
+                mutex_unlock(&u132->scheduler_lock);
                 u132_hcd_giveback_urb(u132, endp, urb, urb->status);
                 return;
         }
@@ -1133,28 +1133,28 @@
 {
         struct u132_endp *endp = data;
         struct u132 *u132 = endp->u132;
-        down(&u132->scheduler_lock);
+        mutex_lock(&u132->scheduler_lock);
         if (u132->going > 1) {
                 dev_err(&u132->platform_dev->dev, "device has been removed %d\n"
                         , u132->going);
-                up(&u132->scheduler_lock);
+                mutex_unlock(&u132->scheduler_lock);
                 u132_hcd_forget_urb(u132, endp, urb, -ENODEV);
                 return;
         } else if (endp->dequeueing) {
                 endp->dequeueing = 0;
-                up(&u132->scheduler_lock);
+                mutex_unlock(&u132->scheduler_lock);
                 u132_hcd_giveback_urb(u132, endp, urb, -EINTR);
                 return;
         } else if (u132->going > 0) {
                 dev_err(&u132->platform_dev->dev, "device is being removed urb="
                         "%p status=%d\n", urb, urb->status);
-                up(&u132->scheduler_lock);
+                mutex_unlock(&u132->scheduler_lock);
                 u132_hcd_giveback_urb(u132, endp, urb, -ENODEV);
                 return;
         } else if (urb->status == -EINPROGRESS) {
                 int retval;
                 struct u132_ring *ring = endp->ring;
-                up(&u132->scheduler_lock);
+                mutex_unlock(&u132->scheduler_lock);
                 retval = usb_ftdi_elan_edset_input(u132->platform_dev,
                         ring->number, endp, urb, 0, endp->usb_endp, 0,
                         u132_hcd_enumeration_empty_recv);
@@ -1165,7 +1165,7 @@
         } else {
                 dev_err(&u132->platform_dev->dev, "CALLBACK called urb=%p statu"
                         "s=%d\n", urb, urb->status);
-                up(&u132->scheduler_lock);
+                mutex_unlock(&u132->scheduler_lock);
                 u132_hcd_giveback_urb(u132, endp, urb, urb->status);
                 return;
         }
@@ -1177,32 +1177,32 @@
 {
         struct u132_endp *endp = data;
         struct u132 *u132 = endp->u132;
-        down(&u132->scheduler_lock);
+        mutex_lock(&u132->scheduler_lock);
         if (u132->going > 1) {
                 dev_err(&u132->platform_dev->dev, "device has been removed %d\n"
                         , u132->going);
-                up(&u132->scheduler_lock);
+                mutex_unlock(&u132->scheduler_lock);
                 u132_hcd_forget_urb(u132, endp, urb, -ENODEV);
                 return;
         } else if (endp->dequeueing) {
                 endp->dequeueing = 0;
-                up(&u132->scheduler_lock);
+                mutex_unlock(&u132->scheduler_lock);
                 u132_hcd_giveback_urb(u132, endp, urb, -EINTR);
                 return;
         } else if (u132->going > 0) {
                 dev_err(&u132->platform_dev->dev, "device is being removed urb="
                         "%p status=%d\n", urb, urb->status);
-                up(&u132->scheduler_lock);
+                mutex_unlock(&u132->scheduler_lock);
                 u132_hcd_giveback_urb(u132, endp, urb, -ENODEV);
                 return;
         } else if (urb->status == -EINPROGRESS) {
-                up(&u132->scheduler_lock);
+                mutex_unlock(&u132->scheduler_lock);
                 u132_hcd_giveback_urb(u132, endp, urb, 0);
                 return;
         } else {
                 dev_err(&u132->platform_dev->dev, "CALLBACK called urb=%p statu"
                         "s=%d\n", urb, urb->status);
-                up(&u132->scheduler_lock);
+                mutex_unlock(&u132->scheduler_lock);
                 u132_hcd_giveback_urb(u132, endp, urb, urb->status);
                 return;
         }
@@ -1215,22 +1215,22 @@
         struct u132_endp *endp = data;
         struct u132 *u132 = endp->u132;
         u8 address = u132->addr[endp->usb_addr].address;
-        down(&u132->scheduler_lock);
+        mutex_lock(&u132->scheduler_lock);
         if (u132->going > 1) {
                 dev_err(&u132->platform_dev->dev, "device has been removed %d\n"
                         , u132->going);
-                up(&u132->scheduler_lock);
+                mutex_unlock(&u132->scheduler_lock);
                 u132_hcd_forget_urb(u132, endp, urb, -ENODEV);
                 return;
         } else if (endp->dequeueing) {
                 endp->dequeueing = 0;
-                up(&u132->scheduler_lock);
+                mutex_unlock(&u132->scheduler_lock);
                 u132_hcd_giveback_urb(u132, endp, urb, -EINTR);
                 return;
         } else if (u132->going > 0) {
                 dev_err(&u132->platform_dev->dev, "device is being removed urb="
                         "%p status=%d\n", urb, urb->status);
-                up(&u132->scheduler_lock);
+                mutex_unlock(&u132->scheduler_lock);
                 u132_hcd_giveback_urb(u132, endp, urb, -ENODEV);
                 return;
         } else if (urb->status == -EINPROGRESS) {
@@ -1243,7 +1243,7 @@
                         *u++ = *b++;
                 }
                 urb->actual_length = len;
-                up(&u132->scheduler_lock);
+                mutex_unlock(&u132->scheduler_lock);
                 retval = usb_ftdi_elan_edset_empty(u132->platform_dev,
                         ring->number, endp, urb, address, endp->usb_endp, 0x3,
                         u132_hcd_initial_empty_sent);
@@ -1254,7 +1254,7 @@
         } else {
                 dev_err(&u132->platform_dev->dev, "CALLBACK called urb=%p statu"
                         "s=%d\n", urb, urb->status);
-                up(&u132->scheduler_lock);
+                mutex_unlock(&u132->scheduler_lock);
                 u132_hcd_giveback_urb(u132, endp, urb, urb->status);
                 return;
         }
@@ -1267,28 +1267,28 @@
         struct u132_endp *endp = data;
         struct u132 *u132 = endp->u132;
         u8 address = u132->addr[endp->usb_addr].address;
-        down(&u132->scheduler_lock);
+        mutex_lock(&u132->scheduler_lock);
         if (u132->going > 1) {
                 dev_err(&u132->platform_dev->dev, "device has been removed %d\n"
                         , u132->going);
-                up(&u132->scheduler_lock);
+                mutex_unlock(&u132->scheduler_lock);
                 u132_hcd_forget_urb(u132, endp, urb, -ENODEV);
                 return;
         } else if (endp->dequeueing) {
                 endp->dequeueing = 0;
-                up(&u132->scheduler_lock);
+                mutex_unlock(&u132->scheduler_lock);
                 u132_hcd_giveback_urb(u132, endp, urb, -EINTR);
                 return;
         } else if (u132->going > 0) {
                 dev_err(&u132->platform_dev->dev, "device is being removed urb="
                         "%p status=%d\n", urb, urb->status);
-                up(&u132->scheduler_lock);
+                mutex_unlock(&u132->scheduler_lock);
                 u132_hcd_giveback_urb(u132, endp, urb, -ENODEV);
                 return;
         } else if (urb->status == -EINPROGRESS) {
                 int retval;
                 struct u132_ring *ring = endp->ring;
-                up(&u132->scheduler_lock);
+                mutex_unlock(&u132->scheduler_lock);
                 retval = usb_ftdi_elan_edset_input(u132->platform_dev,
                         ring->number, endp, urb, address, endp->usb_endp, 0,
                         u132_hcd_initial_input_recv);
@@ -1299,7 +1299,7 @@
         } else {
                 dev_err(&u132->platform_dev->dev, "CALLBACK called urb=%p statu"
                         "s=%d\n", urb, urb->status);
-                up(&u132->scheduler_lock);
+                mutex_unlock(&u132->scheduler_lock);
                 u132_hcd_giveback_urb(u132, endp, urb, urb->status);
                 return;
         }
@@ -1314,9 +1314,9 @@
         struct u132_ring *ring =
 		container_of(work, struct u132_ring, scheduler.work);
         struct u132 *u132 = ring->u132;
-        down(&u132->scheduler_lock);
+        mutex_lock(&u132->scheduler_lock);
         if (ring->in_use) {
-                up(&u132->scheduler_lock);
+                mutex_unlock(&u132->scheduler_lock);
                 u132_ring_put_kref(u132, ring);
                 return;
         } else if (ring->curr_endp) {
@@ -1333,7 +1333,7 @@
                                 ring->curr_endp = endp;
                                 u132_endp_cancel_work(u132, last_endp);
                                 u132_endp_queue_work(u132, last_endp, 0);
-                                up(&u132->scheduler_lock);
+                                mutex_unlock(&u132->scheduler_lock);
                                 u132_ring_put_kref(u132, ring);
                                 return;
                         } else {
@@ -1347,7 +1347,7 @@
                         last_endp->jiffies)) {
                         u132_endp_cancel_work(u132, last_endp);
                         u132_endp_queue_work(u132, last_endp, 0);
-                        up(&u132->scheduler_lock);
+                        mutex_unlock(&u132->scheduler_lock);
                         u132_ring_put_kref(u132, ring);
                         return;
                 } else {
@@ -1357,15 +1357,15 @@
                 }
                 if (wakeup > 0) {
                         u132_ring_requeue_work(u132, ring, wakeup);
-                        up(&u132->scheduler_lock);
+                        mutex_unlock(&u132->scheduler_lock);
                         return;
                 } else {
-                        up(&u132->scheduler_lock);
+                        mutex_unlock(&u132->scheduler_lock);
                         u132_ring_put_kref(u132, ring);
                         return;
                 }
         } else {
-                up(&u132->scheduler_lock);
+                mutex_unlock(&u132->scheduler_lock);
                 u132_ring_put_kref(u132, ring);
                 return;
         }
@@ -1377,32 +1377,32 @@
         struct u132_endp *endp =
 		container_of(work, struct u132_endp, scheduler.work);
         struct u132 *u132 = endp->u132;
-        down(&u132->scheduler_lock);
+        mutex_lock(&u132->scheduler_lock);
         ring = endp->ring;
         if (endp->edset_flush) {
                 endp->edset_flush = 0;
                 if (endp->dequeueing)
                         usb_ftdi_elan_edset_flush(u132->platform_dev,
                                 ring->number, endp);
-                up(&u132->scheduler_lock);
+                mutex_unlock(&u132->scheduler_lock);
                 u132_endp_put_kref(u132, endp);
                 return;
         } else if (endp->active) {
-                up(&u132->scheduler_lock);
+                mutex_unlock(&u132->scheduler_lock);
                 u132_endp_put_kref(u132, endp);
                 return;
         } else if (ring->in_use) {
-                up(&u132->scheduler_lock);
+                mutex_unlock(&u132->scheduler_lock);
                 u132_endp_put_kref(u132, endp);
                 return;
         } else if (endp->queue_next == endp->queue_last) {
-                up(&u132->scheduler_lock);
+                mutex_unlock(&u132->scheduler_lock);
                 u132_endp_put_kref(u132, endp);
                 return;
         } else if (endp->pipetype == PIPE_INTERRUPT) {
                 u8 address = u132->addr[endp->usb_addr].address;
                 if (ring->in_use) {
-                        up(&u132->scheduler_lock);
+                        mutex_unlock(&u132->scheduler_lock);
                         u132_endp_put_kref(u132, endp);
                         return;
                 } else {
@@ -1412,7 +1412,7 @@
                         endp->active = 1;
                         ring->curr_endp = endp;
                         ring->in_use = 1;
-                        up(&u132->scheduler_lock);
+                        mutex_unlock(&u132->scheduler_lock);
                         retval = edset_single(u132, ring, endp, urb, address,
                                 endp->toggle_bits, u132_hcd_interrupt_recv);
                         if (retval == 0) {
@@ -1423,7 +1423,7 @@
         } else if (endp->pipetype == PIPE_CONTROL) {
                 u8 address = u132->addr[endp->usb_addr].address;
                 if (ring->in_use) {
-                        up(&u132->scheduler_lock);
+                        mutex_unlock(&u132->scheduler_lock);
                         u132_endp_put_kref(u132, endp);
                         return;
                 } else if (address == 0) {
@@ -1433,7 +1433,7 @@
                         endp->active = 1;
                         ring->curr_endp = endp;
                         ring->in_use = 1;
-                        up(&u132->scheduler_lock);
+                        mutex_unlock(&u132->scheduler_lock);
                         retval = edset_setup(u132, ring, endp, urb, address,
                                 0x2, u132_hcd_initial_setup_sent);
                         if (retval == 0) {
@@ -1447,7 +1447,7 @@
                         endp->active = 1;
                         ring->curr_endp = endp;
                         ring->in_use = 1;
-                        up(&u132->scheduler_lock);
+                        mutex_unlock(&u132->scheduler_lock);
                         retval = edset_setup(u132, ring, endp, urb, 0, 0x2,
                                 u132_hcd_enumeration_address_sent);
                         if (retval == 0) {
@@ -1462,7 +1462,7 @@
                         endp->active = 1;
                         ring->curr_endp = endp;
                         ring->in_use = 1;
-                        up(&u132->scheduler_lock);
+                        mutex_unlock(&u132->scheduler_lock);
                         retval = edset_setup(u132, ring, endp, urb, address,
                                 0x2, u132_hcd_configure_setup_sent);
                         if (retval == 0) {
@@ -1474,7 +1474,7 @@
                 if (endp->input) {
                         u8 address = u132->addr[endp->usb_addr].address;
                         if (ring->in_use) {
-                                up(&u132->scheduler_lock);
+                                mutex_unlock(&u132->scheduler_lock);
                                 u132_endp_put_kref(u132, endp);
                                 return;
                         } else {
@@ -1484,7 +1484,7 @@
                                 endp->active = 1;
                                 ring->curr_endp = endp;
                                 ring->in_use = 1;
-                                up(&u132->scheduler_lock);
+                                mutex_unlock(&u132->scheduler_lock);
                                 retval = edset_input(u132, ring, endp, urb,
                                         address, endp->toggle_bits,
                                         u132_hcd_bulk_input_recv);
@@ -1497,7 +1497,7 @@
                 } else {        /* output pipe */
                         u8 address = u132->addr[endp->usb_addr].address;
                         if (ring->in_use) {
-                                up(&u132->scheduler_lock);
+                                mutex_unlock(&u132->scheduler_lock);
                                 u132_endp_put_kref(u132, endp);
                                 return;
                         } else {
@@ -1507,7 +1507,7 @@
                                 endp->active = 1;
                                 ring->curr_endp = endp;
                                 ring->in_use = 1;
-                                up(&u132->scheduler_lock);
+                                mutex_unlock(&u132->scheduler_lock);
                                 retval = edset_output(u132, ring, endp, urb,
                                         address, endp->toggle_bits,
                                         u132_hcd_bulk_output_sent);
@@ -3038,7 +3038,7 @@
         u132->power = 0;
         u132->reset = 0;
         mutex_init(&u132->sw_lock);
-        init_MUTEX(&u132->scheduler_lock);
+        mutex_init(&u132->scheduler_lock);
         while (rings-- > 0) {
                 struct u132_ring *ring = &u132->ring[rings];
                 ring->u132 = u132;

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

    Yo soy como soy y tú eres como eres, construyamos un mundo donde yo
    pueda ser sin dejar de ser yo, donde tú puedas ser sin dejar de ser
    tú, y donde ni yo ni tú obliguemos al otro a ser como yo o como tú
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
