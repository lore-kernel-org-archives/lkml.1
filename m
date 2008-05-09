Return-Path: <linux-kernel-owner+w=401wt.eu-S933505AbYEIFkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933505AbYEIFkb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 01:40:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752683AbYEIFkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 01:40:16 -0400
Received: from fnoeppeil48.netpark.at ([217.175.205.176]:34346 "EHLO
	roarinelk.homelinux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbYEIFkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 01:40:13 -0400
Date: Fri, 9 May 2008 07:40:10 +0200
From: Manuel Lauss <mano@roarinelk.homelinux.net>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] Alchemy: db1200/pb1200: register mmc platform
	device and board specific functions
Message-ID: <20080509054010.GA32719@roarinelk.homelinux.net>
References: <20080507160154.GA17806@roarinelk.homelinux.net> <20080507160634.GE17806@roarinelk.homelinux.net> <4822F4FC.5040107@ru.mvista.com> <20080508130833.GA25971@roarinelk.homelinux.net> <482354D0.9040304@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <482354D0.9040304@ru.mvista.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2008 at 11:30:24PM +0400, Sergei Shtylyov wrote:
> Manuel Lauss wrote:
>
>>>> diff --git a/arch/mips/au1000/common/platform.c 
>>>> b/arch/mips/au1000/common/platform.c
>>>> index 31d2a22..08a5900 100644
>>>> --- a/arch/mips/au1000/common/platform.c
>>>> +++ b/arch/mips/au1000/common/platform.c
>>>> -
>>>> -static struct platform_device au1xxx_mmc_device = {
>>>> -	.name = "au1xxx-mmc",
>>>> -	.id = 0,
>>>> -	.dev = {
>>>> -		.dma_mask               = &au1xxx_mmc_dmamask,
>>>> -		.coherent_dma_mask      = 0xffffffff,
>>>> -	},
>>>> -	.num_resources  = ARRAY_SIZE(au1xxx_mmc_resources),
>>>> -	.resource       = au1xxx_mmc_resources,
>>>> -};
>>>> #endif /* #ifdef CONFIG_SOC_AU1200 */
>>>
>>>   What board-specific was here?
>
>> Nothing in here per se, but a) I don't like this file, it registers
>> stuff some boards don't need/want,  b) this part is only interesting
>> for pb1200 board anyway.
>
>    Sigh. Do you know that Au1100 also has the same MMC controllers? The 
> platform device is not registered in this case though and the driver 
> (however small it now actually uses the platform device per se) is 
> therefore unable to control it (well, I'm not sure it can do that since it 
> seems to be Au1200 centered now (using DBDMA), however it was initially 
> written for Au1100 as it seems.

I gathered that from the driver source...

I assume the PIO paths in the driver are intended for the Au1100, correct?
Should not be too hard to force PIO paths when no DDMA IDs are passed
through the platform device's resources.
Someone should test it on Au1100 though.


>> I moved it to the pb1200 platform.c because
>> of the function pointers for au1xmmc platdata.
>
>    I'm sure that can be handled without moving the device itself...

Okay...


>>>> +	return (bcsr->sig_status & au1xmmc_card_table[host->id].bcsrstatus)
>>>> +		? 1 : 0;
>>>> +}
>>>> +
>>>> +static struct au1xmmc_platdata db1xmmcpd = {
>>>> +	.set_power	= pb1200mmc_set_power,
>>>> +	.card_inserted	= pb1200mmc_card_inserted,
>>>> +	.card_readonly	= pb1200mmc_card_readonly,
>>>> +	.cd_setup	= NULL,		/* use poll-timer in driver */
>
>>>   Function ptrs in the platform data?  That's something new -- though why 
>>> not? :-)
>
>> Is this an accepted way of doing things in the kernel?  If not, I'm open 
>> to
>> suggestions!
>
>    I really don't know -- never seen such trick before.
>
>> (I prefer this to globally-visible methods called by the
>> driver.  I like it when related things are neatly grouped together).
>
>    Yes, this indeed looks better.
>

Unless someone else speaks up against it, I'll leave it the way it is.


>>>> +static struct platform_device au1200_sd0_device = {
>>>> +	.name = "au1xxx-mmc",
>>>> +	.id = 0,	/* index into au1xmmc_card_table[] */
>>>> +	.dev = {
>>>> +		.dma_mask               = &au1xxx_mmc_dmamask,
>>>> +		.coherent_dma_mask      = 0xffffffff,
>>>> +		.platform_data		= &db1xmmcpd,
>
>>>   Can't we leave the MMC platform device where it is but define the 
>>> platform data structure per board with some starndard name? Since IMO it 
>>> doesn't make sense to move the platform device itself.
>
>> I like my device setup data in one file (preferably living in the board
>> subdir), but for mainline inclusion I can move it back to its original
>> place if you and others prefer so.
>
>    I'd definitely prefer to leave the SOC device where they were...

Okay.


>>>> +	},
>>>> +	.num_resources  = ARRAY_SIZE(au1200sd0_res),
>>>> +	.resource       = au1200sd0_res,
>>>> +};
>>>> +
>>>> +#ifndef CONFIG_MIPS_DB1200
>
>>>   Wait, SD controller 1 is there regardless of the board, so should be 
>>> registerred regardless. If however the board doesn't have the necessary 
>>> resources to support the driver functionality, I think it can be 
>>> indicated by the board-level platform data, so that the driver could 
>>> decide whether it wants to support that controller or not.
>
>> Won't this cause problems if e.g. you are using PCMCIA (since SD1 pins are
>> muxed with pcmcia signals)? 
>
>    Good point.  I think that the code in arch/mips/au1000/common/platform.c 
> should check the sys_pinfunc register, and not blindly register all 
> devices.

Hm, sounds ugly, but I'll add something.

Thanks!
	Manuel Lauss
