Return-Path: <linux-kernel-owner+w=401wt.eu-S1754024AbYHROEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbYHROEx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 10:04:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752630AbYHROEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 10:04:32 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:50229 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530AbYHROE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 10:04:28 -0400
Date: Mon, 18 Aug 2008 07:04:04 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, akpm@linux-foundation.org,
       oleg@tv-sign.ru, dipankar@in.ibm.com, rostedt@goodmis.org,
       dvhltc@us.ibm.com, niv@us.ibm.com
Subject: Re: [PATCH tip/core/rcu] classic RCU locking and memory-barrier
	cleanups
Message-ID: <20080818140404.GD6847@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080805162144.GA8297@linux.vnet.ibm.com> <489936E5.7020509@colorfullife.com> <20080807031806.GA6910@linux.vnet.ibm.com> <48A93D49.2000601@colorfullife.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="2oS5YaxWCcQjTEyO"
Content-Disposition: inline
In-Reply-To: <48A93D49.2000601@colorfullife.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 18, 2008 at 11:13:45AM +0200, Manfred Spraul wrote:
> Paul E. McKenney wrote:
>>
>>> Right now, I try to understand the current code first - and some of it 
>>> doesn't make much sense.
>>>
>>> There are three per-cpu lists:
>>> ->nxt
>>> ->cur
>>> ->done.
>>>
>>> Obviously, there must be a quiescent state between cur and done.
>>> But why does the code require a quiescent state between nxt and cur?
>>> I think that's superflous. The only thing that is required is that all 
>>> cpus have moved their callbacks from nxt to cur. That doesn't need a 
>>> quiescent state, this operation could be done in hard interrupt as well.
>>>     
>>
>> The deal is that we have to put incoming callbacks somewhere while
>> the batch in ->cur waits for an RCU grace period.  That somewhere is
>> ->nxt.  So to be painfully pedantic, the callbacks in ->nxt are not
>> waiting for an RCU grace period.  Instead, they are waiting for the
>> callbacks in ->cur to get out of the way.
>>
>>   
> Ok, thanks.
> If I understand the new code in tip/rcu correctly, you have rewritten that 
> block anyway.
>
> I'll try to implement my proposal - on paper, it looks far simpler than the 
> current code.

Indeed.  The current code has accreted a bunch of fixes that have greatly
complicated the code.

