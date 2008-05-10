Return-Path: <linux-kernel-owner+w=401wt.eu-S1755366AbYEJKBG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366AbYEJKBG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 06:01:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752517AbYEJKAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 06:00:54 -0400
Received: from gateway-1237.mvista.com ([63.81.120.155]:61198 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752337AbYEJKAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 06:00:53 -0400
Message-ID: <023101c8b284$b7f67a30$5205a8c0@acerfa265979ef>
From: "Sergei Shtylyov" <sshtylyov@ru.mvista.com>
To: "Manuel Lauss" <mano@roarinelk.homelinux.net>
Cc: <linux-mips@linux-mips.org>, <linux-kernel@vger.kernel.org>
References: <20080507160154.GA17806@roarinelk.homelinux.net> <20080507160634.GE17806@roarinelk.homelinux.net> <4822F4FC.5040107@ru.mvista.com> <20080508130833.GA25971@roarinelk.homelinux.net> <482354D0.9040304@ru.mvista.com> <20080509054010.GA32719@roarinelk.homelinux.net>
Subject: Re: [PATCH 4/7] Alchemy: db1200/pb1200: register mmc platformdevice and board specific functions
Date: Sat, 10 May 2008 14:00:45 +0400
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="ISO-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3138
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message ----- 
From: "Manuel Lauss" <mano@roarinelk.homelinux.net>
To: "Sergei Shtylyov" <sshtylyov@ru.mvista.com>
Cc: <linux-mips@linux-mips.org>; <linux-kernel@vger.kernel.org>
Sent: Friday, May 09, 2008 9:40 AM
Subject: Re: [PATCH 4/7] Alchemy: db1200/pb1200: register mmc platformdevice 
and board specific functions


> On Thu, May 08, 2008 at 11:30:24PM +0400, Sergei Shtylyov wrote:
>> Manuel Lauss wrote:

>>>>> diff --git a/arch/mips/au1000/common/platform.c
>>>>> b/arch/mips/au1000/common/platform.c
>>>>> index 31d2a22..08a5900 100644
>>>>> --- a/arch/mips/au1000/common/platform.c
>>>>> +++ b/arch/mips/au1000/common/platform.c
>>>>> -
>>>>> -static struct platform_device au1xxx_mmc_device = {
>>>>> - .name = "au1xxx-mmc",
>>>>> - .id = 0,
>>>>> - .dev = {
>>>>> - .dma_mask               = &au1xxx_mmc_dmamask,
>>>>> - .coherent_dma_mask      = 0xffffffff,
>>>>> - },
>>>>> - .num_resources  = ARRAY_SIZE(au1xxx_mmc_resources),
>>>>> - .resource       = au1xxx_mmc_resources,
>>>>> -};
>>>>> #endif /* #ifdef CONFIG_SOC_AU1200 */
>>>>
>>>>   What board-specific was here?

>>> Nothing in here per se, but a) I don't like this file, it registers
>>> stuff some boards don't need/want,  b) this part is only interesting
>>> for pb1200 board anyway.

>>    Sigh. Do you know that Au1100 also has the same MMC controllers? The
>> platform device is not registered in this case though and the driver
>> (however small it now actually uses the platform device per se) is
>> therefore unable to control it (well, I'm not sure it can do that since 
>> it
>> seems to be Au1200 centered now (using DBDMA), however it was initially
>> written for Au1100 as it seems.

> I gathered that from the driver source...

> I assume the PIO paths in the driver are intended for the Au1100, correct?
> Should not be too hard to force PIO paths when no DDMA IDs are passed
> through the platform device's resources.


   Yes but it should've probably also supported DMA via Au1100 DMA 
controller (not DBDMA).

>>>>> + return (bcsr->sig_status & au1xmmc_card_table[host->id].bcsrstatus)
>>>>> + ? 1 : 0;
>>>>> +}
>>>>> +
>>>>> +static struct au1xmmc_platdata db1xmmcpd = {
>>>>> + .set_power = pb1200mmc_set_power,
>>>>> + .card_inserted = pb1200mmc_card_inserted,
>>>>> + .card_readonly = pb1200mmc_card_readonly,
>>>>> + .cd_setup = NULL, /* use poll-timer in driver */

>>>>   Function ptrs in the platform data?  That's something new -- though 
>>>> why
>>>> not? :-)

>>> Is this an accepted way of doing things in the kernel?  If not, I'm open
>>> to suggestions!

>>    I really don't know -- never seen such trick before.

>>> (I prefer this to globally-visible methods called by the
>>> driver.  I like it when related things are neatly grouped together).

>>    Yes, this indeed looks better.

> Unless someone else speaks up against it, I'll leave it the way it is.

   I assume just parametrizing the board-level functions using the data 
about BCSR (like it was done in the driver before) just won't work?

>>>>> + },
>>>>> + .num_resources  = ARRAY_SIZE(au1200sd0_res),
>>>>> + .resource       = au1200sd0_res,
>>>>> +};
>>>>> +
>>>>> +#ifndef CONFIG_MIPS_DB1200

>>>>   Wait, SD controller 1 is there regardless of the board, so should be
>>>> registerred regardless. If however the board doesn't have the necessary
>>>> resources to support the driver functionality, I think it can be
>>>> indicated by the board-level platform data, so that the driver could
>>>> decide whether it wants to support that controller or not.

>>> Won't this cause problems if e.g. you are using PCMCIA (since SD1 pins 
>>> are
>>> muxed with pcmcia signals)?

>>    Good point.  I think that the code in 
>> arch/mips/au1000/common/platform.c
>> should check the sys_pinfunc register, and not blindly register all
>> devices.

> Hm, sounds ugly, but I'll add something.

   Why? I think it's smarter than register SoC devices in every instance of 
board setup code. This way, the board setup code has already programmed 
sys_pinfunc as it sees fit, and the common code accomodates to this need 
registering those devices that the coard code have selected.

> Thanks!
> Manuel Lauss

WBR, Sergei


