Return-Path: <linux-kernel-owner+w=401wt.eu-S934607AbZLMBvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934607AbZLMBvr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 20:51:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934422AbZLMBuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 20:50:50 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43568 "HELO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934382AbZLMBus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 20:50:48 -0500
Date: Sat, 12 Dec 2009 18:22:39 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alberto Panizzo <maramaopercheseimorto@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
       Sascha linux-arm <s.hauer@pengutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel-infradead <linux-arm-kernel@lists.infradead.org>,
       Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Message-ID: <20091212182239.GD3092@sirena.org.uk>
References: <1260635829.2054.16.camel@climbing-alby>
 <1260636523.2054.28.camel@climbing-alby>
 <1260636819.2054.33.camel@climbing-alby>
 <1260636976.2054.36.camel@climbing-alby>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260636976.2054.36.camel@climbing-alby>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 82.41.240.126
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/4] regulator: add voltage selection capability to
 mc13783 regulators.
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 12, 2009 at 05:56:16PM +0100, Alberto Panizzo wrote:
> This patch, complete the mc13783 regulator subsystem driver with 
> voltage selecting capability.
> Main Switches (SW1AB, SW2AB) are not supported yet.
> 
> Signed-off-by: Alberto Panizzo <maramaopercheseimorto@gmail.com>

This is broadly OK but there are a number of issues, mostly stylistic
which it would be better to fix.  scripts/checkpatch.pl will catch a lot
of these.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

on the basis that the code is correct, though.

> +static int mc13783_regulator_list_voltage (struct regulator_dev *rdev, unsigned selector)

These long lines really ought to be wrapped, and you've got an extra
space before the ( which isn't the usual coding style.  There's lots of
other odditities with things like this which checkpatch should catch.

> +static int mc13783_get_best_voltage_index(struct regulator_dev *rdev,
> +						int min_uV, int max_uV)
> +{
> +	int reg_id = rdev_get_id(rdev);
> +	int i;
> +	int bestmatch;
> +	int bestindex;
> +
> +	/*
> +	 * Locate the minimum voltage fitting the criteria on
> +	 * this regulator. The switchable voltages are not
> +	 * in strict falling order so we need to check them
> +	 * all for the best match.
> +	 */
> +	bestmatch = INT_MAX;
> +	bestindex = -1;
> +	for (i = 0; i < mc13783_regulators[reg_id].desc.n_voltages; i++) {
> +		if (mc13783_regulators[reg_id].voltages[i] <= max_uV &&
> +		    mc13783_regulators[reg_id].voltages[i] >= min_uV &&
> +		    mc13783_regulators[reg_id].voltages[i] < bestmatch) {
> +			bestmatch = mc13783_regulators[reg_id].voltages[i];
> +			bestindex = i;
> +		}
> +	}

Not that it makes much difference but you could just ignore max_uV until
you're done then check it once at the end since you're selecting for the
lowest matching voltage anyway.

> +	/* If it is a fixed regulator*/
> +	if (mc13783_regulators[id].desc.n_voltages == 1)
> +	{

if (...)  {

though it might be as well to define the fixed voltage regulators
separately with their own get and list functions rather than special
casing like this.

> +	mc13783_lock(priv->mc13783);
> +	ret = mc13783_reg_read( priv->mc13783,
> +				mc13783_regulators[id].vsel_reg, &val);

Extra space after the (.
