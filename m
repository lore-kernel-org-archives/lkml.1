Return-Path: <linux-kernel-owner+w=401wt.eu-S1761497AbZJJO6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761497AbZJJO6k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 10:58:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752437AbZJJO6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 10:58:40 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:55937 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbZJJO6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 10:58:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type;
        b=FSG7y4UZ3dlBTqbHlS1uHzqNzbIA09lEIRpya8XuvxJLoYPZV+ImLiHjlmB92N2c+h
         wLkXeKra2oilUfWVeWFtqjHrS/Pw7GOef/a7O25TC5I/PP9U3FyGQaO0bEDwbQlmtbPY
         zzr45tbPNgLp0IdFrpGmmo7w90LXi4FDM2aXM=
Message-ID: <4AD0A0F7.9070700@clamav.net>
Date: Sat, 10 Oct 2009 17:57:59 +0300
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwin@clamav.net>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, aCaB <acab@clamav.net>
Subject: Mutex vs semaphores scheduler bug
X-Enigmail-Version: 0.95.0
Content-Type: multipart/mixed;
 boundary="------------090700050602050408020507"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090700050602050408020507
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi,

If a semaphore (such as mmap_sem) is heavily congested, then using a
userspace mutex makes the program faster.

For example using a mutex around *anonymous* mmaps, speeds it up
significantly (~80% on this microbenchmark,
~15% on real applications). Such workarounds shouldn't  be necessary for
userspace applications, the kernel should
by default use the most efficient implementation for locks.

Run the attached testcase, and see that when using a mutex, the elapsed
time (and user+sys too) is smaller
than when not using the mutex [1].

So using mmap/munmap by itself (and thus directly hitting the
semaphore), and memsetting only first page
is 80% slower than doing the same guarded by a mutex.
If the entire allocated region is memset (thus faulting all pages), then
the mmap without a mutex is still 7% slower.

In both cases the maximum time for a mmap is HIGHER when using the mutex
(8.7 ms>5.1 ms and 4 ms>0.2 ms),
however the average time is smaller.
However when using a mutex the number of context switches is SMALLER by
40-60%.

I think its a bug in the scheduler, it scheduler the mutex case much
better.
Maybe because userspace also spins a bit before actually calling
futex(). So *maybe* a possible fix would be to also try
and spin a little on some semaphores before taking them.

I think its important to optimize the mmap_sem semaphore, because it is
hit quite often (even when not mmaping files):
 - mmap of anon memory
 - malloc (due to above)
 - stack increase
 - page faults (of both file-mapped and anon memory)

P.S.: this is not just a microbenchmark, it came up during profiling of
ClamAV, using the mutex speeds it up by ~15%.
P.S.: if needed I can send you my .config
Best regards,
--Edwin

[1]

Timings on Linux 2.6.31 Intel(R) Core(TM)2 Quad  CPU   Q9550  @ 2.83GHz
--------------------------------------------------------------------------------------------------------------------------

Running tests with ntimings=100, nloops=100, nthreads=16, number of CPUs=4
Starting test mmap sem congestion (memset all)
Test mmap sem congestion (memset all) ended
Timing mmap sem congestion (memset all): elapsted time: 99.1104 s, 3.055
%user, 38.521 %sys
max 5175.1 us, average 2477.75 us, stdev 49681.3 us
resource usage: 3.02818 s user, 38.1784 s sys, 99.1104 s elapsed,
(10240001 min + 0 maj) pagefaults, 5844551 + 2924 context switches

Starting test mmap sem congestion with mutex workaround (memset all)
Test mmap sem congestion with mutex workaround (memset all) ended
Timing mmap sem congestion with mutex workaround (memset all): elapsted
time: 93.4126 s, 3.357 %user, 31.822 %sys
max 8710.94 us, average 2335.3 us, stdev 549728 us
resource usage: 3.13619 s user, 29.7259 s sys, 93.4126 s elapsed,
(10240000 min + 0 maj) pagefaults, 3316568 + 1464 context switches

Starting test mmap sem congestion (memset firstpage)
Test mmap sem congestion (memset firstpage) ended
Timing mmap sem congestion (memset firstpage): elapsted time: 6.73074 s,
0.000 %user, 15.571 %sys
max 229.96 us, average 168.263 us, stdev 541.789 us
resource usage: 0 s user, 1.04806 s sys, 6.73074 s elapsed, (160000 min
+ 0 maj) pagefaults, 639971 + 7993 context switches

