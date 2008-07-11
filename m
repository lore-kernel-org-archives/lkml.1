Return-Path: <linux-kernel-owner+w=401wt.eu-S1760530AbYGKNuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760530AbYGKNuk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 09:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759385AbYGKNsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 09:48:00 -0400
Received: from zbr.yandex.ru ([213.180.219.33]:34983 "EHLO gavana.yandex.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759378AbYGKNry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 09:47:54 -0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, David Fries <david@fries.net>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 20/30] W1: ds2490.c add support for strong pullup
Date: Fri, 11 Jul 2008 17:51:35 +0400
Message-Id: <1215784306963-git-send-email-johnpol@2ka.mipt.ru>
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <12157843054074-git-send-email-johnpol@2ka.mipt.ru>
References: <12157843054074-git-send-email-johnpol@2ka.mipt.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add strong pullup support for ds2490 driver, also drop mdelay(750),
which busy waits, usage in favour of msleep for long delays.  Now with
msleep only being called when the strong pullup is active, one wire
bus operations are only taking minimal system overhead.

The new set_pullup will only enable the strong pullup when requested,
which is expected to be the only write operation that will benefit
from a strong pullup.

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

---
 drivers/w1/masters/ds2490.c |   76 +++++++++++++++++++++---------------------
 1 files changed, 38 insertions(+), 38 deletions(-)

diff --git a/drivers/w1/masters/ds2490.c b/drivers/w1/masters/ds2490.c
index c8365fb..8ab2c86 100644
--- a/drivers/w1/masters/ds2490.c
+++ b/drivers/w1/masters/ds2490.c
@@ -98,11 +98,6 @@
 #define BRANCH_MAIN			0xCC
 #define BRANCH_AUX			0x33
 
-/*
- * Duration of the strong pull-up pulse in milliseconds.
- */
-#define PULLUP_PULSE_DURATION		750
-
 /* Status flags */
 #define ST_SPUA				0x01  /* Strong Pull-up is active */
 #define ST_PRGA				0x02  /* 12V programming pulse is being generated */
@@ -131,6 +126,11 @@ struct ds_device
 
 	int			ep[NUM_EP];
 
+	/* Strong PullUp
+	 * 0: pullup not active, else duration in milliseconds
+	 */
+	int			spu_sleep;
+
 	struct w1_bus_master	master;
 };
 
@@ -192,7 +192,7 @@ static int ds_send_control_cmd(struct ds_device *dev, u16 value, u16 index)
 
 	return err;
 }
-#if 0
+
 static int ds_send_control_mode(struct ds_device *dev, u16 value, u16 index)
 {
 	int err;
@@ -207,7 +207,7 @@ static int ds_send_control_mode(struct ds_device *dev, u16 value, u16 index)
 
 	return err;
 }
-#endif
+
 static int ds_send_control(struct ds_device *dev, u16 value, u16 index)
 {
 	int err;
@@ -294,14 +294,6 @@ static int ds_recv_status(struct ds_device *dev, struct ds_status *st)
 		if (count < 0)
 			return err;
 	}
-#if 0
-	if (st->status & ST_IDLE) {
-		printk(KERN_INFO "Resetting pulse after ST_IDLE.\n");
-		err = ds_start_pulse(dev, PULLUP_PULSE_DURATION);
-		if (err)
-			return err;
-	}
-#endif
 
 	return err;
 }
@@ -472,32 +464,26 @@ static int ds_set_speed(struct ds_device *dev, int speed)
 }
 #endif  /*  0  */
 
-static int ds_start_pulse(struct ds_device *dev, int delay)
+static int ds_set_pullup(struct ds_device *dev, int delay)
 {
 	int err;
 	u8 del = 1 + (u8)(delay >> 4);
-	struct ds_status st;
-
-#if 0
-	err = ds_stop_pulse(dev, 10);
-	if (err)
-		return err;
-
-	err = ds_send_control_mode(dev, MOD_PULSE_EN, PULSE_SPUE);
-	if (err)
-		return err;
-#endif
-	err = ds_send_control(dev, COMM_SET_DURATION | COMM_IM, del);
-	if (err)
-		return err;
 
-	err = ds_send_control(dev, COMM_PULSE | COMM_IM | COMM_F, 0);
+	dev->spu_sleep = 0;
+	err = ds_send_control_mode(dev, MOD_PULSE_EN, delay?PULSE_SPUE:0);
 	if (err)
 		return err;
 
-	mdelay(delay);
+	if (delay) {
+		err = ds_send_control(dev, COMM_SET_DURATION | COMM_IM, del);
+		if (err)
+			return err;
 
-	ds_wait_status(dev, &st);
+		/* Just storing delay would not get the trunication and
+		 * roundup.
+		 */
+		dev->spu_sleep = del<<4;
+	}
 
 	return err;
 }
@@ -558,6 +544,9 @@ static int ds_write_byte(struct ds_device *dev, u8 byte)
 	if (err)
 		return err;
 
+	if (dev->spu_sleep)
+		msleep(dev->spu_sleep);
+
 	err = ds_wait_status(dev, &st);
 	if (err)
 		return err;
@@ -566,8 +555,6 @@ static int ds_write_byte(struct ds_device *dev, u8 byte)
 	if (err < 0)
 		return err;
 
-	ds_start_pulse(dev, PULLUP_PULSE_DURATION);
-
 	return !(byte == rbyte);
 }
 
@@ -603,7 +590,7 @@ static int ds_read_block(struct ds_device *dev, u8 *buf, int len)
 	if (err < 0)
 		return err;
 
-	err = ds_send_control(dev, COMM_BLOCK_IO | COMM_IM | COMM_SPU, len);
+	err = ds_send_control(dev, COMM_BLOCK_IO | COMM_IM, len);
 	if (err)
 		return err;
 
@@ -630,14 +617,15 @@ static int ds_write_block(struct ds_device *dev, u8 *buf, int len)
 	if (err)
 		return err;
 
+	if (dev->spu_sleep)
+		msleep(dev->spu_sleep);
+
 	ds_wait_status(dev, &st);
 
 	err = ds_recv_data(dev, buf, len);
 	if (err < 0)
 		return err;
 
-	ds_start_pulse(dev, PULLUP_PULSE_DURATION);
-
 	return !(err == len);
 }
 
@@ -803,6 +791,16 @@ static u8 ds9490r_reset(void *data)
 	return 0;
 }
 
+static u8 ds9490r_set_pullup(void *data, int delay)
+{
+	struct ds_device *dev = data;
+
+	if (ds_set_pullup(dev, delay))
+		return 1;
+
+	return 0;
+}
+
 static int ds_w1_init(struct ds_device *dev)
 {
 	memset(&dev->master, 0, sizeof(struct w1_bus_master));
@@ -816,6 +814,7 @@ static int ds_w1_init(struct ds_device *dev)
 	dev->master.read_block	= &ds9490r_read_block;
 	dev->master.write_block	= &ds9490r_write_block;
 	dev->master.reset_bus	= &ds9490r_reset;
+	dev->master.set_pullup	= &ds9490r_set_pullup;
 
 	return w1_add_master_device(&dev->master);
 }
@@ -839,6 +838,7 @@ static int ds_probe(struct usb_interface *intf,
 		printk(KERN_INFO "Failed to allocate new DS9490R structure.\n");
 		return -ENOMEM;
 	}
+	dev->spu_sleep = 0;
 	dev->udev = usb_get_dev(udev);
 	if (!dev->udev) {
 		err = -ENOMEM;
-- 
1.4.4.4

