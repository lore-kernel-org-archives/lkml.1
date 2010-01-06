Return-Path: <linux-kernel-owner+w=401wt.eu-S1755454Ab0AFE5N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454Ab0AFE5N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 23:57:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755191Ab0AFE5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 23:57:11 -0500
Received: from mail-yx0-f188.google.com ([209.85.210.188]:49649 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755132Ab0AFE5K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 23:57:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Y9KkGN36aPz9wq39JNZBphGznf8AFB/HFVP0TqUnytAfpY7v0YcIdz/eN1E6fBuhbO
         tEPNlvT5SZY90/EuGcM7iAQpzBaLFACv5UKXEqHsfWHRTMAoKVk+7wMOcHfvtCR3NvsH
         r1Fc0GfDLTBy6iAAf/8DkjzEZ4h/dR1pCsAhU=
MIME-Version: 1.0
In-Reply-To: <20100106002158.GM4274@sortiz.org>
References: <20100105050914.32264.762.sendpatchset@rxone.opensource.se>
	 <20100106002158.GM4274@sortiz.org>
Date: Wed, 6 Jan 2010 13:57:09 +0900
Message-ID: <aec7e5c31001052057u68deaab2y1d63a2e881ef94a3@mail.gmail.com>
Subject: Re: [PATCH] MMC: hardware abstraction for CNF area
From: Magnus Damm <magnus.damm@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, ian@mnementh.co.uk, linux-sh@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

On Wed, Jan 6, 2010 at 9:21 AM, Samuel Ortiz <sameo@linux.intel.com> wrote:
> On Tue, Jan 05, 2010 at 02:09:14PM +0900, Magnus Damm wrote:
>> From: Ian Molton <ian@mnementh.co.uk>
>>
>> This patch abstracts out the CNF area code from tmio_mmc which
>> is not present in all hardware that can use this driver. This
>> is required so that we can support non-toshiba based hardware.
>>
>> ASIC3 support by Philipp Zabel
>>
>> [ Magnus Damm: extracted patch from git.mnementh.co.uk, tried
>>   to apply on top of current linux-2.6 but got rejects due to
>>   -mm patch 14f1b75b1d31673d7ab6ac6d2f8fe7f23c705229, solved
>>   conflict by hand, regenerated patch and posted to lkml ]
> Thanks for taking care of that.

No worries!

> I wish I could take this patch straight away, but I have some objections, see
> below:
>
>> +     .suspend       = asic3_mmc_disable,
>> +     .resume        = asic3_mmc_enable,
> Why are we moving from enable/disable to resume/suspend ?
> It makes sense from a naming point of view, but that should be in a separate
> patch.

I agree.

>> +static const struct resource t7l66xb_mmc_resources[];
> Could we simply move the t7l66xb_mmc_resources[] definition here instead ?

Yep, makes sense.

>> --- /dev/null
>> +++ work/drivers/mfd/tmio_core.c      2010-01-05 13:27:31.000000000 +0900
>> @@ -0,0 +1,62 @@
>> +/*
>> + * Toshiba TC6393XB SoC support
> Bogus comment.

Yes.

>> + * Copyright(c) 2009 Ian Molton <spyro@f2s.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +#include <linux/mfd/tmio.h>
>> +
>> +static int shift;
> That I dont like. Carry the shift as a function argument, because there is no
> reason to have a static variable here.

Yeah, this part of the code is pretty darn ugly. Will fix.

> In fact, we could even move this code to tmio_mmc.c and export the symbols
> from there. The tmio_mmc code know the bus shift, doesnt it ?

The purpose of this patch is to make tmio_mmc work with a single I/O
memory window. So this code was intentionally moved out of tmio_mmc. I
don't care so much though, my original patch kept support for two
windows in tmio_mmc but Ian preferred to make the tmio_mmc driver work
with a single window only. Perhaps Ian has something to say?

I'll just pass the shift as a function argument for now.

>> --- 0001/drivers/mmc/host/tmio_mmc.c
>> +++ work/drivers/mmc/host/tmio_mmc.c  2010-01-05 13:28:07.000000000 +0900
>> @@ -46,7 +46,9 @@ static void tmio_mmc_set_clock(struct tm
>>               clk |= 0x100;
>>       }
>>
>> -     sd_config_write8(host, CNF_SD_CLK_MODE, clk >> 22);
>> +     if (host->set_no_clk_div)
>> +             host->set_no_clk_div(host->pdev, (clk>>22) & 1);
>> +
> You either need a backup path or make the set_no_clk_div() implementation
> mandatory. IOW, we should at least call tmio_core_mmc_clk_div() if
> set_no_clk_div() is not defined. Or then if you assume that all tmio drivers
> must implement those hooks, then return if it's not there. I would prefer the
> former option though as that would allow me to split this patch into what I
> see as .33 material (tmio_mmc.[ch], tmio_core.c [that I would rather see moved
> to tmio_mmc.c], and tmio.h)

The hardware driven by the SuperH SDHI driver lacks support for the
second memory window, so ->set_no_clk_div() is set to NULL in that
case. And falling back on tmio_core_mmc_clk_div() will only work on
hardware with two memory windows, so that idea will break SuperH SDHI.
It may be a good idea with dummy nop functions to avoid the if case,
but none of these functions are called in any hot path so from my
point of view it's ok as is.

I agree that a lot of code in a single patch is far from optimal. Feel
free to break out the patch in any way you'd like. My original patches
were broken out, but for some reason this all-in-one approach was
chosen.

I don't have access to any hardware except SuperH SDHI boards, but I'm
pretty sure Ian and Phillip has tested this patch on whatever hardware
they have available. So it may make sense to keep the code as is to
avoid breakage.

>> @@ -475,8 +478,8 @@ static int tmio_mmc_suspend(struct platf
>>       ret = mmc_suspend_host(mmc, state);
>>
>>       /* Tell MFD core it can disable us now.*/
>> -     if (!ret && cell->disable)
>> -             cell->disable(dev);
>> +     if (!ret && cell->suspend)
>> +             cell->suspend(dev);
> That sort of change doesnt belong to that patch, unless I'm missing something.

I agree.

>> +     /* Callbacks for clock / power control */
>> +     void (*set_pwr)(struct platform_device *host, int state);
>> +     void (*set_no_clk_div)(struct platform_device *host, int state);
> The name is a bit misleading, imo. Wouldn't set_clk_div() be more appropriate?

Yep, will go with ->set_clk_div().

>> +#define CNF_CMD     0x04
>> +#define CNF_CTL_BASE   0x10
>> +#define CNF_INT_PIN  0x3d
>> +#define CNF_STOP_CLK_CTL 0x40
>> +#define CNF_GCLK_CTL 0x41
>> +#define CNF_SD_CLK_MODE 0x42
>> +#define CNF_PIN_STATUS 0x44
>> +#define CNF_PWR_CTL_1 0x48
>> +#define CNF_PWR_CTL_2 0x49
>> +#define CNF_PWR_CTL_3 0x4a
>> +#define CNF_CARD_DETECT_MODE 0x4c
>> +#define CNF_SD_SLOT 0x50
>> +#define CNF_EXT_GCLK_CTL_1 0xf0
>> +#define CNF_EXT_GCLK_CTL_2 0xf1
>> +#define CNF_EXT_GCLK_CTL_3 0xf9
>> +#define CNF_SD_LED_EN_1 0xfa
>> +#define CNF_SD_LED_EN_2 0xfe
>> +
>> +#define   SDCREN 0x2   /* Enable access to MMC CTL regs. (flag in COMMAND_REG)*/
>> +
>> +#define sd_config_write8(base, shift, reg, val) \
>> +     tmio_iowrite8((val), (base) + ((reg) << (shift)))
>> +#define sd_config_write16(base, shift, reg, val) \
>> +     tmio_iowrite16((val), (base) + ((reg) << (shift)))
>> +#define sd_config_write32(base, shift, reg, val) \
>> +     do { \
>> +     tmio_iowrite16((val), (base) + ((reg) << (shift))); \
>> +     tmio_iowrite16((val) >> 16, (base) + ((reg + 2) << (shift))); \
>> +     } while (0)
> By implementing the tmio_core API in tmio_mmc.c, you wouldnt need to redefine
> those.

Right, but we want to code to be broken out of tmio_mmc so putting it
back does not make sense.

Thanks a lot for your help. I'll submit a patch on top of this one
with fixes. Feel free to apply it on top or roll it in.

Cheers,

/ magnus
