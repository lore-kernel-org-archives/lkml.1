Return-Path: <linux-kernel-owner+w=401wt.eu-S1757702AbZFOJCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757702AbZFOJCe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 05:02:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754590AbZFOJC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 05:02:27 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34777 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751694AbZFOJC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 05:02:26 -0400
Date: Mon, 15 Jun 2009 10:55:42 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC PATCH] posix-cpu-timers: optimize calling
 thread_group_cputime()
Message-ID: <20090615105542.2d9f76c7@dhcp-lab-109.englab.brq.redhat.com>
In-Reply-To: <20090612142546.GC3784@redhat.com>
References: <20090612123903.37cfd868@dhcp-lab-109.englab.brq.redhat.com>
	<1244804986.6691.1224.camel@laptop>
	<20090612132008.0c6f3e93@dhcp-lab-109.englab.brq.redhat.com>
	<20090612142546.GC3784@redhat.com>
Organization: RedHat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Jun 2009 16:25:46 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> To clarify, I am not arguing against this patch, just a queston.
> 
> On 06/12, Stanislaw Gruszka wrote:
> >
> > On Fri, 12 Jun 2009 13:09:46 +0200
> > Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> >
> > > On Fri, 2009-06-12 at 12:39 +0200, Stanislaw Gruszka wrote:
> > > > -               times->utime = cputime_add(times->utime, t->utime);
> > > > -               times->stime = cputime_add(times->stime, t->stime);
> > > > -               times->sum_exec_runtime += t->se.sum_exec_runtime;
> > > > +               if (mask & TG_CPUCLOCK_UTIME)
> > > > +                       times->utime = cputime_add(times->utime, t->utime);
> > > > +               if (mask & TG_CPUCLOCK_STIME)
> > > > +                       times->stime = cputime_add(times->stime, t->stime);
> > > > +               if (mask & TG_CPUCLOCK_SCHED)
> > > > +                       times->sum_exec_runtime += t->se.sum_exec_runtime;
> > >
> > > Does adding 3 branches really make it faster?
> > Actually I did not any benchmarking yet, so I don't know what is the real
> > impact of the patch. I hope it make things taster but the result can be
> > opposite from my expectations.
> 
> I agree with Peter, if we complicate the code it would be nice to know
> this really makes it faster. Besides, thread_group_cputime() should not
> be called that often.

I did some benchmarking, I don't think further the patch is good, it not get
speed up I expected for clock_gettime(). 

First was measurement of thread_group_cycles() [1] with standart usage when is
called from posix_cpu_timers_exit_group():

Without patch:

tg_cputime_cycles 1524672
tg_cputime_n 6246
average: 244 cycles

With patch:

tg_cputime_cycles 1593876
tg_cputime_n 6368
average: 250 cycles

Second benchmark measure time of 250 thread process which do lots of
clock_gettime(), here are results:

Without patch:

[stasiu@dhcp-lab-195 Work]$ ./bench_getclock
CLK_PROF: 0.387411
CLK_VIRT: 0.371487
CLK_SCHED: 0.396650

With patch:

[stasiu@dhcp-lab-195 Work]$ ./bench_getclock
CLK_PROF: 0.336056
CLK_VIRT: 0.305781
CLK_SCHED: 0.339739

[1] Patch to measure thread_group_cputime() cycles:

diff --git a/fs/proc/stat.c b/fs/proc/stat.c
index 81e4eb6..14021e8 100644
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -22,6 +22,9 @@
 #define arch_idle_time(cpu) 0
 #endif
 
+extern unsigned long long tg_cputime_cycles;
+extern unsigned long tg_cputime_n;
+
 static int show_stat(struct seq_file *p, void *v)
 {
 	int i, j;
@@ -108,12 +111,16 @@ static int show_stat(struct seq_file *p, void *v)
 		"btime %lu\n"
 		"processes %lu\n"
 		"procs_running %lu\n"
-		"procs_blocked %lu\n",
+		"procs_blocked %lu\n"
+		"tg_cputime_cycles %llu\n"
+		"tg_cputime_n %lu\n",
 		nr_context_switches(),
 		(unsigned long)jif,
 		total_forks,
 		nr_running(),
-		nr_iowait());
+		nr_iowait(),
+		tg_cputime_cycles,
+		tg_cputime_n);
 
 	return 0;
 }
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index b5f1b44..6ff946c 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -230,13 +230,20 @@ static int cpu_clock_sample(const clockid_t which_clock, struct task_struct *p,
 	return 0;
 }
 
+unsigned long long tg_cputime_cycles;
+unsigned long tg_cputime_n;
+
 void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times,
 			  int mask)
 {
 	struct sighand_struct *sighand;
 	struct signal_struct *sig;
 	struct task_struct *t;
+	unsigned long long xstart, xend;
 
+	xstart = get_cycles();
+	barrier();
+ 
 	*times = INIT_CPUTIME;
 
 	rcu_read_lock();
@@ -266,6 +273,11 @@ void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times,
 		times->sum_exec_runtime += sig->sum_sched_runtime;
 out:
 	rcu_read_unlock();
+
+	barrier();
+	xend = get_cycles();
+	tg_cputime_cycles += xend - xstart;
+	tg_cputime_n++;
 }
 
 static void update_gt_cputime(struct task_cputime *a, struct task_cputime *b)


[2] Benchmark multithread process clock_gettime():

#include <sys/time.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include <unistd.h>
#include <pthread.h>
#include <unistd.h>

#define CPUCLOCK_PROF		0
#define CPUCLOCK_VIRT		1
#define CPUCLOCK_SCHED		2

#define MAKE_PROCESS_CPUCLOCK(pid, clock) \
	((~(clockid_t) (pid) << 3) | (clockid_t) (clock))

#define CLK_PROF	MAKE_PROCESS_CPUCLOCK(0, CPUCLOCK_PROF)
#define CLK_VIRT	MAKE_PROCESS_CPUCLOCK(0, CPUCLOCK_VIRT)
#define CLK_SCHED	MAKE_PROCESS_CPUCLOCK(0, CPUCLOCK_SCHED)

#define NTHREADS 250

void *thread_main(void *dummy)
{
	while (1)
		sleep(100);
}                     

void create_threads(void)
{
	int i, rc;
	pthread_t tid;
	pthread_attr_t attr;

	pthread_attr_init(&attr);

	for (i = 0; i < NTHREADS; i++) {
		rc = pthread_create(&tid, &attr, thread_main, NULL);
  		if (rc) {              
    			printf("ERROR; return code from pthread_create() is %d\n", rc);
    			exit(-1);
    		}
	}
}

double timeval_diff(const struct timeval *start, const struct timeval *end)
{
	return (end->tv_sec - start->tv_sec) + (end->tv_usec - start->tv_usec)/1000000.0;
}

void bench(clockid_t cid, char *str)
{
	int i;
	struct timespec ts;
	struct timeval start, end;
	double t;

	gettimeofday(&start, NULL);
	for (i = 0; i < 100000; i++)
		clock_gettime(cid, &ts);
	gettimeofday(&end, NULL);
	
	t = timeval_diff(&start, &end);
	printf("%s: %f\n", str, t);
}

int main(void)
{
	create_threads();
	bench(CLK_PROF, "CLK_PROF");
	bench(CLK_VIRT, "CLK_VIRT");
	bench(CLK_SCHED, "CLK_SCHED");
	return 0;
}
