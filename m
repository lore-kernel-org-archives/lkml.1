Return-Path: <linux-kernel-owner+w=401wt.eu-S1758583AbXJKN2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758583AbXJKN2l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 09:28:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756242AbXJKN2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 09:28:07 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:16123 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758687AbXJKN16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 09:27:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=d/JhwRzQSKrcUoj44tF5CUpV3mlV7UwDnZuslOLp3z0yAND/zXyXhrdtyc399rrC1efKIE/PCtA+efisvrMVjy8P+Hn4rybTN1l66lvgoRFN3tMVhkEhNQSJSwBnny785AZN4SBS0AFM2SHNRUN2JpDsSqt4qXyjl+Vm4y38mBE=
Message-ID: <d120d5000710110627x625476ccl6802cf5e97aa8533@mail.gmail.com>
Date: Thu, 11 Oct 2007 09:27:55 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Bryan Wu" <bryan.wu@analog.com>,
       "Michael Hennerich" <michael.hennerich@analog.com>
Subject: Re: [PATCH 2/3] Input/Touchscreen Driver: add support AD7877 touchscreen driver
Cc: linux-input@atrey.karlin.mff.cuni.cz,
       linux-joystick@atrey.karlin.mff.cuni.cz, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <1192098220-25828-3-git-send-email-bryan.wu@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1192098220-25828-1-git-send-email-bryan.wu@analog.com>
	 <1192098220-25828-3-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bryan, Michael,

On 10/11/07, Bryan Wu <bryan.wu@analog.com> wrote:
> +
> +static int gpio3 = 0;

No need to initialize.

