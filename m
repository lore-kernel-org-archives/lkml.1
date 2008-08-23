Return-Path: <linux-kernel-owner+w=401wt.eu-S1753526AbYHWBxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526AbYHWBxt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 21:53:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751355AbYHWBxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 21:53:40 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:33500 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbYHWBxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 21:53:39 -0400
Date: Fri, 22 Aug 2008 18:53:36 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josht@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, cl@linux-foundation.org, mingo@elte.hu,
       akpm@linux-foundation.org, manfred@colorfullife.com,
       dipankar@in.ibm.com, schamp@sgi.com, niv@us.ibm.com, dvhltc@us.ibm.com,
       ego@in.ibm.com, laijs@cn.fujitsu.com, rostedt@goodmis.org
Subject: Re: [PATCH, RFC, tip/core/rcu] scalable classic RCU implementation
Message-ID: <20080823015336.GP6744@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080821234318.GA1754@linux.vnet.ibm.com> <1219447772.5197.98.camel@josh-work.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219447772.5197.98.camel@josh-work.beaverton.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2008 at 04:29:32PM -0700, Josh Triplett wrote:
> On Thu, 2008-08-21 at 16:43 -0700, Paul E. McKenney wrote:
> > Hello!
> > 
> > Experimental, not for inclusion.
> > 
> > Attached is a patch to Classic RCU that applies a hierarchy, greatly
> > reducing the contention on the top-level lock for large machines.
> > This passes mild rcutorture testing on x86 and ppc64, but is most
> > definitely not ready for inclusion.  It is OK for experimental work
> > assuming sufficiently brave experimenters.  See also Manfred Spraul's
> > patch at http://lkml.org/lkml/2008/8/21/336 (or his earlier work from
> > 2004 at http://marc.info/?l=linux-kernel&m=108546384711797&w=2).
> > We will converge onto a common patch in the fullness of time, but
> > are currently exploring different regions of the design space.
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
> > o	The interface to dynticks is clumsy at best.  Improvements
> > 	on the way.
> > 
> > o	CPU onlining and offlining is probably broken.  Will be tested.
> > 
> > o	The check-CPU-stalls code is busted.  Will be fixed.
> > 
> > o	There are probably hangs, rcutorture failures, &c.
> > 
> > o	There is not yet a human-readable design document.  Will be fixed.
> > 
> > o	The largest machine I can get my hands on at the moment only
> > 	has 8 CPUs, which really doesn't stress this algorithm much.
> > 
> > If you want to use this against a Linus kernel, the following will work:
> > 
> > Start with 2.6.27-rc3.
> > 
> > Apply http://www.rdrop.com/users/paulmck/patches/paulmck-rcu.2008.08.20a.patch
> > which catches you up to a recent linux-2.6-tip tip/core/rcu commit.
> > 
> > Apply http://www.rdrop.com/users/paulmck/patches/2.6.27-rc3-hierRCU-6.patch
> > which gets you the current hierarchical RCU implementation.
> > 
> > Thoughts?
> 
> Looks great.  A few comments below.

Thank you for reviewing this!

> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> > 
> >  include/linux/rcuclassic.h |  154 ++++--
> >  kernel/Kconfig.preempt     |   31 +
> >  kernel/Makefile            |    3 
> >  kernel/rcuclassic.c        | 1095 +++++++++++++++++++++++++++++----------------
> >  kernel/rcuclassic_trace.c  |  219 +++++++++
> >  5 files changed, 1076 insertions(+), 426 deletions(-)
> > 
> > diff --git a/include/linux/rcuclassic.h b/include/linux/rcuclassic.h
> > index 1658995..97e646a 100644
> > --- a/include/linux/rcuclassic.h
> > +++ b/include/linux/rcuclassic.h
> > @@ -18,6 +18,7 @@
> >   * Copyright IBM Corporation, 2001
> 
> ", 2008", here and elsewhere?

Hey, at least I got the first three digits right!  ;-)  Fixed.

> >   * and inputs from Rusty Russell, Andrea Arcangeli and Andi Kleen.
> > @@ -26,8 +27,10 @@
> >   * http://lse.sourceforge.net/locking/rclock_OLS.2001.05.01c.sc.pdf (OLS2001)
> >   *
> >   * For detailed explanation of Read-Copy Update mechanism see -
> > - * 		Documentation/RCU
> > - *
> > + * 	Documentation/RCU
> > + * 	http://lwn.net/Articles/262464/ (What is RCU, Fundamentally?)
> > + * 	http://lwn.net/Articles/263130/ (What is RCU's Usage?)
> > + * 	http://lwn.net/Articles/264090/ (What is RCU's API? + references)
> >   */
> 
> Why put these references here rather than in Documentation/RCU?  It
> seems easier to keep documentation up to date in one place.  If you
> think these represent a good "getting started" set of documents, how
> about a Documentation/RCU/ReadTheseFirst with links to them, or how
> about linking to them from whatisRCU.txt?

