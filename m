Return-Path: <linux-kernel-owner+w=401wt.eu-S1756126AbZFJR47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126AbZFJR47 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 13:56:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755217AbZFJR4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 13:56:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:51534 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755202AbZFJR4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 13:56:49 -0400
Date: Wed, 10 Jun 2009 13:56:50 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Christoph Hellwig <hch@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
       Rik van Riel <riel@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <peterz@infradead.org>, Theodore Tso <tytso@mit.edu>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Jiaying Zhang <jiayingz@google.com>
Subject: Re: [RFC PATCH 2/5] tracing/events: nicer print format for parsing
In-Reply-To: <20090610171648.GD31096@elte.hu>
Message-ID: <alpine.DEB.2.00.0906101353200.30552@gandalf.stny.rr.com>
References: <20090609014534.790466803@goodmis.org> <20090609014746.481457542@goodmis.org> <20090609192159.GD6057@nowhere> <20090610094819.GA25527@infradead.org> <20090610101124.GA25042@elte.hu> <alpine.DEB.2.00.0906100812370.30552@gandalf.stny.rr.com>
 <20090610171648.GD31096@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 10 Jun 2009, Ingo Molnar wrote:
> > 
> > I actually tried this first. But it breaks once we start getting types 
> > into the code:
> > 
> > print fmt: "call_site=%lx ptr=%p bytes_req=%zu bytes_alloc=%zu gfp_flags=%s",
> >           REC->call_site, REC->ptr, REC->bytes_req, REC->bytes_alloc, 
> >           (REC->gfp_flags) ? ({ static const struct trace_print_flags 
> >           flags[] = { {(unsigned long)(((gfp_t)0x10u) | ((gfp_t)0x40u) |
> >                       ((gfp_t)0x80u) | ((gfp_t)0x20000u) | ((gfp_t)0x02u) | 
> >                        ((gfp_t)0x100000u)), "GFP_HIGHUSER_MOVABLE"}, [...]
> > 
> > Will break on gfp_t. [...]
> 
> It wont break if we introduce a couple of common-sense types into 
> the parsing/translation code. gfp_t is well-known.
> 
> Modules wont be able to generate new dynamic types - but that's OK i 
> think, existing C types and common kernel types (and anything else 
> we add) ought to be plenty enough.
> 
> > [...] We also have cases where the enum name slips in too:
> > 
> > print fmt: "softirq=%d action=%s", REC->vec, ({ static const struct trace_print_flags symbols[] =
> >             { { HI_SOFTIRQ, "HI" }, { TIMER_SOFTIRQ, "TIMER" }, { NET_TX_SOFTIRQ, "NET_TX" },
> >               { NET_RX_SOFTIRQ, "NET_RX" }, { BLOCK_SOFTIRQ, "BLOCK" },
> >               { TASKLET_SOFTIRQ, "TASKLET" }, { SCHED_SOFTIRQ, "SCHED" },
> >               { HRTIMER_SOFTIRQ, "HRTIMER" }, { RCU_SOFTIRQ, "RCU" },
> >               { -1, ((void *)0) }}; ftrace_print_symbols_seq(p, REC->vec, symbols); })
> > 
> > Yes we can add special types for things like gfp_t, but as we get 
> > more and more users of TRACE_EVENT, the tools will never be able 
> > to keep up.
> 
> i still disagree. The tool will have to know about gfp_t in the tag 
> language too. So there's always going to be a constant expansion of 
> the type space.
> 
> The point is that the number of new types is an order of magnitude 
> less than the number of new tracepoints.
> 
> Also, with tools like perf in the kernel repo under tools/perf/, 
> we'll be able to keep up with mainline types very flexibly and very 
> accurately.

I rather include a C parser than require dynamic compiling of the code to 
read the file. The want to be able to read the binary data from other 
systems. The output could include the format, and the binary data.

I'm working on ways to make the printk output in the format file not so 
ugly. There's tricks I can still do with __get_str and friends. But this 
still does not solve the issues with enums.

But my CPP skills are starting to incur another boost, lets see what else 
I can come up with ;-)

-- Steve

