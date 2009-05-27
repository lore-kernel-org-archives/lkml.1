Return-Path: <linux-kernel-owner+w=401wt.eu-S1758800AbZE0AJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758800AbZE0AJz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 20:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754531AbZE0AJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 20:09:48 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44343 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753988AbZE0AJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 20:09:47 -0400
Date: Wed, 27 May 2009 09:08:13 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 5/5] (experimental) chase and free cache only swap
Message-Id: <20090527090813.a0e436f8.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090526181359.GB2843@cmpxchg.org>
References: <20090526121259.b91b3e9d.kamezawa.hiroyu@jp.fujitsu.com>
	<20090526121834.dd9a4193.kamezawa.hiroyu@jp.fujitsu.com>
	<20090526181359.GB2843@cmpxchg.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 May 2009 20:14:00 +0200
Johannes Weiner <hannes@cmpxchg.org> wrote:

> On Tue, May 26, 2009 at 12:18:34PM +0900, KAMEZAWA Hiroyuki wrote:
> > 
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > 
> > Just a trial/example patch.
> > I'd like to consider more. Better implementation idea is welcome.
> > 
> > When the system does swap-in/swap-out repeatedly, there are 
> > cache-only swaps in general.
> > Typically,
> >  - swapped out in past but on memory now while vm_swap_full() returns true
> > pages are cache-only swaps. (swap_map has no references.)
> > 
> > This cache-only swaps can be an obstacles for smooth page reclaiming.
> > Current implemantation is very naive, just scan & free.
> 
> I think we can just remove that vm_swap_full() check in do_swap_page()
> and try to remove the page from swap cache unconditionally.
> 
I'm not sure why reclaim swap entry only at write fault.

> If it's still mapped someplace else, we let it cached.  If not, there
> is not much use for keeping it around and we free it.
> 
yes.

> When I removed it and did benchmarks, I couldn't spot any difference
> in the timings, though.  Did you measure the benefits of your patch
> somehow?
My patche has no "performance benefit". (My patch description may be bad.)
I just checked that cache-only-swap can be big.(by sysrq-m)

Even when we remove vm_swap_full() in do_swap_page(),
swapin-readahead + trylock-at-zap + vmscan makes "unused" swap caches easily.
It reaches 1M in 2hours test of heavy swap program.

But yes, I admit I don't like scan & free. I'm now thinking some mark-and-sweep
approach...but it tends to consume memory and to be racy ;)

> 
> According to the git history tree, vm_swap_full() was initially only
> used to aggressively drop cache entries even when they are mapped.
> 
> Rik put it into vmscan to reclaim swap cache _at all_ for activated
> pages.  But I think unconditionally dropping the cache entry makes
> sense if the page gets shuffled around on the LRU list.  Better to
> re-allocate a swap slot close to the new LRU buddies on the next scan.
> 
> And having this all covered, the need for the scanning your patch does
> should be gone, unless I missed something.
> 
Considering memcg, global lru scanning is no help ;(
And I'm writing this patch for memcg.

It seems I should make this 5/5 patch as an independent one and
test 1-4/5 first.

Thank you for review.

Regards,
-Kame



