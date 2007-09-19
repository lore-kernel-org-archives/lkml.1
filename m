Return-Path: <linux-kernel-owner+w=401wt.eu-S1751749AbXISTTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751749AbXISTTZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 15:19:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750814AbXISTTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 15:19:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41791 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789AbXISTTR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 15:19:17 -0400
Date: Wed, 19 Sep 2007 21:18:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Antoine Martin <antoine@nagafix.co.uk>,
       Satyam Sharma <satyam.sharma@gmail.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: CFS: some bad numbers with Java/database threading [FIXED]
Message-ID: <20070919191837.GA19500@elte.hu>
References: <46E871FE.9010908@nagafix.co.uk> <20070913112427.GA20686@elte.hu> <20070914083246.GA20514@elte.hu> <a781481a0709140306k3faf3585haae26853fe81381c@mail.gmail.com> <46EAA7E4.8020700@nagafix.co.uk> <20070914153216.GA27213@elte.hu> <46F00417.7080301@redhat.com> <20070918224656.GA26719@elte.hu> <46F058EE.1080408@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F058EE.1080408@redhat.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Chuck Ebbert <cebbert@redhat.com> wrote:

> I just got a bug report today:
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=295071
> 
> ==================================================
> 
> Description of problem:
> 
> The CFS scheduler does not seem to implement sched_yield correctly. If 
> one program loops with a sched_yield and another program prints out 
> timing information in a loop. You will see that if both are taskset to 
> the same core that the timing stats will be twice as long as when they 
> are on different cores. This problem was not in 2.6.21-1.3194 but 
> showed up in 2.6.22.4-65 and continues in the newest released kernel 
> 2.6.22.5-76.

sched_yield is a very poorly defined interface as it does not tell the 
kernel anything about what kind of locking user-space does. When an app 
calls the syscall it basically tells the scheduler: "uhm, ok, i'm 
blocked and i want you to do something else now. I dont want to tell you 
how long this task wants to wait, and i dont want to tell you on what 
condition it should be unblocked. Just ... do some stuff and let me 
alone. See ya."

That's not an intelligent interface upon which the scheduler can do 
anything particularly intelligent (in fact, it's a very stupid interface 
upon which the scheduler can only do stupid things), and hence 
schedulers tend to implement sched_yield() quite arbitrarily and in a 
very scheduler-internals dependent way - which internals change when the 
scheduler is changed materially.

The correct way to tell the kernel that the task is blocked is to use 
futexes for example, or any kernel-based locking or wait object - there 
are myriads of APIs for these. (The only well-defined behavior of yield 
is for SCHED_FIFO/RR tasks - and that is fully preserved in CFS.)

Regarding compatible behavior: it's not possible to fully emulate the 
O(1) scheduler's yield behavior, because the yield implementation 
depended on so many scheduler internals. We changed yield when we went 
from 2.4 to 2.6, and even in 2.6 we changed it a number of times. To 
avoid the reoccuring problems of applications mistakenly relying on 
sched_yield(), we now context-switch on yield very weakly for 
SCHED_OTHER tasks (SCHED_FIFO/RR behavior is unchanged) - this is the 
only sane behavior that will get apps to stop using sched_yield() - and 
that's the difference that the above testcase shows. (there's actual 
user-space code executed, instead of the frequent overscheduling.)

My patch below adds a sysctl flag that triggers a context-switch when 
yield is called (how futile and undefined and broken that might be), but 
that would only be for legacy reasons. We could still add this patch, 
but i was reluctant to send it to Linus without having at least one 
application that relies on having it and that benefits from it 
(Antoine's test turned out to not rely on it - see the '[FIXED]' 
qualifier in the subject line).

Linus, what do you think? I have no strong feelings, I think the patch 
cannot hurt (it does not change anything by default) - but we should not 
turn the workaround flag on by default. If you agree that we should do 
this, then please pull this single patch from the sched.git tree:

   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git

i've tested it with the flag off and on as well, and it works as 
expected.

	Ingo

------------------>
Ingo Molnar (1):
      sched: yield workaround

 include/linux/sched.h |    2 +
 kernel/sched_fair.c   |   73 +++++++++++++++++++++++++++++++++++++++++++++-----
 kernel/sysctl.c       |   19 +++++++++++++
 3 files changed, 88 insertions(+), 6 deletions(-)

	Ingo

------------------------------>
Subject: sched: yield workaround
From: Ingo Molnar <mingo@elte.hu>

sched_yield() is fundamentally broken, and CFS has changed
its behavior. Some apps that mistakenly rely on sched_yield()
want "weak" sched yield (such as desktop apps) - while some
apps want "strong" sched_yield() (for example some JDKs).

There's no way for the scheduler to figure out which of the
two variants the app really wants - because sched_yield() is
all about hiding from the kernel the true structure of the
user-space locking code.

As a solution, provide a workaround, to introduce a more
agressive sched_yield implementation:

 # default one:
 echo 0 > /proc/sys/kernel/sched_yield_bug_workaround

 # always queues the current task next to the next task:
 echo 1 > /proc/sys/kernel/sched_yield_bug_workaround

 # NOP:
 echo 2 > /proc/sys/kernel/sched_yield_bug_workaround

