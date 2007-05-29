Return-Path: <linux-kernel-owner+w=401wt.eu-S1760892AbXE2Kln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760892AbXE2Kln (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 06:41:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756098AbXE2Klf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 06:41:35 -0400
Received: from wr-out-0506.google.com ([64.233.184.227]:25851 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756004AbXE2Kle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 06:41:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qqT3TkvTcg37NSMwEj7buVR44/P362+Is0qFz8jvm2c2JzfIjPw8Qv2rIGTDg0/4S5KxRexohV525gu3YJhtRaVBqClaAB96fiC5EBSdtCWSh/mb9Yubas1C3M1CxE01OVX/R0/NGIOKCBOy5pNj8UXKrmzq60a9/9OUnUSO4LQ=
Message-ID: <a781481a0705290341w4c403c1ej43565a1e66805522@mail.gmail.com>
Date: Tue, 29 May 2007 16:11:32 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Michael-Luke Jones" <mlj28@cam.ac.uk>
Subject: Re: Makefile question (was [RFC] LZO de/compression support - take 6)
Cc: "Nitin Gupta" <nitingupta910@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>, linux-mm-cc@laptop.org,
       linuxcompressed-devel@lists.sourceforge.net,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Daniel Hazelton" <dhazelton@enter.net>,
       "Richard Purdie" <richard@openedhand.com>,
       "Bret Towe" <magnade@gmail.com>
In-Reply-To: <292C7F80-B80D-4645-8FF5-49BF911398E1@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4cefeab80705280734i37df1742k6738cd4200813684@mail.gmail.com>
	 <292C7F80-B80D-4645-8FF5-49BF911398E1@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/29/07, Michael-Luke Jones <mlj28@cam.ac.uk> wrote:
> On 28 May 2007, at 15:34, Nitin Gupta wrote:
>
> > diff --git a/lib/Kconfig b/lib/Kconfig
> > index 2e7ae6b..eb95eaa 100644
> > --- a/lib/Kconfig
> > +++ b/lib/Kconfig
> > @@ -64,6 +64,12 @@ config ZLIB_INFLATE
> > config ZLIB_DEFLATE
> >       tristate
> >
> > +config LZO1X_COMPRESS
> > +     tristate
> > +
> > +config LZO1X_DECOMPRESS
> > +     tristate
> > +
> > #
> > # Generic allocator support is selected if needed
> > #
> > diff --git a/lib/Makefile b/lib/Makefile
> > index c8c8e20..448ae37 100644
> > --- a/lib/Makefile
> > +++ b/lib/Makefile
> > @@ -49,6 +49,8 @@ obj-$(CONFIG_GENERIC_ALLOCATOR) += genalloc.o
> > obj-$(CONFIG_ZLIB_INFLATE) += zlib_inflate/
> > obj-$(CONFIG_ZLIB_DEFLATE) += zlib_deflate/
> > obj-$(CONFIG_REED_SOLOMON) += reed_solomon/
> > +obj-$(CONFIG_LZO1X_COMPRESS) += lzo1x/
> > +obj-$(CONFIG_LZO1X_DECOMPRESS) += lzo1x/
> >
> > obj-$(CONFIG_TEXTSEARCH) += textsearch.o
> > obj-$(CONFIG_TEXTSEARCH_KMP) += ts_kmp.o
>
> Hey there,
>
> Is this syntax OK for Makefile use? I'm only asking out of personal
> ignorance and because I'd use:

> > +obj-$(CONFIG_LZO1X_COMPRESS) += lzo1x/
> > +obj-$(CONFIG_LZO1X_DECOMPRESS) += lzo1x/

This is syntactically correct (and wouldn't produce any build errors),
but it's quite ... strange, still. Why would I even want to /build/ the
compress code if all I selected was the decompress option?

Also, when both the options are y, make would just make the first
target, then recurse back into that same directory again and skip
it because it just made it ... which, although harmless, is ... strange.

So I'm not sure if we really want both the options to resolve to the
same make target -- the kernel typically has more users of
_decompress_ than those of _compress_, so it does make some sense
to completely decouple the two into separate directories in lib/ and have
separate Kconfig options (as well as Makefile target subdirs) for them.

> Kconfig:
>
> config LZO1X_COMPRESS
>         select LZO1X
>         tristate
>
> config LZO1X_DECOMPRESS
>         select LZO1X
>         tristate
>
> config LZO1X
>         tristate (or boolean??)

Hmmm ... if this is /really/ what we want to do, what's wrong with simply:

config LZO1x
	tristate

?

> Makefile:
>
> obj-$(CONFIG_LZO1X) += lzo1x/

I find nothing wrong with the style being used for ZLIB presently. Agreed,
users of ZLIB do typically want to select only decompress *without*
compress whereas there's no such user for LZO currently, but I see
nothing wrong in just copying over ZLIB's style for LZO too (i.e. decoupling
the compress and decompress code into separate subdirs in lib/).
And if not, then why have two separate (dummy) Kconfig options either?
