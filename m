Return-Path: <linux-kernel-owner+w=401wt.eu-S1756669AbZBSUov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669AbZBSUov (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 15:44:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754091AbZBSUoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 15:44:39 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52840 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753823AbZBSUoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 15:44:38 -0500
Date: Thu, 19 Feb 2009 12:44:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nicolas Pitre <nico@cam.org>
Cc: drzeus-mmc@drzeus.cx, linux-kernel@vger.kernel.org,
       Maen Suleiman <maen@marvell.com>
Subject: Re: [PATCH] SDIO driver for Marvell SoCs
Message-Id: <20090219124418.dfc4dc9a.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0902172338110.32550@xanadu.home>
References: <alpine.LFD.2.00.0902172338110.32550@xanadu.home>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Feb 2009 23:46:21 -0500 (EST)
Nicolas Pitre <nico@cam.org> wrote:

> From: Maen Suleiman <maen@marvell.com>
> 
> This supports MMC/SD/SDIO currently found on the Kirkwood 88F6281 and
> 88F6192 SoC controllers.
> 
> Signed-off-by: Nicolas Pitre <nico@marvell.com>

It would be nice to have Maen's signoff.

>
> ...
>
> +#define mvsd_write(offs, val)	writel(val, iobase + (offs))
> +#define mvsd_read(offs)		readl(iobase + (offs))

It's rather grotty to have a macro which secretly relies upon the
presence of a particularly-named local variable.

>
> ...
>
> +static int __init mvsd_probe(struct platform_device *pdev)
> +{
> +	struct mmc_host *mmc = NULL;
> +	struct mvsd_host *host = NULL;
> +	const struct mvsdio_platform_data *mvsd_data;
> +	struct resource *r;
> +	int ret, irq;
> +
> +	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	irq = platform_get_irq(pdev, 0);
> +	mvsd_data = pdev->dev.platform_data;
> +	if (!r || irq < 0 || !mvsd_data)
> +		return -ENXIO;
> +
> +	r = request_mem_region(r->start, SZ_1K, DRIVER_NAME);
> +	if (!r)
> +		return -EBUSY;
> +
> +	mmc = mmc_alloc_host(sizeof(struct mvsd_host), &pdev->dev);
> +	if (!mmc) {
> +		ret = -ENOMEM;
> +		goto out;

Resource `r' is leaked here.

> +	}
> +
> +	host = mmc_priv(mmc);
> +	host->mmc = mmc;
> +	host->dev = &pdev->dev;
> +	host->res = r;
> +	host->base_clock = mvsd_data->clock / 2;
> +
> +	mmc->ops = &mvsd_ops;
> +
> +	mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34;
> +	mmc->caps = MMC_CAP_4_BIT_DATA | MMC_CAP_SDIO_IRQ |
> +		    MMC_CAP_SD_HIGHSPEED | MMC_CAP_MMC_HIGHSPEED;
> +
> +	mmc->f_min = DIV_ROUND_UP(host->base_clock, MVSD_BASE_DIV_MAX);
> +	mmc->f_max = maxfreq;
> +
> +	mmc->max_blk_size = 2048;
> +	mmc->max_blk_count = 65535;
> +
> +	mmc->max_hw_segs = 1;
> +	mmc->max_phys_segs = 1;
> +	mmc->max_seg_size = mmc->max_blk_size * mmc->max_blk_count;
> +	mmc->max_req_size = mmc->max_blk_size * mmc->max_blk_count;
> +
> +	spin_lock_init(&host->lock);
> +
> +	host->base = ioremap(r->start, SZ_4K);
> +	if (!host->base) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
> +	/* (Re-)program MBUS remapping windows if we are asked to. */
> +	if (mvsd_data->dram != NULL)
> +		mv_conf_mbus_windows(host, mvsd_data->dram);
> +
> +	mvsd_power_down(host);
> +
> +	ret = request_irq(irq, mvsd_irq, 0, DRIVER_NAME, host);
> +	if (ret) {
> +		printk(KERN_ERR "%s: cannot assign irq %d\n", DRIVER_NAME, irq);
> +		goto out;
> +	} else
> +		host->irq = irq;
> +
> +	if (mvsd_data->gpio_card_detect) {
> +		ret = gpio_request(mvsd_data->gpio_card_detect,
> +				   DRIVER_NAME " cd");
> +		if (ret == 0) {
> +			irq = gpio_to_irq(mvsd_data->gpio_card_detect);
> +			ret = request_irq(irq, mvsd_card_detect_irq,
> +					  IRQ_TYPE_EDGE_RISING | IRQ_TYPE_EDGE_FALLING,
> +					  DRIVER_NAME " cd", host);
> +			if (ret == 0)
> +				host->gpio_card_detect =
> +					mvsd_data->gpio_card_detect;
> +			else
> +				gpio_free(mvsd_data->gpio_card_detect);
> +		}
> +	}
> +	if (!host->gpio_card_detect)
> +		mmc->caps |= MMC_CAP_NEEDS_POLL;
> +
> +	if (mvsd_data->gpio_write_protect) {
> +		ret = gpio_request(mvsd_data->gpio_write_protect,
> +				   DRIVER_NAME " wp");
> +		if (ret == 0) {
> +			gpio_direction_input(mvsd_data->gpio_write_protect);
> +			host->gpio_write_protect =
> +				mvsd_data->gpio_write_protect;
> +		}
> +	}
> +
> +	setup_timer(&host->timer, mvsd_timeout_timer, (unsigned long)host);
> +	platform_set_drvdata(pdev, mmc);
> +	ret = mmc_add_host(mmc);
> +	if (ret)
> +		goto out;
> +	return 0;
> +
> +out:
> +	if (host) {
> +		if (host->irq)
> +			free_irq(host->irq, host);
> +		if (host->gpio_card_detect) {
> +			free_irq(gpio_to_irq(host->gpio_card_detect), host);
> +			gpio_free(host->gpio_card_detect);
> +		}
> +		if (host->gpio_write_protect)
> +			gpio_free(host->gpio_write_protect);
> +		if (host->base)
> +			iounmap(host->base);
> +		if (host->res)
> +			release_resource(host->res);
> +	}
> +	if (mmc)
> +		mmc_free_host(mmc);
> +
> +	return ret;
> +}
> +
> +static int __exit mvsd_remove(struct platform_device *pdev)
> +{
> +	struct mmc_host *mmc = platform_get_drvdata(pdev);
> +
> +	if (mmc) {
> +		struct mvsd_host *host = mmc_priv(mmc);
> +
> +		if (host->gpio_card_detect) {
> +			free_irq(gpio_to_irq(host->gpio_card_detect), host);
> +			gpio_free(host->gpio_card_detect);
> +		}
> +		mmc_remove_host(mmc);
> +		free_irq(host->irq, host);
> +		if (host->gpio_write_protect)
> +			gpio_free(host->gpio_write_protect);
> +		del_timer_sync(&host->timer);
> +		mvsd_power_down(host);
> +		iounmap(host->base);
> +		release_resource(host->res);
> +		mmc_free_host(mmc);

Perhaps this function and the error path ("out:") in the preceding
function could share code.

> +	}
> +	platform_set_drvdata(pdev, NULL);
> +	return 0;

