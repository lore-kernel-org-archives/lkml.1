Return-Path: <linux-kernel-owner+w=401wt.eu-S1754334AbZBRTrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334AbZBRTrj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 14:47:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751893AbZBRTra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 14:47:30 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:33659 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751756AbZBRTra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 14:47:30 -0500
Date: Wed, 18 Feb 2009 11:47:27 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] generic-ipi: remove kmalloc()
Message-ID: <20090218194727.GB7011@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090217215904.059250145@chello.nl> <20090217220053.500765201@chello.nl> <20090218002823.GA25408@linux.vnet.ibm.com> <20090218161515.GA24895@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090218161515.GA24895@redhat.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 18, 2009 at 05:15:15PM +0100, Oleg Nesterov wrote:
> On 02/17, Paul E. McKenney wrote:
> >
> > On Tue, Feb 17, 2009 at 10:59:06PM +0100, Peter Zijlstra wrote:
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
> 
> Could you explain a bit more here?
> 
> The compiler can't re-order this code due to cpu_relax(). Cpu can
> re-order, but this doesn't matter because both the sender and ipi
> handler take call_single_queue->lock.
> 
> And, giwen that csd_unlock() does mb() before csd_unlock(), how
> it is possible that other CPU (ipi handler) still uses the old
> values in *data after we see !CSD_FLAG_LOCK ?

Good point on cpu_relax(), which appears to be at least a compiler
barrier on all architectures.

I must confess to being in the habit of assuming reordering unless I
can prove that such reordering cannot happen.  I am running tests of
this code snippet on POWER, but do not have access to ARM, which some
say has more tendency to ignore control-flow dependencies than does Power.

I will let people know what comes of the tests.

> > Note that this smb_mb() is required even if cpu_relax() contains a
> > memory barrier, as it is possible to execute csd_lock_wait() without
> > executing the cpu_relax(), if you get there at just the right time.
> 
> Can't understand... Nobody can do csd_wait() on this per-cpu entry,
> but I guess you meant something else.
> 
> > OK...  What prevents the following sequence of events?
> >
> > o	CPU 0 calls smp_call_function_many(), targeting numerous CPUs,
> > 	including CPU 2.  CPU 0 therefore enqueues this on the global
> > 	call_function.queue.  "wait" is not specified, so CPU 0 returns
> > 	immediately after sending the IPIs.
> >
> > 	It decrements the ->refs field, but, finding the result
> > 	non-zero, refrains from removing the element that CPU 0
> > 	enqueued, and also refrains from invoking csd_unlock().
> >
> > o	CPU 3 also receives the IPI, and also calls the needed function.
> > 	Now, only CPU 1 need receive the IPI for the element to be
> > 	removed.
> 
> so we have a single entry E0 on list,
> 
> > o	CPU 3 calls smp_call_function_many(), targeting numerous CPUs,
> > 	but -not- including CPU 2.  CPU 3 therefore also this on the
> > 	global call_function.queue and sends the IPIs, but no IPI for
> > 	CPU 2.	Your choice as to whether CPU 3 waits or not.
> 
> now we have E3 -> E0
> 
> > o	CPU 2 receives CPU 3's IPI, but CPU 0's element is first on the
> > 	list.  CPU 2 fetches the pointer (via list_for_each_entry_rcu()),
> > 	and then...
> 
> it actually sees E3, not E0
> 
> > o	CPU 1 finally re-enables irqs and receives the IPIs!!!  It
> > 	finds CPU 0's element on the queue, calls the function,
> > 	decrements the ->refs field, and finds that it is zero.
> > 	So, CPU 1 invokes list_del_rcu() to remove the element
> > 	(OK so far, as list_del_rcu() doesn't overwrite the next
> > 	pointer), then invokes csd_unlock() to release the element.
> >
> > o	CPU 0 then invokes another smp_call_function_many(), also
> > 	multiple CPUs, but -not- to CPU 2.  It requeues the element
> > 	that was just csd_unlock()ed above, carrying CPU 2 with it.
> > 	It IPIs CPUs 1 and 3, but not CPU 2.
> 
> and inserts the element E0 at the head of the list again,
> 
> >
> > o	CPU 2 continues, and falls off the bottom of the list.
> 
> afaics, it doesn't.
> 
> Every time smp_call_function_many() reuses the element, it sets its
> ->next pointer to the head of the list. If we race with another CPU
> which fetches this pointer, this CPU has to re-scan the whole list,
> but since we always modify/read data under data->lock this should
> be safe, that CPU must notice (!cpumask_test_cpu(cpu, data->cpumask).
> 
> No?

You are quite correct.  I guess I should have gone home early instead of
reviewing Peter's patch...  :-/

							Thanx, Paul
