Return-Path: <linux-kernel-owner+w=401wt.eu-S935197AbYEUNLK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935197AbYEUNLK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 09:11:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757040AbYEUNK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 09:10:56 -0400
Received: from fnoeppeil48.netpark.at ([217.175.205.176]:56194 "EHLO
	roarinelk.homelinux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755888AbYEUNK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 09:10:56 -0400
Date: Wed, 21 May 2008 15:10:53 +0200
From: Manuel Lauss <mano@roarinelk.homelinux.net>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org, drzeus@drzeus.cx
Subject: Re: [PATCH 4/9] Alchemy: register mmc platform device for
	db1200/pb1200 boards
Message-ID: <20080521131053.GA8459@roarinelk.homelinux.net>
References: <20080519080339.GA21985@roarinelk.homelinux.net> <20080519080605.GE21985@roarinelk.homelinux.net> <4834166C.40901@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4834166C.40901@ru.mvista.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sergei,

> Manuel Lauss wrote:
>
>> Add au1xmmc platform data for PB1200/DB1200 boards, and wire up
>> the 2 SD controllers for them.
>
>> Signed-off-by: Manuel Lauss <mano@roarinelk.homelinux.net>
>
>    OK, this definitely looks better (and shorter :-).

Thanks ;-)


>> +static struct resource au1200_mmc0_resources[] = {
>> +	[0] = {
>> +		.start          = SD0_PHYS_ADDR,
>> +		.end            = SD0_PHYS_ADDR + 0x7ffff,
>> +		.flags          = IORESOURCE_MEM,
>> +	},
>> +	[1] = {
>> +		.start		= AU1200_SD_INT,
>> +		.flags		= IORESOURCE_IRQ,
>> +	},
>> +	[2] = {
>> +		.start		= DSCR_CMD0_SDMS_TX0,
>> +		.flags		= IORESOURCE_DMA,
>> +	},
>> +	[3] = {
>> +		.start          = DSCR_CMD0_SDMS_RX0,
>> +		.flags          = IORESOURCE_DMA,
>> +	}
>> +};
>> +
>> +static struct resource au1200_mmc1_resources[] = {
>> +	[0] = {
>> +		.start          = SD1_PHYS_ADDR,
>> +		.end            = SD1_PHYS_ADDR + 0x7ffff,
>> +		.flags          = IORESOURCE_MEM,
>> +	},
>> +	[1] = {
>> +		.start		= AU1200_SD_INT,
>> +		.flags		= IORESOURCE_IRQ,
>> +	},
>> +	[2] = {
>> +		.start		= DSCR_CMD0_SDMS_TX1,
>> +		.flags		= IORESOURCE_DMA,
>> +	},
>> +	[3] = {
>> +		.start          = DSCR_CMD0_SDMS_RX1,
>> +		.flags          = IORESOURCE_DMA,
>> +	}
>> +};
>> +
>
>    Shouldn't the IRQ/DMA resources also have their 'end' field set?

Not sure, but I'll add them too.


>> +static void pb1200mmc0_set_power(void *mmc_host, int state)
>> +{
>> +	if (state)
>> +		bcsr->board |= BCSR_BOARD_SD0PWR;
>> +	else
>> +		bcsr->board &= ~BCSR_BOARD_SD0PWR;
>> +
>> +	au_sync_delay(1);
>> +}
>> +
>> +static int pb1200mmc0_card_readonly(void *mmc_host)
>> +{
>> +	return (bcsr->status & BCSR_STATUS_SD0WP) ? 1 : 0;
>> +}
>> +
>> +static int pb1200mmc0_card_inserted(void *mmc_host)
>> +{
>> +	return (bcsr->sig_status & BCSR_INT_SD0INSERT) ? 1 : 0;
>> +}
>> +
>> +#ifndef CONFIG_MIPS_DB1200
>> +static void pb1200mmc1_set_power(void *mmc_host, int state)
>> +{
>> +	if (state)
>> +		bcsr->board |= BCSR_BOARD_SD1PWR;
>> +	else
>> +		bcsr->board &= ~BCSR_BOARD_SD1PWR;
>> +
>> +	au_sync_delay(1);
>> +}
>> +
>> +static int pb1200mmc1_card_readonly(void *mmc_host)
>> +{
>> +	return (bcsr->status & BCSR_STATUS_SD1WP) ? 1 : 0;
>> +}
>> +
>> +static int pb1200mmc1_card_inserted(void *mmc_host)
>> +{
>> +	return (bcsr->sig_status & BCSR_INT_SD1INSERT) ? 1 : 0;
>> +}
>> +#endif
>
>    These 2 separate versions could be converted into single one by using 
> the data arrays holding info BCSR bits -- something like the MMC driver has 
> currently.

Well, that's what my initial submission did, but it required access to the
mmc drivers host structure (moved from au1xmmc.h to au1100_mmc.h) to determine
which controller wants the attention, and you weren't fond of that.


>> +
>> +const struct au1xmmc_platform_data au1xmmc_platdata[2] = {
>> +	[0] = {
>> +		.set_power	= pb1200mmc0_set_power,
>> +		.card_inserted	= pb1200mmc0_card_inserted,
>> +		.card_readonly	= pb1200mmc0_card_readonly,
>> +		.cd_setup	= NULL,		/* use poll-timer in driver */
>> +	},
>> +#ifndef CONFIG_MIPS_DB1200
>> +	[1] = {
>> +		.set_power	= pb1200mmc1_set_power,
>> +		.card_inserted	= pb1200mmc1_card_inserted,
>> +		.card_readonly	= pb1200mmc1_card_readonly,
>> +		.cd_setup	= NULL,		/* use poll-timer in driver */
>> +	},
>> +#endif
>> +};
>
>    You don't have to explicitly set 'cd_setup' to NULL...

The comment explains what setting to NULL does, so I'd like to
keep it (for people implementing this for other boards and wondering what
to do with thse members...)


> PS: BTW, I've noticed that include/asm-mips/mach-db1x00/db1x00.h defines 
> macros mmc_card_insterted() and mmc_power_on() which no code seems to be 
> using (might have been intended for use by the MMC driver but why no such 
> macros in other board headers?). Care to remove those while you're working 
> on MMC?

Sure, I'll add another patch to the pile.


Thank you!
	Manuel Lauss
