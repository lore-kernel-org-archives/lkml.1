Return-Path: <linux-kernel-owner+w=401wt.eu-S966076AbXDGQUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966076AbXDGQUs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 12:20:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966079AbXDGQUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 12:20:48 -0400
Received: from mail.gmx.net ([213.165.64.20]:40439 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S966076AbXDGQUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 12:20:46 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19SdbIntipSSev0YRe5/fmxqaObvEfwzmR/SOhhsM
	61eICvnIhrxoIQ
Subject: SD scheduler testing hitch
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Con Kolivas <kernel@kolivas.org>
In-Reply-To: <20070407092401.GB16356@elte.hu>
References: <b647ffbd0704040704k2e4b3abcyfadc7662dff37f5b@mail.gmail.com>
	 <20070404141546.GA862@elte.hu>
	 <b647ffbd0704041305t2a140369q56cf9f0746b8fd86@mail.gmail.com>
	 <20070406170319.2c961eba.akpm@linux-foundation.org>
	 <20070407092401.GB16356@elte.hu>
Content-Type: multipart/mixed; boundary="=-c9FqSQMMRC2VIMd3ZjsD"
Date: Sat, 07 Apr 2007 18:20:40 +0200
Message-Id: <1175962840.10478.49.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-c9FqSQMMRC2VIMd3ZjsD
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Sat, 2007-04-07 at 11:24 +0200, Ingo Molnar wrote:
> * Andrew Morton <akpm@linux-foundation.org> wrote:

> > Where are we at with staircase anyway?  Is it looking like a 2.6.22 
> > thing? I don't personally think we've yet seen enough serious 
> > performance testing to permit a merge, apart from other issues...
> 
> yes, that's my thinking too at the moment. I'd also like to see a 
> summary of 'open design questions' list from Mike (if Mike has 
> time/energy for that?) - many questions were raised, a good number of 
> them were answered, various changes done to SD but there's no good 
> summary of the current state of affairs.

I'm working on it. I started testing fairness, but ran into a snag.

What I was testing was my theory that SD can't possibly be fair to
sleeping tasks because the differential between long burn short sleep
tasks and long sleep short burn tasks is tossed at the end of every
rotation.  That theory seems to be true, but here's the snag...

2.6.21-rc6-sd-0.39, box is 3GHz P4/HT

tenpercent: tenpercent.c compiled to run 1 10% duty cycle task.
100ms and friends:  tenpercent.c hard coded for N ms burn + 1 usec sleep.

taskset -c 1 ./tenpercent
taskset -c 1 ./100ms (or ilk)

top - 10:47:57 up  3:11, 13 users,  load average: 1.65, 1.63, 2.50

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  P COMMAND
 7357 root       9   0  1568  440  360 R   92  0.0  10:55.01 1 100ms
 7356 root       1   0  1568  444  360 S    8  0.0   1:00.01 1 tenpercent
 5557 root       1   0  164m  21m 4876 S    0  2.1   1:58.90 0 Xorg
 6343 root       3   0  2376 1068  768 R    0  0.1   2:51.19 0 top

top - 11:05:16 up  3:29, 13 users,  load average: 1.52, 1.50, 1.81

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  P COMMAND
 7395 root       5   0  1568  444  360 R   90  0.0   8:54.25 1 100ms
 7394 root       0 -10  1568  440  360 S   10  0.0   1:00.21 1 tenpercent
 6343 root       3   0  2376 1068  768 R    0  0.1   3:04.16 0 top
    1 root       1   0   736  288  240 S    0  0.0   0:00.90 0 init

top - 11:20:58 up  3:44, 13 users,  load average: 1.89, 1.87, 1.78

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  P COMMAND
 7429 root       2 -10  1568  444  360 R   92  0.0  12:03.81 1 100ms
 7428 root       0 -10  1568  444  360 R    8  0.0   1:00.08 1 tenpercent
 6343 root       3   0  2376 1068  768 R    1  0.1   3:19.36 0 top
    1 root       1   0   736  288  240 S    0  0.0   0:00.90 0 init

top - 12:22:27 up  4:46, 13 users,  load average: 1.90, 1.92, 1.94

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  P COMMAND
 8235 root       1 -20  1568  444  360 R   95  0.0  19:31.20 1 100ms
 8234 root       0 -20  1568  444  360 S    5  0.0   1:00.01 1 tenpercent
 6343 root       3   0  2376 1068  768 R    1  0.1   4:24.24 0 top
 4926 root       1   0  1820  632  544 S    0  0.1   0:02.34 0 hald-addon-stor

top - 13:38:22 up  6:02, 13 users,  load average: 1.53, 1.51, 1.51

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  P COMMAND
 8643 root       5   0  1564  444  360 R   93  0.0  12:15.49 1 50ms
 8642 root       1   0  1564  444  360 S    7  0.0   1:00.28 1 tenpercent
 6343 root       3   0  2376 1080  768 R    0  0.1   5:27.22 0 top
    1 root       1   0   736  288  240 S    0  0.0   0:00.91 0 init

top - 14:02:39 up  6:26, 13 users,  load average: 1.75, 1.71, 1.56

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  P COMMAND
 8726 root       5   0  1564  444  360 R   94  0.0  15:19.07 1 8ms
 8727 root       1   0  1564  444  360 R    6  0.0   1:00.11 1 tenpercent
 5557 root       1   0  164m  21m 4632 S    0  2.1   3:20.92 0 Xorg
 6079 root       1   0 31584  17m  12m S    0  1.7   0:04.35 0 konsole

top - 16:22:01 up  8:45, 13 users,  load average: 1.73, 1.81, 1.60

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  P COMMAND
  10622 root       1   0  1428  264  212 R   98  0.0  10:00.43 1 xx
  10621 root       1   0  1564  440  360 S    1  0.0   0:06.49 1 tenpercent
  10423 root       3   0  2248 1052  764 R    0  0.1   0:27.45 0 top
      1 root       1   0   736  288  240 S    0  0.0   0:00.91 0 init

xx.c just tries to terminate the rotation if it gets preempted, and
seems to succeed.  It usually isn't this bad, but every few starts it
gets this bad.  I thought it might be screwing up the calibration of
tenpercent if xx started first, but I plugged it into tenp.c (attached)
after the calibration, and still see this every few starts.  It always
gets more cpu than it should, but sometimes it's extreme.

I have yet to see tenpercent start at 1 percent usage in many many
tries, but I just repeated it with the attached in seven tries.

xx.c

#include <stdio.h>
#include <sys/time.h>

#define max(a,b) ((a) > (b) ? (a) : (b))
#define min(a,b) ((a) < (b) ? (a) : (b))

int main(void)
{
    struct timeval then, now;
    struct timespec t = {0, 1000}, r;

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
        if (t2 - t1 >= 1000 && nanosleep(&t, &r))
            break;
    }
    return 0;
}

--=-c9FqSQMMRC2VIMd3ZjsD
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
    struct timespec t = {0, 1000}, r;

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
        if (t2 - t1 >= 1000 && nanosleep(&t, &r))
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

--=-c9FqSQMMRC2VIMd3ZjsD--

