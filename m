Return-Path: <linux-kernel-owner+w=401wt.eu-S1763896AbYEEWqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763896AbYEEWqz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 18:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755195AbYEEWqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 18:46:44 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:55502 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754905AbYEEWqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 18:46:42 -0400
Date: Mon, 5 May 2008 10:43:12 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       jeremy@goop.org, mingo@elte.hu
Subject: Re: [PATCH 1/10] Add generic helpers for arch IPI function calls
Message-ID: <20080505174312.GC7543@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080430121712.GR11126@linux.vnet.ibm.com> <20080430123717.GC12774@kernel.dk> <20080502020241.GA26088@linux.vnet.ibm.com> <20080502021233.GC11844@wotan.suse.de> <20080502122955.GB15522@linux.vnet.ibm.com> <20080502124205.GA23680@linux.vnet.ibm.com> <1209733169.13978.157.camel@twins> <20080503054930.GA19664@wotan.suse.de> <20080503181148.GA16159@linux.vnet.ibm.com> <20080505041533.GA17640@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080505041533.GA17640@wotan.suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2008 at 06:15:33AM +0200, Nick Piggin wrote:
> On Sat, May 03, 2008 at 11:11:48AM -0700, Paul E. McKenney wrote:
> > On Sat, May 03, 2008 at 07:49:30AM +0200, Nick Piggin wrote:
> > > > This is perfectly deadlock free when wait=0 and it just returns -ENOMEM
> > > > on allocation failure.
> > > 
> > > Yeah, I'm just talking about the wait=0 case. (btw. I'd rather the core
> > > API takes some data rather than allocates some itself, eg because you
> > > might want to have it on the stack).
> > 
> > But taking data on the stack is safe only in the wait=1 case, right?
> 
> Sure, but the API would be general enough to handle it.

OK...  But the wait=1 case already unconditionally stores its data on the
stack.  In the wait=0 case, I would guess that it would be good to supply
a function that gets called after a grace period elapses after the last
CPU invokes the to-be-called-by-all-CPUs function:

int smp_call_function_nowait(void (*func)(void *), void *info, int natomic, void (*cleanup)(struct rcu_head *rcu))

Is this what you are looking for?  My guess is that the idea is to
pre-allocate the memory before entering a bunch of irq-diabled code that
is difficult to unwind from.

> > > For the wait=1 case, something very clever such as processing pending
> > > requests in a polling loop might be cool... however I'd rather not add
> > > such complexity until someone needs it (you could stick a comment in
> > > there outlining your algorithm). But I'd just rather not have peole rely
> > > on it yet.
> > 
> > In that case we may need to go back to the global lock with only one
> > request being processed at a time.  Otherwise, if two wait=1 requests
> > happen at the same time, they deadlock waiting for each other to process
> > their request.  (See Keith Owens: http://lkml.org/lkml/2008/5/2/183).
> > 
> > In other words, if you want to allow parallel calls to
> > smp_call_function(), the simplest way to do it seems to be to do the
> > polling loop.  The other ways I have come up with thus far are uglier
> > and less effective (see http://lkml.org/lkml/2008/4/30/164).
> > 
> > Now, what I -could- do would be to prohibit the wait=1 case from
> > irq-disable state from polling -- that would make sense, as the caller
> > probably had a reason to mask irqs, and might not take kindly to having
> > them faked behind the caller's back.  ;-)
> 
> I think we're talking past each other a little bit.
> 
> There is no irq-disabled calls as yet, therefore I don't think we should
> add a lot of complex code just to _allow_ for it; at least, not until a
> really compelling user comes up.
> 
> The main thing is to parallelise the code. The fact that we can trivially 
> support irq-disabled calls for nowait case (if the caller supplies the
> data or can handle failure) is just a bonus.

Well, that would explain my confusion!!!  ;-)

It is also not hard to support irq-disabled calls for the wait case one
of two ways:

o	Expand the scope of call_function_lock to cover the call
	to csd_flag_wait().  In the irq-disabled-wait case, use
	spin_trylock_irqsave() to acquire this lock.  If lock acquisition
	fails, hand back -EBUSY.

o	Use the polling trick.  This avoids deadlock and failure as well,
	but means that one form of irqs happens behind your back despite
	irqs being disabled.

So just saying "no" until a need arises makes sense here.

> > > > It it doesn't return -ENOMEM I know its been queued and will be
> > > > processed at some point, if it does fail, I can deal with it in another
> > > > way.
> > > 
> > > At least with IPIs I think we can guarantee they will be processed on
> > > the target after we queue them.
> > 
> > OK, so let me make sure I understand what is needed.  One example might be
> > some code called from scheduler_tick(), which runs with irqs disabled.
> > Without the ability to call smp_call_function() directly, you have
> > to fire off a work queue or something.  Now, if smp_call_function()
> > can hand you an -ENOMEM or (maybe) an -EBUSY, then you still have to
> > fire off the work queue, but you probably only have to do it rarely,
> > minimizing the performance impact.
> > 
> > Another possibility is when it is -nice- to call smp_call_function(),
> > but can just try again on the next scheduler_tick() -- ignoring dynticks
> > idle for the moment.  In this case, you might still test the error return
> > to set a flag that you will check on the next scheduler_tick() call.
> > 
> > Is this where you guys are coming from?
> > 
> > And you are all OK with smp_call_function() called with irqs enabled
> > never being able to fail, right?  (Speaking of spaghetti code, why
> > foist unnecessary failure checks on the caller...)
> 
> Having the fallback is fine, yes. I'd say it shouldn't often get called.

The fallback is to waiting in the current patch (see below).  This version
disallows calls with irqs disabled, so parallel calls to smp_call_function()
will process each other's function calls concurrently.  Might be a bit of
a surprise to some existing uses -- but is the price of parallelism.

> > > > I know I'd like to do that and I suspect Nick has a few use cases up his
> > > > sleeve as well.
> > > 
> > > It would be handy. The "quickly kick something off on another CPU" is
> > > pretty nice in mm/ when you have per-cpu queues or caches that might
> > > want to be flushed.
> > 
> > OK, I think I might be seeing what you guys are getting at.  Here is
> > what I believe you guys need:
> > 
> > 1.	No deadlocks, ever, not even theoretical "low probability"
> > 	deadlocks.
> 
> Of course ;)
> 
> > 2.	No failure returns when called with irqs enabled.  On the other
> > 	hand, when irqs are disabled, failure is possible.  Though hopefully
> > 	unlikely.
> 
> I think I'd like to keep existing smp_call_function that disallows
> irq-disabled calls and can't fail. Introduce a new one for irq-disabled
> case.

