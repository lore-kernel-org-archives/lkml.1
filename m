Return-Path: <linux-kernel-owner+w=401wt.eu-S1761521AbZLKWkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761521AbZLKWkh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 17:40:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761406AbZLKWkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 17:40:36 -0500
Received: from mail-px0-f174.google.com ([209.85.216.174]:47184 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761337AbZLKWkf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 17:40:35 -0500
MIME-Version: 1.0
In-Reply-To: <20091211221015.GB24456@elf.ucw.cz>
References: <20091208102842.GH12264@elf.ucw.cz>
	 <4B1EB57D.6070408@bluewatersys.com> <20091208214658.GC4164@elf.ucw.cz>
	 <4B1ECEEE.3000209@bluewatersys.com>
	 <4B203575.6050407@bluewatersys.com>
	 <20091210172458.GJ19454@elf.ucw.cz>
	 <4B2150B7.3040207@bluewatersys.com>
	 <BD79186B4FD85F4B8E60E381CAEE190901FB0F92@mi8nycmail19.Mi8.com>
	 <20091211221015.GB24456@elf.ucw.cz>
Date: Fri, 11 Dec 2009 14:40:41 -0800
Message-ID: <d6200be20912111440k427c5013j2b17191bcbae2d52@mail.gmail.com>
Subject: Re: GPIO support for HTC Dream
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: H Hartley Sweeten <hartleys@visionengravers.com>,
       Ryan Mallon <ryan@bluewatersys.com>,
       Daniel Walker <dwalker@codeaurora.org>,
       Iliyan Malchev <malchev@google.com>,
       Brian Swetland <swetland@google.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 2:10 PM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
> Ok, thanks to Ryan and everyone... You were right, the code was way
> too complex.
>
> Cleaning it up according to Hartley's great howto resulted in:
>
>  arch/arm/Kconfig                     |    1
>  arch/arm/mach-msm/board-dream-gpio.c |  327 +++++++++--------------------------
>  arch/arm/mach-msm/board-dream.c      |   24 --
>  arch/arm/mach-msm/generic_gpio.c     |  270 ----------------------------
>  arch/arm/mach-msm/gpio_chip.h        |   30 ---
>  kernel/printk.c                      |    6
>  6 files changed, 102 insertions(+), 556 deletions(-)
>
>> As Ryan says, using gpiolib will clean this up immensely.
>>
>> It appears the what you really have for gpio's is 7 8-bit ports that start
>> with gpio number 128.  Each port appears to only have one control register.
>> This register is written with a '1' to drive the gpio as a high output and
>> '0' to drive it as a low output or to use it as an input.  Not really
>> sure if this is correct since the code is a bit screwy.
>
> It seems it is, because it seems to work.
>
>> Your current code is written so that all of the gpio's are in one "chip".
>> Because of this you are having to calculate the 'reg' needed to access the
>> gpio whenever you need to read or write to a gpio.
>>
>> If you follow the ep93xx implementation you can break the whole thing down
>> into 'banks' and simplify everything.  Something like:
>
> ...and get 100 lines of results, instead of 600... Yep, thanks.
>
> Now, it will still need some cleanups -- I'm not sure if gpios are
> dream-specific or generic for whole msm.... I kind of assume they
> should be generic for msm. Google people, can you help?

I'm not exactly sure what you are asking. Gpios in general are not
dream specific, the code in board-dream-gpio.c is. Some gpios (e.g.
DREAM_4_BALL_UP_0) are used for a dream specific function, but point
to a gpio that is generic to the msm architecture.

>
>> static struct dream_gpio_chip dream_gpio_banks[] = {
>>       DREAM_GPIO_BANK("MISC2", 0x00, DREAM_GPIO_MISC2_BASE),
>>       DREAM_GPIO_BANK("MISC3", 0x02, DREAM_GPIO_MISC3_BASE),
>>       DREAM_GPIO_BANK("MISC4", 0x04, DREAM_GPIO_MISC4_BASE),
>>       DREAM_GPIO_BANK("MISC5", 0x06, DREAM_GPIO_MISC5_BASE),
>>       DREAM_GPIO_BANK("INT2", 0x08, DREAM_GPIO_INT2_BASE),
>>       DREAM_GPIO_BANK("MISC1", 0x0a, DREAM_GPIO_MISC1_BASE),
>>       DREAM_GPIO_BANK("VIRTUAL", 0x12, DREAM_GPIO_VIRTUAL_BASE),
>> };
>
> Yep, that did the trick.
>
>> With this you can now just access the dream_gpio_chip data in all
>> the member function using the to_dream_gpio_chip() macro.
>>
>> I agree with Ryan and think you would be better off in the long
>> run to re-code this and use gpiolib.  You might also want to break
>> out all the gpio interrupt stuff and submit it as a seperate patch.
>
> Will do. Here's how the patch looks now.
>
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 1c4119c..8bb8546 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -565,6 +565,8 @@ config ARCH_MSM
>        select CPU_V6
>        select GENERIC_TIME
>        select GENERIC_CLOCKEVENTS
> +       select GENERIC_GPIO
> +       select ARCH_REQUIRE_GPIOLIB

Please do not do this in a board specific change. You have not changed
the msm generic gpio support to use gpiolib.

-- 
Arve Hjønnevåg
