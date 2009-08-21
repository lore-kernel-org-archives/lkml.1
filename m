Return-Path: <linux-kernel-owner+w=401wt.eu-S932365AbZHUO6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932365AbZHUO6T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 10:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932229AbZHUO6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 10:58:18 -0400
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:43782 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932207AbZHUO6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 10:58:17 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AugEANpSjkpMRdTz/2dsb2JhbACBU9UBhBgFgU8
Date: Fri, 21 Aug 2009 10:58:14 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Josh Triplett <josht@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, rostedt@goodmis.org, hugh.dickins@tiscali.co.uk,
       benh@kernel.crashing.org
Subject: Re: [PATCH -tip/core/rcu 1/6] Cleanups and fixes for RCU in face
	of heavy CPU-hotplug stress
Message-ID: <20090821145814.GB29542@Krystal>
References: <20090815165153.GA8886@linux.vnet.ibm.com> <1250533487.2709.14.camel@josh-work.beaverton.ibm.com> <20090817192036.GJ6760@linux.vnet.ibm.com> <20090818152643.GA5549@elte.hu> <20090820140335.GA31773@Krystal> <20090821141721.GA11098@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090821141721.GA11098@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 10:21:14 up 3 days,  1:10,  2 users,  load average: 0.25, 0.37,
	0.28
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > I would not trust this architecture for synchronization tests. 
> > There has been reports of a hardware bug affecting the cmpxchg 
> > instruction in the field. The load fence normally implied by the 
> > semantic seems to be missing. AFAIK, AMD never acknowledged the 
> > problem.
> 
> If cmpxchg was broken i'd be having far worse problems and very 
> widely so.
> 
> FYI, this was the same box i prototyped/developed -rt on, which uses 
> cmpxchg for _everything_.
> 
> That's not a proof of course (it's near impossible to prove the lack 
> of a bug), but it's sure a strong indicator and you'll need to 
> provide far more proof of misbehavior before i discount a bona fide 
> regression on this box.
> 
> 	Ingo

You are right, the race condition is unlikely. Finally AMD issued an
errata: #147

Potential Violation of Read Ordering Rules Between
Semaphore Operations and Unlocked Read-Modify-Write
Instructions

http://support.amd.com/us/Processor_TechDocs/25759.pdf

One needs to have this kind of instruction sequence:

lock; cmpxchg
cmpxchg

to hit the problem, which seems to be a pattern unlikely to happen in
the kernel. Maybe except in ftrace, with a combination of spinlock and
cmpxchg_local().

FWIW, I created a small test program which aims at triggering the
problem. So far my AMD box did not show any symptom (although the CPU
family, model and MSR values indicate that it should be affected).

The following program is actually pretty useful to stress-test memory
barriers.

Mathieu


/*
 * Memory barrier ordering testing
 *
 * Allows to test whether architecture primitives really act as full memory
 * barriers.
 *
 * build with gcc -O2 -lpthread -o test-memory-barrier test-memory-barrier.c
 *
 * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
 * License: GPLv2
 */

#include <stdio.h>
#include <pthread.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
#include <stdio.h>
#include <signal.h>

#define CACHE_LINE_SIZE 64

#define MAX_DELAY	32

#define LONG_PER_CACHE_LINE	(CACHE_LINE_SIZE / sizeof(long))

/* gcc definitions */

#define barrier()	asm volatile("" ::: "memory");

/* AMD/Intel definitions */

#ifdef FIX_AMD_LOCK_CMPXCHG_BUG
#define CMPXCHG_LFENCE	"lfence\n\t"
#else
#define CMPXCHG_LFENCE
#endif

#define LOCK_PREFIX "lock; "

#define __xg(x) ((volatile long *)(x))

static inline void prefetch(const void *x)
{
	asm volatile ("prefetcht0 (%0)\n\t" : : "r" (x));
}

static inline void clflush(volatile void *__p)
{
	asm volatile("clflush %0" : "+m" (*(volatile char *)__p));
}

