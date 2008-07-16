Return-Path: <linux-kernel-owner+w=401wt.eu-S1758359AbYGPPED@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758359AbYGPPED (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 11:04:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755988AbYGPPDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 11:03:50 -0400
Received: from tomts43.bellnexxia.net ([209.226.175.110]:37559 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755682AbYGPPDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 11:03:49 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtUEAOSkfUhMRKxB/2dsb2JhbACBWa8d
Date: Wed, 16 Jul 2008 11:03:47 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <peterz@infradead.org>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Masami Hiramatsu <mhiramat@redhat.com>,
       Martin Bligh <mbligh@google.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [patch 12/17] LTTng instrumentation - page
Message-ID: <20080716150347.GJ24546@Krystal>
References: <20080715222604.331269462@polymtl.ca> <20080715222748.646777573@polymtl.ca> <1216197667.5232.30.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1216197667.5232.30.camel@twins>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:03:34 up 41 days, 19:44,  5 users,  load average: 0.31, 1.60,
	1.46
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Tue, 2008-07-15 at 18:26 -0400, Mathieu Desnoyers wrote:
> > plain text document attachment (lttng-instrumentation-page.patch)
> > Paging activity instrumentation. Instruments page allocation/free to keep track
> > of page allocation. This does not cover hugetlb activity, which is covered by a
> > separate patch.
> > 
> > Those tracepoints are used by LTTng.
> > 
> > About the performance impact of tracepoints (which is comparable to markers),
> > even without immediate values optimizations, tests done by Hideo Aoki on ia64
> > show no regression. His test case was using hackbench on a kernel where
> > scheduler instrumentation (about 5 events in code scheduler code) was added.
> > See the "Tracepoints" patch header for performance result detail.
> > 
> > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> > CC: Martin Bligh <mbligh@google.com>
> > CC: Masami Hiramatsu <mhiramat@redhat.com>
> > CC: 'Peter Zijlstra' <peterz@infradead.org>
> > CC: "Frank Ch. Eigler" <fche@redhat.com>
> > CC: 'Ingo Molnar' <mingo@elte.hu>
> > CC: 'Hideo AOKI' <haoki@redhat.com>
> > CC: Takashi Nishiie <t-nishiie@np.css.fujitsu.com>
> > CC: 'Steven Rostedt' <rostedt@goodmis.org>
> > CC: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
> > ---
> >  include/trace/page.h |   16 ++++++++++++++++
> >  mm/page_alloc.c      |    6 ++++++
> >  2 files changed, 22 insertions(+)
> > 
> > Index: linux-2.6-lttng/mm/page_alloc.c
> > ===================================================================
> > --- linux-2.6-lttng.orig/mm/page_alloc.c	2008-07-15 13:54:46.000000000 -0400
> > +++ linux-2.6-lttng/mm/page_alloc.c	2008-07-15 14:04:38.000000000 -0400
> > @@ -46,6 +46,7 @@
> >  #include <linux/page-isolation.h>
> >  #include <linux/memcontrol.h>
> >  #include <linux/debugobjects.h>
> > +#include <trace/page.h>
> >  
> >  #include <asm/tlbflush.h>
> >  #include <asm/div64.h>
> > @@ -510,6 +511,8 @@ static void __free_pages_ok(struct page 
> >  	int i;
> >  	int reserved = 0;
> >  
> > +	trace_page_free(page, order);
> > +
> >  	for (i = 0 ; i < (1 << order) ; ++i)
> >  		reserved += free_pages_check(page + i);
> >  	if (reserved)
> > @@ -966,6 +969,8 @@ static void free_hot_cold_page(struct pa
> >  	struct per_cpu_pages *pcp;
> >  	unsigned long flags;
> >  
> > +	trace_page_free(page, 0);
> > +
> >  	if (PageAnon(page))
> >  		page->mapping = NULL;
> >  	if (free_pages_check(page))
> > @@ -1630,6 +1635,7 @@ nopage:
> >  		show_mem();
> >  	}
> >  got_pg:
> > +	trace_page_alloc(page, order);
> >  	return page;
> >  }
> >  
> > Index: linux-2.6-lttng/include/trace/page.h
> > ===================================================================
> > --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> > +++ linux-2.6-lttng/include/trace/page.h	2008-07-15 14:04:38.000000000 -0400
> 
> This name seems inconsitent with your other choices.
> 
> include/traec/page_alloc.h comes to mind
> 

Yes, good idea, will fix.

Mathieu

> > @@ -0,0 +1,16 @@
> > +#ifndef _TRACE_PAGE_H
> > +#define _TRACE_PAGE_H
> > +
> > +#include <linux/tracepoint.h>
> > +
> > +/*
> > + * mm_page_alloc : page can be NULL.
> > + */
> > +DEFINE_TRACE(page_alloc,
> > +	TPPROTO(struct page *page, unsigned int order),
> > +	TPARGS(page, order));
> > +DEFINE_TRACE(page_free,
> > +	TPPROTO(struct page *page, unsigned int order),
> > +	TPARGS(page, order));
> > +
> > +#endif
> > 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
