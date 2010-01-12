Return-Path: <linux-kernel-owner+w=401wt.eu-S1752864Ab0ALLwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864Ab0ALLwA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 06:52:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752132Ab0ALLv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 06:51:59 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46011 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752426Ab0ALLv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 06:51:59 -0500
Date: Tue, 12 Jan 2010 11:51:56 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/01] regulator: support max8649
Message-ID: <20100112115156.GA546@rakim.wolfsonmicro.main>
References: <771cded01001120041ue24edabk8e4638ef7151c947@mail.gmail.com>
 <771cded01001120051l44fd76bx80d2fd4b6f60bd0b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <771cded01001120051l44fd76bx80d2fd4b6f60bd0b@mail.gmail.com>
X-Cookie: falsie salesman, n:
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 12, 2010 at 03:51:09AM -0500, Haojian Zhuang wrote:

> Enable Maxim max8649 regulator driver.

This seems basically fine but there's a few relatively minor issues
below, mostly coding style rather than anything serious.

> +static int max8649_list_voltage(struct regulator_dev *rdev, unsigned index)
> +{
> +	return MAX8649_DCDC_VMIN + index * MAX8649_DCDC_STEP;
> +}

Brackets here would help legibility even if not strictly required.

> +	data= (min_uV - MAX8649_DCDC_VMIN + MAX8649_DCDC_STEP - 1)
> +		/ MAX8649_DCDC_STEP;

Should be "data ="

> +static struct regulator_desc dcdc_desc = {
> +	.name		= "DCDC",

MAX8649 might be a better name but it doesn't really make any odds.

> +	.ops		= &max8649_dcdc_ops,
> +	.type		= REGULATOR_VOLTAGE,
> +	.n_voltages	= 1 << 7,

Use the max index value you have above?

> +	info->vol_reg = (info->mode == 0) ? MAX8649_MODE0
> +			: ((info->mode == 1) ? MAX8649_MODE1
> +			: ((info->mode == 2) ? MAX8649_MODE2
> +			: MAX8649_MODE3));

This should really be a switch statement for legibility.  In general the
ternery operator should be used very sparingly, and if you've got more
than one of them it's not a good sign.

> +	/* enable/disable auto enter power save mode */
> +	info->powersave = pdata->powersave;
> +	data = (info->powersave) ? 0 : MAX8649_POWER_SAVE;
> +	max8649_set_bits(info->i2c, info->vol_reg, MAX8649_POWER_SAVE, data);

I'm not sure what this power save mode is but I suspect it'd map well
onto the regulator_set_mode() API - normal mode for power saving, fast
mode for power saving disabled.

> +	if (pdata->ramp_timing) {
> +		info->ramp_timing = pdata->ramp_timing;
> +		max8649_set_bits(info->i2c, MAX8649_RAMP, MAX8649_RAMP_MASK,
> +				 info->ramp_timing << 5);
> +	}

You might want to implement the new enable_time() API for this.

> +	pr_info("Max8649 regulator device is detected.\n");

This should be at most debug level, and should be dev_() to distinguish
between multiple devices.