> On the one hand, a state machine that keeps track of a global state:
> - collect the callbacks in a nxt list.
> - wait for quiecent
> - destroy the callbacks in the nxt list.
> (actually, there will be 5 states, 2 additional for "start the next rcu 
> cycle immediately")
>
> On the other hand a cpu bitmap that keeps track of the cpus that have 
> completed the work that must be done after a state change.
> The last cpu advances the global state.

FWIW, attached is what I have coded up thus far along these lines.
Currently testing in user space, hence some of the strange code and
comments flagged by "@@@" and "&&&&".  It automatically shapes the
hierarchy, reverting to no hierarchy for machines with few CPUs, and
using up to two additional levels for machines with many CPUs.  It would
not be hard to add additional levels, but given that the two additional
levels on a 64-bit machine can support 256K CPUs, this should suffice
for almost all cases.

> The state machine could be seq_lock protected, the cpu bitmap could be 
> either hierarchical or flat or for uniprocessor just a nop.

I chose hierarchical for cache locality.  I used simple spinlocks
instead of seq_lock on the grounds that the hierarchy decreases lock
contention by orders of magnitude.  I do still access some values
outside of locks, but this is greatly reduced compared to the current
code base.

> Do you have any statistics about rcu_check_callbacks? On my single-cpu 
> system, around 2/3 of the calls are from "normal" context, i.e. 
> rcu_qsctr_inc() is called.

This depends critically on the workload.  Workloads such as HPC that
spend almost all of their time in user-mode execution would invoke
rcu_qsctr_inc() almost all of the time, as would workloads with
significant idle time.  On the other hand, it is possible to arrange
so that almost all execution is in the kernel and there are almost no
context switches, in which case, rcu_qsctr_inc() would only be called
after a force_quiescent_state().

But most workloads should see rcu_qsctr_inc() called most of the time.

							Thanx, Paul

--2oS5YaxWCcQjTEyO
Content-Type: text/x-chdr; charset=us-ascii
Content-Description: rcuclassic.h
Content-Disposition: attachment; filename="rcuclassic.h"

/*
 * rcuclassic.h: user-level prototype of hierarchical classic RCU.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 *
 * Copyright (c) 2008 Paul E. McKenney, IBM Corporation.
 */

#define RCU_DONE_TAIL		0	/* Also RCU_WAIT head. */
#define RCU_WAIT_TAIL		1	/* Also RCU_NEXT_READY head. */
#define RCU_NEXT_READY_TAIL	2	/* Also RCU_NEXT head. */
#define RCU_NEXT_TAIL		3
#define RCU_NEXT_SIZE		4

/* Per-CPU data for Read-Copy UPdate. */
struct rcu_data {
	/* 1) quiescent-state and grace-period handling : */
	long		completed;	/* Track rsp->completed gp number */
					/*  in order to detect GP end. */
	long		gpnum;		/* Highest gp number that this CPU */
					/*  is aware of having started. */
	int		passed_quiesc;	/* User-mode/idle loop etc. */
	int		qs_pending;	/* core waits for quiesc state */
					/*  rdp->completed!=rsp->completed, */
					/*  but with less cache thrashing. */
	struct rcu_node *mynode;	/* this CPU's leaf of hierarchy */

	/* 2) batch handling */
	/*
	 * If nxtlist is not NULL, it is partitioned as follows.
	 * Any of the partitions might be empty, in which case the
	 * pointer to that partition will be equal to the pointer for
	 * the following partition.  When the list is empty, all of
	 * the nxttail elements point to nxtlist, which is NULL.
	 *
	 * [*nxttail[2], NULL = *nxttail[3]):
	 *	Entries that might have arrived after current GP ended
	 * [*nxttail[1], *nxttail[2]):
	 *	Entries known to have arrived before current GP ended
	 * [*nxttail[0], *nxttail[1]):
	 *	Entries that batch # <= ->completed - 1: waiting for current GP
	 * [nxtlist, *nxttail[0]):
	 *	Entries that batch # <= ->completed
	 *	The grace period for these entries has completed, and
	 *	the other grace-period-completed entries may be moved
	 *	here temporarily in rcu_process_callbacks().
	 */
	struct rcu_head *nxtlist;
	struct rcu_head **nxttail[RCU_NEXT_SIZE];
	long            qlen; 	 	/* # of queued callbacks */
	/* @@@ struct rcu_head *donelist;	*/
	/* @@@ struct rcu_head **donetail;	*/
	long		blimit;		/* Upper limit on a processed batch */
	int cpu;
	/* struct rcu_head barrier; */
};

/* @@@ DECLARE_PER_CPU(struct rcu_data, rcu_data); */
/* @@@ DECLARE_PER_CPU(struct rcu_data, rcu_bh_data); */
DEFINE_PER_CPU(struct rcu_data, rcu_data);
DEFINE_PER_CPU(struct rcu_data, rcu_bh_data);

/*
 * Increment the quiescent state "counter".
 * This used to really be a counter, but has atrophied.  The reason is
 * that we do not need to know how many quiescent states passed, just
 * if there was at least one since the start of the grace period.
 * The counter has therefore become a simple flag.
 */
static inline void rcu_qsctr_inc(int cpu)
{
	struct rcu_data *rdp = &per_cpu(rcu_data, cpu);
	rdp->passed_quiesc = 1;
}
static inline void rcu_bh_qsctr_inc(int cpu)
{
	struct rcu_data *rdp = &per_cpu(rcu_bh_data, cpu);
	rdp->passed_quiesc = 1;
}

--2oS5YaxWCcQjTEyO
Content-Type: text/x-csrc; charset=us-ascii
Content-Description: rcuclassic.c
Content-Disposition: attachment; filename="rcuclassic.c"

/*
 * rcuclassic.c: user-level prototype of hierarchical classic RCU.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 *
 * Copyright (c) 2008 Paul E. McKenney, IBM Corporation.
 */


#define CONFIG_RCU_FANOUT 3
#define NR_CPUS 5
/* #define CONFIG_RCU_FANOUT_EXACT */

#include <stdio.h>
#include "api.h"
#include "rcuclassic.h"

/* Define shape of hierarchy based on NR_CPUS and CONFIG_RCU_FANOUT. */

#define MAX_RCU_LEVELS 3
#if NR_CPUS <= CONFIG_RCU_FANOUT
#define NUM_RCU_LEVELS 1
#define NUM_RCU_LEVEL_1 1
#define NUM_RCU_LEVEL_2 NR_CPUS
#define NUM_RCU_LEVEL_3 0
#define NUM_RCU_LEVEL_4 0
#define NUM_RCU_NODES NUM_RCU_LEVEL_1
#elif NR_CPUS <= CONFIG_RCU_FANOUT * CONFIG_RCU_FANOUT
#define NUM_RCU_LEVELS 2
#define NUM_RCU_LEVEL_1 1
#define NUM_RCU_LEVEL_2 \
	(((NR_CPUS) + (CONFIG_RCU_FANOUT) - 1) / (CONFIG_RCU_FANOUT))
#define NUM_RCU_LEVEL_3 NR_CPUS
#define NUM_RCU_LEVEL_4 0
#define NUM_RCU_NODES \
	((NUM_RCU_LEVEL_1) + (NUM_RCU_LEVEL_2))
#elif NR_CPUS <= CONFIG_RCU_FANOUT * CONFIG_RCU_FANOUT * CONFIG_RCU_FANOUT
#define NUM_RCU_LEVELS 3
#define RCU_FANOUT_SQ ((CONFIG_RCU_FANOUT) * (CONFIG_RCU_FANOUT))
#define NUM_RCU_LEVEL_1 1
#define NUM_RCU_LEVEL_2 \
	(((NR_CPUS) + (RCU_FANOUT_SQ) - 1) / (RCU_FANOUT_SQ))
#define NUM_RCU_LEVEL_3 \
	((NR_CPUS) + (CONFIG_RCU_FANOUT) - 1) / (CONFIG_RCU_FANOUT)
#define NUM_RCU_LEVEL_4 NR_CPUS
#define NUM_RCU_NODES \
	((NUM_RCU_LEVEL_1) + \
	 (NUM_RCU_LEVEL_2) + \
	 (NUM_RCU_LEVEL_3))
#else
#error "CONFIG_RCU_FANOUT insufficient for NR_CPUS"
#endif

/* Data structure definitions. */

/*
 * Definition for node within the RCU grace-period-detection hierarchy.
 */
struct rcu_node {
	spinlock_t lock;
	long	qsmask;		/* CPUs or groups that need to switch in      */
				/*  order for current grace period to proceed.*/
	long	qsmaskinit;	/* Per-GP initialization for qsmask.	      */
	int	grplo;		/* lowest-numbered CPU or group here.	      */
	int	grphi;		/* highest-numbered CPU or group here.	      */
	char	grpnum;		/* CPU/group number for next level up.	      */
	char	level;		/* root is at level 0.			      */
	struct rcu_node *parent;
} ____cacheline_internodealigned_in_smp;

/*
 * RCU global state, including node hierarchy.  This hierarchy is
 * represented in "heap" form in a dense array.  The root (first level)
 * of the hierarchy is in ->node[0] (referenced by ->level[0]), the second
 * level in ->node[1] through ->node[m] (->node[1] referenced by ->level[1]),
 * and the third level in ->node[m+1] and following (->node[m+1] referenced
 * by ->level[2]).  The number of levels is determined by the number of
 * CPUs and by CONFIG_RCU_FANOUT.  Small systems will have a "hierarchy"
 * consisting of a single rcu_node.
 */
struct rcu_state {
	struct rcu_node node[NUM_RCU_NODES];	/* Hierarchy. */
	struct rcu_node *level[NUM_RCU_LEVELS];	/* Hierarchy levels. */
	int levelcnt[MAX_RCU_LEVELS + 1];	/* # nodes in each level. */
	int levelspread[NUM_RCU_LEVELS];	/* kids/node in each level. */

	/* The following fields are guarded by the root rcu_node's lock. */

	char	signaled ____cacheline_internodealigned_in_smp;
						/* sent GP-kick IPIs? */
	int	gpnum;				/* Current gp number. */
	int	completed;			/* # of last completed gp. */
};

#define RCU_STATE_INITIALIZER(name) { \
	.node = { { \
		.lock = __SPIN_LOCK_UNLOCKED(&name.node[0].lock), \
		.qsmask = 0, \
	} }, \
	.level = { &name.node[0] }, \
	.levelcnt = { \
		NUM_RCU_LEVEL_1,  /* root of hierarchy. */ \
		NUM_RCU_LEVEL_2, \
		NUM_RCU_LEVEL_3, \
		NUM_RCU_LEVEL_4, /* == MAX_RCU_LEVELS */ \
	}, \
	.gpnum = -300, \
	.completed = -300, \
}

