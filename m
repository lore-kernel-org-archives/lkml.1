Return-Path: <linux-kernel-owner+w=401wt.eu-S1759887AbZBCAVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759887AbZBCAVr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 19:21:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755853AbZBCAVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 19:21:24 -0500
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:22341 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754573AbZBCAVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 19:21:22 -0500
X-MUA: Evolution 2.24.3 
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgMFALsch0lQLLDG/2dsb2JhbACBbssbhBQG
X-IronPort-AV: E=Sophos;i="4.37,368,1231113600"; 
   d="scan'208";a="141265869"
Subject: Re: [PATCH] sh: maple: Add support for VMU devices (v2) [3/3]
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: greg KH <greg@kroah.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Paul Mundt <lethal@linux-sh.org>, dwmw2 <dwmw2@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       MTD <linux-mtd@lists.infradead.org>,
       linux-sh <linux-sh@vger.kernel.org>,
       linux-input <linux-input@vger.kernel.org>
In-Reply-To: <1233619569.13918.12.camel@localhost.localdomain>
References: <1233619569.13918.12.camel@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 03 Feb 2009 00:17:58 +0000
Message-Id: <1233620278.13918.33.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates the Maple keyboard driver to reflect changes in the
maple bus code and also to tidy up some dubious legacy code.

Signed-off-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
---

diff --git a/drivers/input/keyboard/maple_keyb.c b/drivers/input/keyboard/maple_keyb.c
index 22f17a5..42ff911 100644
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
@@ -159,22 +159,30 @@ static void dc_kbd_callback(struct mapleq *mq)
 
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
+	if (!mdev) {
+		error = -EINVAL;
+		goto fail;
+	}
 
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
 
@@ -195,7 +203,7 @@ static int probe_maple_kbd(struct device *dev)
 
 	error = input_register_device(idev);
 	if (error)
-		goto fail;
+		goto fail_register;
 
 	/* Maple polling is locked to VBLANK - which may be just 50/s */
 	maple_getcond_callback(mdev, dc_kbd_callback, HZ/50,
@@ -207,10 +215,12 @@ static int probe_maple_kbd(struct device *dev)
 
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
 


