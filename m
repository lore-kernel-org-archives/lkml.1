Return-Path: <linux-kernel-owner+w=401wt.eu-S1752522AbZGaNKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522AbZGaNKI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 09:10:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752093AbZGaNKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 09:10:07 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:41418 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbZGaNKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 09:10:05 -0400
Date: Fri, 31 Jul 2009 14:10:05 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Roger Quadros <quadros.roger@gmail.com>
Cc: lrg@slimlogic.co.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: Add GPIO enable control to fixed voltage
	regulator driver
Message-ID: <20090731131005.GE17091@sirena.org.uk>
References: <1249044918-695-1-git-send-email-quadros.roger@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249044918-695-1-git-send-email-quadros.roger@gmail.com>
X-Cookie: hipatitis:
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 31, 2009 at 03:55:18PM +0300, Roger Quadros wrote:

Looks good, some relatively nitpicky issues:

> +	int use_gpio_control;

This isn't needed, just use an invalid GPIO value (zero or less).

> +       if (data->use_gpio_control) {
> +               gpio_set_value(data->gpio,
> +                               data->enable_high ? 1 : 0);

Nicer to use the _cansleep() variants in case the GPIO is one on an
I2C/SPI device of some kind.  The regulator API doesn't mind if drivers
sleep so long as they don't do so excessively and it's not normally
sufficiently performance critical to make the inlining worth it.

> +		if (ret) {
> +			dev_err(&pdev->dev, "Could not obtain regulator " \
> +					"enable GPIO %d\n", config->gpio);

Please do something like:

	dev_err(&pdev->dev,
		"Could not obtain enable GPIO %d: %d\n",
		config->gpio, ret);

so that the error message is all in one in the source (so it's easier to
find when grepping the kernel log.  You also don't need the \.

> +			goto err_name;
> +		} else {

No need for the else clause; you've got the goto above.

> +			ret = gpio_direction_output(config->gpio,
> +				config->enable_high ? 0 : 1);
> +			if (ret) {
> +				dev_err(&pdev->dev, "Could not configure " \
> +					"enable GPIO %d direction\n",
> +					config->gpio);
> +				gpio_free(config->gpio);
> +				goto err_name;
> +			}

Same comment as above with regard to the error message.  It would be
nice to have the default state passed in as platform data if you can't
read it back to help avoid bouncing supplies at startup.  IIRC
gpio_get_value() will generally take a good stab at giving the current
state no matter if the GPIO is input our output but I'd need to check.

> +       int use_gpio_control;   /* Use GPIO enable control */
> +       int gpio;               /* GPIO to use for enable control */
> +
> +       int enable_high;        /* Polarity of enable GPIO
> +                                * 1 = Active High, 0 = Active Low

If you mark the comments with /** they'll get picked up by kerneldoc.
