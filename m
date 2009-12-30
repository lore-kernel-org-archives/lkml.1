Return-Path: <linux-kernel-owner+w=401wt.eu-S1752687AbZL3LAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687AbZL3LAZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 06:00:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542AbZL3LAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 06:00:24 -0500
Received: from gateway-1237.mvista.com ([206.112.117.35]:8827 "HELO
	imap.sh.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1752519AbZL3LAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 06:00:24 -0500
Message-ID: <4B3B32B1.4010900@ru.mvista.com>
Date: Wed, 30 Dec 2009 14:00:01 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Vipin Bhandari <vipin.bhandari@ti.com>
Cc: linux-kernel@vger.kernel.org,
       davinci-linux-open-source@linux.davincidsp.com,
       akpm@linux-foundation.org, drzeus-mmc@drzeus.cx
Subject: Re: [PATCH] davinci: MMC: Adding support for 8bit MMC cards
References: <1262001865-4373-1-git-send-email-vipin.bhandari@ti.com>
In-Reply-To: <1262001865-4373-1-git-send-email-vipin.bhandari@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Vipin Bhandari wrote:

   [Re-replying to all, as I only replied to Vipin the first time.]

> This patch adds the support for 8bit MMC cards. The controller
> data width is configurable depending on the wires setting in the
> platform data structure.
>
> MMC 8bit is tested on OMAPL137 and MMC 4bit is tested on OMAPL138 EVM.
>
> Signed-off-by: Vipin Bhandari <vipin.bhandari@ti.com>
>   

   This has been done by MV in the internal tree but as you code is 
significantly differenet from that one, I'm not asking you about the 
missing MV signoffs...

> diff --git a/drivers/mmc/host/davinci_mmc.c 
> b/drivers/mmc/host/davinci_mmc.c
> index dd45e7c..3bd0ba2 100644
> --- a/drivers/mmc/host/davinci_mmc.c
> +++ b/drivers/mmc/host/davinci_mmc.c
> @@ -73,6 +73,7 @@
>  /* DAVINCI_MMCCTL definitions */
>  #define MMCCTL_DATRST         (1 << 0)
>  #define MMCCTL_CMDRST         (1 << 1)
> +#define MMCCTL_WIDTH_8_BIT    (1 << 8)
>  #define MMCCTL_WIDTH_4_BIT    (1 << 2)
>  #define MMCCTL_DATEG_DISABLED (0 << 6)
>  #define MMCCTL_DATEG_RISING   (1 << 6)
> @@ -791,22 +792,42 @@ static void calculate_clk_divider(struct 
> mmc_host *mmc, struct mmc_ios *ios)
>  
>  static void mmc_davinci_set_ios(struct mmc_host *mmc, struct mmc_ios 
> *ios)
>  {
> -    unsigned int mmc_pclk = 0;
>      struct mmc_davinci_host *host = mmc_priv(mmc);
>  
> -    mmc_pclk = host->mmc_input_clk;
>      dev_dbg(mmc_dev(host->mmc),
>          "clock %dHz busmode %d powermode %d Vdd %04x\n",
>          ios->clock, ios->bus_mode, ios->power_mode,
>          ios->vdd);
> -    if (ios->bus_width == MMC_BUS_WIDTH_4) {
> -        dev_dbg(mmc_dev(host->mmc), "Enabling 4 bit mode\n");
> -        writel(readl(host->base + DAVINCI_MMCCTL) | MMCCTL_WIDTH_4_BIT,
> -            host->base + DAVINCI_MMCCTL);
> -    } else {
> -        dev_dbg(mmc_dev(host->mmc), "Disabling 4 bit mode\n");
> -        writel(readl(host->base + DAVINCI_MMCCTL) & ~MMCCTL_WIDTH_4_BIT,
> +
> +    switch (ios->bus_width) {
> +    case MMC_BUS_WIDTH_8:
> +        dev_dbg(mmc_dev(host->mmc), "Enabling 8 bit mode\n");
> +        writel((readl(host->base + DAVINCI_MMCCTL) &
> +            ~MMCCTL_WIDTH_4_BIT) | MMCCTL_WIDTH_8_BIT,
>              host->base + DAVINCI_MMCCTL);
> +        break;
> +    case MMC_BUS_WIDTH_4:
> +        dev_dbg(mmc_dev(host->mmc), "Enabling 4 bit mode\n");
> +        if (host->version == MMC_CTLR_VERSION_2)
> +            writel((readl(host->base + DAVINCI_MMCCTL) &
> +                ~MMCCTL_WIDTH_8_BIT) | MMCCTL_WIDTH_4_BIT,
> +                host->base + DAVINCI_MMCCTL);
> +        else
> +            writel(readl(host->base + DAVINCI_MMCCTL) |
> +                MMCCTL_WIDTH_4_BIT,
> +                host->base + DAVINCI_MMCCTL);
>   

   I don't think it makes sense to check for host->version just to not 
clear the bit which is reserved for original DaVinci. There's nothing 
criminal in clearing a reserved bit, so I'm suggesting that you remove 
the check.

> +        break;
> +    case MMC_BUS_WIDTH_1:
> +        dev_dbg(mmc_dev(host->mmc), "Enabling 1 bit mode\n");
> +        if (host->version == MMC_CTLR_VERSION_2)
> +            writel(readl(host->base + DAVINCI_MMCCTL) &
> +                ~(MMCCTL_WIDTH_8_BIT | MMCCTL_WIDTH_4_BIT),
> +                host->base + DAVINCI_MMCCTL);
> +        else
> +            writel(readl(host->base + DAVINCI_MMCCTL) &
> +                ~MMCCTL_WIDTH_4_BIT,
> +                host->base + DAVINCI_MMCCTL);
>   

   Same comment here...

> +        break;
>   

   It'll result less code if you read/write the register only once -- 
before/after the *switch* statement respectively.

>      }
>  
>      calculate_clk_divider(mmc, ios);
> @@ -1189,10 +1210,14 @@ static int __init davinci_mmcsd_probe(struct 
> platform_device *pdev)
>  
>      /* REVISIT:  someday, support IRQ-driven card detection.  */
>      mmc->caps |= MMC_CAP_NEEDS_POLL;
> +    mmc->caps |= MMC_CAP_WAIT_WHILE_BUSY;
>   

    Does this flag have to do with the bus width at all? :-/

WBR, Sergei