struct rcu_state rcu_state = RCU_STATE_INITIALIZER(rcu_state);
/* @@@ DEFINE_PER_CPU(struct rcu_data, rcu_data); */

struct rcu_state rcu_bh_state = RCU_STATE_INITIALIZER(rcu_bh_state);
/* @@@ DEFINE_PER_CPU(struct rcu_data, rcu_bh_data); */

static int blimit = 10;
static int qhimark = 10000;
static int qlowmark = 100;

/*
 * Does the current CPU require a yet-as-unscheduled grace period?
 */
static inline int
cpu_needs_another_gp(struct rcu_state *rsp, struct rcu_data *rdp)
{
	return *rdp->nxttail[RCU_DONE_TAIL] &&
	       ACCESS_ONCE(rsp->completed) == ACCESS_ONCE(rsp->gpnum);
}

/*
 * Return the root node of the specified rcu_state structure.
 */
static inline struct rcu_node *rcu_get_root(struct rcu_state *rsp)
{
	return &rsp->node[0];
}

/*
 * Compute the per-level fanout, either using the exact fanout specified
 * or balancing the tree, depending on CONFIG_RCU_FANOUT_EXACT.
 */
#ifdef CONFIG_RCU_FANOUT_EXACT
void rcu_init_levelspread(struct rcu_state *rsp)
{
	int i;

	for (i = NUM_RCU_LEVELS - 1; i >= 0; i--) {
		levelspread[i] = CONFIG_RCU_FANOUT;
	}
	
}
#else /* #ifdef CONFIG_RCU_FANOUT_EXACT */
void rcu_init_levelspread(struct rcu_state *rsp)
{
	int ccur;
	int cprv;
	int i;

	cprv = NR_CPUS;
	for (i = NUM_RCU_LEVELS - 1; i >= 0; i--) {
		ccur = rsp->levelcnt[i];
		rsp->levelspread[i] = (cprv + ccur - 1) / ccur;
		cprv = ccur;
	}
	
}
#endif /* #else #ifdef CONFIG_RCU_FANOUT_EXACT */

/*
 * When a given CPU first becomes aware of a grace period, it knows
 * that all of its pre-existing callbacks will be covered by the next
 * grace period.
 *
 * Similarly, if a given CPU has not yet let RCU know that it passed
 * through a quiescent state for the current grace period, then that
 * CPU knows that all of its callbacks may safely be invoked at the
 * end of the next grace period.
 */
