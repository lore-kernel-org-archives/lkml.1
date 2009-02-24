Return-Path: <linux-kernel-owner+w=401wt.eu-S1758824AbZBXQx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758824AbZBXQx5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 11:53:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755431AbZBXQxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 11:53:48 -0500
Received: from smtp3.ultrahosting.com ([74.213.175.254]:54944 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753528AbZBXQxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 11:53:46 -0500
Date: Tue, 24 Feb 2009 11:43:29 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Mel Gorman <mel@csn.ul.ie>
cc: Linux Memory Management List <linux-mm@kvack.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 04/19] Convert gfp_zone() to use a table of precalculated
 values
In-Reply-To: <1235477835-14500-5-git-send-email-mel@csn.ul.ie>
Message-ID: <alpine.DEB.1.10.0902241112310.22519@qirst.com>
References: <1235477835-14500-1-git-send-email-mel@csn.ul.ie> <1235477835-14500-5-git-send-email-mel@csn.ul.ie>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Feb 2009, Mel Gorman wrote:

>  static inline enum zone_type gfp_zone(gfp_t flags)
>  {
> -#ifdef CONFIG_ZONE_DMA
> -	if (flags & __GFP_DMA)
> -		return ZONE_DMA;
> -#endif
> -#ifdef CONFIG_ZONE_DMA32
> -	if (flags & __GFP_DMA32)
> -		return ZONE_DMA32;
> -#endif
> -	if ((flags & (__GFP_HIGHMEM | __GFP_MOVABLE)) ==
> -			(__GFP_HIGHMEM | __GFP_MOVABLE))
> -		return ZONE_MOVABLE;
> -#ifdef CONFIG_HIGHMEM
> -	if (flags & __GFP_HIGHMEM)
> -		return ZONE_HIGHMEM;
> -#endif
> -	return ZONE_NORMAL;
> +	return gfp_zone_table[flags & GFP_ZONEMASK];
>  }

Aassume

GFP_DMA		= 0x01
GFP_DMA32	= 0x02
GFP_MOVABLE	= 0x04
GFP_HIGHMEM	= 0x08

ZONE_NORMAL	= 0
ZONE_DMA	= 1
ZONE_DMA32	= 2
ZONE_MOVABLE	= 3
ZONE_HIGHMEM	= 4

then we could implement gfp_zone simply as:

static inline enum zone_type gfp_zone(gfp_t flags)
{
	return ffs(flags & 0xf);
}

However, this would return ZONE_MOVABLE if only GFP_MOVABLE would be
set but not GFP_HIGHMEM.

If we could make sure that GFP_MOVABLE always includes GFP_HIGHMEM then
this would not be a problem.
