Return-Path: <linux-kernel-owner+w=401wt.eu-S1760664AbYBIADh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760664AbYBIADh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 19:03:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755228AbYBIAD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 19:03:27 -0500
Received: from lixom.net ([66.141.50.11]:38770 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754535AbYBIAD0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 19:03:26 -0500
Date: Fri, 8 Feb 2008 18:04:56 -0600
From: Olof Johansson <olof@lixom.net>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Scheduler(?) regression from 2.6.22 to 2.6.24 for short-lived
	threads
Message-ID: <20080209000456.GA21021@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I ended up with a customer benchmark in my lap this week that doesn't
do well on recent kernels. :(

After cutting it down to a simple testcase/microbenchmark, it seems like
recent kernels don't do as well with short-lived threads competing
with the thread it's cloned off of. The CFS scheduler changes come to
mind, but I suppose it could be caused by something else as well.

The pared-down testcase is included below. Reported runtime for the
testcase has increased almost 3x between 2.6.22 and 2.6.24:

2.6.22: 3332 ms
2.6.23: 4397 ms
2.6.24: 8953 ms
2.6.24-git19: 8986 ms

While running, it'll fork off a bunch of threads, each doing just a little
work, then busy-waiting on the original thread to finish as well. Yes,
it's incredibly stupidly coded but that's not my point here.

During run, (runtime 10s on my 1.5GHz Core2 Duo laptop), vmstat 2  shows:

 0  0      0 115196 364748 2248396    0    0     0     0  163   89  0  0 100  0
 2  0      0 115172 364748 2248396    0    0     0     0  270  178 24  0 76  0
 2  0      0 115172 364748 2248396    0    0     0     0  402  283 52  0 48  0
 2  0      0 115180 364748 2248396    0    0     0     0  402  281 50  0 50  0
 2  0      0 115180 364764 2248396    0    0     0    22  403  295 51  0 48  1
 2  0      0 115056 364764 2248396    0    0     0     0  399  280 52  0 48  0
 0  0      0 115196 364764 2248396    0    0     0     0  241  141 17  0 83  0
 0  0      0 115196 364768 2248396    0    0     0     2  155   67  0  0 100  0
 0  0      0 115196 364768 2248396    0    0     0     0  148   62  0  0 100  0

I.e. runqueue is 2, but only one cpu is busy. However, this still seems
true on the kernel that runs the testcase in more reasonable time.

Also, 'time' reports real and user time roughly the same on all kernels,
so it's not that the older kernels are better at spreading out the load
between the two cores (either that or it doesn't account for stuff right).

I've included the config files, runtime output and vmstat output at
http://lixom.net/~olof/threadtest/. I see similar behaviour on PPC as
well as x86, so it's not architecture-specific.

Testcase below. Yes, I know, there's a bunch of stuff that could be done
differently and better, but it still doesn't motivate why there's a 3x
slowdown between kernel versions...


-Olof



#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

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

volatile long stopped;

int thread_func(int cpus)
{
	int j;

	for (j = 0; j < 10000; j++)
		;

	atomic_inc(&stopped);

	/* Busy-wait */
	while (stopped < cpus)
		j++;
}

long usecs(void)
{
	struct timeval tv;
	gettimeofday(&tv, NULL);
	return tv.tv_sec * 1000000 + tv.tv_usec;
}

int main(int argc, char **argv)
{
	pthread_t thread;
	int i;
	long t1, t2;

	t1 = usecs();
	for (i = 0; i < 500; i++) {
		stopped = 0;

		pthread_create(&thread, NULL, thread_func, 2);
		thread_func(2);
		pthread_join(thread, NULL);
	}
	t2 = usecs();

	printf("time %ld ms\n", (t2-t1) / 1000);

	return 0;
}