static inline void
rcu_next_callbacks_are_ready(struct rcu_data *rdp)
{
	rdp->nxttail[RCU_NEXT_READY_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
}

/*
 * Update local state to record the newly noticed grace period.
 */
static void note_new_gpnum(struct rcu_state *rsp, struct rcu_data *rdp)
{
	rdp->qs_pending = 1;
	rdp->passed_quiesc = 0;
	rdp->gpnum = rsp->gpnum;
}

/*
 * Did a new RCU grace period start since we last checked?  Update
 * local state appropriately if so.
 */
static int
check_for_new_grace_period(struct rcu_state *rsp, struct rcu_data *rdp)
{
	unsigned long flags;

	local_irq_save(flags);
	if (rdp->gpnum != rsp->gpnum) {
		note_new_gpnum(rsp, rdp);
		local_irq_restore(flags);
		return 1;
	}
	local_irq_restore(flags);
	return 0;
}

/*
 * Start a new RCU grace period if warranted, re-initializing the hierarchy
 * in preparation for detecting the next grace period.  The caller must hold
 * the root node's ->lock, which is released before return.  Hard irqs must
 * be disabled.
 */
static void rcu_start_gp(struct rcu_state *rsp, struct rcu_data *rdp)
{
	struct rcu_node *rnp = rcu_get_root(rsp);
	struct rcu_node *rnp_cur;
	struct rcu_node *rnp_end;
	struct rcu_node *rnp_stack[NUM_RCU_LEVELS];

	if (!cpu_needs_another_gp(rsp, rdp)) {

		/*
		 * Either there is no need to detect any more grace periods
		 * at the moment, or we are already in the process of
		 * detecting one.  Either way, we should not start a new
		 * RCU grace period, so drop the lock and exit.
		 */

		spin_unlock(&rnp->lock);
		return;
	}

	/* Advance to a new grace period. */

	rsp->gpnum++;
	note_new_gpnum(rsp, rdp);

	/*
	 * Because we are first, we know that all our callbacks will
	 * be covered by this upcoming grace period, even the ones
	 * that were registered arbitrarily recently.
	 */

	rcu_next_callbacks_are_ready(rdp);
	rdp->nxttail[RCU_WAIT_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];

	/* Special-case the common single-level case. */

	if (NUM_RCU_NODES == 1) {
		rnp->qsmask = rnp->qsmaskinit;
		spin_unlock(&rnp->lock);
		return;
	}

	spin_unlock(&rnp->lock);
	
	/*
	 * Set all the quiescent-state-needed bits in all the non-leaf
	 * RCU nodes.  This operation relies on the layout of the
	 * hierarchy within the rsp->node[] array.  Note that other
	 * CPUs will access only the leaves of the hierarchy, which
	 * still indicate that no grace period is in progress.
	 *
	 * We therefore do not need to hold any locks.  Any required
	 * memory barriers will be supplied by the locks guarding the
	 * leaf rcu_nodes in the hierarchy.
	 */

	rnp_end = rsp->level[NUM_RCU_LEVELS - 1];
	for (rnp_cur = &rsp->node[0]; rnp_cur < rnp_end; rnp_cur++)
		rnp_cur->qsmask = rnp_cur->qsmaskinit;

	/*
	 * Now set up the leaf nodes.  Here we must be careful.  First,
	 * we need to hold the lock in order to exclude other CPUs, which
	 * might be contending for the leaf nodes' locks.  Second, as
	 * soon as we initialize a given leaf node, its CPUs might run
	 * up the rest of the hierarchy.  Third, CPUs might be coming
	 * online and going offline during this time.  We must therefore
	 * acquire locks for each node that we touch during this stage.
	 *
	 * Note that the grace period cannot complete until we finish
	 * the initialization process, as there will be at least one
	 * qsmask bit set in the root node until that time, namely the
	 * one corresponding to this CPU.
	 */

	rnp_end = &rsp->node[NUM_RCU_NODES];
	rnp_cur = rsp->level[NUM_RCU_LEVELS - 1];
	for (; rnp_cur < rnp_end; rnp_cur++) {
		spin_lock(&rnp_cur->lock);
		rnp_cur->qsmask = rnp_cur->qsmaskinit;
		spin_unlock(&rnp_cur->lock);
	}
}

/*
 * Advance this CPU's callbacks after the end of an RCU grace period.
 */
static void
rcu_process_gp_end(struct rcu_state *rsp, struct rcu_data *rdp)
{
	long completed_snap;
	unsigned long flags;

	local_irq_save(flags);
	completed_snap = ACCESS_ONCE(rsp->completed);

	/* Did another grace period end? */
	if (rdp->completed != completed_snap) {

		/* Advance callbacks.  No harm if list empty. */
		rdp->nxttail[RCU_DONE_TAIL] = rdp->nxttail[RCU_WAIT_TAIL];
		rdp->nxttail[RCU_WAIT_TAIL] = rdp->nxttail[RCU_NEXT_READY_TAIL];
		rdp->nxttail[RCU_NEXT_READY_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];

		/* Remember that we saw this grace-period completion. */
		rdp->completed = completed_snap;
	}
	local_irq_restore(flags);
}

/*
 * Record a quiescent state for the specified CPU.  Note that a CPU
 * going offline counts as a quiescent state.
 */
static void cpu_quiet(int cpu, struct rcu_state *rsp, struct rcu_data *rdp)
{
	long mask;
	struct rcu_node *rnp;

	rnp = rdp->mynode;
	spin_lock(&rnp->lock);
	mask = 1L << (cpu - rnp->grplo);
	for (;;) {
		if (!(rnp->qsmask & mask)) {

			/* Our bit has already been cleared, so done. */

			spin_unlock(&rnp->lock);
			return;
		}
		rnp->qsmask &= ~mask;
		if (rnp->qsmask != 0) {

			/* Other bits still set at this level, so done. */

			spin_unlock(&rnp->lock);
			return;
		}
		mask = 1L << rnp->grpnum;
		if (rnp->parent == NULL) {

			/* No more levels. */

			break;
		}
		spin_unlock(&rnp->lock);
		rnp = rnp->parent;
		spin_lock(&rnp->lock);
	}

	/*
	 * Get here if we are the last CPU to pass through a quiescent
	 * state for this grace period.  Clean up and let rcu_start_gp()
	 * start up the next grace period if one is needed.  Note that
	 * we still hold rnp->lock, as required by rcu_start_gp().
	 */
	rsp->completed = rsp->gpnum;
/*&&&&*/printf("cpu_quiet: end of grace period detected by %d.\n", rdp->cpu);
	rcu_process_gp_end(rsp, rdp);
	rcu_start_gp(rsp, rdp);
}

/*
 * Check to see if there is a new grace period of which this CPU
 * is not yet aware, and if so, set up local rcu_data state for it.
 * Otherwise, see if this CPU has just passed through its first
 * quiescent state for this grace period, and record that fact if so.
 */
static void
rcu_check_quiescent_state(struct rcu_state *rsp, struct rcu_data *rdp)
{
	/* If there is now a new grace period, record and return. */
	if (check_for_new_grace_period(rsp, rdp))
		return;

	/* Did this CPU already do its part for the current grace period? */
	if (!rdp->qs_pending)
		return;

	/*
	 * Was there a quiescent state since the beginning of the grace
	 * period? If no, then exit and wait for the next call.
	 */
	if (!rdp->passed_quiesc)
		return;

	/*
	 * Say we did our quiescent state, and set up to process all
	 * currently pending callbacks at the end of the next grace
	 * period.
	 */
	rdp->qs_pending = 0;
	rcu_next_callbacks_are_ready(rdp);
	cpu_quiet(rdp->cpu, rsp, rdp);

	/*
	 * rdp->quiescbatch/rcp->cur and the cpu bitmap can come out of sync
	 * during cpu startup. Ignore the quiescent state.  @@@ fixed???
	 */
}

#ifdef CONFIG_HOTPLUG_CPU


/*
 * Remove the outgoing CPU from the bitmasks in the rcu_node hierarchy
 * and move all callbacks from the outgoing CPU to the current one.
 */
static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp,
			      struct rcu_data *rdp, struct rcu_data *rdp_me)
{
	int i;
	long mask;
	struct rcu_node *rnp;

