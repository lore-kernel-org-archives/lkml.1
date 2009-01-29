Return-Path: <linux-kernel-owner+w=401wt.eu-S1763563AbZA2AeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763563AbZA2AeO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:34:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764106AbZA2AVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 19:21:13 -0500
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:23121 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760282AbZA2AVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 19:21:11 -0500
X-MUA: Evolution 2.24.3 
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhIFAIeEgElQLLDG/2dsb2JhbACBbsl4hUcG
X-IronPort-AV: E=Sophos;i="4.37,340,1231113600"; 
   d="scan'208";a="134939758"
Subject: [PATCH RFC] sh: maple: Add support for SEGA Dreamcast VMU and
 clean up maple bus driver (3/3)
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Greg KH <greg@kroah.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       dwmw2 <dwmw2@infradead.org>, linux-sh <linux-sh@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-input <linux-input@vger.kernel.org>,
       MTD <linux-mtd@lists.infradead.org>
In-Reply-To: <1233187750.6734.27.camel@localhost.localdomain>
References: <1233186456.6734.16.camel@localhost.localdomain>
	 <1233187069.6734.21.camel@localhost.localdomain>
	 <1233187750.6734.27.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 29 Jan 2009 00:18:07 +0000
Message-Id: <1233188287.6734.32.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Consequential patch to the maple keyboard driver and general fix to the keyboard driver.

Signed-off-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
---

diff --git a/drivers/input/keyboard/maple_keyb.c b/drivers/input/keyboard/maple_keyb.c
index 22f17a5..8d3bb1d 100644
--- a/drivers/input/keyboard/maple_keyb.c
+++ b/drivers/input/keyboard/maple_keyb.c
@@ -140,7 +140,7 @@ static void dc_kbd_callback(struct mapleq *mq)
 {
 	struct maple_device *mapledev = mq->dev;
 	struct dc_kbd *kbd = maple_get_drvdata(mapledev);
-	unsigned long *buf = mq->recvbuf;
+	unsigned long *buf = (unsigned long *)(mq->recvbuf->buf);
 
 	/*
 	 * We should always get the lock because the only
@@ -159,22 +159,41 @@ static void dc_kbd_callback(struct mapleq *mq)
 
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
+		error = EINVAL;
+		goto fail;
+	}
+
+	mdrv = to_maple_driver(dev->driver);
+	if (!mdrv) {
+		error = EINVAL;
+		goto fail;
+	}
+
+	if (!(mdev->function & MAPLE_FUNC_KEYBOARD)) {
+		error = EINVAL;
+		goto fail;
+	}
 
 	kbd = kzalloc(sizeof(struct dc_kbd), GFP_KERNEL);
-	idev = input_allocate_device();
-	if (!kbd || !idev) {
-		error = -ENOMEM;
+	if (!kbd) {
+		error = ENOMEM;
 		goto fail;
 	}
 
+	idev = input_allocate_device();
+	if (!idev) {
+		error = ENOMEM;
+		goto fail_idev_alloc;
+	}
+
 	kbd->dev = idev;
 	memcpy(kbd->keycode, dc_kbd_keycode, sizeof(kbd->keycode));
 
@@ -195,7 +214,7 @@ static int probe_maple_kbd(struct device *dev)
 
 	error = input_register_device(idev);
 	if (error)
-		goto fail;
+		goto fail_register;
 
 	/* Maple polling is locked to VBLANK - which may be just 50/s */
 	maple_getcond_callback(mdev, dc_kbd_callback, HZ/50,
@@ -207,11 +226,13 @@ static int probe_maple_kbd(struct device *dev)
 
 	return error;
 
-fail:
+fail_register:
+	maple_set_drvdata(mdev, NULL);
 	input_free_device(idev);
+fail_idev_alloc:
 	kfree(kbd);
-	maple_set_drvdata(mdev, NULL);
-	return error;
+fail:
+	return -error;
 }
 
 static int remove_maple_kbd(struct device *dev)


