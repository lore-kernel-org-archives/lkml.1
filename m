Return-Path: <linux-kernel-owner+w=401wt.eu-S1753551AbZHGPyD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551AbZHGPyD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 11:54:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752238AbZHGPyC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 11:54:02 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:47594 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbZHGPyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 11:54:00 -0400
Date: Fri, 7 Aug 2009 16:53:59 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Anuj Aggarwal <anuj.aggarwal@ti.com>
Cc: lrg@slimlogic.co.uk, linux-omap@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] Regulator: Add TPS65023 regulator driver
Message-ID: <20090807155358.GI639@sirena.org.uk>
References: <1249658726-10769-1-git-send-email-anuj.aggarwal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249658726-10769-1-git-send-email-anuj.aggarwal@ti.com>
X-Cookie: Sic Transit Gloria Thursdi.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 07, 2009 at 08:55:26PM +0530, Anuj Aggarwal wrote:

> +static int tps_65023_set_bits(struct tps_pmic *tps, u8 reg, u8 mask)
> +{
> +	u8 data;
> +	int err;
> +
> +	err = tps_65023_read_reg(tps, reg, &data);
> +	if (err) {
> +		pr_err("Read from reg 0x%x failed\n", reg);
> +		return err;
> +	}
> +
> +	data |= mask;
> +
> +	return tps_65023_write_reg(tps, reg, data);
> +}

This and the clear_bits() function should use a lock to stop data
corruption if two simultaneous read/modify/write operations occur.  The
regulator framework doesn't stop two different regulators being updated
simultaneously.

> +	if (min_uV < tps->info[dcdc]->min_uV 
> +			|| min_uV > tps->info[dcdc]->max_uV)
> +		return -EINVAL;

Odd indentation for the or clause here and elsewhere.

> +	for (vsel = 0; vsel < tps->info[dcdc]->table_len; vsel++) {
> +		int mV = tps->info[dcdc]->table[vsel];
> +		int uV = mV * 1000;
> +
> +		/* Break at the first in-range value */
> +		if (min_uV <= uV && uV <= max_uV)
> +			break;
> +	}
> +
> +	/* write to the register */
> +	return tps_65023_write_reg(tps, TPS65023_REG_DEF_CORE, vsel);

There should be a check after the for loop to make sure we actually
found a voltage - the min/max check earlier isn't enough since a
consumer could ask for a very narrow voltage range that the chip is
unable to generate.  For example, if 1.1V and 1.2V are supported a
request for exactly 1.15V would fail to match.

The same issue applies to the LDO.

> +	ret = tps_65023_read_reg(tps, TPS65023_REG_LDO_CTRL, &reg_ctrl);
> +
> +	if (ret < 0)
> +		return ret;
> +
> +	reg_ctrl &= TPS65023_LDO_CTRL_LDOx_MASK(ldo - TPS65023_LDO_1);
> +	reg_ctrl |= 
> +		(vsel << (TPS65023_LDO_CTRL_LDOx_SHIFT(ldo - TPS65023_LDO_1)));
> +	return tps_65023_write_reg(tps, TPS65023_REG_LDO_CTRL, reg_ctrl);

This will also have the locking issue I mentioned earlier with the set
bits operation.

> +/* Operations permitted on VDCDCx */
> +static struct regulator_ops tps65023_dcdc_ops = {
> +	.is_enabled = tps65023_dcdc_is_enabled,
> +	.enable = tps65023_dcdc_enable,
> +	.disable = tps65023_dcdc_disable,
> +	.get_voltage = tps65023_dcdc_get_voltage,
> +	.set_voltage = tps65023_dcdc_set_voltage,

It'd be good to also implement list_voltage().

> +								init_data, tps);
> +		if (IS_ERR(rdev)) {
> +			dev_err(&client->dev, "failed to register %s\n",
> +				id->name);
> +			kfree(tps);
> +			return PTR_ERR(rdev);
> +		}

This should go through and deallocate any regulators that were
succesfully allocated if it hits an error.

> +/* Supported voltage values for regulators */
> +static const u16 VDCDC1_VSEL_table[] = {

It'd feel more natural when reading the source if these tables were at
the top of the driver (so the reader knows they're there when going from
the top of the driver to the bottom) but that's just a personal
preference.

> +static const struct tps_info tps65023_regs[] = {
> +	{
> +	.name = "VDCDC1",
> +	.min_uV =  800000,
> +	.max_uV = 1600000,
> +	.fixed = 0,
> +	.table_len = ARRAY_SIZE(VDCDC1_VSEL_table),
> +	.table = VDCDC1_VSEL_table,
> +	},

Indentation here is a bit non-standard - I'd expect either the {} around
the elements to be in column 0 or another level of indentation for the
fields.

> +	{
> +	.name = "VDCDC2",
> +	.min_uV =  3300000,
> +	.max_uV = 3300000,
> +	.fixed = 1,
> +	.table_len = 0,
> +	},

You could drop the fixed flag and just have fixed be inferred from
min_uV == max_uV?

> +static struct i2c_driver tps_65023_i2c_driver = {
> +	.driver = {
> +		.name = "tps_65023_pwr",
> +		.owner = THIS_MODULE,
> +	},

It'd be more natural to drop the _pwr from the name of the driver - most
I2C devices have a name which is just the chip name (and normally with
no _s too so tps65023).