Starting test mmap sem congestion with mutex workaround (memset firstpage)
Test mmap sem congestion with mutex workaround (memset firstpage) ended
Timing mmap sem congestion with mutex workaround (memset firstpage):
elapsted time: 1.23567 s, 2.590 %user, 37.553 %sys
max 4039.39 us, average 30.887 us, stdev 61860.3 us
resource usage: 0.032 s user, 0.464025 s sys, 1.23567 s elapsed, (160000
min + 0 maj) pagefaults, 22335 + 53 context switches

Timings on Linux 2.6.30.4 Intel(R) Xeon(R) CPU E5405 @ 2.00GHz
--------------------------------------------------------------------------------------------------------------------------

Running tests with ntimings=100, nloops=100, nthreads=16, number of CPUs=8
Starting test mmap sem congestion (memset all)
Test mmap sem congestion (memset all) ended
Timing mmap sem congestion (memset all): elapsted time: 81.7756 s,
10.527 %user, 317.860 %sys
        max 4893.67 us, average 4088.78 us, stdev 23209.1 us
        resource usage: 8.60853 s user, 259.932 s sys, 81.7756 s
elapsed, (10240002 min + 0 maj) pagefaults, 5278414 + 16294 context switches

Starting test mmap sem congestion with mutex workaround (memset all)
Test mmap sem congestion with mutex workaround (memset all) ended
Timing mmap sem congestion with mutex workaround (memset all): elapsted
time: 55.312 s, 13.068 %user, 259.070 %sys
        max 5665.63 us, average 2765.6 us, stdev 527012 us
        resource usage: 7.22845 s user, 143.297 s sys, 55.312 s elapsed,
(10240000 min + 0 maj) pagefaults, 3351636 + 14707 context switches

Starting test mmap sem congestion (memset firstpage)
Test mmap sem congestion (memset firstpage) ended
Timing mmap sem congestion (memset firstpage): elapsted time: 6.08303 s,
0.526 %user, 51.951 %sys
        max 354.55 us, average 304.151 us, stdev 74.5072 us
        resource usage: 0.032 s user, 3.16019 s sys, 6.08303 s elapsed,
(160000 min + 0 maj) pagefaults, 639994 + 3959 context switches

Starting test mmap sem congestion with mutex workaround (memset firstpage)
Test mmap sem congestion with mutex workaround (memset firstpage) ended
Timing mmap sem congestion with mutex workaround (memset firstpage):
elapsted time: 1.15893 s, 6.558 %user, 90.088 %sys
        max 4767.38 us, average 57.9458 us, stdev 83782.6 us
        resource usage: 0.076001 s user, 1.04406 s sys, 1.15893 s
elapsed, (160000 min + 0 maj) pagefaults, 64700 + 29 context switches



--------------090700050602050408020507
Content-Type: text/x-csrc;
 name="scheduler.c"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename="scheduler.c"

/*
 *  Copyright (C) 2009 Török Edwin
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License version 2 as
 *  published by the Free Software Foundation.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
 *  MA 02110-1301, USA.
 */

/* 
 * Compile with: gcc scheduler.c  -Wall -lm -pthread -g -O2 
 */
#include <sys/mman.h>
#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>
#include <sys/time.h>
#include <stdint.h>
#include <stdint.h>
#include <sys/resource.h>
#include <pthread.h>
#include <math.h>
#include <unistd.h>
#include <string.h>
#define RUSAGE_THREAD 1 /* why isn't this in resource.h? */

static int32_t mmap_sem_congestion_all()
{
    void *data = mmap(NULL, 256*1024, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0);
    if (data == MAP_FAILED) {
	perror("mmap");
	abort();
    }
    madvise(data, 256*1024, MADV_RANDOM|MADV_DONTFORK);
    memset(data, 0x5a, 256*1024);
    munmap(data, 256*1024);
    return 1;
}

