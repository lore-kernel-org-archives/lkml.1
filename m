Return-Path: <linux-kernel-owner+w=401wt.eu-S1760214AbZD2NXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760214AbZD2NXp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 09:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757018AbZD2NXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 09:23:11 -0400
Received: from mail-qy0-f196.google.com ([209.85.221.196]:37000 "EHLO
	mail-qy0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255AbZD2NXG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 09:23:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AuPGS6zl2WeBEY64xl/aE1wHUJ1jBIWweqr9PBw1D8BBJVcaChiqNoGMIO1pfdgdH8
         ue0YQHgekPg/BoAq4aiDqvuZntomcSys0bEUHI1NlgKyq2n5GxHeSIDnrNrf2NRnmaOW
         JfgcMyuG/SiDXWH/8fNRo7v2e8eGy6W1pGZ+U=
MIME-Version: 1.0
In-Reply-To: <1241006627-22811-1-git-send-email-thierry.reding@avionic-design.de>
References: <1241006627-22811-1-git-send-email-thierry.reding@avionic-design.de>
Date: Wed, 29 Apr 2009 18:53:04 +0530
Message-ID: <5d5443650904290623n3712cd7dja653a139cff2cf6d@mail.gmail.com>
Subject: Re: [PATCH] input: Add support for the TSC2003 controller.
From: Trilok Soni <soni.trilok@gmail.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry,

I have added linux-omap community. How different is this chip from
tsc2007. It looks to me that this chip is not much different from
tsc2007 (this is just quick look at the driver). If they
are similar please consider using i2c_device_id feature in tsc2007 to
accommodate this chip.

---Trilok Soni

On Wed, Apr 29, 2009 at 5:33 PM, Thierry Reding
<thierry.reding@avionic-design.de> wrote:
> This patch implements touchscreen support for the TSC2003 controller. There is
> no support for the temperature sensor yet.
>
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
>
> ---
>  drivers/input/touchscreen/Kconfig   |    8 +
>  drivers/input/touchscreen/Makefile  |    1 +
>  drivers/input/touchscreen/tsc2003.c |  416 +++++++++++++++++++++++++++++++++++
>  include/linux/i2c/tsc2003.h         |   28 +++
>  4 files changed, 453 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
> index b01fd61..87b980c 100644
> --- a/drivers/input/touchscreen/Kconfig
> +++ b/drivers/input/touchscreen/Kconfig
> @@ -455,6 +455,14 @@ config TOUCHSCREEN_TOUCHIT213
>          To compile this driver as a module, choose M here: the
>          module will be called touchit213.
>
> +config TOUCHSCREEN_TSC2003
> +       tristate "Texas Instruments TSC2003 Touchscreen Controller"
> +       depends on I2C
> +       ---help---
> +         If you say yes here you get support for the Texas Instruments
> +         TSC2003 Touchscreen Controller with on-chip temperature
> +         measurement.
> +
>  config TOUCHSCREEN_TSC2007
>        tristate "TSC2007 based touchscreens"
>        depends on I2C
> diff --git a/drivers/input/touchscreen/Makefile b/drivers/input/touchscreen/Makefile
> index 6700f7b..e965422 100644
> --- a/drivers/input/touchscreen/Makefile
> +++ b/drivers/input/touchscreen/Makefile
> @@ -27,6 +27,7 @@ obj-$(CONFIG_TOUCHSCREEN_PENMOUNT)    += penmount.o
>  obj-$(CONFIG_TOUCHSCREEN_TOUCHIT213)   += touchit213.o
>  obj-$(CONFIG_TOUCHSCREEN_TOUCHRIGHT)   += touchright.o
>  obj-$(CONFIG_TOUCHSCREEN_TOUCHWIN)     += touchwin.o
> +obj-$(CONFIG_TOUCHSCREEN_TSC2003)      += tsc2003.o
>  obj-$(CONFIG_TOUCHSCREEN_TSC2007)      += tsc2007.o
>  obj-$(CONFIG_TOUCHSCREEN_UCB1400)      += ucb1400_ts.o
>  obj-$(CONFIG_TOUCHSCREEN_WACOM_W8001)  += wacom_w8001.o
> diff --git a/drivers/input/touchscreen/tsc2003.c b/drivers/input/touchscreen/tsc2003.c
> new file mode 100644
> index 0000000..5acaa0d
> --- /dev/null
> +++ b/drivers/input/touchscreen/tsc2003.c
> @@ -0,0 +1,416 @@
> +/*
> + * linux/drivers/input/touchscreen/tsc2003.c
> + *
> + * Copyright (C) 2007-2008 Avionic Design Development GmbH
> + * Copyright (C) 2008-2009 Avionic Design GmbH
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * Written by Thierry Reding <thierry.reding@avionic-design.de>
> + */
> +
> +#include <linux/delay.h>
> +#include <linux/i2c.h>
> +#include <linux/input.h>
> +#include <linux/interrupt.h>
> +#include <linux/i2c/tsc2003.h>
> +
> +#define        DRIVER_NAME     "tsc2003"
> +#define        DRIVER_VERSION  "1"
> +
> +/* basic commands */
> +#define        CMD_MEASURE_TEMPERATURE_0       0x00
> +#define        CMD_MEASURE_BATTERY_1           0x10
> +#define        CMD_MEASURE_INPUT_1             0x20
> +#define        CMD_MEASURE_TEMPERATURE_1       0x40
> +#define        CMD_MEASURE_BATTERY_2           0x50
> +#define        CMD_MEASURE_INPUT_2             0x60
> +#define        CMD_ACTIVATE_X                  0x80
> +#define        CMD_ACTIVATE_Y                  0x90
> +#define        CMD_ACTIVATE_XY                 0xA0
> +#define        CMD_MEASURE_X                   0xC0
> +#define        CMD_MEASURE_Y                   0xD0
> +#define        CMD_MEASURE_Z1                  0xE0
> +#define        CMD_MEASURE_Z2                  0xF0
> +
> +/* powerdown modes */
> +#define        PDM_POWERDOWN                   0x00
> +#define        PDM_IR_OFF_ADC_ON               0x04
> +#define        PDM_IR_ON_ADC_OFF               0x08
> +#define        PDM_IR_ON_ADC_ON                0x0A
> +#define        PDM_TOUCH_IRQ_OFF               0x04
> +
> +/* data width modes */
> +#define        MODE_12BIT                      0x00
> +#define        MODE_8BIT                       0x02
> +
> +/* periodic polling delay and period */
> +#define        TS_POLL_DELAY   (1 * 1000000)
> +#define        TS_POLL_PERIOD  (5 * 1000000)
> +
> +/**
> + * struct ts_event - touchscreen event structure
> + * @pendown:   state of the pen
> + * @x:         X-coordinate of the event
> + * @y:         Y-coordinate of the event
> + * @z:         pressure of the event
> + */
> +struct ts_event {
> +       short pendown;
> +       short x;
> +       short y;
> +       short z;
> +};
> +
> +/**
> + * struct tsc2003 - touchscreen controller context
> + * @client:    I2C client
> + * @input:     touchscreen input device
> + * @lock:      lock for resource protection
> + * @timer:     timer for periodical polling
> + * @work:      workqueue structure
> + * @pendown:   current pen state
> + * @event:     current touchscreen event
> + * @pdata:     platform-specific information
> + */
> +struct tsc2003 {
> +       struct i2c_client *client;
> +       struct input_dev *input;
> +       spinlock_t lock;
> +       struct hrtimer timer;
> +       struct work_struct work;
> +
> +       struct ts_event event;
> +       unsigned pendown:1;
> +
> +       struct tsc2003_platform_data *pdata;
> +};
> +
> +/**
> + * tsc2003_get_pendown_state() - obtain the current pen state
> + * @ts:                touchscreen controller context
> + */
> +static int tsc2003_get_pendown_state(struct tsc2003 *ts)
> +{
> +       int state = 0;
> +
> +       if (ts && ts->pdata && ts->pdata->get_irq_level)
> +               state = !ts->pdata->get_irq_level();
> +
> +       return state;
> +}
> +
> +/**
> + * tsc2003_read() - send a command and read the response
> + * @client:    I2C client
> + * @command:   command to send
> + */
> +static int tsc2003_read(struct i2c_client *client, u8 command)
> +{
> +       u8 value[2] = { 0, 0 };
> +       int size = 2;
> +       int status;
> +
> +       command &= ~MODE_8BIT;
> +
> +       status = i2c_master_send(client, &command, 1);
> +       if (status < 0)
> +               return status;
> +
> +       if (command & MODE_8BIT)
> +               size = 1;
> +
> +       status = i2c_master_recv(client, value, size);
> +       if (status < 0)
> +               return status;
> +
> +       if (command & MODE_8BIT)
> +               return value[0];
> +
> +       return (value[0] << 4) | (value[1] >> 4);
> +}
> +
> +/**
> + * tsc2003_read_x() - read touch screen X-coordinate
> + * @client:    I2C client
> + * @pdm:       powerdown mode
> + * @samples:   number of samples to average over
> + */
> +static int tsc2003_read_x(struct i2c_client *client, u8 pdm, int samples)
> +{
> +       return tsc2003_read(client, CMD_MEASURE_X | pdm);
> +}
> +
> +/**
> + * tsc2003_read_y() - read touch screen Y-coordinate
> + * @client:    I2C client
> + * @pdm:       powerdown mode
> + * @samples:   number of samples to average over
> + */
> +static int tsc2003_read_y(struct i2c_client *client, u8 pdm, int samples)
> +{
> +       return tsc2003_read(client, CMD_MEASURE_Y | pdm);
> +}
> +
> +/**
> + * tsc2003_read_z() - read touch screen pressure
> + * @client:    I2C client
> + * @pdm:       powerdown mode
> + * @samples:   number of samples to average over
> + */
> +static int tsc2003_read_z(struct i2c_client *client, u8 pdm, int samples)
> +{
> +       int p1 = tsc2003_read(client, CMD_MEASURE_Z1 | pdm);
> +       int p2 = tsc2003_read(client, CMD_MEASURE_Z2 | pdm);
> +
> +       p2 = 0;
> +
> +       return p1;
> +}
> +
> +/**
> + * tsc2003_timer() - timer callback function
> + * @timer:     timer that caused this function call
> + */
> +static enum hrtimer_restart tsc2003_timer(struct hrtimer *timer)
> +{
> +       struct tsc2003 *ts = container_of(timer, struct tsc2003, timer);
> +       unsigned long flags = 0;
> +       int state = 0;
> +
> +       spin_lock_irqsave(&ts->lock, flags);
> +
> +       state = tsc2003_get_pendown_state(ts);
> +       if (state) {
> +               /* reset if this is the first pen down event */
> +               if (!ts->pendown) {
> +                       ts->event.pendown = 0;
> +                       ts->pendown = 1;
> +               }
> +
> +               schedule_work(&ts->work);
> +       } else {
> +               /* enable IRQ after the pen was lifted */
> +               if (ts->pendown)
> +                       ts->pendown = 0;
> +
> +               input_report_key(ts->input, BTN_TOUCH, 0);
> +               input_report_abs(ts->input, ABS_PRESSURE, 0);
> +               input_sync(ts->input);
> +
> +               enable_irq(ts->client->irq);
> +       }
> +
> +       spin_unlock_irqrestore(&ts->lock, flags);
> +       return HRTIMER_NORESTART;
> +}
> +
> +/**
> + * tsc2003_work() - work queue handler (initiated by the interrupt handler)
> + * @work:      work queue to handle
> + */
> +static void tsc2003_work(struct work_struct *work)
> +{
> +       struct tsc2003 *ts = container_of(work, struct tsc2003, work);
> +
> +       /* report only the first pen down event */
> +       if (!ts->event.pendown) {
> +               input_report_key(ts->input, BTN_TOUCH, 1);
> +               ts->event.pendown = 1;
> +       }
> +
> +       /* read X- and Y-coordinates and the pressure */
> +       ts->event.x = tsc2003_read_x(ts->client, PDM_POWERDOWN, 1);
> +       ts->event.y = tsc2003_read_y(ts->client, PDM_POWERDOWN, 1);
> +       ts->event.z = tsc2003_read_z(ts->client, PDM_POWERDOWN, 1);
> +
> +       /* report X- and Y-coordinates and the pressure */
> +       input_report_abs(ts->input, ABS_X, ts->event.x);
> +       input_report_abs(ts->input, ABS_Y, ts->event.y);
> +       input_report_abs(ts->input, ABS_PRESSURE, ts->event.z);
> +       input_sync(ts->input);
> +
> +       /* restart the timer */
> +       hrtimer_start(&ts->timer, ktime_set(0, TS_POLL_PERIOD),
> +                       HRTIMER_MODE_REL);
> +}
> +
> +/**
> + * tsc2003_interrupt() - interrupt handler for touch events
> + * @irq:       interrupt to handle
> + * @dev_id:    device-specific information
> + */
> +static irqreturn_t tsc2003_interrupt(int irq, void *dev_id)
> +{
> +       struct i2c_client *client = (struct i2c_client *)dev_id;
> +       struct tsc2003 *ts = i2c_get_clientdata(client);
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&ts->lock, flags);
> +
> +       /* if the pen is down, disable IRQ and start timer chain */
> +       if (tsc2003_get_pendown_state(ts)) {
> +               disable_irq_nosync(client->irq);
> +               hrtimer_start(&ts->timer, ktime_set(0, TS_POLL_DELAY),
> +                               HRTIMER_MODE_REL);
> +       }
> +
> +       spin_unlock_irqrestore(&ts->lock, flags);
> +       return IRQ_HANDLED;
> +}
> +
> +/**
> + * tsc2003_probe() - initialize the I2C client
> + * @client:    client to initialize
> + * @id:                I2C device ID
> + */
> +static int tsc2003_probe(struct i2c_client *client,
> +               const struct i2c_device_id *id)
> +{
> +       struct tsc2003 *ts;
> +       int err = 0;
> +
> +       ts = kzalloc(sizeof(*ts), GFP_KERNEL);
> +       if (!ts) {
> +               err = -ENOMEM;
> +               goto fail;
> +       }
> +
> +       ts->client = client;
> +
> +       ts->input = input_allocate_device();
> +       if (!ts->input) {
> +               err = -ENOMEM;
> +               goto fail;
> +       }
> +
> +       /* setup the input device */
> +       ts->input->name = "Texas Instruments TSC2003 I2C Touchscreen";
> +       ts->input->phys = DRIVER_NAME "/input0";
> +       ts->input->id.bustype = BUS_I2C;
> +       ts->input->dev.parent = &client->dev;
> +
> +       ts->input->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
> +       ts->input->keybit[BIT_WORD(BTN_TOUCH)] = BIT_MASK(BTN_TOUCH);
> +       input_set_abs_params(ts->input, ABS_X, 0, 0x3ff, 0, 0);
> +       input_set_abs_params(ts->input, ABS_Y, 0, 0x3ff, 0, 0);
> +       input_set_abs_params(ts->input, ABS_PRESSURE, 0, 0x3ff, 0, 0);
> +
> +       /* setup platform-specific hooks */
> +       ts->pdata = client->dev.platform_data;
> +       if (!ts->pdata || !ts->pdata->init_irq || !ts->pdata->get_irq_level) {
> +               dev_err(&client->dev, "no platform-specific callbacks "
> +                               "provided\n");
> +               err = -ENXIO;
> +               goto fail;
> +       }
> +
> +       if (ts->pdata->init_irq) {
> +               err = ts->pdata->init_irq();
> +               if (err < 0) {
> +                       dev_err(&client->dev, "failed to initialize IRQ#%d: "
> +                                       "%d\n", client->irq, err);
> +                       goto fail;
> +               }
> +       }
> +
> +       spin_lock_init(&ts->lock);
> +       hrtimer_init(&ts->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
> +       ts->timer.function = tsc2003_timer;
> +       INIT_WORK(&ts->work, tsc2003_work);
> +       ts->pendown = 0;
> +
> +       err = request_irq(client->irq, tsc2003_interrupt, IRQF_SHARED,
> +                       "TSC2003 Touch Screen", client);
> +       if (err) {
> +               dev_err(&client->dev, "failed to request IRQ#%d: %d\n",
> +                               client->irq, err);
> +               goto fail;
> +       }
> +
> +       i2c_set_clientdata(client, ts);
> +
> +       err = input_register_device(ts->input);
> +       if (err) {
> +               dev_err(&client->dev, "failed to register input device: %d\n",
> +                               err);
> +               goto fail_irq;
> +       }
> +
> +       /* dummy read; necessary to enable the pen IRQ */
> +       (void)tsc2003_read_z(client, PDM_POWERDOWN, 1);
> +       err = 0;
> +       goto out;
> +
> +fail_irq:
> +       free_irq(client->irq, client);
> +
> +fail:
> +       if (ts) {
> +               input_free_device(ts->input);
> +               kfree(ts);
> +       }
> +
> +       i2c_set_clientdata(client, NULL);
> +out:
> +       return err;
> +}
> +
> +/**
> + * tsc2003_remove() - cleanup the I2C client
> + * @client:    client to clean up
> + */
> +static int tsc2003_remove(struct i2c_client *client)
> +{
> +       struct tsc2003 *priv = i2c_get_clientdata(client);
> +
> +       free_irq(client->irq, client);
> +       i2c_set_clientdata(client, NULL);
> +       input_unregister_device(priv->input);
> +       kfree(priv);
> +
> +       return 0;
> +}
> +
> +static const struct i2c_device_id tsc2003_ids[] = {
> +       { DRIVER_NAME, 0 },
> +       { }
> +};
> +
> +/* TSC2003 I2C driver */
> +static struct i2c_driver tsc2003_driver = {
> +       .driver = {
> +               .name = DRIVER_NAME,
> +               .owner = THIS_MODULE,
> +       },
> +       .probe = tsc2003_probe,
> +       .remove = __devexit_p(tsc2003_remove),
> +       .id_table = tsc2003_ids,
> +};
> +
> +/**
> + * tsc2003_init() - module initialization
> + */
> +static int __init tsc2003_init(void)
> +{
> +       return i2c_add_driver(&tsc2003_driver);
> +}
> +
> +/**
> + * tsc2003_exit() - module cleanup
> + */
> +static void __exit tsc2003_exit(void)
> +{
> +       i2c_del_driver(&tsc2003_driver);
> +}
> +
> +module_init(tsc2003_init);
> +module_exit(tsc2003_exit);
> +
> +MODULE_AUTHOR("Thierry Reding <thierry.reding@avionic-design.de>");
> +MODULE_DESCRIPTION("Texas Instruments TSC2003 I2C Touch Screen driver");
> +MODULE_LICENSE("GPL v2");
> +MODULE_VERSION(DRIVER_VERSION);
> +
> diff --git a/include/linux/i2c/tsc2003.h b/include/linux/i2c/tsc2003.h
> new file mode 100644
> index 0000000..45e6100
> --- /dev/null
> +++ b/include/linux/i2c/tsc2003.h
> @@ -0,0 +1,28 @@
> +/**
> + * linux/include/i2c/tsc2003.h
> + *
> + * Copyright (C) 2007-2008 Avionic Design Development GmbH
> + * Copyright (C) 2008-2009 Avionic Design GmbH
> + *
> + * This file is subject to the terms and conditions of the GNU General Public
> + * License. See the file COPYING in the main directory of this archive for
> + * more details.
> + *
> + * Written by Thierry Reding <thierry.reding@avionic-design.de>
> + */
> +
> +#ifndef LINUX_I2C_TSC2003_H
> +#define LINUX_I2C_TSC2003_H
> +
> +/**
> + * struct tsc2003_platform_data - platform-specific TSC2003 data
> + * @init_irq:          initialize interrupt
> + * @get_irq_level:     obtain current interrupt level
> + */
> +struct tsc2003_platform_data {
> +       int (*init_irq)(void);
> +       int (*get_irq_level)(void);
> +};
> +
> +#endif /* !LINUX_I2C_TSC2003_H */
> +
> --
> tg: (fb160d7..) adx/i2c/tsc2003 (depends on: adx/master)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
