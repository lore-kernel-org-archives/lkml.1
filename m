Return-Path: <linux-kernel-owner+w=401wt.eu-S1762891AbXFGPA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762891AbXFGPA6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 11:00:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758324AbXFGPAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 11:00:52 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:58901 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205AbXFGPAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 11:00:51 -0400
Subject: Re: LZO patch comparision
From: Richard Purdie <rpurdie@openedhand.com>
To: Nitin Gupta <nitingupta910@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4cefeab80706070710x79ee3ca8h5ae8419bec2edce3@mail.gmail.com>
References: <1181217390.6086.108.camel@localhost.localdomain>
	 <4cefeab80706070710x79ee3ca8h5ae8419bec2edce3@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 07 Jun 2007 16:00:27 +0100
Message-Id: <1181228427.6086.165.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-06-07 at 19:40 +0530, Nitin Gupta wrote:
> On 6/7/07, Richard Purdie <rpurdie@openedhand.com> wrote:
> > In the following,
> > - is Nitin's patch
> > + is my version.

> > +       for (;;) {
> > -               DINDEX1(dindex, ip);
> > +               dindex = DMS((0x21 * DX3(ip,5,5,6)) >> 5, 0);
> >                 m_pos = dict[dindex];
> >
> > Probably makes sense to expand the define since its single use.
> 
> DINDEX{1,2} definition varies with LZO flavours (lzo1x, lzo1y etc.),
> so its better to leave this macro as such.

Ok, I've no real preference.

> > -                               op[-2] |= (unsigned char)t;
> > +                               op[-2] |= t;
> > The unsigned char casts are all unneeded.
> > I'll skip future cases of these issues but there are more.
> 
> 't' is size_t, so shouldn't we do this casting while doing OR b/w
> unsigned char and size_t ? I'm not sure here.

op is an unsigned char. The assignment implies the cast and it will make
no difference to the output code (I've checked).

> >
> > @@ -203,61 +165,60 @@
> >                         break;
> >         }
> >
> > -       *out_len = (size_t)(op - out);
> > -       return (size_t)(in_end - ii);
> > +       *out_len = op - out;
> > +       return in_end - ii;
> >
> > unneeded casts.
> 
> You pointed out _lots_ of such unnecessary casts. I wonder why author
> did these in first place? He aims "unlimited" backward compatibility
> but I'm not too sure if removing these castings can break code on any
> of archs that Linux supports.

The author supports any compiler on any arch with a wide range of
compiler flags. If we assume gcc and the standard kernel coding
standards/flags, the casts are not needed. All the casts I've suggested
removing are implied by the assignments made.

FWIW, my bytecode comparisons also confirm there are no bytecode changes
on the arches I made the tests on.

> > -       if (!workmem)
> > -               return -EINVAL;
> >
> > Could be confused with LZO's own error codes. Do we need this?
> 
> This is basic (good-to-have) sanity check. s/-EINVAL/LZO_E_ERROR

It should never happen and I'm not sure its worth guarding against but
LZO_E_ERROR is better.

> > +#define HAVE_IP_OR(x, ip_end, ip) ((ip_end - ip) < (size_t)(x))
> > +#define HAVE_OP_OR(x, op_end, op) ((op_end - op) < (size_t)(x))
> > +#define HAVE_LB_OR(m_pos, out, op) (m_pos < out || m_pos >= op)
> >
> > Your NEED_* defines affect flow control contra to CodingStyle, hence my
> > choice of these instead and the associated code changes which I'll skip
> > over.
> 
> 1. Why did you remove (size_t) cast in LHS? It's now like comparison
> between signed and unsigned int.

Where does the int come from? op_end, op and friends are all pointers
and will hence be unsigned...

> 2. Naming is strange. I suggest:
> HAVE_IP_OR -> CHECK_IP
> HAVE_OP_OR -> CHECK_OP
> HAVE_LB_OR -> CHECK_LB

ok.

> > -               /* copy literals */
> > -               NEED_OP(t + 3);
> > -               NEED_IP(t + 4);
> > -#ifndef UNALIGNED_OK
> > -               if (((ip | op ) & 3) == 0) {
> > -#endif
> > +               if (HAVE_OP_OR(t + 3, op_end, op))
> > +                       goto output_overrun;
> > +               if (HAVE_IP_OR(t + 4, ip_end, ip))
> > +                       goto input_overrun;
> > +
> > +#if defined(LZO_UNALIGNED_OK_4)
> >                         COPY4(op, ip);
> >                         op += 4;
> >                         ip += 4;
> >
> 
> There is no need to have separate LZO_UNALIGNED_OK_{2,4}. If unaligned
> access is allowed and is faster than byte-by-byte access, set
> UNALIGNED_OK otherwise not.

There was no real added complication in leaving them separate. Some
archs support LZO_UNALIGNED_OK_4 but not LZO_UNALIGNED_OK_2 (AVR32
according to the kernel headers). 

Anyhow, this is pending a look at what get/put_unaligned does to the
bytecode...

> > We have a fairly major difference in the code here. This is where you've
> > assumed LZO_ALIGNED_OK_4 was set and it wasn't set in any in LZO in any
> > of my tests. Assuming LZO_ALIGNED_OK_4 should be safe for the kernel and
> > the code path you've added probably performs better but why was it
> > disabled in minilzo?
> >
> > -#ifdef UNALIGNED_OK
> > +#if defined(LZO_UNALIGNED_OK_4)
> >                         if (t >= 2 * 4 - (3 - 1) && (op - m_pos) >= 4) {
> > -#else
> > -                       if (t >= 2 * 4 - (3 - 1) &&
> > -                                       (((op | m_pos) &  3) == 0)) {
> > -#endif
> >
> > Same again here.
> 
> Here, you are avoiding optimization in case op, m_pos happen to be
> (4-byte) aligned.

Yes, for the reason I described - minilzo didn't enable that
optimisation / codepath - why?

> > diff -uwr 1/lzodefs.h 2/lzodefs.h
> > --- 1/lzodefs.h 2007-06-07 09:33:34.000000000 +0100
> > +++ 2/lzodefs.h 2007-06-06 17:40:56.000000000 +0100
> >
> > -#ifndef __LZO1X_INT_H
> > -#define __LZO1X_INT_H
> >
> > Pointless since only the LZO code will include this and it will do it
> > once.
> 
> No header file should ever be without these.

Plenty of kernel header files are...

> > +/* Which machines to allow unaligned accesses on */
> > +#if defined(CONFIG_X86_32) || defined(CONFIG_X86_64)
> > +#define LZO_UNALIGNED_OK_2
> > +#define LZO_UNALIGNED_OK_4
> >  #endif
> 
> > Probably preferable to do this here using CONFIG options rather than in
> > the Makefile.
> 
> I think, CONFIG_* option is not present for all archs (ARM/PPC?). The
> arch is simply picked up as a compilation arg (ARCH=x) or using `uname
> -m`. So I think its better to leave this in Makefile as simple list.

Ok, this will need some further thought. Its probably not worth
discussing until the implications of get/put_unaligned have been looked
at. A lot of effort has gone into those header files and we should
probably try and use them if its not going to affect performance too
much.

> > I still need to do some further tests to ascertain whether
> > we can use get/put_unaligned without affecting performance instead.
> 
> I think, get/put_unaligned should not be used on archs where these are
> slower than simple byte-by-byte access. I suspect this is the case
> where dirty work behind unaligned access is done in s/w (though I have
> not done any benchmarks myself).
>
> > So in summary apart from style issues, the code is the same apart from
> > the alignment access issues.
> 
> Yes. I will look into these alignment issues again.

Likewise.

Cheers,

Richard


