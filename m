Return-Path: <linux-kernel-owner+w=401wt.eu-S1757256AbZGMU6G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256AbZGMU6G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 16:58:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756864AbZGMU6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 16:58:05 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49437 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757199AbZGMU6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 16:58:03 -0400
Date: Mon, 13 Jul 2009 22:57:50 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Brian Swetland <swetland@google.com>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: HTC: touchscreen driver
Message-ID: <20090713205749.GE2569@elf.ucw.cz>
References: <20090710084323.GA6522@elf.ucw.cz> <a55d774e0907100155m25366994pe9ec5d0f5f868818@mail.gmail.com> <20090710103243.GB7789@elf.ucw.cz> <a55d774e0907100431j3fdc4671i6b185019594367fa@mail.gmail.com> <20090713202302.GC2569@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090713202302.GC2569@elf.ucw.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I'm looking at synaptic touchscreen driver... who should be listed as
an author?

Changes I have so far are...

checkpatch only has minor complains -- lines over 80 characters -- but
the code is _way_ too deeply nested with way too little functions.

								Pavel

diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index 339083e..fa3404f 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -94,6 +94,9 @@ config TOUCHSCREEN_GUNZE
 config TOUCHSCREEN_ELAN_I2C_8232
 	tristate "Elan 8232 I2C touchscreen"
 	depends on I2C
+	help
+	  This enables support for Elan over I2C based touchscreens.
+	  Such touchscreen is used in HTC Dream.
 
 config TOUCHSCREEN_ELO
 	tristate "Elo serial touchscreens"
@@ -215,6 +218,8 @@ config TOUCHSCREEN_SYNAPTICS_I2C_RMI
 	depends on I2C
 	help
 	  This enables support for Synaptics RMI over I2C based touchscreens.
+	  Such touchscreen is used in HTC Dream.
+
 
 config TOUCHSCREEN_TOUCHRIGHT
 	tristate "Touchright serial touchscreen"
diff --git a/drivers/input/touchscreen/synaptics_i2c_rmi.c b/drivers/input/touchscreen/synaptics_i2c_rmi.c
index a45634b..28213b5 100644
--- a/drivers/input/touchscreen/synaptics_i2c_rmi.c
+++ b/drivers/input/touchscreen/synaptics_i2c_rmi.c
@@ -1,4 +1,5 @@
-/* drivers/input/keyboard/synaptics_i2c_rmi.c
+/*
+ * Support for synaptics touchscreen.
  *
  * Copyright (C) 2007 Google, Inc.
  *
@@ -15,7 +16,6 @@
 
 #include <linux/module.h>
 #include <linux/delay.h>
-#include <linux/earlysuspend.h>
 #include <linux/hrtimer.h>
 #include <linux/i2c.h>
 #include <linux/input.h>
@@ -24,18 +24,16 @@
 #include <linux/platform_device.h>
 #include <linux/synaptics_i2c_rmi.h>
 
-#define swap(x, y) do { typeof(x) z = x; x = y; y = z; } while (0)
-
 static struct workqueue_struct *synaptics_wq;
 
 struct synaptics_ts_data {
-	uint16_t addr;
+	u16 addr;
 	struct i2c_client *client;
 	struct input_dev *input_dev;
 	int use_irq;
 	struct hrtimer timer;
 	struct work_struct  work;
-	uint16_t max[2];
+	u16 max[2];
 	int snap_state[2][2];
 	int snap_down_on[2];
 	int snap_down_off[2];
@@ -43,36 +41,35 @@ struct synaptics_ts_data {
 	int snap_up_off[2];
 	int snap_down[2];
 	int snap_up[2];
-	uint32_t flags;
+	u32 flags;
 	int (*power)(int on);
-	struct early_suspend early_suspend;
 };
 
-#ifdef CONFIG_HAS_EARLYSUSPEND
-static void synaptics_ts_early_suspend(struct early_suspend *h);
-static void synaptics_ts_late_resume(struct early_suspend *h);
-#endif
-
 static int synaptics_init_panel(struct synaptics_ts_data *ts)
 {
 	int ret;
 
-	ret = i2c_smbus_write_byte_data(ts->client, 0xff, 0x10); /* page select = 0x10 */
+	/* page select = 0x10 */
+	ret = i2c_smbus_write_byte_data(ts->client, 0xff, 0x10);
 	if (ret < 0) {
-		printk(KERN_ERR "i2c_smbus_write_byte_data failed for page select\n");
+		printk(KERN_ERR "smbus write failed for page select\n");
 		goto err_page_select_failed;
 	}
