Return-Path: <linux-kernel-owner+w=401wt.eu-S1755929AbZB1WX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929AbZB1WX1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 17:23:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754480AbZB1WXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 17:23:18 -0500
Received: from yw-out-2324.google.com ([74.125.46.29]:39992 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849AbZB1WXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 17:23:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HUz+uvHrr3qaD86lJaa9S0VAd58P9VQfeyrEnRPLkQtgVjc++02eCMV3ZM6fsNFJZC
         fGKj5Ty3m24cOM6BjL0z3gQpubQyQNSL9Cve5HPiBRQ3/piEmiyUrf8A+3orJaXZxYAb
         MTmup+pBj8pPPXWX4pkJwOu8Q4qxZEwYE2IF8=
Date: Sat, 28 Feb 2009 14:23:03 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Felipe Balbi <me@felipebalbi.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Samuel Ortiz <sameo@openedhand.com>
Subject: Re: [PATCH 1/2] input: misc: add twl4030-pwrbutton driver
Message-ID: <20090228141725.ZZRA012@mailhub.coreip.homeip.net>
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235762883-20870-1-git-send-email-me@felipebalbi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

On Fri, Feb 27, 2009 at 09:28:02PM +0200, Felipe Balbi wrote:
> From: Felipe Balbi <felipe.balbi@nokia.com>
> 
> This is part of the twl4030 multifunction device driver.
> 
> With this driver we add support for reporting KEY_POWER
> events via the input layer.

...

> 
> +
> +	err = twl4030_i2c_read_u8(TWL4030_MODULE_PM_MASTER, &value,
> +				  STS_HW_CONDITIONS);
> +	if (!err)  {
> +		input_report_key(powerbutton_dev, KEY_POWER,
> +				 value & PWR_PWRON_IRQ);

input_sync() here please.

> +	} else {
> +		dev_err(dbg_dev, "twl4030: i2c error %d while reading TWL4030"
> +			" PM_MASTER STS_HW_CONDITIONS register\n", err);
> +	}
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int __devinit twl4030_pwrbutton_probe(struct platform_device *pdev)
> +{
> +	int err = 0;
> +	int irq = platform_get_irq(pdev, 0);
> +
> +	dbg_dev = &pdev->dev;
> +
> +	/* PWRBTN == PWRON */
> +	err = request_irq(irq, powerbutton_irq,
> +			IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
> +			"twl4030-pwrbutton", NULL);

Requesting IRQ before allocating input device seems unsafe. If IRQ
arrives right now we'll go boom.


> +	if (err < 0) {
> +		dev_dbg(&pdev->dev, "Can't get IRQ for pwrbutton: %d\n", err);
> +		goto out;
> +	}
> +
> +	powerbutton_dev = input_allocate_device();
> +	if (!powerbutton_dev) {
> +		dev_dbg(&pdev->dev, "Can't allocate power button\n");
> +		err = -ENOMEM;
> +		goto free_irq_and_out;
> +	}
> +
> +	powerbutton_dev->evbit[0] = BIT_MASK(EV_KEY);
> +	powerbutton_dev->keybit[BIT_WORD(KEY_POWER)] = BIT_MASK(KEY_POWER);
> +	powerbutton_dev->name = "triton2-pwrbutton";

powerbutton_dev->dev.parent = &pdev->dev;

Any chance we could set up phys as well? BUS_I2C seems to be in order as
well.

> +
> +	err = input_register_device(powerbutton_dev);
> +	if (err) {
> +		dev_dbg(&pdev->dev, "Can't register power button: %d\n", err);
> +		goto free_input_dev;
> +	}
> +
> +	dev_info(&pdev->dev, "triton2 power button driver initialized\n");
> +
> +	return 0;
> +
> +
> +free_input_dev:
> +	input_free_device(powerbutton_dev);
> +free_irq_and_out:
> +	free_irq(TWL4030_PWRIRQ_PWRBTN, NULL);
> +out:
> +	return err;
> +}
> +
> +static int __devexit twl4030_pwrbutton_remove(struct platform_device *pdev)
> +{
> +	int irq = platform_get_irq(pdev, 0);
> +
> +	free_irq(irq, NULL);
> +	input_unregister_device(powerbutton_dev);
> +	input_free_device(powerbutton_dev);

Do not call free after unregistering, unregister will drop last
reference and will cause device structure be freed.

-- 
Dmitry