	/* Remove the outgoing CPU from the masks in the rcu_node hierarchy. */
	rnp = rdp->mynode;
	spin_lock(&rnp->lock);
	mask = 1L << (cpu - rnp->grplo);
	for (;;) {
		rnp->qsmaskinit &= ~mask;
		if (rnp->qsmaskinit != 0) {
			spin_unlock(&rnp->lock);
			break;
		}
		mask = 1L << rnp->grpnum;
		spin_unlock(&rnp->lock);
		rnp = rnp->parent;
		if (rnp == NULL)
			break;
		spin_lock(&rnp->lock);
	}

	/* Being offline is a quiescent state, so go record it. */
	cpu_quiet(cpu, rsp, rdp);

	/*
	 * Move callbacks from the outgoing CPU to the running CPU.
	 * Note that the outgoing CPU is now quiscent, so it is now
	 * (uncharacteristically) safe to access it rcu_data structure.
	 * Note also that we must carefully retain the order of the
	 * outgoing CPU's callbacks in order for rcu_barrier() to work
	 * correctly.  Finally, note that we start all the callbacks
	 * afresh, even those that have passed through a grace period
	 * and are therefore ready to invoke.  The theory is that hotplug
	 * events are rare, and that if they are frequent enough to
	 * indefinitely delay callbacks, you have far worse things to
	 * be worrying about.
	 *
	 * We disable irqs to prevent races with call_rcu() invoked
	 * from interrupt handlers.
	 */
	if (rdp->nxtlist != NULL) {
		local_irq_disable();
		*rdp_me->nxttail[RCU_NEXT_TAIL] = rdp->nxtlist;
		rdp_me->nxttail[RCU_NEXT_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
		rdp->nxtlist = NULL;
		for (i = 0; i < RCU_NEXT_SIZE; i++)
			rdp->nxttail[i] = &rdp->nxtlist;
		local_irq_enable();
	}
}

/*
 * Remove the specified CPU from the RCU hierarchy and move any pending
 * callbacks that it might have to the current CPU.  This code assumes
 * that at least one CPU in the system will remain running at all times.
 * Any attempt to offline -all- CPUs is likely to strand RCU callbacks.
 */
static void rcu_offline_cpu(int cpu)  /* !HOTPLUG_CPU @@@ */
{
	struct rcu_data *rdp = &per_cpu(rcu_data, cpu);
	struct rcu_data *rdp_me = &__get_cpu_var(rcu_data);
	struct rcu_data *bh_rdp = &per_cpu(rcu_bh_data, cpu);
	struct rcu_data *bh_rdp_me = &__get_cpu_var(rcu_bh_data);

	__rcu_offline_cpu(cpu, &rcu_state, rdp, rdp_me);
	__rcu_offline_cpu(cpu, &rcu_bh_state, bh_rdp, bh_rdp_me);
}

#else /* #ifdef CONFIG_HOTPLUG_CPU */

static inline void
__rcu_offline_cpu(int cpu, struct rcu_state *rsp, struct rcu_data *rdp)
{
}

#endif /* #else #ifdef CONFIG_HOTPLUG_CPU */

/*
 * Invoke any RCU callbacks that have made it to the end of their grace
 * period.
 */
static void rcu_do_batch(struct rcu_data *rdp)
{
	struct rcu_head *next, *list, **tail;
	int count;

	/* If no callbacks are ready, just return.*/
	if (&rdp->nxtlist == rdp->nxttail[RCU_DONE_TAIL])
		return;

	/*
	 * Extract the list of ready callbacks, disabling to prevent
	 * races with call_rcu() from interrupt handlers.
	 */
	local_irq_disable();
	list = rdp->nxtlist;
	rdp->nxtlist = *rdp->nxttail[RCU_DONE_TAIL];
	*rdp->nxttail[RCU_DONE_TAIL] = NULL;
	tail = rdp->nxttail[RCU_DONE_TAIL];
	for (count = RCU_NEXT_SIZE - 1; count >= 0; count--)
		if (rdp->nxttail[count] == rdp->nxttail[RCU_DONE_TAIL])
			rdp->nxttail[count] = &rdp->nxtlist;
	local_irq_enable();

	/* Invoke callbacks. */
	count = 0;
	while (list) {
		next = list->next;
		prefetch(next);
		list->func(list);
		list = next;
		if (++count >= rdp->blimit)
			break;
	}

	/* Update count, and requeue any remaining callbacks. */
	local_irq_disable();
	rdp->qlen -= count;
	if (list != NULL) {
		*tail = rdp->nxtlist;
		rdp->nxtlist = list;
		for (count = 0; count < RCU_NEXT_SIZE; count++)
			if (&rdp->nxtlist == rdp->nxttail[count])
				rdp->nxttail[count] = tail;
			else
				break;
	}
	local_irq_enable();

	/* Reinstate batch limit if we have worked down the excess. */
	if (rdp->blimit == INT_MAX && rdp->qlen <= qlowmark)
		rdp->blimit = blimit;

	/* Re-raise the RCU softirq if there are callbacks remaining. */
	if (&rdp->nxtlist == rdp->nxttail[RCU_DONE_TAIL])
		raise_rcu_softirq();
}

/*
 * This does the RCU processing work from softirq context.
 */
static void
__rcu_process_callbacks(struct rcu_state *rsp, struct rcu_data *rdp)
{
	/*
	 * Advance callbacks in response to end of earlier grace
	 * period that some other CPU ended.
	 */
	rcu_process_gp_end(rsp, rdp);

	/* Update RCU state based on any recent quiescent states. */
	rcu_check_quiescent_state(rsp, rdp);

	/* Does this CPU require a not-yet-started grace period? */
	if (cpu_needs_another_gp(rsp, rdp)) {
		spin_lock(&rcu_get_root(rsp)->lock);
		rcu_start_gp(rsp, rdp);  /* releases rsp->lock */
	}

	rcu_do_batch(rdp);
}

static void rcu_process_callbacks(struct softirq_action *unused)
{
	/*
	 * Memory references from any prior RCU read-side critical sections
	 * executed by the interrupted code must be see before any RCU
	 * grace-period manupulations below.
	 */

	smp_mb(); /* See above block comment. */

	__rcu_process_callbacks(&rcu_state, &__get_cpu_var(rcu_data));
	__rcu_process_callbacks(&rcu_bh_state, &__get_cpu_var(rcu_bh_data));

	/*
	 * Memory references from any later RCU read-side critical sections
	 * executed by the interrupted code must be see after any RCU
	 * grace-period manupulations above.
	 */

	smp_mb(); /* See above block comment. */
}

/*
 * Check to see if there is any immediate RCU-related work to be done
 * by the current CPU, for the specified type of RCU, returning 1 if so.
 * The checks are in order of increasing expense: checks that can be
 * carried out against CPU-local state are performed first.
 */
static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp)
{
	/* Check for CPU stalls, if enabled. */
	/* @@@ check_cpu_stall(rsp, rdp); @@@ */

	/* Is the RCU core waiting for a quiescent state from this CPU? */
	if (rdp->qs_pending)
		return 1;

	/* Does this CPU have finished callbacks to invoke? */
	if (rdp->nxttail[RCU_DONE_TAIL] != &rdp->nxtlist)
		return 1;

	/* Are there callbacks waiting for a GP that needs to be started? */
	if (cpu_needs_another_gp(rsp, rdp))
		return 1;

	/* Has another RCU grace period has been detected?  */
	if (ACCESS_ONCE(rsp->completed) != rdp->completed)
		return 1;

	/* nothing to do */
	return 0;
}

