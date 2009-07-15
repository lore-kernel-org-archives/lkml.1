Return-Path: <linux-kernel-owner+w=401wt.eu-S932311AbZGOUaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932311AbZGOUaa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 16:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932283AbZGOUaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 16:30:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40065 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932117AbZGOUaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 16:30:30 -0400
Date: Wed, 15 Jul 2009 13:30:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: rientjes@google.com, npiggin@suse.de, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] page-allocator: Ensure that processes that have been
 OOM killed exit the page allocator (resend)
Message-Id: <20090715133014.a3566bdd.akpm@linux-foundation.org>
In-Reply-To: <20090715104944.GC9267@csn.ul.ie>
References: <20090715104944.GC9267@csn.ul.ie>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jul 2009 11:49:45 +0100
Mel Gorman <mel@csn.ul.ie> wrote:

> Processes that have been OOM killed set the thread flag TIF_MEMDIE. A process
> such as this is expected to exit the page allocator but potentially, it
> loops forever. This patch checks TIF_MEMDIE when deciding whether to loop
> again in the page allocator. If set, and __GFP_NOFAIL is not specified
> then the loop will exit on the assumption it's no longer important for the
> process to make forward progress. Note that a process that has just been
> OOM-killed will still loop at least one more time retrying the allocation
> before the thread flag is checked.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> --- 
>  mm/page_alloc.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index f8902e7..5c98d02 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1547,6 +1547,14 @@ should_alloc_retry(gfp_t gfp_mask, unsigned int order,
>  	if (gfp_mask & __GFP_NORETRY)
>  		return 0;
>  
> +	/* Do not loop if OOM-killed unless __GFP_NOFAIL is specified */
> +	if (test_thread_flag(TIF_MEMDIE)) {
> +		if (gfp_mask & __GFP_NOFAIL)
> +			WARN(1, "Potential infinite loop with __GFP_NOFAIL");
> +		else
> +			return 0;
> +	}
> +
>  	/*
>  	 * In this implementation, order <= PAGE_ALLOC_COSTLY_ORDER
>  	 * means __GFP_NOFAIL, but that may not be true in other

This fixes a post-2.6.30 regression, yes?

I dug out the commit ID a while back but lost it. Ho hum.
