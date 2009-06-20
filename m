Return-Path: <linux-kernel-owner+w=401wt.eu-S1759807AbZFTB2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759807AbZFTB2j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 21:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753938AbZFTB2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 21:28:30 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:42885 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751455AbZFTB23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 21:28:29 -0400
Date: Fri, 19 Jun 2009 18:28:31 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] TOMOYO: Add garbage collector support. (v3)
Message-ID: <20090620012831.GT6724@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <200906172019.EAE00032.OLOJFQVMtFOFSH@I-love.SAKURA.ne.jp> <20090617163122.GC6767@linux.vnet.ibm.com> <200906180534.n5I5YgMY080614@www262.sakura.ne.jp> <20090618152854.GB6794@linux.vnet.ibm.com> <200906190457.n5J4vkkT010851@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906190457.n5J4vkkT010851@www262.sakura.ne.jp>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 19, 2009 at 01:57:46PM +0900, Tetsuo Handa wrote:
> Hello.
> 
> The GC thread is a loop of
> 
> (1) Take gc_mutex
> (2) Remove an element from the list using RCU
> (3) Wait for readers without releasing gc_mutex
> (4) Free up that element
> (5) Release gc_mutex
> 
> A new round will not see element which was removed by previous round.

Understood.

> Paul E. McKenney wrote:
> > > > Consider the following sequence of events:
> > > > 
> > > > o	CPU 0 picks up users_counter_idx int local variable idx.
> > > > 	Let's assume that the value is zero.
> > > > 
> > > > o	CPU 0 is now preempted, interrupted, or otherwise delayed.
> > > > 
>       o	CPU 1 takes gc_mutex.

Your (1).

> 
> > > > o	CPU 1 starts garbage collection, finding some elements to
> > > > 	delete, thus setting "element_deleted" to true.

Your (2).

> > > > o	CPU 1 continues garbage collection, inverting the value of
> > > > 	users_counter_idx, so that the value is now one, waiting
> > > > 	for the value-zero readers, and freeing up the old elements.

Your (3) and (4).

>       o	CPU 1 releases gc_mutex.
> > [1]

Your (5).

> > > > o	CPU 0 continues execution, first atomically incrementing
> > > > 	users_counter[0], then traversing the list, possibly sleeping.

Now the trick here is that CPU 0 has the old value of users_counter_idx.
So the reader and the garbage collector now disagree on which interval
they are operating in.

And CPU 0 might now be holding an element that will be deleted by the
next round of GC.

>       o	CPU 2 takes gc_mutex.

Your (1) again.  Presumably your single kernel thread migrated from
CPU 1 to CPU 2, which could really happen.

> > > > o	CPU 2 starts a new round of garbage collection, again finding
> > > > 	some elements to delete, and thus again setting
> > > > 	"elements_deleted" to true.  One of the elements deleted
> > > > 	is the one that CPU 0 is currently referencing while asleep.

Your (2) again.

> > > No. CPU 2 can't start a new round of GC because GC function is exclusively
> > > executed because of gc_mutex mutex.
> > 
> > But CPU 1 would have released gc_mutex back at time [1], right?
> > 
> Yes, CPU 1 will release gc_mutex after freeing up elements (which were removed
> from the list after gc_mutex was taken).
> 
> If CPU 0 sleeps between "idx = atomic_read(&users_counter_idx)" and
> "atomic_inc(&users_counter[idx])", CPU 0 will not see the element
> removed by CPU 1 because CPU 0 has not started list traversal.
> Same result for CPU 0 sleeping between "atomic_inc(&users_counter[idx])"
> and "list_for_each_rcu() {".

No, CPU 0 really did start list traversal three bullets ago.  The
problem is that the reader and gc disagree on what interval they are in.

> > > > o	CPU 2 continues garbage collection, inverting the value of
> > > > 	users_counter_idx, so that the value is now zero, waiting
> > > > 	for the value-one readers, and freeing up the old elements.
> > > > 	Note that CPU 0 is a value-zero reader, so that CPU 2 will
> > > > 	not wait on it.
> > > > 
> > > > 	CPU 2 therefore kfree()s the element that CPU 0 is currently
> > > > 	referencing.

Your (3) and (4) again.  Note that the reader has incremented
users_counter[0], while the GC is waiting only for users_counter[1].
So the GC is not going to wait for the reader.

> > > CPU 2 won't continue GC, for CPU 2 can't start a new round of GC.
> > 
> > I still don't see why CPU 0 would not have released gc_mutex back
> > at point [1].
> > 
> CPU 1 has released gc_mutex at point [1].
> In that case, CPU 2 can take gc_mutex and start a new round.
> Nobody can start a new round before previous round finishes.
> 
> CPU 2 can start a new round, but by that time, CPU 0 finished list traversal
> and atomically decremented users_counter[0] . CPU 1 won't finish a GC round
> before CPU 0 decrements users_counter[0], and thus CPU 2 won't start
> a new GC round before CPU 0 finishes list traversal.

