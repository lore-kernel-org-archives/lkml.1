Return-Path: <linux-kernel-owner+w=401wt.eu-S1758833AbZCPSzB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758833AbZCPSzB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 14:55:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753830AbZCPSyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 14:54:49 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:52246 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbZCPSys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 14:54:48 -0400
Date: Mon, 16 Mar 2009 12:26:07 -0400 (EDT)
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
Subject: Re: [PATCH 26/35] Use the per-cpu allocator for orders up to
 PAGE_ALLOC_COSTLY_ORDER
In-Reply-To: <1237196790-7268-27-git-send-email-mel@csn.ul.ie>
Message-ID: <alpine.DEB.1.10.0903161222070.32577@qirst.com>
References: <1237196790-7268-1-git-send-email-mel@csn.ul.ie> <1237196790-7268-27-git-send-email-mel@csn.ul.ie>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Mar 2009, Mel Gorman wrote:

> -static void free_hot_cold_page(struct page *page, int cold)
> +static void free_hot_cold_page(struct page *page, int order, int cold)
>  {
>  	struct zone *zone = page_zone(page);
>  	struct per_cpu_pages *pcp;
>  	unsigned long flags;
>  	int clearMlocked = PageMlocked(page);
>
> +	/* SLUB can return lowish-order compound pages that need handling */
> +	if (order > 0 && unlikely(PageCompound(page)))
> +		if (unlikely(destroy_compound_page(page, order)))
> +			return;
> +

Isnt that also true for stacks and generic network objects ==- 8k?

>  again:
>  	cpu  = get_cpu();
> -	if (likely(order == 0)) {
> +	if (likely(order <= PAGE_ALLOC_COSTLY_ORDER)) {
>  		struct per_cpu_pages *pcp;
> +		int batch;
> +		int delta;
>
>  		pcp = &zone_pcp(zone, cpu)->pcp;
> +		batch = max(1, pcp->batch >> order);
>  		local_irq_save(flags);
>  		if (!pcp->count) {
> -			pcp->count = rmqueue_bulk(zone, 0,
> -					pcp->batch, &pcp->list, migratetype);
> +			delta = rmqueue_bulk(zone, order, batch,
> +					&pcp->list, migratetype);
> +			bulk_add_pcp_page(pcp, order, delta);
>  			if (unlikely(!pcp->count))
>  				goto failed;

The pcp adds a series of order N pages if an order N alloc occurs and the
queue is empty?

