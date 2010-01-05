Return-Path: <linux-kernel-owner+w=401wt.eu-S1755118Ab0AEXz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118Ab0AEXz2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 18:55:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754666Ab0AEXz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 18:55:27 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:63307 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224Ab0AEXz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 18:55:26 -0500
To: Chaithrika U S <chaithrika@ti.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       davinci-linux-open-source@linux.davincidsp.com
Subject: Re: [PATCH 1/2] davinci: MMC: Add a function to control reset state of the controller
References: <1261052091-14379-1-git-send-email-chaithrika@ti.com>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Tue, 05 Jan 2010 15:55:23 -0800
In-Reply-To: <1261052091-14379-1-git-send-email-chaithrika@ti.com> (Chaithrika U. S.'s message of "Thu\, 17 Dec 2009 17\:44\:51 +0530")
Message-ID: <87tyv0p0no.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chaithrika U S <chaithrika@ti.com> writes:

> Add a helper function which will aid in changing the reset
> status of the controller.
>
> Signed-off-by: Chaithrika U S <chaithrika@ti.com>

Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>


> ---
> Applies to Linus' kernel tree.
>
>  drivers/mmc/host/davinci_mmc.c |   37 ++++++++++++++++---------------------
>  1 files changed, 16 insertions(+), 21 deletions(-)
>
> diff --git a/drivers/mmc/host/davinci_mmc.c b/drivers/mmc/host/davinci_mmc.c
> index dd45e7c..25645bf 100644
> --- a/drivers/mmc/host/davinci_mmc.c
> +++ b/drivers/mmc/host/davinci_mmc.c
> @@ -884,19 +884,26 @@ static void mmc_davinci_cmd_done(struct mmc_davinci_host *host,
>  	}
>  }
>  
> -static void
> -davinci_abort_data(struct mmc_davinci_host *host, struct mmc_data *data)
> +static inline void mmc_davinci_reset_ctrl(struct mmc_davinci_host *host,
> +								int val)
>  {
>  	u32 temp;
>  
> -	/* reset command and data state machines */
>  	temp = readl(host->base + DAVINCI_MMCCTL);
> -	writel(temp | MMCCTL_CMDRST | MMCCTL_DATRST,
> -		host->base + DAVINCI_MMCCTL);
> +	if (val)	/* reset */
> +		temp |= MMCCTL_CMDRST | MMCCTL_DATRST;
> +	else		/* enable */
> +		temp &= ~(MMCCTL_CMDRST | MMCCTL_DATRST);
>  
> -	temp &= ~(MMCCTL_CMDRST | MMCCTL_DATRST);
> -	udelay(10);
>  	writel(temp, host->base + DAVINCI_MMCCTL);
> +	udelay(10);
> +}
> +
> +static void
> +davinci_abort_data(struct mmc_davinci_host *host, struct mmc_data *data)
> +{
> +	mmc_davinci_reset_ctrl(host, 1);
> +	mmc_davinci_reset_ctrl(host, 0);
>  }
>  
>  static irqreturn_t mmc_davinci_irq(int irq, void *dev_id)
> @@ -1100,15 +1107,8 @@ static inline void mmc_davinci_cpufreq_deregister(struct mmc_davinci_host *host)
>  #endif
>  static void __init init_mmcsd_host(struct mmc_davinci_host *host)
>  {
> -	/* DAT line portion is diabled and in reset state */
> -	writel(readl(host->base + DAVINCI_MMCCTL) | MMCCTL_DATRST,
> -		host->base + DAVINCI_MMCCTL);
> -
> -	/* CMD line portion is diabled and in reset state */
> -	writel(readl(host->base + DAVINCI_MMCCTL) | MMCCTL_CMDRST,
> -		host->base + DAVINCI_MMCCTL);
>  
> -	udelay(10);
> +	mmc_davinci_reset_ctrl(host, 1);
>  
>  	writel(0, host->base + DAVINCI_MMCCLK);
>  	writel(MMCCLK_CLKEN, host->base + DAVINCI_MMCCLK);
> @@ -1116,12 +1116,7 @@ static void __init init_mmcsd_host(struct mmc_davinci_host *host)
>  	writel(0x1FFF, host->base + DAVINCI_MMCTOR);
>  	writel(0xFFFF, host->base + DAVINCI_MMCTOD);
>  
> -	writel(readl(host->base + DAVINCI_MMCCTL) & ~MMCCTL_DATRST,
> -		host->base + DAVINCI_MMCCTL);
> -	writel(readl(host->base + DAVINCI_MMCCTL) & ~MMCCTL_CMDRST,
> -		host->base + DAVINCI_MMCCTL);
> -
> -	udelay(10);
> +	mmc_davinci_reset_ctrl(host, 0);
>  }
>  
>  static int __init davinci_mmcsd_probe(struct platform_device *pdev)
> -- 
> 1.5.6
