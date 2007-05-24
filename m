Return-Path: <linux-kernel-owner+w=401wt.eu-S1751426AbXEXOU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751426AbXEXOU1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 10:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750786AbXEXOUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 10:20:16 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:56186 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbXEXOUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 10:20:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fkjvy+VuQ+TOwDroLUIQklBd2x2QG3bysNAKe0SMvatYEGZDEy9mfu9ohJfvKpOsQfigwB3sJxtcUXde7kMb3vPQwcJQRb4GuaczMjsfIOEu/c0ZqZl376qogHiQmrEkBfw4EwGvKBRpCESgpC5A4U5Th9dCmFBcArZRPicfCtk=
Message-ID: <4cefeab80705240720s2c047979r27f3d9433ebeac80@mail.gmail.com>
Date: Thu, 24 May 2007 19:50:02 +0530
From: "Nitin Gupta" <nitingupta910@gmail.com>
To: "Richard Purdie" <richard@openedhand.com>
Subject: Re: [RFC] LZO de/compression support - take 3
Cc: "Satyam Sharma" <satyam.sharma@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm-cc@laptop.org, "Bret Towe" <magnade@gmail.com>
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

On 5/24/07, Richard Purdie <richard@openedhand.com> wrote:
> On Thu, 2007-05-24 at 01:04 +0530, Satyam Sharma wrote:
> > On 5/23/07, Nitin Gupta <nitingupta910@gmail.com> wrote:
>
<snip>

> I remember this being mentioned. My answer was that this is the same
> behaviour as the zlib library and you do not want to alloc/free this
> memory every time you have a piece of data to compress as it will
> totally cripple performance. This allocation of buffers is a standard
> part of the crypto and jffs2 compression APIs too.
>

This is why there are no wrappers for this LZO -- in compressed
caching also we have wrappers that take care of this. I don't think
anyone will want to alloc/free for every compression they do.   So I
am just going to leave code without wrappers.

> > I just read the follow-ups to this, so perhaps we /can/ use the unsafe
> > versions in certain situations. But I agree with Michael's suggestion
> > to rename _safe to decompress and decompress to _unsafe ...
>
> Lets just add the _unsafe postfix and leave "safe" alone, then it
> remains the same name as userspace and will be less confusing for anyone
> used to the userspace library ;-).

Ok - will do this :)

>
> > Hmmm, perhaps you could extract the common stuff between the
> > _safe and _unsafe versions out into a separate function and then
> > reuse it from _safe and _unsafe wrappers? In any case, this kind
> > of Makefile jugglery (even in the master Makefile) just to avoid the
> > above doesn't seem quite right ...
>
> FWIW, I don't like the symlink much either. My version of the patch
> doesn't do things that way.

You have duplicated decompress code twice! Although this will do away
with symlink but I was wondering if a symlink is really that bad!

> > > diff --git a/lib/lzo1x/lzo1x_int.h b/lib/lzo1x/lzo1x_int.h
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
>


+1. I looked into Satyam suggestion as above but ...yes, we should not
leave everything to compiler.  And since all this was suggested just
to do away with that symlink, I don't think this splitting work is
worth the effort.


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
> * the performance implications of the rewrite are unknown
>

I agree with your points - there can surely be bugs in my porting work
since it involves too many chages. But considering that the port is
just ~500 lines, if we can fix it and optimize to get
comparable/better perf. results than original one, we will end up with
much cleaner and smaller code.

For rigous testing, I have sent 'compress-test' module (with usage) to
Bret Towe who has 64-bit machines available for testing.

> In theory both sets of code should result in the output bytecode if the
> compiler does its job properly. Ideally I'd like to compare the
> performance of them as well as have a look at the code. I'm not quite
> sure when I'm going to have time for this though :/.
>
> Also, I did notice you had the error defines in two header files. They
> should only exist in one place and the LZO implementation should be
> including the copy in linux/.
>

Ah! I now notice them -- will keep the copy in linux/lzo1x.h only.

Thanks for your comments.

- Nitin
