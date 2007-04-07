Return-Path: <linux-kernel-owner+w=401wt.eu-S966129AbXDGRRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966129AbXDGRRm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 13:17:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966131AbXDGRRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 13:17:42 -0400
Received: from mail.gmx.net ([213.165.64.20]:33309 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S966129AbXDGRRl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 13:17:41 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18gZykK7jkg1wuRTdgGD5ovYW88OAOycDnk74x/3c
	rUlAObZro/bl8q
Subject: Re: SD scheduler testing hitch
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Con Kolivas <kernel@kolivas.org>
In-Reply-To: <1175962840.10478.49.camel@Homer.simpson.net>
References: <b647ffbd0704040704k2e4b3abcyfadc7662dff37f5b@mail.gmail.com>
	 <20070404141546.GA862@elte.hu>
	 <b647ffbd0704041305t2a140369q56cf9f0746b8fd86@mail.gmail.com>
	 <20070406170319.2c961eba.akpm@linux-foundation.org>
	 <20070407092401.GB16356@elte.hu>
	 <1175962840.10478.49.camel@Homer.simpson.net>
Content-Type: multipart/mixed; boundary="=-ORFsABSSjRV50v/h33VR"
Date: Sat, 07 Apr 2007 19:17:35 +0200
Message-Id: <1175966255.11408.5.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ORFsABSSjRV50v/h33VR
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Sat, 2007-04-07 at 18:20 +0200, Mike Galbraith wrote:

> xx.c
> 
> #include <stdio.h>
> #include <sys/time.h>
> 
> #define max(a,b) ((a) > (b) ? (a) : (b))
> #define min(a,b) ((a) < (b) ? (a) : (b))
> 
> int main(void)
> {
>     struct timeval then, now;
>     struct timespec t = {0, 1000}, r;
> 
>     for(;;) {
>         int t1, t2;
>         short i;
> 
>         if (gettimeofday(&then, 0))
>             break;
>         for (i = 1; i > 0; i++);
>         if (gettimeofday(&now, 0))
>             break;
>         t2 = max(then.tv_usec, now.tv_usec);
>         t1 = min(then.tv_usec, now.tv_usec);
>         if (t2 - t1 >= 1000 && nanosleep(&t, &r))
>             break;
>     }
>     return 0;
> }

I lowered the time to 500us, and ran at nice -10.. it starves tenpercent
here every time.  (ran as taskset -c 1 nice -n -10 ./fairtest)  The
starving 10% duty cycle task has trouble getting 1% CPU.

	-Mike

--=-ORFsABSSjRV50v/h33VR
Content-Disposition: attachment; filename=fairtest.c
Content-Type: text/x-csrc; name=fairtest.c; charset=us-ascii
Content-Transfer-Encoding: 7bit

// gcc -O2 -o tenp tenp.c -lrt
// code from interbench.c
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>
#include <errno.h>
#include <sys/types.h>
/*
 * Start $forks processes that run for 10% cpu time each. Set this to
 * 15 * number of cpus for best effect.
 */
int forks = 1;

unsigned long run_us = 1000000000, sleep_us;
unsigned long loops_per_ms;

void terminal_error(const char *name)
{
	fprintf(stderr, "\n");
	perror(name);
	exit (1);
}

unsigned long long get_nsecs(struct timespec *myts)
{
	if (clock_gettime(CLOCK_REALTIME, myts))
		terminal_error("clock_gettime");
	return (myts->tv_sec * 1000000000 + myts->tv_nsec );
}

void burn_loops(unsigned long loops)
{
	unsigned long i;

	/*
	 * We need some magic here to prevent the compiler from optimising
	 * this loop away. Otherwise trying to emulate a fixed cpu load
	 * with this loop will not work.
	 */
	for (i = 0 ; i < loops ; i++)
	     asm volatile("" : : : "memory");
}

/* Use this many usecs of cpu time */
void burn_usecs(unsigned long usecs)
{
	unsigned long ms_loops;

	ms_loops = loops_per_ms / 1000 * usecs;
	burn_loops(ms_loops);
}

void microsleep(unsigned long long usecs)
{
	struct timespec req, rem;

	rem.tv_sec = rem.tv_nsec = 0;

	req.tv_sec = usecs / 1000000;
	req.tv_nsec = (usecs - (req.tv_sec * 1000000)) * 1000;
continue_sleep:
	if ((nanosleep(&req, &rem)) == -1) {
		if (errno == EINTR) {
			if (rem.tv_sec || rem.tv_nsec) {
				req.tv_sec = rem.tv_sec;
				req.tv_nsec = rem.tv_nsec;
				goto continue_sleep;
			}
			goto out;
		}
		terminal_error("nanosleep");
	}
out:
	return;
}

/*
 * In an unoptimised loop we try to benchmark how many meaningless loops
 * per second we can perform on this hardware to fairly accurately
 * reproduce certain percentage cpu usage
 */
void calibrate_loop(void)
{
	unsigned long long start_time, loops_per_msec, run_time = 0,
		min_run_us = run_us;
	unsigned long loops;
	struct timespec myts;
	int i;

	printf("Calibrating loop\n");
	loops_per_msec = 1000000;
redo:
	/* Calibrate to within 1% accuracy */
	while (run_time > 1010000 || run_time < 990000) {
		loops = loops_per_msec;
		start_time = get_nsecs(&myts);
		burn_loops(loops);
		run_time = get_nsecs(&myts) - start_time;
		loops_per_msec = (1000000 * loops_per_msec / run_time ? :
			loops_per_msec);
	}

	/* Rechecking after a pause increases reproducibility */
	microsleep(1);
	loops = loops_per_msec;
	start_time = get_nsecs(&myts);
	burn_loops(loops);
	run_time = get_nsecs(&myts) - start_time;

	/* Tolerate 5% difference on checking */
	if (run_time > 1050000 || run_time < 950000)
		goto redo;
	loops_per_ms=loops_per_msec;
	printf("Calibrating sleep interval\n");
	microsleep(1);
	/* Find the smallest time interval close to 1ms that we can sleep */
	for (i = 0; i < 100; i++) {
		start_time=get_nsecs(&myts);
		microsleep(1000);
		run_time=get_nsecs(&myts)-start_time;
		run_time /= 1000;
		if (run_time < run_us && run_us > 1000)
			run_us = run_time;
	}
	/* Then set run_us to that duration and sleep_us to 9 x that */
	sleep_us = run_us * 9;
	printf("Calibrating run interval\n");
	microsleep(1);
	/* Do a few runs to see what really gets us run_us runtime */
	for (i = 0; i < 100; i++) {
		start_time=get_nsecs(&myts);
		burn_usecs(run_us);
		run_time=get_nsecs(&myts)-start_time;
		run_time /= 1000;
		if (run_time < min_run_us && run_time > run_us)
			min_run_us = run_time;
	}
	if (min_run_us < run_us)
		run_us = run_us * run_us / min_run_us;
	printf("Each fork will run for %lu usecs and sleep for %lu usecs\n",
		run_us, sleep_us);
}


#define max(a,b) ((a) > (b) ? (a) : (b))
#define min(a,b) ((a) < (b) ? (a) : (b))

void steal(void)
{
    struct timeval then, now;
    struct timespec t = {0, 500}, r;

    for(;;) {
        int t1, t2;
        short i;

        if (gettimeofday(&then, 0))
            break;
        for (i = 1; i > 0; i++);
        if (gettimeofday(&now, 0))
            break;
        t2 = max(then.tv_usec, now.tv_usec);
        t1 = min(then.tv_usec, now.tv_usec);
        if (t2 - t1 >= 500 && nanosleep(&t, &r))
            break;
    }
}

int main(void){
	int i, child;

	calibrate_loop();
	printf("starting %d forks\n", forks);
	for(i = 0; i < forks; i++){
		if(!(child = fork()))
			break;
	}
        if (child)
            steal();
	else while(1){
		burn_usecs(run_us);
		microsleep(sleep_us);
	}
	return 0;
}

--=-ORFsABSSjRV50v/h33VR--

