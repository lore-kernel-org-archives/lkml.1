Return-Path: <linux-kernel-owner+w=401wt.eu-S932631AbZHDJQP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932631AbZHDJQP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 05:16:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932584AbZHDJQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 05:16:15 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:42014 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932564AbZHDJQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 05:16:14 -0400
Subject: Re: [PATCH] Regulator: Implement list_voltage for pcf50633
 regulator driver.
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1249344232-19784-1-git-send-email-lars@metafoo.de>
References: <1249344232-19784-1-git-send-email-lars@metafoo.de>
Content-Type: text/plain
Date: Tue, 04 Aug 2009 10:16:06 +0100
Message-Id: <1249377366.4248.156.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-04 at 02:03 +0200, Lars-Peter Clausen wrote:
> This patch implements list_voltage for the pcf50644 regulator driver.
> As the voltages are linearly scaled the code to convert register values to
> voltages can be reused and most of the code can be shared with get_voltage.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> ---
>  drivers/regulator/pcf50633-regulator.c |   96 +++++++++++++++++++++-----------
>  1 files changed, 64 insertions(+), 32 deletions(-)
> 
> diff --git a/drivers/regulator/pcf50633-regulator.c b/drivers/regulator/pcf50633-regulator.c
> index 8e14900..e19f451 100644
> --- a/drivers/regulator/pcf50633-regulator.c
> +++ b/drivers/regulator/pcf50633-regulator.c
> @@ -24,11 +24,12 @@
>  #include <linux/mfd/pcf50633/core.h>
>  #include <linux/mfd/pcf50633/pmic.h>
>  
> -#define PCF50633_REGULATOR(_name, _id) 		\
> +#define PCF50633_REGULATOR(_name, _id, _n) 		\
>  	{					\
>  		.name = _name, 			\
>  		.id = _id,			\
>  		.ops = &pcf50633_regulator_ops,	\
> +		.n_voltages = _n, \
>  		.type = REGULATOR_VOLTAGE, 	\
>  		.owner = THIS_MODULE, 		\
>  	}
> @@ -149,11 +150,42 @@ static int pcf50633_regulator_set_voltage(struct regulator_dev *rdev,
>  	return pcf50633_reg_write(pcf, regnr, volt_bits);
>  }
>  
> +static int pcf50633_regulator_voltage_value(enum pcf50633_regulator_id id,
> +						u8 bits)
> +{
> +	int millivolts;
> +
> +	switch (id) {
> +	case PCF50633_REGULATOR_AUTO:
> +		millivolts = auto_voltage_value(bits);
> +		break;
> +	case PCF50633_REGULATOR_DOWN1:
> +		millivolts = down_voltage_value(bits);
> +		break;
> +	case PCF50633_REGULATOR_DOWN2:
> +		millivolts = down_voltage_value(bits);
> +		break;
> +	case PCF50633_REGULATOR_LDO1:
> +	case PCF50633_REGULATOR_LDO2:
> +	case PCF50633_REGULATOR_LDO3:
> +	case PCF50633_REGULATOR_LDO4:
> +	case PCF50633_REGULATOR_LDO5:
> +	case PCF50633_REGULATOR_LDO6:
> +	case PCF50633_REGULATOR_HCLDO:
> +		millivolts = ldo_voltage_value(bits);
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return millivolts * 1000;
> +}
> +
>  static int pcf50633_regulator_get_voltage(struct regulator_dev *rdev)
>  {
>  	struct pcf50633 *pcf;
> -	int regulator_id, millivolts, volt_bits;
> -	u8 regnr;
> +	int regulator_id;
> +	u8 volt_bits, regnr;
>  
>  	pcf = rdev_get_drvdata(rdev);
>  
> @@ -164,33 +196,32 @@ static int pcf50633_regulator_get_voltage(struct regulator_dev *rdev)
>  	regnr = pcf50633_regulator_registers[regulator_id];
>  
>  	volt_bits = pcf50633_reg_read(pcf, regnr);
> -	if (volt_bits < 0)
> -		return -1;
> +
> +	return pcf50633_regulator_voltage_value(regulator_id, volt_bits);
> +}
> +
> +static int pcf50633_regulator_list_voltage(struct regulator_dev *rdev,
> +						unsigned int index)
> +{
> +	struct pcf50633 *pcf;
> +	int regulator_id;
> +
> +	pcf = rdev_get_drvdata(rdev);;

Extra ; above

Fixed and applied.

Thanks

Liam

