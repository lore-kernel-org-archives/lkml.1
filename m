Return-Path: <linux-kernel-owner+w=401wt.eu-S1759572AbXEXIZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759572AbXEXIZz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 04:25:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755952AbXEXIZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 04:25:48 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:50465 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755649AbXEXIZq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 04:25:46 -0400
Subject: Re: [RFC] LZO de/compression support - take 3
From: Richard Purdie <richard@openedhand.com>
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: Nitin Gupta <nitingupta910@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm-cc@laptop.org
In-Reply-To: <a781481a0705231234m62327134mbfd1c1478b6fb99a@mail.gmail.com>
References: <4cefeab80705230127r58e8f9e1sa644092e95eb81eb@mail.gmail.com>
	 <a781481a0705231234m62327134mbfd1c1478b6fb99a@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 24 May 2007 09:25:05 +0100
Message-Id: <1179995105.5880.7.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-24 at 01:04 +0530, Satyam Sharma wrote: 
> On 5/23/07, Nitin Gupta <nitingupta910@gmail.com> wrote:
> > diff --git a/include/linux/lzo1x.h b/include/linux/lzo1x.h
> > [...]
> > +/* Size of temp buffer (workmem) required by lzo1x_compress */
> > +#define LZO1X_WORKMEM_SIZE     ((size_t) (16384L * sizeof(unsigned char *)))
> > +
> > +/*
> > + * This required 'workmem' of size LZO1X_WORKMEM_SIZE
> > + */
> > +int lzo1x_compress(const unsigned char *src, size_t src_len,
> > +               unsigned char *dst, size_t *dst_len,
> > +               void *workmem);
> 
> Just defining and exporting LZO1X_WORKMEM_SIZE may not be enough
> to guarantee that users _will_ pass in workmem of size exactly that much.
> 
> If this workmem is really merely a temp buffer required by lzo1x_compress(),
> I'd suggest you rename lzo1x_compress() in lzo1x_compress.c to
> __lzo1x_compress(), and implement a lzo1x_compress() wrapper for the
> user that handles the allocation (and subsequent free'ing) of this temp
> buffer itself.
> 
> [ I vaguely remember discussing something of this sort with Richard
> when he had submitted his patchset too, perhaps you can look into
> his implementation to see how he's managing this ... ]

I remember this being mentioned. My answer was that this is the same
behaviour as the zlib library and you do not want to alloc/free this
memory every time you have a piece of data to compress as it will
totally cripple performance. This allocation of buffers is a standard
part of the crypto and jffs2 compression APIs too.

> I just read the follow-ups to this, so perhaps we /can/ use the unsafe
> versions in certain situations. But I agree with Michael's suggestion
> to rename _safe to decompress and decompress to _unsafe ...

Lets just add the _unsafe postfix and leave "safe" alone, then it
remains the same name as userspace and will be less confusing for anyone
used to the userspace library ;-).

> > diff --git a/lib/lzo1x/Makefile b/lib/lzo1x/Makefile
> > [...]
> > +#
> > +# When compiling this module out of tree, do 'make prepare_lzo'
> > +# before compiling as usual
> > +#
> > +obj-$(CONFIG_LZO1X) += lzo1x.o
> > +CFLAGS_lzo1x_decompress_safe.o += -DLZO1X_DECOMPRESS_SAFE
> > +lzo1x-objs := lzo1x_compress.o lzo1x_decompress.o lzo1x_decompress_safe.o
> > +
> > +prepare_lzo:
> > +       @ln -sf lzo1x_decompress.c lzo1x_decompress_safe.c
> > +
> 
> ... ah, so that's why the master Makefile changes.
> 
> Hmmm, perhaps you could extract the common stuff between the
> _safe and _unsafe versions out into a separate function and then
> reuse it from _safe and _unsafe wrappers? In any case, this kind
> of Makefile jugglery (even in the master Makefile) just to avoid the
> above doesn't seem quite right ...

FWIW, I don't like the symlink much either. My version of the patch
doesn't do things that way.

> > diff --git a/lib/lzo1x/lzo1x_decompress.c b/lib/lzo1x/lzo1x_decompress.c
> > [...]
> > +#if defined(LZO1X_DECOMPRESS_SAFE)
> > +input_overrun:
> > +    *out_len = (size_t)(op - out);
> > +    return LZO_E_INPUT_OVERRUN;
> > +
> > +output_overrun:
> > +    *out_len = (size_t)(op - out);
> > +    return LZO_E_OUTPUT_OVERRUN;
> > +
> > +lookbehind_overrun:
> > +    *out_len = (size_t)(op - out);
> > +    return LZO_E_LOOKBEHIND_OVERRUN;
> > +#endif
> > +}
> > +
> > +EXPORT_SYMBOL(lzo1x_decompress);
> 
> Ok, so this is all there is between _safe and _unsafe, it seems ...

