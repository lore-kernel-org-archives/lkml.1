Return-Path: <linux-kernel-owner+w=401wt.eu-S1756506AbZD0INU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506AbZD0INU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 04:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752629AbZD0INF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 04:13:05 -0400
Received: from e28smtp09.in.ibm.com ([59.145.155.9]:45411 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440AbZD0INE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 04:13:04 -0400
Date: Mon, 27 Apr 2009 13:42:06 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "hugh@veritas.com" <hugh@veritas.com>
Subject: Re: [RFC][PATCH] fix swap entries is not reclaimed in proper way
	for memg v3.
Message-ID: <20090427081206.GI4454@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090421162121.1a1d15fe.kamezawa.hiroyu@jp.fujitsu.com> <20090422143833.2e11e10b.nishimura@mxp.nes.nec.co.jp> <20090424133306.0d9fb2ce.kamezawa.hiroyu@jp.fujitsu.com> <20090424152103.a5ee8d13.nishimura@mxp.nes.nec.co.jp> <20090424162840.2ad06d8a.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090424162840.2ad06d8a.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-04-24 16:28:40]:

> This is new one. (using new logic.) Maybe enough light-weight and caches all cases.

You sure mean catches above :)


> 
> Thanks,
> -Kame
> ==
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> Because free_swap_and_cache() function is called under spinlocks,
> it can't sleep and use trylock_page() instead of lock_page().
> By this, swp_entry which is not used after zap_xx can exists as
> SwapCache, which will be never used.
> This kind of SwapCache is reclaimed by global LRU when it's found
> at LRU rotation.
> 
> When memory cgroup is used,  the global LRU will not be kicked and
> stale Swap Caches will not be reclaimed. This is problematic because
> memcg's swap entry accounting is leaked and memcg can't know it.
> To catch this stale SwapCache, we have to chase it and check the
> swap is alive or not again.
> 
> This patch adds a function to chase stale swap cache and reclaim it
> in modelate way. When zap_xxx fails to remove swap ent, it will be
> recoreded into buffer and memcg's "work" will reclaim it later.
> No sleep, no memory allocation under free_swap_and_cache().
> 
> This patch also adds stale-swap-cache-congestion logic and try to avoid having
> too much stale swap caches at the same time.
> 
> Implementation is naive but maybe the cost meets trade-off.
> 
> How to test:
>   1. set limit of memory to very small (1-2M?). 
>   2. run some amount of program and run page reclaim/swap-in.
>   3. kill programs by SIGKILL etc....then, Stale Swap Cache will
>      be increased. After this patch, stale swap caches are reclaimed
>      and mem+swap controller will not go to OOM.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Quick comment on the design

1. I like the marking of swap cache entries as stale
2. Can't we reclaim stale entries during memcg LRU reclaim? Why write
a GC for it?

-- 
	Balbir
