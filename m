Return-Path: <linux-kernel-owner+w=401wt.eu-S1754701AbYBKIQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701AbYBKIQS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 03:16:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752149AbYBKIQD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 03:16:03 -0500
Received: from mail.gmx.net ([213.165.64.20]:53899 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751821AbYBKIQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 03:16:00 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19c06g2APNcK2kRSlbmFxAge8rSpKNQ/Y01jNOwN9
	tN8biagQ0o48vj
Subject: Re: Scheduler(?) regression from 2.6.22 to 2.6.24 for short-lived
	threads
From: Mike Galbraith <efault@gmx.de>
To: Olof Johansson <olof@lixom.net>
Cc: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20080210070056.GA6401@lixom.net>
References: <20080209000456.GA21021@lixom.net>
	 <1202543920.9578.3.camel@homer.simson.net> <20080209080319.GO8953@1wt.eu>
	 <1202554705.10287.12.camel@homer.simson.net> <20080209114009.GP8953@1wt.eu>
	 <1202564259.4035.18.camel@homer.simson.net> <20080209161957.GA3364@1wt.eu>
	 <20080210052941.GA4731@lixom.net> <20080210061558.GC22137@1wt.eu>
	 <20080210070056.GA6401@lixom.net>
Content-Type: text/plain
Date: Mon, 11 Feb 2008 09:15:55 +0100
Message-Id: <1202717755.21339.65.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2008-02-10 at 01:00 -0600, Olof Johansson wrote:
> On Sun, Feb 10, 2008 at 07:15:58AM +0100, Willy Tarreau wrote:
> 
> > > I agree that the testcase is highly artificial. Unfortunately, it's
> > > not uncommon to see these kind of weird testcases from customers tring
> > > to evaluate new hardware. :( They tend to be pared-down versions of
> > > whatever their real workload is (the real workload is doing things more
> > > appropriately, but the smaller version is used for testing). I was lucky
> > > enough to get source snippets to base a standalone reproduction case on
> > > for this, normally we wouldn't even get copies of their binaries.
> > 
> > I'm well aware of that. What's important is to be able to explain what is
> > causing the difference and why the test case does not represent anything
> > related to performance. Maybe the code author wanted to get 500 parallel
> > threads and got his code wrong ?
> 
> I believe it started out as a simple attempt to parallelize a workload
> that sliced the problem too low, instead of slicing it in larger chunks
> and have each thread do more work at a time. It did well on 2.6.22 with
> almost a 2x speedup, but did worse than the single-treaded testcase on a
> 2.6.24 kernel.
> 
> So yes, it can clearly be handled through explanations and education
> and fixen the broken testcase, but I'm still not sure the new behaviour
> is desired.

Piddling around with your testcase, it still looks to me like things
improved considerably in latest greatest git.  Hopefully that means
happiness is in the pipe for the real workload... synthetic load is
definitely happier here as burst is shortened.

#!/bin/sh

uname -r >> results
./threadtest 10 1000000 >> results
./threadtest 100 100000 >> results
./threadtest 1000 10000 >> results
./threadtest 10000 1000 >> results
./threadtest 100000 100 >> results
echo >> results

(threadtest <iterations> <burn_time>)

results:
2.6.22.17-smp
time: 10525370 (us)  work: 20000000  wait: 181000  idx: 1.90
time: 13514232 (us)  work: 20000001  wait: 2666366  idx: 1.48
time: 36280953 (us)  work: 20000008  wait: 21156077  idx: 0.55
time: 196374337 (us)  work: 20000058  wait: 177141620  idx: 0.10
time: 128721968 (us)  work: 20000099  wait: 115052705  idx: 0.16

2.6.22.17-cfs-v24.1-smp
time: 10579591 (us)  work: 20000000  wait: 203659  idx: 1.89
time: 11170784 (us)  work: 20000000  wait: 471961  idx: 1.79
time: 11650138 (us)  work: 20000000  wait: 1406224  idx: 1.72
time: 21447616 (us)  work: 20000007  wait: 10689242  idx: 0.93
time: 106792791 (us)  work: 20000060  wait: 92098132  idx: 0.19

2.6.23.15-smp
time: 10507122 (us)  work: 20000000  wait: 159809  idx: 1.90
time: 10545417 (us)  work: 20000000  wait: 263833  idx: 1.90
time: 11337770 (us)  work: 20000012  wait: 1069588  idx: 1.76
time: 15969860 (us)  work: 20000000  wait: 5577750  idx: 1.25
time: 54029726 (us)  work: 20000027  wait: 41734789  idx: 0.37

2.6.23.15-cfs-v24-smp
time: 10528972 (us)  work: 20000000  wait: 217060  idx: 1.90
time: 10697159 (us)  work: 20000000  wait: 447224  idx: 1.87
time: 12242250 (us)  work: 20000000  wait: 1930175  idx: 1.63
time: 26364658 (us)  work: 20000011  wait: 15468447  idx: 0.76
time: 158338977 (us)  work: 20000084  wait: 144048265  idx: 0.13

2.6.24.1-smp
time: 10570521 (us)  work: 20000000  wait: 208947  idx: 1.89
time: 10699224 (us)  work: 20000000  wait: 404644  idx: 1.87
time: 12280164 (us)  work: 20000005  wait: 1969263  idx: 1.63
time: 26424580 (us)  work: 20000004  wait: 15725967  idx: 0.76
time: 159012417 (us)  work: 20000055  wait: 144906212  idx: 0.13

2.6.25-smp (.git)
time: 10707278 (us)  work: 20000000  wait: 376063  idx: 1.87
time: 10696886 (us)  work: 20000000  wait: 455909  idx: 1.87
time: 11068510 (us)  work: 19990003  wait: 820104  idx: 1.81
time: 11493803 (us)  work: 19995076  wait: 1160150  idx: 1.74
time: 21311673 (us)  work: 20001848  wait: 9399490  idx: 0.94


#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <pthread.h>

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

void *thread_func(void *cpus)
{
	long work = 0, wait = 0;

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

	if (argc > 1)
		iter = atoi(argv[1]);

	if (argc > 2)
		burn_usecs = atoi(argv[2]);

	t1 = usecs();
	while(iter--) {
		stopped = 0;

		pthread_create(&thread, NULL, &thread_func, &cpus);
		thread_func(&cpus);
		pthread_join(thread, NULL);
	}
	t2 = usecs();

	printf("time: %ld (us)  work: %ld  wait: %ld  idx: %2.2f\n",
		t2-t1, tot_work, tot_wait, (double)tot_work/(t2-t1));

	return 0;
}



