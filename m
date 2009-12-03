Return-Path: <linux-kernel-owner+w=401wt.eu-S1756035AbZLCO3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035AbZLCO3S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 09:29:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752929AbZLCO3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 09:29:17 -0500
Received: from smtp.nokia.com ([192.100.122.230]:18682 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbZLCO3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 09:29:16 -0500
Message-ID: <4B17CADB.1070406@nokia.com>
Date: Thu, 03 Dec 2009 16:27:39 +0200
From: Adrian Hunter <adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Daniel Mack <daniel@caiaq.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>, Pierre Ossman <pierre@ossman.eu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matt Fleming <matt@console-pimps.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Linus Walleij <linus.walleij@stericsson.com>,
       Eric Miao <eric.y.miao@gmail.com>,
       Robert Jarzmik <robert.jarzmik@free.fr>,
       Cliff Brake <cbrake@bec-systems.com>,
       "Lavinen Jarkko (Nokia-D/Helsinki)" <jarkko.lavinen@nokia.com>,
       "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
       "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] mmc: move regulator handling to core
References: <1259844390-10541-1-git-send-email-daniel@caiaq.de>
In-Reply-To: <1259844390-10541-1-git-send-email-daniel@caiaq.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Dec 2009 14:27:41.0281 (UTC) FILETIME=[C5644D10:01CA7424]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gDaniel Mack wrote:
> At the moment, regulator operations are done from individual mmc host
> drivers. This is a problem because the regulators are not claimed
> exclusively but the mmc core enables and disables them according to the
> return value of regulator_is_enabled(). That can lead to a number of
> problems and warnings when regulators are shared among multiple
> consumers or if regulators are marked as 'always_on'.
> 
> Fix this by moving the some logic to the core, and put the regulator
> reference to the mmc_host struct and let it do its own supply state
> tracking so that the reference counting in the regulator won't get
> confused.
> 
> [Note that I could only compile-test the mmci.c change]
> 
> Signed-off-by: Daniel Mack <daniel@caiaq.de>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Liam Girdwood <lrg@slimlogic.co.uk>
> Cc: Pierre Ossman <pierre@ossman.eu>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Matt Fleming <matt@console-pimps.org>
> Cc: Adrian Hunter <adrian.hunter@nokia.com>
> Cc: David Brownell <dbrownell@users.sourceforge.net>
> Cc: Russell King <rmk+kernel@arm.linux.org.uk>
> Cc: Linus Walleij <linus.walleij@stericsson.com>
> Cc: Eric Miao <eric.y.miao@gmail.com>
> Cc: Robert Jarzmik <robert.jarzmik@free.fr>
> Cc: Cliff Brake <cbrake@bec-systems.com>
> Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>
> Cc: linux-mmc@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> ---
>  drivers/mmc/core/core.c   |   36 ++++++++++++++++++++----------------
>  drivers/mmc/core/host.c   |    3 +++
>  drivers/mmc/host/mmci.c   |   28 ++++++++++++----------------
>  drivers/mmc/host/mmci.h   |    1 -
>  drivers/mmc/host/pxamci.c |   20 ++++++++------------
>  include/linux/mmc/host.h  |   10 ++++++----

What about arch/arm/mach-omap2/mmc-twl4030.c ?


>  6 files changed, 49 insertions(+), 49 deletions(-)
> 
> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> index 7dab2e5..9acb655 100644
> --- a/drivers/mmc/core/core.c
> +++ b/drivers/mmc/core/core.c
> @@ -727,13 +727,13 @@ EXPORT_SYMBOL(mmc_vddrange_to_ocrmask);
>   * regulator.  This would normally be called before registering the
>   * MMC host adapter.
>   */
> -int mmc_regulator_get_ocrmask(struct regulator *supply)
> +int mmc_regulator_get_ocrmask(struct mmc_host *host)
>  {
>  	int			result = 0;
>  	int			count;
>  	int			i;
>  
> -	count = regulator_count_voltages(supply);
> +	count = regulator_count_voltages(host->vcc);
>  	if (count < 0)
>  		return count;
>  
> @@ -741,7 +741,7 @@ int mmc_regulator_get_ocrmask(struct regulator *supply)
>  		int		vdd_uV;
>  		int		vdd_mV;
>  
> -		vdd_uV = regulator_list_voltage(supply, i);
> +		vdd_uV = regulator_list_voltage(host->vcc, i);
>  		if (vdd_uV <= 0)
>  			continue;
>  
> @@ -755,24 +755,22 @@ EXPORT_SYMBOL(mmc_regulator_get_ocrmask);
>  
>  /**
>   * mmc_regulator_set_ocr - set regulator to match host->ios voltage
> + * @host: the mmc_host
>   * @vdd_bit: zero for power off, else a bit number (host->ios.vdd)
> - * @supply: regulator to use
>   *
>   * Returns zero on success, else negative errno.
>   *
>   * MMC host drivers may use this to enable or disable a regulator using
> - * a particular supply voltage.  This would normally be called from the
> + * the registered supply voltage.  This would normally be called from the
>   * set_ios() method.
>   */
> -int mmc_regulator_set_ocr(struct regulator *supply, unsigned short vdd_bit)
> +int mmc_regulator_set_ocr(struct mmc_host *host, unsigned short vdd_bit)
>  {
>  	int			result = 0;
>  	int			min_uV, max_uV;
> -	int			enabled;
>  
> -	enabled = regulator_is_enabled(supply);
> -	if (enabled < 0)
> -		return enabled;
> +	if (!host->vcc || IS_ERR(host->vcc))
> +		return -EINVAL;
>  
>  	if (vdd_bit) {
>  		int		tmp;
> @@ -795,18 +793,24 @@ int mmc_regulator_set_ocr(struct regulator *supply, unsigned short vdd_bit)
>  		/* avoid needless changes to this voltage; the regulator
>  		 * might not allow this operation
>  		 */
> -		voltage = regulator_get_voltage(supply);
> +		voltage = regulator_get_voltage(host->vcc);
>  		if (voltage < 0)
>  			result = voltage;
>  		else if (voltage < min_uV || voltage > max_uV)
> -			result = regulator_set_voltage(supply, min_uV, max_uV);
> +			result = regulator_set_voltage(host->vcc, min_uV, max_uV);
>  		else
>  			result = 0;
>  
> -		if (result == 0 && !enabled)
> -			result = regulator_enable(supply);
> -	} else if (enabled) {
> -		result = regulator_disable(supply);
> +		if (result == 0 && !host->vcc_enabled) {
> +			result = regulator_enable(host->vcc);
> +
> +			if (result == 0)
> +				host->vcc_enabled = 1;
> +		}
> +	} else if (host->vcc_enabled) {
> +		result = regulator_disable(host->vcc);
> +		if (result == 0)
> +			host->vcc_enabled = 0;
>  	}
>  
>  	return result;
> diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
> index a268d12..f422d1f 100644
> --- a/drivers/mmc/core/host.c
> +++ b/drivers/mmc/core/host.c
> @@ -18,6 +18,7 @@
>  #include <linux/leds.h>
>  
>  #include <linux/mmc/host.h>
> +#include <linux/regulator/consumer.h>
>  
>  #include "core.h"
>  #include "host.h"
> @@ -154,6 +155,8 @@ void mmc_remove_host(struct mmc_host *host)
>  	mmc_remove_host_debugfs(host);
>  #endif
>  
> +	regulator_put(host->vcc);
> +

If the core is doing a 'regulator_put()' shouldn't it also be doing
a 'regulator_get()'?  Why not leave it to the drivers?

>  	device_del(&host->class_dev);
>  
>  	led_trigger_unregister_simple(host->led);
> diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
> index 705a589..eea9cde 100644
> --- a/drivers/mmc/host/mmci.c
> +++ b/drivers/mmc/host/mmci.c
> @@ -455,15 +455,15 @@ static void mmci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
>  
>  	switch (ios->power_mode) {
>  	case MMC_POWER_OFF:
> -		if(host->vcc &&
> -		   regulator_is_enabled(host->vcc))
> -			regulator_disable(host->vcc);
> +		if(mmc->vcc && mmc->vcc_enabled) {
> +			regulator_disable(mmc->vcc);
> +			mmc->vcc_enabled = 0;
> +		}
>  		break;
>  	case MMC_POWER_UP:
>  #ifdef CONFIG_REGULATOR
> -		if (host->vcc)
> -			/* This implicitly enables the regulator */
> -			mmc_regulator_set_ocr(host->vcc, ios->vdd);
> +		/* This implicitly enables the regulator */
> +		mmc_regulator_set_ocr(mmc, ios->vdd);
>  #endif
>  		/*
>  		 * The translate_vdd function is not used if you have
> @@ -473,7 +473,7 @@ static void mmci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
>  		 * a regulator, we might have some other platform specific
>  		 * power control behind this translate function.
>  		 */
> -		if (!host->vcc && host->plat->translate_vdd)
> +		if (!mmc->vcc && host->plat->translate_vdd)
>  			pwr |= host->plat->translate_vdd(mmc_dev(mmc), ios->vdd);
>  		/* The ST version does not have this, fall through to POWER_ON */
>  		if (host->hw_designer != AMBA_VENDOR_ST) {
> @@ -621,11 +621,11 @@ static int __devinit mmci_probe(struct amba_device *dev, struct amba_id *id)
>  	mmc->f_max = min(host->mclk, fmax);
>  #ifdef CONFIG_REGULATOR
>  	/* If we're using the regulator framework, try to fetch a regulator */
> -	host->vcc = regulator_get(&dev->dev, "vmmc");
> -	if (IS_ERR(host->vcc))
> -		host->vcc = NULL;
> +	mmc->vcc = regulator_get(&dev->dev, "vmmc");
> +	if (IS_ERR(mmc->vcc))
> +		mmc->vcc = NULL;
>  	else {
> -		int mask = mmc_regulator_get_ocrmask(host->vcc);
> +		int mask = mmc_regulator_get_ocrmask(mmc);
>  
>  		if (mask < 0)
>  			dev_err(&dev->dev, "error getting OCR mask (%d)\n",
> @@ -640,7 +640,7 @@ static int __devinit mmci_probe(struct amba_device *dev, struct amba_id *id)
>  	}
>  #endif
>  	/* Fall back to platform data if no regulator is found */
> -	if (host->vcc == NULL)
> +	if (mmc->vcc == NULL)
>  		mmc->ocr_avail = plat->ocr_mask;
>  	mmc->caps = plat->capabilities;
>  
> @@ -777,10 +777,6 @@ static int __devexit mmci_remove(struct amba_device *dev)
>  		clk_disable(host->clk);
>  		clk_put(host->clk);
>  
> -		if (regulator_is_enabled(host->vcc))
> -			regulator_disable(host->vcc);
> -		regulator_put(host->vcc);
> -
>  		mmc_free_host(mmc);
>  
>  		amba_release_regions(dev);
> diff --git a/drivers/mmc/host/mmci.h b/drivers/mmc/host/mmci.h
> index 1ceb9a9..a7f9a51 100644
> --- a/drivers/mmc/host/mmci.h
> +++ b/drivers/mmc/host/mmci.h
> @@ -175,7 +175,6 @@ struct mmci_host {
>  	struct scatterlist	*sg_ptr;
>  	unsigned int		sg_off;
>  	unsigned int		size;
> -	struct regulator	*vcc;
>  };
>  
>  static inline void mmci_init_sg(struct mmci_host *host, struct mmc_data *data)
> diff --git a/drivers/mmc/host/pxamci.c b/drivers/mmc/host/pxamci.c
> index fb0978c..25d2367 100644
> --- a/drivers/mmc/host/pxamci.c
> +++ b/drivers/mmc/host/pxamci.c
> @@ -69,25 +69,23 @@ struct pxamci_host {
>  	unsigned int		dma_dir;
>  	unsigned int		dma_drcmrrx;
>  	unsigned int		dma_drcmrtx;
> -
> -	struct regulator	*vcc;
>  };
>  
>  static inline void pxamci_init_ocr(struct pxamci_host *host)
>  {
>  #ifdef CONFIG_REGULATOR
> -	host->vcc = regulator_get(mmc_dev(host->mmc), "vmmc");
> +	host->mmc->vcc = regulator_get(mmc_dev(host->mmc), "vmmc");
>  
> -	if (IS_ERR(host->vcc))
> -		host->vcc = NULL;
> +	if (IS_ERR(host->mmc->vcc))
> +		host->mmc->vcc = NULL;
>  	else {
> -		host->mmc->ocr_avail = mmc_regulator_get_ocrmask(host->vcc);
> +		host->mmc->ocr_avail = mmc_regulator_get_ocrmask(host->mmc);
>  		if (host->pdata && host->pdata->ocr_mask)
>  			dev_warn(mmc_dev(host->mmc),
>  				"given ocr_mask will not be used\n");
>  	}
>  #endif
> -	if (host->vcc == NULL) {
> +	if (host->mmc->vcc == NULL) {
>  		/* fall-back to platform data */
>  		host->mmc->ocr_avail = host->pdata ?
>  			host->pdata->ocr_mask :
> @@ -100,10 +98,10 @@ static inline void pxamci_set_power(struct pxamci_host *host, unsigned int vdd)
>  	int on;
>  
>  #ifdef CONFIG_REGULATOR
> -	if (host->vcc)
> -		mmc_regulator_set_ocr(host->vcc, vdd);
> +	if (host->mmc->vcc)
> +		mmc_regulator_set_ocr(host->mmc, vdd);
>  #endif
> -	if (!host->vcc && host->pdata &&
> +	if (!host->mmc->vcc && host->pdata &&
>  	    gpio_is_valid(host->pdata->gpio_power)) {
>  		on = ((1 << vdd) & host->pdata->ocr_mask);
>  		gpio_set_value(host->pdata->gpio_power,
> @@ -775,8 +773,6 @@ static int pxamci_remove(struct platform_device *pdev)
>  			gpio_free(gpio_ro);
>  		if (gpio_is_valid(gpio_power))
>  			gpio_free(gpio_power);
> -		if (host->vcc)
> -			regulator_put(host->vcc);
>  
>  		if (host->pdata && host->pdata->exit)
>  			host->pdata->exit(&pdev->dev, mmc);
> diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
> index eaf3636..2c1b079 100644
> --- a/include/linux/mmc/host.h
> +++ b/include/linux/mmc/host.h
> @@ -111,6 +111,7 @@ struct mmc_host_ops {
>  
>  struct mmc_card;
>  struct device;
> +struct regulator;
>  
>  struct mmc_host {
>  	struct device		*parent;
> @@ -203,6 +204,9 @@ struct mmc_host {
>  
>  	struct dentry		*debugfs_root;
>  
> +	struct regulator	*vcc;
> +	unsigned int		 vcc_enabled:1;
> +
>  	unsigned long		private[0] ____cacheline_aligned;
>  };
>  
> @@ -237,10 +241,8 @@ static inline void mmc_signal_sdio_irq(struct mmc_host *host)
>  	wake_up_process(host->sdio_irq_thread);
>  }
>  
> -struct regulator;
> -
> -int mmc_regulator_get_ocrmask(struct regulator *supply);
> -int mmc_regulator_set_ocr(struct regulator *supply, unsigned short vdd_bit);
> +int mmc_regulator_get_ocrmask(struct mmc_host *host);
> +int mmc_regulator_set_ocr(struct mmc_host *host, unsigned short vdd_bit);
>  
>  int mmc_card_awake(struct mmc_host *host);
>  int mmc_card_sleep(struct mmc_host *host);