> +
> +static int ad7877_read(struct device *dev, u16 reg)
> +{
> +       struct spi_device       *spi = to_spi_device(dev);
> +       struct ser_req          *req = kzalloc(sizeof *req, GFP_KERNEL);

How many reads can happen at once? Maybe allocate 1 ser_req per
touchcsreen when creating it?

> +
> +       if (likely(x && z1 && !device_suspended(&ts->spi->dev))) {
> +               /* compute touch pressure resistance using equation #2 */
> +               Rt = z2;
> +               Rt -= z1;
> +               Rt *= x;
> +               Rt *= ts->x_plate_ohms;
> +               Rt /= z1;
> +               Rt = (Rt + 2047) >> 12;
> +       } else
> +               Rt = 0;
> +
> +       if (Rt) {
> +               input_report_abs(input_dev, ABS_X, x);
> +               input_report_abs(input_dev, ABS_Y, y);
> +               sync = 1;
> +       }
> +
> +       if (sync) {
> +               input_report_abs(input_dev, ABS_PRESSURE, Rt);
> +               input_sync(input_dev);
> +       }

Confused about the logic - you set sync only if Rt != 0 so why don't
fold second "if" into the first one?

> +/* Must be called with ts->lock held */
> +static void ad7877_disable(struct ad7877 *ts)
> +{
> +       if (ts->disabled)
> +               return;
> +
> +       ts->disabled = 1;
> +
> +       if (!ts->pending) {
> +               ts->irq_disabled = 1;
> +               disable_irq(ts->spi->irq);
> +       } else {
> +               /* the kthread will run at least once more, and
> +                * leave everything in a clean state, IRQ disabled
> +                */
> +               while (ts->pending) {
> +                       spin_unlock_irq(&ts->lock);
> +                       msleep(1);
> +                       spin_lock_irq(&ts->lock);
> +               }
> +       }
> +
> +       /* we know the chip's in lowpower mode since we always
> +        * leave it that way after every request
> +        */
> +
> +}

This looks scary. Can you try moving locking inside ad7877_enable and
ad7877_disable?

> +
> +static int __devinit ad7877_probe(struct spi_device *spi)
> +{
> +       struct ad7877                   *ts;
> +       struct input_dev                *input_dev;
> +       struct ad7877_platform_data     *pdata = spi->dev.platform_data;
> +       struct spi_message              *m;
> +       int                             err;
> +       u16                             verify;
> +
> +
> +       if (!spi->irq) {
> +               dev_dbg(&spi->dev, "no IRQ?\n");
> +               return -ENODEV;
> +       }
> +
> +
> +       if (!pdata) {
> +               dev_dbg(&spi->dev, "no platform data?\n");
> +               return -ENODEV;
> +       }
> +
> +
> +       /* don't exceed max specified SPI CLK frequency */
> +       if (spi->max_speed_hz > MAX_SPI_FREQ_HZ) {
> +               dev_dbg(&spi->dev, "SPI CLK %d Hz?\n",spi->max_speed_hz);
> +               return -EINVAL;
> +       }
> +
> +       ts = kzalloc(sizeof(struct ad7877), GFP_KERNEL);
> +       input_dev = input_allocate_device();
> +       if (!ts || !input_dev) {
> +               err = -ENOMEM;
> +               goto err_free_mem;
> +       }
> +
> +
> +       dev_set_drvdata(&spi->dev, ts);
> +       spi->dev.power.power_state = PMSG_ON;
> +
> +       ts->spi = spi;
> +       ts->input = input_dev;
> +       ts->intr_flag = 0;
> +       init_timer(&ts->timer);
> +       ts->timer.data = (unsigned long) ts;
> +       ts->timer.function = ad7877_timer;
> +
> +       spin_lock_init(&ts->lock);
> +
> +       ts->model = pdata->model ? : 7877;
> +       ts->vref_delay_usecs = pdata->vref_delay_usecs ? : 100;
> +       ts->x_plate_ohms = pdata->x_plate_ohms ? : 400;
> +       ts->pressure_max = pdata->pressure_max ? : ~0;
> +
> +
> +       ts->stopacq_polarity = pdata->stopacq_polarity;
> +       ts->first_conversion_delay = pdata->first_conversion_delay;
> +       ts->acquisition_time = pdata->acquisition_time;
> +       ts->averaging = pdata->averaging;
> +       ts->pen_down_acc_interval = pdata->pen_down_acc_interval;
> +
> +       snprintf(ts->phys, sizeof(ts->phys), "%s/input0", spi->dev.bus_id);
> +
> +       input_dev->name = "AD7877 Touchscreen";
> +       input_dev->phys = ts->phys;
> +       input_dev->cdev.dev = &spi->dev;

Please use input_dev->dev.parent, i will kill 'cdev' soon.

> +
> +       err = input_register_device(input_dev);
> +       if (err)
> +               goto err_remove_attr;
> +
> +       ts->intr_flag = 0;
> +
> +       ad7877_task = kthread_run(ad7877_thread, ts, "ad7877_ktsd");
> +
> +        if (IS_ERR(ad7877_task)) {
> +                printk(KERN_ERR "ts: Failed to start ad7877_task\n");
> +                goto err_remove_attr;

You shoudl use input_unregister_device() once it was registered. So
you need something like
             goto err_unregister_idev;
...
err_unregister_idev:
        input_unregister_device(input_dev);
        input-dve = NULL; /* so we don't try to free it later */
err_remove_attr:
...

> +        }
> +
> +       return 0;
> +
> + err_remove_attr:
> +
> +       sysfs_remove_group(&spi->dev.kobj, &ad7877_attr_group);
> +
> +       if(gpio3)
> +               device_remove_file(&spi->dev, &dev_attr_gpio3);
> +       else
> +               device_remove_file(&spi->dev, &dev_attr_aux3);
> +
> +
> +       free_irq(spi->irq, ts);
> + err_free_mem:
> +       input_free_device(input_dev);
> +       kfree(ts);
> +       return err;
> +}
> +
> +static int __devexit ad7877_remove(struct spi_device *spi)
> +{
> +       struct ad7877           *ts = dev_get_drvdata(&spi->dev);
> +
> +       input_unregister_device(ts->input);
> +
> +       ad7877_suspend(spi, PMSG_SUSPEND);
> +
> +       kthread_stop(ad7877_task);

You don't want to unregister device before stopping
interrupts/kthread. Otherwise there is a chance you will try to use
just freed device to send event through.

The driver also contains some indenting damage, please re-check.

Thanks!

-- 
Dmitry
