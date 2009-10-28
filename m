Return-Path: <linux-kernel-owner+w=401wt.eu-S1754364AbZJ1Pdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364AbZJ1Pdl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 11:33:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754338AbZJ1Pdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 11:33:40 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37526 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751360AbZJ1Pdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 11:33:40 -0400
Date: Wed, 28 Oct 2009 15:35:03 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Maciej Sosnowski <maciej.sosnowski@intel.com>,
       Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org,
       Linus Walleij <linus.walleij@stericsson.com>
Subject: Re: [PATCH 1/2] Add COH 901 318 DMA block driver v3
Message-ID: <20091028153503.11018cbe@lxorguk.ukuu.org.uk>
In-Reply-To: <1256743137-16987-1-git-send-email-linus.walleij@stericsson.com>
References: <1256743137-16987-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +struct dma_chan;
> +struct platform_device;
> +struct dma_chan;
> +struct dma_async_tx_descriptor;
> +enum dma_data_direction;

Surely it would be better to get the headers included in the right order ?

> +	dev_buf = kmalloc(4*1024, GFP_KERNEL);
> +
> +	snprintf(tmp, 50, "DMA -- enable dma channels\n");
> +	strcat(dev_buf, tmp);

Out of memory - NULL - bang

> +
> +	for (i = 0; i < debugfs_dma_base->platform->max_channels; i++) {
> +		if (started_channels & (1 << i)) {
> +			snprintf(tmp, 50, "channel %d\n", i);
> +			strcat(dev_buf, tmp);

Why not do this without the copies ? 

		x += snprintf(x, .., .....)

> +	if (*f_pos + count > dev_size)
> +		count = dev_size - *f_pos;

Overflow ? or is your offset protected elsewhere from lseek/large count ?



> +	pm->started_channels &= ~((u64)1 << cohc->id);

1ULL is perhaps cleaner ?


> +	void *virtbase = cohc->base->virtbase;

These should probably be __iomem to keep sparse happy ?


> +static int __init coh901318_probe(struct platform_device *pdev)
> +{

> +	base = kmalloc(ALIGN(sizeof(struct coh901318_base), 4) +
> +		       pdata->max_channels *
> +		       sizeof(struct coh901318_chan),
> +		       GFP_KERNEL);
> +	base->chans = ((void *)base) + ALIGN(sizeof(struct coh901318_base), 4);
> +
> +	if (!base)
> +		goto err_alloc_coh_dma_channels;

I'd swap those two over 8)

> +	err = request_irq(irq, dma_irq_handler, IRQF_DISABLED,
> +			  "coh901318", base);

You pass base here


> + err_pool_create:
> +	free_irq(platform_get_irq(pdev, 0), NULL);

So need to do likewise here

> +static int __exit coh901318_remove(struct platform_device *pdev)
> +{
> +	struct coh901318_base *base = platform_get_drvdata(pdev);
> +
> +	dma_async_device_unregister(&base->dma_memcpy);
> +	dma_async_device_unregister(&base->dma_slave);
> +	coh901318_pool_destroy(&base->pool);
> +	free_irq(platform_get_irq(pdev, 0), NULL);

and here

