Return-Path: <linux-kernel-owner+w=401wt.eu-S1757173AbZHGIDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173AbZHGIDg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 04:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757041AbZHGIDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 04:03:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59528 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755187AbZHGIDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 04:03:32 -0400
Date: Fri, 7 Aug 2009 10:02:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Larry Woodman <lwoodman@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, riel@redhat.com,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH 2/6] tracing, page-allocator: Add trace events for
	anti-fragmentation falling back to other migratetypes
Message-ID: <20090807080249.GA21821@elte.hu>
References: <1249574827-18745-1-git-send-email-mel@csn.ul.ie> <1249574827-18745-3-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249574827-18745-3-git-send-email-mel@csn.ul.ie>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mel Gorman <mel@csn.ul.ie> wrote:

> +++ b/mm/page_alloc.c
> @@ -839,6 +839,12 @@ __rmqueue_fallback(struct zone *zone, int order, int start_migratetype)
>  							start_migratetype);
>  
>  			expand(zone, page, order, current_order, area, migratetype);
> +
> +			trace_mm_page_alloc_extfrag(page, order, current_order,
> +				start_migratetype, migratetype,
> +				current_order < pageblock_order,
> +				migratetype == start_migratetype);

This tracepoint too should be optimized some more:

 - pageblock_order can be passed down verbatim instead of the 
   'current_order < pageblock_order': it means one comparison less 
   in the fast-path, plus it gives more trace information as well.

 - migratetype == start_migratetype check is superfluous as both 
   values are already traced. This property can be added to the 
   TP_printk() post-processing stage instead, if the pretty-printing 
   is desired.

	Ingo
