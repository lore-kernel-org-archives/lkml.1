Return-Path: <linux-kernel-owner+w=401wt.eu-S1752113AbZIAHTO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113AbZIAHTO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 03:19:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751178AbZIAHTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 03:19:14 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45829 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbZIAHTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 03:19:13 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 1 Sep 2009 16:17:21 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
       lkml <linux-kernel@vger.kernel.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH mmotm] Fix NUMA accounting in numastat.txt
Message-Id: <20090901161721.f104c476.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090901135321.f0da4715.minchan.kim@barrios-desktop>
References: <20090901135321.f0da4715.minchan.kim@barrios-desktop>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Sep 2009 13:53:21 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> 
> In Documentation/numastat.txt, it confused me.
> For example, there are nodes [0,1] in system.
> 
> barrios:~$ cat /proc/zoneinfo | egrep 'numa|zone'
> Node 0, zone	DMA
> 	numa_hit	33226
> 	numa_miss	1739
> 	numa_foreign	27978
> 	..
> 	..
> Node 1, zone	DMA
> 	numa_hit	307
> 	numa_miss	46900
> 	numa_foreign	0
> 
> 1) In node 0,  NUMA_MISS means it wanted to allocate page
> in node 1 but ended up with page in node 0
> 
> 2) In node 0, NUMA_FOREIGN means it wanted to allocate page
> in node 0 but ended up with page from Node 1.
> 
> But now, numastat explains it oppositely about (MISS, FOREIGN).
> Let's fix up with viewpoint of zone. 
> 

I'm confused....documentation is really bad ?
Implementation isn't ?

Hmm, this function ?
==
void zone_statistics(struct zone *preferred_zone, struct zone *z)
{
        if (z->zone_pgdat == preferred_zone->zone_pgdat) {
                __inc_zone_state(z, NUMA_HIT);
        } else {
                __inc_zone_state(z, NUMA_MISS);
                __inc_zone_state(preferred_zone, NUMA_FOREIGN);
        }
        if (z->node == numa_node_id())
                __inc_zone_state(z, NUMA_LOCAL);
        else
                __inc_zone_state(z, NUMA_OTHER);
}
==
I wonder
==
void zone_statistics(struct zone *preferred_zone, struct zone *z)
{
        if (z->zone_pgdat == preferred_zone->zone_pgdat) {
                __inc_zone_state(z, NUMA_HIT);
        } else {
                __inc_zone_state(preferred_zone, NUMA_MISS);
                __inc_zone_state(z, NUMA_FOREIGN);
        }
        if (z->node == numa_node_id())
                __inc_zone_state(z, NUMA_LOCAL);
        else
                __inc_zone_state(z, NUMA_OTHER);
}
==
Is correct fix ....

Thanks,
-Kame


> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> ---
>  Documentation/numastat.txt |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/numastat.txt b/Documentation/numastat.txt
> index 80133ac..9fcc9a6 100644
> --- a/Documentation/numastat.txt
> +++ b/Documentation/numastat.txt
> @@ -7,10 +7,10 @@ All units are pages. Hugepages have separate counters.
> 
>  numa_hit			A process wanted to allocate memory from this node,
>  					and succeeded.
> -numa_miss			A process wanted to allocate memory from this node,
> -					but ended up with memory from another.
> -numa_foreign		A process wanted to allocate on another node,
> -				    but ended up with memory from this one.
> +numa_miss			A process wanted to allocate memory from another node,
> +					but ended up with memory from this node.
> +numa_foreign		A process wanted to allocate on this node,
> +				    but ended up with memory from another one.
>  local_node			A process ran on this node and got memory from it.
>  other_node			A process ran on this node and got memory from another node.
>  interleave_hit 		Interleaving wanted to allocate from this node
> --
> 1.5.4.3
> 
> 
> 
> -- 
> Kind regards,
> Minchan Kim
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 

