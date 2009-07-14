Return-Path: <linux-kernel-owner+w=401wt.eu-S1754553AbZGNKGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553AbZGNKGv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 06:06:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754487AbZGNKGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 06:06:50 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44498 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529AbZGNKGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 06:06:47 -0400
Date: Tue, 14 Jul 2009 12:06:34 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Brian Swetland <swetland@google.com>, dmitry.torokhov@gmail.com,
       dtor@mail.ru, linux-input@vger.kernel.org
Cc: Andrew Morton <akpm@osdl.org>
Subject: Support for synaptic touchscreen in HTC dream
Message-ID: <20090714100634.GA4054@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arve Hj?nnev?g <arve@android.com>

This adds support for synaptic touchscreen, used in HTC dream
cellphone.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index bb6486a..fa3404f 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -206,6 +213,14 @@ config TOUCHSCREEN_MIGOR
 	  To compile this driver as a module, choose M here: the
 	  module will be called migor_ts.
 
+config TOUCHSCREEN_SYNAPTICS_I2C_RMI
+	tristate "Synaptics i2c touchscreen"
+	depends on I2C
+	help
+	  This enables support for Synaptics RMI over I2C based touchscreens.
+	  Such touchscreen is used in HTC Dream.
+
+
 config TOUCHSCREEN_TOUCHRIGHT
 	tristate "Touchright serial touchscreen"
 	select SERIO
diff --git a/drivers/input/touchscreen/Makefile b/drivers/input/touchscreen/Makefile
index d3375af..959dcda 100644
--- a/drivers/input/touchscreen/Makefile
+++ b/drivers/input/touchscreen/Makefile
@@ -22,6 +23,7 @@ obj-$(CONFIG_TOUCHSCREEN_HP7XX)		+= jornada720_ts.o
 obj-$(CONFIG_TOUCHSCREEN_HTCPEN)	+= htcpen.o
 obj-$(CONFIG_TOUCHSCREEN_USB_COMPOSITE)	+= usbtouchscreen.o
 obj-$(CONFIG_TOUCHSCREEN_PENMOUNT)	+= penmount.o
+obj-$(CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI)	+= synaptics_i2c_rmi.o
 obj-$(CONFIG_TOUCHSCREEN_TOUCHIT213)	+= touchit213.o
 obj-$(CONFIG_TOUCHSCREEN_TOUCHRIGHT)	+= touchright.o
 obj-$(CONFIG_TOUCHSCREEN_TOUCHWIN)	+= touchwin.o
