Return-Path: <linux-kernel-owner+w=401wt.eu-S1758034AbYB1HMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758034AbYB1HMe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 02:12:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756750AbYB1HMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 02:12:14 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:39052 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756481AbYB1HML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 02:12:11 -0500
Date: Wed, 27 Feb 2008 23:09:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Dmitry Torokhov <dtor@mail.ru>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Liam Girdwood <liam.girdwood@wolfsonmicro.com>,
       Graeme Gregory <gg@opensource.wolfsonmicro.com>,
       Mike Arthur <mike.arthur@wolfsonmicro.com>,
       Dmitry Baryshkov <dbaryshkov@gmail.com>,
       Stanley Cai <stanley.cai@intel.com>,
       Rodolfo Giometti <giometti@enneenne.com>,
       Russell King <rmk@arm.linux.org.uk>,
       Pete MacKay <linux01@architechnical.net>,
       Marc Kleine-Budde <mkl@pengutronix.de>, Ian Molton <spyro@f2s.com>,
       Vincent Sanders <vince@kyllikki.org>,
       Andrew Zabolotny <zap@homelink.ru>
Subject: Re: [PATCH 1/6] Core driver for WM97xx touchscreens
Message-Id: <20080227230928.993d424e.akpm@linux-foundation.org>
In-Reply-To: <12040332183316-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <12040332183316-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Feb 2008 13:40:13 +0000 Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> This patch series adds support for the touchscreen controllers provided
> by Wolfson Microelectronics WM97xx series chips in both polled and
> streaming modes.
> 
> These drivers have been maintained out of tree since 2003.  During that
> time the driver the primary maintainer was Liam Girdwood and a number of
> people have made contributions including Dmitry Baryshkov, Stanley Cai,
> Rodolfo Giometti, Russell King, Marc Kleine-Budde, Ian Molton, Vincent
> Sanders, Andrew Zabolotny, Graeme Gregory, Mike Arthur and myself.
> Apologies to anyone I have omitted.
> 

Nice looking drivers.

> ...
>
> +/*
> + * Handle a pen down interrupt.
> + */
> +static void wm97xx_pen_irq_worker(struct work_struct *work)
> +{
> +	struct wm97xx *wm = container_of(work, struct wm97xx, pen_event_work);
> +
> +	/* do we need to enable the touch panel reader */
> +	if (wm->id == WM9705_ID2) {
> +		if (wm97xx_reg_read(wm, AC97_WM97XX_DIGITISER_RD) &
> +					WM97XX_PEN_DOWN)
> +			wm->pen_is_down = 1;
> +		else
> +			wm->pen_is_down = 0;
> +	} else {
> +		u16 status, pol;
> +		mutex_lock(&wm->codec_mutex);
> +		status = wm97xx_reg_read(wm, AC97_GPIO_STATUS);
> +		pol = wm97xx_reg_read(wm, AC97_GPIO_POLARITY);
> +
> +		if (WM97XX_GPIO_13 & pol & status) {
> +			wm->pen_is_down = 1;
> +			wm97xx_reg_write(wm, AC97_GPIO_POLARITY, pol &
> +						~WM97XX_GPIO_13);
> +		} else {
> +			wm->pen_is_down = 0;
> +			wm97xx_reg_write(wm, AC97_GPIO_POLARITY, pol |
> +					 WM97XX_GPIO_13);
> +		}
> +
> +		if (wm->id == WM9712_ID2)
> +			wm97xx_reg_write(wm, AC97_GPIO_STATUS, (status &
> +						~WM97XX_GPIO_13) << 1);
> +		else
> +			wm97xx_reg_write(wm, AC97_GPIO_STATUS, status &
> +						~WM97XX_GPIO_13);
> +		mutex_unlock(&wm->codec_mutex);
> +	}
> +
> +	queue_delayed_work(wm->ts_workq, &wm->ts_reader, 0);

This is equvaltnet to queue_work().

Why queue the work instead of just callng it synchronously right here?

> +	if (!wm->pen_is_down && wm->mach_ops && wm->mach_ops->acc_enabled)
> +		wm->mach_ops->acc_pen_up(wm);
> +	wm->mach_ops->irq_enable(wm, 1);
> +}
> +
> +/*
> + * Codec PENDOWN irq handler
> + *
> + * We have to disable the codec interrupt in the handler because it can
> + * take upto 1ms to clear the interrupt source. The interrupt is then enabled
> + * again in the slow handler when the source has been cleared.
> + */
> +static irqreturn_t wm97xx_pen_interrupt(int irq, void *dev_id)
> +{
> +	struct wm97xx *wm = dev_id;
> +	wm->mach_ops->irq_enable(wm, 0);
> +	queue_work(wm->ts_workq, &wm->pen_event_work);
> +	return IRQ_HANDLED;
> +}

