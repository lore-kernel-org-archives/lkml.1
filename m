Return-Path: <linux-kernel-owner+w=401wt.eu-S932394AbYDUNXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932394AbYDUNXv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 09:23:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760014AbYDUNTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 09:19:08 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:8449 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757975AbYDUNS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 09:18:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:in-reply-to:references:date:subject:cc:from;
        b=jYHOZDNQiyCtPlI/JN8jgQYsCk1KiKEVEvb1uwSPkmkz1eMYeCD4pUy+Yry4CxUGy6VPXtDj9OIpTTftAQe8ZOijVFIGQyO0JcQQDxDo//C/o+ZHAcpBz7X3p8ZDMoZ+CjmjchzQ3vhTJ4EnST4un0mJsW3y5eWBcqq8VRu0ubY=
Message-Id: <fc55e95214f1e8384e48cff88279d16507fa5358.1208783694.git.dmitry.torokhov@gmail.com>
In-Reply-To: <cover.1208783694.git.dmitry.torokhov@gmail.com>
References: <cover.1208783694.git.dmitry.torokhov@gmail.com>
Date: Thu, 3 Apr 2008 16:18:44 -0400
Subject: [PATCH 15/37] Input: xpad - do not report nonexistent buttons for xbox360
Cc: linux-kernel@vger.kernel.org, jkosina@suse.cz, akpm@linux-foundation.org
From: Anssi Hannula <dmitry.torokhov@gmail.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The buttons BTN_C and BTN_Z are only used in the original xbox
controller, not in xbox360 controller. Therefore only add them to
keybit when the controller is a non-360 one.

Signed-off-by: Anssi Hannula <anssi.hannula@gmail.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---
 drivers/input/joystick/xpad.c |   18 ++++++++++++++----
 1 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index 8952495..b48f705 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -144,12 +144,19 @@ static const struct xpad_device {
 	{ 0x0000, 0x0000, "Generic X-Box pad", MAP_DPAD_UNKNOWN, XTYPE_UNKNOWN }
 };
 
-static const signed short xpad_btn[] = {
-	BTN_A, BTN_B, BTN_C, BTN_X, BTN_Y, BTN_Z,	/* "analog" buttons */
+/* buttons shared with xbox and xbox360 */
+static const signed short xpad_common_btn[] = {
+	BTN_A, BTN_B, BTN_X, BTN_Y,			/* "analog" buttons */
 	BTN_START, BTN_BACK, BTN_THUMBL, BTN_THUMBR,	/* start/back/sticks */
 	-1						/* terminating entry */
 };
 
+/* original xbox controllers only */
+static const signed short xpad_btn[] = {
+	BTN_C, BTN_Z,		/* "analog" buttons */
+	-1			/* terminating entry */
+};
+
 /* only used if MAP_DPAD_TO_BUTTONS */
 static const signed short xpad_btn_pad[] = {
 	BTN_LEFT, BTN_RIGHT,		/* d-pad left, right */
@@ -679,11 +686,14 @@ static int xpad_probe(struct usb_interface *intf, const struct usb_device_id *id
 	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
 
 	/* set up buttons */
-	for (i = 0; xpad_btn[i] >= 0; i++)
-		set_bit(xpad_btn[i], input_dev->keybit);
+	for (i = 0; xpad_common_btn[i] >= 0; i++)
+		set_bit(xpad_common_btn[i], input_dev->keybit);
 	if (xpad->xtype == XTYPE_XBOX360)
 		for (i = 0; xpad360_btn[i] >= 0; i++)
 			set_bit(xpad360_btn[i], input_dev->keybit);
+	else
+		for (i = 0; xpad_btn[i] >= 0; i++)
+			set_bit(xpad_btn[i], input_dev->keybit);
 	if (xpad->dpad_mapping == MAP_DPAD_TO_BUTTONS)
 		for (i = 0; xpad_btn_pad[i] >= 0; i++)
 			set_bit(xpad_btn_pad[i], input_dev->keybit);
-- 
1.5.5.rc2.6.gf58d


