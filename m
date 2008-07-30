Return-Path: <linux-kernel-owner+w=401wt.eu-S1761396AbYG3K2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761396AbYG3K2e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 06:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754862AbYG3K2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 06:28:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40299 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754787AbYG3K2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 06:28:23 -0400
Date: Wed, 30 Jul 2008 03:27:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Marc Pignat <marc.pignat@hevs.ch>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
       David Brownell <david-b@pacbell.net>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Tobias Himmer <tobias@himmer-online.de>,
       "Hans J. Koch" <hjk@linutronix.de>
Subject: Re: [RFC,PATCH v2] hwmon: ADC124S501 generic driver
Message-Id: <20080730032729.75033fc7.akpm@linux-foundation.org>
In-Reply-To: <200807301216.01125.marc.pignat@hevs.ch>
References: <200807301216.01125.marc.pignat@hevs.ch>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jul 2008 12:16:00 +0200 Marc Pignat <marc.pignat@hevs.ch> wrote:

> SPI driver for analog to digital converters national semiconductor ADC081S101,
> ADC124S501, ...
> 
> Code for 8 channels by : Tobias Himmer <tobias@himmer-online.de>
> 
> Signed-off-by: Marc Pignat <marc.pignat@hevs.ch>
> ---
> 
> Hi all!
> 
> patch against 2.6.27-rc1, tested on a custom arm board and only compile-tested
> on x86.
> 
> This driver add support for National Semiconductor ADC<bb><c>S<sss> chip family,
> where:
>  * bb  is the resolution in number of bits (8, 10, 12)
>  * c   is the number of channels (1, 2, 4, 8)
>  * sss is the maximum conversion speed (021 for 200 kSPS, 051 for 500
>    kSPS and 101 for 1 MSPS)
> 
> Changes from v1:
>  * error recovery fixed
>  * support for 8 channels, thanks to Tobias
>  * better CodingStyle
> 
> Thanks for your comments and testing ;)
> 

I think you forgot this bit:

diff -puN drivers/hwmon/adcxx.c~hwmon-adc124s501-generic-driver-cleanup drivers/hwmon/adcxx.c
--- a/drivers/hwmon/adcxx.c~hwmon-adc124s501-generic-driver-cleanup
+++ a/drivers/hwmon/adcxx.c
@@ -61,7 +61,6 @@ static ssize_t adcxx_read(struct device 
 	struct spi_device *spi = to_spi_device(dev);
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct adcxx *adc = dev_get_drvdata(&spi->dev);
-
 	u8 tx_buf[2] = { attr->index << 3 }; /* other bits are don't care */
 	u8 rx_buf[2];
 	int status;
@@ -100,7 +99,6 @@ static ssize_t adcxx_show_max(struct dev
 {
 	struct spi_device *spi = to_spi_device(dev);
 	struct adcxx *adc = dev_get_drvdata(&spi->dev);
-
 	u32 reference;
 
 	if (mutex_lock_interruptible(&adc->lock))
@@ -118,7 +116,6 @@ static ssize_t adcxx_set_max(struct devi
 {
 	struct spi_device *spi = to_spi_device(dev);
 	struct adcxx *adc = dev_get_drvdata(&spi->dev);
-
 	unsigned long value;
 
 	if (strict_strtoul(buf, 10, &value))
_

OK?

> diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
> index 00ff533..9c4a579 100644
> --- a/drivers/hwmon/Kconfig
> +++ b/drivers/hwmon/Kconfig
> @@ -390,6 +390,22 @@ config SENSORS_LM70
>  	  This driver can also be built as a module.  If so, the module
>  	  will be called lm70.
>  
> +config SENSORS_ADCXX
> +	tristate "National Semiconductor ADCxxxSxxx"
> +	depends on SPI_MASTER && EXPERIMENTAL
> +	help
> +	  If you say yes here you get support for the National Semiconductor
> +	  ADC<bb><c>S<sss> chip family, where
> +	  * bb  is the resolution in number of bits (8, 10, 12)
> +	  * c   is the number of channels (1, 2, 4)
> +	  * sss is the maximum conversion speed (021 for 200 kSPS, 051 for 500
> +	    kSPS and 101 for 1 MSPS)
> +
> +	  Examples : ADC081S101, ADC124S501, ...
> +
> +	  This driver can also be built as a module.  If so, the module
> +	  will be called adcxx.

hm, I wonder if it really needs to be EXPERIMENTAL.

> +static struct spi_driver adcxx1s_driver = {
> +	.driver = {
> +		.name	= "adcxx1s",
> +		.owner	= THIS_MODULE,
> +	},
> +	.probe	= adcxx1s_probe,
> +	.remove	= __devexit_p(adcxx_remove),
> +};
> +
> +static struct spi_driver adcxx2s_driver = {
> +	.driver = {
> +		.name	= "adcxx2s",
> +		.owner	= THIS_MODULE,
> +	},
> +	.probe	= adcxx2s_probe,
> +	.remove	= __devexit_p(adcxx_remove),
> +};
> +
> +static struct spi_driver adcxx4s_driver = {
> +	.driver = {
> +		.name	= "adcxx4s",
> +		.owner	= THIS_MODULE,
> +	},
> +	.probe	= adcxx4s_probe,
> +	.remove	= __devexit_p(adcxx_remove),
> +};

Is suspend/resume support needed on this device?