We can lose events, can't we?  We only have one work to queue, and if it is
already queued, the queue_work() here is a no-op.

otoh there's no payload so there's actually no data to lose.

Still, this stands out a bit and perhaps a comment which describes the
overall interrupt handling design would help here.

> +/*
> + * initialise pen IRQ handler and workqueue
> + */
> +static int wm97xx_init_pen_irq(struct wm97xx *wm)
> +{
> +	u16 reg;
> +
> +	/* If an interrupt is supplied an IRQ enable operation must also be
> +	 * provided. */
> +	BUG_ON(!wm->mach_ops->irq_enable);
> +
> +	INIT_WORK(&wm->pen_event_work, wm97xx_pen_irq_worker);
> +
> +	if (request_irq(wm->pen_irq, wm97xx_pen_interrupt, IRQF_SHARED,
> +			"wm97xx-pen", wm)) {
> +		dev_err(wm->dev,
> +			"Failed to register pen down interrupt, polling");
> +		wm->pen_irq = 0;
> +		return -EINVAL;
> +	}
> +
> +	/* enable PEN down on wm9712/13 */
> +	if (wm->id != WM9705_ID2) {
> +		reg = wm97xx_reg_read(wm, AC97_MISC_AFE);
> +		wm97xx_reg_write(wm, AC97_MISC_AFE, reg & 0xfffb);
> +		reg = wm97xx_reg_read(wm, 0x5a);
> +		wm97xx_reg_write(wm, 0x5a, reg & ~0x0001);
> +	}
> +
> +	return 0;
> +}
> +
> +static int wm97xx_read_samples(struct wm97xx *wm)
> +{
> +	struct wm97xx_data data;
> +	int rc;
> +
> +	mutex_lock(&wm->codec_mutex);
> +
> +	if (wm->mach_ops && wm->mach_ops->acc_enabled)
> +		rc = wm->mach_ops->acc_pen_down(wm);
> +	else
> +		rc = wm->codec->poll_touch(wm, &data);
> +
> +	if (rc & RC_PENUP) {
> +		if (wm->pen_is_down) {
> +			wm->pen_is_down = 0;
> +			dev_dbg(wm->dev, "pen up\n");
> +			input_report_abs(wm->input_dev, ABS_PRESSURE, 0);
> +			input_sync(wm->input_dev);
> +		} else if (!(rc & RC_AGAIN)) {
> +			/* We need high frequency updates only while
> +			* pen is down, the user never will be able to
> +			* touch screen faster than a few times per
> +			* second... On the other hand, when the user
> +			* is actively working with the touchscreen we
> +			* don't want to lose the quick response. So we
> +			* will slowly increase sleep time after the
> +			* pen is up and quicky restore it to ~one task
> +			* switch when pen is down again.
> +			*/
> +			if (wm->ts_reader_interval < HZ / 10)
> +				wm->ts_reader_interval++;
> +		}
> +
> +	} else if (rc & RC_VALID) {
> +		dev_dbg(wm->dev,
> +			"pen down: x=%x:%d, y=%x:%d, pressure=%x:%d\n",
> +			data.x >> 12, data.x & 0xfff, data.y >> 12,
> +			data.y & 0xfff, data.p >> 12, data.p & 0xfff);
> +		input_report_abs(wm->input_dev, ABS_X, data.x & 0xfff);
> +		input_report_abs(wm->input_dev, ABS_Y, data.y & 0xfff);
> +		input_report_abs(wm->input_dev, ABS_PRESSURE, data.p & 0xfff);
> +		input_sync(wm->input_dev);
> +		wm->pen_is_down = 1;
> +		wm->ts_reader_interval = wm->ts_reader_min_interval;
> +	} else if (rc & RC_PENDOWN) {
> +		dev_dbg(wm->dev, "pen down\n");
> +		wm->pen_is_down = 1;
> +		wm->ts_reader_interval = wm->ts_reader_min_interval;
> +	}
> +
> +	mutex_unlock(&wm->codec_mutex);
> +	return rc;
> +}
> +
> +/*
> +* The touchscreen sample reader.
> +*/
> +static void wm97xx_ts_reader(struct work_struct *work)
> +{
> +	int rc;
> +	struct wm97xx *wm = container_of(work, struct wm97xx, ts_reader.work);
> +
> +	BUG_ON(!wm->codec);
> +
> +	do {
> +		rc = wm97xx_read_samples(wm);
> +	} while (rc & RC_AGAIN);
> +
> +	if (wm->pen_is_down || !wm->pen_irq)
> +		queue_delayed_work(wm->ts_workq, &wm->ts_reader,
> +				   wm->ts_reader_interval);
> +}

