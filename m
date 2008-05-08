Return-Path: <linux-kernel-owner+w=401wt.eu-S1757274AbYEHMmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274AbYEHMmT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 08:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753119AbYEHMmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 08:42:10 -0400
Received: from homer.mvista.com ([63.81.120.155]:27566 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752929AbYEHMmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 08:42:08 -0400
Message-ID: <4822F4FC.5040107@ru.mvista.com>
Date: Thu, 08 May 2008 16:41:32 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Manuel Lauss <mano@roarinelk.homelinux.net>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] Alchemy: db1200/pb1200: register mmc platform device
 and board specific functions
References: <20080507160154.GA17806@roarinelk.homelinux.net> <20080507160634.GE17806@roarinelk.homelinux.net>
In-Reply-To: <20080507160634.GE17806@roarinelk.homelinux.net>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Manuel Lauss wrote:

> Signed-off-by: Manuel Lauss <mano@roarinelk.homelinux.net>

> diff --git a/arch/mips/au1000/common/platform.c b/arch/mips/au1000/common/platform.c
> index 31d2a22..08a5900 100644
> --- a/arch/mips/au1000/common/platform.c
> +++ b/arch/mips/au1000/common/platform.c

    Hm, I don't see anything board-specific in
arch/mips/au1000/common/platform.c anymore -- after I removed IDE and SMC
91C111 from there (these were devices on the static bus).

