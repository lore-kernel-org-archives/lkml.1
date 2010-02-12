Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545Ab0BLBcM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 20:32:12 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55554 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340Ab0BLBcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 20:32:10 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 12 Feb 2010 10:28:41 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 6/7 -mm] oom: avoid oom killer for lowmem allocations
Message-Id: <20100212102841.fa148baf.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.1002100229410.8001@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1002100224210.8001@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1002100229410.8001@chino.kir.corp.google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Feb 2010 08:32:21 -0800 (PST)
David Rientjes <rientjes@google.com> wrote:

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
> 
> Signed-off-by: David Rientjes <rientjes@google.com>

>From viewpoint of panic-on-oom lover, this patch seems to cause regression.
please do this check after sysctl_panic_on_oom == 2 test.
I think it's easy. So, temporary Nack to this patch itself.


And I think calling notifier is not very bad in the situation.
==
void out_of_memory()
 ..snip..
  blocking_notifier_call_chain(&oom_notify_list, 0, &freed);


So,

        if (sysctl_panic_on_oom == 2) {
                dump_header(NULL, gfp_mask, order, NULL);
                panic("out of memory. Compulsory panic_on_oom is selected.\n");
        }

	if (gfp_zone(gfp_mask) < ZONE_NORMAL) /* oom-kill is useless if lowmem is exhausted. */
		return;

is better. I think.

Thanks,
-Kame


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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

