Return-Path: <linux-kernel-owner+w=401wt.eu-S1752657AbYLCLV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657AbYLCLV2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 06:21:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751662AbYLCLVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 06:21:17 -0500
Received: from yw-out-2324.google.com ([74.125.46.29]:24591 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbYLCLVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 06:21:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ZrLbxglj1KOTcnujt7RpovxKSiLWEWKTFtQiX39GN3d+yawbm3MtuMHRS6LMWfYV5s
         NZLmLkXHfumvdB3tU3K8CX3w/vOMtuML1qmEX5INHFCasqecqEl8o0IvIInJAC1smpjJ
         z8hIbj0kRt0zj+WchbDuGxCnTVsaOZubJsrnQ=
Message-ID: <5d5443650812030321p77c4941cj2202418f0b0d44a2@mail.gmail.com>
Date: Wed, 3 Dec 2008 16:51:12 +0530
From: "Trilok Soni" <soni.trilok@gmail.com>
To: "Kwangwoo Lee" <kwangwoo.lee@gmail.com>
Subject: Re: [PATCH] Add tsc2007 based touchscreen driver.
Cc: dmitry.torokhov@gmail.com, linux-kernel@vger.kernel.org,
       "David Brownell" <david-b@pacbell.net>,
       "linux-omap@vger.kernel.org Mailing List" 
	<linux-omap@vger.kernel.org>
In-Reply-To: <483a38b80812020539v2323a784h7f202749687764db@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <483a38b80812020539v2323a784h7f202749687764db@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee

Adding linux-omap mailing list. Sometime I am thinking that same chip
might have interface to be connected on another board/cpu through SPI
too, so in this case we will have two drivers doing the same thing and
difference is  just a change of the bus interface.

We should do something v4l2_subdev framework right now going on on
v4l2 mailing list to abstract the sensor drivers from bus.

On Tue, Dec 2, 2008 at 7:09 PM, Kwangwoo Lee <kwangwoo.lee@gmail.com> wrote:
> Hello,
>
> I'm newbie and I tested this driver on my ARM9 based SoC - MV86XX.
> But the platform codes are not submitted yet.
>
> The example of platform specific codes are followed:
>
> /* TSC2007 Touchscreen */
> #ifdef CONFIG_LCD_CT024TN02
> /* GPIO13:GINT3 = PENIRQ */
> #define TS_PENIRQ_GPIO          GPIO13
> #define TS_CHAINED_GPIO         3
> #else
> /* GPIO5:GINT1 = PENIRQ */
> #define TS_PENIRQ_GPIO          GPIO5
> #define TS_CHAINED_GPIO         1
> #endif
>
> static int mv_get_pendown_state(void)
> {
>        int val = 0;
>
>        mv_gpio_set_direction(TS_PENIRQ_GPIO, 0);
>        mv_gpio_mux_ctrl(TS_PENIRQ_GPIO, GPIO_PIN_MODE_GPIO);
>
>        val =  mv_gpio_get_value(TS_PENIRQ_GPIO);
>        mv_gpio_mux_ctrl(TS_PENIRQ_GPIO, GPIO_PIN_MODE_INT);
>
>        val = val ? 0 : 1;
>        return val;
> }
>
> static void mv_clear_penirq(void)
> {
>        mv_gpio_int_clear(TS_CHAINED_GPIO);
> }
>
> static int mv_init_ts(void)
> {
>        mv_gpio_set_direction(TS_PENIRQ_GPIO, 0);       /* input */
>        mv_gpio_mux_ctrl(TS_PENIRQ_GPIO, GPIO_PIN_MODE_INT);
>
>        mv_gpio_int_mode(TS_CHAINED_GPIO, GPIO_INT_FALLING_EDGE);
>        mv_gpio_int_clear(TS_CHAINED_GPIO);
>        mv_gpio_int_unmask(TS_CHAINED_GPIO);
>        return 0;
> }
>
> static void mv_exit_ts(void)
> {
>        mv_gpio_mux_ctrl(TS_PENIRQ_GPIO, GPIO_PIN_MODE_GPIO);
>        mv_gpio_int_mask(TS_CHAINED_GPIO);
> }
>
> struct tsc2007_platform_data mv_tsc2007_data = {
>        .model = 2007,
>        .x_plate_ohms = 180,
>        .get_pendown_state = mv_get_pendown_state,
>        .clear_penirq      = mv_clear_penirq,
>        .init_platform_hw  = mv_init_ts,
>        .exit_platform_hw  = mv_exit_ts,
> };
>
> /* I2C clients */
> static struct i2c_board_info __initdata mv_i2c_clients[] = {
>        [0] = {
>                I2C_BOARD_INFO("tsc2007", 0x90),
>                .type           = "tsc2007",
>                .platform_data  = &mv_tsc2007_data,
>                .irq            = IRQ_GPIO,
>        },
> };
>
> i2c_register_board_info() should be used.
>
> Signed-off-by: Kwangwoo Lee <kwangwoo.lee@gmail.com>
> ---
>  drivers/input/touchscreen/Kconfig   |    9 +
>  drivers/input/touchscreen/Makefile  |    1 +
>  drivers/input/touchscreen/tsc2007.c |  398 +++++++++++++++++++++++++++++++++++
>  include/linux/i2c/tsc2007.h         |   17 ++
>  4 files changed, 425 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/input/touchscreen/tsc2007.c
>  create mode 100644 include/linux/i2c/tsc2007.h
>
> diff --git a/drivers/input/touchscreen/Kconfig
> b/drivers/input/touchscreen/Kconfig
> index 3d1ab8f..78abdfb 100644
> --- a/drivers/input/touchscreen/Kconfig
> +++ b/drivers/input/touchscreen/Kconfig
> @@ -376,4 +376,13 @@ config TOUCHSCREEN_TOUCHIT213
>          To compile this driver as a module, choose M here: the
>          module will be called touchit213.
>
> +config TOUCHSCREEN_TSC2007
> +       tristate "TSC2007 based touchscreens"
> +       depends on I2C
> +       help
> +         Say Y here if you have a TSC2007 based touchscreens.
> +
> +         To compile this driver as a module, choose M here: the
> +         module will be called tsc2007.
> +
>  endif
> diff --git a/drivers/input/touchscreen/Makefile
> b/drivers/input/touchscreen/Makefile
> index 15cf290..824999c 100644
> --- a/drivers/input/touchscreen/Makefile
> +++ b/drivers/input/touchscreen/Makefile
> @@ -31,3 +31,4 @@ wm97xx-ts-$(CONFIG_TOUCHSCREEN_WM9705)        += wm9705.o
>  wm97xx-ts-$(CONFIG_TOUCHSCREEN_WM9712) += wm9712.o
>  wm97xx-ts-$(CONFIG_TOUCHSCREEN_WM9713) += wm9713.o
>  obj-$(CONFIG_TOUCHSCREEN_WM97XX_MAINSTONE)     += mainstone-wm97xx.o
> +obj-$(CONFIG_TOUCHSCREEN_TSC2007)      += tsc2007.o
> diff --git a/drivers/input/touchscreen/tsc2007.c
> b/drivers/input/touchscreen/tsc2007.c
> new file mode 100644
> index 0000000..85fb520
> --- /dev/null
> +++ b/drivers/input/touchscreen/tsc2007.c
> @@ -0,0 +1,398 @@
> +/*
> + * drivers/input/touchscreen/tsc2007.c
> + *
> + * Copyright (c) 2008 MtekVision Co., Ltd.
> + *     Kwangwoo Lee <kwlee@mtekvision.com>
> + *
> + * Using code from:
> + *  - ads7846.c
> + *     Copyright (c) 2005 David Brownell
> + *     Copyright (c) 2006 Nokia Corporation
> + *  - corgi_ts.c
> + *     Copyright (C) 2004-2005 Richard Purdie
> + *  - omap_ts.[hc], ads7846.h, ts_osk.c
> + *     Copyright (C) 2002 MontaVista Software
> + *     Copyright (C) 2004 Texas Instruments
> + *     Copyright (C) 2005 Dirk Behme
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License version 2 as
> + *  published by the Free Software Foundation.
> + */
> +
> +#include <linux/hwmon.h>
> +#include <linux/init.h>
> +#include <linux/err.h>
> +#include <linux/delay.h>
> +#include <linux/input.h>
> +#include <linux/interrupt.h>
> +#include <linux/slab.h>
> +#include <linux/i2c.h>
> +#include <linux/i2c/tsc2007.h>
> +#include <linux/io.h>
> +
> +#include <asm/irq.h>
> +
> +#define TS_POLL_DELAY  (10 * 1000)     /* ns delay before the first sample */
> +#define TS_POLL_PERIOD (5 * 1000)      /* ns delay between samples */
> +
> +#define TSC2007_MEASURE_TEMP0          (0x0 << 4)
> +#define TSC2007_MEASURE_AUX            (0x2 << 4)
> +#define TSC2007_MEASURE_TEMP1          (0x4 << 4)
> +#define TSC2007_ACTIVATE_XN            (0x8 << 4)
> +#define TSC2007_ACTIVATE_YN            (0x9 << 4)
> +#define TSC2007_ACTIVATE_YP_XN         (0xa << 4)
> +#define TSC2007_SETUP                  (0xb << 4)
> +#define TSC2007_MEASURE_X              (0xc << 4)
> +#define TSC2007_MEASURE_Y              (0xd << 4)
> +#define TSC2007_MEASURE_Z1             (0xe << 4)
> +#define TSC2007_MEASURE_Z2             (0xf << 4)
> +
> +#define TSC2007_POWER_OFF_IRQ_EN       (0x0 << 2)
> +#define TSC2007_ADC_ON_IRQ_DIS0                (0x1 << 2)
> +#define TSC2007_ADC_OFF_IRQ_EN         (0x2 << 2)
> +#define TSC2007_ADC_ON_IRQ_DIS1                (0x3 << 2)
> +
> +#define TSC2007_12BIT                  (0x0 << 1)
> +#define TSC2007_8BIT                   (0x1 << 1)
> +
> +#define        MAX_12BIT                       ((1 << 12) - 1)
> +
> +#define ADC_ON_12BIT   (TSC2007_12BIT | TSC2007_ADC_ON_IRQ_DIS0)
> +
> +#define READ_Y         (ADC_ON_12BIT | TSC2007_MEASURE_Y)
> +#define READ_Z1                (ADC_ON_12BIT | TSC2007_MEASURE_Z1)
> +#define READ_Z2                (ADC_ON_12BIT | TSC2007_MEASURE_Z2)
> +#define READ_X         (ADC_ON_12BIT | TSC2007_MEASURE_X)
> +#define PWRDOWN                (TSC2007_12BIT | TSC2007_POWER_OFF_IRQ_EN)
> +
> +struct ts_event {
> +       u16     x;
> +       u16     y;
> +       u16     z1, z2;
> +};
> +
> +struct tsc2007 {
> +       struct input_dev        *input;
> +       char                    phys[32];
> +       struct hrtimer          timer;
> +       struct ts_event         tc;
> +
> +       struct i2c_client       *client;
> +
> +       spinlock_t              lock;
> +
> +       u16                     model;
> +       u16                     x_plate_ohms;
> +
> +       unsigned                pendown;
> +       int                     irq;
> +
> +       int                     (*get_pendown_state)(void);
> +       void                    (*clear_penirq)(void);
> +};
> +
> +static int tsc2007_xfer(void *tsc, unsigned char cmd)
> +{
> +       struct tsc2007    *ts     = tsc;
> +       struct i2c_client *client = ts->client;
> +
> +       unsigned char  rbuf[2];
> +       unsigned short val;
> +       int result;
> +
> +       result = i2c_master_send(client, &cmd, 1);
> +       if (result != 1) {
> +               dev_err(&client->dev, "send failed, cmd 0x%x\n", cmd);
> +               goto cmd_fail;
> +       }
> +
> +       result = i2c_master_recv(client, rbuf, 2);
> +       if (result != 2) {
> +               dev_err(&client->dev, "recv failed, cmd 0x%x\n", cmd);
> +               goto cmd_fail;
> +       }
> +
> +       rbuf[1] = (rbuf[1] >> 4) | ((rbuf[0] & 0x0f) << 4);
> +       rbuf[0] = rbuf[0] >> 4;
> +
> +       val = *((unsigned short *) rbuf);
> +       val = be16_to_cpu(val);
> +
> +       dev_dbg(&client->dev, "cmd [0x%x], rbuf [0x%x, 0x%x] => val [%u]\n",
> +               cmd, rbuf[0], rbuf[1], val);
> +
> +       return (int) val;
> +
> +cmd_fail:
> +       return -EIO;
> +}
> +
> +static void tsc2007_send_event(void *tsc)
> +{
> +       struct tsc2007  *ts = tsc;
> +       u32             Rt;
> +       u16             x, y, z1, z2;
> +
> +       x = ts->tc.x;
> +       y = ts->tc.y;
> +       z1 = ts->tc.z1;
> +       z2 = ts->tc.z2;
> +
> +       /* range filtering */
> +       if (x == MAX_12BIT)
> +               x = 0;
> +
> +       if (likely(x && z1)) {
> +               /* compute touch pressure resistance using equation #1 */
> +               Rt = z2;
> +               Rt -= z1;
> +               Rt *= x;
> +               Rt *= ts->x_plate_ohms;
> +               Rt /= z1;
> +               Rt = (Rt + 2047) >> 12;
> +       } else
> +               Rt = 0;
> +
> +       /* Sample found inconsistent by debouncing or pressure is beyond
> +        * the maximum. Don't report it to user space, repeat at least
> +        * once more the measurement
> +        */
> +       if (Rt > MAX_12BIT) {
> +               dev_dbg(&ts->client->dev, "ignored pressure %d\n", Rt);
> +
> +               hrtimer_start(&ts->timer, ktime_set(0, TS_POLL_PERIOD),
> +                             HRTIMER_MODE_REL);
> +               return;
> +       }
> +
> +       /* NOTE: We can't rely on the pressure to determine the pen down
> +        * state, even this controller has a pressure sensor.  The pressure
> +        * value can fluctuate for quite a while after lifting the pen and
> +        * in some cases may not even settle at the expected value.
> +        *
> +        * The only safe way to check for the pen up condition is in the
> +        * timer by reading the pen signal state (it's a GPIO _and_ IRQ).
> +        */
> +       if (Rt) {
> +               struct input_dev *input = ts->input;
> +
> +               if (!ts->pendown) {
> +                       dev_dbg(&ts->client->dev, "DOWN\n");
> +
> +                       input_report_key(input, BTN_TOUCH, 1);
> +                       ts->pendown = 1;
> +               }
> +
> +               input_report_abs(input, ABS_X, x);
> +               input_report_abs(input, ABS_Y, y);
> +               input_report_abs(input, ABS_PRESSURE, Rt);
> +
> +               input_sync(input);
> +
> +               dev_dbg(&ts->client->dev, "point(%4d,%4d), pressure (%4u)\n",
> +                       x, y, Rt);
> +       }
> +
> +       hrtimer_start(&ts->timer, ktime_set(0, TS_POLL_PERIOD),
> +                       HRTIMER_MODE_REL);
> +}
> +
> +static int tsc2007_read_values(struct tsc2007 *tsc)
> +{
> +       struct tsc2007  *ts = tsc;
> +
> +       /* y- still on; turn on only y+ (and ADC) */
> +       ts->tc.y = tsc2007_xfer(ts, READ_Y);
> +
> +       /* turn y- off, x+ on, then leave in lowpower */
> +       ts->tc.x = tsc2007_xfer(ts, READ_X);
> +
> +       /* turn y+ off, x- on; we'll use formula #1 */
> +       ts->tc.z1 = tsc2007_xfer(ts, READ_Z1);
> +       ts->tc.z2 = tsc2007_xfer(ts, READ_Z2);
> +
> +       /* power down */
> +       tsc2007_xfer(ts, PWRDOWN);
> +       return 0;
> +}
> +
> +static enum hrtimer_restart tsc2007_timer(struct hrtimer *handle)
> +{
> +       struct tsc2007  *ts = container_of(handle, struct tsc2007, timer);
> +
> +       spin_lock_irq(&ts->lock);
> +
> +       if (unlikely(!ts->get_pendown_state() && ts->pendown)) {
> +               struct input_dev *input = ts->input;
> +
> +               dev_dbg(&ts->client->dev, "UP\n");
> +
> +               input_report_key(input, BTN_TOUCH, 0);
> +               input_report_abs(input, ABS_PRESSURE, 0);
> +               input_sync(input);
> +
> +               ts->pendown = 0;
> +               enable_irq(ts->irq);
> +       } else {
> +               /* pen is still down, continue with the measurement */
> +               dev_dbg(&ts->client->dev, "pen is still down\n");
> +
> +               tsc2007_read_values(ts);
> +               tsc2007_send_event(ts);
> +       }
> +
> +       spin_unlock_irq(&ts->lock);
> +       return HRTIMER_NORESTART;
> +}
> +
> +static irqreturn_t tsc2007_irq(int irq, void *handle)
> +{
> +       struct tsc2007 *ts = handle;
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&ts->lock, flags);
> +       if (likely(ts->get_pendown_state())) {
> +               disable_irq(ts->irq);
> +               hrtimer_start(&ts->timer, ktime_set(0, TS_POLL_DELAY),
> +                                       HRTIMER_MODE_REL);
> +       }
> +
> +       if (ts->clear_penirq)
> +               ts->clear_penirq();
> +
> +       spin_unlock_irqrestore(&ts->lock, flags);
> +
> +       return IRQ_HANDLED;
> +}
> +
> +static int tsc2007_probe(struct i2c_client *client,
> +                       const struct i2c_device_id *id)
> +{
> +       struct i2c_adapter      *adapter = to_i2c_adapter(client->dev.parent);
> +       struct tsc2007          *ts;
> +       struct tsc2007_platform_data *pdata;
> +       struct input_dev        *input_dev;
> +       int                     err;
> +
> +       pdata = client->dev.platform_data;
> +       if (pdata == NULL) {
> +               dev_err(&client->dev, "platform data is required!\n");
> +               return -EINVAL;
> +       }
> +
> +       if (!i2c_check_functionality(adapter,
> +                       I2C_FUNC_I2C | I2C_FUNC_SMBUS_WRITE_BYTE_DATA))
> +               return -EIO;
> +
> +       ts = kzalloc(sizeof(struct tsc2007), GFP_KERNEL);
> +       input_dev = input_allocate_device();
> +       if (!ts || !input_dev) {
> +               err = -ENOMEM;
> +               goto err_free_mem;
> +       }
> +
> +       ts->client = client;
> +       i2c_set_clientdata(client, ts);
> +
> +       ts->input = input_dev;
> +
> +       hrtimer_init(&ts->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
> +       ts->timer.function = tsc2007_timer;
> +
> +       spin_lock_init(&ts->lock);
> +
> +       ts->model             = pdata->model;
> +       ts->x_plate_ohms      = pdata->x_plate_ohms;
> +       ts->get_pendown_state = pdata->get_pendown_state;
> +       ts->clear_penirq      = pdata->clear_penirq;
> +
> +       pdata->init_platform_hw();
> +
> +       snprintf(ts->phys, sizeof(ts->phys), "%s/input0", client->dev.bus_id);
> +
> +       input_dev->name = "TSC2007 Touchscreen";
> +       input_dev->phys = ts->phys;
> +
> +       input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
> +       input_dev->keybit[BIT_WORD(BTN_TOUCH)] = BIT_MASK(BTN_TOUCH);
> +
> +       input_set_abs_params(input_dev, ABS_X, 0, MAX_12BIT, 0, 0);
> +       input_set_abs_params(input_dev, ABS_Y, 0, MAX_12BIT, 0, 0);
> +       input_set_abs_params(input_dev, ABS_PRESSURE, 0, MAX_12BIT, 0, 0);
> +
> +       tsc2007_read_values(ts);
> +
> +       ts->irq = client->irq;
> +       if (request_irq(ts->irq, tsc2007_irq, 0,
> +                       client->dev.driver->name, ts)) {
> +               dev_err(&client->dev, "irq %d busy?\n", ts->irq);
> +               err = -EBUSY;
> +               goto err_free_mem;
> +       }
> +
> +       err = input_register_device(input_dev);
> +       if (err)
> +               goto err_free_irq;
> +
> +       dev_info(&client->dev, "registered with irq (%d)\n", ts->irq);
> +
> +       return 0;
> +
> + err_free_irq:
> +       free_irq(ts->irq, ts);
> + err_free_mem:
> +       input_free_device(input_dev);
> +       kfree(ts);
> +       return err;
> +}
> +
> +static int tsc2007_remove(struct i2c_client *client)
> +{
> +       struct tsc2007  *ts = i2c_get_clientdata(client);
> +       struct tsc2007_platform_data *pdata;
> +
> +       pdata = client->dev.platform_data;
> +       pdata->exit_platform_hw();
> +
> +       input_unregister_device(ts->input);
> +       free_irq(ts->irq, ts);
> +       kfree(ts);
> +
> +       dev_info(&client->dev, "unregistered\n");
> +       return 0;
> +}
> +
> +static struct i2c_device_id tsc2007_idtable[] = {
> +       { "tsc2007", 0 },
> +       { }
> +};
> +
> +MODULE_DEVICE_TABLE(i2c, tsc2007_idtable);
> +
> +static struct i2c_driver tsc2007_driver = {
> +       .driver         = {
> +               .owner          = THIS_MODULE,
> +               .name           = "tsc2007"
> +       },
> +       .id_table       = tsc2007_idtable,
> +       .probe          = tsc2007_probe,
> +       .remove         = tsc2007_remove,
> +};
> +
> +static int __init tsc2007_init(void)
> +{
> +       return i2c_add_driver(&tsc2007_driver);
> +}
> +
> +static void __exit tsc2007_exit(void)
> +{
> +       i2c_del_driver(&tsc2007_driver);
> +}
> +
> +module_init(tsc2007_init);
> +module_exit(tsc2007_exit);
> +
> +MODULE_AUTHOR("Kwangwoo Lee <kwlee@mtekvision.com>");
> +MODULE_DESCRIPTION("TSC2007 TouchScreen Driver");
> +MODULE_LICENSE("GPL");
> diff --git a/include/linux/i2c/tsc2007.h b/include/linux/i2c/tsc2007.h
> new file mode 100644
> index 0000000..c6361fb
> --- /dev/null
> +++ b/include/linux/i2c/tsc2007.h
> @@ -0,0 +1,17 @@
> +#ifndef __LINUX_I2C_TSC2007_H
> +#define __LINUX_I2C_TSC2007_H
> +
> +/* linux/i2c/tsc2007.h */
> +
> +struct tsc2007_platform_data {
> +       u16     model;                          /* 2007. */
> +       u16     x_plate_ohms;
> +
> +       int     (*get_pendown_state)(void);
> +       void    (*clear_penirq)(void);          /* If needed, clear 2nd level
> +                                                  interrupt source */
> +       int     (*init_platform_hw)(void);
> +       void    (*exit_platform_hw)(void);
> +};
> +
> +#endif
> --
> 1.5.6.5
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
