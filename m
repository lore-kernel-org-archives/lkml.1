Return-Path: <linux-kernel-owner+w=401wt.eu-S1752667AbZHaNah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667AbZHaNah (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 09:30:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751091AbZHaNah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 09:30:37 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55626 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750833AbZHaNag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 09:30:36 -0400
Subject: Re: [PATCH 2/2] U300 AB3100 boardinfo
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-arm-kernel@lists.infradead.org, Liam Girdwood <lrg@slimlogic.co.uk>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
In-Reply-To: <1251667855-31806-1-git-send-email-linus.walleij@stericsson.com> (sfid-20090830_223118_061062_2D83C043)
References: <1251667855-31806-1-git-send-email-linus.walleij@stericsson.com>
	 (sfid-20090830_223118_061062_2D83C043)
Content-Type: text/plain
Organization: Wolfson Microelectronics
Date: Mon, 31 Aug 2009 14:11:07 +0100
Message-Id: <1251724267.4254.73.camel@finisterre.sirena.org.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-08-30 at 23:30 +0200, Linus Walleij wrote:

>  arch/arm/mach-u300/Makefile    |    1 +
>  arch/arm/mach-u300/i2c.c       |  304 ++++++++++++++++++++++++++++++++++++++++
>  arch/arm/mach-u300/regulator.c |  150 ++++++++++++++++++++

Is mach-u300 for all machines with a given processor or is it for a
specific system?

> +static struct regulator_consumer_supply supply_ldo_c[] = {
> +	{
> +		.dev_name = "ab3100-codec",
> +		.supply = "vaudio", /* Powers the codec */
> +	},
> +};

Does the CODEC really take a single supply called vaudio or are there
several inputs to the CODEC? Since it's integrated into the chip it's
not unreasonable for there to be only one supply (the digital is likely
to be powered internally and one analogue supply is plausible) but it's
common for there to be multiple supplies.

> +		/* Buck converter routing and constraints */
> +		{
> +			.constraints = {
> +				.min_uV = 0,
> +				.max_uV = 1800000,
> +				.valid_modes_mask = REGULATOR_MODE_NORMAL,
> +				.valid_ops_mask =
> +				REGULATOR_CHANGE_VOLTAGE |
> +				REGULATOR_CHANGE_STATUS,
> +			},
> +			.num_consumer_supplies = ARRAY_SIZE(supply_buck),
> +			.consumer_supplies = supply_buck,
> +		},

I'd strongly expect that the minimum voltage for the core is higher than
the one you're setting here - normally you'd set the lowest voltage it
can operate at.

> +		/* Buck converter in sleep mode routing and constraints */
> +		{
> +			.constraints = {
> +				.min_uV = 0,
> +				.max_uV = 1800000,
> +				.valid_modes_mask = REGULATOR_MODE_NORMAL,
> +				.valid_ops_mask =
> +				REGULATOR_CHANGE_VOLTAGE |
> +				REGULATOR_CHANGE_STATUS,
> +			},
> +			.num_consumer_supplies = ARRAY_SIZE(supply_buck_sleep),
> +			.consumer_supplies = supply_buck_sleep,
> +		},

Hrm, I didn't pick this up when reading the regulator driver but does
this mean that you're registering two different regulators for the same
buck convertor? The regulator API already provides separate
configuration for suspend mode. This is currently mostly only used to
set up regulators that have explicit suspend support but (as with and
probably as part of the sequencing) the core will at some point end up
providing soft support for this for use when the hardware doesn't
support this explicitly for some reason.

Probably we should have the core use the vanilla setup functions if
there's no support in the driver; we probably also need a way to force
the core to do the configuration via the runtime modes even if the
regulator has explicit suspend support in case the board has opted not
to use that.

> +/*
> + * Hog the regulators needed to power up the board.
> + */
> +static int __init u300_init_boardpower(void)
> +{
> +	int err;
> +	u32 val;
> +
> +	pr_info("U300: setting up board power\n");
> +	radio_power = regulator_get(NULL, "vrad");
> +	if (IS_ERR(radio_power)) {
> +		pr_err("could not get vrad\n");
> +		return PTR_ERR(radio_power);
> +	}
> +	err = regulator_enable(radio_power);
> +	if (err) {
> +		pr_err("could not enable vrad\n");
> +		return err;
> +	}

This all looks like it can be supported with the existing constraints
code; look at boot_on and always_on. Normally the only thing that should
need deviceless supplies like you have here is cpufreq (due to the fact
that there's no struct device available for cpufreq to use).

Is there some problem with the existing support that you're trying to
work around here?

