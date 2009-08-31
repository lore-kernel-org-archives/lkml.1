Return-Path: <linux-kernel-owner+w=401wt.eu-S1752704AbZHaMo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704AbZHaMo1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 08:44:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752288AbZHaMo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 08:44:26 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45643 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751196AbZHaMoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 08:44:25 -0400
Subject: Re: [PATCH 1/2] AB3100 regulator support v2
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, Samuel Ortiz <sameo@linux.intel.com>,
       Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
In-Reply-To: <1251667749-31276-1-git-send-email-linus.walleij@stericsson.com> (sfid-20090830_222927_307976_AB051003)
References: <1251667749-31276-1-git-send-email-linus.walleij@stericsson.com>
	 (sfid-20090830_222927_307976_AB051003)
Content-Type: text/plain
Organization: Wolfson Microelectronics
Date: Mon, 31 Aug 2009 13:44:01 +0100
Message-Id: <1251722641.4254.46.camel@finisterre.sirena.org.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-08-30 at 23:29 +0200, Linus Walleij wrote:

> Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
> Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

It's probably better to only use this if someone's reviewed the driver
and said it's OK.

Overall this looks pretty good, it's addressed almost all of the issues
I had last time. There's a few sticky bits below, though.

> +	err = ab3100_get_register_interruptible(abreg->ab3100, abreg->regreg,
> +						&regval);
> +	if (err) {
> +		if (err != -ERESTARTSYS)
> +			dev_err(&reg->dev, "unable to get register 0x%x\n",
> +				abreg->regreg);
> +		else
> +			dev_info(&reg->dev,
> +				 "interrupted while getting register 0x%x\n",
> +				 abreg->regreg);
> +		return err;
> +	}

I did query last time if having these operations be interruptible is a
good idea - I can't see it helping robustness, it's not something that
other drivers are doing and it'd complicate things for all API users to
add handling for the error. I don't recall any discussion of the
thinking here?

> +	bestmatch = INT_MAX;
> +	bestindex = -1;
> +	for (i = 0; i < abreg->voltages_len; i++) {
> +		if (abreg->typ_voltages[i] <= max_uV &&
> +		    abreg->typ_voltages[i] >= min_uV &&
> +		    abreg->typ_voltages[i] < bestmatch) {
> +			bestmatch = abreg->typ_voltages[i];
> +			bestindex = i;
> +		}
> +	}
> +
> +	if (i < 0) {
> +		dev_warn(&reg->dev, "requested %d<=x<=%d uV, out of range!\n",
> +			 min_uV, max_uV);

That should be a check for bestindex, not i - i will always be
abreg->voltages_len.

> +/*
> + * The external regulator just calls back into the platform
> + * board setup to get/set the regulator.
> + */
> +static int ab3100_get_voltage_regulator_external(struct regulator_dev *reg)
> +{
> +	struct ab3100_regulator *abreg = reg->reg_data;
> +
> +	if (abreg->plfdata->get_ext_voltage)
> +		return abreg->plfdata->get_ext_voltage();
> +	return -ENXIO;
> +}

Hrm.  I suspect that you either want to add some platform data to
specify the voltage as a plain number or just have boards use the
regulator supply mechanism with a fixed voltage regulator supplied by
this one if they need to specify the voltage of the supply.

> +	/* Set up regulators */
> +	for (i = 0; i < ARRAY_SIZE(ab3100_regulators); i++) {
> +		/* This regulator is special and has to be set last */
> +		if (ab3100_regulators[i].regreg == AB3100_LDO_D) {
> +			ldo_d_val = plfdata->reg_initvals[i];
> +			continue;
> +		}
> +
> +		err = ab3100_set_register_interruptible(ab3100,
> +					ab3100_regulators[i].regreg,
> +					plfdata->reg_initvals[i]);
> +		if (err) {
> +			dev_err(&pdev->dev, "regulator initialization failed with error %d\n",
> +				err);
> +			return err;
> +		}
> +	}

It is a big improvement to have the configuration be specified as
platform data but I'm still a bit concerned about the idea of providing
this power sequencing as a driver-local feature.

The regulator API already has mechanisms for setting the default state
for regulators and the general problem of sequencing the initial setup
isn't specific to this chip. There's currently no sequencing support in
the API, largely because most systems have some explicit power
sequencing in the hardware and a specific way of signalling the PMIC to
kick off the powerdown or suspend sequences so it's not a big deal. I
suspect that with the implementation you've got here you might run into
trouble with systems which need some sequencing beyond just ordering
everything else with respect to LDO D, which I suspect is more likely to
occur if you need this level of soft implementation. I'd also be worried
that any core sequencing that is introduced (I expect we will need it at
some point - possibly soon, Mike Rappaport has some issues that look
like they might need to be fixed sequencing support) might break your
systems, though I think that may just be an excess of caution.

I've been having a bit of a think about the best way to handle this;
it'd mean that we'd need to have some way for a machine driver to
provide sequences for the power on and off transitions that we might
need to do. Working out how to actually run the sequences would be
slightly tricky - we could wait for all the mentioned regulators to be
registered but that'd create issues if some of the later regulators in
the sequence depend on the earlier parts of the sequence for
registration.

Have you looked at the possibility of integrating this into the core?

