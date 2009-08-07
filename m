Return-Path: <linux-kernel-owner+w=401wt.eu-S1757118AbZHGHxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757118AbZHGHxt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 03:53:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757087AbZHGHxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 03:53:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60152 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757070AbZHGHxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 03:53:48 -0400
Date: Fri, 7 Aug 2009 09:53:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Larry Woodman <lwoodman@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, riel@redhat.com,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH 3/6] tracing, page-allocator: Add trace event for page
	traffic related to the buddy lists
Message-ID: <20090807075317.GC20292@elte.hu>
References: <1249574827-18745-1-git-send-email-mel@csn.ul.ie> <1249574827-18745-4-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249574827-18745-4-git-send-email-mel@csn.ul.ie>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mel Gorman <mel@csn.ul.ie> wrote:

> +TRACE_EVENT(mm_page_pcpu_drain,
> +
> +	TP_PROTO(struct page *page, int order, int migratetype),
> +
> +	TP_ARGS(page, order, migratetype),
> +
> +	TP_STRUCT__entry(
> +		__field(	struct page *,	page		)
> +		__field(	int,		order		)
> +		__field(	int,		migratetype	)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->page		= page;
> +		__entry->order		= order;
> +		__entry->migratetype	= migratetype;
> +	),
> +
> +	TP_printk("page=%p pfn=%lu order=%d cpu=%d migratetype=%d",
> +		__entry->page,
> +		page_to_pfn(__entry->page),
> +		__entry->order,
> +		smp_processor_id(),
> +		__entry->migratetype)

> +	trace_mm_page_alloc_zone_locked(page, order, migratetype, order == 0);

This can be optimized further by omitting the migratetype field and 
adding something like this:

	TP_printk("page=%p pfn=%lu order=%d cpu=%d migratetype=%d",
		__entry->page,
		page_to_pfn(__entry->page),
		__entry->order,
		smp_processor_id(),
		__entry->order == 0);

The advantage is 4 bytes less in the record and a shorter tracepoint 
fast-path - while still having the same output.

	Ingo
