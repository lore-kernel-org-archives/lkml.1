Return-Path: <linux-kernel-owner+w=401wt.eu-S932330AbZFIMIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932330AbZFIMIf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 08:08:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932315AbZFIMIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 08:08:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34037 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932293AbZFIMIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 08:08:18 -0400
Date: Tue, 9 Jun 2009 14:07:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
       Christoph Hellwig <hch@infradead.org>, Rik van Riel <riel@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Jiaying Zhang <jiayingz@google.com>
Subject: Re: [RFC PATCH 0/5] simplify the print fmt in the event format
	files
Message-ID: <20090609120729.GB25586@elte.hu>
References: <20090609014534.790466803@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090609014534.790466803@goodmis.org>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> This is a request for comments on the new print format style to show
> in the format file.
> 
> As more and more users of ftrace are retrieving their data through
> the binary interface, it has become more important to be able to
> parse the format of these binary records.
> 
> Since the output may also be used in dumps of the kernel, it is still
> important that ftrace has a way within the kernel to display the
> data records in a human readable format.
> 
> The current method is with TP_printk, in the TRACE_EVENT. This acts
> just like a printk and lets the developer print out their format
> anyway they would like to. But the problem with this is that the
> readers of the binary data would either have to have a C parser to understand
> the output, or would have to have a custom made parser to match the
> contents, and hope that the contents would not change.
> 
> This patch series creates a new marco called TP_FORMAT that can be
> used in place of the TP_printk inside the TRACE_EVENT macro.
> 
> This format has the current following language:
> 
>  * FMT :=  constant string FMT | COMMAND FMT | empty
>  * COMMAND := <TYPE:FIELD> | <mask:FIELD:DELIM:MASKS> | <sym:FIELD:SYMBOLS> |
>  *               <if:FIELD:TRUE:FALSE>
>  * TYPE := int | hex | ptr | string | strarray
>  * FIELD := defined by the event structure
>  * MASKS := MASK=NAME,MASKS | MASK=NAME
>  * MASK := the bit mask to match
>  * DELIM := delimiter to separate the fields. None and ':' are both allowed
>  * SYMBOLS := SYM=NAME,SYMBOLS | SYM=NAME
>  * SYM := the symbol value to test against
>  * TRUE := print when field is non zero
>  * FALSE := print when field is zero or NULL
>  * NAME := the name to write when a match is found
>  *
>  * A '\<' would print '<'
> 
> We can extend this langange when we need to. A user app could just
> ignore a type it does not understand.
> 
> This is an RFC patch set. I basically just got it working but it lacks
> some clean ups on errors. And I need to investigate the use of the
> fields structures to make sure they are adquately protected. It uses
> the fields that are pased by the filter code.
> 
> This makes the output of the format much cleaner.

Agreed, it's clearly cleaner.

> 
> We go from this:
> 
>  print fmt: "irq=%d handler=%s", REC->irq, (char *)((void *)REC + REC->__data_loc_name)
> 
> to this:
> 
>  format: irq=<int:irq> handler=<string:name>
> 
> and this:
> 
>   print fmt: "softirq=%d action=%s", REC->vec, ({ static const struct trace_print_flags symbols[] = { { HI_SOFTIRQ, "HI" }, { TIMER_SOFTIRQ, "TIMER" }, { NET_TX_SOFTIRQ, "NET_TX" }, { NET_RX_SOFTIRQ, "NET_RX" }, { BLOCK_SOFTIRQ, "BLOCK" }, { TASKLET_SOFTIRQ, "TASKLET" }, { SCHED_SOFTIRQ, "SCHED" }, { HRTIMER_SOFTIRQ, "HRTIMER" }, { RCU_SOFTIRQ, "RCU" }, { -1, ((void *)0) }}; ftrace_print_symbols_seq (p, REC->vec, symbols); })
> 
> To this:
> 
> format: softirq=<int:vec> action=<sym:vec:0=HI,1=TIMER,2=NET_TX,3=NET_RX,4=BLOCK,5=TASKLET,6=SCHED,7=HRTIMER,8=RCU

Introducing new, elaborate description languages is always risky. 
Would there be a way to reuse something existing - ideally some nice 
sub-set of C structure definitions?

Also, would it be possible to put more newlines into the format, so 
that human inspection is more straightforward. It wont matter to the 
tools.

	Ingo
