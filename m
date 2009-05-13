Return-Path: <linux-kernel-owner+w=401wt.eu-S1758523AbZEMAeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758523AbZEMAeb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 20:34:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755878AbZEMAeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 20:34:19 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:63773 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302AbZEMAeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 20:34:18 -0400
Date: Wed, 13 May 2009 09:28:28 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: nishimura@mxp.nes.nec.co.jp,
       Daisuke Nishimura <d-nishimura@mtf.biglobe.ne.jp>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>, mingo@elte.hu,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][BUGFIX] memcg: fix for deadlock between
 lock_page_cgroup and mapping tree_lock
Message-Id: <20090513092828.cbaa5a76.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20090513085949.3c4b7b97.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090512104401.28edc0a8.kamezawa.hiroyu@jp.fujitsu.com>
	<20090512140648.0974cb10.nishimura@mxp.nes.nec.co.jp>
	<20090512160901.8a6c5f64.kamezawa.hiroyu@jp.fujitsu.com>
	<20090512170007.ad7f5c7b.nishimura@mxp.nes.nec.co.jp>
	<20090512171356.3d3a7554.kamezawa.hiroyu@jp.fujitsu.com>
	<20090512195823.15c5cb80.d-nishimura@mtf.biglobe.ne.jp>
	<20090513085949.3c4b7b97.kamezawa.hiroyu@jp.fujitsu.com>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 May 2009 08:59:49 +0900, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Tue, 12 May 2009 19:58:23 +0900
> Daisuke Nishimura <d-nishimura@mtf.biglobe.ne.jp> wrote:
> 
> > On Tue, 12 May 2009 17:13:56 +0900
> > KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > 
> > > On Tue, 12 May 2009 17:00:07 +0900
> > > Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
> > > > hmm, I see.
> > > > cache_charge is outside of tree_lock, so moving uncharge would make sense.
> > > > IMHO, we should make the period of spinlock as small as possible,
> > > > and charge/uncharge of pagecache/swapcache is protected by page lock, not tree_lock.
> > > > 
> > > How about this ?
> > Looks good conceptually, but it cannot be built :)
> > 
> > It needs a fix like this.
> > Passed build test with enabling/disabling both CONFIG_MEM_RES_CTLR
> > and CONFIG_SWAP.
> > 
> ok, will update. can I add you Signed-off-by on the patch ?
> 
Sure.

	Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

The patch(with my fix applied) seems to work fine, I need run it
for more long time though.

> Thanks,
> -Kame
> > ===
> >  include/linux/swap.h |    5 +++++
> >  mm/memcontrol.c      |    4 +++-
> >  mm/swap_state.c      |    4 +---
> >  mm/vmscan.c          |    2 +-
> >  4 files changed, 10 insertions(+), 5 deletions(-)
> > 
> > diff --git a/include/linux/swap.h b/include/linux/swap.h
> > index caf0767..6ea541d 100644
> > --- a/include/linux/swap.h
> > +++ b/include/linux/swap.h
> > @@ -431,6 +431,11 @@ static inline swp_entry_t get_swap_page(void)
> >  #define has_swap_token(x) 0
> >  #define disable_swap_token() do { } while(0)
> >  
> > +static inline void
> > +mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent)
> > +{
> > +}
> > +
> >  #endif /* CONFIG_SWAP */
> >  #endif /* __KERNEL__*/
> >  #endif /* _LINUX_SWAP_H */
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 0c9c1ad..89523cf 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -1488,8 +1488,9 @@ void mem_cgroup_uncharge_cache_page(struct page *page)
> >  	__mem_cgroup_uncharge_common(page, MEM_CGROUP_CHARGE_TYPE_CACHE);
> >  }
> >  
> > +#ifdef CONFIG_SWAP
> >  /*
> > - * called from __delete_from_swap_cache() and drop "page" account.
> > + * called after __delete_from_swap_cache() and drop "page" account.
> >   * memcg information is recorded to swap_cgroup of "ent"
> >   */
> >  void mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent)
> > @@ -1506,6 +1507,7 @@ void mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent)
> >  	if (memcg)
> >  		css_put(&memcg->css);
> >  }
> > +#endif
> >  
> >  #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
> >  /*
> > diff --git a/mm/swap_state.c b/mm/swap_state.c
> > index 87f10d4..7624c89 100644
> > --- a/mm/swap_state.c
> > +++ b/mm/swap_state.c
> > @@ -109,8 +109,6 @@ int add_to_swap_cache(struct page *page, swp_entry_t entry, gfp_t gfp_mask)
> >   */
> >  void __delete_from_swap_cache(struct page *page)
> >  {
> > -	swp_entry_t ent = {.val = page_private(page)};
> > -
> >  	VM_BUG_ON(!PageLocked(page));
> >  	VM_BUG_ON(!PageSwapCache(page));
> >  	VM_BUG_ON(PageWriteback(page));
> > @@ -190,7 +188,7 @@ void delete_from_swap_cache(struct page *page)
> >  	__delete_from_swap_cache(page);
> >  	spin_unlock_irq(&swapper_space.tree_lock);
> >  
> > -	mem_cgroup_uncharge_swapcache(page, ent);
> > +	mem_cgroup_uncharge_swapcache(page, entry);
> >  	swap_free(entry);
> >  	page_cache_release(page);
> >  }
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 6c5988d..a7d7a06 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -470,7 +470,7 @@ static int __remove_mapping(struct address_space *mapping, struct page *page)
> >  		swp_entry_t swap = { .val = page_private(page) };
> >  		__delete_from_swap_cache(page);
> >  		spin_unlock_irq(&mapping->tree_lock);
> > -		mem_cgroup_uncharge_swapcache(page);
> > +		mem_cgroup_uncharge_swapcache(page, swap);
> >  		swap_free(swap);
> >  	} else {
> >  		__remove_from_page_cache(page);
> > ===
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> > 
> 
