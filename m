Return-Path: <linux-kernel-owner+w=401wt.eu-S1752287AbYIEXFE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287AbYIEXFE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 19:05:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751436AbYIEXEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 19:04:54 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:42079 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbYIEXEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 19:04:53 -0400
Date: Fri, 5 Sep 2008 16:04:11 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, cl@linux-foundation.org, mingo@elte.hu,
       manfred@colorfullife.com, dipankar@in.ibm.com, josht@linux.vnet.ibm.com,
       schamp@sgi.com, niv@us.ibm.com, dvhltc@us.ibm.com, ego@in.ibm.com,
       laijs@cn.fujitsu.com, rostedt@goodmis.org, peterz@infradead.org,
       penberg@cs.helsinki.fi, andi@firstfloor.org
Subject: Re: [PATCH, RFC] v4 scalable classic RCU implementation
Message-ID: <20080905230411.GC6737@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080821234318.GA1754@linux.vnet.ibm.com> <20080825000738.GA24339@linux.vnet.ibm.com> <20080830004935.GA28548@linux.vnet.ibm.com> <20080905152930.GA8124@linux.vnet.ibm.com> <20080905123340.bbb26f27.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080905123340.bbb26f27.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2008 at 12:33:40PM -0700, Andrew Morton wrote:
> On Fri, 5 Sep 2008 08:29:30 -0700
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

Thank you very much for looking this over!

> > Hello!
> > 
> > Still experimental, not for inclusion.  But ready for serious experimental
> > use, in particular, experience on an actual >1000-CPU machine would be
> > most welcome.
> > 
> > Updates from v3:
> > 
> > o	The hierarchical-RCU implementation has been moved to its own
> > 	"rcutree" set of files.  This allows configuring three different
> > 	implementations of RCU (CLASSIC_RCU, PREEMPT_RCU, and the new
> > 	TREE_RCU).  More importantly, it enables easy application of
> > 	this patch to a wide variety of Linux versions.
> > 
> > 	I hope that this implementation can completely replace Classic
> > 	RCU, but in the meantime, this split makes for easier testing
> > 	and review.
> > 
> > o	The stalled-CPU detection is now implemented and working,
> > 	enabled by the CONFIG_RCU_CPU_STALL config parameter.  Complaints
> > 	are kprint()ed 3 seconds into the stall, and every 30 seconds
> > 	thereafter.  It also now attempts to force quiescent states.
> 
> The CONFIG_RCU_CPU_STALL identifier seems poorly-chosen to me - it
> sounds like it will stall my CPU.  Should it be
> CONFIG_RCU_CPU_STALL_DETECTOR?  If it's a debugging option then it
> should have _DEBUG in there too.

CONFIG_RCU_CPU_STALL_DETECTOR it is!  It is sufficiently lightweight
to be included in production systems, and similar mechanisms have proven
their value in my experience.  So no _DEBUG.

