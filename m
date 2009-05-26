Return-Path: <linux-kernel-owner+w=401wt.eu-S1758523AbZEZVbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758523AbZEZVbv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 17:31:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758229AbZEZVbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 17:31:42 -0400
Received: from smtp2-g21.free.fr ([212.27.42.2]:47769 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757618AbZEZVbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 17:31:40 -0400
To: Philipp Zabel <philipp.zabel@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] regulator/max1586: support increased V3 voltage range
References: <1243366748-8428-1-git-send-email-philipp.zabel@gmail.com>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Tue, 26 May 2009 23:31:30 +0200
Message-ID: <87zlczblfx.fsf@free.fr>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Philipp Zabel <philipp.zabel@gmail.com> writes:

> The V3 regulator can be configured with an external resistor
> connected to the feedback pin (R24 in the data sheet) to
> increase the voltage range.
>
> For example, hx4700 has R24 = 3.32 kOhm to achieve a maximum
> V3 voltage of 1.55 V which is needed for 624 MHz CPU frequency.
Cool.
Let me ask minor changes to the calculation formula, and r24 parameter.

>
> Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
> ---
>  drivers/regulator/max1586.c       |   75 ++++++++++++++++++++++++++++---------
>  include/linux/regulator/max1586.h |    7 +++
>  2 files changed, 64 insertions(+), 18 deletions(-)
>
> diff --git a/drivers/regulator/max1586.c b/drivers/regulator/max1586.c
> index bbbb55f..db11099 100644
> --- a/drivers/regulator/max1586.c
> +++ b/drivers/regulator/max1586.c
> @@ -27,43 +27,56 @@
>  #define MAX1586_V3_MAX_VSEL 31
>  #define MAX1586_V6_MAX_VSEL 3
>  
> -#define MAX1586_V3_MIN_UV   700000
> -#define MAX1586_V3_MAX_UV  1475000
> -#define MAX1586_V3_STEP_UV   25000
These 3 should be kept I think, see below.

