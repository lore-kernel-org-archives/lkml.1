Return-Path: <linux-kernel-owner+w=401wt.eu-S1761644AbZCPS5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761644AbZCPS5Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 14:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761168AbZCPSzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 14:55:52 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:39060 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761029AbZCPSzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 14:55:51 -0400
Date: Mon, 16 Mar 2009 12:05:53 -0400 (EDT)
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
Subject: Re: [PATCH 18/35] Do not disable interrupts in free_page_mlock()
In-Reply-To: <1237196790-7268-19-git-send-email-mel@csn.ul.ie>
Message-ID: <alpine.DEB.1.10.0903161203230.32577@qirst.com>
References: <1237196790-7268-1-git-send-email-mel@csn.ul.ie> <1237196790-7268-19-git-send-email-mel@csn.ul.ie>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Mar 2009, Mel Gorman wrote:

> @@ -570,6 +570,8 @@ static void __free_pages_ok(struct page *page, unsigned int order)
>  	kernel_map_pages(page, 1 << order, 0);
>
>  	local_irq_save(flags);
> +	if (clearMlocked)
> +		free_page_mlock(page);
>  	__count_vm_events(PGFREE, 1 << order);
>  	free_one_page(page_zone(page), page, order,
>  					get_pageblock_migratetype(page));

Add an unlikely(clearMblocked) here?

> @@ -1036,6 +1039,9 @@ static void free_hot_cold_page(struct page *page, int cold)
>  	pcp = &zone_pcp(zone, get_cpu())->pcp;
>  	local_irq_save(flags);
>  	__count_vm_event(PGFREE);
> +	if (clearMlocked)
> +		free_page_mlock(page);
> +
>  	if (cold)
>  		list_add_tail(&page->lru, &pcp->list);
>  	else
>

Same here also make sure tha the __count_vm_events(PGFREE) comes after the
free_pages_mlock() to preserve symmetry with __free_pages_ok() and maybe
allow the compiler to do CSE between two invocations of
__count_vm_events().

