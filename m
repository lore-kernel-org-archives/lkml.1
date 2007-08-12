Return-Path: <linux-kernel-owner+w=401wt.eu-S935639AbXHLQGB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935639AbXHLQGB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 12:06:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763257AbXHLQFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 12:05:51 -0400
Received: from smtp-100-sunday.nerim.net ([62.4.16.100]:50052 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760742AbXHLQFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 12:05:50 -0400
Date: Sun, 12 Aug 2007 18:06:07 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Mark M. Hoffman" <mhoffman@lightlink.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc1 regression: hwmon/w83627ehf: wrong fan speed
Message-ID: <20070812180607.7ed23553@hyperion.delvare>
In-Reply-To: <20070805162141.GI6221@jupiter.solarsys.private>
References: <46B5B290.4040907@s5r6.in-berlin.de>
	<20070805162141.GI6221@jupiter.solarsys.private>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Sun, 5 Aug 2007 12:21:41 -0400, Mark M. Hoffman wrote:
> Author: Mark M. Hoffman <mhoffman@lightlink.com>
> Date:   Sun Aug 5 12:19:01 2007 -0400
> 
>     hwmon: read fan_div values during probe
>     
>     This patch forces the driver to read the fan divider values during early init.
>     Otherwise, a call to store_fan_min() could access uninitialized variables.
>     
>     Signed-off-by: Mark M. Hoffman <mhoffman@lightlink.com>

Good catch.

Signed-off-by: Jean Delvare <khali@linux-fr.org>

> 
> diff --git a/drivers/hwmon/w83627ehf.c b/drivers/hwmon/w83627ehf.c
> index c51ae2e..bca7fbc 100644
> --- a/drivers/hwmon/w83627ehf.c
> +++ b/drivers/hwmon/w83627ehf.c
> @@ -421,6 +421,31 @@ static void w83627ehf_write_fan_div(struct w83627ehf_data *data, int nr)
>  	}
>  }
>  
> +static void w83627ehf_update_fan_div(struct w83627ehf_data *data)
> +{
> +	int i;
> +
> +	i = w83627ehf_read_value(data, W83627EHF_REG_FANDIV1);
> +	data->fan_div[0] = (i >> 4) & 0x03;
> +	data->fan_div[1] = (i >> 6) & 0x03;
> +	i = w83627ehf_read_value(data, W83627EHF_REG_FANDIV2);
> +	data->fan_div[2] = (i >> 6) & 0x03;
> +	i = w83627ehf_read_value(data, W83627EHF_REG_VBAT);
> +	data->fan_div[0] |= (i >> 3) & 0x04;
> +	data->fan_div[1] |= (i >> 4) & 0x04;
> +	data->fan_div[2] |= (i >> 5) & 0x04;
> +	if (data->has_fan & ((1 << 3) | (1 << 4))) {
> +		i = w83627ehf_read_value(data, W83627EHF_REG_DIODE);
> +		data->fan_div[3] = i & 0x03;
> +		data->fan_div[4] = ((i >> 2) & 0x03)
> +				 | ((i >> 5) & 0x04);
> +	}
> +	if (data->has_fan & (1 << 3)) {
> +		i = w83627ehf_read_value(data, W83627EHF_REG_SMI_OVT);
> +		data->fan_div[3] |= (i >> 5) & 0x04;
> +	}
> +}
> +
>  static struct w83627ehf_data *w83627ehf_update_device(struct device *dev)
>  {
>  	struct w83627ehf_data *data = dev_get_drvdata(dev);
> @@ -432,25 +457,7 @@ static struct w83627ehf_data *w83627ehf_update_device(struct device *dev)
>  	if (time_after(jiffies, data->last_updated + HZ + HZ/2)
>  	 || !data->valid) {
>  		/* Fan clock dividers */
> -		i = w83627ehf_read_value(data, W83627EHF_REG_FANDIV1);
> -		data->fan_div[0] = (i >> 4) & 0x03;
> -		data->fan_div[1] = (i >> 6) & 0x03;
> -		i = w83627ehf_read_value(data, W83627EHF_REG_FANDIV2);
> -		data->fan_div[2] = (i >> 6) & 0x03;
> -		i = w83627ehf_read_value(data, W83627EHF_REG_VBAT);
> -		data->fan_div[0] |= (i >> 3) & 0x04;
> -		data->fan_div[1] |= (i >> 4) & 0x04;
> -		data->fan_div[2] |= (i >> 5) & 0x04;
> -		if (data->has_fan & ((1 << 3) | (1 << 4))) {
> -			i = w83627ehf_read_value(data, W83627EHF_REG_DIODE);
> -			data->fan_div[3] = i & 0x03;
> -			data->fan_div[4] = ((i >> 2) & 0x03)
> -					 | ((i >> 5) & 0x04);
> -		}
> -		if (data->has_fan & (1 << 3)) {
> -			i = w83627ehf_read_value(data, W83627EHF_REG_SMI_OVT);
> -			data->fan_div[3] |= (i >> 5) & 0x04;
> -		}
> +		w83627ehf_update_fan_div(data);
>  
>  		/* Measured voltages and limits */
>  		for (i = 0; i < data->in_num; i++) {
> @@ -1312,6 +1319,9 @@ static int __devinit w83627ehf_probe(struct platform_device *pdev)
>  	if (!(i & (1 << 1)) && (!fan5pin))
>  		data->has_fan |= (1 << 4);
>  
> +	/* Read fan clock dividers immediately */
> +	w83627ehf_update_fan_div(data);
> +
>  	/* Register sysfs hooks */
>    	for (i = 0; i < ARRAY_SIZE(sda_sf3_arrays); i++)
>  		if ((err = device_create_file(dev,


-- 
Jean Delvare
