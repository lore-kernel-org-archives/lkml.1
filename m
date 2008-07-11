Return-Path: <linux-kernel-owner+w=401wt.eu-S1760253AbYGKNtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760253AbYGKNtx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 09:49:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754849AbYGKNr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 09:47:57 -0400
Received: from zbr.yandex.ru ([213.180.219.33]:34975 "EHLO gavana.yandex.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755875AbYGKNrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 09:47:52 -0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, David Fries <david@fries.net>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 30/30] W1: ds2490.c optimize ds_set_pullup
Date: Fri, 11 Jul 2008 17:51:45 +0400
Message-Id: <1215784307247-git-send-email-johnpol@2ka.mipt.ru>
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <12157843054074-git-send-email-johnpol@2ka.mipt.ru>
References: <12157843054074-git-send-email-johnpol@2ka.mipt.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Optimize the ds_set_pullup function.  For a strong pullup to be sent
the ds2490 has to have both the strong pullup mode enabled, and the
specific write operation has to have the SPU bit enabled.  Previously
the write always had the SPU bit enabled and both the duration and
model was set when a strong pullup was requested.  Now the strong
pullup mode is enabled at initialization time, the delay is updated
only when the value changes, and the write SPU bit is set only when a
strong pullup is required.  This removes two or three bus transactions
per strong pullup request.

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

---
 drivers/w1/masters/ds2490.c |   64 ++++++++++++++++++++++++++++++-------------
 1 files changed, 45 insertions(+), 19 deletions(-)

diff --git a/drivers/w1/masters/ds2490.c b/drivers/w1/masters/ds2490.c
index 466048f..d38ac01 100644
--- a/drivers/w1/masters/ds2490.c
+++ b/drivers/w1/masters/ds2490.c
@@ -141,6 +141,10 @@ struct ds_device
 	 * 0: pullup not active, else duration in milliseconds
 	 */
 	int			spu_sleep;
+	/* spu_bit contains COMM_SPU or 0 depending on if the strong pullup
+	 * should be active or not for writes.
+	 */
+	u16			spu_bit;
 
 	struct w1_bus_master	master;
 };
@@ -311,6 +315,25 @@ static void ds_dump_status(struct ds_device *dev, unsigned char *buf, int count)
 	}
 }
 
+static void ds_reset_device(struct ds_device *dev)
+{
+	ds_send_control_cmd(dev, CTL_RESET_DEVICE, 0);
+	/* Always allow strong pullup which allow individual writes to use
+	 * the strong pullup.
+	 */
+	if (ds_send_control_mode(dev, MOD_PULSE_EN, PULSE_SPUE))
+		printk(KERN_ERR "ds_reset_device: "
+			"Error allowing strong pullup\n");
+	/* Chip strong pullup time was cleared. */
+	if (dev->spu_sleep) {
+		/* lower 4 bits are 0, see ds_set_pullup */
+		u8 del = dev->spu_sleep>>4;
+		if (ds_send_control(dev, COMM_SET_DURATION | COMM_IM, del))
+			printk(KERN_ERR "ds_reset_device: "
+				"Error setting duration\n");
+	}
+}
+
 static int ds_recv_data(struct ds_device *dev, unsigned char *buf, int size)
 {
 	int count, err;
@@ -444,7 +467,7 @@ static int ds_wait_status(struct ds_device *dev, struct ds_status *st)
 
 	if (err >= 16 && st->status & ST_EPOF) {
 		printk(KERN_INFO "Resetting device after ST_EPOF.\n");
-		ds_send_control_cmd(dev, CTL_RESET_DEVICE, 0);
+		ds_reset_device(dev);
 		/* Always dump the device status. */
 		count = 101;
 	}
@@ -509,24 +532,26 @@ static int ds_set_speed(struct ds_device *dev, int speed)
 
 static int ds_set_pullup(struct ds_device *dev, int delay)
 {
-	int err;
+	int err = 0;
 	u8 del = 1 + (u8)(delay >> 4);
+	/* Just storing delay would not get the trunication and roundup. */
+	int ms = del<<4;
+
+	/* Enable spu_bit if a delay is set. */
+	dev->spu_bit = delay?COMM_SPU:0;
+	/* If delay is zero, it has already been disabled, if the time is
+	 * the same as the hardware was last programmed to, there is also
+	 * nothing more to do.  Compare with the recalculated value ms
+	 * rather than del or delay which can have a different value.
+	 */
+	if (delay == 0 || ms == dev->spu_sleep)
+		return err;
 
-	dev->spu_sleep = 0;
-	err = ds_send_control_mode(dev, MOD_PULSE_EN, delay?PULSE_SPUE:0);
+	err = ds_send_control(dev, COMM_SET_DURATION | COMM_IM, del);
 	if (err)
 		return err;
 
-	if (delay) {
-		err = ds_send_control(dev, COMM_SET_DURATION | COMM_IM, del);
-		if (err)
-			return err;
-
-		/* Just storing delay would not get the trunication and
-		 * roundup.
-		 */
-		dev->spu_sleep = del<<4;
-	}
+	dev->spu_sleep = ms;
 
 	return err;
 }
@@ -577,11 +602,11 @@ static int ds_write_byte(struct ds_device *dev, u8 byte)
 	struct ds_status st;
 	u8 rbyte;
 
-	err = ds_send_control(dev, COMM_BYTE_IO | COMM_IM | COMM_SPU, byte);
+	err = ds_send_control(dev, COMM_BYTE_IO | COMM_IM | dev->spu_bit, byte);
 	if (err)
 		return err;
 
-	if (dev->spu_sleep)
+	if (dev->spu_bit)
 		msleep(dev->spu_sleep);
 
 	err = ds_wait_status(dev, &st);
@@ -648,11 +673,11 @@ static int ds_write_block(struct ds_device *dev, u8 *buf, int len)
 	if (err < 0)
 		return err;
 
-	err = ds_send_control(dev, COMM_BLOCK_IO | COMM_IM | COMM_SPU, len);
+	err = ds_send_control(dev, COMM_BLOCK_IO | COMM_IM | dev->spu_bit, len);
 	if (err)
 		return err;
 
-	if (dev->spu_sleep)
+	if (dev->spu_bit)
 		msleep(dev->spu_sleep);
 
 	ds_wait_status(dev, &st);
@@ -849,7 +874,7 @@ static int ds_w1_init(struct ds_device *dev)
 	 * the input buffer.  This will cause the next read to fail
 	 * see the note in ds_recv_data.
 	 */
-	ds_send_control_cmd(dev, CTL_RESET_DEVICE, 0);
+	ds_reset_device(dev);
 
 	dev->master.data	= dev;
 	dev->master.touch_bit	= &ds9490r_touch_bit;
@@ -892,6 +917,7 @@ static int ds_probe(struct usb_interface *intf,
 		return -ENOMEM;
 	}
 	dev->spu_sleep = 0;
+	dev->spu_bit = 0;
 	dev->udev = usb_get_dev(udev);
 	if (!dev->udev) {
 		err = -ENOMEM;
-- 
1.4.4.4

