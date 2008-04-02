Return-Path: <linux-kernel-owner+w=401wt.eu-S1760142AbYDUNUO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760142AbYDUNUO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 09:20:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759480AbYDUNSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 09:18:45 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:9129 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757392AbYDUNSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 09:18:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:in-reply-to:references:date:subject:cc:from;
        b=ZA3OS5xBbi8kqod6QrOSWOJf+DF+ryLEZbd6vVPO37/MtCRdiLwoSgazPd1hW0189z3m6d82prmVgkQji0im8V57xyvCP98fob1gp3usnXEBL6jNI4+4kH9dPGFW1ZUtqCXVxaKykSw7eskWcL0TXunipaMGTbGSRnv5jzcrXX4=
Message-Id: <e6cdd15629a5a99d805fa3cbf0f5174bcfc685bb.1208783694.git.dmitry.torokhov@gmail.com>
In-Reply-To: <cover.1208783694.git.dmitry.torokhov@gmail.com>
References: <cover.1208783694.git.dmitry.torokhov@gmail.com>
Date: Wed, 2 Apr 2008 00:42:42 -0400
Subject: [PATCH 02/37] Input: locomokbd - add 'off' button support for Sharp Collie/Poodle
Cc: linux-kernel@vger.kernel.org, jkosina@suse.cz, akpm@linux-foundation.org
From: Helge Deller <dmitry.torokhov@gmail.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enables the Sharp Zaurus Collie and Poodle devices to be turned off
by pressing the "Cancel" button for a few seconds (as designed by
Sharp).

Additional small cleanups:
- removal of unused #defines and variables
- add missing __devinit/__devexit/__devinitconst annotations
- reorganized copyright notice

Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---
 drivers/input/keyboard/locomokbd.c |   73 +++++++++++++++++++++++------------
 1 files changed, 48 insertions(+), 25 deletions(-)

diff --git a/drivers/input/keyboard/locomokbd.c b/drivers/input/keyboard/locomokbd.c
index 5a0ca18..9caed30 100644
--- a/drivers/input/keyboard/locomokbd.c
+++ b/drivers/input/keyboard/locomokbd.c
@@ -1,14 +1,12 @@
 /*
- *  Copyright (c) 2005 John Lenz
+ * LoCoMo keyboard driver for Linux-based ARM PDAs:
+ * 	- SHARP Zaurus Collie (SL-5500)
+ * 	- SHARP Zaurus Poodle (SL-5600)
  *
+ * Copyright (c) 2005 John Lenz
  * Based on from xtkbd.c
- */
-
-/*
- * LoCoMo keyboard driver for Linux/ARM
- */
-
-/*
+ *
+ *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
@@ -47,7 +45,8 @@ MODULE_LICENSE("GPL");
 #define KEY_CONTACT		KEY_F18
 #define KEY_CENTER		KEY_F15
 
-static unsigned char locomokbd_keycode[LOCOMOKBD_NUMKEYS] = {
+static const unsigned char
+locomokbd_keycode[LOCOMOKBD_NUMKEYS] __devinitconst = {
 	0, KEY_ESC, KEY_ACTIVITY, 0, 0, 0, 0, 0, 0, 0,				/* 0 - 9 */
 	0, 0, 0, 0, 0, 0, 0, KEY_MENU, KEY_HOME, KEY_CONTACT,			/* 10 - 19 */
 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0,						/* 20 - 29 */
