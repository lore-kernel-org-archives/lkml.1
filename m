Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374Ab0BOI3g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 03:29:36 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34899 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080Ab0BOI3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 03:29:34 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [patch 6/7 -mm] oom: avoid oom killer for lowmem allocations
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <alpine.DEB.2.00.1002100229410.8001@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1002100224210.8001@chino.kir.corp.google.com> <alpine.DEB.2.00.1002100229410.8001@chino.kir.corp.google.com>
Message-Id: <20100215172530.72A1.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 15 Feb 2010 17:29:29 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If memory has been depleted in lowmem zones even with the protection
> afforded to it by /proc/sys/vm/lowmem_reserve_ratio, it is unlikely that
> killing current users will help.  The memory is either reclaimable (or
> migratable) already, in which case we should not invoke the oom killer at
> all, or it is pinned by an application for I/O.  Killing such an
> application may leave the hardware in an unspecified state and there is
> no guarantee that it will be able to make a timely exit.
> 
> Lowmem allocations are now failed in oom conditions so that the task can
> perhaps recover or try again later.  Killing current is an unnecessary
> result for simply making a GFP_DMA or GFP_DMA32 page allocation and no
> lowmem allocations use the now-deprecated __GFP_NOFAIL bit so retrying is
> unnecessary.
> 
> Previously, the heuristic provided some protection for those tasks with 
> CAP_SYS_RAWIO, but this is no longer necessary since we will not be
> killing tasks for the purposes of ISA allocations.

The main difference of Kamezawasan's patch is, his patch treated DMA
zone is filled by mlocked page too.
but I personally think such case should be solved auto page migration
mechanism. (probably, mel's memory compaction patch provide its base
infrastructure). So this patch seems enough and proper.

	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


> 
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  mm/page_alloc.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1914,6 +1914,9 @@ rebalance:
>  	 * running out of options and have to consider going OOM
>  	 */
>  	if (!did_some_progress) {
> +		/* The oom killer won't necessarily free lowmem */
> +		if (high_zoneidx < ZONE_NORMAL)
> +			goto nopage;
>  		if ((gfp_mask & __GFP_FS) && !(gfp_mask & __GFP_NORETRY)) {
>  			if (oom_killer_disabled)
>  				goto nopage;
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>



