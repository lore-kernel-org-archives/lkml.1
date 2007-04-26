Return-Path: <linux-kernel-owner+w=401wt.eu-S933646AbXDZIh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933646AbXDZIh7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 04:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933617AbXDZIh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 04:37:59 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:56656
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S933646AbXDZIh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 04:37:58 -0400
Date: Thu, 26 Apr 2007 10:40:51 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: wim@iguana.be
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] use mutex instead of semaphore in Berkshire USB-PC Watchdog driver
Message-ID: <20070426084050.GA6468@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	wim@iguana.be, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

the Berkshire USB-PC Watchdog driver uses a semaphore as mutex. use
the mutex API instead of the (binary) semaphore

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--
diff --git a/drivers/char/watchdog/pcwd_usb.c b/drivers/char/watchdog/pcwd_usb.c
index 31037f9..1e7a671 100644
--- a/drivers/char/watchdog/pcwd_usb.c
+++ b/drivers/char/watchdog/pcwd_usb.c
@@ -146,7 +146,7 @@ struct usb_pcwd_private {
 	atomic_t		cmd_received;		/* true if we received a report after a command */
 
 	int			exists;			/* Wether or not the device exists */
-	struct semaphore	sem;			/* locks this structure */
+	struct mutex		mtx;			/* locks this structure */
 };
 static struct usb_pcwd_private *usb_pcwd_device;
 
@@ -635,7 +635,7 @@ static int usb_pcwd_probe(struct usb_interface *interface, const struct usb_devi
 
 	usb_pcwd_device = usb_pcwd;
 
-	init_MUTEX (&usb_pcwd->sem);
+	mutex_init(&usb_pcwd->mtx);
 	usb_pcwd->udev = udev;
 	usb_pcwd->interface = interface;
 	usb_pcwd->interface_number = iface_desc->desc.bInterfaceNumber;
@@ -763,7 +763,7 @@ static void usb_pcwd_disconnect(struct usb_interface *interface)
 	usb_pcwd = usb_get_intfdata (interface);
 	usb_set_intfdata (interface, NULL);
 
-	down (&usb_pcwd->sem);
+	mutex_lock(&usb_pcwd->mtx);
 
 	/* Stop the timer before we leave */
 	if (!nowayout)
@@ -777,7 +777,7 @@ static void usb_pcwd_disconnect(struct usb_interface *interface)
 	misc_deregister(&usb_pcwd_temperature_miscdev);
 	unregister_reboot_notifier(&usb_pcwd_notifier);
 
-	up (&usb_pcwd->sem);
+	mutex_unlock(&usb_pcwd->mtx);
 
 	/* Delete the USB PCWD device */
 	usb_pcwd_delete(usb_pcwd);

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

         An ounce of practice is worth more than tons of preaching
                            (Mahatma Gandhi)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
