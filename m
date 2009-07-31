Return-Path: <linux-kernel-owner+w=401wt.eu-S1752722AbZGaRUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722AbZGaRUG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 13:20:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752620AbZGaRUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 13:20:05 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43591 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752491AbZGaRUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 13:20:05 -0400
Date: Fri, 31 Jul 2009 18:20:02 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Roger Quadros <quadros.roger@gmail.com>
Cc: philipp.zabel@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] regulator: Add GPIO enable control to fixed voltage
 regulator driver
Message-ID: <20090731172002.GA32578@rakim.wolfsonmicro.main>
References: <1249057189-11992-1-git-send-email-quadros.roger@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249057189-11992-1-git-send-email-quadros.roger@gmail.com>
X-Cookie: Hire the morally handicapped.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 31, 2009 at 07:19:49PM +0300, Roger Quadros wrote:

> Signed-off-by: Roger Quadros <ext-roger.quadros@nokia.com>
> Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Err...  no, it isn't.  I reviewed a previous version of the patch but
there were some issues that needed fixing.  I've not reviewed this
version.

>  static int fixed_voltage_is_enabled(struct regulator_dev *dev)
>  {
> -	return 1;
> +	struct fixed_voltage_data *data = rdev_get_drvdata(dev);
> +
> +	if (data->gpio)
> +		return data->is_enabled;

Please use gpio_is_valid() as Phillip previously suggested.  For this
particular use you could simplify the code marginally by just setting
is_enabled at probe() time if there's no GPIO, not that it really
matters.

> +       if (data->gpio) {
> +               gpio_set_value(data->gpio,
> +                               data->enable_high ? 1 : 0);

_cansleep(), please, as previously requested.
 
> +		ret = gpio_get_value(config->gpio);

Can this fail?  It returns an int...

> +		ret = gpio_direction_output(config->gpio, ret);
> +		if (ret) {
> +			dev_err(&pdev->dev, "Could not configure "
> +				"enable GPIO %d direction: %d\n",
> +						config->gpio, ret);
> +			goto err_gpio;

As previously requested please don't split for log messages text over
lines unless you have to.  It makes it easier to find the message from a
kernel log - grep for 'configure enable GPIO' won't match this source
file the way you've written it above.

> +		}
> +	} else
> +		dev_warn(&pdev->dev, "Not using GPIO 0 for enable control\n");

Probably better to soldier on and use the GPIO here but either way is
fine; the warning is for the benefit of existing out of tree users to
help them transition gracefully.
