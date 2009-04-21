Return-Path: <linux-kernel-owner+w=401wt.eu-S1756738AbZDUJZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738AbZDUJZX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 05:25:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754652AbZDUJZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 05:25:06 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:59729 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368AbZDUJZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 05:25:05 -0400
Date: Tue, 21 Apr 2009 18:23:31 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: [patch 3/3][rfc] vmscan: batched swap slot allocation
Message-Id: <20090421182331.5c96615e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090421085231.GB2527@cmpxchg.org>
References: <1240259085-25872-1-git-send-email-hannes@cmpxchg.org>
	<1240259085-25872-3-git-send-email-hannes@cmpxchg.org>
	<20090421095857.b989ce44.kamezawa.hiroyu@jp.fujitsu.com>
	<20090421085231.GB2527@cmpxchg.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Apr 2009 10:52:31 +0200
Johannes Weiner <hannes@cmpxchg.org> wrote:

> > Keeping multiple pages locked while they stay on private list ? 
> 
> Yeah, it's a bit suboptimal but I don't see a way around it.
> 
Hmm, seems to increase stale swap cache dramatically under memcg ;)

> > BTW, isn't it better to add "allocate multiple swap space at once" function
> > like
> >  - void get_swap_pages(nr, swp_entry_array[])
> > ? "nr" will not be bigger than SWAP_CLUSTER_MAX.
> 
> It will sometimes be, see __zone_reclaim().
> 
Hm ? If I read the code correctly, __zone_reclaim() just call shrink_zone() and
"nr" to shrink_page_list() is SWAP_CLUSTER_MAX, at most.

> I had such a function once.  The interesting part is: how and when do
> you call it?  If you drop the page lock in between, you need to redo
> the checks for unevictability and whether the page has become mapped
> etc.
> 
> You also need to have the pages in swap cache as soon as possible or
> optimistic swap-in will 'steal' your swap slots.  See add_to_swap()
> when the cache radix tree says -EEXIST.
> 

If I was you, modify "offset" calculation of
  get_swap_pages()
     -> scan_swap_map()
to allow that a cpu  tends to find countinous swap page cluster.
Too difficult ?

Regards,
-Kame

