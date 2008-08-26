Return-Path: <linux-kernel-owner+w=401wt.eu-S1758197AbYHZQF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758197AbYHZQF6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 12:05:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756496AbYHZQFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 12:05:50 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:51312 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934AbYHZQFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 12:05:49 -0400
Date: Tue, 26 Aug 2008 09:05:30 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josht@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, cl@linux-foundation.org, mingo@elte.hu,
       akpm@linux-foundation.org, manfred@colorfullife.com,
       dipankar@in.ibm.com, schamp@sgi.com, niv@us.ibm.com, dvhltc@us.ibm.com,
       ego@in.ibm.com, laijs@cn.fujitsu.com, rostedt@goodmis.org
Subject: Re: [PATCH, RFC, tip/core/rcu] scalable classic RCU implementation
Message-ID: <20080826160530.GB6656@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080821234318.GA1754@linux.vnet.ibm.com> <1219447772.5197.98.camel@josh-work.beaverton.ibm.com> <20080823015336.GP6744@linux.vnet.ibm.com> <1219701750.12334.29.camel@josh-work.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219701750.12334.29.camel@josh-work.beaverton.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2008 at 03:02:30PM -0700, Josh Triplett wrote:
> On Fri, 2008-08-22 at 18:53 -0700, Paul E. McKenney wrote:
> > On Fri, Aug 22, 2008 at 04:29:32PM -0700, Josh Triplett wrote:
> > > On Thu, 2008-08-21 at 16:43 -0700, Paul E. McKenney wrote:
> > > > -	spinlock_t	lock	____cacheline_internodealigned_in_smp;
> > > > -	cpumask_t	cpumask; /* CPUs that need to switch in order    */
> > > > -				 /* for current batch to proceed.        */
> > > > +/*
> > > > + * Definition for node within the RCU grace-period-detection hierarchy.
> > > > + */
> > > > +struct rcu_node {
> > > > +	spinlock_t lock;
> > > > +	unsigned long	qsmask;	/* CPUs or groups that need to switch in      */
> > > > +				/*  order for current grace period to proceed.*/
> > > > +	unsigned long	qsmaskinit;
> > > > +				/* Per-GP initialization for qsmask.	      */
> > > > +	int	grplo;		/* lowest-numbered CPU or group here.	      */
> > > > +	int	grphi;		/* highest-numbered CPU or group here.	      */
> > > > +	char	grpnum;		/* CPU/group number for next level up.	      */
> > > > +	char	level;		/* root is at level 0.			      */
> > > 
> > > These four fields should use sized types, and preferably unsigned types.
> > 
> > OK for grpnum and level, but grphi and grplo need to be "int" to
> > match the various CPU-manipulation primitives.
> 
> Fair enough; the CPU-manipulation primitives do indeed use "int".  Odd
> that they use a signed type.

It does allow use of -1 for "no particular CPU" or for error checking,
which can sometimes be useful.

> > > > +	struct rcu_node *parent;
> > > >  } ____cacheline_internodealigned_in_smp;
> > > > 
> > > > -/* Is batch a before batch b ? */
> > > > -static inline int rcu_batch_before(long a, long b)
> > > > -{
> > > > -	return (a - b) < 0;
> > > > -}
> > > > +/*
> > > > + * RCU global state, including node hierarchy.  This hierarchy is
> > > > + * represented in "heap" form in a dense array.  The root (first level)
> > > > + * of the hierarchy is in ->node[0] (referenced by ->level[0]), the second
> > > > + * level in ->node[1] through ->node[m] (->node[1] referenced by ->level[1]),
> > > > + * and the third level in ->node[m+1] and following (->node[m+1] referenced
> > > > + * by ->level[2]).  The number of levels is determined by the number of
> > > > + * CPUs and by CONFIG_RCU_FANOUT.  Small systems will have a "hierarchy"
> > > > + * consisting of a single rcu_node.
> > > > + */
> > > > +struct rcu_state {
> > > > +	struct rcu_node node[NUM_RCU_NODES];	/* Hierarchy. */
> > > > +	struct rcu_node *level[NUM_RCU_LEVELS];	/* Hierarchy levels. */
> > > > +	int levelcnt[MAX_RCU_LEVELS + 1];	/* # nodes in each level. */
> > > > +	int levelspread[NUM_RCU_LEVELS];	/* kids/node in each level. */
> > > 
> > > These two should use sized types.
> > 
> > Fair enough.  And can be 8 bits, for that matter.
> 
> levelspread can, since it will never exceed 64, but levelcnt cannot.
> That would lead to a bug on systems with more than 256 CPUs.

Good catch!!! Fixed.

> > > > +
> > > > +	/* The following fields are guarded by the root rcu_node's lock. */
> > > > +
> > > > +	char	signaled ____cacheline_internodealigned_in_smp;
> > > > +						/* sent GP-kick IPIs? */
> > > 
> > > u8 or bool, depending on semantics.  If just a simple flag, how about
> > > bool?
> > 
> > This will need to be a non-bool shortly.
> 
> OK.
> 
> > OK, so what the heck -are- the official type names???  u8 seems
> > to be defined in a powerpc-specific file.  OK, it also appears in
> > include/asm-generic/int-l64.h.  s8, u8, s16, u16, s32, u32, s64, and
> > u64, then?
> 
> Yes. {s,u}{8,16,32,64}, defined in include/asm-generic/int-{l,ll}64.h,
> depending on architecture.

Got it!

> > > >  	int cpu;
> > > >  	struct rcu_head barrier;
> > > >  };
> > > > 
> > > > +extern struct rcu_state rcu_state;
> > > >  DECLARE_PER_CPU(struct rcu_data, rcu_data);
> > > > +
> > > > +extern struct rcu_state rcu_bh_state;
> > > >  DECLARE_PER_CPU(struct rcu_data, rcu_bh_data);
> > > 
> > > Why extern and in the header?  I don't see anything else using them.
> > 
> > kernel/rcuclassic_trace.c, right?
> 
> Hmmm, true.  Unfortunate, particularly if only for the benefit of
> tracing code which doesn't even get compiled under normal circumstances.