> > o	The algorithm uses pre-fabricated masks rather than shifting
> > 	on each access.
> > 
> > o	Review comments have been applied (thank you all!!!).
> > 	For but one example, call_rcu() and call_rcu_bh() are now
> > 	one-liners.
> > 
> > o	The rcu_pending() and rcu_needs_cpu() primitives are now
> > 	much more aggressive about permitting CPUs to enter dynticks
> > 	idle mode.  Only CPUs that have RCU callbacks are kept out
> > 	of dynticks idle mode.
> > 
> > Attached is an updated patch to Classic RCU that applies a
> > hierarchy, greatly reducing the contention on the top-level lock
> > for large machines.  This passes 10-hour concurrent rcutorture and
> > online-offline testing on 128-CPU ppc64.  It is OK for experimental
> > work assuming only modestly brave experimenters (and perhaps even
> > cowardly experiementers), but not yet ready for inclusion.  See also
> > Manfred Spraul's recent patches (or his earlier work from 2004 at
> > http://marc.info/?l=linux-kernel&m=108546384711797&w=2).  We will
> > converge onto a common patch in the fullness of time, but are currently
> > exploring different regions of the design space.  That said, I have
> > already gratefully stolen a number of Manfred's ideas.
> > 
> > This patch provides CONFIG_RCU_FANOUT, which controls the bushiness
> > of the RCU hierarchy.  Defaults to 32 on 32-bit machines and 64 on
> > 64-bit machines.  If CONFIG_NR_CPUS is less than CONFIG_RCU_FANOUT,
> > there is no hierarchy.  By default, the RCU initialization code will
> > adjust CONFIG_RCU_FANOUT to balance the hierarchy, so strongly NUMA
> > architectures may choose to set CONFIG_RCU_FANOUT_EXACT to disable
> > this balancing, allowing the hierarchy to be exactly aligned to the
> > underlying hardware.  Up to two levels of hierarchy are permitted
> > (in addition to the root node), allowing up to 16,384 CPUs on 32-bit
> > systems and up to 262,144 CPUs on 64-bit systems.  I just know that I
> > am going to regret saying this, but this seems more than sufficient
> > for the foreseeable future.  (Some architectures might wish to set
> > CONFIG_RCU_FANOUT=4, which would limit such architectures to 64 CPUs.
> > If this becomes a real problem, additional levels can be added, but I
> > doubt that it will make a significant difference on real hardware.)
> > 
> > In the common case, a given CPU will manipulate its private rcu_data
> > structure and the rcu_node structure that it shares with its immediate
> > neighbors.  This can reduce both lock and memory contention by multiple
> > orders of magnitude, which should eliminate the need for the strange
> > manipulations that are reported to be required when running Linux on
> > very large systems.
> > 
> > Some shortcomings:
> > 
> > o	Entering and leaving dynticks idle mode is a quiescent state,
> > 	but the current patch doesn't take advantage of this (noted
> > 	by Manfred).  It appears that it should be possible to make
> > 	nmi_enter() and nmi_exit() provide an in_nmi(), which would make
> > 	it possible for rcu_irq_enter() and rcu_irq_exit() to figure
> > 	out whether it is safe to tell RCU about the quiescent state --
> > 	and also greatly simplify the code.  However, a first attempt
> > 	to hack this into existence failed, so will be taking a more
> > 	measured approach.
> > 
> > o	There are a few places where grace periods are unnecessarily
> > 	delayed.
> > 
> > o	There are probably hangs, rcutorture failures, &c.  In particular,
> > 	the case where an interrupt from dynticks idle invokes call_rcu()
> > 	requires a bit more thought.  And it requires NMIs to be sorted
> > 	as noted above.
> > 
> > o	There are a few architectures that will sometimes execute irq
> > 	handlers on CPUs that are already marked offline.  This is the
> > 	subject of separate patches.  (Yes, you do have to have a very
> > 	unlikely code construct hitting an unlikely sequence of events
> > 	for anything bad to happen, but still needs to be fixed.)
> > 
> > o	Structure field layout is likely highly suboptimal.  On the other
> > 	hand, given that the read-side primitives do not touch any of
> > 	this data, this issue is not as pressing as it might otherwise be.
> > 
> > o	There is not yet a human-readable design document.  Will be fixed.
> 
> You forgot
> 
>   o	Adds yet another RCU flavour
> 
> Having alternative implementations of the same thing is a real cost in
> terms of maintainability, supportability, etc, etc.

Agreed, but note well the quote from above:

	The hierarchical-RCU implementation has been moved to its own
 	"rcutree" set of files.  This allows configuring three different
 	implementations of RCU (CLASSIC_RCU, PREEMPT_RCU, and the new
 	TREE_RCU).  More importantly, it enables easy application of
 	this patch to a wide variety of Linux versions.
 
 	I hope that this implementation can completely replace Classic
 	RCU, but in the meantime, this split makes for easier testing
 	and review.

The idea is to avoid adding another RCU flavour (or flavor, for that
matter), instead replacing Classic RCU.

