Return-Path: <linux-kernel-owner+w=401wt.eu-S1758320AbXEXKt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758320AbXEXKt3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 06:49:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754443AbXEXKtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 06:49:21 -0400
Received: from wr-out-0506.google.com ([64.233.184.236]:31651 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754478AbXEXKtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 06:49:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WsEC4hRstVTaA6gVxMq7Q+DKUYy4fudgrygqE+8dc6M7Usj9XTS5xXgivAfA1TuQV3CdZtZRPu/2zbJf885t0HAUE5uvF0RV436coCaPs0aRo7P8nmQsD3CqbM2s76BHqNxAGHSn9O8Jz6ip0jsGj/Ntae3EZrHQue0WllZxMpM=
Message-ID: <a781481a0705240349n190becbcvb04245ef1ed4565a@mail.gmail.com>
Date: Thu, 24 May 2007 16:19:19 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Nitin Gupta" <nitingupta910@gmail.com>
Subject: Re: [RFC] LZO de/compression support - take 3
Cc: linux-kernel@vger.kernel.org, "Richard Purdie" <richard@openedhand.com>,
       linux-mm-cc@laptop.org
In-Reply-To: <4cefeab80705232137o4607b740yfa9bfe2fe4ec1b21@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4cefeab80705230127r58e8f9e1sa644092e95eb81eb@mail.gmail.com>
	 <a781481a0705231234m62327134mbfd1c1478b6fb99a@mail.gmail.com>
	 <4cefeab80705232137o4607b740yfa9bfe2fe4ec1b21@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/24/07, Nitin Gupta <nitingupta910@gmail.com> wrote:
> On 5/24/07, Satyam Sharma <satyam.sharma@gmail.com> wrote:
> > [...]
> > Just defining and exporting LZO1X_WORKMEM_SIZE may not be enough
> > to guarantee that users _will_ pass in workmem of size exactly that much.
> >
> > If this workmem is really merely a temp buffer required by lzo1x_compress(),
> > I'd suggest you rename lzo1x_compress() in lzo1x_compress.c to
> > __lzo1x_compress(), and implement a lzo1x_compress() wrapper for the
> > user that handles the allocation (and subsequent free'ing) of this temp
> > buffer itself.
> >
>
> I did not include such wrapper since allocation method will depend on
> particular scenario (like kmalloc vs. vmalloc and flags GFP_KERNEL vs
> GFP_ATOMIC etc...). But still maybe we can have "default" wrapper that
> does, say vmalloc(GFP_KERNEL)/vfree and let others with specific
> requirement have their own wrappers.

Actually, the problem with my recommendation (see Richard's response
on this thread too) is performance degradation, because we're
allocating / freeing memory on every compress() call -- so just ignore this
recommendation. But we can do better (see below) ...

> > [ I vaguely remember discussing something of this sort with Richard
> > when he had submitted his patchset too, perhaps you can look into
> > his implementation to see how he's managing this ... ]
> >
>
> ok.

Ok, I remember that discussion with Richard now. It was regarding the
JFFS2 glue code, actually. To avoid repeated allocation and free() of
the workspace memory, allocate a static global workspace of required
size for ourselves at module init time itself, and introduce a simple
spinlock to protect tht buffer and synchronize between concurrent calls
to lzo1x_compress(). There'd be no slowdown for single users of
lzo1x_compress(), but concurrent users (wonder how many there'd be)
would need to wait on the spinlock. You can consider a similar approach
for the /lib/lzo code too, if you want.

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
> > disruptions to all the Makefiles above and these #ifdef's ugliness ..
>
> Hmm..I will try to get this done.

Yes, like you said, both the versions have common macro's (defined
differently for the safe and unsafe cases) sprinkled in them. We can
take care of that by the following common definitions:

#define TEST_IP        (!safe || (ip < ip_end))
#define NEED_IP(x) \
       if (safe && ((size_t)(ip_end - ip) < (size_t)(x))) goto input_overrun
#define NEED_OP(x) \
       if (safe && ((size_t)(op_end - op) < (size_t)(x))) goto output_overrun
#define TEST_LB(m_pos) \
       if (safe && (m_pos < out || m_pos >= op)) goto lookbehind_overrun

In fact this makes the macros independent of SAFE or !SAFE compile
options, so you may simply even get rid of them altogether if you want ...

However, as Richard mentioned in his follow-up, this introduces a
condition test for even the _unsafe versions where there was previously
none because of the macros simply getting compiled away. Keeping
the safe test (the argument passed to the low-level function by the
_safe and _unsafe wrappers as 1 or 0) first in the condition would
definitely help, but if we're really bothered with even that performance
compromise (can do tests to find out how much), why not just go ahead
and duplicate those few lines of common code! Still beats the symlink
and Makefile "prepare" things.

> > BTW, it'd be really cool if Richard and yourself could get together and
> > pool your energies / efforts to develop a common / same patchset for this.
> > (I wonder how different your implementations are, actually, and if there
> > are any significant performance disparities, especially.) I really like your
> > work, as it clears up the major gripe I had with Richard's patchset -- the
> > ugliness (and monstrosity) of it.
>
> I am really looking forward to co-operating with Richard regarding
> this - although our approach for this porting is quite different but I
> hope we can get around this. Duplication sucks!  :)

Yeah, hope you guys can come up with a single best version.

Satyam
