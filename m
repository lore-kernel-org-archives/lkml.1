Return-Path: <linux-kernel-owner+w=401wt.eu-S1755123AbYJHFLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123AbYJHFLr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 01:11:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750888AbYJHFLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 01:11:40 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:39766 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750821AbYJHFLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 01:11:39 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=0avESXwS/5BggCkDY4prXkmBolOHCwyqolXuX5OxEzMoP9NeHXdXJzic6fokKdLBby6qTXJtQSQL/dBpptMdtIYsbl08sdf7QnzIqhiOZbHz/dcyFyBpkYS2pte+E3JV5bfDIYOL7wIN3s+yl7KodzIMxoQF5vLwWbhSq1R3MP0=  ;
X-YMail-OSG: Qow8p2wVM1kryilcjcF_4LPtA2Kpeu7315T5J_GxFPMGLfAb.oSKV.lodYTuh9XYg37ZAeopyrl5QGRzQdmcsShPTzuukKFooSGgoilLwYXWkdS8.p70.2GYjwFBaKo7wBmX8N2N4ScdAGmyeKeAYeTuSzgr.mOwu7nLovqAqg--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Matt Mackall <mpm@selenic.com>
Subject: Re: [BUG] SLOB's krealloc() seems bust
Date: Wed, 8 Oct 2008 16:11:30 +1100
User-Agent: KMail/1.9.5
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-mm <linux-mm@kvack.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       akpm <akpm@linuxfoundation.org>
References: <1223387841.26330.36.camel@lappy.programming.kicks-ass.net> <1223441190.13453.459.camel@calx> <200810081554.33651.nickpiggin@yahoo.com.au>
In-Reply-To: <200810081554.33651.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810081611.30897.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 October 2008 15:54, Nick Piggin wrote:
> On Wednesday 08 October 2008 15:46, Matt Mackall wrote:
> > On Wed, 2008-10-08 at 15:22 +1100, Nick Piggin wrote:
> > > On Wednesday 08 October 2008 10:08, Matt Mackall wrote:

> > > > diff -r 5e32b09a1b2b mm/slob.c
> > > > --- a/mm/slob.c	Fri Oct 03 14:04:43 2008 -0500
> > > > +++ b/mm/slob.c	Tue Oct 07 18:05:15 2008 -0500
> > > > @@ -514,9 +514,11 @@
> > > >  		return 0;
> > > >
> > > >  	sp = (struct slob_page *)virt_to_page(block);
> > > > -	if (slob_page(sp))
> > > > -		return ((slob_t *)block - 1)->units + SLOB_UNIT;
> > > > -	else
> > > > +	if (slob_page(sp)) {
> > > > +		int align = max(ARCH_KMALLOC_MINALIGN, ARCH_SLAB_MINALIGN);
> > > > +		unsigned int *m = (unsigned int *)(block - align);
> > > > +		return SLOB_UNITS(*m); /* round up */
> > > > +	} else
> > > >  		return sp->page.private;
> > > >  }
> > >
> > > Yes, I came up with nearly the same patch before reading this
> > >
> > > --- linux-2.6/mm/slob.c 2008-10-08 14:43:17.000000000 +1100
> > > +++ suth/mm/slob.c      2008-10-08 15:11:06.000000000 +1100
> > > @@ -514,9 +514,11 @@ size_t ksize(const void *block)
> > >                 return 0;
> > >
> > >         sp = (struct slob_page *)virt_to_page(block);
> > > -       if (slob_page(sp))
> > > -               return (((slob_t *)block - 1)->units - 1) * SLOB_UNIT;
> > > -       else
> > > +       if (slob_page(sp)) {
> > > +               int align = max(ARCH_KMALLOC_MINALIGN,
> > > ARCH_SLAB_MINALIGN); +               unsigned int *m = (unsigned int
> > > *)(block - align); +               return *m + align;
> > > +       } else
> > >                 return sp->page.private;
> > >  }
> > >
> > > However, mine is lifted directly from kfree, wheras you do something a
> > > bit different. Hmm, ksize arguably could be used to find the underlying
> > > allocated slab size in order to use a little bit more than we'd asked
> > > for. So probably we should really just `return *m` (don't round up or
> > > add any padding).
> >
> > Huh? ksize should report how much space is available in the buffer. If
> > we request 33 bytes from SLUB and it gives us 64, ksize reports 64. If
> > we request 33 bytes from SLOB and it gives us 34, we should report 34.
>
> Oh.. hmm yeah right, I didn't realise what you were doing there.
> OK, so your patch looks good to me then (provided it is diffed against
> the previous one, for Linus).

OK, no, that's why I got confused. SLOB_UNITS will round you up to the
next SLOB_UNIT. You'd then have to multiply by SLOB_UNIT to get back to
bytes.
