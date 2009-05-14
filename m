Return-Path: <linux-kernel-owner+w=401wt.eu-S1754334AbZENJ5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334AbZENJ5T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 05:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbZENJ5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 05:57:03 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:42142 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427AbZENJ5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 05:57:01 -0400
Date: Thu, 14 May 2009 10:57:01 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "'Liam Girdwood'" <lrg@slimlogic.co.uk>,
       "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>
Subject: Re: [PATCH] LP3971 PMIC regulator driver
Message-ID: <20090514095700.GA28291@sirena.org.uk>
References: <E4D3F24EA6C9E54F817833EAE0D912AC02245E982A@bssrvexch01.BS.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E4D3F24EA6C9E54F817833EAE0D912AC02245E982A@bssrvexch01.BS.local>
X-Cookie: You too can wear a nose mitten.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 14, 2009 at 09:33:40AM +0200, Marek Szyprowski wrote:
> This patch adds regulator drivers for National Semiconductors LP3971 PMIC.
> This LP3971 PMIC controller has 3 DC/DC voltage converters and 5 low drop-out
> (LDO) regulators. LP3971 PMIC controller uses I2C interface.
> 
> Reviewed-by: Kyungmin Park <kyungmin.park@samsung.com>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>

This looks basically good, a few comments below but personally I'd be
inclined to merge this as-is and deal with the remaining issues as
separate patches so:

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

It'd be good to also implement list_voltage().

> +static int lp3971_dcdc_get_voltage(struct regulator_dev *dev)
> +{
> +       struct lp3971 *lp3971 = rdev_get_drvdata(dev);
> +       int buck = rdev_get_id(dev) - LP3971_DCDC1;
> +       u16 reg;
> +       int val;
> +
> +       reg = lp3971_reg_read(lp3971, LP3971_BUCK_TARGET_VOL1_REG(buck));
> +       reg &= BUCK_TARGET_VOL_MASK;
> +
> +       if (reg <= BUCK_TARGET_VOL_MAX_IDX)
> +               val = 1000 * buck_voltage_map[reg];
> +       else
> +               val = 0;

I'd expect some kind of warning to be displayed here?

> +       /* Detect LP3971 (initial system control 1 reg is '0x60') */
> +       ret = lp3971_i2c_read(i2c, LP3971_SYS_CONTROL1_REG, 1, &val);
> +       if (ret < 0) {
> +               dev_err(&i2c->dev, "failed to detect device\n");
> +               goto err_detect;
> +       }
> +

You don't actually appear to check the value you read back here?
