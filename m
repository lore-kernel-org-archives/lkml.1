Return-Path: <linux-kernel-owner+w=401wt.eu-S1760691AbYCNTpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760691AbYCNTpw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 15:45:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760041AbYCNTnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 15:43:49 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:45027 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760032AbYCNTnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 15:43:47 -0400
Message-Id: <1205523826.7441.1242464129@webmail.messagingengine.com>
X-Sasl-Enc: xOjqPKOlFwSlyG0klpmE0rD4wKg4omILFa8g8iI3hUsp 1205523826
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Alexander van Heukelum" <heukelum@mailshack.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andi Kleen" <andi@firstfloor.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, "LKML" <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <20080312200128.GA24983@mailshack.com> <47DABEFB.3050704@goop.org>
Subject: Re: [PATCH] x86: merge the simple bitops and move them to bitops.h
In-Reply-To: <47DABEFB.3050704@goop.org>
Date: Fri, 14 Mar 2008 20:43:46 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Mar 2008 11:07:55 -0700, "Jeremy Fitzhardinge"
<jeremy@goop.org> said:
> Alexander van Heukelum wrote:
> > x86: merge the simple bitops and move them to bitops.h
> >
> > Some of those can be written in such a way that the same
> > inline assembly can be used to generate both 32 bit and
> > 64 bit code.
> >
> > For ffs and fls, x86_64 unconditionally used the cmov
> > instruction and i386 unconditionally used a conditional
> > branch over a mov instruction. In the current patch I
> > chose to select the version based on the availability
> > of the cmov instruction instead. A small detail here is
> > that x86_64 did not previously set CONFIG_X86_CMOV=y.
> >   
> 
> Looks good in general.  What's left in bitops_{32,64}.h now?

Thanks for taking a look!

bitops_{32,64}.h are getting pretty empty ;)

Both contain find_first_bit/find_first_zero_bit, i386 has them inlined,
x86_64 has an ugly define to select between small bitmaps (inlined) and
an out-of-line version. I think they should be unified much like how
find_next_bit and find_next_zero_bit work now (in x86#testing).

Both define fls64(), but i386 uses a generic one and x86_64 defines
one all by itself. The generic one is currently not suitable for
use by 64-bit archs... that can change.

x86_64 defines ARCH_HAS_FAST_MULTIPLIER, i386 not. This affects a
choice of generated code in the (generic) hweight function. It would
be nice if that could move to some other file.

x86_64 has a mysterious inline function set_bit_string, which is
only used by pci-calgary_64.c and pci-gart_64.c. Not sure what to
do with it.

> (Some comments below.)

--- %< ---

> > +#ifdef __KERNEL__
> > +/**
> > + * ffs - find first bit set
> > + * @x: the word to search
> > + *
> > + * This is defined the same way as
> > + * the libc and compiler builtin ffs routines, therefore
> > + * differs in spirit from the above ffz() (man ffs).
> 
> This comment seems wrong.  My "man ffs" says that it returns 1-32 for 
> non-zero inputs, and 0 for a zero input.  This function returns 0-31, or 
> -1 for a zero input.

Seems, indeed. You missed the "return r + 1;" ;-)

> > + */
> > +static inline int ffs(int x)
> > +{
> > +	int r;
> > +#ifdef CONFIG_X86_CMOV
> > +	__asm__("bsfl %1,%0\n\t"
> > +		"cmovzl %2,%0"
> >   
> 
> The prevailing style in bitops.h is to use "bsf"/"cmovz" and let the 
> compiler work out the size from the register names.

The comment rightly mentions that ffs differs in spirit from the rest
of the functions here. The type to be used here it always a 4-byte one
(int); most other functions operate on longs. I have not checked if the
explicit size is absolutely necessary, but I feel much safer with the
explicit size there.

> > +		: "=r" (r) : "rm" (x), "r" (-1));
> > +#else
> > +	__asm__("bsfl %1,%0\n\t"
> > +		"jnz 1f\n\t"
> > +		"movl $-1,%0\n"
> > +		"1:" : "=r" (r) : "rm" (x));
> > +#endif
> > +	return r+1;
> > +}
> > +
> > +/**
> > + * fls - find last bit set
> > + * @x: the word to search
> > + *
> > + * This is defined the same way as ffs().
> >   
> 
> And this comment is even more wrong, given that ffs and fls are 
> completely different functions ;)
> 
> I know these are from the original, but its worth fixing given that 
> you're touching it anyway.

I'll see if I can come up with something better.

Greetings,
    Alexander

> > + */
> > +static inline int fls(int x)
> > +{
> > +	int r;
> > +#ifdef CONFIG_X86_CMOV
> > +	__asm__("bsrl %1,%0\n\t"
> > +		"cmovzl %2,%0"
> > +		: "=&r" (r) : "rm" (x), "rm" (-1));
> > +#else
> > +	__asm__("bsrl %1,%0\n\t"
> > +		"jnz 1f\n\t"
> > +		"movl $-1,%0\n"
> > +		"1:" : "=r" (r) : "rm" (x));
> > +#endif
> > +	return r+1;
> > +}
> > +#endif /* __KERNEL__ */
> > +
> >  #undef ADDR
> >  
> >  #ifdef CONFIG_X86_32
> 
>     J
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - A no graphics, no pop-ups email service

