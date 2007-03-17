Return-Path: <linux-kernel-owner+w=401wt.eu-S965163AbXCQJnI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965163AbXCQJnI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 05:43:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933826AbXCQJnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 05:43:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41543 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933821AbXCQJnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 05:43:06 -0400
Date: Sat, 17 Mar 2007 10:42:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nicholas Miell <nmiell@comcast.net>
Cc: Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [patch] CFS scheduler: Completely Fair Scheduler / CONFIG_SCHED_FAIR
Message-ID: <20070317094223.GA28330@elte.hu>
References: <200703042335.26785.a1426z@gawab.com> <200703170040.48316.kernel@kolivas.org> <1174059299.7886.25.camel@Homer.simpson.net> <200703170813.32594.kernel@kolivas.org> <1174084207.7009.9.camel@Homer.simpson.net> <1174105443.3144.4.camel@entropy> <1174110965.7911.44.camel@Homer.simpson.net> <1174112768.3144.8.camel@entropy> <20070317074506.GA13685@elte.hu> <1174119830.3144.22.camel@entropy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1174119830.3144.22.camel@entropy>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Nicholas Miell <nmiell@comcast.net> wrote:

> > this regression has to be fixed before RSDL can be merged, simply 
> > because it is a pretty negative effect that goes beyond any of the 
> > visible positive improvements that RSDL brings over the current 
> > scheduler. If it is better to fix X, then X has to be fixed _first_, 
> > at least in form of a prototype patch that can be _tested_, and then 
> > the result has to be validated against RSDL.
> 
> RSDL is, above all else, fair. Predictably so.

SCHED_BATCH (an existing feature of the current scheduler) is even 
fairer and even more deterministic than RSDL, because it has _zero_ 
heuristics.

so how about the patch below (against current -git), which adds the 
"CFS, Completely Fair Scheduler" feature? With that you could test your 
upcoming X fixes. (it also adds /proc/sys/kernel/sched_fair so that you 
can compare the fair scheduler against the vanilla scheduler.) It's very 
simple and unintrusive:

 4 files changed, 28 insertions(+)

furthermore, this is just the first step: if CONFIG_SCHED_FAIR becomes 
widespread amongst distributions then we can remove the interactivity 
estimator code altogether, and simplify the code quite a bit.

( NOTE: more improvements are possible as well: right now most
  interactivity calculations are still done even if CONFIG_SCHED_FAIR is
  enabled - that could be improved upon. )

	Ingo

------------------------------>
Subject: [patch] CFS scheduler: Completely Fair Scheduler
From: Ingo Molnar <mingo@elte.hu>

add the CONFIG_SCHED_FAIR option (default: off): this turns the Linux 
scheduler into a completely fair scheduler for SCHED_OTHER tasks: with 
perfect roundrobin scheduling, fair distribution of timeslices combined 
with no interactivity boosting and no heuristics.

a /proc/sys/kernel/sched_fair option is also available to turn
this behavior on/off.

if this option establishes itself amongst leading distributions then we
could in the future remove the interactivity estimator altogether.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h  |    1 +
 kernel/Kconfig.preempt |    9 +++++++++
 kernel/sched.c         |    8 ++++++++
 kernel/sysctl.c        |   10 ++++++++++
 4 files changed, 28 insertions(+)

Index: linux/include/linux/sched.h
===================================================================
--- linux.orig/include/linux/sched.h
+++ linux/include/linux/sched.h
@@ -119,6 +119,7 @@ extern unsigned long avenrun[];		/* Load
 	load += n*(FIXED_1-exp); \
 	load >>= FSHIFT;
 
+extern unsigned int sched_fair;
 extern unsigned long total_forks;
 extern int nr_threads;
 DECLARE_PER_CPU(unsigned long, process_counts);
Index: linux/kernel/Kconfig.preempt
===================================================================
--- linux.orig/kernel/Kconfig.preempt
+++ linux/kernel/Kconfig.preempt
@@ -63,3 +63,12 @@ config PREEMPT_BKL
 	  Say Y here if you are building a kernel for a desktop system.
 	  Say N if you are unsure.
 
+config SCHED_FAIR
+	bool "Completely Fair Scheduler"
+	help
+	  This option turns the Linux scheduler into a completely fair
+	  scheduler. User-space workloads will round-robin fairly, and
+	  they have to be prioritized using nice levels.
+
+	  Say N if you are unsure.
+
Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -4040,6 +4040,10 @@ static inline struct task_struct *find_p
 	return pid ? find_task_by_pid(pid) : current;
 }
 
+#ifdef CONFIG_SCHED_FAIR
+unsigned int sched_fair = 1;
+#endif
+
 /* Actually do priority change: must hold rq lock. */
 static void __setscheduler(struct task_struct *p, int policy, int prio)
 {
@@ -4055,6 +4059,10 @@ static void __setscheduler(struct task_s
 	 */
 	if (policy == SCHED_BATCH)
 		p->sleep_avg = 0;
+#ifdef CONFIG_SCHED_FAIR
+	if (policy == SCHED_NORMAL && sched_fair)
+		p->sleep_avg = 0;
+#endif
 	set_load_weight(p);
 }
 
Index: linux/kernel/sysctl.c
===================================================================
--- linux.orig/kernel/sysctl.c
+++ linux/kernel/sysctl.c
@@ -205,6 +205,16 @@ static ctl_table root_table[] = {
 };
 
 static ctl_table kern_table[] = {
+#ifdef CONFIG_SCHED_FAIR
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "sched_fair",
+		.data		= &sched_fair,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+#endif
 	{
 		.ctl_name	= KERN_PANIC,
 		.procname	= "panic",
