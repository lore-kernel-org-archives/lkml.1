Return-Path: <linux-kernel-owner+w=401wt.eu-S1762519AbZFRP3E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762519AbZFRP3E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 11:29:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758276AbZFRP2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 11:28:55 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:54021 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752284AbZFRP2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 11:28:53 -0400
Date: Thu, 18 Jun 2009 08:28:54 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] TOMOYO: Add garbage collector support. (v3)
Message-ID: <20090618152854.GB6794@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <200906172019.EAE00032.OLOJFQVMtFOFSH@I-love.SAKURA.ne.jp> <20090617163122.GC6767@linux.vnet.ibm.com> <200906180534.n5I5YgMY080614@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906180534.n5I5YgMY080614@www262.sakura.ne.jp>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 18, 2009 at 02:34:42PM +0900, Tetsuo Handa wrote:
> Hello.
> 
> Paul E. McKenney wrote:
> > Consider the following sequence of events:
> > 
> > o	CPU 0 picks up users_counter_idx int local variable idx.
> > 	Let's assume that the value is zero.
> > 
> > o	CPU 0 is now preempted, interrupted, or otherwise delayed.
> > 
> > o	CPU 1 starts garbage collection, finding some elements to
> > 	delete, thus setting "element_deleted" to true.
> > 
> > o	CPU 1 continues garbage collection, inverting the value of
> > 	users_counter_idx, so that the value is now one, waiting
> > 	for the value-zero readers, and freeing up the old elements.

[1]

> > o	CPU 0 continues execution, first atomically incrementing
> > 	users_counter[0], then traversing the list, possibly sleeping.
> > 
> > o	CPU 2 starts a new round of garbage collection, again finding
> > 	some elements to delete, and thus again setting
> > 	"elements_deleted" to true.  One of the elements deleted
> > 	is the one that CPU 0 is currently referencing while asleep.
> > 
> No. CPU 2 can't start a new round of GC because GC function is exclusively
> executed because of gc_mutex mutex.

But CPU 1 would have released gc_mutex back at time [1], right?

> > o	CPU 2 continues garbage collection, inverting the value of
> > 	users_counter_idx, so that the value is now zero, waiting
> > 	for the value-one readers, and freeing up the old elements.
> > 	Note that CPU 0 is a value-zero reader, so that CPU 2 will
> > 	not wait on it.
> > 
> > 	CPU 2 therefore kfree()s the element that CPU 0 is currently
> > 	referencing.
> > 
> CPU 2 won't continue GC, for CPU 2 can't start a new round of GC.

I still don't see why CPU 0 would not have released gc_mutex back
at point [1].

> > o	CPU 0 wakes up, and suffers possibly fatal disappointment upon
> > 	attempting to reference an element that has been freed -- and,
> > 	worse yet, possibly re-allocated as some other type of
> > 	structure.
> >
> CPU 0 won't suffer, for first round of GC (by CPU 1) prevents CPU 2 from
> starting a new round of GC.

Why would CPU 1 be unable to complete its round of GC, thus releasing
gc_mutex, thus allowing CPU 2 from starting a new one?  For that matter,
CPU 1 could start a new round, correct?

> > Or am I missing something in your pseudocode?
> I think you missed that GC function is executed exclusively.
> 
> The race between readers and GC is avoided as below.

If you can tell me why CPU 1 cannot release gc_mutex, I will look at
the following.  Until then, I will stand by my scenario above.  ;-)

> (a-1) A reader reads users_counter_idx and saves to r_idx
> (a-2) GC removes element from the list using RCU
> (a-3) GC reads users_counter_idx and saves to g_idx
> (a-4) GC inverts users_counter_idx
> (a-5) GC releases the removed element
> (a-6) A reader increments users_counter[r_idx]
> (a-7) A reader won't see the element removed by GC because
>       the reader has not started list traversal as of (a-2)
> 
> (b-1) A reader reads users_counter_idx and saves to r_idx
> (b-2) A reader increments users_counter[r_idx]
> (b-3) GC removes element from the list using RCU
> (b-4) A reader won't see the element removed by GC
> (b-5) GC reads users_counter_idx and saves to g_idxo
> (b-6) GC inverts users_counter_idx
> (b-7) GC waits for users_counter[g_idx] to become 0
> (b-8) A reader decrements users_counter[r_idx]
> (b-9) GC releases the removed element
> 
> (c-1) A reader reads users_counter_idx and saves to r_idx
> (c-2) A reader increments users_counter[r_idx]
> (c-3) A reader sees the element
> (c-4) GC removes element from the list using RCU
> (c-5) GC reads users_counter_idx and saves to g_idx
> (c-6) GC inverts users_counter_idx
> (c-7) GC waits for users_counter[g_idx] to become 0
> (c-8) A reader decrements users_counter[r_idx]
> (c-9) GC releases the removed element
> 
> What I worry is that some memory barriers might be needed between
> 
> > > {
> > > 	/* Get counter index. */
> > > 	int idx = atomic_read(&users_counter_idx);
> > > 	/* Lock counter. */
> > > 	atomic_inc(&users_counter[idx]);
> - here -
> > > 	list_for_each_entry_rcu() {
> > > 		... /* Allowed to sleep. */
> > > 	}
> - here -
> > > 	/* Unlock counter. */
> > > 	atomic_dec(&users_counter[idx]);
> > > }
> 
> and
> 
> > > 	if (element_deleted) {
> > > 		/* Swap active counter. */
> > > 		const int idx = atomic_read(&users_counter_idx);
> - here -
> > > 		atomic_set(&users_counter_idx, idx ^ 1);
> - here -
> > > 		/*
> > > 		 * Wait for readers who are using previously active counter.
> > > 		 * This is similar to synchronize_rcu() while this code allows
> > > 		 * readers to do operations which may sleep.
> > > 		 */
> > > 		while (atomic_read(&users_counter[idx]))
> > > 			msleep(1000);
> > > 		/*
> > > 		 * Nobody is using previously active counter.
> > > 		 * Ready to release memory of elements removed before
> > > 		 * previously active counter became inactive.
> > > 		 */
> > > 		kfree(element);
> > > 	}
> 
> in order to enforce ordering.

