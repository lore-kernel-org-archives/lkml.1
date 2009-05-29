Return-Path: <linux-kernel-owner+w=401wt.eu-S1755140AbZE2XaH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140AbZE2XaH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 19:30:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752354AbZE2X35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 19:29:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37339 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751825AbZE2X34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 19:29:56 -0400
Date: Fri, 29 May 2009 16:29:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
       linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] hwrng: Add TX4939 RNG driver
Message-Id: <20090529162907.9cb1bba2.akpm@linux-foundation.org>
In-Reply-To: <1243350141-883-1-git-send-email-anemo@mba.ocn.ne.jp>
References: <1243350141-883-1-git-send-email-anemo@mba.ocn.ne.jp>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 May 2009 00:02:20 +0900
Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:

> This patch adds support for the integrated RNG of the TX4939 SoC.
> 

I think Herbert handles hwrng patches?

I assume that the MIPS patch "[PATCH] TXx9: Add TX4939 RNG support"
depends upon this patch?

>  create mode 100644 drivers/char/hw_random/tx4939-rng.c
> 
> diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
> index 5fab647..9d321cc 100644
> --- a/drivers/char/hw_random/Kconfig
> +++ b/drivers/char/hw_random/Kconfig
> @@ -148,3 +148,16 @@ config HW_RANDOM_VIRTIO
>  
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called virtio-rng.  If unsure, say N.
> +
> +config HW_RANDOM_TX4939
> +	tristate "TX4939 Random Number Generator support"
> +	depends on HW_RANDOM && SOC_TX4939
> +	default HW_RANDOM
> +	---help---
> +	  This driver provides kernel-side support for the Random Number
> +	  Generator hardware found on TX4939 SoC.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called tx4939-rng.
> +
> +	  If unsure, say Y.
> diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_random/Makefile
> index e81d21a..936d388 100644
> --- a/drivers/char/hw_random/Makefile
> +++ b/drivers/char/hw_random/Makefile
> @@ -15,3 +15,4 @@ obj-$(CONFIG_HW_RANDOM_IXP4XX) += ixp4xx-rng.o
>  obj-$(CONFIG_HW_RANDOM_OMAP) += omap-rng.o
>  obj-$(CONFIG_HW_RANDOM_PASEMI) += pasemi-rng.o
>  obj-$(CONFIG_HW_RANDOM_VIRTIO) += virtio-rng.o
> +obj-$(CONFIG_HW_RANDOM_TX4939) += tx4939-rng.o
> diff --git a/drivers/char/hw_random/tx4939-rng.c b/drivers/char/hw_random/tx4939-rng.c
> new file mode 100644
> index 0000000..27aed22
> --- /dev/null
> +++ b/drivers/char/hw_random/tx4939-rng.c
> @@ -0,0 +1,157 @@
> +/*
> + * RNG driver for TX4939 Random Number Generators (RNG)
> + *
> + * Copyright (C) 2009 Atsushi Nemoto <anemo@mba.ocn.ne.jp>
> + *
> + * This file is subject to the terms and conditions of the GNU General Public
> + * License.  See the file "COPYING" in the main directory of this archive
> + * for more details.
> + */
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/delay.h>
> +#include <linux/io.h>
> +#include <linux/platform_device.h>
> +#include <linux/hw_random.h>
> +
> +#define TX4939_RNG_RCSR		0x00000000
> +#define TX4939_RNG_ROR(n)	(0x00000018 + (n) * 8)
> +
> +#define TX4939_RNG_RCSR_INTE	0x00000008
> +#define TX4939_RNG_RCSR_RST	0x00000004
> +#define TX4939_RNG_RCSR_FIN	0x00000002
> +#define TX4939_RNG_RCSR_ST	0x00000001
> +
> +struct tx4939_rng {
> +	struct hwrng rng;
> +	void __iomem *base;
> +	u64 databuf[3];
> +	unsigned int data_avail;
> +};
> +
> +static u64 read_rng(void __iomem *base, unsigned int offset)
> +{
> +	/* Caller must disable interrupts */
> +	return ____raw_readq(base + offset);
> +}

What is the reasoning behind the local_irq_disable() requirement?

Because I'm wondering whether this is safe on SMP?

