Return-Path: <linux-kernel-owner+w=401wt.eu-S933882AbXGYREw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933882AbXGYREw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 13:04:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756376AbXGYREn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 13:04:43 -0400
Received: from gateway-1237.mvista.com ([63.81.120.155]:25135 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754780AbXGYREm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 13:04:42 -0400
Message-ID: <46A78322.3080607@ru.mvista.com>
Date: Wed, 25 Jul 2007 21:06:42 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Vitaly Bordug <vitb@kernel.crashing.org>
Cc: linux-ide@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] [POWERPC] MPC8349E-mITX: use platform IDE driver
 for CF	interface
References: <20070725165318.5331.23795.stgit@localhost.localdomain> <20070725165326.5331.19920.stgit@localhost.localdomain>
In-Reply-To: <20070725165326.5331.19920.stgit@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Vitaly Bordug wrote:

> This updates relevant platform code (freescale mpc8349itx target) 
> to make the CompactFlash work in TrueIDE mode. 

   Erm, I'm not sure it's worth submitting the platform device driver for 
PowerPC at this point, but well...

> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> Signed-off-by: Vitaly Bordug <vitb@kernel.crashing.org>

>  arch/powerpc/boot/dts/mpc8349emitx.dts    |    9 ++++
>  arch/powerpc/platforms/83xx/mpc834x_itx.c |   70 +++++++++++++++++++++++++++++
>  2 files changed, 79 insertions(+), 0 deletions(-)

> diff --git a/arch/powerpc/boot/dts/mpc8349emitx.dts b/arch/powerpc/boot/dts/mpc8349emitx.dts
> index db0d003..f8f0e8a 100644
> --- a/arch/powerpc/boot/dts/mpc8349emitx.dts
> +++ b/arch/powerpc/boot/dts/mpc8349emitx.dts
> @@ -37,6 +37,15 @@
>  		reg = <00000000 10000000>;
>  	};
>  
> +	ide@f0000000 {
> +		compatible = "mmio-ide";
> +		device_type = "ide";

    Why not "ata"?

> +		reg = <f0000000 10 f000020c 4>;
> +		ioport_shift = <1>;

    Please use hyphen, not underscore in the property names ("device_type" 
seems an only exception from this rule).
    And since using shift instead of size buys you nothing is this case, I'd 
prefer this property to be called reg-size or reg-stride.

[...]
> diff --git a/arch/powerpc/platforms/83xx/mpc834x_itx.c b/arch/powerpc/platforms/83xx/mpc834x_itx.c
> index 40a0194..d63a104 100644
> --- a/arch/powerpc/platforms/83xx/mpc834x_itx.c
> +++ b/arch/powerpc/platforms/83xx/mpc834x_itx.c
[...]
> @@ -43,6 +44,75 @@ unsigned long isa_io_base = 0;
>  unsigned long isa_mem_base = 0;
>  #endif
>  
> +static int __init mmio_ide_of_init(void)
> +{
> +	struct device_node *np;
> +	unsigned int i;
> +
> +	for (np = NULL, i = 0;
> +	     (np = of_find_compatible_node(np, "ide", "mmio-ide")) != NULL;
> +	     i++) {
> +		int ret = 0;

    Unneeded initialization.

> +		struct resource res[3];
> +		struct platform_device *pdev = NULL;

    Another one.

> +		static struct pata_platform_info pdata;
> +
> +		memset(res, 0, sizeof(res));
> +
> +		ret = of_address_to_resource(np, 0, &res[0]);
> +		if (ret) {
> +			printk(KERN_ERR "mmio-ide.%d: unable to get "
> +			       "resource from OF\n", i);
> +			goto err0;
> +		}
> +
> +		ret = of_address_to_resource(np, 1, &res[1]);
> +		if (ret) {
> +			printk(KERN_ERR "mmio-ide.%d: unable to get "
> +			       "resource from OF\n", i);
> +			goto err0;

    Erm, these printk's are repetitive, isn't it better to put them under err0 
label?

> +		}
> +
> +		res[2].start = res[2].end = irq_of_parse_and_map(np, 0);
> +		if (res[2].start == NO_IRQ) {
> +			printk(KERN_ERR "mmio-ide.%d: no IRQ\n", i);
> +			goto err0;
> +		}
> +		res[2].name = "pata_platform";
> +		res[2].flags = IORESOURCE_IRQ;
> +
> +		pdata.ioport_shift = *((u32 *)of_get_property(np,
> +					"ioport_shift", NULL));
> +
> +		pdev = platform_device_alloc("pata_platform", i);
> +		if (!pdev)
> +			goto err1;

    Hm, not err0?

> +
> +		ret = platform_device_add_data(pdev, &pdata, sizeof(pdata));
> +		if (ret)
> +			goto err1;
> +
> +		ret = platform_device_add_resources(pdev, res, ARRAY_SIZE(res));
> +		if (ret)
> +			goto err1;
> +
> +		ret = platform_device_register(pdev);
> +		if (ret)
> +			goto err1;
> +
> +		continue;
> +err1:
> +		printk(KERN_ERR "mmio-ide.%d: registration failed\n", i);
> +		platform_device_del(pdev); /* it will free everything */
> +err0:
> +		/* Even if some device failed, try others */
> +		continue;
> +	}
> +
> +	return 0;
> +}
> +device_initcall(mmio_ide_of_init);
> +
>  /* ************************************************************************
>   *
>   * Setup the architecture

MBR, Sergei
