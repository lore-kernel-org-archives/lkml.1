Return-Path: <linux-kernel-owner+w=401wt.eu-S1751328AbZLRLDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751328AbZLRLDk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 06:03:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750870AbZLRLDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 06:03:40 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:58987 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbZLRLDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 06:03:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=nqaTlpTkWG+BbG1kI8JqaD2yHQhfWTiciHKFJbwLKpWRNuregd+9TRs7MztmW7m60g
         TF/9vhEcF4qFauwjmk/9wk6MpfvQ0XgLOG6psXXJn2/b9xs11MXhVEYiB0XF3QOXYAzK
         7QyLUB77nevAjMUXmmlAQ7IreJnzXlWpbfqZw=
MIME-Version: 1.0
In-Reply-To: <1261052101-14409-1-git-send-email-chaithrika@ti.com>
References: <1261052101-14409-1-git-send-email-chaithrika@ti.com>
Date: Fri, 18 Dec 2009 16:33:35 +0530
Message-ID: <4fb5db50912180303w2052bce8q76c04782d9cd355e@mail.gmail.com>
Subject: Re: [PATCH 2/2] davinci: MMC: updates to suspend/resume 
	implementation
From: Janakiram Sistla <janakiram.sistla@gmail.com>
To: Chaithrika U S <chaithrika@ti.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       davinci-linux-open-source@linux.davincidsp.com,
       khilman@deeprootsystems.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/09, Chaithrika U S <chaithrika@ti.com> wrote:
> Improve the suspend and resume callbacks in DaVinci MMC
> host controller driver.
[Ram] I came cross in the mailing some days back that "direct"
.suspend and .resume calls will stop being supported.Is This
true??This patch does require a migration then again.

> Tested on DA850/OMAP-L138 EVM. This testing requires patches
> which add suspend-to-RAM support to DA850/OMAP-L138 SoC[1].
>
> [1]http://linux.davincidsp.com/pipermail/davinci-linux-open-source/
> 2009-September/016118.html
>
> Signed-off-by: Chaithrika U S <chaithrika@ti.com>
> ---
> Applies to Linus' kernel tree.
>
>  drivers/mmc/host/davinci_mmc.c |   31 +++++++++++++++++++++++++++++--
>  1 files changed, 29 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/mmc/host/davinci_mmc.c b/drivers/mmc/host/davinci_mmc.c
> index 25645bf..7d05cc1 100644
> --- a/drivers/mmc/host/davinci_mmc.c
> +++ b/drivers/mmc/host/davinci_mmc.c
> @@ -170,6 +170,7 @@ struct mmc_davinci_host {
>  #define DAVINCI_MMC_DATADIR_READ       1
>  #define DAVINCI_MMC_DATADIR_WRITE      2
>        unsigned char data_dir;
> +       unsigned char suspended;
>
>        /* buffer is used during PIO of one scatterlist segment, and
>         * is updated along with buffer_bytes_left.  bytes_left applies
> @@ -1300,15 +1301,41 @@ static int __exit davinci_mmcsd_remove(struct platform_device *pdev)
>  static int davinci_mmcsd_suspend(struct platform_device *pdev, pm_message_t msg)
>  {
>        struct mmc_davinci_host *host = platform_get_drvdata(pdev);
> +       int ret;
>
> -       return mmc_suspend_host(host->mmc, msg);
> +       mmc_host_enable(host->mmc);
> +       ret = mmc_suspend_host(host->mmc, msg);
> +       if (!ret) {
> +               writel(0, host->base + DAVINCI_MMCIM);
> +               mmc_davinci_reset_ctrl(host, 1);
> +               mmc_host_disable(host->mmc);
> +               clk_disable(host->clk);
> +               host->suspended = 1;
> +       } else {
> +               host->suspended = 0;
> +               mmc_host_disable(host->mmc);
> +       }
> +
> +       return ret;
>  }
>
>  static int davinci_mmcsd_resume(struct platform_device *pdev)
>  {
>        struct mmc_davinci_host *host = platform_get_drvdata(pdev);
> +       int ret;
>
> -       return mmc_resume_host(host->mmc);
> +       if (!host->suspended)
> +               return 0;
> +
> +       clk_enable(host->clk);
> +       mmc_host_enable(host->mmc);
> +
> +       mmc_davinci_reset_ctrl(host, 0);
> +       ret = mmc_resume_host(host->mmc);
> +       if (!ret)
> +               host->suspended = 0;
> +
> +       return ret;
>  }
>  #else
>  #define davinci_mmcsd_suspend  NULL
> --
> 1.5.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
