Return-Path: <linux-kernel-owner+w=401wt.eu-S1756917AbZDAFWP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917AbZDAFWP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 01:22:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752942AbZDAFV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 01:21:59 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:34561 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059AbZDAFV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 01:21:58 -0400
Date: Wed, 1 Apr 2009 14:08:28 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: nishimura@mxp.nes.nec.co.jp,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Rik van Riel <riel@redhat.com>,
       Balbir Singh <balbir@in.ibm.com>
Subject: Re: [PATCH] vmscan: memcg needs may_swap (Re: [patch] vmscan:
 rename  sc.may_swap to may_unmap)
Message-Id: <20090401140828.755f87aa.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20090401040951.GA1548@cmpxchg.org>
References: <28c262360903301826w6429720es8ceb361cfc088b1@mail.gmail.com>
	<20090331104237.e689f279.kamezawa.hiroyu@jp.fujitsu.com>
	<20090331104625.B1C7.A69D9226@jp.fujitsu.com>
	<20090401040951.GA1548@cmpxchg.org>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Apr 2009 06:09:51 +0200, Johannes Weiner <hannes@cmpxchg.org> wrote:
> On Tue, Mar 31, 2009 at 10:48:32AM +0900, KOSAKI Motohiro wrote:
> > > > Sorry for too late response.
> > > > I don't know memcg well.
> > > > 
> > > > The memcg managed to use may_swap well with global page reclaim until now.
> > > > I think that was because may_swap can represent both meaning.
> > > > Do we need each variables really ?
> > > > 
> > > > How about using union variable ?
> > > 
> > > or Just removing one of them  ?
> > 
> > I hope all may_unmap user convert to using may_swap.
> > may_swap is more efficient and cleaner meaning.
> 
> How about making may_swap mean the following:
> 
> 	@@ -642,6 +639,8 @@ static unsigned long shrink_page_list(st
> 	 		 * Try to allocate it some swap space here.
> 	 		 */
> 	 		if (PageAnon(page) && !PageSwapCache(page)) {
> 	+			if (!sc->map_swap)
> 	+				goto keep_locked;
> 	 			if (!(sc->gfp_mask & __GFP_IO))
> 	 				goto keep_locked;
> 	 			if (!add_to_swap(page))
> 
but it doesn't work for shmem/tmpfs, does it?
So, I did in my first patch like:

@@ -616,6 +619,11 @@ static unsigned long shrink_page_list(struct list_head *page_list,
 		if (!sc->may_unmap && page_mapped(page))
 			goto keep_locked;
 
+		if (!sc->may_swap && PageSwapBacked(page)
+			/* SwapCache uses 'swap' already */
+			&& !PageSwapCache(page))
+			goto keep_locked;
+
 		/* Double the slab pressure for mapped and swapcache pages */
 		if (page_mapped(page) || PageSwapCache(page))
 			sc->nr_scanned++;

> try_to_free_pages() always sets it.
> 
> try_to_free_mem_cgroup_pages() sets it depending on whether it really
> wants swapping, and only swapping, right?
right.

> But the above would still reclaim already swapped anon pages
then, it would be better to add a check at shrink_page_list anyway..

Kosaki-san, what do you think?


Thanks,
Daisuke Nishimura.

> and I don't know the memory
> controller.
> 
> balance_pgdat() always sets it.
> 
> __zone_reclaim() sets it depending on zone_reclaim_mode.  The
> RECLAIM_SWAP bit of this field and its documentation in
> Documentation/sysctl/vm.txt suggests it also really only means swap.
> 
> shrink_all_memory() would be the sole user of may_unmap because it
> really wants to eat cache first.  But this could be figured out on a
> different occasion.
> 
> 	Hannes
