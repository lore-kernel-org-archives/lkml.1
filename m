Return-Path: <linux-kernel-owner+w=401wt.eu-S1752179AbXLEQRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179AbXLEQRY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 11:17:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751309AbXLEQRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 11:17:16 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:59443 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbXLEQRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 11:17:15 -0500
Message-ID: <4756CEEE.9050908@cosmosbay.com>
Date: Wed, 05 Dec 2007 17:16:46 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jie Chen <chen@jlab.org>, Simon Holm Th??gersen <odie@cs.aau.dk>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Possible bug from kernel 2.6.22 and above, 2.6.24-rc4
References: <4744966C.900@jlab.org> <4744ADA9.7040905@cosmosbay.com> <4744E0DC.7050808@jlab.org> <1195698770.11808.4.camel@odie.local> <4744F042.4070002@jlab.org> <20071204131707.GA4232@elte.hu> <4756C3D9.9030107@jlab.org> <20071205154014.GA6491@elte.hu>
In-Reply-To: <20071205154014.GA6491@elte.hu>
Content-Type: multipart/mixed;
 boundary="------------060101060503040905040604"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Wed, 05 Dec 2007 17:16:54 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060101060503040905040604
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

Ingo Molnar a écrit :
> * Jie Chen <chen@jlab.org> wrote:
> 
>> I just ran the same test on two 2.6.24-rc4 kernels: one with 
>> CONFIG_FAIR_GROUP_SCHED on and the other with CONFIG_FAIR_GROUP_SCHED 
>> off. The odd behavior I described in my previous e-mails were still 
>> there for both kernels. Let me know If I can be any more help. Thank 
>> you.
> 
> ok, i had a look at your data, and i think this is the result of the 
> scheduler balancing out to idle CPUs more agressively than before. Doing 
> that is almost always a good idea though - but indeed it can result in 
> "bad" numbers if all you do is to measure the ping-pong "performance" 
> between two threads. (with no real work done by any of them).
> 
> the moment you saturate the system a bit more, the numbers should 
> improve even with such a ping-pong test.
> 
> do you have testcode (or a modification of your testcase sourcecode) 
> that simulates a real-life situation where 2.6.24-rc4 performs not as 
> well as you'd like it to see? (or if qmt.tar.gz already contains that 
> then please point me towards that portion of the test and how i should 
> run it - thanks!)
> 
> 	Ingo

I cooked a program shorter than Jie one, to try to understand what was going 
on. Its a pure cpu burner program, with no thread synchronisation (but the 
pthread_join at the very end)

As each thread is bound to a given cpu, I am not sure the scheduler is allowed 
to balance to an idle cpu.

Unfortunatly I dont have a 4 way SMP idle machine available to
test it.

$ gcc -O2 -o burner burner.c
$ ./burner
Time to perform the unit of work on one thread is 0.040328 s
Time to perform the unit of work on 2 threads is 0.040221 s

I tried it on a 64 way machine (Thanks David :) ) and noticed some strange
results that may be related to the Niagara hardware (time for 64 threads was 
nearly the double for one thread)


--------------060101060503040905040604
Content-Type: text/plain;
 name="burner.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="burner.c"

#include <pthread.h>
#include <sched.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/time.h>
#include <stdio.h>
#include <stdlib.h>

int blockthemall=1;
static void inline cpupause()
{
#if defined(i386)
 asm volatile("rep;nop":::"memory");
#else
 asm volatile("":::"memory");
#endif
}
/*
 * Determines number of cpus
 * Can be overiden by the NR_CPUS environment variable
 */
int number_of_cpus()
{
	char line[1024], *p;
	int cnt = 0;
	FILE *F;

	p = getenv("NR_CPUS");
	if (p)
		return atoi(p);
	F = fopen("/proc/cpuinfo", "r");
	if (F == NULL) {
		perror("/proc/cpuinfo");
		return 1;
	}
	while (fgets(line, sizeof(line), F) != NULL) {
		if (memcmp(line, "processor", 9) == 0)
			cnt++;
	}
	fclose(F);
	return cnt;
}

void compute_elapsed(struct timeval *delta, const struct timeval *t0)
{
	struct timeval t1;

	gettimeofday(&t1, NULL);
	delta->tv_sec = t1.tv_sec - t0->tv_sec;
	delta->tv_usec = t1.tv_usec - t0->tv_usec;
	if (delta->tv_usec < 0) {
		delta->tv_usec += 1000000;
		delta->tv_sec--;
	}
}

int nr_loops = 20*1000000;
double incr=0.3456;
void perform_work()
{
	int i;
	double t = 0.0;
	for (i = 0; i < nr_loops; i++) {
		t += incr;
		}
	if (t < 0.0) printf("well... should not happen\n");
}

void set_affinity(int cpu)
{
	long cpu_mask;
	int res;

	cpu_mask = 1L << cpu;
	res = sched_setaffinity(0, sizeof(cpu_mask), &cpu_mask);
	if (res)
		perror("sched_setaffinity");
}

void *thread_work(void *arg)
{
	int cpu = (int)arg;
	set_affinity(cpu);
	while (blockthemall)
		cpupause();
	perform_work();
	return (void *)0;
}

main(int argc, char *argv[])
{
	struct timeval t0, delta;
	int nr_cpus, i;
	pthread_t *tids;

	gettimeofday(&t0, NULL);
	perform_work();
	compute_elapsed(&delta, &t0);
	printf("Time to perform the unit of work on one thread is %d.%06d s\n", delta.tv_sec, delta.tv_usec);

	nr_cpus = number_of_cpus();
	if (nr_cpus <= 1)
		return 0;
	tids = malloc(nr_cpus * sizeof(pthread_t));
	for (i = 1; i < nr_cpus; i++) {
		pthread_create(tids + i, NULL, thread_work, (void *)i);
	}

	set_affinity(0);
	gettimeofday(&t0, NULL);
	blockthemall=0;
	perform_work();
	for (i = 1; i < nr_cpus; i++)
		pthread_join(tids[i], NULL);
	compute_elapsed(&delta, &t0);
	printf("Time to perform the unit of work on %d threads is %d.%06d s\n", nr_cpus, delta.tv_sec, delta.tv_usec);
	
}

--------------060101060503040905040604--
