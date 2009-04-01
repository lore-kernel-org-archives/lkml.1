Return-Path: <linux-kernel-owner+w=401wt.eu-S1751495AbZDAELt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751495AbZDAELt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 00:11:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750777AbZDAELj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 00:11:39 -0400
Received: from cmpxchg.org ([85.214.51.133]:60626 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757AbZDAELi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 00:11:38 -0400
Date: Wed, 1 Apr 2009 06:09:51 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Rik van Riel <riel@redhat.com>,
       Balbir Singh <balbir@in.ibm.com>
Subject: Re: [PATCH] vmscan: memcg needs may_swap (Re: [patch] vmscan: rename  sc.may_swap to may_unmap)
Message-ID: <20090401040951.GA1548@cmpxchg.org>
References: <28c262360903301826w6429720es8ceb361cfc088b1@mail.gmail.com> <20090331104237.e689f279.kamezawa.hiroyu@jp.fujitsu.com> <20090331104625.B1C7.A69D9226@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090331104625.B1C7.A69D9226@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 31, 2009 at 10:48:32AM +0900, KOSAKI Motohiro wrote:
> > > Sorry for too late response.
> > > I don't know memcg well.
> > > 
> > > The memcg managed to use may_swap well with global page reclaim until now.
> > > I think that was because may_swap can represent both meaning.
> > > Do we need each variables really ?
> > > 
> > > How about using union variable ?
> > 
> > or Just removing one of them  ?
> 
> I hope all may_unmap user convert to using may_swap.
> may_swap is more efficient and cleaner meaning.

How about making may_swap mean the following:

	@@ -642,6 +639,8 @@ static unsigned long shrink_page_list(st
	 		 * Try to allocate it some swap space here.
	 		 */
	 		if (PageAnon(page) && !PageSwapCache(page)) {
	+			if (!sc->map_swap)
	+				goto keep_locked;
	 			if (!(sc->gfp_mask & __GFP_IO))
	 				goto keep_locked;
	 			if (!add_to_swap(page))

try_to_free_pages() always sets it.

try_to_free_mem_cgroup_pages() sets it depending on whether it really
wants swapping, and only swapping, right?  But the above would still
reclaim already swapped anon pages and I don't know the memory
controller.

balance_pgdat() always sets it.

__zone_reclaim() sets it depending on zone_reclaim_mode.  The
RECLAIM_SWAP bit of this field and its documentation in
Documentation/sysctl/vm.txt suggests it also really only means swap.

shrink_all_memory() would be the sole user of may_unmap because it
really wants to eat cache first.  But this could be figured out on a
different occasion.

	Hannes