No, since there is some ifdefs in the header file.

> > diff --git a/lib/lzo1x/lzo1x_int.h b/lib/lzo1x/lzo1x_int.h
> > [...]
> > +/* Macros for 'safe' decompression */
> > +#ifdef LZO1X_DECOMPRESS_SAFE
> > +
> > +#define lzo1x_decompress lzo1x_decompress_safe
> > +#define TEST_IP        (ip < ip_end)
> > +#define NEED_IP(x) \
> > +       if ((size_t)(ip_end - ip) < (size_t)(x)) goto input_overrun
> > +#define NEED_OP(x) \
> > +       if ((size_t)(op_end - op) < (size_t)(x)) goto output_overrun
> > +#define TEST_LB(m_pos) \
> > +       if (m_pos < out || m_pos >= op) goto lookbehind_overrun
> > +#define HAVE_TEST_IP
> > +#define HAVE_ANY_OP
> > +
> > +#else  /* !LZO1X_DECOMPRESS_SAFE */
> > +
> > +#define        TEST_IP         1
> > +#define        TEST_LB(x)      ((void) 0)
> > +#define        NEED_IP(x)      ((void) 0)
> > +#define        NEED_OP(x)      ((void) 0)
> > +#undef HAVE_TEST_IP
> > +#undef HAVE_ANY_OP
> > +
> > +#endif /* LZO1X_DECOMPRESS_SAFE */
> 
> ... ugh. Yes, extracting the common stuff between the _safe and _unsafe
> variants in a common low-level __lzo1x_decompress kind of function
> definitely looks doable. The low-level function could simply take an extra
> argument (say, set by the _safe and _unsafe wrappers) that tells it
> whether it is being called as safe or unsafe ... helps us get rid of the
> disruptions to all the Makefiles above and these #ifdef's ugliness ...

I suspect it will probably damage performance unless the compiler is
very clever and I don't trust compilers that much...

> BTW, it'd be really cool if Richard and yourself could get together and
> pool your energies / efforts to develop a common / same patchset for this.
> (I wonder how different your implementations are, actually, and if there
> are any significant performance disparities, especially.) I really like your
> work, as it clears up the major gripe I had with Richard's patchset -- the
> ugliness (and monstrosity) of it. But he's also worked up the glue code for
> cryptoapi / jffs2 etc for this, so no point duplicating his efforts.

All I will add is that after the amendment I made, the ugliness in my
patchset is confined to one file now and I still think its the better
approach to take.

My main concerns with this patch are that:
* from the security point of view its not tried and tested code
* I'm not 100% confident in what Nitin has done with the code from a 
  buffer overflow/security PoV
* its not tested on many architectures
* the performance implications of the rewrite are unknown

In theory both sets of code should result in the output bytecode if the
compiler does its job properly. Ideally I'd like to compare the
performance of them as well as have a look at the code. I'm not quite
sure when I'm going to have time for this though :/.

Also, I did notice you had the error defines in two header files. They
should only exist in one place and the LZO implementation should be
including the copy in linux/.

Cheers,

Richard


