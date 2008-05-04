Return-Path: <linux-kernel-owner+w=401wt.eu-S1757986AbYEDWFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757986AbYEDWFT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 18:05:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755452AbYEDWFB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 18:05:01 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:35045 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755061AbYEDWE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 18:04:59 -0400
Date: Sun, 4 May 2008 15:04:40 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       jeremy@goop.org, mingo@elte.hu
Subject: Re: [PATCH 1/10] Add generic helpers for arch IPI function calls
Message-ID: <20080504220440.GA1470@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080430113456.GY12774@kernel.dk> <20080430121712.GR11126@linux.vnet.ibm.com> <20080430123717.GC12774@kernel.dk> <20080502020241.GA26088@linux.vnet.ibm.com> <20080502021233.GC11844@wotan.suse.de> <20080502122955.GB15522@linux.vnet.ibm.com> <20080502124205.GA23680@linux.vnet.ibm.com> <1209733169.13978.157.camel@twins> <20080503054930.GA19664@wotan.suse.de> <20080503181148.GA16159@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080503181148.GA16159@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 03, 2008 at 11:11:48AM -0700, Paul E. McKenney wrote:
> On Sat, May 03, 2008 at 07:49:30AM +0200, Nick Piggin wrote:
> > On Fri, May 02, 2008 at 02:59:29PM +0200, Peter Zijlstra wrote:
> > > On Fri, 2008-05-02 at 05:42 -0700, Paul E. McKenney wrote:
> > > 
> > > > And here is one scenario that makes me doubt that my imagination is
> > > > faulty:
> > > > 
> > > > 1.	CPU 0 disables irqs.
> > > > 
> > > > 2.	CPU 1 disables irqs.
> > > > 
> > > > 3.	CPU 0 invokes smp_call_function().  But CPU 1 will never respond
> > > > 	because its irqs are disabled.
> > > > 
> > > > 4.	CPU 1 invokes smp_call_function().  But CPU 0 will never respond
> > > > 	because its irqs are disabled.
> > > > 
> > > > Looks like inherent deadlock to me, requiring that smp_call_function()
> > > > be invoked with irqs enabled.
> > > > 
> > > > So, what am I missing here?
> > > 
> > > The wish to do it anyway ;-)
> > > 
> > > I can imagine some situations where I'd like to try anyway and fall back
> > > to a slower path when failing.
> > > 
> > > With the initial design we would simply allocate data, stick it on the
> > > queue and call the ipi (when needed).
> > > 
> > > This is perfectly deadlock free when wait=0 and it just returns -ENOMEM
> > > on allocation failure.
> > 
> > Yeah, I'm just talking about the wait=0 case. (btw. I'd rather the core
> > API takes some data rather than allocates some itself, eg because you
> > might want to have it on the stack).
> 
> But taking data on the stack is safe only in the wait=1 case, right?
> 
> > For the wait=1 case, something very clever such as processing pending
> > requests in a polling loop might be cool... however I'd rather not add
> > such complexity until someone needs it (you could stick a comment in
> > there outlining your algorithm). But I'd just rather not have peole rely
> > on it yet.
> 
> In that case we may need to go back to the global lock with only one
> request being processed at a time.  Otherwise, if two wait=1 requests
> happen at the same time, they deadlock waiting for each other to process
> their request.  (See Keith Owens: http://lkml.org/lkml/2008/5/2/183).
> 
> In other words, if you want to allow parallel calls to
> smp_call_function(), the simplest way to do it seems to be to do the
> polling loop.  The other ways I have come up with thus far are uglier
> and less effective (see http://lkml.org/lkml/2008/4/30/164).
> 
> Now, what I -could- do would be to prohibit the wait=1 case from
> irq-disable state from polling -- that would make sense, as the caller
> probably had a reason to mask irqs, and might not take kindly to having
> them faked behind the caller's back.  ;-)
> 
> > > It it doesn't return -ENOMEM I know its been queued and will be
> > > processed at some point, if it does fail, I can deal with it in another
> > > way.
> > 
> > At least with IPIs I think we can guarantee they will be processed on
> > the target after we queue them.
> 
> OK, so let me make sure I understand what is needed.  One example might be
> some code called from scheduler_tick(), which runs with irqs disabled.
> Without the ability to call smp_call_function() directly, you have
> to fire off a work queue or something.  Now, if smp_call_function()
> can hand you an -ENOMEM or (maybe) an -EBUSY, then you still have to
> fire off the work queue, but you probably only have to do it rarely,
> minimizing the performance impact.
> 
> Another possibility is when it is -nice- to call smp_call_function(),
> but can just try again on the next scheduler_tick() -- ignoring dynticks
> idle for the moment.  In this case, you might still test the error return
> to set a flag that you will check on the next scheduler_tick() call.
> 
> Is this where you guys are coming from?
> 
> And you are all OK with smp_call_function() called with irqs enabled
> never being able to fail, right?  (Speaking of spaghetti code, why
> foist unnecessary failure checks on the caller...)
> 
> > > I know I'd like to do that and I suspect Nick has a few use cases up his
> > > sleeve as well.
> > 
> > It would be handy. The "quickly kick something off on another CPU" is
> > pretty nice in mm/ when you have per-cpu queues or caches that might
> > want to be flushed.
> 
> OK, I think I might be seeing what you guys are getting at.  Here is
> what I believe you guys need:
> 
> 1.	No deadlocks, ever, not even theoretical "low probability"
> 	deadlocks.
> 
> 2.	No failure returns when called with irqs enabled.  On the other
> 	hand, when irqs are disabled, failure is possible.  Though hopefully
> 	unlikely.
> 
> 3.	Parallel execution of multiple smp_call_function() requests
> 	is required, even when called with irqs disabled.
> 
> 4.	The wait=1 case with irqs disabled is prohibited.
> 
> 5.	If you call smp_call_function() with irqs disabled, then you
> 	are guaranteed that no other CPU's smp_call_function() handler
> 	will be invoked while smp_call_function() is executing.
> 
> Anything I am missing?

On the off-chance that the answer to the above question is "no", here
is a crude patch on top of Jens's earlier patch.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 arch/Kconfig |    2 -
 kernel/smp.c |  107 ++++++++++++++++++-----------------------------------------
 2 files changed, 34 insertions(+), 75 deletions(-)

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
index 36d3eca..d7e8dd1 100644
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
@@ -48,7 +44,7 @@ void __cpuinit init_call_single_data(void)
 	}
 }
 
