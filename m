Return-Path: <linux-kernel-owner+w=401wt.eu-S1767352AbXDFBEB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767352AbXDFBEB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 21:04:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992882AbXDFBEB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 21:04:01 -0400
Received: from mail28.syd.optusnet.com.au ([211.29.133.169]:45858 "EHLO
	mail28.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2992877AbXDFBD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 21:03:59 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Ingo Molnar <mingo@elte.hu>
Subject: Ten percent test
Date: Fri, 6 Apr 2007 11:03:33 +1000
User-Agent: KMail/1.9.5
Cc: Mike Galbraith <efault@gmx.de>, linux list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>
References: <200703290237.38777.kernel@kolivas.org> <1175770950.6609.16.camel@Homer.simpson.net> <20070405115447.GA24138@elte.hu>
In-Reply-To: <20070405115447.GA24138@elte.hu>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 1317
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_mxZFGSkitLWdPci"
Message-Id: <200704061103.34489.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_mxZFGSkitLWdPci
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thursday 05 April 2007 21:54, Ingo Molnar wrote:
>  - fiftyp.c:  noticeable, but alot better than previously!

fiftyp.c seems to have been stumbled across by accident as having an effect 
when Xenofon was trying to recreate Mike's 50% x 3 test case. I suggest a ten 
percent version like the following would be more useful as a test for the 
harmful effect discovered in fiftyp.c. (/me throws in obligatory code style 
change).

Starts 15 processes that sleep ten times longer than they run. Change forks to 
15 times the number of cpus you have and it should work on any size hardware.

-- 
-ck

--Boundary-00=_mxZFGSkitLWdPci
Content-Type: text/x-csrc;
  charset="iso-8859-1";
  name="tenp.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="tenp.c"

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
int forks = 15;

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

int main(void){
	int i;

	calibrate_loop();
	printf("starting %d forks\n", forks);
	for(i = 1; i < forks; i++){
		if(!fork())
			break;
	}
	while(1){
		burn_usecs(run_us);
		microsleep(sleep_us);
	}
	return 0;
}

--Boundary-00=_mxZFGSkitLWdPci--
