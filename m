Return-Path: <linux-kernel-owner+w=401wt.eu-S1760702AbZE0Gwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760702AbZE0Gwg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 02:52:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760297AbZE0Gw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 02:52:29 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51635 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759787AbZE0Gw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 02:52:28 -0400
Date: Wed, 27 May 2009 15:50:55 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 5/5] (experimental) chase and free cache only swap
Message-Id: <20090527155055.2dcee5ce.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090527153024.bb275962.nishimura@mxp.nes.nec.co.jp>
References: <20090526121259.b91b3e9d.kamezawa.hiroyu@jp.fujitsu.com>
	<20090526121834.dd9a4193.kamezawa.hiroyu@jp.fujitsu.com>
	<20090527141442.d191dc2d.kamezawa.hiroyu@jp.fujitsu.com>
	<20090527153024.bb275962.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 May 2009 15:30:24 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> On Wed, 27 May 2009 14:14:42 +0900, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > On Tue, 26 May 2009 12:18:34 +0900
> > KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > 
> > > 
> > > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > > 
> > This is a replacement for this. (just an idea, not testd.)
> > 
> > I think this works well. Does anyone has concerns ?
> I think so too, except some trivial build errors ;)
> 
Oh, will be fixed in the next post :(

> I'll test it, but it will take a long time to see the effect of this patch
> even if setting the swap space to reasonable size.
> 
Yes, Hot-to-test is my concern, too..

Thanks,
-Kame


> 
> Thanks,
> Daisuke Nishimura.
> 
> > Do I have to modify swap-cluster code to do this in sane way ?
> > 
> > ---
> >  mm/swapfile.c |   40 ++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 40 insertions(+)
> > 
> > Index: new-trial-swapcount/mm/swapfile.c
> > ===================================================================
> > --- new-trial-swapcount.orig/mm/swapfile.c
> > +++ new-trial-swapcount/mm/swapfile.c
> > @@ -74,6 +74,26 @@ static inline unsigned short make_swap_c
> >  	return ret;
> >  }
> >  
> > +static int try_to_reuse_swap(struct swap_info_struct *si, unsigned long offset)
> > +{
> > +	int type = si - swap_info;
> > +	swp_entry_t entry = swp_entry(type, offset);
> > +	struct page *page;
> > +
> > +	page = find_get_page(page);
> > +	if (!page)
> > +		return 0;
> > +	if (!trylock_page(page)) {
> > +		page_cache_release(page);
> > +		return 0;
> > +	}
> > +	try_to_free_swap(page);
> > +	unlock_page(page);
> > +	page_cache_release(page);
> > +	return 1;
> > +}
> > +
> > +
> >  /*
> >   * We need this because the bdev->unplug_fn can sleep and we cannot
> >   * hold swap_lock while calling the unplug_fn. And swap_lock
> > @@ -295,6 +315,18 @@ checks:
> >  		goto no_page;
> >  	if (offset > si->highest_bit)
> >  		scan_base = offset = si->lowest_bit;
> > +
> > +	/* reuse swap entry of cache-only swap if not busy. */
> > +	if (vm_swap_full() && si->swap_map[offset] == SWAP_HAS_CACHE) {
> > +		int ret;
> > +		spin_unlock(&swap_lock);
> > +		ret = try_to_reuse_swap(si, offset));
> > +		spin_lock(&swap_lock);
> > +		if (ret)
> > +			goto checks; /* we released swap_lock */
> > +		goto scan;
> > +	}
> > +
> >  	if (si->swap_map[offset])
> >  		goto scan;
> >  
> > @@ -378,6 +410,10 @@ scan:
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
> > @@ -389,6 +425,10 @@ scan:
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
> 