again, if this work is already scheduled, your queue_delayed_work() here is
a no-op.  Will things all work correctly?

> +/**
> + *	wm97xx_ts_input_open - Open the touch screen input device.
> + *	@idev:	Input device to be opened.
> + *
> + *	Called by the input sub system to open a wm97xx touchscreen device.
> + *  Starts the touchscreen thread and touch digitiser.

A bit of whitecpace inconsistency there.

I don't understand why people use tabs to indent kerneldoc - all it does is
waste the space where you want to put text.  Shrug.

> + */
> +static int wm97xx_ts_input_open(struct input_dev *idev)
> +{
> +	struct wm97xx *wm = input_get_drvdata(idev);
> +
> +	wm->ts_workq = create_singlethread_workqueue("kwm97xx");
> +	if (wm->ts_workq == NULL) {
> +		dev_err(wm->dev,
> +			"Failed to create workqueue\n");
> +		return -EINVAL;
> +	}
> +
> +	/* start digitiser */
> +	if (wm->mach_ops && wm->mach_ops->acc_enabled)
> +		wm->codec->acc_enable(wm, 1);
> +	wm->codec->dig_enable(wm, 1);
> +
> +	INIT_DELAYED_WORK(&wm->ts_reader, wm97xx_ts_reader);
> +
> +	wm->ts_reader_min_interval = HZ >= 100 ? HZ / 100 : 1;
> +	if (wm->ts_reader_min_interval < 1)
> +		wm->ts_reader_min_interval = 1;
> +	wm->ts_reader_interval = wm->ts_reader_min_interval;
> +
> +	wm->pen_is_down = 0;
> +	if (wm->pen_irq)
> +		wm97xx_init_pen_irq(wm);
> +	else
> +		dev_err(wm->dev, "No IRQ specified\n");
> +
> +	/* If we either don't have an interrupt for pen down events or
> +	 * failed to acquire it then we need to poll.
> +	 */
> +	if (wm->pen_irq == 0)
> +		queue_delayed_work(wm->ts_workq, &wm->ts_reader,
> +				   wm->ts_reader_interval);
> +
> +	return 0;
> +}

So...  this driver continuously polls the hardware at 100HZ?  If so,
powertop users will come after you with pitchforks.

