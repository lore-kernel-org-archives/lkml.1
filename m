Return-Path: <linux-kernel-owner+w=401wt.eu-S1755206AbZDVUG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206AbZDVUG2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 16:06:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751941AbZDVUGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 16:06:18 -0400
Received: from smtp-out.google.com ([216.239.33.17]:36473 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148AbZDVUGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 16:06:17 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=cl5jSAIrVTIgTbG0YgRYRNLxLy9NejxwPULXvw5EQLpqQx9WvmMZXOGjRWTJStFq1
	riVTZYy1oy+8dMlT+sJsA==
Date: Wed, 22 Apr 2009 13:06:07 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mel Gorman <mel@csn.ul.ie>
cc: Linux Memory Management List <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 18/22] Use allocation flags as an index to the zone
 watermark
In-Reply-To: <1240408407-21848-19-git-send-email-mel@csn.ul.ie>
Message-ID: <alpine.DEB.2.00.0904221251350.14558@chino.kir.corp.google.com>
References: <1240408407-21848-1-git-send-email-mel@csn.ul.ie> <1240408407-21848-19-git-send-email-mel@csn.ul.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Apr 2009, Mel Gorman wrote:

> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index b174f2c..6030f49 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1154,10 +1154,15 @@ failed:
>  	return NULL;
>  }
>  
> -#define ALLOC_NO_WATERMARKS	0x01 /* don't check watermarks at all */
> -#define ALLOC_WMARK_MIN		0x02 /* use pages_min watermark */
> -#define ALLOC_WMARK_LOW		0x04 /* use pages_low watermark */
> -#define ALLOC_WMARK_HIGH	0x08 /* use pages_high watermark */
> +/* The WMARK bits are used as an index zone->pages_mark */
> +#define ALLOC_WMARK_MIN		0x00 /* use pages_min watermark */
> +#define ALLOC_WMARK_LOW		0x01 /* use pages_low watermark */
> +#define ALLOC_WMARK_HIGH	0x02 /* use pages_high watermark */
> +#define ALLOC_NO_WATERMARKS	0x04 /* don't check watermarks at all */
> +
> +/* Mask to get the watermark bits */
> +#define ALLOC_WMARK_MASK	(ALLOC_NO_WATERMARKS-1)
> +
>  #define ALLOC_HARDER		0x10 /* try to alloc harder */
>  #define ALLOC_HIGH		0x20 /* __GFP_HIGH set */
>  #define ALLOC_CPUSET		0x40 /* check for correct cpuset */

The watermark flags should probably be members of an anonymous enum since 
they're being used as an index into an array.  If another watermark were 
ever to be added it would require a value of 0x03, for instance.

	enum {
		ALLOC_WMARK_MIN,
		ALLOC_WMARK_LOW,
		ALLOC_WMARK_HIGH,

		ALLOC_WMARK_MASK = 0xf	/* no more than 16 possible watermarks */
	};

This eliminates ALLOC_NO_WATERMARKS and the caller that uses it would 
simply pass 0.

> @@ -1445,12 +1450,7 @@ zonelist_scan:
>  
>  		if (!(alloc_flags & ALLOC_NO_WATERMARKS)) {

This would become

	if (alloc_flags & ALLOC_WMARK_MASK)
