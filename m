Return-Path: <linux-kernel-owner+w=401wt.eu-S1761963AbXFGOKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761963AbXFGOKx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 10:10:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754637AbXFGOKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 10:10:46 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:26795 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754310AbXFGOKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 10:10:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GREuC7apAi/nJxteBx86aoxHLNJxeemLEgY2RuZNk+weBzbk4L208nqv98NBgo8KzjHgV2MWLsIcw4NSCw18VpEZLaCZOllSvbWn2fiF/DpFbOdWNjm5xHaXOvUq7kpRAdCa/YboDyvBK1nEQrhk66FB2boBqv/XeuxexDAEDvg=
Message-ID: <4cefeab80706070710x79ee3ca8h5ae8419bec2edce3@mail.gmail.com>
Date: Thu, 7 Jun 2007 19:40:43 +0530
From: "Nitin Gupta" <nitingupta910@gmail.com>
To: "Richard Purdie" <rpurdie@openedhand.com>
Subject: Re: LZO patch comparision
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1181217390.6086.108.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1181217390.6086.108.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/7/07, Richard Purdie <rpurdie@openedhand.com> wrote:

>
> In the following,
> - is Nitin's patch
> + is my version.
>

>
> +       for (;;) {
> -               DINDEX1(dindex, ip);
> +               dindex = DMS((0x21 * DX3(ip,5,5,6)) >> 5, 0);
>                 m_pos = dict[dindex];
>
> Probably makes sense to expand the define since its single use.

DINDEX{1,2} definition varies with LZO flavours (lzo1x, lzo1y etc.),
so its better to leave this macro as such.

>
> -               if ((m_pos < in) || (m_off = (size_t)(ip - m_pos)) <= 0
> -                                || m_off > M4_MAX_OFFSET)
> +               if (m_pos < in)
> +                       goto literal;
> +
> +               m_off = ip - m_pos;
> +               if (m_off == 0 || m_off > M4_MAX_OFFSET)
>                         goto literal;
>
> This can be expanded to be more obvious. Need to be careful about
> signage, the <= becomes a == but we can then lose the cast.

Yes. Look better.

> -                               op[-2] |= (unsigned char)t;
> +                               op[-2] |= t;
> The unsigned char casts are all unneeded.
> I'll skip future cases of these issues but there are more.

't' is size_t, so shouldn't we do this casting while doing OR b/w
unsigned char and size_t ? I'm not sure here.

>
> @@ -203,61 +165,60 @@
>                         break;
>         }
>
> -       *out_len = (size_t)(op - out);
> -       return (size_t)(in_end - ii);
> +       *out_len = op - out;
> +       return in_end - ii;
>
> unneeded casts.
>

You pointed out _lots_ of such unnecessary casts. I wonder why author
did these in first place? He aims "unlimited" backward compatibility
but I'm not too sure if removing these castings can break code on any
of archs that Linux supports.


>
> -       if (!workmem)
> -               return -EINVAL;
>
> Could be confused with LZO's own error codes. Do we need this?

This is basic (good-to-have) sanity check. s/-EINVAL/LZO_E_ERROR

>
> +#define HAVE_IP_OR(x, ip_end, ip) ((ip_end - ip) < (size_t)(x))
> +#define HAVE_OP_OR(x, op_end, op) ((op_end - op) < (size_t)(x))
> +#define HAVE_LB_OR(m_pos, out, op) (m_pos < out || m_pos >= op)
>
> Your NEED_* defines affect flow control contra to CodingStyle, hence my
> choice of these instead and the associated code changes which I'll skip
> over.

1. Why did you remove (size_t) cast in LHS? It's now like comparison
between signed and unsigned int.
2. Naming is strange. I suggest:
HAVE_IP_OR -> CHECK_IP
HAVE_OP_OR -> CHECK_OP
HAVE_LB_OR -> CHECK_LB

>
> -MODULE_LICENSE("GPL");
> -MODULE_DESCRIPTION("LZO1X Decompression");
> +#if defined(LZO_UNALIGNED_OK_4)
> +#define COPY4(dst,src) *(u32 *)(dst) = *(const u32 *)(src)
> +#endif
>
> Only the decompressor uses COPY4 so I moved it to this file.

ok.

