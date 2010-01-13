Return-Path: <linux-kernel-owner+w=401wt.eu-S1754537Ab0AMNSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537Ab0AMNSn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 08:18:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754365Ab0AMNSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 08:18:42 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51482 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754268Ab0AMNSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 08:18:41 -0500
Date: Wed, 13 Jan 2010 13:18:40 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Adrian Hunter <adrian.hunter@nokia.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
       "Quadros Roger (Nokia-D/Helsinki)" <roger.quadros@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: Add 'start-up time' to fixed voltage
 regulators
Message-ID: <20100113131840.GF27473@rakim.wolfsonmicro.main>
References: <4B4DB562.2080601@nokia.com>
 <20100113120327.GB27473@rakim.wolfsonmicro.main>
 <4B4DB94E.8080602@nokia.com>
 <20100113122612.GC27473@rakim.wolfsonmicro.main>
 <4B4DC66C.5050106@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B4DC66C.5050106@nokia.com>
X-Cookie: Kiss me twice.  I'm schizophrenic.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 13, 2010 at 03:11:08PM +0200, Adrian Hunter wrote:
> From bd97e65b280be528239e3932da8be512ce7785ed Mon Sep 17 00:00:00 2001
> From: Adrian Hunter <adrian.hunter@nokia.com>
> Date: Tue, 12 Jan 2010 12:25:13 +0200
> Subject: [PATCH] regulator: Add 'start-up time' to fixed voltage regulators
> 
> Add a field to specify a delay for the start-up time of
> a fixed voltage regulator.
> 
> Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>

Looks good, thanks.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

> ---
> drivers/regulator/fixed.c       |    5 +++++
> include/linux/regulator/fixed.h |    2 ++
> 2 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
> index f9f516a..40d4080 100644
> --- a/drivers/regulator/fixed.c
> +++ b/drivers/regulator/fixed.c
> @@ -24,12 +24,14 @@
> #include <linux/regulator/driver.h>
> #include <linux/regulator/fixed.h>
> #include <linux/gpio.h>
> +#include <linux/delay.h>
> 
> struct fixed_voltage_data {
> 	struct regulator_desc desc;
> 	struct regulator_dev *dev;
> 	int microvolts;
> 	int gpio;
> +	unsigned startup_delay;
> 	unsigned enable_high:1;
> 	unsigned is_enabled:1;
> };
> @@ -48,6 +50,8 @@ static int fixed_voltage_enable(struct regulator_dev *dev)
> 	if (gpio_is_valid(data->gpio)) {
> 		gpio_set_value_cansleep(data->gpio, data->enable_high);
> 		data->is_enabled = 1;
> +		if (data->startup_delay)
> +			udelay(data->startup_delay);
> 	}
> 
> 	return 0;
> @@ -117,6 +121,7 @@ static int regulator_fixed_voltage_probe(struct platform_device *pdev)
> 
> 	drvdata->microvolts = config->microvolts;
> 	drvdata->gpio = config->gpio;
> +	drvdata->startup_delay = config->startup_delay;
> 
> 	if (gpio_is_valid(config->gpio)) {
> 		drvdata->enable_high = config->enable_high;
> diff --git a/include/linux/regulator/fixed.h b/include/linux/regulator/fixed.h
> index e94a4a1..02edef1 100644
> --- a/include/linux/regulator/fixed.h
> +++ b/include/linux/regulator/fixed.h
> @@ -25,6 +25,7 @@ struct regulator_init_data;
>  * @microvolts:		Output voltage of regulator
>  * @gpio:		GPIO to use for enable control
>  * 			set to -EINVAL if not used
> + * @startup_delay:	Start-up time in microseconds
>  * @enable_high:	Polarity of enable GPIO
>  *			1 = Active high, 0 = Active low
>  * @enabled_at_boot:	Whether regulator has been enabled at
> @@ -41,6 +42,7 @@ struct fixed_voltage_config {
> 	const char *supply_name;
> 	int microvolts;
> 	int gpio;
> +	unsigned startup_delay;
> 	unsigned enable_high:1;
> 	unsigned enabled_at_boot:1;
> 	struct regulator_init_data *init_data;
> -- 
> 1.6.0.4
