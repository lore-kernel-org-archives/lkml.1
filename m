Return-Path: <linux-kernel-owner+w=401wt.eu-S1757324AbZF2G32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757324AbZF2G32 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 02:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751226AbZF2G3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 02:29:18 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:50269 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbZF2G3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 02:29:16 -0400
X-Greylist: delayed 880 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Jun 2009 02:29:16 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JcjvWUiQ6Ojkx9e5BtZme2znzF17sml94ccgWwDHRI9KFW8TnpDTzJJbce2TGEhdt6
         55TRr0F1uZj/HLqto0/yQIkKjbJoph8f+jdUwDvbZT+mObD6XM747OAsS0dSkrosHXf2
         v3Z8xKjKAxF9li/2wgIeZsnHKJYHtv3vGJNdE=
Date: Sun, 28 Jun 2009 23:29:14 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Daniel Ribeiro <drwyrm@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       openezx-devel <openezx-devel@lists.openezx.org>,
       Harald Welte <laforge@gnumonks.org>,
       Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] PCAP touchscreen driver (for 2.6.32)
Message-ID: <20090629062914.GF12821@dtor-d630.eng.vmware.com>
References: <1246122138.3727.12.camel@brutus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246122138.3727.12.camel@brutus>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On Sat, Jun 27, 2009 at 02:02:18PM -0300, Daniel Ribeiro wrote:
> Touchscreen driver for PCAP2 PMIC.
> 
> Signed-off-by: Daniel Ribeiro <drwyrm@gmail.com>
> 
> ---
>  drivers/input/touchscreen/Kconfig   |    9 ++
>  drivers/input/touchscreen/Makefile  |    1 +
>  drivers/input/touchscreen/pcap_ts.c |  235 +++++++++++++++++++++++++++++++++++
>  3 files changed, 245 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
> index 72e2712..8e6fa8b 100644
> --- a/drivers/input/touchscreen/Kconfig
> +++ b/drivers/input/touchscreen/Kconfig
> @@ -498,4 +498,13 @@ config TOUCHSCREEN_W90X900
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called w90p910_ts.
>  
> +config TOUCHSCREEN_PCAP
> +	tristate "Motorola PCAP touchscreen"
> +	depends on EZX_PCAP
> +	help
> +	  Say Y here if you have a Motorola EZX telephone and
> +	  want to support the built-in touchscreen.
> +
> +	  If unsure, say N.
> +
>  endif
> diff --git a/drivers/input/touchscreen/Makefile b/drivers/input/touchscreen/Makefile
> index 3e1c5e0..4599bf7 100644
> --- a/drivers/input/touchscreen/Makefile
> +++ b/drivers/input/touchscreen/Makefile
> @@ -40,3 +40,4 @@ obj-$(CONFIG_TOUCHSCREEN_WM97XX_ATMEL)	+= atmel-wm97xx.o
>  obj-$(CONFIG_TOUCHSCREEN_WM97XX_MAINSTONE)	+= mainstone-wm97xx.o
>  obj-$(CONFIG_TOUCHSCREEN_WM97XX_ZYLONITE)	+= zylonite-wm97xx.o
>  obj-$(CONFIG_TOUCHSCREEN_W90X900)	+= w90p910_ts.o
> +obj-$(CONFIG_TOUCHSCREEN_PCAP)		+= pcap_ts.o
> diff --git a/drivers/input/touchscreen/pcap_ts.c b/drivers/input/touchscreen/pcap_ts.c
> new file mode 100644
> index 0000000..7877fdf
> --- /dev/null
> +++ b/drivers/input/touchscreen/pcap_ts.c
> @@ -0,0 +1,235 @@
> +/*
> + * Driver for Motorola PCAP2 touchscreen as found in the EZX phone platform.
> + *
> + *  Copyright (C) 2006 Harald Welte <laforge@openezx.org>
> + *  Copyright (C) 2009 Daniel Ribeiro <drwyrm@gmail.com>
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License version 2 as
> + *  published by the Free Software Foundation.
> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/fs.h>
> +#include <linux/string.h>
> +#include <linux/pm.h>
> +#include <linux/timer.h>
> +#include <linux/interrupt.h>
> +#include <linux/platform_device.h>
> +#include <linux/input.h>
> +#include <linux/mfd/ezx-pcap.h>
> +
> +struct pcap_ts {
> +	struct pcap_chip *pcap;
> +	struct input_dev *input;
> +	struct delayed_work work;
> +	u16 x, y;
> +	u16 pressure;
> +	u8 read_state;
> +};
> +
> +#define SAMPLE_DELAY	20 /* msecs */
> +
> +#define X_AXIS_MIN	0
> +#define X_AXIS_MAX	1023
> +#define Y_AXIS_MAX	X_AXIS_MAX
> +#define Y_AXIS_MIN	X_AXIS_MIN
> +#define PRESSURE_MAX	X_AXIS_MAX
> +#define PRESSURE_MIN	X_AXIS_MIN
> +
> +static void pcap_ts_read_xy(void *data, u16 res[2])
> +{
> +	struct pcap_ts *pcap_ts = data;
> +
> +	switch (pcap_ts->read_state) {
> +	case PCAP_ADC_TS_M_PRESSURE:
> +		/* pressure reading is unreliable */
> +		if (res[0] > PRESSURE_MIN && res[0] < PRESSURE_MAX)
> +			pcap_ts->pressure = res[0];
> +		pcap_ts->read_state = PCAP_ADC_TS_M_XY;
> +		schedule_delayed_work(&pcap_ts->work, 0);
> +		break;
> +	case PCAP_ADC_TS_M_XY:
> +		pcap_ts->y = res[0];
> +		pcap_ts->x = res[1];
> +		if (pcap_ts->x <= X_AXIS_MIN || pcap_ts->x >= X_AXIS_MAX ||
> +		    pcap_ts->y <= Y_AXIS_MIN || pcap_ts->y >= Y_AXIS_MAX) {
> +			/* pen has been released */
> +			input_report_abs(pcap_ts->input, ABS_PRESSURE, 0);
> +			input_report_key(pcap_ts->input, BTN_TOUCH, 0);
> +
> +			pcap_ts->read_state = PCAP_ADC_TS_M_STANDBY;
> +			schedule_delayed_work(&pcap_ts->work, 0);

It looks like the only thing the work will do is:

> +	pcap_set_ts_bits(pcap_ts->pcap,
> +			pcap_ts->read_state << PCAP_ADC_TS_M_SHIFT);

So why not do that directly here instead of scheduling work again?

> +		} else {
> +			/* pen is touching the screen*/
> +			input_report_abs(pcap_ts->input, ABS_X, pcap_ts->x);
> +			input_report_abs(pcap_ts->input, ABS_Y, pcap_ts->y);
> +			input_report_key(pcap_ts->input, BTN_TOUCH, 1);
> +			input_report_abs(pcap_ts->input, ABS_PRESSURE,
> +						pcap_ts->pressure);
> +
> +			/* switch back to pressure read mode */
> +			pcap_ts->read_state = PCAP_ADC_TS_M_PRESSURE;
> +			schedule_delayed_work(&pcap_ts->work,
> +					msecs_to_jiffies(SAMPLE_DELAY));
> +		}
> +		input_sync(pcap_ts->input);
> +		break;
> +	default:

Maybe add some angry words here?

> +		break;
> +	}
> +}
> +
> +static void pcap_ts_work(struct work_struct *work)
> +{
> +	struct delayed_work *dw = container_of(work, struct delayed_work, work);
> +	struct pcap_ts *pcap_ts = container_of(dw, struct pcap_ts, work);
> +	u8 ch[2];
> +
> +	pcap_set_ts_bits(pcap_ts->pcap,
> +			pcap_ts->read_state << PCAP_ADC_TS_M_SHIFT);
> +
> +	if (pcap_ts->read_state == PCAP_ADC_TS_M_STANDBY)
> +		return;
> +
> +	/* start adc conversion */
> +	ch[0] = PCAP_ADC_CH_TS_X1;
> +	ch[1] = PCAP_ADC_CH_TS_Y1;
> +	pcap_adc_async(pcap_ts->pcap, PCAP_ADC_BANK_1, 0, ch,
> +						pcap_ts_read_xy, pcap_ts);
> +}
> +
> +static irqreturn_t pcap_ts_event_touch(int pirq, void *data)
> +{
> +	struct pcap_ts *pcap_ts = data;
> +
> +	if (pcap_ts->read_state == PCAP_ADC_TS_M_STANDBY) {
> +		pcap_ts->read_state = PCAP_ADC_TS_M_PRESSURE;
> +		schedule_delayed_work(&pcap_ts->work, 0);
> +	}
> +	return IRQ_HANDLED;
> +}
> +
> +static int __devinit pcap_ts_probe(struct platform_device *pdev)
> +{
> +	struct input_dev *input_dev;
> +	struct pcap_ts *pcap_ts;
> +	int err = -ENOMEM;
> +
> +	pcap_ts = kzalloc(sizeof(*pcap_ts), GFP_KERNEL);
> +	if (!pcap_ts)
> +		return err;
> +
> +	pcap_ts->pcap = platform_get_drvdata(pdev);
> +	platform_set_drvdata(pdev, pcap_ts);
> +
> +	input_dev = input_allocate_device();
> +	if (!pcap_ts || !input_dev)
> +		goto fail;
> +
> +	INIT_DELAYED_WORK(&pcap_ts->work, pcap_ts_work);
> +
> +	pcap_ts->read_state = PCAP_ADC_TS_M_STANDBY;
> +
> +	pcap_ts->input = input_dev;
> +
> +	input_dev->name = "pcap-touchscreen";
> +	input_dev->phys = "pcap_ts/input0";
> +	input_dev->id.bustype = BUS_HOST;
> +	input_dev->id.vendor = 0x0001;
> +	input_dev->id.product = 0x0002;
> +	input_dev->id.version = 0x0100;
> +	input_dev->dev.parent = &pdev->dev;
> +
> +	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
> +	input_dev->keybit[BIT_WORD(BTN_TOUCH)] = BIT_MASK(BTN_TOUCH);
> +	input_set_abs_params(input_dev, ABS_X, X_AXIS_MIN, X_AXIS_MAX, 0, 0);
> +	input_set_abs_params(input_dev, ABS_Y, Y_AXIS_MIN, Y_AXIS_MAX, 0, 0);
> +	input_set_abs_params(input_dev, ABS_PRESSURE, PRESSURE_MIN,
> +			     PRESSURE_MAX, 0, 0);
> +
> +	err = request_irq(pcap_to_irq(pcap_ts->pcap, PCAP_IRQ_TS),
> +			pcap_ts_event_touch, 0, "Touch Screen", pcap_ts);
> +	if (err)
> +		goto fail;
> +
> +	err = input_register_device(pcap_ts->input);
> +	if (err)
> +		goto fail_touch;
> +
> +	schedule_delayed_work(&pcap_ts->work, 0);
> +
> +	return 0;
> +
> +fail_touch:
> +	free_irq(pcap_to_irq(pcap_ts->pcap, PCAP_IRQ_TS), pcap_ts);
> +fail:
> +	input_free_device(input_dev);
> +	kfree(pcap_ts);
> +
> +	return err;
> +}
> +
> +static int __devexit pcap_ts_remove(struct platform_device *pdev)
> +{
> +	struct pcap_ts *pcap_ts = platform_get_drvdata(pdev);
> +
> +	free_irq(pcap_to_irq(pcap_ts->pcap, PCAP_IRQ_TS), pcap_ts);
> +
> +	input_unregister_device(pcap_ts->input);
> +	cancel_delayed_work_sync(&pcap_ts->work);

I think these 2 lines shoudl be swapped...

> +	kfree(pcap_ts);
> +
> +	return 0;
> +}
> +
> +#ifdef CONFIG_PM
> +static int pcap_ts_suspend(struct platform_device *pdev, pm_message_t state)
> +{
> +	struct pcap_ts *pcap_ts = platform_get_drvdata(pdev);
> +
> +	pcap_set_ts_bits(pcap_ts->pcap, PCAP_ADC_TS_REF_LOWPWR);

What about the work? Don't you need cancel_delayed_work_sync() here?

> +	return 0;
> +}
> +
> +static int pcap_ts_resume(struct platform_device *pdev)
> +{
> +	struct pcap_ts *pcap_ts = platform_get_drvdata(pdev);
> +
> +	pcap_set_ts_bits(pcap_ts->pcap,
> +				pcap_ts->read_state << PCAP_ADC_TS_M_SHIFT);

Do you need to kick off the work here the same way you do it in
probe()?

> +	return 0;
> +}


Could you implement open() and close() methods and keep the touchscreen
in low power mode until there are users? They should be very similar to
suspend and resume you have here.

> +#endif
> +
> +static struct platform_driver pcap_ts_driver = {
> +	.probe		= pcap_ts_probe,
> +	.remove		= __devexit_p(pcap_ts_remove),
> +#ifdef CONFIG_PM
> +	.suspend	= pcap_ts_suspend,
> +	.resume		= pcap_ts_resume,
> +#endif
> +	.driver		= {
> +		.name	= "pcap-ts",
> +		.owner	= THIS_MODULE,
> +	},
> +};
> +
> +static int __init pcap_ts_init(void)
> +{
> +	return platform_driver_register(&pcap_ts_driver);
> +}
> +
> +static void __exit pcap_ts_exit(void)
> +{
> +	platform_driver_unregister(&pcap_ts_driver);
> +}
> +
> +module_init(pcap_ts_init);
> +module_exit(pcap_ts_exit);
> +
> +MODULE_DESCRIPTION("Motorola PCAP2 touchscreen driver");
> +MODULE_AUTHOR("Daniel Ribeiro / Harald Welte");
> +MODULE_LICENSE("GPL");

MODULE_ALIAS()?

Thanks!

-- 
Dmitry
