Return-Path: <linux-kernel-owner+w=401wt.eu-S1754202AbYJHEyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202AbYJHEyv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 00:54:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750903AbYJHEyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 00:54:43 -0400
Received: from smtp114.mail.mud.yahoo.com ([209.191.84.67]:34180 "HELO
	smtp114.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750867AbYJHEym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 00:54:42 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Xxf/pvSBpLDAs1KZcAv3yOFJihvg7G4gf07PIthVFA8BTEp/bqd4PlzcvE76yxYcbQ8tnkwwLKHV2t6DKUqFYTzjTUIsxK52qszo5yAyMVxESPBhppRToLJkb7Qz2aBZwP0M8IdwUzqRhfrxfuCyaTNbXisqdJvIwuugaAyfsHc=  ;
X-YMail-OSG: LF7QcKcVM1n_3VRund7tsUOcbwmsLyY0pkKDXXSLSC2SRt2otFnTeIJA6EvmNaFc7TzrfUbflgsQRYGoUqdYWyCOZd6mS3nini55khms55hrT2uz5KQt7ae9susM1D8PF9eWmhs_SScZo55awE5nDIAho53IWfxgBZsbS6LR0r3h2SUVJ9_4O1yRJ5jU
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Matt Mackall <mpm@selenic.com>
Subject: Re: [BUG] SLOB's krealloc() seems bust
Date: Wed, 8 Oct 2008 15:54:33 +1100
User-Agent: KMail/1.9.5
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-mm <linux-mm@kvack.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       akpm <akpm@linuxfoundation.org>
References: <1223387841.26330.36.camel@lappy.programming.kicks-ass.net> <200810081522.31739.nickpiggin@yahoo.com.au> <1223441190.13453.459.camel@calx>
In-Reply-To: <1223441190.13453.459.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810081554.33651.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 October 2008 15:46, Matt Mackall wrote:
> On Wed, 2008-10-08 at 15:22 +1100, Nick Piggin wrote:
> > On Wednesday 08 October 2008 10:08, Matt Mackall wrote:
> > > On Tue, 2008-10-07 at 20:31 +0300, Pekka Enberg wrote:
> > > > Hi Matt,
> > > >
> > > > On Tue, Oct 7, 2008 at 8:13 PM, Matt Mackall <mpm@selenic.com> wrote:
> > > > >> > @@ -515,7 +515,7 @@
> > > > >> >
> > > > >> >        sp = (struct slob_page *)virt_to_page(block);
> > > > >> >        if (slob_page(sp))
> > > > >> > -               return ((slob_t *)block - 1)->units + SLOB_UNIT;
> > > > >> > +               return (((slob_t *)block - 1)->units - 1) *
> > > > >> > SLOB_UNIT;
> > > > >>
> > > > >> Hmm. I don't understand why we do the "minus one" thing here.
> > > > >> Aren't we underestimating the size now?
> > > > >
> > > > > The first -1 takes us to the object header in front of the object
> > > > > pointer. The second -1 subtracts out the size of the header.
> > > > >
> > > > > But it's entirely possible I'm off by one, so I'll double-check.
> > > > > Nick?
> > > >
> > > > Yeah, I was referring to the second subtraction. Looking at
> > > > slob_page_alloc(), for example, we compare the return value of
> > > > slob_units() to SLOB_UNITS(size), so I don't think we count the
> > > > header in ->units. I mean, we ought to be seeing the subtraction
> > > > elsewhere in the code as well, no?
> > >
> > > Ok, I've looked a bit closer at it and I think we need a different fix.
> > >
> > > The underlying allocator, slob_alloc, takes a size in bytes and returns
> > > an object of that size, with the first word containing the number of
> > > slob_t units.
> > >
> > > kmalloc calls slob_alloc after adding on some space for header and
> > > architecture padding. This space is not necessarily 1 slob unit:
> > >
> > >         unsigned int *m;
> > >         int align = max(ARCH_KMALLOC_MINALIGN, ARCH_SLAB_MINALIGN);
> > > ...
> > >                 m = slob_alloc(size + align, gfp, align, node);
> > >                 *m = size;
> > >  	        return (void *)m + align;
> > >
> > > Note that we overwrite the header with our own size -in bytes-.
> > > kfree does the reverse:
> >
> > Right.
> >
> > >                 int align = max(ARCH_KMALLOC_MINALIGN,
> > > ARCH_SLAB_MINALIGN); unsigned int *m = (unsigned int *)(block - align);
> > >                 slob_free(m, *m + align);
> > >
> > > That second line is locating the kmalloc header. All looks good.
> > >
> > > The MINALIGN business was introduced by Nick with:
> > >
> > >  slob: improved alignment handling
> > >
> > > but seems to have missed ksize, which should now be doing the following
> > > to match:
> > >
> > > diff -r 5e32b09a1b2b mm/slob.c
> > > --- a/mm/slob.c	Fri Oct 03 14:04:43 2008 -0500
> > > +++ b/mm/slob.c	Tue Oct 07 18:05:15 2008 -0500
> > > @@ -514,9 +514,11 @@
> > >  		return 0;
> > >
> > >  	sp = (struct slob_page *)virt_to_page(block);
> > > -	if (slob_page(sp))
> > > -		return ((slob_t *)block - 1)->units + SLOB_UNIT;
> > > -	else
> > > +	if (slob_page(sp)) {
> > > +		int align = max(ARCH_KMALLOC_MINALIGN, ARCH_SLAB_MINALIGN);
> > > +		unsigned int *m = (unsigned int *)(block - align);
> > > +		return SLOB_UNITS(*m); /* round up */
> > > +	} else
> > >  		return sp->page.private;
> > >  }
> >
> > Yes, I came up with nearly the same patch before reading this
> >
> > --- linux-2.6/mm/slob.c 2008-10-08 14:43:17.000000000 +1100
> > +++ suth/mm/slob.c      2008-10-08 15:11:06.000000000 +1100
> > @@ -514,9 +514,11 @@ size_t ksize(const void *block)
> >                 return 0;
> >
> >         sp = (struct slob_page *)virt_to_page(block);
> > -       if (slob_page(sp))
> > -               return (((slob_t *)block - 1)->units - 1) * SLOB_UNIT;
> > -       else
> > +       if (slob_page(sp)) {
> > +               int align = max(ARCH_KMALLOC_MINALIGN,
> > ARCH_SLAB_MINALIGN); +               unsigned int *m = (unsigned int
> > *)(block - align); +               return *m + align;
> > +       } else
> >                 return sp->page.private;
> >  }
> >
> > However, mine is lifted directly from kfree, wheras you do something a
> > bit different. Hmm, ksize arguably could be used to find the underlying
> > allocated slab size in order to use a little bit more than we'd asked
> > for. So probably we should really just `return *m` (don't round up or
> > add any padding).
>
> Huh? ksize should report how much space is available in the buffer. If
> we request 33 bytes from SLUB and it gives us 64, ksize reports 64. If
> we request 33 bytes from SLOB and it gives us 34, we should report 34.

Oh.. hmm yeah right, I didn't realise what you were doing there.
OK, so your patch looks good to me then (provided it is diffed against
the previous one, for Linus).


> > > That leaves the question of why this morning's patch worked at all,
> > > given that it was based on how SLOB worked before Nick's patch. But I
> > > haven't finished working through that. Peter, can I get you to test the
> > > above?
> >
> > I didn't have ksize in my slob user test harness, but added a couple of
> > tests in there, and indeed ksize was returning complete garbage both
> > before and after the latest patch to slob. I'd say it was simply luck.
>
> I was going to dig your harness up this morning and realized it was on
> my dead laptop. Send me another copy?

OK, off-list.
