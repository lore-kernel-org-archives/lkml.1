Return-Path: <linux-kernel-owner+w=401wt.eu-S932740AbXIFVS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932740AbXIFVS0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 17:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757560AbXIFVSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 17:18:16 -0400
Received: from 184.5.221.87.dynamic.jazztel.es ([87.221.5.184]:46533 "EHLO
	traven.no-ip.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757550AbXIFVSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 17:18:15 -0400
X-Greylist: delayed 529 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Sep 2007 17:18:14 EDT
Date: Thu, 6 Sep 2007 23:18:15 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: gregkh@suse.de, linux-usb-users@lists.sourceforge.net,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH 1/2] ELAN U132 Host Controller Driver: convert sw_lock to
	mutex
Message-ID: <20070906211815.GD3081@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	gregkh@suse.de, linux-usb-users@lists.sourceforge.net,
	linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
References: <20070906210922.GC3081@traven>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070906210922.GC3081@traven>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The ELAN U132 Host Controller Driver uses the semaphore sw_lock as
mutex. Use the mutex API instead of the (binary) semaphore.

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--

diff --git a/drivers/usb/host/u132-hcd.c b/drivers/usb/host/u132-hcd.c
index b88eb3c..1201ca4 100644
--- a/drivers/usb/host/u132-hcd.c
+++ b/drivers/usb/host/u132-hcd.c
@@ -184,7 +184,7 @@ struct u132_ring {
 struct u132 {
         struct kref kref;
         struct list_head u132_list;
-        struct semaphore sw_lock;
+        struct mutex sw_lock;
         struct semaphore scheduler_lock;
         struct u132_platform_data *board;
         struct platform_device *platform_dev;
@@ -493,20 +493,20 @@ static void u132_hcd_monitor_work(struct work_struct *work)
                 return;
         } else {
                 int retval;
-                down(&u132->sw_lock);
+                mutex_lock(&u132->sw_lock);
                 retval = read_roothub_info(u132);
                 if (retval) {
                         struct usb_hcd *hcd = u132_to_hcd(u132);
                         u132_disable(u132);
                         u132->going = 1;
-                        up(&u132->sw_lock);
+                        mutex_unlock(&u132->sw_lock);
                         usb_hc_died(hcd);
                         ftdi_elan_gone_away(u132->platform_dev);
                         u132_monitor_put_kref(u132);
                         return;
                 } else {
                         u132_monitor_requeue_work(u132, 500);
-                        up(&u132->sw_lock);
+                        mutex_unlock(&u132->sw_lock);
                         return;
                 }
         }
@@ -1805,10 +1805,10 @@ static void u132_hcd_stop(struct usb_hcd *hcd)
                 dev_err(&u132->platform_dev->dev, "device hcd=%p is being remov"
                         "ed\n", hcd);
         } else {
-                down(&u132->sw_lock);
+                mutex_lock(&u132->sw_lock);
                 msleep(100);
                 u132_power(u132, 0);
-                up(&u132->sw_lock);
+                mutex_unlock(&u132->sw_lock);
         }
 }
 
@@ -1830,7 +1830,7 @@ static int u132_hcd_start(struct usb_hcd *hcd)
                         (pdev->dev.platform_data))->vendor;
                 u16 device = ((struct u132_platform_data *)
                         (pdev->dev.platform_data))->device;
-                down(&u132->sw_lock);
+                mutex_lock(&u132->sw_lock);
                 msleep(10);
                 if (vendor == PCI_VENDOR_ID_AMD && device == 0x740c) {
                         u132->flags = OHCI_QUIRK_AMD756;
@@ -1845,7 +1845,7 @@ static int u132_hcd_start(struct usb_hcd *hcd)
                         u132->going = 1;
                 }
                 msleep(100);
-                up(&u132->sw_lock);
+                mutex_unlock(&u132->sw_lock);
                 return retval;
         } else {
                 dev_err(&u132->platform_dev->dev, "platform_device missing\n");
@@ -1865,13 +1865,13 @@ static int u132_hcd_reset(struct usb_hcd *hcd)
                 return -ESHUTDOWN;
         } else {
                 int retval;
-                down(&u132->sw_lock);
+                mutex_lock(&u132->sw_lock);
                 retval = u132_init(u132);
                 if (retval) {
                         u132_disable(u132);
                         u132->going = 1;
                 }
-                up(&u132->sw_lock);
+                mutex_unlock(&u132->sw_lock);
                 return retval;
         }
 }
@@ -2805,7 +2805,7 @@ static int u132_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
                 return -ESHUTDOWN;
         } else {
                 int retval = 0;
-                down(&u132->sw_lock);
+                mutex_lock(&u132->sw_lock);
                 switch (typeReq) {
                 case ClearHubFeature:
                         switch (wValue) {
@@ -2868,7 +2868,7 @@ static int u132_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
                       stall:retval = -EPIPE;
                         break;
                 }
-                up(&u132->sw_lock);
+                mutex_unlock(&u132->sw_lock);
                 return retval;
         }
 }
@@ -3004,7 +3004,7 @@ static int __devexit u132_remove(struct platform_device *pdev)
                         dev_err(&u132->platform_dev->dev, "removing device u132"
 				".%d\n", u132->sequence_num);
                         msleep(100);
-                        down(&u132->sw_lock);
+                        mutex_lock(&u132->sw_lock);
                         u132_monitor_cancel_work(u132);
                         while (rings-- > 0) {
                                 struct u132_ring *ring = &u132->ring[rings];
@@ -3017,7 +3017,7 @@ static int __devexit u132_remove(struct platform_device *pdev)
                         u132->going += 1;
                         printk(KERN_INFO "removing device u132.%d\n",
                                 u132->sequence_num);
-                        up(&u132->sw_lock);
+                        mutex_unlock(&u132->sw_lock);
                         usb_remove_hcd(hcd);
                         u132_u132_put_kref(u132);
                         return 0;
@@ -3037,7 +3037,7 @@ static void u132_initialise(struct u132 *u132, struct platform_device *pdev)
         u132->platform_dev = pdev;
         u132->power = 0;
         u132->reset = 0;
-        init_MUTEX(&u132->sw_lock);
+        mutex_init(&u132->sw_lock);
         init_MUTEX(&u132->scheduler_lock);
         while (rings-- > 0) {
                 struct u132_ring *ring = &u132->ring[rings];
@@ -3047,7 +3047,7 @@ static void u132_initialise(struct u132 *u132, struct platform_device *pdev)
                 ring->curr_endp = NULL;
                 INIT_DELAYED_WORK(&ring->scheduler,
 				  u132_hcd_ring_work_scheduler);
-        } down(&u132->sw_lock);
+        } mutex_lock(&u132->sw_lock);
         INIT_DELAYED_WORK(&u132->monitor, u132_hcd_monitor_work);
         while (ports-- > 0) {
                 struct u132_port *port = &u132->port[ports];
@@ -3077,7 +3077,7 @@ static void u132_initialise(struct u132 *u132, struct platform_device *pdev)
         while (endps-- > 0) {
                 u132->endp[endps] = NULL;
         }
-        up(&u132->sw_lock);
+        mutex_unlock(&u132->sw_lock);
         return;
 }


-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

                If you don't know where you are going,
               you will probably end up somewhere else
                         (Laurence J. Peter)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
