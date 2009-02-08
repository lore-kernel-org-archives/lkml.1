Return-Path: <linux-kernel-owner+w=401wt.eu-S1753952AbZBHUIK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952AbZBHUIK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 15:08:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752228AbZBHUH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 15:07:56 -0500
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:40775 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751387AbZBHUHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 15:07:54 -0500
X-Trace: 145594294/mk-filter-1.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.44.176.198/None/adrian@newgolddream.dyndns.info
X-SBRS: None
X-RemoteIP: 80.44.176.198
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-MUA: Evolution 2.24.3 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsoEAHrKjklQLLDG/2dsb2JhbACBbspuhBoG
X-IronPort-AV: E=Sophos;i="4.37,400,1231113600"; 
   d="scan'208";a="145594294"
Subject: Re: [PATCH] sh: maple: add support for Visual Memory Card devices,
 and make consequential changes to maple input drivers - 0/3 - v5
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Greg KH <greg@kroah.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       dwmw2 <dwmw2@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       MTD <linux-mtd@lists.infradead.org>,
       linux-sh <linux-sh@vger.kernel.org>,
       linux-input <linux-input@vger.kernel.org>,
       Paul Mundt <lethal@linux-sh.org>
In-Reply-To: <1234122069.6736.8.camel@localhost.localdomain>
References: <1234122069.6736.8.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sun, 08 Feb 2009 20:07:37 +0000
Message-Id: <1234123657.6736.32.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Consequential changes to the maple input drivers as well as a cleanup of
the keyboard code.

Signed-off-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
---
diff --git a/drivers/input/joystick/maplecontrol.c b/drivers/input/joystick/maplecontrol.c
index e50047b..77cfde5 100644
--- a/drivers/input/joystick/maplecontrol.c
+++ b/drivers/input/joystick/maplecontrol.c
@@ -3,7 +3,7 @@
  *	Based on drivers/usb/iforce.c
  *
  *	Copyright Yaegashi Takeshi, 2001
- *	Adrian McMenamin, 2008
+ *	Adrian McMenamin, 2008 - 2009
  */
 
 #include <linux/kernel.h>
@@ -29,7 +29,7 @@ static void dc_pad_callback(struct mapleq *mq)
 	struct maple_device *mapledev = mq->dev;
 	struct dc_pad *pad = maple_get_drvdata(mapledev);
 	struct input_dev *dev = pad->dev;
-	unsigned char *res = mq->recvbuf;
+	unsigned char *res = mq->recvbuf->buf;
 
 	buttons = ~le16_to_cpup((__le16 *)(res + 8));
 
diff --git a/drivers/input/keyboard/maple_keyb.c b/drivers/input/keyboard/maple_keyb.c
index 22f17a5..5aa2361 100644
--- a/drivers/input/keyboard/maple_keyb.c
+++ b/drivers/input/keyboard/maple_keyb.c
@@ -1,8 +1,8 @@
 /*
  * SEGA Dreamcast keyboard driver
  * Based on drivers/usb/usbkbd.c
- * Copyright YAEGASHI Takeshi, 2001
- * Porting to 2.6 Copyright Adrian McMenamin, 2007, 2008
+ * Copyright (c) YAEGASHI Takeshi, 2001
+ * Porting to 2.6 Copyright (c) Adrian McMenamin, 2007 - 2009
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -33,7 +33,7 @@ static DEFINE_MUTEX(maple_keyb_mutex);
 
 #define NR_SCANCODES 256
 
-MODULE_AUTHOR("YAEGASHI Takeshi, Adrian McMenamin");
+MODULE_AUTHOR("Adrian McMenamin <adrian@mcmen.demon.co.uk");
 MODULE_DESCRIPTION("SEGA Dreamcast keyboard driver");
 MODULE_LICENSE("GPL");
 
@@ -115,7 +115,7 @@ static void dc_scan_kbd(struct dc_kbd *kbd)
 				input_event(dev, EV_MSC, MSC_SCAN, code);
 				input_report_key(dev, keycode, 0);
 			} else
-				printk(KERN_DEBUG "maple_keyb: "
+				dev_dbg(&dev->dev,
 					"Unknown key (scancode %#x) released.",
 					code);
 		}
@@ -127,7 +127,7 @@ static void dc_scan_kbd(struct dc_kbd *kbd)
 				input_event(dev, EV_MSC, MSC_SCAN, code);
 				input_report_key(dev, keycode, 1);
 			} else
-				printk(KERN_DEBUG "maple_keyb: "
+				dev_dbg(&dev->dev,
 					"Unknown key (scancode %#x) pressed.",
 					code);
 		}
@@ -140,7 +140,7 @@ static void dc_kbd_callback(struct mapleq *mq)
 {
 	struct maple_device *mapledev = mq->dev;
 	struct dc_kbd *kbd = maple_get_drvdata(mapledev);
-	unsigned long *buf = mq->recvbuf;
+	unsigned long *buf = (unsigned long *)(mq->recvbuf->buf);
 
 	/*
 	 * We should always get the lock because the only
@@ -159,22 +159,27 @@ static void dc_kbd_callback(struct mapleq *mq)
 
 static int probe_maple_kbd(struct device *dev)
 {
-	struct maple_device *mdev = to_maple_dev(dev);
-	struct maple_driver *mdrv = to_maple_driver(dev->driver);
+	struct maple_device *mdev;
+	struct maple_driver *mdrv;
 	int i, error;
 	struct dc_kbd *kbd;
 	struct input_dev *idev;
 
-	if (!(mdev->function & MAPLE_FUNC_KEYBOARD))
-		return -EINVAL;
+	mdev = to_maple_dev(dev);
+	mdrv = to_maple_driver(dev->driver);
 
 	kbd = kzalloc(sizeof(struct dc_kbd), GFP_KERNEL);
-	idev = input_allocate_device();
-	if (!kbd || !idev) {
+	if (!kbd) {
 		error = -ENOMEM;
 		goto fail;
 	}
 
+	idev = input_allocate_device();
+	if (!idev) {
+		error = -ENOMEM;
+		goto fail_idev_alloc;
+	}
+
 	kbd->dev = idev;
 	memcpy(kbd->keycode, dc_kbd_keycode, sizeof(kbd->keycode));
 
@@ -195,7 +200,7 @@ static int probe_maple_kbd(struct device *dev)
 
 	error = input_register_device(idev);
 	if (error)
-		goto fail;
+		goto fail_register;
 
 	/* Maple polling is locked to VBLANK - which may be just 50/s */
 	maple_getcond_callback(mdev, dc_kbd_callback, HZ/50,
@@ -207,10 +212,12 @@ static int probe_maple_kbd(struct device *dev)
 
 	return error;
 
-fail:
+fail_register:
+	maple_set_drvdata(mdev, NULL);
 	input_free_device(idev);
+fail_idev_alloc:
 	kfree(kbd);
-	maple_set_drvdata(mdev, NULL);
+fail:
 	return error;
 }
 





