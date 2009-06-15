Return-Path: <linux-kernel-owner+w=401wt.eu-S933789AbZFOSP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933789AbZFOSP3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 14:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932145AbZFOSPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 14:15:09 -0400
Received: from mail-px0-f189.google.com ([209.85.216.189]:47504 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932173AbZFOSPF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 14:15:05 -0400
X-Greylist: delayed 300 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Jun 2009 14:15:04 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OA4IPgSsYNkF7CnYxwT/nWT0P0rNICT9q3NJ7JI6zFW1mUzjExusgMugeGIOWjxZEW
         JVB9pauUYsZ2EbYKXriATiv3AWBIT85UNmprSb0PtZ4mtOvwgMS7T1rwK/hxtmLKE656
         G1xy0gzRGD50edCtpx8bUKNJjY2s8U8OUnlKg=
MIME-Version: 1.0
In-Reply-To: <4A366439.70005@mocean-labs.com>
References: <4A366439.70005@mocean-labs.com>
Date: Mon, 15 Jun 2009 23:40:05 +0530
Message-ID: <5d5443650906151110u3f7d9d1cm1990e767d29a45b6@mail.gmail.com>
Subject: Re: [RESEND][PATCH] input: Added TSC2003
From: Trilok Soni <soni.trilok@gmail.com>
To: =?ISO-8859-1?Q?Richard_R=F6jfors?= 
	<richard.rojfors.ext@mocean-labs.com>
Cc: linux-input@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-omap@vger.kernel.org,
       Thierry Reding <thierry.reding@avionic-design.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jun 15, 2009 at 8:39 PM, Richard
Röjfors<richard.rojfors.ext@mocean-labs.com> wrote:
> Supplied is a driver for the TSC2003. There is actually a driver for TSC2007 which can be used in some cases.
> The platform struct is reused from the TSC2007.
> There is a big difference in the implementation between the drivers, this one does not use HR timers.
> The TSC2007 driver performs synchronous I2C in the timer callback (SW IRQ context) which is bad when
> the I2C driver is interrupt driven.
>

Meaning? I think I2C transaction can sleep. I don't see (right now)
need for two drivers. TSC2003 id was added to TSC2007. If you think
TSC2007 doesn't provide enough support for it, then please add that in
TSC2007 driver itself. We don't need create another driver it seems.

I have added Thierry who can further comment on it, as he has access
to device with TSC2003.

>
> Signed-off-by: Richard Röjfors <richard.rojfors.ext@mocean-labs.com>
> ---
> Index: linux-2.6.30-rc7/drivers/input/touchscreen/tsc2003.c
> ===================================================================
> --- linux-2.6.30-rc7/drivers/input/touchscreen/tsc2003.c        (revision 0)
> +++ linux-2.6.30-rc7/drivers/input/touchscreen/tsc2003.c        (revision 869)
> @@ -0,0 +1,387 @@
> +/*
> + * tsc2003.c Driver for TI TSC2003 touch screen controller
> + * Copyright (c) 2009 Intel Corporation
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +
> +/* Supports:
> + * TI TSC2003
> + *
> + * Inspired by tsc2007, Copyright (c) 2008 MtekVision Co., Ltd.
> + */
> +#include <linux/module.h>
> +#include <linux/input.h>
> +#include <linux/interrupt.h>
> +#include <linux/i2c.h>
> +#include <linux/i2c/tsc2007.h>
> +#include <linux/kthread.h>
> +#include <linux/semaphore.h>
> +
> +#define TSC2003_DRIVER_NAME            "tsc2003"
> +
> +#define TS_POLL_PERIOD 20              /* ms delay between samples */
> +
> +#define TSC2003_MEASURE_TEMP0          (0x0 << 4)
> +#define TSC2003_MEASURE_AUX            (0x2 << 4)
> +#define TSC2003_MEASURE_TEMP1          (0x4 << 4)
> +#define TSC2003_ACTIVATE_XN            (0x8 << 4)
> +#define TSC2003_ACTIVATE_YN            (0x9 << 4)
> +#define TSC2003_ACTIVATE_YP_XN         (0xa << 4)
> +#define TSC2003_SETUP                  (0xb << 4)
> +#define TSC2003_MEASURE_X              (0xc << 4)
> +#define TSC2003_MEASURE_Y              (0xd << 4)
> +#define TSC2003_MEASURE_Z1             (0xe << 4)
> +#define TSC2003_MEASURE_Z2             (0xf << 4)
> +
> +#define TSC2003_POWER_OFF_IRQ_EN       (0x0 << 2)
> +#define TSC2003_ADC_ON_IRQ_DIS0                (0x1 << 2)
> +#define TSC2003_ADC_OFF_IRQ_EN         (0x2 << 2)
> +#define TSC2003_ADC_ON_IRQ_DIS1                (0x3 << 2)
> +
> +#define TSC2003_12BIT                  (0x0 << 1)
> +#define TSC2003_8BIT                   (0x1 << 1)
> +
> +#define        MAX_12BIT                       ((1 << 12) - 1)
> +
> +#define ADC_ON_12BIT   (TSC2003_12BIT | TSC2003_ADC_ON_IRQ_DIS0)
> +
> +#define READ_Y         (ADC_ON_12BIT | TSC2003_MEASURE_Y)
> +#define READ_Z1                (ADC_ON_12BIT | TSC2003_MEASURE_Z1)
> +#define READ_Z2                (ADC_ON_12BIT | TSC2003_MEASURE_Z2)
> +#define READ_X         (ADC_ON_12BIT | TSC2003_MEASURE_X)
> +#define PWRDOWN                (TSC2003_12BIT | TSC2003_POWER_OFF_IRQ_EN)
> +
> +struct ts_event {
> +       int     x;
> +       int     y;
> +       int     z1, z2;
> +};
> +
> +struct tsc2003 {
> +       struct input_dev        *input;
> +       char                    phys[32];
> +       struct task_struct      *task;
> +       struct ts_event         tc;
> +       struct completion       penirq_completion;
> +
> +       struct i2c_client       *client;
> +
> +       u16                     model;
> +       u16                     x_plate_ohms;
> +
> +       unsigned                pendown;
> +};
> +
> +static inline int tsc2003_xfer(struct tsc2003 *tsc, u8 cmd)
> +{
> +       s32 data;
> +       u16 val;
> +
> +       data = i2c_smbus_read_word_data(tsc->client, cmd);
> +       if (data < 0) {
> +               dev_err(&tsc->client->dev, "i2c io error: %d\n", data);
> +               return data;
> +       }
> +
> +       /* The protocol and raw data format from i2c interface:
> +        * S Addr Wr [A] Comm [A] S Addr Rd [A] [DataLow] A [DataHigh] NA P
> +        * Where DataLow has [D11-D4], DataHigh has [D3-D0 << 4 | Dummy 4bit].
> +        */
> +       val = swab16(data) >> 4;
> +
> +       dev_dbg(&tsc->client->dev, "data: 0x%x, val: 0x%x\n", data, val);
> +
> +       return val;
> +}
> +
> +static void tsc2003_send_event(void *tsc)
> +{
> +       struct tsc2003  *ts = tsc;
> +       struct input_dev *input = ts->input;
> +       u32             rt = 0;
> +       u16             x, y, z1, z2;
> +
> +       x = ts->tc.x;
> +       y = ts->tc.y;
> +       z1 = ts->tc.z1;
> +       z2 = ts->tc.z2;
> +
> +       /* range filtering */
> +       if (x == MAX_12BIT)
> +               x = 0;
> +
> +       if (likely(x && z1)) {
> +               /* compute touch pressure resistance using equation #1 */
> +               rt = z2;
> +               rt -= z1;
> +               rt *= x;
> +               rt *= ts->x_plate_ohms;
> +               rt /= z1;
> +               rt = (rt + 2047) >> 12;
> +       }
> +
> +       /* Sample found inconsistent by debouncing or pressure is beyond
> +        * the maximum. Don't report it to user space, repeat at least
> +        * once more the measurement
> +        */
> +       if (rt > MAX_12BIT)
> +               return;
> +
> +       /* NOTE: We can't rely on the pressure to determine the pen down
> +        * state, even this controller has a pressure sensor.  The pressure
> +        * value can fluctuate for quite a while after lifting the pen and
> +        * in some cases may not even settle at the expected value.
> +        *
> +        * The only safe way to check for the pen up condition is in the
> +        * timer by reading the pen signal state (it's a GPIO _and_ IRQ).
> +        */
> +       if (rt) {
> +               if (!ts->pendown) {
> +                       dev_dbg(&ts->client->dev, "DOWN\n");
> +
> +                       input_report_key(input, BTN_TOUCH, 1);
> +                       ts->pendown = 1;
> +               }
> +
> +               input_report_abs(input, ABS_X, x);
> +               input_report_abs(input, ABS_Y, y);
> +               input_report_abs(input, ABS_PRESSURE, rt);
> +
> +               input_sync(input);
> +
> +               dev_dbg(&ts->client->dev, "point(%4d,%4d), pressure (%4u)\n",
> +                       x, y, rt);
> +       } else if (ts->pendown) {
> +               /* pen up */
> +               dev_dbg(&ts->client->dev, "UP\n");
> +               input_report_key(input, BTN_TOUCH, 0);
> +               input_report_abs(input, ABS_PRESSURE, 0);
> +               input_sync(input);
> +
> +               ts->pendown = 0;
> +       }
> +}
> +
> +static int tsc2003_power_off_irq_en(struct tsc2003 *tsc)
> +{
> +       /* power down */
> +       return tsc2003_xfer(tsc, PWRDOWN);
> +}
> +
> +static int tsc2003_read_values(struct tsc2003 *tsc)
> +{
> +       /* y- still on; turn on only y+ (and ADC) */
> +       tsc->tc.y = tsc2003_xfer(tsc, READ_Y);
> +       if (tsc->tc.y < 0)
> +               return tsc->tc.y;
> +
> +       /* turn y- off, x+ on, then leave in lowpower */
> +       tsc->tc.x = tsc2003_xfer(tsc, READ_X);
> +       if (tsc->tc.x < 0)
> +               return tsc->tc.x;
> +
> +       /* turn y+ off, x- on; we'll use formula #1 */
> +       tsc->tc.z1 = tsc2003_xfer(tsc, READ_Z1);
> +       if (tsc->tc.z1 < 0)
> +               return tsc->tc.z1;
> +
> +       tsc->tc.z2 = tsc2003_xfer(tsc, READ_Z2);
> +       if (tsc->tc.z2 < 0)
> +               return tsc->tc.z2;
> +
> +       return 0;
> +}
> +
> +
> +static irqreturn_t tsc2003_irq(int irq, void *handle)
> +{
> +       struct tsc2003 *ts = handle;
> +
> +       /* do not call the synced version -> deadlock */
> +       disable_irq_nosync(irq);
> +       /* signal the thread to continue */
> +       complete(&ts->penirq_completion);
> +
> +       return IRQ_HANDLED;
> +}
> +
> +static int tsc2003_thread(void *d)
> +{
> +       struct tsc2003 *ts = (struct tsc2003 *)d;
> +       int ret;
> +
> +       allow_signal(SIGKILL);
> +
> +       while (!signal_pending(current)) {
> +               /* power down and wait for interrupt */
> +               do {
> +                       /* loop because the I2C bus might be busy */
> +                       ret = msleep_interruptible(TS_POLL_PERIOD);
> +                       if (!ret)
> +                               ret = tsc2003_power_off_irq_en(ts);
> +               } while (ret == -EAGAIN && !signal_pending(current));
> +
> +               if (signal_pending(current))
> +                       break;
> +
> +               ret = wait_for_completion_interruptible(&ts->penirq_completion);
> +               if (!ret) {
> +                       int first = 1;
> +                       /* got IRQ, start poll, until pen is up */
> +                       while (!ret && !signal_pending(current)
> +                               && (first || ts->pendown)) {
> +                               ret = tsc2003_read_values(ts);
> +                               if (!ret)
> +                                       tsc2003_send_event(ts);
> +                               ret = msleep_interruptible(TS_POLL_PERIOD);
> +                               first = 0;
> +                       }
> +
> +                       /* we re enable the interrupt */
> +                       if (!signal_pending(current))
> +                               enable_irq(ts->client->irq);
> +               }
> +       }
> +
> +       return 0;
> +}
> +
> +static int tsc2003_probe(struct i2c_client *client,
> +                       const struct i2c_device_id *id)
> +{
> +       struct tsc2003 *ts;
> +       struct tsc2007_platform_data *pdata = client->dev.platform_data;
> +       struct input_dev *input_dev;
> +       int err;
> +
> +       if (!pdata) {
> +               dev_err(&client->dev, "platform data is required!\n");
> +               return -EINVAL;
> +       }
> +
> +       if (!i2c_check_functionality(client->adapter,
> +                                    I2C_FUNC_SMBUS_READ_WORD_DATA))
> +               return -EIO;
> +
> +       ts = kzalloc(sizeof(struct tsc2003), GFP_KERNEL);
> +       input_dev = input_allocate_device();
> +       if (!ts || !input_dev) {
> +               err = -ENOMEM;
> +               goto err_free_mem;
> +       }
> +
> +       ts->client = client;
> +       i2c_set_clientdata(client, ts);
> +
> +       ts->input = input_dev;
> +
> +       ts->model             = pdata->model;
> +       ts->x_plate_ohms      = pdata->x_plate_ohms;
> +
> +       snprintf(ts->phys, sizeof(ts->phys),
> +                "%s/input0", dev_name(&client->dev));
> +
> +       input_dev->name = TSC2003_DRIVER_NAME" Touchscreen";
> +       input_dev->phys = ts->phys;
> +       input_dev->id.bustype = BUS_I2C;
> +
> +       input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
> +       input_dev->keybit[BIT_WORD(BTN_TOUCH)] = BIT_MASK(BTN_TOUCH);
> +
> +       input_set_abs_params(input_dev, ABS_X, 0, MAX_12BIT, 0, 0);
> +       input_set_abs_params(input_dev, ABS_Y, 0, MAX_12BIT, 0, 0);
> +       input_set_abs_params(input_dev, ABS_PRESSURE, 0, MAX_12BIT, 0, 0);
> +
> +       init_completion(&ts->penirq_completion);
> +
> +       ts->task = kthread_run(tsc2003_thread, ts, TSC2003_DRIVER_NAME);
> +       if (IS_ERR(ts->task)) {
> +               err = PTR_ERR(ts->task);
> +               goto err_free_mem;
> +       }
> +
> +       err = request_irq(client->irq, tsc2003_irq, 0,
> +                       client->dev.driver->name, ts);
> +       if (err < 0) {
> +               dev_err(&client->dev, "irq %d busy?\n", client->irq);
> +               goto err_free_thread;
> +       }
> +
> +       err = input_register_device(input_dev);
> +       if (err)
> +               goto err_free_irq;
> +
> +       dev_info(&client->dev, "registered with irq (%d)\n", client->irq);
> +
> +       return 0;
> +
> + err_free_irq:
> +       free_irq(client->irq, ts);
> + err_free_thread:
> +       kthread_stop(ts->task);
> + err_free_mem:
> +       input_free_device(input_dev);
> +       kfree(ts);
> +       return err;
> +}
> +
> +static int tsc2003_remove(struct i2c_client *client)
> +{
> +       struct tsc2003 *ts = i2c_get_clientdata(client);
> +
> +       free_irq(client->irq, ts);
> +       send_sig(SIGKILL, ts->task, 1);
> +       kthread_stop(ts->task);
> +       input_unregister_device(ts->input);
> +       kfree(ts);
> +
> +       return 0;
> +}
> +
> +static struct i2c_device_id tsc2003_idtable[] = {
> +       { TSC2003_DRIVER_NAME, 0 },
> +       { }
> +};
> +
> +MODULE_DEVICE_TABLE(i2c, tsc2003_idtable);
> +
> +static struct i2c_driver tsc2003_driver = {
> +       .driver = {
> +               .owner  = THIS_MODULE,
> +               .name   = TSC2003_DRIVER_NAME,
> +               .bus = &i2c_bus_type,
> +       },
> +       .id_table       = tsc2003_idtable,
> +       .probe          = tsc2003_probe,
> +       .remove         = tsc2003_remove,
> +};
> +
> +static int __init tsc2003_init(void)
> +{
> +       return i2c_add_driver(&tsc2003_driver);
> +}
> +
> +static void __exit tsc2003_exit(void)
> +{
> +       i2c_del_driver(&tsc2003_driver);
> +}
> +
> +module_init(tsc2003_init);
> +module_exit(tsc2003_exit);
> +
> +MODULE_AUTHOR("Mocean Laboratories <info@mocean-labs.com>");
> +MODULE_DESCRIPTION("TSC2003 TouchScreen Driver");
> +MODULE_LICENSE("GPL v2");
> +
> Index: linux-2.6.30-rc7/drivers/input/touchscreen/Kconfig
> ===================================================================
> --- linux-2.6.30-rc7/drivers/input/touchscreen/Kconfig  (revision 861)
> +++ linux-2.6.30-rc7/drivers/input/touchscreen/Kconfig  (revision 869)
> @@ -455,6 +455,17 @@
>          To compile this driver as a module, choose M here: the
>          module will be called touchit213.
>
> +config TOUCHSCREEN_TSC2003
> +       tristate "TSC2003 based touchscreens"
> +       depends on I2C
> +       help
> +         Say Y here if you have a TSC2003 based touchscreen.
> +
> +         If unsure, say N.
> +
> +         To compile this driver as a module, choose M here: the
> +         module will be called tsc2003.
> +
>  config TOUCHSCREEN_TSC2007
>        tristate "TSC2007 based touchscreens"
>        depends on I2C
> Index: linux-2.6.30-rc7/drivers/input/touchscreen/Makefile
> ===================================================================
> --- linux-2.6.30-rc7/drivers/input/touchscreen/Makefile (revision 861)
> +++ linux-2.6.30-rc7/drivers/input/touchscreen/Makefile (revision 869)
> @@ -27,6 +27,7 @@
>  obj-$(CONFIG_TOUCHSCREEN_TOUCHIT213)   += touchit213.o
>  obj-$(CONFIG_TOUCHSCREEN_TOUCHRIGHT)   += touchright.o
>  obj-$(CONFIG_TOUCHSCREEN_TOUCHWIN)     += touchwin.o
> +obj-$(CONFIG_TOUCHSCREEN_TSC2003)      += tsc2003.o
>  obj-$(CONFIG_TOUCHSCREEN_TSC2007)      += tsc2007.o
>  obj-$(CONFIG_TOUCHSCREEN_UCB1400)      += ucb1400_ts.o
>  obj-$(CONFIG_TOUCHSCREEN_WACOM_W8001)  += wacom_w8001.o
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
