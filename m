Return-Path: <linux-kernel-owner+w=401wt.eu-S1751695AbZFDHBI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751695AbZFDHBI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 03:01:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752177AbZFDHA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 03:00:57 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48650 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbZFDHA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 03:00:57 -0400
Date: Thu, 4 Jun 2009 15:59:26 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] reuse unused swap entry if necessary
Message-Id: <20090604155926.1c88d9de.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090604145733.ddfb3c88.nishimura@mxp.nes.nec.co.jp>
References: <20090602120425.0bcff554.kamezawa.hiroyu@jp.fujitsu.com>
	<20090602121202.6740a718.kamezawa.hiroyu@jp.fujitsu.com>
	<20090604145733.ddfb3c88.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Jun 2009 14:57:33 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> On Tue, 2 Jun 2009 12:12:02 +0900, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > 
> > This is a replacement for
> >  mm-reuse-unused-swap-entry-if-necessary.patch in mmotm.
> >  function is renamed and comments are added.
> > 
> > ==
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > 
> > Now, we can know the swap is just used as SwapCache via swap_map,
> > without looking up swap cache.
> > 
> > Then, we have a chance to reuse swap-cache-only swap entries in
> > get_swap_pages().
> > 
> > This patch tries to free swap-cache-only swap entries if swap is
> > not enough.
> > Note: We hit following path when swap_cluster code cannot find
> > a free cluster. Then, vm_swap_full() is not only condition to allow
> > the kernel to reclaim unused swap.
> > 
> > Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> I've confirmed that usage increase of swap and swapcache stopped
> at some threshold in my test, in which , before this patch, some programs
> had been oom-killed after a long time because of shortage of swap space.
> 
> This has been merged to mm already though:
> 
> 	Tested-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> 
Wondeful :) Thank you for your long efforts and patiance.

Regards,
-Kame


> Thanks,
> Daiuske Nishimura.
> 
> > ---
> >  mm/swapfile.c |   47 +++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 47 insertions(+)
> > 
> > Index: mmotm-2.6.30-May28/mm/swapfile.c
> > ===================================================================
> > --- mmotm-2.6.30-May28.orig/mm/swapfile.c
> > +++ mmotm-2.6.30-May28/mm/swapfile.c
> > @@ -79,6 +79,32 @@ static inline unsigned short encode_swap
> >  	return ret;
> >  }
> >  
> > +/* returnes 1 if swap entry is freed */
> > +static int
> > +__try_to_reclaim_swap(struct swap_info_struct *si, unsigned long offset)
> > +{
> > +	int type = si - swap_info;
> > +	swp_entry_t entry = swp_entry(type, offset);
> > +	struct page *page;
> > +	int ret = 0;
> > +
> > +	page = find_get_page(&swapper_space, entry.val);
> > +	if (!page)
> > +		return 0;
> > +	/*
> > +	 * This function is called from scan_swap_map() and it's called
> > +	 * by vmscan.c at reclaiming pages. So, we hold a lock on a page, here.
> > +	 * We have to use trylock for avoiding deadlock. This is a special
> > +	 * case and you should use try_to_free_swap() with explicit lock_page()
> > +	 * in usual operations.
> > +	 */
> > +	if (trylock_page(page)) {
> > +		ret = try_to_free_swap(page);
> > +		unlock_page(page);
> > +	}
> > +	page_cache_release(page);
> > +	return ret;
> > +}
> >  
> >  /*
> >   * We need this because the bdev->unplug_fn can sleep and we cannot
> > @@ -301,6 +327,19 @@ checks:
> >  		goto no_page;
> >  	if (offset > si->highest_bit)
> >  		scan_base = offset = si->lowest_bit;
> > +
> > +	/* reuse swap entry of cache-only swap if not busy. */
> > +	if (vm_swap_full() && si->swap_map[offset] == SWAP_HAS_CACHE) {
> > +		int swap_was_freed;
> > +		spin_unlock(&swap_lock);
> > +		swap_was_freed = __try_to_reclaim_swap(si, offset);
> > +		spin_lock(&swap_lock);
> > +		/* entry was freed successfully, try to use this again */
> > +		if (swap_was_freed)
> > +			goto checks;
> > +		goto scan; /* check next one */
> > +	}
> > +
> >  	if (si->swap_map[offset])
> >  		goto scan;
> >  
> > @@ -382,6 +421,10 @@ scan:
> >  			spin_lock(&swap_lock);
> >  			goto checks;
> >  		}
> > +		if (vm_swap_full() && si->swap_map[offset] == SWAP_HAS_CACHE) {
> > +			spin_lock(&swap_lock);
> > +			goto checks;
> > +		}
> >  		if (unlikely(--latency_ration < 0)) {
> >  			cond_resched();
> >  			latency_ration = LATENCY_LIMIT;
> > @@ -393,6 +436,10 @@ scan:
> >  			spin_lock(&swap_lock);
> >  			goto checks;
> >  		}
> > +		if (vm_swap_full() && si->swap_map[offset] == SWAP_HAS_CACHE) {
> > +			spin_lock(&swap_lock);
> > +			goto checks;
> > +		}
> >  		if (unlikely(--latency_ration < 0)) {
> >  			cond_resched();
> >  			latency_ration = LATENCY_LIMIT;
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