diff --git a/drivers/input/touchscreen/synaptics_i2c_rmi.c b/drivers/input/touchscreen/synaptics_i2c_rmi.c
new file mode 100644
index 0000000..fe10e85
--- /dev/null
+++ b/drivers/input/touchscreen/synaptics_i2c_rmi.c
@@ -0,0 +1,587 @@
+/*
+ * Support for synaptics touchscreen.
+ *
+ * Copyright (C) 2007 Google, Inc.
+ * Author: Arve Hj?nnev?g <arve@android.com>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/delay.h>
+#include <linux/hrtimer.h>
+#include <linux/i2c.h>
+#include <linux/input.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/platform_device.h>
+#include <linux/synaptics_i2c_rmi.h>
+
+static struct workqueue_struct *synaptics_wq;
+
+struct synaptics_ts_data {
+	u16 addr;
+	struct i2c_client *client;
+	struct input_dev *input_dev;
+	int use_irq;
+	struct hrtimer timer;
+	struct work_struct  work;
+	u16 max[2];
+	int snap_state[2][2];
+	int snap_down_on[2];
+	int snap_down_off[2];
+	int snap_up_on[2];
+	int snap_up_off[2];
+	int snap_down[2];
+	int snap_up[2];
+	u32 flags;
+	int (*power)(int on);
+};
+
+static int i2c_set(struct synaptics_ts_data *ts, u8 reg, u8 val, char *msg)
+{
+	int ret = i2c_smbus_write_byte_data(ts->client, reg, val);
+	if (ret < 0)
+		pr_err("i2c_smbus_write_byte_data failed (%s)\n", msg);
+	return ret;
+}
+
+static int i2c_read(struct synaptics_ts_data *ts, u8 reg, char *msg)
+{
+	int ret = i2c_smbus_read_byte_data(ts->client, 0xf0);
+	if (ret < 0)
+		pr_err("i2c_smbus_read_byte_data failed (%s)\n", msg);
+	return ret;
+}
+
+static int synaptics_init_panel(struct synaptics_ts_data *ts)
+{
+	int ret;
+
+	ret = i2c_set(ts, 0xff, 0x10, "set page select");
+	if (ret == 0)
+		ret = i2c_set(ts, 0x41, 0x04, "set No Clip Z");
+
+	ret = i2c_set(ts, 0xff, 0x04, "fallback page select");
+	ret = i2c_set(ts, 0xf0, 0x81, "select 80 reports per second");
+	return ret;
+}
+
+static void decode_report(struct synaptics_ts_data *ts, u8 *buf)
+{
+	int pos[2][2];
+	int f, a;
+	int base = 2;
+	int z = buf[1];
+	int w = buf[0] >> 4;
+	int finger = buf[0] & 7;
+	int finger2_pressed;
+
+	for (f = 0; f < 2; f++) {
+		u32 flip_flag = SYNAPTICS_FLIP_X;
+		for (a = 0; a < 2; a++) {
+			int p = buf[base + 1];
+			p |= (u16)(buf[base] & 0x1f) << 8;
+			if (ts->flags & flip_flag)
+				p = ts->max[a] - p;
+			if (ts->flags & SYNAPTICS_SNAP_TO_INACTIVE_EDGE) {
+				if (ts->snap_state[f][a]) {
+					if (p <= ts->snap_down_off[a])
+						p = ts->snap_down[a];
+					else if (p >= ts->snap_up_off[a])
+						p = ts->snap_up[a];
+					else
+						ts->snap_state[f][a] = 0;
+				} else {
+					if (p <= ts->snap_down_on[a]) {
+						p = ts->snap_down[a];
+						ts->snap_state[f][a] = 1;
+					} else if (p >= ts->snap_up_on[a]) {
+						p = ts->snap_up[a];
+						ts->snap_state[f][a] = 1;
+					}
+				}
+			}
+			pos[f][a] = p;
+			base += 2;
+			flip_flag <<= 1;
+		}
+		base += 2;
+		if (ts->flags & SYNAPTICS_SWAP_XY)
+			swap(pos[f][0], pos[f][1]);
+	}
+	if (z) {
+		input_report_abs(ts->input_dev, ABS_X, pos[0][0]);
+		input_report_abs(ts->input_dev, ABS_Y, pos[0][1]);
+	}
+	input_report_abs(ts->input_dev, ABS_PRESSURE, z);
+	input_report_abs(ts->input_dev, ABS_TOOL_WIDTH, w);
+	input_report_key(ts->input_dev, BTN_TOUCH, finger);
+	finger2_pressed = finger > 1 && finger != 7;
+	input_report_key(ts->input_dev, BTN_2, finger2_pressed);
+	if (finger2_pressed) {
+		input_report_abs(ts->input_dev, ABS_HAT0X, pos[1][0]);
+		input_report_abs(ts->input_dev, ABS_HAT0Y, pos[1][1]);
+	}
+	input_sync(ts->input_dev);
+}
+
+static void synaptics_ts_work_func(struct work_struct *work)
+{
+	int i;
+	int ret;
+	int bad_data = 0;
+	struct i2c_msg msg[2];
+	u8 start_reg = 0;
+	u8 buf[15];
+	struct synaptics_ts_data *ts =
+		container_of(work, struct synaptics_ts_data, work);
+
+	msg[0].addr = ts->client->addr;
+	msg[0].flags = 0;
+	msg[0].len = 1;
+	msg[0].buf = &start_reg;
+	msg[1].addr = ts->client->addr;
+	msg[1].flags = I2C_M_RD;
+	msg[1].len = sizeof(buf);
+	msg[1].buf = buf;
+
+	for (i = 0; i < ((ts->use_irq && !bad_data) ? 1 : 10); i++) {
+		ret = i2c_transfer(ts->client->adapter, msg, 2);
+		if (ret < 0) {
+			printk(KERN_ERR "ts_work: i2c_transfer failed\n");
+			bad_data = 1;
+			continue;
+		}
+		if ((buf[14] & 0xc0) != 0x40) {
+			printk(KERN_WARNING "synaptics_ts_work_func:"
+			       " bad read %x %x %x %x %x %x %x %x %x"
+			       " %x %x %x %x %x %x, ret %d\n",
+			       buf[0], buf[1], buf[2], buf[3],
+			       buf[4], buf[5], buf[6], buf[7],
+			       buf[8], buf[9], buf[10], buf[11],
+			       buf[12], buf[13], buf[14], ret);
+			if (bad_data)
+				synaptics_init_panel(ts);
+			bad_data = 1;
+			continue;
+		}
+		bad_data = 0;
+		if ((buf[14] & 1) == 0)
+			break;
+
+		decode_report(ts, buf);
+	}
+	if (ts->use_irq)
+		enable_irq(ts->client->irq);
+}
+
+static enum hrtimer_restart synaptics_ts_timer_func(struct hrtimer *timer)
+{
+	struct synaptics_ts_data *ts =
+		container_of(timer, struct synaptics_ts_data, timer);
+
+	queue_work(synaptics_wq, &ts->work);
+
+	hrtimer_start(&ts->timer, ktime_set(0, 12500000), HRTIMER_MODE_REL);
+	return HRTIMER_NORESTART;
+}
+
+static irqreturn_t synaptics_ts_irq_handler(int irq, void *dev_id)
+{
+	struct synaptics_ts_data *ts = dev_id;
+
+	disable_irq(ts->client->irq);
+	queue_work(synaptics_wq, &ts->work);
+	return IRQ_HANDLED;
+}
+
+static int detect(struct synaptics_ts_data *ts, u32 *panel_version)
+{
+	int ret;
+	int retry = 10;
+
+	ret = i2c_set(ts, 0xf4, 0x01, "reset device");
+
+	while (retry-- > 0) {
+		ret = i2c_smbus_read_byte_data(ts->client, 0xe4);
+		if (ret >= 0)
+			break;
+		msleep(100);
+	}
+	if (ret < 0) {
+		pr_err("i2c_smbus_read_byte_data failed\n");
+		return ret;
+	}
+
+	*panel_version = ret << 8;
+	ret = i2c_read(ts, 0xe5, "product minor");
+	if (ret < 0)
+		return ret;
+	*panel_version |= ret;
+
+	ret = i2c_read(ts, 0xe3, "property");
+	if (ret < 0)
+		return ret;
+
+	pr_info("synaptics: version %x, product property %x\n", 
+		*panel_version, ret);
+	return 0;
+}
+
+static void compute_areas(struct synaptics_ts_data *ts,	
+			  struct synaptics_i2c_rmi_platform_data *pdata,
+			  u16 max_x, u16 max_y)
+{
+	u32 inactive_area_left;
+	u32 inactive_area_right;
+	u32 inactive_area_top;
+	u32 inactive_area_bottom;
+	u32 snap_left_on;
+	u32 snap_left_off;
+	u32 snap_right_on;
+	u32 snap_right_off;
+	u32 snap_top_on;
+	u32 snap_top_off;
+	u32 snap_bottom_on;
+	u32 snap_bottom_off;
+	u32 fuzz_x;
+	u32 fuzz_y;
+	int fuzz_p;
+	int fuzz_w;
+	int swapped = !!(ts->flags & SYNAPTICS_SWAP_XY);
+
+	inactive_area_left = pdata->inactive_left;
+	inactive_area_right = pdata->inactive_right;
+	inactive_area_top = pdata->inactive_top;
+	inactive_area_bottom = pdata->inactive_bottom;
+	snap_left_on = pdata->snap_left_on;
+	snap_left_off = pdata->snap_left_off;
+	snap_right_on = pdata->snap_right_on;
+	snap_right_off = pdata->snap_right_off;
+	snap_top_on = pdata->snap_top_on;
+	snap_top_off = pdata->snap_top_off;
+	snap_bottom_on = pdata->snap_bottom_on;
+	snap_bottom_off = pdata->snap_bottom_off;
+	fuzz_x = pdata->fuzz_x;
+	fuzz_y = pdata->fuzz_y;
+	fuzz_p = pdata->fuzz_p;
+	fuzz_w = pdata->fuzz_w;
+
+	inactive_area_left = inactive_area_left * max_x / 0x10000;
+	inactive_area_right = inactive_area_right * max_x / 0x10000;
+	inactive_area_top = inactive_area_top * max_y / 0x10000;
+	inactive_area_bottom = inactive_area_bottom * max_y / 0x10000;
+	snap_left_on = snap_left_on * max_x / 0x10000;
+	snap_left_off = snap_left_off * max_x / 0x10000;
+	snap_right_on = snap_right_on * max_x / 0x10000;
+	snap_right_off = snap_right_off * max_x / 0x10000;
+	snap_top_on = snap_top_on * max_y / 0x10000;
+	snap_top_off = snap_top_off * max_y / 0x10000;
+	snap_bottom_on = snap_bottom_on * max_y / 0x10000;
+	snap_bottom_off = snap_bottom_off * max_y / 0x10000;
+	fuzz_x = fuzz_x * max_x / 0x10000;
+	fuzz_y = fuzz_y * max_y / 0x10000;
+
+
+	ts->snap_down[swapped] = -inactive_area_left;
+	ts->snap_up[swapped] = max_x + inactive_area_right;
+	ts->snap_down[!swapped] = -inactive_area_top;
+	ts->snap_up[!swapped] = max_y + inactive_area_bottom;
+	ts->snap_down_on[swapped] = snap_left_on;
+	ts->snap_down_off[swapped] = snap_left_off;
+	ts->snap_up_on[swapped] = max_x - snap_right_on;
+	ts->snap_up_off[swapped] = max_x - snap_right_off;
+	ts->snap_down_on[!swapped] = snap_top_on;
+	ts->snap_down_off[!swapped] = snap_top_off;
+	ts->snap_up_on[!swapped] = max_y - snap_bottom_on;
+	ts->snap_up_off[!swapped] = max_y - snap_bottom_off;
+	pr_info("synaptics_ts_probe: max_x %d, max_y %d\n", max_x, max_y);
+	pr_info("synaptics_ts_probe: inactive_x %d %d, inactive_y %d %d\n",
+	       inactive_area_left, inactive_area_right,
+	       inactive_area_top, inactive_area_bottom);
+	pr_info("synaptics_ts_probe: snap_x %d-%d %d-%d, snap_y %d-%d %d-%d\n",
+	       snap_left_on, snap_left_off, snap_right_on, snap_right_off,
+	       snap_top_on, snap_top_off, snap_bottom_on, snap_bottom_off);
+
+	input_set_abs_params(ts->input_dev, ABS_X,
+			     -inactive_area_left, max_x + inactive_area_right, 
+			     fuzz_x, 0);
+	input_set_abs_params(ts->input_dev, ABS_Y,
+			     -inactive_area_top, max_y + inactive_area_bottom,
+			     fuzz_y, 0);
+	input_set_abs_params(ts->input_dev, ABS_PRESSURE, 0, 255, fuzz_p, 0);
+	input_set_abs_params(ts->input_dev, ABS_TOOL_WIDTH, 0, 15, fuzz_w, 0);
+	input_set_abs_params(ts->input_dev, ABS_HAT0X, -inactive_area_left,
+			     max_x + inactive_area_right, fuzz_x, 0);
+	input_set_abs_params(ts->input_dev, ABS_HAT0Y, -inactive_area_top,
+			     max_y + inactive_area_bottom, fuzz_y, 0);
+}
+
+static int synaptics_ts_probe(
+	struct i2c_client *client, const struct i2c_device_id *id)
+{
+	struct synaptics_ts_data *ts;
+	u8 buf0[4];
+	u8 buf1[8];
+	struct i2c_msg msg[2];
+	int ret = 0;
+	struct synaptics_i2c_rmi_platform_data *pdata;
+	u32 panel_version = 0;
+	u16 max_x, max_y;
+
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
+		printk(KERN_ERR "synaptics_ts_probe: need I2C_FUNC_I2C\n");
+		ret = -ENODEV;
+		goto err_check_functionality_failed;
+	}
+
+	ts = kzalloc(sizeof(*ts), GFP_KERNEL);
+	if (ts == NULL) {
+		ret = -ENOMEM;
+		goto err_alloc_data_failed;
+	}
+	INIT_WORK(&ts->work, synaptics_ts_work_func);
+	ts->client = client;
+	i2c_set_clientdata(client, ts);
+	pdata = client->dev.platform_data;
+	if (pdata)
+		ts->power = pdata->power;
+	else
+		pdata = kzalloc(sizeof(*pdata), GFP_KERNEL);
+
+	if (ts->power) {
+		ret = ts->power(1);
+		if (ret < 0) {
+			printk(KERN_ERR "synaptics_ts_probe power on failed\n");
+			goto err_power_failed;
+		}
+	}
+
+	ret = detect(ts, &panel_version);
+	if (ret)
+		goto err_detect_failed;
+
+	while (pdata->version > panel_version)
+		pdata++;
+	ts->flags = pdata->flags;
+
+	ret = i2c_read(ts, 0xf0, "device control");
+	if (ret < 0)
+		goto err_detect_failed;
+	pr_info("synaptics: device control %x\n", ret);
+
+	ret = i2c_read(ts, 0xf1, "interrupt enable");
+	if (ret < 0)
+		goto err_detect_failed;
+	pr_info("synaptics_ts_probe: interrupt enable %x\n", ret);
+
+	ret = i2c_set(ts, 0xf1, 0, "disable interrupt");
+	if (ret < 0)
+		goto err_detect_failed;
+
+	msg[0].addr = ts->client->addr;
+	msg[0].flags = 0;
+	msg[0].len = 1;
+	msg[0].buf = buf0;
+	buf0[0] = 0xe0;
+	msg[1].addr = ts->client->addr;
+	msg[1].flags = I2C_M_RD;
+	msg[1].len = 8;
+	msg[1].buf = buf1;
+	ret = i2c_transfer(ts->client->adapter, msg, 2);
+	if (ret < 0) {
+		printk(KERN_ERR "i2c_transfer failed\n");
+		goto err_detect_failed;
+	}
+	printk(KERN_INFO "synaptics_ts_probe: 0xe0: %x %x %x %x %x %x %x %x\n",
+	       buf1[0], buf1[1], buf1[2], buf1[3],
+	       buf1[4], buf1[5], buf1[6], buf1[7]);
+
+	ret = i2c_set(ts, 0xff, 0x10, "page select = 0x10");
+	if (ret < 0)
+		goto err_detect_failed;
+
+	ret = i2c_smbus_read_word_data(ts->client, 0x04);
+	if (ret < 0) {
+		printk(KERN_ERR "i2c_smbus_read_word_data failed\n");
+		goto err_detect_failed;
+	}
+	ts->max[0] = max_x = (ret >> 8 & 0xff) | ((ret & 0x1f) << 8);
+	ret = i2c_smbus_read_word_data(ts->client, 0x06);
+	if (ret < 0) {
+		printk(KERN_ERR "i2c_smbus_read_word_data failed\n");
+		goto err_detect_failed;
+	}
+	ts->max[1] = max_y = (ret >> 8 & 0xff) | ((ret & 0x1f) << 8);
+	if (ts->flags & SYNAPTICS_SWAP_XY)
+		swap(max_x, max_y);
+
+	/* will also switch back to page 0x04 */
+	ret = synaptics_init_panel(ts);
+	if (ret < 0) {
+		pr_err("synaptics_init_panel failed\n");
+		goto err_detect_failed;
+	}
+
+	ts->input_dev = input_allocate_device();
+	if (ts->input_dev == NULL) {
+		ret = -ENOMEM;
+		pr_err("synaptics: Failed to allocate input device\n");
+		goto err_input_dev_alloc_failed;
+	}
+	ts->input_dev->name = "synaptics-rmi-touchscreen";
+	set_bit(EV_SYN, ts->input_dev->evbit);
+	set_bit(EV_KEY, ts->input_dev->evbit);
+	set_bit(BTN_TOUCH, ts->input_dev->keybit);
+	set_bit(BTN_2, ts->input_dev->keybit);
+	set_bit(EV_ABS, ts->input_dev->evbit);
+
+	compute_areas(ts, pdata, max_x, max_y);
+
+
+	ret = input_register_device(ts->input_dev);
+	if (ret) {
+		pr_err("synaptics: Unable to register %s input device\n", 
+		       ts->input_dev->name);
+		goto err_input_register_device_failed;
+	}
+	if (client->irq) {
+		ret = request_irq(client->irq, synaptics_ts_irq_handler,
+				  0, client->name, ts);
+		if (ret == 0) {
+			ret = i2c_set(ts, 0xf1, 0x01, "enable abs int");
+			if (ret)
+				free_irq(client->irq, ts);
+		}
+		if (ret == 0)
+			ts->use_irq = 1;
+		else
+			dev_err(&client->dev, "request_irq failed\n");
+	}
+	if (!ts->use_irq) {
+		hrtimer_init(&ts->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+		ts->timer.function = synaptics_ts_timer_func;
+		hrtimer_start(&ts->timer, ktime_set(1, 0), HRTIMER_MODE_REL);
+	}
+
+	pr_info("synaptics: Start touchscreen %s in %s mode\n", 
+		ts->input_dev->name, ts->use_irq ? "interrupt" : "polling");
+
+	return 0;
+
+ err_input_register_device_failed:
+	input_free_device(ts->input_dev);
+
+ err_input_dev_alloc_failed:
+ err_detect_failed:
+ err_power_failed:
+	kfree(ts);
+ err_alloc_data_failed:
+ err_check_functionality_failed:
+	return ret;
+}
+
+static int synaptics_ts_remove(struct i2c_client *client)
+{
+	struct synaptics_ts_data *ts = i2c_get_clientdata(client);
+
+	if (ts->use_irq)
+		free_irq(client->irq, ts);
+	else
+		hrtimer_cancel(&ts->timer);
+	input_unregister_device(ts->input_dev);
+	kfree(ts);
+	return 0;
+}
+
+static int synaptics_ts_suspend(struct i2c_client *client, pm_message_t mesg)
+{
+	int ret;
+	struct synaptics_ts_data *ts = i2c_get_clientdata(client);
+
+	if (ts->use_irq)
+		disable_irq(client->irq);
+	else
+		hrtimer_cancel(&ts->timer);
+	ret = cancel_work_sync(&ts->work);
+	if (ret && ts->use_irq) /* if work was pending disable-count is now 2 */
+		enable_irq(client->irq);
+	i2c_set(ts, 0xf1, 0, "disable interrupt");
+	i2c_set(ts, 0xf0, 0x86, "deep sleep");
+
+	if (ts->power) {
+		ret = ts->power(0);
+		if (ret < 0)
+			pr_err("synaptics_ts_suspend power off failed\n");
+	}
+	return 0;
+}
+
+static int synaptics_ts_resume(struct i2c_client *client)
+{
+	int ret;
+	struct synaptics_ts_data *ts = i2c_get_clientdata(client);
+
+	if (ts->power) {
+		ret = ts->power(1);
+		if (ret < 0)
+			pr_err("synaptics_ts_resume power on failed\n");
+	}
+
+	synaptics_init_panel(ts);
+
+	if (ts->use_irq) {
+		enable_irq(client->irq);
+		i2c_set(ts, 0xf1, 0x01, "enable abs int");
+	} else
+		hrtimer_start(&ts->timer, ktime_set(1, 0), HRTIMER_MODE_REL);
+
+	return 0;
+}
+
+
+static const struct i2c_device_id synaptics_ts_id[] = {
+	{ SYNAPTICS_I2C_RMI_NAME, 0 },
+	{ }
+};
+
+static struct i2c_driver synaptics_ts_driver = {
+	.probe		= synaptics_ts_probe,
+	.remove		= synaptics_ts_remove,
+	.suspend	= synaptics_ts_suspend,
+	.resume		= synaptics_ts_resume,
+	.id_table	= synaptics_ts_id,
+	.driver = {
+		.name	= SYNAPTICS_I2C_RMI_NAME,
+	},
+};
+
+static int __devinit synaptics_ts_init(void)
+{
+	synaptics_wq = create_singlethread_workqueue("synaptics_wq");
+	if (!synaptics_wq)
+		return -ENOMEM;
+	return i2c_add_driver(&synaptics_ts_driver);
+}
+
+static void __exit synaptics_ts_exit(void)
+{
+	i2c_del_driver(&synaptics_ts_driver);
+	if (synaptics_wq)
+		destroy_workqueue(synaptics_wq);
+}
+
+module_init(synaptics_ts_init);
+module_exit(synaptics_ts_exit);
+
+MODULE_DESCRIPTION("Synaptics Touchscreen Driver");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/synaptics_i2c_rmi.h b/include/linux/synaptics_i2c_rmi.h
new file mode 100644
index 0000000..73e1de7
--- /dev/null
+++ b/include/linux/synaptics_i2c_rmi.h
@@ -0,0 +1,53 @@
+/*
+ * synaptics_i2c_rmi.h - platform data structure for f75375s sensor
+ *
+ * Copyright (C) 2008 Google, Inc.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef _LINUX_SYNAPTICS_I2C_RMI_H
+#define _LINUX_SYNAPTICS_I2C_RMI_H
+
+#define SYNAPTICS_I2C_RMI_NAME "synaptics-rmi-ts"
+
+enum {
+	SYNAPTICS_FLIP_X = 1UL << 0,
+	SYNAPTICS_FLIP_Y = 1UL << 1,
+	SYNAPTICS_SWAP_XY = 1UL << 2,
+	SYNAPTICS_SNAP_TO_INACTIVE_EDGE = 1UL << 3,
+};
+
+struct synaptics_i2c_rmi_platform_data {
+	u32 version;	/* Use this entry for panels with */
+				/* (major << 8 | minor) version or above. */
+				/* If non-zero another array entry follows */
+	int (*power)(int on);	/* Only valid in first array entry */
+	u32 flags;
+	u32 inactive_left; /* 0x10000 = screen width */
+	u32 inactive_right; /* 0x10000 = screen width */
+	u32 inactive_top; /* 0x10000 = screen height */
+	u32 inactive_bottom; /* 0x10000 = screen height */
+	u32 snap_left_on; /* 0x10000 = screen width */
+	u32 snap_left_off; /* 0x10000 = screen width */
+	u32 snap_right_on; /* 0x10000 = screen width */
+	u32 snap_right_off; /* 0x10000 = screen width */
+	u32 snap_top_on; /* 0x10000 = screen height */
+	u32 snap_top_off; /* 0x10000 = screen height */
+	u32 snap_bottom_on; /* 0x10000 = screen height */
+	u32 snap_bottom_off; /* 0x10000 = screen height */
+	u32 fuzz_x; /* 0x10000 = screen width */
+	u32 fuzz_y; /* 0x10000 = screen height */
+	int fuzz_p;
+	int fuzz_w;
+};
+
+#endif /* _LINUX_SYNAPTICS_I2C_RMI_H */



-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
