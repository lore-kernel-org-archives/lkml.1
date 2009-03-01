Return-Path: <linux-kernel-owner+w=401wt.eu-S1756321AbZCAA6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756321AbZCAA6d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 19:58:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753777AbZCAA6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 19:58:22 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:18349 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666AbZCAA6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 19:58:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=CSF6y6sszfG3USoImgLN9HICxYHVbblRgc640TQXbT8Z1bkBDKKqUy/xZ/N+JlH8Ve
         G4JxflKGp8JBXwMvmBbOO1l6AwrbhP9dehoP8JujG0cPkxlin145dE433oju08jknJ+L
         +q0fvNR05HQ75Ag/yDgeonWMC73g0wVJ1SWnw=
Date: Sat, 28 Feb 2009 16:58:01 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Felipe Balbi <me@felipebalbi.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Samuel Ortiz <sameo@openedhand.com>
Subject: Re: [PATCH 1/2] input: misc: add twl4030-pwrbutton driver
Message-ID: <20090228165156.ZZRA012@mailhub.coreip.homeip.net>
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com> <20090228141725.ZZRA012@mailhub.coreip.homeip.net> <20090301003014.GA22673@frodo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090301003014.GA22673@frodo>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 01, 2009 at 02:30:18AM +0200, Felipe Balbi wrote:
> On Sat, Feb 28, 2009 at 02:23:03PM -0800, Dmitry Torokhov wrote:
> > Hi Felipe,
> > 
> > On Fri, Feb 27, 2009 at 09:28:02PM +0200, Felipe Balbi wrote:
> > > From: Felipe Balbi <felipe.balbi@nokia.com>
> > > 
> > > This is part of the twl4030 multifunction device driver.
> > > 
> > > With this driver we add support for reporting KEY_POWER
> > > events via the input layer.
> > 
> > ...
> 
> thanks for reviewing, how about the version below:
> 

Looks good, couple more items...

>  
> +config INPUT_TWL4030_PWRBUTTON
> +	tristate "TWL4030 Power button Driver"
> +	depends on TWL4030_CORE
> +

Help should be added, at least document module name as we do with
other drivers.

> +
> +static struct input_dev *powerbutton_dev;
> +static struct device *dbg_dev;

Get rid of dbg_dev. The only place it is used in powerbutton_irq and you
can get it from powerbutton_dev->dev.parent now.

> +
> +static irqreturn_t powerbutton_irq(int irq, void *dev_id)
> +{
> +	int err;
> +	u8 value;
> +
> +#ifdef CONFIG_LOCKDEP
> +	/* WORKAROUND for lockdep forcing IRQF_DISABLED on us, which
> +	 * we don't want and can't tolerate.  Although it might be
> +	 * friendlier not to borrow this thread context...
> +	 */

I would like more verbage explaining that this is a threaded IRQ and
therefore is allowed to sleep and other stuff.

> +	local_irq_enable();
> +#endif
> +
> +	err = twl4030_i2c_read_u8(TWL4030_MODULE_PM_MASTER, &value,
> +				  STS_HW_CONDITIONS);
> +	if (!err)  {
> +		input_report_key(powerbutton_dev, KEY_POWER,
> +				 value & PWR_PWRON_IRQ);
> +		input_sync(powerbutton_dev);
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

No need to initialize.

> +	int irq = platform_get_irq(pdev, 0);
> +
> +	dbg_dev = &pdev->dev;
> +
> +	powerbutton_dev = input_allocate_device();
> +	if (!powerbutton_dev) {
> +		dev_dbg(&pdev->dev, "Can't allocate power button\n");
> +		err = -ENOMEM;
> +		goto out;
> +	}
> +
> +	err = request_irq(irq, powerbutton_irq,
> +			IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
> +			"twl4030-pwrbutton", NULL);
> +	if (err < 0) {
> +		dev_dbg(&pdev->dev, "Can't get IRQ for pwrbutton: %d\n", err);
> +		goto free_input_dev;
> +	}
> +
> +	powerbutton_dev->evbit[0] = BIT_MASK(EV_KEY);
> +	powerbutton_dev->keybit[BIT_WORD(KEY_POWER)] = BIT_MASK(KEY_POWER);
> +	powerbutton_dev->name = "triton2-pwrbutton";
> +	powerbutton_dev->phys = "twl4030_pwrbutton/input0";

I would like consistency here, if possible. Everywhere we have
twl4030{-|_}pwrbutton except in the name which says "triton2".. What
gives?

> +	powerbutton_dev->dev.parent = &pdev->dev;
> +
> +	err = input_register_device(powerbutton_dev);
> +	if (err) {
> +		dev_dbg(&pdev->dev, "Can't register power button: %d\n", err);
> +		goto free_irq_and_out;
> +	}
> +
> +	dev_info(&pdev->dev, "triton2 power button driver initialized\n");

Loose the message, boot is noisy enough as it is.

-- 
Dmitry
