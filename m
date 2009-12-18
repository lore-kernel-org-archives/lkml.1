Return-Path: <linux-kernel-owner+w=401wt.eu-S932527AbZLRStr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932527AbZLRStr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 13:49:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755390AbZLRStq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 13:49:46 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58427 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754605AbZLRStp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 13:49:45 -0500
Date: Fri, 18 Dec 2009 19:49:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] timer fixes
Message-ID: <20091218184936.GA24429@elte.hu>
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

Please pull the latest timers-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-fixes-for-linus

 Thanks,

	Ingo

------------------>
Simon Horman (1):
      timers: Remove duplicate setting of new_base in __mod_timer()

Thomas Gleixner (1):
      clockevents: Prevent clockevent_devices list corruption on cpu hotplug


 kernel/time/clockevents.c |   18 +++++++++++++++---
 kernel/timer.c            |    2 --
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index 20a8920..91db2e3 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -238,8 +238,9 @@ void clockevents_exchange_device(struct clock_event_device *old,
  */
 void clockevents_notify(unsigned long reason, void *arg)
 {
-	struct list_head *node, *tmp;
+	struct clock_event_device *dev, *tmp;
 	unsigned long flags;
+	int cpu;
 
 	spin_lock_irqsave(&clockevents_lock, flags);
 	clockevents_do_notify(reason, arg);
@@ -250,8 +251,19 @@ void clockevents_notify(unsigned long reason, void *arg)
 		 * Unregister the clock event devices which were
 		 * released from the users in the notify chain.
 		 */
-		list_for_each_safe(node, tmp, &clockevents_released)
-			list_del(node);
+		list_for_each_entry_safe(dev, tmp, &clockevents_released, list)
+			list_del(&dev->list);
+		/*
+		 * Now check whether the CPU has left unused per cpu devices
+		 */
+		cpu = *((int *)arg);
+		list_for_each_entry_safe(dev, tmp, &clockevent_devices, list) {
+			if (cpumask_test_cpu(cpu, dev->cpumask) &&
+			    cpumask_weight(dev->cpumask) == 1) {
+				BUG_ON(dev->mode != CLOCK_EVT_MODE_UNUSED);
+				list_del(&dev->list);
+			}
+		}
 		break;
 	default:
 		break;
diff --git a/kernel/timer.c b/kernel/timer.c
index 5db5a8d..15533b7 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -656,8 +656,6 @@ __mod_timer(struct timer_list *timer, unsigned long expires,
 
 	debug_activate(timer, expires);
 
-	new_base = __get_cpu_var(tvec_bases);
-
 	cpu = smp_processor_id();
 
 #if defined(CONFIG_NO_HZ) && defined(CONFIG_SMP)
