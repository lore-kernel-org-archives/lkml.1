Return-Path: <linux-kernel-owner+w=401wt.eu-S1760449AbZBDWMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760449AbZBDWMV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 17:12:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753261AbZBDWMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 17:12:09 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49972 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752457AbZBDWMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 17:12:08 -0500
Date: Wed, 4 Feb 2009 14:11:55 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [git pull] timer fix
In-Reply-To: <20090204192551.GA19539@elte.hu>
Message-ID: <alpine.LFD.2.00.0902041400100.3247@localhost.localdomain>
References: <20090204192551.GA19539@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 4 Feb 2009, Ingo Molnar wrote:
>
> Pavel Emelyanov (1):
>       x86: fix hpet timer reinit for x86_64
> 
> 
>  arch/x86/kernel/hpet.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
> index 64d5ad0..ec319d1 100644
> --- a/arch/x86/kernel/hpet.c
> +++ b/arch/x86/kernel/hpet.c
> @@ -1075,7 +1075,7 @@ static void hpet_rtc_timer_reinit(void)
>  		hpet_t1_cmp += delta;
>  		hpet_writel(hpet_t1_cmp, HPET_T1_CMP);
>  		lost_ints++;
> -	} while ((long)(hpet_readl(HPET_COUNTER) - hpet_t1_cmp) > 0);
> +	} while ((long)(hpet_readl(HPET_COUNTER) - (u32)hpet_t1_cmp) > 0);

This is bordering on not being correct.

It may happen to _work_, but the fact is, you want a 32-bit signed 
compare, not a 64-bit subtract that just happens to work. So the proper 
fix is to just make it do

	} while ((s32)(hpet_readl(HPET_COUNTER) - hpet_t1_cmp) > 0);

Otherwise you always end up depending on very subtle internal logic, and 
the exact types of the things involved.

In particular, think about when HPET_COUNTER or hpet_t1_cmp overflows in 
32 bits, and what you want to happen. If you do the subtract add test in 
64 bits, it will simply do the wrong thing. Think what happens if 
hpet_t1_cmp is actually _larger_ than HPET_COUNTER, but overflowed in 32 
bits, and you're now looking at:

	(long) (0xffffffff - 0x00000001)

which is actually > 0, so the thing will continue to loop INCORRECTLY. It 
should have stopped (and _would_ have stopped on 32-bit x86).

In contrast, look at what happens if you do the subtracting (or at least 
test the _result_ of the subtract) in the right size:

	(s32) (0xffffffff - 0x00000001) 

which becomes -2, which is not larger than 0, which means that we exit 
(which is correct, because the comparator value is actually ahead of the 
current count: 0x00000001 is _ahead_ of 0xffffffff, even if it's smaller 
in an "unsigned long".

So I'm not going to pull it. This cast is simply wrong.

Either cast the result of the subtract to "s32" (or "int", whatever), or 
cast _both_ of them to (s32) so that the subtract is done in a signed 
type, and then the expansion to (long) will still be right - but 
unnecessary - in the sign.

			Linus