in the future, the use of this sysctl might generate
a deprecation warning, so that apps start moving away
from their reliance on sched_yield().

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h |    2 +
 kernel/sched_fair.c   |   73 +++++++++++++++++++++++++++++++++++++++++++++-----
 kernel/sysctl.c       |   19 +++++++++++++
 3 files changed, 88 insertions(+), 6 deletions(-)

Index: linux/include/linux/sched.h
===================================================================
--- linux.orig/include/linux/sched.h
+++ linux/include/linux/sched.h
@@ -1402,10 +1402,12 @@ extern void sched_idle_next(void);
 
 extern unsigned int sysctl_sched_latency;
 extern unsigned int sysctl_sched_min_granularity;
+extern unsigned int sysctl_sched_yield_granularity;
 extern unsigned int sysctl_sched_wakeup_granularity;
 extern unsigned int sysctl_sched_batch_wakeup_granularity;
 extern unsigned int sysctl_sched_stat_granularity;
 extern unsigned int sysctl_sched_runtime_limit;
+extern unsigned int sysctl_sched_yield_bug_workaround;
 extern unsigned int sysctl_sched_child_runs_first;
 extern unsigned int sysctl_sched_features;
 
Index: linux/kernel/sched_fair.c
===================================================================
--- linux.orig/kernel/sched_fair.c
+++ linux/kernel/sched_fair.c
@@ -42,6 +42,16 @@ unsigned int sysctl_sched_latency __read
  */
 unsigned int sysctl_sched_min_granularity __read_mostly = 2000000ULL;
 
+unsigned int sysctl_sched_yield_granularity __read_mostly = 10000000ULL;
+
+/*
+ * sys_sched_yield workaround switch.
+ *
+ * This option switches the yield implementation of the
+ * old scheduler back on.
+ */
+unsigned int __read_mostly sysctl_sched_yield_bug_workaround;
+
 /*
  * SCHED_BATCH wake-up granularity.
  * (default: 25 msec, units: nanoseconds)
@@ -901,15 +911,66 @@ static void dequeue_task_fair(struct rq 
  */
 static void yield_task_fair(struct rq *rq, struct task_struct *p)
 {
-	struct cfs_rq *cfs_rq = task_cfs_rq(p);
+	if (!sysctl_sched_yield_bug_workaround) {
+		struct cfs_rq *cfs_rq = task_cfs_rq(p);
+		__update_rq_clock(rq);
+
+		/*
+		 * Dequeue and enqueue the task to update its
+		 * position within the tree:
+		 */
+		dequeue_entity(cfs_rq, &p->se, 0);
+		enqueue_entity(cfs_rq, &p->se, 0);
+		return;
+	}
+
+	if (sysctl_sched_yield_bug_workaround == 1) {
+		struct cfs_rq *cfs_rq = task_cfs_rq(p);
+		struct rb_node *curr, *next, *first;
+		struct task_struct *p_next;
+		s64 yield_key;
+
+		__update_rq_clock(rq);
+		curr = &p->se.run_node;
+		first = first_fair(cfs_rq);
+		/*
+		 * Move this task to the second place in the tree:
+		 */
+		if (curr != first)
+			next = rb_next(curr);
+		else
+			next = first;
+		/*
+		 * We were the last one already - nothing to do, return
+		 * and reschedule:
+		 */
+		if (unlikely(!next))
+			return;
+
+		p_next = rb_entry(next, struct task_struct, se.run_node);
+		/*
+		 * Minimally necessary key value to be the second in the tree:
+		 */
+		yield_key = p_next->se.fair_key +
+					(int)sysctl_sched_yield_granularity;
+
+		dequeue_entity(cfs_rq, &p->se, 0);
+
+		/*
+		 * Only update the key if we need to move more backwards
+		 * than the minimally necessary position to be the second:
+		 */
+		if (p->se.fair_key < yield_key)
+			p->se.fair_key = yield_key;
+
+		__enqueue_entity(cfs_rq, &p->se);
+		return;
+	}
 
-	__update_rq_clock(rq);
 	/*
-	 * Dequeue and enqueue the task to update its
-	 * position within the tree:
+	 * Just reschedule, do nothing else:
 	 */
-	dequeue_entity(cfs_rq, &p->se, 0);
-	enqueue_entity(cfs_rq, &p->se, 0);
+	resched_task(p);
 }
 
 /*
Index: linux/kernel/sysctl.c
===================================================================
--- linux.orig/kernel/sysctl.c
+++ linux/kernel/sysctl.c
@@ -244,6 +244,17 @@ static ctl_table kern_table[] = {
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "sched_yield_granularity_ns",
+		.data		= &sysctl_sched_yield_granularity,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &min_sched_granularity_ns,
+		.extra2		= &max_sched_granularity_ns,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "sched_wakeup_granularity_ns",
 		.data		= &sysctl_sched_wakeup_granularity,
 		.maxlen		= sizeof(unsigned int),
@@ -303,6 +314,14 @@ static ctl_table kern_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 #endif
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "sched_yield_bug_workaround",
+		.data		= &sysctl_sched_yield_bug_workaround,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
 #ifdef CONFIG_PROVE_LOCKING
 	{
 		.ctl_name	= CTL_UNNUMBERED,
