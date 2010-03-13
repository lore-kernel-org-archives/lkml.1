Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934073Ab0CMQms (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 11:42:48 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36857 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932862Ab0CMQmr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 11:42:47 -0500
Date: Sat, 13 Mar 2010 17:42:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20100313164238.GA16531@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

 Thanks,

	Ingo

------------------>
Dan Carpenter (1):
      sched: Cleanup: remove unused variable in try_to_wake_up()

Dimitri Sivanich (1):
      x86: Fix sched_clock_cpu for systems with unsynchronized TSC

Peter Zijlstra (1):
      sched: Fix pick_next_highest_task_rt() for cgroups


 arch/x86/kernel/cpu/intel.c |    3 ++-
 kernel/sched.c              |    4 ++--
 kernel/sched_rt.c           |    7 ++++++-
 3 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 879666f..7e1cca1 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -70,7 +70,8 @@ static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
 	if (c->x86_power & (1 << 8)) {
 		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
 		set_cpu_cap(c, X86_FEATURE_NONSTOP_TSC);
-		sched_clock_stable = 1;
+		if (!check_tsc_unstable())
+			sched_clock_stable = 1;
 	}
 
 	/*
diff --git a/kernel/sched.c b/kernel/sched.c
index 6a212c9..2c1db81 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2359,7 +2359,7 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state,
 {
 	int cpu, orig_cpu, this_cpu, success = 0;
 	unsigned long flags;
-	struct rq *rq, *orig_rq;
+	struct rq *rq;
 
 	if (!sched_feat(SYNC_WAKEUPS))
 		wake_flags &= ~WF_SYNC;
@@ -2367,7 +2367,7 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state,
 	this_cpu = get_cpu();
 
 	smp_wmb();
-	rq = orig_rq = task_rq_lock(p, &flags);
+	rq = task_rq_lock(p, &flags);
 	update_rq_clock(rq);
 	if (!(p->state & state))
 		goto out;
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index bf3e38f..c4fb42a 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1146,7 +1146,12 @@ static struct task_struct *pick_next_highest_task_rt(struct rq *rq, int cpu)
 		if (next && next->prio < idx)
 			continue;
 		list_for_each_entry(rt_se, array->queue + idx, run_list) {
-			struct task_struct *p = rt_task_of(rt_se);
+			struct task_struct *p;
+
+			if (!rt_entity_is_task(rt_se))
+				continue;
+
+			p = rt_task_of(rt_se);
 			if (pick_rt_task(rq, p, cpu)) {
 				next = p;
 				break;
