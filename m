Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746Ab0BHU3O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 15:29:14 -0500
Received: from www.tglx.de ([62.245.132.106]:34952 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755090Ab0BHU3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 15:29:12 -0500
Date: Mon, 8 Feb 2010 21:28:39 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andreas Mohr <andi@lisas.de>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       John Stultz <johnstul@us.ibm.com>
Subject: Re: clocksource mutex deadlock, cat current_clocksource
 (2.6.33-rc6/7)
In-Reply-To: <20100208194734.GA20316@rhlx01.hs-esslingen.de>
Message-ID: <alpine.LFD.2.00.1002082117210.2811@localhost.localdomain>
References: <20100206142141.GA12871@rhlx01.hs-esslingen.de> <alpine.LFD.2.00.1002061534020.2811@localhost.localdomain> <20100207191949.GA23665@rhlx01.hs-esslingen.de> <20100208053830.GA7128@rhlx01.hs-esslingen.de> <alpine.LFD.2.00.1002081010330.2811@localhost.localdomain>
 <20100208093719.GA15428@rhlx01.hs-esslingen.de> <alpine.LFD.2.00.1002081038430.2811@localhost.localdomain> <20100208194734.GA20316@rhlx01.hs-esslingen.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Feb 2010, Andreas Mohr wrote:
> Hi,
> 
> On Mon, Feb 08, 2010 at 11:06:58AM +0100, Thomas Gleixner wrote:
> > EIP: 0060:[<c1045170>] EFLAGS: 00000082 CPU: 0
> > EIP is at timekeeping_forward_now+0x116/0x139
> > 
> > I don't see what might make the machine stuck here. Can you decode the
> > source line with "addr2line -e vmlinux c1045170" please ?
> 
> And the winner is:
> /usr/src/linux-2.6.33-rc7/include/linux/math64.h:91
> 
> static __always_inline u32
> __iter_div_u64_rem(u64 dividend, u32 divisor, u64 *remainder)
> {
>         u32 ret = 0;
> 
>         while (dividend >= divisor) {
>                 /* The following asm() prevents the compiler from
>                    optimising this loop into a modulo operation.  */
>                 asm("" : "+rm"(dividend));
> 
>                 dividend -= divisor;
>                 ret++;
>         }
> 
>         *remainder = dividend;
> 
>         return ret;
> }
> 
> 
> while ......
> 
> Do I see a divisor == 0 here?? ;)

The only function which is calling __iter_div_u64_rem() from
timekeeping_forward_now() is timespec_add_ns() which calls it with a
constant divisor:

static __always_inline void timespec_add_ns(struct timespec *a, u64 ns)
{
        a->tv_sec += __iter_div_u64_rem(a->tv_nsec + ns, NSEC_PER_SEC, &ns);
        a->tv_nsec = ns;
}

There goes the theory :)

Which compiler version are you using ?

Can you please provide the disassembly of kernel/time/timekeeping.o ?

Thanks,

	tglx
