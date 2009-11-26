Return-Path: <linux-kernel-owner+w=401wt.eu-S1759906AbZKZIku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759906AbZKZIku (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 03:40:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759806AbZKZIku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 03:40:50 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55472 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759801AbZKZIkt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 03:40:49 -0500
Date: Thu, 26 Nov 2009 09:40:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, penberg@cs.helsinki.fi, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] events: Rename TRACE_EVENT_TEMPLATE() to
 DECLARE_EVENT_CLASS()
Message-ID: <20091126084039.GA15919@elte.hu>
References: <4B0E286A.2000405@cn.fujitsu.com>
 <tip-091ad3658e3c76c5fb05f65bfb64a0246f8f31b5@git.kernel.org>
 <1259224390.21397.87.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259224390.21397.87.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Thu, 2009-11-26 at 08:16 +0000, tip-bot for Ingo Molnar wrote:
> > Commit-ID:  091ad3658e3c76c5fb05f65bfb64a0246f8f31b5
> > Gitweb:     http://git.kernel.org/tip/091ad3658e3c76c5fb05f65bfb64a0246f8f31b5
> > Author:     Ingo Molnar <mingo@elte.hu>
> > AuthorDate: Thu, 26 Nov 2009 09:04:55 +0100
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Thu, 26 Nov 2009 09:04:55 +0100
> > 
> > events: Rename TRACE_EVENT_TEMPLATE() to DECLARE_EVENT_CLASS()
> > 
> > It is not quite obvious at first sight what TRACE_EVENT_TEMPLATE
> > does: does it define an event as well beyond defining a template?
> > 
> > To clarify this, rename it to DECLARE_EVENT_CLASS, which follows
> > the various 'DECLARE_*()' idioms we already have in the kernel:
> > 
> >   DECLARE_EVENT_CLASS(class)
> > 
> >     DEFINE_EVENT(class, event1)
> >     DEFINE_EVENT(class, event2)
> >     DEFINE_EVENT(class, event3)
> > 
> > To complete this logic we should also rename TRACE_EVENT() to:
> > 
> >   DEFINE_SINGLE_EVENT(single_event)
> > 
> > ... but in a more quiet moment of the kernel cycle.
> 
> 
> I would like to hear what others think about this change before we go 
> ahead and implement it.

You mean TRACE_EVENT() -> DEFINE_SINGLE_EVENT()? Sure, we want todo it 
in a more quiet moment of the kernel cycle, not now.

(TRACE_EVENT_TEMPLATE OTOH has existed for just a few days so it's not a 
problem.)

> A lot of developers have just learned about TRACE_EVENT and now it 
> just disappeared. Well, not really, but in the sense of ' find 
> linux.git -name '*.[ch]' | xargs grep TRACE_EVENT' it no longer 
> exists.

A second problem with the TRACE_EVENT name is that it's not just for 
tracing - we dont necessarily 'trace' events here. We can use the event 
callbacks to collect pure counts:

| aldebaran> perf stat -e sched:sched_wakeup ./hackbench 10
| Time: 0.093
|
|  Performance counter stats for './hackbench 10':
|
|           15481  sched:sched_wakeup      
|
|     0.107390574  seconds time elapsed

etc.

A third problem is that the name 'TRACE_EVENT' does not tell us what is 
being done. Do we declare it? Do we also define it?

DEFINE_SINGLE_EVENT() solves all these problems:

 - It's obvious what it does

 - It suggests users of it that there's another non-single-event 
   facility, gently nudging them towards the use of the more efficient
   DEFINE_EVENT_CLASS() + DEFINE_EVENT() method.

 - It fits nicely into the rest of the naming scheme.

	Ingo