> +static void write_rng(u64 val, void __iomem *base, unsigned int offset)
> +{
> +	return ____raw_writeq(val, base + offset);
> +}
> +
> +static int tx4939_rng_data_present(struct hwrng *rng, int wait)
> +{
> +	struct tx4939_rng *rngdev = container_of(rng, struct tx4939_rng, rng);
> +	int i;
> +
> +	if (rngdev->data_avail)
> +		return rngdev->data_avail;
> +	for (i = 0; i < 20; i++) {
> +		local_irq_disable();
> +		if (!(read_rng(rngdev->base, TX4939_RNG_RCSR)
> +		      & TX4939_RNG_RCSR_ST)) {
> +			rngdev->databuf[0] =
> +				read_rng(rngdev->base, TX4939_RNG_ROR(0));
> +			rngdev->databuf[1] =
> +				read_rng(rngdev->base, TX4939_RNG_ROR(1));
> +			rngdev->databuf[2] =
> +				read_rng(rngdev->base, TX4939_RNG_ROR(2));
> +			rngdev->data_avail =
> +				sizeof(rngdev->databuf) / sizeof(u32);
> +			/* Start RNG */
> +			write_rng(TX4939_RNG_RCSR_ST,
> +				  rngdev->base, TX4939_RNG_RCSR);
> +			wait = 0;
> +		}
> +		local_irq_enable();
> +		if (!wait)
> +			break;
> +		udelay(1);
> +	}
> +	return rngdev->data_avail;
> +}

The mysterious udelay() needs a comment, because there is no way in
which the reader can otherwise work out why it is there.

> +static int tx4939_rng_data_read(struct hwrng *rng, u32 *buffer)
> +{
> +	struct tx4939_rng *rngdev = container_of(rng, struct tx4939_rng, rng);
> +
> +	rngdev->data_avail--;
> +	*buffer = *((u32 *)&rngdev->databuf + rngdev->data_avail);
> +	return sizeof(u32);
> +}

Concurrent callers can corrupt rngdev->data_avail ?

> +static int __init tx4939_rng_probe(struct platform_device *dev)
> +{
> +	struct tx4939_rng *rngdev;
> +	struct resource *r;
> +	int i;
> +
> +	r = platform_get_resource(dev, IORESOURCE_MEM, 0);
> +	if (!r)
> +		return -EBUSY;
> +	rngdev = devm_kzalloc(&dev->dev, sizeof(*rngdev), GFP_KERNEL);
> +	if (!rngdev)
> +		return -ENOMEM;
> +	if (!devm_request_mem_region(&dev->dev, r->start, resource_size(r),
> +				     dev_name(&dev->dev)))
> +		return -EBUSY;
> +	rngdev->base = devm_ioremap(&dev->dev, r->start, resource_size(r));
> +	if (!rngdev->base)
> +		return -EBUSY;
> +
> +	rngdev->rng.name = dev_name(&dev->dev);
> +	rngdev->rng.data_present = tx4939_rng_data_present;
> +	rngdev->rng.data_read = tx4939_rng_data_read;
> +
> +	local_irq_disable();
> +	/* Reset RNG */
> +	write_rng(TX4939_RNG_RCSR_RST, rngdev->base, TX4939_RNG_RCSR);
> +	write_rng(0, rngdev->base, TX4939_RNG_RCSR);
> +	/* Start RNG */
> +	write_rng(TX4939_RNG_RCSR_ST, rngdev->base, TX4939_RNG_RCSR);
> +	local_irq_enable();
> +	/* drop first two results */

The comment doesn't provide the reason for doing this?

> +	for (i = 0; i < 2; i++) {
> +		rngdev->data_avail = 0;
> +		if (!tx4939_rng_data_present(&rngdev->rng, 1))
> +			return -EIO;
> +	}
> +
> +	platform_set_drvdata(dev, rngdev);
> +	return hwrng_register(&rngdev->rng);
> +}
> +
> +static int __exit tx4939_rng_remove(struct platform_device *dev)
> +{
> +	struct tx4939_rng *rngdev = platform_get_drvdata(dev);
> +
> +	hwrng_unregister(&rngdev->rng);
> +	platform_set_drvdata(dev, NULL);
> +	return 0;
> +}
> +
> +static struct platform_driver tx4939_rng_driver = {
> +	.driver		= {
> +		.name	= "tx4939-rng",
> +		.owner	= THIS_MODULE,
> +	},
> +	.remove = tx4939_rng_remove,
> +};
> +
> +static int __init tx4939_rng_init(void)
> +{
> +	return platform_driver_probe(&tx4939_rng_driver, tx4939_rng_probe);
> +}
> +
> +static void __exit tx4939_rng_exit(void)
> +{
> +	platform_driver_unregister(&tx4939_rng_driver);
> +}
> +
> +module_init(tx4939_rng_init);
> +module_exit(tx4939_rng_exit);
> +
> +MODULE_DESCRIPTION("H/W Random Number Generator (RNG) driver for TX4939");
> +MODULE_LICENSE("GPL");

