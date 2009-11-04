Return-Path: <linux-kernel-owner+w=401wt.eu-S1754653AbZKDEYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbZKDEYg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 23:24:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754530AbZKDEYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 23:24:35 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:57541 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754347AbZKDEYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 23:24:34 -0500
From: "Chaithrika U S" <chaithrika@ti.com>
To: "'Chaithrika U S'" <chaithrika@ti.com>, <linux-kernel@vger.kernel.org>
Cc: <akpm@linux-foundation.org>,
       <davinci-linux-open-source@linux.davincidsp.com>,
       <vipin.bhandari@ti.com>, <khilman@deeprootsystems.com>
References: <1256040610-30684-1-git-send-email-chaithrika@ti.com>
In-Reply-To: <1256040610-30684-1-git-send-email-chaithrika@ti.com>
Subject: RE: [PATCH] davinci: MMC: add cpufreq support
Date: Wed, 4 Nov 2009 09:52:16 +0530
Message-ID: <008101ca5d06$644e23f0$2cea6bd0$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcpRfhVihMeH54IfT9uXpJ8NW37e8wLhz/Xw
Content-Language: en-us
x-cr-hashedpuzzle: B6Ja IJ3Y Jdr1 LISW LLjX N+ND SEoW UPVn VuQU dPf6 eN+z llUt mPaI vl4A 0C1Q 9ftZ;6;YQBrAHAAbQBAAGwAaQBuAHUAeAAtAGYAbwB1AG4AZABhAHQAaQBvAG4ALgBvAHIAZwA7AGMAaABhAGkAdABoAHIAaQBrAGEAQAB0AGkALgBjAG8AbQA7AGQAYQB2AGkAbgBjAGkALQBsAGkAbgB1AHgALQBvAHAAZQBuAC0AcwBvAHUAcgBjAGUAQABsAGkAbgB1AHgALgBkAGEAdgBpAG4AYwBpAGQAcwBwAC4AYwBvAG0AOwBrAGgAaQBsAG0AYQBuAEAAZABlAGUAcAByAG8AbwB0AHMAeQBzAHQAZQBtAHMALgBjAG8AbQA7AGwAaQBuAHUAeAAtAGsAZQByAG4AZQBsAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwB2AGkAcABpAG4ALgBiAGgAYQBuAGQAYQByAGkAQAB0AGkALgBjAG8AbQA=;Sosha1_v1;7;{320FC7EE-D904-46AA-B67F-6405BD5C35F8};YwBoAGEAaQB0AGgAcgBpAGsAYQBAAHQAaQAuAGMAbwBtAA==;Wed, 04 Nov 2009 04:22:00 GMT;UgBFADoAIABbAFAAQQBUAEMASABdACAAZABhAHYAaQBuAGMAaQA6ACAATQBNAEMAOgAgAGEAZABkACAAYwBwAHUAZgByAGUAcQAgAHMAdQBwAHAAbwByAHQA
x-cr-puzzleid: {320FC7EE-D904-46AA-B67F-6405BD5C35F8}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do you have any review comments or suggestions for this patch?

Regards, 
Chaithrika