static int32_t mmap_sem_congestion_firstpage()
{
    void *data = mmap(NULL, 256*1024, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0);
    if (data == MAP_FAILED) {
	perror("mmap");
	abort();
    }
    madvise(data, 256*1024, MADV_RANDOM|MADV_DONTFORK);
    memset(data, 0x5a, 4096);
    munmap(data, 256*1024);
    return 1;
}

static pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;

static int32_t mmap_sem_congestion_mtx_all()
{
    pthread_mutex_lock(&mutex);
    void *data = mmap(NULL, 256*1024, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0);
    madvise(data, 256*1024, MADV_RANDOM|MADV_DONTFORK);
    pthread_mutex_unlock(&mutex);
    if (data == MAP_FAILED) {
	perror("mmap");
	abort();
    }
    memset(data, 0x5a, 256*1024);
    pthread_mutex_lock(&mutex);
    munmap(data, 256*1024);
    pthread_mutex_unlock(&mutex);
    return 1;
}

static int32_t mmap_sem_congestion_mtx_firstpage()
{
    pthread_mutex_lock(&mutex);
    void *data = mmap(NULL, 256*1024, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0);
    madvise(data, 256*1024, MADV_RANDOM|MADV_DONTFORK);
    memset(data, 0x5a, 4096);
    pthread_mutex_unlock(&mutex);
    if (data == MAP_FAILED) {
	perror("mmap");
	abort();
    }
    pthread_mutex_lock(&mutex);
    munmap(data, 256*1024);
    pthread_mutex_unlock(&mutex);
    return 1;
}


typedef int32_t (*foofunc)(void);
volatile int nodce;
struct result {
    long double average;
    long double sum;
    long double sum2;
    uint64_t tmax;
    uint64_t tmin;
    struct timeval elapsedtime;
    struct rusage rusage;
} result;

static pthread_mutex_t result_mutex = PTHREAD_MUTEX_INITIALIZER;

static void timeit(foofunc f, const char *name, unsigned ntimings, unsigned nloops)
{
    struct rusage rs0, rs1;
    struct timeval tv00, tv01;

    int64_t timings[ntimings], tmin,tmax;
    long double avg, sum2;
    int64_t sum=0;
    int32_t tmp=0;
    unsigned i, j;

    if (getrusage(RUSAGE_THREAD, &rs0) == -1) {
	perror("getrusage");
	abort();
    }
    gettimeofday(&tv00, NULL);
    for (j=0;j<ntimings;j++) {
	struct timeval tv0, tv1;
	gettimeofday(&tv0, NULL);
	for (i=0;i<nloops;i++)
	    tmp += f();
	gettimeofday(&tv1, NULL);
	nodce = tmp;
	timings[j] = (tv1.tv_usec - tv0.tv_usec) + (tv1.tv_sec - tv0.tv_sec)*1000000;
	sum += timings[j];
    }
    gettimeofday(&tv01, NULL);
    if (getrusage(RUSAGE_THREAD, &rs1) == -1) {
	perror("getrusage");
	abort();
    }
    avg = ((long double)sum) / ntimings / nloops;

    tmin=tmax=timings[0];
    sum2 = 0;
    for (j=0;j<ntimings;j++) {
	if (timings[j] > tmax)
	    tmax = timings[j];
	else if (timings[j] < tmin) {
	    tmin = timings[j];
	}
	long double t = timings[j]/nloops;
	sum2 += t*t;
    }
    pthread_mutex_lock(&result_mutex);
    result.average += avg;
    result.sum += sum/nloops;
    result.sum2 += sum2;
    result.elapsedtime.tv_sec += tv01.tv_sec - tv00.tv_sec;
    result.elapsedtime.tv_usec += tv01.tv_usec - tv00.tv_usec;
    if (tmax > result.tmax)
	result.tmax = tmax;
    if (tmin < result.tmin)
	result.tmin = tmin;
    result.rusage.ru_utime.tv_sec += rs1.ru_utime.tv_sec - rs0.ru_utime.tv_sec;
    result.rusage.ru_utime.tv_usec += rs1.ru_utime.tv_usec - rs0.ru_utime.tv_usec;
    result.rusage.ru_stime.tv_sec += rs1.ru_stime.tv_sec - rs0.ru_stime.tv_sec;
    result.rusage.ru_stime.tv_usec += rs1.ru_stime.tv_usec - rs0.ru_stime.tv_usec;
    result.rusage.ru_minflt += rs1.ru_minflt - rs0.ru_minflt;
    result.rusage.ru_majflt += rs1.ru_majflt - rs0.ru_majflt;
    result.rusage.ru_nvcsw += rs1.ru_nvcsw - rs0.ru_nvcsw;
    result.rusage.ru_nivcsw += rs1.ru_nivcsw - rs0.ru_nivcsw;
    pthread_mutex_unlock(&result_mutex);
}

