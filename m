Return-Path: <linux-kernel-owner+w=401wt.eu-S1752547AbYL3Gb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547AbYL3Gb0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 01:31:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751330AbYL3GbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 01:31:18 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:60178 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266AbYL3GbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 01:31:16 -0500
Date: Mon, 29 Dec 2008 22:31:10 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] RCU: Move some definitions to minimal headers.
Message-ID: <20081230063110.GB6772@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <cover.1230499486.git.eduard.munteanu@linux360.ro> <01504e3763e57759f34045051e86cb35c17b43b5.1230499486.git.eduard.munteanu@linux360.ro> <84144f020812290142o6299c225o37c2c499db9f0985@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020812290142o6299c225o37c2c499db9f0985@mail.gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 29, 2008 at 11:42:43AM +0200, Pekka Enberg wrote:
> On Mon, Dec 29, 2008 at 3:40 AM, Eduard - Gabriel Munteanu
> <eduard.munteanu@linux360.ro> wrote:
> > linux/rcupdate.h used to include SLAB headers, which got in the way of
> > switching kmemtrace to use tracepoints instead of markers. The circular
> > header inclusion pattern that appeared was making it impossible to use
> > tracepoints in SLAB allocator inlines.
> >
> > This moves some header code into separate files. As an added bonus,
> > preprocessing is faster if care is taken to use these minimal headers,
> > since no effort is spent on including SLAB headers.
> >
> > Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
> 
> I'm okay with this but lets cc Paul for an ack/nak.

First let me make sure that I understand the intent.  The idea looks to
me to be to split rcuclassic.h into an rcuclassic_min.h that contains
only those definitions needed by a pure RCU reader, leaving the rest of
the internal-to-RCU stuff in rcuclassic.h.  Correct?

If so, then rcupreempt.h and rcutree.h would need to be similarly split,
correct?  (Not sure rcupreempt.h splits so nicely, will need to look.)

I have not yet thought through what would need to happen in rcupdate.h.
My guess is that very few files that include rcupdate.h need anything
more than what you put in rcuclassic_min.h along with rcu_assign_pointer()
and rcu_dereference() and various function declarations from rcupdate.h.

If this really is the case, then it seems like it would be best for
rcupdate.h to give the minimal RCU-reader definitions and for something
like rcupdate_internal.h to give the works.  Not sure that this really
works nicely for all of the RCU implementations, though...  Will dig
into it some more.

							Thanx, Paul

