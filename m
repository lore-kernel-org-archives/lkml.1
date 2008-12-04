Return-Path: <linux-kernel-owner+w=401wt.eu-S1757793AbYLDKRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757793AbYLDKRe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 05:17:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755148AbYLDKRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 05:17:21 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:52318 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755144AbYLDKRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 05:17:18 -0500
Subject: Re: [RFC PATCH] hrtimer: removing all ur callback modes
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, oliver@hartkopp.net
In-Reply-To: <1227613431.4259.1537.camel@twins>
References: <1227613431.4259.1537.camel@twins>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 04 Dec 2008 11:17:10 +0100
Message-Id: <1228385830.5092.43.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-11-25 at 12:43 +0100, Peter Zijlstra wrote:
> Hi,
> 
> This is an attempt at removing some of the hrtimer complexity by
> reducing the number of callback modes to 1.
> 
> This means that all hrtimer callback functions will be ran from HARD-irq
> context.
> 
> I went through all the 30 odd hrtimer callback functions in the kernel
> and saw only one that I'm not quite sure of, which is the one in
> net/can/bcm.c - hence I'm CC-ing the folks responsible for that code.
> 
> Furthermore, the hrtimer core now calls callbacks directly with IRQs
> disabled in case you try to enqueue an expired timer. If this timer is a
> periodic timer (which should use hrtimer_forward() to advance its time)
> then it might be possible to end up in an inf. recursive loop due to the
> fact that hrtimer_forward() doesn't round up to the next timer
> granularity, and therefore keeps on calling the callback - obviously
> this needs a fix.
> 
> Aside from that, this seems to compile and actually boot on my dual core
> test box - although I'm sure there are some bugs in, me not hitting any
> makes me certain :-)
> 
> Not-Quite-Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Ingo, this addition fixes the hotplug issue on my machine

---
 hrtimer.c |   65 +++++++++++++++++++++++++++++++++++---------------------------
 1 file changed, 37 insertions(+), 28 deletions(-)

Index: linux-2.6/kernel/hrtimer.c
===================================================================
--- linux-2.6.orig/kernel/hrtimer.c
+++ linux-2.6/kernel/hrtimer.c
@@ -1496,7 +1496,7 @@ static void __cpuinit init_hrtimers_cpu(
 #ifdef CONFIG_HOTPLUG_CPU
 
 static void migrate_hrtimer_list(struct hrtimer_clock_base *old_base,
-				 struct hrtimer_clock_base *new_base, int dcpu)
+				struct hrtimer_clock_base *new_base)
 {
 	struct hrtimer *timer;
 	struct rb_node *node;
@@ -1514,40 +1514,34 @@ static void migrate_hrtimer_list(struct 
 		__remove_hrtimer(timer, old_base, HRTIMER_STATE_MIGRATE, 0);
 		timer->base = new_base;
 		/*
-		 * Enqueue the timer. Allow reprogramming of the event device
+		 * Enqueue the timers on the new cpu, but do not reprogram 
+		 * the timer as that would enable a deadlock between
+		 * hrtimer_enqueue_reprogramm() running the timer and us still
+		 * holding a nested base lock.
+		 *
+		 * Instead we tickle the hrtimer interrupt after the migration
+		 * is done, which will run all expired timers and re-programm
+		 * the timer device.
 		 */
-		enqueue_hrtimer(timer, new_base, 1);
+		enqueue_hrtimer(timer, new_base, 0);
 
-#ifdef CONFIG_HIGH_RES_TIMERS
-		/*
-		 * Happens with high res enabled when the timer was
-		 * already expired and the callback mode is
-		 * HRTIMER_CB_IRQSAFE_UNLOCKED (hrtimer_sleeper). The
-		 * enqueue code does not move them to the soft irq
-		 * pending list for performance/latency reasons, but
-		 * in the migration state, we need to do that
-		 * otherwise we end up with a stale timer.
-		 */
-		if (timer->state == HRTIMER_STATE_MIGRATE) {
-			/* XXX: running on offline cpu */
-			__run_hrtimer(timer);
-		}
-#endif
 		/* Clear the migration state bit */
 		timer->state &= ~HRTIMER_STATE_MIGRATE;
 	}
 }
 
-static void migrate_hrtimers(int cpu)
+static int migrate_hrtimers(int scpu)
 {
 	struct hrtimer_cpu_base *old_base, *new_base;
-	int i;
+	int dcpu, i;
 
-	BUG_ON(cpu_online(cpu));
-	old_base = &per_cpu(hrtimer_bases, cpu);
+	BUG_ON(cpu_online(scpu));
+	old_base = &per_cpu(hrtimer_bases, scpu);
 	new_base = &get_cpu_var(hrtimer_bases);
 
-	tick_cancel_sched_timer(cpu);
+	dcpu = smp_processor_id();
+
+	tick_cancel_sched_timer(scpu);
 	/*
 	 * The caller is globally serialized and nobody else
 	 * takes two locks at once, deadlock is not possible.
@@ -1557,32 +1551,47 @@ static void migrate_hrtimers(int cpu)
 
 	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++) {
 		migrate_hrtimer_list(&old_base->clock_base[i],
-				     &new_base->clock_base[i], cpu);
+				     &new_base->clock_base[i]);
 	}
 
 	spin_unlock(&old_base->lock);
 	spin_unlock_irq(&new_base->lock);
 	put_cpu_var(hrtimer_bases);
+
+	return dcpu;
+}
+
+static void tickle_timers(void *arg)
+{
+	hrtimer_peek_ahead_timers();
 }
+
 #endif /* CONFIG_HOTPLUG_CPU */
 
 static int __cpuinit hrtimer_cpu_notify(struct notifier_block *self,
 					unsigned long action, void *hcpu)
 {
-	unsigned int cpu = (long)hcpu;
+	int dcpu = -1, scpu = (long)hcpu;
 
 	switch (action) {
 
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
-		init_hrtimers_cpu(cpu);
+		init_hrtimers_cpu(scpu);
 		break;
 
 #ifdef CONFIG_HOTPLUG_CPU
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
-		clockevents_notify(CLOCK_EVT_NOTIFY_CPU_DEAD, &cpu);
-		migrate_hrtimers(cpu);
+		clockevents_notify(CLOCK_EVT_NOTIFY_CPU_DEAD, &scpu);
+		dcpu = migrate_hrtimers(scpu);
+		break;
+
+	case CPU_POST_DEAD:
+		if (dcpu == -1)
+			break;
+
+		smp_call_function_single(dcpu, tickle_timers, NULL, 0);
 		break;
 #endif
 

