Return-Path: <linux-kernel-owner+w=401wt.eu-S932248Ab0AFPh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932248Ab0AFPh5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 10:37:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755043Ab0AFPh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 10:37:56 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:47983 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754880Ab0AFPhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 10:37:55 -0500
To: Chaithrika U S <chaithrika@ti.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       davinci-linux-open-source@linux.davincidsp.com
Subject: Re: [PATCH  v2 2/2] davinci: MMC: updates to suspend/resume implementation
References: <1262770489-9486-1-git-send-email-chaithrika@ti.com>
	<1262770489-9486-2-git-send-email-chaithrika@ti.com>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Wed, 06 Jan 2010 07:37:52 -0800
In-Reply-To: <1262770489-9486-2-git-send-email-chaithrika@ti.com> (Chaithrika U. S.'s message of "Wed\,  6 Jan 2010 15\:04\:49 +0530")
Message-ID: <87k4vvmegf.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chaithrika U S <chaithrika@ti.com> writes:

> Improve the suspend and resume callbacks in DaVinci MMC
> host controller driver.

I think this changelog needs a bit more detail on what "improve" means.

Also, you should add a comment about the conversion to dev_pm_ops.

Kevin

> Tested on DA850/OMAP-L138 EVM. This testing requires patches
> which add suspen-to-RAM support to DA850/OMAP-L138 SoC[1].
>
> [1]http://linux.davincidsp.com/pipermail/davinci-linux-open-source/
> 2009-September/016118.html
>
> Signed-off-by: Chaithrika U S <chaithrika@ti.com>
> ---
> Applies to Linus' kernel tree.
>
>  drivers/mmc/host/davinci_mmc.c |   51 +++++++++++++++++++++++++++++++++------
>  1 files changed, 43 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/mmc/host/davinci_mmc.c b/drivers/mmc/host/davinci_mmc.c
> index 25645bf..d60f648 100644
> --- a/drivers/mmc/host/davinci_mmc.c
> +++ b/drivers/mmc/host/davinci_mmc.c
> @@ -170,6 +170,7 @@ struct mmc_davinci_host {
>  #define DAVINCI_MMC_DATADIR_READ	1
>  #define DAVINCI_MMC_DATADIR_WRITE	2
>  	unsigned char data_dir;
> +	unsigned char suspended;
>  
>  	/* buffer is used during PIO of one scatterlist segment, and
>  	 * is updated along with buffer_bytes_left.  bytes_left applies
> @@ -1297,32 +1298,66 @@ static int __exit davinci_mmcsd_remove(struct platform_device *pdev)
>  }
>  
>  #ifdef CONFIG_PM
> -static int davinci_mmcsd_suspend(struct platform_device *pdev, pm_message_t msg)
> +static int davinci_mmcsd_suspend(struct device *dev)
>  {
> +	struct platform_device *pdev = to_platform_device(dev);
>  	struct mmc_davinci_host *host = platform_get_drvdata(pdev);
> +	struct pm_message msg = { PM_EVENT_SUSPEND };
> +	int ret;
>  
> -	return mmc_suspend_host(host->mmc, msg);
> +	mmc_host_enable(host->mmc);
> +	ret = mmc_suspend_host(host->mmc, msg);
> +	if (!ret) {
> +		writel(0, host->base + DAVINCI_MMCIM);
> +		mmc_davinci_reset_ctrl(host, 1);
> +		mmc_host_disable(host->mmc);
> +		clk_disable(host->clk);
> +		host->suspended = 1;
> +	} else {
> +		host->suspended = 0;
> +		mmc_host_disable(host->mmc);
> +	}
> +
> +	return ret;
>  }
>  
> -static int davinci_mmcsd_resume(struct platform_device *pdev)
> +static int davinci_mmcsd_resume(struct device *dev)
>  {
> +	struct platform_device *pdev = to_platform_device(dev);
>  	struct mmc_davinci_host *host = platform_get_drvdata(pdev);
> +	int ret;
>  
> -	return mmc_resume_host(host->mmc);
> +	if (!host->suspended)
> +		return 0;
> +
> +	clk_enable(host->clk);
> +	mmc_host_enable(host->mmc);
> +
> +	mmc_davinci_reset_ctrl(host, 0);
> +	ret = mmc_resume_host(host->mmc);
> +	if (!ret)
> +		host->suspended = 0;
> +
> +	return ret;
>  }
> +
> +static struct dev_pm_ops davinci_mmcsd_pm = {
> +	.suspend        = davinci_mmcsd_suspend,
> +	.resume         = davinci_mmcsd_resume,
> +};
> +
> +#define davinci_mmcsd_pm_ops (&davinci_mmcsd_pm)
>  #else
> -#define davinci_mmcsd_suspend	NULL
> -#define davinci_mmcsd_resume	NULL
> +#define davinci_mmcsd_pm_ops NULL
>  #endif
>  
>  static struct platform_driver davinci_mmcsd_driver = {
>  	.driver		= {
>  		.name	= "davinci_mmc",
>  		.owner	= THIS_MODULE,
> +		.pm	= davinci_mmcsd_pm_ops,
>  	},
>  	.remove		= __exit_p(davinci_mmcsd_remove),
> -	.suspend	= davinci_mmcsd_suspend,
> -	.resume		= davinci_mmcsd_resume,
>  };
>  
>  static int __init davinci_mmcsd_init(void)
> -- 
> 1.5.6