> @@ -162,24 +162,6 @@ static struct resource au1xxx_usb_gdt_resources[] = {
>  	},
>  };
>  
> -static struct resource au1xxx_mmc_resources[] = {
> -	[0] = {
> -		.start          = SD0_PHYS_ADDR,
> -		.end            = SD0_PHYS_ADDR + 0x40,
> -		.flags          = IORESOURCE_MEM,
> -	},
> -	[1] = {
> -		.start		= SD1_PHYS_ADDR,
> -		.end 		= SD1_PHYS_ADDR + 0x40,

    Hm, I haven't noticed that these are off-by-one... :-/

> -		.flags		= IORESOURCE_MEM,
> -	},
> -	[2] = {
> -		.start          = AU1200_SD_INT,
> -		.end            = AU1200_SD_INT,
> -		.flags          = IORESOURCE_IRQ,
> -	}
> -};
> -
>  static u64 udc_dmamask = ~(u32)0;
>  
>  static struct platform_device au1xxx_usb_gdt_device = {
> @@ -245,19 +227,6 @@ static struct platform_device au1200_lcd_device = {
>  	.num_resources  = ARRAY_SIZE(au1200_lcd_resources),
>  	.resource       = au1200_lcd_resources,
>  };
> -
> -static u64 au1xxx_mmc_dmamask =  ~(u32)0;
> -
> -static struct platform_device au1xxx_mmc_device = {
> -	.name = "au1xxx-mmc",
> -	.id = 0,
> -	.dev = {
> -		.dma_mask               = &au1xxx_mmc_dmamask,
> -		.coherent_dma_mask      = 0xffffffff,
> -	},
> -	.num_resources  = ARRAY_SIZE(au1xxx_mmc_resources),
> -	.resource       = au1xxx_mmc_resources,
> -};
>  #endif /* #ifdef CONFIG_SOC_AU1200 */

    What board-specific was here?

>  static struct platform_device au1x00_pcmcia_device = {
> diff --git a/arch/mips/au1000/pb1200/platform.c b/arch/mips/au1000/pb1200/platform.c
> index 5930110..bee2bf7 100644
> --- a/arch/mips/au1000/pb1200/platform.c
> +++ b/arch/mips/au1000/pb1200/platform.c
> @@ -20,8 +20,17 @@
>  
>  #include <linux/init.h>
>  #include <linux/platform_device.h>
> +#include <linux/mmc/host.h>
>  
>  #include <asm/mach-au1x00/au1xxx.h>
> +#include <asm/mach-au1x00/au1xxx_dbdma.h>
> +#include <asm/mach-au1x00/au1100_mmc.h>
> +
> +#if defined(CONFIG_MIPS_PB1200)
> +#include <asm/mach-pb1x00/pb1200.h>
> +#elif defined(CONFIG_MIPS_DB1200)
> +#include <asm/mach-db1x00/db1200.h>
> +#endif

#include <asm/mach-au1x00/au1xxx.h> does all that already -- you don't need to
include the board specific headers one more time.  Drop this part please.

>  static struct resource ide_resources[] = {
>  	[0] = {
> @@ -70,9 +79,125 @@ static struct platform_device smc91c111_device = {
>  	.resource	= smc91c111_resources
>  };
>  
> +
> +static const struct {
> +	u16 bcsrpwr;
> +	u16 bcsrstatus;
> +	u16 wpstatus;
> +} au1xmmc_card_table[] = {
> +	{ BCSR_BOARD_SD0PWR, BCSR_INT_SD0INSERT, BCSR_STATUS_SD0WP },
> +#ifndef CONFIG_MIPS_DB1200
> +	{ BCSR_BOARD_SD1PWR, BCSR_INT_SD1INSERT, BCSR_STATUS_SD1WP }
> +#endif
> +};
> +
> +static void pb1200mmc_set_power(void *mmc_host, int state)
> +{
> +	struct au1xmmc_host *host = mmc_priv((struct mmc_host *)mmc_host);
> +	u32 val = au1xmmc_card_table[host->id].bcsrpwr;
> +
> +	bcsr->board &= ~val;
> +	if (state)
> +		bcsr->board |= val;
> +
> +	au_sync_delay(1);
> +}
> +
> +static int pb1200mmc_card_readonly(void *mmc_host)
> +{
> +	struct au1xmmc_host *host = mmc_priv((struct mmc_host *)mmc_host);

    Insert new line after a declaration please.

> +	return (bcsr->status & au1xmmc_card_table[host->id].wpstatus) ? 1 : 0;
> +}
> +
> +static int pb1200mmc_card_inserted(void *mmc_host)
> +{
> +	struct au1xmmc_host *host = mmc_priv((struct mmc_host *)mmc_host);

    The same here.

> +	return (bcsr->sig_status & au1xmmc_card_table[host->id].bcsrstatus)
> +		? 1 : 0;
> +}
> +
> +static struct au1xmmc_platdata db1xmmcpd = {
> +	.set_power	= pb1200mmc_set_power,
> +	.card_inserted	= pb1200mmc_card_inserted,
> +	.card_readonly	= pb1200mmc_card_readonly,
> +	.cd_setup	= NULL,		/* use poll-timer in driver */

    Function ptrs in the platform data?  That's something new -- though why 
not? :-)

> +};
> +
> +static u64 au1xxx_mmc_dmamask =  ~(u32)0;
> +
> +struct resource au1200sd0_res[] = {
> +	[0] = {
> +		.start	= CPHYSADDR(SD0_BASE),

    Why not just use SD0_PHYS_ADDR?

> +		.end	= CPHYSADDR(SD0_BASE) + 0x40,

    You've missed "- 1" here. Though it's alos not clear why 0x40 and not 0x3c 
(there's not register at 0x3c) or 0x80000 -- the range used according to the 
memory map...

> +		.flags	= IORESOURCE_MEM,
> +	},
> +	[2] = {
> +		.start	= AU1200_SD_INT,
> +		.flags	= IORESOURCE_IRQ,
> +	},
> +	[3] = {
> +		.start	= DSCR_CMD0_SDMS_TX0,
> +		.flags	= IORESOURCE_DMA,
> +	},
> +	[4] = {
> +		.start	= DSCR_CMD0_SDMS_RX0,
> +		.flags	= IORESOURCE_DMA,
> +	},
> +};

    Humm. The other devices (like IDE) should also claim DMA resources...

> +
> +static struct platform_device au1200_sd0_device = {
> +	.name = "au1xxx-mmc",
> +	.id = 0,	/* index into au1xmmc_card_table[] */
> +	.dev = {
> +		.dma_mask               = &au1xxx_mmc_dmamask,
> +		.coherent_dma_mask      = 0xffffffff,
> +		.platform_data		= &db1xmmcpd,

    Can't we leave the MMC platform device where it is but define the platform 
data structure per board with some starndard name? Since IMO it doesn't make 
sense to move the platform device itself.

> +	},
> +	.num_resources  = ARRAY_SIZE(au1200sd0_res),
> +	.resource       = au1200sd0_res,
> +};
> +
> +#ifndef CONFIG_MIPS_DB1200

    Wait, SD controller 1 is there regardless of the board, so should be 
registerred regardless. If however the board doesn't have the necessary 
resources to support the driver functionality, I think it can be indicated by 
the board-level platform data, so that the driver could decide whether it 
wants to support that controller or not.

> +struct resource au1200sd1_res[] = {
> +	[0] = {
> +		.start	= CPHYSADDR(SD1_BASE),
> +		.end	= CPHYSADDR(SD1_BASE) + 0xff,

    Why not 0x40 if the controllers are symmetric I wonder? I'd say it should 
be 0x80000 even (and don't forget to sutract one ;-)...

WBR, Sergei

