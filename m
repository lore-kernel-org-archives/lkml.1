Return-Path: <linux-kernel-owner+w=401wt.eu-S1753844AbXGGQo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbXGGQo7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 12:44:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752337AbXGGQou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 12:44:50 -0400
Received: from h155.mvista.com ([63.81.120.155]:55629 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752307AbXGGQot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 12:44:49 -0400
Message-ID: <468FC376.2040405@ru.mvista.com>
Date: Sat, 07 Jul 2007 20:46:46 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Vitaly Bordug <vitb@kernel.crashing.org>
Cc: linux-ide@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] [POWERPC] mmio ide support for mpc8349-itx target
References: <20070707094852.9473.21013.stgit@localhost.localdomain> <20070707094900.9473.48577.stgit@localhost.localdomain>
In-Reply-To: <20070707094900.9473.48577.stgit@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Vitaly Bordug wrote:

> This updates relevant platform code
> (freescale mpc8349itx target) to make the CompactFlash
> work in TrueIDE mode.

> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> Signed-off-by: Vitaly Bordug <vitb@kernel.crashing.org>

    It would have been good if you tried to actualy compile your code. ;-)

> diff --git a/arch/powerpc/boot/dts/mpc8349emitx.dts b/arch/powerpc/boot/dts/mpc8349emitx.dts
> index db0d003..b3e80ab 100644
> --- a/arch/powerpc/boot/dts/mpc8349emitx.dts
> +++ b/arch/powerpc/boot/dts/mpc8349emitx.dts
> @@ -42,7 +42,7 @@
>  		#size-cells = <1>;
>  		#interrupt-cells = <2>;
>  		device_type = "soc";
> -		ranges = <0 e0000000 00100000>;
> +		ranges = <0 e0000000 1f000000>;
>  		reg = <e0000000 00000200>;
>  		bus-frequency = <0>;                    // from bootloader
>  
> @@ -229,6 +229,21 @@
>  			descriptor-types-mask = <01010ebf>;
>  		};
>  
> +		ide@10000000 {
> + 			#interrupt-cells = <2>;

    Hm, why define that prop for a node with no children?

> + 			interrupts = <17 8>;
> + 			interrupt-map = <0 0 0 1 700 17 8>;
> + 			interrupt-map-mask = <0>;
> + 
> + 			#size-cells = <1>;
> + 			#address-cells = <1>;

    Same question here.

> + 			reg = <10000000 10 10000200 10>;
> + 
> + 			device_type = "ide";

    I think that already adopted device type is "ata", not "ide".

> + 			compatible = "mmio-ide";
> + 			interrupt-parent = < &ipic >;
> + 		};
> +
>  		ipic: pic@700 {
>  			interrupt-controller;
>  			#address-cells = <0>;
> diff --git a/arch/powerpc/sysdev/fsl_soc.c b/arch/powerpc/sysdev/fsl_soc.c
> index cad1757..b3fe011 100644
> --- a/arch/powerpc/sysdev/fsl_soc.c
> +++ b/arch/powerpc/sysdev/fsl_soc.c
> @@ -1103,3 +1103,116 @@ err:
>  arch_initcall(cpm_smc_uart_of_init);
>  
>  #endif /* CONFIG_8xx */
> +
> +#ifdef CONFIG_MPC834x_ITX

    Erm, isn't this stuff misplaced? Is this really SoC device? I remember 
seeng this in the arch/ppc/ platform code before (in the internal tree)...

> +#include <linux/ide.h>
> +#include <linux/mmio-ide.h>
> +#include <asm-ppc/mpc83xx.h>
> +
> +static void mmio_ide_outsw(unsigned long port, void *addr, u32 count)
> +{
> +	_outsw_ns((void __iomem *)port, addr, count);
> +}
> +
> +static void mmio_ide_insw(unsigned long port, void *addr, u32 count)
> +{
> +	_insw_ns((void __iomem *)port, addr, count);
> +}
> +
> +void mmio_ide_mmiops (ide_hwif_t *hwif)
> +{
> +	default_hwif_mmiops(hwif);
> +	hwif->OUTL = NULL;

    OUTL() method no longer exists.

> +	hwif->OUTSW = mmio_ide_outsw;
> +	hwif->OUTSL = NULL;
> +	hwif->INL = NULL;

    And neither INL() does.

> +	hwif->INSW = mmio_ide_insw;
> +	hwif->INSL = NULL;
> +}
> +
> +void mmio_ide_selectproc (ide_drive_t *drive)
> +{
> +	u8 stat;
> +
> +	stat = drive->hwif->INB(IDE_STATUS_REG);
> +	if ((stat & READY_STAT) && (stat & BUSY_STAT))
> +		drive->present = 0;
> +	else
> +		drive->present = 1;
> +}
> +

    Heh, attempt to emulate hotplug. :-)

> +static int __init fsl_mmio_ide_of_init(void)
> +{
> +	struct device_node *np;
> +	unsigned int i;
> +
> +	for (np = NULL, i = 0;
> +	     (np = of_find_compatible_node(np, "ide", "mmio-ide")) != NULL;
> +	     i++) {
> +		int ret = 0;
> +		struct resource res[3];
> +		struct platform_device *pdev = NULL;
> +		static struct mmio_ide_platform_data pdata = {
> +			/* TODO: pass via OF? */
> +			.byte_lanes_swapping = 0,
> +			.regaddr_step        = 2,
> +			.mmiops              = mmio_ide_mmiops,
> +			.selectproc          = mmio_ide_selectproc,

    Definitely, you won't be able to pass methods via of_platform_device. :-)

> +		};
> +
> +		memset(res, 0, sizeof(res));
> +
> +		ret = of_address_to_resource(np, 0, &res[0]);
> +		if (ret) {
> +			printk(KERN_ERR "mmio-ide.%d: unable to get "
> +			       "resource from OF\n",i );

    CodingStyle: space after comma, no space before paren.

[...]
> +		res[2].name = "mmio-ide";
> +		res[2].flags = IORESOURCE_IRQ;;

    One ; too many here. ;-)

MBR, Sergei