> +/**
> + *	wm97xx_ts_input_close - Close the touch screen input device.
> + *	@idev:	Input device to be closed.
> + *
> + *	Called by the input sub system to close a wm97xx touchscreen device.
> + *  Kills the touchscreen thread and stops the touch digitiser.
> + */
> +
> +static void wm97xx_ts_input_close(struct input_dev *idev)
> +{
> +	struct wm97xx *wm = input_get_drvdata(idev);
> +
> +	if (wm->pen_irq)
> +		free_irq(wm->pen_irq, wm);
> +
> +	wm->pen_is_down = 0;
> +
> +	/* ts_reader rearms itself so we need to explicitly stop it
> +	 * before we destroy the workqueue.
> +	 */
> +	cancel_delayed_work_sync(&wm->ts_reader);
> +	destroy_workqueue(wm->ts_workq);
> +
> +	/* stop digitiser */
> +	wm->codec->dig_enable(wm, 0);
> +	if (wm->mach_ops && wm->mach_ops->acc_enabled)
> +		wm->codec->acc_enable(wm, 0);
> +}
> +
> +static int wm97xx_probe(struct device *dev)
> +{
> +	struct wm97xx *wm;
> +	int ret = 0, id = 0;
> +
> +	wm = kzalloc(sizeof(struct wm97xx), GFP_KERNEL);
> +	if (!wm)
> +		return -ENOMEM;
> +	mutex_init(&wm->codec_mutex);
> +
> +	wm->dev = dev;
> +	dev->driver_data = wm;
> +	wm->ac97 = to_ac97_t(dev);
> +
> +	/* check that we have a supported codec */
> +	id = wm97xx_reg_read(wm, AC97_VENDOR_ID1);
> +	if (id != WM97XX_ID1) {
> +		dev_err(dev, "Device with vendor %04x is not a wm97xx\n", id);
> +		ret = -ENODEV;
> +		goto alloc_err;
> +	}
> +
> +	wm->id = wm97xx_reg_read(wm, AC97_VENDOR_ID2);
> +
> +	dev_info(wm->dev, "detected a wm97%02x codec\n", wm->id & 0xff);
> +
> +	switch (wm->id & 0xff) {
> +#ifdef CONFIG_TOUCHSCREEN_WM9705
> +	case 0x05:
> +		wm->codec = &wm9705_codec;
> +		break;
> +#endif
> +#ifdef CONFIG_TOUCHSCREEN_WM9712
> +	case 0x12:
> +		wm->codec = &wm9712_codec;
> +		break;
> +#endif
> +#ifdef CONFIG_TOUCHSCREEN_WM9713
> +	case 0x13:
> +		wm->codec = &wm9713_codec;
> +		break;
> +#endif

That's a wee bit combersome.  Really a "core" should not know about its
specific clients.  A better and more typical design would have the clients
registering themselves with the core via some registration interface.

> +	default:
> +		dev_err(wm->dev, "Support for wm97%02x not compiled in.\n",
> +			wm->id & 0xff);
> +		ret = -ENODEV;
> +		goto alloc_err;
> +	}
> +
> +	wm->input_dev = input_allocate_device();
> +	if (wm->input_dev == NULL) {
> +		ret = -ENOMEM;
> +		goto alloc_err;
> +	}
> +
> +	/* set up touch configuration */
> +	wm->input_dev->name = "wm97xx touchscreen";

spaces in names are OK here?  They can make proc files basically
unparseable.

> +	wm->input_dev->open = wm97xx_ts_input_open;
> +	wm->input_dev->close = wm97xx_ts_input_close;
> +	set_bit(EV_ABS, wm->input_dev->evbit);
> +	set_bit(ABS_X, wm->input_dev->absbit);
> +	set_bit(ABS_Y, wm->input_dev->absbit);
> +	set_bit(ABS_PRESSURE, wm->input_dev->absbit);
> +	input_set_abs_params(wm->input_dev, ABS_X, abs_x[0], abs_x[1],
> +			     abs_x[2], 0);
> +	input_set_abs_params(wm->input_dev, ABS_Y, abs_y[0], abs_y[1],
> +			     abs_y[2], 0);
> +	input_set_abs_params(wm->input_dev, ABS_PRESSURE, abs_p[0], abs_p[1],
> +			     abs_p[2], 0);
> +	input_set_drvdata(wm->input_dev, wm);
> +	wm->input_dev->dev.parent = dev;
> +	ret = input_register_device(wm->input_dev);
> +	if (ret < 0)
> +		goto dev_alloc_err;
> +
> +	/* set up physical characteristics */
> +	wm->codec->phy_init(wm);
> +
> +	/* load gpio cache */
> +	wm->gpio[0] = wm97xx_reg_read(wm, AC97_GPIO_CFG);
> +	wm->gpio[1] = wm97xx_reg_read(wm, AC97_GPIO_POLARITY);
> +	wm->gpio[2] = wm97xx_reg_read(wm, AC97_GPIO_STICKY);
> +	wm->gpio[3] = wm97xx_reg_read(wm, AC97_GPIO_WAKEUP);
> +	wm->gpio[4] = wm97xx_reg_read(wm, AC97_GPIO_STATUS);
> +	wm->gpio[5] = wm97xx_reg_read(wm, AC97_MISC_AFE);
> +
> +	/* register our battery device */
> +	wm->battery_dev = platform_device_alloc("wm97xx-battery", -1);
> +	if (!wm->battery_dev) {
> +		ret = -ENOMEM;
> +		goto batt_err;
> +	}
> +	platform_set_drvdata(wm->battery_dev, wm);
> +	wm->battery_dev->dev.parent = dev;
> +	ret = platform_device_add(wm->battery_dev);
> +	if (ret < 0)
> +		goto batt_reg_err;
> +
> +	/* register our extended touch device (for machine specific
> +	 * extensions) */
> +	wm->touch_dev = platform_device_alloc("wm97xx-touch", -1);
> +	if (!wm->touch_dev) {
> +		ret = -ENOMEM;
> +		goto touch_err;
> +	}
> +	platform_set_drvdata(wm->touch_dev, wm);
> +	wm->touch_dev->dev.parent = dev;
> +	ret = platform_device_add(wm->touch_dev);
> +	if (ret < 0)
> +		goto touch_reg_err;
> +
> +	return ret;
> +
> + touch_reg_err:
> +	platform_device_put(wm->touch_dev);
> + touch_err:
> +	platform_device_unregister(wm->battery_dev);
> +	wm->battery_dev = NULL;
> + batt_reg_err:
> +	platform_device_put(wm->battery_dev);
> + batt_err:
> +	input_unregister_device(wm->input_dev);
> +	wm->input_dev = NULL;
> + dev_alloc_err:
> +	input_free_device(wm->input_dev);
> + alloc_err:
> +	kfree(wm);
> +
> +	return ret;
> +}

