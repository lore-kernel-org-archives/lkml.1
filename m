Return-Path: <linux-kernel-owner+w=401wt.eu-S932308AbZGOU3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308AbZGOU3m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 16:29:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932283AbZGOU3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 16:29:42 -0400
Received: from smtp-out.google.com ([216.239.45.13]:25308 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932259AbZGOU3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 16:29:41 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=iWiX0IZiVxMfPxO36xZ+FfHXCgkY7dibM6Ni7GaSRsVVbAfTpW87E2Cjuq9tG80Wd
	cNOyCZWZIRXkutGYWoPLQ==
Date: Wed, 15 Jul 2009 13:29:33 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mel Gorman <mel@csn.ul.ie>
cc: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] page-allocator: Ensure that processes that have been
 OOM killed exit the page allocator (resend)
In-Reply-To: <20090715104944.GC9267@csn.ul.ie>
Message-ID: <alpine.DEB.2.00.0907151326350.22582@chino.kir.corp.google.com>
References: <20090715104944.GC9267@csn.ul.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jul 2009, Mel Gorman wrote:

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
> 

This only works for GFP_ATOMIC since the next iteration of the page 
allocator will (probably) fail reclaim and simply invoke the oom killer 
again, which will notice current has TIF_MEMDIE set and choose to do 
nothing, at which time the allocator simply loops again.