On Tue, Oct 20, 2009 at 17:40:10, Chaithrika U S wrote:
> Add cpufreq support to MMC driver. The clock divider value has to be
> modified according to the controller input frequency.
> 
> Signed-off-by: Chaithrika U S <chaithrika@ti.com>
> ---
> This patch applies on top of the following two patches submitted to LKML
> http://patchwork.kernel.org/patch/54013/
> http://patchwork.kernel.org/patch/50914/
> 
>  drivers/mmc/host/davinci_mmc.c |  100 +++++++++++++++++++++++++++++++++------
>  1 files changed, 84 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/mmc/host/davinci_mmc.c b/drivers/mmc/host/davinci_mmc.c
> index fe8f613..b54c779 100644
> --- a/drivers/mmc/host/davinci_mmc.c
> +++ b/drivers/mmc/host/davinci_mmc.c
> @@ -25,6 +25,7 @@
>  #include <linux/platform_device.h>
>  #include <linux/clk.h>
>  #include <linux/err.h>
> +#include <linux/cpufreq.h>
>  #include <linux/mmc/host.h>
>  #include <linux/io.h>
>  #include <linux/irq.h>
> @@ -200,6 +201,9 @@ struct mmc_davinci_host {
>  	u8 version;
>  	/* for ns in one cycle calculation */
>  	unsigned ns_in_one_cycle;
> +#ifdef CONFIG_CPU_FREQ
> +	struct notifier_block	freq_transition;
> +#endif
>  };
>  
>  
> @@ -739,27 +743,12 @@ static unsigned int calculate_freq_for_card(struct mmc_davinci_host *host,
>  	return mmc_push_pull_divisor;
>  }
>  
> -static void mmc_davinci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
> +static void calculate_clk_divider(struct mmc_host *mmc, struct mmc_ios *ios)
>  {
>  	unsigned int open_drain_freq = 0, mmc_pclk = 0;
>  	unsigned int mmc_push_pull_freq = 0;
>  	struct mmc_davinci_host *host = mmc_priv(mmc);
>  
> -	mmc_pclk = host->mmc_input_clk;
> -	dev_dbg(mmc_dev(host->mmc),
> -		"clock %dHz busmode %d powermode %d Vdd %04x\n",
> -		ios->clock, ios->bus_mode, ios->power_mode,
> -		ios->vdd);
> -	if (ios->bus_width == MMC_BUS_WIDTH_4) {
> -		dev_dbg(mmc_dev(host->mmc), "Enabling 4 bit mode\n");
> -		writel(readl(host->base + DAVINCI_MMCCTL) | MMCCTL_WIDTH_4_BIT,
> -			host->base + DAVINCI_MMCCTL);
> -	} else {
> -		dev_dbg(mmc_dev(host->mmc), "Disabling 4 bit mode\n");
> -		writel(readl(host->base + DAVINCI_MMCCTL) & ~MMCCTL_WIDTH_4_BIT,
> -			host->base + DAVINCI_MMCCTL);
> -	}
> -
>  	if (ios->bus_mode == MMC_BUSMODE_OPENDRAIN) {
>  		u32 temp;
>  
> @@ -798,6 +787,29 @@ static void mmc_davinci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
>  
>  		udelay(10);
>  	}
> +}
> +
> +static void mmc_davinci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
> +{
> +	unsigned int mmc_pclk = 0;
> +	struct mmc_davinci_host *host = mmc_priv(mmc);
> +
> +	mmc_pclk = host->mmc_input_clk;
> +	dev_dbg(mmc_dev(host->mmc),
> +		"clock %dHz busmode %d powermode %d Vdd %04x\n",
> +		ios->clock, ios->bus_mode, ios->power_mode,
> +		ios->vdd);
> +	if (ios->bus_width == MMC_BUS_WIDTH_4) {
> +		dev_dbg(mmc_dev(host->mmc), "Enabling 4 bit mode\n");
> +		writel(readl(host->base + DAVINCI_MMCCTL) | MMCCTL_WIDTH_4_BIT,
> +			host->base + DAVINCI_MMCCTL);
> +	} else {
> +		dev_dbg(mmc_dev(host->mmc), "Disabling 4 bit mode\n");
> +		writel(readl(host->base + DAVINCI_MMCCTL) & ~MMCCTL_WIDTH_4_BIT,
> +			host->base + DAVINCI_MMCCTL);
> +	}
> +
> +	calculate_clk_divider(mmc, ios);
>  
>  	host->bus_mode = ios->bus_mode;
>  	if (ios->power_mode == MMC_POWER_UP) {
> @@ -1040,6 +1052,52 @@ static struct mmc_host_ops mmc_davinci_ops = {
>  
>  /*----------------------------------------------------------------------*/
>  
> +#ifdef CONFIG_CPU_FREQ
> +static int mmc_davinci_cpufreq_transition(struct notifier_block *nb,
> +				     unsigned long val, void *data)
> +{
> +	struct mmc_davinci_host *host;
> +	unsigned int mmc_pclk;
> +	struct mmc_host *mmc;
> +	unsigned long flags;
> +
> +	host = container_of(nb, struct mmc_davinci_host, freq_transition);
> +	mmc = host->mmc;
> +	mmc_pclk = clk_get_rate(host->clk);
> +
> +	if (val == CPUFREQ_POSTCHANGE) {
> +		spin_lock_irqsave(&mmc->lock, flags);
> +		host->mmc_input_clk = mmc_pclk;
> +		calculate_clk_divider(mmc, &mmc->ios);
> +		spin_unlock_irqrestore(&mmc->lock, flags);
> +	}
> +
> +	return 0;
> +}
> +
> +static inline int mmc_davinci_cpufreq_register(struct mmc_davinci_host *host)
> +{
> +	host->freq_transition.notifier_call = mmc_davinci_cpufreq_transition;
> +
> +	return cpufreq_register_notifier(&host->freq_transition,
> +					 CPUFREQ_TRANSITION_NOTIFIER);
> +}
> +
> +static inline void mmc_davinci_cpufreq_deregister(struct mmc_davinci_host *host)
> +{
> +	cpufreq_unregister_notifier(&host->freq_transition,
> +				    CPUFREQ_TRANSITION_NOTIFIER);
> +}
> +#else
> +static inline int mmc_davinci_cpufreq_register(struct mmc_davinci_host *host)
> +{
> +	return 0;
> +}
> +
> +static inline void mmc_davinci_cpufreq_deregister(struct mmc_davinci_host *host)
> +{
> +}
> +#endif
>  static void __init init_mmcsd_host(struct mmc_davinci_host *host)
>  {
>  	/* DAT line portion is diabled and in reset state */
> @@ -1169,6 +1227,12 @@ static int __init davinci_mmcsd_probe(struct platform_device *pdev)
>  
>  	platform_set_drvdata(pdev, host);
>  
> +	ret = mmc_davinci_cpufreq_register(host);
> +	if (ret) {
> +		dev_err(&pdev->dev, "failed to register cpufreq\n");
> +		goto cpu_freq_fail;
> +	}
> +
>  	ret = mmc_add_host(mmc);
>  	if (ret < 0)
>  		goto out;
> @@ -1186,6 +1250,8 @@ static int __init davinci_mmcsd_probe(struct platform_device *pdev)
>  	return 0;
>  
>  out:
> +	mmc_davinci_cpufreq_deregister(host);
> +cpu_freq_fail:
>  	if (host) {
>  		davinci_release_dma_channels(host);
>  
> @@ -1215,6 +1281,8 @@ static int __exit davinci_mmcsd_remove(struct platform_device *pdev)
>  
>  	platform_set_drvdata(pdev, NULL);
>  	if (host) {
> +		mmc_davinci_cpufreq_deregister(host);
> +
>  		mmc_remove_host(host->mmc);
>  		free_irq(host->irq, host);
>  
> -- 
> 1.5.6
> 


