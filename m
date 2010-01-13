Return-Path: <linux-kernel-owner+w=401wt.eu-S1754086Ab0AMX20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab0AMX20 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 18:28:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752558Ab0AMX20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 18:28:26 -0500
Received: from smtp-out.google.com ([216.239.33.17]:44582 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983Ab0AMX2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 18:28:25 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=uHDnsWl7KkbE6pihrA+nk+FU5YX0tGsh67bwEY1P8DDTQ1wrROOcNj2Kb+cca3WCy
	4cuZ0COdpssLZpw40PKFg==
Date: Wed, 13 Jan 2010 15:28:16 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mel Gorman <mel@csn.ul.ie>
cc: Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 7/7] Do not compact within a preferred zone after a
 compaction failure
In-Reply-To: <1262795169-9095-8-git-send-email-mel@csn.ul.ie>
Message-ID: <alpine.DEB.2.00.1001131527050.18951@chino.kir.corp.google.com>
References: <1262795169-9095-1-git-send-email-mel@csn.ul.ie> <1262795169-9095-8-git-send-email-mel@csn.ul.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jan 2010, Mel Gorman wrote:

> The fragmentation index may indicate that a failure it due to external
> fragmentation, a compaction run complete and an allocation failure still
> fail. There are two obvious reasons as to why
> 
>   o Page migration cannot move all pages so fragmentation remains
>   o A suitable page may exist but watermarks are not met
> 
> In the event of compaction and allocation failure, this patch prevents
> compaction happening for a short interval. It's only recorded on the
> preferred zone but that should be enough coverage. This could have been
> implemented similar to the zonelist_cache but the increased size of the
> zonelist did not appear to be justified.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> ---
>  include/linux/mmzone.h |    7 +++++++
>  mm/page_alloc.c        |   15 ++++++++++++++-
>  2 files changed, 21 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 30fe668..1d6ccbe 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -328,6 +328,13 @@ struct zone {
>  	unsigned long		*pageblock_flags;
>  #endif /* CONFIG_SPARSEMEM */
>  
> +#ifdef CONFIG_MIGRATION
> +	/*
> +	 * If a compaction fails, do not try compaction again until
> +	 * jiffies is after the value of compact_resume
> +	 */
> +	unsigned long		compact_resume;
> +#endif

CONFIG_COMPACTION?

>  
>  	ZONE_PADDING(_pad1_)
>  
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 7275afb..9c86606 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1729,7 +1729,7 @@ __alloc_pages_direct_reclaim(gfp_t gfp_mask, unsigned int order,
>  	cond_resched();
>  
>  	/* Try memory compaction for high-order allocations before reclaim */
> -	if (order) {
> +	if (order && time_after(jiffies, preferred_zone->compact_resume)) {
>  		*did_some_progress = try_to_compact_pages(zonelist,
>  						order, gfp_mask, nodemask);
>  		if (*did_some_progress != COMPACT_INCOMPLETE) {
> @@ -1748,6 +1748,19 @@ __alloc_pages_direct_reclaim(gfp_t gfp_mask, unsigned int order,
>  			 * but not enough to satisfy watermarks.
>  			 */
>  			count_vm_event(COMPACTFAIL);
> +
> +			/*
> +			 * On failure, avoid compaction for a short time.
> +			 * XXX: This is very unsatisfactory. The failure
> +			 * 	to compact has nothing to do with time
> +			 * 	and everything to do with the requested
> +			 * 	order, the number of free pages and
> +			 * 	watermarks. How to wait on that is more
> +			 * 	unclear, but the answer would apply to
> +			 * 	other areas where the VM waits based on
> +			 * 	time.
> +			 */
> +			preferred_zone->compact_resume = jiffies + HZ/50;
>  		}
>  	}
>  

This will need to be moved to (another) inline function dependent on 
CONFIG_COMPACTION since we don't have zone->compact_resume without it; 
it's probably better to seperate the function out rather than add #ifdef's 
within __alloc_pages_direct_reclaim().
