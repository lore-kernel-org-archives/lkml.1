Return-Path: <linux-kernel-owner+w=401wt.eu-S1756559AbYJGRQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559AbYJGRQ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 13:16:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753946AbYJGRQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 13:16:36 -0400
Received: from waste.org ([66.93.16.53]:37007 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753477AbYJGRQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 13:16:35 -0400
Subject: Re: [BUG] SLOB's krealloc() seems bust
From: Matt Mackall <mpm@selenic.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-mm <linux-mm@kvack.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       akpm <akpm@linuxfoundation.org>
In-Reply-To: <84144f020810070957y241a16d6y2d03f451aa3dd4a7@mail.gmail.com>
References: <1223387841.26330.36.camel@lappy.programming.kicks-ass.net>
	 <48EB6D2C.30806@linux-foundation.org> <1223391655.13453.344.camel@calx>
	 <1223395846.26330.55.camel@lappy.programming.kicks-ass.net>
	 <1223397455.13453.385.camel@calx>
	 <84144f020810070957y241a16d6y2d03f451aa3dd4a7@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 07 Oct 2008 12:13:39 -0500
Message-Id: <1223399619.13453.389.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-10-07 at 19:57 +0300, Pekka Enberg wrote:
> Hi Matt,
> 
> On Tue, Oct 7, 2008 at 7:37 PM, Matt Mackall <mpm@selenic.com> wrote:
> > SLOB: fix bogus ksize calculation
> >
> > SLOB's ksize calculation was braindamaged and generally harmlessly
> > underreported the allocation size. But for very small buffers, it could
> > in fact overreport them, leading code depending on krealloc to overrun
> > the allocation and trample other data.
> >
> > Signed-off-by: Matt Mackall <mpm@selenic.com>
> > Tested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> >
> > diff -r 5e32b09a1b2b mm/slob.c
> > --- a/mm/slob.c Fri Oct 03 14:04:43 2008 -0500
> > +++ b/mm/slob.c Tue Oct 07 11:27:47 2008 -0500
> > @@ -515,7 +515,7 @@
> >
> >        sp = (struct slob_page *)virt_to_page(block);
> >        if (slob_page(sp))
> > -               return ((slob_t *)block - 1)->units + SLOB_UNIT;
> > +               return (((slob_t *)block - 1)->units - 1) * SLOB_UNIT;
> 
> Hmm. I don't understand why we do the "minus one" thing here. Aren't
> we underestimating the size now?

The first -1 takes us to the object header in front of the object
pointer. The second -1 subtracts out the size of the header.

But it's entirely possible I'm off by one, so I'll double-check. Nick?

-- 
Mathematics is the supreme nostalgia of our time.

