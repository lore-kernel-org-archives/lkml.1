Return-Path: <linux-kernel-owner+w=401wt.eu-S1754990AbYFOTqI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990AbYFOTqI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 15:46:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751617AbYFOToz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 15:44:55 -0400
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:46318 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751069AbYFOTow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 15:44:52 -0400
X-Trace: 28678560/mk-filter-4.mail.uk.tiscali.com/B2C/$THROTTLED-DYNAMIC/CUSTOMER-DYNAMIC-IP/81.1.82.193
X-SBRS: None
X-RemoteIP: 81.1.82.193
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhIFACAOVUhRAVLB/2dsb2JhbACBW6ob
X-IronPort-AV: E=Sophos;i="4.27,648,1204502400"; 
   d="scan'208";a="28678560"
Subject: [PATCH] input: Clean up maple keyboard driver
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       linux-input <linux-input@vger.kernel.org>,
       linux-sh <linux-sh@vger.kernel.org>, Paul Mundt <lethal@linux-sh.org>
Content-Type: text/plain
Date: Sun, 15 Jun 2008 20:43:39 +0100
Message-Id: <1213559019.22707.12.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Have a single probe function instead of a probe and a connect function.
Also tidy a comment.
1 files changed, 33 insertions(+), 48 deletions(-)


Signed-off-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
---



diff --git a/drivers/input/keyboard/maple_keyb.c b/drivers/input/keyboard/maple_keyb.c
index 94e9b3f..37ad346 100644
--- a/drivers/input/keyboard/maple_keyb.c
+++ b/drivers/input/keyboard/maple_keyb.c
@@ -144,8 +144,8 @@ static void dc_kbd_callback(struct mapleq *mq)
 	unsigned long *buf = mq->recvbuf;
 
 	/*
-	 * We should always be getting the lock because the only
-	 * time it may be locked if driver is in cleanup phase.
+	 * We should always get the lock because the only
+	 * time it may be locked is if driver is in cleanup phase.
 	 */
 	if (likely(mutex_trylock(&maple_keyb_mutex))) {
 
@@ -158,63 +158,73 @@ static void dc_kbd_callback(struct mapleq *mq)
 	}
 }
 
-static int dc_kbd_connect(struct maple_device *mdev)
+
+/* allow the keyboard to be used */
+static int probe_maple_kbd(struct device *dev)
 {
-	int i, error;
+	struct maple_device *mdev = to_maple_dev(dev);
+	struct maple_driver *mdrv = to_maple_driver(dev->driver);
 	struct dc_kbd *kbd;
-	struct input_dev *dev;
+	struct input_dev *idev;
+	int error, i;
 
 	kbd = kzalloc(sizeof(struct dc_kbd), GFP_KERNEL);
 	if (!kbd) {
 		error = -ENOMEM;
 		goto fail_kbd;
 	}
-	dev = input_allocate_device();
-	if (!dev) {
+
+	idev = input_allocate_device();
+	if (!idev) {
 		error = -ENOMEM;
 		goto fail_dev;
 	}
 
 	mdev->private_data = kbd;
 
-	kbd->dev = dev;
+	kbd->dev = idev;
 	memcpy(kbd->keycode, dc_kbd_keycode, sizeof(kbd->keycode));
 
-	dev->name = mdev->product_name;
-	dev->evbit[0] = BIT(EV_KEY) | BIT(EV_REP);
-	dev->keycode = kbd->keycode;
-	dev->keycodesize = sizeof(unsigned short);
-	dev->keycodemax = ARRAY_SIZE(kbd->keycode);
-	dev->id.bustype = BUS_HOST;
-	dev->dev.parent = &mdev->dev;
+	idev->name = mdev->product_name;
+	idev->evbit[0] = BIT(EV_KEY) | BIT(EV_REP);
+	idev->keycode = kbd->keycode;
+	idev->keycodesize = sizeof(unsigned short);
+	idev->keycodemax = ARRAY_SIZE(kbd->keycode);
+	idev->id.bustype = BUS_HOST;
+	idev->dev.parent = &mdev->dev;
 
 	for (i = 0; i < NR_SCANCODES; i++)
-		__set_bit(dc_kbd_keycode[i], dev->keybit);
-	__clear_bit(KEY_RESERVED, dev->keybit);
+		__set_bit(dc_kbd_keycode[i], idev->keybit);
+	__clear_bit(KEY_RESERVED, idev->keybit);
 
-	input_set_capability(dev, EV_MSC, MSC_SCAN);
-	input_set_drvdata(dev, kbd);
+	input_set_capability(idev, EV_MSC, MSC_SCAN);
+	input_set_drvdata(idev, kbd);
 
-	error = input_register_device(dev);
+	error = input_register_device(idev);
 	if (error)
 		goto fail;
 
 	/* Maple polling is locked to VBLANK - which may be just 50/s */
 	maple_getcond_callback(mdev, dc_kbd_callback, HZ/50,
 		MAPLE_FUNC_KEYBOARD);
-	return 0;
+
+	mdev->driver = mdrv;
+
+	return error;
 
 fail:
-	input_free_device(dev);
+	input_free_device(idev);
 fail_dev:
 	kfree(kbd);
 fail_kbd:
 	mdev->private_data = NULL;
 	return error;
+
 }
 
-static void dc_kbd_disconnect(struct maple_device *mdev)
+static int remove_maple_kbd(struct device *dev)
 {
+	struct maple_device *mdev = to_maple_dev(dev);
 	struct dc_kbd *kbd;
 
 	mutex_lock(&maple_keyb_mutex);
@@ -225,36 +235,11 @@ static void dc_kbd_disconnect(struct maple_device *mdev)
 	kfree(kbd);
 
 	mutex_unlock(&maple_keyb_mutex);
-}
-
-/* allow the keyboard to be used */
-static int probe_maple_kbd(struct device *dev)
-{
-	struct maple_device *mdev = to_maple_dev(dev);
-	struct maple_driver *mdrv = to_maple_driver(dev->driver);
-	int error;
-
-	error = dc_kbd_connect(mdev);
-	if (error)
-		return error;
-
-	mdev->driver = mdrv;
-
-	return 0;
-}
-
-static int remove_maple_kbd(struct device *dev)
-{
-	struct maple_device *mdev = to_maple_dev(dev);
-
-	dc_kbd_disconnect(mdev);
 	return 0;
 }
 
 static struct maple_driver dc_kbd_driver = {
 	.function = MAPLE_FUNC_KEYBOARD,
-	.connect = dc_kbd_connect,
-	.disconnect = dc_kbd_disconnect,
 	.drv = {
 		.name = "Dreamcast_keyboard",
 		.probe = probe_maple_kbd,

