Return-Path: <linux-kernel-owner+w=401wt.eu-S1754024AbZDYUnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbZDYUnk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 16:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752534AbZDYUna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 16:43:30 -0400
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:6500 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751090AbZDYUn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 16:43:29 -0400
X-Trace: 184312437/mk-filter-4.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.103.174/None/adrian@newgolddream.info
X-SBRS: None
X-RemoteIP: 79.69.103.174
X-IP-MAIL-FROM: adrian@newgolddream.info
X-SMTP-AUTH: 
X-MUA: Evolution 2.26.1 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ag4FADoS80lPRWeu/2dsb2JhbACBUMp9g3QF
X-IronPort-AV: E=Sophos;i="4.40,247,1238972400"; 
   d="scan'208";a="184312437"
Subject: Re: [PATCH] maple: input: fix up maple mouse driver - v2
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-sh <linux-sh@vger.kernel.org>
In-Reply-To: <1240685216.4808.13.camel@localhost.localdomain>
References: <1240685216.4808.13.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sat, 25 Apr 2009 21:43:18 +0100
Message-Id: <1240692198.4808.21.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-04-25 at 19:46 +0100, Adrian McMenamin wrote:
> The maple mouse driver currently in mainline is broken:

Here is a better fix for this, keeping an open and close, so reducing
the load on the system when the mouse is not in use, and also properly
referencing the maple device buffer following the recent update.

drivers/input/mouse/maplemouse.c |   44
+++++++++++++++++++------------------
 1 files changed, 23 insertions(+), 21 deletions(-)

Signed-off-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
---

diff --git a/drivers/input/mouse/maplemouse.c b/drivers/input/mouse/maplemouse.c
index d196abf..8937428 100644
--- a/drivers/input/mouse/maplemouse.c
+++ b/drivers/input/mouse/maplemouse.c
@@ -2,8 +2,8 @@
  *	SEGA Dreamcast mouse driver
  *	Based on drivers/usb/usbmouse.c
  *
- *	Copyright Yaegashi Takeshi, 2001
- *	Adrian McMenamin, 2008
+ *	Copyright (c) Yaegashi Takeshi, 2001
+ *	Adrian McMenamin, 2008 - 2009
  */
 
 #include <linux/kernel.h>
@@ -29,7 +29,7 @@ static void dc_mouse_callback(struct mapleq *mq)
 	struct maple_device *mapledev = mq->dev;
 	struct dc_mouse *mse = maple_get_drvdata(mapledev);
 	struct input_dev *dev = mse->dev;
-	unsigned char *res = mq->recvbuf;
+	unsigned char *res = mq->recvbuf->buf;
 
 	buttons = ~res[8];
 	relx = *(unsigned short *)(res + 12) - 512;
@@ -47,7 +47,7 @@ static void dc_mouse_callback(struct mapleq *mq)
 
 static int dc_mouse_open(struct input_dev *dev)
 {
-	struct dc_mouse *mse = dev->dev.platform_data;
+	struct dc_mouse *mse = maple_get_drvdata(to_maple_dev(&dev->dev));
 
 	maple_getcond_callback(mse->mdev, dc_mouse_callback, HZ/50,
 		MAPLE_FUNC_MOUSE);
@@ -57,29 +57,33 @@ static int dc_mouse_open(struct input_dev *dev)
 
 static void dc_mouse_close(struct input_dev *dev)
 {
-	struct dc_mouse *mse = dev->dev.platform_data;
+	struct dc_mouse *mse = maple_get_drvdata(to_maple_dev(&dev->dev));
 
 	maple_getcond_callback(mse->mdev, dc_mouse_callback, 0,
 		MAPLE_FUNC_MOUSE);
 }
 
-
+/* allow the mouse to be used */
 static int __devinit probe_maple_mouse(struct device *dev)
 {
 	struct maple_device *mdev = to_maple_dev(dev);
 	struct maple_driver *mdrv = to_maple_driver(dev->driver);
+	int error;
 	struct input_dev *input_dev;
 	struct dc_mouse *mse;
-	int error;
 
 	mse = kzalloc(sizeof(struct dc_mouse), GFP_KERNEL);
-	input_dev = input_allocate_device();
-
-	if (!mse || !input_dev) {
+	if (!mse) {
 		error = -ENOMEM;
 		goto fail;
 	}
 
+	input_dev = input_allocate_device();
+	if (!input_dev) {
+		error = -ENOMEM;
+		goto fail_nomem;
+	}
+
 	mse->dev = input_dev;
 	mse->mdev = mdev;
 
@@ -89,25 +93,24 @@ static int __devinit probe_maple_mouse(struct device *dev)
 		BIT_MASK(BTN_RIGHT) | BIT_MASK(BTN_MIDDLE);
 	input_dev->relbit[0] = BIT_MASK(REL_X) | BIT_MASK(REL_Y) |
 		BIT_MASK(REL_WHEEL);
-	input_dev->name = mdev->product_name;
-	input_dev->id.bustype = BUS_HOST;
 	input_dev->open = dc_mouse_open;
 	input_dev->close = dc_mouse_close;
+	input_dev->name = mdev->product_name;
+	input_dev->id.bustype = BUS_HOST;
+	error =	input_register_device(input_dev);
+	if (error)
+		goto fail_register;
 
 	mdev->driver = mdrv;
 	maple_set_drvdata(mdev, mse);
 
-	error =	input_register_device(input_dev);
-	if (error)
-		goto fail;
-
-	return 0;
+	return error;
 
-fail:
+fail_register:
 	input_free_device(input_dev);
-	maple_set_drvdata(mdev, NULL);
+fail_nomem:
 	kfree(mse);
-	mdev->driver = NULL;
+fail:
 	return error;
 }
 
@@ -120,7 +123,6 @@ static int __devexit remove_maple_mouse(struct device *dev)
 	input_unregister_device(mse->dev);
 	maple_set_drvdata(mdev, NULL);
 	kfree(mse);
-
 	return 0;
 }
 


