Return-Path: <linux-kernel-owner+w=401wt.eu-S1762351AbXINBp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762351AbXINBp6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 21:45:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753045AbXINBpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 21:45:50 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60381 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752698AbXINBpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 21:45:49 -0400
Date: Thu, 13 Sep 2007 18:44:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Andy Whitcroft <apw@shadowen.org>, Paul Mundt <lethal@linux-sh.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH -mm] mm: Fix memory hotplug + sparsemem build.
Message-Id: <20070913184456.16ff248e.akpm@linux-foundation.org>
In-Reply-To: <20070911182546.F139.Y-GOTO@jp.fujitsu.com>
References: <20070911170921.F137.Y-GOTO@jp.fujitsu.com>
	<20070911091516.GE6288@shadowen.org>
	<20070911182546.F139.Y-GOTO@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Sep 2007 18:37:12 +0900 Yasunori Goto <y-goto@jp.fujitsu.com> wrote:

> 
> > > +	if (onlined_pages){
> > 
> > Nit, needs a space there before the '{'.
> 
> Ah, Ok. I attached fixed patch in this mail.
> 
> > The problem as I see it is that when we boot the system we start a
> > kswapd on all nodes with memory.  If the hot-add adds memory to a
> > pre-existing node with no memory we will not start one and we end up
> > with a node with memory and no kswapd.  Bad.
> > 
> > As kswapd_run is a no-op when a kswapd already exists this seems a safe
> > way to fix that.  Paul's ->zone conversion is obviously correct also.
> > 
> > Acked-by: Andy Whitcroft <apw@shadowen.org>
> 
> Thanks for your explanation.
> You mentioned all of my intention correctly. :-)
> 
> 
> ----
> 
> Fix kswapd doesn't run when memory is added on memory-less-node.
> Fix compile error of zone->node when CONFIG_NUMA is off.
> 
> Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
> Signed-off-by: Paul Mundt <lethal@linux-sh.org>
> Acked-by: Andy Whitcroft <apw@shadowen.org>
> 
> 
> ---
>  mm/memory_hotplug.c |    9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> Index: current/mm/memory_hotplug.c
> ===================================================================
> --- current.orig/mm/memory_hotplug.c	2007-09-07 18:08:07.000000000 +0900
> +++ current/mm/memory_hotplug.c	2007-09-11 17:29:19.000000000 +0900
> @@ -211,10 +211,12 @@ int online_pages(unsigned long pfn, unsi
>  		online_pages_range);
>  	zone->present_pages += onlined_pages;
>  	zone->zone_pgdat->node_present_pages += onlined_pages;
> -	if (onlined_pages)
> -		node_set_state(zone->node, N_HIGH_MEMORY);
>  
>  	setup_per_zone_pages_min();
> +	if (onlined_pages) {
> +		kswapd_run(zone_to_nid(zone));
> +		node_set_state(zone_to_nid(zone), N_HIGH_MEMORY);
> +	}
>  
>  	if (need_zonelists_rebuild)
>  		build_all_zonelists();
> @@ -269,9 +271,6 @@ int add_memory(int nid, u64 start, u64 s
>  		if (!pgdat)
>  			return -ENOMEM;
>  		new_pgdat = 1;
> -		ret = kswapd_run(nid);
> -		if (ret)
> -			goto error;
>  	}
>  
>  	/* call arch's memory hotadd */
> 

OK, we're getting into a mess here.  This patch fixes
update-n_high_memory-node-state-for-memory-hotadd.patch, but which patch
does update-n_high_memory-node-state-for-memory-hotadd.patch fix?

At present I just whacked
update-n_high_memory-node-state-for-memory-hotadd.patch at the end of
everything, but that was lazy of me and it ends up making a mess.