Indeed.  Putting rcuclassic_trace.c into rcuclassic.c gets pretty ugly.
I suppose that another possibility would be to #include rcuclassic_trace.c
into rcuclassic.c, which might actually be the best approach.

> > > >  	select DEBUG_FS
> > > >  	default y
> > > >  	help
> > > > @@ -77,3 +76,33 @@ config RCU_TRACE
> > > > 
> > > >  	  Say Y here if you want to enable RCU tracing
> > > >  	  Say N if you are unsure.
> > > > +
> > > > +config RCU_FANOUT
> > > > +	int "Hierarchical RCU fanout value"
> > > > +	range 2 64 if 64BIT
> > > > +	range 2 32 if !64BIT
> > > > +	depends on CLASSIC_RCU
> > > > +	default 64 if 64BIT
> > > > +	default 32 if !64BIT
> > > > +	help
> > > > +	  This option controls the fanout of hierarchical implementations
> > > > +	  of RCU, allowing RCU to work efficiently on machines with
> > > > +	  large numbers of CPUs.  This value must be at least the cube
> > > > +	  root of NR_CPUS, which allows NR_CPUS up to 32,768 for 32-bit
> > > > +	  systems and up to 262,144 for 64-bit systems.
> > > > +
> > > > +	  Select a specific number if testing RCU itself.
> > > 
> > > ...or if attempting to tune for a specific NUMA system.
> > 
> > Indeed.  But I need to see an actual example before I document it.
> > It would be easy to make things slower by following the NUMA hardware
> > layout.
> 
> Fair enough.
> 
> > > > +	  Take the default if unsure.
> > > > +
> > > > +config RCU_FANOUT_EXACT
> > > > +	bool "Disable hierarchical RCU auto-balancing"
> > > > +	depends on CLASSIC_RCU
> > > > +	default n
> > > > +	help
> > > > +	  This option forces use of the exact RCU_FANOUT value specified,
> > > > +	  regardless of imbalances in the hierarchy.  This can be useful
> > > > +	  on systems with strong NUMA behavior.
> > > > +
> > > > +	  Without RCU_FANOUT_EXACT, the code will balance the hierarchy.
> > > 
> > > You might want to give a specific example of a NUMA machine, the
> > > appropriate value to use on that machine, and the result with and
> > > without RCU_FANOUT_EXACT.
> > 
> > Or change "can" to "might".  ;-)
> 
> :)
> 
> Right, my comment only applies if such an example actually exists. :)

