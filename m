Return-Path: <linux-kernel-owner+w=401wt.eu-S1757903AbZD1AUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757903AbZD1AUq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 20:20:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773AbZD1AUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 20:20:36 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60145 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728AbZD1AUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 20:20:36 -0400
Date: Tue, 28 Apr 2009 09:19:02 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: nishimura@mxp.nes.nec.co.jp
Cc: Daisuke Nishimura <d-nishimura@mtf.biglobe.ne.jp>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "hugh@veritas.com" <hugh@veritas.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix leak of swap accounting as stale swap cache under
 memcg
Message-Id: <20090428091902.fc44efbc.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090427210856.d5f4109e.d-nishimura@mtf.biglobe.ne.jp>
References: <20090427181259.6efec90b.kamezawa.hiroyu@jp.fujitsu.com>
	<20090427210856.d5f4109e.d-nishimura@mtf.biglobe.ne.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Apr 2009 21:08:56 +0900
Daisuke Nishimura <d-nishimura@mtf.biglobe.ne.jp> wrote:

> > Index: mmotm-2.6.30-Apr24/mm/vmscan.c
> > ===================================================================
> > --- mmotm-2.6.30-Apr24.orig/mm/vmscan.c
> > +++ mmotm-2.6.30-Apr24/mm/vmscan.c
> > @@ -661,6 +661,9 @@ static unsigned long shrink_page_list(st
> >  		if (PageAnon(page) && !PageSwapCache(page)) {
> >  			if (!(sc->gfp_mask & __GFP_IO))
> >  				goto keep_locked;
> > +			/* avoid making more stale swap caches */
> > +			if (memcg_stale_swap_congestion())
> > +				goto keep_locked;
> >  			if (!add_to_swap(page))
> >  				goto activate_locked;
> >  			may_enter_fs = 1;
> > 
> Well, as I mentioned before(http://marc.info/?l=linux-kernel&m=124066623510867&w=2),
> this cannot avoid type-2(set !PageCgroupUsed by the owner process via
> page_remove_rmap()->mem_cgroup_uncharge_page() before being added to swap cache).
> If these swap caches go through shrink_page_list() without beeing freed
> for some reason, these swap caches doesn't go back to memcg's LRU.
> 
> Type-2 doesn't pressure memsw.usage, but you can see it by plotting
> "grep SwapCached /proc/meminfo".
> 
> And I don't think it's a good idea to add memcg_stale_swap_congestion() here.
> This means less possibility to reclaim pages.
> 
Hmm. maybe adding congestion_wait() ?

> Do you dislike the patch I attached in the above mail ?
> 
I doubt whether the patch covers all type-2 case.

> If not, please merge it(I tested your prvious version with some fixes and
> my patch, and it worked well). Or shall I send is as a separate patch
> to fix type-2 after your patch(yours looks good to me for type-1)?
> (to tell the truth, I want reuse memcg_free_unused_swapcache() in another patch)
> 
> 
I'll consider again and post v3.
But I'll go into a series of holidays, so, may not come back until May/6.

Thanks,
-Kame


> Thanks,
> Daisuke Nishimura.
> 