static inline unsigned long __cmpxchg_local(volatile void *ptr, unsigned long old,
				      unsigned long new, int size)
{
	unsigned long prev;
	switch (size) {
	case 1:
		asm volatile("cmpxchgb %b1,%2\n\t"
			     : "=a"(prev)
			     : "q"(new), "m"(*__xg(ptr)), "0"(old)
			     : "memory");
		return prev;
	case 2:
		asm volatile("cmpxchgw %w1,%2\n\t"
			     : "=a"(prev)
			     : "r"(new), "m"(*__xg(ptr)), "0"(old)
			     : "memory");
		return prev;
	case 4:
		asm volatile("cmpxchgl %k1,%2\n\t"
			     : "=a"(prev)
			     : "r"(new), "m"(*__xg(ptr)), "0"(old)
			     : "memory");
		return prev;
	case 8:
		asm volatile("cmpxchgq %1,%2\n\t"
			     : "=a"(prev)
			     : "r"(new), "m"(*__xg(ptr)), "0"(old)
			     : "memory");
		return prev;
	}
	return old;
}

static inline unsigned long __cmpxchg(volatile void *ptr, unsigned long old,
				      unsigned long new, int size)
{
	unsigned long prev;
	switch (size) {
	case 1:
		asm volatile(LOCK_PREFIX "cmpxchgb %b1,%2\n\t"
			     CMPXCHG_LFENCE
			     "cmpxchgb %b1,%2\n\t"
			     : "=a"(prev)
			     : "q"(new), "m"(*__xg(ptr)), "0"(old)
			     : "memory");
		return prev;
	case 2:
		asm volatile(LOCK_PREFIX "cmpxchgw %w1,%2\n\t"
			     CMPXCHG_LFENCE
			     "cmpxchgw %w1,%2\n\t"
			     : "=a"(prev)
			     : "r"(new), "m"(*__xg(ptr)), "0"(old)
			     : "memory");
		return prev;
	case 4:
		asm volatile(LOCK_PREFIX "cmpxchgl %k1,%2\n\t"
			     CMPXCHG_LFENCE
			     "cmpxchgl %k1,%2\n\t"
			     : "=a"(prev)
			     : "r"(new), "m"(*__xg(ptr)), "0"(old)
			     : "memory");
		return prev;
	case 8:
		asm volatile(LOCK_PREFIX "cmpxchgq %1,%2\n\t"
			     CMPXCHG_LFENCE
			     "cmpxchgq %1,%2\n\t"
			     : "=a"(prev)
			     : "r"(new), "m"(*__xg(ptr)), "0"(old)
			     : "memory");
		return prev;
	}
	return old;
}

/*
 * Note: no "lock" prefix even on SMP: xchg always implies lock anyway
 * Note 2: xchg has side effect, so that attribute volatile is necessary,
 *	  but generally the primitive is invalid, *ptr is output argument. --ANK
 */
static inline unsigned long __xchg(unsigned long x, volatile void *ptr,
				   int size)
{
	switch (size) {
	case 1:
		asm volatile("xchgb %b0,%1"
			     : "=q" (x)
			     : "m" (*__xg(ptr)), "0" (x)
			     : "memory");
		break;
	case 2:
		asm volatile("xchgw %w0,%1"
			     : "=r" (x)
			     : "m" (*__xg(ptr)), "0" (x)
			     : "memory");
		break;
	case 4:
		asm volatile("xchgl %k0,%1"
			     : "=r" (x)
			     : "m" (*__xg(ptr)), "0" (x)
			     : "memory");
		break;
	case 8:
		asm volatile("xchgq %0,%1"
			     : "=r" (x)
			     : "m" (*__xg(ptr)), "0" (x)
			     : "memory");
		break;
	}
	return x;
}

#define xchg(ptr, v) ((__typeof__(*(ptr)))__xchg((unsigned long)(v), \
						 (ptr), sizeof(*(ptr))))

static inline void atomic_long_inc(volatile unsigned long *v)
{
	asm volatile(LOCK_PREFIX "incq %0"
		: "=m" (*v)
		: "m" (*v));
}

static inline void atomic_long_dec(volatile unsigned long *v)
{
	asm volatile(LOCK_PREFIX "decq %0"
		: "=m" (*v)
		: "m" (*v));
}

static inline long atomic_long_add_return(int i, volatile long *v)
{
	int __i = i;
	asm volatile(LOCK_PREFIX "xaddq %0, %1"
		: "+r" (i), "+m" (*v)
		: : "memory");
	return i + __i;
}

#define atomic_inc_return(v)  (atomic_add_return(1, v))

#define cmpxchg_local(ptr, o, n)					\
	((__typeof__(*(ptr)))__cmpxchg_local((ptr), (unsigned long)(o),	\
				       (unsigned long)(n), sizeof(*(ptr))))

#define cmpxchg(ptr, o, n)						\
	((__typeof__(*(ptr)))__cmpxchg((ptr), (unsigned long)(o),	\
				       (unsigned long)(n), sizeof(*(ptr))))

