Return-Path: <linux-kernel-owner+w=401wt.eu-S1753837AbZECBQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837AbZECBQY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 21:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753088AbZECBQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 21:16:15 -0400
Received: from mga03.intel.com ([143.182.124.21]:48092 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753065AbZECBQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 21:16:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,284,1239001200"; 
   d="scan'208";a="138540510"
Date: Sun, 3 May 2009 09:15:40 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Rik van Riel <riel@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>, Elladan <elladan@eskimo.com>,
       linux-kernel@vger.kernel.org, tytso@mit.edu, linux-mm@kvack.org
Subject: Re: [PATCH] vmscan: evict use-once pages first (v3)
Message-ID: <20090503011540.GA5702@localhost>
References: <20090428044426.GA5035@eskimo.com> <20090428192907.556f3a34@bree.surriel.com> <1240987349.4512.18.camel@laptop> <20090429114708.66114c03@cuia.bos.redhat.com> <2f11576a0904290907g48e94e74ye97aae593f6ac519@mail.gmail.com> <20090429131436.640f09ab@cuia.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090429131436.640f09ab@cuia.bos.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 29, 2009 at 01:14:36PM -0400, Rik van Riel wrote:
> When the file LRU lists are dominated by streaming IO pages,
> evict those pages first, before considering evicting other
> pages.
> 
> This should be safe from deadlocks or performance problems
> because only three things can happen to an inactive file page:
> 1) referenced twice and promoted to the active list
> 2) evicted by the pageout code
> 3) under IO, after which it will get evicted or promoted
> 
> The pages freed in this way can either be reused for streaming
> IO, or allocated for something else. If the pages are used for
> streaming IO, this pageout pattern continues. Otherwise, we will
> fall back to the normal pageout pattern.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>
> 
[snip]
> +static int inactive_file_is_low_global(struct zone *zone)
> +{
> +	unsigned long active, inactive;
> +
> +	active = zone_page_state(zone, NR_ACTIVE_FILE);
> +	inactive = zone_page_state(zone, NR_INACTIVE_FILE);
> +
> +	return (active > inactive);
> +}
[snip]
>  static unsigned long shrink_list(enum lru_list lru, unsigned long nr_to_scan,
>  	struct zone *zone, struct scan_control *sc, int priority)
>  {
>  	int file = is_file_lru(lru);
>  
> -	if (lru == LRU_ACTIVE_FILE) {
> +	if (lru == LRU_ACTIVE_FILE && inactive_file_is_low(zone, sc)) {
>  		shrink_active_list(nr_to_scan, zone, sc, priority, file);
>  		return 0;
>  	}

Acked-by: Wu Fengguang <fengguang.wu@intel.com>

I like this idea - it's simple and sound, and is expected to work well
for the majority workloads. Sure the arbitrary 1:1 active:inactive ratio
may be suboptimal for many workloads, but it is mostly safe.

In the worse scenario, it could waste half the memory that could
otherwise be used for readahead buffer and to prevent thrashing, in a
server serving large datasets that are hardly reused, but still slowly
builds up its active list during the long uptime (think about a slowly
performance downgrade that can be fixed by a crude dropcache action).

That said, the actual performance degradation could be much smaller -
say 15% - all memories are not equal.

Thanks,
Fengguang
