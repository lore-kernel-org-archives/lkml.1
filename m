Return-Path: <linux-kernel-owner+w=401wt.eu-S934505AbZGQMZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934505AbZGQMZb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 08:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934496AbZGQMZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 08:25:30 -0400
Received: from www.tglx.de ([62.245.132.106]:57919 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934466AbZGQMZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 08:25:29 -0400
Message-Id: <20090717122103.135604861@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 17 Jul 2009 12:24:57 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rafael Wysocki <rjw@sisk.pl>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 1/2] sched: fix load average accounting vs. cpu hotplug
References: <20090717121545.489258927@linutronix.de>
Content-Disposition: inline;
	filename=sched-loadavg-clear-calc_load_active-on-dead.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new load average code clears rq->calc_load_active on
CPU_ONLINE. That's wrong as the new onlined CPU might have got a
scheduler tick already and accounted the delta to the stale value of
the time we offlined the CPU.

Clear the value when we cleanup the dead CPU instead. 

Also move the update of the calc_load_update time for the newly online
CPU to CPU_UP_PREPARE to avoid that the CPU plays catch up with the
stale update time value.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -7289,6 +7289,7 @@ static void migrate_dead_tasks(unsigned 
 static void calc_global_load_remove(struct rq *rq)
 {
 	atomic_long_sub(rq->calc_load_active, &calc_load_tasks);
+	rq->calc_load_active = 0;
 }
 #endif /* CONFIG_HOTPLUG_CPU */
 
@@ -7515,6 +7516,7 @@ migration_call(struct notifier_block *nf
 		task_rq_unlock(rq, &flags);
 		get_task_struct(p);
 		cpu_rq(cpu)->migration_thread = p;
+		rq->calc_load_update = calc_load_update;
 		break;
 
 	case CPU_ONLINE:
@@ -7525,8 +7527,6 @@ migration_call(struct notifier_block *nf
 		/* Update our root-domain */
 		rq = cpu_rq(cpu);
 		spin_lock_irqsave(&rq->lock, flags);
-		rq->calc_load_update = calc_load_update;
-		rq->calc_load_active = 0;
 		if (rq->rd) {
 			BUG_ON(!cpumask_test_cpu(cpu, rq->rd->span));
 


