Return-Path: <linux-kernel-owner+w=401wt.eu-S1754572Ab0ALXhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572Ab0ALXhl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 18:37:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750929Ab0ALXhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 18:37:39 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35857 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751444Ab0ALXhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 18:37:38 -0500
Date: Tue, 12 Jan 2010 15:37:33 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Chaithrika U S <chaithrika@ti.com>
Cc: linux-kernel@vger.kernel.org,
       davinci-linux-open-source@linux.davincidsp.com,
       khilman@deeprootsystems.com
Subject: Re: [PATCH  v3 2/2] davinci: MMC: updates to suspend/resume
 implementation
Message-Id: <20100112153733.fd182ed1.akpm@linux-foundation.org>
In-Reply-To: <1262950740-12625-1-git-send-email-chaithrika@ti.com>
References: <1262950740-12625-1-git-send-email-chaithrika@ti.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  8 Jan 2010 17:09:00 +0530
Chaithrika U S <chaithrika@ti.com> wrote:

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

Was it proper to ignore the mmc_host_enable() return values?