/*
 * Check to see if there is any immediate RCU-related work to be done
 * by the current CPU, returning 1 if so.  This function is part of the
 * RCU implementation; it is -not- an exported member of the RCU API.
 */
int rcu_pending(int cpu)
{
	return __rcu_pending(&rcu_state, &per_cpu(rcu_data, cpu)) ||
	       __rcu_pending(&rcu_bh_state, &per_cpu(rcu_bh_data, cpu));
}

/*
 * Check to see if this CPU is in a non-context-switch quiescent state
 * (user mode or idle loop for rcu, non-softirq execution for rcu_bh).
 * Also schedule the RCU softirq handler.
 *
 * This function must be called with hardirqs disabled.  It is normally
 * invoked from the scheduling-clock interrupt.  If rcu_pending returns
 * false, there is no point in invoking rcu_check_callbacks().
 */
void rcu_check_callbacks(int cpu, int user)
{
	if (user ||
	    (idle_cpu(cpu) && !in_softirq() &&
				hardirq_count() <= (1 << HARDIRQ_SHIFT))) {

		/*
		 * Get here if this CPU took its interrupt from user
		 * mode or from the idle loop, and if this is not a
		 * nested interrupt.  In this case, the CPU is in
		 * a quiescent state, so count it.
		 *
		 * Also do a memory barrier.  This is needed to handle
		 * the case where writes from a preempt-disable section
		 * of code get reordered into schedule() by this CPU's
		 * write buffer.  The memory barrier makes sure that
		 * the rcu_qsctr_inc() and rcu_bh_qsctr_inc() are see
		 * by other CPUs to happen after any such write.
		 */

		smp_mb();  /* See above block comment. */
		rcu_qsctr_inc(cpu);
		rcu_bh_qsctr_inc(cpu);

	} else if (!in_softirq()) {

		/*
		 * Get here if this CPU did not take its interrupt from
		 * softirq, in other words, if it is not interrupting
		 * a rcu_bh read-side critical section.  This is an _bh
		 * critical section, so count it.  The memory barrier
		 * is needed for the same reason as is the above one.
		 */

		smp_mb();  /* See above block comment. */
		rcu_bh_qsctr_inc(cpu);
	}
	raise_rcu_softirq();
}

