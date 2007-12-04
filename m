Return-Path: <linux-kernel-owner+w=401wt.eu-S1754680AbXLDQzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680AbXLDQzc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 11:55:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752127AbXLDQzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 11:55:23 -0500
Received: from mx1.riseup.net ([204.13.164.18]:43454 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049AbXLDQzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 11:55:22 -0500
Date: Tue, 4 Dec 2007 17:55:40 +0100
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: gregkh@suse.de, linux-usb-users@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] USB testing driver: convert dev->sem to mutex
Message-ID: <20071204165540.GH6729@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	gregkh@suse.de, linux-usb-users@lists.sourceforge.net,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

USB testing driver: convert semaphore dev->sem to the mutex API

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--

diff --git a/drivers/usb/misc/usbtest.c b/drivers/usb/misc/usbtest.c
index ea31621..57260ab 100644
--- a/drivers/usb/misc/usbtest.c
+++ b/drivers/usb/misc/usbtest.c
@@ -6,6 +6,7 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/scatterlist.h>
+#include <linux/mutex.h>
 
 #include <linux/usb.h>
 
@@ -64,7 +65,7 @@ struct usbtest_dev {
 	int			in_iso_pipe;
 	int			out_iso_pipe;
 	struct usb_endpoint_descriptor	*iso_in, *iso_out;
-	struct semaphore	sem;
+	struct mutex		lock;
 
 #define TBUF_SIZE	256
 	u8			*buf;
@@ -1558,11 +1559,11 @@ usbtest_ioctl (struct usb_interface *intf, unsigned int code, void *buf)
 			|| param->sglen < 0 || param->vary < 0)
 		return -EINVAL;
 
-	if (down_interruptible (&dev->sem))
+	if (mutex_lock_interruptible(&dev->lock))
 		return -ERESTARTSYS;
 
 	if (intf->dev.power.power_state.event != PM_EVENT_ON) {
-		up (&dev->sem);
+		mutex_unlock(&dev->lock);
 		return -EHOSTUNREACH;
 	}
 
@@ -1574,7 +1575,7 @@ usbtest_ioctl (struct usb_interface *intf, unsigned int code, void *buf)
 	    	int	res;
 
 		if (intf->altsetting->desc.bInterfaceNumber) {
-			up (&dev->sem);
+			mutex_unlock(&dev->lock);
 			return -ENODEV;
 		}
 		res = set_altsetting (dev, dev->info->alt);
@@ -1582,7 +1583,7 @@ usbtest_ioctl (struct usb_interface *intf, unsigned int code, void *buf)
 			dev_err (&intf->dev,
 					"set altsetting to %d failed, %d\n",
 					dev->info->alt, res);
-			up (&dev->sem);
+			mutex_unlock(&dev->lock);
 			return res;
 		}
 	}
@@ -1855,7 +1856,7 @@ usbtest_ioctl (struct usb_interface *intf, unsigned int code, void *buf)
 		param->duration.tv_usec += 1000 * 1000;
 		param->duration.tv_sec -= 1;
 	}
-	up (&dev->sem);
+	mutex_unlock(&dev->lock);
 	return retval;
 }
 
@@ -1905,7 +1906,7 @@ usbtest_probe (struct usb_interface *intf, const struct usb_device_id *id)
 		return -ENOMEM;
 	info = (struct usbtest_info *) id->driver_info;
 	dev->info = info;
-	init_MUTEX (&dev->sem);
+	mutex_init(&dev->lock);
 
 	dev->intf = intf;
 
@@ -1990,7 +1991,7 @@ static void usbtest_disconnect (struct usb_interface *intf)
 {
 	struct usbtest_dev	*dev = usb_get_intfdata (intf);
 
-	down (&dev->sem);
+	mutex_lock(&dev->lock);
 
 	usb_set_intfdata (intf, NULL);
 	dev_dbg (&intf->dev, "disconnect\n");

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

    Tant qu'il y aura sur terre des hommes pour qui existe un concept
    d' 'honneur national', la menace d'une nouvelle guerre subsistera
                              (B. Traven)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
