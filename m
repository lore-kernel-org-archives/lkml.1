Return-Path: <linux-kernel-owner+w=401wt.eu-S1757352AbYGPOhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352AbYGPOhc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 10:37:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755511AbYGPOhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 10:37:24 -0400
Received: from tomts10.bellnexxia.net ([209.226.175.54]:63200 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754417AbYGPOhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 10:37:24 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtUEALijfUhMRKxB/2dsb2JhbACBWa8R
Date: Wed, 16 Jul 2008 10:37:19 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <peterz@infradead.org>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Masami Hiramatsu <mhiramat@redhat.com>,
       linux-mm@kvack.org, Dave Hansen <haveblue@us.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [patch 09/17] LTTng instrumentation - filemap
Message-ID: <20080716143719.GF24546@Krystal>
References: <20080715222604.331269462@polymtl.ca> <20080715222748.002421557@polymtl.ca> <1216197334.5232.24.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1216197334.5232.24.camel@twins>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:34:11 up 41 days, 19:15,  5 users,  load average: 3.41, 1.23,
	0.85
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Tue, 2008-07-15 at 18:26 -0400, Mathieu Desnoyers wrote:
> > plain text document attachment (lttng-instrumentation-filemap.patch)
> > Instrumentation of waits caused by memory accesses on mmap regions.
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
> > CC: linux-mm@kvack.org
> > CC: Dave Hansen <haveblue@us.ibm.com>
> > CC: Masami Hiramatsu <mhiramat@redhat.com>
> > CC: 'Peter Zijlstra' <peterz@infradead.org>
> > CC: "Frank Ch. Eigler" <fche@redhat.com>
> > CC: 'Ingo Molnar' <mingo@elte.hu>
> > CC: 'Hideo AOKI' <haoki@redhat.com>
> > CC: Takashi Nishiie <t-nishiie@np.css.fujitsu.com>
> > CC: 'Steven Rostedt' <rostedt@goodmis.org>
> > CC: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
> > ---
> >  include/trace/filemap.h |   13 +++++++++++++
> >  mm/filemap.c            |    3 +++
> >  2 files changed, 16 insertions(+)
> > 
> > Index: linux-2.6-lttng/mm/filemap.c
> > ===================================================================
> > --- linux-2.6-lttng.orig/mm/filemap.c	2008-07-15 14:51:50.000000000 -0400
> > +++ linux-2.6-lttng/mm/filemap.c	2008-07-15 15:14:46.000000000 -0400
> > @@ -33,6 +33,7 @@
> >  #include <linux/cpuset.h>
> >  #include <linux/hardirq.h> /* for BUG_ON(!in_atomic()) only */
> >  #include <linux/memcontrol.h>
> > +#include <trace/filemap.h>
> >  #include "internal.h"
> >  
> >  /*
> > @@ -541,9 +542,11 @@ void wait_on_page_bit(struct page *page,
> >  {
> >  	DEFINE_WAIT_BIT(wait, &page->flags, bit_nr);
> >  
> > +	trace_filemap_wait_start(page, bit_nr);
> >  	if (test_bit(bit_nr, &page->flags))
> >  		__wait_on_bit(page_waitqueue(page), &wait, sync_page,
> >  							TASK_UNINTERRUPTIBLE);
> > +	trace_filemap_wait_end(page, bit_nr);
> >  }
> >  EXPORT_SYMBOL(wait_on_page_bit);
> 
> I don't like the trace_filemap_wait_* naming..
> 

Me neither :)

> trace_wait_on_page_* might make more sense
> 

Yep, agreed,

Mathieu

> > Index: linux-2.6-lttng/include/trace/filemap.h
> > ===================================================================
> > --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> > +++ linux-2.6-lttng/include/trace/filemap.h	2008-07-15 15:14:46.000000000 -0400
> > @@ -0,0 +1,13 @@
> > +#ifndef _TRACE_FILEMAP_H
> > +#define _TRACE_FILEMAP_H
> > +
> > +#include <linux/tracepoint.h>
> > +
> > +DEFINE_TRACE(filemap_wait_start,
> > +	TPPROTO(struct page *page, int bit_nr),
> > +	TPARGS(page, bit_nr));
> > +DEFINE_TRACE(filemap_wait_end,
> > +	TPPROTO(struct page *page, int bit_nr),
> > +	TPARGS(page, bit_nr));
> > +
> > +#endif
> > 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