-static void csd_flag_wait(struct call_single_data *data)
+static void csd_flag_wait(struct call_single_data *data, int poll)
 {
 	/* Wait for response */
 	do {
@@ -59,6 +55,8 @@ static void csd_flag_wait(struct call_single_data *data)
 		if (!(data->flags & CSD_FLAG_WAIT))
 			break;
 		cpu_relax();
+		if (poll)
+			generic_smp_call_function_interrupt();
 	} while (1);
 }
 
@@ -66,7 +64,7 @@ static void csd_flag_wait(struct call_single_data *data)
  * Insert a previously allocated call_single_data element for execution
  * on the given CPU. data must already have ->func, ->info, and ->flags set.
  */
-static void generic_exec_single(int cpu, struct call_single_data *data)
+static void generic_exec_single(int cpu, struct call_single_data *data, int poll)
 {
 	struct call_single_queue *dst = &per_cpu(call_single_queue, cpu);
 	int wait = data->flags & CSD_FLAG_WAIT, ipi;
@@ -81,39 +79,7 @@ static void generic_exec_single(int cpu, struct call_single_data *data)
 		arch_send_call_function_single_ipi(cpu);
 
 	if (wait)
-		csd_flag_wait(data);
-}
-
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
+		csd_flag_wait(data, poll);
 }
 
 static void rcu_free_call_data(struct rcu_head *head)
