Return-Path: <linux-kernel-owner+w=401wt.eu-S1751973AbZIVTPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973AbZIVTPm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 15:15:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751925AbZIVTPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 15:15:40 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:38995 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbZIVTPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 15:15:37 -0400
Date: Tue, 22 Sep 2009 12:15:31 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>
Message-ID: <20090922191529.GB4690@sirena.org.uk>
References: <1253625499-9314-1-git-send-email-w.sang@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253625499-9314-1-git-send-email-w.sang@pengutronix.de>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 72.254.91.198
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC] regulator: add driver for MAX8660/8661
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 22, 2009 at 03:18:19PM +0200, Wolfram Sang wrote:

Overall this looks pretty good - some comments...

>  Documentation/power/regulator/max8660.txt |   32 ++

Hrm, if we're going to do this we should do it consistently for all the
drivers.  I think I prefer documentation embedded in the source TBH but
only a little bit.

> +This chip is a bit nasty because it is a write-only device. Thus, the driver
> +uses shadow registers to keep track of its values. The main problem appears to
> +be the initialization: When Linux boots up, we cannot know if the chip is in
> +the default state or not, so we would have to pass such information in
> +platform_data. As this adds a bit of complexity to the driver, this is left
> +out for now until it is really needed.

The AB3100 regulator has a somewhat similar problem in that it appears
to pretty much need some very device specific setup to be done since it
expects software to do a lot of the bootstrapping.  Your plan of passing
in platform data and just blatting the device configuration does seem
reasonable if there's stuff like that.

> +Note that disabling V3 or V4 has no effect if pin EN34 is driven high (pin and
> +register are ORed, see datasheet).

Might be worth exposing this for control via GPIO in a future version of
the driver.

> +- Make use of the forced PWM modes?

regulator_set_mode() - should be fairly straightforward.

> +- ARD?

I'm not sure what you mean by this?

> +	struct regulator_dev *rdev[0];

I'm not a big fan of the 0 length array - just [] ought to do?

> +static int max8660_dcdc_enable(struct regulator_dev *rdev)
> +{
> +	int ret;
> +	struct max8660 *max8660 = rdev_get_drvdata(rdev);
> +	u8 val = (rdev_get_id(rdev) == MAX8660_V3) ? 1 : 4;
> +	ret = max8660_write(max8660, MAX8660_OVER1, 0xff, val);
> +	val = (rdev_get_id(rdev) == MAX8660_V3) ? 0x03 : 0x30;
> +	return (ret != 0) ? :
> +		max8660_write(max8660, MAX8660_VCC1, ~val, val & 0x11);

Some comments here as to why you're also updating VCC1 would be helpful
here, it's a bit obscure at the minute.

> +		switch (pdata->subdevs[i].id) {
> +		case MAX8660_V3:
> +			if (boot_on)
> +				max8660->shadow_regs[MAX8660_OVER1] |= 1;
> +			break;

Might be worth a comment explaining why you're doing this - I believe
you need this to be done first so that set_voltage() doesn't power
things off but it's not immediately obvious from the code.
