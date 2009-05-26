Return-Path: <linux-kernel-owner+w=401wt.eu-S1757213AbZEZSPI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213AbZEZSPI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 14:15:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754838AbZEZSO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 14:14:57 -0400
Received: from cmpxchg.org ([85.214.51.133]:35233 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756220AbZEZSO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 14:14:57 -0400
Date: Tue, 26 May 2009 20:14:00 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 5/5] (experimental) chase and free cache only swap
Message-ID: <20090526181359.GB2843@cmpxchg.org>
References: <20090526121259.b91b3e9d.kamezawa.hiroyu@jp.fujitsu.com> <20090526121834.dd9a4193.kamezawa.hiroyu@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090526121834.dd9a4193.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26, 2009 at 12:18:34PM +0900, KAMEZAWA Hiroyuki wrote:
> 
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> Just a trial/example patch.
> I'd like to consider more. Better implementation idea is welcome.
> 
> When the system does swap-in/swap-out repeatedly, there are 
> cache-only swaps in general.
> Typically,
>  - swapped out in past but on memory now while vm_swap_full() returns true
> pages are cache-only swaps. (swap_map has no references.)
> 
> This cache-only swaps can be an obstacles for smooth page reclaiming.
> Current implemantation is very naive, just scan & free.

I think we can just remove that vm_swap_full() check in do_swap_page()
and try to remove the page from swap cache unconditionally.

If it's still mapped someplace else, we let it cached.  If not, there
is not much use for keeping it around and we free it.

When I removed it and did benchmarks, I couldn't spot any difference
in the timings, though.  Did you measure the benefits of your patch
somehow?

According to the git history tree, vm_swap_full() was initially only
used to aggressively drop cache entries even when they are mapped.

Rik put it into vmscan to reclaim swap cache _at all_ for activated
pages.  But I think unconditionally dropping the cache entry makes
sense if the page gets shuffled around on the LRU list.  Better to
re-allocate a swap slot close to the new LRU buddies on the next scan.

And having this all covered, the need for the scanning your patch does
should be gone, unless I missed something.

	Hannes