OK, now just refers to Documentation/RCU.

> >  #ifndef __LINUX_RCUCLASSIC_H
> > @@ -40,69 +43,136 @@
> >  #include <linux/cpumask.h>
> >  #include <linux/seqlock.h>
> > 
> > +/*
> > + * Define the shape of the rcu_node hierarchy based on NR_CPUS and
> > + * CONFIG_RCU_FANOUT.
> > + */
> > 
> > -/* Global control variables for rcupdate callback mechanism. */
> > -struct rcu_ctrlblk {
> > -	long	cur;		/* Current batch number.                      */
> > -	long	completed;	/* Number of the last completed batch         */
> > -	long	pending;	/* Number of the last pending batch           */
> > -#ifdef CONFIG_DEBUG_RCU_STALL
> > -	unsigned long gp_check;	/* Time grace period should end, in seconds.  */
> > -#endif /* #ifdef CONFIG_DEBUG_RCU_STALL */
> > -
> > -	int	signaled;
> > +#define MAX_RCU_LEVELS 3
> > +#if NR_CPUS <= CONFIG_RCU_FANOUT
> > +#define NUM_RCU_LEVELS 1
> > +#define NUM_RCU_LEVEL_1 1
> > +#define NUM_RCU_LEVEL_2 NR_CPUS
> > +#define NUM_RCU_LEVEL_3 0
> > +#define NUM_RCU_LEVEL_4 0
> > +#define NUM_RCU_NODES NUM_RCU_LEVEL_1
> > +#elif NR_CPUS <= CONFIG_RCU_FANOUT * CONFIG_RCU_FANOUT
> > +#define NUM_RCU_LEVELS 2
> > +#define NUM_RCU_LEVEL_1 1
> > +#define NUM_RCU_LEVEL_2 \
> > +	(((NR_CPUS) + (CONFIG_RCU_FANOUT) - 1) / (CONFIG_RCU_FANOUT))
> > +#define NUM_RCU_LEVEL_3 NR_CPUS
> > +#define NUM_RCU_LEVEL_4 0
> > +#define NUM_RCU_NODES \
> > +	((NUM_RCU_LEVEL_1) + (NUM_RCU_LEVEL_2))
> > +#elif NR_CPUS <= CONFIG_RCU_FANOUT * CONFIG_RCU_FANOUT * CONFIG_RCU_FANOUT
> > +#define NUM_RCU_LEVELS 3
> > +#define RCU_FANOUT_SQ ((CONFIG_RCU_FANOUT) * (CONFIG_RCU_FANOUT))
> > +#define NUM_RCU_LEVEL_1 1
> > +#define NUM_RCU_LEVEL_2 \
> > +	(((NR_CPUS) + (RCU_FANOUT_SQ) - 1) / (RCU_FANOUT_SQ))
> > +#define NUM_RCU_LEVEL_3 \
> > +	((NR_CPUS) + (CONFIG_RCU_FANOUT) - 1) / (CONFIG_RCU_FANOUT)
> > +#define NUM_RCU_LEVEL_4 NR_CPUS
> > +#define NUM_RCU_NODES \
> > +	((NUM_RCU_LEVEL_1) + \
> > +	 (NUM_RCU_LEVEL_2) + \
> > +	 (NUM_RCU_LEVEL_3))
> > +#else
> > +#error "CONFIG_RCU_FANOUT insufficient for NR_CPUS"
> > +#endif
> 
> This should get replaced by the revised version you followed up with.

Yep, fixed.

> > -	spinlock_t	lock	____cacheline_internodealigned_in_smp;
> > -	cpumask_t	cpumask; /* CPUs that need to switch in order    */
> > -				 /* for current batch to proceed.        */
> > +/*
> > + * Definition for node within the RCU grace-period-detection hierarchy.
> > + */
> > +struct rcu_node {
> > +	spinlock_t lock;
> > +	unsigned long	qsmask;	/* CPUs or groups that need to switch in      */
> > +				/*  order for current grace period to proceed.*/
> > +	unsigned long	qsmaskinit;
> > +				/* Per-GP initialization for qsmask.	      */
> > +	int	grplo;		/* lowest-numbered CPU or group here.	      */
> > +	int	grphi;		/* highest-numbered CPU or group here.	      */
> > +	char	grpnum;		/* CPU/group number for next level up.	      */
> > +	char	level;		/* root is at level 0.			      */
> 
> These four fields should use sized types, and preferably unsigned types.

OK for grpnum and level, but grphi and grplo need to be "int" to
match the various CPU-manipulation primitives.

> > +	struct rcu_node *parent;
> >  } ____cacheline_internodealigned_in_smp;
> > 
> > -/* Is batch a before batch b ? */
> > -static inline int rcu_batch_before(long a, long b)
> > -{
> > -	return (a - b) < 0;
> > -}
> > +/*
> > + * RCU global state, including node hierarchy.  This hierarchy is
> > + * represented in "heap" form in a dense array.  The root (first level)
> > + * of the hierarchy is in ->node[0] (referenced by ->level[0]), the second
> > + * level in ->node[1] through ->node[m] (->node[1] referenced by ->level[1]),
> > + * and the third level in ->node[m+1] and following (->node[m+1] referenced
> > + * by ->level[2]).  The number of levels is determined by the number of
> > + * CPUs and by CONFIG_RCU_FANOUT.  Small systems will have a "hierarchy"
> > + * consisting of a single rcu_node.
> > + */
> > +struct rcu_state {
> > +	struct rcu_node node[NUM_RCU_NODES];	/* Hierarchy. */
> > +	struct rcu_node *level[NUM_RCU_LEVELS];	/* Hierarchy levels. */
> > +	int levelcnt[MAX_RCU_LEVELS + 1];	/* # nodes in each level. */
> > +	int levelspread[NUM_RCU_LEVELS];	/* kids/node in each level. */
> 
> These two should use sized types.

Fair enough.  And can be 8 bits, for that matter.

> > +
> > +	/* The following fields are guarded by the root rcu_node's lock. */
> > +
> > +	char	signaled ____cacheline_internodealigned_in_smp;
> > +						/* sent GP-kick IPIs? */
> 
> u8 or bool, depending on semantics.  If just a simple flag, how about
> bool?

This will need to be a non-bool shortly.

OK, so what the heck -are- the official type names???  u8 seems
to be defined in a powerpc-specific file.  OK, it also appears in
include/asm-generic/int-l64.h.  s8, u8, s16, u16, s32, u32, s64, and
u64, then?

> > +	long	gpnum;				/* Current gp number. */
> > +	long	completed;			/* # of last completed gp. */
> > +	spinlock_t onofflock;			/* exclude on/offline and */
> > +						/*  starting new GP. */
> > +};
> > 
> > -/* Is batch a after batch b ? */
> > -static inline int rcu_batch_after(long a, long b)
> > -{
> > -	return (a - b) > 0;
> > -}
> > +#define RCU_DONE_TAIL		0	/* Also RCU_WAIT head. */
> > +#define RCU_WAIT_TAIL		1	/* Also RCU_NEXT_READY head. */
> > +#define RCU_NEXT_READY_TAIL	2	/* Also RCU_NEXT head. */
> > +#define RCU_NEXT_TAIL		3
> > +#define RCU_NEXT_SIZE		4
> > 
> >  /* Per-CPU data for Read-Copy UPdate. */
> >  struct rcu_data {
> > -	/* 1) quiescent state handling : */
> > -	long		quiescbatch;     /* Batch # for grace period */
> > -	int		passed_quiesc;	 /* User-mode/idle loop etc. */
> > -	int		qs_pending;	 /* core waits for quiesc state */
> > +	/* 1) quiescent-state and grace-period handling : */
> > +	long		completed;	/* Track rsp->completed gp number */
> > +					/*  in order to detect GP end. */
> > +	long		gpnum;		/* Highest gp number that this CPU */
> > +					/*  is aware of having started. */
> > +	int		passed_quiesc;	/* User-mode/idle loop etc. */
> > +	int		qs_pending;	/* Core waits for quiesc state. */
> 
> Looks like several whitespace changes occurred here; several of these
> lines didn't actually change except in whitespace.

Whitespace-only changes are kind of lost in the noise with this patch.
Best to apply it and inspect the result.

> The same comment about sized types applies here, but these fields didn't
> actually change in this patch.

Both can be bool.  The completed and gpnum fields can probably be s32,
but deferring that change.

> > +	struct rcu_node *mynode;	/* This CPU's leaf of hierarchy */
> > 
> >  	/* 2) batch handling */
> >  	/*
> > -	 * if nxtlist is not NULL, then:
> > -	 * batch:
> > -	 *	The batch # for the last entry of nxtlist
> > -	 * [*nxttail[1], NULL = *nxttail[2]):
> > -	 *	Entries that batch # <= batch
> > +	 * If nxtlist is not NULL, it is partitioned as follows.
> > +	 * Any of the partitions might be empty, in which case the
> > +	 * pointer to that partition will be equal to the pointer for
> > +	 * the following partition.  When the list is empty, all of
> > +	 * the nxttail elements point to nxtlist, which is NULL.
> > +	 *
> > +	 * [*nxttail[2], NULL = *nxttail[3]):
> > +	 *	Entries that might have arrived after current GP ended
> > +	 * [*nxttail[1], *nxttail[2]):
> > +	 *	Entries known to have arrived before current GP ended
> >  	 * [*nxttail[0], *nxttail[1]):
> > -	 *	Entries that batch # <= batch - 1
> > +	 *	Entries that batch # <= ->completed - 1: waiting for current GP
> >  	 * [nxtlist, *nxttail[0]):
> > -	 *	Entries that batch # <= batch - 2
> > +	 *	Entries that batch # <= ->completed
> >  	 *	The grace period for these entries has completed, and
> >  	 *	the other grace-period-completed entries may be moved
> >  	 *	here temporarily in rcu_process_callbacks().
> >  	 */
> > -	long  	       	batch;
> >  	struct rcu_head *nxtlist;
> > -	struct rcu_head **nxttail[3];
> > -	long            qlen; 	 	 /* # of queued callbacks */
> > -	struct rcu_head *donelist;
> > -	struct rcu_head **donetail;
> > -	long		blimit;		 /* Upper limit on a processed batch */
> > +	struct rcu_head **nxttail[RCU_NEXT_SIZE];
> > +	long            qlen; 	 	/* # of queued callbacks */
> > +	long		blimit;		/* Upper limit on a processed batch */
> 
> Some whitespace changes again here; several of these lines didn't change
> except in whitespace.

And the string of spaces needs to become tabs while I am at it...

> >  	int cpu;
> >  	struct rcu_head barrier;
> >  };
> > 
> > +extern struct rcu_state rcu_state;
> >  DECLARE_PER_CPU(struct rcu_data, rcu_data);
> > +
> > +extern struct rcu_state rcu_bh_state;
> >  DECLARE_PER_CPU(struct rcu_data, rcu_bh_data);
> 
> Why extern and in the header?  I don't see anything else using them.

kernel/rcuclassic_trace.c, right?

> >  /*
> > diff --git a/kernel/Kconfig.preempt b/kernel/Kconfig.preempt
> > index 9fdba03..43062bf 100644
> > --- a/kernel/Kconfig.preempt
> > +++ b/kernel/Kconfig.preempt
> > @@ -68,7 +68,6 @@ config PREEMPT_RCU
> > 
> >  config RCU_TRACE
> >  	bool "Enable tracing for RCU - currently stats in debugfs"
> > -	depends on PREEMPT_RCU
> 
> Might want to document in the commit message that you have tracing
> information through RCU_TRACE, and that it applies to non-preemptible
> RCU as well now.

And in Documentation/RCU, for that matter...

> >  	select DEBUG_FS
> >  	default y
> >  	help
> > @@ -77,3 +76,33 @@ config RCU_TRACE
> > 
> >  	  Say Y here if you want to enable RCU tracing
> >  	  Say N if you are unsure.
> > +
> > +config RCU_FANOUT
> > +	int "Hierarchical RCU fanout value"
> > +	range 2 64 if 64BIT
> > +	range 2 32 if !64BIT
> > +	depends on CLASSIC_RCU
> > +	default 64 if 64BIT
> > +	default 32 if !64BIT
> > +	help
> > +	  This option controls the fanout of hierarchical implementations
> > +	  of RCU, allowing RCU to work efficiently on machines with
> > +	  large numbers of CPUs.  This value must be at least the cube
> > +	  root of NR_CPUS, which allows NR_CPUS up to 32,768 for 32-bit
> > +	  systems and up to 262,144 for 64-bit systems.
> > +
> > +	  Select a specific number if testing RCU itself.
> 
> ...or if attempting to tune for a specific NUMA system.

Indeed.  But I need to see an actual example before I document it.
It would be easy to make things slower by following the NUMA hardware
layout.

> > +	  Take the default if unsure.
> > +
> > +config RCU_FANOUT_EXACT
> > +	bool "Disable hierarchical RCU auto-balancing"
> > +	depends on CLASSIC_RCU
> > +	default n
> > +	help
> > +	  This option forces use of the exact RCU_FANOUT value specified,
> > +	  regardless of imbalances in the hierarchy.  This can be useful
> > +	  on systems with strong NUMA behavior.
> > +
> > +	  Without RCU_FANOUT_EXACT, the code will balance the hierarchy.
> 
> You might want to give a specific example of a NUMA machine, the
> appropriate value to use on that machine, and the result with and
> without RCU_FANOUT_EXACT.

Or change "can" to "might".  ;-)

> > +	  Say n if unsure.
> > diff --git a/kernel/Makefile b/kernel/Makefile
> > index 4e1d7df..d838fbd 100644
> > --- a/kernel/Makefile
> > +++ b/kernel/Makefile
> > @@ -75,6 +75,9 @@ obj-$(CONFIG_SECCOMP) += seccomp.o
> >  obj-$(CONFIG_RCU_TORTURE_TEST) += rcutorture.o
> >  obj-$(CONFIG_CLASSIC_RCU) += rcuclassic.o
> >  obj-$(CONFIG_PREEMPT_RCU) += rcupreempt.o
> > +ifeq ($(CONFIG_CLASSIC_RCU),y)
> > +obj-$(CONFIG_RCU_TRACE) += rcuclassic_trace.o
> > +endif
> >  ifeq ($(CONFIG_PREEMPT_RCU),y)
> >  obj-$(CONFIG_RCU_TRACE) += rcupreempt_trace.o
> >  endif
> 
> It might actually make sense here to do this instead:
> 
> ifeq ($(CONFIG_RCU_TRACE),y)
> obj-$(CONFIG_CLASSIC_RCU) += rcuclassic_trace.o
> obj-$(CONFIG_PREEMPT_RCU) += rcupreempt_trace.o
> endif

Excellent point!  Fixed.

> > diff --git a/kernel/rcuclassic.c b/kernel/rcuclassic.c
> > index 01e761a..5584b22 100644
> > --- a/kernel/rcuclassic.c
> > +++ b/kernel/rcuclassic.c
> > @@ -27,7 +28,10 @@
> >   * http://lse.sourceforge.net/locking/rclock_OLS.2001.05.01c.sc.pdf (OLS2001)
> >   *
> >   * For detailed explanation of Read-Copy Update mechanism see -
> > - * 		Documentation/RCU
> > + * 	Documentation/RCU
> > + * 	http://lwn.net/Articles/262464/ (What is RCU, Fundamentally?)
> > + * 	http://lwn.net/Articles/263130/ (What is RCU's Usage?)
> > + * 	http://lwn.net/Articles/264090/ (What is RCU's API? + references)
> 
> Same comment as before; maintaining these in a single place seems
> easier.

Now just does Documentation/RCU.

> > +struct rcu_state rcu_state = RCU_STATE_INITIALIZER(rcu_state);
> >  DEFINE_PER_CPU(struct rcu_data, rcu_data) = { 0L };
> > +
> > +struct rcu_state rcu_bh_state = RCU_STATE_INITIALIZER(rcu_bh_state);
> >  DEFINE_PER_CPU(struct rcu_data, rcu_bh_data) = { 0L };
> 
> How about making these state structures static, along with removing the
> extern in the header?

No can do, as I need them in kernel/rcuclassic_trace.c.

> > -static int blimit = 10;
> > -static int qhimark = 10000;
> > -static int qlowmark = 100;
> > +static int blimit = 10;		/* Maximum callbacks per softirq. */
> > +static int qhimark = 10000;	/* If this many pending, ignore blimit. */
> > +static int qlowmark = 100;	/* Once only this many pending, use blimit. */
> 
> Indentation mismatch on the comments?

Looks fine in the source -- context diff-ism.

> >  #ifdef CONFIG_SMP
> > -static void force_quiescent_state(struct rcu_data *rdp,
> > -			struct rcu_ctrlblk *rcp)
> > +static void force_quiescent_state(struct rcu_state *rsp)
> >  {
> >  	int cpu;
> > -	cpumask_t cpumask;
> >  	unsigned long flags;
> > 
> >  	set_need_resched();
> > -	spin_lock_irqsave(&rcp->lock, flags);
> > -	if (unlikely(!rcp->signaled)) {
> > -		rcp->signaled = 1;
> > +	if (!spin_trylock_irqsave(&rsp->onofflock, flags))
> > +		return;
> 
> This seems to make force_quiescent_state rather less forceful.

It will try again on the next scheduling-clock interrupt.  The reason
I did this is because ->onofflock is a global lock acquired when
beginning a quiescent state or when onlining/offlining.  Can't let
force_quiescent_state() monopolize things, and would like to exclude
online/offline while doing force_quiescent_state().  Hence make
force_quiescent_state() back off if the lock is held.

There is probably a better way to do this...

> > +/*
> > + * Does the current CPU require a yet-as-unscheduled grace period?
> > + */
> > +static inline int
> > +cpu_needs_another_gp(struct rcu_state *rsp, struct rcu_data *rdp)
> > +{
> > +	return *rdp->nxttail[RCU_DONE_TAIL] &&
> > +	       ACCESS_ONCE(rsp->completed) == ACCESS_ONCE(rsp->gpnum);
> > +}
> 
> ACCESS_ONCE, like memory barriers, benefits from an accompanying
> explanation.

OK.  These are accessed without holding the relevant lock, and I don't
want the compiler to refetch them.  (For example, if inlined into other
code touching these same variables.)  Yes, I am paranoid.

> > -#else
> > +#else /* #ifdef CONFIG_HOTPLUG_CPU */
> > 
> > -static void rcu_offline_cpu(int cpu)
> > +static inline void
> > +rcu_offline_cpu(int cpu)
> >  {
> >  }
> 
> No need to explicitly say "inline"; GCC should do the right thing here.
> Same comment applies a couple of other places in your patch.

OK, I will get rid of these.  You can do the other 26,000 of them.  ;-)

> > @@ -658,14 +806,19 @@ int rcu_needs_cpu(int cpu)
> >  	struct rcu_data *rdp = &per_cpu(rcu_data, cpu);
> >  	struct rcu_data *rdp_bh = &per_cpu(rcu_bh_data, cpu);
> > 
> > -	return !!rdp->nxtlist || !!rdp_bh->nxtlist || rcu_pending(cpu);
> > +	return !!*rdp->nxttail[RCU_DONE_TAIL] ||
> > +	       !!*rdp_bh->nxttail[RCU_DONE_TAIL] ||
> > +	       rcu_pending(cpu);
> 
> !! seems unnecessary here.

Someone once told me why this was necessary, but I forget.  It was in the
original, and I didn't put it there.  Some weirdness about conversion
to 32-bit integer when the lower 32 bits of the pointer was zero or
some such.  So if your pointer value was 0x100000000, for example,
so that conversion to int gives zero.

> > +void call_rcu_bh(struct rcu_head *head,
> > +				void (*func)(struct rcu_head *rcu))
> > +{
> > +	unsigned long flags;
> > +
> > +	head->func = func;
> > +	head->next = NULL;
> > +	local_irq_save(flags);
> > +	__call_rcu(head, &rcu_bh_state, &__get_cpu_var(rcu_bh_data));
> > +	local_irq_restore(flags);
> > +}
> > +EXPORT_SYMBOL_GPL(call_rcu_bh);
> 
> This comment applies to the original code, but:
> You only call __call_rcu twice, in call_rcu and call_rcu_bh.  Both
> times, you set head first, then wrap the call with local_irq_save.  How
> about moving both into __call_rcu, making call_rcu and call_rcu_bh
> one-liners?

I can't pass "rcu_data" to a function (or at least I don't know how to
do so, short of passing __per_cpu_rcu_data and doing the per-CPU stuff
by hand).  I could make __call_rcu() be a macro, but that seemed more
ugly than it seemed worthwhile.

Is there some other approach that would work?

> > --- /dev/null
> > +++ b/kernel/rcuclassic_trace.c
> 
> > +static struct mutex rcuclassic_trace_mutex;
> 
> static DEFINE_MUTEX(rcuclassic_trace_mutex);
> Then you don't need mutex_init later in your init function.

Good point.

> > +static char *rcuclassic_trace_buf;
> > +#define RCUPREEMPT_TRACE_BUF_SIZE 4096
> 
> Did you perhaps want PAGE_SIZE?

I really want some way of gracefully handling arbitrarily long output
to debugfs.  I am sure that some such exists, but haven't found it.
What I do instead is to arbitrarily truncate output to 4096 bytes,
which will be stunningly less than useful on a 4,096-CPU machine.  :-/

Suggestions welcome!

							Thanx, Paul
