Return-Path: <linux-kernel-owner+w=401wt.eu-S1755139AbZBPUez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139AbZBPUez (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 15:34:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752652AbZBPUee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 15:34:34 -0500
Received: from mx2.redhat.com ([66.187.237.31]:38540 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752340AbZBPUed (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 15:34:33 -0500
Date: Mon, 16 Feb 2009 21:30:55 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] generic-smp: remove single ipi fallback for
	smp_call_function_many()
Message-ID: <20090216203055.GA5135@redhat.com>
References: <20090216163847.431174825@chello.nl> <20090216164114.433430761@chello.nl> <20090216191008.GA1521@redhat.com> <1234813292.30178.327.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234813292.30178.327.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16, Peter Zijlstra wrote:
>
> On Mon, 2009-02-16 at 20:10 +0100, Oleg Nesterov wrote:
> > Actually I don't understand the counter/free_list logic.
> >
> > 	generic_smp_call_function_interrupt:
> >
> > 			/*
> > 			 * When the global queue is empty, its guaranteed that no cpu
> > 			 * is still observing any entry on the free_list, therefore
> > 			 * we can go ahead and unlock them.
> > 			 */
> > 			if (!--call_function.counter)
> > 				list_splice_init(&call_function.free_list, &free_list);
> >
> > I can't see why "its guaranteed that no cpu ...". Let's suppose CPU 0
> > "hangs" for some reason in generic_smp_call_function_interrupt() right
> > before "if (!cpumask_test_cpu(cpu, data->cpumask))" test. Then it is
> > possible that another CPU removes the single entry (which doesn't have
> > CPU 0 in data->cpumask) from call_function.queue.
>
> Then call_function.counter wouldn't be 0, and we would not release the
> list entries.

Why it wouldn't be 0? IOW, do you mean that the spurious CALL_FUNCTION_VECTOR
is not possible?

OK, let's suppose CPUs 1 and 2 both do smp_call_function_many(cpumask_of(0)).

CPU_1 does arch_send_call_function_ipi_mask() and returns.

CPU_2 inserts cfd_data[2] and hangs before arch_send_call_function_ipi_mask().

CPU_0 sees the interrupt and removes both entries.

CPU_2 proceeds, and sends IPI to CPU_0 again.

Now, when CPU_0 sees CALL_FUNCTION_VECTOR interrupt and calls
generic_smp_call_function_interrupt(), there is no work for this CPU,
so the above race is possible even with counter/free_list.

The new entry can be inserted (counter becomes 1) and quickly removed
(counter becomes 0) while CPU 0 still sees it on list.

Unless I misread the patch of course...

> > Now, if that entry is re-added, we can have a problem if CPU 0 sees
> > the partly initialized entry.
>
> Right, so the scenario is that a cpu observes the list entry after we do
> list_del_rcu() -- most likely a cpu not in the original mask, taversing
> the list for a next entry -- we have to wait for some quiescent state to
> ensure nobody is still referencing it.

Yes I see. But if we change generic_smp_call_function_interrupt() to
re-check cpumask_test_cpu(cpu, data->cpumask) under data->lock then
we don't have to wait for quiescent state, afaics. And we have to
take this lock anyway.

Because smp_call_function_many() does mb(), but I can't see how it
can help. Some CPU from ->cpumask can already execute
generic_smp_call_function_interrupt() before we do
arch_send_call_function_ipi_mask().


> > But why do we need counter/free_list at all?
> > Can't we do the following:
> >
> > 	- initialize call_function_data.lock at boot time
> >
> > 	- change smp_call_function_many() to initialize cfd_data
> > 	  under ->lock
> >
> > 	- change generic_smp_call_function_interrupt() to do
> >
> > 		list_for_each_entry_rcu(data) {
> >
> > 			if (!cpumask_test_cpu(cpu, data->cpumask))
> > 				continue;
> >
> > 			spin_lock(&data->lock);
> > 			if (!cpumask_test_cpu(cpu, data->cpumask)) {
> > 				spin_unlock(data->lock);
> > 				continue;
> > 			}
> >
> > 			cpumask_clear_cpu(cpu, data->cpumask);
> > 			refs = --data->refs;
> >
> > 			func = data->func;
> > 			info = data->info;
> > 			spin_unlock(&data->lock);
> >
> > 			func(info);
> >
> > 			if (refs)
> > 				continue;
> >
> > 			...
> > 		}
> >
> > Afaics, it is OK if smp_call_function_many() sees the "unneeded" entry on
> > list, the only thing we must ensure is that we can't "misunderstand" this
> > entry.
> >
> > No?
>
> Hmm, could that not leed to loops, and or missed entries in the
> list-iteration?

How? when we lock data->lock and see this cpu in the ->cpumask,
we can be sure we can proceed?

Oleg.