Hopefully we have correctly tuned the uncertainty.

> > > > -static int blimit = 10;
> > > > -static int qhimark = 10000;
> > > > -static int qlowmark = 100;
> > > > +static int blimit = 10;		/* Maximum callbacks per softirq. */
> > > > +static int qhimark = 10000;	/* If this many pending, ignore blimit. */
> > > > +static int qlowmark = 100;	/* Once only this many pending, use blimit. */
> > > 
> > > Indentation mismatch on the comments?
> > 
> > Looks fine in the source -- context diff-ism.
> 
> Sigh.  Yay for tabs.
> 
> > > >  #ifdef CONFIG_SMP
> > > > -static void force_quiescent_state(struct rcu_data *rdp,
> > > > -			struct rcu_ctrlblk *rcp)
> > > > +static void force_quiescent_state(struct rcu_state *rsp)
> > > >  {
> > > >  	int cpu;
> > > > -	cpumask_t cpumask;
> > > >  	unsigned long flags;
> > > > 
> > > >  	set_need_resched();
> > > > -	spin_lock_irqsave(&rcp->lock, flags);
> > > > -	if (unlikely(!rcp->signaled)) {
> > > > -		rcp->signaled = 1;
> > > > +	if (!spin_trylock_irqsave(&rsp->onofflock, flags))
> > > > +		return;
> > > 
> > > This seems to make force_quiescent_state rather less forceful.
> > 
> > It will try again on the next scheduling-clock interrupt.  The reason
> > I did this is because ->onofflock is a global lock acquired when
> > beginning a quiescent state or when onlining/offlining.  Can't let
> > force_quiescent_state() monopolize things, and would like to exclude
> > online/offline while doing force_quiescent_state().  Hence make
> > force_quiescent_state() back off if the lock is held.
> > 
> > There is probably a better way to do this...
> 
> Primarily concerned about the possibility of perpetual failure.  Then
> again, eventually a grace period will occur "naturally".  Just wondering
> whether the inability to force might cause a problem.

Ah!  So the lock can fail for the following reasons:

1.	Some other CPU is in force_quiescent_state().  Here there is
	clearly no problem.

2.	Some other CPU is initializing the rcu_node hierarchy to set
	up a new quiescent state.  Here, we shouldn't have been
	executing force_quiescent_state() in the first place, so
	again no problem.

3.	Some other CPU is adjusting the rcu_node hierarchy to account
	for a CPU online or offline operation.  There is enough overhead
	in onlining and offlining CPUs that it seems unlikely that this
	could result in a denial of service.  However, if someone can
	make this happen, I will make the online/offline operation check
	to see if it should do a force_quiescent_state() -- which will
	require an __force_quiescent_state() where the onofflock is
	acquired by the caller.

So we are covered on #1 and #2, and very likely covered on #3, with an
easy fix if I am wrong.

> > > > -#else
> > > > +#else /* #ifdef CONFIG_HOTPLUG_CPU */
> > > > 
> > > > -static void rcu_offline_cpu(int cpu)
> > > > +static inline void
> > > > +rcu_offline_cpu(int cpu)
> > > >  {
> > > >  }
> > > 
> > > No need to explicitly say "inline"; GCC should do the right thing here.
> > > Same comment applies a couple of other places in your patch.
> > 
> > OK, I will get rid of these.  You can do the other 26,000 of them.  ;-)
> 
> :)
> 
> > > > @@ -658,14 +806,19 @@ int rcu_needs_cpu(int cpu)
> > > >  	struct rcu_data *rdp = &per_cpu(rcu_data, cpu);
> > > >  	struct rcu_data *rdp_bh = &per_cpu(rcu_bh_data, cpu);
> > > > 
> > > > -	return !!rdp->nxtlist || !!rdp_bh->nxtlist || rcu_pending(cpu);
> > > > +	return !!*rdp->nxttail[RCU_DONE_TAIL] ||
> > > > +	       !!*rdp_bh->nxttail[RCU_DONE_TAIL] ||
> > > > +	       rcu_pending(cpu);
> > > 
> > > !! seems unnecessary here.
> > 
> > Someone once told me why this was necessary, but I forget.  It was in the
> > original, and I didn't put it there.  Some weirdness about conversion
> > to 32-bit integer when the lower 32 bits of the pointer was zero or
> > some such.  So if your pointer value was 0x100000000, for example,
> > so that conversion to int gives zero.
> 
> Good point!  That doesn't apply if you use ||, though.  If you just did
> "return somepointer" that could potentially cause the problem you
> describe.  In any case, it can't *hurt* to have it; GCC should do the
> sane thing.

