Return-Path: <linux-kernel-owner+w=401wt.eu-S1757815AbYA2BR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757815AbYA2BR1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 20:17:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752039AbYA2BRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 20:17:19 -0500
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:45636 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902AbYA2BRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 20:17:18 -0500
Message-ID: <479E7E98.3080807@tiscali.nl>
Date: Tue, 29 Jan 2008 02:17:12 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Carlos Aguiar <carlos.aguiar@indt.org.br>
CC: Pierre Ossman <drzeus-list@drzeus.cx>, Tony Lindgren <tony@atomide.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/18] MMC: OMAP: Introduce new multislot structure and
 change driver to use it
References: <479E27EB.3040502@indt.org.br>
In-Reply-To: <479E27EB.3040502@indt.org.br>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Carlos Aguiar wrote:
> From: Juha Yrjola <juha.yrjola@solidboot.com>
> 
> Introduce new MMC multislot structure and change driver to use it.

> diff --git a/drivers/mmc/host/omap.c b/drivers/mmc/host/omap.c

It could be that I misunderstand, but...

> @@ -897,19 +1037,106 @@ static const struct mmc_host_ops mmc_omap_ops = {
>  	.get_ro		= mmc_omap_get_ro,
>  };
>  
> -static int __init mmc_omap_probe(struct platform_device *pdev)
> +static int __init mmc_omap_new_slot(struct mmc_omap_host *host, int id)
>  {
> -	struct omap_mmc_conf *minfo = pdev->dev.platform_data;
> +	struct mmc_omap_slot *slot = NULL;
>  	struct mmc_host *mmc;
> +	int r;
> +
> +	mmc = mmc_alloc_host(sizeof(struct mmc_omap_slot), host->dev);

since you mmc_alloc_host here...

> +	if (mmc == NULL)
> +		return -ENOMEM;
> +
> +	slot = mmc_priv(mmc);
> +	slot->host = host;
> +	slot->mmc = mmc;
> +	slot->id = id;
> +	slot->pdata = &host->pdata->slots[id];
> +
> +	host->slots[id] = slot;
> +
> +	mmc->caps = MMC_CAP_MULTIWRITE | MMC_CAP_MMC_HIGHSPEED |
> +		    MMC_CAP_SD_HIGHSPEED;
> +	if (host->pdata->conf.wire4)
> +		mmc->caps |= MMC_CAP_4_BIT_DATA;
> +
> +	mmc->ops = &mmc_omap_ops;
> +	mmc->f_min = 400000;
> +
> +	if (cpu_class_is_omap2())
> +		mmc->f_max = 48000000;
> +	else
> +		mmc->f_max = 24000000;
> +	if (host->pdata->max_freq)
> +		mmc->f_max = min(host->pdata->max_freq, mmc->f_max);
> +	mmc->ocr_avail = slot->pdata->ocr_mask;
> +
> +	/* Use scatterlist DMA to reduce per-transfer costs.
> +	 * NOTE max_seg_size assumption that small blocks aren't
> +	 * normally used (except e.g. for reading SD registers).
> +	 */
> +	mmc->max_phys_segs = 32;
> +	mmc->max_hw_segs = 32;
> +	mmc->max_blk_size = 2048;	/* BLEN is 11 bits (+1) */
> +	mmc->max_blk_count = 2048;	/* NBLK is 11 bits (+1) */
> +	mmc->max_req_size = mmc->max_blk_size * mmc->max_blk_count;
> +	mmc->max_seg_size = mmc->max_req_size;
> +
> +	r = mmc_add_host(mmc);
> +	if (r < 0)
> +		return r;

shouldn't you mmc_free_host(mmc) here?

> +
> +	if (slot->pdata->name != NULL) {
> +		r = device_create_file(&mmc->class_dev,
> +					&dev_attr_slot_name);
> +		if (r < 0)
> +			goto err_remove_host;
> +	}
> +
> +	if (slot->pdata->get_ro != NULL) {
> +		r = device_create_file(&mmc->class_dev,
> +					&dev_attr_ro);
> +	}
> +
> +	return 0;
> +
> +err_remove_slot_name:

This label has no goto, so the 2 lines below are dead code...
Ok, now I see It's in the next patch. (maybe better to put these lines
in that patch?)

> +	if (slot->pdata->name != NULL)
> +		device_remove_file(&mmc->class_dev, &dev_attr_ro);
> +err_remove_host:
> +	mmc_remove_host(mmc);

and maybe mmc_free_host(mmc) here?

> +	return r;
> +}

from mmc_omap_probe()

+	for (i = 0; i < pdata->nr_slots; i++) {
+		ret = mmc_omap_new_slot(host, i);
+		if (ret < 0) {
+			while (--i >= 0)
+				mmc_omap_remove_slot(host->slots[i]);

mmc_omap_remove_slot() does a mmc_free_host(), but note the decrement of i:
the current isn't freed.