static void
__call_rcu(struct rcu_head *head, struct rcu_state *rsp, struct rcu_data *rdp)
{
	smp_mb(); /* Ensure RCU update seen before callback registry. */

	/*
	 * Opportunistically note grace-period endings and beginnings.
	 * Note that we might see a beginning right after we see an
	 * end, but never vice versa, since this CPU has to pass through
	 * a quiescent state betweentimes.
	 */
	rcu_process_gp_end(rsp, rdp);
	check_for_new_grace_period(rsp, rdp);

	*rdp->nxttail[RCU_NEXT_TAIL] = head;
	rdp->nxttail[RCU_NEXT_TAIL] = &head->next;

	if (unlikely(++rdp->qlen > qhimark)) {
		rdp->blimit = INT_MAX;
		/* @@@ force_quiescent_state(rsp, rdp); */
	}
}

/**
 * call_rcu - Queue an RCU callback for invocation after a grace period.
 * @head: structure to be used for queueing the RCU updates.
 * @func: actual update function to be invoked after the grace period
 *
 * The update function will be invoked some time after a full grace
 * period elapses, in other words after all currently executing RCU
 * read-side critical sections have completed.  RCU read-side critical
 * sections are delimited by rcu_read_lock() and rcu_read_unlock(),
 * and may be nested.
 */
void call_rcu(struct rcu_head *head,
				void (*func)(struct rcu_head *rcu))
{
	unsigned long flags;

	head->func = func;
	head->next = NULL;
	local_irq_save(flags);
	__call_rcu(head, &rcu_state, &__get_cpu_var(rcu_data));
	local_irq_restore(flags);
}
/*@@@ EXPORT_SYMBOL_GPL(call_rcu); */

/**
 * call_rcu_bh - Queue an RCU for invocation after a quicker grace period.
 * @head: structure to be used for queueing the RCU updates.
 * @func: actual update function to be invoked after the grace period
 *
 * The update function will be invoked some time after a full grace
 * period elapses, in other words after all currently executing RCU
 * read-side critical sections have completed. call_rcu_bh() assumes
 * that the read-side critical sections end on completion of a softirq
 * handler. This means that read-side critical sections in process
 * context must not be interrupted by softirqs. This interface is to be
 * used when most of the read-side critical sections are in softirq context.
 * RCU read-side critical sections are delimited by rcu_read_lock() and
 * rcu_read_unlock(), * if in interrupt context or rcu_read_lock_bh()
 * and rcu_read_unlock_bh(), if in process context. These may be nested.
 */
void call_rcu_bh(struct rcu_head *head,
				void (*func)(struct rcu_head *rcu))
{
	unsigned long flags;

	head->func = func;
	head->next = NULL;
	local_irq_save(flags);
	__call_rcu(head, &rcu_bh_state, &__get_cpu_var(rcu_bh_data));
	local_irq_restore(flags);
}
/* @@@ EXPORT_SYMBOL_GPL(call_rcu_bh); */

/*
 * Initialize a CPU's per-CPU RCU data.  We take this "scorched earth"
 * approach so that we don't have to worry about how long the CPU has
 * been gone, or whether it ever was online previously.  We do trust the
 * ->mynode field, as it is constant for a given struct rcu_data and
 * initialized during early boot.
 *
 * Note that only one online or offline event can be happening at a given
 * time.  Note also that we can accept some slop in the rsp->completed
 * access due to the fact that this CPU cannot possibly have any RCU
 * callbacks in flight yet.
 */