> > ---
> >  include/linux/rcuclassic.h     |   40 +--------
> >  include/linux/rcuclassic_min.h |   77 +++++++++++++++
> >  include/linux/rcupdate.h       |  160 +-------------------------------
> >  include/linux/rcupdate_min.h   |  205 ++++++++++++++++++++++++++++++++++++++++
> >  include/linux/rcupreempt.h     |   32 +------
> >  include/linux/rcupreempt_min.h |   68 +++++++++++++
> >  6 files changed, 353 insertions(+), 229 deletions(-)
> >  create mode 100644 include/linux/rcuclassic_min.h
> >  create mode 100644 include/linux/rcupdate_min.h
> >  create mode 100644 include/linux/rcupreempt_min.h
> >
> > diff --git a/include/linux/rcuclassic.h b/include/linux/rcuclassic.h
> > index 5f89b62..32f1512 100644
> > --- a/include/linux/rcuclassic.h
> > +++ b/include/linux/rcuclassic.h
> > @@ -39,6 +39,7 @@
> >  #include <linux/percpu.h>
> >  #include <linux/cpumask.h>
> >  #include <linux/seqlock.h>
> > +#include <linux/rcuclassic_min.h>
> >
> >  #ifdef CONFIG_RCU_CPU_STALL_DETECTOR
> >  #define RCU_SECONDS_TILL_STALL_CHECK   ( 3 * HZ) /* for rcp->jiffies_stall */
> > @@ -131,45 +132,6 @@ static inline void rcu_bh_qsctr_inc(int cpu)
> >  extern int rcu_pending(int cpu);
> >  extern int rcu_needs_cpu(int cpu);
> >
> > -#ifdef CONFIG_DEBUG_LOCK_ALLOC
> > -extern struct lockdep_map rcu_lock_map;
> > -# define rcu_read_acquire()    \
> > -                       lock_acquire(&rcu_lock_map, 0, 0, 2, 1, NULL, _THIS_IP_)
> > -# define rcu_read_release()    lock_release(&rcu_lock_map, 1, _THIS_IP_)
> > -#else
> > -# define rcu_read_acquire()    do { } while (0)
> > -# define rcu_read_release()    do { } while (0)
> > -#endif
> > -
> > -#define __rcu_read_lock() \
> > -       do { \
> > -               preempt_disable(); \
> > -               __acquire(RCU); \
> > -               rcu_read_acquire(); \
> > -       } while (0)
> > -#define __rcu_read_unlock() \
> > -       do { \
> > -               rcu_read_release(); \
> > -               __release(RCU); \
> > -               preempt_enable(); \
> > -       } while (0)
> > -#define __rcu_read_lock_bh() \
> > -       do { \
> > -               local_bh_disable(); \
> > -               __acquire(RCU_BH); \
> > -               rcu_read_acquire(); \
> > -       } while (0)
> > -#define __rcu_read_unlock_bh() \
> > -       do { \
> > -               rcu_read_release(); \
> > -               __release(RCU_BH); \
> > -               local_bh_enable(); \
> > -       } while (0)
> > -
> > -#define __synchronize_sched() synchronize_rcu()
> > -
> > -#define call_rcu_sched(head, func) call_rcu(head, func)
> > -
> >  extern void __rcu_init(void);
> >  #define rcu_init_sched()       do { } while (0)
> >  extern void rcu_check_callbacks(int cpu, int user);
> > diff --git a/include/linux/rcuclassic_min.h b/include/linux/rcuclassic_min.h
> > new file mode 100644
> > index 0000000..7ea051b
> > --- /dev/null
> > +++ b/include/linux/rcuclassic_min.h
> > @@ -0,0 +1,77 @@
> > +/*
> > + * Read-Copy Update mechanism for mutual exclusion (classic version)
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation; either version 2 of the License, or
> > + * (at your option) any later version.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, write to the Free Software
> > + * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
> > + *
> > + * Copyright IBM Corporation, 2001
> > + *
> > + * Author: Dipankar Sarma <dipankar@in.ibm.com>
> > + *
> > + * Based on the original work by Paul McKenney <paulmck@us.ibm.com>
> > + * and inputs from Rusty Russell, Andrea Arcangeli and Andi Kleen.
> > + * Papers:
> > + * http://www.rdrop.com/users/paulmck/paper/rclockpdcsproof.pdf
> > + * http://lse.sourceforge.net/locking/rclock_OLS.2001.05.01c.sc.pdf (OLS2001)
> > + *
> > + * For detailed explanation of Read-Copy Update mechanism see -
> > + *             Documentation/RCU
> > + *
> > + */
> > +
> > +#ifndef _LINUX_RCUCLASSIC_MIN_H
> > +#define _LINUX_RCUCLASSIC_MIN_H
> > +
> > +#ifdef CONFIG_DEBUG_LOCK_ALLOC
> > +#include <linux/lockdep.h>
> > +extern struct lockdep_map rcu_lock_map;
> > +# define rcu_read_acquire()    \
> > +                       lock_acquire(&rcu_lock_map, 0, 0, 2, 1, NULL, _THIS_IP_)
> > +# define rcu_read_release()    lock_release(&rcu_lock_map, 1, _THIS_IP_)
> > +#else
> > +# define rcu_read_acquire()    do { } while (0)
> > +# define rcu_read_release()    do { } while (0)
> > +#endif
> > +
> > +#define __rcu_read_lock() \
> > +       do { \
> > +               preempt_disable(); \
> > +               __acquire(RCU); \
> > +               rcu_read_acquire(); \
> > +       } while (0)
> > +#define __rcu_read_unlock() \
> > +       do { \
> > +               rcu_read_release(); \
> > +               __release(RCU); \
> > +               preempt_enable(); \
> > +       } while (0)
> > +#define __rcu_read_lock_bh() \
> > +       do { \
> > +               local_bh_disable(); \
> > +               __acquire(RCU_BH); \
> > +               rcu_read_acquire(); \
> > +       } while (0)
> > +#define __rcu_read_unlock_bh() \
> > +       do { \
> > +               rcu_read_release(); \
> > +               __release(RCU_BH); \
> > +               local_bh_enable(); \
> > +       } while (0)
> > +
> > +#define __synchronize_sched() synchronize_rcu()
> > +
> > +#define call_rcu_sched(head, func) call_rcu(head, func)
> > +
> > +#endif /* _LINUX_RCUCLASSIC_MIN_H */
> > +
> > diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> > index 86f1f5e..d7659e8 100644
> > --- a/include/linux/rcupdate.h
> > +++ b/include/linux/rcupdate.h
> > @@ -41,16 +41,7 @@
> >  #include <linux/seqlock.h>
> >  #include <linux/lockdep.h>
> >  #include <linux/completion.h>
> > -
> > -/**
> > - * struct rcu_head - callback structure for use with RCU
> > - * @next: next update requests in a list
> > - * @func: actual update function to call after the grace period.
> > - */
> > -struct rcu_head {
> > -       struct rcu_head *next;
> > -       void (*func)(struct rcu_head *head);
> > -};
> > +#include <linux/rcupdate_min.h>
> >
> >  #ifdef CONFIG_CLASSIC_RCU
> >  #include <linux/rcuclassic.h>
> > @@ -64,131 +55,6 @@ struct rcu_head {
> >        (ptr)->next = NULL; (ptr)->func = NULL; \
> >  } while (0)
> >
> > -/**
> > - * rcu_read_lock - mark the beginning of an RCU read-side critical section.
> > - *
> > - * When synchronize_rcu() is invoked on one CPU while other CPUs
> > - * are within RCU read-side critical sections, then the
> > - * synchronize_rcu() is guaranteed to block until after all the other
> > - * CPUs exit their critical sections.  Similarly, if call_rcu() is invoked
> > - * on one CPU while other CPUs are within RCU read-side critical
> > - * sections, invocation of the corresponding RCU callback is deferred
> > - * until after the all the other CPUs exit their critical sections.
> > - *
> > - * Note, however, that RCU callbacks are permitted to run concurrently
> > - * with RCU read-side critical sections.  One way that this can happen
> > - * is via the following sequence of events: (1) CPU 0 enters an RCU
> > - * read-side critical section, (2) CPU 1 invokes call_rcu() to register
> > - * an RCU callback, (3) CPU 0 exits the RCU read-side critical section,
> > - * (4) CPU 2 enters a RCU read-side critical section, (5) the RCU
> > - * callback is invoked.  This is legal, because the RCU read-side critical
> > - * section that was running concurrently with the call_rcu() (and which
> > - * therefore might be referencing something that the corresponding RCU
> > - * callback would free up) has completed before the corresponding
> > - * RCU callback is invoked.
> > - *
> > - * RCU read-side critical sections may be nested.  Any deferred actions
> > - * will be deferred until the outermost RCU read-side critical section
> > - * completes.
> > - *
> > - * It is illegal to block while in an RCU read-side critical section.
> > - */
> > -#define rcu_read_lock() __rcu_read_lock()
> > -
> > -/**
> > - * rcu_read_unlock - marks the end of an RCU read-side critical section.
> > - *
> > - * See rcu_read_lock() for more information.
> > - */
> > -
> > -/*
> > - * So where is rcu_write_lock()?  It does not exist, as there is no
> > - * way for writers to lock out RCU readers.  This is a feature, not
> > - * a bug -- this property is what provides RCU's performance benefits.
> > - * Of course, writers must coordinate with each other.  The normal
> > - * spinlock primitives work well for this, but any other technique may be
> > - * used as well.  RCU does not care how the writers keep out of each
> > - * others' way, as long as they do so.
> > - */
> > -#define rcu_read_unlock() __rcu_read_unlock()
> > -
> > -/**
> > - * rcu_read_lock_bh - mark the beginning of a softirq-only RCU critical section
> > - *
> > - * This is equivalent of rcu_read_lock(), but to be used when updates
> > - * are being done using call_rcu_bh(). Since call_rcu_bh() callbacks
> > - * consider completion of a softirq handler to be a quiescent state,
> > - * a process in RCU read-side critical section must be protected by
> > - * disabling softirqs. Read-side critical sections in interrupt context
> > - * can use just rcu_read_lock().
> > - *
> > - */
> > -#define rcu_read_lock_bh() __rcu_read_lock_bh()
> > -
> > -/*
> > - * rcu_read_unlock_bh - marks the end of a softirq-only RCU critical section
> > - *
> > - * See rcu_read_lock_bh() for more information.
> > - */
> > -#define rcu_read_unlock_bh() __rcu_read_unlock_bh()
> > -
> > -/**
> > - * rcu_read_lock_sched - mark the beginning of a RCU-classic critical section
> > - *
> > - * Should be used with either
> > - * - synchronize_sched()
> > - * or
> > - * - call_rcu_sched() and rcu_barrier_sched()
> > - * on the write-side to insure proper synchronization.
> > - */
> > -#define rcu_read_lock_sched() preempt_disable()
> > -
> > -/*
> > - * rcu_read_unlock_sched - marks the end of a RCU-classic critical section
> > - *
> > - * See rcu_read_lock_sched for more information.
> > - */
> > -#define rcu_read_unlock_sched() preempt_enable()
> > -
> > -
> > -
> > -/**
> > - * rcu_dereference - fetch an RCU-protected pointer in an
> > - * RCU read-side critical section.  This pointer may later
> > - * be safely dereferenced.
> > - *
> > - * Inserts memory barriers on architectures that require them
> > - * (currently only the Alpha), and, more importantly, documents
> > - * exactly which pointers are protected by RCU.
> > - */
> > -
> > -#define rcu_dereference(p)     ({ \
> > -                               typeof(p) _________p1 = ACCESS_ONCE(p); \
> > -                               smp_read_barrier_depends(); \
> > -                               (_________p1); \
> > -                               })
> > -
> > -/**
> > - * rcu_assign_pointer - assign (publicize) a pointer to a newly
> > - * initialized structure that will be dereferenced by RCU read-side
> > - * critical sections.  Returns the value assigned.
> > - *
> > - * Inserts memory barriers on architectures that require them
> > - * (pretty much all of them other than x86), and also prevents
> > - * the compiler from reordering the code that initializes the
> > - * structure after the pointer assignment.  More importantly, this
> > - * call documents which pointers will be dereferenced by RCU read-side
> > - * code.
> > - */
> > -
> > -#define rcu_assign_pointer(p, v) \
> > -       ({ \
> > -               if (!__builtin_constant_p(v) || \
> > -                   ((v) != NULL)) \
> > -                       smp_wmb(); \
> > -               (p) = (v); \
> > -       })
> > -
> >  /* Infrastructure to implement the synchronize_() primitives. */
> >
> >  struct rcu_synchronize {
> > @@ -211,24 +77,6 @@ void name(void) \
> >  }
> >
> >  /**
> > - * synchronize_sched - block until all CPUs have exited any non-preemptive
> > - * kernel code sequences.
> > - *
> > - * This means that all preempt_disable code sequences, including NMI and
> > - * hardware-interrupt handlers, in progress on entry will have completed
> > - * before this primitive returns.  However, this does not guarantee that
> > - * softirq handlers will have completed, since in some kernels, these
> > - * handlers can run in process context, and can block.
> > - *
> > - * This primitive provides the guarantees made by the (now removed)
> > - * synchronize_kernel() API.  In contrast, synchronize_rcu() only
> > - * guarantees that rcu_read_lock() sections will have completed.
> > - * In "classic RCU", these two guarantees happen to be one and
> > - * the same, but can differ in realtime RCU implementations.
> > - */
> > -#define synchronize_sched() __synchronize_sched()
> > -
> > -/**
> >  * call_rcu - Queue an RCU callback for invocation after a grace period.
> >  * @head: structure to be used for queueing the RCU updates.
> >  * @func: actual update function to be invoked after the grace period
> > @@ -263,12 +111,6 @@ extern void call_rcu(struct rcu_head *head,
> >  extern void call_rcu_bh(struct rcu_head *head,
> >                        void (*func)(struct rcu_head *head));
> >
> > -/* Exported common interfaces */
> > -extern void synchronize_rcu(void);
> > -extern void rcu_barrier(void);
> > -extern void rcu_barrier_bh(void);
> > -extern void rcu_barrier_sched(void);
> > -
> >  /* Internal to kernel */
> >  extern void rcu_init(void);
> >  extern int rcu_needs_cpu(int cpu);
> > diff --git a/include/linux/rcupdate_min.h b/include/linux/rcupdate_min.h
> > new file mode 100644
> > index 0000000..35ca45d
> > --- /dev/null
> > +++ b/include/linux/rcupdate_min.h
> > @@ -0,0 +1,205 @@
> > +/*
> > + * Read-Copy Update mechanism for mutual exclusion
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation; either version 2 of the License, or
> > + * (at your option) any later version.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, write to the Free Software
> > + * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
> > + *
> > + * Copyright IBM Corporation, 2001
> > + *
> > + * Author: Dipankar Sarma <dipankar@in.ibm.com>
> > + *
> > + * Based on the original work by Paul McKenney <paulmck@us.ibm.com>
> > + * and inputs from Rusty Russell, Andrea Arcangeli and Andi Kleen.
> > + * Papers:
> > + * http://www.rdrop.com/users/paulmck/paper/rclockpdcsproof.pdf
> > + * http://lse.sourceforge.net/locking/rclock_OLS.2001.05.01c.sc.pdf (OLS2001)
> > + *
> > + * This is a minimal header. Use it if you don't require all definitions,
> > + * as it doesn't end up including slab stuff and lots of other headers.
> > + *
> > + * For detailed explanation of Read-Copy Update mechanism see -
> > + *             http://lse.sourceforge.net/locking/rcupdate.html
> > + *
> > + */
> > +
> > +#ifndef __LINUX_RCUPDATE_MIN_H
> > +#define __LINUX_RCUPDATE_MIN_H
> > +
> > +/**
> > + * struct rcu_head - callback structure for use with RCU
> > + * @next: next update requests in a list
> > + * @func: actual update function to call after the grace period.
> > + */
> > +struct rcu_head {
> > +       struct rcu_head *next;
> > +       void (*func)(struct rcu_head *head);
> > +};
> > +
> > +#ifdef CONFIG_CLASSIC_RCU
> > +#include <linux/rcuclassic_min.h>
> > +#else /* #ifdef CONFIG_CLASSIC_RCU */
> > +#include <linux/rcupreempt_min.h>
> > +#endif /* #else #ifdef CONFIG_CLASSIC_RCU */
> > +
> > +/**
> > + * rcu_read_lock - mark the beginning of an RCU read-side critical section.
> > + *
> > + * When synchronize_rcu() is invoked on one CPU while other CPUs
> > + * are within RCU read-side critical sections, then the
> > + * synchronize_rcu() is guaranteed to block until after all the other
> > + * CPUs exit their critical sections.  Similarly, if call_rcu() is invoked
> > + * on one CPU while other CPUs are within RCU read-side critical
> > + * sections, invocation of the corresponding RCU callback is deferred
> > + * until after the all the other CPUs exit their critical sections.
> > + *
> > + * Note, however, that RCU callbacks are permitted to run concurrently
> > + * with RCU read-side critical sections.  One way that this can happen
> > + * is via the following sequence of events: (1) CPU 0 enters an RCU
> > + * read-side critical section, (2) CPU 1 invokes call_rcu() to register
> > + * an RCU callback, (3) CPU 0 exits the RCU read-side critical section,
> > + * (4) CPU 2 enters a RCU read-side critical section, (5) the RCU
> > + * callback is invoked.  This is legal, because the RCU read-side critical
> > + * section that was running concurrently with the call_rcu() (and which
> > + * therefore might be referencing something that the corresponding RCU
> > + * callback would free up) has completed before the corresponding
> > + * RCU callback is invoked.
> > + *
> > + * RCU read-side critical sections may be nested.  Any deferred actions
> > + * will be deferred until the outermost RCU read-side critical section
> > + * completes.
> > + *
> > + * It is illegal to block while in an RCU read-side critical section.
> > + */
> > +#define rcu_read_lock() __rcu_read_lock()
> > +
> > +/**
> > + * rcu_read_unlock - marks the end of an RCU read-side critical section.
> > + *
> > + * See rcu_read_lock() for more information.
> > + */
> > +
> > +/*
> > + * So where is rcu_write_lock()?  It does not exist, as there is no
> > + * way for writers to lock out RCU readers.  This is a feature, not
> > + * a bug -- this property is what provides RCU's performance benefits.
> > + * Of course, writers must coordinate with each other.  The normal
> > + * spinlock primitives work well for this, but any other technique may be
> > + * used as well.  RCU does not care how the writers keep out of each
> > + * others' way, as long as they do so.
> > + */
> > +#define rcu_read_unlock() __rcu_read_unlock()
> > +
> > +/**
> > + * rcu_read_lock_bh - mark the beginning of a softirq-only RCU critical section
> > + *
> > + * This is equivalent of rcu_read_lock(), but to be used when updates
> > + * are being done using call_rcu_bh(). Since call_rcu_bh() callbacks
> > + * consider completion of a softirq handler to be a quiescent state,
> > + * a process in RCU read-side critical section must be protected by
> > + * disabling softirqs. Read-side critical sections in interrupt context
> > + * can use just rcu_read_lock().
> > + *
> > + */
> > +#define rcu_read_lock_bh() __rcu_read_lock_bh()
> > +
> > +/*
> > + * rcu_read_unlock_bh - marks the end of a softirq-only RCU critical section
> > + *
> > + * See rcu_read_lock_bh() for more information.
> > + */
> > +#define rcu_read_unlock_bh() __rcu_read_unlock_bh()
> > +
> > +/**
> > + * rcu_read_lock_sched - mark the beginning of a RCU-classic critical section
> > + *
> > + * Should be used with either
> > + * - synchronize_sched()
> > + * or
> > + * - call_rcu_sched() and rcu_barrier_sched()
> > + * on the write-side to insure proper synchronization.
> > + */
> > +#define rcu_read_lock_sched() preempt_disable()
> > +
> > +/*
> > + * rcu_read_unlock_sched - marks the end of a RCU-classic critical section
> > + *
> > + * See rcu_read_lock_sched for more information.
> > + */
> > +#define rcu_read_unlock_sched() preempt_enable()
> > +
> > +
> > +
> > +/**
> > + * rcu_dereference - fetch an RCU-protected pointer in an
> > + * RCU read-side critical section.  This pointer may later
> > + * be safely dereferenced.
> > + *
> > + * Inserts memory barriers on architectures that require them
> > + * (currently only the Alpha), and, more importantly, documents
> > + * exactly which pointers are protected by RCU.
> > + */
> > +
> > +#define rcu_dereference(p)     ({ \
> > +                               typeof(p) _________p1 = ACCESS_ONCE(p); \
> > +                               smp_read_barrier_depends(); \
> > +                               (_________p1); \
> > +                               })
> > +
> > +/**
> > + * rcu_assign_pointer - assign (publicize) a pointer to a newly
> > + * initialized structure that will be dereferenced by RCU read-side
> > + * critical sections.  Returns the value assigned.
> > + *
> > + * Inserts memory barriers on architectures that require them
> > + * (pretty much all of them other than x86), and also prevents
> > + * the compiler from reordering the code that initializes the
> > + * structure after the pointer assignment.  More importantly, this
> > + * call documents which pointers will be dereferenced by RCU read-side
> > + * code.
> > + */
> > +
> > +#define rcu_assign_pointer(p, v) \
> > +       ({ \
> > +               if (!__builtin_constant_p(v) || \
> > +                   ((v) != NULL)) \
> > +                       smp_wmb(); \
> > +               (p) = (v); \
> > +       })
> > +
> > +/**
> > + * synchronize_sched - block until all CPUs have exited any non-preemptive
> > + * kernel code sequences.
> > + *
> > + * This means that all preempt_disable code sequences, including NMI and
> > + * hardware-interrupt handlers, in progress on entry will have completed
> > + * before this primitive returns.  However, this does not guarantee that
> > + * softirq handlers will have completed, since in some kernels, these
> > + * handlers can run in process context, and can block.
> > + *
> > + * This primitive provides the guarantees made by the (now removed)
> > + * synchronize_kernel() API.  In contrast, synchronize_rcu() only
> > + * guarantees that rcu_read_lock() sections will have completed.
> > + * In "classic RCU", these two guarantees happen to be one and
> > + * the same, but can differ in realtime RCU implementations.
> > + */
> > +#define synchronize_sched() __synchronize_sched()
> > +
> > +/* Exported common interfaces */
> > +extern void synchronize_rcu(void);
> > +extern void rcu_barrier(void);
> > +extern void rcu_barrier_bh(void);
> > +extern void rcu_barrier_sched(void);
> > +
> > +#endif /* __LINUX_RCUPDATE_MIN_H */
> > +
> > diff --git a/include/linux/rcupreempt.h b/include/linux/rcupreempt.h
> > index 3e05c09..1f1dcf1 100644
> > --- a/include/linux/rcupreempt.h
> > +++ b/include/linux/rcupreempt.h
> > @@ -39,6 +39,7 @@
> >  #include <linux/percpu.h>
> >  #include <linux/cpumask.h>
> >  #include <linux/seqlock.h>
> > +#include <linux/rcupreempt_min.h>
> >
> >  struct rcu_dyntick_sched {
> >        int dynticks;
> > @@ -58,37 +59,6 @@ static inline void rcu_qsctr_inc(int cpu)
> >  }
> >  #define rcu_bh_qsctr_inc(cpu)
> >
> > -/*
> > - * Someone might want to pass call_rcu_bh as a function pointer.
> > - * So this needs to just be a rename and not a macro function.
> > - *  (no parentheses)
> > - */
> > -#define call_rcu_bh            call_rcu
> > -
> > -/**
> > - * call_rcu_sched - Queue RCU callback for invocation after sched grace period.
> > - * @head: structure to be used for queueing the RCU updates.
> > - * @func: actual update function to be invoked after the grace period
> > - *
> > - * The update function will be invoked some time after a full
> > - * synchronize_sched()-style grace period elapses, in other words after
> > - * all currently executing preempt-disabled sections of code (including
> > - * hardirq handlers, NMI handlers, and local_irq_save() blocks) have
> > - * completed.
> > - */
> > -extern void call_rcu_sched(struct rcu_head *head,
> > -                          void (*func)(struct rcu_head *head));
> > -
> > -extern void __rcu_read_lock(void)      __acquires(RCU);
> > -extern void __rcu_read_unlock(void)    __releases(RCU);
> > -extern int rcu_pending(int cpu);
> > -extern int rcu_needs_cpu(int cpu);
> > -
> > -#define __rcu_read_lock_bh()   { rcu_read_lock(); local_bh_disable(); }
> > -#define __rcu_read_unlock_bh() { local_bh_enable(); rcu_read_unlock(); }
> > -
> > -extern void __synchronize_sched(void);
> > -
> >  extern void __rcu_init(void);
> >  extern void rcu_init_sched(void);
> >  extern void rcu_check_callbacks(int cpu, int user);
> > diff --git a/include/linux/rcupreempt_min.h b/include/linux/rcupreempt_min.h
> > new file mode 100644
> > index 0000000..37d3693
> > --- /dev/null
> > +++ b/include/linux/rcupreempt_min.h
> > @@ -0,0 +1,68 @@
> > +/*
> > + * Read-Copy Update mechanism for mutual exclusion (RT implementation)
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation; either version 2 of the License, or
> > + * (at your option) any later version.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, write to the Free Software
> > + * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
> > + *
> > + * Copyright (C) IBM Corporation, 2006
> > + *
> > + * Author:  Paul McKenney <paulmck@us.ibm.com>
> > + *
> > + * Based on the original work by Paul McKenney <paul.mckenney@us.ibm.com>
> > + * and inputs from Rusty Russell, Andrea Arcangeli and Andi Kleen.
> > + * Papers:
> > + * http://www.rdrop.com/users/paulmck/paper/rclockpdcsproof.pdf
> > + * http://lse.sourceforge.net/locking/rclock_OLS.2001.05.01c.sc.pdf (OLS2001)
> > + *
> > + * For detailed explanation of Read-Copy Update mechanism see -
> > + *             Documentation/RCU
> > + *
> > + */
> > +
> > +#ifndef __LINUX_RCUPREEMPT_MIN_H
> > +#define __LINUX_RCUPREEMPT_MIN_H
> > +
> > +/*
> > + * Someone might want to pass call_rcu_bh as a function pointer.
> > + * So this needs to just be a rename and not a macro function.
> > + *  (no parentheses)
> > + */
> > +#define call_rcu_bh            call_rcu
> > +
> > +/**
> > + * call_rcu_sched - Queue RCU callback for invocation after sched grace period.
> > + * @head: structure to be used for queueing the RCU updates.
> > + * @func: actual update function to be invoked after the grace period
> > + *
> > + * The update function will be invoked some time after a full
> > + * synchronize_sched()-style grace period elapses, in other words after
> > + * all currently executing preempt-disabled sections of code (including
> > + * hardirq handlers, NMI handlers, and local_irq_save() blocks) have
> > + * completed.
> > + */
> > +extern void call_rcu_sched(struct rcu_head *head,
> > +                          void (*func)(struct rcu_head *head));
> > +
> > +extern void __rcu_read_lock(void)      __acquires(RCU);
> > +extern void __rcu_read_unlock(void)    __releases(RCU);
> > +extern int rcu_pending(int cpu);
> > +extern int rcu_needs_cpu(int cpu);
> > +
> > +#define __rcu_read_lock_bh()   { rcu_read_lock(); local_bh_disable(); }
> > +#define __rcu_read_unlock_bh() { local_bh_enable(); rcu_read_unlock(); }
> > +
> > +extern void __synchronize_sched(void);
> > +
> > +#endif /* __LINUX_RCUPREEMPT_MIN_H */
> > +
> > --
> > 1.6.0.6
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
