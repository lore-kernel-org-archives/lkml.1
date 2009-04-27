Return-Path: <linux-kernel-owner+w=401wt.eu-S1755553AbZD0IXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553AbZD0IXR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 04:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754730AbZD0IW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 04:22:56 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36223 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754795AbZD0IWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 04:22:54 -0400
Date: Mon, 27 Apr 2009 17:21:19 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "hugh@veritas.com" <hugh@veritas.com>
Subject: Re: [RFC][PATCH] fix swap entries is not reclaimed in proper way
 for memg v3.
Message-Id: <20090427172119.d84aaa68.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090427081206.GI4454@balbir.in.ibm.com>
References: <20090421162121.1a1d15fe.kamezawa.hiroyu@jp.fujitsu.com>
	<20090422143833.2e11e10b.nishimura@mxp.nes.nec.co.jp>
	<20090424133306.0d9fb2ce.kamezawa.hiroyu@jp.fujitsu.com>
	<20090424152103.a5ee8d13.nishimura@mxp.nes.nec.co.jp>
	<20090424162840.2ad06d8a.kamezawa.hiroyu@jp.fujitsu.com>
	<20090427081206.GI4454@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Apr 2009 13:42:06 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-04-24 16:28:40]:
> 
> > This is new one. (using new logic.) Maybe enough light-weight and caches all cases.
> 
> You sure mean catches above :)
> 
> 
> > 
> > Thanks,
> > -Kame
> > ==
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > 
> > Because free_swap_and_cache() function is called under spinlocks,
> > it can't sleep and use trylock_page() instead of lock_page().
> > By this, swp_entry which is not used after zap_xx can exists as
> > SwapCache, which will be never used.
> > This kind of SwapCache is reclaimed by global LRU when it's found
> > at LRU rotation.
> > 
> > When memory cgroup is used,  the global LRU will not be kicked and
> > stale Swap Caches will not be reclaimed. This is problematic because
> > memcg's swap entry accounting is leaked and memcg can't know it.
> > To catch this stale SwapCache, we have to chase it and check the
> > swap is alive or not again.
> > 
> > This patch adds a function to chase stale swap cache and reclaim it
> > in modelate way. When zap_xxx fails to remove swap ent, it will be
> > recoreded into buffer and memcg's "work" will reclaim it later.
> > No sleep, no memory allocation under free_swap_and_cache().
> > 
> > This patch also adds stale-swap-cache-congestion logic and try to avoid having
> > too much stale swap caches at the same time.
> > 
> > Implementation is naive but maybe the cost meets trade-off.
> > 
> > How to test:
> >   1. set limit of memory to very small (1-2M?). 
> >   2. run some amount of program and run page reclaim/swap-in.
> >   3. kill programs by SIGKILL etc....then, Stale Swap Cache will
> >      be increased. After this patch, stale swap caches are reclaimed
> >      and mem+swap controller will not go to OOM.
> > 
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> Quick comment on the design
> 
> 1. I like the marking of swap cache entries as stale

I like to. But there is no space to record it as stale. And "race" makes
that difficult even if we have enough space. If you read the whole thread,
you know there are many patterns of race.

> 2. Can't we reclaim stale entries during memcg LRU reclaim? Why write
> a GC for it?
> 
Because they are not on memcg LRU. we can't reclaim it by memcg LRU.
(See the first mail from Nishimura of this thread. It explains well.)

One easy case is here.

  - CPU0 call zap_pte()->free_swap_and_cache()
  - CPU1 tries to swap-in it.
  In this case, free_swap_and_cache() doesn't free swp_entry and swp_entry
  is read into the memory. But it will never be added memcg's LRU until
  it's mapped.
  (What we have to consider here is swapin-readahead. It can swap-in memory
   even if it's not accessed. Then, this race window is larger than expected.)

We can't use memcg's LRU then...what we can do is.

 - scanning global LRU all
 or
 - use some trick to reclaim them in lazy way.


Thanks,
-Kame