> > ...
> >
> > +#if (NR_CPUS) <= RCU_FANOUT
> > +#  define NUM_RCU_LVLS	      1
> > +#  define NUM_RCU_LVL_0	      1
> > +#  define NUM_RCU_LVL_1	      (NR_CPUS)
> > +#  define NUM_RCU_LVL_2	      0
> > +#  define NUM_RCU_LVL_3	      0
> > +#elif (NR_CPUS) <= RCU_FANOUT_SQ
> > +#  define NUM_RCU_LVLS	      2
> > +#  define NUM_RCU_LVL_0	      1
> > +#  define NUM_RCU_LVL_1	      (((NR_CPUS) + RCU_FANOUT - 1) / RCU_FANOUT)
> > +#  define NUM_RCU_LVL_2	      (NR_CPUS)
> > +#  define NUM_RCU_LVL_3	      0
> > +#elif (NR_CPUS) <= RCU_FANOUT_CUBE
> > +#  define NUM_RCU_LVLS	      3
> > +#  define NUM_RCU_LVL_0	      1
> > +#  define NUM_RCU_LVL_1	      (((NR_CPUS) + RCU_FANOUT_SQ - 1) / RCU_FANOUT_SQ)
> > +#  define NUM_RCU_LVL_2	      (((NR_CPUS) + (RCU_FANOUT) - 1) / (RCU_FANOUT))
> > +#  define NUM_RCU_LVL_3	      NR_CPUS
> > +#else
> > +# error "CONFIG_RCU_FANOUT insufficient for NR_CPUS"
> > +#endif /* #if (NR_CPUS) <= RCU_FANOUT */
> 
> Using NR_CPUS for anything at all is grossly, grossly inaccurate. 
> Vendors can and will ship kernels with NR_CPUS=1024 and their customers
> can and will run those kernels on 4-cpu machines.  Lots of customers.
> 
> That's a two-and-a-half-order-of-magnitude inaccuracy.  It makes all
> your above work meaningless.
> 
> To be useful, these decisions should be made at runtime.

I agree in principle, but this case is an exception.

Suppose that we have NR_CPUS=1024 on a 4-CPU 64-bit machine.  Since 64^2
is greater than 1024, we end up with a two-level hierarchy, with one
rcu_node structure at the root and 16 rcu_node leaf structures, each
of which takes up a single 128-byte cache line.  There will be two such
structures in the system, one for rcu and one for rcu_bh.

So I do not believe that this will be a problem.

One laptops, this is even less of an issue -- NR_CPUS=8 on my laptop,
which would reduce to a pair rcu_node structures, one for rcu, the other
for rcu_bh.

Making the decision at runtime would bloat the code by much more than the
extra data consumed.  And introduce yet more races between online/offline
and everything else.  Besides, this way I am being bloat-compatible
with DEFINE_PER_CPU().  ;-)

> > +#define RCU_SUM (NUM_RCU_LVL_0 + NUM_RCU_LVL_1 + NUM_RCU_LVL_2 + NUM_RCU_LVL_3)
> > +#define NUM_RCU_NODES (RCU_SUM - NR_CPUS)
> > +
> > +/*
> > + * Definition for node within the RCU grace-period-detection hierarchy.
> > + */
> > +struct rcu_node {
> > +	spinlock_t lock;
> > +	unsigned long qsmask;	/* CPUs or groups that need to switch in */
> > +				/*  order for current grace period to proceed.*/
> > +	unsigned long qsmaskinit;
> > +				/* Per-GP initialization for qsmask. */
> > +	unsigned long grpmask;	/* Mask to apply to parent qsmask. */
> > +	int	grplo;		/* lowest-numbered CPU or group here. */
> > +	int	grphi;		/* highest-numbered CPU or group here. */
> > +	u8	grpnum;		/* CPU/group number for next level up. */
> > +	u8	level;		/* root is at level 0. */
> > +	struct rcu_node *parent;
> > +} ____cacheline_internodealigned_in_smp;
> 
> So this is a 4096-byte structure on some setups.

You lost me on this one.  On a 64-bit system, I have 8 bytes each for
lock, qsmask, qsmaskinit, grpmask, and parent, four bytes each for grplo
and grphi, and another byte each for grpnum and level, for a total of
50 bytes for each struct rcu_node, which comes to a single cache line
for most large system.  Given the default CONFIG_RCU_FANOUT=64 and
NR_CPUS=4096, we have a two-level hierarchy with one root rcu_node
structure and 64 leaf rcu_node structures.  This gives a total of
65 cache lines.

> How many of them do we expect to be concurrently instantiated?

Two sets, one for rcu and one for rcu_bh, for a grand total of 130
cache lines.

Now the rcu_data structure is another story, given that it is a
DEFINE_PER_CPU() variable, though it has several hundred other per-CPU
friends in the Linux kernel.

