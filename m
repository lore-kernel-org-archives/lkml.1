Return-Path: <linux-kernel-owner+w=401wt.eu-S1754823AbZBRQGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823AbZBRQGy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 11:06:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754109AbZBRQGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 11:06:44 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:47061 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752035AbZBRQGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 11:06:42 -0500
Date: Wed, 18 Feb 2009 08:06:37 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 2/3] generic-ipi: remove kmalloc()
Message-ID: <20090218160637.GA7011@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090217215904.059250145@chello.nl> <20090217220053.500765201@chello.nl> <20090218002823.GA25408@linux.vnet.ibm.com> <1234953737.4637.57.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234953737.4637.57.camel@laptop>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 18, 2009 at 11:42:17AM +0100, Peter Zijlstra wrote:
> On Tue, 2009-02-17 at 16:28 -0800, Paul E. McKenney wrote:
> > On Tue, Feb 17, 2009 at 10:59:06PM +0100, Peter Zijlstra wrote:
> 
> > > +static int
> > > +hotplug_cfd(struct notifier_block *nfb, unsigned long action, void *hcpu)
> > > +{
> > > +	long cpu = (long)hcpu;
> > > +	struct call_function_data *cfd = &per_cpu(cfd_data, cpu);
> > > +
> > > +	switch (action) {
> > > +	case CPU_UP_PREPARE:
> > > +	case CPU_UP_PREPARE_FROZEN:
> > > +		if (!alloc_cpumask_var_node(&cfd->cpumask, GFP_KERNEL,
> > > +				cpu_to_node(cpu)))
> > > +			return NOTIFY_BAD;
> > > +		break;
> > > +
> > > +#ifdef CONFIG_CPU_HOTPLUG
> > > +	case CPU_UP_CANCELED:
> > > +	case CPU_UP_CANCELED_FROZEN:
> > > +
> > > +	case CPU_DEAD:
> > > +	case CPU_DEAD_FROZEN:
> > > +		free_cpumask_var(cfd->cpumask);
> > > +		break;
> > > +#endif
> > > +
> > > +	return NOTIFY_OK;
> > > +	};
> > > +}
> > 
> > Hmmm....  Why not the following?  Do we really need to free the cpumask
> > when a CPU departs, given that it might return later?
> 
> Probably not, but that's what we have these callbacks for, might as well
> use them.

Fair enough...

> > > +/*
> > > + * csd_lock/csd_unlock used to serialize access to per-cpu csd resources
> > > + *
> > > + * For non-synchronous ipi calls the csd can still be in use by the previous
> > > + * function call. For multi-cpu calls its even more interesting as we'll have
> > > + * to ensure no other cpu is observing our csd.
> > > + */
> > > +static void csd_lock(struct call_single_data *data)
> > >  {
> > > -	/* Wait for response */
> > > -	do {
> > > -		if (!(data->flags & CSD_FLAG_WAIT))
> > > -			break;
> > > +	while (data->flags & CSD_FLAG_LOCK)
> > >  		cpu_relax();
> > > -	} while (1);
> > > +	data->flags = CSD_FLAG_LOCK;
> > 
> > We do need an smp_mb() here, otherwise, the call from
> > smp_call_function_single() could be reordered by either CPU or compiler
> > as follows:
> > 
> > 	data->func = func;
> > 	data->info = info;
> > 	csd_lock(data);
> > 
> > This might come as a bit of a surprise to the other CPU still trying to
> > use the old values for data->func and data->info.
> > 
> > Note that this smb_mb() is required even if cpu_relax() contains a
> > memory barrier, as it is possible to execute csd_lock_wait() without
> > executing the cpu_relax(), if you get there at just the right time.
> 
> I'm not quite sure I follow, if we observe !(flags & LOCK) then we're
> guaranteed that no cpu will still needs func and info. They might still
> be observing the list entry, but should not find themselves on the
> cpumask -- which is guarded by ->lock.

The compiler could reorder as above, in which case the other CPU might
still be looking at the ->func and ->info fields when the stores happen,
but might have done csd_unlock() by the time this CPU does its
csd_lock().

> Anyway, I'm happy to add the mb().

Please!  ;-)