-	ret = i2c_smbus_write_byte_data(ts->client, 0x41, 0x04); /* Set "No Clip Z" */
+
+	/* Set "No Clip Z" */
+	ret = i2c_smbus_write_byte_data(ts->client, 0x41, 0x04);
 	if (ret < 0)
-		printk(KERN_ERR "i2c_smbus_write_byte_data failed for No Clip Z\n");
+		printk(KERN_ERR "smbus write failed for No Clip Z\n");
 
 err_page_select_failed:
-	ret = i2c_smbus_write_byte_data(ts->client, 0xff, 0x04); /* page select = 0x04 */
+	/* page select = 0x04 */
+	ret = i2c_smbus_write_byte_data(ts->client, 0xff, 0x04);
 	if (ret < 0)
-		printk(KERN_ERR "i2c_smbus_write_byte_data failed for page select\n");
-	ret = i2c_smbus_write_byte_data(ts->client, 0xf0, 0x81); /* normal operation, 80 reports per second */
+		printk(KERN_ERR "smbus write failed for page select\n");
+	/* normal operation, 80 reports per second */
+	ret = i2c_smbus_write_byte_data(ts->client, 0xf0, 0x81);
 	if (ret < 0)
-		printk(KERN_ERR "synaptics_ts_resume: i2c_smbus_write_byte_data failed\n");
+		printk(KERN_ERR "smbus write failed for 80/second\n");
 	return ret;
 }
 
@@ -82,9 +79,10 @@ static void synaptics_ts_work_func(struct work_struct *work)
 	int ret;
 	int bad_data = 0;
 	struct i2c_msg msg[2];
-	uint8_t start_reg;
-	uint8_t buf[15];
-	struct synaptics_ts_data *ts = container_of(work, struct synaptics_ts_data, work);
+	u8 start_reg;
+	u8 buf[15];
+	struct synaptics_ts_data *ts = \
+		container_of(work, struct synaptics_ts_data, work);
 
 	msg[0].addr = ts->client->addr;
 	msg[0].flags = 0;
@@ -96,19 +94,12 @@ static void synaptics_ts_work_func(struct work_struct *work)
 	msg[1].len = sizeof(buf);
 	msg[1].buf = buf;
 
