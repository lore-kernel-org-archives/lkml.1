Return-Path: <linux-kernel-owner+w=401wt.eu-S1752063AbZJWOLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063AbZJWOLQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 10:11:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752019AbZJWOLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 10:11:15 -0400
Received: from mga07.intel.com ([143.182.124.22]:43308 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751999AbZJWOLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 10:11:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,612,1249282800"; 
   d="scan'208";a="202659868"
Date: Fri, 23 Oct 2009 16:13:11 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Ilkka Koskinen <ilkka.koskinen@nokia.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH v2] twl4030: Enable low-power mode to 32kHz oscillator
Message-ID: <20091023141310.GB3718@sortiz.org>
References: <1256210049-4567-1-git-send-email-ilkka.koskinen@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256210049-4567-1-git-send-email-ilkka.koskinen@nokia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ilkka,

On Thu, Oct 22, 2009 at 02:14:09PM +0300, Ilkka Koskinen wrote:
> Allows TWL's 32kHz oscillator to go in low-power mode when
> main battery voltage is running low.
Patch applied, thanks a lot.

Cheers,
Samuel.


> Signed-off-by: Ilkka Koskinen <ilkka.koskinen@nokia.com>
> ---
>  drivers/mfd/twl4030-core.c  |    9 +++++++--
>  include/linux/i2c/twl4030.h |    5 +++++
>  2 files changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mfd/twl4030-core.c b/drivers/mfd/twl4030-core.c
> index eee5af8..004a8be 100644
> --- a/drivers/mfd/twl4030-core.c
> +++ b/drivers/mfd/twl4030-core.c
> @@ -177,6 +177,7 @@
>  #define HFCLK_FREQ_26_MHZ		(2 << 0)
>  #define HFCLK_FREQ_38p4_MHZ		(3 << 0)
>  #define HIGH_PERF_SQ			(1 << 3)
> +#define CK32K_LOWPWR_EN			(1 << 7)
>  
>  
>  /* chip-specific feature flags, for i2c_device_id.driver_data */
> @@ -681,7 +682,8 @@ static inline int __init unprotect_pm_master(void)
>  	return e;
>  }
>  
> -static void clocks_init(struct device *dev)
> +static void clocks_init(struct device *dev,
> +			struct twl4030_clock_init_data *clock)
>  {
>  	int e = 0;
>  	struct clk *osc;
> @@ -728,6 +730,9 @@ static void clocks_init(struct device *dev)
>  	}
>  
>  	ctrl |= HIGH_PERF_SQ;
> +	if (clock && clock->ck32k_lowpwr_enable)
> +		ctrl |= CK32K_LOWPWR_EN;
> +
>  	e |= unprotect_pm_master();
>  	/* effect->MADC+USB ck en */
>  	e |= twl4030_i2c_write_u8(TWL4030_MODULE_PM_MASTER, ctrl, R_CFG_BOOT);
> @@ -806,7 +811,7 @@ twl4030_probe(struct i2c_client *client, const struct i2c_device_id *id)
>  	inuse = true;
>  
>  	/* setup clock framework */
> -	clocks_init(&client->dev);
> +	clocks_init(&client->dev, pdata->clock);
>  
>  	/* load power event scripts */
>  	if (twl_has_power() && pdata->power)
> diff --git a/include/linux/i2c/twl4030.h b/include/linux/i2c/twl4030.h
> index 4a2fb27..10e68cb 100644
> --- a/include/linux/i2c/twl4030.h
> +++ b/include/linux/i2c/twl4030.h
> @@ -313,6 +313,10 @@ int twl4030_i2c_read(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes);
>  
>  /*----------------------------------------------------------------------*/
>  
> +struct twl4030_clock_init_data {
> +	bool ck32k_lowpwr_enable;
> +};
> +
>  struct twl4030_bci_platform_data {
>  	int *battery_tmp_tbl;
>  	unsigned int tblsize;
> @@ -407,6 +411,7 @@ extern void twl4030_power_init(struct twl4030_power_data *triton2_scripts);
>  
>  struct twl4030_platform_data {
>  	unsigned				irq_base, irq_end;
> +	struct twl4030_clock_init_data		*clock;
>  	struct twl4030_bci_platform_data	*bci;
>  	struct twl4030_gpio_platform_data	*gpio;
>  	struct twl4030_madc_platform_data	*madc;
> -- 
> 1.6.0.4
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
