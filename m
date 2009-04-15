Return-Path: <linux-kernel-owner+w=401wt.eu-S1755240AbZDOBPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240AbZDOBPt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 21:15:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752901AbZDOBPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 21:15:39 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:16193 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972AbZDOBPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 21:15:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qLT6mCW3PI7tJnA9kPVo6K4KRNseUzJ3NDnJVE3zfCE06SwztkdaqH8qT6Q5NVpmkE
         KfQaF4xM9VorMTTs24MdFAZBc6m0/Zm74MB0gAcJYRSbbbed4XmWb3GDPIv1HEr/42a+
         Qlov+wEUf5L1qSZPbS5Asqi+b5fcFj8ccd7SI=
Date: Wed, 15 Apr 2009 03:15:34 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Zhaolei <zhaolei@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Tom Zanussi <tzanussi@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 5/4] ftrace, workqueuetrace: display work name
Message-ID: <20090415011533.GI5968@nowhere>
References: <20090414125142.C63D.A69D9226@jp.fujitsu.com> <20090414211620.GB5968@nowhere> <20090415085310.AC0D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090415085310.AC0D.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 15, 2009 at 08:55:31AM +0900, KOSAKI Motohiro wrote:
> > > ------------------------------
> > > # tracer: nop
> > > #
> > > #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
> > > #              | |       |          |         |
> > >           <idle>-0     [003]  1540.844960: workqueue_insertion: thread=events/3:30 func=e1000_watchdog_task+0x0/0x6ae [e1000e] work=&adapter->watchdog_task
> > >           <idle>-0     [003]  1540.844964: workqueue_insertion: thread=events/3:30 func=vmstat_update+0x0/0x3f work=vmstat_work
> > >            <...>-30    [003]  1540.844969: workqueue_handler_entry: thread=events/3:30 latency=0ms func=e1000_watchdog_task+0x0/0x6ae [e1000e] work=&adapter-
> > > >watchdog_task
> > >            <...>-30    [003]  1540.845003: workqueue_handler_exit: thread=events/3:30 func=e1000_watchdog_task+0x0/0x6ae [e1000e] work=&adapter->watchdog_tas
> > > k
> > >            <...>-30    [003]  1540.845004: workqueue_handler_entry: thread=events/3:30 latency=0ms func=vmstat_update+0x0/0x3f work=vmstat_work
> > >            <...>-30    [003]  1540.845007: workqueue_handler_exit: thread=events/3:30 func=vmstat_update+0x0/0x3f work=vmstat_work
> > > 
> > > This patch increase kernel-size for work name string table.
> > > But actually, lockdep already have work name string table. then if you already use lockdep,
> > > you don't get kernel-size increasing by this patch.
> > 
> > I don't know. Does it happen that frequently for a function to be used
> > by several works?
> > If so, this feature may be indeed interesting.
> 
> No, it's really rare.
> in last discuttion, "per work" tracing is one of the key-word.
> then, I add this.
> 
> but, if frequency is important, I can drop it.


Kosaki-san,

Perhaps you misunderstood me, which is easy because my english is
evil ;-)

We have to distinguish event tracing and statistical/histogram tracing
here.

Event tracing is about logging the events when they come and store
them one by one to output them later. That's what does TRACE_EVENT
for instance.

Statistical tracing doesn't store a trace of each event but instead
update some numbers after each event: number of events, maximum
latency, average, etc...

About event tracing, we want to have something that let us identifying
the events individually. For the works it can be either the function
embedeed in the work, or the work itself.
But do we need both? Since it's rare that a function can be embedeed in
more than two works, I guess we only need one of those informations.
Which one is the more efficient to identify a work? That can be discussed
actually.

When I talked about per-work tracing, it was in a generic way. What do we
use to identify each work individually: either the function or the work
name? Both seems accurate for that actually, the fact is that both can
be used for per-work tracing.

Actually my previous mails were focused on statistical tracing.

You proposed something that would result in the following final view:

	workqueue_name:pid	n_inserted n_executed cpu max_latency

And then by looking at the trace file, we can retrieve the work/function
that produced this max latency.

While I proposed this another idea:

	workqueue_name:pid	n_inserted n_executed cpu

	work1	latency_avg	latency_max
	work2	latency_avg	latency_max
	work3	latency_avg	latency_max
	.....

(We can have it with one file per workqueue).
work1 can be either the work name or the function executed though
the function is probably the main focus here because it's the
real source culprit.
But we can also output work_name:func

You see? With such output we see immediately which works are creating the
worst latencies.
And the event tracing is still very helpful here to have a more
fine grained tracing and see the behaviour of some works more precisely.

That's a kind of tracing process we can imagine:

- we start by looking at the statistics and indentify the wicked
  works/funcs.
- we look at the events on /debug/tracing/trace and, coupling with
  some well-chosen filters, we observe the behaviour of a work with
  more precision.


But I'm not opposite to your patch, I think it can be helpful to also
have the work name on certain circumstances.
But it makes the whole line a bit messy with a lot of informations for
those who only need the func name (or only the work name).
The best would be to have a runtime option to choose whether we want
to display it or not.

Frederic.

