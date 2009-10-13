Return-Path: <linux-kernel-owner+w=401wt.eu-S1760906AbZJMSYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760906AbZJMSYf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 14:24:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760897AbZJMSYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 14:24:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43671 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760896AbZJMSYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 14:24:33 -0400
Date: Tue, 13 Oct 2009 20:23:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20091013182349.GA11251@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
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

Linus,

Please pull the latest sched-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

 Thanks,

	Ingo

------------------>
Ingo Molnar (1):
      Revert "x86, timers: Check for pending timers after (device) interrupts"

Mike Galbraith (1):
      sched: Update the clock of runqueue select_task_rq() selected

Randy Dunlap (1):
      sched: Fix missing kernel-doc notation


 arch/x86/kernel/irq.c |    2 --
 arch/x86/kernel/smp.c |    1 -
 kernel/sched.c        |   10 ++++++++--
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 3912061..74656d1 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -244,7 +244,6 @@ unsigned int __irq_entry do_IRQ(struct pt_regs *regs)
 				__func__, smp_processor_id(), vector, irq);
 	}
 
-	run_local_timers();
 	irq_exit();
 
 	set_irq_regs(old_regs);
@@ -269,7 +268,6 @@ void smp_generic_interrupt(struct pt_regs *regs)
 	if (generic_interrupt_extension)
 		generic_interrupt_extension();
 
-	run_local_timers();
 	irq_exit();
 
 	set_irq_regs(old_regs);
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index d915d95..ec1de97 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -198,7 +198,6 @@ void smp_reschedule_interrupt(struct pt_regs *regs)
 {
 	ack_APIC_irq();
 	inc_irq_stat(irq_resched_count);
-	run_local_timers();
 	/*
 	 * KVM uses this interrupt to force a cpu out of guest mode
 	 */
diff --git a/kernel/sched.c b/kernel/sched.c
index 76c0e96..789001d 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -676,6 +676,7 @@ inline void update_rq_clock(struct rq *rq)
 
 /**
  * runqueue_is_locked
+ * @cpu: the processor in question.
  *
  * Returns true if the current cpu runqueue is locked.
  * This interface allows printk to be called with the runqueue lock
@@ -2311,7 +2312,7 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state,
 {
 	int cpu, orig_cpu, this_cpu, success = 0;
 	unsigned long flags;
-	struct rq *rq;
+	struct rq *rq, *orig_rq;
 
 	if (!sched_feat(SYNC_WAKEUPS))
 		wake_flags &= ~WF_SYNC;
@@ -2319,7 +2320,7 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state,
 	this_cpu = get_cpu();
 
 	smp_wmb();
-	rq = task_rq_lock(p, &flags);
+	rq = orig_rq = task_rq_lock(p, &flags);
 	update_rq_clock(rq);
 	if (!(p->state & state))
 		goto out;
@@ -2350,6 +2351,10 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state,
 		set_task_cpu(p, cpu);
 
 	rq = task_rq_lock(p, &flags);
+
+	if (rq != orig_rq)
+		update_rq_clock(rq);
+
 	WARN_ON(p->state != TASK_WAKING);
 	cpu = task_cpu(p);
 
@@ -3656,6 +3661,7 @@ static void update_group_power(struct sched_domain *sd, int cpu)
 
 /**
  * update_sg_lb_stats - Update sched_group's statistics for load balancing.
+ * @sd: The sched_domain whose statistics are to be updated.
  * @group: sched_group whose statistics are to be updated.
  * @this_cpu: Cpu for which load balance is currently performed.
  * @idle: Idle status of this_cpu