No, because CPU 2 is waiting on users_counter[1] to reach zero, but
the reader has incremented users_counter[0].  GC will thus -not- wait
on the reader.

> > > > o	CPU 0 wakes up, and suffers possibly fatal disappointment upon
> > > > 	attempting to reference an element that has been freed -- and,
> > > > 	worse yet, possibly re-allocated as some other type of
> > > > 	structure.
> > > >
> > > CPU 0 won't suffer, for first round of GC (by CPU 1) prevents CPU 2 from
> > > starting a new round of GC.
> > 
> > Why would CPU 1 be unable to complete its round of GC, thus releasing
> > gc_mutex, thus allowing CPU 2 from starting a new one?  For that matter,
> > CPU 1 could start a new round, correct?
> > 
> Because CPU 1 waits for CPU 0's atomic_dec() without releasing gc_mutex .

But CPU 0 did not do its atomic_inc() until after CPU 1 got done
waiting, so CPU 1 cannot possibly wait on CPU 0.  CPU 2 cannot possibly
wait on CPU 0, because they are using different elements of the
users_counters[] array.

> > > > Or am I missing something in your pseudocode?
> > > I think you missed that GC function is executed exclusively.
> > > 
> > > The race between readers and GC is avoided as below.
> > 
> > If you can tell me why CPU 1 cannot release gc_mutex, I will look at
> > the following.  Until then, I will stand by my scenario above.  ;-)
> 
> CPU 1 can release gc_mutex when that round finished (i.e. after freeing up
> elements removed by that round).

Agreed, but I don't understand how this helps.