struct data {
    const char *name;
    foofunc f;
    unsigned ntimings;
    unsigned nloops;
};

static void *thread(void* arg)
{
    struct data *data = (struct data*)arg;
    timeit(data->f, data->name, data->ntimings, data->nloops);
    return arg;
}
static int numcpu;
static void runtest(const char *name, foofunc f, unsigned ntimings, unsigned nloops, unsigned nthreads)
{
    unsigned i;
    pthread_t threads[nthreads];
    struct data data;
    data.name = name;
    data.f = f;
    data.ntimings = ntimings;
    data.nloops = nloops;
    printf("Starting test %s\n", name);
    memset(&result, 0, sizeof(result));
    for (i=0;i<nthreads;i++) {
	if (pthread_create(&threads[i], NULL, thread, (void*)&data) == -1) {
	    perror("pthread_create");
	    abort();
	}
    }
    for (i=0;i<nthreads;i++) {
	pthread_join(threads[i], NULL);
    }
    long double avg = result.average / nthreads;
    printf("Test %s ended\n", name);
    unsigned count = ntimings*nthreads;
    long double stdev = count*result.sum2 - result.sum*result.sum;
    stdev /= count*(count-1);
    long double elapsedtime = result.elapsedtime.tv_sec + result.elapsedtime.tv_usec/1000000.0;
    /* utime/stime */
    elapsedtime /= numcpu;
    long double utime = result.rusage.ru_utime.tv_sec + result.rusage.ru_utime.tv_usec/1000000.0;
    long double stime = result.rusage.ru_stime.tv_sec + result.rusage.ru_stime.tv_usec/1000000.0;
    double up = 100.0*utime/elapsedtime;
    double sp = 100.0*stime/elapsedtime;

    printf("Timing %s: elapsted time: %Lg s, %.3f %%user, %.3f %%sys\n", name, elapsedtime, up, sp);
    printf("\tmax %g us, average %Lg us, stdev %Lg us\n",
	   1.0*result.tmax/nloops, avg, stdev);
    printf("\tresource usage: %Lg s user, %Lg s sys, %Lg s elapsed, (%lu min + %lu maj) pagefaults, %lu + %lu context switches\n\n",
	   utime, stime, elapsedtime,
	   result.rusage.ru_minflt, result.rusage.ru_majflt,
	   result.rusage.ru_nvcsw, result.rusage.ru_nivcsw);
}


int main(int argc, char *argv[])
{
    numcpu = sysconf(_SC_NPROCESSORS_ONLN);
    if (numcpu == -1) {
	perror("sysconf(_SC_NPROCESSOR_ONLN)");
	abort();
    }
    unsigned ntimings=100, nloops=100, nthreads=16;
    if (argc > 2) {
	ntimings = atoi(argv[1]);
	if (argc > 3) {
	    nloops = atoi(argv[2]);
	    if (argc > 4) {
		nthreads = atoi(argv[3]);
	    }
	}
    }
    printf("Running tests with ntimings=%u, nloops=%u, nthreads=%u, number of CPUs=%u\n",
	   ntimings, nloops, nthreads, numcpu);
    runtest("mmap sem congestion (memset all)", mmap_sem_congestion_all, ntimings, nloops, nthreads);
    runtest("mmap sem congestion with mutex workaround (memset all)", mmap_sem_congestion_mtx_all, ntimings, nloops, nthreads);
    runtest("mmap sem congestion (memset firstpage)", mmap_sem_congestion_firstpage, ntimings, nloops, nthreads);
    runtest("mmap sem congestion with mutex workaround (memset firstpage)", mmap_sem_congestion_mtx_firstpage, ntimings, nloops, nthreads);
    return 0;
}

--------------090700050602050408020507--
