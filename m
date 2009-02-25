Return-Path: <linux-kernel-owner+w=401wt.eu-S1761459AbZBYJrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761459AbZBYJrT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 04:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754574AbZBYJrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 04:47:05 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42466 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752960AbZBYJrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 04:47:02 -0500
Date: Wed, 25 Feb 2009 01:44:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jason Baron <jbaron@redhat.com>, Martin Bligh <mbligh@google.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/4] tracing: add event trace infrastructure
Message-Id: <20090225014442.7b7b7726.akpm@linux-foundation.org>
In-Reply-To: <1235554387.3849.30.camel@penberg-laptop>
References: <20090225025608.956691460@goodmis.org>
	<20090225025753.798204550@goodmis.org>
	<20090224194548.3effb746.akpm@linux-foundation.org>
	<alpine.DEB.2.00.0902242252480.12697@gandalf.stny.rr.com>
	<20090224203308.8d623e0b.akpm@linux-foundation.org>
	<20090225081118.GC15303@elte.hu>
	<20090225002852.5ef5b869.akpm@linux-foundation.org>
	<84144f020902250100k41e55dd7w8a9c8d2ca96908ea@mail.gmail.com>
	<20090225012250.db68e480.akpm@linux-foundation.org>
	<1235554387.3849.30.camel@penberg-laptop>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Feb 2009 11:33:07 +0200 Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> Hi Andrew,
> 
> On Wed, 2009-02-25 at 01:22 -0800, Andrew Morton wrote:
> > irqsoff latency trace v1.1.5 on 2.6.26-rc8
> > --------------------------------------------------------------------
> >  latency: 97 us, #3/3, CPU#0 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:2)
> >     -----------------
> >     | task: swapper-0 (uid:0 nice:0 policy:0 rt_prio:0)
> >     -----------------
> >  => started at: apic_timer_interrupt
> >  => ended at:   do_softirq
> 
> <the header seems broken here, should have # at the beginning of the line>
> 
> > 
> > #                _------=> CPU#
> > #               / _-----=> irqs-off
> > #              | / _----=> need-resched
> > #              || / _---=> hardirq/softirq
> > #              ||| / _--=> preempt-depth
> > #              |||| /
> > #              |||||     delay
> > #  cmd     pid ||||| time  |   caller
> > #     \   /    |||||   \   |   /
> >   <idle>-0     0d..1    0us+: trace_hardirqs_off_thunk (apic_timer_interrupt)
> >   <idle>-0     0d.s.   97us : __do_softirq (do_softirq)
> >   <idle>-0     0d.s1   98us : trace_hardirqs_on (do_softirq)
> > 
> > your time starts now.
> 
> Well, what do you want to know? The first thing to do here is to:
> 
> $ grep -v "#" trace 
>   <idle>-0     0d..1    0us+: trace_hardirqs_off_thunk (apic_timer_interrupt)
>   <idle>-0     0d.s.   97us : __do_softirq (do_softirq)
>   <idle>-0     0d.s1   98us : trace_hardirqs_on (do_softirq)
> 
> after which you have access to the raw data. This particular trace seems
> to be somewhat hard to parse (because not all fields are whitespace
> delimited) but I can assure you that any format I rely on is not.

yes, but now you need to think about how this interface would have been
designed if we'd decided to access it with something smarter than
`cat'.

I mean, look at it.  All the multi-space column lining upping, the
unnecessary "us" annotation, the strange symbol(symbol) thing, etc. 
Plus it would have been more self-describing.  Right now, your parser
has to either assume that the second character of "0d..1" is
"irqs-off", or it has to learn how to follow ascii art lines.

Plus...  it's all English-only.

> So if you're arguing against specific ftrace plugins, go ahead (you
> probably have a fair point there). But please don't dismiss the while
> _concept_ of ftrace because of them.

Where on earth did that come from?

What I'm arguing against is putting English-only pretty-printers and
pretty-parsers on wrong side of int 80.  That's all.

