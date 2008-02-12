Return-Path: <linux-kernel-owner+w=401wt.eu-S1761659AbYBLJYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761659AbYBLJYM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 04:24:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751950AbYBLJXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 04:23:53 -0500
Received: from mail.gmx.net ([213.165.64.20]:38891 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1760866AbYBLJXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 04:23:30 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19WXa8Nr7ZWNcyiEJcIsjt9gxPBpYdKv7eIZJeGoh
	bQOIA7bco8juOk
Subject: Re: Scheduler(?) regression from 2.6.22 to 2.6.24 for short-lived
	threads
From: Mike Galbraith <efault@gmx.de>
To: Olof Johansson <olof@lixom.net>
Cc: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20080211203159.GA11161@lixom.net>
References: <1202554705.10287.12.camel@homer.simson.net>
	 <20080209114009.GP8953@1wt.eu> <1202564259.4035.18.camel@homer.simson.net>
	 <20080209161957.GA3364@1wt.eu> <20080210052941.GA4731@lixom.net>
	 <20080210061558.GC22137@1wt.eu> <20080210070056.GA6401@lixom.net>
	 <1202717755.21339.65.camel@homer.simson.net>
	 <20080211172648.GA7962@lixom.net>
	 <1202759926.4165.31.camel@homer.simson.net>
	 <20080211203159.GA11161@lixom.net>
Content-Type: multipart/mixed; boundary="=-Pp2RiqX1U0SVgP95n63v"
Date: Tue, 12 Feb 2008 10:23:26 +0100
Message-Id: <1202808206.7829.36.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Pp2RiqX1U0SVgP95n63v
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Mon, 2008-02-11 at 14:31 -0600, Olof Johansson wrote:
> On Mon, Feb 11, 2008 at 08:58:46PM +0100, Mike Galbraith wrote:

> > It shouldn't matter if you yield or not really, that should reduce the
> > number of non-work spin cycles wasted awaiting preemption as threads
> > execute in series (the problem), and should improve your performance
> > numbers, but not beyond single threaded.
> > 
> > If I plugged a yield into the busy wait, I would expect to see a large
> > behavioral difference due to yield implementation changes, but that
> > would only be a symptom in this case, no?  Yield should be a noop.
> 
> Exactly. It made a big impact on the first testcase from Friday, where
> the spin-off thread spent the bulk of the time in the busy-wait loop,
> with a very small initial workload loop. Thus the yield passed the cpu
> over to the other thread who got a chance to run the small workload,
> followed by a quick finish by both of them. The better model spends the
> bulk of the time in the first workload loop, so yielding doesn't gain
> at all the same amount.

There is a strong dependency on execution order in this testcase.

Between cpu affinity and giving the child a little head start to reduce
the chance (100% if child wakes on same CPU and doesn't preempt parent)
of busy wait, modified testcase behaves.  I don't think I should need
the CPU affinity, but I do.

If you plunk a usleep(1) in prior to calling thread_func() does your
testcase performance change radically?  If so, I wonder if the real
application has the same kind of dependency.

	-Mike

--=-Pp2RiqX1U0SVgP95n63v
Content-Disposition: attachment; filename=threadtest.c
Content-Type: text/x-csrc; name=threadtest.c; charset=utf-8
Content-Transfer-Encoding: 7bit

#define _GNU_SOURCE

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <pthread.h>
#include <sched.h>
#include <sys/time.h>
#include <sys/types.h>
#include <sys/syscall.h>

#ifdef __PPC__
static void atomic_inc(volatile long *a)
{
	asm volatile ("1:\n\
			lwarx  %0,0,%1\n\
			addic  %0,%0,1\n\
			stwcx. %0,0,%1\n\
			bne-  1b" : "=&r" (result) : "r"(a));
}
#else
static void atomic_inc(volatile long *a)
{
	asm volatile ("lock; incl %0" : "+m" (*a));
}
#endif

long usecs(void)
{
	struct timeval tv;
	gettimeofday(&tv, NULL);
	return tv.tv_sec * 1000000 + tv.tv_usec;
}

void burn(long *burnt)
{
	long then, now, delta, tolerance = 10;

	then = now = usecs();
	while (now == then)
		now = usecs();
	delta = now - then;
	if (delta < tolerance)
		*burnt += delta;
}

volatile long stopped;
long burn_usecs = 1000, tot_work, tot_wait;

pid_t parent;
#define gettid() syscall(SYS_gettid)

void *thread_func(void *cpus)
{
	long work = 0, wait = 0;
	cpu_set_t cpuset;
	pid_t whoami = gettid();

	if (whoami != parent) {
		CPU_ZERO(&cpuset);
		CPU_SET(1, &cpuset);
		sched_setaffinity(whoami, sizeof(cpuset), &cpuset);
		usleep(1);
	}

	while (work < burn_usecs)
		burn(&work);
	tot_work += work;

	atomic_inc(&stopped);

	/* Busy-wait */
	while (stopped < *(int *)cpus)
		burn(&wait);
	tot_wait += wait;

	return NULL;
}

int main(int argc, char **argv)
{
	pthread_t thread;
	int iter = 500, cpus = 2;
	long t1, t2;
	cpu_set_t cpuset;

	if (argc > 1)
		iter = atoi(argv[1]);

	if (argc > 2)
		burn_usecs = atoi(argv[2]);

	parent = gettid();
	CPU_ZERO(&cpuset);
	CPU_SET(0, &cpuset);
	sched_setaffinity(parent, sizeof(cpuset), &cpuset);

	t1 = usecs();
	while(iter--) {
		stopped = 0;

		pthread_create(&thread, NULL, &thread_func, &cpus);
		/* clild needs headstart guarantee to avoid busy wait */
		usleep(1);
		thread_func(&cpus);
		pthread_join(thread, NULL);
	}
	t2 = usecs();

	printf("time: %ld (us)  work: %ld  wait: %ld  idx: %2.2f\n",
		t2-t1, tot_work, tot_wait, (double)tot_work/(t2-t1));

	return 0;
}

--=-Pp2RiqX1U0SVgP95n63v--