static void
rcu_init_percpu_data(int cpu, struct rcu_state *rsp, struct rcu_data *rdp)
{
	long completed_snap;
	int i;
	long mask;
	struct rcu_node *rnp = rdp->mynode;

	spin_lock(&rnp->lock);
	completed_snap = ACCESS_ONCE(rsp->completed);
	memset(rdp, 0, sizeof(*rdp));
	rdp->completed = completed_snap;
	rdp->gpnum = completed_snap;
	rdp->passed_quiesc = 1;
	rdp->qs_pending = 0;
	rdp->mynode = rnp;
	for (i = 0; i < RCU_NEXT_SIZE; i++)
		rdp->nxttail[i] = &rdp->nxtlist;
	rdp->blimit = /* @@@ blimit */ 10;
	rdp->cpu = cpu;

	/* Add CPU to rcu_node bitmasks. */

	mask = 1L << (cpu - rnp->grplo);
	for (;;) {
		rnp->qsmaskinit |= mask;
		mask = 1L << rnp->grpnum;
		spin_unlock(&rnp->lock);
		rnp = rnp->parent;
		if ((rnp == NULL) || !!(rnp->qsmaskinit & mask))
			break;
		spin_lock(&rnp->lock);
	}
}

static void __cpuinit rcu_online_cpu(int cpu)
{
	struct rcu_data *rdp = &per_cpu(rcu_data, cpu);
	struct rcu_data *bh_rdp = &per_cpu(rcu_bh_data, cpu);

	rcu_init_percpu_data(cpu, &rcu_state, rdp);
	rcu_init_percpu_data(cpu, &rcu_bh_state, bh_rdp);
	/* open_softirq(RCU_SOFTIRQ, rcu_process_callbacks, NULL); @@@ */
}

/*
 * Handle CPU online/offline notifcation events.
 */
static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
				unsigned long action, void *hcpu)
{
	long cpu = (long)hcpu;

	switch (action) {
	case CPU_UP_PREPARE:
	case CPU_UP_PREPARE_FROZEN:
		rcu_online_cpu(cpu);
		break;
	case CPU_DEAD:
	case CPU_DEAD_FROZEN:
		rcu_offline_cpu(cpu);
		break;
	default:
		break;
	}
	return NOTIFY_OK;
}

/*
 * Helper function for rcu_init() that initializes one rcu_state structure.
 */
static void __init rcu_init_one(struct rcu_state *rsp)
{
	int i;
	int j;
	struct rcu_node *rnp;

	/* Initialize the level-tracking arrays. */

	for (i = 1; i < NUM_RCU_LEVELS; i++) {
		rsp->level[i] = rsp->level[i - 1] + rsp->levelcnt[i - 1];
	}
	rcu_init_levelspread(rsp);

	/* Initialize the elements themselves, starting from the leaves. */

	for (i = NUM_RCU_LEVELS - 1; i > 0; i--) {
		rnp = rsp->level[i];
		for (j = 0; j < rsp->levelcnt[i]; j++, rnp++) {
			spin_lock_init(&rnp->lock);
			rnp->qsmask = rsp->node[0].qsmask;
			rnp->grplo = j * rsp->levelspread[i];
			rnp->grphi = (j + 1) * rsp->levelspread[i] - 1;
			if (rnp->grphi >= rsp->levelcnt[i + 1])
				rnp->grphi = rsp->levelcnt[i + 1] - 1;
			rnp->qsmaskinit = 0;
			if (i != NUM_RCU_LEVELS - 1)
				rnp->grplo = rnp->grphi = 0;
			rnp->grpnum = j % rsp->levelspread[i - 1];
			rnp->level = i;
			rnp->parent = rsp->level[i - 1] + 
				      j / rsp->levelspread[i - 1];
		}
	}

	/* Initialize the root of the hierarchy. */

	rsp->node[0].qsmaskinit = 0;
	rsp->node[0].grpnum = -1;
	rsp->signaled = 0;
}

/*
 * Helper macro for rcu_init().  To be used nowhere else!
 * Assigns leaf node pointers into each CPU's rcu_data structure.
 */
#define RCU_DATA_PTR_INIT(rsp, rcu_data) \
do { \
	rnp = (rsp)->level[NUM_RCU_LEVELS - 1]; \
	j = 0; \
	for_each_possible_cpu(i) { \
		if (i > rnp[j].grphi) \
			j++; \
		per_cpu(rcu_data, i).mynode = &rnp[j]; \
	} \
} while (0)

static struct notifier_block __cpuinitdata rcu_nb = {
	.notifier_call	= rcu_cpu_notify,
};

static void __init rcu_init(void)
{
	int i;			/* All used by RCU_DATA_PTR_INIT(). */
	int j;
	struct rcu_node *rnp;

	rcu_init_one(&rcu_state);
	RCU_DATA_PTR_INIT(&rcu_state, rcu_data);
	rcu_init_one(&rcu_bh_state);
	RCU_DATA_PTR_INIT(&rcu_bh_state, rcu_bh_data);

	for_each_online_cpu(i)
		rcu_cpu_notify(&rcu_nb, CPU_UP_PREPARE, (void *)(long)i);
#if 0 /* @@@ */
	/* Register notifier for non-boot CPUs */
	register_cpu_notifier(&rcu_nb);
#endif /* @@@ #if 0 */
}

--2oS5YaxWCcQjTEyO--