-	/* printk("synaptics_ts_work_func\n"); */
 	for (i = 0; i < ((ts->use_irq && !bad_data) ? 1 : 10); i++) {
 		ret = i2c_transfer(ts->client->adapter, msg, 2);
 		if (ret < 0) {
 			printk(KERN_ERR "synaptics_ts_work_func: i2c_transfer failed\n");
 			bad_data = 1;
 		} else {
-			/* printk("synaptics_ts_work_func: %x %x %x %x %x %x" */
-			/*        " %x %x %x %x %x %x %x %x %x, ret %d\n", */
-			/*        buf[0], buf[1], buf[2], buf[3], */
-			/*        buf[4], buf[5], buf[6], buf[7], */
-			/*        buf[8], buf[9], buf[10], buf[11], */
-			/*        buf[12], buf[13], buf[14], ret); */
 			if ((buf[14] & 0xc0) != 0x40) {
 				printk(KERN_WARNING "synaptics_ts_work_func:"
 				       " bad read %x %x %x %x %x %x %x %x %x"
@@ -130,33 +121,17 @@ static void synaptics_ts_work_func(struct work_struct *work)
 				int pos[2][2];
 				int f, a;
 				int base;
-				/* int x = buf[3] | (uint16_t)(buf[2] & 0x1f) << 8; */
-				/* int y = buf[5] | (uint16_t)(buf[4] & 0x1f) << 8; */
 				int z = buf[1];
 				int w = buf[0] >> 4;
 				int finger = buf[0] & 7;
-
-				/* int x2 = buf[3+6] | (uint16_t)(buf[2+6] & 0x1f) << 8; */
-				/* int y2 = buf[5+6] | (uint16_t)(buf[4+6] & 0x1f) << 8; */
-				/* int z2 = buf[1+6]; */
-				/* int w2 = buf[0+6] >> 4; */
-				/* int finger2 = buf[0+6] & 7; */
-
-				/* int dx = (int8_t)buf[12]; */
-				/* int dy = (int8_t)buf[13]; */
 				int finger2_pressed;
 
-				/* printk("x %4d, y %4d, z %3d, w %2d, F %d, 2nd: x %4d, y %4d, z %3d, w %2d, F %d, dx %4d, dy %4d\n", */
-				/*	x, y, z, w, finger, */
-				/*	x2, y2, z2, w2, finger2, */
-				/*	dx, dy); */
-
 				base = 2;
 				for (f = 0; f < 2; f++) {
-					uint32_t flip_flag = SYNAPTICS_FLIP_X;
+					u32 flip_flag = SYNAPTICS_FLIP_X;
 					for (a = 0; a < 2; a++) {
 						int p = buf[base + 1];
-						p |= (uint16_t)(buf[base] & 0x1f) << 8;
+						p |= (u16)(buf[base] & 0x1f) << 8;
 						if (ts->flags & flip_flag)
 							p = ts->max[a] - p;
 						if (ts->flags & SYNAPTICS_SNAP_TO_INACTIVE_EDGE) {
@@ -209,7 +184,6 @@ static void synaptics_ts_work_func(struct work_struct *work)
 static enum hrtimer_restart synaptics_ts_timer_func(struct hrtimer *timer)
 {
 	struct synaptics_ts_data *ts = container_of(timer, struct synaptics_ts_data, timer);
-	/* printk("synaptics_ts_timer_func\n"); */
 
 	queue_work(synaptics_wq, &ts->work);
 
@@ -221,7 +195,6 @@ static irqreturn_t synaptics_ts_irq_handler(int irq, void *dev_id)
 {
 	struct synaptics_ts_data *ts = dev_id;
 
-	/* printk("synaptics_ts_irq_handler\n"); */
 	disable_irq(ts->client->irq);
 	queue_work(synaptics_wq, &ts->work);
 	return IRQ_HANDLED;
@@ -231,11 +204,11 @@ static int synaptics_ts_probe(
 	struct i2c_client *client, const struct i2c_device_id *id)
 {
 	struct synaptics_ts_data *ts;
-	uint8_t buf0[4];
-	uint8_t buf1[8];
+	u8 buf0[4];
+	u8 buf1[8];
 	struct i2c_msg msg[2];
 	int ret = 0;
-	uint16_t max_x, max_y;
+	u16 max_x, max_y;
 	int fuzz_x, fuzz_y, fuzz_p, fuzz_w;
 	struct synaptics_i2c_rmi_platform_data *pdata;
 	int inactive_area_left;
@@ -250,7 +223,7 @@ static int synaptics_ts_probe(
 	int snap_top_off;
 	int snap_bottom_on;
 	int snap_bottom_off;
-	uint32_t panel_version;
+	u32 panel_version;
 
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
 		printk(KERN_ERR "synaptics_ts_probe: need I2C_FUNC_I2C\n");
@@ -466,7 +439,7 @@ static int synaptics_ts_probe(
 	input_set_abs_params(ts->input_dev, ABS_TOOL_WIDTH, 0, 15, fuzz_w, 0);
 	input_set_abs_params(ts->input_dev, ABS_HAT0X, -inactive_area_left, max_x + inactive_area_right, fuzz_x, 0);
 	input_set_abs_params(ts->input_dev, ABS_HAT0Y, -inactive_area_top, max_y + inactive_area_bottom, fuzz_y, 0);
-	/* ts->input_dev->name = ts->keypad_info->name; */
+
 	ret = input_register_device(ts->input_dev);
 	if (ret) {
 		printk(KERN_ERR "synaptics_ts_probe: Unable to register %s input device\n", ts->input_dev->name);
@@ -489,12 +462,6 @@ static int synaptics_ts_probe(
 		ts->timer.function = synaptics_ts_timer_func;
 		hrtimer_start(&ts->timer, ktime_set(1, 0), HRTIMER_MODE_REL);
 	}
-#ifdef CONFIG_HAS_EARLYSUSPEND
-	ts->early_suspend.level = EARLY_SUSPEND_LEVEL_BLANK_SCREEN + 1;
-	ts->early_suspend.suspend = synaptics_ts_early_suspend;
-	ts->early_suspend.resume = synaptics_ts_late_resume;
-	register_early_suspend(&ts->early_suspend);
-#endif
 
 	printk(KERN_INFO "synaptics_ts_probe: Start touchscreen %s in %s mode\n", ts->input_dev->name, ts->use_irq ? "interrupt" : "polling");
 
@@ -515,7 +482,7 @@ err_check_functionality_failed:
 static int synaptics_ts_remove(struct i2c_client *client)
 {
 	struct synaptics_ts_data *ts = i2c_get_clientdata(client);
-	unregister_early_suspend(&ts->early_suspend);
+
 	if (ts->use_irq)
 		free_irq(client->irq, ts);
 	else
@@ -525,72 +492,6 @@ static int synaptics_ts_remove(struct i2c_client *client)
 	return 0;
 }
 
-static int synaptics_ts_suspend(struct i2c_client *client, pm_message_t mesg)
-{
-	int ret;
-	struct synaptics_ts_data *ts = i2c_get_clientdata(client);
-
-	if (ts->use_irq)
-		disable_irq(client->irq);
-	else
-		hrtimer_cancel(&ts->timer);
-	ret = cancel_work_sync(&ts->work);
-	if (ret && ts->use_irq) /* if work was pending disable-count is now 2 */
-		enable_irq(client->irq);
-	ret = i2c_smbus_write_byte_data(ts->client, 0xf1, 0); /* disable interrupt */
-	if (ret < 0)
-		printk(KERN_ERR "synaptics_ts_suspend: i2c_smbus_write_byte_data failed\n");
-
-	ret = i2c_smbus_write_byte_data(client, 0xf0, 0x86); /* deep sleep */
-	if (ret < 0)
-		printk(KERN_ERR "synaptics_ts_suspend: i2c_smbus_write_byte_data failed\n");
-	if (ts->power) {
-		ret = ts->power(0);
-		if (ret < 0)
-			printk(KERN_ERR "synaptics_ts_resume power off failed\n");
-	}
-	return 0;
-}
-
-static int synaptics_ts_resume(struct i2c_client *client)
-{
-	int ret;
-	struct synaptics_ts_data *ts = i2c_get_clientdata(client);
-
-	if (ts->power) {
-		ret = ts->power(1);
-		if (ret < 0)
-			printk(KERN_ERR "synaptics_ts_resume power on failed\n");
-	}
-
-	synaptics_init_panel(ts);
-
-	if (ts->use_irq)
-		enable_irq(client->irq);
-
-	if (!ts->use_irq)
-		hrtimer_start(&ts->timer, ktime_set(1, 0), HRTIMER_MODE_REL);
-	else
-		i2c_smbus_write_byte_data(ts->client, 0xf1, 0x01); /* enable abs int */
-
-	return 0;
-}
-
-#ifdef CONFIG_HAS_EARLYSUSPEND
-static void synaptics_ts_early_suspend(struct early_suspend *h)
-{
-	struct synaptics_ts_data *ts;
-	ts = container_of(h, struct synaptics_ts_data, early_suspend);
-	synaptics_ts_suspend(ts->client, PMSG_SUSPEND);
-}
-
-static void synaptics_ts_late_resume(struct early_suspend *h)
-{
-	struct synaptics_ts_data *ts;
-	ts = container_of(h, struct synaptics_ts_data, early_suspend);
-	synaptics_ts_resume(ts->client);
-}
-#endif
 
 static const struct i2c_device_id synaptics_ts_id[] = {
 	{ SYNAPTICS_I2C_RMI_NAME, 0 },
@@ -600,10 +501,6 @@ static const struct i2c_device_id synaptics_ts_id[] = {
 static struct i2c_driver synaptics_ts_driver = {
 	.probe		= synaptics_ts_probe,
 	.remove		= synaptics_ts_remove,
-#ifndef CONFIG_HAS_EARLYSUSPEND
-	.suspend	= synaptics_ts_suspend,
-	.resume		= synaptics_ts_resume,
-#endif
 	.id_table	= synaptics_ts_id,
 	.driver = {
 		.name	= SYNAPTICS_I2C_RMI_NAME,

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