> -
>  #define MAX1586_V6_MIN_UV        0
>  #define MAX1586_V6_MAX_UV  3000000
>  
>  #define I2C_V3_SELECT (0 << 5)
>  #define I2C_V6_SELECT (1 << 5)
>  
> +struct max1586_data {
> +	struct i2c_client *client;
> +
> +	/* min/max V3 voltage */
> +	int min_uV;
> +	int max_uV;

> +};
> +
>  /*
>   * V3 voltage
>   * On I2C bus, sending a "x" byte to the max1586 means :
> - *   set V3 to 0.700V + (x & 0x1f) * 0.025V
> + *   set V3 to 0.700V + (x & 0x1f) * 0.025V,
> + *   set V3 to 0.730V + (x & 0x1f) * 0.026V,
> + *   set V3 to 0.750V + (x & 0x1f) * 0.027V or
> + *   set V3 to 0.780V + (x & 0x1f) * 0.028V
> + * depending on the external resistance R24.
That's not really the full truth.

The real V3 is (0.700V + (x & 0x1f) * 0.025V) * gain, where :
 - if R24 is not connected, gain = 1
 - if R24 and R25 are connected, gain = 1 + R24/R25 + R24/185.5
   Here, it should be assumed that R25 >> 10k.ohm, which means that R24/R25
   becomes meaningless compared to R24/185.5.
   Therefore, the formula becomes:
     gain = 1 + R24/185.5
For reference, R24 and R25 are described in Max1586 datasheet, in figure7
(extending the maximum core voltage range).

I'd like that put in the comment please.

>  
>  static int max1586_v3_set(struct regulator_dev *rdev, int min_uV, int max_uV)
>  {
> -	struct i2c_client *client = rdev_get_drvdata(rdev);
> +	struct max1586_data *max1586 = rdev_get_drvdata(rdev);
> +	struct i2c_client *client = max1586->client;
> +	unsigned range_uV = max1586->max_uV - max1586->min_uV;
>  	unsigned selector;
>  	u8 v3_prog;
>  
> -	if (min_uV < MAX1586_V3_MIN_UV || min_uV > MAX1586_V3_MAX_UV)
> -		return -EINVAL;
> -	if (max_uV < MAX1586_V3_MIN_UV || max_uV > MAX1586_V3_MAX_UV)
> +	if (min_uV > max1586->max_uV || max_uV < max1586->min_uV)
>  		return -EINVAL;
> +	if (min_uV < max1586->min_uV)
> +		min_uV = max1586->min_uV;
>  
> -	selector = (min_uV - MAX1586_V3_MIN_UV) / MAX1586_V3_STEP_UV;
> -	if (max1586_v3_calc_voltage(selector) > max_uV)
> +	selector = (min_uV - max1586->min_uV) * 31 / range_uV;
                                                \-> ???
Why 31 ? Could I have a define here, and probably that define would be a value
of 32 (as there are 32 different steps, not 31).

> +	if (max1586_v3_calc_voltage(max1586, selector) > max_uV)
>  		return -EINVAL;
>  
>  	dev_dbg(&client->dev, "changing voltage v3 to %dmv\n",
> -		max1586_v3_calc_voltage(selector) / 1000);
> +		max1586_v3_calc_voltage(max1586, selector) / 1000);
>  
>  	v3_prog = I2C_V3_SELECT | (u8) selector;
>  	return i2c_smbus_write_byte(client, v3_prog);
> @@ -71,9 +84,11 @@ static int max1586_v3_set(struct regulator_dev *rdev, int min_uV, int max_uV)
>  
>  static int max1586_v3_list(struct regulator_dev *rdev, unsigned selector)
>  {
> +	struct max1586_data *max1586 = rdev_get_drvdata(rdev);
> +
>  	if (selector > MAX1586_V3_MAX_VSEL)
>  		return -EINVAL;
> -	return max1586_v3_calc_voltage(selector);
> +	return max1586_v3_calc_voltage(max1586, selector);
>  }
>  
>  /*
> @@ -164,12 +179,33 @@ static int max1586_pmic_probe(struct i2c_client *client,
>  {
>  	struct regulator_dev **rdev;
>  	struct max1586_platform_data *pdata = client->dev.platform_data;
> -	int i, id, ret = 0;
> +	struct max1586_data *max1586;
> +	int i, id, ret = -ENOMEM;
>  
>  	rdev = kzalloc(sizeof(struct regulator_dev *) * (MAX1586_V6 + 1),
>  		       GFP_KERNEL);
>  	if (!rdev)
> -		return -ENOMEM;
> +		goto out;
> +
> +	max1586 = kzalloc(sizeof(struct max1586_data *), GFP_KERNEL);
> +	if (!max1586)
> +		goto out_unmap;
> +
> +	max1586->client = client;

> +	switch (pdata->r24) {
> +	case MAX1586_R24_3k32:
> +		max1586->min_uV = 730000;
> +		max1586->max_uV = 1550000;
> +		break;
> +	case MAX1586_R24_5k11:
> +		max1586->min_uV = 750000;
> +		max1586->max_uV = 1600000;
> +		break;
> +	case MAX1586_R24_7k5:
> +		max1586->min_uV = 780000;
> +		max1586->max_uV = 1650000;
> +		break;
> +	}
I would like that changed to something more or less like :
if (pdata->r24 == 0)
	gain = 1;
else
	gain = 1 + R24/185.5;
max1586->min_uV = gain * MAX1586_V3_IN_UV;
max1586->max_uV = gain * MAX1586_V3_MAX_UV;

>  
>  	ret = -EINVAL;
>  	for (i = 0; i < pdata->num_subdevs && i <= MAX1586_V6; i++) {
> @@ -182,7 +218,7 @@ static int max1586_pmic_probe(struct i2c_client *client,
>  		}
>  		rdev[i] = regulator_register(&max1586_reg[id], &client->dev,
>  					     pdata->subdevs[i].platform_data,
> -					     client);
> +					     max1586);
>  		if (IS_ERR(rdev[i])) {
>  			ret = PTR_ERR(rdev[i]);
>  			dev_err(&client->dev, "failed to register %s\n",
> @@ -198,7 +234,10 @@ static int max1586_pmic_probe(struct i2c_client *client,
>  err:
>  	while (--i >= 0)
>  		regulator_unregister(rdev[i]);
> +	kfree(max1586);
> +out_unmap:
>  	kfree(rdev);
> +out:
>  	return ret;
>  }
>  
> diff --git a/include/linux/regulator/max1586.h b/include/linux/regulator/max1586.h
> index 2056973..cdf2010 100644
> --- a/include/linux/regulator/max1586.h
> +++ b/include/linux/regulator/max1586.h
> @@ -26,6 +26,10 @@
>  #define MAX1586_V3 0
>  #define MAX1586_V6 1
>  
> +#define MAX1586_R24_3k32 3320
> +#define MAX1586_R24_5k11 5110
> +#define MAX1586_R24_7k5  7500
This could be gone, as R24 will define the exact value of R24 in ohms.

> +
>  /**
>   * max1586_subdev_data - regulator data
>   * @id: regulator Id (either MAX1586_V3 or MAX1586_V6)
> @@ -43,10 +47,13 @@ struct max1586_subdev_data {
>   * @num_subdevs: number of regultors used (may be 1 or 2)
>   * @subdevs: regulator used
>   *           At most, there will be a regulator for V3 and one for V6 voltages.
> + * @r24: external regulator to increase V3 range
Rather :
+ * @r24: external resistor value to increase V3 range (in ohms), or 0 if none

Cheers.

--
Robert
