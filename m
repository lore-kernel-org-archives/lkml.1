Return-Path: <linux-kernel-owner+w=401wt.eu-S1753257AbXEXUKH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257AbXEXUKH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 16:10:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752986AbXEXUJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 16:09:49 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:25543 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984AbXEXUJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 16:09:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DSc5faOmlJeFE2O06Sn8fM+d98ZBXdtBID1U6Ab+JGH1moyLW5fkvxhbgLTvZ2WOg7Jy2S20Sbv8aGEDZ3yZdmehNxcsGIVxS3Zy9jOqM0XElac6CxLRqlboequWRf8GK2YHWmowiWpkvWsm+RrvPoZJ5k2go+nupl3NivQHCLU=
Message-ID: <a781481a0705241309i7b8b20e4o7c486c0b659d7094@mail.gmail.com>
Date: Fri, 25 May 2007 01:39:45 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Nitin Gupta" <nitingupta910@gmail.com>
Subject: Re: [RFC] LZO de/compression support - take 3
Cc: "Richard Purdie" <richard@openedhand.com>, linux-kernel@vger.kernel.org,
       linux-mm-cc@laptop.org, "Bret Towe" <magnade@gmail.com>
In-Reply-To: <4cefeab80705240720s2c047979r27f3d9433ebeac80@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4cefeab80705230127r58e8f9e1sa644092e95eb81eb@mail.gmail.com>
	 <a781481a0705231234m62327134mbfd1c1478b6fb99a@mail.gmail.com>
	 <1179995105.5880.7.camel@localhost.localdomain>
	 <4cefeab80705240720s2c047979r27f3d9433ebeac80@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/24/07, Nitin Gupta <nitingupta910@gmail.com> wrote:
> [...]
> > > > diff --git a/lib/lzo1x/lzo1x_int.h b/lib/lzo1x/lzo1x_int.h
> > > > [...]
> > > > +/* Macros for 'safe' decompression */
> > > > +#ifdef LZO1X_DECOMPRESS_SAFE
> > > > +
> > > > +#define lzo1x_decompress lzo1x_decompress_safe
> > > > +#define TEST_IP        (ip < ip_end)
> > > > +#define NEED_IP(x) \
> > > > +       if ((size_t)(ip_end - ip) < (size_t)(x)) goto input_overrun
> > > > +#define NEED_OP(x) \
> > > > +       if ((size_t)(op_end - op) < (size_t)(x)) goto output_overrun
> > > > +#define TEST_LB(m_pos) \
> > > > +       if (m_pos < out || m_pos >= op) goto lookbehind_overrun
> > > > +#define HAVE_TEST_IP
> > > > +#define HAVE_ANY_OP
> > > > +
> > > > +#else  /* !LZO1X_DECOMPRESS_SAFE */
> > > > +
> > > > +#define        TEST_IP         1
> > > > +#define        TEST_LB(x)      ((void) 0)
> > > > +#define        NEED_IP(x)      ((void) 0)
> > > > +#define        NEED_OP(x)      ((void) 0)
> > > > +#undef HAVE_TEST_IP
> > > > +#undef HAVE_ANY_OP
> > > > +
> > > > +#endif /* LZO1X_DECOMPRESS_SAFE */
> > >
> > > ... ugh. Yes, extracting the common stuff between the _safe and _unsafe
> > > variants in a common low-level __lzo1x_decompress kind of function
> > > definitely looks doable. The low-level function could simply take an extra
> > > argument (say, set by the _safe and _unsafe wrappers) that tells it
> > > whether it is being called as safe or unsafe ... helps us get rid of the
> > > disruptions to all the Makefiles above and these #ifdef's ugliness ...
> >
> > I suspect it will probably damage performance unless the compiler is
> > very clever and I don't trust compilers that much...
>
> +1. I looked into Satyam suggestion as above but ...yes, we should not
> leave everything to compiler.  And since all this was suggested just
> to do away with that symlink, I don't think this splitting work is
> worth the effort.

Not just the symlink ... we get rid of the changes in the two Makefiles,
the -D...SAFE stuff, some #ifdef's _and_ the macros listed above. Code
becomes even smaller and simpler. But yes, as I said, there'd be an
extra condition tested by the _unsafe variant (and *only* the _unsafe
variant, I must add) at the locations of these macros that was compiled
away previously. As for performance hit, I'd be interested in actually
measuring it first ... I definitely wouldn't mind trading off a couple of %
for a simpler and smaller patch.

But if you don't want even _that_ performance hit, you could also
simply duplicate the decompress() like Richard has done.

> For rigous testing, I have sent 'compress-test' module (with usage) to
> Bret Towe who has 64-bit machines available for testing.

This test module isn't so performance benchmarking friendly, good
enough for checking correctness of the algorithm implementation and
robustness of the code. But I think Richard's cryptoapi glue code patch
would work for your version too, as both your interfaces are the same,
so that'd be a better way to benchmark the relative performance of
your patch vs his. If you can test/benchmark both your versions and
produce results that beat his code, you've made it :-)
