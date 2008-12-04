Return-Path: <linux-kernel-owner+w=401wt.eu-S1757787AbYLDOC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757787AbYLDOC2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 09:02:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757480AbYLDOCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 09:02:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51686 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757428AbYLDOCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 09:02:04 -0500
Date: Thu, 4 Dec 2008 15:02:00 +0100
From: Nick Piggin <npiggin@suse.de>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: wassim dagash <wassim.dagash@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: KSWAPD Algorithm - 100% CPU
Message-ID: <20081204140200.GA22631@wotan.suse.de>
References: <cb94e63d0812022304x49dfe519if4f8a8572a396672@mail.gmail.com> <20081203163740.1D4D.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081203163740.1D4D.KOSAKI.MOTOHIRO@jp.fujitsu.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2008 at 06:20:46PM +0900, KOSAKI Motohiro wrote:
> (CC to Nick Piggin and Andrew Morton.)
> 
> Hi
> 
> At first, could you post reproduce program?
> if nobody can reproduce, fixing is difficult.
> 
> obiously, we need the patch validate by reproduce program.
> 
> 
> > Hi All,
> > Description:
> > I countered a weird problem with kswapd:
> > it runs in some infinite loop trying to swap until order 10 of zone
> > highmem is OK, While zone higmem (as I understand) has nothing to do
> > with contiguous memory (cause there is no 1-1 mapping) which means
> > kswapd will continue to try to balance order 10 of zone highmem
> > forever (or until someone release a very large chunk of highmem).
> > Can anyone please explain me the algorithm of kswapd and why it tries
> > to balance order 10 of zone higmem ?
> 
> At second, I'd like to talk about kswapd background and algorithm.
> 
> 1st kswapd balancing introduced following commit.
> 
> --------------------------------------------------------
> commit 6cbd719443491404f63f9ff79ead9eba256511ee
> Author: akpm <akpm>
> Date:   Fri Mar 12 16:24:40 2004 +0000
> 
>     [PATCH] kswapd: fix lumpy page reclaim
> 
>     As kswapd is now scanning zones in the highmem->normal->dma direction it can
>     get into competition with the page allocator: kswapd keep on trying to free
>     pages from highmem, then kswapd moves onto lowmem.  By the time kswapd has
>     done proportional scanning in lowmem, someone has come in and allocated a few
>     pages from highmem.  So kswapd goes back and frees some highmem, then some
>     lowmem again.  But nobody has allocated any lowmem yet.  So we keep on and on
>     scanning lowmem in response to highmem page allocations.
> 
>     With a simple `dd' on a 1G box we get:
> 
>      r  b   swpd   free   buff  cache   si   so    bi    bo   in    cs us sy wa id
>      0  3      0  59340   4628 922348    0    0     4 28188 1072   808  0 10 46 44
>      0  3      0  29932   4660 951760    0    0     0 30752 1078   441  1  6 30 64
>      0  3      0  57568   4556 924052    0    0     0 30748 1075   478  0  8 43 49
>      0  3      0  29664   4584 952176    0    0     0 30752 1075   472  0  6 34 60
>      0  3      0   5304   4620 976280    0    0     4 40484 1073   456  1  7 52 41
>      0  3      0 104856   4508 877112    0    0     0 18452 1074    97  0  7 67 26
>      0  3      0  70768   4540 911488    0    0     0 35876 1078   746  0  7 34 59
>      1  2      0  42544   4568 939680    0    0     0 21524 1073   556  0  5 43 51
>      0  3      0   5520   4608 976428    0    0     4 37924 1076   836  0  7 41 51
>      0  2      0   4848   4632 976812    0    0    32 12308 1092    94  0  1 33 66
> 
>     Simple fix: go back to scanning the zones in the dma->normal->highmem
>     direction so we meet the page allocator in the middle somewhere.
> 
>      r  b   swpd   free   buff  cache   si   so    bi    bo   in    cs us sy wa id
>      1  3      0   5152   3468 976548    0    0     4 37924 1071   650  0  8 64 28
>      1  2      0   4888   3496 976588    0    0     0 23576 1075   726  0  6 66 27
>      0  3      0   5336   3532 976348    0    0     0 31264 1072   708  0  8 60 32
>      0  3      0   6168   3560 975504    0    0     0 40992 1072   683  0  6 63 31
>      0  3      0   4560   3580 976844    0    0     0 18448 1073   233  0  4 59 37
>      0  3      0   5840   3624 975712    0    0     4 26660 1072   800  1  8 46 45
>      0  3      0   4816   3648 976640    0    0     0 40992 1073   526  0  6 47 47
>      0  3      0   5456   3672 976072    0    0     0 19984 1070   320  0  5 60 35
> 
>     BKrev: 4051e448CiuO4KIoyJ6pqIVrkhuNnw
> --------------------------------------------------------
> 
> At that time, kswapd didn't check memory contenious at all.
> it has following code.
> 
> 		------------------------------------------------------------
> +                               if (zone->free_pages <= zone->pages_high) {
> +                                       end_zone = i;
> +                                       goto scan;
> +                               }
> 		-----------------------------------------------------------------
> 
> 
> 
> 2nd commit improve memory coutenious check.
> 
> --------------------------------------------------------
> commit e0e1723229b6f96922d10bb932f94d899132b462
> Author: nickpiggin <nickpiggin>
> Date:   Tue Jan 4 04:14:42 2005 +0000
> 
>     [PATCH] mm: teach kswapd about higher order areas
> 
>     Teach kswapd to free memory on behalf of higher order allocators.  This
>     could be important for higher order atomic allocations because they
>     otherwise have no means to free the memory themselves.
> 
>     Signed-off-by: Nick Piggin <nickpiggin@yahoo.com.au>
>     Signed-off-by: Andrew Morton <akpm@osdl.org>
>     Signed-off-by: Linus Torvalds <torvalds@osdl.org>
> 
>     BKrev: 41da1832E5flzqtNXq5m70WxihpcMw
> --------------------------------------------------------
> 
> At that time, kswapd has following code.
> 
> 		--------------------------------------------------------
> -                               if (zone->free_pages <= zone->pages_high) {
> +                               if (!zone_watermark_ok(zone, order,
> +                                               zone->pages_high, 0, 0, 0)) {
>                                         end_zone = i;
>                                         goto scan;
>                                 }
> 		--------------------------------------------------------
> 
> The problem is, alloc_pages(GFP_KERNEL, 10) need to contenious order-10 memory.
> but doesn't need to highmem couteniously.
> 
> However alloc_pages() pass to order==10 information.
> but doesn't pass to highmem coutinuous is unnecessary.
> 
> Oops, that is bug, I think.
> 
> 
> So, I'd like to fix this bug.
> However, I check my guessing is right or not at first.
> please reproduce program.
> 
> 
> 
> > Details:
> > I build an instrumented kernel with debug messages in
> > "zone_watermark_ok" function, and from the code and debug messages I
> > see that "zone_watermark_ok" returns 0 when kswapd invokes it (through
> > balance_pgdat) in order to decide if zone highmem is balanced or not,
> > which lead in some configurations to infinite loop of kswapd ( if no
> > large chunks of highmem released) . I added a condition to
> > "balance_pgdat" so it doesn't try to balance order higher than 1 in
> > zone highmem and this conditon solved the problem, what are the risks
> > with such solution? isn't it a bug that kswapd is looking for
> > continuous memory in zone highmem ( as I understand there is no 1-1
> > mapping in zone highmem which is meaningless in kswapd)?
> 
> 
> simple removing seems no good.
> because hugepage on highmem need to highmem coutenious.

kswapd_max_order check and reset should probably go inside
balance_pgdat:loop_again loop.

It is possible we could have a kswapd_max_order[MAX_NR_ZONES] or
something, but I don't know if the complexity would be worth while
given that huge order allocations aren't too common, and resetting
kswapd_max_order inside the loop should be a reasonable fix.



