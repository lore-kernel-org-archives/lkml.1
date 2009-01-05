Return-Path: <linux-kernel-owner+w=401wt.eu-S1754494AbZAELnJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494AbZAELnJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 06:43:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752326AbZAELmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 06:42:55 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48336 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957AbZAELmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 06:42:54 -0500
Message-Id: <20090105103136.284066660@chello.nl>
References: <20090105102818.829119334@chello.nl>
User-Agent: quilt/0.46-1
Date: Mon, 05 Jan 2009 11:28:21 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 3/5] hrtimer: simplify hotplug migration
Content-Disposition: inline; filename=hrtimers-simplify-migration.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

No need for a smp function call, which is likely to run on the same
CPU anyway. We can just call hrtimers_peek_ahead() in the interrupts
disabled section of migrate_hrtimers().

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/hrtimer.c |   25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

Index: linux-2.6-tip/kernel/hrtimer.c
===================================================================
--- linux-2.6-tip.orig/kernel/hrtimer.c
+++ linux-2.6-tip/kernel/hrtimer.c
@@ -1505,11 +1505,6 @@ static void __cpuinit init_hrtimers_cpu(
 
 #ifdef CONFIG_HOTPLUG_CPU
 
-static void tickle_timers(void *arg)
-{
-	hrtimer_peek_ahead_timers();
-}
-
 static void migrate_hrtimer_list(struct hrtimer_clock_base *old_base,
 				struct hrtimer_clock_base *new_base)
 {
@@ -1548,20 +1543,19 @@ static void migrate_hrtimer_list(struct 
 static void migrate_hrtimers(int scpu)
 {
 	struct hrtimer_cpu_base *old_base, *new_base;
-	int dcpu, i;
+	int i;
 
 	BUG_ON(cpu_online(scpu));
-	old_base = &per_cpu(hrtimer_bases, scpu);
-	new_base = &get_cpu_var(hrtimer_bases);
-
-	dcpu = smp_processor_id();
-
 	tick_cancel_sched_timer(scpu);
+
+	local_irq_disable();
+	old_base = &per_cpu(hrtimer_bases, scpu);
+	new_base = &__get_cpu_var(hrtimer_bases);
 	/*
 	 * The caller is globally serialized and nobody else
 	 * takes two locks at once, deadlock is not possible.
 	 */
-	spin_lock_irq(&new_base->lock);
+	spin_lock(&new_base->lock);
 	spin_lock_nested(&old_base->lock, SINGLE_DEPTH_NESTING);
 
 	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++) {
@@ -1570,10 +1564,11 @@ static void migrate_hrtimers(int scpu)
 	}
 
 	spin_unlock(&old_base->lock);
-	spin_unlock_irq(&new_base->lock);
-	put_cpu_var(hrtimer_bases);
+	spin_unlock(&new_base->lock);
 
-	smp_call_function_single(dcpu, tickle_timers, NULL, 0);
+	/* Check, if we got expired work to do */
+	__hrtimer_peek_ahead_timers();
+	local_irq_enable();
 }
 
 #endif /* CONFIG_HOTPLUG_CPU */

-- 

