Return-Path: <linux-kernel-owner+w=401wt.eu-S1757712AbZFIBsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757712AbZFIBsu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 21:48:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756856AbZFIBru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 21:47:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:52698 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768AbZFIBrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 21:47:46 -0400
Message-Id: <20090609014534.790466803@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 08 Jun 2009 21:45:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
       Christoph Hellwig <hch@infradead.org>, Rik van Riel <riel@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Jiaying Zhang <jiayingz@google.com>
Subject: [RFC PATCH 0/5] simplify the print fmt in the event format files
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a request for comments on the new print format style to show
in the format file.

As more and more users of ftrace are retrieving their data through
the binary interface, it has become more important to be able to
parse the format of these binary records.

Since the output may also be used in dumps of the kernel, it is still
important that ftrace has a way within the kernel to display the
data records in a human readable format.

The current method is with TP_printk, in the TRACE_EVENT. This acts
just like a printk and lets the developer print out their format
anyway they would like to. But the problem with this is that the
readers of the binary data would either have to have a C parser to understand
the output, or would have to have a custom made parser to match the
contents, and hope that the contents would not change.

This patch series creates a new marco called TP_FORMAT that can be
used in place of the TP_printk inside the TRACE_EVENT macro.

This format has the current following language:

 * FMT :=  constant string FMT | COMMAND FMT | empty
 * COMMAND := <TYPE:FIELD> | <mask:FIELD:DELIM:MASKS> | <sym:FIELD:SYMBOLS> |
 *               <if:FIELD:TRUE:FALSE>
 * TYPE := int | hex | ptr | string | strarray
 * FIELD := defined by the event structure
 * MASKS := MASK=NAME,MASKS | MASK=NAME
 * MASK := the bit mask to match
 * DELIM := delimiter to separate the fields. None and ':' are both allowed
 * SYMBOLS := SYM=NAME,SYMBOLS | SYM=NAME
 * SYM := the symbol value to test against
 * TRUE := print when field is non zero
 * FALSE := print when field is zero or NULL
 * NAME := the name to write when a match is found
 *
 * A '\<' would print '<'

We can extend this langange when we need to. A user app could just
ignore a type it does not understand.

This is an RFC patch set. I basically just got it working but it lacks
some clean ups on errors. And I need to investigate the use of the
fields structures to make sure they are adquately protected. It uses
the fields that are pased by the filter code.

This makes the output of the format much cleaner.

We go from this:

 print fmt: "irq=%d handler=%s", REC->irq, (char *)((void *)REC + REC->__data_loc_name)

to this:

 format: irq=<int:irq> handler=<string:name>

and this:

  print fmt: "softirq=%d action=%s", REC->vec, ({ static const struct trace_print_flags symbols[] = { { HI_SOFTIRQ, "HI" }, { TIMER_SOFTIRQ, "TIMER" }, { NET_TX_SOFTIRQ, "NET_TX" }, { NET_RX_SOFTIRQ, "NET_RX" }, { BLOCK_SOFTIRQ, "BLOCK" }, { TASKLET_SOFTIRQ, "TASKLET" }, { SCHED_SOFTIRQ, "SCHED" }, { HRTIMER_SOFTIRQ, "HRTIMER" }, { RCU_SOFTIRQ, "RCU" }, { -1, ((void *)0) }}; ftrace_print_symbols_seq (p, REC->vec, symbols); })

To this:

format: softirq=<int:vec> action=<sym:vec:0=HI,1=TIMER,2=NET_TX,3=NET_RX,4=BLOCK,5=TASKLET,6=SCHED,7=HRTIMER,8=RCU

And finally this:

