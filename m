Return-Path: <linux-kernel-owner+w=401wt.eu-S1760726AbXERL1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760726AbXERL1f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 07:27:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756084AbXERL13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 07:27:29 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:41299 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756039AbXERL12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 07:27:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dyx9U7Uz2Dw03vY0DclugBvy80N1HwWrralMlqI15za+AJs4yvDmdTtcVXXJ9GDRFcd0JDLoMHavWVGvEEm2EU6ZSuHkdJved61TXWG9I2ROxd9H6SpJo24KhLO88Y69plQU6usMxOyI1zTRCcvoLbide3KFSKAMkZllZKZzFE4=
Message-ID: <4cefeab80705180427u54110396mfb3acd96c6c446bd@mail.gmail.com>
Date: Fri, 18 May 2007 16:57:25 +0530
From: "Nitin Gupta" <nitingupta910@gmail.com>
To: "Heikki Orsila" <shdl@zakalwe.fi>
Subject: Re: [RFC] LZO1X de/compression support
Cc: linux-kernel@vger.kernel.org, "Richard Purdie" <richard@openedhand.com>,
       "Markus F.X.J. Oberhumer" <markus@oberhumer.com>
In-Reply-To: <20070518101449.GH10873@zakalwe.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4cefeab80705180258g516a6f92w15a49e666dd62b66@mail.gmail.com>
	 <20070518101449.GH10873@zakalwe.fi>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks for review. My comments inline.

On 5/18/07, Heikki Orsila <shdl@zakalwe.fi> wrote:
> Good work..
>
> On Fri, May 18, 2007 at 03:28:31PM +0530, Nitin Gupta wrote:
> > Facts for LZO (at least for original code. Should hold true for this
> > port also - hence the RFC!):
> > - The compressor can never overrun buffer.
> > - The "non-safe" version of decompressor can never overrun buffer if
> > compressed data is unmodified. I am not sure about this if compressed
> > data is malicious (to be confirmed from the author).
> > - The "safe" version can never crash (buffer overrun etc.) - confirmed
> > from the author.
>
> What's the proof?

I confirmned these from the author - I just ported this code. I think
he can answer you better - CC'ed him  :-)

>
> > +/* LZO1X_1 compression */
> > +int
> > +lzo1x_compress(const unsigned char *src, size_t src_len,
> > +             unsigned char *dst, size_t *dst_len,
> > +             void *workmem);
>
> int lzo1x_compress(const unsigned char *src, size_t src_len,
>                    unsigned char *dst, size_t *dst_len,
>                    void *workmem);
>
> is the preferred style.
>

OK. Changed.

<snip>
> > +     register const unsigned char *ip;
>
> Is the register directive really useful? Or any subsequent usage of that
> directive?

The author must be having some performance gain with this directive.
Though I didn't test performance changes with/without this directive.

> > +             DINDEX1(dindex,ip);
>
> Put a space after the delimiter: DINDEX1(dindex, ip); This happens in
> many places in the source, fix them all.

OK.

> Useless brackets: (unsigned char) tt
>
OK.

> > +             }
> > +             do *op++ = *ii++; while (--t > 0);
>
> memcpy(op, ii, t); ? Happens in other places as well.

I looked more carefully into such cases. Following type of code blocks
are repeated at several places:

---
                COPY4(op,ip);
                op += 4;
                ip += 4;
                if (--t > 0) {
                        if (t >= 4) {
                                do {
                                        COPY4(op,ip);
                                        op += 4; ip += 4; t -= 4;
                                } while (t >= 4);
                                if (t > 0)
                                        do
                                                *op++ = *ip++;
                                        while (--t > 0);
                        } else
                                do
                                        *op++ = *ip++;
                                while (--t > 0);
                }
---
Such entire blocks can be replaced by simple:
memcpy(op, ip, t + 4);
Since kernel has separate memcpy() implementation optimized for
specific archs, we shouldn't loose on perf while having simpler (and
shorter) code.

I will work on this and post again.


> > +#define COPY4(dst,src)       *(uint32_t *)(dst) = *(uint32_t *)(src)
>
> Use u32.
>

What is the problem with uint32_t? Anyhow, I think COPY4 will
disappear after those memcpy changes :)

Thanks for comments. I will post revised patch soon.


Cheers,
Nitin