> -       while (TEST_IP) {
> +       while ((ip < ip_end)) {
>
> Might as well expand this...

Yes. Looks better.


> -               /* copy literals */
> -               NEED_OP(t + 3);
> -               NEED_IP(t + 4);
> -#ifndef UNALIGNED_OK
> -               if (((ip | op ) & 3) == 0) {
> -#endif
> +               if (HAVE_OP_OR(t + 3, op_end, op))
> +                       goto output_overrun;
> +               if (HAVE_IP_OR(t + 4, ip_end, ip))
> +                       goto input_overrun;
> +
> +#if defined(LZO_UNALIGNED_OK_4)
>                         COPY4(op, ip);
>                         op += 4;
>                         ip += 4;
>

There is no need to have separate LZO_UNALIGNED_OK_{2,4}. If unaligned
access is allowed and is faster than byte-by-byte access, set
UNALIGNED_OK otherwise not.

> We have a fairly major difference in the code here. This is where you've
> assumed LZO_ALIGNED_OK_4 was set and it wasn't set in any in LZO in any
> of my tests. Assuming LZO_ALIGNED_OK_4 should be safe for the kernel and
> the code path you've added probably performs better but why was it
> disabled in minilzo?
>
> -#ifdef UNALIGNED_OK
> +#if defined(LZO_UNALIGNED_OK_4)
>                         if (t >= 2 * 4 - (3 - 1) && (op - m_pos) >= 4) {
> -#else
> -                       if (t >= 2 * 4 - (3 - 1) &&
> -                                       (((op | m_pos) &  3) == 0)) {
> -#endif
>
> Same again here.

Here, you are avoiding optimization in case op, m_pos happen to be
(4-byte) aligned.

>
> @@ -229,42 +230,45 @@
>
>                         t = *ip++;
> -               } while (TEST_IP);
> +               } while (ip < ip_end);
>
> Might as well expand this.
>

ok.

>
> diff -uwr 1/lzodefs.h 2/lzodefs.h
> --- 1/lzodefs.h 2007-06-07 09:33:34.000000000 +0100
> +++ 2/lzodefs.h 2007-06-06 17:40:56.000000000 +0100
>
> -#ifndef __LZO1X_INT_H
> -#define __LZO1X_INT_H
>
> Pointless since only the LZO code will include this and it will do it
> once.

No header file should ever be without these.

>
> -#include <linux/types.h>
>
> Uneeded?

Yup.

>
> +#define LZO_VERSION             0x2020
> +#define LZO_VERSION_STRING      "2.02"
> +#define LZO_VERSION_DATE        "Oct 17 2005"
>
> A good idea to leave these so the exact version this was created from is
> documented.

ok.

>
>
> +#define DMS(v,s)       ((size_t) (((v) & (D_MASK >> (s))) << (s)))
>
> You've merged this into DINDEX2. Since s is 0, that probably makes sense
> (we can both lose the cast too).
>

> +/* Which machines to allow unaligned accesses on */
> +#if defined(CONFIG_X86_32) || defined(CONFIG_X86_64)
> +#define LZO_UNALIGNED_OK_2
> +#define LZO_UNALIGNED_OK_4
>  #endif
>


> Probably preferable to do this here using CONFIG options rather than in
> the Makefile.

I think, CONFIG_* option is not present for all archs (ARM/PPC?). The
arch is simply picked up as a compilation arg (ARCH=x) or using `uname
-m`. So I think its better to leave this in Makefile as simple list.

> I still need to do some further tests to ascertain whether
> we can use get/put_unaligned without affecting performance instead.
>

I think, get/put_unaligned should not be used on archs where these are
slower than simple byte-by-byte access. I suspect this is the case
where dirty work behind unaligned access is done in s/w (though I have
not done any benchmarks myself).

> So in summary apart from style issues, the code is the same apart from
> the alignment access issues.

Yes. I will look into these alignment issues again.

>
> http://folks.o-hand.com/richard/lzo/lzo_kernel-r5.patch is a version
> I've updated as I went through this which should combine the good bits
> from both *apart* from the alignment issues which I want to look at more
> carefully before taking an approach.
>

I agree with changes I skipped in this reply.


Thanks for detailed comparison.


Cheers,
Nitin