@@ -122,10 +88,7 @@ static void rcu_free_call_data(struct rcu_head *head)
 
 	data = container_of(head, struct call_function_data, rcu_head);
 
-	if (data->csd.flags & CSD_FLAG_ALLOC)
-		kfree(data);
-	else
-		free_cpu_fallback(&data->csd);
+	kfree(data);
 }
 
 /*
@@ -222,8 +185,6 @@ void generic_smp_call_function_single_interrupt(void)
 				data->flags &= ~CSD_FLAG_WAIT;
 			} else if (data_flags & CSD_FLAG_ALLOC)
 				kfree(data);
-			else if (data_flags & CSD_FLAG_FALLBACK)
-				free_cpu_fallback(data);
 		}
 		/*
 		 * See comment on outer loop
@@ -244,40 +205,39 @@ void generic_smp_call_function_single_interrupt(void)
 int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
 			     int retry, int wait)
 {
+	struct call_single_data d;
 	unsigned long flags;
 	/* prevent preemption and reschedule on another processor */
 	int me = get_cpu();
+	int irqsdisabled = irqs_disabled();
 
 	/* Can deadlock when called with interrupts disabled */
-	WARN_ON(wait && irqs_disabled());
+	WARN_ON(wait && irqsdisabled);
 
 	if (cpu == me) {
 		local_irq_save(flags);
 		func(info);
 		local_irq_restore(flags);
 	} else {
-		struct call_single_data *data;
-
-		if (wait) {
-			struct call_single_data d;
+		struct call_single_data *data = NULL;
 
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
+		}
+		if (!data) {
+			if (irqsdisabled) {
+				put_cpu();
+				return -ENOMEM;
 			}
+			data = &d;
+			data->flags = CSD_FLAG_WAIT;
 		}
 
 		data->func = func;
 		data->info = info;
-		generic_exec_single(cpu, data);
+		generic_exec_single(cpu, data, !irqsdisabled);
 	}
 
 	put_cpu();
@@ -300,7 +260,7 @@ void __smp_call_function_single(int cpu, struct call_single_data *data)
 	/* Can deadlock when called with interrupts disabled */
 	WARN_ON((data->flags & CSD_FLAG_WAIT) && irqs_disabled());
 
-	generic_exec_single(cpu, data);
+	generic_exec_single(cpu, data, !irqs_disabled());
 }
 
 /**
@@ -320,13 +280,15 @@ void __smp_call_function_single(int cpu, struct call_single_data *data)
 int smp_call_function_mask(cpumask_t mask, void (*func)(void *), void *info,
 			   int wait)
 {
-	struct call_function_data *data;
+	struct call_function_data d;
+	struct call_function_data *data = NULL;
 	cpumask_t allbutself;
 	unsigned long flags;
 	int cpu, num_cpus;
+	int irqsdisabled = irqs_disabled();
 
 	/* Can deadlock when called with interrupts disabled */
-	WARN_ON(wait && irqs_disabled());
+	WARN_ON(wait && irqsdisabled);
 
 	cpu = smp_processor_id();
 	allbutself = cpu_online_map;
@@ -345,21 +307,18 @@ int smp_call_function_mask(cpumask_t mask, void (*func)(void *), void *info,
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
+	}
+	if (!data) {
+		if (unlikely(irqsdisabled)) {
+			put_cpu();
+			return -ENOMEM;
 		}
+		data = &d;
+		data->csd.flags = CSD_FLAG_WAIT;
 	}
 
 	spin_lock_init(&data->lock);
@@ -382,7 +341,7 @@ int smp_call_function_mask(cpumask_t mask, void (*func)(void *), void *info,
 
 	/* optionally wait for the CPUs to complete */
 	if (wait)
-		csd_flag_wait(&data->csd);
+		csd_flag_wait(&data->csd, !irqsdisabled);
 
 	return 0;
 }
