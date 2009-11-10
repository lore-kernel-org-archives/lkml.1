Return-Path: <linux-kernel-owner+w=401wt.eu-S1755329AbZKJDsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329AbZKJDsx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 22:48:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752430AbZKJDsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 22:48:53 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49251 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751814AbZKJDsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 22:48:52 -0500
Date: Tue, 10 Nov 2009 04:48:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Greg KH <gregkh@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC] new -stable tag variant, Git workflow question
Message-ID: <20091110034831.GB26809@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FYI, today i committed a scheduler performance fix that has a number of 
commit prerequisites for -stable integration. Those commits are not 
marked -stable.

Previously, in similar situations, i solved it by email-forwarding the 
prereq commits to stable@kernel.org. (or by waiting for your 'it does 
not apply to -stable' email and figuring out the prereqs then.)

But we can move this into the Git commit space too, and minimize the 
work for the -stable team, via a new -stable tag variant. So with this 
new commit i started using a new tagging scheme in the commit itself:

 Cc: <stable@kernel.org> # .32.x: a1f84a3: sched: Check for an idle shared cache
 Cc: <stable@kernel.org> # .32.x: 1b9508f: sched: Rate-limit newidle
 Cc: <stable@kernel.org> # .32.x: fd21073: sched: Fix affinity logic
 Cc: <stable@kernel.org> # .32.x
 LKML-Reference: <1257821402.5648.17.camel@marge.simson.net>
 Signed-off-by: Ingo Molnar <mingo@elte.hu>

The tag sequence has the meaning of:

  git cherry-pick a1f84a3
  git cherry-pick 1b9508f
  git cherry-pick fd21073
  git cherry-pick <this commit>

and i'm wondering whether this tagging scheme is fine with your -stable 
scripting, etc.

A further question is, i can see using this tagging scheme in the future 
in merge commits log messages too - will your scripts notice that too?

For example if there's a few commits left in tip:*/urgent branches 
(tip:sched/urgent, tip:core/urgent, tip:x86/urgent, etc.) by the time 
v2.6.32 is released, i will then merge them into tip:sched/core, 
tip:core/core, tip:x86/core, etc. - and i could use the merge commit as 
a notification area to 'activate' them for -stable backporting via a 
merge commit.

This is how such merge commits would look like:

  Merge branch 'core/urgent' into core/rcu

  Merge reason: Pick up urgent fixes that did not make it into .32.0

  Cc: <stable@kernel.org> # .32.x: 83f5b01: rcu: Fix long-grace-period race
  Signed-off-by: Ingo Molnar <mingo@elte.hu>

This is not so rare of a situation as it might seem - for the trees i 
maintain it happens in almost every release cycle - i typically skip 
urgent branch merges after -rc8/-rc9, unless they are very-very-urgent 
fixes - but they'd still be eligible for -stable.

I've attached the full commit below. The prereq commits are not uptream 
yet, and they dont carry a -stable backporting tag as the -stable 
relevance was not anticipated at that point yet. They will all be 
upstream in the next merge window when Linus merges the relevant tree - 
and then all these tags become visible to the -stable team's scripts.

What do you think about this new -stable tagging variant? To me it looks 
quite intuitive, less error-prone and it is more informative as well. 
Furthermore, it gives us some freedom to mark commits as backport 
candidates later on. I kept them oneliners for the purpose of making 
them all self-sufficient tags.

( Sidenote: i wouldnt go as far as to generate null Git commits to mark
  backports after the fact - this scheme is for a series of commits that 
  get 'completed' - there's usually a final followup commit that can 
  embedd this information. )

	Ingo

---------------------------->
>From eae0c9dfb534cb3449888b9601228efa6480fdb5 Mon Sep 17 00:00:00 2001
From: Mike Galbraith <efault@gmx.de>
Date: Tue, 10 Nov 2009 03:50:02 +0100
Subject: [PATCH] sched: Fix and clean up rate-limit newidle code

Commit 1b9508f, "Rate-limit newidle" has been confirmed to fix
the netperf UDP loopback regression reported by Alex Shi.

This is a cleanup and a fix:

 - moved to a more out of the way spot

 - fix to ensure that balancing doesn't try to balance
   runqueues which haven't gone online yet, which can
   mess up CPU enumeration during boot.

Reported-by: Alex Shi <alex.shi@intel.com>
Reported-by: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: <stable@kernel.org> # .32.x: a1f84a3: sched: Check for an idle shared cache
Cc: <stable@kernel.org> # .32.x: 1b9508f: sched: Rate-limit newidle
Cc: <stable@kernel.org> # .32.x: fd21073: sched: Fix affinity logic
Cc: <stable@kernel.org> # .32.x
LKML-Reference: <1257821402.5648.17.camel@marge.simson.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   28 +++++++++++++++-------------
 1 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 23e3535..ad37776 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2354,17 +2354,6 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state,
 	if (rq != orig_rq)
 		update_rq_clock(rq);
 
-	if (rq->idle_stamp) {
-		u64 delta = rq->clock - rq->idle_stamp;
-		u64 max = 2*sysctl_sched_migration_cost;
-
-		if (delta > max)
-			rq->avg_idle = max;
-		else
-			update_avg(&rq->avg_idle, delta);
-		rq->idle_stamp = 0;
-	}
-
 	WARN_ON(p->state != TASK_WAKING);
 	cpu = task_cpu(p);
 
@@ -2421,6 +2410,17 @@ out_running:
 #ifdef CONFIG_SMP
 	if (p->sched_class->task_wake_up)
 		p->sched_class->task_wake_up(rq, p);
+
+	if (unlikely(rq->idle_stamp)) {
+		u64 delta = rq->clock - rq->idle_stamp;
+		u64 max = 2*sysctl_sched_migration_cost;
+
+		if (delta > max)
+			rq->avg_idle = max;
+		else
+			update_avg(&rq->avg_idle, delta);
+		rq->idle_stamp = 0;
+	}
 #endif
 out:
 	task_rq_unlock(rq, &flags);
@@ -4098,7 +4098,7 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 	unsigned long flags;
 	struct cpumask *cpus = __get_cpu_var(load_balance_tmpmask);
 
-	cpumask_setall(cpus);
+	cpumask_copy(cpus, cpu_online_mask);
 
 	/*
 	 * When power savings policy is enabled for the parent domain, idle
@@ -4261,7 +4261,7 @@ load_balance_newidle(int this_cpu, struct rq *this_rq, struct sched_domain *sd)
 	int all_pinned = 0;
 	struct cpumask *cpus = __get_cpu_var(load_balance_tmpmask);
 
-	cpumask_setall(cpus);
+	cpumask_copy(cpus, cpu_online_mask);
 
 	/*
 	 * When power savings policy is enabled for the parent domain, idle
@@ -9522,6 +9522,8 @@ void __init sched_init(void)
 		rq->cpu = i;
 		rq->online = 0;
 		rq->migration_thread = NULL;
+		rq->idle_stamp = 0;
+		rq->avg_idle = 2*sysctl_sched_migration_cost;
 		INIT_LIST_HEAD(&rq->migration_queue);
 		rq_attach_root(rq, &def_root_domain);
 #endif

