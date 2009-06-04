Return-Path: <linux-kernel-owner+w=401wt.eu-S1754392AbZFDJ24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392AbZFDJ24 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 05:28:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753242AbZFDJ2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 05:28:48 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37934 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181AbZFDJ2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 05:28:47 -0400
Date: Thu, 4 Jun 2009 10:28:35 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Baruch Siach <baruch@tkos.co.il>
Cc: linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH v3] gpio: driver for PrimeCell PL061 GPIO controller
Message-ID: <20090604092835.GJ29926@n2100.arm.linux.org.uk>
References: <1243975690-12073-1-git-send-email-baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243975690-12073-1-git-send-email-baruch@tkos.co.il>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 02, 2009 at 11:48:10PM +0300, Baruch Siach wrote:
> +static u32 (*pl061_pending_irq)(int irq);

Hmm, not sure this is entirely a good idea, especially when some
platforms may have more than one of these.  It'll work provided they
all point at the same function, but if they don't, it's bad news.

IRQs do have the ability to have chip specific data attached to them.
See set_irq_chip_data() and get_irq_chip_data().

> +static unsigned int pl061_irq_startup(unsigned irq)
> +{
> +	int ret;
> +
> +	ret = gpio_request(irq_to_gpio(irq), "IRQ");
> +	if (ret < 0) {
> +		pr_warning("%s: warning: gpio_request(%d) returned %d\n",
> +				__func__, irq_to_gpio(irq), ret);
> +		return 0;
> +	}
> +
> +	gpio_direction_input(irq_to_gpio(irq));

I thought that it was not expected that claiming an interrupt would claim
a GPIO automatically - in other words, it's the responsibility of the
driver or platform itself to claim GPIOs for interrupts and ensure that
they're properly configured.

> +static int __init pl061_probe(struct amba_device *dev, struct amba_id *id)
> +{
> +	struct pl061_platform_data *pdata;
> +	struct pl061_gpio *chip;
> +	int ret, irq, i;
> +
> +	pdata = dev->dev.platform_data;
> +	if (pdata == NULL)
> +		return -ENODEV;

-EINVAL would be better.

> +
> +	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
> +	if (chip == NULL)
> +		return -ENOMEM;
> +
> +	if (request_mem_region(dev->res.start, SZ_4K, "pl061") == NULL) {

It would be better to keep SZ_* constants out of what are essentially
generic drivers - or we move them into some generic kernel header (but
I don't hold out that much hope of that happening.)

> diff --git a/include/linux/amba/pl061.h b/include/linux/amba/pl061.h
> new file mode 100644
> index 0000000..9e18fa3
> --- /dev/null
> +++ b/include/linux/amba/pl061.h
> @@ -0,0 +1,18 @@
> +/* platform data for the PL061 GPIO driver */
> +
> +#define GPIODIR 0x400
> +#define GPIOIS  0x404
> +#define GPIOIBE 0x408
> +#define GPIOIEV 0x40C
> +#define GPIOIE  0x410
> +#define GPIORIS 0x414
> +#define GPIOMIS 0x418
> +#define GPIOIC  0x41C

I think it would make sense to have the above register definitions in
the .c file.

Thanks.