OK.  I will review this towards the end, leaving it there to remind me
in the meantime.

So, would I need the !! on the left-hand operand of the first || due
to short-circuiting?

> > > > +void call_rcu_bh(struct rcu_head *head,
> > > > +				void (*func)(struct rcu_head *rcu))
> > > > +{
> > > > +	unsigned long flags;
> > > > +
> > > > +	head->func = func;
> > > > +	head->next = NULL;
> > > > +	local_irq_save(flags);
> > > > +	__call_rcu(head, &rcu_bh_state, &__get_cpu_var(rcu_bh_data));
> > > > +	local_irq_restore(flags);
> > > > +}
> > > > +EXPORT_SYMBOL_GPL(call_rcu_bh);
> > > 
> > > This comment applies to the original code, but:
> > > You only call __call_rcu twice, in call_rcu and call_rcu_bh.  Both
> > > times, you set head first, then wrap the call with local_irq_save.  How
> > > about moving both into __call_rcu, making call_rcu and call_rcu_bh
> > > one-liners?
> > 
> > I can't pass "rcu_data" to a function (or at least I don't know how to
> > do so, short of passing __per_cpu_rcu_data and doing the per-CPU stuff
> > by hand).  I could make __call_rcu() be a macro, but that seemed more
> > ugly than it seemed worthwhile.
> > 
> > Is there some other approach that would work?
> 
> Hmmm.  No, not that I know of.  Sigh.

The only other thing I can think of is dynamically allocated per-CPU
variables, which seemed more ugly than helpful in this case.

> > > > +static char *rcuclassic_trace_buf;
> > > > +#define RCUPREEMPT_TRACE_BUF_SIZE 4096
> > > 
> > > Did you perhaps want PAGE_SIZE?
> > 
> > I really want some way of gracefully handling arbitrarily long output
> > to debugfs.  I am sure that some such exists, but haven't found it.
> > What I do instead is to arbitrarily truncate output to 4096 bytes,
> > which will be stunningly less than useful on a 4,096-CPU machine.  :-/
> > 
> > Suggestions welcome!
> 
> I can see two possibilities, depending on how much complexity you want.
> 
> The complicated way: do one pass calling snprintf everywhere and adding
> up the total length used, and if you run out of memory during that pass,
> reallocate the buffer to at least the total length you accumulated.  Or
> something like that.
> 
> The simple hack:
> #define RCUPREEMPT_TRACE_BUF_SIZE (NR_CPUS * something)
> 
> :)

Given that this doesn't show up in production kernels, I will take
door #2.  Though I was hoping for some sort of interface that "just
made it work" regardless of the size of user reads and the length
and pattern of in-kernel prints, but that might be a bit much...

						Thanx, Paul
