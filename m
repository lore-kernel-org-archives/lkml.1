Return-Path: <linux-kernel-owner+w=401wt.eu-S932990AbZJHSgK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932990AbZJHSgK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 14:36:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932969AbZJHSgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 14:36:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42425 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932966AbZJHSgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 14:36:08 -0400
Date: Thu, 8 Oct 2009 20:35:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arjan van de Ven <arjan@infradead.org>
Subject: [GIT PULL] timer fixes
Message-ID: <20091008183512.GA29701@elte.hu>
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

Please pull the latest timers-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-fixes-for-linus

 Thanks,

	Ingo

------------------>
Arjan van de Ven (1):
      x86, timers: Check for pending timers after (device) interrupts

Eero Nurkkala (1):
      NOHZ: update idle state also when NOHZ is inactive


 arch/x86/kernel/irq.c    |    2 ++
 arch/x86/kernel/smp.c    |    1 +
 kernel/time/tick-sched.c |    9 +++++++--
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 74656d1..3912061 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -244,6 +244,7 @@ unsigned int __irq_entry do_IRQ(struct pt_regs *regs)
 				__func__, smp_processor_id(), vector, irq);
 	}
 
+	run_local_timers();
 	irq_exit();
 
 	set_irq_regs(old_regs);
@@ -268,6 +269,7 @@ void smp_generic_interrupt(struct pt_regs *regs)
 	if (generic_interrupt_extension)
 		generic_interrupt_extension();
 
+	run_local_timers();
 	irq_exit();
 
 	set_irq_regs(old_regs);
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index ec1de97..d915d95 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -198,6 +198,7 @@ void smp_reschedule_interrupt(struct pt_regs *regs)
 {
 	ack_APIC_irq();
 	inc_irq_stat(irq_resched_count);
+	run_local_timers();
 	/*
 	 * KVM uses this interrupt to force a cpu out of guest mode
 	 */
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index e0f59a2..89aed59 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -231,6 +231,13 @@ void tick_nohz_stop_sched_tick(int inidle)
 	if (!inidle && !ts->inidle)
 		goto end;
 
+	/*
+	 * Set ts->inidle unconditionally. Even if the system did not
+	 * switch to NOHZ mode the cpu frequency governers rely on the
+	 * update of the idle time accounting in tick_nohz_start_idle().
+	 */
+	ts->inidle = 1;
+
 	now = tick_nohz_start_idle(ts);
 
 	/*
@@ -248,8 +255,6 @@ void tick_nohz_stop_sched_tick(int inidle)
 	if (unlikely(ts->nohz_mode == NOHZ_MODE_INACTIVE))
 		goto end;
 
-	ts->inidle = 1;
-
 	if (need_resched())
 		goto end;
 
