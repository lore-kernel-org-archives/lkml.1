Return-Path: <linux-kernel-owner+w=401wt.eu-S1755025AbZAFXQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025AbZAFXQU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 18:16:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754078AbZAFXPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 18:15:51 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51371 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649AbZAFXPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 18:15:50 -0500
Date: Tue, 6 Jan 2009 23:14:53 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 14/23] arm: introduce asm/swab.h
Message-ID: <20090106231453.GA3568@flint.arm.linux.org.uk>
References: <1231277452.964.271.camel@brick> <20090106231235.GB20623@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090106231235.GB20623@flint.arm.linux.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2009 at 11:12:35PM +0000, Russell King wrote:
> Thanks for bypassing me.
> 
> We've had this patch in the kernel before, then it got reverted.

Correction - we've had something similar to this before.

> Application: ae82cbfc8beaa69007aa09966d3983ac938c3577
> Reversion: b35de672e74ceea6482b4f690ad053aec8465c5d
> 
>     Revert "[ARM] use the new byteorder headers"
>     
>     This reverts commit ae82cbfc8beaa69007aa09966d3983ac938c3577. It
>     needs the new byteorder headers to be exported to userspace, and
>     they aren't yet -- and probably shouldn't be, at this point in the
>     2.6.27 release cycle (or ever, for that matter).
>     
>     Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
>     Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
> 
> Please explain what's changed to make this acceptable now.
> 
> On Tue, Jan 06, 2009 at 01:30:52PM -0800, Harvey Harrison wrote:
> > Convert to the new-style arch overrides as well.
> > 
> > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> > ---
> >  arch/arm/include/asm/Kbuild      |    1 +
> >  arch/arm/include/asm/byteorder.h |   33 +------------------------
> >  arch/arm/include/asm/swab.h      |   50 ++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 52 insertions(+), 32 deletions(-)
> > 
> > diff --git a/arch/arm/include/asm/Kbuild b/arch/arm/include/asm/Kbuild
> > index 73237bd..43b0b2b 100644
> > --- a/arch/arm/include/asm/Kbuild
> > +++ b/arch/arm/include/asm/Kbuild
> > @@ -1,3 +1,4 @@
> >  include include/asm-generic/Kbuild.asm
> >  
> >  unifdef-y += hwcap.h
> > +unifdef-y += swab.h
> > diff --git a/arch/arm/include/asm/byteorder.h b/arch/arm/include/asm/byteorder.h
> > index 4fbfb22..c02b6fc 100644
> > --- a/arch/arm/include/asm/byteorder.h
> > +++ b/arch/arm/include/asm/byteorder.h
> > @@ -15,38 +15,7 @@
> >  #ifndef __ASM_ARM_BYTEORDER_H
> >  #define __ASM_ARM_BYTEORDER_H
> >  
> > -#include <linux/compiler.h>
> > -#include <asm/types.h>
> > -
> > -static inline __attribute_const__ __u32 ___arch__swab32(__u32 x)
> > -{
> > -	__u32 t;
> > -
> > -#ifndef __thumb__
> > -	if (!__builtin_constant_p(x)) {
> > -		/*
> > -		 * The compiler needs a bit of a hint here to always do the
> > -		 * right thing and not screw it up to different degrees
> > -		 * depending on the gcc version.
> > -		 */
> > -		asm ("eor\t%0, %1, %1, ror #16" : "=r" (t) : "r" (x));
> > -	} else
> > -#endif
> > -		t = x ^ ((x << 16) | (x >> 16)); /* eor r1,r0,r0,ror #16 */
> > -
> > -	x = (x << 24) | (x >> 8);		/* mov r0,r0,ror #8      */
> > -	t &= ~0x00FF0000;			/* bic r1,r1,#0x00FF0000 */
> > -	x ^= (t >> 8);				/* eor r0,r0,r1,lsr #8   */
> > -
> > -	return x;
> > -}
> > -
> > -#define __arch__swab32(x) ___arch__swab32(x)
> > -
> > -#if !defined(__STRICT_ANSI__) || defined(__KERNEL__)
> > -#  define __BYTEORDER_HAS_U64__
> > -#  define __SWAB_64_THRU_32__
> > -#endif
> > +#include <asm/swab.h>
> >  
> >  #ifdef __ARMEB__
> >  #include <linux/byteorder/big_endian.h>
> > diff --git a/arch/arm/include/asm/swab.h b/arch/arm/include/asm/swab.h
> > new file mode 100644
> > index 0000000..27a689b
> > --- /dev/null
> > +++ b/arch/arm/include/asm/swab.h
> > @@ -0,0 +1,50 @@
> > +/*
> > + *  arch/arm/include/asm/byteorder.h
> > + *
> > + * ARM Endian-ness.  In little endian mode, the data bus is connected such
> > + * that byte accesses appear as:
> > + *  0 = d0...d7, 1 = d8...d15, 2 = d16...d23, 3 = d24...d31
> > + * and word accesses (data or instruction) appear as:
> > + *  d0...d31
> > + *
> > + * When in big endian mode, byte accesses appear as:
> > + *  0 = d24...d31, 1 = d16...d23, 2 = d8...d15, 3 = d0...d7
> > + * and word accesses (data or instruction) appear as:
> > + *  d0...d31
> > + */
> > +#ifndef __ASM_ARM_SWAB_H
> > +#define __ASM_ARM_SWAB_H
> > +
> > +#include <linux/compiler.h>
> > +#include <asm/types.h>
> > +
> > +#if !defined(__STRICT_ANSI__) || defined(__KERNEL__)
> > +#  define __SWAB_64_THRU_32__
> > +#endif
> > +
> > +static inline __attribute_const__ __u32 __arch_swab32(__u32 x)
> > +{
> > +	__u32 t;
> > +
> > +#ifndef __thumb__
> > +	if (!__builtin_constant_p(x)) {
> > +		/*
> > +		 * The compiler needs a bit of a hint here to always do the
> > +		 * right thing and not screw it up to different degrees
> > +		 * depending on the gcc version.
> > +		 */
> > +		asm ("eor\t%0, %1, %1, ror #16" : "=r" (t) : "r" (x));
> > +	} else
> > +#endif
> > +		t = x ^ ((x << 16) | (x >> 16)); /* eor r1,r0,r0,ror #16 */
> > +
> > +	x = (x << 24) | (x >> 8);		/* mov r0,r0,ror #8      */
> > +	t &= ~0x00FF0000;			/* bic r1,r1,#0x00FF0000 */
> > +	x ^= (t >> 8);				/* eor r0,r0,r1,lsr #8   */
> > +
> > +	return x;
> > +}
> > +#define __arch_swab32 __arch_swab32
> > +
> > +#endif
> > +
> > -- 
> > 1.6.1.94.g9388
> > 
> > 
> 
> -- 
> Russell King
>  Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
>  maintainer of:

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
