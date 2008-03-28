Return-Path: <linux-kernel-owner+w=401wt.eu-S1758000AbYC1T1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758000AbYC1T1Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 15:27:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754233AbYC1T06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 15:26:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51906 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757512AbYC1T05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 15:26:57 -0400
Date: Fri, 28 Mar 2008 12:25:57 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pawel Staszewski <pstaszewski@artcom.pl>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: 2.6.25-rc7-git2: Reported regressions from 2.6.24
In-Reply-To: <Pine.LNX.4.64.0803281128480.17805@schroedinger.engr.sgi.com>
Message-ID: <alpine.LFD.1.00.0803281214580.14670@woody.linux-foundation.org>
References: <200803272353.51901.rjw@sisk.pl> <alpine.LFD.1.00.0803271859280.14670@woody.linux-foundation.org> <Pine.LNX.4.64.0803272002090.11979@schroedinger.engr.sgi.com> <alpine.LFD.1.00.0803272050290.14670@woody.linux-foundation.org>
 <Pine.LNX.4.64.0803281128480.17805@schroedinger.engr.sgi.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 28 Mar 2008, Christoph Lameter wrote:
> 
> prep_zero_page does:
> 
> static inline void prep_zero_page(struct page *page, int order, gfp_t  gfp_flags)
> {
>         int i;
> 
>         /*
>          * clear_highpage() will use KM_USER0, so it's a bug to use __GFP_ZERO
>          * and __GFP_HIGHMEM from hard or soft interrupt context.
>          */
>         VM_BUG_ON((gfp_flags & __GFP_HIGHMEM) && in_interrupt());
>         for (i = 0; i < (1 << order); i++)
>                 clear_highpage(page + i);

.. and clear_highpage() does:

	void *kaddr = kmap_atomic(page, KM_USER0);
	clear_page(kaddr);

.. where kmap_atomic() on x86 does:

	kmap_atomic() ->
	  kmap_atomic_prot() ->
	    debug_kmap_atomic_prot() ->
	      if (in_irq())
	        WARN_ON_ONCE()

none of which are at all conditional on __GFP_HIGHMEM.

But none of this is relevant. The warning possibly didn't even come from 
slub, it just made me look at it - because *something* is doing GFP_ATOMIC 
together with __GFP_ZERO, and it became obvious that SLUB is one potential 
cause of that.

And the SLUB case simply isn't valid!

> Then clear_highpage calls additional checking functions that have 
> the effect of generally forbiding zeroing in interrupt context if 
> CONFIG_HIGHMEM is set. This is wrong and needs to be fixed.

No. Dammit, the bug is in SLUB.

If SLUB *ever* calls the page allocator with __GFP_ZERO set, it's a 
bug, and that has nothing to do with GFP_ATOMIC or anything else. Because 
SLUB uses its own logic for clearing the result.

Why cannot you just admit it?

Now, _outside_ of SLUB there appear to be other users too, and those users 
need to either be fixed or we need to allow __GFP_ZERO togethe with 
GFP_ATOMIC. But the fact is, SLUB had a really stupid bug that it 
shouldn't have had.

		Linus
