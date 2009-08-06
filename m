Return-Path: <linux-kernel-owner+w=401wt.eu-S1756898AbZHFXIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898AbZHFXIB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 19:08:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756877AbZHFXIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 19:08:00 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:34858 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756262AbZHFXH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 19:07:59 -0400
Date: Fri, 7 Aug 2009 00:07:26 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Dhaval Vasa <dhaval.vasa@einfochips.com>
Cc: nico@marvell.com, linux-kernel@vger.kernel.org, rabeeh@marvell.com
Subject: Re: [PATCH] [ARM] Kirkwood: Marvell OpenRD-Base board support
	added to v2.6.31-rc5
Message-ID: <20090806230726.GA19624@fluff.org.uk>
References: <1249567753-724-1-git-send-email-dhaval.vasa@einfochips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249567753-724-1-git-send-email-dhaval.vasa@einfochips.com>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 06, 2009 at 07:39:13PM +0530, Dhaval Vasa wrote:
> reference:
> http://open-rd.org
> http://code.google.com/p/openrd
> 
> This patch is tested for:
> 1. Boot from DRAM/NAND flash
> 2. NAND read/write/erase
> 3. GbE0
> 4. USB read/write
> 
> FIXME:
> 1. SD/UART1 selection
> 2. MPP configuration (currently, default)
> 3. PEX
> 
> Signed-off-by: Dhaval Vasa <dhaval.vasa@einfochips.com>

You forgot to cc: linux-arm-kernel@lists.arm.linux.org.uk, although
someone really should issue a MAINTAINERS entry for that machine
directory.

> ---
>  arch/arm/mach-kirkwood/Kconfig             |    5 ++
>  arch/arm/mach-kirkwood/Makefile            |    1 +
>  arch/arm/mach-kirkwood/openrd_base-setup.c |   79 ++++++++++++++++++++++++++++
>  3 files changed, 85 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/mach-kirkwood/openrd_base-setup.c

call this openrd.c or openrd_base.c, the -setup is redundant as
these directories are suposed to have the machine setup files in
them.

