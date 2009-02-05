Return-Path: <linux-kernel-owner+w=401wt.eu-S1760684AbZBESDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760684AbZBESDr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 13:03:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755085AbZBESDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 13:03:32 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48966 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756098AbZBESDa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 13:03:30 -0500
Date: Thu, 5 Feb 2009 19:00:15 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] workqueue: not allow recursion run_workqueue
Message-ID: <20090205180015.GA28738@redhat.com>
References: <497838F0.7020408@cn.fujitsu.com> <20090122093046.GC5891@nowhere> <20090122093649.GD24758@elte.hu> <c62985530901220306p78ea541cs28912a844297b304@mail.gmail.com> <1232622615.4890.114.camel@laptop> <498AA0F1.2030003@cn.fujitsu.com> <20090205170156.GA25517@redhat.com> <20090205172429.GA23531@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090205172429.GA23531@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05, Frederic Weisbecker wrote:
>
> On Thu, Feb 05, 2009 at 06:01:56PM +0100, Oleg Nesterov wrote:
> > On 02/05, Lai Jiangshan wrote:
> > >
> > > DEADLOCK EXAMPLE for explain my above option:
> > >
> > > (work_func0() and work_func1() are work callback, and they
> > > calls flush_workqueue())
> > >
> > > CPU#0					CPU#1
> > > run_workqueue()                         run_workqueue()
> > >   work_func0()                            work_func1()
> > >     flush_workqueue()                       flush_workqueue()
> > >       flush_cpu_workqueue(0)                  .
> > >       flush_cpu_workqueue(cpu#1)              flush_cpu_workqueue(cpu#0)
> > >         waiting work_func1() in cpu#1           waiting work_func0 in cpu#0
> > >
> > > DEADLOCK!
> > 
> > I am not sure. Note that when work_func0() calls run_workqueue(),
> > it will clear cwq->current_work, so another flush_ on CPU#1 will
> > not wait for work_func0, no?
>
> No but CPU#1 can wait for a completion that will never be done, because
> CWQ#0 is waiting for CWQ#1.

Still can't understand. When work_func0()->run_workqueue() returns,
we should have no works in ->worklist and ->current_work must be NULL.
If we have a barrier which was inserted before - it should be flushed.


But yes, deadlock is possible, if other works come after run_workqueue()
returns and before work_func1() starts the flush. Just the description is
not exactly accurate, imho.

And we have other problems. Just to say, nothing can guarantee that
run_workqueue() will ever return. It is correct if some work_struct
always re-queues itself and should be cancelled before destroy_workqueue().

Oleg.