> > > > Also, if you have lots of concurrent readers, you can suffer high memory
> > > > contention on the users_counter[] array, correct?
> > > 
> > > Excuse me. I couldn't understand "memory contention"...
> > > 
> > > ( http://www.answers.com/topic/memory-contention )
> > > | A situation in which two different programs, or two parts of a program,
> > > | try to read items in the same block of memory at the same time. 
> > > Why suffered by atomic_read() at the same time?
> > > Cache invalidation by atomic_inc()/atomic_dec() a shared variable?
> > 
> > Yes, cache invalidation by atomic_inc()/atomic_dec() of a shared
> > variable can definitly result in memory contention and extremely
> > bad performance.
> 
> I have poor knowledge about hardware mechanisms.
> Would you please answer within you can?
> 
> I experienced 8086 (not 80186 and later) assembly programming a bit
> on MS-DOS. My experience says that (I don't know actual cycle numbers)
>   "mov eax, ebx" takes one CPU cycle.
>   "mov eax, [ebx]" takes three CPU cycles.
> And it seems to me that modifying a shared variable doesn't affect
> performance.
> But if caching mechanisms exist, "mov eax, [ebx]" takes one CPU cycle if
> [ebx] is on cache, three CPU cycles if not on cache, is this correct?
> And modifying [ebx] invalidates cache, doesn't it?
> Then,
> 
>   atomic_t counter[NR_CPUS];
>   atomic_inc(&counter[smp_prosessor_id()]);
> 
> shows better performance than
> 
>   atomic_t counter;
>   atomic_inc(&counter);
> 
> ?
> Does cache invalidation mechanism invalidate only sizeof(atomic_t) bytes
> (or invalidates more bytes nearby &counter)?

Modern CPUs are quite complex.  There is a multi-cycle penalty for the
instruction being atomic in the first place, and there can be many tens
or even hundreds of cycles penalty if the variable to be manipulated
resides in some other CPU's cache.

These penalties were larger in older SMP hardware.  Also, in general,
the larger the system, the worse the penalties.  Getting data on and off
a chip is quite expensive.  See slide 11 of:

http://www.rdrop.com/users/paulmck/scalability/paper/TMevalSlides.2008.10.19a.pdf

for measurements on a few-years-old system.  Newer multi-core systems
are about a factor of six faster, but only if you keep everything on a
single die.  If you go to multiple sockets, there is still improvement,
but only a factor of two or so in terms of clock period.

> Another keyword which is worrisome for me is NUMA.
> My understanding is that NUMA splits RAM into nodes and tries to use RAM
> in current node.
> In NUMA environment, (for example) "mov eax, [ebx]" takes three CPU cycles
> if ebx refers current node and hundred CPU cycles if ebx refers other node?
> Then, is it preferable to place copy of ACL information to every node
> rather than sharing one ACL information?

Even without NUMA, a load that misses all caches and comes from DRAM
costs many tens or even a few hundred cycles.  NUMA increases the pain,
normally by a small multiple.  The exact numbers will depend on the
hardware, of course.

> > > > I recommend that you look into use of SRCU in this case.
> > > 
> > > I have one worry regarding SRCU.
> > > Inside synchronize_srcu(), there is a loop
> > > 
> > > 	while (srcu_readers_active_idx(sp, idx))
> > > 		schedule_timeout_interruptible(1);
> > > 
> > > but the reader's sleeping duration varies from less than one second to
> > > more than hours.
> > > 
> > > Checking for counters for every jiffies sounds too much waste of CPU.
> > > Delaying kfree() for seconds or minutes won't cause troubles for TOMOYO.
> > > It would be nice if checking interval is configurable like
> > > "schedule_timeout_interruptible(sp->timeout);".
> > 
> > This would not be a difficult change, and certainly would make sense in
> > your case.  I would be happy to review a patch from you, or to create a
> > patch to SRCU if you would prefer.
> > 
> > I would add a field as you say, and add an API element:
> > 
> > 	void set_srcu_timeout(struct srcu_struct *sp, unsigned long timeout)
> > 
> > The timeout would default to 1, and a value of 0 would be interpreted
> > as 1.  In your case, perhaps you would do the following after initializing
> > the srcu_struct:
> > 
> > 	set_srcu_timeout(&tomoyo_srcu, HZ);
> > 
> > Would this work?
> 
> Yes. May I?

Of course!!!

> (I use "long" rather than "unsigned long" because schedule_timeout() rejects
>  negative timeout value.)
> 
> Regards.
> --------------------
> Subject: [PATCH] SRCU: Allow longer timeout for non-urgent reclaimer.
> 
> Currently synchronize_srcu() checks for readers for every jiffies.
> But if reader sleeps for long, we don't need to check so frequently.
> 
> This patch allows non-urgent SRCU reclaimers (e.g. checking for every second
> is sufficient) to use longer timeout.

Looks good to me!  Of course, if it turns out that you don't actually
need it, then not much benefit in including it, but:

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> ---
>  include/linux/srcu.h |    2 ++
>  kernel/srcu.c        |   14 +++++++++++++-
>  2 files changed, 15 insertions(+), 1 deletion(-)
> 
> --- security-testing-2.6.orig/include/linux/srcu.h
> +++ security-testing-2.6/include/linux/srcu.h
> @@ -35,6 +35,7 @@ struct srcu_struct {
>  	int completed;
>  	struct srcu_struct_array *per_cpu_ref;
>  	struct mutex mutex;
> +	long timeout;
>  };
> 
>  #ifndef CONFIG_PREEMPT
> @@ -49,5 +50,6 @@ int srcu_read_lock(struct srcu_struct *s
>  void srcu_read_unlock(struct srcu_struct *sp, int idx) __releases(sp);
>  void synchronize_srcu(struct srcu_struct *sp);
>  long srcu_batches_completed(struct srcu_struct *sp);
> +void set_srcu_timeout(struct srcu_struct *sp, long timeout);
> 
>  #endif
> --- security-testing-2.6.orig/kernel/srcu.c
> +++ security-testing-2.6/kernel/srcu.c
> @@ -44,6 +44,7 @@
>   */
>  int init_srcu_struct(struct srcu_struct *sp)
>  {
> +	sp->timeout = 1;
>  	sp->completed = 0;
>  	mutex_init(&sp->mutex);
>  	sp->per_cpu_ref = alloc_percpu(struct srcu_struct_array);
> @@ -201,7 +202,7 @@ void synchronize_srcu(struct srcu_struct
>  	 */
> 
>  	while (srcu_readers_active_idx(sp, idx))
> -		schedule_timeout_interruptible(1);
> +		schedule_timeout_interruptible(sp->timeout);
> 
>  	synchronize_sched();  /* Force memory barrier on all CPUs. */
> 
> @@ -249,6 +250,17 @@ long srcu_batches_completed(struct srcu_
>  	return sp->completed;
>  }
> 
> +/**
> + * set_srcu_timeout - set checking interval for synchronize_srcu()
> + * @sp: srcu_struct
> + * @timeout: checking interval in jiffies.
> + */
> +void set_srcu_timeout(struct srcu_struct *sp, long timeout)
> +{
> +	if (timeout >= 1 && timeout != MAX_SCHEDULE_TIMEOUT)
> +		sp->timeout = timeout;
> +}
> +
>  EXPORT_SYMBOL_GPL(init_srcu_struct);
>  EXPORT_SYMBOL_GPL(cleanup_srcu_struct);
>  EXPORT_SYMBOL_GPL(srcu_read_lock);
> 
> 
