Return-Path: <linux-kernel-owner+w=401wt.eu-S1757108AbZHGHvG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757108AbZHGHvG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 03:51:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757024AbZHGHvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 03:51:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48203 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755560AbZHGHvE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 03:51:04 -0400
Date: Fri, 7 Aug 2009 09:50:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Larry Woodman <lwoodman@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, riel@redhat.com,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH 1/6] tracing, page-allocator: Add trace events for page
	allocation and page freeing
Message-ID: <20090807075030.GB20292@elte.hu>
References: <1249574827-18745-1-git-send-email-mel@csn.ul.ie> <1249574827-18745-2-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249574827-18745-2-git-send-email-mel@csn.ul.ie>
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

> +TRACE_EVENT(mm_pagevec_free,

> +	TP_fast_assign(
> +		__entry->page		= page;
> +		__entry->order		= order;
> +		__entry->cold		= cold;
> +	),

> -	while (--i >= 0)
> +	while (--i >= 0) {
> +		trace_mm_pagevec_free(pvec->pages[i], 0, pvec->cold);
>  		free_hot_cold_page(pvec->pages[i], pvec->cold);
> +	}

Pagevec freeing has order 0 implicit, so you can further optimize 
this by leaving out the 'order' field and using this format string:

+	TP_printk("page=%p pfn=%lu order=0 cold=%d",
+                       __entry->page,
+                       page_to_pfn(__entry->page),
+                       __entry->cold)

the trace record becomes smaller by 4 bytes and the tracepoint 
fastpath becomes shorter as well.

	Ingo
