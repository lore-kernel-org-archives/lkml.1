Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914Ab0BOGPl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 01:15:41 -0500
Received: from cantor.suse.de ([195.135.220.2]:44846 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753379Ab0BOGPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 01:15:40 -0500
Date: Mon, 15 Feb 2010 17:15:35 +1100
From: Nick Piggin <npiggin@suse.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       haicheng.li@intel.com, rientjes@google.com
Subject: Re: [PATCH] [4/4] SLAB: Fix node add timer race in cache_reap
Message-ID: <20100215061535.GI5723@laptop>
References: <20100211953.850854588@firstfloor.org>
 <20100211205404.085FEB1978@basil.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100211205404.085FEB1978@basil.firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 11, 2010 at 09:54:04PM +0100, Andi Kleen wrote:
> 
> cache_reap can run before the node is set up and then reference a NULL 
> l3 list. Check for this explicitely and just continue. The node
> will be eventually set up.

How, may I ask? cpuup_prepare in the hotplug notifier should always
run before start_cpu_timer.

> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> ---
>  mm/slab.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> Index: linux-2.6.32-memhotadd/mm/slab.c
> ===================================================================
> --- linux-2.6.32-memhotadd.orig/mm/slab.c
> +++ linux-2.6.32-memhotadd/mm/slab.c
> @@ -4093,6 +4093,9 @@ static void cache_reap(struct work_struc
>  		 * we can do some work if the lock was obtained.
>  		 */
>  		l3 = searchp->nodelists[node];
> +		/* Note node yet set up */
> +		if (!l3)
> +			break;
>  
>  		reap_alien(searchp, l3);
>  
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
