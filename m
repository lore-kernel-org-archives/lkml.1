Return-Path: <linux-kernel-owner+w=401wt.eu-S1754838AbZBPVf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbZBPVf5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 16:35:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750941AbZBPVfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 16:35:48 -0500
Received: from mx2.redhat.com ([66.187.237.31]:55942 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727AbZBPVfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 16:35:47 -0500
Date: Mon, 16 Feb 2009 22:32:05 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: Q: smp.c && barriers (Was: [PATCH 1/4] generic-smp: remove
	single ipi fallback for smp_call_function_many())
Message-ID: <20090216213205.GA9098@redhat.com>
References: <20090216163847.431174825@chello.nl> <20090216164114.433430761@chello.nl> <20090216204902.GA6924@redhat.com> <1234818201.30178.386.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234818201.30178.386.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16, Peter Zijlstra wrote:
>
> On Mon, 2009-02-16 at 21:49 +0100, Oleg Nesterov wrote:
> > I am trying to understand the barriers in smp.c, please help!
> >
> > "generic-ipi: fix the smp_mb() placement" commit
> > 561920a0d2bb6d63343e83acfd784c0a77bd28d1 added smp_read_barrier_depends()
> > to generic_smp_call_function_single_interrupt().
> >
> > Why it is needed? The comment says:
> >
> > 	/*
> > 	 * Need to see other stores to list head for checking whether
> > 	 * list is empty without holding q->lock
> > 	 */
> > 	smp_read_barrier_depends();
> > 	while (!list_empty(&q->list)) {
> >
> > But we can't miss the addition to the call_single_queue.list,
> > if generic_exec_single() sees list_empty(&dst->list) it sends
> > another IPI?
>
> I was about to write a response, but found it to be a justification for
> the read_barrier_depends() at the end of the loop.

I forgot to mention I don't understand the read_barrier_depends() at the
end of the loop as well ;)

> > This commit also removed the barrier from csd_flag_wait(), is this OK?
> > Without the barrier, csd_flag_wait() can return before we see the result
> > of data->func() ?
> >
> > IOW,
> > 	int VAR = 0;
> >
> > 	void func(coid *unused)
> > 	{
> > 		VAR = 1;
> > 	}
> >
> > Now,
> >
> > 	smp_call_function_single(0, func, NULL, 1);
> > 	BUG_ON(VAR == 0);
> >
> > afaics, the BUG_ON() above is possible. Is this OK ?
>
> Would it not be the caller's responsibility to provide the needed
> serialization in this case?

Yes, yes, I don't claim this is necessary wrong. I am just asking,
is the lack of "implicit" serialization is "by design" or this was
an oversight.

Oleg.