That makes a lot of sense -- especially if we need to introduce a cleanup
function to handle memory being passed into smp_call_function_disabled()
or whatever it ends up being called.

> But sure, the existing smp_call_function implementation can't fail.

Good!

> > 3.	Parallel execution of multiple smp_call_function() requests
> > 	is required, even when called with irqs disabled.
> 
> I think so. At least for the call_function_single case.

OK.  So you are willing to live with smp_call_function() and
smp_call_function_mask() being globally serialized?  That would
simplify things a bit.  I think...

> > 4.	The wait=1 case with irqs disabled is prohibited.
> > 
> > 5.	If you call smp_call_function() with irqs disabled, then you
> > 	are guaranteed that no other CPU's smp_call_function() handler
> > 	will be invoked while smp_call_function() is executing.
> > 
> > Anything I am missing?
> 
> For the last cases, I actually think your polling loop is pretty cool ;)
> So I don't completely object to it, I just don't think we should add it
> in until something wants it...

Yep, it is one way to permit the irq-disabled-wait case without -EBUSY.
But it does add some hair, so I agree that it should wait until someone
needs it.

> Don't let me dictate the requirements though, the only real one I had
> was to make call_function_single scalable and faster, and call_function
> be as optimal as possible.

OK.  The below still permits parallel smp_call_function()
and smp_call_function_mask() as well as permitting parallel
smp_call_function_single().  It prohibits the irq-disabled case.

Thoughts?

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 arch/Kconfig |    2 -
 kernel/smp.c |   87 +++++++++++------------------------------------------------
 2 files changed, 18 insertions(+), 71 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index a5a0184..5ae9360 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -38,4 +38,4 @@ config HAVE_KRETPROBES
 	def_bool n
 
 config USE_GENERIC_SMP_HELPERS