> > > @@ -122,41 +198,35 @@ void generic_smp_call_function_interrupt
> > >  	 * It's ok to use list_for_each_rcu() here even though we may delete
> > >  	 * 'pos', since list_del_rcu() doesn't clear ->next
> > >  	 */
> > > -	rcu_read_lock();
> > > -	list_for_each_entry_rcu(data, &call_function_queue, csd.list) {
> > > +	list_for_each_entry_rcu(data, &call_function.queue, csd.list) {
> > 
> > OK...  What prevents the following sequence of events?
> > 
> > o	CPU 0 calls smp_call_function_many(), targeting numerous CPUs,
> > 	including CPU 2.  CPU 0 therefore enqueues this on the global
> > 	call_function.queue.  "wait" is not specified, so CPU 0 returns
> > 	immediately after sending the IPIs.
> > 
> > o	CPU 1 disables irqs and leaves them disabled for awhile.
> > 
> > o	CPU 2 receives the IPI, and duly calls the needed function.
> > 	It decrements the ->refs field, but, finding the result
> > 	non-zero, refrains from removing the element that CPU 0
> > 	enqueued, and also refrains from invoking csd_unlock().
> > 
> > o	CPU 3 also receives the IPI, and also calls the needed function.
> > 	Now, only CPU 1 need receive the IPI for the element to be
> > 	removed.
> > 
> > o	CPU 3 calls smp_call_function_many(), targeting numerous CPUs,
> > 	but -not- including CPU 2.  CPU 3 therefore also this on the
> > 	global call_function.queue and sends the IPIs, but no IPI for
> > 	CPU 2.	Your choice as to whether CPU 3 waits or not.
> 
> Right, so the queue is Entry3->Entry0 (we place new entries on at the
> head).

Gah!!!  I even remember looking at the list_add_rcu() and noting that
it was not a list_add_tail_rcu().

Please accept my apologies for my confusion!!!

I suppose that a given CPU might get repeatedly recycled to the beginning
of the list, but someone would have to make that happen before I would
be inclined to worry about it.

> > o	CPU 2 receives CPU 3's IPI, but CPU 0's element is first on the
> > 	list.  CPU 2 fetches the pointer (via list_for_each_entry_rcu()),
> > 	and then...
> 
> CPU0 ? You just excluded cpu2, cpu1 is still blocked, and cpu3 send the
> ipi.
> 
> Furthermore, Entry3 would be first, but suppose it is Entry0, that makes
> the scenario work best.
> 
> > o	CPU 1 finally re-enables irqs and receives the IPIs!!!  It
> > 	finds CPU 0's element on the queue, calls the function,
> > 	decrements the ->refs field, and finds that it is zero.
> > 	So, CPU 1 invokes list_del_rcu() to remove the element
> > 	(OK so far, as list_del_rcu() doesn't overwrite the next
> > 	pointer), then invokes csd_unlock() to release the element.
> 
> CPU1 will see CPU3's element first, and CPU0's element second. But OK.
> 
> > o	CPU 0 then invokes another smp_call_function_many(), also
> > 	multiple CPUs, but -not- to CPU 2.  It requeues the element
> > 	that was just csd_unlock()ed above, carrying CPU 2 with it.
> > 	It IPIs CPUs 1 and 3, but not CPU 2.
> > 
> > o	CPU 2 continues, and falls off the bottom of the list.  It will
> > 	continue to ignore CPU 0's IPI until some other CPU IPIs it.
> > 	On some architectures, a single-target IPI won't cut it, only
> > 	a multi-target IPI.
> > 
> > Or am I missing something subtle here?
> 
> Ah, right, yes. I place new entries at the HEAD not TAIL, so that in
> this case we go from:
> 
> Entry3->Entry0
>            ^
>          CPU2
> 
> to
> 
> Entry0->Entry3
>   ^
> CPU2
> 
> and CPU2 will continue the list iteration, visiting Entry3 twice, which
> is harmless since it will have removed itself from the cpumask the first
> time around.
> 
> > If this really is a problem, there are a number of counter-based solutions
> > to it.  (Famous last words...)
> > 
> > Abandoning all caution and attempting one on the fly...  Make each CPU
> > receiving an IPI increment one per-CPU counter upon entry, and increment
> > it again upon exit with memory barriers after and before, respectively.
> > Then any CPU with an even value can be ignored, and any CPU whose value
> > changes can also be ignored.  Of course, this means you have to scan all
> > CPUs...  But in the worst case, you also had to IPI them all.
> > 
> > Given that this operation is relatively rare, it might be worth using
> > shared reference counters, possibly one pair of such counters per (say)
> > 16 CPUs.  Then the caller flips the counter.
> 
> Yep, I almost implemented a counting RCU which increments a global
> counter on IPI entry and decrements on IPI exit, but then did the above
> FIFO->FILO queue thingy.

A simpler way (if it becomes necessary to add at the tail rather than
the head) would be to periodically check for stalls of this sort and
then resend the IPIs.

> > Alternatively, you can explain to me why my scenario above cannot
> > happen -- but at present, it will take some serious explaining!!!
> 
> I hope to have adequately explained it, but please, feel free to poke
> more holes into it ;-)

You have indeed more than adequately explained it.  The only thing
resembling a hole that I have found thus far is the improbable scenario
that repeatedly pulls a given CPU to the beginning of the list, so that
this CPU never reaches the end.

Again, please accept my apologies for my confusion!!!

							Thanx, Paul
