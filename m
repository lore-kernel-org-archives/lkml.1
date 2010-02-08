Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620Ab0BHTrg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 14:47:36 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:35456 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753593Ab0BHTrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 14:47:35 -0500
Date: Mon, 8 Feb 2010 20:47:34 +0100
From: Andreas Mohr <andi@lisas.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andreas Mohr <andi@lisas.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, John Stultz <johnstul@us.ibm.com>
Subject: Re: clocksource mutex deadlock, cat current_clocksource
	(2.6.33-rc6/7)
Message-ID: <20100208194734.GA20316@rhlx01.hs-esslingen.de>
References: <20100206142141.GA12871@rhlx01.hs-esslingen.de> <alpine.LFD.2.00.1002061534020.2811@localhost.localdomain> <20100207191949.GA23665@rhlx01.hs-esslingen.de> <20100208053830.GA7128@rhlx01.hs-esslingen.de> <alpine.LFD.2.00.1002081010330.2811@localhost.localdomain> <20100208093719.GA15428@rhlx01.hs-esslingen.de> <alpine.LFD.2.00.1002081038430.2811@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1002081038430.2811@localhost.localdomain>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Feb 08, 2010 at 11:06:58AM +0100, Thomas Gleixner wrote:
> EIP: 0060:[<c1045170>] EFLAGS: 00000082 CPU: 0
> EIP is at timekeeping_forward_now+0x116/0x139
> 
> I don't see what might make the machine stuck here. Can you decode the
> source line with "addr2line -e vmlinux c1045170" please ?

And the winner is:
/usr/src/linux-2.6.33-rc7/include/linux/math64.h:91

static __always_inline u32
__iter_div_u64_rem(u64 dividend, u32 divisor, u64 *remainder)
{
        u32 ret = 0;

        while (dividend >= divisor) {
                /* The following asm() prevents the compiler from
                   optimising this loop into a modulo operation.  */
                asm("" : "+rm"(dividend));

                dividend -= divisor;
                ret++;
        }

        *remainder = dividend;

        return ret;
}


while ......



Do I see a divisor == 0 here?? ;)

Andreas Mohr