@@ -67,22 +66,21 @@ static unsigned char locomokbd_keycode[LOCOMOKBD_NUMKEYS] = {
 #define KB_COLS			8
 #define KB_ROWMASK(r)		(1 << (r))
 #define SCANCODE(c,r)		( ((c)<<4) + (r) + 1 )
-#define	NR_SCANCODES		128
 
 #define KB_DELAY		8
 #define SCAN_INTERVAL		(HZ/10)
-#define LOCOMOKBD_PRESSED	1
 
 struct locomokbd {
 	unsigned char keycode[LOCOMOKBD_NUMKEYS];
 	struct input_dev *input;
 	char phys[32];
 
-	struct locomo_dev *ldev;
 	unsigned long base;
 	spinlock_t lock;
 
 	struct timer_list timer;
+	unsigned long suspend_jiffies;
+	unsigned int count_cancel;
 };
 
 /* helper functions for reading the keyboard matrix */
@@ -128,7 +126,7 @@ static inline void locomokbd_reset_col(unsigned long membase, int col)
 /* Scan the hardware keyboard and push any changes up through the input layer */
 static void locomokbd_scankeyboard(struct locomokbd *locomokbd)
 {
-	unsigned int row, col, rowd, scancode;
+	unsigned int row, col, rowd;
 	unsigned long flags;
 	unsigned int num_pressed;
 	unsigned long membase = locomokbd->base;
@@ -145,13 +143,33 @@ static void locomokbd_scankeyboard(struct locomokbd *locomokbd)
 
 		rowd = ~locomo_readl(membase + LOCOMO_KIB);
 		for (row = 0; row < KB_ROWS; row++) {
+			unsigned int scancode, pressed, key;
+
 			scancode = SCANCODE(col, row);
-			if (rowd & KB_ROWMASK(row)) {
-				num_pressed += 1;
-				input_report_key(locomokbd->input, locomokbd->keycode[scancode], 1);
-			} else {
-				input_report_key(locomokbd->input, locomokbd->keycode[scancode], 0);
-			}
+			pressed = rowd & KB_ROWMASK(row);
+			key = locomokbd->keycode[scancode];
+
+			input_report_key(locomokbd->input, key, pressed);
+			if (likely(!pressed))
+				continue;
+
+			num_pressed++;
+
+			/* The "Cancel/ESC" key is labeled "On/Off" on
+			 * Collie and Poodle and should suspend the device
+			 * if it was pressed for more than a second. */
+			if (unlikely(key == KEY_ESC)) {
+				if (!time_after(jiffies,
+					locomokbd->suspend_jiffies + HZ))
+					continue;
+				if (locomokbd->count_cancel++
+					!= (HZ/SCAN_INTERVAL + 1))
+					continue;
+				input_event(locomokbd->input, EV_PWR,
+					KEY_SUSPEND, 1);
+				locomokbd->suspend_jiffies = jiffies;
+			} else
+				locomokbd->count_cancel = 0;
 		}
 		locomokbd_reset_col(membase, col);
 	}
@@ -162,6 +180,8 @@ static void locomokbd_scankeyboard(struct locomokbd *locomokbd)
 	/* if any keys are pressed, enable the timer */
 	if (num_pressed)
 		mod_timer(&locomokbd->timer, jiffies + SCAN_INTERVAL);
+	else
+		locomokbd->count_cancel = 0;
 
 	spin_unlock_irqrestore(&locomokbd->lock, flags);
 }
@@ -186,10 +206,11 @@ static irqreturn_t locomokbd_interrupt(int irq, void *dev_id)
 static void locomokbd_timer_callback(unsigned long data)
 {
 	struct locomokbd *locomokbd = (struct locomokbd *) data;
+
 	locomokbd_scankeyboard(locomokbd);
 }
 
-static int locomokbd_probe(struct locomo_dev *dev)
+static int __devinit locomokbd_probe(struct locomo_dev *dev)
 {
 	struct locomokbd *locomokbd;
 	struct input_dev *input_dev;
@@ -211,7 +232,6 @@ static int locomokbd_probe(struct locomo_dev *dev)
 		goto err_free_mem;
 	}
 
-	locomokbd->ldev = dev;
 	locomo_set_drvdata(dev, locomokbd);
 
 	locomokbd->base = (unsigned long) dev->mapbase;
@@ -222,6 +242,8 @@ static int locomokbd_probe(struct locomo_dev *dev)
 	locomokbd->timer.function = locomokbd_timer_callback;
 	locomokbd->timer.data = (unsigned long) locomokbd;
 
+	locomokbd->suspend_jiffies = jiffies;
+
 	locomokbd->input = input_dev;
 	strcpy(locomokbd->phys, "locomokbd/input0");
 
@@ -233,9 +255,10 @@ static int locomokbd_probe(struct locomo_dev *dev)
 	input_dev->id.version = 0x0100;
 	input_dev->dev.parent = &dev->dev;
 
-	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REP);
+	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REP) |
+				BIT_MASK(EV_PWR);
 	input_dev->keycode = locomokbd->keycode;
-	input_dev->keycodesize = sizeof(unsigned char);
+	input_dev->keycodesize = sizeof(locomokbd_keycode[0]);
 	input_dev->keycodemax = ARRAY_SIZE(locomokbd_keycode);
 
 	memcpy(locomokbd->keycode, locomokbd_keycode, sizeof(locomokbd->keycode));
@@ -268,7 +291,7 @@ static int locomokbd_probe(struct locomo_dev *dev)
 	return err;
 }
 
-static int locomokbd_remove(struct locomo_dev *dev)
+static int __devexit locomokbd_remove(struct locomo_dev *dev)
 {
 	struct locomokbd *locomokbd = locomo_get_drvdata(dev);
 
@@ -292,7 +315,7 @@ static struct locomo_driver keyboard_driver = {
 	},
 	.devid	= LOCOMO_DEVID_KEYBOARD,
 	.probe	= locomokbd_probe,
-	.remove	= locomokbd_remove,
+	.remove	= __devexit_p(locomokbd_remove),
 };
 
 static int __init locomokbd_init(void)
-- 
1.5.5.rc2.6.gf58d