> > ...
> >
> > +#define __rcu_read_lock() \
> > +	do { \
> > +		preempt_disable(); \
> > +		__acquire(RCU); \
> > +		rcu_read_acquire(); \
> > +	} while (0)
> > +#define __rcu_read_unlock() \
> > +	do { \
> > +		rcu_read_release(); \
> > +		__release(RCU); \
> > +		preempt_enable(); \
> > +	} while (0)
> > +#define __rcu_read_lock_bh() \
> > +	do { \
> > +		local_bh_disable(); \
> > +		__acquire(RCU_BH); \
> > +		rcu_read_acquire(); \
> > +	} while (0)
> > +#define __rcu_read_unlock_bh() \
> > +	do { \
> > +		rcu_read_release(); \
> > +		__release(RCU_BH); \
> > +		local_bh_enable(); \
> > +	} while (0)
> 
> did they have to be implemented in macros?  (it's generally best to use
> C where poss)

Nope, just copied this from Classic RCU.  Fixed.

> > +#define __synchronize_sched() synchronize_rcu()
> > +
> > +#define call_rcu_sched(head, func) call_rcu(head, func)
> > +
> > +extern void __rcu_init(void);
> > +#define rcu_init_sched()	do { } while (0)
> 
> static inline void rcu_init_sched(void)
> {
> }
> 
> , IMO

Good point, fixed.

> > ...
> >
> > +/*
> > + * Enter nohz mode, in other words, -leave- the mode in which RCU
> > + * read-side critical sections can occur.  (Though RCU read-side
> > + * critical sections can occur in irq handlers in nohz mode, a possibility
> > + * handled by rcu_irq_enter() and rcu_irq_exit()).
> > + *
> > + * @@@ note quiescent state???
> > + */
> > +static inline void rcu_enter_nohz(void)
> > +{
> > +	static DEFINE_RATELIMIT_STATE(rs, 10 * HZ, 1);
> > +
> > +	smp_mb(); /* CPUs seeing ++ must see prior RCU read-side crit sects */
> > +	__get_cpu_var(rcu_data).dynticks++;
> > +	WARN_ON_RATELIMIT(__get_cpu_var(rcu_data).dynticks & 0x1, &rs);
> > +	__get_cpu_var(rcu_bh_data).dynticks++;
> > +	WARN_ON_RATELIMIT(__get_cpu_var(rcu_bh_data).dynticks & 0x1, &rs);
> > +}
> > +
> > +/*
> > + * Exit nohz mode.
> > + */
> > +static inline void rcu_exit_nohz(void)
> > +{
> > +	static DEFINE_RATELIMIT_STATE(rs, 10 * HZ, 1);
> > +
> > +	__get_cpu_var(rcu_data).dynticks++;
> > +	WARN_ON_RATELIMIT(!(__get_cpu_var(rcu_data).dynticks & 0x1), &rs);
> > +	__get_cpu_var(rcu_bh_data).dynticks++;
> > +	WARN_ON_RATELIMIT(!(__get_cpu_var(rcu_bh_data).dynticks & 0x1), &rs);
> > +	smp_mb(); /* CPUs seeing ++ must see later RCU read-side crit sects */
> > +}
> 
> These are massive.  But it seems they'll only ever be used once, in
> tick-sched.c so whatever.

Indeed.  They belong in rcutree.c rather than in rcutree.h.  Moved.

> > ...
> >
> > +
> > +config RCU_FANOUT
> > +	int "Tree-based Hierarchical RCU fanout value"
> 
> s/H/h/ ?

Done, on both this and TREE_RCU.

> > ...
> >
> > +#include <linux/types.h>
> > +#include <linux/kernel.h>
> > +#include <linux/init.h>
> > +#include <linux/spinlock.h>
> > +#include <linux/smp.h>
> > +#include <linux/rcupdate.h>
> > +#include <linux/interrupt.h>
> > +#include <linux/sched.h>
> > +#include <asm/atomic.h>
> 
> It still surprises me that we don't have include/linux/atomic.h.

;-)

> > ...
> >
> > +
> > +struct rcu_state rcu_state = RCU_STATE_INITIALIZER(rcu_state);
> > +DEFINE_PER_CPU(struct rcu_data, rcu_data) = { 0L };
> > +
> > +struct rcu_state rcu_bh_state = RCU_STATE_INITIALIZER(rcu_bh_state);
> > +DEFINE_PER_CPU(struct rcu_data, rcu_bh_data) = { 0L };
> 
> I believe we don't need the explicit initialsiation any more.

