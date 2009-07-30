Return-Path: <linux-kernel-owner+w=401wt.eu-S1751620AbZG3CBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751620AbZG3CBM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 22:01:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751515AbZG3CBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 22:01:11 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:36591 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505AbZG3CBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 22:01:09 -0400
From: "Madhusudhan" <madhu.cr@ti.com>
To: "'Adrian Hunter'" <adrian.hunter@nokia.com>,
       "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'Jarkko Lavinen'" <jarkko.lavinen@nokia.com>,
       "'linux-omap Mailing List'" <linux-omap@vger.kernel.org>,
       "'Pierre Ossman'" <pierre@ossman.eu>,
       "'Denis Karpov'" <ext-denis.2.karpov@nokia.com>,
       "'Matt Fleming'" <matt@console-pimps.org>,
       "'lkml'" <linux-kernel@vger.kernel.org>
References: <20090728103834.2371.65809.sendpatchset@ahunter-laptop> <20090728104011.2371.89249.sendpatchset@ahunter-laptop>
Subject: RE: [PATCH V2 13/32] omap_hsmmc: context save/restore support
Date: Wed, 29 Jul 2009 21:00:27 -0500
Message-ID: <00ad01ca10b9$82a5d260$544ff780@am.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
In-Reply-To: <20090728104011.2371.89249.sendpatchset@ahunter-laptop>
Thread-Index: AcoPcDj3RCo9eUxmRySk8caaIzGfHABR5d3w
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: linux-omap-owner@vger.kernel.org [mailto:linux-omap-
> owner@vger.kernel.org] On Behalf Of Adrian Hunter
> Sent: Tuesday, July 28, 2009 5:40 AM
> To: Andrew Morton
> Cc: Jarkko Lavinen; Adrian Hunter; linux-omap Mailing List; Pierre Ossman;
> Denis Karpov; Matt Fleming; lkml
> Subject: [PATCH V2 13/32] omap_hsmmc: context save/restore support
> 
> From 43e9fa346d7e386328876a8535dc8619bd1f47ae Mon Sep 17 00:00:00 2001
> From: Denis Karpov <ext-denis.2.karpov@nokia.com>
> Date: Wed, 22 Apr 2009 16:04:25 +0200
> Subject: [PATCH] omap_hsmmc: context save/restore support
> 
> Keep the context over PM dynamic OFF states.
> 
> Signed-off-by: Denis Karpov <ext-denis.2.karpov@nokia.com>
> Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
> ---
>  drivers/mmc/host/omap_hsmmc.c |  194
> ++++++++++++++++++++++++++++++++++++++--
>  1 files changed, 184 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
> index c28d055..ac1a3bf 100644
> --- a/drivers/mmc/host/omap_hsmmc.c
> +++ b/drivers/mmc/host/omap_hsmmc.c
> @@ -37,6 +37,7 @@
> 
>  /* OMAP HSMMC Host Controller Registers */
>  #define OMAP_HSMMC_SYSCONFIG	0x0010
> +#define OMAP_HSMMC_SYSSTATUS	0x0014
>  #define OMAP_HSMMC_CON		0x002C
>  #define OMAP_HSMMC_BLK		0x0104
>  #define OMAP_HSMMC_ARG		0x0108
> @@ -94,6 +95,8 @@
>  #define DUAL_VOLT_OCR_BIT	7
>  #define SRC			(1 << 25)
>  #define SRD			(1 << 26)
> +#define SOFTRESET		(1 << 1)
> +#define RESETDONE		(1 << 0)
> 
>  /*
>   * FIXME: Most likely all the data using these _DEVID defines should come
> @@ -152,6 +155,8 @@ struct mmc_omap_host {
>  	int			slot_id;
>  	int			dbclk_enabled;
>  	int			response_busy;
> +	int			context_loss;
> +
>  	struct	omap_mmc_platform_data	*pdata;
>  };
> 
> @@ -166,6 +171,166 @@ static void omap_mmc_stop_clock(struct mmc_omap_host
> *host)
>  		dev_dbg(mmc_dev(host->mmc), "MMC Clock is not stoped\n");
>  }
> 
> +#ifdef CONFIG_PM
> +
> +/*
> + * Restore the MMC host context, if it was lost as result of a
> + * power state change.
> + */
> +static int omap_mmc_restore_ctx(struct mmc_omap_host *host)
> +{
> +	struct mmc_ios *ios = &host->mmc->ios;
> +	struct omap_mmc_platform_data *pdata = host->pdata;
> +	int context_loss = 0;
> +	u32 hctl, capa, con;
> +	u16 dsor = 0;
> +	unsigned long timeout;
> +
> +	if (pdata->get_context_loss_count) {
> +		context_loss = pdata->get_context_loss_count(host->dev);
> +		if (context_loss < 0)
> +			return 1;
> +	}
This seems to restore the context always. The context should be restored
only if the card was powered OFF, Right?

The context could also be lost if the CORE transitions to OFF. I assume that
case gets handled here without anything extra required if "power_saving" is
set to true. Am I right?

How about the case of eMMC? Since it is not a removable device the card is
not powered OFF. But the CORE OFF would result in context loss. Do we hit
the restore_ctx path in that case?

> +
> +	dev_dbg(mmc_dev(host->mmc), "context was %slost\n",
> +		context_loss == host->context_loss ? "not " : "");
> +	if (host->context_loss == context_loss)
> +		return 1;
> +
> +	/* Wait for hardware reset */
> +	timeout = jiffies + msecs_to_jiffies(MMC_TIMEOUT_MS);
> +	while ((OMAP_HSMMC_READ(host->base, SYSSTATUS) & RESETDONE) !=
> RESETDONE
> +		&& time_before(jiffies, timeout))
> +		;
> +
> +	/* Do software reset */
> +	OMAP_HSMMC_WRITE(host->base, SYSCONFIG, SOFTRESET);
> +	timeout = jiffies + msecs_to_jiffies(MMC_TIMEOUT_MS);
> +	while ((OMAP_HSMMC_READ(host->base, SYSSTATUS) & RESETDONE) !=
> RESETDONE
> +		&& time_before(jiffies, timeout))
> +		;
> +
> +	OMAP_HSMMC_WRITE(host->base, SYSCONFIG,
> +			OMAP_HSMMC_READ(host->base, SYSCONFIG) | AUTOIDLE);
> +
> +	if (host->id == OMAP_MMC1_DEVID) {
> +		if (host->power_mode != MMC_POWER_OFF &&
> +		    (1 << ios->vdd) <= MMC_VDD_23_24)
> +			hctl = SDVS18;
> +		else
> +			hctl = SDVS30;
> +		capa = VS30 | VS18;
> +	} else {
> +		hctl = SDVS18;
> +		capa = VS18;
> +	}
> +
> +	OMAP_HSMMC_WRITE(host->base, HCTL,
> +			OMAP_HSMMC_READ(host->base, HCTL) | hctl);
> +
> +	OMAP_HSMMC_WRITE(host->base, CAPA,
> +			OMAP_HSMMC_READ(host->base, CAPA) | capa);
> +
> +	OMAP_HSMMC_WRITE(host->base, HCTL,
> +			OMAP_HSMMC_READ(host->base, HCTL) | SDBP);
> +
> +	timeout = jiffies + msecs_to_jiffies(MMC_TIMEOUT_MS);
> +	while ((OMAP_HSMMC_READ(host->base, HCTL) & SDBP) != SDBP
> +		&& time_before(jiffies, timeout))
> +		;
> +
> +	OMAP_HSMMC_WRITE(host->base, STAT, STAT_CLEAR);
> +	OMAP_HSMMC_WRITE(host->base, ISE, INT_EN_MASK);
> +	OMAP_HSMMC_WRITE(host->base, IE, INT_EN_MASK);
> +
> +	/* Do not initialize card-specific things if the power is off */
> +	if (host->power_mode == MMC_POWER_OFF)
> +		goto out;
> +
> +	con = OMAP_HSMMC_READ(host->base, CON);
> +	switch (ios->bus_width) {
> +	case MMC_BUS_WIDTH_8:
> +		OMAP_HSMMC_WRITE(host->base, CON, con | DW8);
> +		break;
> +	case MMC_BUS_WIDTH_4:
> +		OMAP_HSMMC_WRITE(host->base, CON, con & ~DW8);
> +		OMAP_HSMMC_WRITE(host->base, HCTL,
> +			OMAP_HSMMC_READ(host->base, HCTL) | FOUR_BIT);
> +		break;
> +	case MMC_BUS_WIDTH_1:
> +		OMAP_HSMMC_WRITE(host->base, CON, con & ~DW8);
> +		OMAP_HSMMC_WRITE(host->base, HCTL,
> +			OMAP_HSMMC_READ(host->base, HCTL) & ~FOUR_BIT);
> +		break;
> +	}
> +
> +	if (ios->clock) {
> +		dsor = OMAP_MMC_MASTER_CLOCK / ios->clock;
> +		if (dsor < 1)
> +			dsor = 1;
> +
> +		if (OMAP_MMC_MASTER_CLOCK / dsor > ios->clock)
> +			dsor++;
> +
> +		if (dsor > 250)
> +			dsor = 250;
> +	}
> +
> +	OMAP_HSMMC_WRITE(host->base, SYSCTL,
> +		OMAP_HSMMC_READ(host->base, SYSCTL) & ~CEN);
> +	OMAP_HSMMC_WRITE(host->base, SYSCTL, (dsor << 6) | (DTO << 16));
> +	OMAP_HSMMC_WRITE(host->base, SYSCTL,
> +		OMAP_HSMMC_READ(host->base, SYSCTL) | ICE);
> +
> +	timeout = jiffies + msecs_to_jiffies(MMC_TIMEOUT_MS);
> +	while ((OMAP_HSMMC_READ(host->base, SYSCTL) & ICS) != ICS
> +		&& time_before(jiffies, timeout))
> +		;
> +
> +	OMAP_HSMMC_WRITE(host->base, SYSCTL,
> +		OMAP_HSMMC_READ(host->base, SYSCTL) | CEN);
> +
> +	con = OMAP_HSMMC_READ(host->base, CON);
> +	if (ios->bus_mode == MMC_BUSMODE_OPENDRAIN)
> +		OMAP_HSMMC_WRITE(host->base, CON, con | OD);
> +	else
> +		OMAP_HSMMC_WRITE(host->base, CON, con & ~OD);
> +out:
> +	host->context_loss = context_loss;
> +
> +	dev_dbg(mmc_dev(host->mmc), "context is restored\n");
> +	return 0;
> +}
> +
> +/*
> + * Save the MMC host context (store the number of power state changes so
> far).
> + */
> +static void omap_mmc_save_ctx(struct mmc_omap_host *host)
> +{
> +	struct omap_mmc_platform_data *pdata = host->pdata;
> +	int context_loss;
> +
> +	if (pdata->get_context_loss_count) {
> +		context_loss = pdata->get_context_loss_count(host->dev);
> +		if (context_loss < 0)
> +			return;
> +		host->context_loss = context_loss;
> +	}
> +}
> +
> +#else
> +
> +static int omap_mmc_restore_ctx(struct mmc_omap_host *host)
> +{
> +	return 0;
> +}
> +
> +static void omap_mmc_save_ctx(struct mmc_omap_host *host)
> +{
> +}
> +
> +#endif
> +
>  /*
>   * Send init stream sequence to card
>   * before sending IDLE command
> @@ -823,6 +988,7 @@ static int omap_mmc_enable(struct mmc_host *mmc)
>  	if (err)
>  		return err;
>  	dev_dbg(mmc_dev(host->mmc), "mmc_fclk: enabled\n");
> +	omap_mmc_restore_ctx(host);
>  	return 0;
>  }
> 
> @@ -830,6 +996,7 @@ static int omap_mmc_disable(struct mmc_host *mmc, int
> lazy)
>  {
>  	struct mmc_omap_host *host = mmc_priv(mmc);
> 
> +	omap_mmc_save_ctx(host);
>  	clk_disable(host->fclk);
>  	dev_dbg(mmc_dev(host->mmc), "mmc_fclk: disabled\n");
>  	return 0;
> @@ -934,7 +1101,7 @@ static void omap_mmc_set_ios(struct mmc_host *mmc,
> struct mmc_ios *ios)
> 
>  	/* Wait till the ICS bit is set */
>  	timeout = jiffies + msecs_to_jiffies(MMC_TIMEOUT_MS);
> -	while ((OMAP_HSMMC_READ(host->base, SYSCTL) & ICS) != 0x2
> +	while ((OMAP_HSMMC_READ(host->base, SYSCTL) & ICS) != ICS
>  		&& time_before(jiffies, timeout))
>  		msleep(1);
> 
> @@ -1014,12 +1181,19 @@ static int mmc_regs_show(struct seq_file *s, void
> *data)
>  {
>  	struct mmc_host *mmc = s->private;
>  	struct mmc_omap_host *host = mmc_priv(mmc);
> +	struct omap_mmc_platform_data *pdata = host->pdata;
> +	int context_loss = 0;
> +
> +	if (pdata->get_context_loss_count)
> +		context_loss = pdata->get_context_loss_count(host->dev);
> 
>  	seq_printf(s, "mmc%d:\n"
>  			" enabled:\t%d\n"
>  			" nesting_cnt:\t%d\n"
> +			" ctx_loss:\t%d:%d\n"
>  			"\nregs:\n",
> -			mmc->index, mmc->enabled ? 1 : 0, mmc->nesting_cnt);
> +			mmc->index, mmc->enabled ? 1 : 0, mmc->nesting_cnt,
> +			host->context_loss, context_loss);
> 
>  	if (clk_enable(host->fclk) != 0) {
>  		seq_printf(s, "can't read the regs\n");
> @@ -1144,6 +1318,8 @@ static int __init omap_mmc_probe(struct
> platform_device *pdev)
>  		goto err1;
>  	}
> 
> +	omap_mmc_save_ctx(host);
> +
>  	mmc->caps |= MMC_CAP_DISABLE;
>  	mmc_set_disable_delay(mmc, 100);
>  	if (mmc_host_enable(host->mmc) != 0) {
> @@ -1380,21 +1556,19 @@ static int omap_mmc_resume(struct platform_device
> *pdev)
>  		return 0;
> 
>  	if (host) {
> -
> -		if (mmc_host_enable(host->mmc) != 0)
> -			goto clk_en_err;
> -
>  		ret = clk_enable(host->iclk);
> -		if (ret) {
> -			mmc_host_disable(host->mmc);
> -			clk_put(host->fclk);
> +		if (ret)
>  			goto clk_en_err;
> -		}
> 
>  		if (clk_enable(host->dbclk) != 0)
>  			dev_dbg(mmc_dev(host->mmc),
>  					"Enabling debounce clk failed\n");
> 
> +		if (mmc_host_enable(host->mmc) != 0) {
> +			clk_disable(host->iclk);
> +			goto clk_en_err;
> +		}
> +
>  		omap_hsmmc_init(host);
> 
>  		if (host->pdata->resume) {
> --
> 1.5.6.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