Quite possibly.  One of the advantages of using things like SRCU is that
the necessary memory barriers are already in place.  (knock wood)

> > Also, if you have lots of concurrent readers, you can suffer high memory
> > contention on the users_counter[] array, correct?
> 
> Excuse me. I couldn't understand "memory contention"...
> 
> ( http://www.answers.com/topic/memory-contention )
> | A situation in which two different programs, or two parts of a program,
> | try to read items in the same block of memory at the same time. 
> Why suffered by atomic_read() at the same time?
> Cache invalidation by atomic_inc()/atomic_dec() a shared variable?

Yes, cache invalidation by atomic_inc()/atomic_dec() of a shared
variable can definitly result in memory contention and extremely
bad performance.

> ( http://wiki.answers.com/Q/What_is_memory_contention )
> | Memory contention is a state a OS memory manager can reside in when to many
> | memory requests (alloc, realloc, free) are issued to it from an active
> | application possibly leading to a DOS condition specific to that
> | application. 
> No memory allocation for users_counter[] array.

This is not the type of memory contention I was thinking of.

> > I recommend that you look into use of SRCU in this case.
> 
> I have one worry regarding SRCU.
> Inside synchronize_srcu(), there is a loop
> 
> 	while (srcu_readers_active_idx(sp, idx))
> 		schedule_timeout_interruptible(1);
> 
> but the reader's sleeping duration varies from less than one second to
> more than hours.
> 
> Checking for counters for every jiffies sounds too much waste of CPU.
> Delaying kfree() for seconds or minutes won't cause troubles for TOMOYO.
> It would be nice if checking interval is configurable like
> "schedule_timeout_interruptible(sp->timeout);".

This would not be a difficult change, and certainly would make sense in
your case.  I would be happy to review a patch from you, or to create a
patch to SRCU if you would prefer.

I would add a field as you say, and add an API element:

	void set_srcu_timeout(struct srcu_struct *sp, unsigned long timeout)

The timeout would default to 1, and a value of 0 would be interpreted
as 1.  In your case, perhaps you would do the following after initializing
the srcu_struct:

	set_srcu_timeout(&tomoyo_srcu, HZ);

Would this work?

> > Anyway, the general approach would be to make changes to your code
> > roughly as follows:
> > 
> > 1.	replace your users_counter and users_counter_idx with a
> > 	struct srcu_struct.
> > 
> > 2.	In the reader, replace the fetch from users_counter_idx and
> > 	the atomic_inc() with srcu_read_lock().
> > 
> > 3.	In the garbage collector, replace the fetch/update of
> > 	users_counter_idx and the "while" loop with synchronize_srcu().
> > 
> I see. Since I isolated the GC as a dedicated kernel thread, writers no longer
> wait for elements to be kfree()ed. I can use SRCU.

Very good!

> > Or is there some reason why SRCU does not work for you?
> None for mainline version.
> 
> I'm also maintaining TOMOYO for older/distributor kernels for those who want to
> enable both SELinux/SMACK/AppArmor/grsecurity etc. and TOMOYO at the same time.
> Thus, if my idea works, I want to backport it to TOMOYO for these kernels.

SRCU has been in the kernel since 2.6.18, but would be easy to
backport.  If you have a recent git tree, run "gitk kernel/srcu.c
include/linux/srcu.h".  You will find four commits that are pretty
well isolated -- you would need the changes to kernel/srcu.c,
include/linux/srcu.h, and kernel/Makefile.

							Thanx, Paul
