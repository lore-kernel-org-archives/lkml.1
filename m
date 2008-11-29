Return-Path: <linux-kernel-owner+w=401wt.eu-S1753228AbYK2Hqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228AbYK2Hqg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 02:46:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750930AbYK2Hq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 02:46:28 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34090 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbYK2Hq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 02:46:27 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [rfc] vmscan: serialize aggressive reclaimers
Cc: kosaki.motohiro@jp.fujitsu.com, Rik van Riel <riel@redhat.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org, mel@csn.ul.ie,
       akpm@linux-foundation.org
In-Reply-To: <20081127173610.GA1781@cmpxchg.org>
References: <20081124145057.4211bd46@bree.surriel.com> <20081127173610.GA1781@cmpxchg.org>
Message-Id: <20081129164322.8131.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Sat, 29 Nov 2008 16:46:24 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Since we have to pull through a reclaim cycle once we commited to it,
> what do you think about serializing the lower priority levels
> completely?
> 
> The idea is that when one reclaimer has done a low priority level
> iteration with a huge reclaim target, chances are that succeeding
> reclaimers don't even need to drop to lower levels at all because
> enough memory has already been freed.
> 
> My testprogram maps and faults in a file that is about as large as my
> physical memory.  Then it spawns off n processes that try allocate
> 1/2n of total memory in anon pages, i.e. half of it in sum.  After it
> ran, I check how much memory has been reclaimed.  But my zone sizes
> are too small to induce enormous reclaim targets so I don't see vast
> over-reclaims.
> 
> I have measured the time of other tests on an SMP machine with 4 cores
> and the following patch applied.  I couldn't see any performance
> degradation.  But since the bug is not triggerable here, I can not
> prove it helps the original problem, either.

I wonder why nobody of vmscan folks write actual performance improvement value
in patch description.

I think this patch point to right direction.
but, unfortunately, this implementation isn't fast as I mesured as.


> 
> The level where it starts serializing is chosen pretty arbitrarily.
> Suggestions welcome :)
> 
> 	Hannes
> 
> ---
> 
> Prevent over-reclaiming by serializing direct reclaimers below a
> certain priority level.
> 
> Over-reclaiming happens when the sum of the reclaim targets of all
> reclaiming processes is larger than the sum of the needed free pages,
> thus leading to excessive eviction of more cache and anonymous pages
> than required.
> 
> A scan iteration over all zones can not be aborted intermittently when
> enough pages are reclaimed because that would mess up the scan balance
> between the zones.  Instead, prevent that too many processes
> simultaneously commit themselves to lower priority level scans in the
> first place.
> 
> Chances are that after the exclusive reclaimer has finished, enough
> memory has been freed that succeeding scanners don't need to drop to
> lower priority levels at all anymore.
> 
> Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
> ---
>  mm/vmscan.c |   20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -35,6 +35,7 @@
>  #include <linux/notifier.h>
>  #include <linux/rwsem.h>
>  #include <linux/delay.h>
> +#include <linux/wait.h>
>  #include <linux/kthread.h>
>  #include <linux/freezer.h>
>  #include <linux/memcontrol.h>
> @@ -42,6 +43,7 @@
>  #include <linux/sysctl.h>
>  
>  #include <asm/tlbflush.h>
> +#include <asm/atomic.h>
>  #include <asm/div64.h>
>  
>  #include <linux/swapops.h>
> @@ -1546,10 +1548,15 @@ static unsigned long shrink_zones(int pr
>   * returns:	0, if no pages reclaimed
>   * 		else, the number of pages reclaimed
>   */
> +
> +static DECLARE_WAIT_QUEUE_HEAD(reclaim_wait);
> +static atomic_t reclaim_exclusive = ATOMIC_INIT(0);
> +
>  static unsigned long do_try_to_free_pages(struct zonelist *zonelist,
>  					struct scan_control *sc)
>  {
>  	int priority;
> +	int exclusive = 0;
>  	unsigned long ret = 0;
>  	unsigned long total_scanned = 0;
>  	unsigned long nr_reclaimed = 0;
> @@ -1580,6 +1587,14 @@ static unsigned long do_try_to_free_page
>  		sc->nr_scanned = 0;
>  		if (!priority)
>  			disable_swap_token();
> +		/*
> +		 * Serialize aggressive reclaimers
> +		 */
> +		if (priority <= DEF_PRIORITY / 2 && !exclusive) {

On large machine, DEF_PRIORITY / 2 is really catastrophe situation.
2^6 = 64. 
if zone has 64GB memory, it mean 1GB reclaim.
I think more early restriction is better.


> +			wait_event(reclaim_wait,
> +				!atomic_cmpxchg(&reclaim_exclusive, 0, 1));
> +			exclusive = 1;
> +		}

if you want to restrict to one task, you can use mutex.
and this wait_queue should put on global variable. it should be zone variable.

In addision, you don't consider recursive relaim and several task can't sleep there.


please believe me. I have richest experience about reclaim throttling in the planet.




