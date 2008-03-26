Return-Path: <linux-kernel-owner+w=401wt.eu-S1758617AbYCZKKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758617AbYCZKKA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 06:10:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751586AbYCZKJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 06:09:52 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51810 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbYCZKJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 06:09:51 -0400
Subject: Re: [PATCH -rt] avoid deadlock related with PG_nonewrefs and
	swap_lock
From: Peter Zijlstra <peterz@infradead.org>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Clark Williams <williams@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, hugh <hugh@veritas.com>
In-Reply-To: <1206525012.8514.488.camel@twins>
References: <47DEB7F0.8040207@ct.jp.nec.com>
	 <47DF097B.4090200@ct.jp.nec.com>
	 <Pine.LNX.4.58.0803172150360.8231@gandalf.stny.rr.com>
	 <1205833218.8514.338.camel@twins>  <47E7F1D1.6010407@ct.jp.nec.com>
	 <1206525012.8514.488.camel@twins>
Content-Type: text/plain
Date: Wed, 26 Mar 2008 11:09:40 +0100
Message-Id: <1206526180.8514.491.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-03-26 at 10:50 +0100, Peter Zijlstra wrote:
> On Mon, 2008-03-24 at 11:24 -0700, Hiroshi Shimamoto wrote:
> > Hi Peter,
> > 
> > I've updated the patch. Could you please review it?
> > 
> > I'm also thinking that it can be in the mainline because it makes
> > the lock period shorter, correct?
> 
> Possibly yeah, Nick, Hugh?
> 
> > ---
> > From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> > 
> > There is a deadlock scenario; remove_mapping() vs free_swap_and_cache().
> > remove_mapping() turns PG_nonewrefs bit on, then locks swap_lock.
> > free_swap_and_cache() locks swap_lock, then wait to turn PG_nonewrefs bit
> > off in find_get_page().
> > 
> > swap_lock can be unlocked before calling find_get_page().
> > 
> > In remove_exclusive_swap_page(), there is similar lock sequence;
> > swap_lock, then PG_nonewrefs bit. swap_lock can be unlocked before
> > turning PG_nonewrefs bit on.
> 
> I worry about this, Once we free the swap entry with swap_entry_free(),
> and drop the swap_lock, another task is basically free to re-use that
> swap location and try to insert another page in that same spot in
> add_to_swap() - read_swap_cache_async() can't race because it would mean
> it still has a swap entry pinned.

D'oh of course it can race, otherwise the add_to_swap() vs
read_swap_cache_async() race wouldn't exist.

Still, given that add_to_swap() handles the race I suspect the other end
does the right thing as well.

> However, add_to_swap() can already handle the race, because it used to
> race against read_swap_cache_async(). It also swap_free()s the entry so
> as to not leak entries. So I think this is indeed correct.
> 
> [ I ought to find some time to port the concurrent page-cache patches on
>   top of Nick's latest lockless series, Hugh's suggestion makes the
>   speculative get much nicer. ]
> 
> > Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> 
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> > ---
> >  mm/swapfile.c |   10 ++++++----
> >  1 files changed, 6 insertions(+), 4 deletions(-)
> > 
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index 5036b70..6fbc77e 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -366,6 +366,7 @@ int remove_exclusive_swap_page(struct page *page)
> >  	/* Is the only swap cache user the cache itself? */
> >  	retval = 0;
> >  	if (p->swap_map[swp_offset(entry)] == 1) {
> > +		spin_unlock(&swap_lock);
> >  		/* Recheck the page count with the swapcache lock held.. */
> >  		lock_page_ref_irq(page);
> >  		if ((page_count(page) == 2) && !PageWriteback(page)) {
> > @@ -374,8 +375,8 @@ int remove_exclusive_swap_page(struct page *page)
> >  			retval = 1;
> >  		}
> >  		unlock_page_ref_irq(page);
> > -	}
> > -	spin_unlock(&swap_lock);
> > +	} else
> > +		spin_unlock(&swap_lock);
> >  
> >  	if (retval) {
> >  		swap_free(entry);
> > @@ -400,13 +401,14 @@ void free_swap_and_cache(swp_entry_t entry)
> >  	p = swap_info_get(entry);
> >  	if (p) {
> >  		if (swap_entry_free(p, swp_offset(entry)) == 1) {
> > +			spin_unlock(&swap_lock);
> >  			page = find_get_page(&swapper_space, entry.val);
> >  			if (page && unlikely(TestSetPageLocked(page))) {
> >  				page_cache_release(page);
> >  				page = NULL;
> >  			}
> > -		}
> > -		spin_unlock(&swap_lock);
> > +		} else
> > +			spin_unlock(&swap_lock);
> >  	}
> >  	if (page) {
> >  		int one_user;

