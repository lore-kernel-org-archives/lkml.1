Return-Path: <linux-kernel-owner+w=401wt.eu-S1763685AbXE1W6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763685AbXE1W6U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 18:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751358AbXE1W6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 18:58:13 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:61595 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181AbXE1W6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 18:58:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QwxNbcs/Crvuvge4MOjqR31OYqbZSoEDh6BUqTGRzTJ7vF6pW71kQ8UFz3ORbwmZ5dvMCAsEWgpi7OKaU8/GWUq51Bza78Vt30haIqHFoplqHoL8BNwu4lzOrotInIPRvS9tIDIzHJRki/tjZL103r0JiUceiaszLW0QbHEwJhU=
Message-ID: <dda83e780705281558p685004a6p69580f49f7020e2f@mail.gmail.com>
Date: Mon, 28 May 2007 15:58:11 -0700
From: "Bret Towe" <magnade@gmail.com>
To: "Nitin Gupta" <nitingupta910@gmail.com>
Subject: Re: [RFC] LZO de/compression support - take 6
Cc: lkml <linux-kernel@vger.kernel.org>, linux-mm-cc@laptop.org,
       linuxcompressed-devel@lists.sourceforge.net,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Daniel Hazelton" <dhazelton@enter.net>,
       "Richard Purdie" <richard@openedhand.com>,
       "Satyam Sharma" <satyam.sharma@gmail.com>
In-Reply-To: <dda83e780705281553s67ace88at60f6ab28b198a832@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4cefeab80705280734i37df1742k6738cd4200813684@mail.gmail.com>
	 <dda83e780705281553s67ace88at60f6ab28b198a832@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/28/07, Bret Towe <magnade@gmail.com> wrote:
> On 5/28/07, Nitin Gupta <nitingupta910@gmail.com> wrote:
> > Hi,
> >
> > This is kernel port of LZO1X-1 compressor and LZO1X decompressor (safe
> > version only).
> >
> > * Changes since 'take 5' (Full Changelog after this):
> > - Added compressor and decomrpesssor as separate and hidden config
> > options (default: n)
> > - Cleanups: removed LZO_CHECK_MPOS_NON_DET macro
> > - removed PTR* macros.
> >
> > * Benchmarks: (system: P4 3GHz, 1G RAM)
> > (Using tester program from Daniel)
> >
> > Following compares this kernel port ('take 6') vs original miniLZO code:
> >
> > 'TinyLZO' refers to this kernel port.
> >
> > 10000 run averages:
> > 'Tiny LZO':
> >        Combined: 61.2223 usec
> >        Compression: 41.8412 usec
> >        Decompression: 19.3811 usec
> > 'miniLZO':
> >        Combined: 66.0444 usec
> >        Compression: 46.6323 usec
> >        Decompression: 19.4121 usec
> >
> > Result:
> > Overall: TinyLZO is 7.3% faster
> > Compressor: TinyLZO is 10.2% faster
> > Decompressor: TinyLZO is 0.15% faster
> >
> > TODO: test 'take 6' port on archs other than x86(_32)
> >
> > * Changelog vs. original LZO:
> > 1) Used standard/kernel defined data types: (this eliminated _huge_
> > #ifdef chunks)
> >   lzo_bytep -> unsigned char *
> >   lzo_uint -> size_t
> >   lzo_xint -> size_t
> >   lzo_uint32p -> u32 *
> >   lzo_uintptr_t  -> unsigned long
> > 2) Removed everything #ifdef'ed under COPY_DICT (this is not set for
> > LZO1X, so removed corres. parts).
> > 3) Removed code #ifdef'ed for LZO1Y, LZO1Z, other variants.
> > 4) Reformatted the code to match general kernel style.
> > 5) The only code change: (as suggested by Andrey)
> > -#if defined(__LITTLE_ENDIAN)
> > -                             m_pos = op - 1;
> > -                             m_pos -= (*(const unsigned short *)ip) >> 2;
> > -#else
> > -                             m_pos = op - 1;
> > -                             m_pos -= (ip[0] >> 2) + (ip[1] << 6);
> > -#endif
> >
> > + m_pos = op - 1 - (cpu_to_le16(*(const u16 *)ip) >> 2);
> >
> > (Andrey suggested le16_to_cpu for above but I think it should be cpu_to_le16).
> > *** Need testing on big endian machine ***
> >
> > Similarly:
> > -#if defined(__LITTLE_ENDIAN)
> > -                             m_pos -= (*(const unsigned short *)ip) >> 2;
> > -#else
> > -                             m_pos -= (ip[0] >> 2) + (ip[1] << 6);
> > -#endif
> >
> > + m_pos -= cpu_to_le16(*(const u16 *)ip) >> 2;
> >
> > 6) Get rid of LZO_CHECK_MPOS_NON_DET macro and PTR* macros.
> >
> >
> > I think it's now ready for mainline inclusion.
> >
> >
> >  include/linux/lzo1x.h        |   66 +++++++++++
> >  lib/Kconfig                  |    6 +
> >  lib/Makefile                 |    2 +
> >  lib/lzo1x/Makefile           |    2 +
> >  lib/lzo1x/lzo1x_compress.c   |  259
>
> tested this on ppc and its still good
> is there any reason to bother with a test on amd64?
> if there is I might be able to get to it tonight
>

forgot to mention that it would make life easier if you would put the
version of the patch
in the .bz2 files you attach since you poping out new takes so quick
