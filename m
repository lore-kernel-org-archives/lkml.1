Return-Path: <linux-kernel-owner+w=401wt.eu-S1761017AbZCPOxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761017AbZCPOxt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 10:53:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752391AbZCPOxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 10:53:39 -0400
Received: from waste.org ([66.93.16.53]:56765 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751794AbZCPOxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 10:53:38 -0400
Subject: Re: SLOB lockup (was: Re: [tip:core/locking] lockdep: annotate
	reclaim context (__GFP_NOFS), fix SLOB)
From: Matt Mackall <mpm@selenic.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Ingo Molnar <mingo@elte.hu>, linux-tip-commits@vger.kernel.org,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de
In-Reply-To: <200903162100.30029.nickpiggin@yahoo.com.au>
References: <20090128135457.350751756@chello.nl>
	 <200903152006.21160.nickpiggin@yahoo.com.au>
	 <1237128960.3213.133.camel@calx>
	 <200903162100.30029.nickpiggin@yahoo.com.au>
Content-Type: text/plain
Date: Mon, 16 Mar 2009 09:52:09 -0500
Message-Id: <1237215129.3213.193.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-16 at 21:00 +1100, Nick Piggin wrote:
> On Monday 16 March 2009 01:56:00 Matt Mackall wrote:
> > On Sun, 2009-03-15 at 20:06 +1100, Nick Piggin wrote:
> > > On Sunday 15 March 2009 17:48:18 Ingo Molnar wrote:
> > > > > Cc: Nick Piggin <npiggin@suse.de>
> > > > > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > > > LKML-Reference: <20090128135457.350751756@chello.nl>
> > > > > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > > >
> > > > and with this fixed, and with SLOB now being tested in -tip, the
> > > > new lockdep assert attached below (followed by a real lockup)
> > > > pops up.
> > > >
> > > > Seems like a genuine SLOB bug, probably present upstream as
> > > > well.
> > >
> > > Hmmf. debugobjects calls back into the slab allocator from the page
> > > allocator. The following patch would improve SLOB, but I think it
> > > would be a good idea to avoid a dependency in that direction. Can
> > > debugobjects defer this freeing?
> >
> > Yeah. I don't think any of the allocators are designed with recursion in
> > mind. That the others aren't (visibly) failing here is blind luck.
> >
> > Nick, not really sure what your patch is accomplishing. It narrows the
> > lock window, but it doesn't eliminate it. But I think we can take the
> > page allocator case out from under the lock entirely, no?
> 
> Oh, it was trying to accomplish exactly this, but wasn't tested (just
> for illustration).
> 
> I think Thomas's deferred freeing work should be a good way to fix this
> problem, but of course reducing locking in SLOB doesn't hurt in the
> slightest either ;)
> 
> 
> > diff -r 8e0f1cee0a71 mm/slob.c
> > --- a/mm/slob.c	Sat Jan 24 15:41:13 2009 -0600
> > +++ b/mm/slob.c	Sun Mar 15 09:50:42 2009 -0500
> > @@ -387,8 +387,6 @@
> >  	sp = (struct slob_page *)virt_to_page(block);
> >  	units = SLOB_UNITS(size);
> >
> > -	spin_lock_irqsave(&slob_lock, flags);
> > -
> >  	if (sp->units + units == SLOB_UNITS(PAGE_SIZE)) {
> >  		/* Go directly to page allocator. Do not pass slob allocator */
> >  		if (slob_page_free(sp))
> 
> This doesn't work because you have to hold the lock over the test
> otherwise another thread can concurrently meddle with sp->units.

Ahh, yes, I was glossing over that code because of the misleading
comment. I was assuming this was the case where the object itself was a
page, rather than object is the only allocation on the page. 

> For that matter my previous patch was buggy, aside from the obvious
> that Ingo pointed out, because I unlocked before removing the page
> from the freelist too.
> 
> This should be pretty close to correct ;)

Yes. Now the only question that remains is if we want to change a nearly
negligible performance improvement for a nearly negligible size
increase.

> --
> 
> Don't hold SLOB lock when freeing the page. Reduces lock hold width.
> 
> Signed-off-by: Nick Piggin <npiggin@suse.de>

Acked-by: Matt Mackall <mpm@selenic.com>

> ---
>  mm/slob.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/mm/slob.c
> ===================================================================
> --- linux-2.6.orig/mm/slob.c
> +++ linux-2.6/mm/slob.c
> @@ -393,10 +393,11 @@ static void slob_free(void *block, int s
>  		/* Go directly to page allocator. Do not pass slob allocator */
>  		if (slob_page_free(sp))
>  			clear_slob_page_free(sp);
> +		spin_unlock_irqrestore(&slob_lock, flags);
>  		clear_slob_page(sp);
>  		free_slob_page(sp);
>  		free_page((unsigned long)b);
> -		goto out;
> +		return;
>  	}
>  
>  	if (!slob_page_free(sp)) {
-- 
http://selenic.com : development and support for Mercurial and Linux


