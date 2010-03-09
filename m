Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960Ab0CIPuy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 10:50:54 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:41890 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754923Ab0CIPut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 10:50:49 -0500
Date: Tue, 9 Mar 2010 09:50:15 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Mel Gorman <mel@csn.ul.ie>
cc: linux-mm@kvack.org, Nick Piggin <npiggin@suse.de>,
       Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
       Chris Mason <chris.mason@oracle.com>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] page-allocator: Under memory pressure, wait on
 pressure to relieve instead of congestion
In-Reply-To: <1268048904-19397-2-git-send-email-mel@csn.ul.ie>
Message-ID: <alpine.DEB.2.00.1003090946180.28897@router.home>
References: <1268048904-19397-1-git-send-email-mel@csn.ul.ie> <1268048904-19397-2-git-send-email-mel@csn.ul.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Mar 2010, Mel Gorman wrote:

> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 30fe668..72465c1 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -398,6 +398,9 @@ struct zone {
>  	unsigned long		wait_table_hash_nr_entries;
>  	unsigned long		wait_table_bits;
>
> +	/* queue for processes waiting for pressure to relieve */
> +	wait_queue_head_t	*pressure_wq;
> +
>  	/*

The waitqueue is in a zone? But allocation occurs by scanning a
list of possible zones.

> +long zonepressure_wait(struct zone *zone, unsigned int order, long timeout)

So zone specific.

>
> -		if (!page && gfp_mask & __GFP_NOFAIL)
> -			congestion_wait(BLK_RW_ASYNC, HZ/50);
> +		if (!page && gfp_mask & __GFP_NOFAIL) {
> +			/* If still failing, wait for pressure on zone to relieve */
> +			zonepressure_wait(preferred_zone, order, HZ/50);

The first zone is special therefore...

What happens if memory becomes available in another zone? Lets say we are
waiting on HIGHMEM and memory in ZONE_NORMAL becomes available?