print fmt: "call_site=%lx ptr=%p bytes_req=%zu bytes_alloc=%zu gfp_flags=%s", REC->call_site, REC->ptr, REC->bytes_req, REC->bytes_alloc, (REC->gfp_flags) ? ({ static const struct trace_print_flags flags[] = { {(unsigned long)(((gfp_t)0x10u
) | ((gfp_t)0x40u) | ((gfp_t)0x80u) | ((gfp_t)0x20000u) | ((gfp_t)0x02u) | ((gfp_t)0x100000u)), "GFP_HIGHUSER_MOVABLE"}, {(unsigned long)(((gfp_t)0x10u) | ((gfp_t)0x40u) | ((gfp_t)0x80u) | ((gfp_t)0x20000u) | ((gfp_t)0x02u)), "GFP_HIGHUSER" }, {(unsigned long)(((gfp_t)0x10u) | ((gfp_t)0x40u) | ((gfp_t)0x80u) | ((gfp_t)0x20000u)), "GFP_USER"}, {(unsigned long)(((gfp_t)0x10u) | ((gfp_t)0x40u) | ((gfp_t)0x80u) | ((gfp_t)0x80000u)), "GFP_TEMPORARY"}, {(unsigned long)(((gfp_t)0x10u) | ((gfp_t)0x40u) | ((gfp_t)0x80u)), "GFP_KERNEL"}, {(unsigned long)(((gfp_t)0x10u) | ((gfp_t)0x40u)), "GFP_NOFS"}, {(unsigned long)(((gfp_t)0x20u)), "GFP_ATOMIC"}, {(unsigned long)(((gfp_t)0x10u)), "GFP_NOIO"}, {(unsigned long)((gfp_t)0x20u), "GFP_HIGH"}, {(unsigned long)((gfp_t)0x10u), "GFP_WAIT"}, {(unsigned long)((gfp_t)0x40u), "GFP_IO"}, {(unsigned long)((gfp_t)0x100u), "GFP_COLD"}, {(unsigned long)((gfp_t)0x200u), "GFP_NOWARN"}, {(unsigned long)((gfp_t)0x400u), "GFP_REPEAT"}, {(unsigned long)((gfp_t)0x800u), "GFP_NOFAIL"}, {(unsigned long)((gfp_t)0x1000u), "GFP_NORETRY"}, {(unsigned long)((gfp_t)0x4000u), "GFP_COMP"}, {(unsigned long)((gfp_t)0x8000u), "GFP_ZERO"}, {(unsigned long)((gfp_t)0x10000u), "GFP_NOMEMALLOC"}, {(unsigned long)((gfp_t)0x20000u), "GFP_HARDWALL"}, {(unsigned long)((gfp_t)0x40000u), "GFP_THISNODE"}, {(unsigned long)((gfp_t)0x80000u), "GFP_RECLAIMABLE"}, {(unsigned long)((gfp_t)0x100000u), "GFP_MOVABLE"}, { -1, ((void *)0) }}; ftrace_print_flags_seq(p, "|", REC->gfp_flags, flags); }) : "GFP_NOWAIT"

to this:

 format: call_site=<hex:call_site> ptr=<ptr:ptr> bytes_req=<int:bytes_req> bytes_alloc=<int:bytes_alloc> gfp_flags=<mask:gfp_flags:|:0=GFP_NOWAIT,0x1200d2=GFP_HIGHUSER_MOVABLE,0x200d2=GFP_HIGHUSER,0x200d0=GFP_USER,0x800d0=GFP_TEMPORARY,0xd0=GFP_KERNEL,0x50=GFP_NOFS,0x20=GFP_ATOMIC,0x10=GFP_NOIO,0x20=GFP_HIGH,0x10=GFP_WAIT,0x40=GFP_IO,0x100=GFP_COLD,0x200=GFP_NOWARN,0x400=GFP_REPEAT,0x800=GFP_NOFAIL,0x1000=GFP_NORETRY,0x4000=GFP_COMP,0x8000=GFP_ZERO,0x10000=GFP_NOMEMALLOC,0x20000=GFP_HARDWALL,0x40000=GFP_THISNODE,0x80000=GFP_RECLAIMABLE,0x100000=GFP_MOVABLE

Note that the old format has "print fmt" where as the new has just "format", 
this will allow for userspace apps to differentiate between the two.

 The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: tip/tracing/event-print-format


Steven Rostedt (5):
      tracing: add trace_seq_vprint interface
      tracing/events: nicer print format for parsing
      tracing/events: modify irq print to new format
      tracing/events: modify sched print to new format
      tracing/events: modify kmem print to new format

----
 include/linux/ftrace_event.h     |   10 +
 include/linux/trace_seq.h        |    2 +
 include/trace/events/irq.h       |   35 +-
 include/trace/events/kmem.h      |   97 +++---
 include/trace/events/sched.h     |   49 +--
 include/trace/ftrace.h           |   22 ++-
 kernel/trace/Makefile            |    1 +
 kernel/trace/trace_output.c      |   32 ++
 kernel/trace/trace_read_binary.c |  674 ++++++++++++++++++++++++++++++++++++++
 9 files changed, 815 insertions(+), 107 deletions(-)
-- 
