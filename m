Return-Path: <linux-kernel-owner+w=401wt.eu-S934377AbYEUMdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934377AbYEUMdT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 08:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763453AbYEUMdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 08:33:09 -0400
Received: from h155.mvista.com ([63.81.120.155]:8658 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762174AbYEUMdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 08:33:08 -0400
Message-ID: <4834166C.40901@ru.mvista.com>
Date: Wed, 21 May 2008 16:32:44 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Manuel Lauss <mano@roarinelk.homelinux.net>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org, drzeus@drzeus.cx
Subject: Re: [PATCH 4/9] Alchemy: register mmc platform device for db1200/pb1200
 boards
References: <20080519080339.GA21985@roarinelk.homelinux.net> <20080519080605.GE21985@roarinelk.homelinux.net>
In-Reply-To: <20080519080605.GE21985@roarinelk.homelinux.net>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Manuel Lauss wrote:

> Add au1xmmc platform data for PB1200/DB1200 boards, and wire up
> the 2 SD controllers for them.

> Signed-off-by: Manuel Lauss <mano@roarinelk.homelinux.net>

    OK, this definitely looks better (and shorter :-).

> diff --git a/arch/mips/au1000/common/platform.c b/arch/mips/au1000/common/platform.c
> index 8cae775..6225e95 100644
> --- a/arch/mips/au1000/common/platform.c
> +++ b/arch/mips/au1000/common/platform.c

[...]

> @@ -248,15 +232,70 @@ static struct platform_device au1200_lcd_device = {
>  
>  static u64 au1xxx_mmc_dmamask =  ~(u32)0;
>  
> -static struct platform_device au1xxx_mmc_device = {
> +extern struct au1xmmc_platform_data au1xmmc_platdata[2];
> +
> +static struct resource au1200_mmc0_resources[] = {
> +	[0] = {
> +		.start          = SD0_PHYS_ADDR,
> +		.end            = SD0_PHYS_ADDR + 0x7ffff,
> +		.flags          = IORESOURCE_MEM,
> +	},
> +	[1] = {
> +		.start		= AU1200_SD_INT,
> +		.flags		= IORESOURCE_IRQ,
> +	},
> +	[2] = {
> +		.start		= DSCR_CMD0_SDMS_TX0,
> +		.flags		= IORESOURCE_DMA,
> +	},
> +	[3] = {
> +		.start          = DSCR_CMD0_SDMS_RX0,
> +		.flags          = IORESOURCE_DMA,
> +	}
> +};
> +
> +static struct resource au1200_mmc1_resources[] = {
> +	[0] = {
> +		.start          = SD1_PHYS_ADDR,
> +		.end            = SD1_PHYS_ADDR + 0x7ffff,
> +		.flags          = IORESOURCE_MEM,
> +	},
> +	[1] = {
> +		.start		= AU1200_SD_INT,
> +		.flags		= IORESOURCE_IRQ,
> +	},
> +	[2] = {
> +		.start		= DSCR_CMD0_SDMS_TX1,
> +		.flags		= IORESOURCE_DMA,
> +	},
> +	[3] = {
> +		.start          = DSCR_CMD0_SDMS_RX1,
> +		.flags          = IORESOURCE_DMA,
> +	}
> +};
> +

    Shouldn't the IRQ/DMA resources also have their 'end' field set?

[...]

> diff --git a/arch/mips/au1000/pb1200/platform.c b/arch/mips/au1000/pb1200/platform.c
> index 5930110..f329a38 100644
> --- a/arch/mips/au1000/pb1200/platform.c
> +++ b/arch/mips/au1000/pb1200/platform.c
> @@ -22,6 +22,66 @@
>  #include <linux/platform_device.h>
>  
>  #include <asm/mach-au1x00/au1xxx.h>
> +#include <asm/mach-au1x00/au1100_mmc.h>
> +
> +static void pb1200mmc0_set_power(void *mmc_host, int state)
> +{
> +	if (state)
> +		bcsr->board |= BCSR_BOARD_SD0PWR;
> +	else
> +		bcsr->board &= ~BCSR_BOARD_SD0PWR;
> +
> +	au_sync_delay(1);
> +}
> +
> +static int pb1200mmc0_card_readonly(void *mmc_host)
> +{
> +	return (bcsr->status & BCSR_STATUS_SD0WP) ? 1 : 0;
> +}
> +
> +static int pb1200mmc0_card_inserted(void *mmc_host)
> +{
> +	return (bcsr->sig_status & BCSR_INT_SD0INSERT) ? 1 : 0;
> +}
> +
> +#ifndef CONFIG_MIPS_DB1200
> +static void pb1200mmc1_set_power(void *mmc_host, int state)
> +{
> +	if (state)
> +		bcsr->board |= BCSR_BOARD_SD1PWR;
> +	else
> +		bcsr->board &= ~BCSR_BOARD_SD1PWR;
> +
> +	au_sync_delay(1);
> +}
> +
> +static int pb1200mmc1_card_readonly(void *mmc_host)
> +{
> +	return (bcsr->status & BCSR_STATUS_SD1WP) ? 1 : 0;
> +}
> +
> +static int pb1200mmc1_card_inserted(void *mmc_host)
> +{
> +	return (bcsr->sig_status & BCSR_INT_SD1INSERT) ? 1 : 0;
> +}
> +#endif

    These 2 separate versions could be converted into single one by using the 
data arrays holding info BCSR bits -- something like the MMC driver has currently.

> +
> +const struct au1xmmc_platform_data au1xmmc_platdata[2] = {
> +	[0] = {
> +		.set_power	= pb1200mmc0_set_power,
> +		.card_inserted	= pb1200mmc0_card_inserted,
> +		.card_readonly	= pb1200mmc0_card_readonly,
> +		.cd_setup	= NULL,		/* use poll-timer in driver */
> +	},
> +#ifndef CONFIG_MIPS_DB1200
> +	[1] = {
> +		.set_power	= pb1200mmc1_set_power,
> +		.card_inserted	= pb1200mmc1_card_inserted,
> +		.card_readonly	= pb1200mmc1_card_readonly,
> +		.cd_setup	= NULL,		/* use poll-timer in driver */
> +	},
> +#endif
> +};

    You don't have to explicitly set 'cd_setup' to NULL...

PS: BTW, I've noticed that include/asm-mips/mach-db1x00/db1x00.h defines 
macros mmc_card_insterted() and mmc_power_on() which no code seems to be using 
(might have been intended for use by the MMC driver but why no such macros in 
other board headers?). Care to remove those while you're working on MMC?

WBR, Sergei
