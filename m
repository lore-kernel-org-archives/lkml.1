Return-Path: <linux-kernel-owner+w=401wt.eu-S1755480AbXGGBub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480AbXGGBub (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 21:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753574AbXGGBuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 21:50:16 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:61215 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753109AbXGGBuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 21:50:14 -0400
Date: Fri, 6 Jul 2007 21:50:09 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Li, Tong N" <tong.n.li@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 10/10] *Tests* Scheduler profiling - Use immediate values
Message-ID: <20070707015009.GA10775@Krystal>
References: <p73vecx21um.fsf@bingen.suse.de> <5FD5754DDBA0B1499B5A0B4BB5419485015CC88A@fmsmsx411.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <5FD5754DDBA0B1499B5A0B4BB5419485015CC88A@fmsmsx411.amr.corp.intel.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:46:55 up 5 days, 13:29,  4 users,  load average: 0.50, 0.56, 0.37
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Li, Tong N (tong.n.li@intel.com) wrote:
> > Also cache misses in this situation tend to be much more than 48
> cycles
> > (even an K8 with integrated memory controller with fastest DIMMs is
> > slower than that)  Mathieu probably measured an L2 miss, not a load
> from
> > RAM.
> > Load from RAM can be hundreds of ns in the worst case.
> > 
> 
> The 48 cycles sounds to me like a memory load in an unloaded system, but
> it is quite low. I wonder how it was measured...
> 
>   tong
> 

Ah, excellent point.

I just re-read through my test case, and I modified it so it initializes
the memory first, instead of using the zero page, and now does a
pseudo-random walk instead of going through the L2 cache lines
sequentially...  that will help. Especially since the memory is dual
channel and the cpu does some prefetching. The code follows this
email for easier review and test.

I also did a test that characterize the speed impact of my LTTng marker
set in both scenarios with a memory I/O hungry program, also provided
below.


* Memory hit for a data-based branch

Here are the results now, on my 3GHz Pentium 4:

number of tests : 100
number of branches per test : 100000
memory hit cycles per iteration (mean) : 636.611
L1 cache hit cycles per iteration (mean) : 89.6413
instruction stream based test, cycles per iteration (mean) : 85.3438
Just getting the pointer from a modulo on a pseudo-random value, doing
  noting with it, cycles per iteration (mean) : 77.5044

So:
Base case:                      77.50 cycles
instruction stream based test:  +7.8394 cycles
L1 cache hit based test:        +12.1369 cycles
Memory load based test:         +559.1066 cycles

So let's say we have a ping flood coming at 
(14014 packets transmitted, 14014 received, 0% packet loss, time 1826ms)
7674 packets per second. If we put 2 markers for irq entry/exit, it
brings us to 15348 markers sites executed per second.

(15348 exec/s) * (559 cycles/exec) / (3G cycles/s) = 0.0029
We therefore have a 0.29% slowdown just on this case.

Compared to this, the instruction stream based test will cause a
slowdown of:

(15348 exec/s) * (7.84 cycles/exec) / (3G cycles/s) = 0.00004
For a 0.004% slowdown.

If we plan to use this for memory allocation, spinlock, and all sort of
very high event rate tracing, we can assume it will execute 10 to 100
times more sites per second, which brings us to 0.4% slowdown with the
instruction stream based test compared to 29% slowdown with the memory
load based test on a system with high memory pressure.



* Markers impact under heavy memory load

Running a kernel with my LTTng instrumentation set, in a test that
generates memory pressure (from userspace) by trashing L1 and L2 caches
between calls to getppid() (note: syscall_trace is active and calls
a marker upon syscall entry and syscall exit; markers are disarmed).
This test is done in user-space, so there are some delays due to IRQs
coming and to the scheduler. (UP 2.6.22-rc6-mm1 kernel, task with -20
nice level)

My first set of results : Linear cache trashing, turned out not to be
very interesting, because it seems like the linearity of the memset on a
full array is somehow detected and it does not "really" trash the
caches.

Now the most interesting result : Random walk L1 and L2 trashing
surrounding a getppid() call.

- Markers compiled out (but syscall_trace execution forced)
number of tests : 10000
No memory pressure
Reading timestamps takes 108.033 cycles
getppid : 1681.4 cycles
With memory pressure
Reading timestamps takes 102.938 cycles
getppid : 15691.6 cycles


- With the immediate values based markers:
number of tests : 10000
No memory pressure
Reading timestamps takes 108.006 cycles
getppid : 1681.84 cycles
With memory pressure
Reading timestamps takes 100.291 cycles
getppid : 11793 cycles


- With global variables based markers:
number of tests : 10000
No memory pressure
Reading timestamps takes 107.999 cycles
getppid : 1669.06 cycles
With memory pressure
Reading timestamps takes 102.839 cycles
getppid : 12535 cycles


The result is quite interesting in that the kernel is slower without
markers than with markers. I explain it by the fact that the data
accessed is not layed out in the same manner in the cache lines when the
markers are compiled in or out. It seems that it aligns the function's
data better to compile-in the markers in this case.

But since the interesting comparison is between the immediate values and
global variables based markers, and because they share the same memory
layout, except for the movl being replaced by a movz, we see that the
global variable based markers (2 markers) adds 742 cycles to each system
call (syscall entry and exit are traced and memory locations for both
global variables lie on the same cache line).

Therefore, not only is it interesting to use the immediate values to
dynamically activate dormant code such as the markers, but I think it
should also be considered as a replacement for many of the "read mostly"
static variables.


Mathieu


Testing memory timings, in user-space:
----------------------------------------------------------------------------
#include <stdio.h>
#include <stdlib.h>
#include <string.h>


typedef unsigned long long cycles_t;

#define barrier() __asm__ __volatile__("": : :"memory")

#define rdtsc(low,high) \
     __asm__ __volatile__("rdtsc" : "=a" (low), "=d" (high))

#define rdtscl(low) \
     __asm__ __volatile__("rdtsc" : "=a" (low) : : "edx")

#define rdtscll(val) \
     __asm__ __volatile__("rdtsc" : "=A" (val))


static inline cycles_t get_cycles(void)
{
	unsigned long long ret = 0;

	barrier();
	rdtscll(ret);
	barrier();
	return ret;
}


#define L1_CACHELINE_SIZE 64
#define L2_CACHELINE_SIZE 128
#define ARRAY_SIZE 524288000

#define NR_TESTS 100
#define NR_ITER 100000

char array[ARRAY_SIZE];
unsigned int glob = 0;

int main(int argc, char **argv)
{
	char *testval;
	cycles_t time1, time2;
	double cycles_per_iter;
	unsigned int i, j;

	srandom(get_cycles());

	printf("number of tests : %lu\n", NR_TESTS);
	printf("number of branches per test : %lu\n", NR_ITER);

	memset(array, 0, ARRAY_SIZE);

	cycles_per_iter = 0.0;
	for (i=0; i<NR_TESTS; i++) {
		time1 = get_cycles();
		for (j = 0; j < NR_ITER; j++) {
			testval = &array[random() % ARRAY_SIZE];
			if (*testval)
				glob++;
		}
		time2 = get_cycles();
		cycles_per_iter += (time2 - time1)/(double)NR_ITER;
	}
	cycles_per_iter /= (double)NR_TESTS;
	printf("memory hit cycles per iteration (mean) : %g\n", cycles_per_iter);

	cycles_per_iter = 0.0;
	for (i=0; i<NR_TESTS; i++) {
		testval = &array[random() % L1_CACHELINE_SIZE];
		if (*testval)
			glob++;
		time1 = get_cycles();
		for (j = 0; j < NR_ITER; j++) {
			testval = &array[random() % L1_CACHELINE_SIZE];
			if (*testval)
				glob++;
		}
		time2 = get_cycles();
		cycles_per_iter += (time2 - time1)/(double)NR_ITER;
	}
	cycles_per_iter /= (double)NR_TESTS;
	printf("L1 cache hit cycles per iteration (mean) : %g\n", cycles_per_iter);

	cycles_per_iter = 0.0;
	for (i=0; i<NR_TESTS; i++) {
		time1 = get_cycles();
		for (j = 0; j < NR_ITER; j++) {
			char condition;
			asm (			".align 2\n\t"
						"0:\n\t"
						"movb %1,%0;\n\t"
					: "=r" (condition)
					: "i" (0));
				testval = &array[random() % ARRAY_SIZE];
				if (condition)
					glob++;
		}
		time2 = get_cycles();
		cycles_per_iter += (time2 - time1)/(double)NR_ITER;
	}
	cycles_per_iter /= (double)NR_TESTS;
	printf("instruction stream based test, cycles per iteration (mean) : %g\n", cycles_per_iter);

	cycles_per_iter = 0.0;
	for (i=0; i<NR_TESTS; i++) {
		time1 = get_cycles();
		for (j = 0; j < NR_ITER; j++) {
			testval = &array[random() % ARRAY_SIZE];
		}
		time2 = get_cycles();
		cycles_per_iter += (time2 - time1)/(double)NR_ITER;
	}
	cycles_per_iter /= (double)NR_TESTS;
	printf("Just getting the pointer, doing noting with it, cycles per iteration (mean) : %g\n", cycles_per_iter);

	return 0;
}
----------------------------------------------------------------------------

And here is the syscall timing under heavy memory I/O load: (gcc -O2)
----------------------------------------------------------------------------
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>

typedef unsigned long long cycles_t;

#define barrier() __asm__ __volatile__("": : :"memory")

#define rdtsc(low,high) \
     __asm__ __volatile__("rdtsc" : "=a" (low), "=d" (high))

#define rdtscl(low) \
     __asm__ __volatile__("rdtsc" : "=a" (low) : : "edx")

#define rdtscll(val) \
     __asm__ __volatile__("rdtsc" : "=A" (val))


static inline cycles_t get_cycles(void)
{
	unsigned long long ret = 0;

	barrier();
	rdtscll(ret);
	barrier();
	return ret;
}


#define L1_CACHELINE_SIZE 64
#define L2_CACHELINE_SIZE 128
#define ARRAY_SIZE 1048576	/* 1 MB, size of L2 cache */

char array[ARRAY_SIZE];

#define NR_TESTS 10000

int main(int argc, char **argv)
{
	cycles_t time1, time2;
	double cycles_per_iter;
	unsigned int i, j;
	pid_t pid;

	printf("number of tests : %lu\n", NR_TESTS);

	srandom(get_cycles());

	printf("No memory pressure\n");
	cycles_per_iter = 0.0;
	for (i=0; i<NR_TESTS; i++) {
		time1 = get_cycles();
		time2 = get_cycles();
		cycles_per_iter += (time2 - time1);
	}
	cycles_per_iter /= (double)NR_TESTS;

	printf("Reading timestamps takes %g cycles\n", cycles_per_iter);

	cycles_per_iter = 0.0;
	for (i=0; i<NR_TESTS; i++) {
		time1 = get_cycles();
		pid = getppid();
		time2 = get_cycles();
		cycles_per_iter += (time2 - time1);
	}
	cycles_per_iter /= (double)NR_TESTS;

	printf("getppid : %g cycles\n", cycles_per_iter);

	printf("With memory pressure\n");

	cycles_per_iter = 0.0;
	for (i=0; i<NR_TESTS; i++) {
		//memset(array, 1, ARRAY_SIZE);
		for (j=0; j<ARRAY_SIZE*3; j++)
			array[random() % ARRAY_SIZE] = 1;
		time1 = get_cycles();
		time2 = get_cycles();
		cycles_per_iter += (time2 - time1);
	}
	cycles_per_iter /= (double)NR_TESTS;

	printf("Reading timestamps takes %g cycles\n", cycles_per_iter);

	cycles_per_iter = 0.0;
	for (i=0; i<NR_TESTS; i++) {
		//memset(array, 1, ARRAY_SIZE);
		for (j=0; j<ARRAY_SIZE*3; j++)
			array[random() % ARRAY_SIZE] = 1;
		time1 = get_cycles();
		pid = getppid();
		time2 = get_cycles();
		cycles_per_iter += (time2 - time1);
	}
	cycles_per_iter /= (double)NR_TESTS;

	printf("getppid : %g cycles\n", cycles_per_iter);

	return 0;
}
----------------------------------------------------------------------------

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