-	def_bool n
+	def_bool y
diff --git a/kernel/smp.c b/kernel/smp.c
index 36d3eca..ef6de3d 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -17,7 +17,6 @@ __cacheline_aligned_in_smp DEFINE_SPINLOCK(call_function_lock);
 enum {
 	CSD_FLAG_WAIT		= 0x01,
 	CSD_FLAG_ALLOC		= 0x02,
-	CSD_FLAG_FALLBACK	= 0x04,
 };
 
 struct call_function_data {
@@ -33,9 +32,6 @@ struct call_single_queue {
 	spinlock_t lock;
 };
 
-static DEFINE_PER_CPU(struct call_function_data, cfd_fallback);
-static DEFINE_PER_CPU(unsigned long, cfd_fallback_used);
-
 void __cpuinit init_call_single_data(void)
 {
 	int i;
@@ -84,48 +80,13 @@ static void generic_exec_single(int cpu, struct call_single_data *data)
 		csd_flag_wait(data);
 }
 
-/*
- * We need to have a global per-cpu fallback of call_function_data, so
- * we can safely proceed with smp_call_function() if dynamic allocation
- * fails and we cannot fall back to on-stack allocation (if wait == 0).
- */
-static noinline void acquire_cpu_fallback(int cpu)
-{
-	while (test_and_set_bit_lock(0, &per_cpu(cfd_fallback_used, cpu)))
-		cpu_relax();
-}
-
-static noinline void free_cpu_fallback(struct call_single_data *csd)
-{
-	struct call_function_data *data;
-	int cpu;
-
-	data = container_of(csd, struct call_function_data, csd);
-
-	/*
-	 * We could drop this loop by embedding a cpu variable in
-	 * csd, but this should happen so extremely rarely (if ever)
-	 * that this seems like a better idea
-	 */
-	for_each_possible_cpu(cpu) {
-		if (&per_cpu(cfd_fallback, cpu) != data)
-			continue;
-
-		clear_bit_unlock(0, &per_cpu(cfd_fallback_used, cpu));
-		break;
-	}
-}
-
 static void rcu_free_call_data(struct rcu_head *head)
 {
 	struct call_function_data *data;
 
 	data = container_of(head, struct call_function_data, rcu_head);
 
-	if (data->csd.flags & CSD_FLAG_ALLOC)
-		kfree(data);
-	else
-		free_cpu_fallback(&data->csd);
+	kfree(data);
 }
 
 /*
@@ -222,8 +183,6 @@ void generic_smp_call_function_single_interrupt(void)
 				data->flags &= ~CSD_FLAG_WAIT;
 			} else if (data_flags & CSD_FLAG_ALLOC)
 				kfree(data);
-			else if (data_flags & CSD_FLAG_FALLBACK)
-				free_cpu_fallback(data);
 		}
 		/*
 		 * See comment on outer loop
@@ -244,35 +203,29 @@ void generic_smp_call_function_single_interrupt(void)
 int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
 			     int retry, int wait)
 {
+	struct call_single_data d;
 	unsigned long flags;
 	/* prevent preemption and reschedule on another processor */
 	int me = get_cpu();
 
 	/* Can deadlock when called with interrupts disabled */
-	WARN_ON(wait && irqs_disabled());
+	WARN_ON(irqs_disabled());
 
 	if (cpu == me) {
 		local_irq_save(flags);
 		func(info);
 		local_irq_restore(flags);
 	} else {
-		struct call_single_data *data;
+		struct call_single_data *data = NULL;
 
-		if (wait) {
-			struct call_single_data d;
-
-			data = &d;
-			data->flags = CSD_FLAG_WAIT;
-		} else {
+		if (!wait) {
 			data = kmalloc(sizeof(*data), GFP_ATOMIC);
 			if (data)
 				data->flags = CSD_FLAG_ALLOC;
-			else {
-				acquire_cpu_fallback(me);
-
-				data = &per_cpu(cfd_fallback, me).csd;
-				data->flags = CSD_FLAG_FALLBACK;
-			}
+		}
+		if (!data) {
+			data = &d;
+			data->flags = CSD_FLAG_WAIT;
 		}
 
 		data->func = func;
@@ -320,13 +273,14 @@ void __smp_call_function_single(int cpu, struct call_single_data *data)
 int smp_call_function_mask(cpumask_t mask, void (*func)(void *), void *info,
 			   int wait)
 {
-	struct call_function_data *data;
+	struct call_function_data d;
+	struct call_function_data *data = NULL;
 	cpumask_t allbutself;
 	unsigned long flags;
 	int cpu, num_cpus;
 
 	/* Can deadlock when called with interrupts disabled */
-	WARN_ON(wait && irqs_disabled());
+	WARN_ON(irqs_disabled());
 
 	cpu = smp_processor_id();
 	allbutself = cpu_online_map;
@@ -345,21 +299,14 @@ int smp_call_function_mask(cpumask_t mask, void (*func)(void *), void *info,
 		return smp_call_function_single(cpu, func, info, 0, wait);
 	}
 
-	if (wait) {
-		struct call_function_data d;
-
-		data = &d;
-		data->csd.flags = CSD_FLAG_WAIT;
-	} else {
+	if (!wait) {
 		data = kmalloc(sizeof(*data), GFP_ATOMIC);
 		if (data)
 			data->csd.flags = CSD_FLAG_ALLOC;
-		else {
-			acquire_cpu_fallback(cpu);
-
-			data = &per_cpu(cfd_fallback, cpu);
-			data->csd.flags = CSD_FLAG_FALLBACK;
-		}
+	}
+	if (!data) {
+		data = &d;
+		data->csd.flags = CSD_FLAG_WAIT;
 	}
 
 	spin_lock_init(&data->lock);