Hmmm...  Compiles without it OK.  Will let you know how the testing
goes.  ;-)

> > ...
> >
> > +/**
> > + * rcu_irq_exit - Called from exiting Hard irq context.
> 
> "called when"?

Fair enough, fixed.

> > ...
> >
> > +static void dyntick_record_completed(struct rcu_state *rsp, int comp) { }
> 
> I don't personally think such fugliness gains us enough.

Multi-line-ified.

> static void dyntick_record_completed(struct rcu_state *rsp, int comp)
> {
> }
> 
> looks nicer, is consistent and doesn't break vi's ]] command.
> 
> >
> > ...
> >
> > +static void check_cpu_stall(struct rcu_state *rsp, struct rcu_data *rdp)
> > +{
> > +	long delta;
> > +	struct rcu_node *rnp;
> > +
> > +	delta = get_seconds() - rsp->seconds_stall;
> > +	rnp = rdp->mynode;
> > +	if ((rnp->qsmask & rdp->grpmask) && delta >= 0L) {
> > +
> > +		/* We haven't checked in, so go dump stack. */
> > +		print_cpu_stall(rsp);
> > +
> > +	} else if (rsp->gpnum != rsp->completed && delta >= 2L) {
> 
> I dislike the L's here.  They don't do anything and they have an
> encapsulation-violation feeling about them.  Do we really want code
> sprinkled all over the palce whcih "knows" spefically which type was
> used to implement these fields?  Or do we want to stick a plain old "2"
> in there and have it Just Work.

Removed the "L"s.

> > +
> > +		/* They had two seconds to dump stack, so complain. */
> > +		print_other_cpu_stall(rsp);
> > +	}
> > +}
> > +
> > +#else /* #ifdef CONFIG_RCU_CPU_STALL */
> > +static void record_gp_stall_check_time(struct rcu_state *rsp) { }
> > +static void check_cpu_stall(struct rcu_state *rsp, struct rcu_data *rdp) { }
> 
> ]]
> ]]

Multi-line-ified.

> >
> > ...
> >
> > +/*
> > + * Start a new RCU grace period if warranted, re-initializing the hierarchy
> > + * in preparation for detecting the next grace period.  The caller must hold
> > + * the root node's ->lock, which is released before return.  Hard irqs must
> > + * be disabled.
> > + */
> > +static void
> > +rcu_start_gp(struct rcu_state *rsp, unsigned long iflg)
> > +	__releases(rsp->rda[smp_processor_id()]->lock)
> 
> hm, does that work?

Yes, by dint of the argument being pretty much ignored at the moment.
And it should work OK if they key off of the types.

> akpm:/usr/src/25> grep -r __releases Documentation 
> akpm:/usr/src/25> 
> 
> lolwesuck.

;-)

> > ...
> >
> > +/*
> > + * Remove the specified CPU from the RCU hierarchy and move any pending
> > + * callbacks that it might have to the current CPU.  This code assumes
> > + * that at least one CPU in the system will remain running at all times.
> > + * Any attempt to offline -all- CPUs is likely to strand RCU callbacks.
> > + */
> > +static void rcu_offline_cpu(int cpu)
> > +{
> > +	__rcu_offline_cpu(cpu, &rcu_state);
> > +	__rcu_offline_cpu(cpu, &rcu_bh_state);
> > +}
> > +
> > +#else /* #ifdef CONFIG_HOTPLUG_CPU */
> > +
> > +static void
> > +rcu_offline_cpu(int cpu)
> 
> unneeded \n there

Fixed.

> > +{
> > +}
> > +
> > +#endif /* #else #ifdef CONFIG_HOTPLUG_CPU */
> > +
> >
> > ...
> >
> 
> Looks great!  I don't understand a line of it!

;-)

Guess I need to get going on that design document...

> It's a pretty big pill to swallow.  Nice performance testing results
> will help it to slide down.

Well, the read side is easy -- exactly the same code sequence as for
Classic RCU.  On the update side, this is more of a bug fix for large
numbers of CPUs, where unadorned Classic RCU is said to suffer terminal
lock contention.  I will see what I can come up with, but at the end of
the day, this will need some testing on machines larger than the 128-CPU
systems that I have access to.

							Thanx, Paul
