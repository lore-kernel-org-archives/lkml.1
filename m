Return-Path: <linux-kernel-owner+w=401wt.eu-S1759398AbYGPIlO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759398AbYGPIlO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 04:41:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754319AbYGPIk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 04:40:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:48689 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240AbYGPIk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 04:40:58 -0400
Subject: Re: [patch 12/17] LTTng instrumentation - page
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Masami Hiramatsu <mhiramat@redhat.com>,
       Martin Bligh <mbligh@google.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
In-Reply-To: <20080715222748.646777573@polymtl.ca>
References: <20080715222604.331269462@polymtl.ca>
	 <20080715222748.646777573@polymtl.ca>
Content-Type: text/plain
Date: Wed, 16 Jul 2008 10:41:07 +0200
Message-Id: <1216197667.5232.30.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-15 at 18:26 -0400, Mathieu Desnoyers wrote:
> plain text document attachment (lttng-instrumentation-page.patch)
> Paging activity instrumentation. Instruments page allocation/free to keep track
> of page allocation. This does not cover hugetlb activity, which is covered by a
> separate patch.
> 
> Those tracepoints are used by LTTng.
> 
> About the performance impact of tracepoints (which is comparable to markers),
> even without immediate values optimizations, tests done by Hideo Aoki on ia64
> show no regression. His test case was using hackbench on a kernel where
> scheduler instrumentation (about 5 events in code scheduler code) was added.
> See the "Tracepoints" patch header for performance result detail.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> CC: Martin Bligh <mbligh@google.com>
> CC: Masami Hiramatsu <mhiramat@redhat.com>
> CC: 'Peter Zijlstra' <peterz@infradead.org>
> CC: "Frank Ch. Eigler" <fche@redhat.com>
> CC: 'Ingo Molnar' <mingo@elte.hu>
> CC: 'Hideo AOKI' <haoki@redhat.com>
> CC: Takashi Nishiie <t-nishiie@np.css.fujitsu.com>
> CC: 'Steven Rostedt' <rostedt@goodmis.org>
> CC: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
> ---
>  include/trace/page.h |   16 ++++++++++++++++
>  mm/page_alloc.c      |    6 ++++++
>  2 files changed, 22 insertions(+)
> 
> Index: linux-2.6-lttng/mm/page_alloc.c
> ===================================================================
> --- linux-2.6-lttng.orig/mm/page_alloc.c	2008-07-15 13:54:46.000000000 -0400
> +++ linux-2.6-lttng/mm/page_alloc.c	2008-07-15 14:04:38.000000000 -0400
> @@ -46,6 +46,7 @@
>  #include <linux/page-isolation.h>
>  #include <linux/memcontrol.h>
>  #include <linux/debugobjects.h>
> +#include <trace/page.h>
>  
>  #include <asm/tlbflush.h>
>  #include <asm/div64.h>
> @@ -510,6 +511,8 @@ static void __free_pages_ok(struct page 
>  	int i;
>  	int reserved = 0;
>  
> +	trace_page_free(page, order);
> +
>  	for (i = 0 ; i < (1 << order) ; ++i)
>  		reserved += free_pages_check(page + i);
>  	if (reserved)
> @@ -966,6 +969,8 @@ static void free_hot_cold_page(struct pa
>  	struct per_cpu_pages *pcp;
>  	unsigned long flags;
>  
> +	trace_page_free(page, 0);
> +
>  	if (PageAnon(page))
>  		page->mapping = NULL;
>  	if (free_pages_check(page))
> @@ -1630,6 +1635,7 @@ nopage:
>  		show_mem();
>  	}
>  got_pg:
> +	trace_page_alloc(page, order);
>  	return page;
>  }
>  
> Index: linux-2.6-lttng/include/trace/page.h
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6-lttng/include/trace/page.h	2008-07-15 14:04:38.000000000 -0400

This name seems inconsitent with your other choices.

include/traec/page_alloc.h comes to mind

> @@ -0,0 +1,16 @@
> +#ifndef _TRACE_PAGE_H
> +#define _TRACE_PAGE_H
> +
> +#include <linux/tracepoint.h>
> +
> +/*
> + * mm_page_alloc : page can be NULL.
> + */
> +DEFINE_TRACE(page_alloc,
> +	TPPROTO(struct page *page, unsigned int order),
> +	TPARGS(page, order));
> +DEFINE_TRACE(page_free,
> +	TPPROTO(struct page *page, unsigned int order),
> +	TPARGS(page, order));
> +
> +#endif
> 