> diff --git a/arch/arm/mach-kirkwood/Kconfig b/arch/arm/mach-kirkwood/Kconfig
> index 25100f7..f2379b3 100644
> --- a/arch/arm/mach-kirkwood/Kconfig
> +++ b/arch/arm/mach-kirkwood/Kconfig
> @@ -38,6 +38,11 @@ config MACH_TS219
>  	  Say 'Y' here if you want your kernel to support the
>  	  QNAP TS-119 and TS-219 Turbo NAS devices.
>  
> +config MACH_OPENRD_BASE
> +	bool "Marvell OpenRD Base Board"
> +	help
> +	  Say 'Y' here if you want your kernel to support the
> +	  Marvell OpenRD Base Board.
>  endmenu
>  
>  endif
> diff --git a/arch/arm/mach-kirkwood/Makefile b/arch/arm/mach-kirkwood/Makefile
> index 9dd680e..80ab0ec 100644
> --- a/arch/arm/mach-kirkwood/Makefile
> +++ b/arch/arm/mach-kirkwood/Makefile
> @@ -6,5 +6,6 @@ obj-$(CONFIG_MACH_RD88F6281)		+= rd88f6281-setup.o
>  obj-$(CONFIG_MACH_MV88F6281GTW_GE)	+= mv88f6281gtw_ge-setup.o
>  obj-$(CONFIG_MACH_SHEEVAPLUG)		+= sheevaplug-setup.o
>  obj-$(CONFIG_MACH_TS219)		+= ts219-setup.o
> +obj-$(CONFIG_MACH_OPENRD_BASE)		+= openrd_base-setup.o
>  
>  obj-$(CONFIG_CPU_IDLE)			+= cpuidle.o
> diff --git a/arch/arm/mach-kirkwood/openrd_base-setup.c b/arch/arm/mach-kirkwood/openrd_base-setup.c
> new file mode 100644
> index 0000000..26b6e58
> --- /dev/null
> +++ b/arch/arm/mach-kirkwood/openrd_base-setup.c
> @@ -0,0 +1,79 @@
> +/*
> + * arch/arm/mach-kirkwood/openrd_base-setup.c
> + *
> + * Marvell OpenRD Base Board Setup
> + *
> + * This file is licensed under the terms of the GNU General Public
> + * License version 2.  This program is licensed "as is" without any
> + * warranty of any kind, whether express or implied.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/platform_device.h>
> +#include <linux/mtd/partitions.h>
> +#include <linux/mv643xx_eth.h>
> +#include <linux/gpio.h>
> +#include <linux/leds.h>
> +#include <asm/mach-types.h>
> +#include <asm/mach/arch.h>
> +#include <mach/kirkwood.h>
> +#include <plat/mvsdio.h>
> +#include "common.h"
> +#include "mpp.h"
> +
> +static struct mtd_partition openrd_base_nand_parts[] = {
> +	{
> +		.name = "u-boot",
> +		.offset = 0,
> +		.size = SZ_1M
> +	}, {
> +		.name = "uImage",
> +		.offset = MTDPART_OFS_NXTBLK,
> +		.size = SZ_4M
> +	}, {
> +		.name = "root",
> +		.offset = MTDPART_OFS_NXTBLK,
> +		.size = MTDPART_SIZ_FULL
> +	},
> +};
> +
> +static struct mv643xx_eth_platform_data openrd_base_ge00_data = {
> +	.phy_addr	= MV643XX_ETH_PHY_ADDR(8),
> +};
> +
> +static struct mvsdio_platform_data openrd_base_mvsdio_data = {
> +	.gpio_card_detect = MPP29_GPIO,	/* MPP29 used as SD card detect */
> +};
> +
> +static unsigned int openrd_base_mpp_config[] __initdata = {
> +	0
> +};
> +
> +static void __init openrd_base_init(void)
> +{
> +	/*
> +	 * Basic setup. Needs to be called early.
> +	 */
> +	kirkwood_init();
> +	kirkwood_mpp_conf(openrd_base_mpp_config);
> +
> +	kirkwood_uart0_init();
> +	kirkwood_nand_init(ARRAY_AND_SIZE(openrd_base_nand_parts), 25);
> +
> +	kirkwood_ehci_init();
> +
> +	kirkwood_ge00_init(&openrd_base_ge00_data);
> +	kirkwood_sdio_init(&openrd_base_mvsdio_data);
> +}
> +
> +MACHINE_START(OPENRD_BASE, "Marvell OpenRD Base Board")
> +	/* Maintainer: Dhaval Vasa <dhaval.vasa@einfochips.com> */
> +	.phys_io	= KIRKWOOD_REGS_PHYS_BASE,
> +	.io_pg_offst	= ((KIRKWOOD_REGS_VIRT_BASE) >> 18) & 0xfffc,
> +	.boot_params	= 0x00000100,
> +	.init_machine	= openrd_base_init,
> +	.map_io		= kirkwood_map_io,
> +	.init_irq	= kirkwood_init_irq,
> +	.timer		= &kirkwood_timer,
> +MACHINE_END
> -- 
> 1.6.0.6
> 
> -- 
> _____________________________________________________________________
> Disclaimer: This e-mail message and all attachments transmitted with it
> are intended solely for the use of the addressee and may contain legally
> privileged and confidential information. If the reader of this message
> is not the intended recipient, or an employee or agent responsible for
> delivering this message to the intended recipient, you are hereby
> notified that any dissemination, distribution, copying, or other use of
> this message or its attachments is strictly prohibited. If you have
> received this message in error, please notify the sender immediately by
> replying to this message and please delete it from your computer. Any
> views expressed in this message are those of the individual sender
> unless otherwise stated.Company has taken enough precautions to prevent
> the spread of viruses. However the company accepts no liability for any
> damage caused by any virus transmitted by this email.
> _____________________________________________________________________
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
