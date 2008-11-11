Return-Path: <linux-kernel-owner+w=401wt.eu-S1752055AbYKKSrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055AbYKKSrj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 13:47:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbYKKSrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 13:47:23 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52284 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751425AbYKKSrW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 13:47:22 -0500
Date: Tue, 11 Nov 2008 19:47:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [git pull] timer fixes
Message-ID: <20081111184710.GA21443@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-fixes-for-linus

 Thanks,

	Ingo

------------------>
Gautham R Shenoy (1):
      timers: handle HRTIMER_CB_IRQSAFE_UNLOCKED correctly from softirq context

Matt Fleming (3):
      x86: HPET: convert WARN_ON to WARN_ON_ONCE
      x86: HPET: read from HPET_Tn_CMP() not HPET_T0_CMP
      x86: HPET: enter hpet_interrupt_handler with interrupts disabled

Thomas Gleixner (2):
      irq: call __irq_enter() before calling the tick_idle_check
      nohz: disable tick_nohz_kick_tick() for now


 arch/x86/kernel/hpet.c   |    4 ++--
 kernel/hrtimer.c         |   17 ++++++++++++++++-
 kernel/softirq.c         |    7 ++++---
 kernel/time/tick-sched.c |    4 ++++
 4 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 77017e8..067d8de 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -322,7 +322,7 @@ static int hpet_next_event(unsigned long delta,
 	 * what we wrote hit the chip before we compare it to the
 	 * counter.
 	 */
-	WARN_ON((u32)hpet_readl(HPET_T0_CMP) != cnt);
+	WARN_ON_ONCE((u32)hpet_readl(HPET_Tn_CMP(timer)) != cnt);
 
 	return (s32)((u32)hpet_readl(HPET_COUNTER) - cnt) >= 0 ? -ETIME : 0;
 }
@@ -445,7 +445,7 @@ static int hpet_setup_irq(struct hpet_dev *dev)
 {
 
 	if (request_irq(dev->irq, hpet_interrupt_handler,
-			IRQF_SHARED|IRQF_NOBALANCING, dev->name, dev))
+			IRQF_DISABLED|IRQF_NOBALANCING, dev->name, dev))
 		return -1;
 
 	disable_irq(dev->irq);
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 2b465df..95d3949 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1209,6 +1209,7 @@ static void run_hrtimer_pending(struct hrtimer_cpu_base *cpu_base)
 		enum hrtimer_restart (*fn)(struct hrtimer *);
 		struct hrtimer *timer;
 		int restart;
+		int emulate_hardirq_ctx = 0;
 
 		timer = list_entry(cpu_base->cb_pending.next,
 				   struct hrtimer, cb_entry);
@@ -1217,10 +1218,24 @@ static void run_hrtimer_pending(struct hrtimer_cpu_base *cpu_base)
 		timer_stats_account_hrtimer(timer);
 
 		fn = timer->function;
+		/*
+		 * A timer might have been added to the cb_pending list
+		 * when it was migrated during a cpu-offline operation.
+		 * Emulate hardirq context for such timers.
+		 */
+		if (timer->cb_mode == HRTIMER_CB_IRQSAFE_PERCPU ||
+		    timer->cb_mode == HRTIMER_CB_IRQSAFE_UNLOCKED)
+			emulate_hardirq_ctx = 1;
+
 		__remove_hrtimer(timer, timer->base, HRTIMER_STATE_CALLBACK, 0);
 		spin_unlock_irq(&cpu_base->lock);
 
-		restart = fn(timer);
+		if (unlikely(emulate_hardirq_ctx)) {
+			local_irq_disable();
+			restart = fn(timer);
+			local_irq_enable();
+		} else
+			restart = fn(timer);
 
 		spin_lock_irq(&cpu_base->lock);
 
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 7110dae..e7c69a7 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -269,10 +269,11 @@ void irq_enter(void)
 {
 	int cpu = smp_processor_id();
 
-	if (idle_cpu(cpu) && !in_interrupt())
+	if (idle_cpu(cpu) && !in_interrupt()) {
+		__irq_enter();
 		tick_check_idle(cpu);
-
-	__irq_enter();
+	} else
+		__irq_enter();
 }
 
 #ifdef __ARCH_IRQ_EXIT_IRQS_DISABLED
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 5bbb104..342fc9c 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -568,6 +568,9 @@ static void tick_nohz_switch_to_nohz(void)
  */
 static void tick_nohz_kick_tick(int cpu)
 {
+#if 0
+	/* Switch back to 2.6.27 behaviour */
+
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
 	ktime_t delta, now;
 
@@ -584,6 +587,7 @@ static void tick_nohz_kick_tick(int cpu)
 		return;
 
 	tick_nohz_restart(ts, now);
+#endif
 }
 
 #else
