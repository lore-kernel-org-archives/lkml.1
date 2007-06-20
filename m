Return-Path: <linux-kernel-owner+w=401wt.eu-S1754437AbXFTQw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437AbXFTQw3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 12:52:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbXFTQwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 12:52:07 -0400
Received: from homer.mvista.com ([63.81.120.155]:53333 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752479AbXFTQwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 12:52:06 -0400
Message-ID: <46795B9B.2020401@ru.mvista.com>
Date: Wed, 20 Jun 2007 20:53:47 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Tony Breeds <tony@bakeyournoodle.com>
Cc: Daniel Walker <dwalker@mvista.com>, Andrew Morton <akpm@osdl.org>,
       john stultz <johnstul@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       LinuxPPC-dev <linuxppc-dev@ozlabs.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC] clocksouce implementation for powerpc
References: <20070616101126.296384219@inhelltoy.tec.linutronix.de>	<20070616101637.107940593@inhelltoy.tec.linutronix.de>	<1182009083.11539.369.camel@imap.mvista.com> <20070620065710.GR9768@bakeyournoodle.com>
In-Reply-To: <20070620065710.GR9768@bakeyournoodle.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Tony Breeds wrote:

>>>plain text document attachment
>>>(clocksource-add-settimeofday-hook.patch)
>>>From: Tony Breeds <tony@bakeyournoodle.com >

>>>I'm working on a clocksource implementation for all powerpc platforms.
>>>some of these platforms needs to do a little work as part of the
>>>settimeofday() syscall and I can't see a way to do that without adding
>>>this hook to clocksource.

>>I'd like to see how this is used? If the code that uses this API change
>>isn't ready yet, then this patch should really wait..

> This is my current patch to rework arch/powerpc/kernel/time.c to create
> a clocksource.  It's not ready for inclusion.

    I guess it's been based on the prior work by John Stultz (and me too :-)?

> powerpc needs to keep the vdso in sync whenener settimeodfay() is
> called.  Adding the hook the to the clocksource structure was my way of
> allowing this to happen.  There are other approaches, but this seemed to
> best allow for runtime.  Initially I considered using update_vsyscall()
> but this is called from do_timer(), and I don't need this code run then
> :(

> This has been booted on pSeries and iSeries (I'm using glibc 2.5, which
> uses the vdso gettimeoday())

[...]
> Index: working/arch/powerpc/kernel/time.c
> ===================================================================
> --- working.orig/arch/powerpc/kernel/time.c
> +++ working/arch/powerpc/kernel/time.c
> @@ -74,6 +74,30 @@
>  #endif
>  #include <asm/smp.h>
>  
> +/* powerpc clocksource/clockevent code */
> +
> +/* TODO:
> + *  o Code style
> + *    * Variable names ... be consistent.
> + *
> + * TODO: Clocksource
> + *  o Need a _USE_RTC() clocksource impelementation
> + *  o xtime:  Either time.c manages it, or clocksource does, not both

    If you mean the init. part, this has been already done by me -- I've 
implemented read_persistent_clock() and got rid of xtime setting. What's left 
is to implemet update_persistent_clock() and get rid of timer_check_rtc()...

> + */
> +
> +#include <linux/clocksource.h>
> +
> +static struct clocksource clocksource_timebase = {
> +	.name         = "timebase",
> +	.rating       = 200,

    Perhaps we even need to raise the rating to 300 or 400 -- according to 
what <linux/clocksource.h> says?

> +	.flags        = CLOCK_SOURCE_IS_CONTINUOUS,
> +	.mask         = CLOCKSOURCE_MASK(64),
> +	.shift        = 22,

    PPC64 has issues with the fixed shift value, see:

http://patchwork.ozlabs.org/linuxppc/patch?id=11125

> +	.mult         = 0,	/* To be filled in */
> +	.read         = NULL,   /* To be filled in */
> +	.settimeofday = NULL,   /* To be filled in */

    I don't quite understand why not just init them right away?  The values 
are fixed anyways.

> +};
> +
>  /* keep track of when we need to update the rtc */
>  time_t last_rtc_update;
>  #ifdef CONFIG_PPC_ISERIES
[...]
> @@ -666,8 +631,8 @@ void timer_interrupt(struct pt_regs * re
>  		if (per_cpu(last_jiffy, cpu) >= tb_next_jiffy) {
>  			tb_last_jiffy = tb_next_jiffy;
>  			do_timer(1);
> -			timer_recalc_offset(tb_last_jiffy);
> -			timer_check_rtc();
> +			/* timer_recalc_offset() && timer_check_rtc()
> +			 * are now called from update_vsyscall() */

    I.e. in the softirq context...

[...]

WBR, Sergei
