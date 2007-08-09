Return-Path: <linux-kernel-owner+w=401wt.eu-S1764553AbXHIUCB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764553AbXHIUCB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 16:02:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757735AbXHIUBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 16:01:49 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:38439 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757912AbXHIUBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 16:01:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jdx8EIB4cwZOyKgYkuCSN4q0tSUnAS6b7s9epOXn2S+u5YBmDZVbeOodCg6FyBxDWLC15iRzCB1uVlgz4/Qhrz7FFXRr00/ME5Y3D8c3WdYRby0L1Fhg0SkMUS0QjRshgyuTmW1YfcyB8zBWqQ5GAzvtrXHmCl2hQAW174kyWiQ=
Message-ID: <1158166a0708091301q1eca67ct2ef3fa81e3878510@mail.gmail.com>
Date: Thu, 9 Aug 2007 21:01:45 +0100
From: "Denis Vlasenko" <vda.linux@googlemail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: [PATCH] msleep() with hrtimers
Cc: "Roman Zippel" <zippel@linux-m68k.org>, "Jonathan Corbet" <corbet@lwn.net>,
       linux-kernel@vger.kernel.org, "Thomas Gleixner" <tglx@linutronix.de>,
       akpm@linux-foundation.org, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <1158166a0708091231r21903840mc927b6baa47e4598@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <15327.1186166232@lwn.net>
	 <Pine.LNX.4.64.0708060150270.1817@scrub.home>
	 <1186360983.2697.8.camel@laptopd505.fenrus.org>
	 <Pine.LNX.4.64.0708060257010.1817@scrub.home>
	 <1186378798.2697.10.camel@laptopd505.fenrus.org>
	 <Pine.LNX.4.64.0708061159370.1817@scrub.home>
	 <1186415621.2706.4.camel@laptopd505.fenrus.org>
	 <Pine.LNX.4.64.0708071417200.1817@scrub.home>
	 <1186546512.2862.3.camel@laptopd505.fenrus.org>
	 <1158166a0708091231r21903840mc927b6baa47e4598@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/9/07, Denis Vlasenko <vda.linux@googlemail.com> wrote:
> On 8/8/07, Arjan van de Ven <arjan@infradead.org> wrote:
> > You keep claiming that hrtimers are so incredibly expensive; but for
> > msleep()... which is mostly called during driver init ... I really don't
> > buy that it's really expensive. We're not doing this a gazilion times
> > per second obviously...
>
> Yes. Optimizing delay or sleep functions for speed is a contradiction
> of terms. IIRC we still optimize udelay for speed, not code size...
> Read it again folks:
>
>         We optimize udelay for speed
>
> How fast your udelay do you want to be today?


Just checked. i386 and x86-64 seems to be sane - udelay() and ndelay()
are not inlined.

Several arches are still frantically try to make udelay faster. Many have
the same comment:

/*
 * Use only for very small delays ( < 1 msec).  Should probably use a
 * lookup table, really, as the multiplications take much too long with
 * short delays.  This is a "reasonable" implementation, though (and the
 * first constant multiplications gets optimized away if the delay is
 * a constant)
 */

and thus seem to be a cut-n-paste code.

BTW, almost all arched have __const_udelay(N) which obviously
does not delay for N usecs:

#define udelay(n) (__builtin_constant_p(n) ? \
        ((n) > 20000 ? __bad_udelay() : __const_udelay((n) * 0x10c7ul)) : \
        __udelay(n))

Bad name.

Are patches which de-inline udelay and do s/__const_udelay/__const_delay/g
be accepted?

Arches with udelay's still inlined are below. mips is especially big.
frv has totally bogus ndelay().

include/asm-ppc/delay.h
extern __inline__ void __udelay(unsigned int x)
{
        unsigned int loops;
        __asm__("mulhwu %0,%1,%2" : "=r" (loops) :
                "r" (x), "r" (loops_per_jiffy * 226));
        __delay(loops);
}


include/asm-parisc/delay.h
static __inline__ void __udelay(unsigned long usecs) {
        __cr16_delay(usecs * ((unsigned long)boot_cpu_data.cpu_hz / 1000000UL));
}


include/asm-mips/delay.h
static inline void __udelay(unsigned long usecs, unsigned long lpj)
{
        unsigned long lo;

        /*
         * The rates of 128 is rounded wrongly by the catchall case
         * for 64-bit.  Excessive precission?  Probably ...
         */
#if defined(CONFIG_64BIT) && (HZ == 128)
        usecs *= 0x0008637bd05af6c7UL;          /* 2**64 / (1000000 / HZ) */
#elif defined(CONFIG_64BIT)
        usecs *= (0x8000000000000000UL / (500000 / HZ));
#else /* 32-bit junk follows here */
        usecs *= (unsigned long) (((0x8000000000000000ULL / (500000 / HZ)) +
                                   0x80000000ULL) >> 32);
#endif

        if (sizeof(long) == 4)
                __asm__("multu\t%2, %3"
                : "=h" (usecs), "=l" (lo)
                : "r" (usecs), "r" (lpj)
                : GCC_REG_ACCUM);
        else if (sizeof(long) == 8)
                __asm__("dmultu\t%2, %3"
                : "=h" (usecs), "=l" (lo)
                : "r" (usecs), "r" (lpj)
                : GCC_REG_ACCUM);

        __delay(usecs);
}


include/asm-m68k/delay.h
static inline void __udelay(unsigned long usecs)
{
        __const_udelay(usecs * 4295);   /* 2**32 / 1000000 */
}


include/asm-h8300/delay.h
static inline void udelay(unsigned long usecs)
{
        usecs *= 4295;          /* 2**32 / 1000000 */
        usecs /= (loops_per_jiffy*HZ);
        if (usecs)
                __delay(usecs);
}


include/asm-frv/delay.h
static inline void udelay(unsigned long usecs)
{
        __delay(usecs * __delay_loops_MHz);
}
#define ndelay(n)       udelay((n) * 5)


include/asm-xtensa/delay.h
static __inline__ void udelay (unsigned long usecs)
{
        unsigned long start = xtensa_get_ccount();
        unsigned long cycles = usecs * (loops_per_jiffy / (1000000UL / HZ));

        /* Note: all variables are unsigned (can wrap around)! */
        while (((unsigned long)xtensa_get_ccount()) - start < cycles)
                ;
}


include/asm-v850/delay.h
static inline void udelay(unsigned long usecs)
{
        register unsigned long full_loops, part_loops;
        full_loops = ((usecs * HZ) / 1000000) * loops_per_jiffy;
        usecs %= (1000000 / HZ);
        part_loops = (usecs * HZ * loops_per_jiffy) / 1000000;
        __delay(full_loops + part_loops);
}


include/asm-cris/delay.h
static inline void udelay(unsigned long usecs)
{
        __delay(usecs * loops_per_usec);
}


include/asm-blackfin/delay.h
static inline void udelay(unsigned long usecs)
{
        extern unsigned long loops_per_jiffy;
        __delay(usecs * loops_per_jiffy / (1000000 / HZ));
}
--
vda
