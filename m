Return-Path: <linux-kernel-owner+w=401wt.eu-S1756428AbYE0F7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756428AbYE0F7Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 01:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752906AbYE0F7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 01:59:17 -0400
Received: from mail.gmx.net ([213.165.64.20]:39330 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750774AbYE0F7P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 01:59:15 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX191c9NDz8h1M7ufzgCuXAWjqXfl6YM5dC5WpRTWH2
	60WVSzn7DSg6h7
Subject: [patch] Re: PostgreSQL pgbench performance regression in 2.6.23+
From: Mike Galbraith <efault@gmx.de>
To: Greg Smith <gsmith@gregsmith.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
In-Reply-To: <Pine.GSO.4.64.0805260851510.24771@westnet.com>
References: <1211440207.5733.8.camel@marge.simson.net>
	 <20080522082814.GA4499@linux.vnet.ibm.com>
	 <1211447105.4823.7.camel@marge.simson.net>
	 <1211452465.7606.8.camel@marge.simson.net>
	 <1211455553.4381.9.camel@marge.simson.net>
	 <1211456659.29104.20.camel@twins>
	 <1211458176.5693.6.camel@marge.simson.net>
	 <1211459081.29104.40.camel@twins>
	 <Pine.GSO.4.64.0805230232190.28654@westnet.com>
	 <1211536814.5851.18.camel@marge.simson.net>
	 <20080523101000.GA13964@elte.hu>
	 <1211537717.5851.22.camel@marge.simson.net>
	 <Pine.GSO.4.64.0805231907150.25273@westnet.com>
	 <1211586407.4786.5.camel@marge.simson.net>
	 <Pine.GSO.4.64.0805260851510.24771@westnet.com>
Content-Type: multipart/mixed; boundary="=-N239WkgeKDHrBBQO+3yB"
Date: Tue, 27 May 2008 07:59:10 +0200
Message-Id: <1211867950.5505.47.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-N239WkgeKDHrBBQO+3yB
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Mon, 2008-05-26 at 20:28 -0400, Greg Smith wrote:

> I did again get useful results here with the stock 2.6.26.git kernel and 
> default parameters using Peter's small patch to adjust se.waker.
> 
> What I found most interesting was how the results changed when I set 
> /proc/sys/kernel/sched_features = 0, without doing anything with batch 
> mode.  The default for that is 1101111111=895. What I then did was run 
> through setting each of those bits off one by one to see which feature(s) 
> were getting in the way here.  The two that mattered a lot were 895-32=863 
> (no SCHED_FEAT_SYNC_WAKEUPS ) and 895-2=893 (no 
> SCHED_FEAT_WAKEUP_PREEMPT).  Combining those two but keeping the rest of 
> the features on (895-32-2=861) actually gave the best result I've ever 
> seen here, better than with all the features disabled.  Tossing out all 
> the tests I did that didn't show anything useful, here's my table of the 
> interesting results.
> 
> Clients	.22.19	.26.git	waker	f=0	f=893	f=863	f=861
> 1	7660	11043	11041	9214	11204	9232	9433
> 2	17798	11452	16306	16916	11165	16686	16097
> 3	29612	13231	18476	24202	11348	26210	26906
> 4	25584	13053	17942	26639	11331	25094	25679
> 6	25295	12263	18472	28918	11761	30525	33297
> 8	24344	11748	19109	32730	12190	31775	35912
> 10	23963	11612	19537	31688	12331	29644	36215
> 15	23026	11414	19518	33209	13050	28651	36452
> 20	22549	11332	19029	32583	13544	25776	35707
> 30	22074	10743	18884	32447	14191	21772	33501
> 40	21495	10406	18609	31704	11017	20600	32743
> 50	20051	10534	17478	29483	14683	19949	31047
> 60	18690	9816	17467	28614	14817	18681	29576
> 
> Note that compared to earlier test runs, I replaced the 5 client case with 
> a 60 client one to get more data on the top end.  I also wouldn't pay too 
> much attention to the single client case; that one really bounces around a 
> lot on most of the kernel revs, even with me doing 5 runs and using the 
> median.

Care to give the below a whirl?  If fixes the over-enthusiastic affinity
bug in a less restrictive way.  It doesn't attempt to addresss the needs
of any particular load though, that needs more thought (tricky issue).

With default features, I get the below.

2.6.26-smp x86_64
1 10121.600913
2 14360.229517
3 17048.770371
4 18748.777814
5 22086.493358
6 24913.416187
8 27976.026783
10 29346.503261
15 29157.239431
20 28392.257204
30 26590.199787
40 24422.481578
50 23305.981434

(I can get a bit more by disabling HR_TICK along with a dinky patchlet
to reduce overhead when it's disabled.  Bottom line is that the bug is
fixed though, maximizing performance is separate issue imho) 

Prevent short-running wakers of short-running threads from overloading a single
cpu via wakeup affinity, and wire up disconnected debug option.

Signed-off-by: Mike Galbraith <efault@gmx.de>

 kernel/sched_fair.c |   25 ++++++++++++++-----------
 1 files changed, 14 insertions(+), 11 deletions(-)

Index: linux-2.6.26.git/kernel/sched_fair.c
===================================================================
--- linux-2.6.26.git.orig/kernel/sched_fair.c
+++ linux-2.6.26.git/kernel/sched_fair.c
@@ -1057,16 +1057,27 @@ wake_affine(struct rq *rq, struct sched_
 	struct task_struct *curr = this_rq->curr;
 	unsigned long tl = this_load;
 	unsigned long tl_per_task;
+	int bad_imbalance;
 
-	if (!(this_sd->flags & SD_WAKE_AFFINE))
+	if (!(this_sd->flags & SD_WAKE_AFFINE) || !sched_feat(AFFINE_WAKEUPS))
 		return 0;
 
 	/*
+	 * If sync wakeup then subtract the (maximum possible)
+	 * effect of the currently running task from the load
+	 * of the current CPU:
+	 */
+	if (sync && tl)
+		tl -= curr->se.load.weight;
+
+	bad_imbalance = 100*(tl + p->se.load.weight) > imbalance*load;
+
+	/*
 	 * If the currently running task will sleep within
 	 * a reasonable amount of time then attract this newly
 	 * woken task:
 	 */
-	if (sync && curr->sched_class == &fair_sched_class) {
+	if (sync && !bad_imbalance && curr->sched_class == &fair_sched_class)
{
 		if (curr->se.avg_overlap < sysctl_sched_migration_cost &&
 				p->se.avg_overlap < sysctl_sched_migration_cost)
 			return 1;
@@ -1075,16 +1086,8 @@ wake_affine(struct rq *rq, struct sched_
 	schedstat_inc(p, se.nr_wakeups_affine_attempts);
 	tl_per_task = cpu_avg_load_per_task(this_cpu);
 
-	/*
-	 * If sync wakeup then subtract the (maximum possible)
-	 * effect of the currently running task from the load
-	 * of the current CPU:
-	 */
-	if (sync)
-		tl -= current->se.load.weight;
-
 	if ((tl <= load && tl + target_load(prev_cpu, idx) <= tl_per_task) ||
-			100*(tl + p->se.load.weight) <= imbalance*load) {
+			!bad_imbalance) {
 		/*
 		 * This domain has SD_WAKE_AFFINE and
 		 * p is cache cold in this domain, and


> Some still open questions after this long investigation that I'd like to 
> know the answers to are:
> 
> 1) Why are my 2.6.26.git results so dramatically worse than the ones Mike 
> posted?  I'm not sure what was different about his test setup here.  The 
> 2.6.22 results are pretty similar, and the fully tuned ones as well, so 
> the big difference on that column bugs me.

Because those were git _with_ Peter's patch.  I was looking at the
difference between a non-broken 2.6.26 with and without minimizing
preemption, to match the way I tested 2.6.22.

> 2) Mike suggested a patch to 2.6.25 in this thread that backports the 
> feature for disabling SCHED_FEAT_SYNC_WAKEUPS.  Would it be reasonable to 
> push that into 2.6.25.5?  It's clearly quite useful for this load and 
> therefore possibly others.

If the patch above flies, imho, that should be folded into the backport
to stable.  The heart of the patch is a bugfix, so definitely stable
material.  Whether to enable the debugging/tweaking knobs as well is a
different question.  (I would do it, but I ain't the maintainer;)

> 3) Peter's se.waker patch is a big step forward on this workload without 
> any tuning, closing a significant amount of the gap between the default 
> setup and what I get with the two troublesome features turned off 
> altogether.  What issues might there be with pushing that into the stock 
> {2.6.25|2.6.26} kernel?

(it doesn't fully address the 1:N needs, that needs much more thought)

> 4) What known workloads are there that suffer if SCHED_FEAT_SYNC_WAKEUPS 
> and SCHED_FEAT_WAKEUP_PREEMPT are disabled?  I'd think that any attempt to 
> tune those code paths would need my case for "works better when 
> SYNC/PREEMPT wakeups disabled" as well as a case that works worse to 
> balance modifications against.

I suspect very many, certainly any load where latency is of major
importance.  Peak performance of the mysql+oltp benchmark for sure is
injured with your settings.  As a really good demonstration of how
important wakeup preemption can be, try running the attached testcase,
which was distilled from a real world load and posted to lkml a few
years ago, without wakeup preemption and nailed to one cpu.

> 5) Once (4) has identified some tests cases, what else might be done to 
> make the default behavior better without killing the situations it's 
> intended for?

See patch :)

	-Mike

--=-N239WkgeKDHrBBQO+3yB
Content-Disposition: attachment; filename=starve.c
Content-Type: text/x-csrc; name=starve.c; charset=UTF-8
Content-Transfer-Encoding: 7bit

#include <stdlib.h>
#include <stdio.h>
#include <signal.h>
#include <unistd.h>

#include <sys/types.h>
#include <sys/wait.h>

volatile unsigned long loop = 10000000;

void
handler (int n)
{
  if (loop > 0)
    --loop;
}

static int
child (void)
{
  pid_t ppid = getppid ();

  sleep (1);
  while (1)
    kill (ppid, SIGUSR1);
  return 0;
}

int
main (int argc, char **argv)
{
  pid_t child_pid;
  int r;

  loop = argc > 1 ? strtoul (argv[1], NULL, 10) : 10000000;
  printf ("expecting to receive %lu signals\n", loop);

  if ((child_pid = fork ()) == 0)
    exit (child ());

  signal (SIGUSR1, handler);
  while (loop)
    sleep (1);
  r = kill (child_pid, SIGTERM);
  waitpid (child_pid, NULL, 0);
  return 0;
}

--=-N239WkgeKDHrBBQO+3yB--