The kernel->userspace interface looks fairly complex.  Is it documented
anywhere?

> +static int wm97xx_remove(struct device *dev)
> +{
> +	struct wm97xx *wm = dev_get_drvdata(dev);
> +
> +	platform_device_unregister(wm->battery_dev);
> +	platform_device_unregister(wm->touch_dev);
> +	input_unregister_device(wm->input_dev);
> +
> +	kfree(wm);
> +	return 0;
> +}
> +
> +#ifdef CONFIG_PM
> +static int wm97xx_resume(struct device *dev)
> +{
> +	struct wm97xx *wm = dev_get_drvdata(dev);
> +
> +	/* restore digitiser and gpios */
> +	if (wm->id == WM9713_ID2) {
> +		wm97xx_reg_write(wm, AC97_WM9713_DIG1, wm->dig[0]);
> +		wm97xx_reg_write(wm, 0x5a, wm->misc);
> +		if (wm->input_dev->users) {
> +			u16 reg;
> +			reg = wm97xx_reg_read(wm, AC97_EXTENDED_MID) & 0x7fff;
> +			wm97xx_reg_write(wm, AC97_EXTENDED_MID, reg);
> +		}
> +	}
> +
> +	wm97xx_reg_write(wm, AC97_WM9713_DIG2, wm->dig[1]);
> +	wm97xx_reg_write(wm, AC97_WM9713_DIG3, wm->dig[2]);
> +
> +	wm97xx_reg_write(wm, AC97_GPIO_CFG, wm->gpio[0]);
> +	wm97xx_reg_write(wm, AC97_GPIO_POLARITY, wm->gpio[1]);
> +	wm97xx_reg_write(wm, AC97_GPIO_STICKY, wm->gpio[2]);
> +	wm97xx_reg_write(wm, AC97_GPIO_WAKEUP, wm->gpio[3]);
> +	wm97xx_reg_write(wm, AC97_GPIO_STATUS, wm->gpio[4]);
> +	wm97xx_reg_write(wm, AC97_MISC_AFE, wm->gpio[5]);
> +
> +	return 0;
> +}
> +
> +#else
> +#define wm97xx_resume		NULL
> +#endif

