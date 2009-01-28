Return-Path: <linux-kernel-owner+w=401wt.eu-S1751403AbZA1KZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751403AbZA1KZO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 05:25:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbZA1KYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 05:24:08 -0500
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:45547 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751930AbZA1KYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 05:24:06 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 3/6] input: bcm5974: Add support for the Macbook 5 (Unibody)
Date: Wed, 28 Jan 2009 11:23:46 +0100
Message-Id: <1233138229-12489-4-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1233138229-12489-3-git-send-email-rydberg@euromail.se>
References: <1233138229-12489-1-git-send-email-rydberg@euromail.se>
 <1233138229-12489-2-git-send-email-rydberg@euromail.se>
 <1233138229-12489-3-git-send-email-rydberg@euromail.se>
X-Originating-IP: 83.248.192.132
X-Scan-Result: No virus found in message 1LS7aU-0000hF-7E.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1LS7aU-0000hF-7E 0b8479bf8ee196b40321778fe03327a0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the new unibody Macbook, with physically
integrated button and trackpad. A new button, BTN_TOOL_PRESS, is
introduced to allow for non-trivial handling of this device in user
space.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Tested-by: David M. Lary <dmlary@gmail.com>
---
 drivers/input/mouse/bcm5974.c |   42 +++++++++++++++++++++++++++++++++++++++-
 include/linux/input.h         |    1 +
 2 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/drivers/input/mouse/bcm5974.c b/drivers/input/mouse/bcm5974.c
index a170574..f85a296 100644
--- a/drivers/input/mouse/bcm5974.c
+++ b/drivers/input/mouse/bcm5974.c
@@ -51,6 +51,10 @@
 #define USB_DEVICE_ID_APPLE_WELLSPRING2_ANSI	0x0230
 #define USB_DEVICE_ID_APPLE_WELLSPRING2_ISO	0x0231
 #define USB_DEVICE_ID_APPLE_WELLSPRING2_JIS	0x0232
+/* Macbook5,1 (unibody), aka wellspring3 */
+#define USB_DEVICE_ID_APPLE_WELLSPRING3_ANSI	0x0236
+#define USB_DEVICE_ID_APPLE_WELLSPRING3_ISO	0x0237
+#define USB_DEVICE_ID_APPLE_WELLSPRING3_JIS	0x0238
 
 #define BCM5974_DEVICE(prod) {					\
 	.match_flags = (USB_DEVICE_ID_MATCH_DEVICE |		\
@@ -72,6 +76,10 @@ static const struct usb_device_id bcm5974_table[] = {
 	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING2_ANSI),
 	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING2_ISO),
 	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING2_JIS),
+	/* Macbook5,1 */
+	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING3_ANSI),
+	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING3_ISO),
+	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING3_JIS),
 	/* Terminating entry */
 	{}
 };
@@ -98,11 +106,19 @@ struct bt_data {
 
 /* trackpad header types */
 enum tp_type {
-	TYPE1			/* plain trackpad */
+	TYPE1,			/* plain trackpad */
+	TYPE2			/* button integrated in trackpad */
 };
 
 /* trackpad finger data offsets */
 #define FINGER_TYPE1		26
+#define FINGER_TYPE2		30
+
+/* trackpad button data offsets */
+#define BUTTON_TYPE2		15
+
+/* integrated button capability by configuration */
+#define HAS_INTEGRATED_BUTTON(c)	(c->tp_type == TYPE2)
 
 /* trackpad finger structure */
 struct tp_finger {
@@ -202,6 +218,17 @@ static const struct bcm5974_config bcm5974_config_table[] = {
 		{ DIM_X, DIM_X / SN_COORD, -4824, 4824 },
 		{ DIM_Y, DIM_Y / SN_COORD, -172, 4290 }
 	},
+	{
+		USB_DEVICE_ID_APPLE_WELLSPRING3_ANSI,
+		USB_DEVICE_ID_APPLE_WELLSPRING3_ISO,
+		USB_DEVICE_ID_APPLE_WELLSPRING3_JIS,
+		0x84, sizeof(struct bt_data),
+		0x81, TYPE2, FINGER_TYPE2, FINGER_TYPE2 + SIZEOF_ALL_FINGERS,
+		{ DIM_PRESSURE, DIM_PRESSURE / SN_PRESSURE, 0, 300 },
+		{ DIM_WIDTH, DIM_WIDTH / SN_WIDTH, 0, 2048 },
+		{ DIM_X, DIM_X / SN_COORD, -4460, 5166 },
+		{ DIM_Y, DIM_Y / SN_COORD, -75, 6700 }
+	},
 	{}
 };
 
@@ -259,6 +286,8 @@ static void setup_events_to_report(struct input_dev *input_dev,
 	__set_bit(BTN_TOOL_DOUBLETAP, input_dev->keybit);
 	__set_bit(BTN_TOOL_TRIPLETAP, input_dev->keybit);
 	__set_bit(BTN_TOOL_QUADTAP, input_dev->keybit);
+	if (HAS_INTEGRATED_BUTTON(cfg))
+		__set_bit(BTN_TOOL_PRESS, input_dev->keybit);
 	__set_bit(BTN_LEFT, input_dev->keybit);
 }
 
@@ -281,7 +310,7 @@ static int report_tp_state(struct bcm5974 *dev, int size)
 	const struct tp_finger *f;
 	struct input_dev *input = dev->input;
 	int raw_p, raw_w, raw_x, raw_y, raw_n;
-	int ptest = 0, origin = 0, nmin = 0, nmax = 0;
+	int ptest = 0, origin = 0, ibt = 0, nmin = 0, nmax = 0;
 	int abs_p = 0, abs_w = 0, abs_x = 0, abs_y = 0;
 
 	if (size < c->tp_offset || (size - c->tp_offset) % SIZEOF_FINGER != 0)
@@ -303,6 +332,10 @@ static int report_tp_state(struct bcm5974 *dev, int size)
 
 		ptest = int2bound(&c->p, raw_p);
 		origin = raw2int(f->origin);
+
+		/* set the integrated button if applicable */
+		if (c->tp_type == TYPE2)
+			ibt = raw2int(dev->tp_data[BUTTON_TYPE2]);
 	}
 
 	/* while tracking finger still valid, count all fingers */
@@ -346,6 +379,11 @@ static int report_tp_state(struct bcm5974 *dev, int size)
 
 	}
 
+	if (HAS_INTEGRATED_BUTTON(c)) {
+		input_report_key(input, BTN_TOOL_PRESS, ibt);
+		input_report_key(input, BTN_LEFT, ibt);
+	}
+
 	input_sync(input);
 
 	return 0;
diff --git a/include/linux/input.h b/include/linux/input.h
index ee5754a..ccc8a9b 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -440,6 +440,7 @@ struct input_absinfo {
 #define BTN_TOOL_FINGER		0x145
 #define BTN_TOOL_MOUSE		0x146
 #define BTN_TOOL_LENS		0x147
+#define BTN_TOOL_PRESS		0x148	/* The trackpad is a physical button */
 #define BTN_TOUCH		0x14a
 #define BTN_STYLUS		0x14b
 #define BTN_STYLUS2		0x14c
-- 
1.5.6.3

