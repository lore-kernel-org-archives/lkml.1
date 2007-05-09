Return-Path: <linux-kernel-owner+w=401wt.eu-S1757367AbXEIRye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367AbXEIRye (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 13:54:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756339AbXEIRy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 13:54:27 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:34876 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756042AbXEIRy0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 13:54:26 -0400
Date: Wed, 9 May 2007 23:32:05 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, tingy@cs.umass.edu, tong.n.li@intel.com
Subject: Definition of fairness (was Re: [patch] CFS scheduler, -v11)
Message-ID: <20070509180205.GA27462@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070508150431.GA26977@elte.hu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="TB36FDmn/VVEgNH/"
Content-Disposition: inline
In-Reply-To: <20070508150431.GA26977@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 08, 2007 at 05:04:31PM +0200, Ingo Molnar wrote:
> thanks Mike - value 0x8 looks pretty good here and doesnt have the 
> artifacts you found. I've done a quick -v11 release with that fixed, 
> available at the usual place:
> 
>     http://people.redhat.com/mingo/cfs-scheduler/
> 
> with no other changes.

Ingo,
	I had a question with respect to the definition of fairness used, esp
for tasks that are not 100% cpu hogs.

Ex: consider two equally important tasks T1 and T2 running on same CPU and 
whose execution nature is:

	T1 = 100% cpu hog
	T2 = 60% cpu hog (run for 600ms, sleep for 400ms)

Over a arbitrary observation period of 10 sec, 

	T1 was ready to run for all 10sec
	T2 was ready to run for 6 sec

Over this observation period, how much execution time should T2 get,
under a "fair" scheduler?

I was expecting both T2 and T1 to get 5 sec (50:50 split). Is this a
wrong expectation of fairness?

Anyway, results of this experiment (using testcase attached) is below.
T2 gets way below its fair share IMO (under both cfs and sd).


2.6.21.1:

 5444 vatsa     16   0  2468  460  388 R   59  0.0   0:19.76 3 T1
 5443 vatsa     25   0  2468  460  388 R   40  0.0   0:15.36 3 T2


2.6.21.1 + cfs-v11:

 5460 vatsa     31   0  2464  460  388 R   70  0.0   0:15.28 3 T1
 5461 vatsa     29   0  2468  460  388 R   30  0.0   0:05.65 3 T2


2.6.21 + sd-0.48:

 5459 vatsa     23   0  2468  460  388 R   70  0.0   0:17.02 3 T1
 5460 vatsa     21   0  2464  460  388 R   30  0.0   0:06.21 3 T2


Note: 

T1 is started as ./cpuhog 600 0 10 > /dev/null &
T2 is started as ./cpuhog 600 400 10 > /dev/null &

First arg = runtime in ms
Second arg = sleeptime in ms
Third arg = Observation period in seconds


-- 
Regards,
vatsa

--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="cpuhog.c"


#include <unistd.h>
#include <stdio.h>
#include <sys/time.h>
#include <sys/resource.h>

double loops_per_ms;

double elapsed_time(struct timeval *tv1, struct timeval *tv2)
{
	double d1, d2;
	int elapsed_ms;

	d1 = tv1->tv_sec + tv1->tv_usec * 1e-6;
	d2 = tv2->tv_sec + tv2->tv_usec * 1e-6;
	elapsed_ms = (d2 - d1) * 1000;

	return elapsed_ms;
}

void calibrate_delay(void)
{
	int i;
	double elapsed_ms;
	struct timeval tv1, tv2;

	gettimeofday(&tv1, NULL);
#define LOOP_COUNT 100000000
	for (i=0; i < LOOP_COUNT; ++i)
		;
	gettimeofday(&tv2, NULL);
	elapsed_ms = elapsed_time(&tv1, &tv2);
	loops_per_ms = LOOP_COUNT / elapsed_ms;

	printf ("loops_per_ms = %f \n", loops_per_ms);
}

int run_length  = 52; 	// in milliseconds
int sleep_length = 24;	// in milliseconds
int epoch_time = 5;	// in seconds

main(int argc, char *argv[])
{
	long int i, delay;
	time_t prevtime;
	double prevusage = 0;
	struct rusage stats;

	if (argc > 1) {
		run_length = atoi(argv[1]);
		if (argc > 2)
			sleep_length = atoi(argv[2]);
		if (argc > 3)
			epoch_time = atoi(argv[3]);
	}

	calibrate_delay();

	delay = run_length * loops_per_ms;

	printf ("run time = %d ms (%ld loops), sleep time = %d ms,"
		" epoch time = %d s\n", run_length, delay, sleep_length,
		 epoch_time);

	prevtime = time(NULL);
	while (1) {
		time_t curtime, deltatime;
		struct rusage stats;

		for (i = 0; i < delay; ++i)
			;
		usleep(sleep_length * 1000);

		curtime = time(NULL);
		deltatime = curtime - prevtime;
		if (deltatime >= epoch_time) {
			double curusage, deltausage;

			getrusage(0, &stats);
			curusage = stats.ru_utime.tv_sec +
				   stats.ru_utime.tv_usec * 1e-6 +
				   stats.ru_stime.tv_sec + 
				   stats.ru_stime.tv_usec * 1e-6;

			deltausage = curusage - prevusage;
			printf ("Obtained %3.2f seconds of execution time in"
		       	      " %d elapsed seconds \n", deltausage, deltatime);
			prevtime = curtime;
			prevusage = curusage;
		}
	}
}

--TB36FDmn/VVEgNH/--