/* REP NOP (PAUSE) is a good thing to insert into busy-wait loops. */
static inline void rep_nop(void)
{
	asm volatile("rep; nop" ::: "memory");
}

static inline void cpu_relax(void)
{
	rep_nop();
}

#define mb()		asm volatile("mfence":::"memory")
#define rmb()		asm volatile("lfence":::"memory")
#define wmb()		asm volatile("sfence":::"memory")

#define smp_mb()	mb()
#define smp_rmb()	rmb()
#define smp_wmb()	wmb()


/* Now, the real test program */

#define ARRAY_SIZE 1048576
#define NR_THREADS 2UL

long gepoch;	/* global current epoch */

/* Array to perform cache-line accesses */
long val[ARRAY_SIZE];

/* Values read */
long x, y;

void wait_for_all_threads(long *lepoch, long *gepoch)
{
	/* barrier #1, 2 threads meet */
	*lepoch += NR_THREADS;
	atomic_long_inc(gepoch);
	while(*gepoch - *lepoch < 0L)
		cpu_relax();
	smp_mb();
}

void *testmemthread(void *arg)
{
	int tid = (int)(long)arg;
	unsigned long tmp;
	volatile long z;
	long lepoch = 0;
	long *evencl = val;
	long *oddcl = val + LONG_PER_CACHE_LINE;
	int i, delay[2];
	int seed = (int)pthread_self();

	printf("thread %d, thread id : %lu, pid %lu\n",
			tid, pthread_self(), getpid());

	for (;;) {
		/* random delay */
		delay[0] = rand_r(&seed) % MAX_DELAY;
		delay[1] = rand_r(&seed) % MAX_DELAY;

		for (i = 0;
		     i < 2 * LONG_PER_CACHE_LINE * delay[0];
		     i+= 2 * LONG_PER_CACHE_LINE)
			clflush(&evencl[i]);
		for (i = 0;
		     i < 2 * LONG_PER_CACHE_LINE * delay[1];
		     i+= 2 * LONG_PER_CACHE_LINE)
			clflush(&oddcl[i]);

		wait_for_all_threads(&lepoch, &gepoch);

		/* load even cache-lines, except *evencl */
		for (i = 2 * LONG_PER_CACHE_LINE;
		     i < 2 * LONG_PER_CACHE_LINE * delay[0];
		     i+= 2 * LONG_PER_CACHE_LINE)
			z = evencl[i];
		/* load odd cache-lines, except *oddcl */
		for (i = 2 * LONG_PER_CACHE_LINE;
		     i < 2 * LONG_PER_CACHE_LINE * delay[1];
		     i+= 2 * LONG_PER_CACHE_LINE)
			z = oddcl[i];

		if (tid == 0)
			*oddcl = 1;
		else
			*evencl = 1;

		/*
		 * This is where the fun is. Try disabling some barriers, using
		 * different flavors, etc...
		 */
		//smp_mb();
		(void)cmpxchg(&tmp, !!delay, 1);
		//(void)xchg(&tmp, 1);

		/* Known inappropriate */
		//(void)cmpxchg_local(&tmp, !!delay, 1);
		//barrier();
		//smp_wmb();
		//smp_rmb();

		if (tid == 0)
			y = *evencl;
		else
			x = *oddcl;

		wait_for_all_threads(&lepoch, &gepoch);

		if (x == 0 && y == 0) {
			printf("Memory ordering inconsistency: "
			       "thread %d x: %ld y: %ld\n", tid, x, y);
			exit(1);
		}
		if (!(lepoch & ((1 << 22) - 1)))
			printf("thread %d epoch %ld, x: %ld, y: %ld\n",
					tid, lepoch, x, y);

		wait_for_all_threads(&lepoch, &gepoch);

		/* Reset variables */
		*evencl = 0;
		*oddcl = 0;
		x = 1;
		y = 1;
	}
	return ((void*)0);
}

int main()
{
	int err;
	pthread_t testmemid[NR_THREADS];
	void *tret;
	int i;

	for (i = 0; i < NR_THREADS; i++) {
		err = pthread_create(&testmemid[i], NULL, testmemthread,
			(void *)(long)i);
		if (err != 0)
			exit(1);
	}

	printf("Infinite loops starting. Hit CTRL+C to abort.\n");

	sleep(100);

	for (i = 0; i < NR_THREADS; i++) {
		err = pthread_join(testmemid[i], &tret);
		if (err != 0)
			exit(1);
	}

	return 0;
}


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
