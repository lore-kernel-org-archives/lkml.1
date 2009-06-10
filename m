Return-Path: <linux-kernel-owner+w=401wt.eu-S1758585AbZFJMSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758585AbZFJMSY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 08:18:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753275AbZFJMSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 08:18:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:65061 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138AbZFJMSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 08:18:15 -0400
Date: Wed, 10 Jun 2009 08:18:15 -0400 (EDT)
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
In-Reply-To: <20090610101124.GA25042@elte.hu>
Message-ID: <alpine.DEB.2.00.0906100812370.30552@gandalf.stny.rr.com>
References: <20090609014534.790466803@goodmis.org> <20090609014746.481457542@goodmis.org> <20090609192159.GD6057@nowhere> <20090610094819.GA25527@infradead.org> <20090610101124.GA25042@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 10 Jun 2009, Ingo Molnar wrote:
> 
> And i kind of like the whole notion on a design level as weell: the 
> kernel exporting C source code for tools :-)
> 
> 	Ingo
> 
> ------------------>
> 
> struct record {
> 	unsigned short common_type;
> 	unsigned char common_flags;
> 	unsigned char common_preempt;
> 	int common_pid;
> 	int common_tgid;
> 	int dev;
> 	unsigned long long sector;
> 	unsigned int nr_sector;
> 	char rwbs[6];
> 	char comm[16];
> } this_record = { 1, 2, 3, 4, 5, 6, 7, 8, { 'a', }, "abc" };
> 
> void main(void)
> {
> 	struct record *REC = &this_record;
> 
> 	printf("%d,%d %s %llu + %u [%s]", ((unsigned int) ((REC->dev) >> 20)), ((unsigned int) ((REC->dev) & ((1U << 20) - 1))), REC->rwbs, (unsigned long long)REC->sector, REC->nr_sector, REC->comm);
> }

I actually tried this first. But it breaks once we start getting types 
into the code:

print fmt: "call_site=%lx ptr=%p bytes_req=%zu bytes_alloc=%zu gfp_flags=%s",
          REC->call_site, REC->ptr, REC->bytes_req, REC->bytes_alloc, 
          (REC->gfp_flags) ? ({ static const struct trace_print_flags 
          flags[] = { {(unsigned long)(((gfp_t)0x10u) | ((gfp_t)0x40u) |
                      ((gfp_t)0x80u) | ((gfp_t)0x20000u) | ((gfp_t)0x02u) | 
                       ((gfp_t)0x100000u)), "GFP_HIGHUSER_MOVABLE"}, [...]

Will break on gfp_t. We also have cases where the enum name slips in too:

print fmt: "softirq=%d action=%s", REC->vec, ({ static const struct trace_print_flags symbols[] =
            { { HI_SOFTIRQ, "HI" }, { TIMER_SOFTIRQ, "TIMER" }, { NET_TX_SOFTIRQ, "NET_TX" },
              { NET_RX_SOFTIRQ, "NET_RX" }, { BLOCK_SOFTIRQ, "BLOCK" },
              { TASKLET_SOFTIRQ, "TASKLET" }, { SCHED_SOFTIRQ, "SCHED" },
              { HRTIMER_SOFTIRQ, "HRTIMER" }, { RCU_SOFTIRQ, "RCU" },
              { -1, ((void *)0) }}; ftrace_print_symbols_seq(p, REC->vec, symbols); })

Yes we can add special types for things like gfp_t, but as we get more and 
more users of TRACE_EVENT, the tools will never be able to keep up.

-- Steve

