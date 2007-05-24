Return-Path: <linux-kernel-owner+w=401wt.eu-S1757379AbXEXLHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379AbXEXLHp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 07:07:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755982AbXEXLHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 07:07:38 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:33375 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755805AbXEXLHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 07:07:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oGPIDlyIBIH1Is/YhAkutlZUweA05z/+Y6hbLvR2ZTcnI656zBnl+R0cF66Oim8u773MDJPukI5u/oW9WaGfyMc3JPIA5+ECManRpFLfVkmgCQySERv5rCLbKOuL/DOyvPFUbSuLCoqC2iX7hQprGt+ddBHKxNzK+VFf8i3DWeo=
Message-ID: <a781481a0705240407p2e9933ecm8d2c9863465cdeac@mail.gmail.com>
Date: Thu, 24 May 2007 16:37:35 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Richard Purdie" <richard@openedhand.com>
Subject: Re: [RFC] LZO de/compression support - take 3
Cc: "Nitin Gupta" <nitingupta910@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm-cc@laptop.org
In-Reply-To: <1179995105.5880.7.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4cefeab80705230127r58e8f9e1sa644092e95eb81eb@mail.gmail.com>
	 <a781481a0705231234m62327134mbfd1c1478b6fb99a@mail.gmail.com>
	 <1179995105.5880.7.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On 5/24/07, Richard Purdie <richard@openedhand.com> wrote:
> On Thu, 2007-05-24 at 01:04 +0530, Satyam Sharma wrote:
> > On 5/23/07, Nitin Gupta <nitingupta910@gmail.com> wrote:
> > > [...]
> > > +/* Macros for 'safe' decompression */
> > > +#ifdef LZO1X_DECOMPRESS_SAFE
> > > +
> > > +#define lzo1x_decompress lzo1x_decompress_safe
> > > +#define TEST_IP        (ip < ip_end)
> > > +#define NEED_IP(x) \
> > > +       if ((size_t)(ip_end - ip) < (size_t)(x)) goto input_overrun
> > > +#define NEED_OP(x) \
> > > +       if ((size_t)(op_end - op) < (size_t)(x)) goto output_overrun
> > > +#define TEST_LB(m_pos) \
> > > +       if (m_pos < out || m_pos >= op) goto lookbehind_overrun
> > > +#define HAVE_TEST_IP
> > > +#define HAVE_ANY_OP
> > > +
> > > +#else  /* !LZO1X_DECOMPRESS_SAFE */
> > > +
> > > +#define        TEST_IP         1
> > > +#define        TEST_LB(x)      ((void) 0)
> > > +#define        NEED_IP(x)      ((void) 0)
> > > +#define        NEED_OP(x)      ((void) 0)
> > > +#undef HAVE_TEST_IP
> > > +#undef HAVE_ANY_OP
> > > +
> > > +#endif /* LZO1X_DECOMPRESS_SAFE */
> >
> > ... ugh. Yes, extracting the common stuff between the _safe and _unsafe
> > variants in a common low-level __lzo1x_decompress kind of function
> > definitely looks doable. The low-level function could simply take an extra
> > argument (say, set by the _safe and _unsafe wrappers) that tells it
> > whether it is being called as safe or unsafe ... helps us get rid of the
> > disruptions to all the Makefiles above and these #ifdef's ugliness ...
>
> I suspect it will probably damage performance unless the compiler is
> very clever and I don't trust compilers that much...

Hmm. The wrappers would clearly be inline, but if we want a common
low-level decompress function, we'd also need to introduce the "if (safe &&)"
kind of tests for those differently-defined macros which could impact
performance (for the _unsafe variant only, isn't it). By how much is the
question, and whether we really care to avoid duplicating 50 lines of code
to take that hit on the unsafe function (or vice versa).

> > BTW, it'd be really cool if Richard and yourself could get together and
> > pool your energies / efforts to develop a common / same patchset for this.
> > (I wonder how different your implementations are, actually, and if there
> > are any significant performance disparities, especially.) I really like your
> > work, as it clears up the major gripe I had with Richard's patchset -- the
> > ugliness (and monstrosity) of it. But he's also worked up the glue code for
> > cryptoapi / jffs2 etc for this, so no point duplicating his efforts.
>
> All I will add is that after the amendment I made, the ugliness in my
> patchset is confined to one file now and I still think its the better
> approach to take.
>
> My main concerns with this patch are that:
> * from the security point of view its not tried and tested code
> * I'm not 100% confident in what Nitin has done with the code from a
>   buffer overflow/security PoV
> * its not tested on many architectures

Right, it needs testing (for correctness and robustness). But that
shouldn't be too difficult -- Nitin, you could just write up a simple test
module that others can use with your patch to do testing on their
arch's ... the more this gets tested, the better chances it's got.

> * the performance implications of the rewrite are unknown
>
> In theory both sets of code should result in the output bytecode if the
> compiler does its job properly. Ideally I'd like to compare the
> performance of them as well as have a look at the code. I'm not quite
> sure when I'm going to have time for this though :/.

Yes, performance disparities (if any) would be most important, IMO.

> Also, I did notice you had the error defines in two header files. They
> should only exist in one place and the LZO implementation should be
> including the copy in linux/.

Satyam
