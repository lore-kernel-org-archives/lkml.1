Return-Path: <linux-kernel-owner+w=401wt.eu-S1753314AbYGXP2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314AbYGXP2g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 11:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752929AbYGXP20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 11:28:26 -0400
Received: from www.tglx.de ([62.245.132.106]:33701 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752885AbYGXP2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 11:28:25 -0400
Date: Thu, 24 Jul 2008 17:25:56 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Tobias Himmer <tobias@himmer-online.de>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
       marc.pignat@hevs.ch
Subject: Re: [RFC,PATCH v1] hwmon: ADC124S501 generic driver
Message-ID: <20080724152556.GD2254@local>
References: <200807241151.50915.tobias@himmer-online.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807241151.50915.tobias@himmer-online.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2008 at 11:51:50AM +0200, Tobias Himmer wrote:
> Hi Marc,
> 
> I just wrote a similar driver for the ADC088S052.

Bad luck ;-)

> Yesterday I noticed your patch and successfully tested a slightly
> modified version of it that supports 8 channels.
> The patch below goes on top of yours.

Nice, both patches combined in mainline would be nice. Works for me.

Thanks,
Hans

> 
> Bye
> 
> Tobias
> 
> Signed-off-by: Tobias Himmer <tobias@himmer-online.de>

Acked-by: Hans J. Koch <hjk@linutronix.de>

> ---
> 
> Index: linux-2.6.26-rc/drivers/hwmon/adcxx.c
> ===================================================================
> --- linux-2.6.26-rc.orig/drivers/hwmon/adcxx.c
> +++ linux-2.6.26-rc/drivers/hwmon/adcxx.c
> @@ -5,13 +5,15 @@
>   *
>   * Copyright (c) 2008 Marc Pignat <marc.pignat@hevs.ch>
>   *
> + * 8 channel support added by Tobias Himmer <tobias@himmer-online.de>
> + *
>   * The adcxx4s communicates with a host processor via an SPI/Microwire Bus
>   * interface. This driver supports the whole family of devices with name
>   * ADC<bb><c>S<sss>, where
>   * * bb is the resolution in number of bits (8, 10, 12)
> - * * c is the number of channels (1, 2, 4)
> - * * sss is the maximum conversion speed (021 for 200 kSPS, 051 for 500 kSPS
> - *   and 101 for 1 MSPS)
> + * * c is the number of channels (1, 2, 4, 8)
> + * * sss is the maximum conversion speed (021 for 200 kSPS, 051 / 052 for
> + *   500 kSPS and 101 for 1 MSPS)
>   *
>   * Complete datasheets are available at National's website here:
>   * http://www.national.com/ds/DC/ADC<bb><c>S<sss>.pdf
> @@ -155,6 +157,10 @@ static struct sensor_device_attribute ad
>  	SENSOR_ATTR(in1_input, S_IRUGO, adcxx_read, NULL, 1),
>  	SENSOR_ATTR(in2_input, S_IRUGO, adcxx_read, NULL, 2),
>  	SENSOR_ATTR(in3_input, S_IRUGO, adcxx_read, NULL, 3),
> +	SENSOR_ATTR(in4_input, S_IRUGO, adcxx_read, NULL, 4),
> +	SENSOR_ATTR(in5_input, S_IRUGO, adcxx_read, NULL, 5),
> +	SENSOR_ATTR(in6_input, S_IRUGO, adcxx_read, NULL, 6),
> +	SENSOR_ATTR(in7_input, S_IRUGO, adcxx_read, NULL, 7),
> };
>  
>  /*----------------------------------------------------------------------*/
> @@ -218,6 +224,11 @@ static int __devinit adcxx4s_probe(struc
>  	return adcxx_probe(spi, 4);
> }
>  
> +static int __devinit adcxx8s_probe(struct spi_device *spi)
> +{
> +	return adcxx_probe(spi, 8);
> +}
> +
>  static int __devexit adcxx_remove(struct spi_device *spi)
> {
>  	struct adcxx *adc = dev_get_drvdata(&spi->dev);
> @@ -259,6 +270,15 @@ static struct spi_driver adcxx4s_driver 
>  	.remove	= __devexit_p(adcxx_remove),
> };
>  
> +static struct spi_driver adcxx8s_driver = {
> +	.driver = {
> +		.name	= "adcxx8s",
> +		.owner	= THIS_MODULE,
> +	},
> +	.probe	= adcxx8s_probe,
> +	.remove	= __devexit_p(adcxx_remove),
> +};
> +
>  static int __init init_adcxx(void)
> {
>  	int status;
> @@ -270,7 +290,11 @@ static int __init init_adcxx(void)
>  	if (status)
>  		return status;
>  
> -	return spi_register_driver(&adcxx4s_driver);
> +	status = spi_register_driver(&adcxx4s_driver);
> +	if (status)
> +		return status;
> +
> +	return spi_register_driver(&adcxx8s_driver);
> }
>  
>  static void __exit exit_adcxx(void)
> @@ -278,6 +302,7 @@ static void __exit exit_adcxx(void)
>  	spi_unregister_driver(&adcxx1s_driver);
>  	spi_unregister_driver(&adcxx2s_driver);
>  	spi_unregister_driver(&adcxx4s_driver);
> +	spi_unregister_driver(&adcxx8s_driver);
> }
>  
>  module_init(init_adcxx);
> @@ -290,3 +315,4 @@ MODULE_LICENSE("GPL");
>  MODULE_ALIAS("adcxx1s");
>  MODULE_ALIAS("adcxx2s");
>  MODULE_ALIAS("adcxx4s");
> +MODULE_ALIAS("adcxx8s");
> Index: linux-2.6.26-rc/drivers/hwmon/Kconfig
> ===================================================================
> --- linux-2.6.26-rc.orig/drivers/hwmon/Kconfig
> +++ linux-2.6.26-rc/drivers/hwmon/Kconfig
> @@ -397,9 +397,9 @@ config SENSORS_ADCXX
>  	  If you say yes here you get support for the National Semiconductor
>  	  ADC<bb><c>S<sss> chip family, where
>  	  * bb  is the resolution in number of bits (8, 10, 12)
> -	  * c   is the number of channels (1, 2, 4)
> -	  * sss is the maximum conversion speed (021 for 200 kSPS, 051 for 500
> -	    kSPS and 101 for 1 MSPS)
> +	  * c   is the number of channels (1, 2, 4, 8)
> +	  * sss is the maximum conversion speed (021 for 200 kSPS, 051 / 052 for
> +	    500 kSPS and 101 for 1 MSPS)
>  
>  	  Examples : ADC081S101, ADC124S501, ...
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
