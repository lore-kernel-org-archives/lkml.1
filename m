Return-Path: <linux-kernel-owner+w=401wt.eu-S932624AbXHaJha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932624AbXHaJha (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 05:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756774AbXHaJhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 05:37:19 -0400
Received: from mail.gmx.net ([213.165.64.20]:49171 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756625AbXHaJhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 05:37:17 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX186CLMcMck6SCOX1nIBB/RdmEI87pDc7/bgTvXYDe
	T2XdNcCjm2KqC6
Subject: Re: [ANNOUNCE/RFC] Really Fair Scheduler
From: Mike Galbraith <efault@gmx.de>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org
In-Reply-To: <Pine.LNX.4.64.0708310139280.1817@scrub.home>
References: <Pine.LNX.4.64.0708310139280.1817@scrub.home>
Content-Type: multipart/mixed; boundary="=-6nQIXxjA+EzUIE19+36M"
Date: Fri, 31 Aug 2007 11:36:55 +0200
Message-Id: <1188553015.8061.36.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-6nQIXxjA+EzUIE19+36M
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Fri, 2007-08-31 at 04:05 +0200, Roman Zippel wrote:
> Hi,

Greetings,

> I'm glad to announce a working prototype of the basic algorithm I
> already suggested last time.

(finding it difficult to resist the urge to go shopping, I
fast-forwarded to test drive... grep shopping arch/i386/kernel/tcs.c if
you're curious;)

I plunked it into 2.6.23-rc4 to see how it reacts to various sleeper
loads, and hit some starvation.  If I got it in right (think so) there's
a bug lurking somewhere.  taskset -c 1 fairtest2 resulted in the below.
It starts up running both tasks at about 60/40 for hog/sleeper, then
after a short while goes nuts.  The hog component eats 100% cpu and
starves the sleeper (and events, forever).

runnable tasks:
            task   PID        tree-key         delta       waiting  switches  prio        sum-exec        sum-wait       sum-sleep    wait-overrun   wait-underrun
------------------------------------------------------------------------------------------------------------------------------------------------------------------
        events/1     8  13979193020350 -3984516524180  541606276813      2014   115               0               0               0               0               0
R      fairtest2  7984  10027571241955 -7942765479096 5707836335486       294   120               0               0               0               0               0
       fairtest2  7989  13539381091732 -4424328443109 8147144513458       286   120               0               0               0               0               0

taskset -c 1 massive_intr 3 9999 produces much saner looking numbers,
and is fair...

runnable tasks:
            task   PID        tree-key         delta       waiting  switches  prio        sum-exec        sum-wait       sum-sleep    wait-overrun   wait-underrun
------------------------------------------------------------------------------------------------------------------------------------------------------------------
    massive_intr 12808  29762662234003         21699       -506538      4650   120               0               0               0               0               0
R   massive_intr 12809  29762662225939          -687         53406      4633   120               0               0               0               0               0
    massive_intr 12810  29762662220183          7879        453097      4619   120               0               0               0               0               0


--=-6nQIXxjA+EzUIE19+36M
Content-Disposition: attachment; filename=fairtest2.c
Content-Type: text/x-csrc; name=fairtest2.c; charset=us-ascii
Content-Transfer-Encoding: 7bit

// gcc -O2 -o fiftyp fiftyp.c -lrt
// code from interbench.c
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/resource.h>
int forks=1;
int runus,sleepus=7000;
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
	unsigned long long start_time, loops_per_msec, run_time = 0;
	unsigned long loops;
	struct timespec myts;

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
	sleep(1);
	loops = loops_per_msec;
	start_time = get_nsecs(&myts);
	burn_loops(loops);
	run_time = get_nsecs(&myts) - start_time;

	/* Tolerate 5% difference on checking */
	if (run_time > 1050000 || run_time < 950000)
		goto redo;
 loops_per_ms=loops_per_msec;
 sleep(1);
 start_time=get_nsecs(&myts);
 microsleep(sleepus);
 run_time=get_nsecs(&myts)-start_time;
 runus=run_time/1000;
}

/*
 * chew.c: original idea by Chris Friesen.  Thanks.
 */

#define THRESHOLD_USEC 2000

unsigned long long stamp()
{
        struct timeval tv;
        gettimeofday(&tv, 0);
        return (unsigned long long) tv.tv_usec + ((unsigned long long) tv.tv_sec)*1000000;
}

int chew()
{
        unsigned long long thresh_ticks = THRESHOLD_USEC;
        unsigned long long cur, last, start, act;
        struct timespec ts;

        sched_rr_get_interval(0, &ts);
        printf("pid %d, prio %3d, interval of %d nsec\n", getpid(), getpriority(PRIO_PROCESS, 0), ts.tv_nsec);

        start = last = stamp();
        while(1) {
                cur = stamp();
                unsigned long long delta = cur-last;
                if (delta > thresh_ticks) {
			act = last - start;
                        printf("pid %d, prio %3d, out for %4llu ms, ran for %4llu ms, load %3llu%\n"
			, getpid(), getpriority(PRIO_PROCESS, 0), delta/1000, act/1000,(act*100)/(cur-start));
                        start = cur = stamp();
                }
                last = cur;
        }

        return 0;
}

int main(void){
 int i, chewpid = getpid();
 calibrate_loop();
 printf("starting %d forks\n",forks);
 for(i=0;i<forks;i++){
  if(!fork())
   break;
 }
 if (chewpid == getpid())
    chew();
 else while(1){
  burn_usecs(runus);
  microsleep(sleepus);
 }
 return 0;
}

--=-6nQIXxjA+EzUIE19+36M--

