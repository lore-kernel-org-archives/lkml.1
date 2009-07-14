Return-Path: <linux-kernel-owner+w=401wt.eu-S1752674AbZGNB34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674AbZGNB34 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 21:29:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752536AbZGNB3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 21:29:55 -0400
Received: from mail-qy0-f192.google.com ([209.85.221.192]:52414 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512AbZGNB3x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 21:29:53 -0400
MIME-Version: 1.0
In-Reply-To: <20090713220726.GA28375@elf.ucw.cz>
References: <20090710084323.GA6522@elf.ucw.cz>
	 <a55d774e0907100155m25366994pe9ec5d0f5f868818@mail.gmail.com>
	 <20090710103243.GB7789@elf.ucw.cz>
	 <a55d774e0907100431j3fdc4671i6b185019594367fa@mail.gmail.com>
	 <20090713202302.GC2569@elf.ucw.cz> <20090713205749.GE2569@elf.ucw.cz>
	 <20090713220726.GA28375@elf.ucw.cz>
Date: Mon, 13 Jul 2009 18:29:52 -0700
Message-ID: <d6200be20907131829o77bce3d8w8f238bc079478368@mail.gmail.com>
Subject: Re: HTC: touchscreen driver
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Brian Swetland <swetland@google.com>,
       kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 13, 2009 at 3:07 PM, Pavel Machek<pavel@ucw.cz> wrote:
> On Mon 2009-07-13 22:57:49, Pavel Machek wrote:
>> Hi!
>>
>> I'm looking at synaptic touchscreen driver... who should be listed as
>> an author?
>>
>> Changes I have so far are...
>>
>> checkpatch only has minor complains -- lines over 80 characters -- but
>> the code is _way_ too deeply nested with way too little functions.
>
> Here's better cleanup. But... some functions are still _way_ too big.
>
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
> index 339083e..fa3404f 100644
> --- a/drivers/input/touchscreen/Kconfig
> +++ b/drivers/input/touchscreen/Kconfig
> @@ -94,6 +94,9 @@ config TOUCHSCREEN_GUNZE
>  config TOUCHSCREEN_ELAN_I2C_8232
>        tristate "Elan 8232 I2C touchscreen"
>        depends on I2C
> +       help
> +         This enables support for Elan over I2C based touchscreens.
> +         Such touchscreen is used in HTC Dream.
>

Why is this here? This driver is not related to elan touchscreens.

>  config TOUCHSCREEN_ELO
>        tristate "Elo serial touchscreens"
> @@ -215,6 +218,8 @@ config TOUCHSCREEN_SYNAPTICS_I2C_RMI
>        depends on I2C
>        help
>          This enables support for Synaptics RMI over I2C based touchscreens.
> +         Such touchscreen is used in HTC Dream.
> +
>
>  config TOUCHSCREEN_TOUCHRIGHT
>        tristate "Touchright serial touchscreen"
> diff --git a/drivers/input/touchscreen/synaptics_i2c_rmi.c b/drivers/input/touchscreen/synaptics_i2c_rmi.c
> index a45634b..f582582 100644
> --- a/drivers/input/touchscreen/synaptics_i2c_rmi.c
> +++ b/drivers/input/touchscreen/synaptics_i2c_rmi.c
> @@ -1,4 +1,5 @@
> -/* drivers/input/keyboard/synaptics_i2c_rmi.c
> +/*
> + * Support for synaptics touchscreen.
>  *
>  * Copyright (C) 2007 Google, Inc.
>  *
> @@ -15,7 +16,6 @@
>
>  #include <linux/module.h>
>  #include <linux/delay.h>
> -#include <linux/earlysuspend.h>
>  #include <linux/hrtimer.h>
>  #include <linux/i2c.h>
>  #include <linux/input.h>
> @@ -24,18 +24,16 @@
>  #include <linux/platform_device.h>
>  #include <linux/synaptics_i2c_rmi.h>
>
> -#define swap(x, y) do { typeof(x) z = x; x = y; y = z; } while (0)
> -
>  static struct workqueue_struct *synaptics_wq;
>
>  struct synaptics_ts_data {
> -       uint16_t addr;
> +       u16 addr;

What is the point of this change?

>        struct i2c_client *client;
>        struct input_dev *input_dev;
>        int use_irq;
>        struct hrtimer timer;
>        struct work_struct  work;
> -       uint16_t max[2];
> +       u16 max[2];
>        int snap_state[2][2];
>        int snap_down_on[2];
>        int snap_down_off[2];
> @@ -43,164 +41,142 @@ struct synaptics_ts_data {
>        int snap_up_off[2];
>        int snap_down[2];
>        int snap_up[2];
> -       uint32_t flags;
> +       u32 flags;
>        int (*power)(int on);
> -       struct early_suspend early_suspend;
>  };
>
> -#ifdef CONFIG_HAS_EARLYSUSPEND
> -static void synaptics_ts_early_suspend(struct early_suspend *h);
> -static void synaptics_ts_late_resume(struct early_suspend *h);
> -#endif
> -
>  static int synaptics_init_panel(struct synaptics_ts_data *ts)
>  {
>        int ret;
>
> -       ret = i2c_smbus_write_byte_data(ts->client, 0xff, 0x10); /* page select = 0x10 */
> +       /* page select = 0x10 */
> +       ret = i2c_smbus_write_byte_data(ts->client, 0xff, 0x10);
>        if (ret < 0) {
> -               printk(KERN_ERR "i2c_smbus_write_byte_data failed for page select\n");
> +               printk(KERN_ERR "smbus write failed for page select\n");
>                goto err_page_select_failed;
>        }
> -       ret = i2c_smbus_write_byte_data(ts->client, 0x41, 0x04); /* Set "No Clip Z" */
> +
> +       /* Set "No Clip Z" */
> +       ret = i2c_smbus_write_byte_data(ts->client, 0x41, 0x04);
>        if (ret < 0)
> -               printk(KERN_ERR "i2c_smbus_write_byte_data failed for No Clip Z\n");
> +               printk(KERN_ERR "smbus write failed for No Clip Z\n");
>
>  err_page_select_failed:
> -       ret = i2c_smbus_write_byte_data(ts->client, 0xff, 0x04); /* page select = 0x04 */
> +       /* page select = 0x04 */
> +       ret = i2c_smbus_write_byte_data(ts->client, 0xff, 0x04);
>        if (ret < 0)
> -               printk(KERN_ERR "i2c_smbus_write_byte_data failed for page select\n");
> -       ret = i2c_smbus_write_byte_data(ts->client, 0xf0, 0x81); /* normal operation, 80 reports per second */
> +               printk(KERN_ERR "smbus write failed for page select\n");
> +       /* normal operation, 80 reports per second */
> +       ret = i2c_smbus_write_byte_data(ts->client, 0xf0, 0x81);
>        if (ret < 0)
> -               printk(KERN_ERR "synaptics_ts_resume: i2c_smbus_write_byte_data failed\n");
> +               printk(KERN_ERR "smbus write failed for 80/second\n");
>        return ret;
>  }
>
> +static void decode_report(struct synaptics_ts_data *ts, u8 *buf)
> +{
> +       int pos[2][2];
> +       int f, a;
> +       int base = 2;
> +       int z = buf[1];
> +       int w = buf[0] >> 4;
> +       int finger = buf[0] & 7;
> +       int finger2_pressed;
> +
> +       for (f = 0; f < 2; f++) {
> +               u32 flip_flag = SYNAPTICS_FLIP_X;
> +               for (a = 0; a < 2; a++) {
> +                       int p = buf[base + 1];
> +                       p |= (u16)(buf[base] & 0x1f) << 8;
> +                       if (ts->flags & flip_flag)
> +                               p = ts->max[a] - p;
> +                       if (ts->flags & SYNAPTICS_SNAP_TO_INACTIVE_EDGE) {
> +                               if (ts->snap_state[f][a]) {
> +                                       if (p <= ts->snap_down_off[a])
> +                                               p = ts->snap_down[a];
> +                                       else if (p >= ts->snap_up_off[a])
> +                                               p = ts->snap_up[a];
> +                                       else
> +                                               ts->snap_state[f][a] = 0;
> +                               } else {
> +                                       if (p <= ts->snap_down_on[a]) {
> +                                               p = ts->snap_down[a];
> +                                               ts->snap_state[f][a] = 1;
> +                                       } else if (p >= ts->snap_up_on[a]) {
> +                                               p = ts->snap_up[a];
> +                                               ts->snap_state[f][a] = 1;
> +                                       }
> +                               }
> +                       }
> +                       pos[f][a] = p;
> +                       base += 2;
> +                       flip_flag <<= 1;
> +               }
> +               base += 2;
> +               if (ts->flags & SYNAPTICS_SWAP_XY)
> +                       swap(pos[f][0], pos[f][1]);
> +       }
> +       if (z) {
> +               input_report_abs(ts->input_dev, ABS_X, pos[0][0]);
> +               input_report_abs(ts->input_dev, ABS_Y, pos[0][1]);
> +       }
> +       input_report_abs(ts->input_dev, ABS_PRESSURE, z);
> +       input_report_abs(ts->input_dev, ABS_TOOL_WIDTH, w);
> +       input_report_key(ts->input_dev, BTN_TOUCH, finger);
> +       finger2_pressed = finger > 1 && finger != 7;
> +       input_report_key(ts->input_dev, BTN_2, finger2_pressed);
> +       if (finger2_pressed) {
> +               input_report_abs(ts->input_dev, ABS_HAT0X, pos[1][0]);
> +               input_report_abs(ts->input_dev, ABS_HAT0Y, pos[1][1]);
> +       }
> +       input_sync(ts->input_dev);
> +}
> +
>  static void synaptics_ts_work_func(struct work_struct *work)
>  {
>        int i;
>        int ret;
>        int bad_data = 0;
>        struct i2c_msg msg[2];
> -       uint8_t start_reg;
> -       uint8_t buf[15];
> -       struct synaptics_ts_data *ts = container_of(work, struct synaptics_ts_data, work);
> +       u8 start_reg = 0;
> +       u8 buf[15];
> +       struct synaptics_ts_data *ts =
> +               container_of(work, struct synaptics_ts_data, work);
>
>        msg[0].addr = ts->client->addr;
>        msg[0].flags = 0;
>        msg[0].len = 1;
>        msg[0].buf = &start_reg;
> -       start_reg = 0x00;
>        msg[1].addr = ts->client->addr;
>        msg[1].flags = I2C_M_RD;
>        msg[1].len = sizeof(buf);
>        msg[1].buf = buf;
>
> -       /* printk("synaptics_ts_work_func\n"); */
>        for (i = 0; i < ((ts->use_irq && !bad_data) ? 1 : 10); i++) {
>                ret = i2c_transfer(ts->client->adapter, msg, 2);
>                if (ret < 0) {
> -                       printk(KERN_ERR "synaptics_ts_work_func: i2c_transfer failed\n");
> +                       printk(KERN_ERR "ts_work: i2c_transfer failed\n");

This will make it harder to read the kernel logs since the driver is
no longer specified.

>                        bad_data = 1;
> -               } else {
> -                       /* printk("synaptics_ts_work_func: %x %x %x %x %x %x" */
> -                       /*        " %x %x %x %x %x %x %x %x %x, ret %d\n", */
> -                       /*        buf[0], buf[1], buf[2], buf[3], */
> -                       /*        buf[4], buf[5], buf[6], buf[7], */
> -                       /*        buf[8], buf[9], buf[10], buf[11], */
> -                       /*        buf[12], buf[13], buf[14], ret); */
> -                       if ((buf[14] & 0xc0) != 0x40) {
> -                               printk(KERN_WARNING "synaptics_ts_work_func:"
> -                                      " bad read %x %x %x %x %x %x %x %x %x"
> -                                      " %x %x %x %x %x %x, ret %d\n",
> -                                      buf[0], buf[1], buf[2], buf[3],
> -                                      buf[4], buf[5], buf[6], buf[7],
> -                                      buf[8], buf[9], buf[10], buf[11],
> -                                      buf[12], buf[13], buf[14], ret);
> -                               if (bad_data)
> -                                       synaptics_init_panel(ts);
> -                               bad_data = 1;
> -                               continue;
> -                       }
> -                       bad_data = 0;
> -                       if ((buf[14] & 1) == 0) {
> -                               /* printk("read %d coordinates\n", i); */
> -                               break;
> -                       } else {
> -                               int pos[2][2];
> -                               int f, a;
> -                               int base;
> -                               /* int x = buf[3] | (uint16_t)(buf[2] & 0x1f) << 8; */
> -                               /* int y = buf[5] | (uint16_t)(buf[4] & 0x1f) << 8; */
> -                               int z = buf[1];
> -                               int w = buf[0] >> 4;
> -                               int finger = buf[0] & 7;
> -
> -                               /* int x2 = buf[3+6] | (uint16_t)(buf[2+6] & 0x1f) << 8; */
> -                               /* int y2 = buf[5+6] | (uint16_t)(buf[4+6] & 0x1f) << 8; */
> -                               /* int z2 = buf[1+6]; */
> -                               /* int w2 = buf[0+6] >> 4; */
> -                               /* int finger2 = buf[0+6] & 7; */
> -
> -                               /* int dx = (int8_t)buf[12]; */
> -                               /* int dy = (int8_t)buf[13]; */
> -                               int finger2_pressed;
> -
> -                               /* printk("x %4d, y %4d, z %3d, w %2d, F %d, 2nd: x %4d, y %4d, z %3d, w %2d, F %d, dx %4d, dy %4d\n", */
> -                               /*      x, y, z, w, finger, */
> -                               /*      x2, y2, z2, w2, finger2, */
> -                               /*      dx, dy); */
> -
> -                               base = 2;
> -                               for (f = 0; f < 2; f++) {
> -                                       uint32_t flip_flag = SYNAPTICS_FLIP_X;
> -                                       for (a = 0; a < 2; a++) {
> -                                               int p = buf[base + 1];
> -                                               p |= (uint16_t)(buf[base] & 0x1f) << 8;
> -                                               if (ts->flags & flip_flag)
> -                                                       p = ts->max[a] - p;
> -                                               if (ts->flags & SYNAPTICS_SNAP_TO_INACTIVE_EDGE) {
> -                                                       if (ts->snap_state[f][a]) {
> -                                                               if (p <= ts->snap_down_off[a])
> -                                                                       p = ts->snap_down[a];
> -                                                               else if (p >= ts->snap_up_off[a])
> -                                                                       p = ts->snap_up[a];
> -                                                               else
> -                                                                       ts->snap_state[f][a] = 0;
> -                                                       } else {
> -                                                               if (p <= ts->snap_down_on[a]) {
> -                                                                       p = ts->snap_down[a];
> -                                                                       ts->snap_state[f][a] = 1;
> -                                                               } else if (p >= ts->snap_up_on[a]) {
> -                                                                       p = ts->snap_up[a];
> -                                                                       ts->snap_state[f][a] = 1;
> -                                                               }
> -                                                       }
> -                                               }
> -                                               pos[f][a] = p;
> -                                               base += 2;
> -                                               flip_flag <<= 1;
> -                                       }
> -                                       base += 2;
> -                                       if (ts->flags & SYNAPTICS_SWAP_XY)
> -                                               swap(pos[f][0], pos[f][1]);
> -                               }
> -                               if (z) {
> -                                       input_report_abs(ts->input_dev, ABS_X, pos[0][0]);
> -                                       input_report_abs(ts->input_dev, ABS_Y, pos[0][1]);
> -                               }
> -                               input_report_abs(ts->input_dev, ABS_PRESSURE, z);
> -                               input_report_abs(ts->input_dev, ABS_TOOL_WIDTH, w);
> -                               input_report_key(ts->input_dev, BTN_TOUCH, finger);
> -                               finger2_pressed = finger > 1 && finger != 7;
> -                               input_report_key(ts->input_dev, BTN_2, finger2_pressed);
> -                               if (finger2_pressed) {
> -                                       input_report_abs(ts->input_dev, ABS_HAT0X, pos[1][0]);
> -                                       input_report_abs(ts->input_dev, ABS_HAT0Y, pos[1][1]);
> -                               }
> -                               input_sync(ts->input_dev);
> -                       }
> +                       continue;
> +               }
> +               if ((buf[14] & 0xc0) != 0x40) {
> +                       printk(KERN_WARNING "synaptics_ts_work_func:"
> +                              " bad read %x %x %x %x %x %x %x %x %x"
> +                              " %x %x %x %x %x %x, ret %d\n",
> +                              buf[0], buf[1], buf[2], buf[3],
> +                              buf[4], buf[5], buf[6], buf[7],
> +                              buf[8], buf[9], buf[10], buf[11],
> +                              buf[12], buf[13], buf[14], ret);
> +                       if (bad_data)
> +                               synaptics_init_panel(ts);
> +                       bad_data = 1;
> +                       continue;
>                }
> +               bad_data = 0;
> +               if ((buf[14] & 1) == 0)
> +                       break;
> +
> +               decode_report(ts, buf);
>        }
>        if (ts->use_irq)
>                enable_irq(ts->client->irq);
> @@ -208,8 +184,8 @@ static void synaptics_ts_work_func(struct work_struct *work)
>
>  static enum hrtimer_restart synaptics_ts_timer_func(struct hrtimer *timer)
>  {
> -       struct synaptics_ts_data *ts = container_of(timer, struct synaptics_ts_data, timer);
> -       /* printk("synaptics_ts_timer_func\n"); */
> +       struct synaptics_ts_data *ts =
> +               container_of(timer, struct synaptics_ts_data, timer);
>
>        queue_work(synaptics_wq, &ts->work);
>
> @@ -221,36 +197,145 @@ static irqreturn_t synaptics_ts_irq_handler(int irq, void *dev_id)
>  {
>        struct synaptics_ts_data *ts = dev_id;
>
> -       /* printk("synaptics_ts_irq_handler\n"); */
>        disable_irq(ts->client->irq);
>        queue_work(synaptics_wq, &ts->work);
>        return IRQ_HANDLED;
>  }
>
> +static int detect(struct synaptics_ts_data *ts, u32 *panel_version)
> +{
> +       int ret;
> +       int retry = 10;
> +
> +       /* device command = reset */
> +       ret = i2c_smbus_write_byte_data(ts->client, 0xf4, 0x01);
> +       if (ret < 0) {
> +               printk(KERN_ERR "i2c_smbus_write_byte_data failed\n");
> +               /* fail? */
> +       }
> +
> +       while (retry-- > 0) {
> +               ret = i2c_smbus_read_byte_data(ts->client, 0xe4);
> +               if (ret >= 0)
> +                       break;
> +               msleep(100);
> +       }
> +       if (ret < 0) {
> +               printk(KERN_ERR "i2c_smbus_read_byte_data failed\n");
> +               return ret;
> +       }
> +
> +       printk(KERN_INFO "synaptics_ts_probe: Product Major Version %x\n", ret);
> +       *panel_version = ret << 8;
> +       ret = i2c_smbus_read_byte_data(ts->client, 0xe5);
> +       if (ret < 0) {
> +               printk(KERN_ERR "i2c_smbus_read_byte_data failed\n");
> +               return ret;
> +       }
> +       printk(KERN_INFO "synaptics_ts_probe: Product Minor Version %x\n", ret);
> +       *panel_version |= ret;
> +
> +       ret = i2c_smbus_read_byte_data(ts->client, 0xe3);
> +       if (ret < 0) {
> +               printk(KERN_ERR "i2c_smbus_read_byte_data failed\n");
> +               return ret;
> +       }
> +       printk(KERN_INFO "synaptics_ts_probe: product property %x\n", ret);
> +       return 0;
> +}
> +
> +static void compute_areas(struct synaptics_ts_data *ts,
> +                         struct synaptics_i2c_rmi_platform_data *pdata,
> +                         u16 max_x, u16 max_y)
> +{
> +       u32 inactive_area_left;
> +       u32 inactive_area_right;
> +       u32 inactive_area_top;
> +       u32 inactive_area_bottom;
> +       u32 snap_left_on;
> +       u32 snap_left_off;
> +       u32 snap_right_on;
> +       u32 snap_right_off;
> +       u32 snap_top_on;
> +       u32 snap_top_off;
> +       u32 snap_bottom_on;
> +       u32 snap_bottom_off;
> +       u32 fuzz_x;
> +       u32 fuzz_y;
> +       int fuzz_p;
> +       int fuzz_w;
> +
> +       inactive_area_left = pdata->inactive_left;
> +       inactive_area_right = pdata->inactive_right;
> +       inactive_area_top = pdata->inactive_top;
> +       inactive_area_bottom = pdata->inactive_bottom;
> +       snap_left_on = pdata->snap_left_on;
> +       snap_left_off = pdata->snap_left_off;
> +       snap_right_on = pdata->snap_right_on;
> +       snap_right_off = pdata->snap_right_off;
> +       snap_top_on = pdata->snap_top_on;
> +       snap_top_off = pdata->snap_top_off;
> +       snap_bottom_on = pdata->snap_bottom_on;
> +       snap_bottom_off = pdata->snap_bottom_off;
> +       fuzz_x = pdata->fuzz_x;
> +       fuzz_y = pdata->fuzz_y;
> +       fuzz_p = pdata->fuzz_p;
> +       fuzz_w = pdata->fuzz_w;
> +
> +       inactive_area_left = inactive_area_left * max_x / 0x10000;
> +       inactive_area_right = inactive_area_right * max_x / 0x10000;
> +       inactive_area_top = inactive_area_top * max_y / 0x10000;
> +       inactive_area_bottom = inactive_area_bottom * max_y / 0x10000;
> +       snap_left_on = snap_left_on * max_x / 0x10000;
> +       snap_left_off = snap_left_off * max_x / 0x10000;
> +       snap_right_on = snap_right_on * max_x / 0x10000;
> +       snap_right_off = snap_right_off * max_x / 0x10000;
> +       snap_top_on = snap_top_on * max_y / 0x10000;
> +       snap_top_off = snap_top_off * max_y / 0x10000;
> +       snap_bottom_on = snap_bottom_on * max_y / 0x10000;
> +       snap_bottom_off = snap_bottom_off * max_y / 0x10000;
> +       fuzz_x = fuzz_x * max_x / 0x10000;
> +       fuzz_y = fuzz_y * max_y / 0x10000;
> +
> +       ts->snap_down[!!(ts->flags & SYNAPTICS_SWAP_XY)] = -inactive_area_left;
> +       ts->snap_up[!!(ts->flags & SYNAPTICS_SWAP_XY)] = max_x + inactive_area_right;
> +       ts->snap_down[!(ts->flags & SYNAPTICS_SWAP_XY)] = -inactive_area_top;
> +       ts->snap_up[!(ts->flags & SYNAPTICS_SWAP_XY)] = max_y + inactive_area_bottom;
> +       ts->snap_down_on[!!(ts->flags & SYNAPTICS_SWAP_XY)] = snap_left_on;
> +       ts->snap_down_off[!!(ts->flags & SYNAPTICS_SWAP_XY)] = snap_left_off;
> +       ts->snap_up_on[!!(ts->flags & SYNAPTICS_SWAP_XY)] = max_x - snap_right_on;
> +       ts->snap_up_off[!!(ts->flags & SYNAPTICS_SWAP_XY)] = max_x - snap_right_off;
> +       ts->snap_down_on[!(ts->flags & SYNAPTICS_SWAP_XY)] = snap_top_on;
> +       ts->snap_down_off[!(ts->flags & SYNAPTICS_SWAP_XY)] = snap_top_off;
> +       ts->snap_up_on[!(ts->flags & SYNAPTICS_SWAP_XY)] = max_y - snap_bottom_on;
> +       ts->snap_up_off[!(ts->flags & SYNAPTICS_SWAP_XY)] = max_y - snap_bottom_off;
> +       printk(KERN_INFO "synaptics_ts_probe: max_x %d, max_y %d\n", max_x, max_y);
> +       printk(KERN_INFO "synaptics_ts_probe: inactive_x %d %d, inactive_y %d %d\n",
> +              inactive_area_left, inactive_area_right,
> +              inactive_area_top, inactive_area_bottom);
> +       printk(KERN_INFO "synaptics_ts_probe: snap_x %d-%d %d-%d, snap_y %d-%d %d-%d\n",
> +              snap_left_on, snap_left_off, snap_right_on, snap_right_off,
> +              snap_top_on, snap_top_off, snap_bottom_on, snap_bottom_off);
> +
> +       input_set_abs_params(ts->input_dev, ABS_X, -inactive_area_left, max_x + inactive_area_right, fuzz_x, 0);
> +       input_set_abs_params(ts->input_dev, ABS_Y, -inactive_area_top, max_y + inactive_area_bottom, fuzz_y, 0);
> +       input_set_abs_params(ts->input_dev, ABS_PRESSURE, 0, 255, fuzz_p, 0);
> +       input_set_abs_params(ts->input_dev, ABS_TOOL_WIDTH, 0, 15, fuzz_w, 0);
> +       input_set_abs_params(ts->input_dev, ABS_HAT0X, -inactive_area_left, max_x + inactive_area_right, fuzz_x, 0);
> +       input_set_abs_params(ts->input_dev, ABS_HAT0Y, -inactive_area_top, max_y + inactive_area_bottom, fuzz_y, 0);
> +}
> +
>  static int synaptics_ts_probe(
>        struct i2c_client *client, const struct i2c_device_id *id)
>  {
>        struct synaptics_ts_data *ts;
> -       uint8_t buf0[4];
> -       uint8_t buf1[8];
> +       u8 buf0[4];
> +       u8 buf1[8];
>        struct i2c_msg msg[2];
>        int ret = 0;
> -       uint16_t max_x, max_y;
> -       int fuzz_x, fuzz_y, fuzz_p, fuzz_w;
>        struct synaptics_i2c_rmi_platform_data *pdata;
> -       int inactive_area_left;
> -       int inactive_area_right;
> -       int inactive_area_top;
> -       int inactive_area_bottom;
> -       int snap_left_on;
> -       int snap_left_off;
> -       int snap_right_on;
> -       int snap_right_off;
> -       int snap_top_on;
> -       int snap_top_off;
> -       int snap_bottom_on;
> -       int snap_bottom_off;
> -       uint32_t panel_version;
> +       u32 panel_version = 0;
> +       u16 max_x, max_y;
>
>        if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
>                printk(KERN_ERR "synaptics_ts_probe: need I2C_FUNC_I2C\n");
> @@ -269,6 +354,9 @@ static int synaptics_ts_probe(
>        pdata = client->dev.platform_data;
>        if (pdata)
>                ts->power = pdata->power;
> +       else
> +               pdata = kzalloc(sizeof(*pdata), GFP_KERNEL);
> +

Where do you free this?

>        if (ts->power) {
>                ret = ts->power(1);
>                if (ret < 0) {
> @@ -277,81 +365,16 @@ static int synaptics_ts_probe(
>                }
>        }
>
> -       ret = i2c_smbus_write_byte_data(ts->client, 0xf4, 0x01); /* device command = reset */
> -       if (ret < 0) {
> -               printk(KERN_ERR "i2c_smbus_write_byte_data failed\n");
> -               /* fail? */
> -       }
> -       {
> -               int retry = 10;
> -               while (retry-- > 0) {
> -                       ret = i2c_smbus_read_byte_data(ts->client, 0xe4);
> -                       if (ret >= 0)
> -                               break;
> -                       msleep(100);
> -               }
> -       }
> -       if (ret < 0) {
> -               printk(KERN_ERR "i2c_smbus_read_byte_data failed\n");
> -               goto err_detect_failed;
> -       }
> -       printk(KERN_INFO "synaptics_ts_probe: Product Major Version %x\n", ret);
> -       panel_version = ret << 8;
> -       ret = i2c_smbus_read_byte_data(ts->client, 0xe5);
> -       if (ret < 0) {
> -               printk(KERN_ERR "i2c_smbus_read_byte_data failed\n");
> -               goto err_detect_failed;
> -       }
> -       printk(KERN_INFO "synaptics_ts_probe: Product Minor Version %x\n", ret);
> -       panel_version |= ret;
> -
> -       ret = i2c_smbus_read_byte_data(ts->client, 0xe3);
> -       if (ret < 0) {
> -               printk(KERN_ERR "i2c_smbus_read_byte_data failed\n");
> +       ret = detect(ts, &panel_version);
> +       if (ret)
>                goto err_detect_failed;
> -       }
> -       printk(KERN_INFO "synaptics_ts_probe: product property %x\n", ret);
>
> -       if (pdata) {
> -               while (pdata->version > panel_version)
> -                       pdata++;
> -               ts->flags = pdata->flags;
> -               inactive_area_left = pdata->inactive_left;
> -               inactive_area_right = pdata->inactive_right;
> -               inactive_area_top = pdata->inactive_top;
> -               inactive_area_bottom = pdata->inactive_bottom;
> -               snap_left_on = pdata->snap_left_on;
> -               snap_left_off = pdata->snap_left_off;
> -               snap_right_on = pdata->snap_right_on;
> -               snap_right_off = pdata->snap_right_off;
> -               snap_top_on = pdata->snap_top_on;
> -               snap_top_off = pdata->snap_top_off;
> -               snap_bottom_on = pdata->snap_bottom_on;
> -               snap_bottom_off = pdata->snap_bottom_off;
> -               fuzz_x = pdata->fuzz_x;
> -               fuzz_y = pdata->fuzz_y;
> -               fuzz_p = pdata->fuzz_p;
> -               fuzz_w = pdata->fuzz_w;
> -       } else {
> -               inactive_area_left = 0;
> -               inactive_area_right = 0;
> -               inactive_area_top = 0;
> -               inactive_area_bottom = 0;
> -               snap_left_on = 0;
> -               snap_left_off = 0;
> -               snap_right_on = 0;
> -               snap_right_off = 0;
> -               snap_top_on = 0;
> -               snap_top_off = 0;
> -               snap_bottom_on = 0;
> -               snap_bottom_off = 0;
> -               fuzz_x = 0;
> -               fuzz_y = 0;
> -               fuzz_p = 0;
> -               fuzz_w = 0;
> -       }
> +       while (pdata->version > panel_version)
> +               pdata++;
> +       ts->flags = pdata->flags;
>
>        ret = i2c_smbus_read_byte_data(ts->client, 0xf0);
> +
>        if (ret < 0) {
>                printk(KERN_ERR "i2c_smbus_read_byte_data failed\n");
>                goto err_detect_failed;
> @@ -427,46 +450,10 @@ static int synaptics_ts_probe(
>        set_bit(BTN_TOUCH, ts->input_dev->keybit);
>        set_bit(BTN_2, ts->input_dev->keybit);
>        set_bit(EV_ABS, ts->input_dev->evbit);
> -       inactive_area_left = inactive_area_left * max_x / 0x10000;
> -       inactive_area_right = inactive_area_right * max_x / 0x10000;
> -       inactive_area_top = inactive_area_top * max_y / 0x10000;
> -       inactive_area_bottom = inactive_area_bottom * max_y / 0x10000;
> -       snap_left_on = snap_left_on * max_x / 0x10000;
> -       snap_left_off = snap_left_off * max_x / 0x10000;
> -       snap_right_on = snap_right_on * max_x / 0x10000;
> -       snap_right_off = snap_right_off * max_x / 0x10000;
> -       snap_top_on = snap_top_on * max_y / 0x10000;
> -       snap_top_off = snap_top_off * max_y / 0x10000;
> -       snap_bottom_on = snap_bottom_on * max_y / 0x10000;
> -       snap_bottom_off = snap_bottom_off * max_y / 0x10000;
> -       fuzz_x = fuzz_x * max_x / 0x10000;
> -       fuzz_y = fuzz_y * max_y / 0x10000;
> -       ts->snap_down[!!(ts->flags & SYNAPTICS_SWAP_XY)] = -inactive_area_left;
> -       ts->snap_up[!!(ts->flags & SYNAPTICS_SWAP_XY)] = max_x + inactive_area_right;
> -       ts->snap_down[!(ts->flags & SYNAPTICS_SWAP_XY)] = -inactive_area_top;
> -       ts->snap_up[!(ts->flags & SYNAPTICS_SWAP_XY)] = max_y + inactive_area_bottom;
> -       ts->snap_down_on[!!(ts->flags & SYNAPTICS_SWAP_XY)] = snap_left_on;
> -       ts->snap_down_off[!!(ts->flags & SYNAPTICS_SWAP_XY)] = snap_left_off;
> -       ts->snap_up_on[!!(ts->flags & SYNAPTICS_SWAP_XY)] = max_x - snap_right_on;
> -       ts->snap_up_off[!!(ts->flags & SYNAPTICS_SWAP_XY)] = max_x - snap_right_off;
> -       ts->snap_down_on[!(ts->flags & SYNAPTICS_SWAP_XY)] = snap_top_on;
> -       ts->snap_down_off[!(ts->flags & SYNAPTICS_SWAP_XY)] = snap_top_off;
> -       ts->snap_up_on[!(ts->flags & SYNAPTICS_SWAP_XY)] = max_y - snap_bottom_on;
> -       ts->snap_up_off[!(ts->flags & SYNAPTICS_SWAP_XY)] = max_y - snap_bottom_off;
> -       printk(KERN_INFO "synaptics_ts_probe: max_x %d, max_y %d\n", max_x, max_y);
> -       printk(KERN_INFO "synaptics_ts_probe: inactive_x %d %d, inactive_y %d %d\n",
> -              inactive_area_left, inactive_area_right,
> -              inactive_area_top, inactive_area_bottom);
> -       printk(KERN_INFO "synaptics_ts_probe: snap_x %d-%d %d-%d, snap_y %d-%d %d-%d\n",
> -              snap_left_on, snap_left_off, snap_right_on, snap_right_off,
> -              snap_top_on, snap_top_off, snap_bottom_on, snap_bottom_off);
> -       input_set_abs_params(ts->input_dev, ABS_X, -inactive_area_left, max_x + inactive_area_right, fuzz_x, 0);
> -       input_set_abs_params(ts->input_dev, ABS_Y, -inactive_area_top, max_y + inactive_area_bottom, fuzz_y, 0);
> -       input_set_abs_params(ts->input_dev, ABS_PRESSURE, 0, 255, fuzz_p, 0);
> -       input_set_abs_params(ts->input_dev, ABS_TOOL_WIDTH, 0, 15, fuzz_w, 0);
> -       input_set_abs_params(ts->input_dev, ABS_HAT0X, -inactive_area_left, max_x + inactive_area_right, fuzz_x, 0);
> -       input_set_abs_params(ts->input_dev, ABS_HAT0Y, -inactive_area_top, max_y + inactive_area_bottom, fuzz_y, 0);
> -       /* ts->input_dev->name = ts->keypad_info->name; */
> +
> +       compute_areas(ts, pdata, max_x, max_y);
> +
> +
>        ret = input_register_device(ts->input_dev);
>        if (ret) {
>                printk(KERN_ERR "synaptics_ts_probe: Unable to register %s input device\n", ts->input_dev->name);
> @@ -489,33 +476,27 @@ static int synaptics_ts_probe(
>                ts->timer.function = synaptics_ts_timer_func;
>                hrtimer_start(&ts->timer, ktime_set(1, 0), HRTIMER_MODE_REL);
>        }
> -#ifdef CONFIG_HAS_EARLYSUSPEND
> -       ts->early_suspend.level = EARLY_SUSPEND_LEVEL_BLANK_SCREEN + 1;
> -       ts->early_suspend.suspend = synaptics_ts_early_suspend;
> -       ts->early_suspend.resume = synaptics_ts_late_resume;
> -       register_early_suspend(&ts->early_suspend);
> -#endif
>
>        printk(KERN_INFO "synaptics_ts_probe: Start touchscreen %s in %s mode\n", ts->input_dev->name, ts->use_irq ? "interrupt" : "polling");
>
>        return 0;
>
> -err_input_register_device_failed:
> + err_input_register_device_failed:
>        input_free_device(ts->input_dev);
>
> -err_input_dev_alloc_failed:
> -err_detect_failed:
> -err_power_failed:
> + err_input_dev_alloc_failed:
> + err_detect_failed:
> + err_power_failed:
>        kfree(ts);
> -err_alloc_data_failed:
> -err_check_functionality_failed:
> + err_alloc_data_failed:
> + err_check_functionality_failed:
>        return ret;
>  }
>
>  static int synaptics_ts_remove(struct i2c_client *client)
>  {
>        struct synaptics_ts_data *ts = i2c_get_clientdata(client);
> -       unregister_early_suspend(&ts->early_suspend);
> +
>        if (ts->use_irq)
>                free_irq(client->irq, ts);
>        else
> @@ -525,72 +506,6 @@ static int synaptics_ts_remove(struct i2c_client *client)
>        return 0;
>  }
>
> -static int synaptics_ts_suspend(struct i2c_client *client, pm_message_t mesg)
> -{
> -       int ret;
> -       struct synaptics_ts_data *ts = i2c_get_clientdata(client);
> -
> -       if (ts->use_irq)
> -               disable_irq(client->irq);
> -       else
> -               hrtimer_cancel(&ts->timer);
> -       ret = cancel_work_sync(&ts->work);
> -       if (ret && ts->use_irq) /* if work was pending disable-count is now 2 */
> -               enable_irq(client->irq);
> -       ret = i2c_smbus_write_byte_data(ts->client, 0xf1, 0); /* disable interrupt */
> -       if (ret < 0)
> -               printk(KERN_ERR "synaptics_ts_suspend: i2c_smbus_write_byte_data failed\n");
> -
> -       ret = i2c_smbus_write_byte_data(client, 0xf0, 0x86); /* deep sleep */
> -       if (ret < 0)
> -               printk(KERN_ERR "synaptics_ts_suspend: i2c_smbus_write_byte_data failed\n");
> -       if (ts->power) {
> -               ret = ts->power(0);
> -               if (ret < 0)
> -                       printk(KERN_ERR "synaptics_ts_resume power off failed\n");
> -       }
> -       return 0;
> -}
> -
> -static int synaptics_ts_resume(struct i2c_client *client)
> -{
> -       int ret;
> -       struct synaptics_ts_data *ts = i2c_get_clientdata(client);
> -
> -       if (ts->power) {
> -               ret = ts->power(1);
> -               if (ret < 0)
> -                       printk(KERN_ERR "synaptics_ts_resume power on failed\n");
> -       }
> -
> -       synaptics_init_panel(ts);
> -
> -       if (ts->use_irq)
> -               enable_irq(client->irq);
> -
> -       if (!ts->use_irq)
> -               hrtimer_start(&ts->timer, ktime_set(1, 0), HRTIMER_MODE_REL);
> -       else
> -               i2c_smbus_write_byte_data(ts->client, 0xf1, 0x01); /* enable abs int */
> -
> -       return 0;
> -}

Why did you remove suspend and resume?

> -
> -#ifdef CONFIG_HAS_EARLYSUSPEND
> -static void synaptics_ts_early_suspend(struct early_suspend *h)
> -{
> -       struct synaptics_ts_data *ts;
> -       ts = container_of(h, struct synaptics_ts_data, early_suspend);
> -       synaptics_ts_suspend(ts->client, PMSG_SUSPEND);
> -}
> -
> -static void synaptics_ts_late_resume(struct early_suspend *h)
> -{
> -       struct synaptics_ts_data *ts;
> -       ts = container_of(h, struct synaptics_ts_data, early_suspend);
> -       synaptics_ts_resume(ts->client);
> -}
> -#endif
>
>  static const struct i2c_device_id synaptics_ts_id[] = {
>        { SYNAPTICS_I2C_RMI_NAME, 0 },
> @@ -600,10 +515,6 @@ static const struct i2c_device_id synaptics_ts_id[] = {
>  static struct i2c_driver synaptics_ts_driver = {
>        .probe          = synaptics_ts_probe,
>        .remove         = synaptics_ts_remove,
> -#ifndef CONFIG_HAS_EARLYSUSPEND
> -       .suspend        = synaptics_ts_suspend,
> -       .resume         = synaptics_ts_resume,
> -#endif

Remove #ifndef only, not the content.


>        .id_table       = synaptics_ts_id,
>        .driver = {
>                .name   = SYNAPTICS_I2C_RMI_NAME,
> diff --git a/include/linux/synaptics_i2c_rmi.h b/include/linux/synaptics_i2c_rmi.h
> index ca51b2f..73e1de7 100644
> --- a/include/linux/synaptics_i2c_rmi.h
> +++ b/include/linux/synaptics_i2c_rmi.h
> @@ -1,5 +1,5 @@
>  /*
> - * include/linux/synaptics_i2c_rmi.h - platform data structure for f75375s sensor
> + * synaptics_i2c_rmi.h - platform data structure for f75375s sensor
>  *
>  * Copyright (C) 2008 Google, Inc.
>  *
> @@ -27,25 +27,25 @@ enum {
>  };
>
>  struct synaptics_i2c_rmi_platform_data {
> -       uint32_t version;       /* Use this entry for panels with */
> +       u32 version;    /* Use this entry for panels with */
>                                /* (major << 8 | minor) version or above. */
>                                /* If non-zero another array entry follows */
>        int (*power)(int on);   /* Only valid in first array entry */
> -       uint32_t flags;
> -       uint32_t inactive_left; /* 0x10000 = screen width */
> -       uint32_t inactive_right; /* 0x10000 = screen width */
> -       uint32_t inactive_top; /* 0x10000 = screen height */
> -       uint32_t inactive_bottom; /* 0x10000 = screen height */
> -       uint32_t snap_left_on; /* 0x10000 = screen width */
> -       uint32_t snap_left_off; /* 0x10000 = screen width */
> -       uint32_t snap_right_on; /* 0x10000 = screen width */
> -       uint32_t snap_right_off; /* 0x10000 = screen width */
> -       uint32_t snap_top_on; /* 0x10000 = screen height */
> -       uint32_t snap_top_off; /* 0x10000 = screen height */
> -       uint32_t snap_bottom_on; /* 0x10000 = screen height */
> -       uint32_t snap_bottom_off; /* 0x10000 = screen height */
> -       uint32_t fuzz_x; /* 0x10000 = screen width */
> -       uint32_t fuzz_y; /* 0x10000 = screen height */
> +       u32 flags;
> +       u32 inactive_left; /* 0x10000 = screen width */
> +       u32 inactive_right; /* 0x10000 = screen width */
> +       u32 inactive_top; /* 0x10000 = screen height */
> +       u32 inactive_bottom; /* 0x10000 = screen height */
> +       u32 snap_left_on; /* 0x10000 = screen width */
> +       u32 snap_left_off; /* 0x10000 = screen width */
> +       u32 snap_right_on; /* 0x10000 = screen width */
> +       u32 snap_right_off; /* 0x10000 = screen width */
> +       u32 snap_top_on; /* 0x10000 = screen height */
> +       u32 snap_top_off; /* 0x10000 = screen height */
> +       u32 snap_bottom_on; /* 0x10000 = screen height */
> +       u32 snap_bottom_off; /* 0x10000 = screen height */
> +       u32 fuzz_x; /* 0x10000 = screen width */
> +       u32 fuzz_y; /* 0x10000 = screen height */

I prefer the existing C99 types.

>        int fuzz_p;
>        int fuzz_w;
>  };
>
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

This driver only supports a subset of Synaptics' devices so a more
generic driver will eventually be needed. The patch below adds support
for a more recent but similar panel.

-- 
Arve Hjønnevåg

----

commit 22d8c831554b8bec6e9fbac9d6bf972c775ee128
Author: Arve Hjønnevåg <arve@android.com>
Date:   Wed Jul 8 21:32:06 2009 -0700

    Input: synaptics_i2c_rmi: Add support for panels with
has-no-relative-data property.

    Signed-off-by: Arve Hjønnevåg <arve@android.com>

diff --git a/drivers/input/touchscreen/synaptics_i2c_rmi.c
b/drivers/input/touchscreen/synaptics_i2c_rmi.c
index a45634b..88c8e4a 100644
--- a/drivers/input/touchscreen/synaptics_i2c_rmi.c
+++ b/drivers/input/touchscreen/synaptics_i2c_rmi.c
@@ -33,6 +33,7 @@ struct synaptics_ts_data {
        struct i2c_client *client;
        struct input_dev *input_dev;
        int use_irq;
+       bool has_relative_report;
        struct hrtimer timer;
        struct work_struct  work;
        uint16_t max[2];
@@ -85,6 +86,7 @@ static void synaptics_ts_work_func(struct work_struct *work)
        uint8_t start_reg;
        uint8_t buf[15];
        struct synaptics_ts_data *ts = container_of(work, struct
synaptics_ts_data, work);
+       int buf_len = ts->has_relative_report ? 15 : 13;

        msg[0].addr = ts->client->addr;
        msg[0].flags = 0;
@@ -93,7 +95,7 @@ static void synaptics_ts_work_func(struct work_struct *work)
        start_reg = 0x00;
        msg[1].addr = ts->client->addr;
        msg[1].flags = I2C_M_RD;
-       msg[1].len = sizeof(buf);
+       msg[1].len = buf_len;
        msg[1].buf = buf;

        /* printk("synaptics_ts_work_func\n"); */
@@ -109,7 +111,7 @@ static void synaptics_ts_work_func(struct work_struct *work)
                        /*        buf[4], buf[5], buf[6], buf[7], */
                        /*        buf[8], buf[9], buf[10], buf[11], */
                        /*        buf[12], buf[13], buf[14], ret); */
-                       if ((buf[14] & 0xc0) != 0x40) {
+                       if ((buf[buf_len - 1] & 0xc0) != 0x40) {
                                printk(KERN_WARNING "synaptics_ts_work_func:"
                                       " bad read %x %x %x %x %x %x %x %x %x"
                                       " %x %x %x %x %x %x, ret %d\n",
@@ -123,7 +125,7 @@ static void synaptics_ts_work_func(struct work_struct *work)
                                continue;
                        }
                        bad_data = 0;
-                       if ((buf[14] & 1) == 0) {
+                       if ((buf[buf_len - 1] & 1) == 0) {
                                /* printk("read %d coordinates\n", i); */
                                break;
                        } else {
@@ -394,6 +396,13 @@ static int synaptics_ts_probe(
                printk(KERN_ERR "i2c_smbus_write_byte_data failed for
page select\n");
                goto err_detect_failed;
        }
+       ret = i2c_smbus_read_word_data(ts->client, 0x02);
+       if (ret < 0) {
+               printk(KERN_ERR "i2c_smbus_read_word_data failed\n");
+               goto err_detect_failed;
+       }
+       ts->has_relative_report = !(ret & 0x100);
+       printk(KERN_INFO "synaptics_ts_probe: Sensor properties %x\n", ret);
        ret = i2c_smbus_read_word_data(ts->client, 0x04);
        if (ret < 0) {
                printk(KERN_ERR "i2c_smbus_read_word_data failed\n");
