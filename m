Return-Path: <linux-kernel-owner+w=401wt.eu-S1754707AbZLBI3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707AbZLBI3T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 03:29:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754348AbZLBI3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 03:29:19 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52239 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbZLBI3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 03:29:18 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4B162551.7050303@jp.fujitsu.com>
Date: Wed, 02 Dec 2009 17:29:05 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Spencer Candland <spencer@bluehost.com>,
       =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
       linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
       Balbir Singh <balbir@in.ibm.com>
Subject: reproducer: utime decreasing
References: <4AFB9029.9000208@jp.fujitsu.com> <20091112144919.GA6218@dhcp-lab-161.englab.brq.redhat.com> <1258038038.4039.467.camel@laptop> <20091112154050.GC6218@dhcp-lab-161.englab.brq.redhat.com> <4B01A8DB.6090002@bluehost.com> <20091117130851.GA3842@dhcp-lab-161.englab.brq.redhat.com> <1258464288.7816.305.camel@laptop> <20091119181744.GA3743@dhcp-lab-161.englab.brq.redhat.com> <4B05F835.10401@jp.fujitsu.com> <20091123100925.GB25978@dhcp-lab-161.englab.brq.redhat.com> <20091123101612.GC25978@dhcp-lab-161.englab.brq.redhat.com>
In-Reply-To: <20091123101612.GC25978@dhcp-lab-161.englab.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following is a sample program that can reproduce the problem
in several ways.

I tested my patch using this reproducer, and confirmed that
applying both of Stanislaw's do_sys_times() patch and my
thread_group_times() patch is required to fix the problem.


Thanks,
H.Seto

===
/*
 * Sample program to demonstrate time decreasing on thread exit
 */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <pthread.h>
#include <sys/times.h>

#define DEFAULT_THREADS 500

unsigned long lpt;
int looptype;
int samplesleep;
int threads;

void *child (void *thread_id)
{
	struct tms t[12];
  	int i, j;
	unsigned long ret = 0, id = (unsigned long)thread_id;

	if (looptype) {
		/*
		 * discont:
		 *
		 *  Loop tricky, to make a significant gap between
		 *  task->{u,s}time and task_times().
		 *
		 *	runtime of a thread  = 0.5 tick * 1000 = 500 ms
		 *	task->{u,s}time	     = (??? , 0)
		 *	task_times()         = ideally (500, 0)
		 */
		for (j = 0; j < 1000; j++) {
			for (i = 0; i < lpt/2; i++)
				;
			usleep(0);
		}
	} else {
		/*
		 * cont:
		 *
		 *  Loop without tricks.
		 *
		 *	runtime of a thread  = 500 ms
		 *	task->{u,s}time      = (500, 0)
		 *	task_times()         = (500, 0)
		 */
		for (i = 0; i < lpt * 500; i++)
			;
	}

	if (!(id % 4))
		/* bother other threads */
		pthread_exit((void *)ret);

	for (i = 0; i < 12; i++) {
		times(&t[i]);
		if (samplesleep)
			usleep(0);
	}

	for (i = 0; i + 5 < 12; i++) {
		/*
		 *  +----+----+----+----+----+
		 * i+0  i+1  i+2  i+3  i+4  i+5
		 *            ^^^^^^
		 *          check here
		 */
		if (t[i+2].tms_utime > t[i+3].tms_utime
		    || t[i+2].tms_stime > t[i+3].tms_stime) {

		   printf("[%4ld] %s decreased %3d: "
			  "(%d %d) (%d %d) [%d %d]<->[%d %d] (%d %d) (%d %d)\n",
				id,
				t[i+2].tms_utime > t[i+3].tms_utime ?
							"utime" : "stime",
				t[i+2].tms_utime > t[i+3].tms_utime ?
				  t[i+3].tms_utime - t[i+2].tms_utime :
				  t[i+3].tms_stime - t[i+2].tms_stime,
				t[i+0].tms_utime, t[i+0].tms_stime,
				t[i+1].tms_utime, t[i+1].tms_stime,
				t[i+2].tms_utime, t[i+2].tms_stime,
				t[i+3].tms_utime, t[i+3].tms_stime,
				t[i+4].tms_utime, t[i+4].tms_stime,
				t[i+5].tms_utime, t[i+5].tms_stime);
		   ret = 1;
		}
	}

	pthread_exit((void *)ret);
}

void get_loops_per_tick(void)
{
	struct tms t1, t2;
	unsigned long i, mloop = 1000 * 1000 * 1000;

	times(&t1);
	for (i = 0; i < mloop; i++)
		;
	times(&t2);

	lpt = mloop / ((t2.tms_utime - t1.tms_utime) * 10);
}

void do_test(int c)
{
	struct tms t1, t2;
	clock_t j1, j2;
	pthread_t *th;
	unsigned long i, ret = 0;

	th = calloc(threads, sizeof(pthread_t));
	if (!th)
		return;

	looptype    = !!(c & 0x1) ? 1 : 0;
	samplesleep = !!(c & 0x2) ? 1 : 0;
	printf("looptype    : %s\n", looptype ? "discont" : "cont");
	printf("samplesleep : %s\n", samplesleep ? "yes" : "no");

	printf(" ## start ##\n");
	j1 = times(&t1);
	for (i = 0; i < threads; i++)
		pthread_create (&th[i], NULL, child, (void *)i);
	for (i = 0; i < threads; i++) {
		int r;
		pthread_join(th[i], (void *)&r);
		ret += (int)r;
	}
	j2 = times(&t2);
	printf(" ## done. ##\n");
	printf(" loop total:\n");
	printf("  user   : %7d ms\n", (t2.tms_utime - t1.tms_utime) * 10);
	printf("  system : %7d ms\n", (t2.tms_stime - t1.tms_stime) * 10);
	printf("  elapse : %7d ms\n", (j2 - j1) * 10);
	printf("  error  : %d\n\n", ret);

	printf("result: %s\n\n", ret ? "BAD" : "GOOD");
}

int main(int argc, char **argv)
{
	int i;

	threads = argc > 1 ? atoi(argv[1]) : DEFAULT_THREADS;

	printf("### Prep:\n");
	get_loops_per_tick();
	printf("loops_per_tick: %ld\n", lpt);
	printf("threads       : %d\n\n", threads);

	printf("### Test:\n");
	for (i = 0; i < 4; i++)
		do_test(i);
}

