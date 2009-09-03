Return-Path: <linux-kernel-owner+w=401wt.eu-S1755507AbZICOPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507AbZICOPv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 10:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755345AbZICOPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 10:15:50 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:42188 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754950AbZICOPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 10:15:49 -0400
Subject: Re: [PATCH 1/2] AB3100 regulator support v4
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Linus Walleij <linus.walleij@stericsson.com>,
       Samuel Ortiz <sameo@linux.intel.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Samuel Ortiz <sameo@linux.intel.com>,
       Russell King <linux@arm.linux.org.uk>
In-Reply-To: <1251982396-23790-1-git-send-email-linus.walleij@stericsson.com>
References: <1251982396-23790-1-git-send-email-linus.walleij@stericsson.com>
Content-Type: text/plain
Date: Thu, 03 Sep 2009 15:15:48 +0100
Message-Id: <1251987348.6735.49.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-03 at 14:53 +0200, Linus Walleij wrote:
> This adds support for the regulators found in the AB3100
> Mixed-Signal IC.
> 
> It further also defines platform data for the ST-Ericsson
> U300 platform and extends the AB3100 MFD driver so that
> platform/board data with regulation constraints and an init
> function can be passed down all the way from the board to
> the regulators.
> 

<snip>

> +static int ab3100_disable_regulator(struct regulator_dev *reg)
> +{
> +	struct ab3100_regulator *abreg = reg->reg_data;
> +	int err;
> +	u8 regval;
> +
> +	/*
> +	 * LDO D is a special regulator. When it is disabled, the entire
> +	 * system is shut down. So this is handled specially.
> +	 */
> +	if (abreg->regreg == AB3100_LDO_D) {
> +		int i;
> +
> +		dev_info(&reg->dev, "disabling LDO D - shut down system\n");
> +		/*
> +		 * Set regulators to default values, ignore any errors,
> +		 * we're going DOWN
> +		 */
> +		for (i = 0; i < ARRAY_SIZE(ab3100_reg_init_order); i++) {
> +			(void) ab3100_set_register_interruptible(abreg->ab3100,
> +					ab3100_reg_init_order[i],
> +					abreg->plfdata->reg_initvals[i]);
> +		}
> +
> +		/* Setting LDO D to 0x00 cuts the power to the SoC */
> +		return ab3100_set_register_interruptible(abreg->ab3100,
> +							 AB3100_LDO_D, 0x00U);
> +
> +	}
> +
> +	/*
> +	 * All other regulators are handled here
> +	 */
> +	err = ab3100_get_register_interruptible(abreg->ab3100, abreg->regreg,
> +						&regval);
> +	if (err) {
> +		dev_err(&reg->dev, "unable to get register 0x%x\n",
> +			abreg->regreg);
> +		return err;
> +	}
> +	regval &= ~AB3100_REG_ON_MASK;
> +	return ab3100_set_register_interruptible(abreg->ab3100, abreg->regreg,
> +						 regval);
> +}

Just wondering if you had looked at the regulator supplier field in
struct regulator_init_data. It's intention was to allow LDO D to be
switched OFF only when all it's consumer regulators were OFF. Likewise
it would also switch this regulator ON if any of it's children were
switched ON.

I assume for this PMIC it would not be useful as it looks like this LDO
is supplying all other PMIC regulators and is ultimately being used as
master power ON/OFF switch ? 

Samuel, are you happy for this to go via mfd for simpler merging ?
If so :-

Signed-off-by: Liam Girdwood <lrg@slimlogic.co.uk>

Thanks

Liam

