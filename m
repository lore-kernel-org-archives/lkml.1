Return-Path: <linux-kernel-owner+w=401wt.eu-S1755763AbZFYClB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763AbZFYClB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 22:41:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753276AbZFYCky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 22:40:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45011 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753240AbZFYCkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 22:40:53 -0400
Date: Wed, 24 Jun 2009 19:40:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ryan Mallon <ryan@bluewatersys.com>
Cc: Linus Walleij <linus.ml.walleij@gmail.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       spi-devel-general@lists.sourceforge.net,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] SST25L (non JEDEC) SPI Flash driver
Message-Id: <20090624194005.2f9574ce.akpm@linux-foundation.org>
In-Reply-To: <4A42BDF3.10901@bluewatersys.com>
References: <4A42BDF3.10901@bluewatersys.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jun 2009 11:59:47 +1200 Ryan Mallon <ryan@bluewatersys.com> wrote:

> Add support for the non JEDEC SST25L SPI Flash devices.
> 
> Signed-off-by: Andre Renaud <andre@bluewatersys.com>
> Signed-off-by: Ryan Mallon <ryan@bluewatersys.com>
> Acked-by: Linus Walleij <linus.walleij@stericsson.com>

It looks OK to my inexperienced eye.

> ...
>
> +		bytes = min(mtd->writesize, (u32)(len - i));

The conventional way of suppressing the warning is min_t().

> +static int __init sst25l_probe(struct spi_device *spi)
> +{
> +	struct flash_info *flash_info;
> +	struct sst25l_flash *flash;
> +	struct flash_platform_data *data;
> +	int i;
> +
> +	flash_info = sst25l_match_device(spi);
> +	if (!flash_info)
> +		return -ENODEV;
> +
> +	flash = kzalloc(sizeof(struct sst25l_flash), GFP_KERNEL);
> +	if (!flash)
> +		return -ENOMEM;
> +
> +	flash->spi = spi;
> +	mutex_init(&flash->lock);
> +	dev_set_drvdata(&spi->dev, flash);
> +
> +	data = spi->dev.platform_data;
> +	if (data && data->name)
> +		flash->mtd.name = data->name;
> +	else
> +		flash->mtd.name = dev_name(&spi->dev);
> +
> +	flash->mtd.type		= MTD_NORFLASH;
> +	flash->mtd.flags	= MTD_CAP_NORFLASH;
> +	flash->mtd.erasesize	= flash_info->erase_size;
> +	flash->mtd.writesize	= flash_info->page_size;
> +	flash->mtd.size		= flash_info->page_size * flash_info->nr_pages;
> +	flash->mtd.erase	= sst25l_erase;
> +	flash->mtd.read		= sst25l_read;
> +	flash->mtd.write 	= sst25l_write;
> +
> +	dev_info(&spi->dev, "%s (%lld Kbytes)\n", flash_info->name,
> +		 (long long)flash->mtd.size >> 10);
> +
> +	DEBUG(MTD_DEBUG_LEVEL2,
> +	      "mtd .name = %s, .size = 0x%llx (%lldMiB) "
> +	      ".erasesize = 0x%.8x (%uKiB) .numeraseregions = %d\n",
> +	      flash->mtd.name,
> +	      (long long)flash->mtd.size, (long long)(flash->mtd.size >> 20),
> +	      flash->mtd.erasesize, flash->mtd.erasesize / 1024,
> +	      flash->mtd.numeraseregions);
> +
> +	if (flash->mtd.numeraseregions)
> +		for (i = 0; i < flash->mtd.numeraseregions; i++)
> +			DEBUG(MTD_DEBUG_LEVEL2,
> +			      "mtd.eraseregions[%d] = { .offset = 0x%llx, "
> +			      ".erasesize = 0x%.8x (%uKiB), "
> +			      ".numblocks = %d }\n",
> +			      i, (long long)flash->mtd.eraseregions[i].offset,
> +			      flash->mtd.eraseregions[i].erasesize,
> +			      flash->mtd.eraseregions[i].erasesize / 1024,
> +			      flash->mtd.eraseregions[i].numblocks);
> +
> +	if (mtd_has_partitions()) {
> +		struct mtd_partition *parts = NULL;
> +		int nr_parts = 0;
> +
> +		if (mtd_has_cmdlinepart()) {
> +			static const char *part_probes[] =
> +				{"cmdlinepart", NULL};
> +
> +			nr_parts = parse_mtd_partitions(&flash->mtd,
> +							part_probes,
> +							&parts, 0);
> +		}
> +
> +		if (nr_parts <= 0 && data && data->parts) {
> +			parts = data->parts;
> +			nr_parts = data->nr_parts;
> +		}
> +
> +		if (nr_parts > 0) {
> +			for (i = 0; i < nr_parts; i++) {
> +				DEBUG(MTD_DEBUG_LEVEL2, "partitions[%d] = "
> +				      "{.name = %s, .offset = 0x%llx, "
> +				      ".size = 0x%llx (%lldKiB) }\n",
> +				      i, parts[i].name,
> +				      (long long)parts[i].offset,
> +				      (long long)parts[i].size,
> +				      (long long)(parts[i].size >> 10));
> +			}
> +
> +			flash->partitioned = 1;
> +			return add_mtd_partitions(&flash->mtd,
> +						  parts, nr_parts);
> +		}
> +
> +	} else if (data->nr_parts) {
> +		dev_warn(&spi->dev, "ignoring %d default partitions on %s\n",
> +			 data->nr_parts, data->name);
> +	}
> +
> +	return add_mtd_device(&flash->mtd) == 1 ? -ENODEV : 0;

If this returns -ENODEV, did we leak the memory at *flash?

> +}
> +