It's strange to see a .resume but no .suspend.

> +/*
> + * Machine specific operations
> + */
> +int wm97xx_register_mach_ops(struct wm97xx *wm,
> +			     struct wm97xx_mach_ops *mach_ops)
> +{
> +	mutex_lock(&wm->codec_mutex);
> +	if (wm->mach_ops) {
> +		mutex_unlock(&wm->codec_mutex);
> +		return -EINVAL;
> +	}
> +	wm->mach_ops = mach_ops;
> +	mutex_unlock(&wm->codec_mutex);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(wm97xx_register_mach_ops);
> +
> +void wm97xx_unregister_mach_ops(struct wm97xx *wm)
> +{
> +	mutex_lock(&wm->codec_mutex);
> +	wm->mach_ops = NULL;
> +	mutex_unlock(&wm->codec_mutex);
> +}
> +EXPORT_SYMBOL_GPL(wm97xx_unregister_mach_ops);
> +
> +static struct device_driver wm97xx_driver = {
> +	.name = 	"ac97",
> +	.bus = 		&ac97_bus_type,
> +	.owner = 	THIS_MODULE,
> +	.probe = 	wm97xx_probe,
> +	.remove = 	wm97xx_remove,
> +	.resume =	wm97xx_resume,
> +};
> +
> +static int __init wm97xx_init(void)
> +{
> +	return driver_register(&wm97xx_driver);
> +}
> +
> +static void __exit wm97xx_exit(void)
> +{
> +	driver_unregister(&wm97xx_driver);
> +}
> +
> +module_init(wm97xx_init);
> +module_exit(wm97xx_exit);
> +
> +/* Module information */
> +MODULE_AUTHOR("Liam Girdwood <liam.girdwood@wolfsonmicro.com>");
> +MODULE_DESCRIPTION("WM97xx Core - Touch Screen / AUX ADC / GPIO Driver");
> +MODULE_LICENSE("GPL");
> diff --git a/include/linux/wm97xx.h b/include/linux/wm97xx.h
> new file mode 100644
> index 0000000..f0d9fc0
> --- /dev/null
> +++ b/include/linux/wm97xx.h
> @@ -0,0 +1,308 @@
> +
> +/*
> + * Register bits and API for Wolfson WM97xx series of codecs
> + */
> +
> +#ifndef _LINUX_WM97XX_H
> +#define _LINUX_WM97XX_H
> +
> +#include <sound/core.h>
> +#include <sound/pcm.h>
> +#include <sound/ac97_codec.h>
> +#include <sound/initval.h>
> +#include <linux/types.h>
> +#include <linux/list.h>
> +#include <linux/input.h>	/* Input device layer */
> +#include <linux/platform_device.h>
> +
> +/*
> + * WM97xx AC97 Touchscreen registers
> + */

ac97 stuff?  But I saw no appropriate dependencies for this in the Kconfig
patch?

> +/*
> + * Codec GPIO status
> + */
> +enum wm97xx_gpio_status {
> +    WM97XX_GPIO_HIGH,
> +    WM97XX_GPIO_LOW
> +};
> +
> +/*
> + * Codec GPIO direction
> + */
> +enum wm97xx_gpio_dir {
> +    WM97XX_GPIO_IN,
> +    WM97XX_GPIO_OUT
> +};
> +
> +/*
> + * Codec GPIO polarity
> + */
> +enum wm97xx_gpio_pol {
> +    WM97XX_GPIO_POL_HIGH,
> +    WM97XX_GPIO_POL_LOW
> +};
> +
> +/*
> + * Codec GPIO sticky
> + */
> +enum wm97xx_gpio_sticky {
> +    WM97XX_GPIO_STICKY,
> +    WM97XX_GPIO_NOTSTICKY
> +};
> +
> +/*
> + * Codec GPIO wake
> + */
> +enum wm97xx_gpio_wake {
> +    WM97XX_GPIO_WAKE,
> +    WM97XX_GPIO_NOWAKE
> +};

Are these gpio's really gp?  If so, should this driver be using the
drivers/gpio/ infrastructure?


