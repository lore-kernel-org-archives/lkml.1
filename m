Return-Path: <linux-kernel-owner+w=401wt.eu-S1754295AbZBPUzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295AbZBPUzc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 15:55:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752015AbZBPUzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 15:55:23 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:56142 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883AbZBPUzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 15:55:23 -0500
Subject: Re: [PATCH 1/4] generic-smp: remove single ipi fallback for
 smp_call_function_many()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20090216203055.GA5135@redhat.com>
References: <20090216163847.431174825@chello.nl>
	 <20090216164114.433430761@chello.nl> <20090216191008.GA1521@redhat.com>
	 <1234813292.30178.327.camel@laptop>  <20090216203055.GA5135@redhat.com>
Content-Type: text/plain
Date: Mon, 16 Feb 2009 21:55:01 +0100
Message-Id: <1234817701.30178.380.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-16 at 21:30 +0100, Oleg Nesterov wrote:
> On 02/16, Peter Zijlstra wrote:
> >
> > On Mon, 2009-02-16 at 20:10 +0100, Oleg Nesterov wrote:
> > > Actually I don't understand the counter/free_list logic.
> > >
> > > 	generic_smp_call_function_interrupt:
> > >
> > > 			/*
> > > 			 * When the global queue is empty, its guaranteed that no cpu
> > > 			 * is still observing any entry on the free_list, therefore
> > > 			 * we can go ahead and unlock them.
> > > 			 */
> > > 			if (!--call_function.counter)
> > > 				list_splice_init(&call_function.free_list, &free_list);
> > >
> > > I can't see why "its guaranteed that no cpu ...". Let's suppose CPU 0
> > > "hangs" for some reason in generic_smp_call_function_interrupt() right
> > > before "if (!cpumask_test_cpu(cpu, data->cpumask))" test. Then it is
> > > possible that another CPU removes the single entry (which doesn't have
> > > CPU 0 in data->cpumask) from call_function.queue.
> >
> > Then call_function.counter wouldn't be 0, and we would not release the
> > list entries.
> 
> Why it wouldn't be 0? IOW, do you mean that the spurious CALL_FUNCTION_VECTOR
> is not possible?

Ah, I think I see what you mean, you're right. I should not be counting
the number of entries in the queue, for when the last one gets removed
does not correlate to another observing entries.

> > > Now, if that entry is re-added, we can have a problem if CPU 0 sees
> > > the partly initialized entry.
> >
> > Right, so the scenario is that a cpu observes the list entry after we do
> > list_del_rcu() -- most likely a cpu not in the original mask, taversing
> > the list for a next entry -- we have to wait for some quiescent state to
> > ensure nobody is still referencing it.
> 
> Yes I see. But if we change generic_smp_call_function_interrupt() to
> re-check cpumask_test_cpu(cpu, data->cpumask) under data->lock then
> we don't have to wait for quiescent state, afaics. And we have to
> take this lock anyway.

Suppose entries A,B,C,D are queued, and some cpu1 is traversing the list
to execute C and is currently at B waiting for data->lock. Concurrently
cpu2 has completed B and removes it from the list, when cpu3 takes B and
inserts it at the end.

So we end up with A->C->D->B, and cpu1 will find its at the end of the
list and stop, never having seen C, the one it was meant to execute.

One possible solution would be to always queue new entries at the head,
but that would be unfair wrt function execution -- do we care?

