Return-Path: <linux-kernel-owner+w=401wt.eu-S1755374AbZFBADQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374AbZFBADQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 20:03:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753456AbZFBADJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 20:03:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59269 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753373AbZFBADI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 20:03:08 -0400
Date: Mon, 1 Jun 2009 17:02:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tobias_Mueller@twam.info
Cc: david-b@pacbell.net, jordan@cosmicpenguin.net, gardner.ben@gmail.com,
       linux-kernel@vger.kernel.org, Andres Salomon <dilinger@queued.net>
Subject: Re: [PATCH v2 001/001] gpio: AMD CS5535/CS5536 GPIO driver
Message-Id: <20090601170255.c10d744c.akpm@linux-foundation.org>
In-Reply-To: <17be05570905301105h395689ja33afa96e7751381@mail.gmail.com>
References: <17be05570905230453i591eb83bnb359f6365c109718@mail.gmail.com>
	<20090526151621.a7446c60.akpm@linux-foundation.org>
	<17be05570905301105h395689ja33afa96e7751381@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 May 2009 20:05:52 +0200
Tobias M__ller <Tobias_Mueller@twam.info> wrote:

> From: Tobias Mueller <Tobias_Mueller@twam.info>
> 
> A GPIO driver for AMD Geode Companion Device CS5535/CS5536
> using the GPIO framework as a replacement for old cs5535-gpio driver.
>
> ...
>
> +/* base address of gpio I/O*/
> +static u32 iobase;

Formally this should have type resource_size_t, I think.  Or `void
__iomem *'.  But given the limited applicability of this driver
(geode-only), I guess u32 is OK.

> +static int gpiobase;
> +module_param_named(gpiobase, gpiobase, int, 0444);
> +MODULE_PARM_DESC(gpiobase, "The GPIO number base. -1 means dynamic");
> +
> +static ulong mask;

hm, ulong isn't a particularly popular "type" in the kernel.  But I
guess it's stable enough.

> +module_param_named(mask, mask, ulong, 0444);
> +MODULE_PARM_DESC(mask, "GPIO channel mask.");
> +
> +/* gets the regiter offset for the GPIO bank.
> + *      low (0-15) stats at 0x00, high (16-31) starts at 0x80 */
>
> ...
>
> +#define gpio_cs5535_suspend NULL
> +#define gpio_cs5535_resume NULL
> +
> +static struct pci_driver gpio_cs5535_driver = {
> +	.name           = "gpio_cs5535",
> +	.id_table       = gpio_cs5535_pci_tbl,
> +	.probe          = gpio_cs5535_probe,
> +	.remove         = gpio_cs5535_remove,
> +	.suspend        = gpio_cs5535_suspend,
> +	.resume         = gpio_cs5535_resume,
> +};

What are the implications of not having suspend/resume support?

> +static int __init gpio_cs5535_init(void)
> +{
> +	return pci_register_driver(&gpio_cs5535_driver);
> +}
> +module_init(gpio_cs5535_init)
> +
> +static void __exit gpio_cs5535_exit(void)
> +{
> +	pci_unregister_driver(&gpio_cs5535_driver);
> +}
> +module_exit(gpio_cs5535_exit);

